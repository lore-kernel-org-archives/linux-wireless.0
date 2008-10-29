Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:47497 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755050AbYJ2Vj6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 17:39:58 -0400
To: linux-wireless@vger.kernel.org
Subject: [RFT][PATCH] p54: initialize all deprecated fields
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
From: Chr <chunkeey@web.de>
Date: Wed, 29 Oct 2008 22:39:50 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200810292239.50074.chunkeey@web.de> (sfid-20081029_224006_508182_B132E726)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The new mechanism for allocing space for control frames,
didn't "zero" out the payload data... However I haven't
heard of any hiccups so far...


Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
John,

can you please tell me what's the current status of the ap/ibss patches?
I got some mails from people who actually want to see it in wireless-testing.
If you've still lots of crazy merge conflicts, let me know!

Regards,
	Chr
---
diff --git a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
index 02a306d..2e76415 100644
--- a/drivers/net/wireless/p54/p54common.c
+++ b/drivers/net/wireless/p54/p54common.c
@@ -9,7 +9,7 @@
  * - the islsm (softmac prism54) driver, which is:
  *   Copyright 2004-2006 Jean-Baptiste Note <jbnote@gmail.com>, et al.
  * - stlc45xx driver
- * C  Copyright (C) 2008 Nokia Corporation and/or its subsidiary(-ies).
+ *   Copyright (C) 2008 Nokia Corporation and/or its subsidiary(-ies).
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -1044,8 +1044,10 @@ static int p54_setup_mac(struct ieee80211_hw *dev, u16 mode, const u8 *bssid)
 	else
 		memcpy(setup->bssid, bssid, ETH_ALEN);
 	setup->rx_antenna = priv->rx_antenna;
+	setup->rx_align = 0;
 	if (priv->fw_var < 0x500) {
 		setup->v1.basic_rate_mask = cpu_to_le32(0x15f);
+		memset(setup->v1.rts_rates, 0, 8);
 		setup->v1.rx_addr = cpu_to_le32(priv->rx_end);
 		setup->v1.max_rx = cpu_to_le16(priv->rx_mtu);
 		setup->v1.rxhw = cpu_to_le16(priv->rxhw);
@@ -1128,11 +1130,11 @@ static int p54_set_freq(struct ieee80211_hw *dev, __le16 freq)
 		}
 
 		entry += sizeof(__le16);
-		chan->pa_points_per_curve =
-			min(priv->curve_data->points_per_channel, (u8) 8);
-
-		memcpy(chan->curve_data, entry, sizeof(*chan->curve_data) *
-		       chan->pa_points_per_curve);
+		chan->pa_points_per_curve = 8;
+		memset(chan->curve_data, 0, sizeof(*chan->curve_data));
+		memcpy(chan->curve_data, entry,
+		       sizeof(struct p54_pa_curve_data_sample) *
+		       min((u8)8, priv->curve_data->points_per_channel));
 		break;
 	}
 
@@ -1208,6 +1210,7 @@ static int p54_set_edcf(struct ieee80211_hw *dev)
 	/* (see prism54/isl_oid.h for further details) */
 	edcf->frameburst = cpu_to_le16(0);
 	edcf->round_trip_delay = cpu_to_le16(0);
+	edcf->flags = 0;
 	memset(edcf->mapping, 0, sizeof(edcf->mapping));
 	memcpy(edcf->queue, priv->qos_params, sizeof(edcf->queue));
 	priv->tx(dev, skb, 1);
