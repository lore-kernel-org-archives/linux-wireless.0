Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93FABC169C4
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 09:26:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6247D2177E
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 09:26:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="j7fD+Yxm";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Z42UYIkn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727232AbfA2J0V (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 04:26:21 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:42336 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbfA2J0V (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 04:26:21 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4BF0960918; Tue, 29 Jan 2019 09:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548753980;
        bh=Sgr1tHTdnB7QIVv5RBDiZ/e0sXKSWbLTd9EPIBIiq9U=;
        h=From:To:Cc:Subject:Date:From;
        b=j7fD+Yxmex7utycKD33OMXmbBiEGOT3H4zXR6g2o31pjvd9YPfV4puysrh/7dpq/W
         CTdm+tYKlILRMP+xMKA5jRhwgZ3i2bbiPdK50cSlonfN74DophtnZgpzDgm3GViKyd
         FaCjDofjM8HSyFQd8NuaybOXHTZ3x0k2zzys/FGc=
Received: from pillair-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pillair@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6F204601D1;
        Tue, 29 Jan 2019 09:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548753976;
        bh=Sgr1tHTdnB7QIVv5RBDiZ/e0sXKSWbLTd9EPIBIiq9U=;
        h=From:To:Cc:Subject:Date:From;
        b=Z42UYIknRASEOxQWnrAOczY2U76CaFBJcHgHdHtUwn3Cz/oq+6+vCjjys7RLe9qOO
         3x+W78U7VmOCxGzhtlSGuJribVOwNmV+myBTQhQ1hwps8vKmMFm6FAMC9XpbvnonXG
         4wVX/o8FkJM/bEeM2N9hPrUeQi91GWHwQvc5asQE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6F204601D1
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=pillair@codeaurora.org
From:   Rakesh Pillai <pillair@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>
Subject: [PATCH] ath10k: Fix hw-restart crash inject mode for WCN3990
Date:   Tue, 29 Jan 2019 14:56:07 +0530
Message-Id: <1548753967-2233-1-git-send-email-pillair@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The hw-restart crash inject mode is a special mode, where
there is no crash generated in the firmware, but instead
the driver restarts the firmware. In order to restart WCN3990
firmware, the driver needs to send qmi_wlan_disable message
followed by the qmi_wlan_enable message to the WCN3990 firmware.

Currently the qmi_wlan_disable message is not sent to
the WCN3990 firmware when hw-restart crash is injected,
which causes the firmware to crash when the driver sends
qmi_wlan_enable message during ath10k_restart.

Send qmi_wlan_disable to the WCN3990 firmware when the
hw-restart crash is injected via debugfs.

Tested HW: WCN3990
Tested FW: WLAN.HL.2.0-01188-QCAHLSWMTPLZ-1

Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/snoc.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index 54efe6b..cceb6d4 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -1000,7 +1000,16 @@ static int ath10k_snoc_wlan_enable(struct ath10k *ar)
 
 static void ath10k_snoc_wlan_disable(struct ath10k *ar)
 {
-	if (!test_bit(ATH10K_FLAG_CRASH_FLUSH, &ar->dev_flags))
+	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
+
+	/* If both ATH10K_FLAG_CRASH_FLUSH and ATH10K_SNOC_FLAG_RECOVERY
+	 * flags are not set, it means that the driver has restarted
+	 * due to a crash inject via debugfs. In this case, the driver
+	 * needs to restart the firmware and hence send qmi wlan disable,
+	 * during the driver restart sequence.
+	 */
+	if (!test_bit(ATH10K_FLAG_CRASH_FLUSH, &ar->dev_flags) ||
+	    !test_bit(ATH10K_SNOC_FLAG_RECOVERY, &ar_snoc->flags))
 		ath10k_qmi_wlan_disable(ar);
 }
 
-- 
2.7.4

