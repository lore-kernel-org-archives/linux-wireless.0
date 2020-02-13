Return-Path: <SRS0=QfV8=4B=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EB2CC352A3
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Feb 2020 05:27:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D2FE2173E
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Feb 2020 05:27:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbgBMF10 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 13 Feb 2020 00:27:26 -0500
Received: from 220-134-220-36.HINET-IP.hinet.net ([220.134.220.36]:57196 "EHLO
        ns.kevlo.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbgBMF10 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Feb 2020 00:27:26 -0500
X-Greylist: delayed 329 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Feb 2020 00:27:25 EST
Received: from ns.kevlo.org (localhost [127.0.0.1])
        by ns.kevlo.org (8.15.2/8.15.2) with ESMTPS id 01D5K11u015681
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Thu, 13 Feb 2020 13:20:02 +0800 (CST)
        (envelope-from kevlo@ns.kevlo.org)
Received: (from kevlo@localhost)
        by ns.kevlo.org (8.15.2/8.15.2/Submit) id 01D5K1bS015680;
        Thu, 13 Feb 2020 13:20:01 +0800 (CST)
        (envelope-from kevlo)
Date:   Thu, 13 Feb 2020 13:20:00 +0800
From:   Kevin Lo <kevlo@kevlo.org>
To:     Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH] rtw88: remove unneeded variable
Message-ID: <20200213052000.GA15671@ns.kevlo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.8.0 (2017-02-23)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remove unneeded fab_version variable in rtw_chip_parameter_setup().
Some of the checks being made were nonsense.

Signed-off-by: Kevin Lo <kevlo@kevlo.org>
---
diff d49f2c5063fdd00f896e408a1c1fa63e6d94a767 /home/kevlo/wireless-drivers-next
blob - 2f73820cd9ba542ebb632267a9460ea87ddcc2a5
file + drivers/net/wireless/realtek/rtw88/main.c
--- drivers/net/wireless/realtek/rtw88/main.c
+++ drivers/net/wireless/realtek/rtw88/main.c
@@ -1118,7 +1118,6 @@ static int rtw_chip_parameter_setup(struct rtw_dev *rt
 	}
 
 	hal->chip_version = rtw_read32(rtwdev, REG_SYS_CFG1);
-	hal->fab_version = BIT_GET_VENDOR_ID(hal->chip_version) >> 2;
 	hal->cut_version = BIT_GET_CHIP_VER(hal->chip_version);
 	hal->mp_chip = (hal->chip_version & BIT_RTL_ID) ? 0 : 1;
 	if (hal->chip_version & BIT_RF_TYPE_ID) {
@@ -1132,11 +1131,6 @@ static int rtw_chip_parameter_setup(struct rtw_dev *rt
 		hal->antenna_tx = BB_PATH_A;
 		hal->antenna_rx = BB_PATH_A;
 	}
-
-	if (hal->fab_version == 2)
-		hal->fab_version = 1;
-	else if (hal->fab_version == 1)
-		hal->fab_version = 2;
 
 	efuse->physical_size = chip->phy_efuse_size;
 	efuse->logical_size = chip->log_efuse_size;
blob - c074cef22120a222948cfab03ca0bd25baa80844
file + drivers/net/wireless/realtek/rtw88/main.h
--- drivers/net/wireless/realtek/rtw88/main.h
+++ drivers/net/wireless/realtek/rtw88/main.h
@@ -1527,7 +1527,6 @@ struct rtw_hal {
 	u32 rcr;
 
 	u32 chip_version;
-	u8 fab_version;
 	u8 cut_version;
 	u8 mp_chip;
 	u8 oem_id;
