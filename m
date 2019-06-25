Return-Path: <SRS0=pdv6=UY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16709C48BD5
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Jun 2019 14:26:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8090213F2
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Jun 2019 14:26:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="S9zlQF2a";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="S9zlQF2a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730461AbfFYO0L (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Jun 2019 10:26:11 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:53050 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727070AbfFYO0K (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Jun 2019 10:26:10 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C988460C60; Tue, 25 Jun 2019 14:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1561472769;
        bh=TEBlvaeNf4r5I6IKGuHGOaBZ98Nqii7cdoNkzjqkhe8=;
        h=From:To:Cc:Subject:Date:From;
        b=S9zlQF2auvbU/JsnBOvoQGy+0+TxipQiBAn0bLa/t/7r/38VZ+DVe6BYquLlog7a+
         fwOT9z8CgbOd9AebnP+AZpwFas8rrG5AvCPRsxtvm9nmOX7pFhwbWq+xJxGMoaXlQq
         9qNUn+gFCZbOmTy7Canw+OmagSwt7V6N4fFMO4A0=
Received: from dundi-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dundi@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 43C8B60CEC;
        Tue, 25 Jun 2019 14:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1561472769;
        bh=TEBlvaeNf4r5I6IKGuHGOaBZ98Nqii7cdoNkzjqkhe8=;
        h=From:To:Cc:Subject:Date:From;
        b=S9zlQF2auvbU/JsnBOvoQGy+0+TxipQiBAn0bLa/t/7r/38VZ+DVe6BYquLlog7a+
         fwOT9z8CgbOd9AebnP+AZpwFas8rrG5AvCPRsxtvm9nmOX7pFhwbWq+xJxGMoaXlQq
         9qNUn+gFCZbOmTy7Canw+OmagSwt7V6N4fFMO4A0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 43C8B60CEC
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=dundi@codeaurora.org
From:   Dundi Raviteja <dundi@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Dundi Raviteja <dundi@codeaurora.org>
Subject: [PATCH] ath10k: Fix memory leak in qmi
Date:   Tue, 25 Jun 2019 19:55:48 +0530
Message-Id: <1561472748-28467-1-git-send-email-dundi@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Currently the memory allocated for qmi handle is
not being freed during de-init which leads to memory leak.

Free the allocated qmi memory in qmi deinit
to avoid memory leak.

Tested HW: WCN3990
Tested FW: WLAN.HL.3.1-01040-QCAHLSWMTPLZ-1

Fixes: fda6fee0001e ("ath10k: add QMI message handshake for wcn3990 client")
Signed-off-by: Dundi Raviteja <dundi@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/qmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
index 2e67878..dcbf20b 100644
--- a/drivers/net/wireless/ath/ath10k/qmi.c
+++ b/drivers/net/wireless/ath/ath10k/qmi.c
@@ -1003,6 +1003,7 @@ int ath10k_qmi_deinit(struct ath10k *ar)
 	qmi_handle_release(&qmi->qmi_hdl);
 	cancel_work_sync(&qmi->event_work);
 	destroy_workqueue(qmi->event_wq);
+	kfree(qmi);
 	ar_snoc->qmi = NULL;
 
 	return 0;
-- 
2.7.4

