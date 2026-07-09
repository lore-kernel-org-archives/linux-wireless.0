Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C259C3BB12D
	for <linux-wireless@vger.kernel.org>; Thu,  9 Jul 2026 19:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783626222; cv=none; b=dJ7Dr7aND9P6hUhek09m5SRg60g+zZnZCSBj6sd634blGHykV6GnMnJtOmLNyVAjMA1rHevlzwFl8vEIDiIsoS6MTzP4+Ko00USPTMlv/begUEC4VzP8mKN2TsbQ/9iSu7ViLRJh5OIPBZL/VRowtX4QScHEGqT9zCNdxz4ZU44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783626222; c=relaxed/simple;
	bh=Tuun+5fElS9CoBUke/kAn2wJXQeORW5prVmFwquO5GM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XBynh0da0tGq45zWUZ9KD+IzlGgWt4JELw+N/VvD73uaPUS+UpIOlSh9NyCtzQpRZokTu4p8f24FAJccp6JKPFeOF7rjFd6LM27aV8gyau4N0pGOqhqnfJU9Bm9gCYagGg/907hjwUfnobdOIETwQfDvuql+krnJXmKZt3Z9o1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CLM964C4; arc=none smtp.client-ip=209.85.160.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CLM964C4"
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-448de0cc236so82323fac.2
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jul 2026 12:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783626220; x=1784231020; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=oaOdjPmOP6fvn4z2t0vFLBEg4g91X3yowDaWH7mhEu4=;
        b=CLM964C4UB7JEsgYdBEVmyOjI2oSnDHuqtfjDhBDegEjyZ/A3F3CaUSWcfgISq6eiS
         KE4RMHYpyqwPUTHeBjHWr9Sy9gCwp/BdnZsoST6/Cu1NdP+tFHQq5GTybkhHuXqMk2p/
         qZ6Zr3VE6Sb/U713uJIjSC/psMyUuvhFMNCQDKPla7It7ZrMa0utMeHrV4Iu5Vp5Py+w
         5CZkTgISCV+QM2LJCe7Y+Zz3kcjxklYB+4SAZwfN/sHCxVM+hvNevqDrfvKS4IckmSS5
         r+g/317CTp1uwL3PrkxNzwg9FyIgQwjOsOJP3tlRpUFcich465R5wVAZtvHbC+ZraLvj
         muBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783626220; x=1784231020;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oaOdjPmOP6fvn4z2t0vFLBEg4g91X3yowDaWH7mhEu4=;
        b=IexeAO9WSAMbmnXeH3mLATvcvgwjruMg4+vmo6AnRpsudEo4qzlLnPy4IzTVaX+w9C
         LjGDRC5BjfNWgFCxdEMAIZvxK9k0EIOrh++xHOXJhcNIJRQ/PwJQdLdk+5K6KLu/rlFB
         S3R9UE6iU90AosFzOmhyFHuQJDwXpYX2Fev4RdRVDGM77EuPMBr6AWgXsq7lfl6CQL2U
         KCjr2Mh6Jmy8aA0KPRVcxqg3nqVQWdnOmkYEgOQ8iN2I3d5wXyZxOVRy7KJCJHLTEy++
         nseS99uY/HlL6otWDsfnPr8cs7xughnhnwlnuP/IMPvnPh4gnVb6EleONryQBV6Ke/VE
         kvNA==
X-Gm-Message-State: AOJu0YzA1RdhwBnIHIKPxSZTj19WJHyubMz2exa7x3coMIAx2vkWN/+P
	lbnIpq3fm6QOSdKOSVju65MI6zDjH/6JQ2fZBKWqROy5SDb4tsswLrwe9Qud+9Nm
X-Gm-Gg: AfdE7cmeMPiSmw9/YnfOtSuE6IhcqgeY2CfWWWTq2Eq7uWmNyTT84pGe0AT/mTYbGx3
	c443WnltQHU6ArewcdRuo9wP7DgO4MX8RKKCLVNux1LxmYVOihpW8cbW2quoJyK1vsAucoC2Lnd
	MDFEjqV7XjWP5qZa623ZBYd2PcQezpq/Qeo9dPYk70SywP7dqIoGcsqeppL6zBGWFwx9XCpO/Yr
	JQjTZI8GEiarKi3IZUy08aepexcO/R3gDMHied56f1CWJLMu7X9rCaCC+1sJRwfuBNOH4CUyzEn
	eB72Vn4ajpxf9SFepylHKWCIgpl506rSmYwRkPly5JcwTemMU1kHOWs9vjWLMFbJ+F4ombk+OYK
	Ur7qcK754ihuWejrYCwCnDCvmbM0oqsi5wAkGiTnuWdOhDVazHpqBPWJfJQfhvTO/N4XvNYVe78
	j9aDwUTVEVfodrFwkWxpEel+BsW8DEtqQNfKhz
X-Received: by 2002:a05:6870:64a4:b0:441:a287:137d with SMTP id 586e51a60fabf-45163c971d8mr6062540fac.29.1783626219603;
        Thu, 09 Jul 2026 12:43:39 -0700 (PDT)
Received: from ub24-261.fyre.ibm.com ([170.225.223.18])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-45191643994sm2832196fac.9.2026.07.09.12.43.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 12:43:39 -0700 (PDT)
From: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
Subject: [PATCH] rtlwifi: rtl8192d: remove dead SMPS rate mask code
Date: Thu,  9 Jul 2026 12:43:15 -0700
Message-ID: <20260709194315.157030-1-chelsyratnawat2001@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mimo_ps is initialized to IEEE80211_SMPS_OFF and never modified in
rtl92d_update_hal_rate_table(). Therefore, the IEEE80211_SMPS_STATIC
case is unreachable.
Remove the unused mimo_ps variable and the dead branch.

Signed-off-by: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
---
 .../realtek/rtlwifi/rtl8192d/hw_common.c      | 21 +++++++------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192d/hw_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192d/hw_common.c
index 97e0d9c01e0a..cfefbe86380f 100644
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
@@ -784,6 +783,7 @@ static void rtl92d_update_hal_rate_table(struct ieee80211_hw *hw,
 	u8 ratr_index = 0;
 	u16 shortgi_rate;
 	u32 ratr_value;
+	u32 ratr_mask;
 
 	curshortgi_40mhz = !!(sta->deflink.ht_cap.cap & IEEE80211_HT_CAP_SGI_40);
 	curshortgi_20mhz = !!(sta->deflink.ht_cap.cap & IEEE80211_HT_CAP_SGI_20);
@@ -811,20 +811,15 @@ static void rtl92d_update_hal_rate_table(struct ieee80211_hw *hw,
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
-- 
2.43.0

