Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:12271 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591AbZLHHfl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2009 02:35:41 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 07 Dec 2009 23:35:48 -0800
Date: Tue, 8 Dec 2009 13:05:42 +0530
From: Bala Shanmugam <sbalashanmugam@atheros.com>
To: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	<mcgrof@bombadil.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <linux-bluetooth@vger.kernel.org>
Subject: [PATCH] Added compat-bluetooth to compat-wireless-2.6
Message-ID: <20091208073542.GC22204@atheros-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Added compat-bluetooth to compat-wireless-2.6

Added new scripts to load and unload wireless
and bluetooth modules seperately.

Compat is compiled as separate kernel module as
both wireless and bluetooth modules require it.

Compat Bluetooth has support to compile latest bluetooth code
for kernel versions 2.6.27 to 2.6.31.
Signed-off-by: Bala Shanmugam <sbalashanmugam@atheros.com>
---
 Makefile                                    |   46 ++-
 compat/patches/16-compat.patch              |  340 ++++++++++++++++
 compat/patches/17-bluetooth.patch           |  528 +++++++++++++++++++++++++++
 compat/patches/98-add-compat-wireless.patch |   20 -
 config.mk                                   |   12 +
 scripts/admin-clean.sh                      |    2 +-
 scripts/admin-update.sh                     |   82 ++++-
 scripts/btload.sh                           |   10 +
 scripts/btunload.sh                         |   13 +
 scripts/load.sh                             |    4 +
 scripts/unload.sh                           |    4 +
 scripts/wlload.sh                           |   22 ++
 scripts/wlunload.sh                         |   54 +++
 13 files changed, 1081 insertions(+), 31 deletions(-)
 create mode 100644 compat/patches/16-compat.patch
 create mode 100644 compat/patches/17-bluetooth.patch
 create mode 100755 scripts/btload.sh
 create mode 100755 scripts/btunload.sh
 create mode 100755 scripts/wlload.sh
 create mode 100755 scripts/wlunload.sh

diff --git a/Makefile b/Makefile
index 150d4be..1658ac8 100644
--- a/Makefile
+++ b/Makefile
@@ -19,14 +19,15 @@ include $(M)/$(COMPAT_CONFIG)
 
 NOSTDINC_FLAGS := -I$(M)/include/ -include $(M)/include/net/compat.h $(CFLAGS)
 
-obj-y := net/wireless/ net/mac80211/ net/rfkill/
+obj-y := net/bluetooth/ net/compat/ net/wireless/ net/mac80211/ net/rfkill/
 ifeq ($(ONLY_CORE),)
 obj-m += \
 	drivers/ssb/ \
 	drivers/misc/eeprom/ \
 	drivers/net/ \
 	drivers/net/usb/ \
-	drivers/net/wireless/
+	drivers/net/wireless/ \
+	drivers/bluetooth/
 endif
 
 else
@@ -163,12 +164,25 @@ install-scripts:
 	@$(MODPROBE) -l usb8xxx
 	@$(MODPROBE) -l usbnet
 	@$(MODPROBE) -l zd1211rw
+	@echo
+	@echo "Currently detected bluetooth subsystem modules:"
+	@echo
+	@$(MODPROBE) -l sco
+	@$(MODPROBE) -l l2cap
+	@$(MODPROBE) -l hidp
+	@$(MODPROBE) -l rfcomm
+	@$(MODPROBE) -l bnep
+	@$(MODPROBE) -l btusb
+	@$(MODPROBE) -l bluetooth
 	@echo 
 	@echo Now run:
 	@echo 
-	@echo make unload
+	@echo sudo make unload to unload both wireless and bluetooth modules
+	@echo sudo make wlunload to unload wireless modules
+	@echo sudo make btunload to unload bluetooth modules
 	@echo
-	@echo And then load the wireless module you need. If unsure reboot.
+	@echo And then load the wireless or bluetooth module you need. If unsure reboot.
+	@echo Alternatively use "sudo make load/wlload/btload" to load modules
 	@echo
 
 uninstall:
@@ -239,6 +253,16 @@ uninstall:
 	@$(MODPROBE) -l usb8xxx
 	@$(MODPROBE) -l usbnet
 	@$(MODPROBE) -l zd1211rw
+	@echo
+	@echo "Your old bluetooth subsystem modules were left intact:"
+	@echo
+	@$(MODPROBE) -l sco
+	@$(MODPROBE) -l l2cap
+	@$(MODPROBE) -l hidp
+	@$(MODPROBE) -l rfcomm
+	@$(MODPROBE) -l bnep
+	@$(MODPROBE) -l btusb
+	@$(MODPROBE) -l bluetooth
 	@
 	@echo 
 
@@ -253,7 +277,19 @@ unload:
 load: unload
 	@./scripts/load.sh
 
-.PHONY: all clean install uninstall unload load
+btunload:
+	@./scripts/btunload.sh
+
+btload: btunload
+	@./scripts/btload.sh
+
+wlunload:
+	@./scripts/wlunload.sh
+
+wlload: wlunload
+	@./scripts/wlload.sh
+
+.PHONY: all clean install uninstall unload load btunload btload wlunload wlload
 
 endif
 
