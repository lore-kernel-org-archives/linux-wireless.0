Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4508 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758346Ab2D1B5M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2012 21:57:12 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/4] brcmfmac: add out of band interrupt support
Date: Fri, 27 Apr 2012 18:56:59 -0700
Message-ID: <1335578219-4224-5-git-send-email-frankyl@broadcom.com> (sfid-20120428_035718_581784_58AF577D)
In-Reply-To: <1335578219-4224-1-git-send-email-frankyl@broadcom.com>
References: <1335578219-4224-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some sdio host controllers do not support real in band interrupt.
Software polling mode as a replacement is not fast enough for
high throughput and new features. Also some in band interrupts
do not support host wake up on embedded platform even when they
are real physical interrupts. Therefore out of band (oob)
interrupt mechanism is implemented for these scenarios.

To provide oob irq number and flags used for irq registration in
brcmfmac, a platform device contains irq resource must be
registered in board specific code.

Here is an example of platform device structure:
struct resource brcmf_sdio_res[] = {
	{
		.start	= GPIO_BRCMF_SDIO_OOB_NUM,
		.end	= GPIO_BRCMF_SDIO_OOB_NUM,
		.flags  = IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHLEVEL,
	}
};
struct platform_device brcmf_sdio_device = {
	.name		= "brcmf_sdio_pd",
	.id		= -1,
	.num_resources	= ARRAY_SIZE(brcmf_sdio_res),
	.resource	= brcmf_sdio_res,
};

Reviewed-by: pieter-paul giesberts <pieterpg@broadcom.com>
Reviewed-by: arend van spriel <arend@broadcom.com>
Signed-off-by: franky lin <frankyl@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/Kconfig             |    9 ++
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |   95 ++++++++++++++++--
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |  105 +++++++++++++++++++-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   24 ++++-
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |   22 +++-
 5 files changed, 240 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/Kconfig b/drivers/net/wireless/brcm80211/Kconfig
index c510453..b480088 100644
--- a/drivers/net/wireless/brcm80211/Kconfig
+++ b/drivers/net/wireless/brcm80211/Kconfig
@@ -36,6 +36,15 @@ config BRCMFMAC_SDIO
 	  IEEE802.11n embedded FullMAC WLAN driver. Say Y if you want to
 	  use the driver for a SDIO wireless card.
 
+config BRCMFMAC_SDIO_OOB
+	bool "Out of band interrupt support for SDIO interface chipset"
+	depends on BRCMFMAC_SDIO
+	---help---
+	  This option enables out-of-band interrupt support for Broadcom
+	  SDIO Wifi chipset using fullmac in order to gain better
+	  performance and deep sleep wake up capability on certain
+	  platforms. Say N if you are unsure.
+
 config BRCMFMAC_USB
 	bool "USB bus interface support for FullMAC driver"
 	depends on USB
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index ea35020..4add7da 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -39,33 +39,113 @@
 
 #define SDIOH_API_ACCESS_RETRY_LIMIT	2
 
