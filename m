Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1705 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781Ab2KTHPH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 02:15:07 -0500
Message-ID: <50AB2DEF.9040602@broadcom.com> (sfid-20121120_081513_695483_91841B4A)
Date: Tue, 20 Nov 2012 08:14:55 +0100
From: "Piotr Haber" <phaber@broadcom.com>
MIME-Version: 1.0
To: "Mario De Chenno" <mario@dechenno.eu>
cc: linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com
Subject: Re: brcmsmac crash/disconects
References: <CANZhVKPJTapzHbu4iY_uC+uuwpn1XqraR6wpC8dn9+yNC55m1Q@mail.gmail.com>
In-Reply-To: <CANZhVKPJTapzHbu4iY_uC+uuwpn1XqraR6wpC8dn9+yNC55m1Q@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary=------------060509000808080704060104
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--------------060509000808080704060104
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit

On 11/19/12 23:10, Mario De Chenno wrote:
> Hi all,
> I cannot succeed getting a decent wireless connection with a Samsung 305U1A
> netbook.
> Wireless card is a Broadcom 4313. The card has been just in-warranty
> replaced but the issue still persists. Windows7 connection is stable, as it
> was before card replacement.
> OS is Slackware Linux 14. I tried stock kernel 3.2.29, then compiled
> 3.4.18, and finally latest compat-wireless sources (3.6.6). The issue is
> always the same: dmesg show timeouts and a driver crash.
> Sometimes I can associate with AP and navigate, but after a while
> connection drops and stays disconnected until reboot.
> I attach logs and configuration (with compat-3.6.6 modules). Let me know if
> I can help further.
> Mario De Chenno

Hi Mario,

thanks for detailed info, could you do 'lspci -vnn'?
And even more helpful would be applying attached patch and
sending us contents of /sys/kernel/debug/brcmsmac/bcma0:0/hardware.
Can you do that?

Kind regards
Piotr


--------------060509000808080704060104
Content-Type: text/plain;
 name=0001-brcmsmac-hardware-info-in-debugfs.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=0001-brcmsmac-hardware-info-in-debugfs.patch

>From ce70af80f87295d72556aadcfe59efea9c10f18a Mon Sep 17 00:00:00 2001
From: Piotr Haber <phaber@broadcom.com>
Date: Fri, 2 Nov 2012 11:15:20 +0100
Subject: [PATCH] brcmsmac: hardware info in debugfs

Put basic information about hardware in debugfs.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Piotr Haber <phaber@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/Makefile   |    3 +-
 drivers/net/wireless/brcm80211/brcmsmac/debug.c    |  113 ++++++++++++++++++++
 drivers/net/wireless/brcm80211/brcmsmac/debug.h    |   28 +++++
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    9 +-
 drivers/net/wireless/brcm80211/brcmsmac/pub.h      |    1 +
 5 files changed, 152 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/debug.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/debug.h

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/Makefile b/drivers/net/wireless/brcm80211/brcmsmac/Makefile
index e227c4c..d3d4151 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/Makefile
+++ b/drivers/net/wireless/brcm80211/brcmsmac/Makefile
@@ -40,7 +40,8 @@ BRCMSMAC_OFILES := \
 	phy/phytbl_n.o \
 	phy/phy_qmath.o \
 	dma.o \
