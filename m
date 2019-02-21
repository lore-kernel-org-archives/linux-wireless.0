Return-Path: <SRS0=z+ld=Q4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 058D9C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 16:22:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C706520836
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 16:22:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="iYQpX4n+";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="KXqHF0yB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbfBUQWL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Feb 2019 11:22:11 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:59112 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbfBUQWK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Feb 2019 11:22:10 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1310360F35; Thu, 21 Feb 2019 16:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550766129;
        bh=DDs6j/F8yOv6tSIvgbDGoBA8/v5XDogrxOMJI3Vq3IU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iYQpX4n+n4GwMYotrGUq8VShQHDvDNot8YjfoRL6aR1GIIWBXw7bqgZ7+IkYy2VsA
         QVkPkC5FrqaOSvLeD0pm/dAxR5dFuzCBFI+th2OBE91TWhc1G2e+HNFWy0r7LBZIFl
         2Ss6V0Kd8adYefeNKJ7TuKyRiEGTyF7IHomhYrT0=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5FC9360F2F;
        Thu, 21 Feb 2019 16:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550766127;
        bh=DDs6j/F8yOv6tSIvgbDGoBA8/v5XDogrxOMJI3Vq3IU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KXqHF0yB1TEvgJ7QMeUnLY1wdGWZfoDfoNSPtZGvGQrX16uMObk9ydTBMS3MX/5mC
         dDL0A6TY0CN4mROX+CHmaU7IJFMUd8ovcB/uOGc8eSJ7BWeLRRNOA2haSyr7BB5PqO
         k7t0u4oCl7tAPFnnWqsURoZfP6W/6tnGK0f3D9To=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5FC9360F2F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, Wen Gong <wgong@codeaurora.org>
Subject: [PATCH 3/4] ath10k: sdio: reset chip on power_down()
Date:   Thu, 21 Feb 2019 18:21:57 +0200
Message-Id: <1550766118-31703-4-git-send-email-kvalo@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1550766118-31703-1-git-send-email-kvalo@codeaurora.org>
References: <1550766118-31703-1-git-send-email-kvalo@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Wen Gong <wgong@codeaurora.org>

The target device needs to be reset during power_down(), otherwise only the
first power_up() will work. And as ath10k calls power_up() during driver
initialisation the driver would be otherwise unusable.

Tested with QCA6174 SDIO with firmware WLAN.RMH.4.4.1-00005-QCARMSWP-1.

Signed-off-by: Wen Gong <wgong@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/sdio.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
index d62502f386f2..fae56c67766f 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -1382,6 +1382,12 @@ static int ath10k_sdio_hif_power_up(struct ath10k *ar,
 
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "sdio power on\n");
 
+	ret = ath10k_sdio_config(ar);
+	if (ret) {
+		ath10k_err(ar, "failed to config sdio: %d\n", ret);
+		return ret;
+	}
+
 	sdio_claim_host(func);
 
 	ret = sdio_enable_func(func);
@@ -1419,11 +1425,19 @@ static void ath10k_sdio_hif_power_down(struct ath10k *ar)
 
 	/* Disable the card */
 	sdio_claim_host(ar_sdio->func);
+
 	ret = sdio_disable_func(ar_sdio->func);
-	sdio_release_host(ar_sdio->func);
+	if (ret) {
+		ath10k_warn(ar, "unable to disable sdio function: %d\n", ret);
+		sdio_release_host(ar_sdio->func);
+		return;
+	}
 
+	ret = mmc_hw_reset(ar_sdio->func->card->host);
 	if (ret)
-		ath10k_warn(ar, "unable to disable sdio function: %d\n", ret);
+		ath10k_warn(ar, "unable to reset sdio: %d\n", ret);
+
+	sdio_release_host(ar_sdio->func);
 
 	ar_sdio->is_disabled = true;
 }
@@ -2028,12 +2042,6 @@ static int ath10k_sdio_probe(struct sdio_func *func,
 
 	ath10k_sdio_set_mbox_info(ar);
 
-	ret = ath10k_sdio_config(ar);
-	if (ret) {
-		ath10k_err(ar, "failed to config sdio: %d\n", ret);
-		goto err_free_wq;
-	}
-
 	bus_params.dev_type = ATH10K_DEV_TYPE_HL;
 	/* TODO: don't know yet how to get chip_id with SDIO */
 	bus_params.chip_id = 0;
-- 
2.7.4