diff --git a/compat/patches/16-compat.patch b/compat/patches/16-compat.patch
new file mode 100644
index 0000000..8ee56c0
--- /dev/null
+++ b/compat/patches/16-compat.patch
@@ -0,0 +1,340 @@
+diff -Nur orig_com/include/net/compat-2.6.28.h mod_com/include/net/compat-2.6.28.h
+--- orig_com/include/net/compat-2.6.28.h	2009-12-03 16:33:59.000000000 +0530
++++ mod_com/include/net/compat-2.6.28.h	2009-12-03 16:59:00.000000000 +0530
+@@ -36,6 +36,16 @@
+ #define pcmcia_parse_tuple(tuple, parse) pccard_parse_tuple(tuple, parse)
+ #endif
+
++/* From : include/pcmcia/ds.h */
++/* loop CIS entries for valid configuration */
++int pcmcia_loop_config(struct pcmcia_device *p_dev,
++		       int	(*conf_check)	(struct pcmcia_device *p_dev,
++						 cistpl_cftable_entry_t *cfg,
++						 cistpl_cftable_entry_t *dflt,
++						 unsigned int vcc,
++						 void *priv_data),
++		       void *priv_data);
++
+ #if 0
+ extern void usb_poison_urb(struct urb *urb);
+ #endif
+@@ -145,6 +155,20 @@
+	}
+ } /* From include/linux/skbuff.h */
+
++/**
++ *	skb_queue_splice_tail - join two skb lists, each list being a queue
++ *	@list: the new list to add
++ *	@head: the place to add it in the first list
++ */
++static inline void skb_queue_splice_tail(const struct sk_buff_head *list,
++					 struct sk_buff_head *head)
++{
++	if (!skb_queue_empty(list)) {
++		__skb_queue_splice(list, head->prev, (struct sk_buff *) head);
++		head->qlen += list->qlen;
++	}
++}
++
+ #ifndef DECLARE_TRACE
+
+ #define TP_PROTO(args...)	args
+@@ -177,6 +201,9 @@
+
+ unsigned long round_jiffies_up(unsigned long j);
+
++extern void skb_add_rx_frag(struct sk_buff *skb, int i, struct page *page,
++			    int off, int size);
++
+ #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28)) */
+
+ #endif /* LINUX_26_28_COMPAT_H */
+diff -Nur orig_com/include/net/compat-2.6.30.h mod_com/include/net/compat-2.6.30.h
+--- orig_com/include/net/compat-2.6.30.h	2009-12-03 16:34:27.000000000 +0530
++++ mod_com/include/net/compat-2.6.30.h	2009-12-03 16:39:53.000000000 +0530
+@@ -15,6 +15,15 @@
+
+ #define IRQ_WAKE_THREAD	(2)
+
++/* From : include/linux/pm.h */
++/* How to reorder dpm_list after device_move() */
++enum dpm_order {
++	DPM_ORDER_NONE,
++	DPM_ORDER_DEV_AFTER_PARENT,
++	DPM_ORDER_PARENT_BEFORE_DEV,
++	DPM_ORDER_DEV_LAST,
++};
++
+ #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30)) */
+
+ #endif /* LINUX_26_30_COMPAT_H */
+diff -Nur orig_com/include/net/compat-2.6.31.h mod_com/include/net/compat-2.6.31.h
+--- orig_com/include/net/compat-2.6.31.h	2009-12-03 11:17:03.000000000 +0530
++++ mod_com/include/net/compat-2.6.31.h	2009-12-03 13:29:41.000000000 +0530
+@@ -11,6 +11,7 @@
+ #include <linux/interrupt.h>
+ #include <net/dst.h>
+ #include <net/genetlink.h>
++#include <linux/ethtool.h>
+
+ /*
+  * These macros allow us to backport rfkill without any
+@@ -106,7 +107,7 @@
+
+ static inline void skb_dst_set(struct sk_buff *skb, struct dst_entry *dst)
+ {
+-	skb->dst = (unsigned long)dst;
++	skb->dst = dst;
+ }
+
+ static inline struct rtable *skb_rtable(const struct sk_buff *skb)
+diff -Nur orig_com/include/net/compat-2.6.32.h mod_com/include/net/compat-2.6.32.h
+--- orig_com/include/net/compat-2.6.32.h	2009-12-03 11:17:03.000000000 +0530
++++ mod_com/include/net/compat-2.6.32.h	2009-12-03 17:14:29.000000000 +0530
+@@ -43,8 +43,34 @@
+ typedef enum netdev_tx netdev_tx_t;
+ #endif /* __KERNEL__ */
+
++/*
++ * dev_pm_ops is only available on kernels >= 2.6.29, for
++ * older kernels we rely on reverting the work to old
++ * power management style stuff.
++ */
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
++/*
++ * Use this if you want to use the same suspend and resume callbacks for suspend
++ * to RAM and hibernation.
++ */
++#define SIMPLE_DEV_PM_OPS(name, suspend_fn, resume_fn) \
++struct dev_pm_ops name = { \
++	.suspend = suspend_fn, \
++	.resume = resume_fn, \
++	.freeze = suspend_fn, \
++	.thaw = resume_fn, \
++	.poweroff = suspend_fn, \
++	.restore = resume_fn, \
++}
++#else
++#define SIMPLE_DEV_PM_OPS(name, suspend_fn, resume_fn)
++#endif /* >= 2.6.29 */
++
+ #define wireless_send_event(a, b, c, d) wireless_send_event(a, b, c, (char * ) d)
+
++/* The export symbol in changed in compat/patches/15-symbol-export-conflicts.patch */
++#define ieee80211_rx(hw, skb) mac80211_ieee80211_rx(hw, skb)
++
+ #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,32)) */
+
+ #endif /* LINUX_26_32_COMPAT_H */
+diff -Nur orig_com/include/net/compat.h mod_com/include/net/compat.h
+--- orig_com/include/net/compat.h	2009-12-03 14:10:50.000000000 +0530
++++ mod_com/include/net/compat.h	2009-12-03 14:12:00.000000000 +0530
+@@ -3,26 +3,24 @@
+
+ #include <linux/autoconf.h>
+ #include <linux/version.h>
++#include <linux/compat_autoconf.h>
+
+ /*
+  * Each compat file represents compatibility code for new kernel
+  * code introduced for *that* kernel revision.
+  */
+
+-#include "compat-2.6.14.h"
+-#include "compat-2.6.18.h"
+-#include "compat-2.6.19.h"
+-#include "compat-2.6.21.h"
+-#include "compat-2.6.22.h"
+-#include "compat-2.6.23.h"
+-#include "compat-2.6.24.h"
+-#include "compat-2.6.25.h"
+-#include "compat-2.6.26.h"
+-#include "compat-2.6.27.h"
+-#include "compat-2.6.28.h"
+-#include "compat-2.6.29.h"
+-#include "compat-2.6.30.h"
+-#include "compat-2.6.31.h"
+-#include "compat-2.6.32.h"
++#include <net/compat-2.6.22.h>
++#include <net/compat-2.6.23.h>
++#include <net/compat-2.6.24.h>
++#include <net/compat-2.6.25.h>
++#include <net/compat-2.6.26.h>
++#include <net/compat-2.6.27.h>
++#include <net/compat-2.6.28.h>
++#include <net/compat-2.6.29.h>
++#include <net/compat-2.6.30.h>
++#include <net/compat-2.6.31.h>
++#include <net/compat-2.6.32.h>
++#include <net/compat-2.6.33.h>
+
+ #endif /* LINUX_26_COMPAT_H */
+diff -Nur orig_com/net/compat/compat-2.6.27.c mod_com/net/compat/compat-2.6.27.c
+--- orig_com/net/compat/compat-2.6.27.c	2009-12-03 11:16:30.000000000 +0530
++++ mod_com/net/compat/compat-2.6.27.c	2009-12-03 12:48:22.000000000 +0530
+@@ -8,7 +8,7 @@
+  * Compatibility file for Linux wireless for kernels 2.6.27
+  */
+
+-#include "compat.h"
++#include <net/compat.h>
+
+ #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,27))
+
+diff -Nur orig_com/net/compat/compat-2.6.28.c mod_com/net/compat/compat-2.6.28.c
+--- orig_com/net/compat/compat-2.6.28.c	2009-12-03 16:32:54.000000000 +0530
++++ mod_com/net/compat/compat-2.6.28.c	2009-12-03 17:08:15.000000000 +0530
+@@ -8,7 +8,7 @@
+  * Compatibility file for Linux wireless for kernels 2.6.28.
+  */
+
+-#include "compat.h"
++#include <net/compat.h>
+
+ #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28))
+
+@@ -84,6 +84,81 @@
+ EXPORT_SYMBOL_GPL(usb_poison_urb);
+ #endif
+
++#include <pcmcia/ds.h>
++struct pcmcia_cfg_mem {
++	tuple_t tuple;
++	cisparse_t parse;
++	u8 buf[256];
++	cistpl_cftable_entry_t dflt;
++};
++/**
++ * pcmcia_loop_config() - loop over configuration options
++ * @p_dev:	the struct pcmcia_device which we need to loop for.
++ * @conf_check:	function to call for each configuration option.
++ *		It gets passed the struct pcmcia_device, the CIS data
++ *		describing the configuration option, and private data
++ *		being passed to pcmcia_loop_config()
++ * @priv_data:	private data to be passed to the conf_check function.
++ *
++ * pcmcia_loop_config() loops over all configuration options, and calls
++ * the driver-specific conf_check() for each one, checking whether
++ * it is a valid one. Returns 0 on success or errorcode otherwise.
++ */
++int pcmcia_loop_config(struct pcmcia_device *p_dev,
++		       int	(*conf_check)	(struct pcmcia_device *p_dev,
++						 cistpl_cftable_entry_t *cfg,
++						 cistpl_cftable_entry_t *dflt,
++						 unsigned int vcc,
++						 void *priv_data),
++		       void *priv_data)
++{
++	struct pcmcia_cfg_mem *cfg_mem;
++
++	tuple_t *tuple;
++	int ret;
++	unsigned int vcc;
++
++	cfg_mem = kzalloc(sizeof(struct pcmcia_cfg_mem), GFP_KERNEL);
++	if (cfg_mem == NULL)
++		return -ENOMEM;
++
++	/* get the current Vcc setting */
++	vcc = p_dev->socket->socket.Vcc;
++
++	tuple = &cfg_mem->tuple;
++	tuple->TupleData = cfg_mem->buf;
++	tuple->TupleDataMax = 255;
++	tuple->TupleOffset = 0;
++	tuple->DesiredTuple = CISTPL_CFTABLE_ENTRY;
++	tuple->Attributes = 0;
++
++	ret = pcmcia_get_first_tuple(p_dev, tuple);
++	while (!ret) {
++		cistpl_cftable_entry_t *cfg = &cfg_mem->parse.cftable_entry;
++
++		if (pcmcia_get_tuple_data(p_dev, tuple))
++			goto next_entry;
++
++		if (pcmcia_parse_tuple(tuple, &cfg_mem->parse))
++			goto next_entry;
++
++		/* default values */
++		p_dev->conf.ConfigIndex = cfg->index;
++		if (cfg->flags & CISTPL_CFTABLE_DEFAULT)
++			cfg_mem->dflt = *cfg;
++
++		ret = conf_check(p_dev, cfg, &cfg_mem->dflt, vcc, priv_data);
++		if (!ret)
++			break;
++
++next_entry:
++		ret = pcmcia_get_next_tuple(p_dev, tuple);
++	}
++
++	return ret;
++}
++EXPORT_SYMBOL(pcmcia_loop_config);
++
+ void usb_unpoison_urb(struct urb *urb)
+ {
+ #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,28))
+@@ -275,4 +350,14 @@
+ }
+ EXPORT_SYMBOL_GPL(round_jiffies_up);
+
++void skb_add_rx_frag(struct sk_buff *skb, int i, struct page *page, int off,
++		int size)
++{
++	skb_fill_page_desc(skb, i, page, off, size);
++	skb->len += size;
++	skb->data_len += size;
++	skb->truesize += size;
++}
++EXPORT_SYMBOL(skb_add_rx_frag);
++
+ #endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28) */
+diff -Nur orig_com/net/compat/compat-2.6.29.c mod_com/net/compat/compat-2.6.29.c
+--- orig_com/net/compat/compat-2.6.29.c	2009-12-03 11:16:30.000000000 +0530
++++ mod_com/net/compat/compat-2.6.29.c	2009-12-03 12:48:22.000000000 +0530
+@@ -8,7 +8,7 @@
+  * Compatibility file for Linux wireless for kernels 2.6.29.
+  */
+
+-#include "compat.h"
++#include <net/compat.h>
+
+ #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29))
+
+diff -Nur orig_com/net/compat/compat-2.6.30.c mod_com/net/compat/compat-2.6.30.c
+--- orig_com/net/compat/compat-2.6.30.c	2009-12-03 11:16:30.000000000 +0530
++++ mod_com/net/compat/compat-2.6.30.c	2009-12-03 12:48:22.000000000 +0530
+@@ -8,7 +8,7 @@
+  * Compatibility file for Linux wireless for kernels 2.6.30.
+  */
+
+-#include "compat.h"
++#include <net/compat.h>
+
+ #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
+
+diff -Nur orig_com/net/compat/compat-2.6.31.c mod_com/net/compat/compat-2.6.31.c
+--- orig_com/net/compat/compat-2.6.31.c	2009-12-03 11:16:30.000000000 +0530
++++ mod_com/net/compat/compat-2.6.31.c	2009-12-03 12:48:22.000000000 +0530
+@@ -8,7 +8,7 @@
+  * Compatibility file for Linux wireless for kernels 2.6.31.
+  */
+
+-#include "compat.h"
++#include <net/compat.h>
+
+ #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31))
+
+diff -Nur orig_com/net/compat/compat-2.6.32.c mod_com/net/compat/compat-2.6.32.c
+--- orig_com/net/compat/compat-2.6.32.c	2009-12-03 11:16:30.000000000 +0530
++++ mod_com/net/compat/compat-2.6.32.c	2009-12-03 12:48:22.000000000 +0530
+@@ -8,7 +8,7 @@
+  * Compatibility file for Linux wireless for kernels 2.6.32.
+  */
+
+-#include "compat.h"
++#include <net/compat.h>
+
+ #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,32))
+
diff --git a/compat/patches/17-bluetooth.patch b/compat/patches/17-bluetooth.patch
new file mode 100644
index 0000000..87545f5
--- /dev/null
+++ b/compat/patches/17-bluetooth.patch
@@ -0,0 +1,528 @@
+diff -Nur a/drivers/bluetooth/hci_ldisc.c b/drivers/bluetooth/hci_ldisc.c
+--- a/drivers/bluetooth/hci_ldisc.c	2009-11-25 11:24:32.000000000 +0530
++++ b/drivers/bluetooth/hci_ldisc.c	2009-11-28 10:56:22.000000000 +0530
+@@ -277,8 +277,13 @@
+	/* FIXME: why is this needed. Note don't use ldisc_ref here as the
+	   open path is before the ldisc is referencable */
+
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,30))
+	if (tty->ldisc->ops->flush_buffer)
+		tty->ldisc->ops->flush_buffer(tty);
++#else
++	if (tty->ldisc.ops->flush_buffer)
++		tty->ldisc.ops->flush_buffer(tty);
++#endif
+	tty_driver_flush_buffer(tty);
+
+	return 0;
+@@ -478,7 +483,11 @@
+		return -EUNATCH;
+
+	default:
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,27))
+		err = n_tty_ioctl_helper(tty, file, cmd, arg);
++#else
++		err = n_tty_ioctl(tty, file, cmd, arg);
++#endif
+		break;
+	};
+
+diff -Nur a/net/bluetooth/af_bluetooth.c b/net/bluetooth/af_bluetooth.c
+--- a/net/bluetooth/af_bluetooth.c	2009-11-25 11:24:43.000000000 +0530
++++ b/net/bluetooth/af_bluetooth.c	2009-12-01 16:13:22.000000000 +0530
+@@ -337,7 +337,11 @@
+		if (sk->sk_state == BT_LISTEN)
+			return -EINVAL;
+
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,31))
+		amount = sk->sk_sndbuf - sk_wmem_alloc_get(sk);
++#else
++    amount = sk->sk_sndbuf - atomic_read(&sk->sk_wmem_alloc);
++#endif
+		if (amount < 0)
+			amount = 0;
+		err = put_user(amount, (int __user *) arg);
+diff -Nur a/net/bluetooth/bnep/core.c b/net/bluetooth/bnep/core.c
+--- a/net/bluetooth/bnep/core.c	2009-11-25 11:24:43.000000000 +0530
++++ b/net/bluetooth/bnep/core.c	2009-12-03 14:51:50.000000000 +0530
+@@ -533,9 +533,11 @@
+	return conn ? &conn->dev : NULL;
+ }
+
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,32))
+ static struct device_type bnep_type = {
+	.name	= "bluetooth",
+ };
++#endif
+
+ int bnep_add_connection(struct bnep_connadd_req *req, struct socket *sock)
+ {
+diff -Nur a/net/bluetooth/bnep/netdev.c b/net/bluetooth/bnep/netdev.c
+--- a/net/bluetooth/bnep/netdev.c	2009-11-25 11:24:43.000000000 +0530
++++ b/net/bluetooth/bnep/netdev.c	2009-11-27 19:35:33.000000000 +0530
+@@ -165,8 +165,12 @@
+ }
+ #endif
+
+-static netdev_tx_t bnep_net_xmit(struct sk_buff *skb,
+-				 struct net_device *dev)
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,31))
++static netdev_tx_t bnep_net_xmit(struct sk_buff *skb, struct net_device *dev)
++#else
++static int bnep_net_xmit(struct sk_buff *skb, struct net_device *dev)
++#endif
++
+ {
+	struct bnep_session *s = netdev_priv(dev);
+	struct sock *sk = s->sock->sk;
+@@ -207,6 +211,7 @@
+	return NETDEV_TX_OK;
+ }
+
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,28))
+ static const struct net_device_ops bnep_netdev_ops = {
+	.ndo_open            = bnep_net_open,
+	.ndo_stop            = bnep_net_close,
+@@ -218,6 +223,16 @@
+	.ndo_change_mtu	     = eth_change_mtu,
+
+ };
++#else
++static struct net_device_stats *bnep_net_get_stats(struct net_device *dev)
++{
++	return &dev->stats;
++}
++static int bnep_net_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
++{
++	return -EINVAL;
++}
++#endif
+
+ void bnep_net_setup(struct net_device *dev)
+ {
+@@ -226,7 +241,18 @@
+	dev->addr_len = ETH_ALEN;
+
+	ether_setup(dev);
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,28))
+	dev->netdev_ops = &bnep_netdev_ops;
++#else
++	dev->open            = bnep_net_open;
++	dev->stop            = bnep_net_close;
++	dev->hard_start_xmit = bnep_net_xmit;
++	dev->get_stats       = bnep_net_get_stats;
++	dev->do_ioctl        = bnep_net_ioctl;
++	dev->set_mac_address = bnep_net_set_mac_addr;
++	dev->set_multicast_list = bnep_net_set_mc_list;
++	dev->tx_timeout      = bnep_net_timeout;
++#endif
+
+	dev->watchdog_timeo  = HZ * 2;
+ }
+diff -Nur a/net/bluetooth/cmtp/capi.c b/net/bluetooth/cmtp/capi.c
+--- a/net/bluetooth/cmtp/capi.c	2009-11-25 11:24:43.000000000 +0530
++++ b/net/bluetooth/cmtp/capi.c	2009-11-26 16:43:42.000000000 +0530
+@@ -382,7 +382,11 @@
+
+	BT_DBG("ctrl %p", ctrl);
+
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,30))
+	capi_ctr_down(ctrl);
++#else
++	capi_ctr_reseted(ctrl);
++#endif
+
+	atomic_inc(&session->terminate);
+	cmtp_schedule(session);
+diff -Nur a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
+--- a/net/bluetooth/hci_core.c	2009-11-25 11:24:43.000000000 +0530
++++ b/net/bluetooth/hci_core.c	2009-11-26 16:01:35.000000000 +0530
+@@ -39,7 +39,12 @@
+ #include <linux/skbuff.h>
+ #include <linux/interrupt.h>
+ #include <linux/notifier.h>
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31))
+ #include <linux/rfkill.h>
++#else
++#include <linux/rfkill_backport.h>
++#endif
++
+ #include <net/sock.h>
+
+ #include <asm/system.h>
+diff -Nur a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
+--- a/net/bluetooth/hci_sock.c	2009-11-25 11:24:43.000000000 +0530
++++ b/net/bluetooth/hci_sock.c	2009-11-25 11:44:07.000000000 +0530
+@@ -466,7 +466,11 @@
+	goto done;
+ }
+
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,31))
+ static int hci_sock_setsockopt(struct socket *sock, int level, int optname, char __user *optval, unsigned int len)
++#else
++static int hci_sock_setsockopt(struct socket *sock, int level, int optname, char __user *optval, int len)
++#endif
+ {
+	struct hci_ufilter uf = { .opcode = 0 };
+	struct sock *sk = sock->sk;
+diff -Nur a/net/bluetooth/hci_sysfs.c b/net/bluetooth/hci_sysfs.c
+--- a/net/bluetooth/hci_sysfs.c	2009-11-25 11:24:43.000000000 +0530
++++ b/net/bluetooth/hci_sysfs.c	2009-11-27 15:19:26.000000000 +0530
+@@ -68,7 +68,11 @@
+	.attrs = bt_link_attrs,
+ };
+
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,31))
+ static const struct attribute_group *bt_link_groups[] = {
++#else
++static struct attribute_group *bt_link_groups[] = {
++#endif
+	&bt_link_group,
+	NULL
+ };
+@@ -126,7 +130,11 @@
+		dev = device_find_child(&conn->dev, NULL, __match_tty);
+		if (!dev)
+			break;
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,29))
+		device_move(dev, NULL, DPM_ORDER_DEV_LAST);
++#else
++		device_move(dev, NULL);
++#endif
+		put_device(dev);
+	}
+
+@@ -392,7 +400,11 @@
+	.attrs = bt_host_attrs,
+ };
+
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,31))
+ static const struct attribute_group *bt_host_groups[] = {
++#else
++static struct attribute_group *bt_host_groups[] = {
++#endif
+	&bt_host_group,
+	NULL
+ };
+diff -Nur a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
+--- a/net/bluetooth/hidp/core.c	2009-11-25 11:24:43.000000000 +0530
++++ b/net/bluetooth/hidp/core.c	2009-11-30 16:14:52.000000000 +0530
+@@ -576,10 +576,16 @@
+		session->input = NULL;
+	}
+
+-	if (session->hid) {
+-		hid_destroy_device(session->hid);
+-		session->hid = NULL;
+-	}
++  if (session->hid) {
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,27))
++    hid_destroy_device(session->hid);
++    session->hid = NULL;
++#else
++    if (session->hid->claimed & HID_CLAIMED_INPUT)
++      hidinput_disconnect(session->hid);
++    hid_free_device(session->hid);
++#endif
++  }
+
+	/* Wakeup user-space polling for socket errors */
+	session->intr_sock->sk->sk_err = EUNATCH;
+@@ -691,6 +697,7 @@
+ {
+ }
+
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,27))
+ static int hidp_parse(struct hid_device *hid)
+ {
+	struct hidp_session *session = hid->driver_data;
+@@ -755,15 +762,44 @@
+ };
+
+ static int hidp_setup_hid(struct hidp_session *session,
++#else
++static const struct {
++	__u16 idVendor;
++	__u16 idProduct;
++	unsigned quirks;
++} hidp_blacklist[] = {
++	/* Apple wireless Mighty Mouse */
++	{ 0x05ac, 0x030c, HID_QUIRK_MIGHTYMOUSE | HID_QUIRK_INVERT_HWHEEL },
++
++	{ }	/* Terminating entry */
++};
++static void hidp_setup_quirks(struct hid_device *hid)
++{
++	unsigned int n;
++
++	for (n = 0; hidp_blacklist[n].idVendor; n++)
++		if (hidp_blacklist[n].idVendor == le16_to_cpu(hid->vendor) &&
++				hidp_blacklist[n].idProduct == le16_to_cpu(hid->product))
++			hid->quirks = hidp_blacklist[n].quirks;
++}
++static void hidp_setup_hid(struct hidp_session *session,
++#endif
+				struct hidp_connadd_req *req)
+ {
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,27))
+	struct hid_device *hid;
+-	bdaddr_t src, dst;
+	int err;
++#else
++	struct hid_device *hid = session->hid;
++	struct hid_report *report;
++#endif
++	bdaddr_t src, dst;
+
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,27))
+	hid = hid_allocate_device();
+	if (IS_ERR(hid))
+		return PTR_ERR(session->hid);
++#endif
+
+	session->hid = hid;
+	session->req = req;
+@@ -782,6 +818,8 @@
+	strncpy(hid->phys, batostr(&src), 64);
+	strncpy(hid->uniq, batostr(&dst), 64);
+
++
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,27))
+	hid->dev.parent = hidp_get_device(session);
+	hid->ll_driver = &hidp_hid_driver;
+
+@@ -796,6 +834,24 @@
+	session->hid = NULL;
+
+	return err;
++#else
++	hid->dev = hidp_get_device(session);
++	hid->hid_open  = hidp_open;
++	hid->hid_close = hidp_close;
++
++	hid->hidinput_input_event = hidp_hidinput_event;
++
++	hidp_setup_quirks(hid);
++
++	list_for_each_entry(report, &hid->report_enum[HID_INPUT_REPORT].report_list, list)
++		hidp_send_report(session, report);
++
++	list_for_each_entry(report, &hid->report_enum[HID_FEATURE_REPORT].report_list, list)
++		hidp_send_report(session, report);
++
++	if (hidinput_connect(hid) == 0)
++		hid->claimed |= HID_CLAIMED_INPUT;
++#endif
+ }
+
+ int hidp_add_connection(struct hidp_connadd_req *req, struct socket *ctrl_sock, struct socket *intr_sock)
+@@ -815,6 +871,39 @@
+
+	BT_DBG("rd_data %p rd_size %d", req->rd_data, req->rd_size);
+
++#if (LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,27))
++	if (req->rd_size > 0) {
++		unsigned char *buf = kmalloc(req->rd_size, GFP_KERNEL);
++
++		if (!buf) {
++			kfree(session);
++			return -ENOMEM;
++		}
++
++		if (copy_from_user(buf, req->rd_data, req->rd_size)) {
++			kfree(buf);
++			kfree(session);
++			return -EFAULT;
++		}
++
++		session->hid = hid_parse_report(buf, req->rd_size);
++
++		kfree(buf);
++
++		if (!session->hid) {
++			kfree(session);
++			return -EINVAL;
++		}
++	}
++
++	if (!session->hid) {
++		session->input = input_allocate_device();
++		if (!session->input) {
++			kfree(session);
++			return -ENOMEM;
++		}
++	}
++#endif
+	down_write(&hidp_session_sem);
+
+	s = __hidp_get_session(&bt_sk(ctrl_sock->sk)->dst);
+@@ -842,6 +931,7 @@
+	session->flags   = req->flags & (1 << HIDP_BLUETOOTH_VENDOR_ID);
+	session->idle_to = req->idle_to;
+
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,27))
+	if (req->rd_size > 0) {
+		err = hidp_setup_hid(session, req);
+		if (err && err != -ENODEV)
+@@ -853,6 +943,16 @@
+		if (err < 0)
+			goto purge;
+	}
++#else
++	if (session->input) {
++		err = hidp_setup_input(session, req);
++		if (err < 0)
++			goto failed;
++	}
++
++	if (session->hid)
++		hidp_setup_hid(session, req);
++#endif
+
+	__hidp_link_session(session);
+
+@@ -884,6 +984,7 @@
+		session->input = NULL;
+	}
+
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,27))
+	if (session->hid) {
+		hid_destroy_device(session->hid);
+		session->hid = NULL;
+@@ -892,10 +993,15 @@
+ purge:
+	skb_queue_purge(&session->ctrl_transmit);
+	skb_queue_purge(&session->intr_transmit);
++#endif
+
+ failed:
+	up_write(&hidp_session_sem);
+
++#if (LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,27))
++	if (session->hid)
++		hid_free_device(session->hid);
++#endif
+	input_free_device(session->input);
+	kfree(session);
+	return err;
+@@ -985,6 +1091,7 @@
+	return err;
+ }
+
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,27))
+ static const struct hid_device_id hidp_table[] = {
+	{ HID_BLUETOOTH_DEVICE(HID_ANY_ID, HID_ANY_ID) },
+	{ }
+@@ -994,6 +1101,7 @@
+	.name = "generic-bluetooth",
+	.id_table = hidp_table,
+ };
++#endif
+
+ static int __init hidp_init(void)
+ {
+@@ -1003,11 +1111,14 @@
+
+	BT_INFO("HIDP (Human Interface Emulation) ver %s", VERSION);
+
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,27))
+	ret = hid_register_driver(&hidp_driver);
+	if (ret)
+		goto err;
++#endif
+
+	ret = hidp_init_sockets();
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,27))
+	if (ret)
+		goto err_drv;
+
+@@ -1015,13 +1126,16 @@
+ err_drv:
+	hid_unregister_driver(&hidp_driver);
+ err:
++#endif
+	return ret;
+ }
+
+ static void __exit hidp_exit(void)
+ {
+	hidp_cleanup_sockets();
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,27))
+	hid_unregister_driver(&hidp_driver);
++#endif
+ }
+
+ module_init(hidp_init);
+diff -Nur a/net/bluetooth/l2cap.c b/net/bluetooth/l2cap.c
+--- a/net/bluetooth/l2cap.c	2009-11-25 11:24:43.000000000 +0530
++++ b/net/bluetooth/l2cap.c	2009-11-25 11:45:08.000000000 +0530
+@@ -1758,7 +1758,11 @@
+	return err;
+ }
+
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,31))
+ static int l2cap_sock_setsockopt(struct socket *sock, int level, int optname, char __user *optval, unsigned int optlen)
++#else
++static int l2cap_sock_setsockopt(struct socket *sock, int level, int optname, char __user *optval, int optlen)
++#endif
+ {
+	struct sock *sk = sock->sk;
+	struct bt_security sec;
+diff -Nur a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
+--- a/net/bluetooth/rfcomm/sock.c	2009-11-25 11:24:43.000000000 +0530
++++ b/net/bluetooth/rfcomm/sock.c	2009-11-25 14:55:56.000000000 +0530
+@@ -766,7 +766,11 @@
+	return err;
+ }
+
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,31))
+ static int rfcomm_sock_setsockopt(struct socket *sock, int level, int optname, char __user *optval, unsigned int optlen)
++#else
++static int rfcomm_sock_setsockopt(struct socket *sock, int level, int optname, char __user *optval, int optlen)
++#endif
+ {
+	struct sock *sk = sock->sk;
+	struct bt_security sec;
+diff -Nur a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
+--- a/net/bluetooth/rfcomm/tty.c	2009-11-25 11:24:43.000000000 +0530
++++ b/net/bluetooth/rfcomm/tty.c	2009-11-27 15:25:36.000000000 +0530
+@@ -731,8 +731,12 @@
+	remove_wait_queue(&dev->wait, &wait);
+
+	if (err == 0)
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,29))
+		device_move(dev->tty_dev, rfcomm_get_device(dev),
+			    DPM_ORDER_DEV_AFTER_PARENT);
++#else
++		device_move(dev->tty_dev, rfcomm_get_device(dev));
++#endif
+
+	rfcomm_tty_copy_pending(dev);
+
+@@ -752,7 +756,11 @@
+
+	if (atomic_dec_and_test(&dev->opened)) {
+		if (dev->tty_dev->parent)
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,29))
+			device_move(dev->tty_dev, NULL, DPM_ORDER_DEV_LAST);
++#else
++			device_move(dev->tty_dev, NULL);
++#endif
+
+		/* Close DLC and dettach TTY */
+		rfcomm_dlc_close(dev->dlc, 0);
+diff -Nur a/net/bluetooth/sco.c b/net/bluetooth/sco.c
+--- a/net/bluetooth/sco.c	2009-11-25 11:24:43.000000000 +0530
++++ b/net/bluetooth/sco.c	2009-11-25 11:45:30.000000000 +0530
+@@ -644,7 +644,11 @@
+	return err;
+ }
+
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,31))
+ static int sco_sock_setsockopt(struct socket *sock, int level, int optname, char __user *optval, unsigned int optlen)
++#else
++static int sco_sock_setsockopt(struct socket *sock, int level, int optname, char __user *optval, int optlen)
++#endif
+ {
+	struct sock *sk = sock->sk;
+	int err = 0;
diff --git a/compat/patches/98-add-compat-wireless.patch b/compat/patches/98-add-compat-wireless.patch
index 0bbf85b..84f75d1 100644
--- a/compat/patches/98-add-compat-wireless.patch
+++ b/compat/patches/98-add-compat-wireless.patch
@@ -18,26 +18,6 @@ If your driver is not a cfg80211 driver you must
 ensure you include compat.h then. I think we
 added compat.h also for ssb, I forget.
 
---- a/net/wireless/Makefile	2009-08-07 12:27:50.836497001 -0700
-+++ b/net/wireless/Makefile	2009-08-07 12:27:51.952497240 -0700
-@@ -15,3 +15,17 @@
- cfg80211-$(CONFIG_CFG80211_WEXT) += wext-compat.o wext-sme.o
- 
- ccflags-y += -D__CHECK_ENDIAN__
-+# Compat-wireless kernel compatibility code
-+cfg80211-$(CONFIG_COMPAT_WIRELESS_22) += compat-2.6.22.o
-+cfg80211-$(CONFIG_COMPAT_WIRELESS_23) += compat-2.6.23.o
-+cfg80211-$(CONFIG_COMPAT_WIRELESS_24) += compat-2.6.24.o
-+cfg80211-$(CONFIG_COMPAT_WIRELESS_25) += compat-2.6.25.o
-+cfg80211-$(CONFIG_COMPAT_WIRELESS_26) += compat-2.6.26.o
-+cfg80211-$(CONFIG_COMPAT_WIRELESS_27) += compat-2.6.27.o
-+cfg80211-$(CONFIG_COMPAT_WIRELESS_28) += compat-2.6.28.o
-+cfg80211-$(CONFIG_COMPAT_WIRELESS_29) += compat-2.6.29.o
-+cfg80211-$(CONFIG_COMPAT_WIRELESS_30) += compat-2.6.30.o
-+cfg80211-$(CONFIG_COMPAT_WIRELESS_31) += compat-2.6.31.o
-+cfg80211-$(CONFIG_COMPAT_WIRELESS_32) += compat-2.6.32.o
-+cfg80211-$(CONFIG_COMPAT_WIRELESS_33) += compat-2.6.33.o
-+
 --- a/include/net/cfg80211.h
 +++ b/include/net/cfg80211.h
 @@ -23,6 +23,7 @@
diff --git a/config.mk b/config.mk
index 4008a01..6f3faf4 100644
--- a/config.mk
+++ b/config.mk
@@ -19,6 +19,9 @@ ifeq ($(CONFIG_MAC80211),y)
 $(error "ERROR: you have MAC80211 compiled into the kernel, CONFIG_MAC80211=y, as such you cannot replace its mac80211 driver. You need this set to CONFIG_MAC80211=m. If you are using Fedora upgrade your kernel as later version should this set as modular. For further information on Fedora see https://bugzilla.redhat.com/show_bug.cgi?id=470143. If you are using your own kernel recompile it and make mac80211 modular")
 endif
 
+ifeq ($(CONFIG_BT),y)
+$(error "ERROR: your kernel has CONFIG_BT=y, you should have it CONFIG_BT=m if you want to use compat bluetooth.")
+endif
 
 # We will warn when you don't have MQ support or NET_SCHED enabled.
 #
@@ -30,6 +33,7 @@ COMPAT_LATEST_VERSION = 32
 KERNEL_SUBLEVEL := $(shell $(MAKE) -C $(KLIB_BUILD) kernelversion | sed -n 's/^2\.6\.\([0-9]\+\).*/\1/p')
 COMPAT_VERSIONS := $(shell I=$(COMPAT_LATEST_VERSION); while [ "$$I" -gt $(KERNEL_SUBLEVEL) ]; do echo $$I; I=$$(($$I - 1)); done)
 $(foreach ver,$(COMPAT_VERSIONS),$(eval CONFIG_COMPAT_WIRELESS_$(ver)=y))
+$(foreach ver,$(COMPAT_VERSIONS),$(eval CONFIG_COMPAT_BLUETOOTH_$(ver)=y))
 
 ifdef CONFIG_COMPAT_WIRELESS_25
 $(error "ERROR: You should use compat-wireless-2.6-old for older kernels, this one is for kernels >= 2.6.25")
@@ -124,6 +128,14 @@ CONFIG_LIB80211_CRYPT_TKIP=m
 
 CONFIG_WIRELESS_OLD_REGULATORY=n
 
+CONFIG_BT=m
+CONFIG_BT_L2CAP=m
+CONFIG_BT_SCO=m
+CONFIG_BT_RFCOMM=m
+CONFIG_BT_BNEP=m
+CONFIG_BT_CMTP=m
+CONFIG_BT_HIDP=m
+
 ifdef CONFIG_COMPAT_WIRELESS_32
 # Old kernels stil do depend on CONFIG_WIRELESS_EXT
 # as we add the wireless handler back to the struct
diff --git a/scripts/admin-clean.sh b/scripts/admin-clean.sh
index 7e2d012..ae5f188 100755
--- a/scripts/admin-clean.sh
+++ b/scripts/admin-clean.sh
@@ -10,4 +10,4 @@ rm -f git-describe
 rm -f master-tag
 rm -f compat-git-release
 rm -f compat-release
-echo "Cleaned wireless-compat-2.6"
+echo "Cleaned wireless-bt-compat-2.6"
diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index f85dacf..d6d47b0 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -16,6 +16,11 @@
 # for example
 #
 GIT_URL="git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git"
+GIT_BT_URL="git://git.kernel.org/pub/scm/linux/kernel/git/holtmann/bluetooth-testing.git"
+GIT_COMPAT_URL="git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat.git"
+
+INCLUDE_NET_BT="hci_core.h l2cap.h bluetooth.h rfcomm.h hci.h"
+NET_BT_DIRS="bluetooth bluetooth/bnep bluetooth/cmtp bluetooth/rfcomm bluetooth/hidp"
 
 INCLUDE_LINUX="ieee80211.h nl80211.h wireless.h"
 INCLUDE_LINUX="$INCLUDE_LINUX pci_ids.h bitops.h eeprom_93cx6.h pm_qos_params.h"
@@ -43,7 +48,7 @@ UNDERLINE="\033[02m"
 NET_DIRS="wireless mac80211 rfkill"
 # User exported this variable
 if [ -z $GIT_TREE ]; then
-	GIT_TREE="/home/$USER/devel/wireless-testing/"
+	GIT_TREE="/home/$USER/wireless-testing/"
 	if [ ! -d $GIT_TREE ]; then
 		echo "Please tell me where your wireless-testing git tree is."
 		echo "You can do this by exporting its location as follows:"
@@ -55,8 +60,41 @@ if [ -z $GIT_TREE ]; then
 		exit 1
 	fi
 else
-	echo "You said to use git tree at: $GIT_TREE"
+	echo "You said to use git tree at: $GIT_TREE for wireless"
+fi
+
+if [ -z $GIT_BT_TREE ]; then
+	GIT_BT_TREE="/home/$USER/bluetooth-testing/"
+	if [ ! -d $GIT_BT_TREE ]; then
+		echo "Please tell me where your bluetooth-testing git tree is."
+		echo "You can do this by exporting its location as follows:"
+		echo
+		echo "  export GIT_BT_TREE=/home/$USER/bluetooth-testing/"
+		echo
+		echo "If you do not have one you can clone the repository:"
+		echo "  git-clone $GIT_BT_URL"
+		exit 1
+	fi
+else
+	echo "You said to use git tree at: $GIT_BT_TREE for bluetooth"
+fi
+
+if [ -z $GIT_COMPAT_TREE ]; then
+	GIT_COMPAT_TREE="/home/$USER/compat/"
+	if [ ! -d $GIT_COMPAT_TREE ]; then
+		echo "Please tell me where your bluetooth-testing git tree is."
+		echo "You can do this by exporting its location as follows:"
+		echo
+		echo "  export GIT_COMPAT_TREE=/home/$USER/compat/"
+		echo
+		echo "If you do not have one you can clone the repository:"
+		echo "  git-clone $GIT_COMPAT_URL"
+		exit 1
+	fi
+else
+	echo "You said to use git tree at: $GIT_COMPAT_TREE for bluetooth"
 fi
+
 # Drivers that have their own directory
 DRIVERS="drivers/net/wireless/ath"
 DRIVERS="$DRIVERS drivers/net/wireless/ath/ar9170"
@@ -75,6 +113,7 @@ DRIVERS="$DRIVERS drivers/net/wireless/libertas_tf"
 DRIVERS="$DRIVERS drivers/net/wireless/ipw2x00"
 DRIVERS="$DRIVERS drivers/net/wireless/wl12xx"
 DRIVERS="$DRIVERS drivers/net/wireless/iwmc3200wifi"
+DRIVERS_BT="drivers/bluetooth"
 
 # Drivers that belong the the wireless directory
 DRIVER_FILES="adm8211.c  adm8211.h"
@@ -91,6 +130,7 @@ mkdir -p include/linux/ include/net/ include/linux/usb \
 	drivers/ssb/ \
 	drivers/net/usb/ \
 	drivers/net/wireless/
+mkdir -p include/net/bluetooth/
 
 # include/linux
 DIR="include/linux"
@@ -109,6 +149,12 @@ for i in $INCLUDE_NET; do
 	cp "$GIT_TREE/$DIR/$i" $DIR/
 done
 
+DIR="include/net/bluetooth"
+for i in $INCLUDE_NET_BT; do
+  echo "Copying $GIT_BT_TREE/$DIR/$i"
+  cp $GIT_BT_TREE/$DIR/$i $DIR/
+done
+
 DIR="include/linux/usb"
 for i in $INCLUDE_LINUX_USB; do
 	echo "Copying $GIT_TREE/$DIR/$i"
@@ -129,6 +175,15 @@ for i in $NET_DIRS; do
 	rm -f net/$i/*.mod.c
 done
 
+# net/bluetooth
+for i in $NET_BT_DIRS; do
+	mkdir -p net/$i
+	echo "Copying $GIT_BT_TREE/net/$i/*.[ch]"
+	cp $GIT_BT_TREE/net/$i/*.[ch] net/$i/
+	cp $GIT_BT_TREE/net/$i/Makefile net/$i/
+	rm -f net/$i/*.mod.c
+done
+
 # Drivers in their own directory
 for i in $DRIVERS; do
 	mkdir -p $i
@@ -138,6 +193,14 @@ for i in $DRIVERS; do
 	rm -f $i/*.mod.c
 done
 
+for i in $DRIVERS_BT; do
+	mkdir -p $i
+	echo "Copying $GIT_BT_TREE/$i/*.[ch]"
+	cp $GIT_BT_TREE/$i/*.[ch] $i/
+	cp $GIT_BT_TREE/$i/Makefile $i/
+	rm -f $i/*.mod.c
+done
+
 # For rndis_wlan, we need a new rndis_host.ko, cdc_ether.ko and usbnet.ko
 RNDIS_REQS="Makefile rndis_host.c cdc_ether.c usbnet.c"
 DIR="drivers/net/usb"
@@ -171,9 +234,18 @@ cp $GIT_TREE/$DIR/* $DIR
 
 
 # Compat stuff
-cp compat/compat-2.6.*.c net/wireless/
-cp compat/compat-2.6.*.h include/net/
-cp compat/compat.h include/net/
+COMPAT_BT="net/compat"
+for i in $COMPAT_BT; do
+	mkdir -p $i
+	echo "Copying $GIT_COMPAT_TREE/$i/*.[ch]"
+	cp $GIT_COMPAT_TREE/*.c $i/
+	#cp $GIT_COMPAT_TREE/*.h include/net
+	cp $GIT_COMPAT_TREE/Makefile $i/
+	rm -f $i/*.mod.c
+done
+#cp compat/*.h include/net/
+cp $GIT_COMPAT_TREE/*.h include/net/
+cp compat/compat-2.6.33.h include/net/
 
 for i in compat/patches/*.patch; do
 	echo -e "${GREEN}Applying backport patch${NORMAL}: ${BLUE}$i${NORMAL}"
diff --git a/scripts/btload.sh b/scripts/btload.sh
new file mode 100755
index 0000000..50f37b6
--- /dev/null
+++ b/scripts/btload.sh
@@ -0,0 +1,10 @@
+#!/bin/bash
+MODULES="bluetooth btusb l2cap sco hidp rfcomm bnep"
+for i in $MODULES; do
+	echo Loading $i...
+	modprobe $i
+done
+echo Starting bluetooth service..
+sudo service bluetooth start
+sudo service bluetooth status
+
diff --git a/scripts/btunload.sh b/scripts/btunload.sh
new file mode 100755
index 0000000..c14f8c6
--- /dev/null
+++ b/scripts/btunload.sh
@@ -0,0 +1,13 @@
+#!/bin/bash
+MODULES="hidp rfcomm bnep l2cap sco btusb bluetooth"
+echo Stoping bluetooth service..
+sudo service bluetooth stop
+sudo service bluetooth status
+
+for i in $MODULES; do
+	grep ^$i /proc/modules 2>&1 > /dev/null
+	if [ $? -eq 0 ]; then
+		echo Unloading $i...
+		modprobe -r --ignore-remove $i
+	fi
+done
diff --git a/scripts/load.sh b/scripts/load.sh
index 7bc8fae..9f82e2c 100755
--- a/scripts/load.sh
+++ b/scripts/load.sh
@@ -12,6 +12,7 @@ MODULES="$MODULES rt2500usb rt73usb"
 MODULES="$MODULES rndis_wlan at76_usb"
 MODULES="$MODULES mwl8k mac80211_hwsim"
 MODULES="$MODULES at76c50x_usb"
+MODULES="$MODULES bluetooth btusb l2cap sco hidp rfcomm bnep"
 for i in $MODULES; do
 	echo Loading $i...
 	modprobe $i
@@ -20,3 +21,6 @@ done
 athload ath5k
 # For b43 we must make sure to unload bcm43xx first
 b43load b43
+echo Starting bluetooth service..
+sudo service bluetooth start
+sudo service bluetooth status
diff --git a/scripts/unload.sh b/scripts/unload.sh
index 75bbfc9..23d1ae5 100755
--- a/scripts/unload.sh
+++ b/scripts/unload.sh
@@ -27,6 +27,10 @@ MODULES="$MODULES rndis_wlan rndis_host cdc_ether usbnet"
 MODULES="$MODULES eeprom_93cx6"
 MODULES="$MODULES lib80211_crypt_ccmp lib80211_crypt_tkip lib80211_crypt_wep"
 MODULES="$MODULES mac80211 cfg80211 lib80211"
+MODULES="$MODULES hidp rfcomm bnep l2cap sco btusb bluetooth"
+echo Stoping bluetooth service..
+sudo service bluetooth stop
+sudo service bluetooth status
 MADWIFI_MODULES="ath_pci ath_rate_sample wlan_scan_sta wlan ath_hal"
 IPW3945D="/sbin/ipw3945d-`uname -r`"
 
diff --git a/scripts/wlload.sh b/scripts/wlload.sh
new file mode 100755
index 0000000..7bc8fae
--- /dev/null
+++ b/scripts/wlload.sh
@@ -0,0 +1,22 @@
+#!/bin/bash
+MODULES="ipw2100 ipw2200 libertas_cs usb8xxx"
+MODULES="$MODULES p54pci p54usb"
+MODULES="$MODULES adm8211 zd1211rw"
+MODULES="$MODULES rtl8180 rtl8187"
+MODULES="$MODULES p54pci p54usb"
+MODULES="$MODULES iwl3945 iwlagn"
+MODULES="$MODULES ath ar9170usb"
+MODULES="$MODULES rtl8180 rtl8187"
+MODULES="$MODULES rt2400pci rt2500pci rt61pci"
+MODULES="$MODULES rt2500usb rt73usb"
+MODULES="$MODULES rndis_wlan at76_usb"
+MODULES="$MODULES mwl8k mac80211_hwsim"
+MODULES="$MODULES at76c50x_usb"
+for i in $MODULES; do
+	echo Loading $i...
+	modprobe $i
+done
+# For ath5k we must be sure to unload MadWifi first
+athload ath5k
+# For b43 we must make sure to unload bcm43xx first
+b43load b43
diff --git a/scripts/wlunload.sh b/scripts/wlunload.sh
new file mode 100755
index 0000000..75bbfc9
--- /dev/null
+++ b/scripts/wlunload.sh
@@ -0,0 +1,54 @@
+#!/bin/bash
+
+# The old stack drivers and the mac80211 rc80211_simple modules
+# which is no longer on recent kernels (its internal)
+OLD_MODULES="iwlwifi_mac80211 rc80211_simple zd1211rw-mac80211"
+OLD_MODULES="$OLD_MODULES ieee80211_crypt_tkip ieee80211_crypt_ccmp"
+OLD_MODULES="$OLD_MODULES ieee80211softmac ieee80211_crypt ieee80211"
+OLD_MODULES="$OLD_MODULES bcm43xx rndis_wext iwl4965"
+MODULES="$OLD_MODULES"
+MODULES="$MODULES ipw2100 ipw2200 libipw"
+MODULES="$MODULES libertas_cs usb8xxx libertas libertas_sdio libertas_spi"
+MODULES="$MODULES libertas_tf libertas_tf_usb"
+MODULES="$MODULES adm8211 zd1211rw"
+MODULES="$MODULES b43 b43legacy ssb"
+MODULES="$MODULES iwl3945 iwlagn iwlcore"
+MODULES="$MODULES ath9k ath5k ar9170usb ath"
+MODULES="$MODULES p54pci p54usb p54spi p54common"
+MODULES="$MODULES rt2400pci rt2500pci rt61pci"
+MODULES="$MODULES rt2500usb rt73usb"
+MODULES="$MODULES rt2x00usb rt2x00lib"
+MODULES="$MODULES rtl8180 rtl8187"
+MODULES="$MODULES mwl8k mac80211_hwsim"
+MODULES="$MODULES at76c50x_usb at76_usb"
+MODULES="$MODULES rndis_wlan rndis_host cdc_ether usbnet"
+# eeprom_93cx6 is used by rt2x00 (rt61pci, rt2500pci, rt2400pci)
+# and Realtek drivers ( rtl8187, rtl8180)
+MODULES="$MODULES eeprom_93cx6"
+MODULES="$MODULES lib80211_crypt_ccmp lib80211_crypt_tkip lib80211_crypt_wep"
+MODULES="$MODULES mac80211 cfg80211 lib80211"
+MADWIFI_MODULES="ath_pci ath_rate_sample wlan_scan_sta wlan ath_hal"
+IPW3945D="/sbin/ipw3945d-`uname -r`"
+
+if [ -f $IPW3945D ]; then
+	$IPW3945D --isrunning
+	if [ ! $? ]; then
+		echo -n "Detected ipw3945 daemon loaded we're going to "
+		echo "shut the daemon down now and remove the module."
+		modprobe -r --ignore-remove ipw3945
+	fi
+fi
+
+grep ath_pci /proc/modules 2>&1 > /dev/null
+if [ $? -eq 0 ]; then
+	echo "MadWifi driver is loaded, going to try to unload it..."
+	./scripts/madwifi-unload
+fi
+
+for i in $MODULES; do
+	grep ^$i /proc/modules 2>&1 > /dev/null
+	if [ $? -eq 0 ]; then
+		echo Unloading $i...
+		modprobe -r --ignore-remove $i
+	fi
+done
-- 
1.6.0.4

