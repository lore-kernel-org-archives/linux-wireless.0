Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:59928 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934532AbZIECI2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Sep 2009 22:08:28 -0400
Received: by fg-out-1718.google.com with SMTP id 22so1227371fge.1
        for <linux-wireless@vger.kernel.org>; Fri, 04 Sep 2009 19:08:29 -0700 (PDT)
Subject: Re: driver_nl80211 broken again
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1251147515.20161.3.camel@johannes.local>
References: <1251117161.22951.4.camel@maxim-laptop>
	 <1251122885.12007.12.camel@johannes.local>
	 <1251144381.9374.4.camel@maxim-laptop>
	 <1251147515.20161.3.camel@johannes.local>
Content-Type: text/plain
Date: Sat, 05 Sep 2009 05:08:23 +0300
Message-Id: <1252116503.2398.26.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-08-24 at 22:58 +0200, Johannes Berg wrote:
> On Mon, 2009-08-24 at 23:06 +0300, Maxim Levitsky wrote:
> 
> > This is typical output of iwconfig, after failure
> > (and I know that this output means trouble):
> 
> Hmm, thanks for the info and especially the log. Unfortunately, I can't
> reproduce this at all.
> 
> Can you run wpa_supplicant with timing info (add -t to the command line)
> and at the same time run "iw event -t" please?
> 
> johannes

I have finally got to the bottom of this, ad it doesn't look good.
There are two bugs that overlap:


1 - when connecting again to the access point (same or another), 
wpa_supplicant does the following:

deassoc
auth
assoc

So it assumes that deassoc command disconnects completely, but it not
longer true.
Yet, I have tried to make its dissassoc function do both, but it failed.
I used following patch:


diff --git a/wpa_supplicant/wpa_supplicant.c b/wpa_supplicant/wpa_supplicant.c
index c68dd82..50afeeb 100644
--- a/wpa_supplicant/wpa_supplicant.c
+++ b/wpa_supplicant/wpa_supplicant.c
@@ -1278,8 +1278,10 @@ void wpa_supplicant_disassociate(struct wpa_supplicant *wpa_s,
        if (!is_zero_ether_addr(wpa_s->bssid)) {
                if (wpa_s->drv_flags & WPA_DRIVER_FLAGS_USER_SPACE_MLME)
                        ieee80211_sta_disassociate(wpa_s, reason_code);
-               else
+               else {
                        wpa_drv_disassociate(wpa_s, wpa_s->bssid, reason_code);
+                       wpa_drv_deauthenticate(wpa_s, wpa_s->bssid, reason_code);
+               }
                addr = wpa_s->bssid;
        }
        wpa_clear_keys(wpa_s, addr);


I got this.


EAPOL: startWhen --> 0
EAPOL: disable timer tick
wpa_driver_nl80211_disassociate
wpa_driver_nl80211_deauthenticate
nl80211: MLME command failed: ret=-67 (Link has been severed)



However, this "hack", did the trick:

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 97a278a..60c4355 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2561,7 +2561,7 @@ int ieee80211_mgd_disassoc(struct ieee80211_sub_if_data *sdata,
                return -ENOLINK;
        }
 
-       ieee80211_set_disassoc(sdata, false);
+       ieee80211_set_disassoc(sdata, true);
 
        mutex_unlock(&ifmgd->mtx);
 
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 79d2eec..fec34a7 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -222,7 +222,7 @@ static void __cfg80211_send_disassoc(struct net_device *dev,
                for (i = 0; i < MAX_AUTH_BSSES; i++) {
                        if (wdev->authtry_bsses[i] || wdev->auth_bsses[i])
                                continue;
-                       wdev->auth_bsses[i] = wdev->current_bss;
+                       /*wdev->auth_bsses[i] = wdev->current_bss;*/
                        wdev->current_bss = NULL;
                        done = true;
                        cfg80211_sme_disassoc(dev, i);


With this ugly hack, everything works just fine. 
-----------------------------------------------------------------------------------------------
2 - independent of the above, the ieee80211_set_disassoc
doesn't work right if deauth==false.


If it is, then a work item is added to station work thread, and it is
never removed:

	} else {
		struct ieee80211_mgd_work *wk = ifmgd->old_associate_work;

		wk->state = IEEE80211_MGD_STATE_IDLE;
		list_add(&wk->list, &ifmgd->work_list);
	}


iee80211_sta_work just ignores the IEEE80211_MGD_STATE_IDLE, thus it
work item remains forever.

This breaks scanning, since __ieee80211_start_scan will refuses to run
until, ifmgd->work_list is empty.



Best regards,
	Maxim Levitsky

