Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:64563 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148AbZFRWV7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 18:21:59 -0400
Received: by mail-ew0-f210.google.com with SMTP id 6so1987323ewy.37
        for <linux-wireless@vger.kernel.org>; Thu, 18 Jun 2009 15:22:01 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 06/23] orinoco: Move firmware capability determination into hw.c
Date: Thu, 18 Jun 2009 23:21:18 +0100
Message-Id: <1245363695-8289-7-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1245363695-8289-1-git-send-email-kilroyd@googlemail.com>
References: <1245363695-8289-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is part of refactorring the initialisation code so that we can load
the firmware before registerring with netdev.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/hw.c   |  216 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/orinoco/hw.h   |    1 +
 drivers/net/wireless/orinoco/main.c |  218 +----------------------------------
 3 files changed, 219 insertions(+), 216 deletions(-)

diff --git a/drivers/net/wireless/orinoco/hw.c b/drivers/net/wireless/orinoco/hw.c
index 632fac8..209c6be 100644
--- a/drivers/net/wireless/orinoco/hw.c
+++ b/drivers/net/wireless/orinoco/hw.c
@@ -13,6 +13,8 @@
 
 #include "hw.h"
 
+#define SYMBOL_MAX_VER_LEN	(14)
+
 /********************************************************************/
 /* Data tables                                                      */
 /********************************************************************/
@@ -36,6 +38,220 @@ static const struct {
 };
 #define BITRATE_TABLE_SIZE ARRAY_SIZE(bitrate_table)
 
