Return-Path: <SRS0=rthY=NG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED96EC6786E
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Oct 2018 05:03:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D8D020834
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Oct 2018 05:03:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="FY95exuR";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="lcVG1yvg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7D8D020834
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbeJZNjH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Oct 2018 09:39:07 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:45312 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbeJZNjH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Oct 2018 09:39:07 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7050660C5F; Fri, 26 Oct 2018 05:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540530219;
        bh=O7S5i1yH3ObOwmdEy1g7xdWLtj5pWblFL2E6PEOl0gI=;
        h=From:To:Cc:Subject:Date:From;
        b=FY95exuRWQHJfZHw0AKn1EzXFe6eQaFilOYhVSvGw6tOAyyYcPZWDTQGeBcU8TBKY
         ecI5YOs1aAPl4CFlno2cyrgi8vw4nJFABO+cJK4kZtrn9IhPBMtDR7tLijJCkfaCqZ
         kZqjbO9XU8YsHlyhm2uPwImsldec2yUjWPXKWcmI=
Received: from localhost (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: akolli@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B601260A33;
        Fri, 26 Oct 2018 05:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540530218;
        bh=O7S5i1yH3ObOwmdEy1g7xdWLtj5pWblFL2E6PEOl0gI=;
        h=From:To:Cc:Subject:Date:From;
        b=lcVG1yvg8ljYvkwpq2KCGKBliiGdPA8cZvi7QmacKN0sMv6OqACGg6oz+91rSl2gf
         rdaYzKupn6NXcOC9T6SFM86FVp+3Jc1Di9WGdIhup2v/DwHaKCPcFaQXBPBzgqygXy
         Ouut0WkrO33zeycwsPJrydiZZv9ixxhVWYY9NfkQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B601260A33
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=akolli@codeaurora.org
From:   Anilkumar Kolli <akolli@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Anilkumar Kolli <akolli@codeaurora.org>
Subject: [PATCH v2] ath10k: report tx rate using ieee80211_tx_rate_update()
Date:   Fri, 26 Oct 2018 10:37:18 +0530
Message-Id: <1540530438-11292-1-git-send-email-akolli@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Mesh path metric needs tx rate information from ieee80211_tx_status()
call but in ath10k there is no mechanism to report tx rate information
via ieee80211_tx_status(), the tx rate is only accessible via
sta_statiscs() op.

Per peer tx stats has tx rate info available, Tx rate is available
to ath10k driver after every 4 PPDU sent in the air. For each PPDU,
ath10k driver updates rate informattion to mac80211 using
ieee80211_tx_rate_update().

Per peer txrate information is updated through per peer statistics
and is available for QCA9888/QCA9984/QCA4019/QCA998X only

Tested on QCA9984 with firmware-5.bin_10.4-3.5.3-00053
Tested on QCA998X with firmware-5.bin_10.2.4-1.0-00036

Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>
---
V2:
  - Rebased on top of tree
  - Dependency mac80211 patch got merged

 drivers/net/wireless/ath/ath10k/core.h   |    1 +
 drivers/net/wireless/ath/ath10k/htt_rx.c |   67 +++++++++++++++++++++++++++---
 drivers/net/wireless/ath/ath10k/wmi.h    |    1 +
 3 files changed, 64 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 042418097cf9..6fb3944fb76a 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -493,6 +493,7 @@ struct ath10k_sta {
 	u32 smps;
 	u16 peer_id;
 	struct rate_info txrate;
+	struct ieee80211_tx_info tx_info;
 
 	struct work_struct update_wk;
 	u64 rx_duration;
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index ffec98f7be50..6a41b4144f01 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2627,7 +2627,7 @@ void ath10k_htt_htc_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 		dev_kfree_skb_any(skb);
 }
 
-static inline int ath10k_get_legacy_rate_idx(struct ath10k *ar, u8 rate)
+static inline s8 ath10k_get_legacy_rate_idx(struct ath10k *ar, u8 rate)
 {
 	static const u8 legacy_rates[] = {1, 2, 5, 11, 6, 9, 12,
 					  18, 24, 36, 48, 54};
@@ -2646,7 +2646,7 @@ static inline int ath10k_get_legacy_rate_idx(struct ath10k *ar, u8 rate)
 ath10k_accumulate_per_peer_tx_stats(struct ath10k *ar,
 				    struct ath10k_sta *arsta,
 				    struct ath10k_per_peer_tx_stats *pstats,
-				    u8 legacy_rate_idx)
+				    s8 legacy_rate_idx)
 {
 	struct rate_info *txrate = &arsta->txrate;
 	struct ath10k_htt_tx_stats *tx_stats;
@@ -2751,8 +2751,10 @@ static inline int ath10k_get_legacy_rate_idx(struct ath10k *ar, u8 rate)
 				struct ath10k_per_peer_tx_stats *peer_stats)
 {
 	struct ath10k_sta *arsta = (struct ath10k_sta *)sta->drv_priv;
+	struct ieee80211_chanctx_conf *conf = NULL;
 	u8 rate = 0, sgi;
 	s8 rate_idx = 0;
+	bool skip_auto_rate;
 	struct rate_info txrate;
 
 	lockdep_assert_held(&ar->data_lock);
@@ -2762,6 +2764,13 @@ static inline int ath10k_get_legacy_rate_idx(struct ath10k *ar, u8 rate)
 	txrate.nss = ATH10K_HW_NSS(peer_stats->ratecode);
 	txrate.mcs = ATH10K_HW_MCS_RATE(peer_stats->ratecode);
 	sgi = ATH10K_HW_GI(peer_stats->flags);
+	skip_auto_rate = ATH10K_FW_SKIPPED_RATE_CTRL(peer_stats->flags);
+
+	/* Firmware's rate control skips broadcast/management frames,
+	 * if host has configure fixed rates and in some other special cases.
+	 */
+	if (skip_auto_rate)
+		return;
 
 	if (txrate.flags == WMI_RATE_PREAMBLE_VHT && txrate.mcs > 9) {
 		ath10k_warn(ar, "Invalid VHT mcs %hhd peer stats",  txrate.mcs);
@@ -2776,7 +2785,7 @@ static inline int ath10k_get_legacy_rate_idx(struct ath10k *ar, u8 rate)
 	}
 
 	memset(&arsta->txrate, 0, sizeof(arsta->txrate));
-
+	memset(&arsta->tx_info.status, 0, sizeof(arsta->tx_info.status));
 	if (txrate.flags == WMI_RATE_PREAMBLE_CCK ||
 	    txrate.flags == WMI_RATE_PREAMBLE_OFDM) {
 		rate = ATH10K_HW_LEGACY_RATE(peer_stats->ratecode);
@@ -2795,11 +2804,59 @@ static inline int ath10k_get_legacy_rate_idx(struct ath10k *ar, u8 rate)
 		arsta->txrate.mcs = txrate.mcs;
 	}
 
-	if (sgi)
-		arsta->txrate.flags |= RATE_INFO_FLAGS_SHORT_GI;
+	switch (txrate.flags) {
+	case WMI_RATE_PREAMBLE_OFDM:
+		if (arsta->arvif && arsta->arvif->vif)
+			conf = rcu_dereference(arsta->arvif->vif->chanctx_conf);
+		if (conf && conf->def.chan->band == NL80211_BAND_5GHZ)
+			arsta->tx_info.status.rates[0].idx = rate_idx - 4;
+		break;
+	case WMI_RATE_PREAMBLE_CCK:
+		arsta->tx_info.status.rates[0].idx = rate_idx;
+		if (sgi)
+			arsta->tx_info.status.rates[0].flags |=
+				(IEEE80211_TX_RC_USE_SHORT_PREAMBLE |
+				 IEEE80211_TX_RC_SHORT_GI);
+		break;
+	case WMI_RATE_PREAMBLE_HT:
+		arsta->tx_info.status.rates[0].idx =
+				txrate.mcs + ((txrate.nss - 1) * 8);
+		if (sgi)
+			arsta->tx_info.status.rates[0].flags |=
+					IEEE80211_TX_RC_SHORT_GI;
+		arsta->tx_info.status.rates[0].flags |= IEEE80211_TX_RC_MCS;
+		break;
+	case WMI_RATE_PREAMBLE_VHT:
+		ieee80211_rate_set_vht(&arsta->tx_info.status.rates[0],
+				       txrate.mcs, txrate.nss);
+		if (sgi)
+			arsta->tx_info.status.rates[0].flags |=
+						IEEE80211_TX_RC_SHORT_GI;
+		arsta->tx_info.status.rates[0].flags |= IEEE80211_TX_RC_VHT_MCS;
+		break;
+	}
 
 	arsta->txrate.nss = txrate.nss;
 	arsta->txrate.bw = ath10k_bw_to_mac80211_bw(txrate.bw);
+	if (sgi)
+		arsta->txrate.flags |= RATE_INFO_FLAGS_SHORT_GI;
+
+	switch (arsta->txrate.bw) {
+	case RATE_INFO_BW_40:
+		arsta->tx_info.status.rates[0].flags |=
+				IEEE80211_TX_RC_40_MHZ_WIDTH;
+		break;
+	case RATE_INFO_BW_80:
+		arsta->tx_info.status.rates[0].flags |=
+				IEEE80211_TX_RC_80_MHZ_WIDTH;
+		break;
+	}
+
+	if (peer_stats->succ_pkts) {
+		arsta->tx_info.flags = IEEE80211_TX_STAT_ACK;
+		arsta->tx_info.status.rates[0].count = 1;
+		ieee80211_tx_rate_update(ar->hw, sta, &arsta->tx_info);
+	}
 
 	if (ath10k_debug_is_extd_tx_stats_enabled(ar))
 		ath10k_accumulate_per_peer_tx_stats(ar, arsta, peer_stats,
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index f7badd079051..e0b1f4767e54 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -4984,6 +4984,7 @@ enum wmi_rate_preamble {
 	(((preamble) << 6) | ((nss) << 4) | (rate))
 #define ATH10K_HW_AMPDU(flags)		((flags) & 0x1)
 #define ATH10K_HW_BA_FAIL(flags)	(((flags) >> 1) & 0x3)
+#define ATH10K_FW_SKIPPED_RATE_CTRL(flags)	(((flags) >> 6) & 0x1)
 
 #define ATH10K_VHT_MCS_NUM	10
 #define ATH10K_BW_NUM		4
-- 
1.7.9.5

