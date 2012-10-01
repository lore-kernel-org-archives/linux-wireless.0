Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:4930 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945Ab2JALkY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Oct 2012 07:40:24 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	"David S . Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.or,
	Joe Perches <joe@perches.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv3] rtlwifi: rtl8192ce: rtl8192cu: use %*phC to dump small buffers
Date: Mon,  1 Oct 2012 14:40:15 +0300
Message-Id: <1349091615-4043-1-git-send-email-andriy.shevchenko@linux.intel.com> (sfid-20121001_134027_818947_21755770)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch changes a bit trace output format in the rtl_cam_program_entry() to
print prefix and the actual data on the same line. Moreover the %*phC outputs
each byte as 2 hex digits, which is slightly different to the original %x.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/cam.c          |    7 ++-----
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c |    6 ++----
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c |    6 ++----
 3 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/cam.c b/drivers/net/wireless/rtlwifi/cam.c
index 5b4b4d4..9af2172 100644
--- a/drivers/net/wireless/rtlwifi/cam.c
+++ b/drivers/net/wireless/rtlwifi/cam.c
@@ -52,11 +52,8 @@ static void rtl_cam_program_entry(struct ieee80211_hw *hw, u32 entry_no,
 	u32 target_content = 0;
 	u8 entry_i;
 
-	RT_TRACE(rtlpriv, COMP_SEC, DBG_LOUD,
-		 "key_cont_128:\n %x:%x:%x:%x:%x:%x\n",
-		 key_cont_128[0], key_cont_128[1],
-		 key_cont_128[2], key_cont_128[3],
-		 key_cont_128[4], key_cont_128[5]);
+	RT_TRACE(rtlpriv, COMP_SEC, DBG_LOUD, "key_cont_128: %*phC\n",
+		 6, key_cont_128);
 
 	for (entry_i = 0; entry_i < CAM_CONTENT_COUNT; entry_i++) {
 		target_command = entry_i + CAM_CONTENT_COUNT * entry_no;
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
index 86d73b3..932780d 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
@@ -1918,10 +1918,8 @@ static void rtl92ce_update_hal_rate_mask(struct ieee80211_hw *hw,
 				     (ratr_index << 28);
 	rate_mask[4] = macid | (shortgi ? 0x20 : 0x00) | 0x80;
 	RT_TRACE(rtlpriv, COMP_RATR, DBG_DMESG,
-		 "Rate_index:%x, ratr_val:%x, %x:%x:%x:%x:%x\n",
-		 ratr_index, ratr_bitmap,
-		 rate_mask[0], rate_mask[1], rate_mask[2], rate_mask[3],
-		 rate_mask[4]);
+		 "Rate_index:%x, ratr_val:%x, %*phC\n",
+		 ratr_index, ratr_bitmap, 5, rate_mask);
 	rtl92c_fill_h2c_cmd(hw, H2C_RA_MASK, 5, rate_mask);
 
 	if (macid != 0)
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
index 4bbb711..7554501 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
@@ -2169,10 +2169,8 @@ void rtl92cu_update_hal_rate_mask(struct ieee80211_hw *hw, u8 rssi_level)
 				      ratr_index << 28);
 	rate_mask[4] = macid | (shortgi ? 0x20 : 0x00) | 0x80;
 	RT_TRACE(rtlpriv, COMP_RATR, DBG_DMESG,
-		 "Rate_index:%x, ratr_val:%x, %x:%x:%x:%x:%x\n",
-		 ratr_index, ratr_bitmap,
-		 rate_mask[0], rate_mask[1], rate_mask[2], rate_mask[3],
-		 rate_mask[4]);
+		 "Rate_index:%x, ratr_val:%x, %*phC\n",
+		 ratr_index, ratr_bitmap, 5, rate_mask);
 	rtl92c_fill_h2c_cmd(hw, H2C_RA_MASK, 5, rate_mask);
 }
 
-- 
1.7.10.4

