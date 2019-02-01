Return-Path: <SRS0=B73O=QI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B554C169C4
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 02:17:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54DE220B1F
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 02:17:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dnViYRNL";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dnViYRNL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbfBACRm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 21:17:42 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:60964 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726798AbfBACRm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 21:17:42 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id AC6F8602CB; Fri,  1 Feb 2019 02:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548987460;
        bh=QeFRpfJFajDzigqfxS5d2WP6FiSe4fjrnPi3DE3UBus=;
        h=From:To:Cc:Subject:Date:From;
        b=dnViYRNLiOFwM9R1bu1es/xmbPINsmDteji6ePwtNDpIWPZlB8uVcULqQivB9Bl7c
         015TmrD9OcaL/kF0EGwxmWTxpFGBx1hNxs9EMvLq+axS6RI1hYWcGm7fL8iXSipaVV
         ogu+XoFx6KkHk9xja/W4nY3CT/9ku0YeRfQb2pCg=
Received: from localhost.localdomain (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: wgong@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D0210601D1;
        Fri,  1 Feb 2019 02:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548987460;
        bh=QeFRpfJFajDzigqfxS5d2WP6FiSe4fjrnPi3DE3UBus=;
        h=From:To:Cc:Subject:Date:From;
        b=dnViYRNLiOFwM9R1bu1es/xmbPINsmDteji6ePwtNDpIWPZlB8uVcULqQivB9Bl7c
         015TmrD9OcaL/kF0EGwxmWTxpFGBx1hNxs9EMvLq+axS6RI1hYWcGm7fL8iXSipaVV
         ogu+XoFx6KkHk9xja/W4nY3CT/9ku0YeRfQb2pCg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D0210601D1
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=wgong@codeaurora.org
From:   Wen Gong <wgong@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH] ath10k: reduce transmit msdu count
Date:   Fri,  1 Feb 2019 10:17:09 +0800
Message-Id: <1548987429-14008-1-git-send-email-wgong@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Alagu Sankar <alagusankar@silex-india.com>

Reduce the transmit MSDU count for SDIO, to match with the descriptors
as used by the firmware. This also acts as a high watermark level for
transmit. Too many packets to the firmware results in transmit overflow
interrupt.

It only affect SDIO chip, it will not cause functionaly changes to
other hardware.

Tested with QCA6174 SDIO with firmware
WLAN.RMH.4.4.1-00005-QCARMSWP-1.

Signed-off-by: Alagu Sankar <alagusankar@silex-india.com>
Signed-off-by: Wen Gong <wgong@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/core.c    | 6 +++++-
 drivers/net/wireless/ath/ath10k/hw.h      | 1 +
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 2 +-
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 22cbe9a..fee4ec1 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2309,7 +2309,11 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 		ar->max_num_stations = TARGET_TLV_NUM_STATIONS;
 		ar->max_num_vdevs = TARGET_TLV_NUM_VDEVS;
 		ar->max_num_tdls_vdevs = TARGET_TLV_NUM_TDLS_VDEVS;
-		ar->htt.max_num_pending_tx = TARGET_TLV_NUM_MSDU_DESC;
+		if (ar->hif.bus == ATH10K_BUS_SDIO)
+			ar->htt.max_num_pending_tx =
+				TARGET_TLV_NUM_MSDU_DESC_HL;
+		else
+			ar->htt.max_num_pending_tx = TARGET_TLV_NUM_MSDU_DESC;
 		ar->wow.max_num_patterns = TARGET_TLV_NUM_WOW_PATTERNS;
 		ar->fw_stats_req_mask = WMI_STAT_PDEV | WMI_STAT_VDEV |
 			WMI_STAT_PEER;
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 1b5da27..c012523 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -724,6 +724,7 @@ struct ath10k_hw_ops {
 #define TARGET_TLV_NUM_TDLS_VDEVS		1
 #define TARGET_TLV_NUM_TIDS			((TARGET_TLV_NUM_PEERS) * 2)
 #define TARGET_TLV_NUM_MSDU_DESC		(1024 + 32)
+#define TARGET_TLV_NUM_MSDU_DESC_HL		64
 #define TARGET_TLV_NUM_WOW_PATTERNS		22
 #define TARGET_TLV_MGMT_NUM_MSDU_DESC		(50)
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index ad4114a..35fb852 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -1611,7 +1611,7 @@ static struct sk_buff *ath10k_wmi_tlv_op_gen_init(struct ath10k *ar)
 	cfg->rx_skip_defrag_timeout_dup_detection_check = __cpu_to_le32(0);
 	cfg->vow_config = __cpu_to_le32(0);
 	cfg->gtk_offload_max_vdev = __cpu_to_le32(2);
-	cfg->num_msdu_desc = __cpu_to_le32(TARGET_TLV_NUM_MSDU_DESC);
+	cfg->num_msdu_desc = __cpu_to_le32(ar->htt.max_num_pending_tx);
 	cfg->max_frag_entries = __cpu_to_le32(2);
 	cfg->num_tdls_vdevs = __cpu_to_le32(TARGET_TLV_NUM_TDLS_VDEVS);
 	cfg->num_tdls_conn_table_entries = __cpu_to_le32(0x20);
-- 
1.9.1

