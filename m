Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp02.msg.oleane.net ([62.161.4.2]:36618 "EHLO
	smtp02.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab3AJN2U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2013 08:28:20 -0500
From: =?UTF-8?Q?C=C3=A9dric_Debarge_-_ACKSYS?= <cedric.debarge@acksys.fr>
To: "'Johannes Berg'" <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
References: <773DB8A82AB6A046AE0195C68612A319014B7055@sbs2003.acksys.local>		 (sfid-20130108_123142_580099_93DD6C6E) <1357734417.9757.6.camel@jlt4.sipsolutions.net>	 <018801cdef1b$dca15b10$95e41130$@acksys.fr> <1357821050.17902.10.camel@jlt4.sipsolutions.net>
In-Reply-To: <1357821050.17902.10.camel@jlt4.sipsolutions.net>
Subject: RE: missing RX_FLAG_DECRIPTED in ieee80211_rx_status after first reassociation in 802.11R
Date: Thu, 10 Jan 2013 14:28:15 +0100
Message-ID: <018c01cdef36$58f1da90$0ad58fb0$@acksys.fr> (sfid-20130110_142824_746802_F9866EE8)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks a lot !

I have successfully tested your patch on my system. 
It is now using hardware encryption available in the radio card.

Best regards,

Cédric DEBARGE	

-----Message d'origine-----
De : Johannes Berg [mailto:johannes@sipsolutions.net] 
Envoyé : jeudi 10 janvier 2013 13:31
À : Cédric Debarge - ACKSYS
Cc : linux-wireless@vger.kernel.org
Objet : Re: missing RX_FLAG_DECRIPTED in ieee80211_rx_status after first reassociation in 802.11R

Hi Cédric,

> 	I attached the trace file since it is quite long (about 1400 lines).
> 	Here are some pointers : 
> 		Original AP = 90:A4:DE:AA:42:94, channel : 132, ssid : acksyscdtest
> 		Second AP = 90:A4:DE:AA:41:ED, channel : 132, ssid : acksyscdtest
> 
> 		When wpa_supplicant is launched, it associates directly with 
> 90:A4:DE:AA:42:94.
> 		The roaming order is given by the wpa_cli roam command (roam 
> 90:A4:DE:AA:41:ED). You can find it at line 1042 of the traces.
> 		I used the -T option of wpa_supplicant.
> 
> 	In order to get cfg80211 traces I had to switch to compat wireless 
> version 2012-12-06 (previous was 2012-09-07). Nevertheless, the 
> behavior seems to remain the same (same exit in 
> ieee80211_key_enable_hw_accel at the first roam).

Thanks for the trace! That allowed me to understand the bug very easily, I didn't realize you had used FT.

It looks like this bug was introduced by my

commit 66e67e418908442389d3a9e6509985f01cbaf9b0
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Fri Jan 20 13:55:27 2012 +0100

    mac80211: redesign auth/assoc

This changed the way mac80211 allocates stations when it connects to an AP, to allocate it before associating. wpa_supplicant can deal with key setting being rejected before association and will set the key again after association, which is the code path that was used before this code change in mac80211, but now mac80211 would accept the key even before that.

I think the patch below might work to restore the old behaviour:

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c index 7d290bc..48a03b0 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -164,7 +164,7 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 			sta = sta_info_get(sdata, mac_addr);
 		else
 			sta = sta_info_get_bss(sdata, mac_addr);
-		if (!sta) {
+		if (!sta || !test_sta_flag(sta, WLAN_STA_ASSOC)) {
 			ieee80211_key_free(sdata->local, key);
 			err = -ENOENT;
 			goto out_unlock;


That would probably be a reasonable patch for stable. I think the other way we could handle this is accept the key, and only upload it to the hardware after the station has been marked associated.

johannes


