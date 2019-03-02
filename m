Return-Path: <SRS0=UNZO=RF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAFD1C43381
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Mar 2019 04:36:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8AB4A20857
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Mar 2019 04:36:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="VQOBf4Q0";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="mU2kXr1O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727420AbfCBEgN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Mar 2019 23:36:13 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:56842 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726693AbfCBEgN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Mar 2019 23:36:13 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9CA2060FF3; Sat,  2 Mar 2019 04:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551501372;
        bh=IsECEzFGbkKwZ+Lyz6pa3AMxPwQvDiO9kddPI3C8uLI=;
        h=From:To:Cc:Subject:Date:From;
        b=VQOBf4Q030FSdoWXxE+I9OYNuJQxc1e/MCkbO8gg8KdYZK6HuIKYIZ3lN6Ldmbw6i
         +xOzzDLcGP+SFshInmwxhJyhrGKI6JELSE4+4kjdKYuCK6+XiWEsvaPQvZNncuKYZ8
         aDpQFDCMfGHxgCOf4ldcSzD1yugao2cZuMfQFp/8=
Received: from govinds-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: govinds@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9CD7960316;
        Sat,  2 Mar 2019 04:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551501371;
        bh=IsECEzFGbkKwZ+Lyz6pa3AMxPwQvDiO9kddPI3C8uLI=;
        h=From:To:Cc:Subject:Date:From;
        b=mU2kXr1OuFnYyKk/hOb266KJHEgbZ0pP2/GjGsuN6sHNLYP68dUCURPXJavjwh3al
         56xyuuirWq3UPPnuGrMtpwkcF6SNZUzbG7oduW/a/dnuS4Cgr0dWYel4LCcPDCoY88
         OV5gGNxMCxOjAUnx7UMHI88OlU9/gWTL+47F4nvg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9CD7960316
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=govinds@codeaurora.org
From:   Govind Singh <govinds@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH] ath10k: Modify CE4 src buffer entries to 2048 for WCN3990
Date:   Sat,  2 Mar 2019 10:06:05 +0530
Message-Id: <20190302043605.27626-1-govinds@codeaurora.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

CE4 is host to target HTT tx pipe, tx completion are not served
on time when CPU is loaded and this cause ce src ring full condition
due to less no of src buffer entries.

To mitigate the issue increase CE4 src buffer entries to 2048.

Testing:
        Tested on QCS404 platform(WCN3990 HW)
        Tested FW: WLAN.HL.3.1-00784-QCAHLSWMTPLZ-1

Signed-off-by: Govind Singh <govinds@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/snoc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index 7fa0f5c1d070..f0ea3c494fe6 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -176,7 +176,7 @@ static struct ce_attr host_ce_config_wlan[] = {
 	/* CE4: host->target HTT */
 	{
 		.flags = CE_ATTR_FLAGS | CE_ATTR_DIS_INTR,
-		.src_nentries = 256,
+		.src_nentries = 2048,
 		.src_sz_max = 256,
 		.dest_nentries = 0,
 		.send_cb = ath10k_snoc_htt_tx_cb,
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

