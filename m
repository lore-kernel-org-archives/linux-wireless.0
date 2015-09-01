Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56887 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbbIAPH3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2015 11:07:29 -0400
Message-ID: <1441120044.2441.9.camel@sipsolutions.net> (sfid-20150901_170732_966963_3B390A22)
Subject: Re: [PATCH 1/1] New driver: rtl8xxxu (mac80211)
From: Johannes Berg <johannes@sipsolutions.net>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
	Larry.Finger@lwfinger.net
Date: Tue, 01 Sep 2015 17:07:24 +0200
In-Reply-To: <wrfjmvx73u0l.fsf@redhat.com>
References: <1440883083-32498-1-git-send-email-Jes.Sorensen@redhat.com>
	 <1440883083-32498-2-git-send-email-Jes.Sorensen@redhat.com>
	 <1441032517.13980.21.camel@sipsolutions.net> <wrfjmvx73u0l.fsf@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-08-31 at 19:42 -0400, Jes Sorensen wrote:
> 
> Anything related to doing things correctly wrt to the mac80211 API 
> would be awesome.

:)

> static int rtl8xxxu_add_interface(struct ieee80211_hw *hw,
>                                   struct ieee80211_vif *vif)
> {
>         struct rtl8xxxu_priv *priv = hw-&gt;priv;
>         int ret;
>         u8 val8;
> 
>         switch (vif-&gt;type) {    
>         case NL80211_IFTYPE_STATION:
>                 rtl8723a_stop_tx_beacon(priv);

This seems odd - you shouldn't have any kind of operation before
add_interface(), so why stop anything?
(You also don't even support beaconing yet anyway)

>                 /*
>                  * This is a bit of a hack - the lower bits of the cipher 
>                  * suite selector happens to match the cipher index in the
>                  * CAM
>                  */

That's probably simply intentional - the cipher suite selector is built
as a OUI : cipher number ...

However - I don't see any code actually using key->cipher here? You
should move the comment into rtl8xxxu_cam_write() I guess.

> static int
> rtl8xxxu_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
>                       enum ieee80211_ampdu_mlme_action action,
>                       struct ieee80211_sta *sta, u16 tid, u16 *ssn, u8 buf_size)
> {
>         struct rtl8xxxu_priv *priv = hw->priv;
>         struct device *dev = &priv->udev->dev;
>         u8 ampdu_factor, ampdu_density;
> 
>         switch (action) {
[...]

I'd be extremely surprised if any of this worked - perhaps you're not
advertising A-MPDU support (yet)?

You're not calling ieee80211_start_tx_ba_cb_irqsafe() or
ieee80211_stop_tx_ba_cb_irqsafe(), so this can't really work. The
session might be set up but will never actually start.

That said, the code also looks incomplete. Perhaps better to just
remove it entirely for now?

>         sta_priv->short_preamble = false;

I don't think there's any need to track it, especially since you only
use it in TX where you have the TX info data about it.

> };

stray semicolons at the end of functions in a few places :)

I guess you can get rid of sta_add/remove entirely. sta_state() is the
better hook to implement, but you don't really need any of the three.

> static void rtl8xxxu_sw_scan_start(struct ieee80211_hw *hw,
>                                    struct ieee80211_vif *vif, const u8 *mac)
> {
> }

No need for this ... You'll get stop even without the start, but
actually I think your start is perhaps missing setting
BEACON_DISABLE_TSF_UPDATE (which stop clears)

johannes
