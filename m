Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE5D2345741
	for <linux-wireless@vger.kernel.org>; Sat, 15 Aug 2026 05:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786772131; cv=none; b=GilihTnSWg8Q3C0IPnrdzU7H4tvMFGl4AUb1JtsWvSJOBKCAoZH4ueci0elh0uAPfjeSY/OGLoIj0678JDPsn3ZrCPVY0/0DQg1VnRncCigOJm1OnBFGEhaSPVCg4ZSHzuBatsIwAliIh2Osdw96o9cB9Nk9JnLdG6jA+La02h8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786772131; c=relaxed/simple;
	bh=Z00uPlHINFdWZ0lDkNXlfTa7IGNeSDYooOU+xbBGCgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eieVe9xs2fruYd+JBZ3ihsYjOACno69zpkBxEKhX+CkgMKFPA7lZOAV4oVLF8pWKp+127PLq/eEvVM0oC/wR1yR42JfQcP/LClzDlXZKfjNvgRZ/+P6obOcNj64zSr2T8OYPSSgtXG9OZoJANJaDfk0q5fjupvIQCBB9CqhiTsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iOOLAtHr; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iOOLAtHr"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5b2a4359d16so1485059e87.3
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2026 22:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786772126; x=1787376926; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=A22tk3gAdpRt2mKGtYB3EhhvS9YqP63DQw1gsI+Ivpk=;
        b=iOOLAtHryoEExIFdct6iTPhiKp3nLdOxBP7IpKsBwwfrYANVGsX/QMUEsX2zwNUS4O
         IAYttLA+juxIGllmuBg+B4QJsgf9qvpy3ForvJKM8r3P++ivbjB0UTZvP8k16mwou37o
         afSNQI0dhrlYetLW+evE8Aa/KouO/IH87PhussD7ZG3u2ZNyhaRWddW/DAApqABeh9/C
         kR7ZGuXnys/vawDGGafav4rF4ejfJCAtlgoURIVTssnKWruADVb7wkcaLPNC7zaHRuJI
         Z2UYYnWu3aEBibOpfIRAzBsZVqxQCrrcJKVHzLNI5Olx6IplolkscGJIHu1Vmh/qFYE8
         zASQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786772126; x=1787376926;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=A22tk3gAdpRt2mKGtYB3EhhvS9YqP63DQw1gsI+Ivpk=;
        b=RH1wLeWj7YHIvwXiD4TWZRz6I9tNBC6SXt8mOStArOpFAGyp5+ytQFZF3LpOJJOCYM
         y0WYVExpWW9e/wkaLDkqpeWB7GhAdDeAnW/EUd+3P5qJqPYLaYkbxX5naMZVz2QTBj4l
         gs15ieUsx2X+WSiH4tr5f8LGIdl9VMIGAtlPQS1ncyMb1AcMiHX9bo2H1gc9AlSa3MLF
         n0BTpnFvG1owpPAyLSF51MQpT14oEC8W7nQxHo2KbFz7cGogaHVuh4IvirMJpSEUz7GI
         wP5Ozqk6/ZiQZoG7Hx9NcInMYeGA/BfGmHsQPOZzj9jMaZKk2A//0NEykROcqfa3G2et
         Mtsw==
X-Gm-Message-State: AOJu0Yw7rVywH8/erZ1OlNaYu4N2z3z3F7qXzuLHfyHPr3YbP8FISDYl
	PlfMnp5KRxX49IFer+9CHgp2TEV7BXPhQ5bTSp0reIBadLIPTOcCMSFf04e3bgMY
X-Gm-Gg: AR+sD11a15tBAht1se1vEiK/SUwJMbIIxGkwtRd0kVoAKqqnbb8BbUt1kp+rTaZnHva
	CgxZ4XwGrDyXrPJqqaXCLOBIQtVLxcAqNaULPa2xKoYY8I5uqIMSxM0e2Po/PnnqJ/N7n8CmZ+d
	xNrJE5KqIB/YbVKhptkU72DSQnctXkQoChHj+VRmfgovfwskH5hQSRlGydxBWQy+QUXu4Pt+prt
	1VToxExaNVBpUDhKeXn575kKhVt0QjeFLqp4blLCfgvUMs3XddFfEEc8/87dWTSknihYktpCWnH
	xYqQbdbH4uLH+3oG0/e9j9oIsGCwJyh0hZFQUToz6q1my/0Q5UX+9KAoXhdN+9HoNJ9mnfn7Rsz
	P5EZQ3zZv0hJX6WySLi7/MYdlPwDFOWTqMHtkdrqguy2D42yuPLmryP2+qFEK84K7PotwcaR6xu
	fi+EaQiIXsm1c2OrAzHSHVpdGtBcHv3EVNqD3VZAgaNUyj84jkCzaDvKp62nJ0a0DFJS+ZfQTTo
	YKNyHR1A7pRuSxD+P5s1FKF8L0yjit9TLuMTIYG7KOUZzQ1I5DTIuR5ty/QlA==
X-Received: by 2002:a05:6512:32c1:b0:5ae:bb52:b09d with SMTP id 2adb3069b0e04-5b45918e859mr1630613e87.52.1786772125614;
        Fri, 14 Aug 2026 22:35:25 -0700 (PDT)
Received: from archlinux ([94.180.44.22])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b458c0a033sm932577e87.67.2026.08.14.22.35.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 22:35:25 -0700 (PDT)
From: Arsenii Pashchenko <ulijg308@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Arsenii Pashchenko <ulijg308@gmail.com>
Subject: [PATCH rtw-next v4 1/3] wifi: rtw88: rtw8822c: Use bitfield macros for DAC IQ sampling
Date: Sat, 15 Aug 2026 12:35:17 +0700
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