-static void brcmf_sdioh_irqhandler(struct sdio_func *func)
+#ifdef CONFIG_BRCMFMAC_SDIO_OOB
+static irqreturn_t brcmf_sdio_irqhandler(int irq, void *dev_id)
+{
+	struct brcmf_sdio_dev *sdiodev = dev_get_drvdata(dev_id);
+
+	brcmf_dbg(INTR, "oob intr triggered\n");
+
+	/*
+	 * out-of-band interrupt is level-triggered which won't
+	 * be cleared until dpc
+	 */
+	if (sdiodev->irq_en) {
+		disable_irq_nosync(irq);
+		sdiodev->irq_en = false;
+	}
+
+	brcmf_sdbrcm_isr(sdiodev->bus);
+
+	return IRQ_HANDLED;
+}
+
+int brcmf_sdio_intr_register(struct brcmf_sdio_dev *sdiodev)
+{
+	int ret = 0;
+	u8 data;
+	unsigned long flags;
+
+	brcmf_dbg(TRACE, "Entering\n");
+
+	brcmf_dbg(ERROR, "requesting irq %d\n", sdiodev->irq);
+	ret = request_irq(sdiodev->irq, brcmf_sdio_irqhandler,
+			  sdiodev->irq_flags, "brcmf_oob_intr",
+			  &sdiodev->func[1]->card->dev);
+	if (ret != 0)
+		return ret;
+	spin_lock_init(&sdiodev->irq_en_lock);
+	spin_lock_irqsave(&sdiodev->irq_en_lock, flags);
+	sdiodev->irq_en = true;
+	spin_unlock_irqrestore(&sdiodev->irq_en_lock, flags);
+
+	ret = enable_irq_wake(sdiodev->irq);
+	if (ret != 0)
+		return ret;
+	sdiodev->irq_wake = true;
+
+	/* must configure SDIO_CCCR_IENx to enable irq */
+	data = brcmf_sdcard_cfg_read(sdiodev, SDIO_FUNC_0,
+				     SDIO_CCCR_IENx, &ret);
+	data |= 1 << SDIO_FUNC_1 | 1 << SDIO_FUNC_2 | 1;
+	brcmf_sdcard_cfg_write(sdiodev, SDIO_FUNC_0, SDIO_CCCR_IENx,
+			       data, &ret);
+
+	/* redirect, configure ane enable io for interrupt signal */
+	data = SDIO_SEPINT_MASK | SDIO_SEPINT_OE;
+	if (sdiodev->irq_flags | IRQF_TRIGGER_HIGH)
+		data |= SDIO_SEPINT_ACT_HI;
+	brcmf_sdcard_cfg_write(sdiodev, SDIO_FUNC_0, SDIO_CCCR_BRCM_SEPINT,
+			       data, &ret);
+
+	return 0;
+}
+
+int brcmf_sdio_intr_unregister(struct brcmf_sdio_dev *sdiodev)
+{
+	brcmf_dbg(TRACE, "Entering\n");
+
+	brcmf_sdcard_cfg_write(sdiodev, SDIO_FUNC_0, SDIO_CCCR_BRCM_SEPINT,
+			       0, NULL);
+	brcmf_sdcard_cfg_write(sdiodev, SDIO_FUNC_0, SDIO_CCCR_IENx, 0, NULL);
+
+	if (sdiodev->irq_wake) {
+		disable_irq_wake(sdiodev->irq);
+		sdiodev->irq_wake = false;
+	}
+	free_irq(sdiodev->irq, &sdiodev->func[1]->card->dev);
+	sdiodev->irq_en = false;
+
+	return 0;
+}
+#else		/* CONFIG_BRCMFMAC_SDIO_OOB */
+static void brcmf_sdio_irqhandler(struct sdio_func *func)
 {
 	struct brcmf_sdio_dev *sdiodev = dev_get_drvdata(&func->card->dev);
 
-	brcmf_dbg(TRACE, "***IRQHandler\n");
+	brcmf_dbg(INTR, "ib intr triggered\n");
 
 	brcmf_sdbrcm_isr(sdiodev->bus);
 }
 
 /* dummy handler for SDIO function 2 interrupt */
-static void brcmf_sdioh_dummy_irq_handler(struct sdio_func *func)
+static void brcmf_sdio_dummy_irqhandler(struct sdio_func *func)
 {
 }
 
-int brcmf_sdcard_intr_reg(struct brcmf_sdio_dev *sdiodev)
+int brcmf_sdio_intr_register(struct brcmf_sdio_dev *sdiodev)
 {
 	brcmf_dbg(TRACE, "Entering\n");
 
 	sdio_claim_host(sdiodev->func[1]);
-	sdio_claim_irq(sdiodev->func[1], brcmf_sdioh_irqhandler);
-	sdio_claim_irq(sdiodev->func[2], brcmf_sdioh_dummy_irq_handler);
+	sdio_claim_irq(sdiodev->func[1], brcmf_sdio_irqhandler);
+	sdio_claim_irq(sdiodev->func[2], brcmf_sdio_dummy_irqhandler);
 	sdio_release_host(sdiodev->func[1]);
 
 	return 0;
 }
 
-int brcmf_sdcard_intr_dereg(struct brcmf_sdio_dev *sdiodev)
+int brcmf_sdio_intr_unregister(struct brcmf_sdio_dev *sdiodev)
 {
 	brcmf_dbg(TRACE, "Entering\n");
 
@@ -76,6 +156,7 @@ int brcmf_sdcard_intr_dereg(struct brcmf_sdio_dev *sdiodev)
 
 	return 0;
 }
+#endif		/* CONFIG_BRCMFMAC_SDIO_OOB */
 
 u8 brcmf_sdcard_cfg_read(struct brcmf_sdio_dev *sdiodev, uint fnc_num, u32 addr,
 			 int *err)
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 758c115..dd07d33 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -27,6 +27,7 @@
 #include <linux/errno.h>
 #include <linux/sched.h>	/* request_irq() */
 #include <linux/module.h>
+#include <linux/platform_device.h>
 #include <net/cfg80211.h>
 
 #include <defs.h>
@@ -55,6 +56,15 @@ static const struct sdio_device_id brcmf_sdmmc_ids[] = {
 };
 MODULE_DEVICE_TABLE(sdio, brcmf_sdmmc_ids);
 
