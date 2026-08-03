Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15FF3D7A01
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 11:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785758317; cv=none; b=S2Inorb1lthE++a2PgQ35zV7bZTXpr7kW/NDQ0SmyI0a5Bd2mCw6uHeFLj9yMSH58ofZfAWQXg18F59so3WMLaSEoPFa+HZToikHsQrJjKjtQRVPYWGN185EoPiYm1FFnqYik+Ctu2Z6cfKwJpa5LBnNtW4+kXyVz1s0PKu8m6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785758317; c=relaxed/simple;
	bh=k7UrqjaX/AIAidinj0Mjiu/cSuxm3BbHz9qtWa/qS/A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WMPpRRY0QIyp4iPor9RX3JAMbSZae+V5w4QM7csMBWA2xT9ukbXK8B57aYZl5ytrJL5pJGDq/qQ67Eo+Q/lvbASrAEJh0jN8FMHN0lhxsRCExAgITzltLE8gnMSW587wD/MfnQcoUdn30jswrL0AxqrtuKtaviu00ii6/PfRZuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I7KhOTKX; arc=none smtp.client-ip=209.85.161.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I7KhOTKX"
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-6acc88b9c5fso1403908eaf.2
        for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2026 04:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785758315; x=1786363115; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=R3rKslDwnV4zeJnBp6rQK9dLaIkOXR2TUwnnkUIzGW8=;
        b=I7KhOTKXgllzwH6XFIjbvh9Jjr0qP8Gpno//z+8x1rr2GJJIBT52FRqzFp69TQbCw1
         mBkg1Ek75t2EXOEE2aYNU9OtTJ8mrf6XiyvhyqK6psryXIuB7SozDo/9pAL2T4n27xPX
         DA9Ll0a1IQoAb/H1K+GD4Y7UEosFDh/XQWdtMgsXQcSB5VK7mDWrU62HHePoKtAuWIR+
         qJ6/lhtMCQRwCfIRcGfQbo88EAQI+a+xIucPJcPQ09/441O5Q/2s+GZS8EA8b+eTTEan
         V64vfofS6I+5BA354Asj70rvGxVZIhF3EG8BKIoyHaWk820x316yTX4ohdY8BUINEE1l
         gztA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785758315; x=1786363115;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R3rKslDwnV4zeJnBp6rQK9dLaIkOXR2TUwnnkUIzGW8=;
        b=XaI1iUOYbDaR8bpVpmJ5IqwDHT15k0xbmRi39IIvucgm6Lz5xsdmQ741ho2rZDc+41
         G9D3JzS3YyG7s9/QSlE4yarLhdwaQUyKXneKt4TXr30XiKzmm7qsJDsoz/gSHUE92Dbl
         byZgEiIRM1btE1YgxTcA4d7dyuiQ4SO8yFii7J2qOg7c3WffX/uW3q2OgmTs4bgSQxpw
         +CKIby7VDLj+C8jOvW1gGrxcghiMHTLqOds5T1d4DFZHTomXl3FAdC+ZfaLC73z2FO4w
         pVkOZ5xiRbb3g3gN6/8N9NZbO4KFJUr0qH7TEv55MVhvdOLZ1QxqgiFC/8tPISuoi2l3
         fe8A==
X-Gm-Message-State: AOJu0Yx6tHN7yFsE/xe96KldCKygCp03LshyNFynUQclcf8vpquoLlQv
	no/UmdkMxhkK34K0Q1Nv4fEEnNenUBydXKuKvFJTpj3H/2JK3pSLhuKW
