Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50FAFC10F0E
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 13:29:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C1062084D
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 13:29:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="bopIppSR";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="EUqaYnFa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbfDLN27 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Apr 2019 09:28:59 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:41524 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726244AbfDLN26 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Apr 2019 09:28:58 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id CFE3B61576; Fri, 12 Apr 2019 13:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555075737;
        bh=FlyOxdMOUqS2MSAO8lUpqTf8ORaBoXHirFVY+/CUD2c=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bopIppSRAHyQ4YE/2WIBI190RP5hxuYzC6TWreks3tT4CBP3cF69yc/+7xptVemrV
         ZNUjzTIsDcml7rv0Q4ULAFXDHiNoOk4YivwwyO8KqfJBOUi/ejr7TvPSZejv1uny84
         q3usWXDaZNd+Ucqjkzm4stPSZESnTIKBFxTdCNoQ=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 448F16177C;
        Fri, 12 Apr 2019 13:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555075735;
        bh=FlyOxdMOUqS2MSAO8lUpqTf8ORaBoXHirFVY+/CUD2c=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EUqaYnFao1HHjtLSVs+Lq/UmV5JFehDwchDrLCgzQkh2xoD6m27Y61OPHFspEugz6
         873u5AC3ug83UU87D4e2ADfQXDFl63/lsU52+8wKg3Hdi2OFlhSPBg8hADO5f2/4dI
         WF0XY9RFMkw+MemerJv7kXEgTawMBsGwx4UvEXhg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 448F16177C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Subject: [PATCH 5/6] ath10k: htt: support MSDU ids with SDIO
From:   Kalle Valo <kvalo@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 12 Apr 2019 16:28:52 +0300
Message-ID: <155507573152.32018.18267130026274436463.stgit@potku.adurom.net>
In-Reply-To: <155507569645.32018.15231567732563770250.stgit@potku.adurom.net>
References: <155507569645.32018.15231567732563770250.stgit@potku.adurom.net>
User-Agent: StGit/0.17.1-17-ge4e0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Alagu Sankar <alagusankar@silex-india.com>

Transmit completion for SDIO is similar to PCIe, modify the high
latency path to allow SDIO modules to use the msdu id.

kvalo: the original patch from Alagu enabled this only for SDIO but I'm not
sure should we also enable this with USB. I'll use bus params to enable this
for so that it's easy to enable also for USB later.

Tested with QCA6174 SDIO with firmware WLAN.RMH.4.4.1-00007-QCARMSWP-1.

Co-developed-by: Wen Gong <wgong@codeaurora.org>
Signed-off-by: Alagu Sankar <alagusankar@silex-india.com>
Signed-off-by: Wen Gong <wgong@codeaurora.org>.
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/core.h   |    1 +
 drivers/net/wireless/ath/ath10k/htt_tx.c |   13 ++++++++++++-
 drivers/net/wireless/ath/ath10k/sdio.c   |    2 ++
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index e08a17b01e03..f22cb3f49034 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -919,6 +919,7 @@ struct ath10k_bus_params {
 	u32 chip_id;
 	enum ath10k_dev_type dev_type;
 	bool link_can_suspend;
+	bool hl_msdu_ids;
 };
 
 struct ath10k {
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index d8e9cc0bb772..88f880b601d8 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -1244,6 +1244,7 @@ static int ath10k_htt_tx_hl(struct ath10k_htt *htt, enum ath10k_hw_txrx_mode txm
 	u8 tid = ath10k_htt_tx_get_tid(msdu, is_eth);
 	u8 flags0 = 0;
 	u16 flags1 = 0;
+	u16 msdu_id = 0;
 
 	data_len = msdu->len;
 
@@ -1291,6 +1292,16 @@ static int ath10k_htt_tx_hl(struct ath10k_htt *htt, enum ath10k_hw_txrx_mode txm
 		}
 	}
 
+	if (ar->bus_param.hl_msdu_ids) {
+		flags1 |= HTT_DATA_TX_DESC_FLAGS1_POSTPONED;
+		res = ath10k_htt_tx_alloc_msdu_id(htt, msdu);
+		if (res < 0) {
+			ath10k_err(ar, "msdu_id allocation failed %d\n", res);
+			goto out;
+		}
+		msdu_id = res;
+	}
+
 	skb_push(msdu, sizeof(*cmd_hdr));
 	skb_push(msdu, sizeof(*tx_desc));
 	cmd_hdr = (struct htt_cmd_hdr *)msdu->data;
@@ -1300,7 +1311,7 @@ static int ath10k_htt_tx_hl(struct ath10k_htt *htt, enum ath10k_hw_txrx_mode txm
 	tx_desc->flags0 = flags0;
 	tx_desc->flags1 = __cpu_to_le16(flags1);
 	tx_desc->len = __cpu_to_le16(data_len);
-	tx_desc->id = 0;
+	tx_desc->id = __cpu_to_le16(msdu_id);
 	tx_desc->frags_paddr = 0; /* always zero */
 	/* Initialize peer_id to INVALID_PEER because this is NOT
 	 * Reinjection path
diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
index bbfdc4d7cf5f..d5073fac9509 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -2045,6 +2045,8 @@ static int ath10k_sdio_probe(struct sdio_func *func,
 	bus_params.dev_type = ATH10K_DEV_TYPE_HL;
 	/* TODO: don't know yet how to get chip_id with SDIO */
 	bus_params.chip_id = 0;
+	bus_params.hl_msdu_ids = true;
+
 	ret = ath10k_core_register(ar, &bus_params);
 	if (ret) {
 		ath10k_err(ar, "failed to register driver core: %d\n", ret);

