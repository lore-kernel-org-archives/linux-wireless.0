Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:53806 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbYJUT4b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2008 15:56:31 -0400
From: Chr <chunkeey@web.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [RFT/RFC][PATCH] p54: fix misbehavings when firmware can't be found
Date: Tue, 21 Oct 2008 21:56:24 +0200
Cc: linux-wireless@vger.kernel.org, bugme-daemon@bugzilla.kernel.org,
	sean@mess.org
References: <bug-11782-10286@http.bugzilla.kernel.org/> <20081021112313.0885a745.akpm@linux-foundation.org>
In-Reply-To: <20081021112313.0885a745.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_oPj/ItglzjrBt91"
Message-Id: <200810212156.24772.chunkeey@web.de> (sfid-20081021_215636_633739_34E26FE5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_oPj/ItglzjrBt91
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tuesday 21 October 2008 20:23:13 Andrew Morton wrote:
> (switched to email.  Please respond via emailed reply-to-all, not via the
> bugzilla web interface).
>
> On Sat, 18 Oct 2008 09:13:00 -0700 (PDT)
>
> bugme-daemon@bugzilla.kernel.org wrote:
> > http://bugzilla.kernel.org/show_bug.cgi?id=11782
> >
> >            Summary: p54 misbehaves when firmware can't be found
> >            Product: Drivers
> >            Version: 2.5
> >      KernelVersion: 2.6.27-git8
> >           Platform: All
> >         OS/Version: Linux
> >               Tree: Mainline
> >             Status: NEW
> >           Severity: low
> >           Priority: P1
> >          Component: network-wireless
> >         AssignedTo: drivers_network-wireless@kernel-bugs.osdl.org
> >         ReportedBy: sean@mess.org
> >
> >
> > Latest working kernel version: 2.6.26
>
well, you can increase 26 to 27. The patch that caused this regression 
went into in 2.6.27-gitX so no stable kernel is affected only this pre-rc1...

anyway, I don't have any p54p hardware right now (for the next two weeks
to be more precise), so sean you have to test it and report back, otherwise
this will properly stay RFT...

I made two versions of the patch, both do the same,
so it more a matter of which one you would like to have.

I prefer the first and bigger one, since it hopefully won't break the other 
patches I send some time ago for wireless-testing...

Regards,
	Chr
---
diff --git a/drivers/net/wireless/p54/p54pci.c 
b/drivers/net/wireless/p54/p54pci.c
index 1c2a02a..88b3cad 100644
--- a/drivers/net/wireless/p54/p54pci.c
+++ b/drivers/net/wireless/p54/p54pci.c
@@ -346,68 +346,6 @@ static void p54p_tx(struct ieee80211_hw *dev, struct 
p54_control_hdr *data,
 		printk(KERN_INFO "%s: tx overflow.\n", wiphy_name(dev->wiphy));
 }
 
