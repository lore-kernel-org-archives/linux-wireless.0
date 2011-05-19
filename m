Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:60449 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932622Ab1ESMdt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 May 2011 08:33:49 -0400
Received: by mail-ew0-f46.google.com with SMTP id 4so742747ewy.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 May 2011 05:33:48 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	Julian Calaby <julian.calaby@gmail.com>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 4/4] b43: bus: add helpers for checking host type
Date: Thu, 19 May 2011 15:11:27 +0200
Message-Id: <1305810687-4567-4-git-send-email-zajec5@gmail.com> (sfid-20110519_143352_833136_BB00FE91)
In-Reply-To: <1305810687-4567-1-git-send-email-zajec5@gmail.com>
References: <1305810687-4567-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/bus.h  |   11 +++++++++++
 drivers/net/wireless/b43/main.c |   12 ++++++------
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/b43/bus.h b/drivers/net/wireless/b43/bus.h
index fd88e2b..79a5ab4 100644
--- a/drivers/net/wireless/b43/bus.h
+++ b/drivers/net/wireless/b43/bus.h
@@ -46,6 +46,17 @@ struct b43_bus_dev {
 	u8 core_rev;
 };
 
+static inline bool b43_bus_host_is_pcmcia(struct b43_bus_dev *dev)
+{
+	return (dev->bus_type == B43_BUS_SSB &&
+		dev->sdev->bus->bustype == SSB_BUSTYPE_PCMCIA);
+}
+static inline bool b43_bus_host_is_sdio(struct b43_bus_dev *dev)
+{
+	return (dev->bus_type == B43_BUS_SSB &&
+		dev->sdev->bus->bustype == SSB_BUSTYPE_SDIO);
+}
+
 struct b43_bus_dev *b43_bus_dev_ssb_init(struct ssb_device *sdev);
 
 #endif /* B43_BUS_H_ */
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 99411da..659bc31 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -1645,7 +1645,7 @@ static void b43_beacon_update_trigger_work(struct work_struct *work)
 	mutex_lock(&wl->mutex);
 	dev = wl->current_dev;
 	if (likely(dev && (b43_status(dev) >= B43_STAT_INITIALIZED))) {
-		if (dev->sdev->bus->bustype == SSB_BUSTYPE_SDIO) {
+		if (b43_bus_host_is_sdio(dev->dev)) {
 			/* wl->mutex is enough. */
 			b43_do_beacon_update_trigger_work(dev);
 			mmiowb();
@@ -3955,7 +3955,7 @@ redo:
 
 	/* Disable interrupts on the device. */
 	b43_set_status(dev, B43_STAT_INITIALIZED);
-	if (dev->sdev->bus->bustype == SSB_BUSTYPE_SDIO) {
+	if (b43_bus_host_is_sdio(dev->dev)) {
 		/* wl->mutex is locked. That is enough. */
 		b43_write32(dev, B43_MMIO_GEN_IRQ_MASK, 0);
 		b43_read32(dev, B43_MMIO_GEN_IRQ_MASK);	/* Flush */
@@ -3968,7 +3968,7 @@ redo:
 	/* Synchronize and free the interrupt handlers. Unlock to avoid deadlocks. */
 	orig_dev = dev;
 	mutex_unlock(&wl->mutex);
-	if (dev->sdev->bus->bustype == SSB_BUSTYPE_SDIO) {
+	if (b43_bus_host_is_sdio(dev->dev)) {
 		b43_sdio_free_irq(dev);
 	} else {
 		synchronize_irq(dev->dev->irq);
@@ -4005,7 +4005,7 @@ static int b43_wireless_core_start(struct b43_wldev *dev)
 	B43_WARN_ON(b43_status(dev) != B43_STAT_INITIALIZED);
 
 	drain_txstatus_queue(dev);
-	if (dev->sdev->bus->bustype == SSB_BUSTYPE_SDIO) {
+	if (b43_bus_host_is_sdio(dev->dev)) {
 		err = b43_sdio_request_irq(dev, b43_sdio_interrupt_handler);
 		if (err) {
 			b43err(dev->wl, "Cannot request SDIO IRQ\n");
@@ -4405,8 +4405,8 @@ static int b43_wireless_core_init(struct b43_wldev *dev)
 	/* Maximum Contention Window */
 	b43_shm_write16(dev, B43_SHM_SCRATCH, B43_SHM_SC_MAXCONT, 0x3FF);
 
-	if ((dev->sdev->bus->bustype == SSB_BUSTYPE_PCMCIA) ||
-	    (dev->sdev->bus->bustype == SSB_BUSTYPE_SDIO) ||
+	if (b43_bus_host_is_pcmcia(dev->dev) ||
+	    b43_bus_host_is_sdio(dev->dev) ||
 	    dev->use_pio) {
 		dev->__using_pio_transfers = 1;
 		err = b43_pio_init(dev);
-- 
1.7.3.4

