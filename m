Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52CB446AA66
	for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2026 16:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786726567; cv=none; b=A907uKh4DYOCh1H+qCDLzkF0u5f5dVQjb37LyY5CJx8d00cXxhCD69Rr9Jgc5JGX1BqmN1fnGNSaXCuzGISIqhhCc8Ji8jwtsR25XFY5pZ+dtAJcU/SNqIJya3+1YTH9uBzy9lBAhhk5yTtStiFlNZbmQy1iwmdDCKNf0An2GwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786726567; c=relaxed/simple;
	bh=f4Z1ImQFV3Vdt2rJNVyWd3vziLNcRh4/EUlq5eBddsY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=m636tzWg1rDwCSCFJVEGrgP7Yev1znCRsApN7KwgPbhVZSSqu6q/ckoQViMnrWia3T40JSAy8Rf3Dg6FlhNRkiWKr5IyGDJ8KA5WOiMjpW2bMLSmc3t5vRdRxSpF5M9fOdFSv9orH/01ITQJUY6SS9L7OxuWO1o+fbT4SW/hmB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=q+iCjw2N; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q+iCjw2N"
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-4af7283bf83so492269b6e.3
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2026 09:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786726565; x=1787331365; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=OIuS3KnXviSmkpO9jd4qUQpqGSJTbz6GUjCtrlU2zjU=;
        b=q+iCjw2N2W37JaLPrlRCYeGy4od8fpPm+HJQvMOgb41zyMNVwDb/admPkwpCDoimwm
         AixiijIrtqQi7X3xU5/YjvxzXY/rfdqq0ijLNEk3F+c8Xw1spmSG0Pn44O2qKgt1pPT0
         ZhBqNCtQCdyo4+WMO9oxzvX509laiUw+MMvwHjcp0fhIN2Qs21U11IE+0/ivoMvoh8F3
         xb40xEy+LTUDfnI6AzN4TAhWG27KyuXsBTKloP+dH0QODw0bvIxgDB9GydadZehMhzEJ
         /MBSM35fSNHZ8qaPlk9AeLswI7kVjkgxIySqWNKLSGZDCc1W3VpEXinljt/syipwlWfh
         AIgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786726565; x=1787331365;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OIuS3KnXviSmkpO9jd4qUQpqGSJTbz6GUjCtrlU2zjU=;
        b=KcT6qljstVTw+BlXBduKwQ2dHTaSEu2ympBo+cYloscRRhFPPZZKBOD0pPCg0+M8du
         UuyfQJU+B3fgHrT/NTvw9dUgty7v+1RiM3R9LUHQKhzCwBcmyJiVbtoh5qPqN22tBjgS
         E/Ywqn65U3p+5Z5mKBRkw3BnIjdgexrZJmw9bxqM45ZdkbmicK97Tvr6MpClz70mXbNo
         N0ZIKYpYJSznGr12rol7RE9OxmkdlPBE0KmFDsGAeGieVfHAo75MEj12tsXdQ4UA3xv4
         gywBk64yFqBW5blsPGBr4QUcVHcy+zcksijlovLH0XP+FQbE9k8AIsa9KWkkXT2iV4HJ
         B/JA==
X-Gm-Message-State: AOJu0Yx/5TWFq6fmH4jRg9dmkYe1MSCHVuQvKC0qo4/k2w8KcegANFvL
	+h5pi3hj4Kfwm3jMCtxucT7eEweOYisYbzJeP6wyQwveXmSS7uzYxAuB
X-Gm-Gg: AR+sD11fbXxkmx9BAg77RapZbSDkQKbRNrt0lZy6dUrH6+JclLODqV2nL1QJzQhL5Z2
	L33UNb78e+a5OJqeA1DbolFi0aAS+2d5mWLtdflddLPuqoPXtOGyvETTEG1mvHLib3TP9tKn83J
	Ud6rG3VNXdKRqI1zdx00ZamGeAxyDWzBHipPcGoiTWwg+OY99OMoeOwjH7XJJzcKE+eXUE+f8kq
	X2Tv1oFHcmXncnYNpIJBFB4qeOFAjFDFILTCX8HaJrk21owheSVtxbaka+8s6yh8pouO1v2r9B7
	ZWcN9ZqWViAPf1fVY6Yu5Zvfn8n309fBeHSUB9MM3XWbTaZcrRWPmHmRHlFK7PktahG+RmqkkR4
	56WMQ2XatrDWI+ogDDvFv98BnSgz6ungmLZmUzK1QkqF6wggG8YqxF0ZQDlTs+fIlBVLbzZ2ZXd
	RUTIBpj2uENIyxbtCrRocW5k1KXXtFx+zcrVJ7eOAMN/dKdEZ+uBOSJsJTVXjh8rFGRiEJhVz7X
	L9GH0zEitzB9KSEa5JIR0TZaQb+5cFlJt4=
