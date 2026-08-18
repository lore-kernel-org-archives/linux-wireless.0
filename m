Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3A2304BB3
	for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2026 05:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787030687; cv=none; b=hyCVI8bUuzwiVXc0cg6yGQ72VkoF7FogNBVpudsNSqfbd8UXpoNf8lEMJGLBsDt9Kr1ldwcE5X40PTAMlJvBMmrxQeYkDzJv7+SVJ0LfCieWpiNeZFg4bhOig4f2v8TXtk7wOgvb6uQDDmm0zQrK8oq3+XY3AlnHi4Ir8b9Voa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787030687; c=relaxed/simple;
	bh=7E+VhZT58ik8GO/S6XGi0iBtCd8oSPWRv8sVTL9uySI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tf1eiyD73qk3L95wx3UKbnHEliUvR+fbabHeZFeRW5Pev6wn50rUE+t+8fXdoT+i91L+HldnkfeRqh9V695VUh2zUSDk7hdq/juEFVg/9D1174Mneya8M3vY59wfAHJB1Bfmg/VGFzIHxTG1CXQ7uewOocCXKbzqfmI7MIegSxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qNU8Q70z; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qNU8Q70z"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-38125cebfdaso6132247a91.1
        for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 22:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787030684; x=1787635484; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=q/clhjOaXJC9axuLbAHZyscxZu7rxZwS548Wq1wQd4E=;
        b=qNU8Q70zhhbqMIo/R9gVRUr5Czjl4y5TsxDxtG6WW6W6qA1FJjF3r+SBDVdDXjvuHF
         393HIxi8lAh75shAFagegX3MoMIFRUJ8bjXNLzt/KgRTmHVKF9cqX6aOdSqXfWTjcofD
         C9kWK3Iub4SF03WXb7zmMjV1ezHzoWlWzwm+0+HqHrjn23zJY+mfzfqN+hkaXXcfbRf9
         i/IUWNOYJE0yJzetxx8DOP2NJGHiBjGZnFBTN+9ILYjcdwDQCR0c7vF3RiZcH4TOLtjk
         fbdkXc45olpSHDT01TCJOdkVdu/V1AjAQZREuGLOVlMcaGzPL0AJqAFACfyUjOk2SwJY
         vjJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787030684; x=1787635484;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=q/clhjOaXJC9axuLbAHZyscxZu7rxZwS548Wq1wQd4E=;
        b=qQTC1xIWpOXPMTpluaYQOTAUwkdq/cSUvCdgacQsSMfAAYcbLi8i1fvuhMKPunp8xn
         dH9sKX8DGdoeoNuO3gU+IQM7uVXmyWT+Qpy87WhAI4kRyub7GDX9xxQTKRwmGE+jpI0Z
         g1SaTzW2TVo32ko5D8m+h3xzpgUb8vPh1q6ybkJFmE030yGvxx84L5LhteuHELGxAgbb
         4lyO2EvkPG4kPGFD7v2UXpuvJRPh3tTrwDWFJL1NTzZJuwlC28XfE1/u7+BNXIiwHDBV
         kN9nE1A1ZXAZMHNQAcYsYsKz8HbYdK3Y7al6n2iNnMMkp+f0HBF29YZuCFp+Tcrh4BmA
         OTWg==
X-Forwarded-Encrypted: i=1; AHgh+RrEEvrUuuscXKlLSemngUmWMYX28R/ztYV/4r/2FVUU46l6mRoyxogGHWgrx3PUC018aHbbADfHDPwV5HcUiA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxMiosivhNQL9GCJSx56rj/uf05peu3uplcPuGXjvqiyJdAI/E7
	wyvCAuVK10tVaDZau5uH5z4WIIYqxGxjicPXlkvQ5iIUic6a0kNplaZJ
X-Gm-Gg: AR+sD134lzcTHFNzobOpos30qwndYtCuVkZkpB0RmU+T8EPgc4QUoovMMARvFs8j9yG
	MfqXFwPZ9Y9Jx8g01YW4qNnFaeWGhaa85syw1/T23rBIV9f7v9np6tPpb8jOeSA0N8mBobdhCjJ
	+aMT5Yy0VhDOMEn0hZjKUN0L9VmbTFdeLIcWNxlcoJ8RvQLpq3/Ugj0Sq15Cs7CDkNvJdVhWQWh
	o8iaDVRuWmhIMk7dZ7PN6mchvTe+UuHZb/uAxKD7v+zEiPk0cmB5BDEhZBjGDmfn3991vskq/ff
	C+RnTeypEu9kuADi7vVMmm6rYi7lsLHvDrISybLFaA+AsxJEfIoXX9WHxNuui+efTF/ESa6WlYy
	gnbI2BLYqb0l5tBorSvHST96BX0B/GZ2n2FZ/tqcV/kckSvnAE0evJ6Qm7OSfuf/Rk0OCLzFZha
	53RXGZSxZzZWlWwvWJsD+Xq9SY0g+1AOIZ6GrYDJwpiVuVSD/ZQQDV/76+1azD
X-Received: by 2002:a17:90b:3f50:b0:38e:6f90:eabd with SMTP id 98e67ed59e1d1-3933b7213c9mr32245744a91.5.1787030684155;
        Mon, 17 Aug 2026 22:24:44 -0700 (PDT)
