Return-Path: <SRS0=cSSL=QN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 479CDC282CC
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 12:14:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 159A92073D
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 12:14:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="NbnvUF/R";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="lCI9kae8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729883AbfBFMOy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Feb 2019 07:14:54 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:40148 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726957AbfBFMOy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Feb 2019 07:14:54 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id F07CB602CC; Wed,  6 Feb 2019 12:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549455293;
        bh=/nRid3yHLDg30Gwil/kLAeJdUVQULE5g5jP/kGRXhGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NbnvUF/RBRlxfnFEAFLTh+sAoPOkCW/P77GXRnhUcDE7q5vBVxPLVqQJYlnKwIYAn
         l/3aIPW2BWKSmphjBwgibm+CxG/wRcTsZE3cK4w7j/K+yJU7wCNQtHnOCVKc6FknpW
         vhH2eUQg49dadMysF8DsFQD16Wtng+UQF25miW/k=
Received: from govinds-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: govinds@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 84D7B608EA;
        Wed,  6 Feb 2019 12:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549455291;
        bh=/nRid3yHLDg30Gwil/kLAeJdUVQULE5g5jP/kGRXhGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lCI9kae8Ik4KeTQQfvndV66D57jv8YC+811OU0NRzitO38MLWIp9/NdNpHt9Y8C25
         HneMPGSbTagaMloiIAiO29z6hcrV0uTICK73hhGJzGQez/wVqXAkDQP1aeP7sOf8lI
         ftlhuJ9vmOgJ0Q8SfnWX/SyoRQKx9leX8rKszhzE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 84D7B608EA
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=govinds@codeaurora.org
From:   Govind Singh <govinds@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH v3 3/3] ath10k: Request credit report if flow control enabled on ep
Date:   Wed,  6 Feb 2019 17:44:33 +0530
Message-Id: <20190206121433.11606-4-govinds@codeaurora.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190206121433.11606-1-govinds@codeaurora.org>
References: <20190206121433.11606-1-govinds@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

FW credit flow control is enabled for only WMI ctrl
service(CE3) but credit update is requested unconditionally
on all HTC services as part of HTC tx in CE3/CE0/CE4.

This is causing WOW failure as FW is not expecting credit
report request on other end-points(CE0/CE4).

Request credit report only on those endpoints where
credit flow control is enabled.

Testing:
    Tested on WCN3990 HW.
    Tested FW: WLAN.HL.2.0-01192-QCAHLSWMTPLZ-1.

Signed-off-by: Govind Singh <govinds@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/htc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index 7654a21323ce..5aa57a01c033 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -88,7 +88,8 @@ static void ath10k_htc_prepare_tx_skb(struct ath10k_htc_ep *ep,
 	hdr->eid = ep->eid;
 	hdr->len = __cpu_to_le16(skb->len - sizeof(*hdr));
 	hdr->flags = 0;
-	hdr->flags |= ATH10K_HTC_FLAG_NEED_CREDIT_UPDATE;
+	if (ep->tx_credit_flow_enabled)
+		hdr->flags |= ATH10K_HTC_FLAG_NEED_CREDIT_UPDATE;
 
 	spin_lock_bh(&ep->htc->tx_lock);
 	hdr->seq_no = ep->seq_no++;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

