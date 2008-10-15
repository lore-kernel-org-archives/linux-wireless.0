Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:33881 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbYJOBvb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 21:51:31 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/6] p54: broken out edcf changes
Date: Wed, 15 Oct 2008 03:55:37 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Pavel Roskin <proski@gnu.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	John W Linville <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200810150355.37902.chunkeey@web.de> (sfid-20081015_035136_294510_E2D6E412)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series hopefully increases p54's "longterm" stability.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
John,

This is testing material.
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-10-15 02:43:56.000000000 +0200
+++ b/drivers/net/wireless/p54/p54common.c	2008-10-14 22:21:25.000000000 +0200
@@ -1114,53 +1114,41 @@ do {	 							\
 	queue.txop = cpu_to_le16(_txop);			\
 } while(0)
 
-static void p54_init_vdcf(struct ieee80211_hw *dev)
+static int p54_set_edcf(struct ieee80211_hw *dev)
 {
 	struct p54_common *priv = dev->priv;
 	struct p54_control_hdr *hdr;
-	struct p54_tx_control_vdcf *vdcf;
+	struct p54_edcf *edcf;
 
-	/* all USB V1 adapters need a extra headroom */
-	hdr = (void *)priv->cached_vdcf + priv->tx_hdr_len;
+	hdr = kzalloc(priv->tx_hdr_len + sizeof(*hdr) + sizeof(*edcf),
+			GFP_ATOMIC);
+	if (!hdr)
+		return -ENOMEM;
+
+	hdr = (void *)hdr + priv->tx_hdr_len;
 	hdr->magic1 = cpu_to_le16(0x8001);
-	hdr->len = cpu_to_le16(sizeof(*vdcf));
+	hdr->len = cpu_to_le16(sizeof(*edcf));
 	hdr->type = cpu_to_le16(P54_CONTROL_TYPE_DCFINIT);
-	hdr->req_id = cpu_to_le32(priv->rx_start);
-
-	vdcf = (struct p54_tx_control_vdcf *) hdr->data;
-
-	P54_SET_QUEUE(vdcf->queue[0], 0x0002, 0x0003, 0x0007, 47);
-	P54_SET_QUEUE(vdcf->queue[1], 0x0002, 0x0007, 0x000f, 94);
-	P54_SET_QUEUE(vdcf->queue[2], 0x0003, 0x000f, 0x03ff, 0);
-	P54_SET_QUEUE(vdcf->queue[3], 0x0007, 0x000f, 0x03ff, 0);
-}
-
-static void p54_set_vdcf(struct ieee80211_hw *dev)
-{
-	struct p54_common *priv = dev->priv;
-	struct p54_control_hdr *hdr;
-	struct p54_tx_control_vdcf *vdcf;
-
-	hdr = (void *)priv->cached_vdcf + priv->tx_hdr_len;
-
-	p54_assign_address(dev, NULL, hdr, sizeof(*hdr) + sizeof(*vdcf));
-
-	vdcf = (struct p54_tx_control_vdcf *) hdr->data;
-
+	hdr->retry1 = hdr->retry2 = 0;
+	edcf = (struct p54_edcf *)hdr->data;
 	if (priv->use_short_slot) {
-		vdcf->slottime = 9;
-		vdcf->magic1 = 0x10;
-		vdcf->magic2 = 0x00;
+		edcf->slottime = 9;
+		edcf->sifs = 0x10;
+		edcf->eofpad = 0x00;
 	} else {
-		vdcf->slottime = 20;
-		vdcf->magic1 = 0x0a;
-		vdcf->magic2 = 0x06;
+		edcf->slottime = 20;
+		edcf->sifs = 0x0a;
+		edcf->eofpad = 0x06;
 	}
-
 	/* (see prism54/isl_oid.h for further details) */
-	vdcf->frameburst = cpu_to_le16(0);
+	edcf->frameburst = cpu_to_le16(0);
+	edcf->round_trip_delay = cpu_to_le16(0);
+	memset(edcf->mapping, 0, sizeof(edcf->mapping));
+	memcpy(edcf->queue, priv->qos_params, sizeof(edcf->queue));
 
-	priv->tx(dev, hdr, sizeof(*hdr) + sizeof(*vdcf), 0);
+	p54_assign_address(dev, NULL, hdr, sizeof(*hdr) + sizeof(*edcf));
+	priv->tx(dev, hdr, sizeof(*hdr) + sizeof(*edcf), 1);
+	return 0;
 }
 
 static int p54_start(struct ieee80211_hw *dev)
