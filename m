Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 112B5C43219
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 06:41:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAEF2206DD
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 06:41:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="JHzm52qq";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="AUahRYlZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbfDZGlU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 02:41:20 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:53486 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbfDZGlU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 02:41:20 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 97DB4607DE; Fri, 26 Apr 2019 06:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556260878;
        bh=rHDrX8b3mBR/s14/d8S8sEZ31f2jjI/LmAr/ZQDdo0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JHzm52qqzgCAqceGXoMNV7qKex1rsfnlGlDN8tSDyiwhwJrftsG9keVOBwAv/R1pB
         XatryjYSdgBpHeBo/0jiuzHqszDj0I6orq/Suf3mXETJbu+2hGEJowWUIXPs69SgmL
         1LW6QwPWUwJK1DqlBXgZsj/RT9PROng9Yr7sCtHo=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E4F8460734;
        Fri, 26 Apr 2019 06:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556260877;
        bh=rHDrX8b3mBR/s14/d8S8sEZ31f2jjI/LmAr/ZQDdo0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AUahRYlZvBQBcCSGijMjILpcYCHthFxUOyltW9anIZitxftnGp/V9FY0RLfRV+SPH
         fB8P5julXTDtdCrsSPypAksliULI0WdWnXMBbm3/Ffd37nsIk8sGZNTeG43er5lg4G
         NqxtHIEYRyMmT8mFcl7BEG94F1dLOZ5sx3/AKuY4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E4F8460734
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, Wen Gong <wgong@codeaurora.org>
Subject: [PATCH 1/5] ath10k: add struct for high latency PN replay protection
Date:   Fri, 26 Apr 2019 09:41:07 +0300
Message-Id: <1556260871-2919-2-git-send-email-kvalo@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556260871-2919-1-git-send-email-kvalo@codeaurora.org>
References: <1556260871-2919-1-git-send-email-kvalo@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Wen Gong <wgong@codeaurora.org>

Add the struct for PN replay protection and fragment packet
handler.

Also fix the bitmask of HTT_RX_DESC_HL_INFO_MCAST_BCAST to match what's currently
used by SDIO firmware. The defines are not used yet so it's safe to modify
them. Remove the conflicting HTT_RX_DESC_HL_INFO_FRAGMENT as
it's not either used in ath10k.

Tested on QCA6174 SDIO with firmware WLAN.RMH.4.4.1-00007-QCARMSWP-1.

Signed-off-by: Wen Gong <wgong@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/core.h |  8 +++++++
 drivers/net/wireless/ath/ath10k/htt.h  | 43 ++++++++++++++++++++++++++++++----
 2 files changed, 47 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index f22cb3f49034..02e53fb85814 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -400,6 +400,14 @@ struct ath10k_peer {
 
 	/* protected by ar->data_lock */
 	struct ieee80211_key_conf *keys[WMI_MAX_KEY_INDEX + 1];
+	union htt_rx_pn_t tids_last_pn[ATH10K_TXRX_NUM_EXT_TIDS];
+	bool tids_last_pn_valid[ATH10K_TXRX_NUM_EXT_TIDS];
+	union htt_rx_pn_t frag_tids_last_pn[ATH10K_TXRX_NUM_EXT_TIDS];
+	u32 frag_tids_seq[ATH10K_TXRX_NUM_EXT_TIDS];
+	struct {
+		enum htt_security_types sec_type;
+		int pn_len;
+	} rx_pn[ATH10K_HTT_TXRX_PEER_SECURITY_MAX];
 };
 
 struct ath10k_txq {
diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 4cee5492abc8..fb5cb9169073 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -733,6 +733,20 @@ struct htt_rx_indication_hl {
 	struct htt_rx_indication_mpdu_range mpdu_ranges[0];
 } __packed;
 
+struct htt_hl_rx_desc {
+	__le32 info;
+	__le32 pn_31_0;
+	union {
+		struct {
+			__le16 pn_47_32;
+			__le16 pn_63_48;
+		} pn16;
+		__le32 pn_63_32;
+	} u0;
+	__le32 pn_95_64;
+	__le32 pn_127_96;
+} __packed;
+
 static inline struct htt_rx_indication_mpdu_range *
 		htt_rx_ind_get_mpdu_ranges(struct htt_rx_indication *rx_ind)
 {
@@ -790,6 +804,21 @@ struct htt_rx_peer_unmap {
 	__le16 peer_id;
 } __packed;
 
+enum htt_txrx_sec_cast_type {
+	HTT_TXRX_SEC_MCAST = 0,
+	HTT_TXRX_SEC_UCAST
+};
+
+enum htt_rx_pn_check_type {
+	HTT_RX_NON_PN_CHECK = 0,
+	HTT_RX_PN_CHECK
+};
+
+enum htt_rx_tkip_demic_type {
+	HTT_RX_NON_TKIP_MIC = 0,
+	HTT_RX_TKIP_MIC
+};
+
 enum htt_security_types {
 	HTT_SECURITY_NONE,
 	HTT_SECURITY_WEP128,
@@ -803,6 +832,9 @@ enum htt_security_types {
 	HTT_NUM_SECURITY_TYPES /* keep this last! */
 };
 
+#define ATH10K_HTT_TXRX_PEER_SECURITY_MAX 2
+#define ATH10K_TXRX_NUM_EXT_TIDS 19
+
 enum htt_security_flags {
 #define HTT_SECURITY_TYPE_MASK 0x7F
 #define HTT_SECURITY_TYPE_LSB  0
@@ -1010,6 +1042,11 @@ struct htt_rx_fragment_indication {
 	u8 fw_msdu_rx_desc[0];
 } __packed;
 
+#define ATH10K_IEEE80211_EXTIV               BIT(5)
+#define ATH10K_IEEE80211_TKIP_MICLEN         8   /* trailing MIC */
+
+#define HTT_RX_FRAG_IND_INFO0_HEADER_LEN     16
+
 #define HTT_RX_FRAG_IND_INFO0_EXT_TID_MASK     0x1F
 #define HTT_RX_FRAG_IND_INFO0_EXT_TID_LSB      0
 #define HTT_RX_FRAG_IND_INFO0_FLUSH_VALID_MASK 0x20
@@ -2128,10 +2165,8 @@ struct htt_rx_desc {
 #define HTT_RX_DESC_HL_INFO_ENCRYPTED_LSB          12
 #define HTT_RX_DESC_HL_INFO_CHAN_INFO_PRESENT_MASK 0x00002000
 #define HTT_RX_DESC_HL_INFO_CHAN_INFO_PRESENT_LSB  13
-#define HTT_RX_DESC_HL_INFO_MCAST_BCAST_MASK       0x00008000
-#define HTT_RX_DESC_HL_INFO_MCAST_BCAST_LSB        15
-#define HTT_RX_DESC_HL_INFO_FRAGMENT_MASK          0x00010000
-#define HTT_RX_DESC_HL_INFO_FRAGMENT_LSB           16
+#define HTT_RX_DESC_HL_INFO_MCAST_BCAST_MASK       0x00010000
+#define HTT_RX_DESC_HL_INFO_MCAST_BCAST_LSB        16
 #define HTT_RX_DESC_HL_INFO_KEY_ID_OCT_MASK        0x01fe0000
 #define HTT_RX_DESC_HL_INFO_KEY_ID_OCT_LSB         17
 
-- 
2.7.4