-	brcms_trace_events.o
+	brcms_trace_events.o \
+	debug.o
 
 MODULEPFX := brcmsmac
 
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/debug.c b/drivers/net/wireless/brcm80211/brcmsmac/debug.c
new file mode 100644
index 0000000..d39387a
--- /dev/null
+++ b/drivers/net/wireless/brcm80211/brcmsmac/debug.c
@@ -0,0 +1,113 @@
+/*
+ * Copyright (c) 2012 Broadcom Corporation
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+ * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+ * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+ * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+#include <linux/debugfs.h>
+#include <linux/if_ether.h>
+#include <linux/if.h>
+#include <linux/netdevice.h>
+#include <linux/ieee80211.h>
+#include <linux/module.h>
+#include <linux/netdevice.h>
+#include <net/mac80211.h>
+
+#include <defs.h>
+#include <brcmu_wifi.h>
+#include <brcmu_utils.h>
+#include "debug.h"
+#include "main.h"
+
+static struct dentry *root_folder;
+
+void brcms_debugfs_init(void)
+{
+	root_folder = debugfs_create_dir(KBUILD_MODNAME, NULL);
+	if (IS_ERR(root_folder))
+		root_folder = NULL;
+}
+
+void brcms_debugfs_exit(void)
+{
+	if (!root_folder)
+		return;
+
+	debugfs_remove_recursive(root_folder);
+	root_folder = NULL;
+}
+
+int brcms_debugfs_attach(struct brcms_pub *drvr)
+{
+	if (!root_folder)
+		return -ENODEV;
+
+	drvr->dbgfs_dir = debugfs_create_dir(
+		 dev_name(&drvr->wlc->hw->d11core->dev), root_folder);
+	return PTR_RET(drvr->dbgfs_dir);
+}
+
+void brcms_debugfs_detach(struct brcms_pub *drvr)
+{
+	if (!IS_ERR_OR_NULL(drvr->dbgfs_dir))
+		debugfs_remove_recursive(drvr->dbgfs_dir);
+}
+
+struct dentry *brcms_debugfs_get_devdir(struct brcms_pub *drvr)
+{
+	return drvr->dbgfs_dir;
+}
+
+static
+ssize_t brcms_debugfs_hardware_read(struct file *f, char __user *data,
+					size_t count, loff_t *ppos)
+{
+	char buf[128];
+	int res;
+	struct brcms_pub *drvr = f->private_data;
+
+	/* only allow read from start */
+	if (*ppos > 0)
+		return 0;
+
+	res = scnprintf(buf, sizeof(buf),
+		"board vendor: %x\n"
+		"board type: %x\n"
+		"board revision: %x\n"
+		"board flags: %x\n"
+		"board flags2: %x\n"
+		"firmware revision: %x\n",
+		drvr->wlc->hw->d11core->bus->boardinfo.vendor,
+		drvr->wlc->hw->d11core->bus->boardinfo.type,
+		drvr->wlc->hw->boardrev,
+		drvr->wlc->hw->boardflags,
+		drvr->wlc->hw->boardflags2,
+		drvr->wlc->ucode_rev
+		);
+
+	return simple_read_from_buffer(data, count, ppos, buf, res);
+}
+
+static const struct file_operations brcms_debugfs_hardware_ops = {
+	.owner = THIS_MODULE,
+	.open = simple_open,
+	.read = brcms_debugfs_hardware_read
+};
+
+void brcms_debugfs_create_files(struct brcms_pub *drvr)
+{
+	struct dentry *dentry = drvr->dbgfs_dir;
+
+	if (!IS_ERR_OR_NULL(dentry))
+		debugfs_create_file("hardware", S_IRUGO, dentry,
+				    drvr, &brcms_debugfs_hardware_ops);
+}
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/debug.h b/drivers/net/wireless/brcm80211/brcmsmac/debug.h
new file mode 100644
index 0000000..894e17e
--- /dev/null
+++ b/drivers/net/wireless/brcm80211/brcmsmac/debug.h
@@ -0,0 +1,28 @@
+/*
+ * Copyright (c) 2010 Broadcom Corporation
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+ * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+ * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+ * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef _BRCMS_DBGFS_H_
+#define _BRCMS_DBGFS_H_
+#include "pub.h"
+
+struct brcms_pub;
+void brcms_debugfs_init(void);
+void brcms_debugfs_exit(void);
+int brcms_debugfs_attach(struct brcms_pub *drvr);
+void brcms_debugfs_detach(struct brcms_pub *drvr);
+struct dentry *brcms_debugfs_get_devdir(struct brcms_pub *drvr);
+void brcms_debugfs_create_files(struct brcms_pub *drvr);
+#endif				/* _BRCMS_DBGFS_H_ */
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index 0e234bd..cd3e7c7 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -33,6 +33,7 @@
 #include "ucode_loader.h"
 #include "mac80211_if.h"
 #include "main.h"
+#include "debug.h"
 
 #define N_TX_QUEUES	4 /* #tx queues on mac80211<->driver interface */
 #define BRCMS_FLUSH_TIMEOUT	100 /* msec */
@@ -861,8 +862,10 @@ static void brcms_free(struct brcms_info *wl)
 	/* kill dpc */
 	tasklet_kill(&wl->tasklet);
 
-	if (wl->pub)
+	if (wl->pub) {
+		brcms_debugfs_detach(wl->pub);
 		brcms_c_module_unregister(wl->pub, "linux", wl);
+	}
 
 	/* free common resources */
 	if (wl->wlc) {
@@ -1094,6 +1097,8 @@ static struct brcms_info *brcms_attach(struct bcma_device *pdev)
 	    regulatory_hint(wl->wiphy, wl->pub->srom_ccode))
 		wiphy_err(wl->wiphy, "%s: regulatory hint failed\n", __func__);
 
+	brcms_debugfs_attach(wl->pub);
+	brcms_debugfs_create_files(wl->pub);
 	n_adapters_found++;
 	return wl;
 
@@ -1207,6 +1212,7 @@ static int __init brcms_module_init(void)
 	if (msglevel != 0xdeadbeef)
 		brcm_msg_level = msglevel;
 #endif
+	brcms_debugfs_init();
 	if (!schedule_work(&brcms_driver_work))
 		return -EBUSY;
 
@@ -1224,6 +1230,7 @@ static void __exit brcms_module_exit(void)
 {
 	cancel_work_sync(&brcms_driver_work);
 	bcma_driver_unregister(&brcms_bcma_driver);
+	brcms_debugfs_exit();
 }
 
 module_init(brcms_module_init);
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/pub.h b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
index 5dbf9d1..9a68e46 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/pub.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
@@ -176,6 +176,7 @@ struct brcms_pub {
 	bool phy_11ncapable;	/* the PHY/HW is capable of 802.11N */
 
 	struct wl_cnt *_cnt;	/* low-level counters in driver */
+	struct dentry *dbgfs_dir;
 };
 
 enum wlc_par_id {
-- 
1.7.9.5


--------------060509000808080704060104--

