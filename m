Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71DAB3D810D
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 22:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784325657; cv=none; b=aKKAbs2UROUoMWovCQICS9Dw3yLduwRoFOXGpR6tQYukZQJMch2TLMGI6XZJHwj+9407zcl8qTlo8ZZCJa/5CrUHxzSr/nG08Taw4Q6Rq1Gv7Jmril8dqf0DCxgLCXe43PPNxMvwfIA60NTtnjVNqvk7tCUTaYA194GYb5mM0s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784325657; c=relaxed/simple;
	bh=sNQwSaEOaywTIpYz/mw3H7vqlsptgE10oo6pANMcnY0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pmPWEhWk0CsIuU4qJFM7qizbtsmnqAofzrkNc/JIjT68k/QlJ9g7TFN7mWYwU4xhvx6f5Cgky4/KQtpT/zPKfVIV0IA8ydQ43qdsp0U3iN/cAW9GJmVzTvoxCBlOXbtDkaLOnXzytsk0tqBsTAIzjBKOdFOySoO1TBjZwfPiPq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GcYp0DzZ; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GcYp0DzZ"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2cf452def93so1923715ad.1
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 15:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784325656; x=1784930456; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LqIjjTV7XqjiceW1/Jt27lRZK5MF8VGskqeVB4/iG2s=;
        b=GcYp0DzZmGcmM2qEYSklMqCDAirC/jd9Zo0TtNwnO3BBrMw6lWOXJJ9qQhr48OtMYJ
         N+1dA7TlRT/0gJk3YulxHvY+xT1GyxvWSi5hcZAU8Y60dyViqqpoUlV5CmvMIA015XOH
         FgX5vfZVMpK5PW/kkuIsDh3OJ8X29KKfRCxDe1lga2klJFimpLUjH+1P99Dd2AWrgpLB
         zPQbZ2suyFcsqOEsW1QdSJy0hmEaR/c+xopkYORwbIAmBybH0SbNzSJprJQlyHrM5Zfe
         SbJs3AgFmtjA3Z5PSm7TQaNkVBzFtKW3+wYC5LM2/ZmHqOyIyHArmtxzbndcjCKflemk
         hfWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784325656; x=1784930456;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LqIjjTV7XqjiceW1/Jt27lRZK5MF8VGskqeVB4/iG2s=;
        b=tZb8SXlCbkYg7rwbCUaASyxjRiOKN2vMy7Gr1L45aMz09FgPqVN8hUp6SKByHMP29Z
         lPbKZpzytL3Z/mBjQnIQQAIFmw+b39/ObnXVOOlEm+LzNB5jhcnrokhIEhgOMjVMDEi9
         5Zmnbkq8HJDziqAKgHQMZO5GOkz8FSFx1NjtYsu9KjddJ5/LC0pVzlaW7KAuVKFDiGfM
         aKR1/jr7/iqj2F57zWNFyqySCQbFYD3OyypNeatVjlEBF+H09NfTN2/dx8UaCzLDOIR8
         pRJr3zbQRUi/emA54VjEJGm0fDtTaA8r8Xqb9iCzbkfG2jl+zT7pAM1iceIn4tTPR1zc
         ntJQ==
X-Gm-Message-State: AOJu0Yy+fEI5OqGfMj211BpPa8986f0KJbsbfzFnEn3ylHYMR1YyUqFn
	UUCBAcmtbZfef6tuX9vHFfJ1wySfX3pvYXemAfY28cz1T1IKycM6x0DEe2Sm2g==
X-Gm-Gg: AfdE7clvPj2K8IlqUxd2Gx/u0X4P3GOUcklKa4IlsUVNfxPCda02Wac6dK7krQyRZXc
	PahH9uzk8Ja1E+eOGubmk55OVpPg9xCGTxwUXe1YxXINfuWTWYMxwYGD49SfHvV4AtFD5GkyTa/
	MwzQZo2gdMSeYhYzvZN5YKqphE0J9w4qHjlWKzzXWqgV43FeOH6gPLR92RqOq+FJgW+yuCt5v3X
	mwU6Rd4ASPRiRACG7WBSlo8G9l/0RK+VXZkI+BopucrNoGVw2UqwzJbH2UtaKa/Q6w2+eIoJXEp
	LHdX1TqfC7FVYSoqu6IZyRqNiy6cXpzczI1AH+CJzXnVXk+I5Zc7vIjUmyWYbUfjExEW6WqU0Fp
	Dn9FGKHtuOJVrOTJ9RYJVYDBN/qW4EzQJlNyY60UpV6twqnGraV3j0oTU4Ehbe9/YHiiQ9emwum
	izrbxzBczuiqlaK9n8hcXzIDJU5NkfMwxRhzTk2tWkwrAy2Bmvxtu5C8cvptX7mvbzY+p+bX49a
	JCNCYuBGl2LaSAXLnP2KAFWx9DGseZy7e4qQp1jq+9ZQF7m+BqKDaY=