Received: from tradnomic.. ([2601:646:8300:7570:ba5c:938b:1f55:72ff])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39531e31b8fsm7271447a91.3.2026.08.17.22.24.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 22:24:43 -0700 (PDT)
From: rafad900 <rafad900@gmail.com>
To: Jes.Sorensen@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Cc: Rafael Alejandro Diaz Cruz <rafad900@gmail.com>
Subject: [PATCH rtw-next v4] wifi: rtl8xxxu: Use local 'dev' variable for dev_warn()
Date: Mon, 17 Aug 2026 22:24:41 -0700
Message-ID: <20260818052441.1651077-1-rafad900@gmail.com>
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
 drivers/net/wireless/realtek/rtl8xxxu/8192f.c | 11 +++----
 drivers/net/wireless/realtek/rtl8xxxu/8723a.c |  4 +--
 drivers/net/wireless/realtek/rtl8xxxu/8723b.c |  4 +--
 drivers/net/wireless/realtek/rtl8xxxu/core.c  | 29 ++++++++++---------
 7 files changed, 38 insertions(+), 33 deletions(-)

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
index bddbd0990de7..042e2aeeb9b8 100644
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
@@ -2241,7 +2242,7 @@ int rtl8xxxu_init_phy_regs(struct rtl8xxxu_priv *priv,
 
 		ret = rtl8xxxu_write32(priv, reg, val);
 		if (ret != sizeof(val)) {
-			dev_warn(&priv->udev->dev,
+			dev_warn(dev,
 				 "Failed to initialize PHY\n");
 			return -EAGAIN;
 		}
@@ -2386,6 +2387,7 @@ static int rtl8xxxu_init_rf_regs(struct rtl8xxxu_priv *priv,
 				 const struct rtl8xxxu_rfregval *array,
 				 enum rtl8xxxu_rfpath path)
 {
+	struct device *dev = &priv->udev->dev;
 	int i, ret;
 	u8 reg;
 	u32 val;
@@ -2420,8 +2422,7 @@ static int rtl8xxxu_init_rf_regs(struct rtl8xxxu_priv *priv,
 
 		ret = rtl8xxxu_write_rfreg(priv, path, reg, val);
 		if (ret) {
-			dev_warn(&priv->udev->dev,
-				 "Failed to initialize RF\n");
+			dev_warn(dev, "Failed to initialize RF\n");
 			return -EAGAIN;
 		}
 		udelay(1);
@@ -2557,6 +2558,7 @@ int rtl8xxxu_init_llt_table(struct rtl8xxxu_priv *priv)
 
 int rtl8xxxu_auto_llt_table(struct rtl8xxxu_priv *priv)
 {
+	struct device *dev = &priv->udev->dev;
 	u32 val32;
 	int ret = 0;
 	int i;
@@ -2574,7 +2576,7 @@ int rtl8xxxu_auto_llt_table(struct rtl8xxxu_priv *priv)
 
 	if (!i) {
 		ret = -EBUSY;
-		dev_warn(&priv->udev->dev, "LLT table init failed\n");
+		dev_warn(dev, "LLT table init failed\n");
 	}
 
 	return ret;
@@ -3088,6 +3090,7 @@ void rtl8xxxu_mac_calibration(struct rtl8xxxu_priv *priv,
 
 static int rtl8xxxu_iqk_path_a(struct rtl8xxxu_priv *priv)
 {
+	struct device *dev = &priv->udev->dev;
 	u32 reg_eac, reg_e94, reg_e9c, reg_ea4, val32;
 	int result = 0;
 
@@ -3137,14 +3140,14 @@ static int rtl8xxxu_iqk_path_a(struct rtl8xxxu_priv *priv)
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
 
@@ -3173,7 +3176,7 @@ static int rtl8xxxu_iqk_path_b(struct rtl8xxxu_priv *priv)
 	    (((reg_ecc & 0x03ff0000) >> 16) != 0x36))
 		result |= 0x02;
 	else
-		dev_warn(&priv->udev->dev, "%s: Path B RX IQK failed!\n",
+		dev_warn(dev, "%s: Path B RX IQK failed!\n",
 			 __func__);
 out:
 	return result;
@@ -3637,6 +3640,7 @@ static void rtl8xxxu_set_ampdu_min_space(struct rtl8xxxu_priv *priv, u8 density)
 
 int rtl8xxxu_active_to_lps(struct rtl8xxxu_priv *priv)
 {
+	struct device *dev = &priv->udev->dev;
 	u8 val8;
 	u8 val32;
 	int count, ret = 0;
@@ -3654,8 +3658,7 @@ int rtl8xxxu_active_to_lps(struct rtl8xxxu_priv *priv)
 	}
 
 	if (!count) {
-		dev_warn(&priv->udev->dev,
-			 "%s: RX poll timed out (0x05f8)\n", __func__);
+		dev_warn(dev, "%s: RX poll timed out (0x05f8)\n", __func__);
 		ret = -EBUSY;
 		goto exit;
 	}
@@ -5869,6 +5872,7 @@ static void rtl8xxxu_rx_urb_work(struct work_struct *work)
 	int ret;
 
 	priv = container_of(work, struct rtl8xxxu_priv, rx_urb_wq);
+	struct device *dev = &priv->udev->dev;
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

