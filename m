Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D561369D53
	for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2026 19:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787081648; cv=none; b=PW6FfEFt6mY6z1OopWMlecqlAhaVjXA3iKBMsZJyFY9FYfsMMxLXivxLVbdP3mMEqa1TFzAuNiOWamo4j1co5GYGaVqBj7yqwDPjnHkXlScnFAQnIWxHSt823zTcrbnJXn+oLVqg/digoC8V3cqyIWrCQ5ahUZWPCWumO7mQIYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787081648; c=relaxed/simple;
	bh=1SOFUBTOJ8XwDIbuJyMgsC+9WCvsdyIt5tYPNFRh9x4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YI3WCvIod1FQqBJWHkeAhiD/S7T+DYwBvgvbDNGPcru4ECK0d9uO+gv3AVwD0JUUS05iZgW8pjrs2R6Eyulnmh/soSmstzZ4exEacl+k58o5MhChK0ODxRUH6B3gb1mU6vhclRCel9nSxNSrKrI1LfNjHbs3bw5V77ew87hiaQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pRXUsY9E; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pRXUsY9E"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7f434cc1c5eso204623a34.0
        for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2026 12:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787081646; x=1787686446; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=D4tmt+Pdb0ltBHdalB+doNnR5Bk3Znm7WuXsBHOBbp8=;
        b=pRXUsY9Etmz6eK1jSRGXMWv+AEI2bGBJ4wLgesBc37UWK8a6pLS3QOSHXOH6O9F0rs
         WtkGzqTXmV4H/8HtSzgx1AjIxk9YXgUJnGJn8DR5qB3kYkLvV9y9HLBPyaVBdxbBHMU1
         PYj+qvgCJXeB796KgK8onFg1kanOXFf6CocwPdeXUT0WwwOJJYrB6xI714MsdBR/GgSe
         c816zG5RnHGeypw+bdlqFLZyW2iq+GvRcnjpaU+KEtG6cvUeTKUkeaNztORgWH0XpfcS
         Ky6jkCWsYqEaCMDv5jPp4TC36CjXL4ojpaGRmcVjYdCk4I7mGYNZ6JEnDocTfKJ9TXbg
         g8hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787081646; x=1787686446;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=D4tmt+Pdb0ltBHdalB+doNnR5Bk3Znm7WuXsBHOBbp8=;
        b=VvZJRMD/a5bNYcnbAkJOfZDXlY8ElDwJdClLjtK2vW6gtO9WP/3lEgJ7GlOp6xA07I
         cvRatlXsIYFPZdzaDNIEfZuz1wQsiKGFV45PypZCdqxlfDKHwwm5ufyUo/TQ5YHVhgzf
         TjG7/jab4vT//XZh9c4qTBxoiGiiZ6exB5zvosDZti2aRkv2A2SaZUi2fAkQ3EJlU97U
         jzO6oqAL0oTZygodsV3qy15yOBnE6irWax/qW9VpszUioVHkEKu5H3js3FXtfgctAfcU
         Kwol4qWpVV/0zSPPWcn8vQk+CwNC7V5kfzLAfltHX8zpYoUhiXijbQgiCdX0YJKWdoSn
         oJDg==
X-Forwarded-Encrypted: i=1; AHgh+Rpgn63qARXPyOF/ayAhCIAN7rx4qIB81ytE/gnrkSAaqlTpPW6mCOwoP3brqZnP4Iit6And3PFfcnxQsRt9Wg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyM/QP8FXsTMhfDxyT0slQNDhdJNj//k8Y/wv3CbUlQyn+swc90
	OECbdk+xvyku7e2IXlikNHv3lTbysrlh4RaHPirrY9Dz9gl93T9ePDA7
