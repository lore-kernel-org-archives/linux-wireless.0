Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8D38C10F0E
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 13:28:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 768542084D
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 13:28:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="htyoHRAD";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="htyoHRAD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbfDLN2i (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Apr 2019 09:28:38 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:41032 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726770AbfDLN2i (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Apr 2019 09:28:38 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id AFC9061544; Fri, 12 Apr 2019 13:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555075717;
        bh=IOnC3d2srXx6IX8l6BUh1Xet/IovSgBdXNg3n8N/F3A=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=htyoHRADmqfdZ8aZ1/hGaFajDx6b2RifeRYt//5PA96Lrtzc239GFllt/lGZ2xfr+
         ulA8AFOgQtrnLDghyhEwjR+/TdpuGQeoOInGhX/APihgQ0zLiMj5aUIg3Xs1dwg/fJ
         CUTLEwQE9mU7LMXy5XdrklZ6vgCgwqNoaCA9v4uI=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7977461544;
        Fri, 12 Apr 2019 13:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555075717;
        bh=IOnC3d2srXx6IX8l6BUh1Xet/IovSgBdXNg3n8N/F3A=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=htyoHRADmqfdZ8aZ1/hGaFajDx6b2RifeRYt//5PA96Lrtzc239GFllt/lGZ2xfr+
         ulA8AFOgQtrnLDghyhEwjR+/TdpuGQeoOInGhX/APihgQ0zLiMj5aUIg3Xs1dwg/fJ
         CUTLEwQE9mU7LMXy5XdrklZ6vgCgwqNoaCA9v4uI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7977461544
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Subject: [PATCH 3/6] ath10k: htt: don't use txdone_fifo with SDIO
From:   Kalle Valo <kvalo@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 12 Apr 2019 16:28:34 +0300
Message-ID: <155507571386.32018.4599069777915701774.stgit@potku.adurom.net>
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

HTT High Latency (ATH10K_DEV_TYPE_HL) does not use txdone_fifo at all, we don't
even initialise it by skipping ath10k_htt_tx_alloc_buf() in
ath10k_htt_tx_start(). Because of this using QCA6174 SDIO
ath10k_htt_rx_tx_compl_ind() will crash when it accesses unitialised
txdone_fifo. So skip txdone_fifo when using High Latency mode.

Tested with QCA6174 SDIO with firmware WLAN.RMH.4.4.1-00007-QCARMSWP-1.

Co-developed-by: Wen Gong <wgong@codeaurora.org>
Signed-off-by: Alagu Sankar <alagusankar@silex-india.com>
Signed-off-by: Wen Gong <wgong@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index a20ea270d519..8d13d0c3e85e 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2277,7 +2277,9 @@ static void ath10k_htt_rx_tx_compl_ind(struct ath10k *ar,
 		 *  Note that with only one concurrent reader and one concurrent
 		 *  writer, you don't need extra locking to use these macro.
 		 */
-		if (!kfifo_put(&htt->txdone_fifo, tx_done)) {
+		if (ar->bus_param.dev_type == ATH10K_DEV_TYPE_HL) {
+			ath10k_txrx_tx_unref(htt, &tx_done);
+		} else if (!kfifo_put(&htt->txdone_fifo, tx_done)) {
 			ath10k_warn(ar, "txdone fifo overrun, msdu_id %d status %d\n",
 				    tx_done.msdu_id, tx_done.status);
 			ath10k_txrx_tx_unref(htt, &tx_done);

