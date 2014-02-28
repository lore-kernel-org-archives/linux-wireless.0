Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:54940 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbaB1OzS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Feb 2014 09:55:18 -0500
Received: by mail-ee0-f54.google.com with SMTP id c41so2269033eek.41
        for <linux-wireless@vger.kernel.org>; Fri, 28 Feb 2014 06:55:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1393597923.13669.65.camel@dubbel>
References: <1393512081-31453-1-git-send-email-luca@coelho.fi>
	<1393512081-31453-4-git-send-email-luca@coelho.fi>
	<CA+BoTQ=yoYAcg8Jo2zoV76gmXe9UU1=wSi1CVWfwiRpqC7yr6w@mail.gmail.com>
	<1393589841.13669.32.camel@dubbel>
	<CA+BoTQmaF+johnB5ia+ez5dFKYPWWwk7E=482Q3hzLv=YvZAvQ@mail.gmail.com>
	<1393594886.13669.47.camel@dubbel>
	<CA+BoTQkafvtCDU5LkDcyVonO2T=koaBCWABzSQmnDOXJh=AvDA@mail.gmail.com>
	<1393597923.13669.65.camel@dubbel>
Date: Fri, 28 Feb 2014 15:55:16 +0100
Message-ID: <CA+BoTQk=YLd+bur3HkJ5jwrT-EYKMF8+nzJSX+bJP_psesuE5g@mail.gmail.com> (sfid-20140228_155524_215659_17B2FDB9)
Subject: Re: [RFC v2 3/4] mac80211: allow reservation of a running chanctx
From: Michal Kazior <michal.kazior@tieto.com>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	sw@simonwunderlich.de,
	"Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28 February 2014 15:32, Luca Coelho <luca@coelho.fi> wrote:
> On Fri, 2014-02-28 at 15:07 +0100, Michal Kazior wrote:
>> On 28 February 2014 14:41, Luca Coelho <luca@coelho.fi> wrote:
>> > On Fri, 2014-02-28 at 13:56 +0100, Michal Kazior wrote:
>> >> The check is simply I have in mind is simply:
>> >>
>> >> bool ieee80211_chanctx_needs_channel_change(struct ieee80211_local
>> >> *local, struct ieee80211_chanctx *ctx) {
>> >>  lockdep_assert_held(&local->chanctx_mtx);
>> >>  rcu_read_lock();
>> >>  list_for_each_entry_rcu(sdata, &local->interfaces, list) {
>> >>   if (sdata->reserved_chanctx != ctx)
>> >>    continue;
>> >>   if (get_current_chanctx(sdata) == sdata->reserved_chanctx)
>> >>    return true;
>> >>  }
>> >>  rcu_read_unlock();
>> >>  return false;
>> >> }
>> >>
>> >> IOW if there's a least one vif bound to given chanctx and the vif has
>> >> both current and future chanctx the same, then the chanctx requires
>> >> in-place channel change (and this matches your original condition
>> >> (mode == RESERVED)).
>> >>
>> >> This should be future proof for multi-interface/channel.
>> >
>> > Okay, I get your point, it's not strictly necessary.  But this would be
>> > needed in other places too, for example in the combinations check.  We
>> > don't want to allow a new interface to join a chanctx that is going to
>> > change.  In my merge between the combination check series and this one,
>> > I have this: http://pastebin.coelho.fi/65603f9d06b28cb2.txt
>>
>> Hmm.. Good point, but the snippet doesn't prevent new vifs from
>> joining a chanctx that's going to change channel.
>
> No, the prevention actually happens in ieee80211_find_chanctx() and it's
> already part of this series.  I just wanted to point out that this is
> needed in several different places.

If you consider multi-vif I don't think doing that in find_chanctx()
is the best thing. If you skip reserved chanctx in find_chanctx() then
you can't use this function when you reserve chanctx that needs
channel change with more than 1 vif.


>> I'm also not quite sure if you need it in the combo check at all.
>> Can't you just throw EBUSY when you try to assign a new vif to chanctx
>> that's going to change channel?
>
> A reserved channel context is taking up space, so new interfaces can't
> rely on being able to use it.  Let's say a HW supports 1 chanctx and
> there is one vif.  Now the vif wants to change channel and reserves its
> chanctx to be changed later.  If a new vif needs a chanctx, it can't use
> the one that is reserved, because it will be changed in the future.  So,
> during the combination checks, we need to calculate the number of needed
> chanctxs for the new vif to be added is 2, so it should fail.

..but returning EBUSY in assign_vif clearly fulfils this requirement.
And I'm still not convinced you need to take "reserved" chanctx into
any consideration during combination checks.


>> For multi-channel hw you could allow creating new chanctx (if there's
>> enough channels in current combination) and make 2 chanctx that will
>> be compatible in the future (and worry about merging them later), or
>> you could deny that until reservation is finalized.
>
> Yes, if you have enough chanctxs to use, it's not a problem.  But during
> the count we need to consider the ones that will be changed (and are
> thus marked as RESERVED) almost as an EXCLUSIVE chanctx, so they are
> counted separately.  The difference between EXCLUSIVE and RESERVED, is
> only that a RESERVED chanctx can have more than one vif (as long as all
> of them have compatible future chandefs).

I think it's just an obfuscation. Either way "reserved" is an
orthogonal state to the original mode. You just want to keep it in the
"old_mode" and have some [mode, old_mode] combinations invalid leaving
just 4 states that can be actually set.


>> > If I'd use the iteration function there would be a lot of iterations
>> > going on.  Not sure that's a problem though.
>> >
>> > The advantages of your approach is that we need less moving parts (ie.
>> > less stuff to save in sdata).  The advantage of using a new mode is that
>> > it would require less code to run.
>>
>> I'd rather not have to worry about memoizing variables and
>> recalculating them when it's not strictly necessary (this isn't tx
>> path). In both cases you have to worry about locking which I think is
>> enough.
>
> As I said, I don't have a preference.  Except that, being lazy, I'd
> prefer not to change what I already did. :P

For what I care I can just make follow up patches that rework some of
the bits I'm complaining about now that I think are necessary for
multi-vif channel switching as long as Johannes is okay with that
(i.e. merge your current code and then accept my re-work). I'm not in
any place to force you to do my bidding ;-)


Michał
