Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:65310 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986AbZLBO3g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Dec 2009 09:29:36 -0500
Received: by mail-bw0-f227.google.com with SMTP id 27so217224bwz.21
        for <linux-wireless@vger.kernel.org>; Wed, 02 Dec 2009 06:29:43 -0800 (PST)
Message-Id: <20091202142908.338175315@gmail.com>
References: <20091202142555.654873300@gmail.com>
Date: Wed, 02 Dec 2009 15:25:56 +0100
From: Holger Schurig <holgerschurig@googlemail.com>
To: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: [PATCH 01/10] libertas: use priv->mesh_tlv instead of priv->mesh_fw_ver
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Both variables contained the same information (no mesh, old mesh, new mesh).
So we can get rid of one variable.

Also move the mesh-version test from cmd.c into mesh.c.

Signed-off-by: Holger Schurig <holgerschurig@gmail.com>

--- linux-wl.orig/drivers/net/wireless/libertas/defs.h
+++ linux-wl/drivers/net/wireless/libertas/defs.h
@@ -397,13 +397,6 @@ enum KEY_INFO_WPA {
 	KEY_INFO_WPA_ENABLED = 0x04
 };
 
-/** mesh_fw_ver */
-enum _mesh_fw_ver {
-	MESH_NONE = 0, /* MESH is not supported */
-	MESH_FW_OLD,   /* MESH is supported in FW V5 */
-	MESH_FW_NEW,   /* MESH is supported in FW V10 and newer */
-};
-
 /* Default values for fwt commands. */
 #define FWT_DEFAULT_METRIC 0
 #define FWT_DEFAULT_DIR 1
