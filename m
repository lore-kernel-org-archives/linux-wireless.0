Return-Path: <SRS0=dpF5=4C=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC830C2BA83
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Feb 2020 14:19:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E82B206B6
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Feb 2020 14:19:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729336AbgBNOTq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Feb 2020 09:19:46 -0500
Received: from 220-134-220-36.HINET-IP.hinet.net ([220.134.220.36]:63084 "EHLO
        ns.kevlo.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726191AbgBNOTp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Feb 2020 09:19:45 -0500
Received: from ns.kevlo.org (localhost [127.0.0.1])
        by ns.kevlo.org (8.15.2/8.15.2) with ESMTPS id 01EEGlqJ026360
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 14 Feb 2020 22:17:02 +0800 (CST)
        (envelope-from kevlo@ns.kevlo.org)
Received: (from kevlo@localhost)
        by ns.kevlo.org (8.15.2/8.15.2/Submit) id 01EEGlcC026359;
        Fri, 14 Feb 2020 22:16:47 +0800 (CST)
        (envelope-from kevlo)
Date:   Fri, 14 Feb 2020 22:16:45 +0800
From:   Kevin Lo <kevlo@kevlo.org>
To:     Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH v2] rtw88: remove unused member of struct rtw_hal
Message-ID: <20200214141645.GA26343@ns.kevlo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.8.0 (2017-02-23)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remove unused fab_version member from struct rtw_hal.
Some of the checks being made were nonsense.

Signed-off-by: Kevin Lo <kevlo@kevlo.org>
---
v2: rebase on top of master
---
diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index 2f73820cd9ba..dc93a4d04f25 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -1118,7 +1118,6 @@ static int rtw_chip_parameter_setup(struct rtw_dev *rtwdev)
 	}
 
 	hal->chip_version = rtw_read32(rtwdev, REG_SYS_CFG1);
-	hal->fab_version = BIT_GET_VENDOR_ID(hal->chip_version) >> 2;
 	hal->cut_version = BIT_GET_CHIP_VER(hal->chip_version);
 	hal->mp_chip = (hal->chip_version & BIT_RTL_ID) ? 0 : 1;
 	if (hal->chip_version & BIT_RF_TYPE_ID) {
@@ -1133,11 +1132,6 @@ static int rtw_chip_parameter_setup(struct rtw_dev *rtwdev)
 		hal->antenna_rx = BB_PATH_A;
 	}
 
-	if (hal->fab_version == 2)
-		hal->fab_version = 1;
-	else if (hal->fab_version == 1)
-		hal->fab_version = 2;
-
 	efuse->physical_size = chip->phy_efuse_size;
 	efuse->logical_size = chip->log_efuse_size;
 	efuse->protect_size = chip->ptct_efuse_size;
diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
index c074cef22120..201ed8870754 100644
--- a/drivers/net/wireless/realtek/rtw88/main.h
+++ b/drivers/net/wireless/realtek/rtw88/main.h
@@ -1527,7 +1527,6 @@ struct rtw_hal {
 	u32 rcr;
 
 	u32 chip_version;
-	u8 fab_version;
 	u8 cut_version;
 	u8 mp_chip;
 	u8 oem_id;
