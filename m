Return-Path: <SRS0=krUy=RM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A909C10F00
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Mar 2019 13:49:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0A6820851
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Mar 2019 13:49:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726432AbfCINtI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Mar 2019 08:49:08 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:40670 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbfCINtI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Mar 2019 08:49:08 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x29DmhLS020428, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x29DmhLS020428
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=NOT);
        Sat, 9 Mar 2019 21:48:43 +0800
Received: from localhost.localdomain (1.168.42.219) by
 RTITCASV01.realtek.com.tw (172.21.6.18) with Microsoft SMTP Server id
 14.3.408.0; Sat, 9 Mar 2019 21:48:43 +0800
From:   <yhchuang@realtek.com>
To:     <kvalo@codeaurora.org>, <johannes@sipsolutions.net>,
        <gregkh@linuxfoundation.org>
CC:     <linux-wireless@vger.kernel.org>, <Larry.Finger@lwfinger.net>,
        <sgruszka@redhat.com>, <pkshih@realtek.com>, <tehuang@realtek.com>,
        <briannorris@chromium.org>
Subject: [PATCH v7 04/14] rtw88: trx files
Date:   Sat, 9 Mar 2019 21:48:12 +0800
Message-ID: <1552139302-20476-5-git-send-email-yhchuang@realtek.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1552139302-20476-1-git-send-email-yhchuang@realtek.com>
References: <1552139302-20476-1-git-send-email-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [1.168.42.219]
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

trx files for Realtek 802.11ac wireless network chips

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
---
 drivers/net/wireless/realtek/rtw88/rx.c | 151 +++++++++++++
 drivers/net/wireless/realtek/rtw88/rx.h |  41 ++++
 drivers/net/wireless/realtek/rtw88/tx.c | 367 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/realtek/rtw88/tx.h |  89 ++++++++
 4 files changed, 648 insertions(+)
 create mode 100644 drivers/net/wireless/realtek/rtw88/rx.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rx.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/tx.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/tx.h

