Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062D833CE80
	for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 05:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786944179; cv=none; b=GekpaU0JwflwgkvJ/5iATmikFJ5KRW2pTGjAlt1FF9gvmmJSrT+f6gfWTUUf2pj3wLwIAiJQvk43OFaPgkyU8sTcZoQfRta8+TzU8zfCHR+7HEPye7GkLTeDrSSFUZYOJ/XjZqYyfEp/Pu+u6/2MPKyKJMWIH68iMFwGwnnoe6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786944179; c=relaxed/simple;
	bh=m//lafZiMHPsKTFgHHjeT1yZXCDwtPPngi0WpmiSllo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=D9zPOPCKtVfe22ShEdNy6ZGSQOwhaz98hJ4m57AteTpdXzgSd6dcf3OuNCY8wLMK2bxRQ6oaFdm1SjCaIKz5cwoOhBNx4vksDKKMDxhg6bcg4aidmSCFNgSVAoLANGZazhsmKdoTYVYTQAJLOCmDl+gTtI6GA1kx68AYS2PlI0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c7V7T9pO; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c7V7T9pO"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-38dc4553f62so3896835a91.0
        for <linux-wireless@vger.kernel.org>; Sun, 16 Aug 2026 22:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786944173; x=1787548973; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NaPYg+7fKtM98eYOYkeAogVotFfFB9OY0Wep3f5FUhI=;
        b=c7V7T9pOHBlrGGHURe9f9SyRnU8Dy25CUYWbvCUk4qopj1DUx7GIYEq9qjaPpf1cnS
         X4eAii2q8M7v0nRQzxLir8QWjmtdr0SIN/8+g1ZHuI4i6OiOv3ZkWKnONMq6A7xcjllY
         nUxzek8DgzK0hUD0WexxHyAJCQWCNU4KGNVFkIKs8OAUdqe666P+aWv5KvDq6/U5Gsz/
         mH+SU/n5eQNbqZmLEr3Mz6oC/tnVrCm+yMO2ZZYjAAKiTwTKjak7Lq8qUnowrhxPNkjV
         1DdJHJf+urTigjhW/GbuwYsQQjMrLYiveg4AfYi8LzRWvJIzg3ldtx39UgkG8t3Me+Og
         3vKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786944173; x=1787548973;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NaPYg+7fKtM98eYOYkeAogVotFfFB9OY0Wep3f5FUhI=;
        b=WL3XFZyY6leI/GsIQ1UZ76EvipqZrGQzpJ2yQ5ttugxPWqXIJpEU8THEZPgR86sse9
         JVw7zKmvEsoeTsBp5oi5GCuaTzwFYePTlquyNBNqaXvADyirpea6ffIGXG2JccMr2SbB
         R2BuPAST4YE6SW1HGzEDl63SbaqtKbx7XZOKwPneasLWs0GkS5+kUIXFcJTIPqVSLcU5
         MsrMuyCYLgpsEs1XH1Fj70bv3L/jfcFLVMnmw94hmHFir6HmGO5l3ggbLRByubxL6b4V
         sFr25Cn/war4zNvRzGFy8xzqfigO6HcL7g7fHTlogi7mx52ZYYfqQ/Cz9FqmLyGzY0ec
         vojw==
X-Forwarded-Encrypted: i=1; AHgh+RqOZTNbXRijf40Kxbkk4KFqXnB7PhPazcbWpJDIwRq6i9IvucUZBimgFNGXq0B+8hgD5GnhvzHnQ6+nxQ2chQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwI9VaG0DH15M7D4xurjS+K2yLN0hT8cs6/fP2HfamRv3Be4OjD
	Py9YRbFdsXkpBZoOdYZDUCZtmniIihk0fAeh8+eTHZV02rf0a4dzN6dY
X-Gm-Gg: AR+sD13+FAgkZ2eeskE6H19q545tafRntR0jYSP9j0vJC8QJziz/RaQvbc2DqwjCW3o
	bCQ+MQN0Bn1+jT5USlvdykr1B+8H4b1lbJ9oyrcH3EZnZ7fKg5vrLWqSVcvYwT/An5l0bBfnxUy
	mQmUZPIK3yBvGxjUUgClWxOlNB8iBNXiE4DLqYM5MQvbrokf3RLNWa79lFBY6Cua8Gl2DlJmtUn
	T+Au5cjds2BdWMESS91bT+FgS6vylnXttICcICZNi0MuHdsVn+mchIFc81cNctxYYsLKkyGcNxT
	WRJbGGaCums45JntmB+FMNw0cpxZ3hVO2DLqQvhkoxDryc9Oe2jNOmQgSckojAzeddZBaHKFi6k
	pUYc/qkPHPlbL3/J7ePykbq3qPjmGxBkTyemhWixb64CgLN3bbeB0pEFrzL3LVSF1jw+9qAKIih
	ovhaqfq4+TAOrl25/jQ7hEDDs1NMAwQrMI/hdheFvBu9HoROO+G56gwQ1yRf8=
