Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:58978 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbYJVMT6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 08:19:58 -0400
From: Chr <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] p54: fix misbehavings when firmware can't be found
Date: Wed, 22 Oct 2008 14:19:56 +0200
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Sean Young <sean@mess.org>, bugme-daemon@bugzilla.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <bug-11782-10286@http.bugzilla.kernel.org/> <200810212156.24772.chunkeey@web.de> <20081022080557.GA38534@atlantis.8hz.com>
In-Reply-To: <20081022080557.GA38534@atlantis.8hz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200810221419.56326.chunkeey@web.de> (sfid-20081022_142002_940740_3D8C34A6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a double-free error in p54pci
( http://bugzilla.kernel.org/show_bug.cgi?id=3D11782 )

Trying to free already-free IRQ 10
Pid: 108, comm: pccardd Not tainted 2.6.27-05577-g0cfd810-dirty #1
Call Trace:
=A0[<c01265dc>] free_irq+0xad/0xb9
=A0[<c01050dd>] dma_generic_alloc_coherent+0x0/0xd7
=A0[<c01ba8e6>] p54p_stop+0x4a/0x1fa
=A0[<c01050dd>] dma_generic_alloc_coherent+0x0/0xd7
=A0[<c02348c5>] p54p_probe+0x23e/0x302

Tested-by: Sean Young
Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
[Ignore the first one, it was wordwrapped]
John / Andrew,

There is another, older patch for a different regression,
wasn't merged yet...

[PATCH] p54: enable 2.4/5GHz spectrum by eeprom bits.
http://article.gmane.org/gmane.linux.kernel.wireless.general/22234

regards,=A0=A0=A0=A0=A0=A0=A0=A0
=A0=A0=A0=A0=A0=A0=A0=A0Chr
---
diff --git a/drivers/net/wireless/p54/p54pci.c b/drivers/net/wireless/p=
54/p54pci.c
index 1c2a02a..88b3cad 100644
--- a/drivers/net/wireless/p54/p54pci.c
+++ b/drivers/net/wireless/p54/p54pci.c
@@ -346,68 +346,6 @@ static void p54p_tx(struct ieee80211_hw *dev, stru=
ct p54_control_hdr *data,
 		printk(KERN_INFO "%s: tx overflow.\n", wiphy_name(dev->wiphy));
 }
=20
-static int p54p_open(struct ieee80211_hw *dev)
-{
-	struct p54p_priv *priv =3D dev->priv;
-	int err;
-
-	init_completion(&priv->boot_comp);
-	err =3D request_irq(priv->pdev->irq, &p54p_interrupt,
-			  IRQF_SHARED, "p54pci", dev);
-	if (err) {
-		printk(KERN_ERR "%s: failed to register IRQ handler\n",
-		       wiphy_name(dev->wiphy));
-		return err;
-	}
-
-	memset(priv->ring_control, 0, sizeof(*priv->ring_control));
-	err =3D p54p_upload_firmware(dev);
-	if (err) {
-		free_irq(priv->pdev->irq, dev);
-		return err;
-	}
-	priv->rx_idx_data =3D priv->tx_idx_data =3D 0;
-	priv->rx_idx_mgmt =3D priv->tx_idx_mgmt =3D 0;
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
-	if (!wait_for_completion_interruptible_timeout(&priv->boot_comp, HZ))=
 {
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
 	struct p54p_priv *priv =3D dev->priv;
@@ -474,6 +412,68 @@ static void p54p_stop(struct ieee80211_hw *dev)
 	memset(ring_control, 0, sizeof(*ring_control));
 }
=20
+static int p54p_open(struct ieee80211_hw *dev)
+{
+	struct p54p_priv *priv =3D dev->priv;
+	int err;
+
+	init_completion(&priv->boot_comp);
+	err =3D request_irq(priv->pdev->irq, &p54p_interrupt,
+			  IRQF_SHARED, "p54pci", dev);
+	if (err) {
+		printk(KERN_ERR "%s: failed to register IRQ handler\n",
+		       wiphy_name(dev->wiphy));
+		return err;
+	}
+
+	memset(priv->ring_control, 0, sizeof(*priv->ring_control));
+	err =3D p54p_upload_firmware(dev);
+	if (err) {
+		free_irq(priv->pdev->irq, dev);
+		return err;
+	}
+	priv->rx_idx_data =3D priv->tx_idx_data =3D 0;
+	priv->rx_idx_mgmt =3D priv->tx_idx_mgmt =3D 0;
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
+	if (!wait_for_completion_interruptible_timeout(&priv->boot_comp, HZ))=
 {
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
@@ -556,11 +556,13 @@ static int __devinit p54p_probe(struct pci_dev *p=
dev,
 	spin_lock_init(&priv->lock);
 	tasklet_init(&priv->rx_tasklet, p54p_rx_tasklet, (unsigned long)dev);
=20
-	p54p_open(dev);
+	err =3D p54p_open(dev);
+	if (err)
+		goto err_free_common;
 	err =3D p54_read_eeprom(dev);
 	p54p_stop(dev);
 	if (err)
-		goto err_free_desc;
+		goto err_free_common;
=20
 	err =3D ieee80211_register_hw(dev);
 	if (err) {
@@ -573,8 +575,6 @@ static int __devinit p54p_probe(struct pci_dev *pde=
v,
=20
  err_free_common:
 	p54_free_common(dev);
-
- err_free_desc:
 	pci_free_consistent(pdev, sizeof(*priv->ring_control),
 			    priv->ring_control, priv->ring_control_dma);
=20
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
