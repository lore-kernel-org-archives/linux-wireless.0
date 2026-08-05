Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE5E382F10
	for <linux-wireless@vger.kernel.org>; Wed,  5 Aug 2026 08:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785918019; cv=none; b=TISrn06Ia0e1mYhjDaRA6Et9CTtrJ6ZdGzfOQQT1CPLQw+TWdj8XlyOQttyt/FywBrYNxn7Sa/q3T+sus+8xGlKL7iQNc362E4bxY50cYzjx+8WXmTDnfr9RUuZADt+ooobJvFTNjlAjRIQ4ANQkJ3IiRWpzukEFniPksnFycAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785918019; c=relaxed/simple;
	bh=sC1PqM3mS4ZwupnHSTVTX76YOTo1lsvoOshl2TlcZ9I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FPii8rokAYPwZrC3ar9vnzbJ68DDt17WhMiio7hJENa9QemInhZOdJxE7Tm9dTXgF9qRWE0YyyCt9CpvLJ88OtvGMi49RaxlAk09Sa6UfdEH6+cEr+UTqkySX9SROOntmo00GkEeL5wUy1ZRs8ubV9ra9NQBFFrbD8t8zdLmTIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TP1jk8nC; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TP1jk8nC"
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-4a427e628a9so290753b6e.0
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2026 01:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785918016; x=1786522816; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7jumsFBHRQJWD6/ookMZn8TKnz47JvFiGso6tpoKjIQ=;
        b=TP1jk8nCz/HLEdvPEQ1FH5LIIq8wXg4aVKovhv9ifq9Mnc7MJLr7TrPxfZCrNb+CNJ
         x1K6dPjDi4daP37ptJlH0K3VoEtCCNZsXRhkG323Nv1VIfMKp9OSM2dKiwutaIc1vY4O
         fKUPm/5pnSyv0+Yi19jgNbXs9r5vb7S0c1WfVONe1NXLdCTy+jx6nuD2MrMV/B5ml/Cp
         5cPNpriOm3jKC5imQQrbXJNMKb/ua/7B1qBMz4HXQb+XirvA+0le5iOxze9p6/ERhtUh
         zjwckwruLLDtoj2SYK6yNW/FHoXwTqCYM2sCLB+zTwZWgub+6pXIu8SBSsUR7N2N944g
         LYNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785918016; x=1786522816;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7jumsFBHRQJWD6/ookMZn8TKnz47JvFiGso6tpoKjIQ=;
        b=TqgVXsqjWV7Edw8TuNLzvb1COpWjSkY2/TOHf9lsT1ZnElt0FXdR9+9I7eOCHbX0KS
         hipvkJF60MiH9aLNdQFo6zdmaTURxJXq6Bmu1RIR39pbfHyouRnr4PfkppuMFFg96QA3
         spNIU7lCXATt7NR5AVKalwvX9YFRWEyiDRvQUh5QmWCj0CHwS2qGVMYBlbqXZWDmWavO
         BAJ2od49g5BRBxXslLDQUodT19ZipwVMjXQuipUfFYRL/xOPr25WsQKo0ae/DUCP4osU
         Lt9ePUGvWS9uqeZaXpnTgirQyrnJjbweCWGSDw6qGt+VThWvvrzYMuawGRXfGF0DtOfj
         SOQA==
X-Forwarded-Encrypted: i=1; AHgh+RoFAA7qklF5WdjKo82PO07LGUc32YdXSCOAlbsK10H/WBMaUGDhDJH7NMo/+FrytRbkcqoR/upl0Dqm1BV/Rw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzKqilWUhiWhRaTLLMQfW8vdcMHVeDvhc1UrubujFpXiRcXuyFY
	pyP21rJnauQA/+p/Zleqi1wkt3EuPUBR5IQxBZFwhzE80WwtyCpJByK+
X-Gm-Gg: AR+sD12FJ4OZvXdlhbur5izgxxcv/OW8EroeD4dZq3uR8LSEDm/nbfyiChu/k+RdwD7
	40kG6W/MEJhiGdJdg9RKwqrShYzFIdrlfIGEuQHge6OhoC0KlelDNGzX+NEVe0eX3XhxUXVbHEh
	47TSmCKhbqkeU8iJ1kVI8fE8ckGTQN/zLOdZkyFspa696ikShMv4Qi16Dm14B5ZCktgAO34Ub5S
	siaArv895Q6FuVXVNZ6ZGW8Tr3+wcXtY1hR2kgk0rP7m5rJICYKtiBBfRRAYZ3tRrxWmzELd5mp
	L4N++qNOyskgXru17O6kLrxnENSDxfPkxsqfCggNHIBKr/hsx6ryaLGXiAygypzi7Mi/soqyizp
	/cvzqCb8q+ispAZRPd/nwM5st0UQZVD8t7h4ePJ6M7QRl3ouHuFUGugnfIIg0xNaOugqnO1YVUP
	yW8+RDIyDTEDV/EkF8XI81t4b0d3d2rfzqzqXZxA7tBcSob7kSPooTqtldX5XXw4Q+LGcwje/OJ
	2xoBzeiCFsYxz/h82GXxOoIAXLpxSSKyQ8vYhab
