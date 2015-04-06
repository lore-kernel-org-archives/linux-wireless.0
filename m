Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:36324 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbbDFSNM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Apr 2015 14:13:12 -0400
Received: by pabsx10 with SMTP id sx10so51491613pab.3
        for <linux-wireless@vger.kernel.org>; Mon, 06 Apr 2015 11:13:11 -0700 (PDT)
From: Taehee Yoo <ap420073@gmail.com>
To: Larry.Finger@lwfinger.net, ap420073@gmail.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8192cu: Remove and replace routine in hw.c and mac.c
Date: Tue,  7 Apr 2015 03:13:00 +0900
Message-Id: <1428343980-13954-1-git-send-email-ap420073@gmail.com> (sfid-20150406_201316_597757_3D5AFBB1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I remove duplicated routines which related rtl92cu_set_hw_reg().

1. rtl92c_set_qos() and HW_VAR_AC_PARAM routine are similar code.
so i replace code with rtlpriv->cfg->ops->set_hw_reg().

2. rtl92c_set_mac_addr() and 'HW_VAR_ETHER_ADDR' case at
rtl92cu_set_hw_reg() routine are similar code.
so i removed rtl92c_set_mac_addr() function.
also it was not used anywhere.

3. remove HW_VAR_ACM_CTRL routine in rtl92cu_set_hw_reg().
if rtl_usb->acm_method is not EACMWAY2_SW, HW_VAR_ACM_CTRL is called
from HW_VAR_AC_PARAM. but it never called. because acm_method is always
EACMWAY2_SW. so i remove acm_method check routine
and HW_VAR_ACM_CTRL routine.

both usb and pci interface is not used HW_VAR_ACM_CTRL.
but i can't test pci interface module, so i didn't modify pci code.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c  | 56 +---------------------------
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.c | 52 +-------------------------
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.h |  1 -
 3 files changed, 2 insertions(+), 107 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
index be9dba3..8eed922 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
@@ -1609,7 +1609,6 @@ void rtl92cu_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
-	struct rtl_usb *rtlusb = rtl_usbdev(rtl_usbpriv(hw));
 	enum wireless_mode wirelessmode = mac->mode;
 	u8 idx = 0;
 
@@ -1818,63 +1817,10 @@ void rtl92cu_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 						u4b_ac_param);
 				break;
 			default:
-				RT_ASSERT(false,
-					  "SetHwReg8185(): invalid aci: %d !\n",
+				RT_ASSERT(false, "invalid aci: %d !\n",
 					  e_aci);
 				break;
 			}
