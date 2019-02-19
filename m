Return-Path: <SRS0=cMLu=Q2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03C07C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 12:12:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB0EB2146E
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 12:12:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="bI+mRUg9";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="QmYYTF4R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbfBSMMG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Feb 2019 07:12:06 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:42634 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727640AbfBSMMG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Feb 2019 07:12:06 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1CA4B608CD; Tue, 19 Feb 2019 12:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550578325;
        bh=ShU8oTqDzJFSReFywGjL8txrHHes0fab7SxGhJT9+R0=;
        h=From:To:Cc:Subject:Date:From;
        b=bI+mRUg9AIId9oKQXeXHOvLRw16GaSCC4c4urqDpYgD4x3x3UXvEXqpIlOHabg0OH
         LSfGyGo6xIaxi09tX4j8fe6q26JMt3XkUV9qEEcvw91zRjPXIP1f1tcs6XsZVOFyHF
         RdJqgDf5SzKsFdhXk7poAG530FD+4AA9ygpR6CCA=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D9220608D4;
        Tue, 19 Feb 2019 12:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550578320;
        bh=ShU8oTqDzJFSReFywGjL8txrHHes0fab7SxGhJT9+R0=;
        h=From:To:Cc:Subject:Date:From;
        b=QmYYTF4RirBo00FosgjDti0dn1xeaVPqGqvxX00SODkuQPc6359QsXUQW+cvUtViX
         yQ2ONM3nukoq53hQB+d4ES79oyEObsW31zHZ/fT9tAY9Ci+Y24rQ3uFZ2gP4koAaMc
         8jmk1mtL0dgtAl6gukN9HHRA693HnaDwFL+1y/Ac=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D9220608D4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH] ath10k: change 'unsigned long int' to 'unsigned long'
Date:   Tue, 19 Feb 2019 14:11:43 +0200
Message-Id: <1550578303-15962-1-git-send-email-kvalo@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fixes checkpatch warnings:

Prefer 'unsigned long' over 'unsigned long int' as the int is unnecessary

Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/core.h        | 16 ++++++++--------
 drivers/net/wireless/ath/ath10k/debug.h       | 20 ++++++++++----------
 drivers/net/wireless/ath/ath10k/debugfs_sta.c | 10 +++++-----
 drivers/net/wireless/ath/ath10k/htt_rx.c      | 16 ++++++++--------
 drivers/net/wireless/ath/ath10k/snoc.h        |  2 +-
 5 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 2f43600717ec..482e60221ccb 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -448,14 +448,14 @@ enum ath10k_amsdu_subfrm_num {
 };
 
 struct ath10k_sta_tid_stats {
-	unsigned long int rx_pkt_from_fw;
-	unsigned long int rx_pkt_unchained;
-	unsigned long int rx_pkt_drop_chained;
-	unsigned long int rx_pkt_drop_filter;
-	unsigned long int rx_pkt_err[ATH10K_PKT_RX_ERR_MAX];
-	unsigned long int rx_pkt_queued_for_mac;
-	unsigned long int rx_pkt_ampdu[ATH10K_AMPDU_SUBFRM_NUM_MAX];
-	unsigned long int rx_pkt_amsdu[ATH10K_AMSDU_SUBFRM_NUM_MAX];
+	unsigned long rx_pkt_from_fw;
+	unsigned long rx_pkt_unchained;
+	unsigned long rx_pkt_drop_chained;
+	unsigned long rx_pkt_drop_filter;
+	unsigned long rx_pkt_err[ATH10K_PKT_RX_ERR_MAX];
+	unsigned long rx_pkt_queued_for_mac;
+	unsigned long rx_pkt_ampdu[ATH10K_AMPDU_SUBFRM_NUM_MAX];
+	unsigned long rx_pkt_amsdu[ATH10K_AMSDU_SUBFRM_NUM_MAX];
 };
 
 enum ath10k_counter_type {
diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index 5cf16d690724..eecafdbc873f 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -213,12 +213,12 @@ void ath10k_sta_add_debugfs(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 void ath10k_sta_update_rx_duration(struct ath10k *ar,
 				   struct ath10k_fw_stats *stats);
 void ath10k_sta_update_rx_tid_stats(struct ath10k *ar, u8 *first_hdr,
-				    unsigned long int num_msdus,
+				    unsigned long num_msdus,
 				    enum ath10k_pkt_rx_err err,
-				    unsigned long int unchain_cnt,
-				    unsigned long int drop_cnt,
-				    unsigned long int drop_cnt_filter,
-				    unsigned long int queued_msdus);
+				    unsigned long unchain_cnt,
+				    unsigned long drop_cnt,
+				    unsigned long drop_cnt_filter,
+				    unsigned long queued_msdus);
 void ath10k_sta_update_rx_tid_stats_ampdu(struct ath10k *ar,
 					  u16 peer_id, u8 tid,
 					  struct htt_rx_indication_mpdu_range *ranges,
@@ -232,12 +232,12 @@ void ath10k_sta_update_rx_duration(struct ath10k *ar,
 
 static inline
 void ath10k_sta_update_rx_tid_stats(struct ath10k *ar, u8 *first_hdr,
-				    unsigned long int num_msdus,
+				    unsigned long num_msdus,
 				    enum ath10k_pkt_rx_err err,
-				    unsigned long int unchain_cnt,
-				    unsigned long int drop_cnt,
-				    unsigned long int drop_cnt_filter,
-				    unsigned long int queued_msdus)
+				    unsigned long unchain_cnt,
+				    unsigned long drop_cnt,
+				    unsigned long drop_cnt_filter,
+				    unsigned long queued_msdus)
 {
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/debugfs_sta.c b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
index 4778a455d81a..ab49793353f4 100644
--- a/drivers/net/wireless/ath/ath10k/debugfs_sta.c
+++ b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
@@ -87,12 +87,12 @@ void ath10k_sta_update_rx_tid_stats_ampdu(struct ath10k *ar, u16 peer_id, u8 tid
 }
 
 void ath10k_sta_update_rx_tid_stats(struct ath10k *ar, u8 *first_hdr,
-				    unsigned long int num_msdus,
+				    unsigned long num_msdus,
 				    enum ath10k_pkt_rx_err err,
-				    unsigned long int unchain_cnt,
-				    unsigned long int drop_cnt,
-				    unsigned long int drop_cnt_filter,
-				    unsigned long int queued_msdus)
+				    unsigned long unchain_cnt,
+				    unsigned long drop_cnt,
+				    unsigned long drop_cnt_filter,
+				    unsigned long queued_msdus)
 {
 	struct ieee80211_sta *sta;
 	struct ath10k_sta *arsta;
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index d5c666c2504c..1afaa107024a 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1905,7 +1905,7 @@ static void ath10k_htt_rx_h_enqueue(struct ath10k *ar,
 }
 
 static int ath10k_unchain_msdu(struct sk_buff_head *amsdu,
-			       unsigned long int *unchain_cnt)
+			       unsigned long *unchain_cnt)
 {
 	struct sk_buff *skb, *first;
 	int space;
@@ -1954,8 +1954,8 @@ static int ath10k_unchain_msdu(struct sk_buff_head *amsdu,
 
 static void ath10k_htt_rx_h_unchain(struct ath10k *ar,
 				    struct sk_buff_head *amsdu,
-				    unsigned long int *drop_cnt,
-				    unsigned long int *unchain_cnt)
+				    unsigned long *drop_cnt,
+				    unsigned long *unchain_cnt)
 {
 	struct sk_buff *first;
 	struct htt_rx_desc *rxd;
@@ -2005,7 +2005,7 @@ static bool ath10k_htt_rx_amsdu_allowed(struct ath10k *ar,
 static void ath10k_htt_rx_h_filter(struct ath10k *ar,
 				   struct sk_buff_head *amsdu,
 				   struct ieee80211_rx_status *rx_status,
-				   unsigned long int *drop_cnt)
+				   unsigned long *drop_cnt)
 {
 	if (skb_queue_empty(amsdu))
 		return;
@@ -2025,10 +2025,10 @@ static int ath10k_htt_rx_handle_amsdu(struct ath10k_htt *htt)
 	struct ieee80211_rx_status *rx_status = &htt->rx_status;
 	struct sk_buff_head amsdu;
 	int ret;
-	unsigned long int drop_cnt = 0;
-	unsigned long int unchain_cnt = 0;
-	unsigned long int drop_cnt_filter = 0;
-	unsigned long int msdus_to_queue, num_msdus;
+	unsigned long drop_cnt = 0;
+	unsigned long unchain_cnt = 0;
+	unsigned long drop_cnt_filter = 0;
+	unsigned long msdus_to_queue, num_msdus;
 	enum ath10k_pkt_rx_err err = ATH10K_PKT_RX_ERR_MAX;
 	u8 first_hdr[RX_HTT_HDR_STATUS_LEN];
 
diff --git a/drivers/net/wireless/ath/ath10k/snoc.h b/drivers/net/wireless/ath/ath10k/snoc.h
index 2b2f23cf7c5d..4e256ae4b3ff 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.h
+++ b/drivers/net/wireless/ath/ath10k/snoc.h
@@ -90,7 +90,7 @@ struct ath10k_snoc {
 	struct ath10k_vreg_info *vreg;
 	struct ath10k_clk_info *clk;
 	struct ath10k_qmi *qmi;
-	unsigned long int flags;
+	unsigned long flags;
 };
 
 static inline struct ath10k_snoc *ath10k_snoc_priv(struct ath10k *ar)
-- 
2.7.4