+#ifdef CONFIG_BRCMFMAC_SDIO_OOB
+static struct list_head oobirq_lh;
+struct brcmf_sdio_oobirq {
+	unsigned int irq;
+	unsigned long flags;
+	struct list_head list;
+};
+#endif		/* CONFIG_BRCMFMAC_SDIO_OOB */
+
 static bool
 brcmf_pm_resume_error(struct brcmf_sdio_dev *sdiodev)
 {
@@ -107,7 +117,8 @@ static inline int brcmf_sdioh_f0_write_byte(struct brcmf_sdio_dev *sdiodev,
 			}
 			sdio_release_host(sdfunc);
 		}
-	} else if (regaddr == SDIO_CCCR_ABORT) {
+	} else if ((regaddr == SDIO_CCCR_ABORT) ||
+		   (regaddr == SDIO_CCCR_IENx)) {
 		sdfunc = kmemdup(sdiodev->func[0], sizeof(struct sdio_func),
 				 GFP_KERNEL);
 		if (!sdfunc)
@@ -467,12 +478,40 @@ void brcmf_sdioh_detach(struct brcmf_sdio_dev *sdiodev)
 
 }
 
+#ifdef CONFIG_BRCMFMAC_SDIO_OOB
+static int brcmf_sdio_getintrcfg(struct brcmf_sdio_dev *sdiodev)
+{
+	struct brcmf_sdio_oobirq *oobirq_entry;
+
+	if (list_empty(&oobirq_lh)) {
+		brcmf_dbg(ERROR, "no valid oob irq resource\n");
+		return -ENXIO;
+	}
+
+	oobirq_entry = list_first_entry(&oobirq_lh, struct brcmf_sdio_oobirq,
+					list);
+
+	sdiodev->irq = oobirq_entry->irq;
+	sdiodev->irq_flags = oobirq_entry->flags;
+	list_del(&oobirq_entry->list);
+	kfree(oobirq_entry);
+
+	return 0;
+}
+#else
+static inline int brcmf_sdio_getintrcfg(struct brcmf_sdio_dev *sdiodev)
+{
+	return 0;
+}
+#endif		/* CONFIG_BRCMFMAC_SDIO_OOB */
+
 static int brcmf_ops_sdio_probe(struct sdio_func *func,
 			      const struct sdio_device_id *id)
 {
 	int ret = 0;
 	struct brcmf_sdio_dev *sdiodev;
 	struct brcmf_bus *bus_if;
+
 	brcmf_dbg(TRACE, "Enter\n");
 	brcmf_dbg(TRACE, "func->class=%x\n", func->class);
 	brcmf_dbg(TRACE, "sdio_vendor: 0x%04x\n", func->vendor);
@@ -511,6 +550,10 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 		sdiodev = dev_get_drvdata(&func->card->dev);
 		if ((!sdiodev) || (sdiodev->func[1]->card != func->card))
 			return -ENODEV;
+
+		ret = brcmf_sdio_getintrcfg(sdiodev);
+		if (ret)
+			return ret;
 		sdiodev->func[2] = func;
 
 		bus_if = sdiodev->bus_if;
@@ -603,6 +646,65 @@ static struct sdio_driver brcmf_sdmmc_driver = {
 #endif	/* CONFIG_PM_SLEEP */
 };
 
+#ifdef CONFIG_BRCMFMAC_SDIO_OOB
+static int brcmf_sdio_pd_probe(struct platform_device *pdev)
+{
+	struct resource *res;
+	struct brcmf_sdio_oobirq *oobirq_entry;
+	int i, ret;
+
+	INIT_LIST_HEAD(&oobirq_lh);
+
+	for (i = 0; ; i++) {
+		res = platform_get_resource(pdev, IORESOURCE_IRQ, i);
+		if (!res)
+			break;
+
+		oobirq_entry = kzalloc(sizeof(struct brcmf_sdio_oobirq),
+				       GFP_KERNEL);
+		oobirq_entry->irq = res->start;
+		oobirq_entry->flags = res->flags & IRQF_TRIGGER_MASK;
+		list_add_tail(&oobirq_entry->list, &oobirq_lh);
+	}
+	if (i == 0)
+		return -ENXIO;
+
+	ret = sdio_register_driver(&brcmf_sdmmc_driver);
+
+	if (ret)
+		brcmf_dbg(ERROR, "sdio_register_driver failed: %d\n", ret);
+
+	return ret;
+}
+
+static struct platform_driver brcmf_sdio_pd = {
+	.probe		= brcmf_sdio_pd_probe,
+	.driver		= {
+		.name	= "brcmf_sdio_pd"
+	}
+};
+
+void brcmf_sdio_exit(void)
+{
+	brcmf_dbg(TRACE, "Enter\n");
+
+	sdio_unregister_driver(&brcmf_sdmmc_driver);
+
+	platform_driver_unregister(&brcmf_sdio_pd);
+}
+
+void brcmf_sdio_init(void)
+{
+	int ret;
+
+	brcmf_dbg(TRACE, "Enter\n");
+
+	ret = platform_driver_register(&brcmf_sdio_pd);
+
+	if (ret)
+		brcmf_dbg(ERROR, "platform_driver_register failed: %d\n", ret);
+}
+#else
 void brcmf_sdio_exit(void)
 {
 	brcmf_dbg(TRACE, "Enter\n");
@@ -621,3 +723,4 @@ void brcmf_sdio_init(void)
 	if (ret)
 		brcmf_dbg(ERROR, "sdio_register_driver failed: %d\n", ret);
 }
+#endif		/* CONFIG_BRCMFMAC_SDIO_OOB */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index b82edaf..1f33b25 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -2352,6 +2352,24 @@ static void brcmf_sdbrcm_bus_stop(struct device *dev)
 	up(&bus->sdsem);
 }
 
