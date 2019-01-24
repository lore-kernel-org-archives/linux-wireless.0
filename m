Return-Path: <SRS0=rH0W=QA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A267C282C3
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jan 2019 14:21:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D5DB21872
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jan 2019 14:21:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="CCkFFFFS";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="FRsZ6lQG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbfAXOVv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 24 Jan 2019 09:21:51 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:37578 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727694AbfAXOVv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Jan 2019 09:21:51 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 34BCC608CD; Thu, 24 Jan 2019 14:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548339710;
        bh=W7hRTUMp+hnIdJaY6kbEOpeZHJOeQ9yk6RHZ5g6EGu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CCkFFFFSoCjET5fG2C8S2KAuCktLA7yN+Ix6s2ejRcQDLS4igso8lAj7p48SiDQ1K
         jCrO8+wKiq43oshirjKZHyHEME9DSA02B2i+4PYQcDy4CJEq1sCbk7i5bi4bU7eUdO
         lxldyUULkLQhiToKdpAVdE60kclRhI0NdzsyzrfY=
Received: from aambure-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: aambure@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 60305608CD;
        Thu, 24 Jan 2019 14:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548339708;
        bh=W7hRTUMp+hnIdJaY6kbEOpeZHJOeQ9yk6RHZ5g6EGu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FRsZ6lQGvE5ERThjzeplHHTHk6tpr3q9xxLLjiHhHga1s5BGosmxGx/vBG1rBxoIU
         fJCypYFPkjeIlLQi4vRvpNJMRkwKliVdKNorUflmIpRtnVAyBvXBM2WuoRrjz08iRU
         mrxlyGJaHTakkkovFvG+E0M4l6wQJSF/CKUBikm0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 60305608CD
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=aambure@codeaurora.org
From:   Abhishek Ambure <aambure@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Abhishek Ambure <aambure@codeaurora.org>
Subject: [PATCH 1/2] ath10k: Assign 'n_cipher_suites = 11' for WCN3990 to enable WPA3
Date:   Thu, 24 Jan 2019 19:51:36 +0530
Message-Id: <1548339697-17766-2-git-send-email-aambure@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1548339697-17766-1-git-send-email-aambure@codeaurora.org>
References: <1548339697-17766-1-git-send-email-aambure@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hostapd uses CCMP, GCMP & GCMP-256 as 'wpa_pairwise' option to run WPA3.
In WCN3990 firmware cipher suite numbers 9 to 11 are for CCMP,
GCMP & GCMP-256.

To enable CCMP, GCMP & GCMP-256 cipher suites in WCN3990 firmware,
host sets 'n_cipher_suites = 11' while initializing hardware parameters.

Tested HW: WCN3990
Tested FW: WLAN.HL.2.0-01188-QCAHLSWMTPLZ-1

Signed-off-by: Abhishek Ambure <aambure@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 399b501f..6f37d0d 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -571,6 +571,7 @@
 		.rri_on_ddr = true,
 		.hw_filter_reset_required = false,
 		.fw_diag_ce_download = false,
+		.n_cipher_suites = 11,
 	},
 };
 
-- 
1.9.1

