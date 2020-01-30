Return-Path: <SRS0=/tVN=3T=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18EB1C33CB2
	for <linux-wireless@archiver.kernel.org>; Thu, 30 Jan 2020 01:33:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2C6220716
	for <linux-wireless@archiver.kernel.org>; Thu, 30 Jan 2020 01:33:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FfWX/ESk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbgA3BdO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 29 Jan 2020 20:33:14 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:33792 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726618AbgA3BdO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Jan 2020 20:33:14 -0500
Received: by mail-oi1-f195.google.com with SMTP id l136so1926781oig.1;
        Wed, 29 Jan 2020 17:33:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5ZdzI82fvwujvYsag8I7TqJgzKEukKEgmUxw93uz7R0=;
        b=FfWX/ESk/Ny+soGUtrSk5sBftjMj5pXOQcWF82TaJBaEL0q9IwJVd6Zf27SJ90qTJx
         2QA4hFaB/nS+UD4pGjVKm8dKvBPVmEXqzZotl2Bc5nTfQZ8wZ+HX6vt4HbHsyj3Cy8Qh
         tVS2tsY5FhnUJmseLiVblX0u5b5zDWVaWTA7H/qNLurJBpt7VbWL3ZgIFLzizSN9Hfp3
         MAILHnkofSiqwIqvlLv2z15G24koWdJaX7MyQC++n/H6GfYnzRrDn+hI8+jr0N10k5r/
         aXxUN7gjq0HF+DpSc1ytLuDhUgrmplLsEVY/FvNmHA8FZswsZpuNvMnRHkk5vVBoIcEs
         yd3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5ZdzI82fvwujvYsag8I7TqJgzKEukKEgmUxw93uz7R0=;
        b=ddSMsYE1hXDxYfJeBzpAkoX3lZ9PBgziLHfDnWGyzmNF8pI0pjsBcr1rFCb9yBuWfz
         EpBZC0JXRlPqM80N3l5wh5vaqUB20xOPyGf+bpHtbdqAU/z+qerZlK1zCVWwfGBPDwIc
         FSIT5aYxw5amLdRiQr1uYYIMMAgFzl5XTqf2d6a+frfs81pFMfwSWleXMQi9nWybZItK
         ME4R9EdLuoN9hWB4icYjHgXaiAv1oWkPsmRZH1x998YP+L5iKjq5ADZGxBkOxIpxcod5
         uWpAlGQYgFx3hYOfZXiDG/+mtTLMAFfmFrJs///uRNP9ghFNxNKZCzsX5DqAExcXzHzG
         Fyxg==
X-Gm-Message-State: APjAAAVEOXuTa394Y6ucizOVztKxPnoOvLDvDaLD73CAq5Z2BktqEkOG
        07YkWrIzTkeq1q8SfGRw5UU=
X-Google-Smtp-Source: APXvYqwiujT7PdmmUTwP1B9oYsiW6xYwpjN4TQq2gTWxjUxEg75TIEEyy9SW2soJdDmlJkt5YB7D1g==
X-Received: by 2002:aca:d483:: with SMTP id l125mr1277102oig.124.1580347993400;
        Wed, 29 Jan 2020 17:33:13 -0800 (PST)
Received: from localhost.localdomain ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id i12sm1336938otk.11.2020.01.29.17.33.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jan 2020 17:33:12 -0800 (PST)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] rtw88: Initialize ret in rtw_wow_check_fw_status
Date:   Wed, 29 Jan 2020 18:33:08 -0700
Message-Id: <20200130013308.16395-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Clang warns a few times (trimmed for brevity):

../drivers/net/wireless/realtek/rtw88/wow.c:295:7: warning: variable
'ret' is used uninitialized whenever 'if' condition is false
[-Wsometimes-uninitialized]

Initialize ret to true and change the other assignments to false because
it is a boolean value.

Fixes: 44bc17f7f5b3 ("rtw88: support wowlan feature for 8822c")
Link: https://github.com/ClangBuiltLinux/linux/issues/850
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/net/wireless/realtek/rtw88/wow.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/wow.c b/drivers/net/wireless/realtek/rtw88/wow.c
index af5c27e1bb07..5db49802c72c 100644
--- a/drivers/net/wireless/realtek/rtw88/wow.c
+++ b/drivers/net/wireless/realtek/rtw88/wow.c
@@ -283,18 +283,18 @@ static void rtw_wow_rx_dma_start(struct rtw_dev *rtwdev)
 
 static bool rtw_wow_check_fw_status(struct rtw_dev *rtwdev, bool wow_enable)
 {
-	bool ret;
+	bool ret = true;
 
 	/* wait 100ms for wow firmware to finish work */
 	msleep(100);
 
 	if (wow_enable) {
 		if (!rtw_read8(rtwdev, REG_WOWLAN_WAKE_REASON))
-			ret = 0;
+			ret = false;
 	} else {
 		if (rtw_read32_mask(rtwdev, REG_FE1IMR, BIT_FS_RXDONE) == 0 &&
 		    rtw_read32_mask(rtwdev, REG_RXPKT_NUM, BIT_RW_RELEASE) == 0)
-			ret = 0;
+			ret = false;
 	}
 
 	if (ret)
-- 
2.25.0