X-Received: by 2002:a17:902:d489:b0:2ca:eff:ff58 with SMTP id d9443c01a7336-2cf34975cdamr49927875ad.15.1784325655445;
        Fri, 17 Jul 2026 15:00:55 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e35])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf34713fe1sm17543755ad.55.2026.07.17.15.00.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 15:00:54 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <stf_xl@wp.pl>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH wireless-next] wifi: rt2x00: Use device-managed register buffers
Date: Fri, 17 Jul 2026 15:00:52 -0700
Message-ID: <20260717220052.824624-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The rt2x00 PCI and USB probe paths allocate EEPROM and RF storage with
plain kzalloc() and then free it from bus-specific teardown helpers.  The
USB path also manages the CSR cache the same way.  These buffers are
tied to the device lifetime, so the explicit free paths add probe and
disconnect cleanup without providing separate ownership.

Allocate the buffers with devm_kzalloc() before the mac80211 hardware is
allocated, then attach the resulting storage to struct rt2x00_dev after
the driver-private state exists.  This lets driver detach and probe
failure rely on device-managed cleanup and removes the duplicated
bus-specific buffer freeing.

Assisted-by: Codex:GPT-5.5
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 .../net/wireless/ralink/rt2x00/rt2x00pci.c    | 104 ++++--------------
 .../net/wireless/ralink/rt2x00/rt2x00usb.c    |  67 ++++-------
 2 files changed, 43 insertions(+), 128 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00pci.c b/drivers/net/wireless/ralink/rt2x00/rt2x00pci.c
index cabeef0dde45..d4635b531481 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00pci.c
@@ -19,84 +19,50 @@
 #include "rt2x00.h"
 #include "rt2x00pci.h"
 
