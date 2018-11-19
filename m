Return-Path: <SRS0=j5ME=N6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4C2AC43441
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Nov 2018 07:50:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6693620684
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Nov 2018 07:50:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ksGoFK/V";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="O7hmSYK/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6693620684
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbeKSSMu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 19 Nov 2018 13:12:50 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:59192 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726348AbeKSSMu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Nov 2018 13:12:50 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D182B607F7; Mon, 19 Nov 2018 07:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542613799;
        bh=oELrnCKFqAkK9S/CU6/96gYvRF0yfs6371qmYqPOoz0=;
        h=From:To:Cc:Subject:Date:From;
        b=ksGoFK/VDMPyFVyJ2zzVB38wUfc5ED0NBZPBiOcgXOE4mAneYmwqys8/gD64Bp6yI
         e/8J9iFXtK3QwvFbjMAAKpmR5w5yVvewwCAJ3yId+rlM7k4HFNe/Ed4QSXRypU+H/K
         KbSW5ETGs9XHxsA/7NKT4O5JiCXypyb1xp7bDN/8=
Received: from localhost (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: bperumal@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4FAA360452;
        Mon, 19 Nov 2018 07:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542613798;
        bh=oELrnCKFqAkK9S/CU6/96gYvRF0yfs6371qmYqPOoz0=;
        h=From:To:Cc:Subject:Date:From;
        b=O7hmSYK/0pZmStlEUEApCI4owxbGoRzAAbAcknBz62ZppObiTE2LZoH5laHROx3zC
         kMM8nbNlH90feo5krf1kwzjemwFwoLY1T4ag5amcFe2DFNifMToluE5xr9K4sZmFdT
         xodoB3uL2O8Fg+aSm94MtNc5u8HUDpt8E64GikuM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4FAA360452
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=bperumal@codeaurora.org
From:   Bhagavathi Perumal S <bperumal@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Bhagavathi Perumal S <bperumal@codeaurora.org>
Subject: [PATCH] ath10k: Fix warning due to msdu limit error
Date:   Mon, 19 Nov 2018 13:18:23 +0530
Message-Id: <1542613703-9704-1-git-send-email-bperumal@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Some hardwares variants(QCA99x0) are limiting msdu deaggregation with
some threshold value(default limit in QCA99x0 is 64 msdus), it was introduced to
avoid excessive MSDU-deaggregation in error cases. When number of sub frames
exceeds the limit, target hardware will send all msdus starting from present
msdu in RAW format as a single msdu packet and it will be indicated with
error status bit "RX_MSDU_END_INFO0_MSDU_LIMIT_ERR" set in rx descriptor.
This msdu frame is a partial raw MSDU and does't have first msdu and ieee80211
header. It caused below warning message.

[  320.151332] ------------[ cut here ]------------
[  320.155006] WARNING: CPU: 0 PID: 3 at drivers/net/wireless/ath/ath10k/htt_rx.c:1188

In our issue case, MSDU limit error happened due to FCS error and generated
this warning message.

This fixes the warning by handling the MSDU limit error. If msdu limit error
happens, driver adds first MSDU's ieee80211 header and sets A-MSDU present bit
in QOS header so that upper layer processes this frame if it is valid or drop it
if FCS error set. And removed the warning message, hence partial msdus without
first msdu is expected in msdu limit error cases.

Tested on QCA9984, Firmware 10.4-3.6-00104

Signed-off-by: Bhagavathi Perumal S <bperumal@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c  | 41 ++++++++++++++++++++++++++++---
 drivers/net/wireless/ath/ath10k/hw.c      |  7 ++++++
 drivers/net/wireless/ath/ath10k/hw.h      | 10 ++++++++
 drivers/net/wireless/ath/ath10k/rx_desc.h |  7 ++++++
 4 files changed, 61 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 984b045..a42f4d9 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1159,7 +1159,8 @@ static void ath10k_htt_rx_h_undecap_raw(struct ath10k *ar,
 					struct sk_buff *msdu,
 					struct ieee80211_rx_status *status,
 					enum htt_rx_mpdu_encrypt_type enctype,
-					bool is_decrypted)
+					bool is_decrypted,
+					const u8 first_hdr[64])
 {
 	struct ieee80211_hdr *hdr;
 	struct htt_rx_desc *rxd;
@@ -1167,6 +1168,9 @@ static void ath10k_htt_rx_h_undecap_raw(struct ath10k *ar,
 	size_t crypto_len;
 	bool is_first;
 	bool is_last;
+	bool msdu_limit_err;
+	int bytes_aligned = ar->hw_params.decap_align_bytes;
+	u8 *qos;
 
 	rxd = (void *)msdu->data - sizeof(*rxd);
 	is_first = !!(rxd->msdu_end.common.info0 &
@@ -1184,16 +1188,45 @@ static void ath10k_htt_rx_h_undecap_raw(struct ath10k *ar,
 	 * [FCS] <-- at end, needs to be trimmed
 	 */
 
+	/* Some hardwares(QCA99x0 variants) limit number of msdus in a-msdu when
+	 * deaggregate, so that unwanted MSDU-deaggregation is avoided for
+	 * error packets. If limit exceeds, hw sends all remaining MSDUs as
+	 * a single last MSDU with this msdu limit error set.
+	 */
+	msdu_limit_err = ath10k_rx_desc_msdu_limit_error(&ar->hw_params, rxd);
+
+	/* If MSDU limit error happens, then don't warn on, the partial raw MSDU
+	 * without first MSDU is expected in that case, and handled later here.
+	 */
 	/* This probably shouldn't happen but warn just in case */
-	if (WARN_ON_ONCE(!is_first))
+	if (WARN_ON_ONCE(!is_first && !msdu_limit_err))
 		return;
 
 	/* This probably shouldn't happen but warn just in case */
-	if (WARN_ON_ONCE(!(is_first && is_last)))
+	if (WARN_ON_ONCE(!(is_first && is_last) && !msdu_limit_err))
 		return;
 
 	skb_trim(msdu, msdu->len - FCS_LEN);
 
+	/* Push original 80211 header */
+	if (unlikely(msdu_limit_err)) {
+		hdr = (struct ieee80211_hdr *)first_hdr;
+		hdr_len = ieee80211_hdrlen(hdr->frame_control);
+		crypto_len = ath10k_htt_rx_crypto_param_len(ar, enctype);
+
+		if (ieee80211_is_data_qos(hdr->frame_control)) {
+			qos = ieee80211_get_qos_ctl(hdr);
+			qos[0] |= IEEE80211_QOS_CTL_A_MSDU_PRESENT;
+		}
+
+		if (crypto_len)
+			memcpy(skb_push(msdu, crypto_len),
+			       (void *)hdr + round_up(hdr_len, bytes_aligned),
+			       crypto_len);
+
+		memcpy(skb_push(msdu, hdr_len), hdr, hdr_len);
+	}
+
 	/* In most cases this will be true for sniffed frames. It makes sense
 	 * to deliver them as-is without stripping the crypto param. This is
 	 * necessary for software based decryption.
@@ -1467,7 +1500,7 @@ static void ath10k_htt_rx_h_undecap(struct ath10k *ar,
 	switch (decap) {
 	case RX_MSDU_DECAP_RAW:
 		ath10k_htt_rx_h_undecap_raw(ar, msdu, status, enctype,
-					    is_decrypted);
+					    is_decrypted, first_hdr);
 		break;
 	case RX_MSDU_DECAP_NATIVE_WIFI:
 		ath10k_htt_rx_h_undecap_nwifi(ar, msdu, status, first_hdr,
diff --git a/drivers/net/wireless/ath/ath10k/hw.c b/drivers/net/wireless/ath/ath10k/hw.c
index af8ae81..61ecf93 100644
--- a/drivers/net/wireless/ath/ath10k/hw.c
+++ b/drivers/net/wireless/ath/ath10k/hw.c
@@ -1119,8 +1119,15 @@ static int ath10k_qca99x0_rx_desc_get_l3_pad_bytes(struct htt_rx_desc *rxd)
 		  RX_MSDU_END_INFO1_L3_HDR_PAD);
 }
 
+static bool ath10k_qca99x0_rx_desc_msdu_limit_error(struct htt_rx_desc *rxd)
+{
+	return !!(rxd->msdu_end.common.info0 &
+		  __cpu_to_le32(RX_MSDU_END_INFO0_MSDU_LIMIT_ERR));
+}
+
 const struct ath10k_hw_ops qca99x0_ops = {
 	.rx_desc_get_l3_pad_bytes = ath10k_qca99x0_rx_desc_get_l3_pad_bytes,
+	.rx_desc_get_msdu_limit_error = ath10k_qca99x0_rx_desc_msdu_limit_error,
 };
 
 const struct ath10k_hw_ops qca6174_ops = {
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 1b5da27..e50a8dc5 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -624,6 +624,7 @@ struct ath10k_hw_ops {
 	int (*rx_desc_get_l3_pad_bytes)(struct htt_rx_desc *rxd);
 	void (*set_coverage_class)(struct ath10k *ar, s16 value);
 	int (*enable_pll_clk)(struct ath10k *ar);
+	bool (*rx_desc_get_msdu_limit_error)(struct htt_rx_desc *rxd);
 };
 
 extern const struct ath10k_hw_ops qca988x_ops;
@@ -642,6 +643,15 @@ struct ath10k_hw_ops {
 	return 0;
 }
 
+static inline bool
+ath10k_rx_desc_msdu_limit_error(struct ath10k_hw_params *hw,
+				struct htt_rx_desc *rxd)
+{
+	if (hw->hw_ops->rx_desc_get_msdu_limit_error)
+		return hw->hw_ops->rx_desc_get_msdu_limit_error(rxd);
+	return false;
+}
+
 /* Target specific defines for MAIN firmware */
 #define TARGET_NUM_VDEVS			8
 #define TARGET_NUM_PEER_AST			2
diff --git a/drivers/net/wireless/ath/ath10k/rx_desc.h b/drivers/net/wireless/ath/ath10k/rx_desc.h
index 310674d..b626cc2 100644
--- a/drivers/net/wireless/ath/ath10k/rx_desc.h
+++ b/drivers/net/wireless/ath/ath10k/rx_desc.h
@@ -572,6 +572,7 @@ struct rx_msdu_start {
 #define RX_MSDU_END_INFO0_REPORTED_MPDU_LENGTH_LSB  0
 #define RX_MSDU_END_INFO0_FIRST_MSDU                BIT(14)
 #define RX_MSDU_END_INFO0_LAST_MSDU                 BIT(15)
+#define RX_MSDU_END_INFO0_MSDU_LIMIT_ERR            BIT(18)
 #define RX_MSDU_END_INFO0_PRE_DELIM_ERR             BIT(30)
 #define RX_MSDU_END_INFO0_RESERVED_3B               BIT(31)
 
@@ -676,6 +677,12 @@ struct rx_msdu_end {
  *		Indicates the last MSDU of the A-MSDU.  MPDU end status is
  *		only valid when last_msdu is set.
  *
+ *msdu_limit_error
+ * 		Indicates that the MSDU threshold was exceeded and thus
+ *		all the rest of the MSDUs will not be scattered and
+ *		will not be decapsulated but will be received in RAW format
+ *		as a single MSDU buffer.
+ *
  *reserved_3a
  *		Reserved: HW should fill with zero.  FW should ignore.
  *
-- 
1.9.1

