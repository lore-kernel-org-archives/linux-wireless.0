Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:42491 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbaB1M43 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Feb 2014 07:56:29 -0500
Received: by mail-ee0-f43.google.com with SMTP id e53so2027317eek.16
        for <linux-wireless@vger.kernel.org>; Fri, 28 Feb 2014 04:56:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1393589841.13669.32.camel@dubbel>
References: <1393512081-31453-1-git-send-email-luca@coelho.fi>
	<1393512081-31453-4-git-send-email-luca@coelho.fi>
	<CA+BoTQ=yoYAcg8Jo2zoV76gmXe9UU1=wSi1CVWfwiRpqC7yr6w@mail.gmail.com>
	<1393589841.13669.32.camel@dubbel>
Date: Fri, 28 Feb 2014 13:56:28 +0100
Message-ID: <CA+BoTQmaF+johnB5ia+ez5dFKYPWWwk7E=482Q3hzLv=YvZAvQ@mail.gmail.com> (sfid-20140228_135633_365557_41996D97)
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

On 28 February 2014 13:17, Luca Coelho <luca@coelho.fi> wrote:
> On Thu, 2014-02-27 at 16:29 +0100, Michal Kazior wrote:
>> On 27 February 2014 15:41, Luca Coelho <luca@coelho.fi> wrote:
>> > Introduce IEEE80211_CHANCTX_RESERVED chanctx mode to mark a channel as
>> > reserved so nobody else can use it (since we know it's going to
>> > change).  In the future, we may allow several vifs to use the same
>> > reservation as long as they plan to use the chanctx on the same
>> > future channel.
>>
>> I don't really think you need a separate mode for that.
>>
>> Since reserved_chanctx is protected by chanctx_mtx you can safely
>> iterate over interfaces and check if any vif is reserving the same
>> chanctx it is assigned to.
>
> I think it's much simpler to keep this new mode.  Reserved channel
> contexts are almost like exclusive contexts (as I was doing in my first
> RFC), but not exactly the same, since they can be used for other
> reservations.

I still argue the new mode is unnecessary. The nature of chanctx is
not going to change (it's either shared or not) due to chanctx
reservation. Also the name "reserved" is ambiguous because you have a
ieee80211_vif_reserve_chanctx() which doesn't necessarily end up with
chanctx mode being changed to RESERVED.

The check is simply I have in mind is simply:

bool ieee80211_chanctx_needs_channel_change(struct ieee80211_local
*local, struct ieee80211_chanctx *ctx) {
 lockdep_assert_held(&local->chanctx_mtx);
 rcu_read_lock();
 list_for_each_entry_rcu(sdata, &local->interfaces, list) {
  if (sdata->reserved_chanctx != ctx)
   continue;
  if (get_current_chanctx(sdata) == sdata->reserved_chanctx)
   return true;
 }
 rcu_read_unlock();
 return false;
}

IOW if there's a least one vif bound to given chanctx and the vif has
both current and future chanctx the same, then the chanctx requires
in-place channel change (and this matches your original condition
(mode == RESERVED)).

This should be future proof for multi-interface/channel.


>> > @@ -622,7 +629,9 @@ int ieee80211_vif_unreserve_chanctx(struct ieee80211_sub_if_data *sdata)
>> >         if (WARN_ON(!sdata->reserved_chanctx))
>> >                 return -EINVAL;
>> >
>> > -       if (--sdata->reserved_chanctx->refcount == 0)
>> > +       if (sdata->reserved_chanctx->mode == IEEE80211_CHANCTX_RESERVED)
>> > +               sdata->reserved_chanctx->mode = sdata->reserved_mode;
>> > +       else if (--sdata->reserved_chanctx->refcount == 0)
>> >                 ieee80211_free_chanctx(sdata->local, sdata->reserved_chanctx);
>> >
>> >         sdata->reserved_chanctx = NULL;
>> > @@ -652,19 +661,42 @@ int ieee80211_vif_reserve_chanctx(struct ieee80211_sub_if_data *sdata,
>> >         /* try to find another context with the chandef we want */
>> >         new_ctx = ieee80211_find_chanctx(local, chandef,
>> >                                          IEEE80211_CHANCTX_SHARED);
>> > -       if (!new_ctx) {
>> > -               /* create a new context */
>> > +       if (new_ctx) {
>> > +               /* reserve the existing compatible context */
>> > +               sdata->reserved_chanctx = new_ctx;
>> > +               new_ctx->refcount++;
>> > +       } else if (curr_ctx->refcount == 1 &&
>> > +                  (local->hw.flags & IEEE80211_HW_CHANGE_RUNNING_CHANCTX)) {
>> > +               /* TODO: when implementing support for multiple
>> > +                * interfaces switching at the same time, we may want
>> > +                * other vifs to reserve it as well, as long as
>> > +                * they're planning to switch to the same channel.  In
>> > +                * that case, we probably have to save the future
>> > +                * chandef and the reserved_mode in the context
>> > +                * itself.
>> > +                */
>>
>> We already save the future chandef (csa_chandef). reserved_mode is not
>> necessary as per my comment above. Again, if you guarantee csa_chandef
>> to be set under chanctx_mtx you can safely iterate over interfaces and
>> calculate compat chandef.
>
> But the calculated "compat chandef" is not exactly what was required in
> the first place.  In sdata->u.bss_conf.chandef we need to have the
> chandef we want for *this* vif.  We need this to recalculate the
> combined chandef if, for instance, another vif leaves our chanctx.
>
> I think we should keep saving the reserved_chandef in sdata (the one
> that was requested when making the reservation) and also save the future
> chandef as a compat combination of all the reservations for that
> chanctx.
>
> You're right that we already have the future chandef.  I just added it
> as "reserved_chandef" in the previous patch. ;) I'll reword this.

I'm confused now.

Where did you introduce "reserved_chandef"? Didn't you introduce
"reserved_chanCTX"?

To make this clear: the future chanctx chandef can be computed as follows:

get_compat_future_chanctx_chandef(local, ctx) {
  list_for_each(sdata, local) {
    if (sdata->reserved_chanctx != ctx)
      continue;
    compat = get_compat_chandef(compat, sdata->csa_chandef);
    if (!compat) break;
  }
  return compat;
}

IOW there's no need for chanctx->future_chandef. This is actually
safer because if you cancel a reservation (e.g. iface is brought down)
you need to downgrade the future chanctx chandef to the minimum, don't
you?


Michał