+/* Firmware version encoding */
+struct comp_id {
+	u16 id, variant, major, minor;
+} __attribute__ ((packed));
+
+static inline fwtype_t determine_firmware_type(struct comp_id *nic_id)
+{
+	if (nic_id->id < 0x8000)
+		return FIRMWARE_TYPE_AGERE;
+	else if (nic_id->id == 0x8000 && nic_id->major == 0)
+		return FIRMWARE_TYPE_SYMBOL;
+	else
+		return FIRMWARE_TYPE_INTERSIL;
+}
+
+/* Set priv->firmware type, determine firmware properties */
+int determine_fw_capabilities(struct orinoco_private *priv)
+{
+	struct net_device *dev = priv->ndev;
+	hermes_t *hw = &priv->hw;
+	int err;
+	struct comp_id nic_id, sta_id;
+	unsigned int firmver;
+	char tmp[SYMBOL_MAX_VER_LEN+1] __attribute__((aligned(2)));
+
+	/* Get the hardware version */
+	err = HERMES_READ_RECORD(hw, USER_BAP, HERMES_RID_NICID, &nic_id);
+	if (err) {
+		printk(KERN_ERR "%s: Cannot read hardware identity: error %d\n",
+		       dev->name, err);
+		return err;
+	}
+
+	le16_to_cpus(&nic_id.id);
+	le16_to_cpus(&nic_id.variant);
+	le16_to_cpus(&nic_id.major);
+	le16_to_cpus(&nic_id.minor);
+	printk(KERN_DEBUG "%s: Hardware identity %04x:%04x:%04x:%04x\n",
+	       dev->name, nic_id.id, nic_id.variant,
+	       nic_id.major, nic_id.minor);
+
+	priv->firmware_type = determine_firmware_type(&nic_id);
+
+	/* Get the firmware version */
+	err = HERMES_READ_RECORD(hw, USER_BAP, HERMES_RID_STAID, &sta_id);
+	if (err) {
+		printk(KERN_ERR "%s: Cannot read station identity: error %d\n",
+		       dev->name, err);
+		return err;
+	}
+
+	le16_to_cpus(&sta_id.id);
+	le16_to_cpus(&sta_id.variant);
+	le16_to_cpus(&sta_id.major);
+	le16_to_cpus(&sta_id.minor);
+	printk(KERN_DEBUG "%s: Station identity  %04x:%04x:%04x:%04x\n",
+	       dev->name, sta_id.id, sta_id.variant,
+	       sta_id.major, sta_id.minor);
+
+	switch (sta_id.id) {
+	case 0x15:
+		printk(KERN_ERR "%s: Primary firmware is active\n",
+		       dev->name);
+		return -ENODEV;
+	case 0x14b:
+		printk(KERN_ERR "%s: Tertiary firmware is active\n",
+		       dev->name);
+		return -ENODEV;
+	case 0x1f:	/* Intersil, Agere, Symbol Spectrum24 */
+	case 0x21:	/* Symbol Spectrum24 Trilogy */
+		break;
+	default:
+		printk(KERN_NOTICE "%s: Unknown station ID, please report\n",
+		       dev->name);
+		break;
+	}
+
+	/* Default capabilities */
+	priv->has_sensitivity = 1;
+	priv->has_mwo = 0;
+	priv->has_preamble = 0;
+	priv->has_port3 = 1;
+	priv->has_ibss = 1;
+	priv->has_wep = 0;
+	priv->has_big_wep = 0;
+	priv->has_alt_txcntl = 0;
+	priv->has_ext_scan = 0;
+	priv->has_wpa = 0;
+	priv->do_fw_download = 0;
+
+	/* Determine capabilities from the firmware version */
+	switch (priv->firmware_type) {
+	case FIRMWARE_TYPE_AGERE:
+		/* Lucent Wavelan IEEE, Lucent Orinoco, Cabletron RoamAbout,
+		   ELSA, Melco, HP, IBM, Dell 1150, Compaq 110/210 */
+		snprintf(priv->fw_name, sizeof(priv->fw_name) - 1,
+			 "Lucent/Agere %d.%02d", sta_id.major, sta_id.minor);
+
+		firmver = ((unsigned long)sta_id.major << 16) | sta_id.minor;
+
+		priv->has_ibss = (firmver >= 0x60006);
+		priv->has_wep = (firmver >= 0x40020);
+		priv->has_big_wep = 1; /* FIXME: this is wrong - how do we tell
+					  Gold cards from the others? */
+		priv->has_mwo = (firmver >= 0x60000);
+		priv->has_pm = (firmver >= 0x40020); /* Don't work in 7.52 ? */
+		priv->ibss_port = 1;
+		priv->has_hostscan = (firmver >= 0x8000a);
+		priv->do_fw_download = 1;
+		priv->broken_monitor = (firmver >= 0x80000);
+		priv->has_alt_txcntl = (firmver >= 0x90000); /* All 9.x ? */
+		priv->has_ext_scan = (firmver >= 0x90000); /* All 9.x ? */
+		priv->has_wpa = (firmver >= 0x9002a);
+		/* Tested with Agere firmware :
+		 *	1.16 ; 4.08 ; 4.52 ; 6.04 ; 6.16 ; 7.28 => Jean II
+		 * Tested CableTron firmware : 4.32 => Anton */
+		break;
+	case FIRMWARE_TYPE_SYMBOL:
+		/* Symbol , 3Com AirConnect, Intel, Ericsson WLAN */
+		/* Intel MAC : 00:02:B3:* */
+		/* 3Com MAC : 00:50:DA:* */
+		memset(tmp, 0, sizeof(tmp));
+		/* Get the Symbol firmware version */
+		err = hermes_read_ltv(hw, USER_BAP,
+				      HERMES_RID_SECONDARYVERSION_SYMBOL,
+				      SYMBOL_MAX_VER_LEN, NULL, &tmp);
+		if (err) {
+			printk(KERN_WARNING
+			       "%s: Error %d reading Symbol firmware info. "
+			       "Wildly guessing capabilities...\n",
+			       dev->name, err);
+			firmver = 0;
+			tmp[0] = '\0';
+		} else {
+			/* The firmware revision is a string, the format is
+			 * something like : "V2.20-01".
+			 * Quick and dirty parsing... - Jean II
+			 */
+			firmver = ((tmp[1] - '0') << 16)
+				| ((tmp[3] - '0') << 12)
+				| ((tmp[4] - '0') << 8)
+				| ((tmp[6] - '0') << 4)
+				| (tmp[7] - '0');
+
+			tmp[SYMBOL_MAX_VER_LEN] = '\0';
+		}
+
+		snprintf(priv->fw_name, sizeof(priv->fw_name) - 1,
+			 "Symbol %s", tmp);
+
+		priv->has_ibss = (firmver >= 0x20000);
+		priv->has_wep = (firmver >= 0x15012);
+		priv->has_big_wep = (firmver >= 0x20000);
+		priv->has_pm = (firmver >= 0x20000 && firmver < 0x22000) ||
+			       (firmver >= 0x29000 && firmver < 0x30000) ||
+			       firmver >= 0x31000;
+		priv->has_preamble = (firmver >= 0x20000);
+		priv->ibss_port = 4;
+
+		/* Symbol firmware is found on various cards, but
+		 * there has been no attempt to check firmware
+		 * download on non-spectrum_cs based cards.
+		 *
+		 * Given that the Agere firmware download works
+		 * differently, we should avoid doing a firmware
+		 * download with the Symbol algorithm on non-spectrum
+		 * cards.
+		 *
+		 * For now we can identify a spectrum_cs based card
+		 * because it has a firmware reset function.
+		 */
+		priv->do_fw_download = (priv->stop_fw != NULL);
+
+		priv->broken_disableport = (firmver == 0x25013) ||
+				(firmver >= 0x30000 && firmver <= 0x31000);
+		priv->has_hostscan = (firmver >= 0x31001) ||
+				     (firmver >= 0x29057 && firmver < 0x30000);
+		/* Tested with Intel firmware : 0x20015 => Jean II */
+		/* Tested with 3Com firmware : 0x15012 & 0x22001 => Jean II */
+		break;
+	case FIRMWARE_TYPE_INTERSIL:
+		/* D-Link, Linksys, Adtron, ZoomAir, and many others...
+		 * Samsung, Compaq 100/200 and Proxim are slightly
+		 * different and less well tested */
+		/* D-Link MAC : 00:40:05:* */
+		/* Addtron MAC : 00:90:D1:* */
+		snprintf(priv->fw_name, sizeof(priv->fw_name) - 1,
+			 "Intersil %d.%d.%d", sta_id.major, sta_id.minor,
+			 sta_id.variant);
+
+		firmver = ((unsigned long)sta_id.major << 16) |
+			((unsigned long)sta_id.minor << 8) | sta_id.variant;
+
+		priv->has_ibss = (firmver >= 0x000700); /* FIXME */
+		priv->has_big_wep = priv->has_wep = (firmver >= 0x000800);
+		priv->has_pm = (firmver >= 0x000700);
+		priv->has_hostscan = (firmver >= 0x010301);
+
+		if (firmver >= 0x000800)
+			priv->ibss_port = 0;
+		else {
+			printk(KERN_NOTICE "%s: Intersil firmware earlier "
+			       "than v0.8.x - several features not supported\n",
+			       dev->name);
+			priv->ibss_port = 1;
+		}
+		break;
+	}
+	printk(KERN_DEBUG "%s: Firmware determined as %s\n", dev->name,
+	       priv->fw_name);
+
+	return 0;
+}
+
 int orinoco_get_bitratemode(int bitrate, int automatic)
 {
 	int ratemode = -1;
diff --git a/drivers/net/wireless/orinoco/hw.h b/drivers/net/wireless/orinoco/hw.h
index dc3f23a..f7845b8 100644
--- a/drivers/net/wireless/orinoco/hw.h
+++ b/drivers/net/wireless/orinoco/hw.h
@@ -23,6 +23,7 @@
 struct orinoco_private;
 struct dev_addr_list;
 
+int determine_fw_capabilities(struct orinoco_private *priv);
 int orinoco_get_bitratemode(int bitrate, int automatic);
 void orinoco_get_ratemode_cfg(int ratemode, int *bitrate, int *automatic);
 
diff --git a/drivers/net/wireless/orinoco/main.c b/drivers/net/wireless/orinoco/main.c
index 345593c..33326d6 100644
--- a/drivers/net/wireless/orinoco/main.c
+++ b/drivers/net/wireless/orinoco/main.c
@@ -142,7 +142,6 @@ static const u8 encaps_hdr[] = {0xaa, 0xaa, 0x03, 0x00, 0x00, 0x00};
 #define ORINOCO_MIN_MTU		256
 #define ORINOCO_MAX_MTU		(IEEE80211_MAX_DATA_LEN - ENCAPS_OVERHEAD)
 
-#define SYMBOL_MAX_VER_LEN	(14)
 #define MAX_IRQLOOPS_PER_IRQ	10
 #define MAX_IRQLOOPS_PER_JIFFY	(20000/HZ) /* Based on a guestimate of
 					    * how many events the
@@ -2096,219 +2095,6 @@ static void orinoco_unregister_pm_notifier(struct orinoco_private *priv)
 /* Initialization                                                   */
 /********************************************************************/
 
-struct comp_id {
-	u16 id, variant, major, minor;
-} __attribute__ ((packed));
-
-static inline fwtype_t determine_firmware_type(struct comp_id *nic_id)
-{
-	if (nic_id->id < 0x8000)
-		return FIRMWARE_TYPE_AGERE;
-	else if (nic_id->id == 0x8000 && nic_id->major == 0)
-		return FIRMWARE_TYPE_SYMBOL;
-	else
-		return FIRMWARE_TYPE_INTERSIL;
-}
-
-/* Set priv->firmware type, determine firmware properties */
-static int determine_firmware(struct net_device *dev)
-{
-	struct orinoco_private *priv = netdev_priv(dev);
-	hermes_t *hw = &priv->hw;
-	int err;
-	struct comp_id nic_id, sta_id;
-	unsigned int firmver;
-	char tmp[SYMBOL_MAX_VER_LEN+1] __attribute__((aligned(2)));
-
-	/* Get the hardware version */
-	err = HERMES_READ_RECORD(hw, USER_BAP, HERMES_RID_NICID, &nic_id);
-	if (err) {
-		printk(KERN_ERR "%s: Cannot read hardware identity: error %d\n",
-		       dev->name, err);
-		return err;
-	}
-
-	le16_to_cpus(&nic_id.id);
-	le16_to_cpus(&nic_id.variant);
-	le16_to_cpus(&nic_id.major);
-	le16_to_cpus(&nic_id.minor);
-	printk(KERN_DEBUG "%s: Hardware identity %04x:%04x:%04x:%04x\n",
-	       dev->name, nic_id.id, nic_id.variant,
-	       nic_id.major, nic_id.minor);
-
-	priv->firmware_type = determine_firmware_type(&nic_id);
-
-	/* Get the firmware version */
-	err = HERMES_READ_RECORD(hw, USER_BAP, HERMES_RID_STAID, &sta_id);
-	if (err) {
-		printk(KERN_ERR "%s: Cannot read station identity: error %d\n",
-		       dev->name, err);
-		return err;
-	}
-
-	le16_to_cpus(&sta_id.id);
-	le16_to_cpus(&sta_id.variant);
-	le16_to_cpus(&sta_id.major);
-	le16_to_cpus(&sta_id.minor);
-	printk(KERN_DEBUG "%s: Station identity  %04x:%04x:%04x:%04x\n",
-	       dev->name, sta_id.id, sta_id.variant,
-	       sta_id.major, sta_id.minor);
-
-	switch (sta_id.id) {
-	case 0x15:
-		printk(KERN_ERR "%s: Primary firmware is active\n",
-		       dev->name);
-		return -ENODEV;
-	case 0x14b:
-		printk(KERN_ERR "%s: Tertiary firmware is active\n",
-		       dev->name);
-		return -ENODEV;
-	case 0x1f:	/* Intersil, Agere, Symbol Spectrum24 */
-	case 0x21:	/* Symbol Spectrum24 Trilogy */
-		break;
-	default:
-		printk(KERN_NOTICE "%s: Unknown station ID, please report\n",
-		       dev->name);
-		break;
-	}
-
-	/* Default capabilities */
-	priv->has_sensitivity = 1;
-	priv->has_mwo = 0;
-	priv->has_preamble = 0;
-	priv->has_port3 = 1;
-	priv->has_ibss = 1;
-	priv->has_wep = 0;
-	priv->has_big_wep = 0;
-	priv->has_alt_txcntl = 0;
-	priv->has_ext_scan = 0;
-	priv->has_wpa = 0;
-	priv->do_fw_download = 0;
-
-	/* Determine capabilities from the firmware version */
-	switch (priv->firmware_type) {
-	case FIRMWARE_TYPE_AGERE:
-		/* Lucent Wavelan IEEE, Lucent Orinoco, Cabletron RoamAbout,
-		   ELSA, Melco, HP, IBM, Dell 1150, Compaq 110/210 */
-		snprintf(priv->fw_name, sizeof(priv->fw_name) - 1,
-			 "Lucent/Agere %d.%02d", sta_id.major, sta_id.minor);
-
-		firmver = ((unsigned long)sta_id.major << 16) | sta_id.minor;
-
-		priv->has_ibss = (firmver >= 0x60006);
-		priv->has_wep = (firmver >= 0x40020);
-		priv->has_big_wep = 1; /* FIXME: this is wrong - how do we tell
-					  Gold cards from the others? */
-		priv->has_mwo = (firmver >= 0x60000);
-		priv->has_pm = (firmver >= 0x40020); /* Don't work in 7.52 ? */
-		priv->ibss_port = 1;
-		priv->has_hostscan = (firmver >= 0x8000a);
-		priv->do_fw_download = 1;
-		priv->broken_monitor = (firmver >= 0x80000);
-		priv->has_alt_txcntl = (firmver >= 0x90000); /* All 9.x ? */
-		priv->has_ext_scan = (firmver >= 0x90000); /* All 9.x ? */
-		priv->has_wpa = (firmver >= 0x9002a);
-		/* Tested with Agere firmware :
-		 *	1.16 ; 4.08 ; 4.52 ; 6.04 ; 6.16 ; 7.28 => Jean II
-		 * Tested CableTron firmware : 4.32 => Anton */
-		break;
-	case FIRMWARE_TYPE_SYMBOL:
-		/* Symbol , 3Com AirConnect, Intel, Ericsson WLAN */
-		/* Intel MAC : 00:02:B3:* */
-		/* 3Com MAC : 00:50:DA:* */
-		memset(tmp, 0, sizeof(tmp));
-		/* Get the Symbol firmware version */
-		err = hermes_read_ltv(hw, USER_BAP,
-				      HERMES_RID_SECONDARYVERSION_SYMBOL,
-				      SYMBOL_MAX_VER_LEN, NULL, &tmp);
-		if (err) {
-			printk(KERN_WARNING
-			       "%s: Error %d reading Symbol firmware info. "
-			       "Wildly guessing capabilities...\n",
-			       dev->name, err);
-			firmver = 0;
-			tmp[0] = '\0';
-		} else {
-			/* The firmware revision is a string, the format is
-			 * something like : "V2.20-01".
-			 * Quick and dirty parsing... - Jean II
-			 */
-			firmver = ((tmp[1] - '0') << 16)
-				| ((tmp[3] - '0') << 12)
-				| ((tmp[4] - '0') << 8)
-				| ((tmp[6] - '0') << 4)
-				| (tmp[7] - '0');
-
-			tmp[SYMBOL_MAX_VER_LEN] = '\0';
-		}
-
-		snprintf(priv->fw_name, sizeof(priv->fw_name) - 1,
-			 "Symbol %s", tmp);
-
-		priv->has_ibss = (firmver >= 0x20000);
-		priv->has_wep = (firmver >= 0x15012);
-		priv->has_big_wep = (firmver >= 0x20000);
-		priv->has_pm = (firmver >= 0x20000 && firmver < 0x22000) ||
-			       (firmver >= 0x29000 && firmver < 0x30000) ||
-			       firmver >= 0x31000;
-		priv->has_preamble = (firmver >= 0x20000);
-		priv->ibss_port = 4;
-
-		/* Symbol firmware is found on various cards, but
-		 * there has been no attempt to check firmware
-		 * download on non-spectrum_cs based cards.
-		 *
-		 * Given that the Agere firmware download works
-		 * differently, we should avoid doing a firmware
-		 * download with the Symbol algorithm on non-spectrum
-		 * cards.
-		 *
-		 * For now we can identify a spectrum_cs based card
-		 * because it has a firmware reset function.
-		 */
-		priv->do_fw_download = (priv->stop_fw != NULL);
-
-		priv->broken_disableport = (firmver == 0x25013) ||
-				(firmver >= 0x30000 && firmver <= 0x31000);
-		priv->has_hostscan = (firmver >= 0x31001) ||
-				     (firmver >= 0x29057 && firmver < 0x30000);
-		/* Tested with Intel firmware : 0x20015 => Jean II */
-		/* Tested with 3Com firmware : 0x15012 & 0x22001 => Jean II */
-		break;
-	case FIRMWARE_TYPE_INTERSIL:
-		/* D-Link, Linksys, Adtron, ZoomAir, and many others...
-		 * Samsung, Compaq 100/200 and Proxim are slightly
-		 * different and less well tested */
-		/* D-Link MAC : 00:40:05:* */
-		/* Addtron MAC : 00:90:D1:* */
-		snprintf(priv->fw_name, sizeof(priv->fw_name) - 1,
-			 "Intersil %d.%d.%d", sta_id.major, sta_id.minor,
-			 sta_id.variant);
-
-		firmver = ((unsigned long)sta_id.major << 16) |
-			((unsigned long)sta_id.minor << 8) | sta_id.variant;
-
-		priv->has_ibss = (firmver >= 0x000700); /* FIXME */
-		priv->has_big_wep = priv->has_wep = (firmver >= 0x000800);
-		priv->has_pm = (firmver >= 0x000700);
-		priv->has_hostscan = (firmver >= 0x010301);
-
-		if (firmver >= 0x000800)
-			priv->ibss_port = 0;
-		else {
-			printk(KERN_NOTICE "%s: Intersil firmware earlier "
-			       "than v0.8.x - several features not supported\n",
-			       dev->name);
-			priv->ibss_port = 1;
-		}
-		break;
-	}
-	printk(KERN_DEBUG "%s: Firmware determined as %s\n", dev->name,
-	       priv->fw_name);
-
-	return 0;
-}
-
 static int orinoco_init(struct net_device *dev)
 {
 	struct orinoco_private *priv = netdev_priv(dev);
@@ -2330,7 +2116,7 @@ static int orinoco_init(struct net_device *dev)
 		goto out;
 	}
 
-	err = determine_firmware(dev);
+	err = determine_fw_capabilities(priv);
 	if (err != 0) {
 		printk(KERN_ERR "%s: Incompatible firmware, aborting\n",
 		       dev->name);
@@ -2347,7 +2133,7 @@ static int orinoco_init(struct net_device *dev)
 			priv->do_fw_download = 0;
 
 		/* Check firmware version again */
-		err = determine_firmware(dev);
+		err = determine_fw_capabilities(priv);
 		if (err != 0) {
 			printk(KERN_ERR "%s: Incompatible firmware, aborting\n",
 			       dev->name);
-- 
1.6.0.6

