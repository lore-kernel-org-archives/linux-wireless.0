Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:33387 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbaJKSAL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Oct 2014 14:00:11 -0400
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, troy_tan@realsil.com.cn,
	Larry Finger <Larry.Finger@lwfinger.net>,
	netdev@vger.kernel.org
Subject: [PATCH V3.18] rtlwifi: rtl8192ee: Prevent log spamming for switch statements
Date: Sat, 11 Oct 2014 12:59:53 -0500
Message-Id: <1413050393-6257-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20141011_200018_097956_134340DE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver logs a message when the default branch of switch statements are
taken. Such information is useful when debugging, but these log items should
not be seen for standard usage.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8192ee/hw.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192ee/hw.c b/drivers/net/wireless/rtlwifi/rtl8192ee/hw.c
index dfdc9b2..1a87edc 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ee/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ee/hw.c
@@ -362,7 +362,7 @@ void rtl92ee_get_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 		}
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_DMESG,
 			 "switch case not process %x\n", variable);
 		break;
 	}
@@ -591,7 +591,7 @@ void rtl92ee_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 				acm_ctrl &= (~ACMHW_BEQEN);
 				break;
 			default:
-				RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+				RT_TRACE(rtlpriv, COMP_ERR, DBG_DMESG,
 					 "switch case not process\n");
 				break;
 			}
@@ -710,7 +710,7 @@ void rtl92ee_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 		}
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_DMESG,
 			 "switch case not process %x\n", variable);
 		break;
 	}
@@ -2424,7 +2424,7 @@ void rtl92ee_set_key(struct ieee80211_hw *hw, u32 key_index,
 			enc_algo = CAM_AES;
 			break;
 		default:
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+			RT_TRACE(rtlpriv, COMP_ERR, DBG_DMESG,
 				 "switch case not process\n");
 			enc_algo = CAM_TKIP;
 			break;
-- 
1.8.4.5

