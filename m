Return-Path: <SRS0=DLa0=WQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D829EC3A589
	for <linux-wireless@archiver.kernel.org>; Tue, 20 Aug 2019 15:48:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE30D22CE3
	for <linux-wireless@archiver.kernel.org>; Tue, 20 Aug 2019 15:48:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="V9fevZJK";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="b3GO+UlP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730204AbfHTPsZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 20 Aug 2019 11:48:25 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:38316 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730141AbfHTPsZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Aug 2019 11:48:25 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 14A1A6119F; Tue, 20 Aug 2019 15:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1566316104;
        bh=UblGLpcvrnPxxaToCmetjgptF1EWEK4xAaEhMIhZkv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V9fevZJK9puq2b5mOvWxqd0OkR7Iskj5KKBExHsCZNGPQ0y3iN+C1wsqlsbJA/Bhx
         FbXaIc6z6CC3HZVim3InASj2UkTIWnHnmJaf34pRvSCHIl/7iNNXm0PT+j9v7WlmRr
         1kiyk0YpP0LCuMEdvjwm7PlEqY6P49Ve7qWENPP8=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 011876119F;
        Tue, 20 Aug 2019 15:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1566316103;
        bh=UblGLpcvrnPxxaToCmetjgptF1EWEK4xAaEhMIhZkv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b3GO+UlPz7yswJUmJS/RHLHYgTxErS/NUb2lTQKFbODL1RUyFxuEmYxbbm6rQerm6
         OUOjhfbf4B4W7a4PuQesjU79p9tDR6bgh2i5fQ9uEjvQr7NQEybcom6wX4mi8Hz301
         bgUkOolMIoUhVkzZAyPVWDwzE85+gJT/wXDtopPo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 011876119F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     linux-wireless@vger.kernel.org
Cc:     ath11k@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH 02/49] ath11k: add Kconfig
Date:   Tue, 20 Aug 2019 18:47:28 +0300
Message-Id: <1566316095-27507-3-git-send-email-kvalo@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1566316095-27507-1-git-send-email-kvalo@codeaurora.org>
References: <1566316095-27507-1-git-send-email-kvalo@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

---
 drivers/net/wireless/ath/ath11k/Kconfig | 34 +++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/Kconfig b/drivers/net/wireless/ath/ath11k/Kconfig
new file mode 100644
index 000000000000..26bf98fa648e
--- /dev/null
+++ b/drivers/net/wireless/ath/ath11k/Kconfig
@@ -0,0 +1,34 @@
+config ATH11K
+        tristate "Qualcomm Technologies 802.11ax chipset support"
+        depends on MAC80211 && HAS_DMA
+	depends on REMOTEPROC
+	depends on ARCH_QCOM || COMPILE_TEST
+	select ATH_COMMON
+	select QCOM_QMI_HELPERS
+        help
+          This module adds support for Qualcomm Technologies 802.11ax family of
+	  chipsets.
+
+          If you choose to build a module, it'll be called ath11k.
+
+config ATH11K_DEBUG
+	bool "QCA ath11k debugging"
+	depends on ATH11K
+	help
+	  Enables debug support
+
+	  If unsure, say Y to make it easier to debug problems.
+
+config ATH11K_DEBUGFS
+	bool "QCA ath11k debugfs support"
+	depends on ATH11K && DEBUG_FS
+	help
+	  Enable ath11k debugfs support
+
+	  If unsure, say Y to make it easier to debug problems.
+
+config ATH11K_TRACING
+	bool "ath11k tracing support"
+	depends on ATH11K && EVENT_TRACING
+	---help---
+	  Select this to ath11k use tracing infrastructure.

