Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D101F3F12D8
	for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 22:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787006476; cv=none; b=RgRLcF6lLIPGsseZ3HniF8UwFtm7uL64rzS+2/wbQPSnbb+ujLDaku2G7mnZUu5dJalN111qv51EsqwlcOdCGMizcWRyRKWjrG4bPmG07c45T1Oiz8PxFk7kPR79iY83WaqqMZFv3IAhlA/Du8FFz87E3HAzq5fYMHanqGud6G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787006476; c=relaxed/simple;
	bh=slShdWwl9l8XXcWyIYlPd2QpzKfAp4Z37OTO/1Zf9wk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ulmjd1Iv8Pfaof7SOVCKS1t75N1LtPqu7sN5atV/YFBCHXEPCGYxMxMUWYTvXOjrIQE8RxRNfp/Fzk2mxYHat55PQQxEGI+zW0DHTe0rNX659eDGfJ/+rTUeRSRmTuaqzJFzDiDJxXX1y1/932IeEIdMSl8C4YmKJn7uQ/BLssk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jzBMgZCn; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jzBMgZCn"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-38dcbade417so3985302a91.1
        for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 15:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787006474; x=1787611274; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/Q6l8e/Zui8lrA7iBPP4EfcGwK1+oeVm5EuwFc4yRPY=;
        b=jzBMgZCnCR28WKYyaIRvZa4vE1jPRAI67JnsXkNXzeT9DHf/h75iS91zTURb4ns00B
         eqMhhyvQXGkk0MKXr1sdwwTIDv858CF43QpOCO036udCPCcCYJmfKNVujnTwg/2ZVX2H
         NY0iJs4FZ1tcWV8Feb5UBBxr15yKAZFTUx0qm88gCCleQ32W9UlJB5XTmPJqKgf7wcSX
         NKLVk9nEFbxXFLmz/W7lL/xHwya1Kow9FCqEYc2XhLjI2RGO8JH06vvHc6HAgQ+gqint
         hzWXN6AgsOnyZEqAO7ztlVc2cYvaOpNnZDSnsEltOE/+vUWh+cHsbDWvj0a7sSXK8I6p
         4cjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787006474; x=1787611274;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/Q6l8e/Zui8lrA7iBPP4EfcGwK1+oeVm5EuwFc4yRPY=;
        b=frQB7TwJFMcus86BEvPHdIKgs5MlBuB8kYaZkz8MB4eW0i5c37fU7Y+E8E41hp4AQJ
         1yPwyy86yKbZnmKaTSk4lLO3fRPH34sxXhMLXW4DSNXzg26ZxDSrqMoiiYhB1Os8Ff7V
         GP9dOdVm+J7MozgFmlcJz1lMgiJnMO9KbJOEfM8hALn4Tex9likt8Dkm2nJAUvaTjg8D
         0/W/iL9CeM8W7R4bv9cgcuujTBZEZwq3aze74l54CmSm9axtfDZJEVn5IOn1AuJAO0vW
         jeYIn91r/wGVTMt8gaOo5NO1H+ZsG9pnufKgxhhn82DKa+G2UCTsCGGo0kPp+VPS7PaB
         tt4A==
X-Forwarded-Encrypted: i=1; AHgh+Rr1bH6EmKARoittTR8Pdd6x2jcUQUvmoWPe2Svcsx/DNcwxdjo/YWzt6OlrLzq+5Nb927uwk8DAL04lXXT69Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1tyVCtv4R+GLBT43XdYdwRE0m8vCvozTsHr54Fq8Nke6tWwxB
	Zru5uZpK24YpfJTXkIiTm6l4YyUtaHLdIjDfjp5HenrWGirIx7LByVjZ
