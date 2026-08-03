Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDDC236B912
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 13:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785762748; cv=none; b=lxMbbvojqXCdMwACIsHGTt16GHjhPKuY4jJ48DOUYU/Oae2O6n2SlmCfFsYIc2pn2R1K2AIZ0oSLvzTJPKNfSxlB7+n0rt+yzgKA1WcZ2GEIVnMDyHrOGH6Bdj0M+G0KsSlaIJXUlg7ArieAIZ9tyDOidmmd/fae/HaMzP7IhEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785762748; c=relaxed/simple;
	bh=mdxF4avpkzXiCtWbEJnWAV7RiToth4AbaLZLL7kkhiE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=q40UjkiT6/DQaoulm5ztE94837LC5PJlBVh0roka7ViOl25SujSNarLg+s6Iw9NVe3wwlLYaN92dUFjJF0BV9kKBS4sJPQ3sBl8+BpmyuMP1ao7MGLgP4P1W9Az0K7s1GZCZgEkXFn5TWCRQ0ppbvrMp5LZwEQj7manUezJAAOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mWS1YroI; arc=none smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mWS1YroI"
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7e6b5737bb2so3019602a34.1
        for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2026 06:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785762739; x=1786367539; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=byW6jvQp8zKfKlaoj0GNIPAuiHh64WLa20kMqH69y+M=;
        b=mWS1YroIw5aJ9hsJFSJQujk4shdwhMij6K0Q72QyidVyGzQq5R5Dx8GR7BQmVJmJC6
         noQQhVrZlCQRguGUdQs8frhPFe2d7YF4uu8HSzkO5FYR9UvbgkvnpA7l0oUPBfYkEXqr
         1UX67Non6ZPOa42pWYxHfzHbDuWQkFFsd1/2o9UVxgv30xE4sRWEaZmMAEt9MxeUYN9r
         lOmMdzb1hYHdUFyu+e2YMNHzHfSzlLgcTR/+U8pmkLLUeAOFk5KzBn78a8WSNvAG0J3V
         EJCNSOOLyEYKRv5ddxjPQKit4kpdQvAdkIV+IDYRAVORo4orlZpQ+Q+9+ocg5TUhetw0
         I0yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785762739; x=1786367539;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=byW6jvQp8zKfKlaoj0GNIPAuiHh64WLa20kMqH69y+M=;
        b=BBPHAa00yYTgca94VuAY1R4wCEwfhv/gWjBT9SNhcw2RdY1QxMzMPx+5nsn8hPZgEL
         tvY4qomByvBnSkPyJE0Ld1QVtFv+cRecdagGz0x4L2AJS1cxTKX3wZbzicRCUmqLMo0U
         4MsU17NEHgVx6EFGJYQh7mi9bJiyp2aLT2lC5sbw0U9+E8Tv2VeI7+O1jBj7Orfg3Q0A
         P56nD9i8vWzgtz5XT15yobyoVGij7q2kNSuUumlfwb82WfGJef72meHhgmkAIhFINDUy
         r3ju2mpXeXBGuxx4WSJpS82aYeBu0K6rfL0r8oUisLtlgWq1FWr3/8aaxv/Ebw5ofyUh
         aAaA==
X-Gm-Message-State: AOJu0YzsgSYk/oxk/Mv566YfuV2/S5kVnJ1dQKJlZNzMoPssmklHd/Tu
	qe1GqTRDf8LUiGerW29swDn3Tw8M9bO1O5YARN5GcSFVMsF5XWrVBMx4ehmwDL1y
X-Gm-Gg: AR+sD124IRjlX8B3+Q4tjyYxflONLw4+17GUJ0bOWdlaaw7vzkqhFQfqt9YL78pg7vB
	Jg75VVB9EzP/hvkmSwB8nkPnUDt2js1aajdMK7NDxWe3LnXL4ywsPGkgbyuRPYOsYRMmWXmut+T
	iYfAp6SK2GIA7aheWdus0b5qLD88ypmp8a0ouQ1i4LGIr68EDOW0NlvzEMTCiXRvFkIN3I1hy2X
	d3x/yBqZqqZGiJYaZrXv/9e+bL7xMbGhaIX0PQdVQyJfpNj7qmd9qhl3fxT+4epBrxL8vOvIS1u
	Lt0wgSI017q+Ih+mXj1kbLHtC8VLZgnlPXrN5AHdja62sYJNfnimqp+kkvUa+7uxzPH+U/YZZOd
	wy2FEsaTXWsZJ77oFj6AMI8x89CANTNWXQ0N21N1LZPtg5rd92rCOxNGkVz6IEbOH80+4kJEr03
	MB67oRwU1ounPmc3msrSquqJgCyCAot/c+vp9I0HaWYX45LJI1/cSAAPCTXzqpRRGGm0SUtKa5n
	2mKT9dkTFDtShPFrLCX79IjjIgUKLwi8FWajhTX
X-Received: by 2002:a05:6830:6d4e:b0:7e9:e257:81cb with SMTP id 46e09a7af769-7f196d7d1a7mr15601097a34.7.1785762738994;
        Mon, 03 Aug 2026 06:12:18 -0700 (PDT)
Received: from cr-x-ubuntu2604-client-1.dev.fyre.ibm.com ([170.225.223.19])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f18ed3e91bsm7202955a34.4.2026.08.03.06.12.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 06:12:18 -0700 (PDT)
From: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
Subject: [PATCH] wifi: rtlwifi: rtl8192cu: Remove logically dead code in rtl92cu_update_hal_rate_table
Date: Mon,  3 Aug 2026 06:12:03 -0700
Message-ID: <20260803131203.998989-1-chelsyratnawat2001@gmail.com>
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
 .../wireless/realtek/rtlwifi/rtl8192cu/hw.c   | 20 +++++++------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
index e75f7ec44e6a..199bab58363c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
@@ -1809,10 +1809,9 @@ static void rtl92cu_update_hal_rate_table(struct ieee80211_hw *hw,
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
-	u32 ratr_value;
+	u32 ratr_value, ratr_mask;
 	u8 ratr_index = 0;
 	u8 nmode = mac->ht_enable;
-	u8 mimo_ps = IEEE80211_SMPS_OFF;
 	u16 shortgi_rate;
 	u32 tmp_ratr_value;
 	u8 curtxbw_40mhz = mac->bw_40;
@@ -1844,19 +1843,14 @@ static void rtl92cu_update_hal_rate_table(struct ieee80211_hw *hw,
 	case WIRELESS_MODE_N_24G:
 	case WIRELESS_MODE_N_5G:
 		nmode = 1;
-		if (mimo_ps == IEEE80211_SMPS_STATIC) {
-			ratr_value &= 0x0007F005;
-		} else {
-			u32 ratr_mask;
 
-			if (get_rf_type(rtlphy) == RF_1T2R ||
-			    get_rf_type(rtlphy) == RF_1T1R)
-				ratr_mask = 0x000ff005;
-			else
-				ratr_mask = 0x0f0ff005;
+		if (get_rf_type(rtlphy) == RF_1T2R ||
+		    get_rf_type(rtlphy) == RF_1T1R)
+			ratr_mask = 0x000ff005;
+		else
+			ratr_mask = 0x0f0ff005;
 
-			ratr_value &= ratr_mask;
-		}
+		ratr_value &= ratr_mask;
 		break;
 	default:
 		if (rtlphy->rf_type == RF_1T2R)
-- 
2.53.0