diff --git a/drivers/net/wireless/realtek/rtw88/rx.c b/drivers/net/wireless/realtek/rtw88/rx.c
new file mode 100644
index 0000000..276856e
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/rx.c
@@ -0,0 +1,151 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2018  Realtek Corporation.
+ */
+
+#include "main.h"
+#include "rx.h"
+#include "ps.h"
+
+void rtw_rx_stats(struct rtw_dev *rtwdev, struct ieee80211_vif *vif,
+		  struct sk_buff *skb)
+{
+	struct ieee80211_hdr *hdr;
+	struct rtw_vif *rtwvif;
+
+	hdr = (struct ieee80211_hdr *)skb->data;
+
+	if (!ieee80211_is_data(hdr->frame_control))
+		return;
+
+	if (!is_broadcast_ether_addr(hdr->addr1) &&
+	    !is_multicast_ether_addr(hdr->addr1)) {
+		rtwdev->stats.rx_unicast += skb->len;
+		rtwdev->stats.rx_cnt++;
+		if (vif) {
+			rtwvif = (struct rtw_vif *)vif->drv_priv;
+			rtwvif->stats.rx_unicast += skb->len;
+			rtwvif->stats.rx_cnt++;
+			if (rtwvif->stats.rx_cnt > RTW_LPS_THRESHOLD)
+				rtw_leave_lps_irqsafe(rtwdev, rtwvif);
+		}
+	}
+}
+EXPORT_SYMBOL(rtw_rx_stats);
+
+struct rtw_rx_addr_match_data {
+	struct rtw_dev *rtwdev;
+	struct ieee80211_hdr *hdr;
+	struct rtw_rx_pkt_stat *pkt_stat;
+	u8 *bssid;
+};
+
+static void rtw_rx_addr_match_iter(void *data, u8 *mac,
+				   struct ieee80211_vif *vif)
+{
+	struct rtw_rx_addr_match_data *iter_data = data;
+	struct ieee80211_sta *sta;
+	struct ieee80211_hdr *hdr = iter_data->hdr;
+	struct rtw_dev *rtwdev = iter_data->rtwdev;
+	struct rtw_sta_info *si;
+	struct rtw_rx_pkt_stat *pkt_stat = iter_data->pkt_stat;
+	u8 *bssid = iter_data->bssid;
+
+	if (ether_addr_equal(vif->bss_conf.bssid, bssid) &&
+	    (ether_addr_equal(vif->addr, hdr->addr1) ||
+	     ieee80211_is_beacon(hdr->frame_control)))
+		sta = ieee80211_find_sta_by_ifaddr(rtwdev->hw, hdr->addr2,
+						   vif->addr);
+	else
+		return;
+
+	if (!sta)
+		return;
+
+	si = (struct rtw_sta_info *)sta->drv_priv;
+	ewma_rssi_add(&si->avg_rssi, pkt_stat->rssi);
+}
+
+static void rtw_rx_addr_match(struct rtw_dev *rtwdev,
+			      struct rtw_rx_pkt_stat *pkt_stat,
+			      struct ieee80211_hdr *hdr)
+{
+	struct rtw_rx_addr_match_data data = {};
+
+	if (pkt_stat->crc_err || pkt_stat->icv_err || !pkt_stat->phy_status ||
+	    ieee80211_is_ctl(hdr->frame_control))
+		return;
+
+	data.rtwdev = rtwdev;
+	data.hdr = hdr;
+	data.pkt_stat = pkt_stat;
+	data.bssid = get_hdr_bssid(hdr);
+
+	rtw_iterate_vifs_atomic(rtwdev, rtw_rx_addr_match_iter, &data);
+}
+
+void rtw_rx_fill_rx_status(struct rtw_dev *rtwdev,
+			   struct rtw_rx_pkt_stat *pkt_stat,
+			   struct ieee80211_hdr *hdr,
+			   struct ieee80211_rx_status *rx_status,
+			   u8 *phy_status)
+{
+	struct ieee80211_hw *hw = rtwdev->hw;
+
+	memset(rx_status, 0, sizeof(*rx_status));
+	rx_status->freq = hw->conf.chandef.chan->center_freq;
+	rx_status->band = hw->conf.chandef.chan->band;
+	if (pkt_stat->crc_err)
+		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
+	if (pkt_stat->decrypted)
+		rx_status->flag |= RX_FLAG_DECRYPTED;
+
+	if (pkt_stat->rate >= DESC_RATEVHT1SS_MCS0)
+		rx_status->encoding = RX_ENC_VHT;
+	else if (pkt_stat->rate >= DESC_RATEMCS0)
+		rx_status->encoding = RX_ENC_HT;
+
+	if (pkt_stat->rate >= DESC_RATEVHT1SS_MCS0 &&
+	    pkt_stat->rate <= DESC_RATEVHT1SS_MCS9) {
+		rx_status->nss = 1;
+		rx_status->rate_idx = pkt_stat->rate - DESC_RATEVHT1SS_MCS0;
+	} else if (pkt_stat->rate >= DESC_RATEVHT2SS_MCS0 &&
+		   pkt_stat->rate <= DESC_RATEVHT2SS_MCS9) {
+		rx_status->nss = 2;
+		rx_status->rate_idx = pkt_stat->rate - DESC_RATEVHT2SS_MCS0;
+	} else if (pkt_stat->rate >= DESC_RATEVHT3SS_MCS0 &&
+		   pkt_stat->rate <= DESC_RATEVHT3SS_MCS9) {
+		rx_status->nss = 3;
+		rx_status->rate_idx = pkt_stat->rate - DESC_RATEVHT3SS_MCS0;
+	} else if (pkt_stat->rate >= DESC_RATEVHT4SS_MCS0 &&
+		   pkt_stat->rate <= DESC_RATEVHT4SS_MCS9) {
+		rx_status->nss = 4;
+		rx_status->rate_idx = pkt_stat->rate - DESC_RATEVHT4SS_MCS0;
+	} else if (pkt_stat->rate >= DESC_RATEMCS0 &&
+		   pkt_stat->rate <= DESC_RATEMCS15) {
+		rx_status->rate_idx = pkt_stat->rate - DESC_RATEMCS0;
+	} else if (rx_status->band == NL80211_BAND_5GHZ &&
+		   pkt_stat->rate >= DESC_RATE6M &&
+		   pkt_stat->rate <= DESC_RATE54M) {
+		rx_status->rate_idx = pkt_stat->rate - DESC_RATE6M;
+	} else if (rx_status->band == NL80211_BAND_2GHZ &&
+		   pkt_stat->rate >= DESC_RATE1M &&
+		   pkt_stat->rate <= DESC_RATE54M) {
+		rx_status->rate_idx = pkt_stat->rate - DESC_RATE1M;
+	} else {
+		rx_status->rate_idx = 0;
+	}
+
+	rx_status->flag |= RX_FLAG_MACTIME_START;
+	rx_status->mactime = pkt_stat->tsf_low;
+
+	if (pkt_stat->bw == RTW_CHANNEL_WIDTH_80)
+		rx_status->bw = RATE_INFO_BW_80;
+	else if (pkt_stat->bw == RTW_CHANNEL_WIDTH_40)
+		rx_status->bw = RATE_INFO_BW_40;
+	else
+		rx_status->bw = RATE_INFO_BW_20;
+
+	rx_status->signal = pkt_stat->signal_power;
+
+	rtw_rx_addr_match(rtwdev, pkt_stat, hdr);
+}
diff --git a/drivers/net/wireless/realtek/rtw88/rx.h b/drivers/net/wireless/realtek/rtw88/rx.h
new file mode 100644
index 0000000..1c187de
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/rx.h
@@ -0,0 +1,41 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2018  Realtek Corporation.
+ */
+
+#ifndef __RTW_RX_H_
+#define __RTW_RX_H_
+
+#define GET_RX_DESC_PHYST(rxdesc)                                              \
+	le32_get_bits(*((__le32 *)(rxdesc) + 0x00), BIT(26))
+#define GET_RX_DESC_ICV_ERR(rxdesc)                                            \
+	le32_get_bits(*((__le32 *)(rxdesc) + 0x00), BIT(15))
+#define GET_RX_DESC_CRC32(rxdesc)                                              \
+	le32_get_bits(*((__le32 *)(rxdesc) + 0x00), BIT(14))
+#define GET_RX_DESC_SWDEC(rxdesc)                                              \
+	le32_get_bits(*((__le32 *)(rxdesc) + 0x00), BIT(27))
+#define GET_RX_DESC_C2H(rxdesc)                                                \
+	le32_get_bits(*((__le32 *)(rxdesc) + 0x02), BIT(28))
+#define GET_RX_DESC_PKT_LEN(rxdesc)                                            \
+	le32_get_bits(*((__le32 *)(rxdesc) + 0x00), GENMASK(13, 0))
+#define GET_RX_DESC_DRV_INFO_SIZE(rxdesc)                                      \
+	le32_get_bits(*((__le32 *)(rxdesc) + 0x00), GENMASK(19, 16))
+#define GET_RX_DESC_SHIFT(rxdesc)                                              \
+	le32_get_bits(*((__le32 *)(rxdesc) + 0x00), GENMASK(25, 24))
+#define GET_RX_DESC_RX_RATE(rxdesc)                                            \
+	le32_get_bits(*((__le32 *)(rxdesc) + 0x03), GENMASK(6, 0))
+#define GET_RX_DESC_MACID(rxdesc)                                              \
+	le32_get_bits(*((__le32 *)(rxdesc) + 0x01), GENMASK(6, 0))
+#define GET_RX_DESC_PPDU_CNT(rxdesc)                                           \
+	le32_get_bits(*((__le32 *)(rxdesc) + 0x02), GENMASK(30, 29))
+#define GET_RX_DESC_TSFL(rxdesc)                                               \
+	le32_get_bits(*((__le32 *)(rxdesc) + 0x05), GENMASK(31, 0))
+
+void rtw_rx_stats(struct rtw_dev *rtwdev, struct ieee80211_vif *vif,
+		  struct sk_buff *skb);
+void rtw_rx_fill_rx_status(struct rtw_dev *rtwdev,
+			   struct rtw_rx_pkt_stat *pkt_stat,
+			   struct ieee80211_hdr *hdr,
+			   struct ieee80211_rx_status *rx_status,
+			   u8 *phy_status);
+
+#endif
diff --git a/drivers/net/wireless/realtek/rtw88/tx.c b/drivers/net/wireless/realtek/rtw88/tx.c
new file mode 100644
index 0000000..e5267d5
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/tx.c
@@ -0,0 +1,367 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2018  Realtek Corporation.
+ */
+
+#include "main.h"
+#include "tx.h"
+#include "fw.h"
+#include "ps.h"
+
+static
+void rtw_tx_stats(struct rtw_dev *rtwdev, struct ieee80211_vif *vif,
+		  struct sk_buff *skb)
+{
+	struct ieee80211_hdr *hdr;
+	struct rtw_vif *rtwvif;
+
+	hdr = (struct ieee80211_hdr *)skb->data;
+
+	if (!ieee80211_is_data(hdr->frame_control))
+		return;
+
+	if (!is_broadcast_ether_addr(hdr->addr1) &&
+	    !is_multicast_ether_addr(hdr->addr1)) {
+		rtwdev->stats.tx_unicast += skb->len;
+		rtwdev->stats.tx_cnt++;
+		if (vif) {
+			rtwvif = (struct rtw_vif *)vif->drv_priv;
+			rtwvif->stats.tx_unicast += skb->len;
+			rtwvif->stats.tx_cnt++;
+			if (rtwvif->stats.tx_cnt > RTW_LPS_THRESHOLD)
+				rtw_leave_lps_irqsafe(rtwdev, rtwvif);
+		}
+	}
+}
+
+void rtw_tx_fill_tx_desc(struct rtw_tx_pkt_info *pkt_info, struct sk_buff *skb)
+{
+	__le32 *txdesc = (__le32 *)skb->data;
+
+	SET_TX_DESC_TXPKTSIZE(txdesc,  pkt_info->tx_pkt_size);
+	SET_TX_DESC_OFFSET(txdesc, pkt_info->offset);
+	SET_TX_DESC_PKT_OFFSET(txdesc, pkt_info->pkt_offset);
+	SET_TX_DESC_QSEL(txdesc, pkt_info->qsel);
+	SET_TX_DESC_BMC(txdesc, pkt_info->bmc);
+	SET_TX_DESC_RATE_ID(txdesc, pkt_info->rate_id);
+	SET_TX_DESC_DATARATE(txdesc, pkt_info->rate);
+	SET_TX_DESC_DISDATAFB(txdesc, pkt_info->dis_rate_fallback);
+	SET_TX_DESC_USE_RATE(txdesc, pkt_info->use_rate);
+	SET_TX_DESC_SEC_TYPE(txdesc, pkt_info->sec_type);
+	SET_TX_DESC_DATA_BW(txdesc, pkt_info->bw);
+	SET_TX_DESC_SW_SEQ(txdesc, pkt_info->seq);
+	SET_TX_DESC_MAX_AGG_NUM(txdesc, pkt_info->ampdu_factor);
+	SET_TX_DESC_AMPDU_DENSITY(txdesc, pkt_info->ampdu_density);
+	SET_TX_DESC_DATA_STBC(txdesc, pkt_info->stbc);
+	SET_TX_DESC_DATA_LDPC(txdesc, pkt_info->ldpc);
+	SET_TX_DESC_AGG_EN(txdesc, pkt_info->ampdu_en);
+	SET_TX_DESC_LS(txdesc, pkt_info->ls);
+	SET_TX_DESC_DATA_SHORT(txdesc, pkt_info->short_gi);
+	SET_TX_DESC_SPE_RPT(txdesc, pkt_info->report);
+	SET_TX_DESC_SW_DEFINE(txdesc, pkt_info->sn);
+}
+EXPORT_SYMBOL(rtw_tx_fill_tx_desc);
+
+static u8 get_tx_ampdu_factor(struct ieee80211_sta *sta)
+{
+	u8 exp = sta->ht_cap.ampdu_factor;
+
+	/* the least ampdu factor is 8K, and the value in the tx desc is the
+	 * max aggregation num, which represents val * 2 packets can be
+	 * aggregated in an AMPDU, so here we should use 8/2=4 as the base
+	 */
+	return (BIT(2) << exp) - 1;
+}
+
+static u8 get_tx_ampdu_density(struct ieee80211_sta *sta)
+{
+	return sta->ht_cap.ampdu_density;
+}
+
+static u8 get_highest_ht_tx_rate(struct rtw_dev *rtwdev,
+				 struct ieee80211_sta *sta)
+{
+	u8 rate;
+
+	if (rtwdev->hal.rf_type == RF_2T2R && sta->ht_cap.mcs.rx_mask[1] != 0)
+		rate = DESC_RATEMCS15;
+	else
+		rate = DESC_RATEMCS7;
+
+	return rate;
+}
+
+static u8 get_highest_vht_tx_rate(struct rtw_dev *rtwdev,
+				  struct ieee80211_sta *sta)
+{
+	struct rtw_efuse *efuse = &rtwdev->efuse;
+	u8 rate;
+	u16 tx_mcs_map;
+
+	tx_mcs_map = le16_to_cpu(sta->vht_cap.vht_mcs.tx_mcs_map);
+	if (efuse->hw_cap.nss == 1) {
+		switch (tx_mcs_map & 0x3) {
+		case IEEE80211_VHT_MCS_SUPPORT_0_7:
+			rate = DESC_RATEVHT1SS_MCS7;
+			break;
+		case IEEE80211_VHT_MCS_SUPPORT_0_8:
+			rate = DESC_RATEVHT1SS_MCS8;
+			break;
+		default:
+		case IEEE80211_VHT_MCS_SUPPORT_0_9:
+			rate = DESC_RATEVHT1SS_MCS9;
+			break;
+		}
+	} else if (efuse->hw_cap.nss >= 2) {
+		switch ((tx_mcs_map & 0xc) >> 2) {
+		case IEEE80211_VHT_MCS_SUPPORT_0_7:
+			rate = DESC_RATEVHT2SS_MCS7;
+			break;
+		case IEEE80211_VHT_MCS_SUPPORT_0_8:
+			rate = DESC_RATEVHT2SS_MCS8;
+			break;
+		default:
+		case IEEE80211_VHT_MCS_SUPPORT_0_9:
+			rate = DESC_RATEVHT2SS_MCS9;
+			break;
+		}
+	} else {
+		rate = DESC_RATEVHT1SS_MCS9;
+	}
+
+	return rate;
+}
+
+static void rtw_tx_report_enable(struct rtw_dev *rtwdev,
+				 struct rtw_tx_pkt_info *pkt_info)
+{
+	struct rtw_tx_report *tx_report = &rtwdev->tx_report;
+
+	/* [11:8], reserved, fills with zero
+	 * [7:2],  tx report sequence number
+	 * [1:0],  firmware use, fills with zero
+	 */
+	pkt_info->sn = (atomic_inc_return(&tx_report->sn) << 2) & 0xfc;
+	pkt_info->report = true;
+}
+
+void rtw_tx_report_purge_timer(struct timer_list *t)
+{
+	struct rtw_dev *rtwdev = from_timer(rtwdev, t, tx_report.purge_timer);
+	struct rtw_tx_report *tx_report = &rtwdev->tx_report;
+	unsigned long flags;
+
+	if (skb_queue_len(&tx_report->queue) == 0)
+		return;
+
+	WARN(1, "purge skb(s) not reported by firmware\n");
+
+	spin_lock_irqsave(&tx_report->q_lock, flags);
+	skb_queue_purge(&tx_report->queue);
+	spin_unlock_irqrestore(&tx_report->q_lock, flags);
+}
+
+void rtw_tx_report_enqueue(struct rtw_dev *rtwdev, struct sk_buff *skb, u8 sn)
+{
+	struct rtw_tx_report *tx_report = &rtwdev->tx_report;
+	unsigned long flags;
+	u8 *drv_data;
+
+	/* pass sn to tx report handler through driver data */
+	drv_data = (u8 *)IEEE80211_SKB_CB(skb)->status.status_driver_data;
+	*drv_data = sn;
+
+	spin_lock_irqsave(&tx_report->q_lock, flags);
+	__skb_queue_tail(&tx_report->queue, skb);
+	spin_unlock_irqrestore(&tx_report->q_lock, flags);
+
+	mod_timer(&tx_report->purge_timer, jiffies + RTW_TX_PROBE_TIMEOUT);
+}
+EXPORT_SYMBOL(rtw_tx_report_enqueue);
+
+static void rtw_tx_report_tx_status(struct rtw_dev *rtwdev,
+				    struct sk_buff *skb, bool acked)
+{
+	struct ieee80211_tx_info *info;
+
+	info = IEEE80211_SKB_CB(skb);
+	ieee80211_tx_info_clear_status(info);
+	if (acked)
+		info->flags |= IEEE80211_TX_STAT_ACK;
+	else
+		info->flags &= ~IEEE80211_TX_STAT_ACK;
+
+	ieee80211_tx_status_irqsafe(rtwdev->hw, skb);
+}
+
+void rtw_tx_report_handle(struct rtw_dev *rtwdev, struct sk_buff *skb)
+{
+	struct rtw_tx_report *tx_report = &rtwdev->tx_report;
+	struct rtw_c2h_cmd *c2h;
+	struct sk_buff *cur, *tmp;
+	unsigned long flags;
+	u8 sn, st;
+	u8 *n;
+
+	c2h = get_c2h_from_skb(skb);
+
+	sn = GET_CCX_REPORT_SEQNUM(c2h->payload);
+	st = GET_CCX_REPORT_STATUS(c2h->payload);
+
+	spin_lock_irqsave(&tx_report->q_lock, flags);
+	skb_queue_walk_safe(&tx_report->queue, cur, tmp) {
+		n = (u8 *)IEEE80211_SKB_CB(cur)->status.status_driver_data;
+		if (*n == sn) {
+			__skb_unlink(cur, &tx_report->queue);
+			rtw_tx_report_tx_status(rtwdev, cur, st == 0);
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&tx_report->q_lock, flags);
+}
+
+static void rtw_tx_mgmt_pkt_info_update(struct rtw_dev *rtwdev,
+					struct rtw_tx_pkt_info *pkt_info,
+					struct ieee80211_tx_control *control,
+					struct sk_buff *skb)
+{
+	pkt_info->use_rate = true;
+	pkt_info->rate_id = 6;
+	pkt_info->dis_rate_fallback = true;
+}
+
+static void rtw_tx_data_pkt_info_update(struct rtw_dev *rtwdev,
+					struct rtw_tx_pkt_info *pkt_info,
+					struct ieee80211_tx_control *control,
+					struct sk_buff *skb)
+{
+	struct ieee80211_sta *sta = control->sta;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct rtw_sta_info *si;
+	u16 seq;
+	u8 ampdu_factor = 0;
+	u8 ampdu_density = 0;
+	bool ampdu_en = false;
+	u8 rate = DESC_RATE6M;
+	u8 rate_id = 6;
+	u8 bw = RTW_CHANNEL_WIDTH_20;
+	bool stbc = false;
+	bool ldpc = false;
+
+	seq = (le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_SEQ) >> 4;
+
+	/* for broadcast/multicast, use default values */
+	if (!sta)
+		goto out;
+
+	if (info->flags & IEEE80211_TX_CTL_AMPDU) {
+		ampdu_en = true;
+		ampdu_factor = get_tx_ampdu_factor(sta);
+		ampdu_density = get_tx_ampdu_density(sta);
+	}
+
+	if (sta->vht_cap.vht_supported)
+		rate = get_highest_vht_tx_rate(rtwdev, sta);
+	else if (sta->ht_cap.ht_supported)
+		rate = get_highest_ht_tx_rate(rtwdev, sta);
+	else if (sta->supp_rates[0] <= 0xf)
+		rate = DESC_RATE11M;
+	else
+		rate = DESC_RATE54M;
+
+	si = (struct rtw_sta_info *)sta->drv_priv;
+
+	bw = si->bw_mode;
+	rate_id = si->rate_id;
+	stbc = si->stbc_en;
+	ldpc = si->ldpc_en;
+
+out:
+	pkt_info->seq = seq;
+	pkt_info->ampdu_factor = ampdu_factor;
+	pkt_info->ampdu_density = ampdu_density;
+	pkt_info->ampdu_en = ampdu_en;
+	pkt_info->rate = rate;
+	pkt_info->rate_id = rate_id;
+	pkt_info->bw = bw;
+	pkt_info->stbc = stbc;
+	pkt_info->ldpc = ldpc;
+}
+
+void rtw_tx_pkt_info_update(struct rtw_dev *rtwdev,
+			    struct rtw_tx_pkt_info *pkt_info,
+			    struct ieee80211_tx_control *control,
+			    struct sk_buff *skb)
+{
+	struct rtw_chip_info *chip = rtwdev->chip;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct rtw_sta_info *si;
+	struct ieee80211_vif *vif = NULL;
+	__le16 fc = hdr->frame_control;
+	u8 sec_type = 0;
+	bool bmc;
+
+	if (control->sta) {
+		si = (struct rtw_sta_info *)control->sta->drv_priv;
+		vif = si->vif;
+	}
+
+	if (ieee80211_is_mgmt(fc) || ieee80211_is_nullfunc(fc))
+		rtw_tx_mgmt_pkt_info_update(rtwdev, pkt_info, control, skb);
+	else if (ieee80211_is_data(fc))
+		rtw_tx_data_pkt_info_update(rtwdev, pkt_info, control, skb);
+
+	if (info->control.hw_key) {
+		struct ieee80211_key_conf *key = info->control.hw_key;
+
+		switch (key->cipher) {
+		case WLAN_CIPHER_SUITE_WEP40:
+		case WLAN_CIPHER_SUITE_WEP104:
+		case WLAN_CIPHER_SUITE_TKIP:
+			sec_type = 0x01;
+			break;
+		case WLAN_CIPHER_SUITE_CCMP:
+			sec_type = 0x03;
+			break;
+		default:
+			break;
+		}
+	}
+
+	bmc = is_broadcast_ether_addr(hdr->addr1) ||
+	      is_multicast_ether_addr(hdr->addr1);
+
+	if (info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS)
+		rtw_tx_report_enable(rtwdev, pkt_info);
+
+	pkt_info->bmc = bmc;
+	pkt_info->sec_type = sec_type;
+	pkt_info->tx_pkt_size = skb->len;
+	pkt_info->offset = chip->tx_pkt_desc_sz;
+	pkt_info->qsel = skb->priority;
+	pkt_info->ls = true;
+
+	/* maybe merge with tx status ? */
+	rtw_tx_stats(rtwdev, vif, skb);
+}
+
+void rtw_rsvd_page_pkt_info_update(struct rtw_dev *rtwdev,
+				   struct rtw_tx_pkt_info *pkt_info,
+				   struct sk_buff *skb)
+{
+	struct rtw_chip_info *chip = rtwdev->chip;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	bool bmc;
+
+	bmc = is_broadcast_ether_addr(hdr->addr1) ||
+	      is_multicast_ether_addr(hdr->addr1);
+	pkt_info->use_rate = true;
+	pkt_info->rate_id = 6;
+	pkt_info->dis_rate_fallback = true;
+	pkt_info->bmc = bmc;
+	pkt_info->tx_pkt_size = skb->len;
+	pkt_info->offset = chip->tx_pkt_desc_sz;
+	pkt_info->qsel = skb->priority;
+	pkt_info->ls = true;
+}
diff --git a/drivers/net/wireless/realtek/rtw88/tx.h b/drivers/net/wireless/realtek/rtw88/tx.h
new file mode 100644
index 0000000..6782632
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/tx.h
@@ -0,0 +1,89 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2018  Realtek Corporation.
+ */
+
+#ifndef __RTW_TX_H_
+#define __RTW_TX_H_
+
+#define RTK_TX_MAX_AGG_NUM_MASK		0x1f
+
+#define RTW_TX_PROBE_TIMEOUT		msecs_to_jiffies(500)
+
+#define SET_TX_DESC_TXPKTSIZE(txdesc, value)                                   \
+	le32p_replace_bits((__le32 *)(txdesc) + 0x00, value, GENMASK(15, 0))
+#define SET_TX_DESC_OFFSET(txdesc, value)                                      \
+	le32p_replace_bits((__le32 *)(txdesc) + 0x00, value, GENMASK(23, 16))
+#define SET_TX_DESC_PKT_OFFSET(txdesc, value)                                  \
+	le32p_replace_bits((__le32 *)(txdesc) + 0x01, value, GENMASK(28, 24))
+#define SET_TX_DESC_QSEL(txdesc, value)                                        \
+	le32p_replace_bits((__le32 *)(txdesc) + 0x01, value, GENMASK(12, 8))
+#define SET_TX_DESC_BMC(txdesc, value)                                         \
+	le32p_replace_bits((__le32 *)(txdesc) + 0x00, value, BIT(24))
+#define SET_TX_DESC_RATE_ID(txdesc, value)                                     \
+	le32p_replace_bits((__le32 *)(txdesc) + 0x01, value, GENMASK(20, 16))
+#define SET_TX_DESC_DATARATE(txdesc, value)                                    \
+	le32p_replace_bits((__le32 *)(txdesc) + 0x04, value, GENMASK(6, 0))
+#define SET_TX_DESC_DISDATAFB(txdesc, value)                                   \
+	le32p_replace_bits((__le32 *)(txdesc) + 0x03, value, BIT(10))
+#define SET_TX_DESC_USE_RATE(txdesc, value)                                    \
+	le32p_replace_bits((__le32 *)(txdesc) + 0x03, value, BIT(8))
+#define SET_TX_DESC_SEC_TYPE(txdesc, value)                                    \
+	le32p_replace_bits((__le32 *)(txdesc) + 0x01, value, GENMASK(23, 22))
+#define SET_TX_DESC_DATA_BW(txdesc, value)                                     \
+	le32p_replace_bits((__le32 *)(txdesc) + 0x05, value, GENMASK(6, 5))
+#define SET_TX_DESC_SW_SEQ(txdesc, value)                                      \
+	le32p_replace_bits((__le32 *)(txdesc) + 0x09, value, GENMASK(23, 12))
+#define SET_TX_DESC_MAX_AGG_NUM(txdesc, value)                                 \
+	le32p_replace_bits((__le32 *)(txdesc) + 0x03, value, GENMASK(21, 17))
+#define SET_TX_DESC_AMPDU_DENSITY(txdesc, value)                               \
+	le32p_replace_bits((__le32 *)(txdesc) + 0x02, value, GENMASK(22, 20))
+#define SET_TX_DESC_DATA_STBC(txdesc, value)                                   \
+	le32p_replace_bits((__le32 *)(txdesc) + 0x05, value, GENMASK(9, 8))
+#define SET_TX_DESC_DATA_LDPC(txdesc, value)                                   \
+	le32p_replace_bits((__le32 *)(txdesc) + 0x05, value, BIT(7))
+#define SET_TX_DESC_AGG_EN(txdesc, value)                                      \
+	le32p_replace_bits((__le32 *)(txdesc) + 0x02, value, BIT(12))
+#define SET_TX_DESC_LS(txdesc, value)                                          \
+	le32p_replace_bits((__le32 *)(txdesc) + 0x00, value, BIT(26))
+#define SET_TX_DESC_DATA_SHORT(txdesc, value)				       \
+	le32p_replace_bits((__le32 *)(txdesc) + 0x05, value, BIT(4))
+#define SET_TX_DESC_SPE_RPT(tx_desc, value)                                    \
+	le32p_replace_bits((__le32 *)(txdesc) + 0x02, value, BIT(19))
+#define SET_TX_DESC_SW_DEFINE(tx_desc, value)                                  \
+	le32p_replace_bits((__le32 *)(txdesc) + 0x06, value, GENMASK(11, 0))
+
+enum rtw_tx_desc_queue_select {
+	TX_DESC_QSEL_TID0	= 0,
+	TX_DESC_QSEL_TID1	= 1,
+	TX_DESC_QSEL_TID2	= 2,
+	TX_DESC_QSEL_TID3	= 3,
+	TX_DESC_QSEL_TID4	= 4,
+	TX_DESC_QSEL_TID5	= 5,
+	TX_DESC_QSEL_TID6	= 6,
+	TX_DESC_QSEL_TID7	= 7,
+	TX_DESC_QSEL_TID8	= 8,
+	TX_DESC_QSEL_TID9	= 9,
+	TX_DESC_QSEL_TID10	= 10,
+	TX_DESC_QSEL_TID11	= 11,
+	TX_DESC_QSEL_TID12	= 12,
+	TX_DESC_QSEL_TID13	= 13,
+	TX_DESC_QSEL_TID14	= 14,
+	TX_DESC_QSEL_TID15	= 15,
+	TX_DESC_QSEL_BEACON	= 16,
+	TX_DESC_QSEL_HIGH	= 17,
+	TX_DESC_QSEL_MGMT	= 18,
+	TX_DESC_QSEL_H2C	= 19,
+};
+
+void rtw_tx_pkt_info_update(struct rtw_dev *rtwdev,
+			    struct rtw_tx_pkt_info *pkt_info,
+			    struct ieee80211_tx_control *control,
+			    struct sk_buff *skb);
+void rtw_tx_fill_tx_desc(struct rtw_tx_pkt_info *pkt_info, struct sk_buff *skb);
+void rtw_tx_report_enqueue(struct rtw_dev *rtwdev, struct sk_buff *skb, u8 sn);
+void rtw_tx_report_handle(struct rtw_dev *rtwdev, struct sk_buff *skb);
+void rtw_rsvd_page_pkt_info_update(struct rtw_dev *rtwdev,
+				   struct rtw_tx_pkt_info *pkt_info,
+				   struct sk_buff *skb);
+
+#endif
-- 
2.7.4

