Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:7526 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836AbXGCPWb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2007 11:22:31 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
Date: Tue, 3 Jul 2007 17:22:23 +0200
Subject: [PATCH] libertas: remove adapter->linkmode
To: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200707031722.23498.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

linkmode was never assigned, so because of kzalloc() it was 0,
which is WLAN_LINKMODE_802_3. There was nowhere any code that
would have changed it. So I got rid and also killed all code
that referenced WLAN_LINKMODE_802_11.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
---
 drivers/net/wireless/libertas/dev.h  |    1 -
 drivers/net/wireless/libertas/rx.c   |  166 ----------------------------------
 drivers/net/wireless/libertas/tx.c   |    7 +-
 drivers/net/wireless/libertas/wext.h |    2 -
 4 files changed, 2 insertions(+), 174 deletions(-)

diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index 1dcfb05..ba31140 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -379,7 +379,6 @@ struct _wlan_adapter {
 	u32 pkttxctrl;
 
 	u16 txrate;
-	u32 linkmode;
 	u32 radiomode;
 	u8 fw_ready;
 
diff --git a/drivers/net/wireless/libertas/rx.c b/drivers/net/wireless/libertas/rx.c
index 6041b9f..bce4ccd 100644
--- a/drivers/net/wireless/libertas/rx.c
+++ b/drivers/net/wireless/libertas/rx.c
@@ -35,7 +35,6 @@ struct rx80211packethdr {
 	void *eth80211_hdr;
 } __attribute__ ((packed));
 
-static int process_rxed_802_11_packet(wlan_private * priv, struct sk_buff *skb);
 
 /**
  *  @brief This function computes the avgSNR .
@@ -172,9 +171,6 @@ int libertas_process_rxed_packet(wlan_private * priv, struct sk_buff *skb)
 
 	lbs_deb_enter(LBS_DEB_RX);
 
-	if (priv->adapter->linkmode == WLAN_LINKMODE_802_11)
-		return process_rxed_802_11_packet(priv, skb);
-
 	p_rx_pkt = (struct rxpackethdr *) skb->data;
 	p_rx_pd = &p_rx_pkt->rx_pd;
 	if (p_rx_pd->rx_control & RxPD_MESH_FRAME)
@@ -273,165 +269,3 @@ done:
 	return ret;
 }
 EXPORT_SYMBOL_GPL(libertas_process_rxed_packet);
-
-/**
- *  @brief This function converts Tx/Rx rates from the Marvell WLAN format
- *  (see Table 2 in Section 3.1) to IEEE80211_RADIOTAP_RATE units (500 Kb/s)
- *
- *  @param rate    Input rate
- *  @return 	   Output Rate (0 if invalid)
- */
-static u8 convert_mv_rate_to_radiotap(u8 rate)
-{
-	switch (rate) {
-	case 0:		/*   1 Mbps */
-		return 2;
-	case 1:		/*   2 Mbps */
-		return 4;
-	case 2:		/* 5.5 Mbps */
-		return 11;
-	case 3:		/*  11 Mbps */
-		return 22;
-	case 4:		/*   6 Mbps */
-		return 12;
-	case 5:		/*   9 Mbps */
-		return 18;
-	case 6:		/*  12 Mbps */
-		return 24;
-	case 7:		/*  18 Mbps */
-		return 36;
-	case 8:		/*  24 Mbps */
-		return 48;
-	case 9:		/*  36 Mbps */
-		return 72;
-	case 10:		/*  48 Mbps */
-		return 96;
-	case 11:		/*  54 Mbps */
-		return 108;
-	}
-	lbs_pr_alert("Invalid Marvell WLAN rate %i\n", rate);
-	return 0;
-}
-
-/**
- *  @brief This function processes a received 802.11 packet and forwards it
- *  to kernel/upper layer
- *
- *  @param priv    A pointer to wlan_private
- *  @param skb     A pointer to skb which includes the received packet
- *  @return 	   0 or -1
- */
-static int process_rxed_802_11_packet(wlan_private * priv, struct sk_buff *skb)
-{
-	wlan_adapter *adapter = priv->adapter;
-	int ret = 0;
-
-	struct rx80211packethdr *p_rx_pkt;
-	struct rxpd *prxpd;
-	struct rx_radiotap_hdr radiotap_hdr;
-	struct rx_radiotap_hdr *pradiotap_hdr;
-
-	lbs_deb_enter(LBS_DEB_RX);
-
-	p_rx_pkt = (struct rx80211packethdr *) skb->data;
-	prxpd = &p_rx_pkt->rx_pd;
-
-	// lbs_deb_hex(LBS_DEB_RX, "RX Data: Before chop rxpd", skb->data, min(skb->len, 100));
-
-	if (skb->len < (ETH_HLEN + 8 + sizeof(struct rxpd))) {
-		lbs_deb_rx("rx err: frame received wit bad length\n");
-		priv->stats.rx_length_errors++;
-		ret = 0;
-		goto done;
-	}
-
-	/*
-	 * Check rxpd status and update 802.3 stat,
-	 */
-	if (!(prxpd->status & cpu_to_le16(MRVDRV_RXPD_STATUS_OK))) {
-		//lbs_deb_rx("rx err: frame received with bad status\n");
-		priv->stats.rx_errors++;
-	}
-
-	lbs_deb_rx("rx data: skb->len-sizeof(RxPd) = %d-%zd = %zd\n",
-	       skb->len, sizeof(struct rxpd), skb->len - sizeof(struct rxpd));
-
-	/* create the exported radio header */
-	switch (priv->adapter->radiomode) {
-	case WLAN_RADIOMODE_NONE:
-		/* no radio header */
-		/* chop the rxpd */
-		skb_pull(skb, sizeof(struct rxpd));
-		break;
-
-	case WLAN_RADIOMODE_RADIOTAP:
-		/* radiotap header */
-		radiotap_hdr.hdr.it_version = 0;
-		/* XXX must check this value for pad */
-		radiotap_hdr.hdr.it_pad = 0;
-		radiotap_hdr.hdr.it_len = sizeof(struct rx_radiotap_hdr);
-		radiotap_hdr.hdr.it_present = RX_RADIOTAP_PRESENT;
-		/* unknown values */
-		radiotap_hdr.flags = 0;
-		radiotap_hdr.chan_freq = 0;
-		radiotap_hdr.chan_flags = 0;
-		radiotap_hdr.antenna = 0;
-		/* known values */
-		radiotap_hdr.rate = convert_mv_rate_to_radiotap(prxpd->rx_rate);
-		/* XXX must check no carryout */
-		radiotap_hdr.antsignal = prxpd->snr + prxpd->nf;
-		radiotap_hdr.rx_flags = 0;
-		if (!(prxpd->status & cpu_to_le16(MRVDRV_RXPD_STATUS_OK)))
-			radiotap_hdr.rx_flags |= IEEE80211_RADIOTAP_F_RX_BADFCS;
-		//memset(radiotap_hdr.pad, 0x11, IEEE80211_RADIOTAP_HDRLEN - 18);
-
-		/* chop the rxpd */
-		skb_pull(skb, sizeof(struct rxpd));
-
-		/* add space for the new radio header */
-		if ((skb_headroom(skb) < sizeof(struct rx_radiotap_hdr)) &&
-		    pskb_expand_head(skb, sizeof(struct rx_radiotap_hdr), 0,
-				     GFP_ATOMIC)) {
-			lbs_pr_alert("%s: couldn't pskb_expand_head\n",
-			       __func__);
-		}
-
-		pradiotap_hdr =
-		    (struct rx_radiotap_hdr *)skb_push(skb,
-						     sizeof(struct
-							    rx_radiotap_hdr));
-		memcpy(pradiotap_hdr, &radiotap_hdr,
-		       sizeof(struct rx_radiotap_hdr));
-		break;
-
-	default:
-		/* unknown header */
-		lbs_pr_alert("Unknown radiomode %i\n",
-		       priv->adapter->radiomode);
-		/* don't export any header */
-		/* chop the rxpd */
-		skb_pull(skb, sizeof(struct rxpd));
-		break;
-	}
-
-	/* Take the data rate from the rxpd structure
-	 * only if the rate is auto
-	 */
-	if (adapter->auto_rate)
-		adapter->cur_rate = libertas_fw_index_to_data_rate(prxpd->rx_rate);
-
-	wlan_compute_rssi(priv, prxpd);
-
-	lbs_deb_rx("rx data: size of actual packet %d\n", skb->len);
-	priv->stats.rx_bytes += skb->len;
-	priv->stats.rx_packets++;
-
-	libertas_upload_rx_packet(priv, skb);
-
-	ret = 0;
-
-done:
-	skb->protocol = __constant_htons(0x0019);	/* ETH_P_80211_RAW */
-	lbs_deb_leave_args(LBS_DEB_RX, "ret %d", ret);
-	return ret;
-}
diff --git a/drivers/net/wireless/libertas/tx.c b/drivers/net/wireless/libertas/tx.c
index 56d8402..a8787b0 100644
--- a/drivers/net/wireless/libertas/tx.c
+++ b/drivers/net/wireless/libertas/tx.c
@@ -110,11 +110,8 @@ static int SendSinglePacket(wlan_private * priv, struct sk_buff *skb)
 				    - sizeof(struct tx_radiotap_hdr));
 
 	}
