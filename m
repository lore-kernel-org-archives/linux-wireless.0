Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C2C3C4168
	for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2026 05:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787895638; cv=none; b=s1a1+xHesV0rgcdpslZvy1w5+vSNLWNqK6Bsxf8eMeBphK/CcZ2efHrnFQLnmUlhkEIRJ3622oHxxMZz9rYqfnh3HQwmzabh3H+ACGUAuMu5iCiRIyFANBn6FKy+uGDh699vhmiegNDk082Quuf4Y71ht1r3TkawLMGz6g+CySY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787895638; c=relaxed/simple;
	bh=J7WWIorQALvl1TB/piLk+5x36QCOVw2Ew4N4qt78e6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JZWWESic/810SSXbYY47XFCvhTIL9cmYzkPgIcfRVPgTdiV3i8JoRE8VHcC5ZWH7Zt278iiI3kjdhU8eH4lgPak50uTUlZeYLXHYGkrJhnAHod0DzaIc6QT4mCg/26eyilinRpOtpvYcZeF7dlOh8M9YVm0rGZCxJL80BzWnr8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qN9XEaZr; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qN9XEaZr"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5b2b92065ffso620732e87.1
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 22:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787895631; x=1788500431; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mTp5tt6o5viHIfZHu8ddHYkmMFpAt4nOgEqLQ0bcKso=;
        b=qN9XEaZr918s1Lm6OD3BWnYKekJX3w6tjeMQvBnW2Pw6tu8Nzi4tbai4pYrouCQflC
         W4DBWC4C6yiTNYd+0SX1WRGo4h/q3g3wOIawknHJ7yeOLwzKKjAZY+Bco0hjoImCw+V2
         dhWjLKPr2mZ5lovi7niYYZV0Izurq5eUsSUkj+quk4m3+P4+H8au0iqXjzclcM0+y0D+
         NfX6J1APKnZLTFvZlwCjjag201z/v/hrN3O/9Q99pHQTxz16BDx0QFc78z357G4RLpj5
         lFBpeZrXXzTxetN3QHGCL8i8ifSGzY2nL18ncgSnVIsiLExJ5hpCnWj1Foh3S6aLzuFm
         isWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787895631; x=1788500431;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mTp5tt6o5viHIfZHu8ddHYkmMFpAt4nOgEqLQ0bcKso=;
        b=cmrDD1WzwFetqMm5KHsZB0oADfAmO+tovwVIu0V0Eg/pVhhQqCwiTw+fOUiKv16eNS
         kridRrae8lR1+tDhrxt/sbKawDd/tIYVXOM35yFxbKMVNmX92bABXrGFpgkj8N4sUB2a
         ITv4rxzGyUlJFleSxGFuIAMr+jiqp59AIrGo/z6j24vA11gtINu96YipSFJjE2dVoMHv
         CJH0F7xKSeZwVYh4RojRYGnWbz5cVm95DVpB3wLfCJedUHFzAamSGhj9640TlGTwV05s
         yosPxrGsb/y9eKeUiRKIXZmm/+kNRvUBOLb1uI3x89nVj6YOt/wXGLLcCmrT3C/cp/dm
         JbJA==
X-Gm-Message-State: AFuF++kAYe0DM9kRVzuGC0HUfbaihfT2YTaY9F1/s6id/n0A0i5aGcVb
	XG9WTkFwMVfDfQfXeX70WWmtN66Sc1+RpT6HEDGKketcEsqMIAnFwFyzrgTl3Eml
X-Gm-Gg: AR+sD13Kq4zl1610oKTTv4LYvwribH8aVYl/eLPas9SZvBhfx6p7ytWTPHV9Gb2S4gr
	AbiGvVW6LWVXvApOSRPqyaHM3Q3ha2X5BXXq9/OO8C204N+dksa+je4ADhJAqprv/G2kcQvokFA
	qTWhUbKyHfpskkf3ISC5M+xS1yIPymZJNFStbMhI4WriApJs1pyrW0j6IJj+kiSX3uSLy2xSCvt
	ULUpUlFkj2JTJSqd9QThwJctG32mzoc4YtBB3tKqdNg+0EamdoEv2tjv9iRGB/8IZyURulXHdc9
	gqPHnCK2GIMjTFzR/vMTPp0Smg7kXQ7Rhcs0JcoUjwCr4fUO6lZwGtqGJNp2PlAwLd7VUa+4v+g
	JBRvx94i4xdxXSRZHmgYmE8wZg7MJt/P3DwE8+9SnbrWZee6/qOhtsAp+qrl9gCDnxuOvtZUIjY
	/DMSgf8rZ0df/TY0SOwS7/r3ycicIj5YjLB5M/WeiV9wGgJYxnlvCMyQKAOFe4RZCM2uBCRpY15
	Y7AH4Vkf+vpMs+Cj/JrA9eVTrorsFwTsnBs60hR9T/TyKui1XVvFqczvCQvZw==
