Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D60ADC43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 00:41:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 728D021564
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 00:41:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jALvuOhK";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ctHblEYk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 728D021564
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbeI0G5A (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 02:57:00 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:57308 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbeI0G5A (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 02:57:00 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5160060B13; Thu, 27 Sep 2018 00:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538008886;
        bh=Z92ZYTFAZQnUgiOmZT0gZKBgCLJrlDxZ0ASma9DdmGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jALvuOhKHZWORYY0PSDwnEoAfNyQiC/au+A/CPk6Cadj0GboJDpPwJ26xiucGhRUB
         RJBdXvSLf5wGIu51PGkjTwX/GQFv/VeAfoCrOTdlWP5JZ4nYcY+rhLSVVCkZaAoxma
         ZkQMurik9UL+nFw4ctxzbEvfUvAKFzVm+T5v3r0E=
Received: from smtp.codeaurora.org (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1 with cipher AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: rmanohar@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0A8AE60B7D;
        Thu, 27 Sep 2018 00:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538008885;
        bh=Z92ZYTFAZQnUgiOmZT0gZKBgCLJrlDxZ0ASma9DdmGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ctHblEYk17VtF62KXpcegbouHsAQv+5kK/0utKbcEH0hahOoHhLAa8r2icvhLKaoT
         9ymVP++2V7Mo1A9+6x1MWOpZYROmjWUeJx1IUiFuh7AcSCBabrkYSTrgl4VMGLiByw
         ZsaymzgnqvN1JAwU6Uk33F01zEght0xUdy6z2gSo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0A8AE60B7D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=rmanohar@codeaurora.org
Received: by smtp.codeaurora.org (sSMTP sendmail emulation); Wed, 26 Sep 2018 17:41:23 -0700
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Kan Yan <kyan@google.com>
Subject: [RFC 2/2] ath10k: reporting estimated tx airtime for fairness
Date:   Wed, 26 Sep 2018 17:41:14 -0700
Message-Id: <1538008874-11692-2-git-send-email-rmanohar@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1538008874-11692-1-git-send-email-rmanohar@codeaurora.org>
References: <1538008874-11692-1-git-send-email-rmanohar@codeaurora.org>
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
 drivers/net/wireless/ath/ath10k/mac.c    | 58 ++++++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath10k/txrx.c   |  4 +++
 4 files changed, 62 insertions(+), 3 deletions(-)

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
index d4648b22ad64..a694dae6f024 100644
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
@@ -3932,6 +3933,50 @@ static bool ath10k_mac_tx_can_push(struct ieee80211_hw *hw,
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
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct ath10k_sta *arsta;
+	u32 pktlen;
+	u16 airtime = 0;
+
+	if (!txq || !txq->sta || !ieee80211_is_data(hdr->frame_control))
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
@@ -3947,6 +3992,7 @@ int ath10k_mac_tx_push_txq(struct ieee80211_hw *hw,
 	size_t skb_len;
 	bool is_mgmt, is_presp;
 	int ret;
+	u16 airtime;
 
 	spin_lock_bh(&ar->htt.tx_lock);
 	ret = ath10k_htt_tx_inc_pending(htt);
@@ -3964,7 +4010,8 @@ int ath10k_mac_tx_push_txq(struct ieee80211_hw *hw,
 		return -ENOENT;
 	}
 
-	ath10k_mac_tx_h_fill_cb(ar, vif, txq, skb);
+	airtime = ath10k_mac_update_airtime(ar, txq, skb);
+	ath10k_mac_tx_h_fill_cb(ar, vif, txq, skb, airtime);
 
 	skb_len = skb->len;
 	txmode = ath10k_mac_tx_h_get_txmode(ar, vif, sta, skb);
@@ -4230,8 +4277,10 @@ static void ath10k_mac_op_tx(struct ieee80211_hw *hw,
 	bool is_mgmt;
 	bool is_presp;
 	int ret;
+	u16 airtime;
 
-	ath10k_mac_tx_h_fill_cb(ar, vif, txq, skb);
+	airtime = ath10k_mac_update_airtime(ar, txq, skb);
+	ath10k_mac_tx_h_fill_cb(ar, vif, txq, skb, airtime);
 
 	txmode = ath10k_mac_tx_h_get_txmode(ar, vif, sta, skb);
 	txpath = ath10k_mac_tx_h_get_txpath(ar, skb, txmode);
@@ -8446,6 +8495,9 @@ int ath10k_mac_register(struct ath10k *ar)
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

