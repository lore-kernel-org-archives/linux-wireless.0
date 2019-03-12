Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6110BC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 11:18:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2EB2B206BA
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 11:18:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="E+XUBUCa";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="RqnuaCnp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbfCLLSf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 07:18:35 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:58528 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726280AbfCLLSf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 07:18:35 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 16A3C608FC; Tue, 12 Mar 2019 11:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552389514;
        bh=T0Y11xnRL4iPaIcxIL83IaSdyaTDLXUlNdcgaQD6Bmg=;
        h=From:To:Cc:Subject:Date:From;
        b=E+XUBUCaeRBxSQ8E8R0mD8SkhZDDaeR5r6sWmor/a271mZI6YadU6Uhc92JwkS7NL
         EC1//md1PAoFW0Mk54MtD62PILuOMTiX/aAjSZuS20nbrPb/twR61oBNgd8q/ACgaz
         DguNvSJF3cN3RxyssXjLHKtBXjeJ7qYBEdlykv5k=
Received: from checstex0244823-lin.qca.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: bpothuno@codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 20E9660208;
        Tue, 12 Mar 2019 11:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552389513;
        bh=T0Y11xnRL4iPaIcxIL83IaSdyaTDLXUlNdcgaQD6Bmg=;
        h=From:To:Cc:Subject:Date:From;
        b=RqnuaCnprc0q54frozcQQB7MaeC8sji4g8qfQCIc7REIDUCXf26bh9B8sHxu50h/z
         4gnVr4uZxex5IYxo2HHMPu6dAnL1PUmocoEKEP6vF9cGgFyEjhU20PXx2CCfQaV1SI
         shpnHciNuBaJJFYRgoLE4dgtnqezp2sWKwbu7X8M=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 20E9660208
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=bpothuno@codeaurora.org
From:   Balaji Pothunoori <bpothuno@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Balaji Pothunoori <bpothuno@codeaurora.org>
Subject: [PATCH] ath10k: rx_duration update for fw_stats debugfs entry
Date:   Tue, 12 Mar 2019 16:47:50 +0530
Message-Id: <1552389470-28405-1-git-send-email-bpothuno@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Currently instant rx_duration always fetching as zero
in fw_stats debugfs entry if extended peer stats event
supports.

This patch updates instant rx_duration in fw_stats entry
based on extended peer stats and maintaining backward
compatibility for 10.2/10.x.

Tested HW: QCA9984.
Tested FW: 10.4-3.6.0.1-00004.

Signed-off-by: Balaji Pothunoori <bpothuno@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/core.h  |  2 +-
 drivers/net/wireless/ath/ath10k/debug.c |  3 +++
 drivers/net/wireless/ath/ath10k/wmi.c   | 37 +++++++++++++++++++++++++++------
 3 files changed, 35 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index e08a17b..a184097 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -196,7 +196,7 @@ struct ath10k_fw_extd_stats_peer {
 	struct list_head list;
 
 	u8 peer_macaddr[ETH_ALEN];
-	u32 rx_duration;
+	u64 rx_duration;
 };
 
 struct ath10k_fw_stats_vdev {
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 32d967a..ac1bcd9 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -305,6 +305,9 @@ void ath10k_debug_fw_stats_process(struct ath10k *ar, struct sk_buff *skb)
 	if (is_end)
 		ar->debug.fw_stats_done = true;
 
+	if (stats.extended)
+		ar->debug.fw_stats.extended = true;
+
 	is_started = !list_empty(&ar->debug.fw_stats.pdevs);
 
 	if (is_started && !is_end) {
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 98a90e4..4f707c6 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -8309,7 +8309,7 @@ ath10k_wmi_fw_vdev_stats_fill(const struct ath10k_fw_stats_vdev *vdev,
 
 static void
 ath10k_wmi_fw_peer_stats_fill(const struct ath10k_fw_stats_peer *peer,
-			      char *buf, u32 *length)
+			      char *buf, u32 *length, bool extended_peer)
 {
 	u32 len = *length;
 	u32 buf_len = ATH10K_FW_STATS_BUF_SIZE;
@@ -8322,13 +8322,27 @@ ath10k_wmi_fw_peer_stats_fill(const struct ath10k_fw_stats_peer *peer,
 			"Peer TX rate", peer->peer_tx_rate);
 	len += scnprintf(buf + len, buf_len - len, "%30s %u\n",
 			"Peer RX rate", peer->peer_rx_rate);
-	len += scnprintf(buf + len, buf_len - len, "%30s %llu\n",
-			"Peer RX duration", peer->rx_duration);
+	if (!extended_peer)
+		len += scnprintf(buf + len, buf_len - len, "%30s %llu\n",
+				"Peer RX duration", peer->rx_duration);
 
 	len += scnprintf(buf + len, buf_len - len, "\n");
 	*length = len;
 }
 
+static void
+ath10k_wmi_fw_extd_peer_stats_fill(const struct ath10k_fw_extd_stats_peer *peer,
+				   char *buf, u32 *length)
+{
+	u32 len = *length;
+	u32 buf_len = ATH10K_FW_STATS_BUF_SIZE;
+
+	len += scnprintf(buf + len, buf_len - len, "%30s %pM\n",
+			"Peer MAC address", peer->peer_macaddr);
+	len += scnprintf(buf + len, buf_len - len, "%30s %llu\n",
+			"Peer RX duration", peer->rx_duration);
+}
+
 void ath10k_wmi_main_op_fw_stats_fill(struct ath10k *ar,
 				      struct ath10k_fw_stats *fw_stats,
 				      char *buf)
@@ -8374,7 +8388,8 @@ void ath10k_wmi_main_op_fw_stats_fill(struct ath10k *ar,
 				 "=================");
 
 	list_for_each_entry(peer, &fw_stats->peers, list) {
-		ath10k_wmi_fw_peer_stats_fill(peer, buf, &len);
+		ath10k_wmi_fw_peer_stats_fill(peer, buf, &len,
+					      fw_stats->extended);
 	}
 
 unlock:
@@ -8432,7 +8447,8 @@ void ath10k_wmi_10x_op_fw_stats_fill(struct ath10k *ar,
 				 "=================");
 
 	list_for_each_entry(peer, &fw_stats->peers, list) {
-		ath10k_wmi_fw_peer_stats_fill(peer, buf, &len);
+		ath10k_wmi_fw_peer_stats_fill(peer, buf, &len,
+					      fw_stats->extended);
 	}
 
 unlock:
@@ -8541,6 +8557,7 @@ void ath10k_wmi_10_4_op_fw_stats_fill(struct ath10k *ar,
 	const struct ath10k_fw_stats_pdev *pdev;
 	const struct ath10k_fw_stats_vdev_extd *vdev;
 	const struct ath10k_fw_stats_peer *peer;
+	const struct ath10k_fw_extd_stats_peer *extd_peer;
 	size_t num_peers;
 	size_t num_vdevs;
 
@@ -8603,7 +8620,15 @@ void ath10k_wmi_10_4_op_fw_stats_fill(struct ath10k *ar,
 				"=================");
 
 	list_for_each_entry(peer, &fw_stats->peers, list) {
-		ath10k_wmi_fw_peer_stats_fill(peer, buf, &len);
+		ath10k_wmi_fw_peer_stats_fill(peer, buf, &len,
+					      fw_stats->extended);
+	}
+
+	if (fw_stats->extended) {
+		list_for_each_entry(extd_peer, &fw_stats->peers_extd, list) {
+			ath10k_wmi_fw_extd_peer_stats_fill(extd_peer, buf,
+							   &len);
+		}
 	}
 
 unlock:
-- 
2.7.4

