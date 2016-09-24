Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36834 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759279AbcIXQ5i (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 24 Sep 2016 12:57:38 -0400
Received: by mail-oi0-f65.google.com with SMTP id i193so10910803oib.3
        for <linux-wireless@vger.kernel.org>; Sat, 24 Sep 2016 09:57:38 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 1/2] rtlwifi: Add HAL_DEF_WOWLAN case to *_get_hw() routines
Date: Sat, 24 Sep 2016 11:57:18 -0500
Message-Id: <1474736239-9826-2-git-send-email-Larry.Finger@lwfinger.net> (sfid-20160924_185741_591481_C9933CB8)
In-Reply-To: <1474736239-9826-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1474736239-9826-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Only rtl8821ae implements WOWLAN; however, the other drivers may receive
a call requesting information about this mode. The other drivers need to
ignore the request rather than logging that the default branch of the
switch statement has been reached.

Reported by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

This patch depends on "realtek: Add switch variable to 'switch case not
processed' messages" submitted by Joe Perches.

Larry
---

 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c | 2 ++
 drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c | 2 ++
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c | 2 ++
 drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c | 2 ++
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c | 2 ++
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c | 2 ++
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c | 2 ++
 7 files changed, 14 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
index 3285117..37d6efc 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
@@ -355,6 +355,8 @@ void rtl88ee_get_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 
 		*((u64 *)(val)) = tsf;
 		break; }
+	case HAL_DEF_WOWLAN:
+		break;
 	default:
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 			 "switch case %#x not processed\n", variable);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c
index 6d308f9..a47be73 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c
@@ -141,6 +141,8 @@ void rtl92ce_get_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 
 		break;
 		}
+	case HAL_DEF_WOWLAN:
+		break;
 	default:
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 			 "switch case %#x not processed\n", variable);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c
index 5369011..d91f8bb 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c
@@ -164,6 +164,8 @@ void rtl92de_get_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 	case HW_VAR_INT_AC:
 		*((bool *)(val)) = rtlpriv->dm.disable_tx_int;
 		break;
+	case HAL_DEF_WOWLAN:
+		break;
 	default:
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 			 "switch case %#x not processed\n", variable);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c
index 47bb6d8..ebf663e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c
@@ -338,6 +338,8 @@ void rtl92ee_get_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 		*((u64 *)(val)) = tsf;
 		}
 		break;
+	case HAL_DEF_WOWLAN:
+		break;
 	default:
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_DMESG,
 			 "switch case %#x not processed\n", variable);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c
index 5bad9c9..52e4430 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c
@@ -77,6 +77,8 @@ void rtl92se_get_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 			*((bool *)(val)) = rtlpriv->dm.current_mrc_switch;
 			break;
 		}
+	case HAL_DEF_WOWLAN:
+		break;
 	default: {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 			 "switch case %#x not processed\n", variable);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c
index 2bf603b..f8be0bd 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c
@@ -141,6 +141,8 @@ void rtl8723e_get_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 
 			break;
 		}
+	case HAL_DEF_WOWLAN:
+		break;
 	default:
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_LOUD,
 			 "switch case %#x not processed\n", variable);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
index 999c1ac..aba60c3 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
@@ -348,6 +348,8 @@ void rtl8723be_get_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 		*((u64 *)(val)) = tsf;
 		}
 		break;
+	case HAL_DEF_WOWLAN:
+		break;
 	default:
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_LOUD,
 			 "switch case %#x not processed\n", variable);
-- 
2.6.6
