Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10154C282C4
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 14:21:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4BF320870
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 14:21:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728722AbfAVOVu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 09:21:50 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:33005 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728416AbfAVOVs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 09:21:48 -0500
Received: by mail-ed1-f66.google.com with SMTP id p6so19494211eds.0
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jan 2019 06:21:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ArfIx3KMdm0G25ep2c9RDAISYwufk1Ha00yFX5Qx9YY=;
        b=eWmirDnYygtNPdXyOj3b0PkjRzwXUQL3kS6hLlXa9qU5qNECmzwEoib3F25Rf2uKA1
         d/W80IczY6ASIjsPrxfm91Lsi2QkD8fFISq3uelpalBrxu72MnmMTp0LpinqdJ37ZeRc
         qKYECtVpw3jY5L5o/LBuZGxNbExVrj/eGdTNFgJXLS7Oxq7vFRuLyyC4okAFC1IT9DFs
         GaXZuIj3mvNUDT9tTx0DgplU3s9hDzWeb9vnd4e3Y8OTWdOcJgwl20ez/7qOpg1iLzkU
         X0WZP0e6Zc+t5jYTijCrYvzYk3phMJdcHwRntWdkUp4+zfn7zlqSt0RHiG+NeXQMQgxw
         KEbQ==
X-Gm-Message-State: AJcUukfstlll8UydE6tpgm+Hrwu+YcwRt6TbVMPBR6xYZcLQOqGjSZVf
        XGUEaUX/HqItaxBOOjAyIlN3Rw==
X-Google-Smtp-Source: ALg8bN5lQqjT75vbrrHo71ow+/HoGISqcdOC4wgNSPnAe5wj7DySxNU90iWIJZIKrN8wEe5n2McwZg==
X-Received: by 2002:a50:91a8:: with SMTP id g37mr30690307eda.216.1548166906373;
        Tue, 22 Jan 2019 06:21:46 -0800 (PST)
Received: from tohojo-x1-rh.localdomain ([2a00:7660:6da:1:2262:af2:1f58:2146])
        by smtp.gmail.com with ESMTPSA id v12-v6sm5150968ejk.58.2019.01.22.06.21.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 22 Jan 2019 06:21:45 -0800 (PST)
Received: by tohojo-x1-rh.localdomain (Postfix, from userid 1000)
        id 2CF6C1833E0; Tue, 22 Jan 2019 15:21:44 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     Kan Yan <kyan@google.com>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        ath10k@lists.infradead.org, make-wifi-fast@lists.bufferbloat.net,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH v6 4/4] ath10k: reporting estimated tx airtime for fairness
Date:   Tue, 22 Jan 2019 15:20:19 +0100
Message-Id: <20190122142019.21417-5-toke@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190122142019.21417-1-toke@redhat.com>
References: <20190122142019.21417-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Kan Yan <kyan@google.com>

Transmit airtime will be estimated from last tx rate used.
Firmware report tx rate by peer stats. Airtime is computed
on tx path and the same will be reported to mac80211 upon
tx completion.

This change is based on Kan's orginal commit in Chromium tree
("CHROMIUM: ath10k: Implementing airtime fairness based TX scheduler")
ref: https://chromium-review.googlesource.com/588190

Tested on QCA4019 with firmware version 10.4-3.2.1.1-00015
Tested on QCA9984 with firmware version 10.4-3.9.0.1-00005

Signed-off-by: Kan Yan <kyan@google.com>
[rmanohar@codeaurora.org: ported only the airtime computation]
Signed-off-by: Rajkumar Manoharan <rmanohar@codeaurora.org>
[toke@redhat.com: Rebase to mac80211-next, add test note]
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---

Rajkumar / Kan: Please check that I didn't mess anything up while
rebasing this onto the current mac80211-next branch!

 drivers/net/wireless/ath/ath10k/core.h   |  2 +
 drivers/net/wireless/ath/ath10k/htt_rx.c |  1 +
 drivers/net/wireless/ath/ath10k/mac.c    | 57 ++++++++++++++++++++++--
 drivers/net/wireless/ath/ath10k/txrx.c   |  4 ++
 4 files changed, 61 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 28cecf7375f8..4528a6e47b8d 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -126,6 +126,7 @@ struct ath10k_skb_cb {
 	u8 flags;
 	u8 eid;
 	u16 msdu_id;
+	u16 airtime_est;
 	struct ieee80211_vif *vif;
 	struct ieee80211_txq *txq;
 } __packed;
