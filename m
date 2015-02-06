Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755550AbbBFWYn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2015 17:24:43 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: Larry.Finger@lwfinger.net, wlanfae@realtek.com,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 1/1] rtlwifi: Clear ACM_CTRL AC3_VO bit correctly
Date: Fri,  6 Feb 2015 17:24:32 -0500
Message-Id: <1423261472-4607-2-git-send-email-Jes.Sorensen@redhat.com> (sfid-20150206_232459_481066_49885480)
In-Reply-To: <1423261472-4607-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1423261472-4607-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

All hw driver components in the rtlwifi driver, except for the
rtl8192de component has this bug. They would clear BE bit in the
ACM_CTRL register instead of the VO bit when processing the VO queue.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/rtlwifi/rtl8188ee/hw.c | 2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c | 2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c | 2 +-
 drivers/net/wireless/rtlwifi/rtl8192ee/hw.c | 2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c | 2 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/hw.c | 2 +-
 drivers/net/wireless/rtlwifi/rtl8723be/hw.c | 2 +-
 drivers/net/wireless/rtlwifi/rtl8821ae/hw.c | 2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c b/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
index f2b9713..edc2cbb 100644
--- a/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
@@ -566,7 +566,7 @@ void rtl88ee_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 				acm_ctrl &= (~ACMHW_VIQEN);
 				break;
 			case AC3_VO:
-				acm_ctrl &= (~ACMHW_BEQEN);
+				acm_ctrl &= (~ACMHW_VOQEN);
 				break;
 			default:
 				RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
index 5c646d5..545b2c1 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
@@ -363,7 +363,7 @@ void rtl92ce_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 					acm_ctrl &= (~AcmHw_ViqEn);
 					break;
 				case AC3_VO:
-					acm_ctrl &= (~AcmHw_BeqEn);
+					acm_ctrl &= (~AcmHw_VoqEn);
 					break;
 				default:
 					RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
index 5513217..ab38e68 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
@@ -1867,7 +1867,7 @@ void rtl92cu_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 					acm_ctrl &= (~AcmHw_ViqEn);
 					break;
 				case AC3_VO:
-					acm_ctrl &= (~AcmHw_BeqEn);
+					acm_ctrl &= (~AcmHw_VoqEn);
 					break;
 				default:
 					RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ee/hw.c b/drivers/net/wireless/rtlwifi/rtl8192ee/hw.c
index 1a87edc..bac42e4 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ee/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ee/hw.c
@@ -588,7 +588,7 @@ void rtl92ee_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 				acm_ctrl &= (~ACMHW_VIQEN);
 				break;
 			case AC3_VO:
-				acm_ctrl &= (~ACMHW_BEQEN);
+				acm_ctrl &= (~ACMHW_VOQEN);
 				break;
 			default:
 				RT_TRACE(rtlpriv, COMP_ERR, DBG_DMESG,
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/hw.c b/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
index 5761d5b..dee88a8 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
@@ -293,7 +293,7 @@ void rtl92se_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 					acm_ctrl &= (~AcmHw_ViqEn);
 					break;
 				case AC3_VO:
-					acm_ctrl &= (~AcmHw_BeqEn);
+					acm_ctrl &= (~AcmHw_VoqEn);
 					break;
 				default:
 					RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/hw.c b/drivers/net/wireless/rtlwifi/rtl8723ae/hw.c
index aa08546..b3b0947 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723ae/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723ae/hw.c
@@ -362,7 +362,7 @@ void rtl8723e_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 					acm_ctrl &= (~ACMHW_VIQEN);
 					break;
 				case AC3_VO:
-					acm_ctrl &= (~ACMHW_BEQEN);
+					acm_ctrl &= (~ACMHW_VOQEN);
 					break;
 				default:
 					RT_TRACE(rtlpriv, COMP_ERR, DBG_LOUD,
diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/hw.c b/drivers/net/wireless/rtlwifi/rtl8723be/hw.c
index 6dad28e..b469983 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723be/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723be/hw.c
@@ -603,7 +603,7 @@ void rtl8723be_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 				acm_ctrl &= (~ACMHW_VIQEN);
 				break;
 			case AC3_VO:
-				acm_ctrl &= (~ACMHW_BEQEN);
+				acm_ctrl &= (~ACMHW_VOQEN);
 				break;
 			default:
 				RT_TRACE(rtlpriv, COMP_ERR, DBG_LOUD,
diff --git a/drivers/net/wireless/rtlwifi/rtl8821ae/hw.c b/drivers/net/wireless/rtlwifi/rtl8821ae/hw.c
index 8ec8200..ac235df 100644
--- a/drivers/net/wireless/rtlwifi/rtl8821ae/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8821ae/hw.c
@@ -667,7 +667,7 @@ void rtl8821ae_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 				acm_ctrl &= (~ACMHW_VIQEN);
 				break;
 			case AC3_VO:
-				acm_ctrl &= (~ACMHW_BEQEN);
+				acm_ctrl &= (~ACMHW_VOQEN);
 				break;
 			default:
 				RT_TRACE(rtlpriv, COMP_ERR, DBG_LOUD,
-- 
2.1.0

