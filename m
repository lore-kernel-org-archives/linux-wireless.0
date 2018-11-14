Return-Path: <SRS0=SE/f=NZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 670DFC43441
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Nov 2018 02:50:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 282BE2082A
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Nov 2018 02:50:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="MLxdF8oi";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dE1GvX4r"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 282BE2082A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732222AbeKNMvp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 14 Nov 2018 07:51:45 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:46498 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732174AbeKNMvo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Nov 2018 07:51:44 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 13E21601D4; Wed, 14 Nov 2018 02:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542163833;
        bh=+8tDCNVT4M1W73lvpP5wmFls8NXiVP5sM3RPOl+7dIk=;
        h=From:To:Cc:Subject:Date:From;
        b=MLxdF8oiaVi0p2muO5OrPRAj3n81DUMt4w1QOAuB0qex/z4kHIMSLmaaWMn1938jd
         c86XlRZbiBQPa5wGRNwdUcpuRu3Eii8es23rTSfSuPFQDLyozji876KJRsi+Ef9TWc
         P2vN9ZbJjRjIsnXqUkKM8JVyS2dO1xIVvN4qDl10=
Received: from localhost.localdomain (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: wgong@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DBBC76028D;
        Wed, 14 Nov 2018 02:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542163832;
        bh=+8tDCNVT4M1W73lvpP5wmFls8NXiVP5sM3RPOl+7dIk=;
        h=From:To:Cc:Subject:Date:From;
        b=dE1GvX4rSaz9v2ZUkKMnS8smSHQwqz8CpKDNtPf+HYteI1hpImJ+La0GzVDkNfsn8
         PgwCCMIQZALWjrL0IcRyo1xO/jQ3QY2WJg7QGyYVz9nVDTLIX26wDtSfbR7PWfr4a7
         vi1zqf3ZDoC5y0Kqz+FKmZT1iTBdFcqisSLmW4Ik=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DBBC76028D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=wgong@codeaurora.org
From:   Wen Gong <wgong@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH] ath10k: Remove ATH10K_STATE_RESTARTED in simulate fw crash
Date:   Wed, 14 Nov 2018 10:50:24 +0800
Message-Id: <1542163824-795-1-git-send-email-wgong@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

When test simulate firmware crash, it is easy to trigger error.
command:
echo soft > /sys/kernel/debug/ieee80211/phyxx/ath10k/simulate_fw_crash.

If input more than two times continuously, then it will have error.
Error message:
ath10k_pci 0000:02:00.0: failed to set vdev 1 RX wake policy: -108
ath10k_pci 0000:02:00.0: device is wedged, will not restart

It is because the state has not changed to ATH10K_STATE_ON immediately,
then it will have more than two simulate crash process running meanwhile,
and complete/wakeup some field twice, it destroy the normal recovery
process.

Tested with QCA6174 PCI with firmware
WLAN.RM.4.4.1-00109-QCARMSWPZ-1, but this will also affect QCA9377 PCI.
It's not a regression with new firmware releases.

Signed-off-by: Wen Gong <wgong@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/debug.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index ada29a4..dc8700b 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -569,8 +569,7 @@ static ssize_t ath10k_write_simulate_fw_crash(struct file *file,
 
 	mutex_lock(&ar->conf_mutex);
 
-	if (ar->state != ATH10K_STATE_ON &&
-	    ar->state != ATH10K_STATE_RESTARTED) {
+	if (ar->state != ATH10K_STATE_ON) {
 		ret = -ENETDOWN;
 		goto exit;
 	}
-- 
1.9.1

