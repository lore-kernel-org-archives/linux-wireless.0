Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f173.google.com ([209.85.211.173]:59540 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbZIHUyW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2009 16:54:22 -0400
Received: by ywh3 with SMTP id 3so5387557ywh.22
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2009 13:54:25 -0700 (PDT)
Subject: Re: driver_nl80211 broken again
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <1252423769.3806.4.camel@johannes.local>
References: <1251117161.22951.4.camel@maxim-laptop>
	 <1251122885.12007.12.camel@johannes.local>
	 <1251144381.9374.4.camel@maxim-laptop>
	 <1251147515.20161.3.camel@johannes.local>
	 <1252116503.2398.26.camel@maxim-laptop>
	 <1252423769.3806.4.camel@johannes.local>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Sep 2009 23:54:20 +0300
Message-Id: <1252443260.16422.5.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-09-08 at 17:29 +0200, Johannes Berg wrote: 
> On Sat, 2009-09-05 at 05:08 +0300, Maxim Levitsky wrote:
> 
> > 1 - when connecting again to the access point (same or another), 
> > wpa_supplicant does the following:
> > 
> > deassoc
> > auth
> > assoc
> > 
> > So it assumes that deassoc command disconnects completely, but it not
> > longer true.
> > Yet, I have tried to make its dissassoc function do both, but it failed.
> > I used following patch:
> > 
> > 
> > diff --git a/wpa_supplicant/wpa_supplicant.c b/wpa_supplicant/wpa_supplicant.c
> > index c68dd82..50afeeb 100644
> > --- a/wpa_supplicant/wpa_supplicant.c
> > +++ b/wpa_supplicant/wpa_supplicant.c
> > @@ -1278,8 +1278,10 @@ void wpa_supplicant_disassociate(struct wpa_supplicant *wpa_s,
> >         if (!is_zero_ether_addr(wpa_s->bssid)) {
> >                 if (wpa_s->drv_flags & WPA_DRIVER_FLAGS_USER_SPACE_MLME)
> >                         ieee80211_sta_disassociate(wpa_s, reason_code);
> > -               else
> > +               else {
> >                         wpa_drv_disassociate(wpa_s, wpa_s->bssid, reason_code);
> > +                       wpa_drv_deauthenticate(wpa_s, wpa_s->bssid, reason_code);
> > +               }
> >                 addr = wpa_s->bssid;
> >         }
> >         wpa_clear_keys(wpa_s, addr);
> 
> Right, this is a known problem. I still think it should be handled in
> wpa_s, but I'm not sure whether that patch should have worked or not.
> 
> > EAPOL: startWhen --> 0
> > EAPOL: disable timer tick
> > wpa_driver_nl80211_disassociate
> > wpa_driver_nl80211_deauthenticate
> > nl80211: MLME command failed: ret=-67 (Link has been severed)
> 
> Ok so it was called, but got -ENOLINK? That's rather odd. But I suspect
> that it had already internally cleared the BSSID, so that it was asking
> to deauth from 00:...:00 -- could you check that?

I figure that out, but the wpa_drv_disassociate and
wpa_drv_deauthenticate are direct wrappers over nl80211 calls.


> 
> > 2 - independent of the above, the ieee80211_set_disassoc
> > doesn't work right if deauth==false.
> > 
> > 
> > If it is, then a work item is added to station work thread, and it is
> > never removed:
> > 
> > 	} else {
> > 		struct ieee80211_mgd_work *wk = ifmgd->old_associate_work;
> > 
> > 		wk->state = IEEE80211_MGD_STATE_IDLE;
> > 		list_add(&wk->list, &ifmgd->work_list);
> > 	}
> > 
> > 
> > iee80211_sta_work just ignores the IEEE80211_MGD_STATE_IDLE, thus it
> > work item remains forever.
> > 
> > This breaks scanning, since __ieee80211_start_scan will refuses to run
> > until, ifmgd->work_list is empty.
> 
> That's intentional, that work item represents the authentication state
> we still have -- the required cleanup should be done by cfg80211 or
> wpa_supplicant.

But isn't it too much?
This means, the wpa_supplicant can lock the device.



> 
> Can you try to figure out what the parameters are that
> wpa_drv_deauthenticate() is sending to the kernel, and why it's getting
> -ENOLINK?

Sure!
Very soon will do


Best regards,
Maxim Levitsky


