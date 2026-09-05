Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D14E63B2FC6
	for <linux-wireless@vger.kernel.org>; Sat,  5 Sep 2026 10:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788602759; cv=none; b=K15RdRwZkbpuOdMyaYJ77vANesuTMCidVF3bgK6P3tAHlrFnTwG1GPBV15dA97FWpCkVySKK6GWH3BPS+pCIABqEer/lofcH3pCIytJdeyrwy5FG67fnIJ80i5GVoBY6v3HCgCVWUdKwg29VoaO7aK2fmIxxm0soOR3Zo7gk2Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788602759; c=relaxed/simple;
	bh=IpBe6QMdFYojPCd3r7iZwbZIV3JLrSuhGwUg6VBmvF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gx39Vea1KkvKnX5xEsPfus+ct3PND1fZ5xFUkVAptaQEQwAvEAu0715XbG74B8oQdTi5yEwMDZlkQrNoAdo+SxkTdsDeNEy1nd9cnI5418E0NQ8Wkwgo2bYktJNt1+dQpcF4zcYOmTF4LV/XW50hU8JuYyX0A4jGl2Ut4H/bwsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=stdXOfHD; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="stdXOfHD"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-3a35920ff96so24433171fa.0
        for <linux-wireless@vger.kernel.org>; Sat, 05 Sep 2026 03:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788602756; x=1789207556; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZihC6gdFyAtWT1MYgYEnu+8RGKM23e/TuDS3snfY308=;
        b=stdXOfHDBp34JXGT9Fwm2mVPufrMaiJaXhwyZoqIRDKiOrvQ0D+upCJ2zs7t/wS23T
         0g+J4R7r0oY3y4SOlcvfyJ83N9sP3BnLt+ldcg3SAvLHQT5eHLXhauPtAVFqq8td6iGa
         2KO1uztNAwXjYa4xknG8+85lST7krWreoJVrcmK+o0AgjXaBj5mBPeM8OkdQNymqcPjA
         LU0PULXq6/wvlTgVkdVkt2s1yHMaVmVdEOSTtIx/X6wnLPQN7JB01M6/dnVJgNtuWP6k
         oKuwyWitKoSh3bpfb4M8uPVbQ3YWMSpd6w7C0Cgy5t2IGddzfQv10UVmYYW4y62az9NR
         Tr2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788602756; x=1789207556;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZihC6gdFyAtWT1MYgYEnu+8RGKM23e/TuDS3snfY308=;
        b=C4xcyDhvUGESh1/REHRO/Ce5aezXVJ5OCfbbSTwKS3awe9T38HTzmluj8B8iRlwnNm
         Y5gh02QnmUzXwMyYFpvKMLAo4nTd/niWc6gjtSmTsHRZBQpgV4+8qs3SD7ZjSIs3GPhn
         0BYxMcNTwovr1gifPQx1AHagmtGlX1A4ZjZLnZDLcuiyvKnWiLTDe32fidadwrjcw0Ej
         iUwLJI9eMNQ1UJlMcftYk9t1b4M1BuLWXsnKrvvX+RfKBhAQyg2E8PCk5ixrqtfgvFp6
         j5YgS0Oe2olhLxIwxRWLaGo8asJvGhnFz9yYvO8RWbcnYZhQbJUtChK//ywZl4i/WthW
         nFTw==
X-Gm-Message-State: AFuF++l4DsrOVb3SGAEdfL/uOyepGZmMV9Mc5bytsEFEuhYf65OYet1D
	BZM/1jvoU6tnCXK2OU8nK7XKuavw+XTLRQAmmIlED/axcy1gspe2SmYc
X-Gm-Gg: AYBFou3V/p/BtEOP+eVF22ilz3U6Rk48J30COnpJY4FsS3po4a+QcL88FnLz1vA9wVl
	UrArBME5FznE8vLR1+6SrGRh+Xv0vkmsP/nyYFeZZOoGM6fN/VL6RVxnQ7JrRCD//F9Zgn3Iab9
	8LskVKMrXTHlu/2rZFmODpUBxukXrx03+fDsrRT/uTpiJOmJCSuzpvIfMqksxSVKhrFweV6tv7L
	mOJBtRO2VSGNYbVuJhEyC1+lNEe/frsxgTcpfvovgaPS9JgS/E8cw4XvUfm/nC12/eUz3zZuw8K
	VSm//qH5x/Mk1hS321cZZy1B631TuILGIoCcOVcOAc7lgBmpZu6ClBEhxfOMB2PDQhuY4DTOBXo
	vnh8c7yGgIeX80yTdR0LZ3FNwT+EmlW0u/TR0rhCUmr4jznn8Sklg/w7BmjnO4AdcYRnzACwcRH
	2PSjlHyJWDxqNLPJhgIYRqzFyitIs0SSr1aDqd27+wyFM9iqxXLMRu2I2wTdY7tzk15n/O4kMMw
	6xlD0xIh6/zJkacmJGBvjz7+Q8GW8GqERjIaCTOhtFSSk3wxLvJI6BAwuhLxA==
X-Received: by 2002:a05:651c:31cf:b0:3a3:61ec:7db7 with SMTP id 38308e7fff4ca-3a372e08c5fmr10761191fa.13.1788602755470;
        Sat, 05 Sep 2026 03:05:55 -0700 (PDT)
Received: from archlinux ([94.180.80.42])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a3705868a0sm13107741fa.19.2026.09.05.03.05.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2026 03:05:55 -0700 (PDT)
From: Arsenii Pashchenko <ulijg308@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Arsenii Pashchenko <ulijg308@gmail.com>
Subject: [PATCH rtw-next v8 1/3] wifi: rtw88: rtw8822c: Use bitfield macros for DAC IQ sampling
Date: Sat,  5 Sep 2026 17:05:46 +0700
Message-ID: <064626e2b0a0e415ddd53afbf908c000524e0e58.1788601784.git.ulijg308@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1788601784.git.ulijg308@gmail.com>
References: <cover.1788601784.git.ulijg308@gmail.com>
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
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
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

