Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:29920 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046Ab1BDLgF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Feb 2011 06:36:05 -0500
Received: from nokia.com (localhost [127.0.0.1])
	by mgw-sa01.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id p14Ba0sP008517
	for <linux-wireless@vger.kernel.org>; Fri, 4 Feb 2011 13:36:00 +0200
From: juuso.oikarinen@nokia.com
To: linux-wireless@vger.kernel.org
Cc: luciano.coelho@nokia.com
Subject: [RFC PATCH] wl12xx: Change claiming of the (SDIO) bus
Date: Fri,  4 Feb 2011 13:35:36 +0200
Message-Id: <1296819336-8373-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Currently, the SDIO bus is claimed separately for each and every SDIO
transaction - i.e. every register write/read etc.

The SDIO claiming is a relatively heavy operation. In a worst case scenario,
it will put the SDIO bus on suspend, stop relevant clocks etc which all can be
extremely costly if done between each SDIO transaction. This has a dramatic
impact on the maximum throughput achieved.

The driver already manages its access to the bus as it needs to manage
chipset ELP. This mechanism disables ELP for the duration of the whole bus
access, consisting of multiple transactions.

Into the IO layer, this patch implements a claim/unclaim function, which is
used to claim access to the bus. Relevant functions are checked and updated to
maintain correctly the claim reference counter, so that each claim is paired
with a corresponding unclaim.

For PLT and ad-hoc modes the bus is kept claimed contantly.

For AP mode, this patch brings no change to the previous way of working,
someone familiar with it and with the ability to test it may implement
something similar as is done here for the other modes.

For the SPI bus, the claim/unclaim functions are not implemented, i.e. no
change to functionality.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/io.h     |   12 ++++++++++
 drivers/net/wireless/wl12xx/main.c   |   14 +++++++++++-
 drivers/net/wireless/wl12xx/ps.c     |    5 ++-
 drivers/net/wireless/wl12xx/sdio.c   |   40 +++++++++++++++++++++++-----------
 drivers/net/wireless/wl12xx/wl12xx.h |    4 +++
 5 files changed, 59 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/io.h b/drivers/net/wireless/wl12xx/io.h
index 844b32b..a5a275c 100644
--- a/drivers/net/wireless/wl12xx/io.h
+++ b/drivers/net/wireless/wl12xx/io.h
@@ -153,6 +153,18 @@ static inline int wl1271_power_on(struct wl1271 *wl)
 	return ret;
 }
 
+static inline void wl1271_claim_io(struct wl1271 *wl)
+{
+	if (wl->if_ops->claim_io)
+		wl->if_ops->claim_io(wl);
+}
+
+static inline void wl1271_unclaim_io(struct wl1271 *wl)
+{
+	if (wl->if_ops->unclaim_io)
+		wl->if_ops->unclaim_io(wl);
+}
+
 
 /* Top Register IO */
 void wl1271_top_reg_write(struct wl1271 *wl, int addr, u16 val);
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index dfab21e..431a34c 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -878,6 +878,7 @@ int wl1271_plt_start(struct wl1271 *wl)
 
 	wl->bss_type = BSS_TYPE_STA_BSS;
 
+	wl1271_claim_io(wl);
 	while (retries) {
 		retries--;
 		ret = wl1271_chip_wakeup(wl);
@@ -910,6 +911,7 @@ irq_disable:
 		cancel_work_sync(&wl->irq_work);
 		mutex_lock(&wl->mutex);
 power_off:
+		wl1271_unclaim_io(wl);
 		wl1271_power_off(wl);
 	}
 
@@ -935,6 +937,7 @@ int __wl1271_plt_stop(struct wl1271 *wl)
 	}
 
 	wl1271_disable_interrupts(wl);
+	wl1271_unclaim_io(wl);
 	wl1271_power_off(wl);
 
 	wl->state = WL1271_STATE_OFF;
@@ -1101,6 +1104,7 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 		goto out;
 	}
 
+	wl1271_claim_io(wl);
 	while (retries) {
 		retries--;
 		ret = wl1271_chip_wakeup(wl);
@@ -1131,6 +1135,7 @@ irq_disable:
 		cancel_work_sync(&wl->irq_work);
 		mutex_lock(&wl->mutex);
 power_off:
+		wl1271_unclaim_io(wl);
 		wl1271_power_off(wl);
 	}
 