X-Received: by 2002:a05:6512:3ba4:b0:5ad:5c4a:8221 with SMTP id 2adb3069b0e04-5b5e684b888mr974450e87.0.1787895631255;
        Thu, 27 Aug 2026 22:40:31 -0700 (PDT)
Received: from archlinux ([94.180.48.0])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b5e8a1a8edsm166172e87.79.2026.08.27.22.40.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 22:40:31 -0700 (PDT)
From: Arsenii Pashchenko <ulijg308@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Arsenii Pashchenko <ulijg308@gmail.com>
Subject: [PATCH rtw-next v7 1/3] wifi: rtw88: rtw8822c: Use bitfield macros for DAC IQ sampling
Date: Fri, 28 Aug 2026 12:40:21 +0700
Message-ID: <e4c9ff204ce4d6901da97a83b11dce1bd42f6b21.1787895379.git.ulijg308@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1787895379.git.ulijg308@gmail.com>
References: <cover.1787895379.git.ulijg308@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Define proper GENMASK constants for the In-phase (I) and Quadrature
(Q) components of the DAC IQ data register in the header file.
Replace manual bit shifting, masking, and rtw_read32_mask() with
standard rtw_read32() and the FIELD_GET() macro to improve code
readability.

Signed-off-by: Arsenii Pashchenko <ulijg308@gmail.com>
---
 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 18 +++++++++---------
 drivers/net/wireless/realtek/rtw88/rtw8822c.h |  3 +++
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
index 244c80264..137544649 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -291,9 +291,9 @@ static void rtw8822c_dac_cal_iq_sample(struct rtw_dev *rtwdev, u32 *iv, u32 *qv)
 
 	while (i < DACK_SN_8822C && cnt < 10000) {
 		cnt++;
-		temp = rtw_read32_mask(rtwdev, 0x2dbc, 0x3fffff);
-		iv[i] = (temp & 0x3ff000) >> 12;
-		qv[i] = temp & 0x3ff;
+		temp = rtw_read32(rtwdev, 0x2dbc);
+		iv[i] = FIELD_GET(RTW8822C_DAC_IV_MASK, temp);
+		qv[i] = FIELD_GET(RTW8822C_DAC_QV_MASK, temp);
 
 		if (rtw8822c_dac_iq_check(rtwdev, iv[i]) &&
 		    rtw8822c_dac_iq_check(rtwdev, qv[i]))
@@ -344,12 +344,12 @@ static void rtw8822c_dac_cal_iq_search(struct rtw_dev *rtwdev,
 		rtw8822c_dac_iq_sort(rtwdev, iv, qv);
 
 		if (i_delta > 5 || q_delta > 5) {
-			temp = rtw_read32_mask(rtwdev, 0x2dbc, 0x3fffff);
-			iv[0] = (temp & 0x3ff000) >> 12;
-			qv[0] = temp & 0x3ff;
-			temp = rtw_read32_mask(rtwdev, 0x2dbc, 0x3fffff);
-			iv[DACK_SN_8822C - 1] = (temp & 0x3ff000) >> 12;
-			qv[DACK_SN_8822C - 1] = temp & 0x3ff;
+			temp = rtw_read32(rtwdev, 0x2dbc);
+			iv[0] = FIELD_GET(RTW8822C_DAC_IV_MASK, temp);
+			qv[0] = FIELD_GET(RTW8822C_DAC_QV_MASK, temp);
+			temp = rtw_read32(rtwdev, 0x2dbc);
+			iv[DACK_SN_8822C - 1] = FIELD_GET(RTW8822C_DAC_IV_MASK, temp);
+			qv[DACK_SN_8822C - 1] = FIELD_GET(RTW8822C_DAC_QV_MASK, temp);
 		} else {
 			break;
 		}
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.h b/drivers/net/wireless/realtek/rtw88/rtw8822c.h
index fc62b67a1..7bea99614 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.h
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.h
@@ -141,6 +141,9 @@ const struct rtw_table name ## _tbl = {			\
 #define DACK_RF_8822C		1
 #define DACK_SN_8822C		100
 
+#define RTW8822C_DAC_IV_MASK GENMASK(21, 12)
+#define RTW8822C_DAC_QV_MASK GENMASK(9, 0)
+
 /* phy status page0 */
 #define GET_PHY_STAT_P0_PWDB_A(phy_stat)                                       \
 	le32_get_bits(*((__le32 *)(phy_stat) + 0x00), GENMASK(15, 8))
-- 
2.55.0