X-Gm-Gg: AR+sD11fQhDSvwLX56BPzLB4xm1f4y65udV9diYt026wpJMnik7ZaWyUulaDaYj1HW9
	pLWck9GRDeBlB7lK+x6V9hVoJu8NrAUqvfgYMD+g4ywUZyM6a4l6sTl+Jf8GHaUjpJ+fxxXRgTA
	2vrkx3WQk+IDP93xSV0b1nGk7YxKwuZhqRL6o9aHAVXxIYtiitjSr0eyAD2ytfk+4yFIZJEh9tm
	enhASoROWe+3tBNQp1kh+mFZZQyUe6EhHCuxKnJmXBEPM1o+dAPcRZt9ZFs5vWz3Q0bUqe5D60Q
	ktSRZgdX339C2eQudntMe8afqX05eN3KnKdIvX6vCbc5Y1mUA9zdeARk4Xe6X+QVQBfQ2zEBop8
	tYn7eCj3IrOwhTn/tRZIBV2tBom9I5/WwbGfIlGyM3uZaybyDs67NdVRAVppc2b7UpjcNx2R4ka
	FRGNenMA0USygvQw9TIe2QbR2CZixBkg7yHaBWYuq7rIP3jvU5Nf7FlVZYanY8S9kijhevXjm4
X-Received: by 2002:a05:6830:2115:b0:7e9:ef39:1caf with SMTP id 46e09a7af769-7f423f6172bmr11331966a34.16.1787081645901;
        Tue, 18 Aug 2026 12:34:05 -0700 (PDT)
Received: from tradnomic.. ([2601:646:8300:7570:ba5c:938b:1f55:72ff])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f41beef73fsm5039287a34.4.2026.08.18.12.34.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 12:34:05 -0700 (PDT)
From: rafad900 <rafad900@gmail.com>
To: Jes.Sorensen@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Cc: Rafael Alejandro Diaz Cruz <rafad900@gmail.com>
Subject: [PATCH rtw-next v5] wifi: rtl8xxxu: Use local 'dev' variable for dev_warn()
Date: Tue, 18 Aug 2026 12:34:02 -0700
Message-ID: <20260818193402.2109269-1-rafad900@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Rafael Alejandro Diaz Cruz <rafad900@gmail.com>

To ensure consistent patterns, the device struct was
defined and used when dev_warn() is called.
This follows the logging pattern used in most of
rtl8xxxu files.

Signed-off-by: Rafael Alejandro Diaz Cruz <rafad900@gmail.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/8188e.c |  4 +--
 drivers/net/wireless/realtek/rtl8xxxu/8188f.c |  3 +-
 drivers/net/wireless/realtek/rtl8xxxu/8192e.c | 16 +++++-----
 drivers/net/wireless/realtek/rtl8xxxu/8192f.c | 11 ++++---
 drivers/net/wireless/realtek/rtl8xxxu/8723a.c |  4 +--
 drivers/net/wireless/realtek/rtl8xxxu/8723b.c |  4 +--
 drivers/net/wireless/realtek/rtl8xxxu/core.c  | 31 ++++++++++---------
 7 files changed, 39 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/8188e.c b/drivers/net/wireless/realtek/rtl8xxxu/8188e.c
index fea5aec9ced9..040f4bbbeae4 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/8188e.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/8188e.c
@@ -643,6 +643,7 @@ static int rtl8188eu_iqk_path_a(struct rtl8xxxu_priv *priv)
 
 static int rtl8188eu_rx_iqk_path_a(struct rtl8xxxu_priv *priv)
 {
+	struct device *dev = &priv->udev->dev;
 	u32 reg_ea4, reg_eac, reg_e94, reg_e9c, val32;
 	int result = 0;
 
@@ -740,8 +741,7 @@ static int rtl8188eu_rx_iqk_path_a(struct rtl8xxxu_priv *priv)
 	    ((reg_eac & 0x03ff0000) != 0x00360000))
 		result |= 0x02;
 	else