X-Gm-Gg: AR+sD10WIz5LNfQmxyEY1PNuMrneKnCFpQB8i7+qwufEp/vqmpep58F61dC6fDQcH3q
	7poqMIqlU8Q6lvwuNdV6a6bK6nElwyUoeq8azmI9kWRoFoKoVsK026cflWOtmO6pJSzw15Iw7Ze
	yzbfpRYr3X2NmhtmReKPTuVYzgSQ9Qiwo1tq5lAdEfS5co5+oMcwOkXYrgx5qDYTVLt/9nlugE1
	4uOTNUL4XKLRoT5hocDQyfW1lsoKBCsHktygpW2jOugcBci5D0xYd8UgBD1Lz/LSKim55Xg4vXT
	hyS6BkYkClUWmUOn68fW1HWNFS3WncrE9dFRO8DEOcZhivQzfYZbklYqaGX575UGsQyokkIDBBL
	K67wxjeqK2OCEavoU45BpaHbUBbY7uBK8lW6r9Q6kftP+JYaxvSZsxrFSaH51jwAKqEzBh/siUg
	g/SKJcv3o8mLwleHG5h2nIoNtAcU34QPNB3A5cSgI6lVCmK0qkSAYk3Gv50QlU/XVScMJRTzfiR
	ZaKNVSxMqMhXPNBR+UIf31gUV+cMGbmwcVdxZ/3
X-Received: by 2002:a05:6820:811b:b0:69d:9dfb:7928 with SMTP id 006d021491bc7-6ae4331b541mr14225525eaf.3.1785758314694;
        Mon, 03 Aug 2026 04:58:34 -0700 (PDT)
Received: from cr-x-ubuntu2604-client-1.dev.fyre.ibm.com ([170.225.223.19])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-458f6064843sm8703341fac.4.2026.08.03.04.58.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 04:58:33 -0700 (PDT)
From: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
Subject: [PATCH] wifi: rtlwifi: rtl8192cu: Remove logically dead code in rtl92cu_update_hal_rate_mask
Date: Mon,  3 Aug 2026 04:58:25 -0700
Message-ID: <20260803115826.992789-1-chelsyratnawat2001@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The variable 'mimo_ps' is initialized to IEEE80211_SMPS_OFF and never
modified throughout the function. This makes the condition checking for
IEEE80211_SMPS_STATIC always evaluate to false, rendering the entire
if-branch unreachable dead code.

This error was reported by Coverity Scan.

Signed-off-by: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
---
 .../wireless/realtek/rtlwifi/rtl8192cu/hw.c   | 70 ++++++++-----------
 1 file changed, 30 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
index 989e7cff8e20..e75f7ec44e6a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
@@ -1911,7 +1911,6 @@ static void rtl92cu_update_hal_rate_mask(struct ieee80211_hw *hw,
 	bool shortgi = false;
 	u8 rate_mask[5];
 	u8 macid = 0;
-	u8 mimo_ps = IEEE80211_SMPS_OFF;
 
 	sta_entry = (struct rtl_sta_info *) sta->drv_priv;
 	wirelessmode = sta_entry->wireless_mode;
@@ -1956,47 +1955,38 @@ static void rtl92cu_update_hal_rate_mask(struct ieee80211_hw *hw,
 	case WIRELESS_MODE_N_5G:
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
-			if (rtlphy->rf_type == RF_1T2R ||
-			    rtlphy->rf_type == RF_1T1R) {
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
+					ratr_bitmap &= 0x0f0f0000;
+				else if (rssi_level == 2)
+					ratr_bitmap &= 0x0f0ff000;
+				else
+					ratr_bitmap &= 0x0f0ff015;
 			} else {
-				if (curtxbw_40mhz) {
-					if (rssi_level == 1)
-						ratr_bitmap &= 0x0f0f0000;
-					else if (rssi_level == 2)
-						ratr_bitmap &= 0x0f0ff000;
-					else
-						ratr_bitmap &= 0x0f0ff015;
-				} else {
-					if (rssi_level == 1)
-						ratr_bitmap &= 0x0f0f0000;
-					else if (rssi_level == 2)
-						ratr_bitmap &= 0x0f0ff000;
-					else
-						ratr_bitmap &= 0x0f0ff005;
-				}
+				if (rssi_level == 1)
+					ratr_bitmap &= 0x0f0f0000;
+				else if (rssi_level == 2)
+					ratr_bitmap &= 0x0f0ff000;
+				else
+					ratr_bitmap &= 0x0f0ff005;
 			}
 		}
 
-- 
2.53.0

