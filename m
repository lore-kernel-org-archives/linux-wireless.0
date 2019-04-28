Return-Path: <SRS0=6X5c=S6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDA25C43218
	for <linux-wireless@archiver.kernel.org>; Sun, 28 Apr 2019 02:17:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1EB52064A
	for <linux-wireless@archiver.kernel.org>; Sun, 28 Apr 2019 02:17:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="QMVjQORQ";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Yjn7zJOt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726242AbfD1CRT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 27 Apr 2019 22:17:19 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:58212 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726079AbfD1CRS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 27 Apr 2019 22:17:18 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1B2D560117; Sun, 28 Apr 2019 02:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556417838;
        bh=8Z+Xnff/4eQbJDrCB2cyLkFo5QwmntY2rBb88/5s6/w=;
        h=From:To:Cc:Subject:Date:From;
        b=QMVjQORQpcRmNxlA+iV2lrKpMz99SPQ3qaRfK0lLouTdOpP3JIt3e+AnYu7mO0337
         qxP9KH7WYZFCDvPBJ9o/Vpqy7bELusuIWArBjVqW+XrEmMh7kwxU8Y2GoHH8d/kyvy
         uu1PUsN8D8vOtYq3Dv8nq/oTo7Bc2MMSGolQvG90=
Received: from localhost.localdomain (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: wgong@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id ADCE4601B4;
        Sun, 28 Apr 2019 02:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556417837;
        bh=8Z+Xnff/4eQbJDrCB2cyLkFo5QwmntY2rBb88/5s6/w=;
        h=From:To:Cc:Subject:Date:From;
        b=Yjn7zJOtiQjwCNgf+VYIr0Y8z7rbb0hxohTorJSOp22cb7sxphk62zBxcHtExUh4o
         JgDkBbYNsQyKjPEuQsCSPiw4Rm3dfUL63oBXo4SSrMJrMXekSsoWS6RV0Quxp+/Onq
         pjsGkakcZvq0y1lt8vV/HtSVbdZoBSjRFdRJDxxU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org ADCE4601B4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=wgong@codeaurora.org
From:   Wen Gong <wgong@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH] ath10k: remove mmc_hw_reset while hif power down
Date:   Sun, 28 Apr 2019 10:17:05 +0800
Message-Id: <1556417825-13713-1-git-send-email-wgong@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

For sdio 3.0 chip, the clock will drop from 200M Hz to 50M Hz after load
ath10k driver, it is because mmc_hw_reset will reset the sdio's power,
then mmc will consider it as sdio 2.0 and drop the clock.

Remove mmc_hw_reset will avoid the drop of clock.

Tested with QCA6174 SDIO with firmware
WLAN.RMH.4.4.1-00007-QCARMSWP-1.

Signed-off-by: Wen Gong <wgong@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/sdio.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
index fae56c6..f1d2af8 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -1433,10 +1433,6 @@ static void ath10k_sdio_hif_power_down(struct ath10k *ar)
 		return;
 	}
 
-	ret = mmc_hw_reset(ar_sdio->func->card->host);
-	if (ret)
-		ath10k_warn(ar, "unable to reset sdio: %d\n", ret);
-
 	sdio_release_host(ar_sdio->func);
 
 	ar_sdio->is_disabled = true;
-- 
1.9.1

