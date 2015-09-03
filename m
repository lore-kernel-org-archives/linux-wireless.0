Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52972 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755140AbbICB7e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Sep 2015 21:59:34 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
	Larry.Finger@lwfinger.net
Subject: Re: [PATCH 1/1] New driver: rtl8xxxu (mac80211)
References: <1440883083-32498-1-git-send-email-Jes.Sorensen@redhat.com>
	<1440883083-32498-2-git-send-email-Jes.Sorensen@redhat.com>
	<1441032517.13980.21.camel@sipsolutions.net>
	<wrfjmvx73u0l.fsf@redhat.com>
	<1441120044.2441.9.camel@sipsolutions.net>
Date: Wed, 02 Sep 2015 21:59:30 -0400
In-Reply-To: <1441120044.2441.9.camel@sipsolutions.net> (Johannes Berg's
	message of "Tue, 01 Sep 2015 17:07:24 +0200")
Message-ID: <wrfj4mjcqn3x.fsf@redhat.com> (sfid-20150903_035939_232551_B5F46E48)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:
> On Mon, 2015-08-31 at 19:42 -0400, Jes Sorensen wrote:
>> 
>> Anything related to doing things correctly wrt to the mac80211 API 
>> would be awesome.
>
> :)
>
>> static int rtl8xxxu_add_interface(struct ieee80211_hw *hw,
>>                                   struct ieee80211_vif *vif)
>> {
>>         struct rtl8xxxu_priv *priv = hw-&gt;priv;
>>         int ret;
>>         u8 val8;
>> 
>>         switch (vif-&gt;type) {    
>>         case NL80211_IFTYPE_STATION:
>>                 rtl8723a_stop_tx_beacon(priv);
>
> This seems odd - you shouldn't have any kind of operation before
> add_interface(), so why stop anything?
> (You also don't even support beaconing yet anyway)

The code mimics what the vendor driver does - part of the bringup of the
chip sets a bunch of parameters from an register value array. Rather
than guessing what their default is, I feel it's safer to just shut it
down here and stick with that.

>
>>                 /*
>>                  * This is a bit of a hack - the lower bits of the cipher 
>>                  * suite selector happens to match the cipher index in the
>>                  * CAM
>>                  */
>
> That's probably simply intentional - the cipher suite selector is built
> as a OUI : cipher number ...
>
> However - I don't see any code actually using key->cipher here? You
> should move the comment into rtl8xxxu_cam_write() I guess.

I did assume it was intentional, but still a bit of a hack in my book.
I'll move the comment, as you suggested.

>> static int
>> rtl8xxxu_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
>>                       enum ieee80211_ampdu_mlme_action action,
>>                       struct ieee80211_sta *sta, u16 tid, u16 *ssn, u8 buf_size)
>> {
>>         struct rtl8xxxu_priv *priv = hw->priv;
>>         struct device *dev = &priv->udev->dev;
>>         u8 ampdu_factor, ampdu_density;
>> 
>>         switch (action) {
> [...]
>
> I'd be extremely surprised if any of this worked - perhaps you're not
> advertising A-MPDU support (yet)?
>
> You're not calling ieee80211_start_tx_ba_cb_irqsafe() or
> ieee80211_stop_tx_ba_cb_irqsafe(), so this can't really work. The
> session might be set up but will never actually start.
>
> That said, the code also looks incomplete. Perhaps better to just
> remove it entirely for now?

I started working on this, but I guess I didn't finish it. One thing I
haven't figured out yet is why I see AMPDU_RX_START events, but I never
see AMPDU_TX_START events show in the log.

>>         sta_priv->short_preamble = false;
>
> I don't think there's any need to track it, especially since you only
> use it in TX where you have the TX info data about it.

Oh, I hadn't spotted that information in struct tx_info - in that case I
ought to be able to get rid of this one.

>
>> };
>
> stray semicolons at the end of functions in a few places :)

Gone :)

> I guess you can get rid of sta_add/remove entirely. sta_state() is the
> better hook to implement, but you don't really need any of the three.

I added it because I was looking at using it for AMPDU, then got stock,
but didn't feel like removing it in case I would need it later.

I need to figure out what goes on with the AMPDU side of things - the
problem writing a driver like this without any spec sheets is that it
isn't quite clear to me, how much of this the firmware takes care of
transparently.

>> static void rtl8xxxu_sw_scan_start(struct ieee80211_hw *hw,
>>                                    struct ieee80211_vif *vif, const u8 *mac)
>> {
>> }
>
> No need for this ... You'll get stop even without the start, but
> actually I think your start is perhaps missing setting
> BEACON_DISABLE_TSF_UPDATE (which stop clears)

I'll have a look at this.

Thanks for the comments!

Jes
