Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:52800 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756063AbdL2Ibo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Dec 2017 03:31:44 -0500
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <yhchuang@realtek.com>, <Larry.Finger@lwfinger.net>,
        <johannes.berg@intel.com>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 11/11] rtlwifi: fill FW version and subversion
Date: Fri, 29 Dec 2017 16:31:12 +0800
Message-ID: <20171229083112.31540-12-pkshih@realtek.com> (sfid-20171229_093248_745303_51547285)
In-Reply-To: <20171229083112.31540-1-pkshih@realtek.com>
References: <20171229083112.31540-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

This commit fills FW version information of RTL8188EE and RTL8723, so
the btcoex can cooperate with FW correctly.
Also, we can display this version in debugfs.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.c         | 2 ++
 drivers/net/wireless/realtek/rtlwifi/rtl8723com/fw_common.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.c
index a2eca669873b..63874512598b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.c
@@ -141,6 +141,8 @@ int rtl88e_download_fw(struct ieee80211_hw *hw,
 		return 1;
 
 	pfwheader = (struct rtlwifi_firmware_header *)rtlhal->pfirmware;
+	rtlhal->fw_version = le16_to_cpu(pfwheader->version);
+	rtlhal->fw_subversion = pfwheader->subversion;
 	pfwdata = rtlhal->pfirmware;
 	fwsize = rtlhal->fwsize;
 	RT_TRACE(rtlpriv, COMP_FW, DBG_DMESG,
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723com/fw_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723com/fw_common.c
index 0d1ebc861720..521039c5d4ce 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723com/fw_common.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723com/fw_common.c
@@ -200,6 +200,8 @@ int rtl8723_download_fw(struct ieee80211_hw *hw,
 		return 1;
 
 	pfwheader = (struct rtlwifi_firmware_header *)rtlhal->pfirmware;
+	rtlhal->fw_version = le16_to_cpu(pfwheader->version);
+	rtlhal->fw_subversion = pfwheader->subversion;
 	pfwdata = rtlhal->pfirmware;
 	fwsize = rtlhal->fwsize;
 
-- 
2.14.1
