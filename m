Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:49150 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758664Ab1DYSXU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2011 14:23:20 -0400
Date: Mon, 25 Apr 2011 13:23:05 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	chaoming_li@realsil.com.cn
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 04/18] rtlwifi: Change cam routines for addition of
 rtl8192se and rtl8192de
Message-ID: <4db5bc09.t2voPC9T0bfzBZ+h%Larry.Finger@lwfinger.net> (sfid-20110425_202324_399388_9FA30283)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaoming_Li <chaoming_li@realsil.com.cn>

Change cam routines for addition of RTL8192SE and RTL8192DE code

Signed-off-by: Chaoming_Li <chaoming_li@realsil.com.cn>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

 cam.c |  107 +++++++++++++++++++++++++++++++++++++++++++++++++++++-------------
 cam.h |    6 +++
 2 files changed, 91 insertions(+), 22 deletions(-)
---

Index: wireless-testing/drivers/net/wireless/rtlwifi/cam.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/cam.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/cam.c
@@ -23,6 +23,8 @@
  * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
  * Hsinchu 300, Taiwan.
  *
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
  *****************************************************************************/
 
 #include "wifi.h"
@@ -49,7 +51,7 @@ static void rtl_cam_program_entry(struct
 	u32 target_content = 0;
 	u8 entry_i;
 
-	RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG,
+	RT_TRACE(rtlpriv, COMP_SEC, DBG_LOUD,
 		 ("key_cont_128:\n %x:%x:%x:%x:%x:%x\n",
 		  key_cont_128[0], key_cont_128[1],
 		  key_cont_128[2], key_cont_128[3],
@@ -68,15 +70,13 @@ static void rtl_cam_program_entry(struct
 			rtl_write_dword(rtlpriv, rtlpriv->cfg->maps[RWCAM],
 					target_command);
 
-			RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG,
-				 ("rtl_cam_program_entry(): "
-				  "WRITE %x: %x\n",
+			RT_TRACE(rtlpriv, COMP_SEC, DBG_LOUD,
+				 ("WRITE %x: %x\n",
 				  rtlpriv->cfg->maps[WCAMI], target_content));
-			RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG,
+			RT_TRACE(rtlpriv, COMP_SEC, DBG_LOUD,
 				 ("The Key ID is %d\n", entry_no));
-			RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG,
-				 ("rtl_cam_program_entry(): "
-				  "WRITE %x: %x\n",
+			RT_TRACE(rtlpriv, COMP_SEC, DBG_LOUD,
+				 ("WRITE %x: %x\n",
 				  rtlpriv->cfg->maps[RWCAM], target_command));
 
 		} else if (entry_i == 1) {
@@ -91,12 +91,10 @@ static void rtl_cam_program_entry(struct
 			rtl_write_dword(rtlpriv, rtlpriv->cfg->maps[RWCAM],
 					target_command);
 
-			RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG,
-				 ("rtl_cam_program_entry(): WRITE A4: %x\n",
-				  target_content));
-			RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG,
-				 ("rtl_cam_program_entry(): WRITE A0: %x\n",
-				  target_command));
+			RT_TRACE(rtlpriv, COMP_SEC, DBG_LOUD,
+				 ("WRITE A4: %x\n", target_content));
+			RT_TRACE(rtlpriv, COMP_SEC, DBG_LOUD,
+				 ("WRITE A0: %x\n", target_command));
 
 		} else {
 
@@ -113,16 +111,14 @@ static void rtl_cam_program_entry(struct
 					target_command);
 			udelay(100);
 
-			RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG,
-				 ("rtl_cam_program_entry(): WRITE A4: %x\n",
-				  target_content));
-			RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG,
-				 ("rtl_cam_program_entry(): WRITE A0: %x\n",
-				  target_command));
+			RT_TRACE(rtlpriv, COMP_SEC, DBG_LOUD,
+				 ("WRITE A4: %x\n", target_content));
+			RT_TRACE(rtlpriv, COMP_SEC, DBG_LOUD,
+				 ("WRITE A0: %x\n", target_command));
 		}
 	}
 
-	RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG,
+	RT_TRACE(rtlpriv, COMP_SEC, DBG_LOUD,
 		 ("after set key, usconfig:%x\n", us_config));
 }
 
@@ -289,3 +285,72 @@ void rtl_cam_empty_entry(struct ieee8021
 
 }
 EXPORT_SYMBOL(rtl_cam_empty_entry);