--- linux-wl.orig/drivers/net/wireless/libertas/dev.h
+++ linux-wl/drivers/net/wireless/libertas/dev.h
@@ -42,7 +42,6 @@ struct lbs_private {
 	u32 mesh_connect_status;
 	struct lbs_mesh_stats mstats;
 	int mesh_open;
-	int mesh_fw_ver;
 	int mesh_autostart_enabled;
 	uint16_t mesh_tlv;
 	u8 mesh_ssid[IEEE80211_MAX_SSID_LEN + 1];
--- linux-wl.orig/drivers/net/wireless/libertas/cmd.c
+++ linux-wl/drivers/net/wireless/libertas/cmd.c
@@ -143,19 +143,6 @@ int lbs_update_hw_spec(struct lbs_privat
 	lbs_deb_cmd("GET_HW_SPEC: hardware interface 0x%x, hardware spec 0x%04x\n",
 		    cmd.hwifversion, cmd.version);
 
-	/* Determine mesh_fw_ver from fwrelease and fwcapinfo */
-	/* 5.0.16p0 9.0.0.p0 is known to NOT support any mesh */
-	/* 5.110.22 have mesh command with 0xa3 command id */
-	/* 10.0.0.p0 FW brings in mesh config command with different id */
-	/* Check FW version MSB and initialize mesh_fw_ver */
-	if (MRVL_FW_MAJOR_REV(priv->fwrelease) == MRVL_FW_V5)
-		priv->mesh_fw_ver = MESH_FW_OLD;
-	else if ((MRVL_FW_MAJOR_REV(priv->fwrelease) >= MRVL_FW_V10) &&
-		(priv->fwcapinfo & MESH_CAPINFO_ENABLE_MASK))
-		priv->mesh_fw_ver = MESH_FW_NEW;
-	else
-		priv->mesh_fw_ver = MESH_NONE;
-
 	/* Clamp region code to 8-bit since FW spec indicates that it should
 	 * only ever be 8-bit, even though the field size is 16-bit.  Some firmware
 	 * returns non-zero high 8 bits here.
--- linux-wl.orig/drivers/net/wireless/libertas/mesh.c
+++ linux-wl/drivers/net/wireless/libertas/mesh.c
@@ -196,7 +196,12 @@ int lbs_init_mesh(struct lbs_private *pr
 
 	lbs_deb_enter(LBS_DEB_MESH);
 
-	if (priv->mesh_fw_ver == MESH_FW_OLD) {
+	/* Determine mesh_fw_ver from fwrelease and fwcapinfo */
+	/* 5.0.16p0 9.0.0.p0 is known to NOT support any mesh */
+	/* 5.110.22 have mesh command with 0xa3 command id */
+	/* 10.0.0.p0 FW brings in mesh config command with different id */
+	/* Check FW version MSB and initialize mesh_fw_ver */
+	if (MRVL_FW_MAJOR_REV(priv->fwrelease) == MRVL_FW_V5) {
 		/* Enable mesh, if supported, and work out which TLV it uses.
 		   0x100 + 291 is an unofficial value used in 5.110.20.pXX
 		   0x100 + 37 is the official value used in 5.110.21.pXX
@@ -218,7 +223,9 @@ int lbs_init_mesh(struct lbs_private *pr
 					    priv->channel))
 				priv->mesh_tlv = 0;
 		}
-	} else if (priv->mesh_fw_ver == MESH_FW_NEW) {
+	} else
+	if ((MRVL_FW_MAJOR_REV(priv->fwrelease) >= MRVL_FW_V10) &&
+		(priv->fwcapinfo & MESH_CAPINFO_ENABLE_MASK)) {
 		/* 10.0.0.pXX new firmwares should succeed with TLV
 		 * 0x100+37; Do not invoke command with old TLV.
 		 */
@@ -227,6 +234,8 @@ int lbs_init_mesh(struct lbs_private *pr
 				    priv->channel))
 			priv->mesh_tlv = 0;
 	}
+
+
 	if (priv->mesh_tlv) {
 		lbs_add_mesh(priv);
 
@@ -416,10 +425,10 @@ struct net_device *lbs_mesh_set_dev(stru
 	struct net_device *dev, struct rxpd *rxpd)
 {
 	if (priv->mesh_dev) {
-		if (priv->mesh_fw_ver == MESH_FW_OLD) {
+		if (priv->mesh_tlv == TLV_TYPE_OLD_MESH_ID) {
 			if (rxpd->rx_control & RxPD_MESH_FRAME)
 				dev = priv->mesh_dev;
-		} else if (priv->mesh_fw_ver == MESH_FW_NEW) {
+		} else if (priv->mesh_tlv == TLV_TYPE_MESH_ID) {
 			if (rxpd->u.bss.bss_num == MESH_IFACE_ID)
 				dev = priv->mesh_dev;
 		}
@@ -432,9 +441,9 @@ void lbs_mesh_set_txpd(struct lbs_privat
 	struct net_device *dev, struct txpd *txpd)
 {
 	if (dev == priv->mesh_dev) {
-		if (priv->mesh_fw_ver == MESH_FW_OLD)
+		if (priv->mesh_tlv == TLV_TYPE_OLD_MESH_ID)
 			txpd->tx_control |= cpu_to_le32(TxPD_MESH_FRAME);
-		else if (priv->mesh_fw_ver == MESH_FW_NEW)
+		else if (priv->mesh_tlv == TLV_TYPE_MESH_ID)
 			txpd->u.bss.bss_num = MESH_IFACE_ID;
 	}
 }
@@ -538,7 +547,7 @@ static int __lbs_mesh_config_send(struct
 	 * Command id is 0xac for v10 FW along with mesh interface
 	 * id in bits 14-13-12.
 	 */
-	if (priv->mesh_fw_ver == MESH_FW_NEW)
+	if (priv->mesh_tlv == TLV_TYPE_MESH_ID)
 		command = CMD_MESH_CONFIG |
 			  (MESH_IFACE_ID << MESH_IFACE_BIT_OFFSET);
 

-- 
http://www.holgerschurig.de
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
