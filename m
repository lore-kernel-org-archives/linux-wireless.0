Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:61718 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbaB1OHi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Feb 2014 09:07:38 -0500
Received: by mail-ee0-f52.google.com with SMTP id c41so2295595eek.11
        for <linux-wireless@vger.kernel.org>; Fri, 28 Feb 2014 06:07:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1393594886.13669.47.camel@dubbel>
References: <1393512081-31453-1-git-send-email-luca@coelho.fi>
	<1393512081-31453-4-git-send-email-luca@coelho.fi>
	<CA+BoTQ=yoYAcg8Jo2zoV76gmXe9UU1=wSi1CVWfwiRpqC7yr6w@mail.gmail.com>
	<1393589841.13669.32.camel@dubbel>
	<CA+BoTQmaF+johnB5ia+ez5dFKYPWWwk7E=482Q3hzLv=YvZAvQ@mail.gmail.com>
	<1393594886.13669.47.camel@dubbel>
Date: Fri, 28 Feb 2014 15:07:37 +0100
Message-ID: <CA+BoTQkafvtCDU5LkDcyVonO2T=koaBCWABzSQmnDOXJh=AvDA@mail.gmail.com> (sfid-20140228_150742_590138_D391767B)
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

On 28 February 2014 14:41, Luca Coelho <luca@coelho.fi> wrote:
> On Fri, 2014-02-28 at 13:56 +0100, Michal Kazior wrote:
>> The check is simply I have in mind is simply:
>>
>> bool ieee80211_chanctx_needs_channel_change(struct ieee80211_local
>> *local, struct ieee80211_chanctx *ctx) {
>>  lockdep_assert_held(&local->chanctx_mtx);
>>  rcu_read_lock();
>>  list_for_each_entry_rcu(sdata, &local->interfaces, list) {
>>   if (sdata->reserved_chanctx != ctx)
>>    continue;
>>   if (get_current_chanctx(sdata) == sdata->reserved_chanctx)
>>    return true;
>>  }
>>  rcu_read_unlock();
>>  return false;
>> }
>>
>> IOW if there's a least one vif bound to given chanctx and the vif has
>> both current and future chanctx the same, then the chanctx requires
>> in-place channel change (and this matches your original condition
>> (mode == RESERVED)).
>>
>> This should be future proof for multi-interface/channel.
>
> Okay, I get your point, it's not strictly necessary.  But this would be
> needed in other places too, for example in the combinations check.  We
> don't want to allow a new interface to join a chanctx that is going to
> change.  In my merge between the combination check series and this one,
> I have this: http://pastebin.coelho.fi/65603f9d06b28cb2.txt

Hmm.. Good point, but the snippet doesn't prevent new vifs from
joining a chanctx that's going to change channel.

I'm also not quite sure if you need it in the combo check at all.
Can't you just throw EBUSY when you try to assign a new vif to chanctx
that's going to change channel?

For multi-channel hw you could allow creating new chanctx (if there's
enough channels in current combination) and make 2 chanctx that will
be compatible in the future (and worry about merging them later), or
you could deny that until reservation is finalized.


> If I'd use the iteration function there would be a lot of iterations
> going on.  Not sure that's a problem though.
>
> The advantages of your approach is that we need less moving parts (ie.
> less stuff to save in sdata).  The advantage of using a new mode is that
> it would require less code to run.

I'd rather not have to worry about memoizing variables and
recalculating them when it's not strictly necessary (this isn't tx
path). In both cases you have to worry about locking which I think is
enough.


Michał