X-Received: by 2002:a17:90b:384b:b0:37f:e1af:df22 with SMTP id 98e67ed59e1d1-3933ba90e38mr22117955a91.17.1786944173112;
        Sun, 16 Aug 2026 22:22:53 -0700 (PDT)
Received: from tradnomic.. ([2601:646:8300:7570:1a50:adc4:d908:3ae])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14153043d24sm2161586c88.3.2026.08.16.22.22.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2026 22:22:52 -0700 (PDT)
From: rafad900 <rafad900@gmail.com>
To: Jes.Sorensen@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Cc: rafad900 <rafad900@gmail.com>
Subject: [PATCH v2] wifi: rtl8xxxu: Use local 'dev' variable for dev_warn()
Date: Sun, 16 Aug 2026 22:22:50 -0700
Message-ID: <20260817052250.358796-1-rafad900@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To ensure consistent patterns, the device struct was
defined and used when dev_warn() is called.
This follows the logging pattern used in most of
rtl8xxxu files.

Signed-off-by: Rafael Alejandro Diaz Cruz <rafad900@gmail.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/8188e.c |  3 ++-
 drivers/net/wireless/realtek/rtl8xxxu/8188f.c |  3 ++-
 drivers/net/wireless/realtek/rtl8xxxu/8192e.c | 12 ++++++----
 drivers/net/wireless/realtek/rtl8xxxu/8192f.c |  9 ++++---
 drivers/net/wireless/realtek/rtl8xxxu/8723a.c |  3 ++-
 drivers/net/wireless/realtek/rtl8xxxu/8723b.c |  3 ++-
 drivers/net/wireless/realtek/rtl8xxxu/core.c  | 24 ++++++++++++-------
 7 files changed, 38 insertions(+), 19 deletions(-)

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
index e314ef991b38..5c077b1372ee 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/8723b.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/8723b.c
@@ -1225,6 +1225,7 @@ static void rtl8723bu_phy_iq_calibrate(struct rtl8xxxu_priv *priv)
 
 static int rtl8723bu_active_to_emu(struct rtl8xxxu_priv *priv)
 {
+	struct device *dev = &priv->udev->dev;
 	u8 val8;
 	u16 val16;
 	u32 val32;
@@ -1256,7 +1257,7 @@ static int rtl8723bu_active_to_emu(struct rtl8xxxu_priv *priv)
 	}
 
 	if (!count) {
-		dev_warn(&priv->udev->dev, "%s: Disabling MAC timed out\n",
+		dev_warn(dev, "%s: Disabling MAC timed out\n",
 			 __func__);
 		ret = -EBUSY;
 		goto exit;
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/core.c b/drivers/net/wireless/realtek/rtl8xxxu/core.c
index 646fe76b086e..8e78134a8131 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/core.c
@@ -2187,6 +2187,7 @@ void rtl8xxxu_firmware_self_reset(struct rtl8xxxu_priv *priv)
 static int
 rtl8xxxu_init_mac(struct rtl8xxxu_priv *priv)
 {
+	struct device *dev = &priv->udev->dev;
 	const struct rtl8xxxu_reg8val *array = priv->fops->mactable;
 	int i, ret;
 	u16 reg;
@@ -2201,7 +2202,7 @@ rtl8xxxu_init_mac(struct rtl8xxxu_priv *priv)
 
 		ret = rtl8xxxu_write8(priv, reg, val);
 		if (ret != 1) {
-			dev_warn(&priv->udev->dev,
+			dev_warn(dev,
 				 "Failed to initialize MAC "
 				 "(reg: %04x, val %02x)\n", reg, val);
 			return -EAGAIN;
@@ -2229,6 +2230,7 @@ rtl8xxxu_init_mac(struct rtl8xxxu_priv *priv)
 int rtl8xxxu_init_phy_regs(struct rtl8xxxu_priv *priv,
 			   const struct rtl8xxxu_reg32val *array)
 {
+	struct device *dev = &priv->udev->dev;
 	int i, ret;
 	u16 reg;
 	u32 val;
@@ -2242,7 +2244,7 @@ int rtl8xxxu_init_phy_regs(struct rtl8xxxu_priv *priv,
 
 		ret = rtl8xxxu_write32(priv, reg, val);
 		if (ret != sizeof(val)) {
-			dev_warn(&priv->udev->dev,
+			dev_warn(dev,
 				 "Failed to initialize PHY\n");
 			return -EAGAIN;
 		}
@@ -2387,6 +2389,7 @@ static int rtl8xxxu_init_rf_regs(struct rtl8xxxu_priv *priv,
 				 const struct rtl8xxxu_rfregval *array,
 				 enum rtl8xxxu_rfpath path)
 {
+	struct device *dev = &priv->udev->dev;
 	int i, ret;
 	u8 reg;
 	u32 val;
@@ -2421,7 +2424,7 @@ static int rtl8xxxu_init_rf_regs(struct rtl8xxxu_priv *priv,
 
 		ret = rtl8xxxu_write_rfreg(priv, path, reg, val);
 		if (ret) {
-			dev_warn(&priv->udev->dev,
+			dev_warn(dev,
 				 "Failed to initialize RF\n");
 			return -EAGAIN;
 		}
@@ -2558,6 +2561,7 @@ int rtl8xxxu_init_llt_table(struct rtl8xxxu_priv *priv)
 
 int rtl8xxxu_auto_llt_table(struct rtl8xxxu_priv *priv)
 {
+	struct device *dev = &priv->udev->dev;
 	u32 val32;
 	int ret = 0;
 	int i;
@@ -2575,7 +2579,7 @@ int rtl8xxxu_auto_llt_table(struct rtl8xxxu_priv *priv)
 
 	if (!i) {
 		ret = -EBUSY;
-		dev_warn(&priv->udev->dev, "LLT table init failed\n");
+		dev_warn(dev, "LLT table init failed\n");
 	}
 
 	return ret;
@@ -3089,6 +3093,7 @@ void rtl8xxxu_mac_calibration(struct rtl8xxxu_priv *priv,
 
 static int rtl8xxxu_iqk_path_a(struct rtl8xxxu_priv *priv)
 {
+	struct device *dev = &priv->udev->dev;
 	u32 reg_eac, reg_e94, reg_e9c, reg_ea4, val32;
 	int result = 0;
 
@@ -3138,7 +3143,7 @@ static int rtl8xxxu_iqk_path_a(struct rtl8xxxu_priv *priv)
 	    ((reg_eac & 0x03ff0000) != 0x00360000))
 		result |= 0x02;
 	else
-		dev_warn(&priv->udev->dev, "%s: Path A RX IQK failed!\n",
+		dev_warn(dev, "%s: Path A RX IQK failed!\n",
 			 __func__);
 out:
 	return result;
@@ -3146,6 +3151,7 @@ static int rtl8xxxu_iqk_path_a(struct rtl8xxxu_priv *priv)
 
 static int rtl8xxxu_iqk_path_b(struct rtl8xxxu_priv *priv)
 {
+	struct device *dev = &priv->udev->dev;
 	u32 reg_eac, reg_eb4, reg_ebc, reg_ec4, reg_ecc;
 	int result = 0;
 
@@ -3174,7 +3180,7 @@ static int rtl8xxxu_iqk_path_b(struct rtl8xxxu_priv *priv)
 	    (((reg_ecc & 0x03ff0000) >> 16) != 0x36))
 		result |= 0x02;
 	else
-		dev_warn(&priv->udev->dev, "%s: Path B RX IQK failed!\n",
+		dev_warn(dev, "%s: Path B RX IQK failed!\n",
 			 __func__);
 out:
 	return result;
@@ -3638,6 +3644,7 @@ static void rtl8xxxu_set_ampdu_min_space(struct rtl8xxxu_priv *priv, u8 density)
 
 int rtl8xxxu_active_to_lps(struct rtl8xxxu_priv *priv)
 {
+	struct device *dev = &priv->udev->dev;
 	u8 val8;
 	u8 val32;
 	int count, ret = 0;
@@ -3655,7 +3662,7 @@ int rtl8xxxu_active_to_lps(struct rtl8xxxu_priv *priv)
 	}
 
 	if (!count) {
-		dev_warn(&priv->udev->dev,
+		dev_warn(dev,
 			 "%s: RX poll timed out (0x05f8)\n", __func__);
 		ret = -EBUSY;
 		goto exit;
@@ -5860,6 +5867,7 @@ static void rtl8xxxu_queue_rx_urb(struct rtl8xxxu_priv *priv,
 
 static void rtl8xxxu_rx_urb_work(struct work_struct *work)
 {
+	struct device *dev = &priv->udev->dev;
 	struct rtl8xxxu_priv *priv;
 	struct rtl8xxxu_rx_urb *rx_urb, *tmp;
 	struct list_head local;
@@ -5893,7 +5901,7 @@ static void rtl8xxxu_rx_urb_work(struct work_struct *work)
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

