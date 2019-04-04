Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEE21C4360F
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 18:49:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 827C820657
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 18:49:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sOf8JLuI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729916AbfDDStT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 14:49:19 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:43177 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727398AbfDDStT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 14:49:19 -0400
Received: by mail-ot1-f67.google.com with SMTP id u15so3295667otq.10
        for <linux-wireless@vger.kernel.org>; Thu, 04 Apr 2019 11:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e/5H+o0y9dBoiEr+Y0EztZlqEccw73DZ/VtlhWOshy4=;
        b=sOf8JLuIRWkbb7tG0BZ3XqQKgrz4073bb0oDrTxIWXDJ9fnlOY35Re+V6314iEF+Dv
         NMBy+Cz7HFTBaa/fuuoS3/Kf5jgPFoOgy1AQml4PdpPoGVZ9EUQOFyW4p6tvP58RU6h4
         eSbO0mI5TwRGuPwkw/6Xl08GvmL3e/Vo9Xf9mYNuZWOrGbdbRzBTqZAYTkvVheb4gK5w
         FBJ/ylgG6IkUFa3m6ga4kOaSh2y0Rve1iA+A0XBIWh8I//j3JtoxyLvQiFBhd+nllE4n
         1ruR6ffobQct1P6KOpItLpZT8FEsFHvY33ZgQ/wbreixsgzSK+/f15eUR3IZyLUSRDtQ
         ZKpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=e/5H+o0y9dBoiEr+Y0EztZlqEccw73DZ/VtlhWOshy4=;
        b=IQzUsNvp6Bf1v60CK6761Q4I1MugtbCaDMVamCKugJsiWPmsxZf2d9tPYKm76rxnDi
         U9qg3VnWjRJgfRUORE8BNhWWw+k4BD9ENxC/kPB6/ZNg3r+jKNGBCFSrB5nIZ4hKjZMo
         hvLu6TTVbhPOt3XrGP15GRa/PWvpmseOOx/IsYdffGo3dHqyuuPE301aQ1NwZ2QCwDSL
         qPgBMV6eG6pO5Ur712PVAJg9OilUub+Xoy+vYBN22JkC4EGd76HqyTejT/CWq+BbECd9
         cMHzhlFolOo9INRzdsIZQZjI80wTD0mlCuQAG4/ueiaPWpPUq5pil4/nEtQYkXa8bzGz
         Nngg==
X-Gm-Message-State: APjAAAVcOpSXbrfC/3WgSYECybCl1AtLqLYLO7SkFw1AQYmjlZi7Sl7D
        zJK33eIwCGMgrC6pSoIBDGJdmXqP
X-Google-Smtp-Source: APXvYqwS6j158iP9D6X+84xViwW7S3KxdWTTC0OGDLZETR3ZSWSS2vuRvDdSVe+2Lm8KTvKgaSd8SQ==
X-Received: by 2002:a9d:ef4:: with SMTP id 107mr5584557otj.152.1554403758475;
        Thu, 04 Apr 2019 11:49:18 -0700 (PDT)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id 189sm8152427oii.58.2019.04.04.11.49.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Apr 2019 11:49:17 -0700 (PDT)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] b43: Remove empty function lpphy_papd_cal()
Date:   Thu,  4 Apr 2019 13:49:14 -0500
Message-Id: <20190404184914.12819-1-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In commit d825db346270e ("b43: shut up clang -Wuninitialized variable
warning"), the message noted that function lpphy_papd_cal() was empty
and had an old TODO regarding its implementation. As the reverse
engineering project that created the LP-PHY version of this driver
has not been active for some time, it is safe to remove this empty
function.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/broadcom/b43/phy_lp.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43/phy_lp.c b/drivers/net/wireless/broadcom/b43/phy_lp.c
index aedee026c5e2..6b7f0238723f 100644
--- a/drivers/net/wireless/broadcom/b43/phy_lp.c
+++ b/drivers/net/wireless/broadcom/b43/phy_lp.c
@@ -1826,12 +1826,6 @@ static void lpphy_stop_tx_tone(struct b43_wldev *dev)
 }
 
 
-static void lpphy_papd_cal(struct b43_wldev *dev, struct lpphy_tx_gains gains,
-			   int mode, bool useindex, u8 index)
-{
-	//TODO
-}
-
 static void lpphy_papd_cal_txpwr(struct b43_wldev *dev)
 {
 	struct b43_phy_lp *lpphy = dev->phy.lp;
@@ -1848,11 +1842,6 @@ static void lpphy_papd_cal_txpwr(struct b43_wldev *dev)
 
 	lpphy_set_tx_power_control(dev, B43_LPPHY_TXPCTL_OFF);
 
-	if (dev->dev->chip_id == 0x4325 && dev->dev->chip_rev == 0)
-		lpphy_papd_cal(dev, oldgains, 0, 1, 30);
-	else
-		lpphy_papd_cal(dev, oldgains, 0, 1, 65);
-
 	if (old_afe_ovr)
 		lpphy_set_tx_gains(dev, oldgains);
 	lpphy_set_bb_mult(dev, old_bbmult);
-- 
2.21.0