@@ -1168,33 +1156,26 @@ static int p54_start(struct ieee80211_hw
 	struct p54_common *priv = dev->priv;
 	int err;
 
-	if (!priv->cached_vdcf) {
-		priv->cached_vdcf = kzalloc(sizeof(struct p54_tx_control_vdcf)+
-			priv->tx_hdr_len + sizeof(struct p54_control_hdr),
-			GFP_KERNEL);
-
-		if (!priv->cached_vdcf)
-			return -ENOMEM;
-	}
-
 	if (!priv->cached_stats) {
 		priv->cached_stats = kzalloc(sizeof(struct p54_statistics) +
 			priv->tx_hdr_len + sizeof(struct p54_control_hdr),
 			GFP_KERNEL);
 
-		if (!priv->cached_stats) {
-			kfree(priv->cached_vdcf);
-			priv->cached_vdcf = NULL;
+		if (!priv->cached_stats)
 			return -ENOMEM;
-		}
 	}
 
 	err = priv->open(dev);
 	if (!err)
 		priv->mode = NL80211_IFTYPE_MONITOR;
+	P54_SET_QUEUE(priv->qos_params[0], 0x0002, 0x0003, 0x0007, 47);
+	P54_SET_QUEUE(priv->qos_params[1], 0x0002, 0x0007, 0x000f, 94);
+	P54_SET_QUEUE(priv->qos_params[2], 0x0003, 0x000f, 0x03ff, 0);
+	P54_SET_QUEUE(priv->qos_params[3], 0x0007, 0x000f, 0x03ff, 0);
+	err = p54_set_edcf(dev);
+	if (!err)
+		mod_timer(&priv->stats_timer, jiffies + HZ);
 
-	p54_init_vdcf(dev);
-	mod_timer(&priv->stats_timer, jiffies + HZ);
 	return err;
 }
 
@@ -1264,7 +1245,8 @@ static int p54_config(struct ieee80211_h
 	priv->rx_antenna = 2; /* automatic */
 	priv->output_power = conf->power_level << 2;
 	ret = p54_set_freq(dev, cpu_to_le16(conf->channel->center_freq));
-	p54_set_vdcf(dev);
+	if (!ret)
+		ret = p54_set_edcf(dev);
 	mutex_unlock(&priv->conf_mutex);
 	return ret;
 }
