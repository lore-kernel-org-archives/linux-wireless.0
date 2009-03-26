Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:46636 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbZCZUIV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 16:08:21 -0400
Subject: Re: [PATCH 2.6.29-rc8-wl] libertas: support mesh for various
	firmware versions
From: Dan Williams <dcbw@redhat.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
In-Reply-To: <alpine.LFD.0.9999.0903250936340.24397@localhost.localdomain>
References: <alpine.LFD.0.9999.0903250936340.24397@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 26 Mar 2009 16:06:01 -0400
Message-Id: <1238097961.3254.0.camel@localhost.localdomain> (sfid-20090326_210825_831636_A1DB7D14)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-03-25 at 09:51 -0700, Bing Zhao wrote:
> rebased to fix the conflict with 6ec54de.
> 
> 
> From 915a19e7208524bda46872d70d6b346e06843c9f Mon Sep 17 00:00:00 2001
> From: Bing Zhao <bzhao@marvell.com>
> Date: Mon, 16 Mar 2009 14:52:36 -0700
> Subject: [PATCH] libertas: support mesh for various firmware versions
> 
> CMD_MESH_CONFIG command ID and a couple of structure members in TxPD,
> RxPD have been changed in firmware version 10.x.y.z and newer.
> 
> Signed-off-by: Kiran Divekar <dkiran@marvell.com>
> Signed-off-by: Bing Zhao <bzhao@marvell.com>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
>  drivers/net/wireless/libertas/cmd.c     |   26 +++++++++++++++++-
>  drivers/net/wireless/libertas/defs.h    |   21 ++++++++++++++
>  drivers/net/wireless/libertas/dev.h     |    1 +
>  drivers/net/wireless/libertas/host.h    |    3 +-
>  drivers/net/wireless/libertas/hostcmd.h |   28 +++++++++++++++++---
>  drivers/net/wireless/libertas/main.c    |   44 +++++++++++++++++++------------
>  drivers/net/wireless/libertas/rx.c      |   32 ++++++----------------
>  drivers/net/wireless/libertas/tx.c      |    8 ++++-
>  drivers/net/wireless/libertas/types.h   |    2 +
>  9 files changed, 116 insertions(+), 49 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
> index 639dd02..17d6f9c 100644
> --- a/drivers/net/wireless/libertas/cmd.c
> +++ b/drivers/net/wireless/libertas/cmd.c
> @@ -119,6 +119,19 @@ int lbs_update_hw_spec(struct lbs_private *priv)
>  	lbs_deb_cmd("GET_HW_SPEC: hardware interface 0x%x, hardware spec 0x%04x\n",
>  		    cmd.hwifversion, cmd.version);
>  
> +	/* Determine mesh_fw_ver from fwrelease and fwcapinfo */
> +	/* 5.0.16p0 9.0.0.p0 is known to NOT support any mesh */
> +	/* 5.110.22 have mesh command with 0xa3 command id */
> +	/* 10.0.0.p0 FW brings in mesh config command with different id */
> +	/* Check FW version MSB and initialize mesh_fw_ver */
> +	if (MRVL_FW_MAJOR_REV(priv->fwrelease) == MRVL_FW_V5)
> +		priv->mesh_fw_ver = MESH_FW_OLD;
> +	else if ((MRVL_FW_MAJOR_REV(priv->fwrelease) >= MRVL_FW_V10) &&
> +		(priv->fwcapinfo & MESH_CAPINFO_ENABLE_MASK))
> +		priv->mesh_fw_ver = MESH_FW_NEW;
> +	else
> +		priv->mesh_fw_ver = MESH_NONE;
> +
>  	/* Clamp region code to 8-bit since FW spec indicates that it should
>  	 * only ever be 8-bit, even though the field size is 16-bit.  Some firmware
>  	 * returns non-zero high 8 bits here.
> @@ -1036,17 +1049,26 @@ static int __lbs_mesh_config_send(struct lbs_private *priv,
>  				  uint16_t action, uint16_t type)
>  {
>  	int ret;
> +	u16 command = CMD_MESH_CONFIG_OLD;
>  
>  	lbs_deb_enter(LBS_DEB_CMD);
>  
> -	cmd->hdr.command = cpu_to_le16(CMD_MESH_CONFIG);
> +	/*
> +	 * Command id is 0xac for v10 FW along with mesh interface
> +	 * id in bits 14-13-12.
> +	 */
> +	if (priv->mesh_fw_ver == MESH_FW_NEW)
> +		command = CMD_MESH_CONFIG |
> +			  (MESH_IFACE_ID << MESH_IFACE_BIT_OFFSET);
> +
> +	cmd->hdr.command = cpu_to_le16(command);
>  	cmd->hdr.size = cpu_to_le16(sizeof(struct cmd_ds_mesh_config));
>  	cmd->hdr.result = 0;
>  
>  	cmd->type = cpu_to_le16(type);
>  	cmd->action = cpu_to_le16(action);
>  
> -	ret = lbs_cmd_with_response(priv, CMD_MESH_CONFIG, cmd);
> +	ret = lbs_cmd_with_response(priv, command, cmd);
>  
>  	lbs_deb_leave(LBS_DEB_CMD);
>  	return ret;
> diff --git a/drivers/net/wireless/libertas/defs.h b/drivers/net/wireless/libertas/defs.h
> index e8dfde3..48da157 100644
> --- a/drivers/net/wireless/libertas/defs.h
> +++ b/drivers/net/wireless/libertas/defs.h
> @@ -227,6 +227,20 @@ static inline void lbs_deb_hex(unsigned int grp, const char *prompt, u8 *buf, in
>  #define TxPD_CONTROL_WDS_FRAME (1<<17)
>  #define TxPD_MESH_FRAME TxPD_CONTROL_WDS_FRAME
>  
> +/** Mesh interface ID */
> +#define MESH_IFACE_ID					0x0001
> +/** Mesh id should be in bits 14-13-12 */
> +#define MESH_IFACE_BIT_OFFSET				0x000c
> +/** Mesh enable bit in FW capability */
> +#define MESH_CAPINFO_ENABLE_MASK			(1<<16)
> +
> +/** FW definition from Marvell v5 */
> +#define MRVL_FW_V5					(0x05)
> +/** FW definition from Marvell v10 */
> +#define MRVL_FW_V10					(0x0a)
> +/** FW major revision definition */
> +#define MRVL_FW_MAJOR_REV(x)				((x)>>24)
> +
>  /** RxPD status */
>  
>  #define MRVDRV_RXPD_STATUS_OK                0x0001
> @@ -380,6 +394,13 @@ enum KEY_INFO_WPA {
>  	KEY_INFO_WPA_ENABLED = 0x04
>  };
>  
> +/** mesh_fw_ver */
> +enum _mesh_fw_ver {
> +	MESH_NONE = 0, /* MESH is not supported */
> +	MESH_FW_OLD,   /* MESH is supported in FW V5 */
> +	MESH_FW_NEW,   /* MESH is supported in FW V10 and newer */
> +};
> +
>  /* Default values for fwt commands. */
>  #define FWT_DEFAULT_METRIC 0
>  #define FWT_DEFAULT_DIR 1
> diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
> index dd682c4..5f3f6b2 100644
> --- a/drivers/net/wireless/libertas/dev.h
> +++ b/drivers/net/wireless/libertas/dev.h
> @@ -101,6 +101,7 @@ struct lbs_mesh_stats {
>  /** Private structure for the MV device */
>  struct lbs_private {
>  	int mesh_open;
> +	int mesh_fw_ver;
>  	int infra_open;
>  	int mesh_autostart_enabled;
>  
> diff --git a/drivers/net/wireless/libertas/host.h b/drivers/net/wireless/libertas/host.h
> index d4457ef..8ff8ac9 100644
> --- a/drivers/net/wireless/libertas/host.h
> +++ b/drivers/net/wireless/libertas/host.h
> @@ -83,7 +83,8 @@
>  #define CMD_FWT_ACCESS				0x0095
>  #define CMD_802_11_MONITOR_MODE			0x0098
>  #define CMD_MESH_ACCESS				0x009b
> -#define CMD_MESH_CONFIG				0x00a3
> +#define CMD_MESH_CONFIG_OLD			0x00a3
> +#define CMD_MESH_CONFIG				0x00ac
>  #define	CMD_SET_BOOT2_VER			0x00a5
>  #define CMD_802_11_BEACON_CTRL			0x00b0
>  
> diff --git a/drivers/net/wireless/libertas/hostcmd.h b/drivers/net/wireless/libertas/hostcmd.h
> index a899aeb..391c54a 100644
> --- a/drivers/net/wireless/libertas/hostcmd.h
> +++ b/drivers/net/wireless/libertas/hostcmd.h
> @@ -13,8 +13,19 @@
>  
>  /* TxPD descriptor */
>  struct txpd {
> -	/* Current Tx packet status */
> -	__le32 tx_status;
> +	/* union to cope up with later FW revisions */
> +	union {
> +		/* Current Tx packet status */
> +		__le32 tx_status;
> +		struct {
> +			/* BSS type: client, AP, etc. */
> +			u8 bss_type;
> +			/* BSS number */
> +			u8 bss_num;
> +			/* Reserved */
> +			__le16 reserved;
> +		} bss;
> +	} u;
>  	/* Tx control */
>  	__le32 tx_control;
>  	__le32 tx_packet_location;
> @@ -36,8 +47,17 @@ struct txpd {
>  
>  /* RxPD Descriptor */
>  struct rxpd {
> -	/* Current Rx packet status */
> -	__le16 status;
> +	/* union to cope up with later FW revisions */
> +	union {
> +		/* Current Rx packet status */
> +		__le16 status;
> +		struct {
> +			/* BSS type: client, AP, etc. */
> +			u8 bss_type;
> +			/* BSS number */
> +			u8 bss_num;
> +		} bss;
> +	} u;
>  
>  	/* SNR */
>  	u8 snr;
> diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
> index d93553f..f14d341 100644
> --- a/drivers/net/wireless/libertas/main.c
> +++ b/drivers/net/wireless/libertas/main.c
> @@ -1316,8 +1316,10 @@ int lbs_start_card(struct lbs_private *priv)
>  
>  	lbs_update_channel(priv);
>  
> -	/* 5.0.16p0 is known to NOT support any mesh */
> -	if (priv->fwrelease > 0x05001000) {
> +	/* Check mesh FW version and appropriately send the mesh start
> +	 * command
> +	 */
> +	if (priv->mesh_fw_ver == MESH_FW_OLD) {
>  		/* Enable mesh, if supported, and work out which TLV it uses.
>  		   0x100 + 291 is an unofficial value used in 5.110.20.pXX
>  		   0x100 + 37 is the official value used in 5.110.21.pXX
> @@ -1331,27 +1333,35 @@ int lbs_start_card(struct lbs_private *priv)
>  		   It's just that 5.110.20.pXX will not have done anything
>  		   useful */
>  
> -		priv->mesh_tlv = 0x100 + 291;
> +		priv->mesh_tlv = TLV_TYPE_OLD_MESH_ID;
>  		if (lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START,
>  				    priv->curbssparams.channel)) {
> -			priv->mesh_tlv = 0x100 + 37;
> +			priv->mesh_tlv = TLV_TYPE_MESH_ID;
>  			if (lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START,
>  					    priv->curbssparams.channel))
>  				priv->mesh_tlv = 0;
>  		}
> -		if (priv->mesh_tlv) {
> -			lbs_add_mesh(priv);
> -
> -			if (device_create_file(&dev->dev, &dev_attr_lbs_mesh))
> -				lbs_pr_err("cannot register lbs_mesh attribute\n");
> -
> -			/* While rtap isn't related to mesh, only mesh-enabled
> -			 * firmware implements the rtap functionality via
> -			 * CMD_802_11_MONITOR_MODE.
> -			 */
> -			if (device_create_file(&dev->dev, &dev_attr_lbs_rtap))
> -				lbs_pr_err("cannot register lbs_rtap attribute\n");
> -		}
> +	} else if (priv->mesh_fw_ver == MESH_FW_NEW) {
> +		/* 10.0.0.pXX new firmwares should succeed with TLV
> +		 * 0x100+37; Do not invoke command with old TLV.
> +		 */
> +		priv->mesh_tlv = TLV_TYPE_MESH_ID;
> +		if (lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START,
> +				    priv->curbssparams.channel))
> +			priv->mesh_tlv = 0;
> +	}
> +	if (priv->mesh_tlv) {
> +		lbs_add_mesh(priv);
> +
> +		if (device_create_file(&dev->dev, &dev_attr_lbs_mesh))
> +			lbs_pr_err("cannot register lbs_mesh attribute\n");
> +
> +		/* While rtap isn't related to mesh, only mesh-enabled
> +		 * firmware implements the rtap functionality via
> +		 * CMD_802_11_MONITOR_MODE.
> +		 */
> +		if (device_create_file(&dev->dev, &dev_attr_lbs_rtap))
> +			lbs_pr_err("cannot register lbs_rtap attribute\n");
>  	}
>  
>  	lbs_debugfs_init_one(priv, dev);
> diff --git a/drivers/net/wireless/libertas/rx.c b/drivers/net/wireless/libertas/rx.c
> index e661e10..2ca2f7b 100644
> --- a/drivers/net/wireless/libertas/rx.c
> +++ b/drivers/net/wireless/libertas/rx.c
> @@ -160,8 +160,15 @@ int lbs_process_rxed_packet(struct lbs_private *priv, struct sk_buff *skb)
>  
>  	p_rx_pkt = (struct rxpackethdr *) skb->data;
>  	p_rx_pd = &p_rx_pkt->rx_pd;
> -	if (priv->mesh_dev && (p_rx_pd->rx_control & RxPD_MESH_FRAME))
> -		dev = priv->mesh_dev;
> +	if (priv->mesh_dev) {
> +		if (priv->mesh_fw_ver == MESH_FW_OLD) {
> +			if (p_rx_pd->rx_control & RxPD_MESH_FRAME)
> +				dev = priv->mesh_dev;
> +		} else if (priv->mesh_fw_ver == MESH_FW_NEW) {
> +			if (p_rx_pd->u.bss.bss_num == MESH_IFACE_ID)
> +				dev = priv->mesh_dev;
> +		}
> +	}
>  
>  	lbs_deb_hex(LBS_DEB_RX, "RX Data: Before chop rxpd", skb->data,
>  		 min_t(unsigned int, skb->len, 100));
> @@ -173,17 +180,6 @@ int lbs_process_rxed_packet(struct lbs_private *priv, struct sk_buff *skb)
>  		goto done;
>  	}
>  
> -	/*
> -	 * Check rxpd status and update 802.3 stat,
> -	 */
> -	if (!(p_rx_pd->status & cpu_to_le16(MRVDRV_RXPD_STATUS_OK))) {
> -		lbs_deb_rx("rx err: frame received with bad status\n");
> -		lbs_pr_alert("rxpd not ok\n");
> -		priv->stats.rx_errors++;
> -		ret = 0;
> -		goto done;
> -	}
> -
>  	lbs_deb_rx("rx data: skb->len-sizeof(RxPd) = %d-%zd = %zd\n",
>  	       skb->len, sizeof(struct rxpd), skb->len - sizeof(struct rxpd));
>  
> @@ -332,14 +328,6 @@ static int process_rxed_802_11_packet(struct lbs_private *priv,
>  		goto done;
>  	}
>  
> -	/*
> -	 * Check rxpd status and update 802.3 stat,
> -	 */
> -	if (!(prxpd->status & cpu_to_le16(MRVDRV_RXPD_STATUS_OK))) {
> -		//lbs_deb_rx("rx err: frame received with bad status\n");
> -		priv->stats.rx_errors++;
> -	}
> -
>  	lbs_deb_rx("rx data: skb->len-sizeof(RxPd) = %d-%zd = %zd\n",
>  	       skb->len, sizeof(struct rxpd), skb->len - sizeof(struct rxpd));
>  
> @@ -351,8 +339,6 @@ static int process_rxed_802_11_packet(struct lbs_private *priv,
>  	radiotap_hdr.hdr.it_pad = 0;
>  	radiotap_hdr.hdr.it_len = cpu_to_le16 (sizeof(struct rx_radiotap_hdr));
>  	radiotap_hdr.hdr.it_present = cpu_to_le32 (RX_RADIOTAP_PRESENT);
> -	if (!(prxpd->status & cpu_to_le16(MRVDRV_RXPD_STATUS_OK)))
> -		radiotap_hdr.flags |= IEEE80211_RADIOTAP_F_BADFCS;
>  	radiotap_hdr.rate = convert_mv_rate_to_radiotap(prxpd->rx_rate);
>  	/* XXX must check no carryout */
>  	radiotap_hdr.antsignal = prxpd->snr + prxpd->nf;
> diff --git a/drivers/net/wireless/libertas/tx.c b/drivers/net/wireless/libertas/tx.c
> index 68bec31..6be3b27 100644
> --- a/drivers/net/wireless/libertas/tx.c
> +++ b/drivers/net/wireless/libertas/tx.c
> @@ -132,8 +132,12 @@ int lbs_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
>  	txpd->tx_packet_length = cpu_to_le16(pkt_len);
>  	txpd->tx_packet_location = cpu_to_le32(sizeof(struct txpd));
>  
> -	if (dev == priv->mesh_dev)
> -		txpd->tx_control |= cpu_to_le32(TxPD_MESH_FRAME);
> +	if (dev == priv->mesh_dev) {
> +		if (priv->mesh_fw_ver == MESH_FW_OLD)
> +			txpd->tx_control |= cpu_to_le32(TxPD_MESH_FRAME);
> +		else if (priv->mesh_fw_ver == MESH_FW_NEW)
> +			txpd->u.bss.bss_num = MESH_IFACE_ID;
> +	}
>  
>  	lbs_deb_hex(LBS_DEB_TX, "txpd", (u8 *) &txpd, sizeof(struct txpd));
>  
> diff --git a/drivers/net/wireless/libertas/types.h b/drivers/net/wireless/libertas/types.h
> index fb7a2d1..de03b9c 100644
> --- a/drivers/net/wireless/libertas/types.h
> +++ b/drivers/net/wireless/libertas/types.h
> @@ -94,6 +94,8 @@ struct ieeetypes_assocrsp {
>  #define TLV_TYPE_TSFTIMESTAMP	    (PROPRIETARY_TLV_BASE_ID + 19)
>  #define TLV_TYPE_RSSI_HIGH          (PROPRIETARY_TLV_BASE_ID + 22)
>  #define TLV_TYPE_SNR_HIGH           (PROPRIETARY_TLV_BASE_ID + 23)
> +#define TLV_TYPE_MESH_ID            (PROPRIETARY_TLV_BASE_ID + 37)
> +#define TLV_TYPE_OLD_MESH_ID        (PROPRIETARY_TLV_BASE_ID + 291)
>  
>  /** TLV related data structures*/
>  struct mrvlietypesheader {