@@ -1162,8 +1167,10 @@ power_off:
 out:
 	mutex_unlock(&wl->mutex);
 
-	if (!ret)
+	if (!ret) {
 		list_add(&wl->list, &wl_list);
+		wl1271_ps_elp_sleep(wl);
+	}
 
 	return ret;
 }
@@ -1180,6 +1187,9 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl)
 
 	WARN_ON(wl->state != WL1271_STATE_ON);
 
+	/* we could be in ELP, so wakeup just in case */
+	wl1271_ps_elp_wakeup(wl, false);
+
 	/* enable dyn ps just in case (if left on due to fw crash etc) */
 	if (wl->bss_type == BSS_TYPE_STA_BSS)
 		ieee80211_enable_dyn_ps(wl->vif);
@@ -1208,7 +1218,9 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl)
 
 	/* let's notify MAC80211 about the remaining pending TX frames */
 	wl1271_tx_reset(wl);
+	wl1271_unclaim_io(wl);
 	wl1271_power_off(wl);
+	WARN_ON(wl->claim_count);
 
 	memset(wl->bssid, 0, ETH_ALEN);
 	memset(wl->ssid, 0, IW_ESSID_MAX_SIZE + 1);
diff --git a/drivers/net/wireless/wl12xx/ps.c b/drivers/net/wireless/wl12xx/ps.c
index 60a3738..6eff7ae 100644
--- a/drivers/net/wireless/wl12xx/ps.c
+++ b/drivers/net/wireless/wl12xx/ps.c
@@ -50,6 +50,7 @@ void wl1271_elp_work(struct work_struct *work)
 	wl1271_debug(DEBUG_PSM, "chip to elp");
 	wl1271_raw_write32(wl, HW_ACCESS_ELP_CTRL_REG_ADDR, ELPCTRL_SLEEP);
 	set_bit(WL1271_FLAG_IN_ELP, &wl->flags);
+	wl1271_unclaim_io(wl);
 
 out:
 	mutex_unlock(&wl->mutex);
@@ -92,7 +93,9 @@ int wl1271_ps_elp_wakeup(struct wl1271 *wl, bool chip_awake)
 		wl->elp_compl = &compl;
 	spin_unlock_irqrestore(&wl->wl_lock, flags);
 
+	wl1271_claim_io(wl);
 	wl1271_raw_write32(wl, HW_ACCESS_ELP_CTRL_REG_ADDR, ELPCTRL_WAKE_UP);
+	clear_bit(WL1271_FLAG_IN_ELP, &wl->flags);
 
 	if (!pending) {
 		ret = wait_for_completion_timeout(
@@ -108,8 +111,6 @@ int wl1271_ps_elp_wakeup(struct wl1271 *wl, bool chip_awake)
 		}
 	}
 
-	clear_bit(WL1271_FLAG_IN_ELP, &wl->flags);
-
 	wl1271_debug(DEBUG_PSM, "wakeup time: %u ms",
 		     jiffies_to_msecs(jiffies - start_time));
 	goto out;
diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/wl12xx/sdio.c
index d5e8748..45be0df 100644
--- a/drivers/net/wireless/wl12xx/sdio.c
+++ b/drivers/net/wireless/wl12xx/sdio.c
@@ -106,8 +106,7 @@ static void wl1271_sdio_raw_read(struct wl1271 *wl, int addr, void *buf,
 	int ret;
 	struct sdio_func *func = wl_to_func(wl);
 
-	sdio_claim_host(func);
-
+	wl1271_claim_io(wl);
 	if (unlikely(addr == HW_ACCESS_ELP_CTRL_REG_ADDR)) {
 		((u8 *)buf)[0] = sdio_f0_readb(func, addr, &ret);
 		wl1271_debug(DEBUG_SDIO, "sdio read 52 addr 0x%x, byte 0x%02x",
@@ -123,8 +122,7 @@ static void wl1271_sdio_raw_read(struct wl1271 *wl, int addr, void *buf,
 		wl1271_dump_ascii(DEBUG_SDIO, "data: ", buf, len);
 	}
 
-	sdio_release_host(func);
-
+	wl1271_unclaim_io(wl);
 	if (ret)
 		wl1271_error("sdio read failed (%d)", ret);
 }
@@ -135,8 +133,7 @@ static void wl1271_sdio_raw_write(struct wl1271 *wl, int addr, void *buf,
 	int ret;
 	struct sdio_func *func = wl_to_func(wl);
 
-	sdio_claim_host(func);
-
+	wl1271_claim_io(wl);
 	if (unlikely(addr == HW_ACCESS_ELP_CTRL_REG_ADDR)) {
 		sdio_f0_writeb(func, ((u8 *)buf)[0], addr, &ret);
 		wl1271_debug(DEBUG_SDIO, "sdio write 52 addr 0x%x, byte 0x%02x",
@@ -152,8 +149,7 @@ static void wl1271_sdio_raw_write(struct wl1271 *wl, int addr, void *buf,
 			ret = sdio_memcpy_toio(func, addr, buf, len);
 	}
 
-	sdio_release_host(func);
-
+	wl1271_unclaim_io(wl);
 	if (ret)
 		wl1271_error("sdio write failed (%d)", ret);
 }
@@ -168,9 +164,9 @@ static int wl1271_sdio_power_on(struct wl1271 *wl)
 	if (ret < 0)
 		goto out;
 
-	sdio_claim_host(func);
+	wl1271_claim_io(wl);
 	sdio_enable_func(func);
-	sdio_release_host(func);
+	wl1271_unclaim_io(wl);
 
 out:
 	return ret;
@@ -180,9 +176,9 @@ static int wl1271_sdio_power_off(struct wl1271 *wl)
 {
 	struct sdio_func *func = wl_to_func(wl);
 
-	sdio_claim_host(func);
+	wl1271_claim_io(wl);
 	sdio_disable_func(func);
-	sdio_release_host(func);
+	wl1271_unclaim_io(wl);
 
 	/* Power down the card */
 	return pm_runtime_put_sync(&func->dev);
@@ -196,6 +192,21 @@ static int wl1271_sdio_set_power(struct wl1271 *wl, bool enable)
 		return wl1271_sdio_power_off(wl);
 }
 
+static void wl1271_sdio_claim_io(struct wl1271 *wl)
+{
+	struct sdio_func *func = wl_to_func(wl);
+	if (!wl->claim_count++)
+		sdio_claim_host(func);
+}
+
+static void wl1271_sdio_unclaim_io(struct wl1271 *wl)
+{
+	struct sdio_func *func = wl_to_func(wl);
+	WARN_ON(wl->claim_count == 0);
+	if (--wl->claim_count == 0)
+		sdio_release_host(func);
+}
+
 static struct wl1271_if_operations sdio_ops = {
 	.read		= wl1271_sdio_raw_read,
 	.write		= wl1271_sdio_raw_write,
@@ -204,7 +215,10 @@ static struct wl1271_if_operations sdio_ops = {
 	.power		= wl1271_sdio_set_power,
 	.dev		= wl1271_sdio_wl_to_dev,
 	.enable_irq	= wl1271_sdio_enable_interrupts,
-	.disable_irq	= wl1271_sdio_disable_interrupts
+	.disable_irq	= wl1271_sdio_disable_interrupts,
+	.claim_io       = wl1271_sdio_claim_io,
+	.unclaim_io     = wl1271_sdio_unclaim_io,
+
 };
 
 static int __devinit wl1271_probe(struct sdio_func *func,
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index d1de13f..d67d6cf 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -263,6 +263,8 @@ struct wl1271_if_operations {
 	struct device* (*dev)(struct wl1271 *wl);
 	void (*enable_irq)(struct wl1271 *wl);
 	void (*disable_irq)(struct wl1271 *wl);
+	void (*claim_io)(struct wl1271 *wl);
+	void (*unclaim_io)(struct wl1271 *wl);
 };
 
 #define MAX_NUM_KEYS 14
@@ -457,6 +459,8 @@ struct wl1271 {
 
 	bool enable_11a;
 
+	int claim_count;
+
 	struct list_head list;
 
 	/* Most recently reported noise in dBm */
-- 
1.7.1

