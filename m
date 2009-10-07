Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:59889 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753AbZJGVao (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2009 17:30:44 -0400
Received: by ewy4 with SMTP id 4so2314045ewy.37
        for <linux-wireless@vger.kernel.org>; Wed, 07 Oct 2009 14:30:07 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH] orinoco: use cfg80211 ethtool ops
Date: Wed,  7 Oct 2009 22:23:32 +0100
Message-Id: <1254950612-14007-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/hw.c      |   33 +++++++++++++++++++++++--------
 drivers/net/wireless/orinoco/hw.h      |    3 +-
 drivers/net/wireless/orinoco/main.c    |   33 +++++--------------------------
 drivers/net/wireless/orinoco/orinoco.h |    1 -
 4 files changed, 32 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/orinoco/hw.c b/drivers/net/wireless/orinoco/hw.c
index 359652d..404830f 100644
--- a/drivers/net/wireless/orinoco/hw.c
+++ b/drivers/net/wireless/orinoco/hw.c
@@ -60,8 +60,15 @@ static inline fwtype_t determine_firmware_type(struct comp_id *nic_id)
 /* Set priv->firmware type, determine firmware properties
  * This function can be called before we have registerred with netdev,
  * so all errors go out with dev_* rather than printk
+ *
+ * If non-NULL stores a firmware description in fw_name.
+ * If non-NULL stores a HW version in hw_ver
+ *
+ * These are output via generic cfg80211 ethtool support.
  */
-int determine_fw_capabilities(struct orinoco_private *priv)
+int determine_fw_capabilities(struct orinoco_private *priv,
+			      char *fw_name, size_t fw_name_len,
+			      u32 *hw_ver)
 {
 	struct device *dev = priv->dev;
 	hermes_t *hw = &priv->hw;
@@ -85,6 +92,12 @@ int determine_fw_capabilities(struct orinoco_private *priv)
 	dev_info(dev, "Hardware identity %04x:%04x:%04x:%04x\n",
 		 nic_id.id, nic_id.variant, nic_id.major, nic_id.minor);
 
+	if (hw_ver)
+		*hw_ver = (((nic_id.id & 0xff) << 24) |
+			   ((nic_id.variant & 0xff) << 16) |
+			   ((nic_id.major & 0xff) << 8) |
+			   (nic_id.minor & 0xff));
+
 	priv->firmware_type = determine_firmware_type(&nic_id);
 
 	/* Get the firmware version */
@@ -135,8 +148,9 @@ int determine_fw_capabilities(struct orinoco_private *priv)
 	case FIRMWARE_TYPE_AGERE:
 		/* Lucent Wavelan IEEE, Lucent Orinoco, Cabletron RoamAbout,
 		   ELSA, Melco, HP, IBM, Dell 1150, Compaq 110/210 */
-		snprintf(priv->fw_name, sizeof(priv->fw_name) - 1,
-			 "Lucent/Agere %d.%02d", sta_id.major, sta_id.minor);
+		if (fw_name)
+			snprintf(fw_name, fw_name_len, "Lucent/Agere %d.%02d",
+				 sta_id.major, sta_id.minor);
 
 		firmver = ((unsigned long)sta_id.major << 16) | sta_id.minor;
 
@@ -185,8 +199,8 @@ int determine_fw_capabilities(struct orinoco_private *priv)
 			tmp[SYMBOL_MAX_VER_LEN] = '\0';
 		}
 
-		snprintf(priv->fw_name, sizeof(priv->fw_name) - 1,
-			 "Symbol %s", tmp);
+		if (fw_name)
+			snprintf(fw_name, fw_name_len, "Symbol %s", tmp);
 
 		priv->has_ibss = (firmver >= 0x20000);
 		priv->has_wep = (firmver >= 0x15012);
@@ -224,9 +238,9 @@ int determine_fw_capabilities(struct orinoco_private *priv)
 		 * different and less well tested */
 		/* D-Link MAC : 00:40:05:* */
 		/* Addtron MAC : 00:90:D1:* */
-		snprintf(priv->fw_name, sizeof(priv->fw_name) - 1,
-			 "Intersil %d.%d.%d", sta_id.major, sta_id.minor,
-			 sta_id.variant);
+		if (fw_name)
+			snprintf(fw_name, fw_name_len, "Intersil %d.%d.%d",
+				 sta_id.major, sta_id.minor, sta_id.variant);
 
 		firmver = ((unsigned long)sta_id.major << 16) |
 			((unsigned long)sta_id.minor << 8) | sta_id.variant;
@@ -245,7 +259,8 @@ int determine_fw_capabilities(struct orinoco_private *priv)
 		}
 		break;
 	}
-	dev_info(dev, "Firmware determined as %s\n", priv->fw_name);
+	if (fw_name)
+		dev_info(dev, "Firmware determined as %s\n", fw_name);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/orinoco/hw.h b/drivers/net/wireless/orinoco/hw.h
index 8df6e87..e2f7fdc 100644
--- a/drivers/net/wireless/orinoco/hw.h
+++ b/drivers/net/wireless/orinoco/hw.h
@@ -24,7 +24,8 @@
 struct orinoco_private;
 struct dev_addr_list;
 
