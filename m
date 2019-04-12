Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B22E9C10F0E
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 13:28:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 738C42084D
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 13:28:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="UZX+D5wT";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="UZX+D5wT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbfDLN23 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Apr 2019 09:28:29 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:40792 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726244AbfDLN23 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Apr 2019 09:28:29 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id BF4A06119E; Fri, 12 Apr 2019 13:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555075708;
        bh=seCpOX84YkfMOHkLN7YFEyuxFmwnd9K2haUTClSZ9Gk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=UZX+D5wTcaOzEVEj48GCb0eM9F3CVU5ytqkEQ228KMXA4wgRpsbZqi4+bHXHPrWZI
         z9rcrsLI6NPj39oKks7hqzyCyGbG5qo+69JEuaM6KWfeOucv0EGu/NoABGE/ZDW0cN
         b3aoZ4BUUiomw6ZN0Nssff1LJU/Mhp7BAVcwBRVk=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CE0B4616B8;
        Fri, 12 Apr 2019 13:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555075708;
        bh=seCpOX84YkfMOHkLN7YFEyuxFmwnd9K2haUTClSZ9Gk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=UZX+D5wTcaOzEVEj48GCb0eM9F3CVU5ytqkEQ228KMXA4wgRpsbZqi4+bHXHPrWZI
         z9rcrsLI6NPj39oKks7hqzyCyGbG5qo+69JEuaM6KWfeOucv0EGu/NoABGE/ZDW0cN
         b3aoZ4BUUiomw6ZN0Nssff1LJU/Mhp7BAVcwBRVk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CE0B4616B8
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Subject: [PATCH 2/6] ath10k: don't disable interrupts in ath10k_sdio_remove()
From:   Kalle Valo <kvalo@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 12 Apr 2019 16:28:25 +0300
Message-ID: <155507570518.32018.13698324211799701564.stgit@potku.adurom.net>
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

From: Wen Gong <wgong@codeaurora.org>

Disabling interrupts this early meant WMI communication was not working anymore
when the SDIO device was removed. But we call ath10k_core_unregister() that
will eventually call ath10k_sdio_hif_stop(), which disables the interrupts. So
there's actually no need to disable interrupts here.

Also remove cancel_work_sync() as it's also called in ath10k_sdio_hif_stop().

Tested with QCA6174 SDIO with firmware WLAN.RMH.4.4.1-00007-QCARMSWP-1.

Signed-off-by: Wen Gong <wgong@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/sdio.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
index fae56c67766f..d573d24624c0 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -2073,8 +2073,6 @@ static void ath10k_sdio_remove(struct sdio_func *func)
 		   "sdio removed func %d vendor 0x%x device 0x%x\n",
 		   func->num, func->vendor, func->device);
 
-	(void)ath10k_sdio_hif_disable_intrs(ar);
-	cancel_work_sync(&ar_sdio->wr_async_work);
 	ath10k_core_unregister(ar);
 	ath10k_core_destroy(ar);
 }