+#ifdef CONFIG_BRCMFMAC_SDIO_OOB
+static inline void brcmf_sdbrcm_clrintr(struct brcmf_sdio *bus)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&bus->sdiodev->irq_en_lock, flags);
+	if (!bus->sdiodev->irq_en && !bus->ipend) {
+		enable_irq(bus->sdiodev->irq);
+		bus->sdiodev->irq_en = true;
+	}
+	spin_unlock_irqrestore(&bus->sdiodev->irq_en_lock, flags);
+}
+#else
+static inline void brcmf_sdbrcm_clrintr(struct brcmf_sdio *bus)
+{
+}
+#endif		/* CONFIG_BRCMFMAC_SDIO_OOB */
+
 static bool brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 {
 	u32 intstatus, newstatus = 0;
@@ -2509,6 +2527,8 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 	bus->intstatus = intstatus;
 
 clkwait:
+	brcmf_sdbrcm_clrintr(bus);
+
 	if (data_ok(bus) && bus->ctrl_frame_stat &&
 		(bus->clkstate == CLK_AVAIL)) {
 		int ret, i;
@@ -3508,7 +3528,7 @@ static int brcmf_sdbrcm_bus_init(struct device *dev)
 			       SBSDIO_FUNC1_CHIPCLKCSR, saveclk, &err);
 
 	if (ret == 0) {
-		ret = brcmf_sdcard_intr_reg(bus->sdiodev);
+		ret = brcmf_sdio_intr_register(bus->sdiodev);
 		if (ret != 0)
 			brcmf_dbg(ERROR, "intr register failed:%d\n", ret);
 	}
@@ -3872,7 +3892,7 @@ static void brcmf_sdbrcm_release(struct brcmf_sdio *bus)
 
 	if (bus) {
 		/* De-register interrupt handler */
-		brcmf_sdcard_intr_dereg(bus->sdiodev);
+		brcmf_sdio_intr_unregister(bus->sdiodev);
 
 		if (bus->sdiodev->bus_if->drvr) {
 			brcmf_detach(bus->sdiodev->dev);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
index 0281d20..7010eaf 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
@@ -43,6 +43,13 @@
 /* as of sdiod rev 0, supports 3 functions */
 #define SBSDIO_NUM_FUNCTION		3
 
+/* function 0 vendor specific CCCR registers */
+#define SDIO_CCCR_BRCM_SEPINT		0xf2
+
+#define  SDIO_SEPINT_MASK		0x01
+#define  SDIO_SEPINT_OE			0x02
+#define  SDIO_SEPINT_ACT_HI		0x04
+
 /* function 1 miscellaneous registers */
 
 /* sprom command and status */
@@ -144,13 +151,18 @@ struct brcmf_sdio_dev {
 	wait_queue_head_t request_buffer_wait;
 	struct device *dev;
 	struct brcmf_bus *bus_if;
+#ifdef CONFIG_BRCMFMAC_SDIO_OOB
+	unsigned int irq;		/* oob interrupt number */
+	unsigned long irq_flags;	/* board specific oob flags */
+	bool irq_en;			/* irq enable flags */
+	spinlock_t irq_en_lock;
+	bool irq_wake;			/* irq wake enable flags */
+#endif		/* CONFIG_BRCMFMAC_SDIO_OOB */
 };
 
-/* Register/deregister device interrupt handler. */
-extern int
-brcmf_sdcard_intr_reg(struct brcmf_sdio_dev *sdiodev);
-
-extern int brcmf_sdcard_intr_dereg(struct brcmf_sdio_dev *sdiodev);
+/* Register/deregister interrupt handler. */
+extern int brcmf_sdio_intr_register(struct brcmf_sdio_dev *sdiodev);
+extern int brcmf_sdio_intr_unregister(struct brcmf_sdio_dev *sdiodev);
 
 /* Access SDIO address space (e.g. CCCR) using CMD52 (single-byte interface).
  *   fn:   function number
-- 
1.7.9.5


