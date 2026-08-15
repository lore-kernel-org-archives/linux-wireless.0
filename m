Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A048346A11
	for <linux-wireless@vger.kernel.org>; Sat, 15 Aug 2026 05:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786772807; cv=none; b=l2h9Q4lGcc36mCsdfeRQMfnVbSppkSMqiTcPUlvdMMKqxn32dFAmGdfoOfuze2XVqJA9VppMtTbNXO4YVpaRNpcYqqqtwglujmb83eY1spusSa4PxArvjaQgNqM0Vl1ZdrkK//ytjnRu0UViLLlc7koZHv1Ksk4s856T99FsXnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786772807; c=relaxed/simple;
	bh=Z00uPlHINFdWZ0lDkNXlfTa7IGNeSDYooOU+xbBGCgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fV1fJaDuiXCnrGjoPGSoAvqJ5BiHiXCksM3xQcKyFHc4r4EP7RfxxkOsl9jRDOxuuyW6GpfJD46NfjkYyXRAmcOl6hd/8Oa79Q0r3Qb+CEXYELY4OgvNJ0mztG5ryGBkFyxqHZe882/Gt0lcUeTDVsH9Mp2fA4Xbc4HTCJzU9Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j2eNaNpJ; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j2eNaNpJ"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5b2a4359d16so1488184e87.3
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2026 22:46:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786772804; x=1787377604; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=A22tk3gAdpRt2mKGtYB3EhhvS9YqP63DQw1gsI+Ivpk=;
        b=j2eNaNpJHZvoz0v5TfUcuWUyEWdC4OX+SVWSoO0kMmG5DDCHJZaPN5m21ZHBlG2NwG
         P/hP0vDjNe4yRC7pBbTQ7xCgmzBDhUrs6zLgs9pZf6FOBpl+UEWkGhZPqLvCT2x1mjV1
         eGjiqpb8CJxzTehGUMJOlYozxZvts7/D6q/bFRBYRk8yfkMOtesArsjWRUADE2Zclx99
         w6IQH2SxbG7cI9OUpGi/HFV3W9cnZkQCVxYl1coaU7zOmzluB109zMGY0zQpr+z+hND8
         yK9UX6N6bWmMSZVDCF5nubTxnePYE+iHC53Tb+y+FQfIAFvi6P4R1sTaAsa8JvQPUeii
         RGOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786772804; x=1787377604;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=A22tk3gAdpRt2mKGtYB3EhhvS9YqP63DQw1gsI+Ivpk=;
        b=MH0YGXfxaeF0uEux0Bn6AjhysnJ4/g7eSfnBgFeuU8/BpouTZfJpcPKJA6OX+trCgO
         Cy5QsFTy5wXiZDjY+ng61p/Ej8tEQR0r5wD8JrGVDoQjZ0o0TagvkoIRnJ71zOHIjuza
         oEvKKyfRHm1N3Eo5BG44OyQngNYNxoUy3pteusmHejEIimIHcjCu046ZZ4z0ouq3W6hE
         x560PLqQiuwHFHMpRAidd3BvvMAxzYAgiepYPdHsrYIApTdOXxATLJG2s2z225Lf2qcx
         jUVIkGCJFuMrETsvj5nfoZC2sUJGJIkVEuveoK8pq5g/7xUqKk1ZrzYCaJyAT4s8TyZX
         DkIQ==
X-Gm-Message-State: AOJu0Yyy9ZCzRgMPFHXCg84+kZc9ZyfZhx6A3InL2UHj7rd13jWiLLWS
	Fh/vlDHz9WCDZvyyyB5LLatEqrpWFPctzakgC7t6LVvSxg/6NIy1WtlJ
X-Gm-Gg: AR+sD10f4cWutng9zBJrTj/Yt0xxinVsTRHD05DEXLRNiWTTt4dxvcQAHtGybTqQVlW
	On1PvxaFnzmpXRsmf8sAchSBlcZ0uynbWtHXMOVLUSgGBflfeuZ6bLiDNlL2dcXykxM5D07/R6w
	PHAxApTVVOZ04bk/vMUocY9gnZBI9ceDtroGh6UyL9j6amStm4K3dPoSIHQYOWFB5agTnAal4Xp
	YbwoSbhs+ILsUaVsdiZ9H+bhjcorg50HVe70eeJT43CwjohIM+4WlMGopAZDSxL0GkaNknIZ04k
	NhjEwiGkWH1oUfVtyEGwfFUhv0Mbuat4jo6orXNIFEx6IuvWLOKur/tJb7XXiNvxqytvm7UxwHM
	/sUjloyz6YpGPtBa79Uc0nM8wHNaszTy4NxKLnyZByG0OCZAVg3lc+kjxCUJY9GQ9+khIIDw8Y5
	umq9LTFZ051AFrqUtTK6fvPiPdJWIb4qzNdY8LofFYct0qatkgO1DWUd7IL0Rt4nTtx65U4wO6K
	p52A02z73bKfvyoJTPe+Yscdp1NZ/MAxVDlAyGhGJ1FKuguafbHe3OCSs5RIw==
X-Received: by 2002:a05:6512:3d94:b0:5b0:1879:1ba9 with SMTP id 2adb3069b0e04-5b45917ebe6mr1663066e87.33.1786772804200;
        Fri, 14 Aug 2026 22:46:44 -0700 (PDT)
Received: from archlinux ([94.180.44.22])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b458bed96esm967527e87.40.2026.08.14.22.46.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 22:46:41 -0700 (PDT)
From: Arsenii Pashchenko <ulijg308@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Arsenii Pashchenko <ulijg308@gmail.com>
Subject: [PATCH rtw-next v5 1/3] wifi: rtw88: rtw8822c: Use bitfield macros for DAC IQ sampling
Date: Sat, 15 Aug 2026 12:46:32 +0700
Message-ID: <b36530d585bfda61cc49637d97615432bb2f3e37.1786771562.git.ulijg308@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1786771562.git.ulijg308@gmail.com>
References: <cover.1786771562.git.ulijg308@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-ID: <20260815054632.DL-EsnNYfQPVxqYZv49UCMa3CwnyWWKjM1DpFwDx0Ts@z>

Define proper GENMASK constants for the In-phase (I) and Quadrature
(Q) components of the DAC IQ data register in the header file.
Replace manual bit shifting, masking, and rtw_read32_mask() with
standard rtw_read32() and the FIELD_GET() macro to improve code
readability.

Signed-off-by: Arsenii Pashchenko <ulijg308@gmail.com>
---
 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 20 +++++++++----------
 drivers/net/wireless/realtek/rtw88/rtw8822c.h |  3 +++
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
index 244c80264..3bf9291d6 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -18,7 +18,7 @@
 #include "bf.h"
 #include "efuse.h"
 
-#define IQK_DONE_8822C 0xaa
+#define IQK_DONE_8822C 0xaa4
 
 static void rtw8822c_config_trx_mode(struct rtw_dev *rtwdev, u8 tx_path,
 				     u8 rx_path, bool is_tx2_path);
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