-		dev_warn(&priv->udev->dev, "%s: Path A RX IQK failed!\n",
-			 __func__);
+		dev_warn(dev, "%s: Path A RX IQK failed!\n", __func__);
 
 out:
 	return result;
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/8188f.c b/drivers/net/wireless/realtek/rtl8xxxu/8188f.c
index 5556aad1a7ad..68609ce37ab0 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/8188f.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/8188f.c
@@ -789,6 +789,7 @@ static int rtl8188fu_init_phy_rf(struct rtl8xxxu_priv *priv)
 
 void rtl8188f_phy_lc_calibrate(struct rtl8xxxu_priv *priv)
 {
+	struct device *dev = &priv->udev->dev;
 	u32 val32;
 	u32 rf_amode, lstf;
 	int i;
@@ -819,7 +820,7 @@ void rtl8188f_phy_lc_calibrate(struct rtl8xxxu_priv *priv)
 	}
 
 	if (i == 100)
-		dev_warn(&priv->udev->dev, "LC calibration timed out.\n");
+		dev_warn(dev, "LC calibration timed out.\n");
 
 	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_MODE_AG, rf_amode);
 
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/8192e.c b/drivers/net/wireless/realtek/rtl8xxxu/8192e.c
index 690ace303150..131da162d9fb 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/8192e.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/8192e.c
@@ -742,6 +742,7 @@ static int rtl8192eu_iqk_path_a(struct rtl8xxxu_priv *priv)
 
 static int rtl8192eu_rx_iqk_path_a(struct rtl8xxxu_priv *priv)
 {
+	struct device *dev = &priv->udev->dev;
 	u32 reg_ea4, reg_eac, reg_e94, reg_e9c, val32;
 	int result = 0;
 
@@ -860,8 +861,7 @@ static int rtl8192eu_rx_iqk_path_a(struct rtl8xxxu_priv *priv)
 	    ((reg_eac & 0x03ff0000) != 0x00360000))
 		result |= 0x02;
 	else
-		dev_warn(&priv->udev->dev, "%s: Path A RX IQK failed!\n",
-			 __func__);
+		dev_warn(dev, "%s: Path A RX IQK failed!\n", __func__);
 
 out:
 	return result;
@@ -869,6 +869,7 @@ static int rtl8192eu_rx_iqk_path_a(struct rtl8xxxu_priv *priv)
 
 static int rtl8192eu_iqk_path_b(struct rtl8xxxu_priv *priv)
 {
+	struct device *dev = &priv->udev->dev;
 	u32 reg_eac, reg_eb4, reg_ebc;
 	int result = 0;
 
@@ -910,14 +911,14 @@ static int rtl8192eu_iqk_path_b(struct rtl8xxxu_priv *priv)
 	    ((reg_ebc & 0x03ff0000) != 0x00420000))
 		result |= 0x01;
 	else
-		dev_warn(&priv->udev->dev, "%s: Path B IQK failed!\n",
-			 __func__);
+		dev_warn(dev, "%s: Path B IQK failed!\n", __func__);
 
 	return result;
 }
 
 static int rtl8192eu_rx_iqk_path_b(struct rtl8xxxu_priv *priv)
 {
+	struct device *dev = &priv->udev->dev;
 	u32 reg_eac, reg_eb4, reg_ebc, reg_ec4, reg_ecc, val32;
 	int result = 0;
 
@@ -1040,8 +1041,7 @@ static int rtl8192eu_rx_iqk_path_b(struct rtl8xxxu_priv *priv)
 	    ((reg_ecc & 0x03ff0000) != 0x00360000))
 		result |= 0x02;
 	else
-		dev_warn(&priv->udev->dev, "%s: Path B RX IQK failed!\n",
-			 __func__);
+		dev_warn(dev, "%s: Path B RX IQK failed!\n", __func__);
 
 out:
 	return result;
