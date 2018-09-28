Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9851C43143
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 23:16:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 715CF206B8
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 23:16:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="pIA7Rxsx";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="HQokged6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 715CF206B8
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbeI2FmY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 29 Sep 2018 01:42:24 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:41096 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726612AbeI2FmY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 29 Sep 2018 01:42:24 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 121E960B7A; Fri, 28 Sep 2018 23:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538176583;
        bh=towxKUrjgpQAC89r7I9Fog9fevOQfJtdwUdEyxNCi2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pIA7RxsxoKIfqkeT4PpOA1w++HJHiq+yyixfeuom1nuBJthkoVm+U3WOiHWkgONxP
         FyME7cAHuPZhMFtzWrbpfx8piZ5pOU/BFhByCuI4GdDh+pREc4pbtNkwoJu9L4zpFi
         KHwjuA8DJo9QrqG3HILH9rJGof28eTNcA9DNkSE8=
Received: from smtp.codeaurora.org (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1 with cipher AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: rmanohar@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 49D4B605FD;
        Fri, 28 Sep 2018 23:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538176582;
        bh=towxKUrjgpQAC89r7I9Fog9fevOQfJtdwUdEyxNCi2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HQokged6YwTiHCFQWOZRaFFd6Bt7iBD8W8FzATKTAKtZacdB1ZotVA0Chd1LAksT/
         j+wawnuLhe3IRHdqE9lRTAPv5lHhdu+BHpW+bbtgwVgMctsvrlwhA1IRQv6a6qCYa2
         +g7zqj7ehzpFpm6V7XqOYZOJa8kOWgPxuratmPmA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 49D4B605FD
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=rmanohar@codeaurora.org
Received: by smtp.codeaurora.org (sSMTP sendmail emulation); Fri, 28 Sep 2018 16:16:20 -0700
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Kan Yan <kyan@google.com>
Subject: [RFC v2 2/2] ath10k: reporting estimated tx airtime for fairness
Date:   Fri, 28 Sep 2018 16:16:14 -0700
Message-Id: <1538176574-5580-2-git-send-email-rmanohar@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1538176574-5580-1-git-send-email-rmanohar@codeaurora.org>
References: <1538176574-5580-1-git-send-email-rmanohar@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Transmit airtime will be estimated from last tx rate used.
Firmware report tx rate by peer stats. Airtime is computed
on tx path and the same will be reported to mac80211 upon
tx completion.

Signed-off-by: Kan Yan <kyan@google.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/core.h   |  2 ++
 drivers/net/wireless/ath/ath10k/htt_rx.c |  1 +
 drivers/net/wireless/ath/ath10k/mac.c    | 57 ++++++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath10k/txrx.c   |  4 +++
 4 files changed, 61 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index d3e20aaf8023..4bfc370bf659 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -123,6 +123,7 @@ struct ath10k_skb_cb {
 	u8 flags;
 	u8 eid;
 	u16 msdu_id;
+	u16 airtime_est;
 	struct ieee80211_vif *vif;
 	struct ieee80211_txq *txq;
 } __packed;
@@ -493,6 +494,7 @@ struct ath10k_sta {
 	u32 smps;
 	u16 peer_id;
 	struct rate_info txrate;
+	u32 last_tx_bitrate;
 
 	struct work_struct update_wk;
 	u64 rx_duration;
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index f2aaa2f7a022..f1de9fc09d9f 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2809,6 +2809,7 @@ static inline int ath10k_get_legacy_rate_idx(struct ath10k *ar, u8 rate)
 
 	arsta->txrate.nss = txrate.nss;
 	arsta->txrate.bw = ath10k_bw_to_mac80211_bw(txrate.bw);
+	arsta->last_tx_bitrate = cfg80211_calculate_bitrate(&arsta->txrate);
 
 	if (ath10k_debug_is_extd_tx_stats_enabled(ar))
 		ath10k_accumulate_per_peer_tx_stats(ar, arsta, peer_stats,
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 3b441179a36c..7021e3b67cf0 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3528,7 +3528,7 @@ static void ath10k_tx_h_add_p2p_noa_ie(struct ath10k *ar,
 static void ath10k_mac_tx_h_fill_cb(struct ath10k *ar,
 				    struct ieee80211_vif *vif,
 				    struct ieee80211_txq *txq,
-				    struct sk_buff *skb)
+				    struct sk_buff *skb, u16 airtime)
 {
 	struct ieee80211_hdr *hdr = (void *)skb->data;
 	struct ath10k_skb_cb *cb = ATH10K_SKB_CB(skb);
@@ -3545,6 +3545,7 @@ static void ath10k_mac_tx_h_fill_cb(struct ath10k *ar,
 
 	cb->vif = vif;
 	cb->txq = txq;
+	cb->airtime_est = airtime;
 }
 
 bool ath10k_mac_tx_frm_has_freq(struct ath10k *ar)
@@ -3932,6 +3933,49 @@ static bool ath10k_mac_tx_can_push(struct ieee80211_hw *hw,
 	return false;
 }
 
+/* Return estimated airtime in microsecond, which is calculated using last
+ * reported TX rate. This is just a rough estimation because host driver has no
+ * knowledge of the actual transmit rate, retries or aggregation. If actual
+ * airtime can be reported by firmware, then delta between estimated and actual
+ * airtime can be adjusted from deficit.
+ */
+#define IEEE80211_ATF_OVERHEAD		100	/* IFS + some slot time */
+#define IEEE80211_ATF_OVERHEAD_IFS	16	/* IFS only */
+static u16 ath10k_mac_update_airtime(struct ath10k *ar,
+				     struct ieee80211_txq *txq,
+				     struct sk_buff *skb)
+{
+	struct ath10k_sta *arsta;
+	u32 pktlen;
+	u16 airtime = 0;
+
+	if (!txq || !txq->sta)
+		return airtime;
+
+	spin_lock_bh(&ar->data_lock);
+	arsta = (struct ath10k_sta *)txq->sta->drv_priv;
+
+	pktlen = skb->len + 38; /* Assume MAC header 30, SNAP 8 for most case */
+	if (arsta->last_tx_bitrate) {
+		/* airtime in us, last_tx_bitrate in 100kbps */
+		airtime = (pktlen * 8 * (1000 / 100))
+				/ arsta->last_tx_bitrate;
+		/* overhead for media access time and IFS */
+		airtime += IEEE80211_ATF_OVERHEAD_IFS;
+	} else {
+		/* This is mostly for throttle excessive BC/MC frames, and the
+		 * airtime/rate doesn't need be exact. Airtime of BC/MC frames
+		 * in 2G get some discount, which helps prevent very low rate
+		 * frames from being blocked for too long.
+		 */
+		airtime = (pktlen * 8 * (1000 / 100)) / 60; /* 6M */
+		airtime += IEEE80211_ATF_OVERHEAD;
+	}
+	spin_unlock_bh(&ar->data_lock);
+
+	return airtime;
+}
+
 int ath10k_mac_tx_push_txq(struct ieee80211_hw *hw,
 			   struct ieee80211_txq *txq)
 {
@@ -3947,6 +3991,7 @@ int ath10k_mac_tx_push_txq(struct ieee80211_hw *hw,
 	size_t skb_len;
 	bool is_mgmt, is_presp;
 	int ret;
+	u16 airtime;
 
 	spin_lock_bh(&ar->htt.tx_lock);
 	ret = ath10k_htt_tx_inc_pending(htt);
@@ -3964,7 +4009,8 @@ int ath10k_mac_tx_push_txq(struct ieee80211_hw *hw,
 		return -ENOENT;
 	}
 
-	ath10k_mac_tx_h_fill_cb(ar, vif, txq, skb);
+	airtime = ath10k_mac_update_airtime(ar, txq, skb);
+	ath10k_mac_tx_h_fill_cb(ar, vif, txq, skb, airtime);
 
 	skb_len = skb->len;
 	txmode = ath10k_mac_tx_h_get_txmode(ar, vif, sta, skb);
@@ -4230,8 +4276,10 @@ static void ath10k_mac_op_tx(struct ieee80211_hw *hw,
 	bool is_mgmt;
 	bool is_presp;
 	int ret;
+	u16 airtime;
 
-	ath10k_mac_tx_h_fill_cb(ar, vif, txq, skb);
+	airtime = ath10k_mac_update_airtime(ar, txq, skb);
+	ath10k_mac_tx_h_fill_cb(ar, vif, txq, skb, airtime);
 
 	txmode = ath10k_mac_tx_h_get_txmode(ar, vif, sta, skb);
 	txpath = ath10k_mac_tx_h_get_txpath(ar, skb, txmode);
@@ -8465,6 +8513,9 @@ int ath10k_mac_register(struct ath10k *ar)
 		wiphy_ext_feature_set(ar->hw->wiphy,
 				      NL80211_EXT_FEATURE_DATA_ACK_SIGNAL_SUPPORT);
 
+	if (ath10k_peer_stats_enabled(ar))
+		wiphy_ext_feature_set(ar->hw->wiphy,
+				      NL80211_EXT_FEATURE_AIRTIME_FAIRNESS);
 	/*
 	 * on LL hardware queues are managed entirely by the FW
 	 * so we only advertise to mac we can do the queues thing
diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index 23606b6972d0..8e7c416cd330 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -95,6 +95,10 @@ int ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 		wake_up(&htt->empty_tx_wq);
 	spin_unlock_bh(&htt->tx_lock);
 
+	if (txq && txq->sta)
+		ieee80211_sta_register_airtime(txq->sta, txq->tid,
+					       skb_cb->airtime_est, 0);
+
 	if (ar->dev_type != ATH10K_DEV_TYPE_HL)
 		dma_unmap_single(dev, skb_cb->paddr, msdu->len, DMA_TO_DEVICE);
 
-- 
1.9.1

