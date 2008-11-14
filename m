Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:40180 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbYKNSl7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2008 13:41:59 -0500
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 3/4] p54: protect against sudden firmware file changes
Date: Fri, 14 Nov 2008 19:41:56 +0100
Cc: John W Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Pavel Roskin <proski@gnu.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200811141941.56752.chunkeey@web.de> (sfid-20081114_194201_685940_C3159ACC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks to "p54: introduce new names for device firmwares"
(325ca16910a380c...) people are now migrating away from the buggy firmwares. 
Of course this is a very good idea, but no one told them to unload the driver first.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-11-14 18:08:22.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.c	2008-11-14 18:12:15.000000000 +0100
@@ -19,6 +19,7 @@
 #include <linux/init.h>
 #include <linux/firmware.h>
 #include <linux/etherdevice.h>
+#include <linux/crc32.h>
 
 #include <net/mac80211.h>
 
@@ -132,12 +133,22 @@ int p54_parse_firmware(struct ieee80211_
 	struct bootrec *bootrec;
 	u32 *data = (u32 *)fw->data;
 	u32 *end_data = (u32 *)fw->data + (fw->size >> 2);
+	u32 crc = crc32_le(~0, (void *)data, fw->size >> 2);
 	u8 *fw_version = NULL;
 	size_t len;
 	int i;
 
-	if (priv->rx_start)
-		return 0;
+	if (priv->fw_crc) {
+		if (priv->fw_crc == crc)
+			return 0;
+
+		printk(KERN_ERR "%s: DO NOT (ex)change firmware files while "
+				"the driver is loaded. This device is now "
+				"disabled. Please reload the driver, "
+				"if you want it back!",
+				wiphy_name(dev->wiphy));
+		return -EINVAL;
+	}
 
 	while (data < end_data && *data)
 		data++;
@@ -227,6 +238,7 @@ int p54_parse_firmware(struct ieee80211_
 		priv->tx_stats[7].limit = 2;		/* AC_BK */
 		dev->queues = 4;
 	}
+	priv->fw_crc = crc;
 
 	return 0;
 }
@@ -1525,16 +1537,24 @@ static int p54_start(struct ieee80211_hw
 
 	mutex_lock(&priv->conf_mutex);
 	err = priv->open(dev);
-	if (!err)
-		priv->mode = NL80211_IFTYPE_MONITOR;
+	if (err)
+		goto out;
 	P54_SET_QUEUE(priv->qos_params[0], 0x0002, 0x0003, 0x0007, 47);
 	P54_SET_QUEUE(priv->qos_params[1], 0x0002, 0x0007, 0x000f, 94);
 	P54_SET_QUEUE(priv->qos_params[2], 0x0003, 0x000f, 0x03ff, 0);
 	P54_SET_QUEUE(priv->qos_params[3], 0x0007, 0x000f, 0x03ff, 0);
 	err = p54_set_edcf(dev);
-	if (!err)
-		err = p54_init_stats(dev);
+	if (err)
+		goto out;
+	err = p54_init_stats(dev);
+	if (err)
+		goto out;
+	err = p54_setup_mac(dev, P54_FILTER_TYPE_NONE, NULL);
+	if (err)
+		goto out;
+	priv->mode = NL80211_IFTYPE_MONITOR;
 
+out:
 	mutex_unlock(&priv->conf_mutex);
 	return err;
 }
diff -Nurp a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
--- a/drivers/net/wireless/p54/p54.h	2008-11-14 00:14:59.000000000 +0100
+++ b/drivers/net/wireless/p54/p54.h	2008-11-05 23:31:28.000000000 +0100
@@ -73,6 +73,7 @@ struct p54_edcf_queue_param {
 struct p54_common {
 	u32 rx_start;
 	u32 rx_end;
+	u32 fw_crc;
 	struct sk_buff_head tx_queue;
 	void (*tx)(struct ieee80211_hw *dev, struct sk_buff *skb,
 		   int free_on_tx);
