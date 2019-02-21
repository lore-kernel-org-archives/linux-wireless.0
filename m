Return-Path: <SRS0=z+ld=Q4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AC32C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 16:22:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19A7920836
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 16:22:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="VKY8T1JG";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="PNdtqHKP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbfBUQWG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Feb 2019 11:22:06 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:58946 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbfBUQWG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Feb 2019 11:22:06 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id EDC3260ECC; Thu, 21 Feb 2019 16:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550766125;
        bh=x6mbtZLchhAtSgSgjExPChUEXfr4Yx6kSSB2wPccl50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VKY8T1JGGQ+id/sBX3erarGKYR4lrRGKGgzspDNBJ3MMup2ki0DXCNcHxn6y5jrfo
         TyO2vWdFoUtsMGcJaYMI1nexpTwPYJOqOk21MvoXVSy6jqMVMYAq/+NsgHY5w0HerP
         cJ6bNxTTaVbXn95H7oXjafuYii9S36dwErAL90Eo=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 91CBA60EC1;
        Thu, 21 Feb 2019 16:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550766124;
        bh=x6mbtZLchhAtSgSgjExPChUEXfr4Yx6kSSB2wPccl50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PNdtqHKPgBy2C+Nqmu5f3gzo6bW7NCv4NH/zHAAOytuYC6MdkrLTb63HthNX3cmjA
         AprHaKPhiAjcJF6CQfh64PC0/jLZ7JqlIP8wnfuAB2122MDS7EWxrxQLfdlgg+amHF
         UGsfnB7PS+cYt/BXMABMKdk8NUh5GFEtYRfr9QVI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 91CBA60EC1
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Alagu Sankar <alagusankar@silex-india.com>,
        Wen Gong <wgong@codeaurora.org>
Subject: [PATCH 1/4] ath10k: sdio: set hi_acs_flags
Date:   Thu, 21 Feb 2019 18:21:55 +0200
Message-Id: <1550766118-31703-2-git-send-email-kvalo@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1550766118-31703-1-git-send-email-kvalo@codeaurora.org>
References: <1550766118-31703-1-git-send-email-kvalo@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Alagu Sankar <alagusankar@silex-india.com>

The SDIO firmware does not allow transmitting packets with the
reduced tx completion HI_ACS option. SDIO firmware uses 1544 as
alternate credit size, which is not big enough for the maximum sized
mac80211 frames. Disable both these HI_ACS flags for SDIO.

Co-developed-by: Wen Gong <wgong@codeaurora.org>
Signed-off-by: Alagu Sankar <alagusankar@silex-india.com>
Signed-off-by: Wen Gong <wgong@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/core.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index ac2cf3f1c7b4..0c62a61b5eac 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -637,10 +637,16 @@ static void ath10k_init_sdio(struct ath10k *ar)
 	ath10k_bmi_write32(ar, hi_mbox_isr_yield_limit, 99);
 	ath10k_bmi_read32(ar, hi_acs_flags, &param);
 
-	param |= (HI_ACS_FLAGS_SDIO_SWAP_MAILBOX_SET |
-		  HI_ACS_FLAGS_SDIO_REDUCE_TX_COMPL_SET |
-		  HI_ACS_FLAGS_ALT_DATA_CREDIT_SIZE);
+	/* Data transfer is not initiated, when reduced Tx completion
+	 * is used for SDIO. disable it until fixed
+	 */
+	param &= ~HI_ACS_FLAGS_SDIO_REDUCE_TX_COMPL_SET;
 
+	/* Alternate credit size of 1544 as used by SDIO firmware is
+	 * not big enough for mac80211 / native wifi frames. disable it
+	 */
+	param &= ~HI_ACS_FLAGS_ALT_DATA_CREDIT_SIZE;
+	param |= HI_ACS_FLAGS_SDIO_SWAP_MAILBOX_SET;
 	ath10k_bmi_write32(ar, hi_acs_flags, param);
 }
 
-- 
2.7.4

