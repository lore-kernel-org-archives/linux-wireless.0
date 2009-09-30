Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:43049 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbZI3BTd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2009 21:19:33 -0400
Received: by fxm18 with SMTP id 18so4955522fxm.17
        for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2009 18:19:36 -0700 (PDT)
Subject: Re: driver_nl80211 broken again
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>
In-Reply-To: <1252443260.16422.5.camel@maxim-laptop>
References: <1251117161.22951.4.camel@maxim-laptop>
	 <1251122885.12007.12.camel@johannes.local>
	 <1251144381.9374.4.camel@maxim-laptop>
	 <1251147515.20161.3.camel@johannes.local>
	 <1252116503.2398.26.camel@maxim-laptop>
	 <1252423769.3806.4.camel@johannes.local>
	 <1252443260.16422.5.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Sep 2009 03:19:28 +0200
Message-Id: <1254273569.4499.8.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> 
> Sure!
> Very soon will do
> 

So I didn't do the testing that soon...
Got swamped by many bugs present in ubuntu 9.10.

Now I have attempted same patch on top of wpa_supplicant, and it works.

diff --git a/wpa_supplicant/wpa_supplicant.c b/wpa_supplicant/wpa_supplicant.c
index 37a1927..a0098b9 100644
--- a/wpa_supplicant/wpa_supplicant.c
+++ b/wpa_supplicant/wpa_supplicant.c
@@ -1302,8 +1302,10 @@ void wpa_supplicant_disassociate(struct wpa_supplicant *wpa_s,
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



Would that be enough, or this is too hacky, and we need to audit each callsite of wpa_supplicant_disassociate
and see if we need to send deauth frame too?


Best regards,
	Maxim Levitsky