+
+u8 rtl_cam_get_free_entry(struct ieee80211_hw *hw, u8 *sta_addr)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	u32 bitmap = (rtlpriv->sec.hwsec_cam_bitmap) >> 4;
+	u8 entry_idx = 0;
+	u8 i, *addr;
+
+	if (NULL == sta_addr) {
+		RT_TRACE(rtlpriv, COMP_SEC, DBG_EMERG,
+			("sta_addr is NULL.\n"));
+		return TOTAL_CAM_ENTRY;
+	}
+	/* Does STA already exist? */
+	for (i = 4; i < TOTAL_CAM_ENTRY; i++) {
+		addr = rtlpriv->sec.hwsec_cam_sta_addr[i];
+		if (memcmp(addr, sta_addr, ETH_ALEN) == 0)
+			return i;
+	}
+	/* Get a free CAM entry. */
+	for (entry_idx = 4; entry_idx < TOTAL_CAM_ENTRY; entry_idx++) {
+		if ((bitmap & BIT(0)) == 0) {
+			RT_TRACE(rtlpriv, COMP_SEC, DBG_EMERG,
+				("-----hwsec_cam_bitmap: 0x%x entry_idx=%d\n",
+				 rtlpriv->sec.hwsec_cam_bitmap, entry_idx));
+			rtlpriv->sec.hwsec_cam_bitmap |= BIT(0) << entry_idx;
+			memcpy(rtlpriv->sec.hwsec_cam_sta_addr[entry_idx],
+			       sta_addr, ETH_ALEN);
+			return entry_idx;
+		}
+		bitmap = bitmap >> 1;
+	}
+	return TOTAL_CAM_ENTRY;
+}
+EXPORT_SYMBOL(rtl_cam_get_free_entry);
+
+void rtl_cam_del_entry(struct ieee80211_hw *hw, u8 *sta_addr)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	u32 bitmap;
+	u8 i, *addr;
+
+	if (NULL == sta_addr) {
+		RT_TRACE(rtlpriv, COMP_SEC, DBG_EMERG,
+			("sta_addr is NULL.\n"));
+	}
+
+	if ((sta_addr[0]|sta_addr[1]|sta_addr[2]|sta_addr[3]|\
+				sta_addr[4]|sta_addr[5]) == 0) {
+		RT_TRACE(rtlpriv, COMP_SEC, DBG_EMERG,
+			("sta_addr is 00:00:00:00:00:00.\n"));
+		return;
+	}
+	/* Does STA already exist? */
+	for (i = 4; i < TOTAL_CAM_ENTRY; i++) {
+		addr = rtlpriv->sec.hwsec_cam_sta_addr[i];
+		bitmap = (rtlpriv->sec.hwsec_cam_bitmap) >> i;
+		if (((bitmap & BIT(0)) == BIT(0)) &&
+		    (memcmp(addr, sta_addr, ETH_ALEN) == 0)) {
+			/* Remove from HW Security CAM */
+			memset(rtlpriv->sec.hwsec_cam_sta_addr[i], 0, ETH_ALEN);
+			rtlpriv->sec.hwsec_cam_bitmap &= ~(BIT(0) << i);
+			printk(KERN_INFO "&&&&&&&&&del entry %d\n", i);
+		}
+	}
+	return;
+}
+EXPORT_SYMBOL(rtl_cam_del_entry);
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/cam.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/cam.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/cam.h
@@ -23,12 +23,13 @@
  * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
  * Hsinchu 300, Taiwan.
  *
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
  *****************************************************************************/
 
 #ifndef __RTL_CAM_H_
 #define __RTL_CAM_H_
 
-#define TOTAL_CAM_ENTRY					32
 #define CAM_CONTENT_COUNT				8
 
 #define CFG_DEFAULT_KEY					BIT(5)
@@ -49,5 +50,8 @@ int rtl_cam_delete_one_entry(struct ieee
 void rtl_cam_mark_invalid(struct ieee80211_hw *hw, u8 uc_index);
 void rtl_cam_empty_entry(struct ieee80211_hw *hw, u8 uc_index);
 void rtl_cam_reset_sec_info(struct ieee80211_hw *hw);
+u8 rtl_cam_get_free_entry(struct ieee80211_hw *hw, u8 *sta_addr);
+void rtl_cam_del_entry(struct ieee80211_hw *hw, u8 *sta_addr);
 
 #endif
+
