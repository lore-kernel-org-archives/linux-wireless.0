Return-Path: <SRS0=AjP+=NE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA9D0C67863
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 06:05:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D569206B5
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 06:05:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7D569206B5
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbeJXObg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Oct 2018 10:31:36 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:52768 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726080AbeJXObf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Oct 2018 10:31:35 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id A698C7D51925C;
        Wed, 24 Oct 2018 14:04:54 +0800 (CST)
Received: from linux-ibm.site (10.175.102.37) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.408.0; Wed, 24 Oct 2018 14:04:51 +0800
From:   zhong jiang <zhongjiang@huawei.com>
To:     <kvalo@codeaurora.org>
CC:     <pkshih@realtek.com>, <davem@davemloft.net>,
        <linux-wireless@vger.kernel.org>, <joe@perches.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCHv3] rtlwifi: rtl8723ae: Remove set but not used variables and #defines
Date:   Wed, 24 Oct 2018 13:52:09 +0800
Message-ID: <1540360329-65013-1-git-send-email-zhongjiang@huawei.com>
X-Mailer: git-send-email 1.7.12.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.102.37]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

radiob_array_table' and 'radiob_arraylen' are not used after setting its value.
It is safe to remove the unused variable. Meanwhile, radio B array should be
removed as well. because it will no longer be referenced.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c   | 5 +----
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/table.c | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/table.h | 2 --
 3 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c
index 5cf29f5..3f33278 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c
@@ -509,13 +509,10 @@ bool rtl8723e_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
 	int i;
 	bool rtstatus = true;
 	u32 *radioa_array_table;
-	u32 *radiob_array_table;
-	u16 radioa_arraylen, radiob_arraylen;
+	u16 radioa_arraylen;
 
 	radioa_arraylen = RTL8723ERADIOA_1TARRAYLENGTH;
 	radioa_array_table = RTL8723E_RADIOA_1TARRAY;
-	radiob_arraylen = RTL8723E_RADIOB_1TARRAYLENGTH;
-	radiob_array_table = RTL8723E_RADIOB_1TARRAY;
 
 	rtstatus = true;
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/table.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/table.c
index 61e8604..1bbee0b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/table.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/table.c
@@ -475,10 +475,6 @@
 	0x000, 0x00030159,
 };
 
-u32 RTL8723E_RADIOB_1TARRAY[RTL8723E_RADIOB_1TARRAYLENGTH] = {
-	0x0,
-};
-
 u32 RTL8723EMAC_ARRAY[RTL8723E_MACARRAYLENGTH] = {
 	0x420, 0x00000080,
 	0x423, 0x00000000,
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/table.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/table.h
index 57a548c..a044f3c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/table.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/table.h
@@ -36,8 +36,6 @@
 extern u32 RTL8723EPHY_REG_ARRAY_PG[RTL8723E_PHY_REG_ARRAY_PGLENGTH];
 #define RTL8723ERADIOA_1TARRAYLENGTH		282
 extern u32 RTL8723E_RADIOA_1TARRAY[RTL8723ERADIOA_1TARRAYLENGTH];
-#define RTL8723E_RADIOB_1TARRAYLENGTH		1
-extern u32 RTL8723E_RADIOB_1TARRAY[RTL8723E_RADIOB_1TARRAYLENGTH];
 #define RTL8723E_MACARRAYLENGTH			172
 extern u32 RTL8723EMAC_ARRAY[RTL8723E_MACARRAYLENGTH];
 #define RTL8723E_AGCTAB_1TARRAYLENGTH		320
-- 
1.7.12.4

