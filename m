Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33389 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761978AbcJaICm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 31 Oct 2016 04:02:42 -0400
Received: by mail-pf0-f196.google.com with SMTP id a136so4721965pfa.0
        for <linux-wireless@vger.kernel.org>; Mon, 31 Oct 2016 01:02:41 -0700 (PDT)
From: Xinming Hu <huxinming820@gmail.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Cathy Luo <cluo@marvell.com>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH 04/12] mwifiex: resolve races between async FW init (failure) and device removal
Date: Mon, 31 Oct 2016 16:02:12 +0800
Message-Id: <1477900940-10549-4-git-send-email-huxinming820@marvell.com> (sfid-20161031_090252_993655_9557BC69)
In-Reply-To: <1477900940-10549-1-git-send-email-huxinming820@marvell.com>
References: <1477900940-10549-1-git-send-email-huxinming820@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Brian Norris <briannorris@chromium.org>

It's possible for the FW init sequence to fail, which will trigger a
device cleanup sequence in mwifiex_fw_dpc(). This sequence can race with
device suspend() or remove() (e.g., reboot or unbind), and can trigger
use-after-free issues. Currently, this driver attempts (poorly) to
synchronize remove() using a semaphore, but it doesn't protect some of
the critical sections properly. Particularly, we grab a pointer to the
adapter struct (card->adapter) without checking if it's being freed or
not. We later do a NULL check on the adapter, but that doesn't work if
the adapter was freed.

Also note that the PCIe interface driver doesn't ever set card->adapter
to NULL, so even if we get the synchronization right, we still might try
to redo the cleanup in ->remove(), even if the FW init failure sequence
already did it.

This patch replaces the static semaphore with a per-device completion
struct, and uses that completion to synchronize the remove() thread with
the mwifiex_fw_dpc(). A future patch will utilize this completion to
synchronize the suspend() thread as well.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/marvell/mwifiex/main.c | 46 ++++++++++-------------------
 drivers/net/wireless/marvell/mwifiex/main.h | 10 +++++--
 drivers/net/wireless/marvell/mwifiex/pcie.c | 18 +++++------
 drivers/net/wireless/marvell/mwifiex/pcie.h |  2 ++
 drivers/net/wireless/marvell/mwifiex/sdio.c | 18 +++++------
 drivers/net/wireless/marvell/mwifiex/sdio.h |  2 ++
 drivers/net/wireless/marvell/mwifiex/usb.c  | 23 +++++++--------
 drivers/net/wireless/marvell/mwifiex/usb.h  |  2 ++
 8 files changed, 53 insertions(+), 68 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index f559ead..206be45 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -525,7 +525,6 @@ static void mwifiex_fw_dpc(const struct firmware *firmware, void *context)
 	struct mwifiex_private *priv;
 	struct mwifiex_adapter *adapter = context;
 	struct mwifiex_fw_image fw;
-	struct semaphore *sem = adapter->card_sem;
 	bool init_failed = false;
 	struct wireless_dev *wdev;
 
@@ -674,7 +673,8 @@ done:
 	}
 	if (init_failed)
 		mwifiex_free_adapter(adapter);
-	up(sem);
+	/* Tell all current and future waiters we're finished */
+	complete_all(adapter->fw_done);
 	return;
 }
 
@@ -1369,7 +1369,7 @@ static void mwifiex_main_work_queue(struct work_struct *work)
  * code is extracted from mwifiex_remove_card()
  */
 static int
-mwifiex_shutdown_sw(struct mwifiex_adapter *adapter, struct semaphore *sem)
+mwifiex_shutdown_sw(struct mwifiex_adapter *adapter)
 {
 	struct mwifiex_private *priv;
 	int i;
@@ -1377,8 +1377,9 @@ mwifiex_shutdown_sw(struct mwifiex_adapter *adapter, struct semaphore *sem)
 	if (!adapter)
 		goto exit_return;
 
-	if (down_interruptible(sem))
-		goto exit_sem_err;
+	wait_for_completion(adapter->fw_done);
+	/* Caller should ensure we aren't suspending while this happens */
+	reinit_completion(adapter->fw_done);
 
 	priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
 	mwifiex_deauthenticate(priv, NULL);
@@ -1435,8 +1436,6 @@ mwifiex_shutdown_sw(struct mwifiex_adapter *adapter, struct semaphore *sem)
 		rtnl_unlock();
 	}
 
