Return-Path: <SRS0=hThr=N5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 891E1C43441
	for <linux-wireless@archiver.kernel.org>; Sun, 18 Nov 2018 02:59:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 408F120815
	for <linux-wireless@archiver.kernel.org>; Sun, 18 Nov 2018 02:59:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mfSc6B9j"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 408F120815
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lwfinger.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725894AbeKRNOI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 18 Nov 2018 08:14:08 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:45513 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725814AbeKRNOI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 18 Nov 2018 08:14:08 -0500
Received: by mail-ot1-f67.google.com with SMTP id 32so24236897ota.12;
        Sat, 17 Nov 2018 18:55:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3zYmiOhJibDHi6oIA7d+rQTRoFiKcaHV5qvmDDwBZzg=;
        b=mfSc6B9jI7hAxZG3tIKImJlNOYPtTQzLIys1mXmnVBBnkyiEDaQ0n5I8PqEhukb7+b
         gt+4gBgCh3wDnTZY+uaKwqKawe44i5pjTV3sVsczyxbG+WFycV2wRNBlPO8UCF64/jJl
         +rYftua6ooahtay7piSiSNnXsDL/4Qko+QNPeBxczOi+OlLHUPbnN3zlBDApmsb2W41s
         4Z1HsNI6PsBGT09xLgxXX/6cj/KLVsKYVZ0YYFWQnmPAM1c91vpoOdZYNNE5ObuY0fR2
         DfrErbEPhdtbXScO4BYMZzON80wA9187g11BcugS7S5mONT3xUp1W+Vfo6hlClszpHDh
         xNLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=3zYmiOhJibDHi6oIA7d+rQTRoFiKcaHV5qvmDDwBZzg=;
        b=Hn2x59Ile4lgLm80dswWW5YqLHPynRMpIEF+iOj8bALzxKamxTMXbKMfV5HoGLbrk3
         /AgS0RPXbBAq5JXzHzHfKEBnYAvqHx1ab+koZo/ij8vOtcE+NzQjtdHLXzEIZuZQec8y
         e8XhQyzZhHnFW6ErIhXFz4fNRwchZ5uewx5ItjI/ds2OI/T30YYVviYxy+pGEhfL2Pkn
         uJaHkYs9oyJvxNUlIlKw5uvNooaayqBLHvVG4IL7T6AX5sCbU0NosnoU1yXDd/i1gxI/
         rEzl1F/BIQeUuHM6KPlzKpI5s9IkO1useJhlGbHpfDYO9QLD43Xf4sB1QZYu4O8TNTu4
         9h4w==
X-Gm-Message-State: AGRZ1gKMEFPDRZEbG8oSPrl7soxEHzWQolN2fTKvqOVgPFkvnz9D4skF
        U2lfcRmTGUHTFoOeD5Vl3Lk=
X-Google-Smtp-Source: AJdET5cxUXtQK6fehmuGY05+oKPXqnsyES28vETPyN89wM4bSPpnTlSEe/bAfkaKmWv8ITt14LzRzw==
X-Received: by 2002:a9d:74c3:: with SMTP id a3mr10640945otl.107.1542509720245;
        Sat, 17 Nov 2018 18:55:20 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id y204-v6sm17640377oiy.40.2018.11.17.18.55.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 17 Nov 2018 18:55:19 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        =?UTF-8?q?Francisco=20Machado=20Magalh=C3=A3es=20Neto?= 
        <franmagneto@gmail.com>, Ping-Ke Shih <pkshih@realtek.com>,
        Stable <stable@vger.kernel.org>
Subject: [PATCH 4.20] rtlwifi: Fix leak of skb when processing C2H_BT_INFO
Date:   Sat, 17 Nov 2018 20:55:03 -0600
Message-Id: <20181118025503.20639-1-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.16.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

With commit 0a9f8f0a1ba9 ("rtlwifi: fix btmpinfo timeout while processing
C2H_BT_INFO"), calling rtl_c2hcmd_enqueue() with rtl_c2h_fast_cmd() true,
the routine returns without freeing that skb, thereby leaking it.

This issue has been discussed at https://github.com/lwfinger/rtlwifi_new/issues/401
and the fix tested there.

Fixes: 0a9f8f0a1ba9 ("rtlwifi: fix btmpinfo timeout while processing C2H_BT_INFO")
Reported-and-tested-by: Francisco Machado Magalhães Neto <franmagneto@gmail.com>
Cc: Francisco Machado Magalhães Neto <franmagneto@gmail.com>
Cc: Ping-Ke Shih <pkshih@realtek.com>
Cc: Stable <stable@vger.kernel.org> # 4.18+
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/realtek/rtlwifi/base.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index f4122c8fdd97..ef9b502ce576 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -2289,6 +2289,7 @@ void rtl_c2hcmd_enqueue(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 	if (rtl_c2h_fast_cmd(hw, skb)) {
 		rtl_c2h_content_parsing(hw, skb);
+		kfree_skb(skb);
 		return;
 	}
 
-- 
2.16.4