-			if (rtlusb->acm_method != EACMWAY2_SW)
-				rtlpriv->cfg->ops->set_hw_reg(hw,
-					 HW_VAR_ACM_CTRL, &e_aci);
-			break;
-		}
-	case HW_VAR_ACM_CTRL:{
-			u8 e_aci = *val;
-			union aci_aifsn *p_aci_aifsn = (union aci_aifsn *)
-							(&(mac->ac[0].aifs));
-			u8 acm = p_aci_aifsn->f.acm;
-			u8 acm_ctrl = rtl_read_byte(rtlpriv, REG_ACMHWCTRL);
-
-			acm_ctrl =
-			    acm_ctrl | ((rtlusb->acm_method == 2) ? 0x0 : 0x1);
-			if (acm) {
-				switch (e_aci) {
-				case AC0_BE:
-					acm_ctrl |= AcmHw_BeqEn;
-					break;
-				case AC2_VI:
-					acm_ctrl |= AcmHw_ViqEn;
-					break;
-				case AC3_VO:
-					acm_ctrl |= AcmHw_VoqEn;
-					break;
-				default:
-					RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
-						 "HW_VAR_ACM_CTRL acm set failed: eACI is %d\n",
-						 acm);
-					break;
-				}
-			} else {
-				switch (e_aci) {
-				case AC0_BE:
-					acm_ctrl &= (~AcmHw_BeqEn);
-					break;
-				case AC2_VI:
-					acm_ctrl &= (~AcmHw_ViqEn);
-					break;
-				case AC3_VO:
-					acm_ctrl &= (~AcmHw_VoqEn);
-					break;
-				default:
-					RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-						 "switch case not processed\n");
-					break;
-				}
-			}
-			RT_TRACE(rtlpriv, COMP_QOS, DBG_TRACE,
-				 "SetHwReg8190pci(): [HW_VAR_ACM_CTRL] Write 0x%X\n",
-				 acm_ctrl);
-			rtl_write_byte(rtlpriv, REG_ACMHWCTRL, acm_ctrl);
 			break;
 		}
 	case HW_VAR_RCR:{
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
index 6e033c7..bfe4f11 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
@@ -405,59 +405,9 @@ void rtl92c_disable_interrupt(struct ieee80211_hw *hw)
 void rtl92c_set_qos(struct ieee80211_hw *hw, int aci)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
-	u32 u4b_ac_param;
 
 	rtl92c_dm_init_edca_turbo(hw);
-	u4b_ac_param = (u32) mac->ac[aci].aifs;
-	u4b_ac_param |=
-	    ((u32) le16_to_cpu(mac->ac[aci].cw_min) & 0xF) <<
-	    AC_PARAM_ECW_MIN_OFFSET;
-	u4b_ac_param |=
-	    ((u32) le16_to_cpu(mac->ac[aci].cw_max) & 0xF) <<
-	    AC_PARAM_ECW_MAX_OFFSET;
-	u4b_ac_param |= (u32) le16_to_cpu(mac->ac[aci].tx_op) <<
-			 AC_PARAM_TXOP_OFFSET;
-	RT_TRACE(rtlpriv, COMP_QOS, DBG_LOUD, "queue:%x, ac_param:%x\n",
-		 aci, u4b_ac_param);
-	switch (aci) {
-	case AC1_BK:
-		rtl_write_dword(rtlpriv, REG_EDCA_BK_PARAM, u4b_ac_param);
-		break;
-	case AC0_BE:
-		rtl_write_dword(rtlpriv, REG_EDCA_BE_PARAM, u4b_ac_param);
-		break;
-	case AC2_VI:
-		rtl_write_dword(rtlpriv, REG_EDCA_VI_PARAM, u4b_ac_param);
-		break;
-	case AC3_VO:
-		rtl_write_dword(rtlpriv, REG_EDCA_VO_PARAM, u4b_ac_param);
-		break;
-	default:
-		RT_ASSERT(false, "invalid aci: %d !\n", aci);
-		break;
-	}
-}
-
-/*-------------------------------------------------------------------------
- * HW MAC Address
- *-------------------------------------------------------------------------*/
-void rtl92c_set_mac_addr(struct ieee80211_hw *hw, const u8 *addr)
-{
-	u32 i;
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-
-	for (i = 0 ; i < ETH_ALEN ; i++)
-		rtl_write_byte(rtlpriv, (REG_MACID + i), *(addr+i));
-
-	RT_TRACE(rtlpriv, COMP_CMD, DBG_DMESG,
-		 "MAC Address: %02X-%02X-%02X-%02X-%02X-%02X\n",
-		 rtl_read_byte(rtlpriv, REG_MACID),
-		 rtl_read_byte(rtlpriv, REG_MACID+1),
-		 rtl_read_byte(rtlpriv, REG_MACID+2),
-		 rtl_read_byte(rtlpriv, REG_MACID+3),
-		 rtl_read_byte(rtlpriv, REG_MACID+4),
-		 rtl_read_byte(rtlpriv, REG_MACID+5));
+	rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_AC_PARAM, (u8 *)&aci);
 }
 
 void rtl92c_init_driver_info_size(struct ieee80211_hw *hw, u8 size)
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.h b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.h
index 969819d..1b69ba2 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.h
@@ -48,7 +48,6 @@ void rtl92c_set_qos(struct ieee80211_hw *hw, int aci);
 /*---------------------------------------------------------------
  *	Hardware init functions
  *---------------------------------------------------------------*/
-void rtl92c_set_mac_addr(struct ieee80211_hw *hw, const u8 *addr);
 void rtl92c_init_interrupt(struct ieee80211_hw *hw);
 void rtl92c_init_driver_info_size(struct ieee80211_hw *hw, u8 size);
 
-- 
1.9.1