-/*
- * PCI driver handlers.
- */
-static void rt2x00pci_free_reg(struct rt2x00_dev *rt2x00dev)
-{
-	kfree(rt2x00dev->rf);
-	rt2x00dev->rf = NULL;
-
-	kfree(rt2x00dev->eeprom);
-	rt2x00dev->eeprom = NULL;
-
-	if (rt2x00dev->csr.base) {
-		iounmap(rt2x00dev->csr.base);
-		rt2x00dev->csr.base = NULL;
-	}
-}
-
-static int rt2x00pci_alloc_reg(struct rt2x00_dev *rt2x00dev)
-{
-	struct pci_dev *pci_dev = to_pci_dev(rt2x00dev->dev);
-
-	rt2x00dev->csr.base = pci_ioremap_bar(pci_dev, 0);
-	if (!rt2x00dev->csr.base)
-		goto exit;
-
-	rt2x00dev->eeprom = kzalloc(rt2x00dev->ops->eeprom_size, GFP_KERNEL);
-	if (!rt2x00dev->eeprom)
-		goto exit;
-
-	rt2x00dev->rf = kzalloc(rt2x00dev->ops->rf_size, GFP_KERNEL);
-	if (!rt2x00dev->rf)
-		goto exit;
-
-	return 0;
-
-exit:
-	rt2x00_probe_err("Failed to allocate registers\n");
-
-	rt2x00pci_free_reg(rt2x00dev);
-
-	return -ENOMEM;
-}
-
 int rt2x00pci_probe(struct pci_dev *pci_dev, const struct rt2x00_ops *ops)
 {
-	struct ieee80211_hw *hw;
 	struct rt2x00_dev *rt2x00dev;
+	struct ieee80211_hw *hw;
+	void __iomem *base;
+	__le16 *eeprom;
 	int retval;
 	u16 chip;
+	u32 *rf;
 
-	retval = pci_enable_device(pci_dev);
+	retval = pcim_enable_device(pci_dev);
 	if (retval) {
 		rt2x00_probe_err("Enable device failed\n");
 		return retval;
 	}
 
-	retval = pci_request_regions(pci_dev, pci_name(pci_dev));
-	if (retval) {
-		rt2x00_probe_err("PCI request regions failed\n");
-		goto exit_disable_device;
+	base = pcim_iomap_region(pci_dev, 0, pci_name(pci_dev));
+	if (IS_ERR(base)) {
+		rt2x00_probe_err("PCI iomap region failed\n");
+		return PTR_ERR(base);
 	}
 
 	pci_set_master(pci_dev);
 
-	if (pci_set_mwi(pci_dev))
+	if (pcim_set_mwi(pci_dev))
 		rt2x00_probe_err("MWI not available\n");
 
 	if (dma_set_mask(&pci_dev->dev, DMA_BIT_MASK(32))) {
 		rt2x00_probe_err("PCI DMA not supported\n");
-		retval = -EIO;
-		goto exit_release_regions;
+		return -EIO;
 	}
 
+	eeprom = devm_kzalloc(&pci_dev->dev, ops->eeprom_size, GFP_KERNEL);
+	if (!eeprom)
+		return -ENOMEM;
+
+	rf = devm_kzalloc(&pci_dev->dev, ops->rf_size, GFP_KERNEL);
+	if (!rf)
+		return -ENOMEM;
+
 	hw = ieee80211_alloc_hw(sizeof(struct rt2x00_dev), ops->hw);
 	if (!hw) {
 		rt2x00_probe_err("Failed to allocate hardware\n");
-		retval = -ENOMEM;
-		goto exit_release_regions;
+		return -ENOMEM;
 	}
 
 	pci_set_drvdata(pci_dev, hw);
@@ -105,18 +71,17 @@ int rt2x00pci_probe(struct pci_dev *pci_dev, const struct rt2x00_ops *ops)
 	rt2x00dev->dev = &pci_dev->dev;
 	rt2x00dev->ops = ops;
 	rt2x00dev->hw = hw;
+	rt2x00dev->csr.base = base;
 	rt2x00dev->irq = pci_dev->irq;
 	rt2x00dev->name = ops->name;
+	rt2x00dev->eeprom = eeprom;
+	rt2x00dev->rf = rf;
 
 	if (pci_is_pcie(pci_dev))
 		rt2x00_set_chip_intf(rt2x00dev, RT2X00_CHIP_INTF_PCIE);
 	else
 		rt2x00_set_chip_intf(rt2x00dev, RT2X00_CHIP_INTF_PCI);
 
-	retval = rt2x00pci_alloc_reg(rt2x00dev);
-	if (retval)
-		goto exit_free_device;
-
 	/*
 	 * Because rt3290 chip use different efuse offset to read efuse data.
 	 * So before read efuse it need to indicate it is the
@@ -127,23 +92,13 @@ int rt2x00pci_probe(struct pci_dev *pci_dev, const struct rt2x00_ops *ops)
 
 	retval = rt2x00lib_probe_dev(rt2x00dev);
 	if (retval)
-		goto exit_free_reg;
+		goto exit_free_device;
 
 	return 0;
 
-exit_free_reg:
-	rt2x00pci_free_reg(rt2x00dev);
-
 exit_free_device:
 	ieee80211_free_hw(hw);
 
-exit_release_regions:
-	pci_clear_mwi(pci_dev);
-	pci_release_regions(pci_dev);
-
-exit_disable_device:
-	pci_disable_device(pci_dev);
-
 	return retval;
 }
 EXPORT_SYMBOL_GPL(rt2x00pci_probe);
@@ -153,19 +108,8 @@ void rt2x00pci_remove(struct pci_dev *pci_dev)
 	struct ieee80211_hw *hw = pci_get_drvdata(pci_dev);
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 
-	/*
-	 * Free all allocated data.
-	 */
 	rt2x00lib_remove_dev(rt2x00dev);
-	rt2x00pci_free_reg(rt2x00dev);
 	ieee80211_free_hw(hw);
-
-	/*
-	 * Free the PCI device data.
-	 */
-	pci_clear_mwi(pci_dev);
-	pci_disable_device(pci_dev);
-	pci_release_regions(pci_dev);
 }
 EXPORT_SYMBOL_GPL(rt2x00pci_remove);
 
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
index 47e427ea8622..938320478728 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
@@ -755,55 +755,31 @@ void rt2x00usb_uninitialize(struct rt2x00_dev *rt2x00dev)
 }
 EXPORT_SYMBOL_GPL(rt2x00usb_uninitialize);
 
