Return-Path: <SRS0=7mY+=OP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A798C04EB8
	for <linux-wireless@archiver.kernel.org>; Thu,  6 Dec 2018 11:40:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A108205C9
	for <linux-wireless@archiver.kernel.org>; Thu,  6 Dec 2018 11:40:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2A108205C9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728144AbeLFLk3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 6 Dec 2018 06:40:29 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38036 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727832AbeLFLk2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Dec 2018 06:40:28 -0500
Received: by mail-wm1-f66.google.com with SMTP id m22so702042wml.3
        for <linux-wireless@vger.kernel.org>; Thu, 06 Dec 2018 03:40:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2l507nDU0W1rv82AQB9Zomps5890aAjpOgur9DidWks=;
        b=sRF/f6EccvpGQJWpDIJ0yzKO5pDi7CNFFhOR3DyLRwexDkneTS5BUazFKkPmtxklfe
         dnR7TjYfH3eCbN9PSJ3uX3azMy3w8nTMDb64xGLtTsZdIbxCXc7+tYgqEkdskCPN5AQC
         vXc9btsDmI6mxJGLypqP+t86QNzZksYAK6NjUjNFUrjxPutnF/3qsv3SXZMKqybU8Tgm
         AiA1hSFfMKfarfOGm7RvCGEK+bkwCX+BroEAGi6KkZtS8j63mRgL/8ZirPdkiobwlugb
         P2e8kjevKGMlhvWluwul9cHR7Ho2SWcnAsCfCRmQ4FmCTjmK/OWmply+MahaslJgkQwt
         1OXw==
X-Gm-Message-State: AA+aEWaot821ltaZ13M11S56Xc4LXdlDBVzutEYNqMKFDF/99s7qsd+W
        El5BxBJZWZzfLHAgtAXfN2DY4+k27Lw=
X-Google-Smtp-Source: AFSGD/U+ykEwT4OIsnWx5GlWXBzHnreMJSOI2k+ETgOStcFXBpAQCo8K1r9kGQA5BlJ5kWzqqjaB7w==
X-Received: by 2002:a1c:864f:: with SMTP id i76mr15243198wmd.83.1544096427082;
        Thu, 06 Dec 2018 03:40:27 -0800 (PST)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id h4sm161410wrt.66.2018.12.06.03.40.25
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 06 Dec 2018 03:40:26 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH] mt76: fix typo in mt76x02_check_mac_err routine
Date:   Thu,  6 Dec 2018 12:40:23 +0100
Message-Id: <401ea9d0ae92b372b5d68060b089e5d44a76d53c.1544096101.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <cover.1544096101.git.lorenzo.bianconi@redhat.com>
References: <cover.1544096101.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Reconfigure properly MT_MAC_SYS_CTRL register after mac sw-reset
in mt76x02_check_mac_err routine

Fixes: 73556561ab9f ("mt76x0: use mt76x02_mac_work as stats handler")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index c08bf371e527..490368dc9325 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -774,8 +774,8 @@ static void mt76x02_check_mac_err(struct mt76x02_dev *dev)
 
 	mt76_set(dev, MT_MAC_SYS_CTRL, MT_MAC_SYS_CTRL_RESET_CSR);
 	udelay(10);
-	mt76_clear(dev, MT_MAC_SYS_CTRL,
-		   MT_MAC_SYS_CTRL_ENABLE_TX | MT_MAC_SYS_CTRL_ENABLE_RX);
+	mt76_wr(dev, MT_MAC_SYS_CTRL,
+		MT_MAC_SYS_CTRL_ENABLE_TX | MT_MAC_SYS_CTRL_ENABLE_RX);
 }
 
 void mt76x02_mac_work(struct work_struct *work)
-- 
2.19.2

