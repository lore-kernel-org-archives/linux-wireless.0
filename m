Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64914 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab2AKXHh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jan 2012 18:07:37 -0500
Received: by mail-iy0-f174.google.com with SMTP id z25so1744774iab.19
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jan 2012 15:07:37 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 3/5] rtl8192cu: Convert driver to use the new macros file
Date: Wed, 11 Jan 2012 17:07:10 -0600
Message-Id: <1326323232-21752-4-git-send-email-Larry.Finger@lwfinger.net> (sfid-20120112_000741_155405_7D7B98B7)
In-Reply-To: <1326323232-21752-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1326323232-21752-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch switches rtl8192cu to use the new macros file.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.c |    6 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c |  193 ++++++++--------
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.h |  310 +-------------------------
 3 files changed, 102 insertions(+), 407 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
index d028f6f..3dcdfd2 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
@@ -873,9 +873,9 @@ static void _rtl92c_query_rxphystatus(struct ieee80211_hw *hw,
 		pstats->rx_pwdb_all = pwdb_all;
 		pstats->rxpower = rx_pwr_all;
 		pstats->recvsignalpower = rx_pwr_all;
-		if (GET_RX_DESC_RX_MCS(pdesc) &&
-		    GET_RX_DESC_RX_MCS(pdesc) >= DESC92_RATEMCS8 &&
-		    GET_RX_DESC_RX_MCS(pdesc) <= DESC92_RATEMCS15)
+		if (GET_RX_DESC_RX_MCS_CU(pdesc) &&
+		    GET_RX_DESC_RX_MCS_CU(pdesc) >= DESC92_RATEMCS8 &&
+		    GET_RX_DESC_RX_MCS_CU(pdesc) <= DESC92_RATEMCS15)
 			max_spatial_stream = 2;
 		else
 			max_spatial_stream = 1;
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
index bde3589..5a8cfd6 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
@@ -307,40 +307,40 @@ bool rtl92cu_rx_query_desc(struct ieee80211_hw *hw,
 {
 	struct rx_fwinfo_92c *p_drvinfo;
 	struct rx_desc_92c *pdesc = (struct rx_desc_92c *)p_desc;
-	u32 phystatus = GET_RX_DESC_PHY_STATUS(pdesc);
+	u32 phystatus = GET_RX_DESC_PHY_STATUS_CU(pdesc);
 
-	stats->length = (u16) GET_RX_DESC_PKT_LEN(pdesc);
-	stats->rx_drvinfo_size = (u8)GET_RX_DESC_DRVINFO_SIZE(pdesc) *
+	stats->length = (u16) GET_RX_DESC_PKT_LEN_CU(pdesc);
+	stats->rx_drvinfo_size = (u8)GET_RX_DESC_DRVINFO_SIZE_CU(pdesc) *
 				 RX_DRV_INFO_SIZE_UNIT;
-	stats->rx_bufshift = (u8) (GET_RX_DESC_SHIFT(pdesc) & 0x03);
-	stats->icv = (u16) GET_RX_DESC_ICV(pdesc);
-	stats->crc = (u16) GET_RX_DESC_CRC32(pdesc);
+	stats->rx_bufshift = (u8) (GET_RX_DESC_SHIFT_CU(pdesc) & 0x03);
+	stats->icv = (u16) GET_RX_DESC_ICV_CU(pdesc);
+	stats->crc = (u16) GET_RX_DESC_CRC32_CU(pdesc);
 	stats->hwerror = (stats->crc | stats->icv);
-	stats->decrypted = !GET_RX_DESC_SWDEC(pdesc);
-	stats->rate = (u8) GET_RX_DESC_RX_MCS(pdesc);
-	stats->shortpreamble = (u16) GET_RX_DESC_SPLCP(pdesc);
-	stats->isampdu = (bool) (GET_RX_DESC_PAGGR(pdesc) == 1);
-	stats->isampdu = (bool) ((GET_RX_DESC_PAGGR(pdesc) == 1)
-				   && (GET_RX_DESC_FAGGR(pdesc) == 1));
-	stats->timestamp_low = GET_RX_DESC_TSFL(pdesc);
-	stats->rx_is40Mhzpacket = (bool) GET_RX_DESC_BW(pdesc);
+	stats->decrypted = !GET_RX_DESC_SWDEC_CU(pdesc);
+	stats->rate = (u8) GET_RX_DESC_RX_MCS_CU(pdesc);
+	stats->shortpreamble = (u16) GET_RX_DESC_SPLCP_CU(pdesc);
+	stats->isampdu = (bool) (GET_RX_DESC_PAGGR_CU(pdesc) == 1);
+	stats->isampdu = (bool) ((GET_RX_DESC_PAGGR_CU(pdesc) == 1)
+				   && (GET_RX_DESC_FAGGR_CU(pdesc) == 1));
+	stats->timestamp_low = GET_RX_DESC_TSFL_CU(pdesc);
+	stats->rx_is40Mhzpacket = (bool) GET_RX_DESC_BW_CU(pdesc);
 	rx_status->freq = hw->conf.channel->center_freq;
 	rx_status->band = hw->conf.channel->band;
-	if (GET_RX_DESC_CRC32(pdesc))
+	if (GET_RX_DESC_CRC32_CU(pdesc))
 		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
-	if (!GET_RX_DESC_SWDEC(pdesc))
+	if (!GET_RX_DESC_SWDEC_CU(pdesc))
 		rx_status->flag |= RX_FLAG_DECRYPTED;
-	if (GET_RX_DESC_BW(pdesc))
+	if (GET_RX_DESC_BW_CU(pdesc))
 		rx_status->flag |= RX_FLAG_40MHZ;
-	if (GET_RX_DESC_RX_HT(pdesc))
+	if (GET_RX_DESC_RX_HT_CU(pdesc))
 		rx_status->flag |= RX_FLAG_HT;
 	rx_status->flag |= RX_FLAG_MACTIME_MPDU;
 	if (stats->decrypted)
 		rx_status->flag |= RX_FLAG_DECRYPTED;
 	rx_status->rate_idx = rtlwifi_rate_mapping(hw,
-					(bool)GET_RX_DESC_RX_HT(pdesc),
-					(u8)GET_RX_DESC_RX_MCS(pdesc));
-	rx_status->mactime = GET_RX_DESC_TSFL(pdesc);
+					(bool)GET_RX_DESC_RX_HT_CU(pdesc),
+					(u8)GET_RX_DESC_RX_MCS_CU(pdesc));
+	rx_status->mactime = GET_RX_DESC_TSFL_CU(pdesc);
 	if (phystatus) {
 		p_drvinfo = (struct rx_fwinfo_92c *)(pdesc + RTL_RX_DESC_SIZE);
 		rtl92c_translate_rx_signal_stuff(hw, skb, stats, pdesc,
@@ -374,42 +374,43 @@ static void _rtl_rx_process(struct ieee80211_hw *hw, struct sk_buff *skb)
 	memset(rx_status, 0, sizeof(*rx_status));
 	rxdesc	= skb->data;
 	skb_len	= skb->len;
-	drvinfo_len = (GET_RX_DESC_DRVINFO_SIZE(rxdesc) * RTL_RX_DRV_INFO_UNIT);
-	pkt_len		= GET_RX_DESC_PKT_LEN(rxdesc);
+	drvinfo_len = (GET_RX_DESC_DRVINFO_SIZE_CU(rxdesc) *
+		       RTL_RX_DRV_INFO_UNIT);
+	pkt_len		= GET_RX_DESC_PKT_LEN_CU(rxdesc);
 	/* TODO: Error recovery. drop this skb or something. */
 	WARN_ON(skb_len < (pkt_len + RTL_RX_DESC_SIZE + drvinfo_len));
-	stats.length = (u16) GET_RX_DESC_PKT_LEN(rxdesc);
-	stats.rx_drvinfo_size = (u8)GET_RX_DESC_DRVINFO_SIZE(rxdesc) *
+	stats.length = (u16) GET_RX_DESC_PKT_LEN_CU(rxdesc);
+	stats.rx_drvinfo_size = (u8)GET_RX_DESC_DRVINFO_SIZE_CU(rxdesc) *
 				RX_DRV_INFO_SIZE_UNIT;
-	stats.rx_bufshift = (u8) (GET_RX_DESC_SHIFT(rxdesc) & 0x03);
-	stats.icv = (u16) GET_RX_DESC_ICV(rxdesc);
-	stats.crc = (u16) GET_RX_DESC_CRC32(rxdesc);
+	stats.rx_bufshift = (u8) (GET_RX_DESC_SHIFT_CU(rxdesc) & 0x03);
+	stats.icv = (u16) GET_RX_DESC_ICV_CU(rxdesc);
+	stats.crc = (u16) GET_RX_DESC_CRC32_CU(rxdesc);
 	stats.hwerror = (stats.crc | stats.icv);
-	stats.decrypted = !GET_RX_DESC_SWDEC(rxdesc);
-	stats.rate = (u8) GET_RX_DESC_RX_MCS(rxdesc);
-	stats.shortpreamble = (u16) GET_RX_DESC_SPLCP(rxdesc);
-	stats.isampdu = (bool) ((GET_RX_DESC_PAGGR(rxdesc) == 1)
-				   && (GET_RX_DESC_FAGGR(rxdesc) == 1));
-	stats.timestamp_low = GET_RX_DESC_TSFL(rxdesc);
-	stats.rx_is40Mhzpacket = (bool) GET_RX_DESC_BW(rxdesc);
+	stats.decrypted = !GET_RX_DESC_SWDEC_CU(rxdesc);
+	stats.rate = (u8) GET_RX_DESC_RX_MCS_CU(rxdesc);
+	stats.shortpreamble = (u16) GET_RX_DESC_SPLCP_CU(rxdesc);
+	stats.isampdu = (bool) ((GET_RX_DESC_PAGGR_CU(rxdesc) == 1)
+				   && (GET_RX_DESC_FAGGR_CU(rxdesc) == 1));
+	stats.timestamp_low = GET_RX_DESC_TSFL_CU(rxdesc);
+	stats.rx_is40Mhzpacket = (bool) GET_RX_DESC_BW_CU(rxdesc);
 	/* TODO: is center_freq changed when doing scan? */
 	/* TODO: Shall we add protection or just skip those two step? */
 	rx_status->freq = hw->conf.channel->center_freq;
 	rx_status->band = hw->conf.channel->band;
-	if (GET_RX_DESC_CRC32(rxdesc))
+	if (GET_RX_DESC_CRC32_CU(rxdesc))
 		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
-	if (!GET_RX_DESC_SWDEC(rxdesc))
+	if (!GET_RX_DESC_SWDEC_CU(rxdesc))
 		rx_status->flag |= RX_FLAG_DECRYPTED;
-	if (GET_RX_DESC_BW(rxdesc))
+	if (GET_RX_DESC_BW_CU(rxdesc))
 		rx_status->flag |= RX_FLAG_40MHZ;
-	if (GET_RX_DESC_RX_HT(rxdesc))
+	if (GET_RX_DESC_RX_HT_CU(rxdesc))
 		rx_status->flag |= RX_FLAG_HT;
 	/* Data rate */
 	rx_status->rate_idx = rtlwifi_rate_mapping(hw,
-					(bool)GET_RX_DESC_RX_HT(rxdesc),
-					(u8)GET_RX_DESC_RX_MCS(rxdesc));
+					(bool)GET_RX_DESC_RX_HT_CU(rxdesc),
+					(u8)GET_RX_DESC_RX_MCS_CU(rxdesc));
 	/*  There is a phy status after this rx descriptor. */
-	if (GET_RX_DESC_PHY_STATUS(rxdesc)) {
+	if (GET_RX_DESC_PHY_STATUS_CU(rxdesc)) {
 		p_drvinfo = (struct rx_fwinfo_92c *)(rxdesc + RTL_RX_DESC_SIZE);
 		rtl92c_translate_rx_signal_stuff(hw, skb, &stats,
 				 (struct rx_desc_92c *)rxdesc, p_drvinfo);
@@ -486,10 +487,10 @@ static void _rtl_tx_desc_checksum(u8 *txdesc)
 	u32 index;
 
 	/* Clear first */
-	SET_TX_DESC_TX_DESC_CHECKSUM(txdesc, 0);
+	SET_TX_DESC_TX_DESC_CHECKSUM_CU(txdesc, 0);
 	for (index = 0; index < 16; index++)
 		checksum = checksum ^ (*(ptr + index));
-	SET_TX_DESC_TX_DESC_CHECKSUM(txdesc, cpu_to_le16(checksum));
+	SET_TX_DESC_TX_DESC_CHECKSUM_CU(txdesc, cpu_to_le16(checksum));
 }
 
 void rtl92cu_tx_fill_desc(struct ieee80211_hw *hw,
@@ -519,52 +520,52 @@ void rtl92cu_tx_fill_desc(struct ieee80211_hw *hw,
 	memset(txdesc, 0, RTL_TX_HEADER_SIZE);
 	SET_TX_DESC_PKT_SIZE(txdesc, pktlen);
 	SET_TX_DESC_LINIP(txdesc, 0);
-	SET_TX_DESC_PKT_OFFSET(txdesc, RTL_DUMMY_OFFSET);
+	SET_TX_DESC_PKT_OFFSET_CU(txdesc, RTL_DUMMY_OFFSET);
 	SET_TX_DESC_OFFSET(txdesc, RTL_TX_HEADER_SIZE);
 	SET_TX_DESC_TX_RATE(txdesc, tcb_desc->hw_rate);
 	if (tcb_desc->use_shortgi || tcb_desc->use_shortpreamble)
-		SET_TX_DESC_DATA_SHORTGI(txdesc, 1);
+		SET_TX_DESC_DATA_SHORTGI_CU(txdesc, 1);
 	if (mac->tids[tid].agg.agg_state == RTL_AGG_ON &&
 		    info->flags & IEEE80211_TX_CTL_AMPDU) {
-		SET_TX_DESC_AGG_ENABLE(txdesc, 1);
-		SET_TX_DESC_MAX_AGG_NUM(txdesc, 0x14);
+		SET_TX_DESC_AGG_ENABLE_CU(txdesc, 1);
+		SET_TX_DESC_MAX_AGG_NUM_CU(txdesc, 0x14);
 	} else {
-		SET_TX_DESC_AGG_BREAK(txdesc, 1);
+		SET_TX_DESC_AGG_BREAK_CU(txdesc, 1);
 	}
-	SET_TX_DESC_SEQ(txdesc, seq_number);
-	SET_TX_DESC_RTS_ENABLE(txdesc, ((tcb_desc->rts_enable &&
+	SET_TX_DESC_SEQ_CU(txdesc, seq_number);
+	SET_TX_DESC_RTS_ENABLE_CU(txdesc, ((tcb_desc->rts_enable &&
 			       !tcb_desc->cts_enable) ? 1 : 0));
-	SET_TX_DESC_HW_RTS_ENABLE(txdesc, ((tcb_desc->rts_enable ||
+	SET_TX_DESC_HW_RTS_ENABLE_CU(txdesc, ((tcb_desc->rts_enable ||
 				  tcb_desc->cts_enable) ? 1 : 0));
-	SET_TX_DESC_CTS2SELF(txdesc, ((tcb_desc->cts_enable) ? 1 : 0));
-	SET_TX_DESC_RTS_STBC(txdesc, ((tcb_desc->rts_stbc) ? 1 : 0));
-	SET_TX_DESC_RTS_RATE(txdesc, tcb_desc->rts_rate);
-	SET_TX_DESC_RTS_BW(txdesc, 0);
-	SET_TX_DESC_RTS_SC(txdesc, tcb_desc->rts_sc);
-	SET_TX_DESC_RTS_SHORT(txdesc,
+	SET_TX_DESC_CTS2SELF_CU(txdesc, ((tcb_desc->cts_enable) ? 1 : 0));
+	SET_TX_DESC_RTS_STBC_CU(txdesc, ((tcb_desc->rts_stbc) ? 1 : 0));
+	SET_TX_DESC_RTS_RATE_CU(txdesc, tcb_desc->rts_rate);
+	SET_TX_DESC_RTS_BW_CU(txdesc, 0);
+	SET_TX_DESC_RTS_SC_CU(txdesc, tcb_desc->rts_sc);
+	SET_TX_DESC_RTS_SHORT_CU(txdesc,
 			      ((tcb_desc->rts_rate <= DESC92_RATE54M) ?
 			       (tcb_desc->rts_use_shortpreamble ? 1 : 0)
 			       : (tcb_desc->rts_use_shortgi ? 1 : 0)));
 	if (mac->bw_40) {
 		if (rate_flag & IEEE80211_TX_RC_DUP_DATA) {
-			SET_TX_DESC_DATA_BW(txdesc, 1);
-			SET_TX_DESC_DATA_SC(txdesc, 3);
+			SET_TX_DESC_DATA_BW_CU(txdesc, 1);
+			SET_TX_DESC_DATA_SC_CU(txdesc, 3);
 		} else if(rate_flag & IEEE80211_TX_RC_40_MHZ_WIDTH){
-			SET_TX_DESC_DATA_BW(txdesc, 1);
-			SET_TX_DESC_DATA_SC(txdesc, mac->cur_40_prime_sc);
+			SET_TX_DESC_DATA_BW_CU(txdesc, 1);
+			SET_TX_DESC_DATA_SC_CU(txdesc, mac->cur_40_prime_sc);
 		} else {
-			SET_TX_DESC_DATA_BW(txdesc, 0);
-			SET_TX_DESC_DATA_SC(txdesc, 0);
+			SET_TX_DESC_DATA_BW_CU(txdesc, 0);
+			SET_TX_DESC_DATA_SC_CU(txdesc, 0);
 		}
 	} else {
-		SET_TX_DESC_DATA_BW(txdesc, 0);
-		SET_TX_DESC_DATA_SC(txdesc, 0);
+		SET_TX_DESC_DATA_BW_CU(txdesc, 0);
+		SET_TX_DESC_DATA_SC_CU(txdesc, 0);
 	}
 	rcu_read_lock();
 	sta = ieee80211_find_sta(mac->vif, mac->bssid);
 	if (sta) {
 		u8 ampdu_density = sta->ht_cap.ampdu_density;
-		SET_TX_DESC_AMPDU_DENSITY(txdesc, ampdu_density);
+		SET_TX_DESC_AMPDU_DENSITY_CU(txdesc, ampdu_density);
 	}
 	rcu_read_unlock();
 	if (info->control.hw_key) {
@@ -573,46 +574,46 @@ void rtl92cu_tx_fill_desc(struct ieee80211_hw *hw,
 		case WLAN_CIPHER_SUITE_WEP40:
 		case WLAN_CIPHER_SUITE_WEP104:
 		case WLAN_CIPHER_SUITE_TKIP:
-			SET_TX_DESC_SEC_TYPE(txdesc, 0x1);
+			SET_TX_DESC_SEC_TYPE_CU(txdesc, 0x1);
 			break;
 		case WLAN_CIPHER_SUITE_CCMP:
-			SET_TX_DESC_SEC_TYPE(txdesc, 0x3);
+			SET_TX_DESC_SEC_TYPE_CU(txdesc, 0x3);
 			break;
 		default:
-			SET_TX_DESC_SEC_TYPE(txdesc, 0x0);
+			SET_TX_DESC_SEC_TYPE_CU(txdesc, 0x0);
 			break;
 		}
 	}
-	SET_TX_DESC_PKT_ID(txdesc, 0);
-	SET_TX_DESC_QUEUE_SEL(txdesc, fw_qsel);
-	SET_TX_DESC_DATA_RATE_FB_LIMIT(txdesc, 0x1F);
-	SET_TX_DESC_RTS_RATE_FB_LIMIT(txdesc, 0xF);
-	SET_TX_DESC_DISABLE_FB(txdesc, 0);
-	SET_TX_DESC_USE_RATE(txdesc, tcb_desc->use_driver_rate ? 1 : 0);
+	SET_TX_DESC_PKT_ID_CU(txdesc, 0);
+	SET_TX_DESC_QUEUE_SEL_CU(txdesc, fw_qsel);
+	SET_TX_DESC_DATA_RATE_FB_LIMIT_CU(txdesc, 0x1F);
+	SET_TX_DESC_RTS_RATE_FB_LIMIT_CU(txdesc, 0xF);
+	SET_TX_DESC_DISABLE_FB_CU(txdesc, 0);
+	SET_TX_DESC_USE_RATE_CU(txdesc, tcb_desc->use_driver_rate ? 1 : 0);
 	if (ieee80211_is_data_qos(fc)) {
 		if (mac->rdg_en) {
 			RT_TRACE(rtlpriv, COMP_SEND, DBG_TRACE,
 				 "Enable RDG function\n");
-			SET_TX_DESC_RDG_ENABLE(txdesc, 1);
+			SET_TX_DESC_RDG_ENABLE_CU(txdesc, 1);
 			SET_TX_DESC_HTC(txdesc, 1);
 		}
 	}
 	if (rtlpriv->dm.useramask) {
-		SET_TX_DESC_RATE_ID(txdesc, tcb_desc->ratr_index);
-		SET_TX_DESC_MACID(txdesc, tcb_desc->mac_id);
+		SET_TX_DESC_RATE_ID_CU(txdesc, tcb_desc->ratr_index);
+		SET_TX_DESC_MACID_CU(txdesc, tcb_desc->mac_id);
 	} else {
-		SET_TX_DESC_RATE_ID(txdesc, 0xC + tcb_desc->ratr_index);
-		SET_TX_DESC_MACID(txdesc, tcb_desc->ratr_index);
+		SET_TX_DESC_RATE_ID_CU(txdesc, 0xC + tcb_desc->ratr_index);
+		SET_TX_DESC_MACID_CU(txdesc, tcb_desc->ratr_index);
 	}
 	if ((!ieee80211_is_data_qos(fc)) && ppsc->leisure_ps &&
 	      ppsc->fwctrl_lps) {
-		SET_TX_DESC_HWSEQ_EN(txdesc, 1);
-		SET_TX_DESC_PKT_ID(txdesc, 8);
+		SET_TX_DESC_HWSEQ_EN_CU(txdesc, 1);
+		SET_TX_DESC_PKT_ID_CU(txdesc, 8);
 		if (!defaultadapter)
-			SET_TX_DESC_QOS(txdesc, 1);
+			SET_TX_DESC_QOS_CU(txdesc, 1);
 	}
 	if (ieee80211_has_morefrags(fc))
-		SET_TX_DESC_MORE_FRAG(txdesc, 1);
+		SET_TX_DESC_MORE_FRAG_CU(txdesc, 1);
 	if (is_multicast_ether_addr(ieee80211_get_DA(hdr)) ||
 	    is_broadcast_ether_addr(ieee80211_get_DA(hdr)))
 		SET_TX_DESC_BMC(txdesc, 1);
@@ -630,16 +631,16 @@ void rtl92cu_fill_fake_txdesc(struct ieee80211_hw *hw, u8 * pDesc,
 	SET_TX_DESC_LAST_SEG(pDesc, 1); /* bLastSeg; */
 	SET_TX_DESC_OFFSET(pDesc, RTL_TX_HEADER_SIZE); /* Offset = 32 */
 	SET_TX_DESC_PKT_SIZE(pDesc, buffer_len); /* Buffer size + command hdr */
-	SET_TX_DESC_QUEUE_SEL(pDesc, QSLT_MGNT); /* Fixed queue of Mgnt queue */
+	SET_TX_DESC_QUEUE_SEL_CU(pDesc, QSLT_MGNT); /* Fixed Mgnt queue */
 	/* Set NAVUSEHDR to prevent Ps-poll AId filed to be changed to error
 	 * vlaue by Hw. */
 	if (bIsPsPoll) {
-		SET_TX_DESC_NAV_USE_HDR(pDesc, 1);
+		SET_TX_DESC_NAV_USE_HDR_CU(pDesc, 1);
 	} else {
-		SET_TX_DESC_HWSEQ_EN(pDesc, 1); /* Hw set sequence number */
-		SET_TX_DESC_PKT_ID(pDesc, 0x100); /* set bit3 to 1. */
+		SET_TX_DESC_HWSEQ_EN_CU(pDesc, 1); /* Hw set sequence number */
+		SET_TX_DESC_PKT_ID_CU(pDesc, 0x100); /* set bit3 to 1. */
 	}
-	SET_TX_DESC_USE_RATE(pDesc, 1); /* use data rate which is set by Sw */
+	SET_TX_DESC_USE_RATE_CU(pDesc, 1); /* use data rate set by Sw */
 	SET_TX_DESC_OWN(pDesc, 1);
 	SET_TX_DESC_TX_RATE(pDesc, DESC92_RATE1M);
 	_rtl_tx_desc_checksum(pDesc);
@@ -658,22 +659,22 @@ void rtl92cu_tx_fill_cmddesc(struct ieee80211_hw *hw,
 	if (firstseg)
 		SET_TX_DESC_OFFSET(pdesc, RTL_TX_HEADER_SIZE);
 	SET_TX_DESC_TX_RATE(pdesc, DESC92_RATE1M);
-	SET_TX_DESC_SEQ(pdesc, 0);
+	SET_TX_DESC_SEQ_CU(pdesc, 0);
 	SET_TX_DESC_LINIP(pdesc, 0);
-	SET_TX_DESC_QUEUE_SEL(pdesc, fw_queue);
+	SET_TX_DESC_QUEUE_SEL_CU(pdesc, fw_queue);
 	SET_TX_DESC_FIRST_SEG(pdesc, 1);
 	SET_TX_DESC_LAST_SEG(pdesc, 1);
-	SET_TX_DESC_RATE_ID(pdesc, 7);
+	SET_TX_DESC_RATE_ID_CU(pdesc, 7);
 	SET_TX_DESC_MACID(pdesc, 0);
 	SET_TX_DESC_OWN(pdesc, 1);
 	SET_TX_DESC_PKT_SIZE((u8 *) pdesc, (u16) (skb->len));
 	SET_TX_DESC_FIRST_SEG(pdesc, 1);
 	SET_TX_DESC_LAST_SEG(pdesc, 1);
 	SET_TX_DESC_OFFSET(pdesc, 0x20);
-	SET_TX_DESC_USE_RATE(pdesc, 1);
+	SET_TX_DESC_USE_RATE_CU(pdesc, 1);
 	if (!ieee80211_is_data_qos(fc)) {
-		SET_TX_DESC_HWSEQ_EN(pdesc, 1);
-		SET_TX_DESC_PKT_ID(pdesc, 8);
+		SET_TX_DESC_HWSEQ_EN_CU(pdesc, 1);
+		SET_TX_DESC_PKT_ID_CU(pdesc, 8);
 	}
 	RT_PRINT_DATA(rtlpriv, COMP_CMD, DBG_LOUD, "H2C Tx Cmd Content",
 		      pdesc, RTL_TX_DESC_SIZE);
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.h b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.h
index 332b06e..40fef00 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.h
@@ -30,6 +30,8 @@
 #ifndef __RTL92CU_TRX_H__
 #define __RTL92CU_TRX_H__
 
+#include "../macros.h"
+
 #define RTL92C_USB_BULK_IN_NUM			1
 #define RTL92C_NUM_RX_URBS			8
 #define RTL92C_NUM_TX_URBS			32
@@ -96,314 +98,6 @@ struct rx_drv_info_92c {
 	u8 reserve:4;
 } __packed;
 
-/* Define a macro that takes a le32 word, converts it to host ordering,
- * right shifts by a specified count, creates a mask of the specified
- * bit count, and extracts that number of bits.
- */
-
-#define SHIFT_AND_MASK_LE(__pdesc, __shift, __bits)		\
-	((le32_to_cpu(*(((__le32 *)(__pdesc)))) >> (__shift)) &	\
-	BIT_LEN_MASK_32(__bits))
-
-/* Define a macro that clears a bit field in an le32 word and
- * sets the specified value into that bit field. The resulting
- * value remains in le32 ordering; however, it is properly converted
- * to host ordering for the clear and set operations before conversion
- * back to le32.
- */
-
-#define SET_BITS_OFFSET_LE(__pdesc, __shift, __len, __val)	\
-	(*(__le32 *)(__pdesc) = 				\
-	(cpu_to_le32((le32_to_cpu(*((__le32 *)(__pdesc))) &	\
-	(~(BIT_OFFSET_LEN_MASK_32((__shift), __len)))) |		\
-	(((u32)(__val) & BIT_LEN_MASK_32(__len)) << (__shift)))));
-
-/* macros to read various fields in RX descriptor */
-
-/* DWORD 0 */
-#define GET_RX_DESC_PKT_LEN(__rxdesc)		\
-	SHIFT_AND_MASK_LE((__rxdesc), 0, 14)
-#define GET_RX_DESC_CRC32(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc, 14, 1)
-#define GET_RX_DESC_ICV(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc, 15, 1)
-#define GET_RX_DESC_DRVINFO_SIZE(__rxdesc)	\
-	SHIFT_AND_MASK_LE(__rxdesc, 16, 4)
-#define GET_RX_DESC_SECURITY(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc, 20, 3)
-#define GET_RX_DESC_QOS(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc, 23, 1)
-#define GET_RX_DESC_SHIFT(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc, 24, 2)
-#define GET_RX_DESC_PHY_STATUS(__rxdesc)	\
-	SHIFT_AND_MASK_LE(__rxdesc, 26, 1)
-#define GET_RX_DESC_SWDEC(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc, 27, 1)
-#define GET_RX_DESC_LAST_SEG(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc, 28, 1)
-#define GET_RX_DESC_FIRST_SEG(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc, 29, 1)
-#define GET_RX_DESC_EOR(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc, 30, 1)
-#define GET_RX_DESC_OWN(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc, 31, 1)
-
-/* DWORD 1 */
-#define GET_RX_DESC_MACID(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+4, 0, 5)
-#define GET_RX_DESC_TID(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+4, 5, 4)
-#define GET_RX_DESC_PAGGR(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+4, 14, 1)
-#define GET_RX_DESC_FAGGR(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+4, 15, 1)
-#define GET_RX_DESC_A1_FIT(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+4, 16, 4)
-#define GET_RX_DESC_A2_FIT(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+4, 20, 4)
-#define GET_RX_DESC_PAM(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+4, 24, 1)
-#define GET_RX_DESC_PWR(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+4, 25, 1)
-#define GET_RX_DESC_MORE_DATA(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+4, 26, 1)
-#define GET_RX_DESC_MORE_FRAG(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+4, 27, 1)
-#define GET_RX_DESC_TYPE(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+4, 28, 2)
-#define GET_RX_DESC_MC(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+4, 30, 1)
-#define GET_RX_DESC_BC(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+4, 31, 1)
-
-/* DWORD 2 */
-#define GET_RX_DESC_SEQ(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+8, 0, 12)
-#define GET_RX_DESC_FRAG(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+8, 12, 4)
-#define GET_RX_DESC_USB_AGG_PKTNUM(__rxdesc)	\
-	SHIFT_AND_MASK_LE(__rxdesc+8, 16, 8)
-#define GET_RX_DESC_NEXT_IND(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+8, 30, 1)
-
-/* DWORD 3 */
-#define GET_RX_DESC_RX_MCS(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+12, 0, 6)
-#define GET_RX_DESC_RX_HT(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+12, 6, 1)
-#define GET_RX_DESC_AMSDU(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+12, 7, 1)
-#define GET_RX_DESC_SPLCP(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+12, 8, 1)
-#define GET_RX_DESC_BW(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+12, 9, 1)
-#define GET_RX_DESC_HTC(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+12, 10, 1)
-#define GET_RX_DESC_TCP_CHK_RPT(__rxdesc)	\
-	SHIFT_AND_MASK_LE(__rxdesc+12, 11, 1)
-#define GET_RX_DESC_IP_CHK_RPT(__rxdesc)	\
-	SHIFT_AND_MASK_LE(__rxdesc+12, 12, 1)
-#define GET_RX_DESC_TCP_CHK_VALID(__rxdesc)	\
-	SHIFT_AND_MASK_LE(__rxdesc+12, 13, 1)
-#define GET_RX_DESC_HWPC_ERR(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+12, 14, 1)
-#define GET_RX_DESC_HWPC_IND(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+12, 15, 1)
-#define GET_RX_DESC_IV0(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+12, 16, 16)
-
-/* DWORD 4 */
-#define GET_RX_DESC_IV1(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+16, 0, 32)
-
-/* DWORD 5 */
-#define GET_RX_DESC_TSFL(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+20, 0, 32)
-
-/*======================= tx desc ============================================*/
-
-/* macros to set various fields in TX descriptor */
-
-/* Dword 0 */
-#define SET_TX_DESC_PKT_SIZE(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc, 0, 16, __value)
-#define SET_TX_DESC_OFFSET(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc, 16, 8, __value)
-#define SET_TX_DESC_BMC(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc, 24, 1, __value)
-#define SET_TX_DESC_HTC(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc, 25, 1, __value)
-#define SET_TX_DESC_LAST_SEG(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc, 26, 1, __value)
-#define SET_TX_DESC_FIRST_SEG(__txdesc, __value)	\
-	 SET_BITS_OFFSET_LE(__txdesc, 27, 1, __value)
-#define SET_TX_DESC_LINIP(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc, 28, 1, __value)
-#define SET_TX_DESC_NO_ACM(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc, 29, 1, __value)
-#define SET_TX_DESC_GF(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc, 30, 1, __value)
-#define SET_TX_DESC_OWN(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc, 31, 1, __value)
-
-
-/* Dword 1 */
-#define SET_TX_DESC_MACID(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc+4, 0, 5, __value)
-#define SET_TX_DESC_AGG_ENABLE(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+4, 5, 1, __value)
-#define SET_TX_DESC_AGG_BREAK(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+4, 6, 1, __value)
-#define SET_TX_DESC_RDG_ENABLE(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+4, 7, 1, __value)
-#define SET_TX_DESC_QUEUE_SEL(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+4, 8, 5, __value)
-#define SET_TX_DESC_RDG_NAV_EXT(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+4, 13, 1, __value)
-#define SET_TX_DESC_LSIG_TXOP_EN(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+4, 14, 1, __value)
-#define SET_TX_DESC_PIFS(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc+4, 15, 1, __value)
-#define SET_TX_DESC_RATE_ID(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc+4, 16, 4, __value)
-#define SET_TX_DESC_RA_BRSR_ID(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+4, 16, 4, __value)
-#define SET_TX_DESC_NAV_USE_HDR(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+4, 20, 1, __value)
-#define SET_TX_DESC_EN_DESC_ID(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+4, 21, 1, __value)
-#define SET_TX_DESC_SEC_TYPE(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc+4, 22, 2, __value)
-#define SET_TX_DESC_PKT_OFFSET(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+4, 26, 5, __value)
-
-/* Dword 2 */
-#define SET_TX_DESC_RTS_RC(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc+8, 0, 6, __value)
-#define SET_TX_DESC_DATA_RC(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc+8, 6, 6, __value)
-#define SET_TX_DESC_BAR_RTY_TH(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+8, 14, 2, __value)
-#define SET_TX_DESC_MORE_FRAG(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+8, 17, 1, __value)
-#define SET_TX_DESC_RAW(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc+8, 18, 1, __value)
-#define SET_TX_DESC_CCX(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc+8, 19, 1, __value)
-#define SET_TX_DESC_AMPDU_DENSITY(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+8, 20, 3, __value)
-#define SET_TX_DESC_ANTSEL_A(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc+8, 24, 1, __value)
-#define SET_TX_DESC_ANTSEL_B(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc+8, 25, 1, __value)
-#define SET_TX_DESC_TX_ANT_CCK(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+8, 26, 2, __value)
-#define SET_TX_DESC_TX_ANTL(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc+8, 28, 2, __value)
-#define SET_TX_DESC_TX_ANT_HT(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+8, 30, 2, __value)
-
-/* Dword 3 */
-#define SET_TX_DESC_NEXT_HEAP_PAGE(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+12, 0, 8, __value)
-#define SET_TX_DESC_TAIL_PAGE(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+12, 8, 8, __value)
-#define SET_TX_DESC_SEQ(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc+12, 16, 12, __value)
-#define SET_TX_DESC_PKT_ID(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc+12, 28, 4, __value)
-
-/* Dword 4 */
-#define SET_TX_DESC_RTS_RATE(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc+16, 0, 5, __value)
-#define SET_TX_DESC_AP_DCFE(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc+16, 5, 1, __value)
-#define SET_TX_DESC_QOS(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc+16, 6, 1, __value)
-#define SET_TX_DESC_HWSEQ_EN(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc+16, 7, 1, __value)
-#define SET_TX_DESC_USE_RATE(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc+16, 8, 1, __value)
-#define SET_TX_DESC_DISABLE_RTS_FB(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+16, 9, 1, __value)
-#define SET_TX_DESC_DISABLE_FB(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+16, 10, 1, __value)
-#define SET_TX_DESC_CTS2SELF(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc+16, 11, 1, __value)
-#define SET_TX_DESC_RTS_ENABLE(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+16, 12, 1, __value)
-#define SET_TX_DESC_HW_RTS_ENABLE(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+16, 13, 1, __value)
-#define SET_TX_DESC_WAIT_DCTS(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+16, 18, 1, __value)
-#define SET_TX_DESC_CTS2AP_EN(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+16, 19, 1, __value)
-#define SET_TX_DESC_DATA_SC(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc+16, 20, 2, __value)
-#define SET_TX_DESC_DATA_STBC(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+16, 22, 2, __value)
-#define SET_TX_DESC_DATA_SHORT(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+16, 24, 1, __value)
-#define SET_TX_DESC_DATA_BW(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc+16, 25, 1, __value)
-#define SET_TX_DESC_RTS_SHORT(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+16, 26, 1, __value)
-#define SET_TX_DESC_RTS_BW(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc+16, 27, 1, __value)
-#define SET_TX_DESC_RTS_SC(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc+16, 28, 2, __value)
-#define SET_TX_DESC_RTS_STBC(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc+16, 30, 2, __value)
-
-/* Dword 5 */
-#define SET_TX_DESC_TX_RATE(__pdesc, __val)		\
-	SET_BITS_OFFSET_LE(__pdesc+20, 0, 6, __val)
-#define SET_TX_DESC_DATA_SHORTGI(__pdesc, __val)	\
-	SET_BITS_OFFSET_LE(__pdesc+20, 6, 1, __val)
-#define SET_TX_DESC_CCX_TAG(__pdesc, __val)		\
-	SET_BITS_OFFSET_LE(__pdesc+20, 7, 1, __val)
-#define SET_TX_DESC_DATA_RATE_FB_LIMIT(__txdesc, __value) \
-	SET_BITS_OFFSET_LE(__txdesc+20, 8, 5, __value)
-#define SET_TX_DESC_RTS_RATE_FB_LIMIT(__txdesc, __value) \
-	SET_BITS_OFFSET_LE(__txdesc+20, 13, 4, __value)
-#define SET_TX_DESC_RETRY_LIMIT_ENABLE(__txdesc, __value) \
-	SET_BITS_OFFSET_LE(__txdesc+20, 17, 1, __value)
-#define SET_TX_DESC_DATA_RETRY_LIMIT(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+20, 18, 6, __value)
-#define SET_TX_DESC_USB_TXAGG_NUM(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+20, 24, 8, __value)
-
-/* Dword 6 */
-#define SET_TX_DESC_TXAGC_A(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc+24, 0, 5, __value)
-#define SET_TX_DESC_TXAGC_B(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc+24, 5, 5, __value)
-#define SET_TX_DESC_USB_MAX_LEN(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+24, 10, 1, __value)
-#define SET_TX_DESC_MAX_AGG_NUM(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+24, 11, 5, __value)
-#define SET_TX_DESC_MCSG1_MAX_LEN(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+24, 16, 4, __value)
-#define SET_TX_DESC_MCSG2_MAX_LEN(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+24, 20, 4, __value)
-#define SET_TX_DESC_MCSG3_MAX_LEN(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+24, 24, 4, __value)
-#define SET_TX_DESC_MCSG7_MAX_LEN(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+24, 28, 4, __value)
-
-/* Dword 7 */
-#define SET_TX_DESC_TX_DESC_CHECKSUM(__txdesc, __value) \
-	SET_BITS_OFFSET_LE(__txdesc+28, 0, 16, __value)
-#define SET_TX_DESC_MCSG4_MAX_LEN(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+28, 16, 4, __value)
-#define SET_TX_DESC_MCSG5_MAX_LEN(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+28, 20, 4, __value)
-#define SET_TX_DESC_MCSG6_MAX_LEN(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+28, 24, 4, __value)
-#define SET_TX_DESC_MCSG15_MAX_LEN(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+28, 28, 4, __value)
-
-
 int  rtl8192cu_endpoint_mapping(struct ieee80211_hw *hw);
 u16 rtl8192cu_mq_to_hwq(__le16 fc, u16 mac80211_queue_index);
 bool rtl92cu_rx_query_desc(struct ieee80211_hw *hw,
-- 
1.7.7