X-Gm-Gg: AR+sD13s1/MzrJeaCDdxMcPI6Ipzwxs1hktTJsmXRfJpSe1fs4Ntoqdqdl3QPmFfkMn
	3vTQOgkoqo4T9hc4fSZ5tgDvB029ylPVA4/DtqV+2C2bIN1ge/5uH5DyjTjVxPI0Yr8kayi0lni
	888cbV1B7FHmIFWit62u/yAXKuNFSHsoi7wopDrQAzjv7G+Bho79jPctXjc0vJ9HOxHGqv9sUBN
	6som59u0vpVnlmzNUpZk41Uwp+ttcDQT2djeXYg9swE8KNx1WXBnagDtFIFrb13HQag9G4M0Cx/
	I6tRPBJ66uQYQ3EyDD37iVeR77RlMPB0Q72ujTPRNemLXG/06xV7gmX/53TpVi8D8yJbOwItRhU
	E9VTaSwXgnLlzaEbhmueGzBwcPzcfRWLw6+e9nJ/d6KPB4gWS4pCQ6eikD6dOPwnotsuJNSwsxp
	t2uC1qS7ZPHuUIbzck15TbpgmABDrG6tb9KPhYK0KqI9M3MXxaDicBarcN2bs=
X-Received: by 2002:a17:90b:1d8e:b0:395:4290:46e0 with SMTP id 98e67ed59e1d1-3955a5de3e9mr3139601a91.5.1787006473967;
        Mon, 17 Aug 2026 15:41:13 -0700 (PDT)
Received: from tradnomic.. ([2601:646:8300:7570:1a50:adc4:d908:3ae])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14152ea340csm9353772c88.0.2026.08.17.15.41.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 15:41:13 -0700 (PDT)
From: rafad900 <rafad900@gmail.com>
To: Jes.Sorensen@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Cc: Rafael Alejandro Diaz Cruz <rafad900@gmail.com>
Subject: [PATCH rtw-next v3] wifi: rtl8xxxu: Use local 'dev' variable for dev_warn()
Date: Mon, 17 Aug 2026 15:41:04 -0700
Message-ID: <20260817224104.1462505-1-rafad900@gmail.com>
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
 drivers/net/wireless/realtek/rtl8xxxu/8188e.c |  3 ++-
 drivers/net/wireless/realtek/rtl8xxxu/8188f.c |  3 ++-
 drivers/net/wireless/realtek/rtl8xxxu/8192e.c | 12 ++++++---
 drivers/net/wireless/realtek/rtl8xxxu/8192f.c |  9 ++++---
 drivers/net/wireless/realtek/rtl8xxxu/8723a.c |  3 ++-
 drivers/net/wireless/realtek/rtl8xxxu/8723b.c |  3 ++-
 drivers/net/wireless/realtek/rtl8xxxu/core.c  | 26 ++++++++++++-------
 7 files changed, 39 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/8188e.c b/drivers/net/wireless/realtek/rtl8xxxu/8188e.c
index fea5aec9ced9..4a64633b2da3 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/8188e.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/8188e.c
@@ -643,6 +643,7 @@ static int rtl8188eu_iqk_path_a(struct rtl8xxxu_priv *priv)
 
 static int rtl8188eu_rx_iqk_path_a(struct rtl8xxxu_priv *priv)
 {
+	struct device *dev = &priv->udev->dev;
 	u32 reg_ea4, reg_eac, reg_e94, reg_e9c, val32;
 	int result = 0;
 
@@ -740,7 +741,7 @@ static int rtl8188eu_rx_iqk_path_a(struct rtl8xxxu_priv *priv)
 	    ((reg_eac & 0x03ff0000) != 0x00360000))
 		result |= 0x02;
 	else