@@ -498,6 +499,7 @@ struct ath10k_sta {
 	u16 peer_id;
 	struct rate_info txrate;
 	struct ieee80211_tx_info tx_info;
+	u32 last_tx_bitrate;
 
 	struct work_struct update_wk;
 	u64 rx_duration;
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index dc9895f2eb9d..6a93b57900ae 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -3078,6 +3078,7 @@ ath10k_update_per_peer_tx_stats(struct ath10k *ar,
 
 	arsta->txrate.nss = txrate.nss;
 	arsta->txrate.bw = ath10k_bw_to_mac80211_bw(txrate.bw);
+	arsta->last_tx_bitrate = cfg80211_calculate_bitrate(&arsta->txrate);
 	if (sgi)
 		arsta->txrate.flags |= RATE_INFO_FLAGS_SHORT_GI;
 
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index cf7fdf72e990..b13dcb4533cb 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3544,7 +3544,7 @@ static void ath10k_tx_h_add_p2p_noa_ie(struct ath10k *ar,
 static void ath10k_mac_tx_h_fill_cb(struct ath10k *ar,
 				    struct ieee80211_vif *vif,
 				    struct ieee80211_txq *txq,
-				    struct sk_buff *skb)
+				    struct sk_buff *skb, u16 airtime)
 {
 	struct ieee80211_hdr *hdr = (void *)skb->data;
 	struct ath10k_skb_cb *cb = ATH10K_SKB_CB(skb);
@@ -3561,6 +3561,7 @@ static void ath10k_mac_tx_h_fill_cb(struct ath10k *ar,
 
 	cb->vif = vif;
 	cb->txq = txq;
+	cb->airtime_est = airtime;
 }
 
 bool ath10k_mac_tx_frm_has_freq(struct ath10k *ar)
@@ -3948,6 +3949,49 @@ static bool ath10k_mac_tx_can_push(struct ieee80211_hw *hw,
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
@@ -3963,6 +4007,7 @@ int ath10k_mac_tx_push_txq(struct ieee80211_hw *hw,
 	size_t skb_len;
 	bool is_mgmt, is_presp;
 	int ret;
+	u16 airtime;
 
 	spin_lock_bh(&ar->htt.tx_lock);
 	ret = ath10k_htt_tx_inc_pending(htt);
@@ -3980,7 +4025,8 @@ int ath10k_mac_tx_push_txq(struct ieee80211_hw *hw,
 		return -ENOENT;
 	}
 
-	ath10k_mac_tx_h_fill_cb(ar, vif, txq, skb);
+	airtime = ath10k_mac_update_airtime(ar, txq, skb);
+	ath10k_mac_tx_h_fill_cb(ar, vif, txq, skb, airtime);
 
 	skb_len = skb->len;
 	txmode = ath10k_mac_tx_h_get_txmode(ar, vif, sta, skb);
@@ -4247,8 +4293,10 @@ static void ath10k_mac_op_tx(struct ieee80211_hw *hw,
 	bool is_mgmt;
 	bool is_presp;
 	int ret;
+	u16 airtime;
 
-	ath10k_mac_tx_h_fill_cb(ar, vif, txq, skb);
+	airtime = ath10k_mac_update_airtime(ar, txq, skb);
+	ath10k_mac_tx_h_fill_cb(ar, vif, txq, skb, airtime);
 
 	txmode = ath10k_mac_tx_h_get_txmode(ar, vif, sta, skb);
 	txpath = ath10k_mac_tx_h_get_txpath(ar, skb, txmode);
@@ -8603,6 +8651,9 @@ int ath10k_mac_register(struct ath10k *ar)
 		wiphy_ext_feature_set(ar->hw->wiphy,
 				      NL80211_EXT_FEATURE_ACK_SIGNAL_SUPPORT);
 
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
2.20.1

