Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:37496 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751998AbZCMXdi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2009 19:33:38 -0400
Date: Fri, 13 Mar 2009 15:06:35 -0700 (PDT)
From: Bing Zhao <bzhao@marvell.com>
To: Dan Williams <dcbw@redhat.com>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	Bing Zhao <bzhao@marvell.com>
Subject: Re: [PATCH resend] libertas: support mesh for various firmware
 versions
In-Reply-To: <alpine.LFD.0.9999.0903111802190.6150@localhost.localdomain>
Message-ID: <alpine.LFD.0.9999.0903131438560.15130@localhost.localdomain> (sfid-20090314_003402_927170_4EB0539C)
References: <alpine.LFD.0.9999.0903111802190.6150@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Wed, 11 Mar 2009, Bing Zhao wrote:

> On Wednesday, March 11, 2009 at 3:26 AM, Dan Williams wrote:
> 
> > I'd prefer to keep this code; can you protect it with firmware version
> > checks for firmware < 5.1?  It looks like those older firmware versions
> > use it, but the 5.1 specification marks RxStatus "Reserved".  Since the
> > driver still works with cf8385 and sd8385 using firmware 5.0.16 and
> > such, I'm not sure we should remove this yet.
> 
> The firmware seems always set MRVDRV_RXPD_STATUS_OK bit in status field.
> I'll double check for this with the old firmware v5.0.16.
> 
> The patch will be re-sent to address above issues.
> 

Hi Dan,

We've confirmed that all firmware revisions (including those older than
5.0.16) set MRVDRV_RXPD_STATUS_OK bit unconditionally. So validating
STATUS_OK in driver seems redundant.

All other issues are addressed in the updated patch below.

Thanks,

Bing



----------------------------------------------------

libertas: support mesh for various firmware versions

CMD_MESH_CONFIG command ID and a couple of structure members in TxPD,
RxPD have been changed in firmware version 10.x.y.z and newer.

Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/libertas/cmd.c     |   26 +++++++++++++++++-
 drivers/net/wireless/libertas/defs.h    |   21 ++++++++++++++
 drivers/net/wireless/libertas/dev.h     |    1 +
 drivers/net/wireless/libertas/host.h    |    3 +-
 drivers/net/wireless/libertas/hostcmd.h |   28 +++++++++++++++++---
 drivers/net/wireless/libertas/main.c    |   44 +++++++++++++++++++------------
 drivers/net/wireless/libertas/rx.c      |   32 ++++++----------------
 drivers/net/wireless/libertas/tx.c      |    8 ++++-
 drivers/net/wireless/libertas/types.h   |    2 +
 9 files changed, 116 insertions(+), 49 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 639dd02..98b6386 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -119,6 +119,19 @@ int lbs_update_hw_spec(struct lbs_private *priv)
 	lbs_deb_cmd("GET_HW_SPEC: hardware interface 0x%x, hardware spec 0x%04x\n",
 		    cmd.hwifversion, cmd.version);
 
+	/* Determine mesh_fw_ver from fwrelease and fwcapinfo */
+	/* 5.0.16p0 9.0.0.p0 is known to NOT support any mesh */
+	/* 5.110.22 have mesh command with 0xa3 command id */
+	/* 10.0.0.p0 FW brings in mesh config command with different id */
+	/* Check FW version MSB and initialize mesh_fw_ver */
+	if (MRVL_FW_MAJOR_REV(priv->fwrelease) == MRVL_FW_V5)
+		priv->mesh_fw_ver = MESH_FW_OLD;
+	else if ((MRVL_FW_MAJOR_REV(priv->fwrelease) >= MRVL_FW_V10) &&
+		(priv->fwcapinfo & MESH_CAPINFO_ENABLE_MASK))
+		priv->mesh_fw_ver = MESH_FW_NEW;
+	else
+		priv->mesh_fw_ver = MESH_NONE;
+
 	/* Clamp region code to 8-bit since FW spec indicates that it should
 	 * only ever be 8-bit, even though the field size is 16-bit.  Some firmware
 	 * returns non-zero high 8 bits here.
@@ -1036,17 +1049,26 @@ static int __lbs_mesh_config_send(struct lbs_private *priv,
 				  uint16_t action, uint16_t type)
 {
 	int ret;
+	__le16 command = CMD_MESH_CONFIG_OLD;
 
 	lbs_deb_enter(LBS_DEB_CMD);
 
-	cmd->hdr.command = cpu_to_le16(CMD_MESH_CONFIG);
+	/*
+	 * Command id is 0xac for v10 FW along with mesh interface
+	 * id in bits 14-13-12.
+	 */
+	if (priv->mesh_fw_ver == MESH_FW_NEW)
+		command = CMD_MESH_CONFIG |
+			  (MESH_IFACE_ID << MESH_IFACE_BIT_OFFSET);
+
+	cmd->hdr.command = cpu_to_le16(command);
 	cmd->hdr.size = cpu_to_le16(sizeof(struct cmd_ds_mesh_config));
 	cmd->hdr.result = 0;
 
 	cmd->type = cpu_to_le16(type);
 	cmd->action = cpu_to_le16(action);
 
