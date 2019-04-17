Return-Path: <SRS0=eC3p=ST=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54BABC10F13
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 00:35:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C09E21773
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 00:35:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LKv62zS3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729005AbfDQAf4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Apr 2019 20:35:56 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:33061 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728237AbfDQAfz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Apr 2019 20:35:55 -0400
Received: by mail-oi1-f195.google.com with SMTP id e5so18619938oii.0
        for <linux-wireless@vger.kernel.org>; Tue, 16 Apr 2019 17:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=z/aRtKGDL+c22EEvzqyKTDNjxFiCHW0y8XkC1pXCKLc=;
        b=LKv62zS3wQhs3d/EHR/zc+qUb7ANrwh2p4OK8v1BztGV/Y9zFq1odW4D+GG8+oAZDS
         /WPrVchFSZI70Ucn6iSnVVO0SDTg3ZUPi1Ru0P+xFhf+UToMw1iH9Wd1Em16/jvfXK/n
         SYAD33/yJuJgAwPDcHmj0x5E7SmrbzVLao3XSzYSZkJDyhGdyfp8k2U1Z/YrVEM7buA7
         Y9Jv96Iuw5zukFpysqvvn4fvvn8av+1S3HM5c2M9bkWufeHbkccECR/Mw84MtuvJMLiG
         tkW5PDtxaQoaRkOehkSPOZPux/vb8wYQTgbM0yukJokTcT8zEU/Bi4UPDrRXIv+j9rbK
         ZCOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=z/aRtKGDL+c22EEvzqyKTDNjxFiCHW0y8XkC1pXCKLc=;
        b=H+ptuFCQZcyrIkcfMasJWMgTSCWgGo25xzuaTUaNyd2KJys05F8fQtE95hNI9Ldvf/
         7NQOqWBcJV54ujjg/7bAVW7Ei3z+WzR4BGxXyk3Cyla7SgSscR5DOjgkx8rQuZqwmM3L
         MXUaqlCueoXXe8CtTabdbOmM3WHMKsG+pjKWvujyporoQg0YZlB7etD8vP8xlF/Hwxw2
         8nPZgHPYjZEh5vapoYeoUCYiEmNVudDA4Dizt1QU40Du3GEC8ylxu4JrMZ/PNter0ogI
         cqkKD0ys+qRwHr+BIMaIzzvGcmvtx7odT/Gm5II6WMGFAbY/9w7230ZPqeEJtUpXIigz
         14Zw==
X-Gm-Message-State: APjAAAXYPf0ryCXTv8dSVOZX0FYMjfnKTVaePW9F+YZXCPaRIP7d35Io
        iku/XpH6Y+HhDSpGlM4mh60=
X-Google-Smtp-Source: APXvYqy77c6S59xg8Y5thekm+GauV60W3GlBXBEMjVvZmR4IdJv/hCo2fLCcdivyBGPou5yx/RYLXg==
X-Received: by 2002:aca:f3c6:: with SMTP id r189mr24628816oih.53.1555461354966;
        Tue, 16 Apr 2019 17:35:54 -0700 (PDT)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id 96sm22374371otf.17.2019.04.16.17.35.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Apr 2019 17:35:54 -0700 (PDT)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] rtlwifi: rtl8188ee: Remove extraneous file
Date:   Tue, 16 Apr 2019 19:35:47 -0500
Message-Id: <20190417003547.26271-1-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.16.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Somehow file drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c.rej was
incorporated into the sources. Obviously, it can be removed.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Reported-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
Andrew,

Thanks.

Larry
---
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c.rej | 10 ----------
 1 file changed, 10 deletions(-)
 delete mode 100644 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c.rej

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c.rej b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c.rej
deleted file mode 100644
index aa03d4605d8c..000000000000
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c.rej
+++ /dev/null
@@ -1,10 +0,0 @@
---- drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
-+++ drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
-@@ -373,6 +373,7 @@ bool rtl88ee_rx_query_desc(struct ieee80211_hw *hw,
- 	struct rx_fwinfo_88e *p_drvinfo;
- 	struct ieee80211_hdr *hdr;
- 	u32 phystatus = GET_RX_DESC_PHYST(pdesc);
-+	u8 wake_match;
- 
- 	status->packet_report_type = (u8)GET_RX_STATUS_DESC_RPT_SEL(pdesc);
- 	if (status->packet_report_type == TX_REPORT2)
-- 
2.16.4