-/*
- * USB driver handlers.
- */
-static void rt2x00usb_free_reg(struct rt2x00_dev *rt2x00dev)
-{
-	kfree(rt2x00dev->rf);
-	rt2x00dev->rf = NULL;
-
-	kfree(rt2x00dev->eeprom);
-	rt2x00dev->eeprom = NULL;
-
-	kfree(rt2x00dev->csr.cache);
-	rt2x00dev->csr.cache = NULL;
-}
-
-static int rt2x00usb_alloc_reg(struct rt2x00_dev *rt2x00dev)
-{
-	rt2x00dev->csr.cache = kzalloc(CSR_CACHE_SIZE, GFP_KERNEL);
-	if (!rt2x00dev->csr.cache)
-		goto exit;
-
-	rt2x00dev->eeprom = kzalloc(rt2x00dev->ops->eeprom_size, GFP_KERNEL);
-	if (!rt2x00dev->eeprom)
-		goto exit;
-
-	rt2x00dev->rf = kzalloc(rt2x00dev->ops->rf_size, GFP_KERNEL);
-	if (!rt2x00dev->rf)
-		goto exit;
-
-	return 0;
-
-exit:
-	rt2x00_probe_err("Failed to allocate registers\n");
-
-	rt2x00usb_free_reg(rt2x00dev);
-
-	return -ENOMEM;
-}
-
 int rt2x00usb_probe(struct usb_interface *usb_intf,
 		    const struct rt2x00_ops *ops)
 {
 	struct usb_device *usb_dev = interface_to_usbdev(usb_intf);
-	struct ieee80211_hw *hw;
 	struct rt2x00_dev *rt2x00dev;
+	struct ieee80211_hw *hw;
+	__le16 *eeprom;
+	void *cache;
 	int retval;
+	u32* rf;
 
 	usb_reset_device(usb_dev);
 
+	cache = devm_kzalloc(&usb_intf->dev, CSR_CACHE_SIZE, GFP_KERNEL);
+	if (!cache)
+		return -ENOMEM;
+
+	eeprom = devm_kzalloc(&usb_intf->dev, ops->eeprom_size, GFP_KERNEL);
+	if (!eeprom)
+		return -ENOMEM;
+
+	rf = devm_kzalloc(&usb_intf->dev, ops->rf_size, GFP_KERNEL);
+	if (!rf)
+		return -ENOMEM;
+
 	hw = ieee80211_alloc_hw(struct_size(rt2x00dev, anchor, 1), ops->hw);
 	if (!hw) {
 		rt2x00_probe_err("Failed to allocate hardware\n");
@@ -816,16 +792,15 @@ int rt2x00usb_probe(struct usb_interface *usb_intf,
 	rt2x00dev->dev = &usb_intf->dev;
 	rt2x00dev->ops = ops;
 	rt2x00dev->hw = hw;
+	rt2x00dev->csr.cache = cache;
+	rt2x00dev->eeprom = eeprom;
+	rt2x00dev->rf = rf;
 
 	rt2x00_set_chip_intf(rt2x00dev, RT2X00_CHIP_INTF_USB);
 
 	INIT_WORK(&rt2x00dev->rxdone_work, rt2x00usb_work_rxdone);
 	INIT_WORK(&rt2x00dev->txdone_work, rt2x00usb_work_txdone);
 
-	retval = rt2x00usb_alloc_reg(rt2x00dev);
-	if (retval)
-		goto exit_free_device;
-
 	init_usb_anchor(rt2x00dev->anchor);
 
 	retval = rt2x00lib_probe_dev(rt2x00dev);
@@ -836,9 +811,6 @@ int rt2x00usb_probe(struct usb_interface *usb_intf,
 
 exit_free_anchor:
 	usb_kill_anchored_urbs(rt2x00dev->anchor);
-	rt2x00usb_free_reg(rt2x00dev);
-
-exit_free_device:
 	ieee80211_free_hw(hw);
 	usb_set_intfdata(usb_intf, NULL);
 
@@ -855,7 +827,6 @@ void rt2x00usb_disconnect(struct usb_interface *usb_intf)
 	 * Free all allocated data.
 	 */
 	rt2x00lib_remove_dev(rt2x00dev);
-	rt2x00usb_free_reg(rt2x00dev);
 	ieee80211_free_hw(hw);
 
 	usb_set_intfdata(usb_intf, NULL);
-- 
2.55.0

