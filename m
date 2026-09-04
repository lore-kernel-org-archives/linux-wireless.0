Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFC2934D382
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 21:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788556593; cv=none; b=Couki/fSNTvoj1u4JCKrlYNKdnX2/KSpsTqpcDT89HN8LcF0oJ9hjq7WER8x781S3fwJgoG2nm+MbF3YBS5uACTBR9N6lDDbdjY3iTQfsb33jDrc1z3Oy7X1l2CY5IUVgBqExZja9Cc5Bzie8bAbccdheBsYWJaBw2qqp4nyU+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788556593; c=relaxed/simple;
	bh=M3UHcumsk83fwH7MILtPbD9JJnZrcUN8A4RBgSArHJM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KaTSKj6a8AbYcfiOGMp0dzn45OB6P3XOp1ynsY2Vf2nwnHZrcZbPL9B2DkP8Ylx5ESWnLJKCPlXiS+ymnYNpXMCGwSclWAxog2LAxWvzt83zFdUdBuU1bmZ5bFcXdT3k7r7kfYOFYwjj+CG9lxdPxV0dUZbYN9uqVJr7MYsw/h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O14/d96/; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O14/d96/"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-383b4a3755fso1279850a91.3
        for <linux-wireless@vger.kernel.org>; Fri, 04 Sep 2026 14:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788556591; x=1789161391; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=rL2Vl7YFb+EGkVpLBZu2e2XMHspyG4EhShKw36L1tO0=;
        b=O14/d96/n8Pw0wnyI+LlIBmTui5cYxlELHW5xn31cJOJXMZu6jfIILaeQeHJcxJIkB
         eGzKFNvVxGgLZjVVk/zx5Wza9WgRZ0vYHcVuJ362Cwz3hTUAmSnMEYfZHX4UhxDs2uMT
         5OeE9JdJZnka1hyQgaAD2LUhzhpNjpPfVJe7QPVaFz9IvEcR8rUKcCi8griSCHJ/2NG9
         vVWY18rf9zBRzV4TXa1MExvHiZ0ggXvqmAwTqq/UXPaq7z1hbWKqHpSNlPP/i64NVPe9
         N9xtCJ/7FDXyZSqYjm3RGfJv0PNoCYkZZ4oQztK9u1vA796HFqSZmXqGC53emnsc+Qgb
         +vRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788556591; x=1789161391;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rL2Vl7YFb+EGkVpLBZu2e2XMHspyG4EhShKw36L1tO0=;
        b=Wvk1HyT3AboAa+HOrRcdK/2GECPLYUR6DfPeqvwcDBXlXU6ON5cuScieloMU26FgLS
         2DR1W7B/484mO5Ou/HSDgfDAp/bBlEvpkr2JnQx9A9h/3ek/8qI14t33MQPuVpziukY0
         zgE4Ybtp/jfiAbg6BzLKeScgXUuJtTSq1p5Vce/XaO4ecj1dQQyJe7zjR9QA8j5Rvbb9
         8qr/b9ZHOlORXKdE47XeWC/ZGCECb09TzdFOLEXw8pUYmOP5nAZ8ppzmzT+k0gwgXMG7
         ZYtDwM8XmdjZwkG1O+rHrt37g4wqhLfN3rwVYx8MbjJ9p8NSrU7xP49M8bv7J58Gd8E6
         sU1A==
X-Gm-Message-State: AFuF++n8i7S+RmoTue4AnWo7RE6/0kslbh6I6J8FW71nmqxvuXfGJd5D
	tB1ItAg+0YR/sMRrV9NDJA9L30DDjo1LshCfQzZKiTrrFFRQ4N+kyzaa0Ro4Kw==
X-Gm-Gg: AYBFou1Ws4h6l7r5fqCejw4GrQt+ex01KfIfeXakp7IjFzhYPU90sPbty4EWa3ZuBhM
	g0KVb/gmjV7ouIdZgGyJILh7MOXOg8VYehnn8sBXBlsRJQLa64lNxagTn53ROCqkzK31A3VrrE/
	GepLDvNH++2LsWwN3/ppJITTYRiVzS0W+XyEOujbO+9Jzl2yx/5t/IZvQmB9StLVNk5B0v8Yewy
	bmy0w7TnCfgpDQUge+ie+s4VI/xA2S2IjRaF8uhpM+/ant14BLd5uk7WZT6TjiHsZsSU4PieiZ+
	nuRCoGTAS3zx7RhFjD0JXYS8McrDfea0AuEe/+wsjBPq1YDc3MMGu3nDGn3XUMvv2me9pjMTqRP
	4BQq8jzkC91YXdP1lccyKmLVSU43CBPz0E0+YNV11lsnXQ8yMWVid+MmejVoL76vMoQg3xygT1c
	76ZMtGQcQeBL7i4BzUN3i9UC6FqKkTQ18+tTS6DdYusF3TDgfV/49nZnj1q95POMzu4WcpnRCJK
	DA/wpppfY9gOI75nULYtQpswyY6blYTxVL4iZUIEp6XTno7ule/KalmolsXhll1pqXO2jnDW5Tc
	7/zdG+L6bw6apE5uaVZeddR9H3dBFCFcwnP+qAK5MJd36VY29g==
X-Received: by 2002:a17:90b:2e0e:b0:398:9be5:b419 with SMTP id 98e67ed59e1d1-39b2622bfecmr13197568a91.20.1788556590839;
        Fri, 04 Sep 2026 14:16:30 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e34])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b08c39227sm12437941a91.9.2026.09.04.14.16.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 14:16:30 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <stf_xl@wp.pl>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCHv2 wireless-next] wifi: rt2x00: Use device-managed register buffers
Date: Fri,  4 Sep 2026 14:16:28 -0700
Message-ID: <20260904211628.83180-1-rosenp@gmail.com>
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
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 v2: fix u32* rf typo.
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
index 47e427ea8622..c9fbc3710fd8 100644
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
+	u32 *rf;
 
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

