Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6BD6C43441
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 06:00:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71F47206B2
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 06:00:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="SdrDhIPC";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="g8Zs7Fkd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 71F47206B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727668AbeJLNbF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 09:31:05 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:35244 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727665AbeJLNbF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 09:31:05 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5734E60C60; Fri, 12 Oct 2018 06:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539324016;
        bh=H8TB22I4TjpBxuaMPZCk/K0t1D20XztHF07Xj23uAKY=;
        h=From:To:Cc:Subject:Date:From;
        b=SdrDhIPCQ0hvRPujErXQ7kYKtGRZQ2dQE1FRxT3PLb4KgBKXb/JpzWfySGjDnj2zY
         6NyGveydlR+4RRX/7WxqG06oGLuTBMBda6VPtrN0rRcXG6A34BZgRUFtQOvZgMKp1H
         xUpl7198j0F45A78QNU6QBacvD+jreOTyb/gC6m8=
Received: from localhost (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: akolli@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B386D60881;
        Fri, 12 Oct 2018 06:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539324015;
        bh=H8TB22I4TjpBxuaMPZCk/K0t1D20XztHF07Xj23uAKY=;
        h=From:To:Cc:Subject:Date:From;
        b=g8Zs7Fkdy2FS456Kx/egp8QVTebaf1veySe+PVgr6d/1WjVyCCi5EH+TGhRMDC+DX
         u+PNpNM9SrONSkzNHj8fEXLrnIahotvayM2JDX9xUGvcPxkHq7yAYl4e31uj6KLBOH
         Frluj60JjxjvNOwwMMc2vD8yPZYFB37ImZqDFqCY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B386D60881
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=akolli@codeaurora.org
From:   Anilkumar Kolli <akolli@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Anilkumar Kolli <akolli@codeaurora.org>
Subject: [PATCHv2] ath10k: Dump tx stats in rate table format
Date:   Fri, 12 Oct 2018 11:33:28 +0530
Message-Id: <1539324208-10525-1-git-send-email-akolli@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This patch adds the tx statistics pkts/bytes dump
in rate table format.

Dump format table is similar to http://mcsindex.com/

Tested on QCA9984/QCA4019/QCA988x
Firmware: 10.4-3.5.3-00057
	  10.2.4-1.0-00037
command:
cat /sys/kernel/debug/ieee80211/phy0/netdev\:wlan0/
    stations/<MACADDR>/tx_stats

Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/core.h        |    1 +
 drivers/net/wireless/ath/ath10k/debugfs_sta.c |   12 +++++++++++-
 drivers/net/wireless/ath/ath10k/htt_rx.c      |   17 ++++++++++++++++-
 drivers/net/wireless/ath/ath10k/wmi.h         |    1 +
 4 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index c76af343db3d..491eb0d2fc5f 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -474,6 +474,7 @@ struct ath10k_htt_data_stats {
 	u64 bw[ATH10K_COUNTER_TYPE_MAX][ATH10K_BW_NUM];
 	u64 nss[ATH10K_COUNTER_TYPE_MAX][ATH10K_NSS_NUM];
 	u64 gi[ATH10K_COUNTER_TYPE_MAX][ATH10K_GI_NUM];
+	u64 rate_table[ATH10K_COUNTER_TYPE_MAX][ATH10K_RATE_TABLE_NUM];
 };
 
 struct ath10k_htt_tx_stats {
diff --git a/drivers/net/wireless/ath/ath10k/debugfs_sta.c b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
index b09cdc699c69..0f3fd65a459e 100644
--- a/drivers/net/wireless/ath/ath10k/debugfs_sta.c
+++ b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
@@ -665,7 +665,7 @@ static ssize_t ath10k_dbg_sta_dump_tx_stats(struct file *file,
 						       "retry", "ampdu"};
 	const char *str[ATH10K_COUNTER_TYPE_MAX] = {"bytes", "packets"};
 	int len = 0, i, j, k, retval = 0;
-	const int size = 2 * 4096;
+	const int size = 16 * 4096;
 	char *buf;
 
 	buf = kzalloc(size, GFP_KERNEL);
@@ -719,6 +719,16 @@ static ssize_t ath10k_dbg_sta_dump_tx_stats(struct file *file,
 				len += scnprintf(buf + len, size - len, "%llu ",
 						 stats->legacy[j][i]);
 			len += scnprintf(buf + len, size - len, "\n");
+			len += scnprintf(buf + len, size - len,
+					 " Rate table %s (1,2 ... Mbps)\n  ",
+					 str[j]);
+			for (i = 0; i < ATH10K_RATE_TABLE_NUM; i++) {
+				len += scnprintf(buf + len, size - len, "%llu ",
+						 stats->rate_table[j][i]);
+				if (!((i + 1) % 8))
+					len +=
+					scnprintf(buf + len, size - len, "\n  ");
+			}
 		}
 	}
 
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index f2405258a6d3..b862d5de5e2f 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2650,7 +2650,7 @@ static inline int ath10k_get_legacy_rate_idx(struct ath10k *ar, u8 rate)
 {
 	struct rate_info *txrate = &arsta->txrate;
 	struct ath10k_htt_tx_stats *tx_stats;
-	int ht_idx, gi, mcs, bw, nss;
+	int idx, ht_idx, gi, mcs, bw, nss;
 
 	if (!arsta->tx_stats)
 		return;
@@ -2661,6 +2661,8 @@ static inline int ath10k_get_legacy_rate_idx(struct ath10k *ar, u8 rate)
 	mcs = txrate->mcs;
 	bw = txrate->bw;
 	nss = txrate->nss;
+	idx = mcs * 8 + 8 * 10 * nss;
+	idx += bw * 2 + gi;
 
 #define STATS_OP_FMT(name) tx_stats->stats[ATH10K_STATS_TYPE_##name]
 
@@ -2711,12 +2713,16 @@ static inline int ath10k_get_legacy_rate_idx(struct ath10k *ar, u8 rate)
 			pstats->succ_bytes + pstats->retry_bytes;
 		STATS_OP_FMT(AMPDU).gi[0][gi] +=
 			pstats->succ_bytes + pstats->retry_bytes;
+		STATS_OP_FMT(AMPDU).rate_table[0][idx] +=
+			pstats->succ_bytes + pstats->retry_bytes;
 		STATS_OP_FMT(AMPDU).bw[1][bw] +=
 			pstats->succ_pkts + pstats->retry_pkts;
 		STATS_OP_FMT(AMPDU).nss[1][nss] +=
 			pstats->succ_pkts + pstats->retry_pkts;
 		STATS_OP_FMT(AMPDU).gi[1][gi] +=
 			pstats->succ_pkts + pstats->retry_pkts;
+		STATS_OP_FMT(AMPDU).rate_table[1][idx] +=
+			pstats->succ_pkts + pstats->retry_pkts;
 	} else {
 		tx_stats->ack_fails +=
 				ATH10K_HW_BA_FAIL(pstats->flags);
@@ -2745,6 +2751,15 @@ static inline int ath10k_get_legacy_rate_idx(struct ath10k *ar, u8 rate)
 	STATS_OP_FMT(RETRY).bw[1][bw] += pstats->retry_pkts;
 	STATS_OP_FMT(RETRY).nss[1][nss] += pstats->retry_pkts;
 	STATS_OP_FMT(RETRY).gi[1][gi] += pstats->retry_pkts;
+
+	if (txrate->flags >= RATE_INFO_FLAGS_MCS) {
+		STATS_OP_FMT(SUCC).rate_table[0][idx] += pstats->succ_bytes;
+		STATS_OP_FMT(SUCC).rate_table[1][idx] += pstats->succ_pkts;
+		STATS_OP_FMT(FAIL).rate_table[0][idx] += pstats->failed_bytes;
+		STATS_OP_FMT(FAIL).rate_table[1][idx] += pstats->failed_pkts;
+		STATS_OP_FMT(RETRY).rate_table[0][idx] += pstats->retry_bytes;
+		STATS_OP_FMT(RETRY).rate_table[1][idx] += pstats->retry_pkts;
+	}
 }
 
 static void
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index f67c52757ea6..300f20523204 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -4991,6 +4991,7 @@ enum wmi_rate_preamble {
 #define ATH10K_LEGACY_NUM	12
 #define ATH10K_GI_NUM		2
 #define ATH10K_HT_MCS_NUM	32
+#define ATH10K_RATE_TABLE_NUM	320
 
 /* Value to disable fixed rate setting */
 #define WMI_FIXED_RATE_NONE    (0xff)
-- 
1.7.9.5

