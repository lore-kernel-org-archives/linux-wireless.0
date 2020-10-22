Return-Path: <SRS0=OSQK=D5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 800ACC388F7
	for <linux-wireless@archiver.kernel.org>; Thu, 22 Oct 2020 03:59:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20B0F21D6C
	for <linux-wireless@archiver.kernel.org>; Thu, 22 Oct 2020 03:59:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="pzzWGEL7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895621AbgJVD7x (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 21 Oct 2020 23:59:53 -0400
Received: from m42-4.mailgun.net ([69.72.42.4]:44999 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2895619AbgJVD7x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Oct 2020 23:59:53 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1603339192; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=V5Nowh5ES0WneN2KeZjwroeiToLSj7SLhntMCc2Rrtc=; b=pzzWGEL7bxDBs2Opip+ITfRwcS0LNtbRM6EKk+WJjm1WhWJRn6gKTehJZ0hUcla9mvGxWIhr
 6vMSvnD1iKQXF8UgMXvyuKVU3QBIfAWBr3f2AqMpgRVWnXe816YeY8n1dTLNuftM7C0Jss0/
 w9X2uhmze/OiGdG7R8JHcqs6sag=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 5f9103b8d63768e57b4593c7 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 22 Oct 2020 03:59:52
 GMT
Sender: govinds=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id AFC84C433F0; Thu, 22 Oct 2020 03:59:51 +0000 (UTC)
Received: from dundi-linux.qualcomm.com (unknown [202.46.22.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: govinds)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E40AFC433C9;
        Thu, 22 Oct 2020 03:59:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E40AFC433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=govinds@codeaurora.org
From:   Govind Singh <govinds@codeaurora.org>
To:     ath11k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH] ath11k: Remove unused param from wmi_mgmt_params
Date:   Thu, 22 Oct 2020 09:29:35 +0530
Message-Id: <1603339175-12706-1-git-send-email-govinds@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

qdf_ctx is not used in wmi_mgmt_params, remove this
un-used variable.

Signed-off-by: Govind Singh <govinds@codeaurora.org>
---
 drivers/net/wireless/ath/ath11k/wmi.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/wmi.h b/drivers/net/wireless/ath/ath11k/wmi.h
index b9f3e559ced7..8256dc73a703 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.h
+++ b/drivers/net/wireless/ath/ath11k/wmi.h
@@ -3291,7 +3291,6 @@ struct wmi_mgmt_params {
 	void *pdata;
 	u16 desc_id;
 	u8 *macaddr;
-	void *qdf_ctx;
 };
 
 enum wmi_sta_ps_mode {
-- 
2.22.0

