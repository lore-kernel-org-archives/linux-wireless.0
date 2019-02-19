Return-Path: <SRS0=cMLu=Q2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D6EAC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 10:01:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07E5C2146F
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 10:01:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="U0U6sNZc";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="U0U6sNZc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727233AbfBSKBV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Feb 2019 05:01:21 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:52346 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbfBSKBV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Feb 2019 05:01:21 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9300960850; Tue, 19 Feb 2019 10:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550570479;
        bh=nDgqUzfo+IDRqFp6PeXCgmeIxqqE8SDfs294he/0LQI=;
        h=From:To:Cc:Subject:Date:From;
        b=U0U6sNZcMLxxOoRCOV9tRYC/l57uDVYSizAmzeY3Pue2cYOdW70Hu+1CkQrQZSKYI
         jvNwZB6e+2X6W49pp8Az0ML3/Th4Wx8k9nNW39nv5+QWyhZDy7F5Y/OBvxJgUwmO9m
         Q9Hm6Ql6/prYlhEWBh9ZyTsXLFCYK1j81H5RcA/0=
Received: from aambure-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: aambure@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BED216034E;
        Tue, 19 Feb 2019 10:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550570479;
        bh=nDgqUzfo+IDRqFp6PeXCgmeIxqqE8SDfs294he/0LQI=;
        h=From:To:Cc:Subject:Date:From;
        b=U0U6sNZcMLxxOoRCOV9tRYC/l57uDVYSizAmzeY3Pue2cYOdW70Hu+1CkQrQZSKYI
         jvNwZB6e+2X6W49pp8Az0ML3/Th4Wx8k9nNW39nv5+QWyhZDy7F5Y/OBvxJgUwmO9m
         Q9Hm6Ql6/prYlhEWBh9ZyTsXLFCYK1j81H5RcA/0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BED216034E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=aambure@codeaurora.org
From:   Abhishek Ambure <aambure@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Abhishek Ambure <aambure@codeaurora.org>
Subject: [PATCH] ath10k: update the max num of peers supported for WCN3990
Date:   Tue, 19 Feb 2019 15:31:08 +0530
Message-Id: <1550570468-25869-1-git-send-email-aambure@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

WCN3990 firmware versions WLAN.HL.2.0-01617-QCAHLSWMTPLZ-1 & onwards
supports maximum 33 peers including self peer. To support maximum peers,
send updated peer param to firmware during initialization.

Tested HW: WCN3990
Tested FW: WLAN.HL.3.1-00784-QCAHLSWMTPLZ-1

Signed-off-by: Abhishek Ambure <aambure@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/core.c | 6 +++---
 drivers/net/wireless/ath/ath10k/hw.h   | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index a1b2aea..336c6a4 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -560,10 +560,10 @@
 		.sw_decrypt_mcast_mgmt = true,
 		.hw_ops = &wcn3990_ops,
 		.decap_align_bytes = 1,
-		.num_peers = TARGET_HL_10_TLV_NUM_PEERS,
+		.num_peers = TARGET_HL_TLV_NUM_PEERS,
 		.n_cipher_suites = 11,
-		.ast_skid_limit = TARGET_HL_10_TLV_AST_SKID_LIMIT,
-		.num_wds_entries = TARGET_HL_10_TLV_NUM_WDS_ENTRIES,
+		.ast_skid_limit = TARGET_HL_TLV_AST_SKID_LIMIT,
+		.num_wds_entries = TARGET_HL_TLV_NUM_WDS_ENTRIES,
 		.target_64bit = true,
 		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL_DUAL_MAC,
 		.per_ce_irq = true,
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index fe6b2ed..67413ae 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -763,9 +763,9 @@ struct ath10k_hw_ops {
 #define TARGET_TLV_MGMT_NUM_MSDU_DESC		(50)
 
 /* Target specific defines for WMI-HL-1.0 firmware */
-#define TARGET_HL_10_TLV_NUM_PEERS		14
-#define TARGET_HL_10_TLV_AST_SKID_LIMIT		6
-#define TARGET_HL_10_TLV_NUM_WDS_ENTRIES	2
+#define TARGET_HL_TLV_NUM_PEERS			33
+#define TARGET_HL_TLV_AST_SKID_LIMIT		16
+#define TARGET_HL_TLV_NUM_WDS_ENTRIES		2
 
 /* Diagnostic Window */
 #define CE_DIAG_PIPE	7
-- 
1.9.1

