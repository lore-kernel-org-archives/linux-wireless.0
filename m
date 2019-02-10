Return-Path: <SRS0=fcMp=QR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D278AC282C2
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Feb 2019 21:49:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0408213F2
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Feb 2019 21:49:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfBJVtn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 10 Feb 2019 16:49:43 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35190 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbfBJVtn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 10 Feb 2019 16:49:43 -0500
Received: by mail-wm1-f65.google.com with SMTP id t200so13309879wmt.0
        for <linux-wireless@vger.kernel.org>; Sun, 10 Feb 2019 13:49:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EM4pdGLHRU/lVQyT45gCPHPza74VRDDVhq/VZ5wVjfA=;
        b=sBcuSmczIAwkk9PP65hO9rVMiTCs32Gh91xWHAvsHN6gGeESjl8DjOKISQ/yANw7g/
         Klffku69bF/4OgoJc9MBZOPKfOs9rXQrC+LhDfuzL+5VtsY5oOijVToo5vmfB1/EHDuh
         KlqffsY4NfqQgsTQ74rK4hTresZPZTrge2NW+gEmblSl9Ti5o/qFk6Ce7PsaeHJVNsq9
         gzyh4tZXPd/Cfz56MIAUQipKI0zfHOsO53eo3Mf6QNtlqzMUipWJWNCvBlEOIUq/DsgQ
         f6i3O2AC+yQbd/cxSeMoN2rj5VGiAz81fJPFYgeQFANT7ZwKGOL5mR6Ox4cIL7Ot2AC2
         yc5A==
X-Gm-Message-State: AHQUAubqxHNa05wsqlzfdqPD+4DR+ni8IiOSmPd4/S4Rwurojzgv3cfM
        8LBnpBd8Qp6CsiD4p569wjQAHzFyjE0=
X-Google-Smtp-Source: AHgI3Ia7FYO202aKduHx1et9huBQ3vTw1GaG6t376elu30ET7yf42pPSZXE6SLDefmT0TfV2k2t1Zw==
X-Received: by 2002:a1c:7016:: with SMTP id l22mr7366843wmc.70.1549835381452;
        Sun, 10 Feb 2019 13:49:41 -0800 (PST)
Received: from lore-desk.lan ([151.66.10.5])
        by smtp.gmail.com with ESMTPSA id q14sm5436323wrw.39.2019.02.10.13.49.40
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 10 Feb 2019 13:49:40 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     nbd@nbd.name, sgruszka@redhat.com, stefan.wahren@i2se.com
Subject: [PATCH wireless-drivers 1/3] mt76: usb: fix possible NULL pointer dereference in mt76u_mcu_deinit
Date:   Sun, 10 Feb 2019 22:49:13 +0100
Message-Id: <54c995e58ca2bdc7ad1cb79926999e0155bb0e16.1549832428.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1549832428.git.lorenzo.bianconi@redhat.com>
References: <cover.1549832428.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fix possible NULL pointer dereference in mt76u_mcu_deinit routine that
can occur if initialization path fails before calling mt76u_mcu_init_rx

Fixes: ee676cd5017c ("mt76: add driver code for MT76x2u based devices")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/usb_mcu.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/usb_mcu.c b/drivers/net/wireless/mediatek/mt76/usb_mcu.c
index 036be4163e69..9527e1216f3d 100644
--- a/drivers/net/wireless/mediatek/mt76/usb_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/usb_mcu.c
@@ -48,9 +48,11 @@ EXPORT_SYMBOL_GPL(mt76u_mcu_init_rx);
 
 void mt76u_mcu_deinit(struct mt76_dev *dev)
 {
-	struct mt76_usb *usb = &dev->usb;
+	struct mt76u_buf *buf = &dev->usb.mcu.res;
 
-	usb_kill_urb(usb->mcu.res.urb);
-	mt76u_buf_free(&usb->mcu.res);
+	if (buf->urb) {
+		usb_kill_urb(buf->urb);
+		mt76u_buf_free(buf);
+	}
 }
 EXPORT_SYMBOL_GPL(mt76u_mcu_deinit);
-- 
2.20.1