X-Received: by 2002:a4a:ee14:0:b0:6b0:afc1:d87b with SMTP id 006d021491bc7-6b0d6016835mr6131865eaf.8.1786726564806;
        Fri, 14 Aug 2026 09:56:04 -0700 (PDT)
Received: from cr-x-ubuntu2604-client-1.dev.fyre.ibm.com ([170.225.223.19])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f3e869b7f7sm1304962a34.25.2026.08.14.09.56.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 09:56:04 -0700 (PDT)
From: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
X-Google-Original-From: Chelsy Ratnawat <chelsy.ratnawat1@ibm.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
Subject: [PATCH] wifi: rtlwifi: remove dead mimo_ps handling from rate update code
Date: Fri, 14 Aug 2026 09:55:56 -0700
Message-ID: <20260814165556.1102547-1-chelsy.ratnawat1@ibm.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>

Several rtlwifi drivers declare mimo_ps as IEEE80211_SMPS_OFF
and never modify it. As a result, conditionals checking for
IEEE80211_SMPS_STATIC or IEEE80211_SMPS_DYNAMIC are false,
making those branches unreachable.

Remove the unused mimo_ps variables, drop the dead SMPS
branches, and simplify the remaining rate mask selection logic
without changing runtime behavior. Also move ratr_mask
declarations out of the removed conditional blocks where
appropriate.

Signed-off-by: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
---
 .../wireless/realtek/rtlwifi/rtl8188ee/hw.c   |  2 -
 .../wireless/realtek/rtlwifi/rtl8192ee/hw.c   |  1 -
 .../wireless/realtek/rtlwifi/rtl8192se/hw.c   | 92 ++++++++-----------
 .../wireless/realtek/rtlwifi/rtl8723ae/hw.c   |  1 -
 .../wireless/realtek/rtlwifi/rtl8821ae/hw.c   | 69 ++++++--------
 5 files changed, 67 insertions(+), 98 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
