Return-Path: <SRS0=B81N=5P=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 449AFC43331
	for <linux-wireless@archiver.kernel.org>; Mon, 30 Mar 2020 11:17:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E03520716
	for <linux-wireless@archiver.kernel.org>; Mon, 30 Mar 2020 11:17:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="joZfyMxE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729719AbgC3LR0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 30 Mar 2020 07:17:26 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:50372 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729267AbgC3LR0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Mar 2020 07:17:26 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1585567045; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=y5l4D1uJhpmoqhp6QtOXfphJUeCXOCOcQmpsT21Adc8=; b=joZfyMxE92AS//DLXg2/z8zm97fY1ApXVowJGFJZ2vML8lO+Y8hbCTxubCnON07LnztTe3Y6
 s6kqNpti3eOiYD56uTI4J/lDxg/bt0RhHVcPntTVUfJlH2jdA7rpPp5kOn8iUign1Df18E04
 b7Ke0EmTToXfjsnXmVzoFLNxUt8=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e81d545.7f5e0fdb4b20-smtp-out-n01;
 Mon, 30 Mar 2020 11:17:25 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6D45EC44791; Mon, 30 Mar 2020 11:17:25 +0000 (UTC)
Received: from checstp253621-lin.qualcomm.com (blr-c-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: srirrama)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AEE5AC433F2;
        Mon, 30 Mar 2020 11:17:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AEE5AC433F2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=srirrama@codeaurora.org
From:   Sriram R <srirrama@codeaurora.org>
To:     ath11k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, Sriram R <srirrama@codeaurora.org>
Subject: [PATCH] ath11k: Avoid mgmt tx count underflow
Date:   Mon, 30 Mar 2020 16:47:08 +0530
Message-Id: <1585567028-9242-1-git-send-email-srirrama@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The mgmt tx count reference is incremented/decremented on every mgmt tx and on
tx completion event from firmware.
In case of an unexpected mgmt tx completion event from firmware,
the counter would underflow. Avoid this by decrementing
only when the tx count is greater than 0.

Signed-off-by: Sriram R <srirrama@codeaurora.org>
---
 drivers/net/wireless/ath/ath11k/wmi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index e7ce369..d999c47 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -3740,8 +3740,9 @@ static int wmi_process_mgmt_tx_comp(struct ath11k *ar, u32 desc_id,
 
 	ieee80211_tx_status_irqsafe(ar->hw, msdu);
 
-	WARN_ON_ONCE(atomic_read(&ar->num_pending_mgmt_tx) == 0);
-	atomic_dec(&ar->num_pending_mgmt_tx);
+	/* WARN when we received this event without doing any mgmt tx */
+	if (atomic_dec_if_positive(&ar->num_pending_mgmt_tx) < 0)
+		WARN_ON_ONCE(1);
 
 	return 0;
 }
-- 
2.7.4