-	up(sem);
-exit_sem_err:
 	mwifiex_dbg(adapter, INFO, "%s, successful\n", __func__);
 exit_return:
 	return 0;
@@ -1446,21 +1445,18 @@ exit_return:
  * code is extracted from mwifiex_add_card()
  */
 static int
-mwifiex_reinit_sw(struct mwifiex_adapter *adapter, struct semaphore *sem,
+mwifiex_reinit_sw(struct mwifiex_adapter *adapter, struct completion *fw_done,
 		  struct mwifiex_if_ops *if_ops, u8 iface_type)
 {
 	char fw_name[32];
 	struct pcie_service_card *card = adapter->card;
 
-	if (down_interruptible(sem))
-		goto exit_sem_err;
-
 	mwifiex_init_lock_list(adapter);
 	if (adapter->if_ops.up_dev)
 		adapter->if_ops.up_dev(adapter);
 
 	adapter->iface_type = iface_type;
-	adapter->card_sem = sem;
+	adapter->fw_done = fw_done;
 
 	adapter->hw_status = MWIFIEX_HW_STATUS_INITIALIZING;
 	adapter->surprise_removed = false;
@@ -1511,7 +1507,8 @@ mwifiex_reinit_sw(struct mwifiex_adapter *adapter, struct semaphore *sem,
 	}
 	strcpy(adapter->fw_name, fw_name);
 	mwifiex_dbg(adapter, INFO, "%s, successful\n", __func__);
-	up(sem);
+
+	complete_all(adapter->fw_done);
 	return 0;
 
 err_init_fw:
@@ -1531,8 +1528,7 @@ err_init_fw:
 err_kmalloc:
 	mwifiex_terminate_workqueue(adapter);
 	adapter->surprise_removed = true;
-	up(sem);
-exit_sem_err:
+	complete_all(adapter->fw_done);
 	mwifiex_dbg(adapter, INFO, "%s, error\n", __func__);
 
 	return -1;
@@ -1547,12 +1543,12 @@ void mwifiex_do_flr(struct mwifiex_adapter *adapter, bool prepare)
 	struct mwifiex_if_ops if_ops;
 
 	if (!prepare) {
-		mwifiex_reinit_sw(adapter, adapter->card_sem, &if_ops,
+		mwifiex_reinit_sw(adapter, adapter->fw_done, &if_ops,
 				  adapter->iface_type);
 	} else {
 		memcpy(&if_ops, &adapter->if_ops,
 		       sizeof(struct mwifiex_if_ops));
-		mwifiex_shutdown_sw(adapter, adapter->card_sem);
+		mwifiex_shutdown_sw(adapter);
 	}
 }
 EXPORT_SYMBOL_GPL(mwifiex_do_flr);
@@ -1571,21 +1567,18 @@ EXPORT_SYMBOL_GPL(mwifiex_do_flr);
  *      - Add logical interfaces
  */
 int
-mwifiex_add_card(void *card, struct semaphore *sem,
+mwifiex_add_card(void *card, struct completion *fw_done,
 		 struct mwifiex_if_ops *if_ops, u8 iface_type)
 {
 	struct mwifiex_adapter *adapter;
 
-	if (down_interruptible(sem))
-		goto exit_sem_err;
-
 	if (mwifiex_register(card, if_ops, (void **)&adapter)) {
 		pr_err("%s: software init failed\n", __func__);
 		goto err_init_sw;
 	}
 
 	adapter->iface_type = iface_type;
-	adapter->card_sem = sem;
+	adapter->fw_done = fw_done;
 
 	adapter->hw_status = MWIFIEX_HW_STATUS_INITIALIZING;
 	adapter->surprise_removed = false;
@@ -1654,9 +1647,7 @@ err_kmalloc:
 	mwifiex_free_adapter(adapter);
 
 err_init_sw:
-	up(sem);
 
-exit_sem_err:
 	return -1;
 }
 EXPORT_SYMBOL_GPL(mwifiex_add_card);
@@ -1672,14 +1663,11 @@ EXPORT_SYMBOL_GPL(mwifiex_add_card);
  *      - Unregister the device
  *      - Free the adapter structure
  */
-int mwifiex_remove_card(struct mwifiex_adapter *adapter, struct semaphore *sem)
+int mwifiex_remove_card(struct mwifiex_adapter *adapter)
 {
 	struct mwifiex_private *priv = NULL;
 	int i;
 
-	if (down_trylock(sem))
-		goto exit_sem_err;
-
 	if (!adapter)
 		goto exit_remove;
 
@@ -1749,8 +1737,6 @@ int mwifiex_remove_card(struct mwifiex_adapter *adapter, struct semaphore *sem)
 	mwifiex_free_adapter(adapter);
 
 exit_remove:
-	up(sem);
-exit_sem_err:
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mwifiex_remove_card);
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index 7f67f23..bbd8d63 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -20,6 +20,7 @@
 #ifndef _MWIFIEX_MAIN_H_
 #define _MWIFIEX_MAIN_H_
 
+#include <linux/completion.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/sched.h>
@@ -985,7 +986,10 @@ struct mwifiex_adapter {
 	u32 usr_dot_11ac_mcs_support;
 
 	atomic_t pending_bridged_pkts;
-	struct semaphore *card_sem;
+
+	/* For synchronizing FW initialization with device lifecycle. */
+	struct completion *fw_done;
+
 	bool ext_scan;
 	u8 fw_api_ver;
 	u8 key_api_major_ver, key_api_minor_ver;
@@ -1413,8 +1417,8 @@ static inline u8 mwifiex_is_tdls_link_setup(u8 status)
 
 int mwifiex_init_shutdown_fw(struct mwifiex_private *priv,
 			     u32 func_init_shutdown);
-int mwifiex_add_card(void *, struct semaphore *, struct mwifiex_if_ops *, u8);
-int mwifiex_remove_card(struct mwifiex_adapter *, struct semaphore *);
+int mwifiex_add_card(void *, struct completion *, struct mwifiex_if_ops *, u8);
+int mwifiex_remove_card(struct mwifiex_adapter *);
 
 void mwifiex_get_version(struct mwifiex_adapter *adapter, char *version,
 			 int maxlen);
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index e6bea02..5507c89 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -35,8 +35,6 @@ static u8 user_rmmod;
 
 static struct mwifiex_if_ops pcie_ops;
 
-static struct semaphore add_remove_card_sem;
-
 static int
 mwifiex_map_pci_memory(struct mwifiex_adapter *adapter, struct sk_buff *skb,
 		       size_t size, int flags)
@@ -193,6 +191,8 @@ static int mwifiex_pcie_probe(struct pci_dev *pdev,
 	if (!card)
 		return -ENOMEM;
 
+	init_completion(&card->fw_done);
+
 	card->dev = pdev;
 
 	if (ent->driver_data) {
@@ -206,7 +206,7 @@ static int mwifiex_pcie_probe(struct pci_dev *pdev,
 		card->pcie.can_ext_scan = data->can_ext_scan;
 	}
 
-	if (mwifiex_add_card(card, &add_remove_card_sem, &pcie_ops,
+	if (mwifiex_add_card(card, &card->fw_done, &pcie_ops,
 			     MWIFIEX_PCIE)) {
 		pr_err("%s failed\n", __func__);
 		return -1;
@@ -228,6 +228,8 @@ static void mwifiex_pcie_remove(struct pci_dev *pdev)
 	if (!card)
 		return;
 
+	wait_for_completion(&card->fw_done);
+
 	adapter = card->adapter;
 	if (!adapter || !adapter->priv_num)
 		return;
@@ -247,7 +249,7 @@ static void mwifiex_pcie_remove(struct pci_dev *pdev)
 		mwifiex_init_shutdown_fw(priv, MWIFIEX_FUNC_SHUTDOWN);
 	}
 
-	mwifiex_remove_card(card->adapter, &add_remove_card_sem);
+	mwifiex_remove_card(adapter);
 }
 
 static void mwifiex_pcie_shutdown(struct pci_dev *pdev)
@@ -3151,8 +3153,7 @@ static struct mwifiex_if_ops pcie_ops = {
 /*
  * This function initializes the PCIE driver module.
  *
- * This initiates the semaphore and registers the device with
- * PCIE bus.
+ * This registers the device with PCIE bus.
  */
 static int mwifiex_pcie_init_module(void)
 {
@@ -3160,8 +3161,6 @@ static int mwifiex_pcie_init_module(void)
 
 	pr_debug("Marvell PCIe Driver\n");
 
-	sema_init(&add_remove_card_sem, 1);
-
 	/* Clear the flag in case user removes the card. */
 	user_rmmod = 0;
 
@@ -3185,9 +3184,6 @@ static int mwifiex_pcie_init_module(void)
  */
 static void mwifiex_pcie_cleanup_module(void)
 {
-	if (!down_interruptible(&add_remove_card_sem))
-		up(&add_remove_card_sem);
-
 	/* Set the flag as user is removing this module. */
 	user_rmmod = 1;
 
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.h b/drivers/net/wireless/marvell/mwifiex/pcie.h
index 46f99ca..ae3365d 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.h
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.h
@@ -22,6 +22,7 @@
 #ifndef	_MWIFIEX_PCIE_H
 #define	_MWIFIEX_PCIE_H
 
+#include    <linux/completion.h>
 #include    <linux/pci.h>
 #include    <linux/interrupt.h>
 
@@ -345,6 +346,7 @@ struct pcie_service_card {
 	struct pci_dev *dev;
 	struct mwifiex_adapter *adapter;
 	struct mwifiex_pcie_device pcie;
+	struct completion fw_done;
 
 	u8 txbd_flush;
 	u32 txbd_wrptr;
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index f04cf5a..1f6ebde 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -49,8 +49,6 @@ static u8 user_rmmod;
 static struct mwifiex_if_ops sdio_ops;
 static unsigned long iface_work_flags;
 
-static struct semaphore add_remove_card_sem;
-
 static struct memory_type_mapping generic_mem_type_map[] = {
 	{"DUMP", NULL, 0, 0xDD},
 };
@@ -156,6 +154,8 @@ mwifiex_sdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
 	if (!card)
 		return -ENOMEM;
 
+	init_completion(&card->fw_done);
+
 	card->func = func;
 	card->device_id = id;
 
@@ -197,7 +197,7 @@ mwifiex_sdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
 		}
 	}
 
-	ret = mwifiex_add_card(card, &add_remove_card_sem, &sdio_ops,
+	ret = mwifiex_add_card(card, &card->fw_done, &sdio_ops,
 			       MWIFIEX_SDIO);
 	if (ret) {
 		dev_err(&func->dev, "add card failed\n");
@@ -283,6 +283,8 @@ mwifiex_sdio_remove(struct sdio_func *func)
 	if (!card)
 		return;
 
+	wait_for_completion(&card->fw_done);
+
 	adapter = card->adapter;
 	if (!adapter || !adapter->priv_num)
 		return;
@@ -300,7 +302,7 @@ mwifiex_sdio_remove(struct sdio_func *func)
 		mwifiex_init_shutdown_fw(priv, MWIFIEX_FUNC_SHUTDOWN);
 	}
 
-	mwifiex_remove_card(card->adapter, &add_remove_card_sem);
+	mwifiex_remove_card(adapter);
 }
 
 /*
@@ -2771,14 +2773,11 @@ static struct mwifiex_if_ops sdio_ops = {
 /*
  * This function initializes the SDIO driver.
  *
- * This initiates the semaphore and registers the device with
- * SDIO bus.
+ * This registers the device with SDIO bus.
  */
 static int
 mwifiex_sdio_init_module(void)
 {
-	sema_init(&add_remove_card_sem, 1);
-
 	/* Clear the flag in case user removes the card. */
 	user_rmmod = 0;
 
@@ -2797,9 +2796,6 @@ mwifiex_sdio_init_module(void)
 static void
 mwifiex_sdio_cleanup_module(void)
 {
-	if (!down_interruptible(&add_remove_card_sem))
-		up(&add_remove_card_sem);
-
 	/* Set the flag as user is removing this module. */
 	user_rmmod = 1;
 	cancel_work_sync(&sdio_work);
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.h b/drivers/net/wireless/marvell/mwifiex/sdio.h
index db837f1..cc0aac8 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.h
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.h
@@ -21,6 +21,7 @@
 #define	_MWIFIEX_SDIO_H
 
 
+#include <linux/completion.h>
 #include <linux/mmc/sdio.h>
 #include <linux/mmc/sdio_ids.h>
 #include <linux/mmc/sdio_func.h>
@@ -244,6 +245,7 @@ struct sdio_mmc_card {
 	struct mwifiex_adapter *adapter;
 	struct device_node *plt_of_node;
 	struct mwifiex_plt_wake_cfg *plt_wake_cfg;
+	struct completion fw_done;
 
 	const char *firmware;
 	const struct mwifiex_sdio_card_reg *reg;
diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
index 57ed834..c20ff2f 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.c
+++ b/drivers/net/wireless/marvell/mwifiex/usb.c
@@ -24,7 +24,6 @@
 
 static u8 user_rmmod;
 static struct mwifiex_if_ops usb_ops;
-static struct semaphore add_remove_card_sem;
 
 static struct usb_device_id mwifiex_usb_table[] = {
 	/* 8766 */
@@ -386,6 +385,8 @@ static int mwifiex_usb_probe(struct usb_interface *intf,
 	if (!card)
 		return -ENOMEM;
 
+	init_completion(&card->fw_done);
+
 	id_vendor = le16_to_cpu(udev->descriptor.idVendor);
 	id_product = le16_to_cpu(udev->descriptor.idProduct);
 	bcd_device = le16_to_cpu(udev->descriptor.bcdDevice);
@@ -475,7 +476,7 @@ static int mwifiex_usb_probe(struct usb_interface *intf,
 
 	usb_set_intfdata(intf, card);
 
-	ret = mwifiex_add_card(card, &add_remove_card_sem, &usb_ops,
+	ret = mwifiex_add_card(card, &card->fw_done, &usb_ops,
 			       MWIFIEX_USB);
 	if (ret) {
 		pr_err("%s: mwifiex_add_card failed: %d\n", __func__, ret);
@@ -601,13 +602,15 @@ static void mwifiex_usb_disconnect(struct usb_interface *intf)
 	struct usb_card_rec *card = usb_get_intfdata(intf);
 	struct mwifiex_adapter *adapter;
 
-	if (!card || !card->adapter) {
-		pr_err("%s: card or card->adapter is NULL\n", __func__);
+	if (!card) {
+		dev_err(&intf->dev, "%s: card is NULL\n", __func__);
 		return;
 	}
 
+	wait_for_completion(&card->fw_done);
+
 	adapter = card->adapter;
-	if (!adapter->priv_num)
+	if (!adapter || !adapter->priv_num)
 		return;
 
 	if (user_rmmod && !adapter->mfg_mode) {
@@ -627,7 +630,7 @@ static void mwifiex_usb_disconnect(struct usb_interface *intf)
 
 	mwifiex_dbg(adapter, FATAL,
 		    "%s: removing card\n", __func__);
-	mwifiex_remove_card(adapter, &add_remove_card_sem);
+	mwifiex_remove_card(adapter);
 
 	usb_put_dev(interface_to_usbdev(intf));
 }
@@ -1201,8 +1204,7 @@ static struct mwifiex_if_ops usb_ops = {
 
 /* This function initializes the USB driver module.
  *
- * This initiates the semaphore and registers the device with
- * USB bus.
+ * This registers the device with USB bus.
  */
 static int mwifiex_usb_init_module(void)
 {
@@ -1210,8 +1212,6 @@ static int mwifiex_usb_init_module(void)
 
 	pr_debug("Marvell USB8797 Driver\n");
 
-	sema_init(&add_remove_card_sem, 1);
-
 	ret = usb_register(&mwifiex_usb_driver);
 	if (ret)
 		pr_err("Driver register failed!\n");
@@ -1231,9 +1231,6 @@ static int mwifiex_usb_init_module(void)
  */
 static void mwifiex_usb_cleanup_module(void)
 {
-	if (!down_interruptible(&add_remove_card_sem))
-		up(&add_remove_card_sem);
-
 	/* set the flag as user is removing this module */
 	user_rmmod = 1;
 
diff --git a/drivers/net/wireless/marvell/mwifiex/usb.h b/drivers/net/wireless/marvell/mwifiex/usb.h
index 30e8eb8..e5f204e 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.h
+++ b/drivers/net/wireless/marvell/mwifiex/usb.h
@@ -20,6 +20,7 @@
 #ifndef _MWIFIEX_USB_H
 #define _MWIFIEX_USB_H
 
+#include <linux/completion.h>
 #include <linux/usb.h>
 
 #define USB8XXX_VID		0x1286
@@ -75,6 +76,7 @@ struct usb_card_rec {
 	struct mwifiex_adapter *adapter;
 	struct usb_device *udev;
 	struct usb_interface *intf;
+	struct completion fw_done;
 	u8 rx_cmd_ep;
 	struct urb_context rx_cmd;
 	atomic_t rx_cmd_urb_pending;
-- 
1.8.1.4
