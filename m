Return-Path: <SRS0=dpF5=4C=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 751EBC35242
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Feb 2020 03:40:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49B7F206ED
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Feb 2020 03:40:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="QY/00eC7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728520AbgBNDkd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 13 Feb 2020 22:40:33 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:14252 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728052AbgBNDkd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Feb 2020 22:40:33 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1581651633; h=Content-Transfer-Encoding: MIME-Version:
 Message-Id: Date: Subject: Cc: To: From: Sender;
 bh=6F6q74eRqaT7YwRMjDoofD8qMcMiA27lN8j/aAC1ZPU=; b=QY/00eC7dYRNrSp+4+mCSAnslWqm610PWWsnGom8kSEkVeZq4Tn8n3aGNp8pFyh4YpdQM/bj
 yfPsoC3GqAktM2OBEX/ravLk8NR8ISub0P8Ia6O6mAWEs3H13vG6NkYGQAzbSDDAKz7KA2j+
 DlRLwHYpFqOLbG+P0GMsbVVypOQ=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e4616a7.7fcaa1142068-smtp-out-n02;
 Fri, 14 Feb 2020 03:40:23 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E773DC4479C; Fri, 14 Feb 2020 03:40:22 +0000 (UTC)
Received: from wgong-HP-Z240-SFF-Workstation.qca.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: wgong)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A2003C43383;
        Fri, 14 Feb 2020 03:40:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A2003C43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=wgong@codeaurora.org
From:   Wen Gong <wgong@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, wgong@codeaurora.org
Subject: [PATCH] ath10k: start recovery process when read int status fail for sdio
Date:   Fri, 14 Feb 2020 11:40:07 +0800
Message-Id: <20200214034007.24512-1-wgong@codeaurora.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

When running simulate crash stress test, it happened
"failed to read from address 0x800: -110".

Test steps:
1. Run command continuous
echo soft > /sys/kernel/debug/ieee80211/phy0/ath10k/simulate_fw_crash

2. error happened and it did not begin recovery for long time.
[74377.334846] ath10k_sdio mmc1:0001:1: simulating soft firmware crash
[74378.378217] ath10k_sdio mmc1:0001:1: failed to read from address 0x800: -110
[74378.378371] ath10k_sdio mmc1:0001:1: failed to process pending SDIO interrupts: -110

It has sdio errors since it can not read MBOX_HOST_INT_STATUS_ADDRESS,
then it has to do recovery process to recovery ath10k.

Tested with QCA6174 SDIO with firmware WLAN.RMH.4.4.1-00042.

Signed-off-by: Wen Gong <wgong@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/sdio.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
index 7b894dcaad2e..ef389aba046d 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -941,8 +941,11 @@ static int ath10k_sdio_mbox_read_int_status(struct ath10k *ar,
 	 */
 	ret = ath10k_sdio_read(ar, MBOX_HOST_INT_STATUS_ADDRESS,
 			       irq_proc_reg, sizeof(*irq_proc_reg));
-	if (ret)
+	if (ret) {
+		queue_work(ar->workqueue, &ar->restart_work);
+		ath10k_warn(ar, "read int status fail, start recovery\n");
 		goto out;
+	}
 
 	/* Update only those registers that are enabled */
 	*host_int_status = irq_proc_reg->host_int_status &
-- 
2.23.0
