Return-Path: <SRS0=qAu2=SM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98EDAC10F11
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 04:31:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DD4E20854
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 04:31:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="lW7f047e";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="OP4havjy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbfDJEbN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Apr 2019 00:31:13 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:43594 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbfDJEbN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Apr 2019 00:31:13 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B9EB4602B7; Wed, 10 Apr 2019 04:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554870671;
        bh=ImNpd/A83IwqUY8wQ21mLfijwT60NC1UYHmPPpQWilI=;
        h=From:To:Cc:Subject:Date:From;
        b=lW7f047eHOrpRJlI11Kim+dPQTGooh0iKx55bt/l7AQo+wRiE21+mzvMPQUn9OuWG
         awmbIEZU0H27dMmkT/T3r/WqSH6g7Ho0pMECu3yFAwjvYdMZo50M8Cgbxv9lNuZGFu
         ASb1gYMZLGuPAH0ak94kjZgwJ+g05Le9/YSTKDcY=
Received: from localhost.localdomain (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: wgong@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2EF81602B7;
        Wed, 10 Apr 2019 04:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554870667;
        bh=ImNpd/A83IwqUY8wQ21mLfijwT60NC1UYHmPPpQWilI=;
        h=From:To:Cc:Subject:Date:From;
        b=OP4havjyDMQ7gYlJUOLQBrHSv+Zg8C9E40+cMS8pd7bdvAH8cYNZj7b4vSBcF9W/+
         6nVXCrowa/SviLjfcshfMlL8EttlB5xd1mxa7tJsVaO08FqZE07bIWucEpdHj/l9P2
         a0PmJm6qhkKUaBrslImbBGWJCcQqFe5viYAnxsVM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2EF81602B7
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=wgong@codeaurora.org
From:   Wen Gong <wgong@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH] ath10k: change swap mail box config for UTF mode of SDIO
Date:   Wed, 10 Apr 2019 12:30:54 +0800
Message-Id: <1554870654-4236-1-git-send-email-wgong@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

For SDIO chip, it does not have HTT connect step in boot phase of UTF
mode, so it does not need the swap configuration for UTF mode, otherwise
it will trigger UTF load fail. For normal mode, it is swap between HTT
and WMI, for UTF mode, it does not have HTT, so it can not swap between
HTT and WMI.

Disable swap mail box for UTF mode will let UTF mode load success.

Tested with QCA6174 SDIO with firmware
WLAN.RMH.4.4.1-00007-QCARMSWP-1.

Signed-off-by: Wen Gong <wgong@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/core.c | 11 ++++++++---
 drivers/net/wireless/ath/ath10k/sdio.c |  5 +++++
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 835b8de..79a238c 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -629,7 +629,7 @@ static void ath10k_send_suspend_complete(struct ath10k *ar)
 	complete(&ar->target_suspend);
 }
 
-static void ath10k_init_sdio(struct ath10k *ar)
+static void ath10k_init_sdio(struct ath10k *ar, enum ath10k_firmware_mode mode)
 {
 	u32 param = 0;
 
@@ -646,7 +646,12 @@ static void ath10k_init_sdio(struct ath10k *ar)
 	 * not big enough for mac80211 / native wifi frames. disable it
 	 */
 	param &= ~HI_ACS_FLAGS_ALT_DATA_CREDIT_SIZE;
-	param |= HI_ACS_FLAGS_SDIO_SWAP_MAILBOX_SET;
+
+	if (mode == ATH10K_FIRMWARE_MODE_UTF)
+		param &= ~HI_ACS_FLAGS_SDIO_SWAP_MAILBOX_SET;
+	else
+		param |= HI_ACS_FLAGS_SDIO_SWAP_MAILBOX_SET;
+
 	ath10k_bmi_write32(ar, hi_acs_flags, param);
 
 	/* Explicitly set fwlog prints to zero as target may turn it on
@@ -2501,7 +2506,7 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
 			goto err;
 
 		if (ar->hif.bus == ATH10K_BUS_SDIO)
-			ath10k_init_sdio(ar);
+			ath10k_init_sdio(ar, mode);
 	}
 
 	ar->htc.htc_ops.target_send_suspend_complete =
diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
index fae56c6..bfb125b 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -1637,7 +1637,12 @@ static int ath10k_sdio_hif_swap_mailbox(struct ath10k *ar)
 		ath10k_dbg(ar, ATH10K_DBG_SDIO,
 			   "sdio mailbox swap service enabled\n");
 		ar_sdio->swap_mbox = true;
+	} else {
+		ath10k_dbg(ar, ATH10K_DBG_SDIO,
+			"sdio mailbox swap service disabled\n");
+		ar_sdio->swap_mbox = false;
 	}
+
 	return 0;
 }
 
-- 
1.9.1

