Return-Path: <SRS0=Z1rL=YC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6EA6ECE58D
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Oct 2019 09:01:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0D4B2133F
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Oct 2019 09:01:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729896AbfJIJB3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 9 Oct 2019 05:01:29 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:52718 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726579AbfJIJB2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Oct 2019 05:01:28 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 753B350DD7A12F2FFBEB;
        Wed,  9 Oct 2019 17:01:26 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Wed, 9 Oct 2019
 17:01:16 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <pkshih@realtek.com>, <kvalo@codeaurora.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH RESEND] rtlwifi: rtl8192ee: Remove set but not used variable 'err'
Date:   Wed, 9 Oct 2019 17:08:27 +0800
Message-ID: <1570612107-13286-1-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c: In function rtl92ee_download_fw:
drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c:111:6: warning: variable err set but not used [-Wunused-but-set-variable]

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
index 67305ce..0546242 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
@@ -108,7 +108,6 @@ int rtl92ee_download_fw(struct ieee80211_hw *hw, bool buse_wake_on_wlan_fw)
 	struct rtlwifi_firmware_header *pfwheader;
 	u8 *pfwdata;
 	u32 fwsize;
-	int err;
 	enum version_8192e version = rtlhal->version;

 	if (!rtlhal->pfirmware)
@@ -146,9 +145,7 @@ int rtl92ee_download_fw(struct ieee80211_hw *hw, bool buse_wake_on_wlan_fw)
 	_rtl92ee_write_fw(hw, version, pfwdata, fwsize);
 	_rtl92ee_enable_fw_download(hw, false);

-	err = _rtl92ee_fw_free_to_go(hw);
-
-	return 0;
+	return _rtl92ee_fw_free_to_go(hw);
 }

 static bool _rtl92ee_check_fw_read_last_h2c(struct ieee80211_hw *hw, u8 boxnum)
--
2.7.4

