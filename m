Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5959DC43381
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Feb 2021 19:30:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 376BF60C3E
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Feb 2021 19:30:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233176AbhBVTaF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 22 Feb 2021 14:30:05 -0500
Received: from m42-2.mailgun.net ([69.72.42.2]:47657 "EHLO m42-2.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233321AbhBVT1v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Feb 2021 14:27:51 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1614022050; h=Content-Transfer-Encoding: MIME-Version:
 Message-Id: Date: Subject: Cc: To: From: Sender;
 bh=r5K63Go6dNwm808NunS14UEUj0MvExkwJGR/rs0kO7M=; b=kcwXzlNaMQT/oJQy11tOQj6CxaEdAdddcyGg3GL0uKGkkOfYCLRghShUGuoMl4b9vj++vK5B
 eovInlNqCeAFE5l+xt1pwthGzro4t4wSoUJ3bSC/WOxKt3vqrughuqOjMId0YyzTczFMlWEu
 Blq0mzmu/Xppu8UZfMqDyNJKd0o=
X-Mailgun-Sending-Ip: 69.72.42.2
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 60340584ba086638309f136c (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 22 Feb 2021 19:27:00
 GMT
Sender: alokad=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 03DD6C43462; Mon, 22 Feb 2021 19:27:00 +0000 (UTC)
Received: from alokad-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: alokad)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3B515C433CA;
        Mon, 22 Feb 2021 19:26:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3B515C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=alokad@codeaurora.org
From:   Aloka Dixit <alokad@codeaurora.org>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        Aloka Dixit <alokad@codeaurora.org>
Subject: [PATCH V5 0/2] WMI and debugfs calls for TWT dialogs
Date:   Mon, 22 Feb 2021 11:26:49 -0800
Message-Id: <20210222192651.1782-1-alokad@codeaurora.org>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This patchset adds support for TWT dialogs using debugfs.
Individual patch files show changes in V5.

John Crispin (2):
  ath11k: add WMI calls to manually add/del/pause/resume TWT dialogs
  ath11k: add debugfs for TWT debug calls

 drivers/net/wireless/ath/ath11k/core.h  |   4 +
 drivers/net/wireless/ath/ath11k/debug.c | 224 ++++++++++++++++++++++++
 drivers/net/wireless/ath/ath11k/debug.h |  13 ++
 drivers/net/wireless/ath/ath11k/mac.c   |   3 +
 drivers/net/wireless/ath/ath11k/wmi.c   | 218 ++++++++++++++++++++++-
 drivers/net/wireless/ath/ath11k/wmi.h   | 114 ++++++++++++
 6 files changed, 572 insertions(+), 4 deletions(-)


base-commit: f5242d42da02730c67d517a7402015c13f59deee
-- 
2.25.0