-static int p54p_open(struct ieee80211_hw *dev)
-{
-	struct p54p_priv *priv = dev->priv;
-	int err;
-
-	init_completion(&priv->boot_comp);
-	err = request_irq(priv->pdev->irq, &p54p_interrupt,
-			  IRQF_SHARED, "p54pci", dev);
-	if (err) {
-		printk(KERN_ERR "%s: failed to register IRQ handler\n",
-		       wiphy_name(dev->wiphy));
-		return err;
-	}
-
-	memset(priv->ring_control, 0, sizeof(*priv->ring_control));
-	err = p54p_upload_firmware(dev);
-	if (err) {
-		free_irq(priv->pdev->irq, dev);
-		return err;
-	}
-	priv->rx_idx_data = priv->tx_idx_data = 0;
-	priv->rx_idx_mgmt = priv->tx_idx_mgmt = 0;
-
-	p54p_refill_rx_ring(dev, 0, priv->ring_control->rx_data,
-		ARRAY_SIZE(priv->ring_control->rx_data), priv->rx_buf_data);
-
-	p54p_refill_rx_ring(dev, 2, priv->ring_control->rx_mgmt,
-		ARRAY_SIZE(priv->ring_control->rx_mgmt), priv->rx_buf_mgmt);
-
-	P54P_WRITE(ring_control_base, cpu_to_le32(priv->ring_control_dma));
-	P54P_READ(ring_control_base);
-	wmb();
-	udelay(10);
-
-	P54P_WRITE(int_enable, cpu_to_le32(ISL38XX_INT_IDENT_INIT));
-	P54P_READ(int_enable);
-	wmb();
-	udelay(10);
-
-	P54P_WRITE(dev_int, cpu_to_le32(ISL38XX_DEV_INT_RESET));
-	P54P_READ(dev_int);
-
-	if (!wait_for_completion_interruptible_timeout(&priv->boot_comp, HZ)) {
-		printk(KERN_ERR "%s: Cannot boot firmware!\n",
-		       wiphy_name(dev->wiphy));
-		free_irq(priv->pdev->irq, dev);
-		return -ETIMEDOUT;
-	}
-
-	P54P_WRITE(int_enable, cpu_to_le32(ISL38XX_INT_IDENT_UPDATE));
-	P54P_READ(int_enable);
-	wmb();
-	udelay(10);
-
-	P54P_WRITE(dev_int, cpu_to_le32(ISL38XX_DEV_INT_UPDATE));
-	P54P_READ(dev_int);
-	wmb();
-	udelay(10);
-
-	return 0;
-}
-
 static void p54p_stop(struct ieee80211_hw *dev)
 {
 	struct p54p_priv *priv = dev->priv;
@@ -474,6 +412,68 @@ static void p54p_stop(struct ieee80211_hw *dev)
 	memset(ring_control, 0, sizeof(*ring_control));
 }
 
