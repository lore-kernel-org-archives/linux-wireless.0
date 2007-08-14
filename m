Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:34440 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760065AbXHNLwI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2007 07:52:08 -0400
Message-Id: <20070814093410.322846000@sipsolutions.net>
References: <20070814093254.021041000@sipsolutions.net>
Date: Tue, 14 Aug 2007 11:32:58 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 4/4] hostapd: remove PRISM2_PARAM_NEXT_MODE
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

802.11 A is easily distinguishable based on frequency, and the difference
between 802.11B/G isn't really done well in mac80211 with most 802.11G
drivers supporting only 802.11G channels and no B channels

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
What reason is there anyway for distinguishing between an 802.11G and an
802.11B channel? Regulatory? In that case, well, needs lots of work.

 hostapd/driver_devicescape.c |   14 --------------
 1 file changed, 14 deletions(-)

--- hostap.orig/hostapd/driver_devicescape.c	2007-08-14 11:32:35.000000000 +0200
+++ hostap/hostapd/driver_devicescape.c	2007-08-14 11:32:36.000000000 +0200
@@ -367,20 +367,6 @@ static int i802_set_freq(void *priv, int
 	struct i802_driver_data *drv = priv;
 	struct iwreq iwr;
 
-	switch (mode) {
-	case HOSTAPD_MODE_IEEE80211A:
-		mode = MODE_IEEE80211A;
-		break;
-	case HOSTAPD_MODE_IEEE80211B:
-		mode = MODE_IEEE80211B;
-		break;
-	case HOSTAPD_MODE_IEEE80211G:
-		mode = MODE_IEEE80211G;
-		break;
-	}
-
-	hostap_ioctl_prism2param(drv, PRISM2_PARAM_NEXT_MODE, mode);
-
 	memset(&iwr, 0, sizeof(iwr));
 	os_strlcpy(iwr.ifr_name, drv->hapd->conf->iface, IFNAMSIZ);
 	iwr.u.freq.m = freq;

-- 

