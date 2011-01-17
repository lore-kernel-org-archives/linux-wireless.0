Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx.techwires.net ([79.140.39.242]:46075 "EHLO mx.techwires.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753226Ab1AQQVd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jan 2011 11:21:33 -0500
In-Reply-To: <201101171621.29863.bernhard.schmidt@saxnet.de>
References: <201101171621.29863.bernhard.schmidt@saxnet.de>
From: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
To: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 17 Jan 2011 14:27:29 +0100
Subject: [PATCH 8/8] hostap: do not disable radar channels
Cc: <lrodriguez@atheros.com>, <nbd@openwrt.org>, <dubowoj@neratec.com>,
	<zefir.kurtisi@neratec.com>, <simon.wunderlich@saxnet.de>
Message-Id: <20110117161327.A8B3D209B@mx.techwires.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 src/ap/hw_features.c |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/src/ap/hw_features.c b/src/ap/hw_features.c
index a7f4eda..81caf63 100644
--- a/src/ap/hw_features.c
+++ b/src/ap/hw_features.c
@@ -126,19 +126,6 @@ int hostapd_get_hw_features(struct hostapd_iface *iface)
 		/* set flag for channels we can use in current regulatory
 		 * domain */
 		for (j = 0; j < feature->num_channels; j++) {
-			/*
-			 * Disable all channels that are marked not to allow
-			 * IBSS operation or active scanning. In addition,
-			 * disable all channels that require radar detection,
-			 * since that (in addition to full DFS) is not yet
-			 * supported.
-			 */
-			if (feature->channels[j].flag &
-			    (HOSTAPD_CHAN_NO_IBSS |
-			     HOSTAPD_CHAN_PASSIVE_SCAN |
-			     HOSTAPD_CHAN_RADAR))
-				feature->channels[j].flag |=
-					HOSTAPD_CHAN_DISABLED;
 			if (feature->channels[j].flag & HOSTAPD_CHAN_DISABLED)
 				continue;
 			wpa_printf(MSG_MSGDUMP, "Allowed channel: mode=%d "
-- 
1.5.6.5