X-Received: by 2002:a05:6820:151a:b0:6aa:f84d:83f9 with SMTP id 006d021491bc7-6ae96f3d750mr2251067eaf.23.1785918016358;
        Wed, 05 Aug 2026 01:20:16 -0700 (PDT)
Received: from cr-x-ubuntu2604-client-1.dev.fyre.ibm.com ([170.225.223.19])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4599e6c7eedsm1798867fac.17.2026.08.05.01.20.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 01:20:13 -0700 (PDT)
From: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
To: pkshih@realtek.com
Cc: hvilleneuve@dimonoff.com,
	linux-wireless@vger.kernel.org,
	Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
Subject: [PATCH] wifi: rtlwifi: remove dead mimo_ps handling from rate update code
Date: Wed,  5 Aug 2026 01:20:04 -0700
Message-ID: <20260805082004.608667-1-chelsyratnawat2001@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
 .../realtek/rtlwifi/rtl8192d/hw_common.c      | 22 ++---
 .../wireless/realtek/rtlwifi/rtl8192ee/hw.c   |  1 -
 .../wireless/realtek/rtlwifi/rtl8192se/hw.c   | 92 ++++++++-----------
 .../wireless/realtek/rtlwifi/rtl8723ae/hw.c   |  1 -
 .../wireless/realtek/rtlwifi/rtl8821ae/hw.c   | 69 ++++++--------
 6 files changed, 75 insertions(+), 112 deletions(-)

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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192d/hw_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192d/hw_common.c
index 97e0d9c01e0a..6d8b39174bb6 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192d/hw_common.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192d/hw_common.c
@@ -775,7 +775,6 @@ static void rtl92d_update_hal_rate_table(struct ieee80211_hw *hw,
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &rtlpriv->phy;
 	enum wireless_mode wirelessmode;
-	u8 mimo_ps = IEEE80211_SMPS_OFF;
 	u8 curtxbw_40mhz = mac->bw_40;
 	u8 nmode = mac->ht_enable;
 	u8 curshortgi_40mhz;
@@ -783,7 +782,7 @@ static void rtl92d_update_hal_rate_table(struct ieee80211_hw *hw,
 	u32 tmp_ratr_value;
 	u8 ratr_index = 0;
 	u16 shortgi_rate;
-	u32 ratr_value;
+	u32 ratr_value, ratr_mask;
 
 	curshortgi_40mhz = !!(sta->deflink.ht_cap.cap & IEEE80211_HT_CAP_SGI_40);
 	curshortgi_20mhz = !!(sta->deflink.ht_cap.cap & IEEE80211_HT_CAP_SGI_20);
@@ -811,20 +810,15 @@ static void rtl92d_update_hal_rate_table(struct ieee80211_hw *hw,
 	case WIRELESS_MODE_N_24G:
 	case WIRELESS_MODE_N_5G:
 		nmode = 1;
-		if (mimo_ps == IEEE80211_SMPS_STATIC) {
-			ratr_value &= 0x0007F005;
-		} else {
-			u32 ratr_mask;
 
-			if (get_rf_type(rtlphy) == RF_1T2R ||
-			    get_rf_type(rtlphy) == RF_1T1R) {
-				ratr_mask = 0x000ff005;
-			} else {
-				ratr_mask = 0x0f0ff005;
-			}
-
-			ratr_value &= ratr_mask;
+		if (get_rf_type(rtlphy) == RF_1T2R ||
+		    get_rf_type(rtlphy) == RF_1T1R) {
+			ratr_mask = 0x000ff005;
+		} else {
+			ratr_mask = 0x0f0ff005;
 		}
+
+		ratr_value &= ratr_mask;
 		break;
 	default:
 		if (rtlphy->rf_type == RF_1T2R)
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
index 9b119a51bc30..91e56be7a336 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
@@ -3473,7 +3473,6 @@ static void rtl8821ae_update_hal_rate_mask(struct ieee80211_hw *hw,
 	bool b_shortgi = false;
 	u8 rate_mask[7];
 	u8 macid = 0;
-	u8 mimo_ps = IEEE80211_SMPS_OFF;
 	u8 rf_type;
 
 	sta_entry = (struct rtl_sta_info *)sta->drv_priv;
@@ -3540,47 +3539,37 @@ static void rtl8821ae_update_hal_rate_mask(struct ieee80211_hw *hw,
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