index 53c32e1de7e4..910f8372d83d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
@@ -1970,7 +1970,6 @@ static void rtl88ee_update_hal_rate_table(struct ieee80211_hw *hw,
 	u32 ratr_value;
 	u8 ratr_index = 0;
 	u8 b_nmode = mac->ht_enable;
-	/*u8 mimo_ps = IEEE80211_SMPS_OFF;*/
 	u16 shortgi_rate;
 	u32 tmp_ratr_value;
 	u8 curtxbw_40mhz = mac->bw_40;
@@ -2070,7 +2069,6 @@ static void rtl88ee_update_hal_rate_mask(struct ieee80211_hw *hw,
 	bool b_shortgi = false;
 	u8 rate_mask[5];
 	u8 macid = 0;
-	/*u8 mimo_ps = IEEE80211_SMPS_OFF;*/
 
 	sta_entry = (struct rtl_sta_info *)sta->drv_priv;
 	wirelessmode = sta_entry->wireless_mode;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c
index 48a3c94606be..00048912900c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c
@@ -2266,7 +2266,6 @@ static void rtl92ee_update_hal_rate_mask(struct ieee80211_hw *hw,
 	bool b_shortgi = false;
 	u8 rate_mask[7] = {0};
 	u8 macid = 0;
-	/*u8 mimo_ps = IEEE80211_SMPS_OFF;*/
 	sta_entry = (struct rtl_sta_info *)sta->drv_priv;
 	wirelessmode = sta_entry->wireless_mode;
 	if (mac->opmode == NL80211_IFTYPE_STATION ||
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c
index e5775b94f04e..6b9f247d11e0 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c
@@ -2001,10 +2001,9 @@ static void rtl92se_update_hal_rate_table(struct ieee80211_hw *hw,
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
-	u32 ratr_value;
+	u32 ratr_value, ratr_mask;
 	u8 ratr_index = 0;
 	u8 nmode = mac->ht_enable;
-	u8 mimo_ps = IEEE80211_SMPS_OFF;
 	u16 shortgi_rate = 0;
 	u32 tmp_ratr_value = 0;
 	u8 curtxbw_40mhz = mac->bw_40;
@@ -2032,26 +2031,21 @@ static void rtl92se_update_hal_rate_table(struct ieee80211_hw *hw,
 	case WIRELESS_MODE_N_24G:
 	case WIRELESS_MODE_N_5G:
 		nmode = 1;
-		if (mimo_ps == IEEE80211_SMPS_STATIC) {
-			ratr_value &= 0x0007F005;
-		} else {
-			u32 ratr_mask;
-
-			if (get_rf_type(rtlphy) == RF_1T2R ||
-			    get_rf_type(rtlphy) == RF_1T1R) {
-				if (curtxbw_40mhz)
-					ratr_mask = 0x000ff015;
-				else
-					ratr_mask = 0x000ff005;
-			} else {
-				if (curtxbw_40mhz)
-					ratr_mask = 0x0f0ff015;
-				else
-					ratr_mask = 0x0f0ff005;
-			}
 
-			ratr_value &= ratr_mask;
+		if (get_rf_type(rtlphy) == RF_1T2R ||
+		    get_rf_type(rtlphy) == RF_1T1R) {
+			if (curtxbw_40mhz)
+				ratr_mask = 0x000ff015;
+			else
+				ratr_mask = 0x000ff005;
+		} else {
+			if (curtxbw_40mhz)
+				ratr_mask = 0x0f0ff015;
+			else
+				ratr_mask = 0x0f0ff005;
 		}
+
+		ratr_value &= ratr_mask;
 		break;
 	default:
 		if (rtlphy->rf_type == RF_1T2R)
@@ -2119,7 +2113,6 @@ static void rtl92se_update_hal_rate_mask(struct ieee80211_hw *hw,
 	u32 band = 0;
 	bool bmulticast = false;
 	u8 macid = 0;
-	u8 mimo_ps = IEEE80211_SMPS_OFF;
 
 	sta_entry = (struct rtl_sta_info *) sta->drv_priv;
 	wirelessmode = sta_entry->wireless_mode;
@@ -2167,41 +2160,32 @@ static void rtl92se_update_hal_rate_mask(struct ieee80211_hw *hw,
 		band |= (WIRELESS_11N | WIRELESS_11G | WIRELESS_11B);
 		ratr_index = RATR_INX_WIRELESS_NGB;
 
-		if (mimo_ps == IEEE80211_SMPS_STATIC) {
-			if (rssi_level == 1)
-				ratr_bitmap &= 0x00070000;
-			else if (rssi_level == 2)
-				ratr_bitmap &= 0x0007f000;
-			else
-				ratr_bitmap &= 0x0007f005;
+		if (rtlphy->rf_type == RF_1T2R ||
+		    rtlphy->rf_type == RF_1T1R) {
+			if (rssi_level == 1) {
+				ratr_bitmap &= 0x000f0000;
+			} else if (rssi_level == 3) {
+				ratr_bitmap &= 0x000fc000;
+			} else if (rssi_level == 5) {
+				ratr_bitmap &= 0x000ff000;
+			} else {
+				if (curtxbw_40mhz)
+					ratr_bitmap &= 0x000ff015;
+				else
+					ratr_bitmap &= 0x000ff005;
+			}
 		} else {
-			if (rtlphy->rf_type == RF_1T2R ||
-				rtlphy->rf_type == RF_1T1R) {
-				if (rssi_level == 1) {
-						ratr_bitmap &= 0x000f0000;
-				} else if (rssi_level == 3) {
-					ratr_bitmap &= 0x000fc000;
-				} else if (rssi_level == 5) {
-						ratr_bitmap &= 0x000ff000;
-				} else {
-					if (curtxbw_40mhz)
-						ratr_bitmap &= 0x000ff015;
-					else
-						ratr_bitmap &= 0x000ff005;
-				}
+			if (rssi_level == 1) {
+				ratr_bitmap &= 0x0f8f0000;
+			} else if (rssi_level == 3) {
+				ratr_bitmap &= 0x0f8fc000;
+			} else if (rssi_level == 5) {
+				ratr_bitmap &= 0x0f8ff000;
 			} else {
-				if (rssi_level == 1) {
-					ratr_bitmap &= 0x0f8f0000;
-				} else if (rssi_level == 3) {
-					ratr_bitmap &= 0x0f8fc000;
-				} else if (rssi_level == 5) {
-					ratr_bitmap &= 0x0f8ff000;
-				} else {
-					if (curtxbw_40mhz)
-						ratr_bitmap &= 0x0f8ff015;
-					else
-						ratr_bitmap &= 0x0f8ff005;
-				}
+				if (curtxbw_40mhz)
+					ratr_bitmap &= 0x0f8ff015;
+				else
+					ratr_bitmap &= 0x0f8ff005;
 			}
 		}
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c
index bd45d9bd40bb..2e50f5c24df8 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c
@@ -1924,7 +1924,6 @@ static void rtl8723e_update_hal_rate_mask(struct ieee80211_hw *hw,
 	bool shortgi = false;
 	u8 rate_mask[5];
 	u8 macid = 0;
-	/*u8 mimo_ps = IEEE80211_SMPS_OFF;*/
 
 	sta_entry = (struct rtl_sta_info *)sta->drv_priv;
 	wirelessmode = sta_entry->wireless_mode;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
index 1ba53e671207..31f499be99a3 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
@@ -3468,7 +3468,6 @@ static void rtl8821ae_update_hal_rate_mask(struct ieee80211_hw *hw,
 	bool b_shortgi = false;
 	u8 rate_mask[7];
 	u8 macid = 0;
-	u8 mimo_ps = IEEE80211_SMPS_OFF;
 	u8 rf_type;
 
 	sta_entry = (struct rtl_sta_info *)sta->drv_priv;
@@ -3535,47 +3534,37 @@ static void rtl8821ae_update_hal_rate_mask(struct ieee80211_hw *hw,
 		else
 			ratr_index = RATR_INX_WIRELESS_NG;
 
-		if (mimo_ps == IEEE80211_SMPS_STATIC
-			|| mimo_ps == IEEE80211_SMPS_DYNAMIC) {
-			if (rssi_level == 1)
-				ratr_bitmap &= 0x000f0000;
-			else if (rssi_level == 2)
-				ratr_bitmap &= 0x000ff000;
-			else
-				ratr_bitmap &= 0x000ff005;
+		if (rf_type == RF_1T1R) {
+			if (curtxbw_40mhz) {
+				if (rssi_level == 1)
+					ratr_bitmap &= 0x000f0000;
+				else if (rssi_level == 2)
+					ratr_bitmap &= 0x000ff000;
+				else
+					ratr_bitmap &= 0x000ff015;
+			} else {
+				if (rssi_level == 1)
+					ratr_bitmap &= 0x000f0000;
+				else if (rssi_level == 2)
+					ratr_bitmap &= 0x000ff000;
+				else
+					ratr_bitmap &= 0x000ff005;
+			}
 		} else {
-			if (rf_type == RF_1T1R) {
-				if (curtxbw_40mhz) {
-					if (rssi_level == 1)
-						ratr_bitmap &= 0x000f0000;
-					else if (rssi_level == 2)
-						ratr_bitmap &= 0x000ff000;
-					else
-						ratr_bitmap &= 0x000ff015;
-				} else {
-					if (rssi_level == 1)
-						ratr_bitmap &= 0x000f0000;
-					else if (rssi_level == 2)
-						ratr_bitmap &= 0x000ff000;
-					else
-						ratr_bitmap &= 0x000ff005;
-				}
+			if (curtxbw_40mhz) {
+				if (rssi_level == 1)
+					ratr_bitmap &= 0x0fff0000;
+				else if (rssi_level == 2)
+					ratr_bitmap &= 0x0ffff000;
+				else
+					ratr_bitmap &= 0x0ffff015;
 			} else {
-				if (curtxbw_40mhz) {
-					if (rssi_level == 1)
-						ratr_bitmap &= 0x0fff0000;
-					else if (rssi_level == 2)
-						ratr_bitmap &= 0x0ffff000;
-					else
-						ratr_bitmap &= 0x0ffff015;
-				} else {
-					if (rssi_level == 1)
-						ratr_bitmap &= 0x0fff0000;
-					else if (rssi_level == 2)
-						ratr_bitmap &= 0x0ffff000;
-					else
-						ratr_bitmap &= 0x0ffff005;
-				}
+				if (rssi_level == 1)
+					ratr_bitmap &= 0x0fff0000;
+				else if (rssi_level == 2)
+					ratr_bitmap &= 0x0ffff000;
+				else
+					ratr_bitmap &= 0x0ffff005;
 			}
 		}
 		break;
-- 
2.53.0