@@ -1319,20 +1301,14 @@ static int p54_conf_tx(struct ieee80211_
 		       const struct ieee80211_tx_queue_params *params)
 {
 	struct p54_common *priv = dev->priv;
-	struct p54_tx_control_vdcf *vdcf;
-
-	vdcf = (struct p54_tx_control_vdcf *)(((struct p54_control_hdr *)
-		((void *)priv->cached_vdcf + priv->tx_hdr_len))->data);
 
 	if ((params) && !(queue > 4)) {
-		P54_SET_QUEUE(vdcf->queue[queue], params->aifs,
+		P54_SET_QUEUE(priv->qos_params[queue], params->aifs,
 			params->cw_min, params->cw_max, params->txop);
 	} else
 		return -EINVAL;
 
-	p54_set_vdcf(dev);
-
-	return 0;
+	return p54_set_edcf(dev);
 }
 
 static int p54_init_xbow_synth(struct ieee80211_hw *dev)
@@ -1418,7 +1394,7 @@ static void p54_bss_info_changed(struct 
 
 	if (changed & BSS_CHANGED_ERP_SLOT) {
 		priv->use_short_slot = info->use_short_slot;
-		p54_set_vdcf(dev);
+		p54_set_edcf(dev);
 	}
 }
 
@@ -1499,7 +1475,6 @@ void p54_free_common(struct ieee80211_hw
 	kfree(priv->iq_autocal);
 	kfree(priv->output_limit);
 	kfree(priv->curve_data);
-	kfree(priv->cached_vdcf);
 }
 EXPORT_SYMBOL_GPL(p54_free_common);
 
diff -Nurp a/drivers/net/wireless/p54/p54common.h b/drivers/net/wireless/p54/p54common.h
--- a/drivers/net/wireless/p54/p54common.h	2008-10-12 16:33:42.000000000 +0200
+++ b/drivers/net/wireless/p54/p54common.h	2008-10-14 22:19:24.000000000 +0200
@@ -7,8 +7,12 @@
  * Copyright (c) 2006, Michael Wu <flamingice@sourmilk.net>
  * Copyright (c) 2007, Christian Lamparter <chunkeey@web.de>
  *
- * Based on the islsm (softmac prism54) driver, which is:
- * Copyright 2004-2006 Jean-Baptiste Note <jbnote@gmail.com>, et al.
+ * Based on:
+ * - the islsm (softmac prism54) driver, which is:
+ *   Copyright 2004-2006 Jean-Baptiste Note <jbnote@gmail.com>, et al.
+ *
+ * - LMAC API interface header file for STLC4560 (lmac_longbow.h)
+ *   Copyright (C) 2007 Conexant Systems, Inc.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -286,21 +290,15 @@ struct p54_tx_control_led {
 	__le16 duration;
 } __attribute__ ((packed));
 
-struct p54_tx_vdcf_queues {
-	__le16 aifs;
-	__le16 cwmin;
-	__le16 cwmax;
-	__le16 txop;
-} __attribute__ ((packed));
-
-struct p54_tx_control_vdcf {
-	u8 padding;
+struct p54_edcf {
+	u8 flags;
 	u8 slottime;
-	u8 magic1;
-	u8 magic2;
-	struct p54_tx_vdcf_queues queue[8];
-	u8 pad2[4];
+	u8 sifs;
+	u8 eofpad;
+	struct p54_edcf_queue_param queue[8];
+	u8 mapping[4];
 	__le16 frameburst;
+	__le16 round_trip_delay;
 } __attribute__ ((packed));
 
 struct p54_statistics {
diff -Nurp a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
--- a/drivers/net/wireless/p54/p54.h	2008-10-12 16:33:42.000000000 +0200
+++ b/drivers/net/wireless/p54/p54.h	2008-10-14 22:19:58.000000000 +0200
@@ -49,6 +49,13 @@ struct p54_control_hdr {
 	u8 data[0];
 } __attribute__ ((packed));
 
+struct p54_edcf_queue_param {
+	__le16 aifs;
+	__le16 cwmin;
+	__le16 cwmax;
+	__le16 txop;
+} __attribute__ ((packed));
+
 #define EEPROM_READBACK_LEN 0x3fc
 
 #define ISL38XX_DEV_FIRMWARE_ADDR 0x20000
@@ -85,13 +92,13 @@ struct p54_common {
 	u8 version;
 	u8 rx_antenna;
 	unsigned int tx_hdr_len;
-	void *cached_vdcf;
 	unsigned int fw_var;
 	unsigned int fw_interface;
 	unsigned int output_power;
 	u32 tsf_low32;
 	u32 tsf_high32;
 	struct ieee80211_tx_queue_stats tx_stats[8];
+	struct p54_edcf_queue_param qos_params[8];
 	struct ieee80211_low_level_stats stats;
 	struct timer_list stats_timer;
 	struct completion stats_comp;
