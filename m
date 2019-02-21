Return-Path: <SRS0=z+ld=Q4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3216FC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 16:22:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 027F920836
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 16:22:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="UY976z24";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="b1lyMzWo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbfBUQWI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Feb 2019 11:22:08 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:59022 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbfBUQWH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Feb 2019 11:22:07 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B9C4E60EC1; Thu, 21 Feb 2019 16:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550766126;
        bh=Aa/WMHHzXxuVrhxwrUzH4oZfZhzhOm9of7SGso60Otw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UY976z24LrCgUgTR1xnin72RXBua8ZYntwKb+3FY5+xcSbTz3mk8IZ+JMFYh6kBQU
         Tmn+bMZugmRTYlGcEBra0quSGuFYm/FvQeLsMQd0pDj5amLGGca8WzauaGQwJka5E2
         J18f6VNg5YDwCtB4r9imX/LnMGOAbv//Uj8u2OpY=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8716560C04;
        Thu, 21 Feb 2019 16:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550766125;
        bh=Aa/WMHHzXxuVrhxwrUzH4oZfZhzhOm9of7SGso60Otw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b1lyMzWoABo1byK6y6SENS5Ree4uk53sws8dDUudAlsOwKBx2Futv2j2gFjiIODMo
         bk78VlvXK2yGPDNeVQ4TgCTxUPHxtjuGiTFsgf75DG65tZwupKP+u10TgF/OrSvYMD
         BxiptBwe2DrstAG+TtNsgjo/oYgW5pHzvoI+jpg0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8716560C04
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Alagu Sankar <alagusankar@silex-india.com>,
        Wen Gong <wgong@codeaurora.org>
Subject: [PATCH 2/4] ath10k: sdio: disable fwlog prints
Date:   Thu, 21 Feb 2019 18:21:56 +0200
Message-Id: <1550766118-31703-3-git-send-email-kvalo@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1550766118-31703-1-git-send-email-kvalo@codeaurora.org>
References: <1550766118-31703-1-git-send-email-kvalo@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Alagu Sankar <alagusankar@silex-india.com>

The SDIO firmware may turn it on based on scratch registers so disable the
firmware log to avoid that.

Co-developed-by: Wen Gong <wgong@codeaurora.org>
Signed-off-by: Alagu Sankar <alagusankar@silex-india.com>
Signed-off-by: Wen Gong <wgong@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 0c62a61b5eac..7ccd6741c5b0 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -648,6 +648,13 @@ static void ath10k_init_sdio(struct ath10k *ar)
 	param &= ~HI_ACS_FLAGS_ALT_DATA_CREDIT_SIZE;
 	param |= HI_ACS_FLAGS_SDIO_SWAP_MAILBOX_SET;
 	ath10k_bmi_write32(ar, hi_acs_flags, param);
+
+	/* Explicitly set fwlog prints to zero as target may turn it on
+	 * based on scratch registers.
+	 */
+	ath10k_bmi_read32(ar, hi_option_flag, &param);
+	param |= HI_OPTION_DISABLE_DBGLOG;
+	ath10k_bmi_write32(ar, hi_option_flag, param);
 }
 
 static int ath10k_init_configure_target(struct ath10k *ar)
-- 
2.7.4