-	ret = lbs_cmd_with_response(priv, CMD_MESH_CONFIG, cmd);
+	ret = lbs_cmd_with_response(priv, command, cmd);
 
 	lbs_deb_leave(LBS_DEB_CMD);
 	return ret;
diff --git a/drivers/net/wireless/libertas/defs.h b/drivers/net/wireless/libertas/defs.h
index e8dfde3..48da157 100644
--- a/drivers/net/wireless/libertas/defs.h
+++ b/drivers/net/wireless/libertas/defs.h
@@ -227,6 +227,20 @@ static inline void lbs_deb_hex(unsigned int grp, const char *prompt, u8 *buf, in
 #define TxPD_CONTROL_WDS_FRAME (1<<17)
 #define TxPD_MESH_FRAME TxPD_CONTROL_WDS_FRAME
 
+/** Mesh interface ID */
+#define MESH_IFACE_ID					0x0001
+/** Mesh id should be in bits 14-13-12 */
+#define MESH_IFACE_BIT_OFFSET				0x000c
+/** Mesh enable bit in FW capability */
+#define MESH_CAPINFO_ENABLE_MASK			(1<<16)
+
+/** FW definition from Marvell v5 */
+#define MRVL_FW_V5					(0x05)
+/** FW definition from Marvell v10 */
+#define MRVL_FW_V10					(0x0a)
+/** FW major revision definition */
+#define MRVL_FW_MAJOR_REV(x)				((x)>>24)
+
 /** RxPD status */
 
 #define MRVDRV_RXPD_STATUS_OK                0x0001
@@ -380,6 +394,13 @@ enum KEY_INFO_WPA {
 	KEY_INFO_WPA_ENABLED = 0x04
 };
 
+/** mesh_fw_ver */
+enum _mesh_fw_ver {
+	MESH_NONE = 0, /* MESH is not supported */
+	MESH_FW_OLD,   /* MESH is supported in FW V5 */
+	MESH_FW_NEW,   /* MESH is supported in FW V10 and newer */
+};
+
 /* Default values for fwt commands. */
 #define FWT_DEFAULT_METRIC 0
 #define FWT_DEFAULT_DIR 1
diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index dd682c4..5f3f6b2 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -101,6 +101,7 @@ struct lbs_mesh_stats {
 /** Private structure for the MV device */
 struct lbs_private {
 	int mesh_open;
+	int mesh_fw_ver;
 	int infra_open;
 	int mesh_autostart_enabled;
 
diff --git a/drivers/net/wireless/libertas/host.h b/drivers/net/wireless/libertas/host.h
index d4457ef..8ff8ac9 100644
--- a/drivers/net/wireless/libertas/host.h
+++ b/drivers/net/wireless/libertas/host.h
@@ -83,7 +83,8 @@
 #define CMD_FWT_ACCESS				0x0095
 #define CMD_802_11_MONITOR_MODE			0x0098
 #define CMD_MESH_ACCESS				0x009b
-#define CMD_MESH_CONFIG				0x00a3
+#define CMD_MESH_CONFIG_OLD			0x00a3
+#define CMD_MESH_CONFIG				0x00ac
 #define	CMD_SET_BOOT2_VER			0x00a5
 #define CMD_802_11_BEACON_CTRL			0x00b0
 
diff --git a/drivers/net/wireless/libertas/hostcmd.h b/drivers/net/wireless/libertas/hostcmd.h
index a899aeb..391c54a 100644
--- a/drivers/net/wireless/libertas/hostcmd.h
+++ b/drivers/net/wireless/libertas/hostcmd.h
@@ -13,8 +13,19 @@
 
 /* TxPD descriptor */
 struct txpd {
-	/* Current Tx packet status */
-	__le32 tx_status;
+	/* union to cope up with later FW revisions */
+	union {
+		/* Current Tx packet status */
+		__le32 tx_status;
+		struct {
+			/* BSS type: client, AP, etc. */
+			u8 bss_type;
+			/* BSS number */
+			u8 bss_num;
+			/* Reserved */
+			__le16 reserved;
+		} bss;
+	} u;
 	/* Tx control */
 	__le32 tx_control;
 	__le32 tx_packet_location;
@@ -36,8 +47,17 @@ struct txpd {
 
 /* RxPD Descriptor */
 struct rxpd {
-	/* Current Rx packet status */
-	__le16 status;
+	/* union to cope up with later FW revisions */
+	union {
+		/* Current Rx packet status */
+		__le16 status;
+		struct {
+			/* BSS type: client, AP, etc. */
+			u8 bss_type;
+			/* BSS number */
+			u8 bss_num;
+		} bss;
+	} u;
 
 	/* SNR */
 	u8 snr;
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index d93553f..f14d341 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -1316,8 +1316,10 @@ int lbs_start_card(struct lbs_private *priv)
 
 	lbs_update_channel(priv);
 
-	/* 5.0.16p0 is known to NOT support any mesh */
-	if (priv->fwrelease > 0x05001000) {
+	/* Check mesh FW version and appropriately send the mesh start
+	 * command
+	 */
+	if (priv->mesh_fw_ver == MESH_FW_OLD) {
 		/* Enable mesh, if supported, and work out which TLV it uses.
 		   0x100 + 291 is an unofficial value used in 5.110.20.pXX
 		   0x100 + 37 is the official value used in 5.110.21.pXX
@@ -1331,27 +1333,35 @@ int lbs_start_card(struct lbs_private *priv)
 		   It's just that 5.110.20.pXX will not have done anything
 		   useful */
 
-		priv->mesh_tlv = 0x100 + 291;
+		priv->mesh_tlv = TLV_TYPE_OLD_MESH_ID;
 		if (lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START,
 				    priv->curbssparams.channel)) {
-			priv->mesh_tlv = 0x100 + 37;
+			priv->mesh_tlv = TLV_TYPE_MESH_ID;
 			if (lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START,
 					    priv->curbssparams.channel))
 				priv->mesh_tlv = 0;
 		}
-		if (priv->mesh_tlv) {
-			lbs_add_mesh(priv);
-
-			if (device_create_file(&dev->dev, &dev_attr_lbs_mesh))
-				lbs_pr_err("cannot register lbs_mesh attribute\n");
-
-			/* While rtap isn't related to mesh, only mesh-enabled
-			 * firmware implements the rtap functionality via
-			 * CMD_802_11_MONITOR_MODE.
-			 */
-			if (device_create_file(&dev->dev, &dev_attr_lbs_rtap))
-				lbs_pr_err("cannot register lbs_rtap attribute\n");
-		}
+	} else if (priv->mesh_fw_ver == MESH_FW_NEW) {
+		/* 10.0.0.pXX new firmwares should succeed with TLV
+		 * 0x100+37; Do not invoke command with old TLV.
+		 */
+		priv->mesh_tlv = TLV_TYPE_MESH_ID;
+		if (lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START,
+				    priv->curbssparams.channel))
+			priv->mesh_tlv = 0;
+	}
+	if (priv->mesh_tlv) {
+		lbs_add_mesh(priv);
+
+		if (device_create_file(&dev->dev, &dev_attr_lbs_mesh))
+			lbs_pr_err("cannot register lbs_mesh attribute\n");
+
+		/* While rtap isn't related to mesh, only mesh-enabled
+		 * firmware implements the rtap functionality via
+		 * CMD_802_11_MONITOR_MODE.
+		 */
+		if (device_create_file(&dev->dev, &dev_attr_lbs_rtap))
+			lbs_pr_err("cannot register lbs_rtap attribute\n");
 	}
 
 	lbs_debugfs_init_one(priv, dev);
diff --git a/drivers/net/wireless/libertas/rx.c b/drivers/net/wireless/libertas/rx.c
index 079e6aa..5cf1462 100644
--- a/drivers/net/wireless/libertas/rx.c
+++ b/drivers/net/wireless/libertas/rx.c
@@ -160,8 +160,15 @@ int lbs_process_rxed_packet(struct lbs_private *priv, struct sk_buff *skb)
 
 	p_rx_pkt = (struct rxpackethdr *) skb->data;
 	p_rx_pd = &p_rx_pkt->rx_pd;
-	if (priv->mesh_dev && (p_rx_pd->rx_control & RxPD_MESH_FRAME))
-		dev = priv->mesh_dev;
+	if (priv->mesh_dev) {
+		if (priv->mesh_fw_ver == MESH_FW_OLD) {
+			if (p_rx_pd->rx_control & RxPD_MESH_FRAME)
+				dev = priv->mesh_dev;
+		} else if (priv->mesh_fw_ver == MESH_FW_NEW) {
+			if (p_rx_pd->u.bss.bss_num == MESH_IFACE_ID)
+				dev = priv->mesh_dev;
+		}
+	}
 
 	lbs_deb_hex(LBS_DEB_RX, "RX Data: Before chop rxpd", skb->data,
 		 min_t(unsigned int, skb->len, 100));
@@ -173,17 +180,6 @@ int lbs_process_rxed_packet(struct lbs_private *priv, struct sk_buff *skb)
 		goto done;
 	}
 
-	/*
-	 * Check rxpd status and update 802.3 stat,
-	 */
-	if (!(p_rx_pd->status & cpu_to_le16(MRVDRV_RXPD_STATUS_OK))) {
-		lbs_deb_rx("rx err: frame received with bad status\n");
-		lbs_pr_alert("rxpd not ok\n");
-		priv->stats.rx_errors++;
-		ret = 0;
-		goto done;
-	}
-
 	lbs_deb_rx("rx data: skb->len-sizeof(RxPd) = %d-%zd = %zd\n",
 	       skb->len, sizeof(struct rxpd), skb->len - sizeof(struct rxpd));
 
@@ -332,14 +328,6 @@ static int process_rxed_802_11_packet(struct lbs_private *priv,
 		goto done;
 	}
 
-	/*
-	 * Check rxpd status and update 802.3 stat,
-	 */
-	if (!(prxpd->status & cpu_to_le16(MRVDRV_RXPD_STATUS_OK))) {
-		//lbs_deb_rx("rx err: frame received with bad status\n");
-		priv->stats.rx_errors++;
-	}
-
 	lbs_deb_rx("rx data: skb->len-sizeof(RxPd) = %d-%zd = %zd\n",
 	       skb->len, sizeof(struct rxpd), skb->len - sizeof(struct rxpd));
 
@@ -361,8 +349,6 @@ static int process_rxed_802_11_packet(struct lbs_private *priv,
 	/* XXX must check no carryout */
 	radiotap_hdr.antsignal = prxpd->snr + prxpd->nf;
 	radiotap_hdr.rx_flags = 0;
-	if (!(prxpd->status & cpu_to_le16(MRVDRV_RXPD_STATUS_OK)))
-		radiotap_hdr.rx_flags |= IEEE80211_RADIOTAP_F_RX_BADFCS;
 	//memset(radiotap_hdr.pad, 0x11, IEEE80211_RADIOTAP_HDRLEN - 18);
 
 	/* chop the rxpd */
diff --git a/drivers/net/wireless/libertas/tx.c b/drivers/net/wireless/libertas/tx.c
index 68bec31..6be3b27 100644
--- a/drivers/net/wireless/libertas/tx.c
+++ b/drivers/net/wireless/libertas/tx.c
@@ -132,8 +132,12 @@ int lbs_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	txpd->tx_packet_length = cpu_to_le16(pkt_len);
 	txpd->tx_packet_location = cpu_to_le32(sizeof(struct txpd));
 
-	if (dev == priv->mesh_dev)
-		txpd->tx_control |= cpu_to_le32(TxPD_MESH_FRAME);
+	if (dev == priv->mesh_dev) {
+		if (priv->mesh_fw_ver == MESH_FW_OLD)
+			txpd->tx_control |= cpu_to_le32(TxPD_MESH_FRAME);
+		else if (priv->mesh_fw_ver == MESH_FW_NEW)
+			txpd->u.bss.bss_num = MESH_IFACE_ID;
+	}
 
 	lbs_deb_hex(LBS_DEB_TX, "txpd", (u8 *) &txpd, sizeof(struct txpd));
 
diff --git a/drivers/net/wireless/libertas/types.h b/drivers/net/wireless/libertas/types.h
index fb7a2d1..de03b9c 100644
--- a/drivers/net/wireless/libertas/types.h
+++ b/drivers/net/wireless/libertas/types.h
@@ -94,6 +94,8 @@ struct ieeetypes_assocrsp {
 #define TLV_TYPE_TSFTIMESTAMP	    (PROPRIETARY_TLV_BASE_ID + 19)
 #define TLV_TYPE_RSSI_HIGH          (PROPRIETARY_TLV_BASE_ID + 22)
 #define TLV_TYPE_SNR_HIGH           (PROPRIETARY_TLV_BASE_ID + 23)
+#define TLV_TYPE_MESH_ID            (PROPRIETARY_TLV_BASE_ID + 37)
+#define TLV_TYPE_OLD_MESH_ID        (PROPRIETARY_TLV_BASE_ID + 291)
 
 /** TLV related data structures*/
 struct mrvlietypesheader {