-int determine_fw_capabilities(struct orinoco_private *priv);
+int determine_fw_capabilities(struct orinoco_private *priv, char *fw_name,
+			      size_t fw_name_len, u32 *hw_ver);
 int orinoco_hw_read_card_settings(struct orinoco_private *priv, u8 *dev_addr);
 int orinoco_hw_allocate_fid(struct orinoco_private *priv);
 int orinoco_get_bitratemode(int bitrate, int automatic);
diff --git a/drivers/net/wireless/orinoco/main.c b/drivers/net/wireless/orinoco/main.c
index 7a32bcb..c0c8ff6 100644
--- a/drivers/net/wireless/orinoco/main.c
+++ b/drivers/net/wireless/orinoco/main.c
@@ -83,7 +83,6 @@
 #include <linux/device.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
-#include <linux/ethtool.h>
 #include <linux/suspend.h>
 #include <linux/if_arp.h>
 #include <linux/wireless.h>
@@ -162,8 +161,6 @@ static const u8 encaps_hdr[] = {0xaa, 0xaa, 0x03, 0x00, 0x00, 0x00};
 				 | HERMES_EV_WTERR | HERMES_EV_INFO \
 				 | HERMES_EV_INFDROP)
 
-static const struct ethtool_ops orinoco_ethtool_ops;
-
 /********************************************************************/
 /* Data types                                                       */
 /********************************************************************/
@@ -1994,7 +1991,9 @@ int orinoco_init(struct orinoco_private *priv)
 		goto out;
 	}
 
-	err = determine_fw_capabilities(priv);
+	err = determine_fw_capabilities(priv, wiphy->fw_version,
+					sizeof(wiphy->fw_version),
+					&wiphy->hw_version);
 	if (err != 0) {
 		dev_err(dev, "Incompatible firmware, aborting\n");
 		goto out;
@@ -2010,7 +2009,9 @@ int orinoco_init(struct orinoco_private *priv)
 			priv->do_fw_download = 0;
 
 		/* Check firmware version again */
-		err = determine_fw_capabilities(priv);
+		err = determine_fw_capabilities(priv, wiphy->fw_version,
+						sizeof(wiphy->fw_version),
+						&wiphy->hw_version);
 		if (err != 0) {
 			dev_err(dev, "Incompatible firmware, aborting\n");
 			goto out;
@@ -2212,7 +2213,6 @@ int orinoco_if_add(struct orinoco_private *priv,
 	dev->ieee80211_ptr = wdev;
 	dev->netdev_ops = &orinoco_netdev_ops;
 	dev->watchdog_timeo = HZ; /* 1 second timeout */
-	dev->ethtool_ops = &orinoco_ethtool_ops;
 	dev->wireless_handlers = &orinoco_handler_def;
 #ifdef WIRELESS_SPY
 	dev->wireless_data = &priv->wireless_data;
@@ -2348,27 +2348,6 @@ void orinoco_down(struct orinoco_private *priv)
 }
 EXPORT_SYMBOL(orinoco_down);
 
-static void orinoco_get_drvinfo(struct net_device *dev,
-				struct ethtool_drvinfo *info)
-{
-	struct orinoco_private *priv = ndev_priv(dev);
-
-	strncpy(info->driver, DRIVER_NAME, sizeof(info->driver) - 1);
-	strncpy(info->version, DRIVER_VERSION, sizeof(info->version) - 1);
-	strncpy(info->fw_version, priv->fw_name, sizeof(info->fw_version) - 1);
-	if (dev->dev.parent)
-		strncpy(info->bus_info, dev_name(dev->dev.parent),
-			sizeof(info->bus_info) - 1);
-	else
-		snprintf(info->bus_info, sizeof(info->bus_info) - 1,
-			 "PCMCIA %p", priv->hw.iobase);
-}
-
-static const struct ethtool_ops orinoco_ethtool_ops = {
-	.get_drvinfo = orinoco_get_drvinfo,
-	.get_link = ethtool_op_get_link,
-};
-
 /********************************************************************/
 /* Module initialization                                            */
 /********************************************************************/
diff --git a/drivers/net/wireless/orinoco/orinoco.h b/drivers/net/wireless/orinoco/orinoco.h
index 9ac6f1d..665ef56 100644
--- a/drivers/net/wireless/orinoco/orinoco.h
+++ b/drivers/net/wireless/orinoco/orinoco.h
@@ -93,7 +93,6 @@ struct orinoco_private {
 
 	/* Capabilities of the hardware/firmware */
 	fwtype_t firmware_type;
-	char fw_name[32];
 	int ibss_port;
 	int nicbuf_size;
 	u16 channel_mask;
-- 
1.6.3.3

