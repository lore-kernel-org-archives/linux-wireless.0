Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:57580 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753540Ab1AKNep (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jan 2011 08:34:45 -0500
Date: Tue, 11 Jan 2011 14:34:41 +0100 (CET)
From: Wojciech Dubowik <dubowoj@neratec.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: lrodriguez <lrodriguez@atheros.com>, nbd <nbd@openwrt.org>,
	Johannes Berg <johannes@sipsolutions.net>
Message-ID: <2847292.30.1294752879394.JavaMail.wlan@CHBU500181>
In-Reply-To: <5380482.20.1294752135253.JavaMail.wlan@CHBU500181>
Subject: [RFC] mac80211: Allow AP to change channels for DFS support
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

  I have started studying DFS support possibilities in ath9k 
and I have noticed that at the moment AP is not allowed to 
change channels when it's using beacons.

I have found that I can go around it by setting CHAN_MODE_UNDEFINED
for this case. Not sure whether we need extra mode for it but
to me this is a case when AP is neither fixed nor hopping.

--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c 
@@ -34,8 +34,11 @@
 				return CHAN_MODE_HOPPING;
 		}
 
-		if (sdata->vif.type == NL80211_IFTYPE_AP &&
-		    !sdata->u.ap.beacon)
+
+		/* TODO: CHAN_MODE_FIXED shouldn't be set when
+		  AP is on DFS channel. For now assume always
+		  undefined */
+		if (sdata->vif.type == NL80211_IFTYPE_AP)
 			continue;
 
 		return CHAN_MODE_FIXED;


It's also possible to check whether channel is of radar type
and set mode undefined for this case. Question is whether it's 
needed at all.

Any comments?

Br,
Wojtek
