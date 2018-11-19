Return-Path: <SRS0=j5ME=N6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 070A3C43441
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Nov 2018 11:30:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE96520823
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Nov 2018 11:30:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="FA1esy6o";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="FA1esy6o"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BE96520823
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728638AbeKSVyN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 19 Nov 2018 16:54:13 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:54360 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728531AbeKSVyM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Nov 2018 16:54:12 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E2E586022B; Mon, 19 Nov 2018 11:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542627051;
        bh=TzkWu1pZajXKGzaNZ8JAYGUJZazCgRZF/09f2wVT25g=;
        h=From:To:Cc:Subject:Date:From;
        b=FA1esy6okVRG6Y2HXe8eDpjrIEtRRLqIivsPHw85Oa2D1p9EAQkdDzx5L/jTfm/gr
         kN/Ibqm4th5XeGH64RaAtzW4BASzh6F03jPFfLt2BHfwzh1PHSTNkseL0SP70c9znh
         TcXzwcRVTtEn1uHpEcRbNkNN2Zz6F1dcmA4brwUw=
Received: from govinds-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: govinds@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3E2E460B11;
        Mon, 19 Nov 2018 11:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542627051;
        bh=TzkWu1pZajXKGzaNZ8JAYGUJZazCgRZF/09f2wVT25g=;
        h=From:To:Cc:Subject:Date:From;
        b=FA1esy6okVRG6Y2HXe8eDpjrIEtRRLqIivsPHw85Oa2D1p9EAQkdDzx5L/jTfm/gr
         kN/Ibqm4th5XeGH64RaAtzW4BASzh6F03jPFfLt2BHfwzh1PHSTNkseL0SP70c9znh
         TcXzwcRVTtEn1uHpEcRbNkNN2Zz6F1dcmA4brwUw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3E2E460B11
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=govinds@codeaurora.org
From:   Govind Singh <govinds@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH] ath10k: Remove work in progress logs from snoc driver
Date:   Mon, 19 Nov 2018 17:00:40 +0530
Message-Id: <20181119113040.23294-1-govinds@codeaurora.org>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

All the necessary patches to make wifi running (over SNOC)
are merged and tested on SDM845/QCS404 platform with WCN3990
wifi module, hence remove work in progress debug from snoc
driver and Kconfig.

Signed-off-by: Govind Singh <govinds@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/Kconfig | 3 +--
 drivers/net/wireless/ath/ath10k/snoc.c  | 1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/Kconfig b/drivers/net/wireless/ath/ath10k/Kconfig
index e1ad6b9166a6..a7fb5441ced4 100644
--- a/drivers/net/wireless/ath/ath10k/Kconfig
+++ b/drivers/net/wireless/ath/ath10k/Kconfig
@@ -47,8 +47,7 @@ config ATH10K_SNOC
 	select QCOM_QMI_HELPERS
 	---help---
 	  This module adds support for integrated WCN3990 chip connected
-	  to system NOC(SNOC). Currently work in progress and will not
-	  fully work.
+	  to system NOC(SNOC).
 
 config ATH10K_DEBUG
 	bool "Atheros ath10k debugging"
diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index 98724d04baef..eda4a6b80e47 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -1633,7 +1633,6 @@ static int ath10k_snoc_probe(struct platform_device *pdev)
 	}
 
 	ath10k_dbg(ar, ATH10K_DBG_SNOC, "snoc probe\n");
-	ath10k_warn(ar, "Warning: SNOC support is still work-in-progress, it will not work properly!");
 
 	return 0;
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