+static int p54p_open(struct ieee80211_hw *dev)
+{
+	struct p54p_priv *priv = dev->priv;
+	int err;
+
+	init_completion(&priv->boot_comp);
+	err = request_irq(priv->pdev->irq, &p54p_interrupt,
+			  IRQF_SHARED, "p54pci", dev);
+	if (err) {
+		printk(KERN_ERR "%s: failed to register IRQ handler\n",
+		       wiphy_name(dev->wiphy));
+		return err;
+	}
+
+	memset(priv->ring_control, 0, sizeof(*priv->ring_control));
+	err = p54p_upload_firmware(dev);
+	if (err) {
+		free_irq(priv->pdev->irq, dev);
+		return err;
+	}
+	priv->rx_idx_data = priv->tx_idx_data = 0;
+	priv->rx_idx_mgmt = priv->tx_idx_mgmt = 0;
+
+	p54p_refill_rx_ring(dev, 0, priv->ring_control->rx_data,
+		ARRAY_SIZE(priv->ring_control->rx_data), priv->rx_buf_data);
+
+	p54p_refill_rx_ring(dev, 2, priv->ring_control->rx_mgmt,
+		ARRAY_SIZE(priv->ring_control->rx_mgmt), priv->rx_buf_mgmt);
+
+	P54P_WRITE(ring_control_base, cpu_to_le32(priv->ring_control_dma));
+	P54P_READ(ring_control_base);
+	wmb();
+	udelay(10);
+
+	P54P_WRITE(int_enable, cpu_to_le32(ISL38XX_INT_IDENT_INIT));
+	P54P_READ(int_enable);
+	wmb();
+	udelay(10);
+
+	P54P_WRITE(dev_int, cpu_to_le32(ISL38XX_DEV_INT_RESET));
+	P54P_READ(dev_int);
+
+	if (!wait_for_completion_interruptible_timeout(&priv->boot_comp, HZ)) {
+		printk(KERN_ERR "%s: Cannot boot firmware!\n",
+		       wiphy_name(dev->wiphy));
+		p54p_stop(dev);
+		return -ETIMEDOUT;
+	}
+
+	P54P_WRITE(int_enable, cpu_to_le32(ISL38XX_INT_IDENT_UPDATE));
+	P54P_READ(int_enable);
+	wmb();
+	udelay(10);
+
+	P54P_WRITE(dev_int, cpu_to_le32(ISL38XX_DEV_INT_UPDATE));
+	P54P_READ(dev_int);
+	wmb();
+	udelay(10);
+
+	return 0;
+}
+
 static int __devinit p54p_probe(struct pci_dev *pdev,
 				const struct pci_device_id *id)
 {
@@ -556,11 +556,13 @@ static int __devinit p54p_probe(struct pci_dev *pdev,
 	spin_lock_init(&priv->lock);
 	tasklet_init(&priv->rx_tasklet, p54p_rx_tasklet, (unsigned long)dev);
 
-	p54p_open(dev);
+	err = p54p_open(dev);
+	if (err)
+		goto err_free_common;
 	err = p54_read_eeprom(dev);
 	p54p_stop(dev);
 	if (err)
-		goto err_free_desc;
+		goto err_free_common;
 
 	err = ieee80211_register_hw(dev);
 	if (err) {
@@ -573,8 +575,6 @@ static int __devinit p54p_probe(struct pci_dev *pdev,
 
  err_free_common:
 	p54_free_common(dev);
-
- err_free_desc:
 	pci_free_consistent(pdev, sizeof(*priv->ring_control),
 			    priv->ring_control, priv->ring_control_dma);
 
---





this is the alternative patch





---
diff --git a/drivers/net/wireless/p54/p54pci.c 
b/drivers/net/wireless/p54/p54pci.c
index 1c2a02a..3f91fbc 100644
--- a/drivers/net/wireless/p54/p54pci.c
+++ b/drivers/net/wireless/p54/p54pci.c
@@ -346,6 +346,8 @@ static void p54p_tx(struct ieee80211_hw *dev, struct 
p54_control_hdr *data,
 		printk(KERN_INFO "%s: tx overflow.\n", wiphy_name(dev->wiphy));
 }
 
+static void p54p_stop(struct ieee80211_hw *dev);
+
 static int p54p_open(struct ieee80211_hw *dev)
 {
 	struct p54p_priv *priv = dev->priv;
@@ -391,7 +393,7 @@ static int p54p_open(struct ieee80211_hw *dev)
 	if (!wait_for_completion_interruptible_timeout(&priv->boot_comp, HZ)) {
 		printk(KERN_ERR "%s: Cannot boot firmware!\n",
 		       wiphy_name(dev->wiphy));
-		free_irq(priv->pdev->irq, dev);
+		p54p_stop(dev);
 		return -ETIMEDOUT;
 	}
 
@@ -556,11 +558,13 @@ static int __devinit p54p_probe(struct pci_dev *pdev,
 	spin_lock_init(&priv->lock);
 	tasklet_init(&priv->rx_tasklet, p54p_rx_tasklet, (unsigned long)dev);
 
-	p54p_open(dev);
+	err = p54p_open(dev);
+	if (err)
+		goto err_free_common;
 	err = p54_read_eeprom(dev);
 	p54p_stop(dev);
 	if (err)
-		goto err_free_desc;
+		goto err_free_common;
 
 	err = ieee80211_register_hw(dev);
 	if (err) {
@@ -573,8 +577,6 @@ static int __devinit p54p_probe(struct pci_dev *pdev,
 
  err_free_common:
 	p54_free_common(dev);
-
- err_free_desc:
 	pci_free_consistent(pdev, sizeof(*priv->ring_control),
 			    priv->ring_control, priv->ring_control_dma);
 

--Boundary-00=_oPj/ItglzjrBt91
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="p54pci-fix-no-firmware-move.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="p54pci-fix-no-firmware-move.diff"

diff --git a/drivers/net/wireless/p54/p54pci.c b/drivers/net/wireless/p54/p54pci.c
index 1c2a02a..88b3cad 100644
--- a/drivers/net/wireless/p54/p54pci.c
+++ b/drivers/net/wireless/p54/p54pci.c
@@ -346,68 +346,6 @@ static void p54p_tx(struct ieee80211_hw *dev, struct p54_control_hdr *data,
 		printk(KERN_INFO "%s: tx overflow.\n", wiphy_name(dev->wiphy));
 }
 
-static int p54p_open(struct ieee80211_hw *dev)
-{
-	struct p54p_priv *priv = dev->priv;
-	int err;
-
-	init_completion(&priv->boot_comp);
-	err = request_irq(priv->pdev->irq, &p54p_interrupt,
-			  IRQF_SHARED, "p54pci", dev);
-	if (err) {
-		printk(KERN_ERR "%s: failed to register IRQ handler\n",
-		       wiphy_name(dev->wiphy));
-		return err;
-	}
-
-	memset(priv->ring_control, 0, sizeof(*priv->ring_control));
-	err = p54p_upload_firmware(dev);
-	if (err) {
-		free_irq(priv->pdev->irq, dev);
-		return err;
-	}
-	priv->rx_idx_data = priv->tx_idx_data = 0;
-	priv->rx_idx_mgmt = priv->tx_idx_mgmt = 0;
-
-	p54p_refill_rx_ring(dev, 0, priv->ring_control->rx_data,
-		ARRAY_SIZE(priv->ring_control->rx_data), priv->rx_buf_data);
-
-	p54p_refill_rx_ring(dev, 2, priv->ring_control->rx_mgmt,
-		ARRAY_SIZE(priv->ring_control->rx_mgmt), priv->rx_buf_mgmt);
-
-	P54P_WRITE(ring_control_base, cpu_to_le32(priv->ring_control_dma));
-	P54P_READ(ring_control_base);
-	wmb();
-	udelay(10);
-
-	P54P_WRITE(int_enable, cpu_to_le32(ISL38XX_INT_IDENT_INIT));
-	P54P_READ(int_enable);
-	wmb();
-	udelay(10);
-
-	P54P_WRITE(dev_int, cpu_to_le32(ISL38XX_DEV_INT_RESET));
-	P54P_READ(dev_int);
-
-	if (!wait_for_completion_interruptible_timeout(&priv->boot_comp, HZ)) {
-		printk(KERN_ERR "%s: Cannot boot firmware!\n",
-		       wiphy_name(dev->wiphy));
-		free_irq(priv->pdev->irq, dev);
-		return -ETIMEDOUT;
-	}
-
-	P54P_WRITE(int_enable, cpu_to_le32(ISL38XX_INT_IDENT_UPDATE));
-	P54P_READ(int_enable);
-	wmb();
-	udelay(10);
-
-	P54P_WRITE(dev_int, cpu_to_le32(ISL38XX_DEV_INT_UPDATE));
-	P54P_READ(dev_int);
-	wmb();
-	udelay(10);
-
-	return 0;
-}
-
 static void p54p_stop(struct ieee80211_hw *dev)
 {
 	struct p54p_priv *priv = dev->priv;
@@ -474,6 +412,68 @@ static void p54p_stop(struct ieee80211_hw *dev)
 	memset(ring_control, 0, sizeof(*ring_control));
 }
 
+static int p54p_open(struct ieee80211_hw *dev)
+{
+	struct p54p_priv *priv = dev->priv;
+	int err;
+
+	init_completion(&priv->boot_comp);
+	err = request_irq(priv->pdev->irq, &p54p_interrupt,
+			  IRQF_SHARED, "p54pci", dev);
+	if (err) {
+		printk(KERN_ERR "%s: failed to register IRQ handler\n",
+		       wiphy_name(dev->wiphy));
+		return err;
+	}
+
+	memset(priv->ring_control, 0, sizeof(*priv->ring_control));
+	err = p54p_upload_firmware(dev);
+	if (err) {
+		free_irq(priv->pdev->irq, dev);
+		return err;
+	}
+	priv->rx_idx_data = priv->tx_idx_data = 0;
+	priv->rx_idx_mgmt = priv->tx_idx_mgmt = 0;
+
+	p54p_refill_rx_ring(dev, 0, priv->ring_control->rx_data,
+		ARRAY_SIZE(priv->ring_control->rx_data), priv->rx_buf_data);
+
+	p54p_refill_rx_ring(dev, 2, priv->ring_control->rx_mgmt,
+		ARRAY_SIZE(priv->ring_control->rx_mgmt), priv->rx_buf_mgmt);
+
+	P54P_WRITE(ring_control_base, cpu_to_le32(priv->ring_control_dma));
+	P54P_READ(ring_control_base);
+	wmb();
+	udelay(10);
+
+	P54P_WRITE(int_enable, cpu_to_le32(ISL38XX_INT_IDENT_INIT));
+	P54P_READ(int_enable);
+	wmb();
+	udelay(10);
+
+	P54P_WRITE(dev_int, cpu_to_le32(ISL38XX_DEV_INT_RESET));
+	P54P_READ(dev_int);
+
+	if (!wait_for_completion_interruptible_timeout(&priv->boot_comp, HZ)) {
+		printk(KERN_ERR "%s: Cannot boot firmware!\n",
+		       wiphy_name(dev->wiphy));
+		p54p_stop(dev);
+		return -ETIMEDOUT;
+	}
+
+	P54P_WRITE(int_enable, cpu_to_le32(ISL38XX_INT_IDENT_UPDATE));
+	P54P_READ(int_enable);
+	wmb();
+	udelay(10);
+
+	P54P_WRITE(dev_int, cpu_to_le32(ISL38XX_DEV_INT_UPDATE));
+	P54P_READ(dev_int);
+	wmb();
+	udelay(10);
+
+	return 0;
+}
+
 static int __devinit p54p_probe(struct pci_dev *pdev,
 				const struct pci_device_id *id)
 {
@@ -556,11 +556,13 @@ static int __devinit p54p_probe(struct pci_dev *pdev,
 	spin_lock_init(&priv->lock);
 	tasklet_init(&priv->rx_tasklet, p54p_rx_tasklet, (unsigned long)dev);
 
-	p54p_open(dev);
+	err = p54p_open(dev);
+	if (err)
+		goto err_free_common;
 	err = p54_read_eeprom(dev);
 	p54p_stop(dev);
 	if (err)
-		goto err_free_desc;
+		goto err_free_common;
 
 	err = ieee80211_register_hw(dev);
 	if (err) {
@@ -573,8 +575,6 @@ static int __devinit p54p_probe(struct pci_dev *pdev,
 
  err_free_common:
 	p54_free_common(dev);
-
- err_free_desc:
 	pci_free_consistent(pdev, sizeof(*priv->ring_control),
 			    priv->ring_control, priv->ring_control_dma);
 

--Boundary-00=_oPj/ItglzjrBt91
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="p54pci-fix-no-firmware.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="p54pci-fix-no-firmware.diff"

diff --git a/drivers/net/wireless/p54/p54pci.c b/drivers/net/wireless/p54/p54pci.c
index 1c2a02a..3f91fbc 100644
--- a/drivers/net/wireless/p54/p54pci.c
+++ b/drivers/net/wireless/p54/p54pci.c
@@ -346,6 +346,8 @@ static void p54p_tx(struct ieee80211_hw *dev, struct p54_control_hdr *data,
 		printk(KERN_INFO "%s: tx overflow.\n", wiphy_name(dev->wiphy));
 }
 
+static void p54p_stop(struct ieee80211_hw *dev);
+
 static int p54p_open(struct ieee80211_hw *dev)
 {
 	struct p54p_priv *priv = dev->priv;
@@ -391,7 +393,7 @@ static int p54p_open(struct ieee80211_hw *dev)
 	if (!wait_for_completion_interruptible_timeout(&priv->boot_comp, HZ)) {
 		printk(KERN_ERR "%s: Cannot boot firmware!\n",
 		       wiphy_name(dev->wiphy));
-		free_irq(priv->pdev->irq, dev);
+		p54p_stop(dev);
 		return -ETIMEDOUT;
 	}
 
@@ -556,11 +558,13 @@ static int __devinit p54p_probe(struct pci_dev *pdev,
 	spin_lock_init(&priv->lock);
 	tasklet_init(&priv->rx_tasklet, p54p_rx_tasklet, (unsigned long)dev);
 
-	p54p_open(dev);
+	err = p54p_open(dev);
+	if (err)
+		goto err_free_common;
 	err = p54_read_eeprom(dev);
 	p54p_stop(dev);
 	if (err)
-		goto err_free_desc;
+		goto err_free_common;
 
 	err = ieee80211_register_hw(dev);
 	if (err) {
@@ -573,8 +577,6 @@ static int __devinit p54p_probe(struct pci_dev *pdev,
 
  err_free_common:
 	p54_free_common(dev);
-
- err_free_desc:
 	pci_free_consistent(pdev, sizeof(*priv->ring_control),
 			    priv->ring_control, priv->ring_control_dma);
 

--Boundary-00=_oPj/ItglzjrBt91--
