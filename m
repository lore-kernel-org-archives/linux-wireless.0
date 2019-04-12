Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3514AC10F0E
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 13:28:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0160D2084D
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 13:28:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YtvbuusJ";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="CBweQumd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbfDLN2V (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Apr 2019 09:28:21 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:40584 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726244AbfDLN2V (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Apr 2019 09:28:21 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 56B64616B9; Fri, 12 Apr 2019 13:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555075700;
        bh=tvoPqiI+paUAOLZVilty2/u/V2VPLMMSzI9QUfRvf1A=;
        h=Subject:From:To:Cc:Date:From;
        b=YtvbuusJBjFwKYni3pKs/U6x+hhvHr/0cJzYMSKanGvRzrQIFyDx8FvoDgq7Gn22D
         WUF30OSLDz27AbBp75Ju42dOPGqUswm0KWJgCgsUVYOrUfe5JWtdV+V2eRqA9ttCnk
         W364nZvPIhfz3H1MaLEh68CqhqZiNUNR5r+jxaYw=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 239386119E;
        Fri, 12 Apr 2019 13:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555075699;
        bh=tvoPqiI+paUAOLZVilty2/u/V2VPLMMSzI9QUfRvf1A=;
        h=Subject:From:To:Cc:Date:From;
        b=CBweQumdAM3gBr0dIb/2CnW/VhAWIItQtRtQXHq5QXytP1t8rNJM39jDrU2cZe01E
         Emp3rVS5bdh/ec7pHw1bqeThGxSHSsbT+3NhUy2imNS5xvQgwFLOBP1PbUexiWhgh6
         ZyXW4K8mlubTuW9CKbwEpJaL4bL2VI7sfMdVkLx4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 239386119E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Subject: [PATCH 1/6] ath10k: sdio: workaround firmware UART pin
 configuration bug
From:   Kalle Valo <kvalo@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 12 Apr 2019 16:28:17 +0300
Message-ID: <155507569645.32018.15231567732563770250.stgit@potku.adurom.net>
User-Agent: StGit/0.17.1-17-ge4e0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Wen Gong <wgong@codeaurora.org>

On QCA6174 SDIO devices the SDIO interrupt will fail if UART is
disabled from ath10k. SDIO firmware enables UART printouts by
default. If ath10k will try to enable UART again the firmware
will configure it's GPIO line incorrectly and SDIO interrupts
won't work anymore. The workaround is to set UART pin again (19
for QCA6174 SDIO) if uart_print is 0.

Tested with QCA6174 SDIO with firmware WLAN.RMH.4.4.1-00007-QCARMSWP-1.

Signed-off-by: Wen Gong <wgong@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/core.c |   10 +++++++++-
 drivers/net/wireless/ath/ath10k/hw.h   |    5 +++++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 835b8de92d55..cfd7bb29a1ec 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2065,8 +2065,16 @@ static int ath10k_init_uart(struct ath10k *ar)
 		return ret;
 	}
 
-	if (!uart_print)
+	if (!uart_print && ar->hw_params.uart_pin_workaround) {
+		ret = ath10k_bmi_write32(ar, hi_dbg_uart_txpin,
+					 ar->hw_params.uart_pin);
+		if (ret) {
+			ath10k_warn(ar, "failed to set UART TX pin: %d", ret);
+			return ret;
+		}
+
 		return 0;
+	}
 
 	ret = ath10k_bmi_write32(ar, hi_dbg_uart_txpin, ar->hw_params.uart_pin);
 	if (ret) {
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 71314999aa24..a92fce1bb6f0 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -606,6 +606,11 @@ struct ath10k_hw_params {
 
 	/* target supporting fw download via diag ce */
 	bool fw_diag_ce_download;
+
+	/* need to set uart pin if disable uart print, workaround for a
+	 * firmware bug
+	 */
+	bool uart_pin_workaround;
 };
 
 struct htt_rx_desc;

