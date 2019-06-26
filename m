Return-Path: <SRS0=g4G6=UZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DE9DC48BD6
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Jun 2019 02:25:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62A362085A
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Jun 2019 02:25:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="EKjNN5Ce";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="EKjNN5Ce"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbfFZCZz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Jun 2019 22:25:55 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:53798 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbfFZCZz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Jun 2019 22:25:55 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id BBF2960208; Wed, 26 Jun 2019 02:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1561515954;
        bh=f0pKdkF8K45BM2sOKIgyVxyJV7l1MVEf4khNSJWXkTQ=;
        h=From:To:Cc:Subject:Date:From;
        b=EKjNN5CexsYfVYBimOBjmTv0wfYT15UUYcarSPUItE9KBPvNXHHE/Yc7URncMG+bi
         U7nSXVdCGRUI1dR5TT6X4RTWgC0dUEAN+0WwH4ywJ9xmDN2m+KX5swoxkd8yM483Ve
         0qpghY+kFlIM0UzmaBDAFxUEEuj6UyW89jgrGUsE=
Received: from localhost.localdomain (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: wgong@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 687B160208;
        Wed, 26 Jun 2019 02:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1561515954;
        bh=f0pKdkF8K45BM2sOKIgyVxyJV7l1MVEf4khNSJWXkTQ=;
        h=From:To:Cc:Subject:Date:From;
        b=EKjNN5CexsYfVYBimOBjmTv0wfYT15UUYcarSPUItE9KBPvNXHHE/Yc7URncMG+bi
         U7nSXVdCGRUI1dR5TT6X4RTWgC0dUEAN+0WwH4ywJ9xmDN2m+KX5swoxkd8yM483Ve
         0qpghY+kFlIM0UzmaBDAFxUEEuj6UyW89jgrGUsE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 687B160208
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=wgong@codeaurora.org
From:   Wen Gong <wgong@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH] ath10k: destroy sdio workqueue while remove sdio module
Date:   Wed, 26 Jun 2019 10:25:40 +0800
Message-Id: <1561515940-13748-1-git-send-email-wgong@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The workqueue need to flush and destory while remove sdio module,
otherwise it will have thread which is not destory after remove
sdio modules.

Tested with QCA6174 SDIO with firmware
WLAN.RMH.4.4.1-00007-QCARMSWP-1.

Signed-off-by: Wen Gong <wgong@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/sdio.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
index fae56c6..40c3b4b 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -2077,6 +2077,9 @@ static void ath10k_sdio_remove(struct sdio_func *func)
 	cancel_work_sync(&ar_sdio->wr_async_work);
 	ath10k_core_unregister(ar);
 	ath10k_core_destroy(ar);
+
+	flush_workqueue(ar_sdio->workqueue);
+	destroy_workqueue(ar_sdio->workqueue);
 }
 
 static const struct sdio_device_id ath10k_sdio_devices[] = {
-- 
1.9.1

