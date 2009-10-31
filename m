Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:34522 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756152AbZJaKdQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Oct 2009 06:33:16 -0400
Received: by fg-out-1718.google.com with SMTP id 16so1945241fgg.1
        for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2009 03:33:20 -0700 (PDT)
Subject: Re: [PATCH 1/2] Allow scanning while in authenticated only state
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>
In-Reply-To: <1256983366.3555.119.camel@johannes.local>
References: <1256939391.31271.11.camel@maxim-laptop>
	 <1256939549.31271.14.camel@maxim-laptop>
	 <1256967782.3555.69.camel@johannes.local>
	 <1256982381.3089.10.camel@maxim-laptop>
	 <1256983366.3555.119.camel@johannes.local>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 31 Oct 2009 12:33:16 +0200
Message-ID: <1256985196.3089.34.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2009-10-31 at 11:02 +0100, Johannes Berg wrote: 
> On Sat, 2009-10-31 at 11:46 +0200, Maxim Levitsky wrote:
> 
> > > I think you just need this wpa_supplicant patch:
> > > http://johannes.sipsolutions.net/patches/hostap/all/2009-10-26-12%3a59/deauth-on-disassoc.patch
> > 
> > Nope, this patch doesn't help.
> > 
> > if I remove the bssid_changed, then it seems to work when connecting to
> > same AP, but still scan hangs when connecting to different.
> 
> Hmm, Luis said it worked when connecting to a different AP. But he got
> assoc refused and/or disassoc from the AP
> 
> > The problem is that wpa_supplicant doesn't do deauthentication
> > explicitly, and I was told that this is right thing to do. This confuses
> > all the nl80211 and mac80211...
> 
> I thought Jouni committed that workaround. I'm still not convinced that
> wpa_supplicant is doing the right thing.
> 
> > I also think that its best just to do both deauthentication and
> > disassociation in same time.
> 
> But then why do we bother?
> 
> > Yet, I think this path is ok, that is, when you disallow scanning, you
> > can be sure that wifi will be dead, and this patch catches the situation
> > when it for sure will disallowed  forever.
> 
> True, in some sense, but the real problem is that the authentication is
> lingering along. If we really need to clean that up in the kernel then
> we'd have to time out authentication structs that didn't get promoted to
> association, instead of just ignoring them like your two patches
> implement [1]. However, since we put control of all this into
> wpa_supplicant, I don't know whether the kernel really should be
> required to clean up -- I was going to write "clean up after it" but
> that's not true [2], you're proposing that the kernel clean up *while*
> wpa_supplicant is in control. I don't think that's right, since it might
> actually want to hang on for an authentication while doing something
> else, for a while at least. How can we calculate an upper bound on that
> in the kernel?
> 
> Now, I can kinda agree that we should allow authentication frames to go
> through while already authenticated, but that's something quite
> different although your patches here would also allow that in some
> hackish way (by accumulating more and more authentication structs that
> are then ignored).
> 
> Now, especially since you say that this still runs into problems while
> connecting to a new AP, I think that wpa_supplicant should
> deauthenticate from the old AP. After all, it wants to eventually
> control FT and anything we do in the kernel will come back and interfere
> with that.
Exactly, at least for now.

How about putting this in wpa_supplicant, and end all trouble with this
for once?

This is a workaround/hack, but at least it works....

Best regards,
Maxim Levitsky

---


commit e57bfd6e760c32177ab74c462839dd20a92343b8
Author: Maxim Levitsky <maximlevitsky@gmail.com>
Date:   Sat Oct 31 12:05:35 2009 +0200

    driver_nl80211: send deauth on disassoc

diff --git a/src/drivers/driver_nl80211.c b/src/drivers/driver_nl80211.c
index b3861f5..dfed87d 100644
--- a/src/drivers/driver_nl80211.c
+++ b/src/drivers/driver_nl80211.c
@@ -2046,12 +2046,18 @@ static int wpa_driver_nl80211_deauthenticate(void *priv, const u8 *addr,
 static int wpa_driver_nl80211_disassociate(void *priv, const u8 *addr,
                                           int reason_code)
 {
+       int err;
        struct wpa_driver_nl80211_data *drv = priv;
        if (!(drv->capa.flags & WPA_DRIVER_FLAGS_SME))
                return wpa_driver_nl80211_disconnect(drv, addr, reason_code);
        wpa_printf(MSG_DEBUG, "%s", __func__);
        drv->associated = 0;
-       return wpa_driver_nl80211_mlme(drv, addr, NL80211_CMD_DISASSOCIATE,
+
+       err = wpa_driver_nl80211_mlme(drv, addr, NL80211_CMD_DISASSOCIATE,
+                                      reason_code);
+       if (err)
+               return err;
+       return wpa_driver_nl80211_mlme(drv, addr, NL80211_CMD_DEAUTHENTICATE,
                                       reason_code);
 }
 