-	/* copy destination address from 802.3 or 802.11 header */
-	if (priv->adapter->linkmode == WLAN_LINKMODE_802_11)
-		memcpy(plocaltxpd->tx_dest_addr_high, p802x_hdr + 4, ETH_ALEN);
-	else
-		memcpy(plocaltxpd->tx_dest_addr_high, p802x_hdr, ETH_ALEN);
+	/* copy destination address from 802.3 header */
+	memcpy(plocaltxpd->tx_dest_addr_high, p802x_hdr, ETH_ALEN);
 
 	lbs_deb_hex(LBS_DEB_TX, "txpd", (u8 *) plocaltxpd, sizeof(struct txpd));
 
diff --git a/drivers/net/wireless/libertas/wext.h b/drivers/net/wireless/libertas/wext.h
index 5b0bbc9..16ecc89 100644
--- a/drivers/net/wireless/libertas/wext.h
+++ b/drivers/net/wireless/libertas/wext.h
@@ -15,8 +15,6 @@ struct wlan_ioctl_regrdwr {
 	u32 value;
 };
 
-#define WLAN_LINKMODE_802_3			0
-#define WLAN_LINKMODE_802_11			2
 #define WLAN_RADIOMODE_NONE			0
 #define WLAN_RADIOMODE_RADIOTAP			2
 
-- 
1.5.2.1