-		dev_warn(&priv->udev->dev, "%s: Path A RX IQK failed!\n",
+		dev_warn(dev, "%s: Path A RX IQK failed!\n",
 			 __func__);
 
 out:
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
index 690ace303150..8385ada532b3 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/8192e.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/8192e.c
@@ -742,6 +742,7 @@ static int rtl8192eu_iqk_path_a(struct rtl8xxxu_priv *priv)
 
 static int rtl8192eu_rx_iqk_path_a(struct rtl8xxxu_priv *priv)
 {
+	struct device *dev = &priv->udev->dev;
 	u32 reg_ea4, reg_eac, reg_e94, reg_e9c, val32;
 	int result = 0;
 
@@ -860,7 +861,7 @@ static int rtl8192eu_rx_iqk_path_a(struct rtl8xxxu_priv *priv)
 	    ((reg_eac & 0x03ff0000) != 0x00360000))
 		result |= 0x02;
 	else
-		dev_warn(&priv->udev->dev, "%s: Path A RX IQK failed!\n",
+		dev_warn(dev, "%s: Path A RX IQK failed!\n",
 			 __func__);
 
 out:
@@ -869,6 +870,7 @@ static int rtl8192eu_rx_iqk_path_a(struct rtl8xxxu_priv *priv)
 
 static int rtl8192eu_iqk_path_b(struct rtl8xxxu_priv *priv)
 {
+	struct device *dev = &priv->udev->dev;
 	u32 reg_eac, reg_eb4, reg_ebc;
 	int result = 0;
 
@@ -910,7 +912,7 @@ static int rtl8192eu_iqk_path_b(struct rtl8xxxu_priv *priv)
 	    ((reg_ebc & 0x03ff0000) != 0x00420000))
 		result |= 0x01;
 	else
-		dev_warn(&priv->udev->dev, "%s: Path B IQK failed!\n",
+		dev_warn(dev, "%s: Path B IQK failed!\n",
 			 __func__);
 
 	return result;
@@ -918,6 +920,7 @@ static int rtl8192eu_iqk_path_b(struct rtl8xxxu_priv *priv)
 
 static int rtl8192eu_rx_iqk_path_b(struct rtl8xxxu_priv *priv)
 {
+	struct device *dev = &priv->udev->dev;
 	u32 reg_eac, reg_eb4, reg_ebc, reg_ec4, reg_ecc, val32;
 	int result = 0;
 
@@ -1040,7 +1043,7 @@ static int rtl8192eu_rx_iqk_path_b(struct rtl8xxxu_priv *priv)
 	    ((reg_ecc & 0x03ff0000) != 0x00360000))
 		result |= 0x02;
 	else
-		dev_warn(&priv->udev->dev, "%s: Path B RX IQK failed!\n",
+		dev_warn(dev, "%s: Path B RX IQK failed!\n",
 			 __func__);
 
 out:
@@ -1495,6 +1498,7 @@ static int rtl8192eu_active_to_lps(struct rtl8xxxu_priv *priv)
 
 static int rtl8192eu_active_to_emu(struct rtl8xxxu_priv *priv)
 {
+	struct device *dev = &priv->udev->dev;
 	u8 val8;
 	int count, ret = 0;
 
@@ -1521,7 +1525,7 @@ static int rtl8192eu_active_to_emu(struct rtl8xxxu_priv *priv)
 	}
 
 	if (!count) {
-		dev_warn(&priv->udev->dev, "%s: Disabling MAC timed out\n",
+		dev_warn(dev, "%s: Disabling MAC timed out\n",
 			 __func__);
 		ret = -EBUSY;
 		goto exit;
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/8192f.c b/drivers/net/wireless/realtek/rtl8xxxu/8192f.c
index 5f076da4b550..0b8c068215d7 100644
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
@@ -1109,7 +1111,7 @@ static int rtl8192fu_iqk_path_b(struct rtl8xxxu_priv *priv)
 	    ((reg_ebc & 0x03ff0000) != 0x00420000))
 		result |= 0x01;
 	else
-		dev_warn(&priv->udev->dev, "%s: Path B IQK failed!\n",
+		dev_warn(dev, "%s: Path B IQK failed!\n",
 			 __func__);
 
 	return result;
@@ -1117,6 +1119,7 @@ static int rtl8192fu_iqk_path_b(struct rtl8xxxu_priv *priv)
 
 static int rtl8192fu_rx_iqk_path_b(struct rtl8xxxu_priv *priv)
 {
+	struct device *dev = &priv->udev->dev;
 	u32 reg_eac, reg_eb4, reg_ebc, reg_ec4, reg_ecc, val32;
 	int result = 0;
 	int ktime;
@@ -1246,7 +1249,7 @@ static int rtl8192fu_rx_iqk_path_b(struct rtl8xxxu_priv *priv)
 	    ((reg_ecc & 0x03ff0000) != 0x00360000))
 		result |= 0x02;
 	else
-		dev_warn(&priv->udev->dev, "%s: Path B RX IQK failed!\n",
+		dev_warn(dev, "%s: Path B RX IQK failed!\n",
 			 __func__);
 
 	return result;
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/8723a.c b/drivers/net/wireless/realtek/rtl8xxxu/8723a.c
index 18e038b82f49..3525ecf07b48 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/8723a.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/8723a.c
@@ -413,6 +413,7 @@ static int rtl8723au_power_on(struct rtl8xxxu_priv *priv)
 
 static int rtl8723au_active_to_emu(struct rtl8xxxu_priv *priv)
 {
+	struct device *dev = &priv->udev->dev;
 	u8 val8;
 	int count, ret = 0;
 
@@ -439,7 +440,7 @@ static int rtl8723au_active_to_emu(struct rtl8xxxu_priv *priv)
 	}
 
 	if (!count) {
-		dev_warn(&priv->udev->dev, "%s: Disabling MAC timed out\n",
+		dev_warn(dev, "%s: Disabling MAC timed out\n",
 			 __func__);
 		ret = -EBUSY;
 		goto exit;
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/8723b.c b/drivers/net/wireless/realtek/rtl8xxxu/8723b.c
index 24c6d8ae76ec..caf0f59aeeaf 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/8723b.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/8723b.c
@@ -1216,6 +1216,7 @@ static void rtl8723bu_phy_iq_calibrate(struct rtl8xxxu_priv *priv)
 
 static int rtl8723bu_active_to_emu(struct rtl8xxxu_priv *priv)
 {
+	struct device *dev = &priv->udev->dev;
 	u8 val8;
 	u16 val16;
 	u32 val32;
@@ -1247,7 +1248,7 @@ static int rtl8723bu_active_to_emu(struct rtl8xxxu_priv *priv)
 	}
 
 	if (!count) {
-		dev_warn(&priv->udev->dev, "%s: Disabling MAC timed out\n",
+		dev_warn(dev, "%s: Disabling MAC timed out\n",
 			 __func__);
 		ret = -EBUSY;
 		goto exit;
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/core.c b/drivers/net/wireless/realtek/rtl8xxxu/core.c
index bddbd0990de7..b3ef8e5c96a8 100644
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
@@ -2200,7 +2201,7 @@ rtl8xxxu_init_mac(struct rtl8xxxu_priv *priv)
 
 		ret = rtl8xxxu_write8(priv, reg, val);
 		if (ret != 1) {
-			dev_warn(&priv->udev->dev,
+			dev_warn(dev,
 				 "Failed to initialize MAC "
 				 "(reg: %04x, val %02x)\n", reg, val);
 			return -EAGAIN;
@@ -2228,6 +2229,7 @@ rtl8xxxu_init_mac(struct rtl8xxxu_priv *priv)
 int rtl8xxxu_init_phy_regs(struct rtl8xxxu_priv *priv,
 			   const struct rtl8xxxu_reg32val *array)
 {
+	struct device *dev = &priv->udev->dev;
 	int i, ret;
 	u16 reg;
 	u32 val;
@@ -2241,7 +2243,7 @@ int rtl8xxxu_init_phy_regs(struct rtl8xxxu_priv *priv,
 
 		ret = rtl8xxxu_write32(priv, reg, val);
 		if (ret != sizeof(val)) {
-			dev_warn(&priv->udev->dev,
+			dev_warn(dev,
 				 "Failed to initialize PHY\n");
 			return -EAGAIN;
 		}
@@ -2386,6 +2388,7 @@ static int rtl8xxxu_init_rf_regs(struct rtl8xxxu_priv *priv,
 				 const struct rtl8xxxu_rfregval *array,
 				 enum rtl8xxxu_rfpath path)
 {
+	struct device *dev = &priv->udev->dev;
 	int i, ret;
 	u8 reg;
 	u32 val;
@@ -2420,7 +2423,7 @@ static int rtl8xxxu_init_rf_regs(struct rtl8xxxu_priv *priv,
 
 		ret = rtl8xxxu_write_rfreg(priv, path, reg, val);
 		if (ret) {
-			dev_warn(&priv->udev->dev,
+			dev_warn(dev,
 				 "Failed to initialize RF\n");
 			return -EAGAIN;
 		}
@@ -2557,6 +2560,7 @@ int rtl8xxxu_init_llt_table(struct rtl8xxxu_priv *priv)
 
 int rtl8xxxu_auto_llt_table(struct rtl8xxxu_priv *priv)
 {
+	struct device *dev = &priv->udev->dev;
 	u32 val32;
 	int ret = 0;
 	int i;
@@ -2574,7 +2578,7 @@ int rtl8xxxu_auto_llt_table(struct rtl8xxxu_priv *priv)
 
 	if (!i) {
 		ret = -EBUSY;
-		dev_warn(&priv->udev->dev, "LLT table init failed\n");
+		dev_warn(dev, "LLT table init failed\n");
 	}
 
 	return ret;
@@ -3088,6 +3092,7 @@ void rtl8xxxu_mac_calibration(struct rtl8xxxu_priv *priv,
 
 static int rtl8xxxu_iqk_path_a(struct rtl8xxxu_priv *priv)
 {
+	struct device *dev = &priv->udev->dev;
 	u32 reg_eac, reg_e94, reg_e9c, reg_ea4, val32;
 	int result = 0;
 
@@ -3137,7 +3142,7 @@ static int rtl8xxxu_iqk_path_a(struct rtl8xxxu_priv *priv)
 	    ((reg_eac & 0x03ff0000) != 0x00360000))
 		result |= 0x02;
 	else
-		dev_warn(&priv->udev->dev, "%s: Path A RX IQK failed!\n",
+		dev_warn(dev, "%s: Path A RX IQK failed!\n",
 			 __func__);
 out:
 	return result;
@@ -3145,6 +3150,7 @@ static int rtl8xxxu_iqk_path_a(struct rtl8xxxu_priv *priv)
 
 static int rtl8xxxu_iqk_path_b(struct rtl8xxxu_priv *priv)
 {
+	struct device *dev = &priv->udev->dev;
 	u32 reg_eac, reg_eb4, reg_ebc, reg_ec4, reg_ecc;
 	int result = 0;
 
@@ -3173,7 +3179,7 @@ static int rtl8xxxu_iqk_path_b(struct rtl8xxxu_priv *priv)
 	    (((reg_ecc & 0x03ff0000) >> 16) != 0x36))
 		result |= 0x02;
 	else
-		dev_warn(&priv->udev->dev, "%s: Path B RX IQK failed!\n",
+		dev_warn(dev, "%s: Path B RX IQK failed!\n",
 			 __func__);
 out:
 	return result;
@@ -3637,6 +3643,7 @@ static void rtl8xxxu_set_ampdu_min_space(struct rtl8xxxu_priv *priv, u8 density)
 
 int rtl8xxxu_active_to_lps(struct rtl8xxxu_priv *priv)
 {
+	struct device *dev = &priv->udev->dev;
 	u8 val8;
 	u8 val32;
 	int count, ret = 0;
@@ -3654,7 +3661,7 @@ int rtl8xxxu_active_to_lps(struct rtl8xxxu_priv *priv)
 	}
 
 	if (!count) {
-		dev_warn(&priv->udev->dev,
+		dev_warn(dev,
 			 "%s: RX poll timed out (0x05f8)\n", __func__);
 		ret = -EBUSY;
 		goto exit;
@@ -5867,8 +5874,9 @@ static void rtl8xxxu_rx_urb_work(struct work_struct *work)
 	struct sk_buff *skb;
 	unsigned long flags;
 	int ret;
-
+	
 	priv = container_of(work, struct rtl8xxxu_priv, rx_urb_wq);
+	struct device *dev = &priv->udev->dev;
 	INIT_LIST_HEAD(&local);
 
 	spin_lock_irqsave(&priv->rx_urb_lock, flags);
@@ -5894,7 +5902,7 @@ static void rtl8xxxu_rx_urb_work(struct work_struct *work)
 			rtl8xxxu_queue_rx_urb(priv, rx_urb);
 			break;
 		default:
-			dev_warn(&priv->udev->dev,
+			dev_warn(dev,
 				 "failed to requeue urb with error %i\n", ret);
 			skb = (struct sk_buff *)rx_urb->urb.context;
 			dev_kfree_skb(skb);
-- 
2.43.0