@@ -1495,6 +1495,7 @@ static int rtl8192eu_active_to_lps(struct rtl8xxxu_priv *priv)
 
 static int rtl8192eu_active_to_emu(struct rtl8xxxu_priv *priv)
 {
+	struct device *dev = &priv->udev->dev;
 	u8 val8;
 	int count, ret = 0;
 
@@ -1521,8 +1522,7 @@ static int rtl8192eu_active_to_emu(struct rtl8xxxu_priv *priv)
 	}
 
 	if (!count) {
-		dev_warn(&priv->udev->dev, "%s: Disabling MAC timed out\n",
-			 __func__);
+		dev_warn(dev, "%s: Disabling MAC timed out\n", __func__);
 		ret = -EBUSY;
 		goto exit;
 	}
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/8192f.c b/drivers/net/wireless/realtek/rtl8xxxu/8192f.c
index 5f076da4b550..e1a10fe38b9a 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/8192f.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/8192f.c
@@ -681,6 +681,7 @@ static void rtl8192fu_init_aggregation(struct rtl8xxxu_priv *priv)
 
 static int rtl8192fu_parse_efuse(struct rtl8xxxu_priv *priv)
 {
+	struct device *dev = &priv->udev->dev;
 	struct rtl8192fu_efuse *efuse = &priv->efuse_wifi.efuse8192fu;
 	int i;
 
@@ -731,7 +732,7 @@ static int rtl8192fu_parse_efuse(struct rtl8xxxu_priv *priv)
 	priv->rfe_type = efuse->rfe_option & 0x1f;
 
 	if (priv->rfe_type != 5 && priv->rfe_type != 1)
-		dev_warn(&priv->udev->dev,
+		dev_warn(dev,
 			 "%s: RFE type %d was not tested. Please send an email to linux-wireless@vger.kernel.org about this.\n",
 			 __func__, priv->rfe_type);
 
@@ -1022,6 +1023,7 @@ static int rtl8192fu_rx_iqk_path_a(struct rtl8xxxu_priv *priv)
 
 static int rtl8192fu_iqk_path_b(struct rtl8xxxu_priv *priv)
 {
+	struct device *dev = &priv->udev->dev;
 	u32 reg_eac, reg_eb4, reg_ebc, val32;
 	u32 rf_0x58_i, rf_0x58_q;
 	u8 rfe = priv->rfe_type;
@@ -1109,14 +1111,14 @@ static int rtl8192fu_iqk_path_b(struct rtl8xxxu_priv *priv)
 	    ((reg_ebc & 0x03ff0000) != 0x00420000))
 		result |= 0x01;
 	else
-		dev_warn(&priv->udev->dev, "%s: Path B IQK failed!\n",
-			 __func__);
+		dev_warn(dev, "%s: Path B IQK failed!\n", __func__);
 
 	return result;
 }
 
 static int rtl8192fu_rx_iqk_path_b(struct rtl8xxxu_priv *priv)
 {
+	struct device *dev = &priv->udev->dev;
 	u32 reg_eac, reg_eb4, reg_ebc, reg_ec4, reg_ecc, val32;
 	int result = 0;
 	int ktime;
@@ -1246,8 +1248,7 @@ static int rtl8192fu_rx_iqk_path_b(struct rtl8xxxu_priv *priv)
 	    ((reg_ecc & 0x03ff0000) != 0x00360000))
 		result |= 0x02;
 	else
-		dev_warn(&priv->udev->dev, "%s: Path B RX IQK failed!\n",
-			 __func__);
+		dev_warn(dev, "%s: Path B RX IQK failed!\n", __func__);
 
 	return result;
 }
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/8723a.c b/drivers/net/wireless/realtek/rtl8xxxu/8723a.c
index 18e038b82f49..a68e89c06cf1 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/8723a.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/8723a.c
@@ -413,6 +413,7 @@ static int rtl8723au_power_on(struct rtl8xxxu_priv *priv)
 
 static int rtl8723au_active_to_emu(struct rtl8xxxu_priv *priv)
 {
+	struct device *dev = &priv->udev->dev;
 	u8 val8;
 	int count, ret = 0;
 
@@ -439,8 +440,7 @@ static int rtl8723au_active_to_emu(struct rtl8xxxu_priv *priv)
 	}
 
 	if (!count) {
-		dev_warn(&priv->udev->dev, "%s: Disabling MAC timed out\n",
-			 __func__);
+		dev_warn(dev, "%s: Disabling MAC timed out\n", __func__);
 		ret = -EBUSY;
 		goto exit;
 	}
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/8723b.c b/drivers/net/wireless/realtek/rtl8xxxu/8723b.c
index 24c6d8ae76ec..2edcb6f34867 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/8723b.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/8723b.c
@@ -1216,6 +1216,7 @@ static void rtl8723bu_phy_iq_calibrate(struct rtl8xxxu_priv *priv)
 
 static int rtl8723bu_active_to_emu(struct rtl8xxxu_priv *priv)
 {
+	struct device *dev = &priv->udev->dev;
 	u8 val8;
 	u16 val16;
 	u32 val32;
@@ -1247,8 +1248,7 @@ static int rtl8723bu_active_to_emu(struct rtl8xxxu_priv *priv)
 	}
 
 	if (!count) {
-		dev_warn(&priv->udev->dev, "%s: Disabling MAC timed out\n",
-			 __func__);
+		dev_warn(dev, "%s: Disabling MAC timed out\n", __func__);
 		ret = -EBUSY;
 		goto exit;
 	}
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/core.c b/drivers/net/wireless/realtek/rtl8xxxu/core.c
index bddbd0990de7..f36cfaa2442f 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/core.c
@@ -2186,6 +2186,7 @@ void rtl8xxxu_firmware_self_reset(struct rtl8xxxu_priv *priv)
 static int
 rtl8xxxu_init_mac(struct rtl8xxxu_priv *priv)
 {
+	struct device *dev = &priv->udev->dev;
 	const struct rtl8xxxu_reg8val *array = priv->fops->mactable;
 	int i, ret;
 	u16 reg;
@@ -2200,8 +2201,7 @@ rtl8xxxu_init_mac(struct rtl8xxxu_priv *priv)
 
 		ret = rtl8xxxu_write8(priv, reg, val);
 		if (ret != 1) {
-			dev_warn(&priv->udev->dev,
-				 "Failed to initialize MAC "
+			dev_warn(dev, "Failed to initialize MAC "
 				 "(reg: %04x, val %02x)\n", reg, val);
 			return -EAGAIN;
 		}
@@ -2228,6 +2228,7 @@ rtl8xxxu_init_mac(struct rtl8xxxu_priv *priv)
 int rtl8xxxu_init_phy_regs(struct rtl8xxxu_priv *priv,
 			   const struct rtl8xxxu_reg32val *array)
 {
+	struct device *dev = &priv->udev->dev;
 	int i, ret;
 	u16 reg;
 	u32 val;
@@ -2241,8 +2242,7 @@ int rtl8xxxu_init_phy_regs(struct rtl8xxxu_priv *priv,
 
 		ret = rtl8xxxu_write32(priv, reg, val);
 		if (ret != sizeof(val)) {
-			dev_warn(&priv->udev->dev,
-				 "Failed to initialize PHY\n");
+			dev_warn(dev, "Failed to initialize PHY\n");
 			return -EAGAIN;
 		}
 		udelay(1);
@@ -2386,6 +2386,7 @@ static int rtl8xxxu_init_rf_regs(struct rtl8xxxu_priv *priv,
 				 const struct rtl8xxxu_rfregval *array,
 				 enum rtl8xxxu_rfpath path)
 {
+	struct device *dev = &priv->udev->dev;
 	int i, ret;
 	u8 reg;
 	u32 val;
@@ -2420,8 +2421,7 @@ static int rtl8xxxu_init_rf_regs(struct rtl8xxxu_priv *priv,
 
 		ret = rtl8xxxu_write_rfreg(priv, path, reg, val);
 		if (ret) {
-			dev_warn(&priv->udev->dev,
-				 "Failed to initialize RF\n");
+			dev_warn(dev, "Failed to initialize RF\n");
 			return -EAGAIN;
 		}
 		udelay(1);
@@ -2557,6 +2557,7 @@ int rtl8xxxu_init_llt_table(struct rtl8xxxu_priv *priv)
 
 int rtl8xxxu_auto_llt_table(struct rtl8xxxu_priv *priv)
 {
+	struct device *dev = &priv->udev->dev;
 	u32 val32;
 	int ret = 0;
 	int i;
@@ -2574,7 +2575,7 @@ int rtl8xxxu_auto_llt_table(struct rtl8xxxu_priv *priv)
 
 	if (!i) {
 		ret = -EBUSY;
-		dev_warn(&priv->udev->dev, "LLT table init failed\n");
+		dev_warn(dev, "LLT table init failed\n");
 	}
 
 	return ret;
@@ -3088,6 +3089,7 @@ void rtl8xxxu_mac_calibration(struct rtl8xxxu_priv *priv,
 
 static int rtl8xxxu_iqk_path_a(struct rtl8xxxu_priv *priv)
 {
+	struct device *dev = &priv->udev->dev;
 	u32 reg_eac, reg_e94, reg_e9c, reg_ea4, val32;
 	int result = 0;
 
@@ -3137,14 +3139,14 @@ static int rtl8xxxu_iqk_path_a(struct rtl8xxxu_priv *priv)
 	    ((reg_eac & 0x03ff0000) != 0x00360000))
 		result |= 0x02;
 	else
-		dev_warn(&priv->udev->dev, "%s: Path A RX IQK failed!\n",
-			 __func__);
+		dev_warn(dev, "%s: Path A RX IQK failed!\n", __func__);
 out:
 	return result;
 }
 
 static int rtl8xxxu_iqk_path_b(struct rtl8xxxu_priv *priv)
 {
+	struct device *dev = &priv->udev->dev;
 	u32 reg_eac, reg_eb4, reg_ebc, reg_ec4, reg_ecc;
 	int result = 0;
 
@@ -3173,7 +3175,7 @@ static int rtl8xxxu_iqk_path_b(struct rtl8xxxu_priv *priv)
 	    (((reg_ecc & 0x03ff0000) >> 16) != 0x36))
 		result |= 0x02;
 	else
-		dev_warn(&priv->udev->dev, "%s: Path B RX IQK failed!\n",
+		dev_warn(dev, "%s: Path B RX IQK failed!\n",
 			 __func__);
 out:
 	return result;
@@ -3637,6 +3639,7 @@ static void rtl8xxxu_set_ampdu_min_space(struct rtl8xxxu_priv *priv, u8 density)
 
 int rtl8xxxu_active_to_lps(struct rtl8xxxu_priv *priv)
 {
+	struct device *dev = &priv->udev->dev;
 	u8 val8;
 	u8 val32;
 	int count, ret = 0;
@@ -3654,8 +3657,7 @@ int rtl8xxxu_active_to_lps(struct rtl8xxxu_priv *priv)
 	}
 
 	if (!count) {
-		dev_warn(&priv->udev->dev,
-			 "%s: RX poll timed out (0x05f8)\n", __func__);
+		dev_warn(dev, "%s: RX poll timed out (0x05f8)\n", __func__);
 		ret = -EBUSY;
 		goto exit;
 	}
@@ -5862,6 +5864,7 @@ static void rtl8xxxu_queue_rx_urb(struct rtl8xxxu_priv *priv,
 static void rtl8xxxu_rx_urb_work(struct work_struct *work)
 {
 	struct rtl8xxxu_priv *priv;
+	struct device *dev;
 	struct rtl8xxxu_rx_urb *rx_urb, *tmp;
 	struct list_head local;
 	struct sk_buff *skb;
@@ -5869,6 +5872,7 @@ static void rtl8xxxu_rx_urb_work(struct work_struct *work)
 	int ret;
 
 	priv = container_of(work, struct rtl8xxxu_priv, rx_urb_wq);
+	dev = &priv->udev->dev;
 	INIT_LIST_HEAD(&local);
 
 	spin_lock_irqsave(&priv->rx_urb_lock, flags);
@@ -5894,8 +5898,7 @@ static void rtl8xxxu_rx_urb_work(struct work_struct *work)
 			rtl8xxxu_queue_rx_urb(priv, rx_urb);
 			break;
 		default:
-			dev_warn(&priv->udev->dev,
-				 "failed to requeue urb with error %i\n", ret);
+			dev_warn(dev, "failed to requeue urb with error %i\n", ret);
 			skb = (struct sk_buff *)rx_urb->urb.context;
 			dev_kfree_skb(skb);
 			usb_free_urb(&rx_urb->urb);
-- 
2.43.0

