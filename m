Return-Path: <SRS0=PZxT=RJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1191C43381
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Mar 2019 17:38:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3D04206DD
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Mar 2019 17:38:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Wil08v4y";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Wil08v4y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727157AbfCFRiI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Mar 2019 12:38:08 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:33676 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726180AbfCFRiI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Mar 2019 12:38:08 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id CC70F606DB; Wed,  6 Mar 2019 17:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551893887;
        bh=oxfyvz53D/OwmLxxx0L2okTfTNQ8JCNo+R6VZ9bnlaM=;
        h=From:To:Cc:Subject:Date:From;
        b=Wil08v4y/ISsH5nltah/hI3CMKmL3HRLckSbePEkvS9ovqp6tc1EggC0ueQjXNmFR
         ul9zluJnghzDl25ySkr3wUnm6ia+REtxsUF76cb+Uomm2ccN5lonHZKUWAM4dJjlJW
         +KjWH87rTioLst0pujBjDMQN3AJJ17lqNX8Wuq3M=
Received: from cheath10p342229-lin.qca.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: tamizhr@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2D8746072E;
        Wed,  6 Mar 2019 17:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551893887;
        bh=oxfyvz53D/OwmLxxx0L2okTfTNQ8JCNo+R6VZ9bnlaM=;
        h=From:To:Cc:Subject:Date:From;
        b=Wil08v4y/ISsH5nltah/hI3CMKmL3HRLckSbePEkvS9ovqp6tc1EggC0ueQjXNmFR
         ul9zluJnghzDl25ySkr3wUnm6ia+REtxsUF76cb+Uomm2ccN5lonHZKUWAM4dJjlJW
         +KjWH87rTioLst0pujBjDMQN3AJJ17lqNX8Wuq3M=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2D8746072E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=tamizhr@codeaurora.org
From:   Tamizh chelvam <tamizhr@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Anilkumar Kolli <akolli@codeaurora.org>,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCH] ath: DFS JP domain W56 fixed pulse type 3 RADAR detection
Date:   Wed,  6 Mar 2019 23:06:11 +0530
Message-Id: <1551893771-22485-1-git-send-email-tamizhr@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Anilkumar Kolli <akolli@codeaurora.org>

Increase pulse width range from 1-2usec to 0-4usec.
During data traffic HW occasionally fails detecting radar pulses,
so that SW cannot get enough radar reports to achieve the success rate.

Tested ath10k hw and fw:
	* QCA9888(10.4-3.5.1-00052)
	* QCA4019(10.4-3.2.1.1-00017)
	* QCA9984(10.4-3.6-00104)
	* QCA988X(10.2.4-1.0-00041)

Tested ath9k hw: AR9300

Tested-by: Tamizh chelvam <tamizhr@codeaurora.org>
Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>
---
 drivers/net/wireless/ath/dfs_pattern_detector.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/dfs_pattern_detector.c b/drivers/net/wireless/ath/dfs_pattern_detector.c
index d52b31b..a274eb0 100644
--- a/drivers/net/wireless/ath/dfs_pattern_detector.c
+++ b/drivers/net/wireless/ath/dfs_pattern_detector.c
@@ -111,7 +111,7 @@ struct radar_types {
 	JP_PATTERN(0, 0, 1, 1428, 1428, 1, 18, 29, false),
 	JP_PATTERN(1, 2, 3, 3846, 3846, 1, 18, 29, false),
 	JP_PATTERN(2, 0, 1, 1388, 1388, 1, 18, 50, false),
-	JP_PATTERN(3, 1, 2, 4000, 4000, 1, 18, 50, false),
+	JP_PATTERN(3, 0, 4, 4000, 4000, 1, 18, 50, false),
 	JP_PATTERN(4, 0, 5, 150, 230, 1, 23, 50, false),
 	JP_PATTERN(5, 6, 10, 200, 500, 1, 16, 50, false),
 	JP_PATTERN(6, 11, 20, 200, 500, 1, 12, 50, false),
-- 
1.9.1

