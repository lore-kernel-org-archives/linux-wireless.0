Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:36673 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbbDTXbT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2015 19:31:19 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	keescook@chromium.org, casey@schaufler-ca.com,
	cocci@systeme.lip6.fr, Junio C Hamano <gitster@pobox.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Hannes Reinecke <hare@suse.de>, Tejun Heo <tj@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	"Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH v1 0/6] module params: few simplifications
Date: Mon, 20 Apr 2015 16:30:32 -0700
Message-Id: <1429572637-30234-2-git-send-email-mcgrof@do-not-panic.com> (sfid-20150421_013256_503215_5D839D95)
In-Reply-To: <1429572637-30234-1-git-send-email-mcgrof@do-not-panic.com>
References: <1429572637-30234-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Most code already uses consts for the struct kernel_param_ops,
sweep the kernel for the last offending stragglers. Other than
include/linux/moduleparam.h and kernel/params.c all other changes
were generated with the following Coccinelle SmPL patch. Merge
conflicts between trees can be handled with Coccinelle.

In the future git could get Coccinelle merge support to deal with
patch --> fail --> grammar --> Coccinelle --> new patch conflicts
automatically for us on patches where the grammar is available and
the patch is of high confidence. Consider this a feature request.

Test compiled on x86_64 against:

  * allnoconfig
  * allmodconfig
  * allyesconfig

@ const_found @
identifier ops;
@@

const struct kernel_param_ops ops = {
};

@ const_not_found depends on !const_found @
identifier ops;
@@

-struct kernel_param_ops ops = {
+const struct kernel_param_ops ops = {
};

Generated-by: Coccinelle SmPL
Cc: cocci@systeme.lip6.fr
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Junio C Hamano <gitster@pobox.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Kees Cook <keescook@chromium.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 arch/s390/kernel/perf_cpum_sf.c         |  2 +-
 arch/x86/kvm/mmu_audit.c                |  2 +-
 arch/x86/platform/uv/uv_nmi.c           |  2 +-
 drivers/block/null_blk.c                |  4 ++--
 drivers/char/ipmi/ipmi_watchdog.c       |  6 +++---
 drivers/dma/dmatest.c                   |  4 ++--
 drivers/ide/ide.c                       |  2 +-
 drivers/infiniband/ulp/srp/ib_srp.c     |  4 ++--
 drivers/input/misc/ati_remote2.c        |  4 ++--
 drivers/input/mouse/psmouse-base.c      |  2 +-
 drivers/misc/lis3lv02d/lis3lv02d.c      |  2 +-
 drivers/mtd/ubi/block.c                 |  2 +-
 drivers/net/wireless/ath/wil6210/main.c |  4 ++--
 drivers/power/test_power.c              | 16 ++++++++--------
 drivers/thermal/intel_powerclamp.c      |  4 ++--
 drivers/tty/hvc/hvc_iucv.c              |  2 +-
 drivers/tty/sysrq.c                     |  2 +-
 drivers/video/fbdev/uvesafb.c           |  2 +-
 drivers/virtio/virtio_mmio.c            |  2 +-
 fs/nfs/super.c                          |  2 +-
 include/linux/moduleparam.h             | 30 +++++++++++++++---------------
 kernel/params.c                         | 14 +++++++-------
 net/sunrpc/auth.c                       |  2 +-
 net/sunrpc/xprtsock.c                   |  6 +++---
 security/apparmor/lsm.c                 |  6 +++---
 security/integrity/ima/ima_crypto.c     |  2 +-
 sound/pci/hda/hda_intel.c               |  2 +-
 27 files changed, 66 insertions(+), 66 deletions(-)

diff --git a/arch/s390/kernel/perf_cpum_sf.c b/arch/s390/kernel/perf_cpum_sf.c
index e6a1578..afe05bf 100644
--- a/arch/s390/kernel/perf_cpum_sf.c
+++ b/arch/s390/kernel/perf_cpum_sf.c
@@ -1572,7 +1572,7 @@ static int param_set_sfb_size(const char *val, const struct kernel_param *kp)
 }
 
 #define param_check_sfb_size(name, p) __param_check(name, p, void)
-static struct kernel_param_ops param_ops_sfb_size = {
+static const struct kernel_param_ops param_ops_sfb_size = {
 	.set = param_set_sfb_size,
 	.get = param_get_sfb_size,
 };
diff --git a/arch/x86/kvm/mmu_audit.c b/arch/x86/kvm/mmu_audit.c
index 9ade5cf..87393e3 100644
--- a/arch/x86/kvm/mmu_audit.c
+++ b/arch/x86/kvm/mmu_audit.c
@@ -291,7 +291,7 @@ static int mmu_audit_set(const char *val, const struct kernel_param *kp)
 	return 0;
 }
 
-static struct kernel_param_ops audit_param_ops = {
+static const struct kernel_param_ops audit_param_ops = {
 	.set = mmu_audit_set,
 	.get = param_get_bool,
 };
diff --git a/arch/x86/platform/uv/uv_nmi.c b/arch/x86/platform/uv/uv_nmi.c
index 7488caf..020c101 100644
--- a/arch/x86/platform/uv/uv_nmi.c
+++ b/arch/x86/platform/uv/uv_nmi.c
@@ -104,7 +104,7 @@ static int param_set_local64(const char *val, const struct kernel_param *kp)
 	return 0;
 }
 
-static struct kernel_param_ops param_ops_local64 = {
+static const struct kernel_param_ops param_ops_local64 = {
 	.get = param_get_local64,
 	.set = param_set_local64,
 };
diff --git a/drivers/block/null_blk.c b/drivers/block/null_blk.c
index 65cd61a..0b4b256 100644
--- a/drivers/block/null_blk.c
+++ b/drivers/block/null_blk.c
@@ -99,7 +99,7 @@ static int null_set_queue_mode(const char *str, const struct kernel_param *kp)
 	return null_param_store_val(str, &queue_mode, NULL_Q_BIO, NULL_Q_MQ);
 }
 
-static struct kernel_param_ops null_queue_mode_param_ops = {
+static const struct kernel_param_ops null_queue_mode_param_ops = {
 	.set	= null_set_queue_mode,
 	.get	= param_get_int,
 };
@@ -127,7 +127,7 @@ static int null_set_irqmode(const char *str, const struct kernel_param *kp)
 					NULL_IRQ_TIMER);
 }
 
-static struct kernel_param_ops null_irqmode_param_ops = {
+static const struct kernel_param_ops null_irqmode_param_ops = {
 	.set	= null_set_irqmode,
 	.get	= param_get_int,
 };
diff --git a/drivers/char/ipmi/ipmi_watchdog.c b/drivers/char/ipmi/ipmi_watchdog.c
index 37b8be7..0ac3bd1 100644
--- a/drivers/char/ipmi/ipmi_watchdog.c
+++ b/drivers/char/ipmi/ipmi_watchdog.c
@@ -208,7 +208,7 @@ static int set_param_timeout(const char *val, const struct kernel_param *kp)
 	return rv;
 }
 
-static struct kernel_param_ops param_ops_timeout = {
+static const struct kernel_param_ops param_ops_timeout = {
 	.set = set_param_timeout,
 	.get = param_get_int,
 };
@@ -270,14 +270,14 @@ static int set_param_wdog_ifnum(const char *val, const struct kernel_param *kp)
 	return 0;
 }
 
-static struct kernel_param_ops param_ops_wdog_ifnum = {
+static const struct kernel_param_ops param_ops_wdog_ifnum = {
 	.set = set_param_wdog_ifnum,
 	.get = param_get_int,
 };
 
 #define param_check_wdog_ifnum param_check_int
 
-static struct kernel_param_ops param_ops_str = {
+static const struct kernel_param_ops param_ops_str = {
 	.set = set_param_str,
 	.get = get_param_str,
 };
diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index 220ee49..b8576fd 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -120,7 +120,7 @@ static struct dmatest_info {
 
 static int dmatest_run_set(const char *val, const struct kernel_param *kp);
 static int dmatest_run_get(char *val, const struct kernel_param *kp);
-static struct kernel_param_ops run_ops = {
+static const struct kernel_param_ops run_ops = {
 	.set = dmatest_run_set,
 	.get = dmatest_run_get,
 };
@@ -195,7 +195,7 @@ static int dmatest_wait_get(char *val, const struct kernel_param *kp)
 	return param_get_bool(val, kp);
 }
 
-static struct kernel_param_ops wait_ops = {
+static const struct kernel_param_ops wait_ops = {
 	.get = dmatest_wait_get,
 	.set = param_set_bool,
 };
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index e29b02c..f086ef3 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -199,7 +199,7 @@ static int ide_set_dev_param_mask(const char *s, const struct kernel_param *kp)
 	return 0;
 }
 
-static struct kernel_param_ops param_ops_ide_dev_mask = {
+static const struct kernel_param_ops param_ops_ide_dev_mask = {
 	.set = ide_set_dev_param_mask
 };
 
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 918814c..e4eec9d 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -98,7 +98,7 @@ module_param(register_always, bool, 0444);
 MODULE_PARM_DESC(register_always,
 		 "Use memory registration even for contiguous memory regions");
 
-static struct kernel_param_ops srp_tmo_ops;
+static const struct kernel_param_ops srp_tmo_ops;
 
 static int srp_reconnect_delay = 10;
 module_param_cb(reconnect_delay, &srp_tmo_ops, &srp_reconnect_delay,
@@ -183,7 +183,7 @@ out:
 	return res;
 }
 
-static struct kernel_param_ops srp_tmo_ops = {
+static const struct kernel_param_ops srp_tmo_ops = {
 	.get = srp_tmo_get,
 	.set = srp_tmo_set,
 };
diff --git a/drivers/input/misc/ati_remote2.c b/drivers/input/misc/ati_remote2.c
index f63341f..cfd58e8 100644
--- a/drivers/input/misc/ati_remote2.c
+++ b/drivers/input/misc/ati_remote2.c
@@ -94,7 +94,7 @@ static int ati_remote2_get_mode_mask(char *buffer,
 
 static unsigned int channel_mask = ATI_REMOTE2_MAX_CHANNEL_MASK;
 #define param_check_channel_mask(name, p) __param_check(name, p, unsigned int)
-static struct kernel_param_ops param_ops_channel_mask = {
+static const struct kernel_param_ops param_ops_channel_mask = {
 	.set = ati_remote2_set_channel_mask,
 	.get = ati_remote2_get_channel_mask,
 };
@@ -103,7 +103,7 @@ MODULE_PARM_DESC(channel_mask, "Bitmask of channels to accept <15:Channel16>...<
 
 static unsigned int mode_mask = ATI_REMOTE2_MAX_MODE_MASK;
 #define param_check_mode_mask(name, p) __param_check(name, p, unsigned int)
-static struct kernel_param_ops param_ops_mode_mask = {
+static const struct kernel_param_ops param_ops_mode_mask = {
 	.set = ati_remote2_set_mode_mask,
 	.get = ati_remote2_get_mode_mask,
 };
diff --git a/drivers/input/mouse/psmouse-base.c b/drivers/input/mouse/psmouse-base.c
index 5bb1658..f8286b6 100644
--- a/drivers/input/mouse/psmouse-base.c
+++ b/drivers/input/mouse/psmouse-base.c
@@ -47,7 +47,7 @@ MODULE_LICENSE("GPL");
 static unsigned int psmouse_max_proto = PSMOUSE_AUTO;
 static int psmouse_set_maxproto(const char *val, const struct kernel_param *);
 static int psmouse_get_maxproto(char *buffer, const struct kernel_param *kp);
-static struct kernel_param_ops param_ops_proto_abbrev = {
+static const struct kernel_param_ops param_ops_proto_abbrev = {
 	.set = psmouse_set_maxproto,
 	.get = psmouse_get_maxproto,
 };
diff --git a/drivers/misc/lis3lv02d/lis3lv02d.c b/drivers/misc/lis3lv02d/lis3lv02d.c
index 4739689..fb8705f 100644
--- a/drivers/misc/lis3lv02d/lis3lv02d.c
+++ b/drivers/misc/lis3lv02d/lis3lv02d.c
@@ -115,7 +115,7 @@ static int param_set_axis(const char *val, const struct kernel_param *kp)
 	return ret;
 }
 
-static struct kernel_param_ops param_ops_axis = {
+static const struct kernel_param_ops param_ops_axis = {
 	.set = param_set_axis,
 	.get = param_get_int,
 };
diff --git a/drivers/mtd/ubi/block.c b/drivers/mtd/ubi/block.c
index db2c05b..5d2751b 100644
--- a/drivers/mtd/ubi/block.c
+++ b/drivers/mtd/ubi/block.c
@@ -161,7 +161,7 @@ static int __init ubiblock_set_param(const char *val,
 	return 0;
 }
 
-static struct kernel_param_ops ubiblock_param_ops = {
+static const struct kernel_param_ops ubiblock_param_ops = {
 	.set    = ubiblock_set_param,
 };
 module_param_cb(block, &ubiblock_param_ops, NULL, 0);
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index c2a2384..790c3df 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -58,7 +58,7 @@ static int mtu_max_set(const char *val, const struct kernel_param *kp)
 	return ret;
 }
 
-static struct kernel_param_ops mtu_max_ops = {
+static const struct kernel_param_ops mtu_max_ops = {
 	.set = mtu_max_set,
 	.get = param_get_uint,
 };
@@ -87,7 +87,7 @@ static int ring_order_set(const char *val, const struct kernel_param *kp)
 	return 0;
 }
 
-static struct kernel_param_ops ring_order_ops = {
+static const struct kernel_param_ops ring_order_ops = {
 	.set = ring_order_set,
 	.get = param_get_uint,
 };
diff --git a/drivers/power/test_power.c b/drivers/power/test_power.c
index f986e0c..83c42ea 100644
--- a/drivers/power/test_power.c
+++ b/drivers/power/test_power.c
@@ -448,42 +448,42 @@ static int param_set_battery_voltage(const char *key,
 
 #define param_get_battery_voltage param_get_int
 
-static struct kernel_param_ops param_ops_ac_online = {
+static const struct kernel_param_ops param_ops_ac_online = {
 	.set = param_set_ac_online,
 	.get = param_get_ac_online,
 };
 
-static struct kernel_param_ops param_ops_usb_online = {
+static const struct kernel_param_ops param_ops_usb_online = {
 	.set = param_set_usb_online,
 	.get = param_get_usb_online,
 };
 
-static struct kernel_param_ops param_ops_battery_status = {
+static const struct kernel_param_ops param_ops_battery_status = {
 	.set = param_set_battery_status,
 	.get = param_get_battery_status,
 };
 
-static struct kernel_param_ops param_ops_battery_present = {
+static const struct kernel_param_ops param_ops_battery_present = {
 	.set = param_set_battery_present,
 	.get = param_get_battery_present,
 };
 
-static struct kernel_param_ops param_ops_battery_technology = {
+static const struct kernel_param_ops param_ops_battery_technology = {
 	.set = param_set_battery_technology,
 	.get = param_get_battery_technology,
 };
 
-static struct kernel_param_ops param_ops_battery_health = {
+static const struct kernel_param_ops param_ops_battery_health = {
 	.set = param_set_battery_health,
 	.get = param_get_battery_health,
 };
 
-static struct kernel_param_ops param_ops_battery_capacity = {
+static const struct kernel_param_ops param_ops_battery_capacity = {
 	.set = param_set_battery_capacity,
 	.get = param_get_battery_capacity,
 };
 
-static struct kernel_param_ops param_ops_battery_voltage = {
+static const struct kernel_param_ops param_ops_battery_voltage = {
 	.set = param_set_battery_voltage,
 	.get = param_get_battery_voltage,
 };
diff --git a/drivers/thermal/intel_powerclamp.c b/drivers/thermal/intel_powerclamp.c
index 9b02d19..a6c840e 100644
--- a/drivers/thermal/intel_powerclamp.c
+++ b/drivers/thermal/intel_powerclamp.c
@@ -119,7 +119,7 @@ exit:
 	return ret;
 }
 
-static struct kernel_param_ops duration_ops = {
+static const struct kernel_param_ops duration_ops = {
 	.set = duration_set,
 	.get = param_get_int,
 };
@@ -167,7 +167,7 @@ exit_win:
 	return ret;
 }
 
-static struct kernel_param_ops window_size_ops = {
+static const struct kernel_param_ops window_size_ops = {
 	.set = window_size_set,
 	.get = param_get_int,
 };
diff --git a/drivers/tty/hvc/hvc_iucv.c b/drivers/tty/hvc/hvc_iucv.c
index f78a87b..bb809cf 100644
--- a/drivers/tty/hvc/hvc_iucv.c
+++ b/drivers/tty/hvc/hvc_iucv.c
@@ -1345,7 +1345,7 @@ static int param_get_vmidfilter(char *buffer, const struct kernel_param *kp)
 
 #define param_check_vmidfilter(name, p) __param_check(name, p, void)
 
-static struct kernel_param_ops param_ops_vmidfilter = {
+static const struct kernel_param_ops param_ops_vmidfilter = {
 	.set = param_set_vmidfilter,
 	.get = param_get_vmidfilter,
 };
diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
index 843f2cd..03b02c3 100644
--- a/drivers/tty/sysrq.c
+++ b/drivers/tty/sysrq.c
@@ -1002,7 +1002,7 @@ static int sysrq_reset_seq_param_set(const char *buffer,
 	return 0;
 }
 
-static struct kernel_param_ops param_ops_sysrq_reset_seq = {
+static const struct kernel_param_ops param_ops_sysrq_reset_seq = {
 	.get	= param_get_ushort,
 	.set	= sysrq_reset_seq_param_set,
 };
diff --git a/drivers/video/fbdev/uvesafb.c b/drivers/video/fbdev/uvesafb.c
index d32d1c4..178ae93 100644
--- a/drivers/video/fbdev/uvesafb.c
+++ b/drivers/video/fbdev/uvesafb.c
@@ -1977,7 +1977,7 @@ static int param_set_scroll(const char *val, const struct kernel_param *kp)
 
 	return 0;
 }
-static struct kernel_param_ops param_ops_scroll = {
+static const struct kernel_param_ops param_ops_scroll = {
 	.set = param_set_scroll,
 };
 #define param_check_scroll(name, p) __param_check(name, p, void)
diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
index 7a5e60d..10189b5 100644
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -691,7 +691,7 @@ static int vm_cmdline_get(char *buffer, const struct kernel_param *kp)
 	return strlen(buffer) + 1;
 }
 
-static struct kernel_param_ops vm_cmdline_param_ops = {
+static const struct kernel_param_ops vm_cmdline_param_ops = {
 	.set = vm_cmdline_set,
 	.get = vm_cmdline_get,
 };
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 21f8f52..3081bba 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -2849,7 +2849,7 @@ static int param_set_portnr(const char *val, const struct kernel_param *kp)
 	*((unsigned int *)kp->arg) = num;
 	return 0;
 }
-static struct kernel_param_ops param_ops_portnr = {
+static const struct kernel_param_ops param_ops_portnr = {
 	.set = param_set_portnr,
 	.get = param_get_uint,
 };
diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index 1c9effa..5d0f4d9 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -225,7 +225,7 @@ struct kparam_array
 
 /* Obsolete - use module_param_cb() */
 #define module_param_call(name, set, get, arg, perm)			\
-	static struct kernel_param_ops __param_ops_##name =		\
+	static const struct kernel_param_ops __param_ops_##name =		\
 		{ .flags = 0, (void *)set, (void *)get };		\
 	__module_param_call(MODULE_PARAM_PREFIX,			\
 			    name, &__param_ops_##name, arg,		\
@@ -376,64 +376,64 @@ static inline void destroy_params(const struct kernel_param *params,
 #define __param_check(name, p, type) \
 	static inline type __always_unused *__check_##name(void) { return(p); }
 
-extern struct kernel_param_ops param_ops_byte;
+extern const struct kernel_param_ops param_ops_byte;
 extern int param_set_byte(const char *val, const struct kernel_param *kp);
 extern int param_get_byte(char *buffer, const struct kernel_param *kp);
 #define param_check_byte(name, p) __param_check(name, p, unsigned char)
 
-extern struct kernel_param_ops param_ops_short;
+extern const struct kernel_param_ops param_ops_short;
 extern int param_set_short(const char *val, const struct kernel_param *kp);
 extern int param_get_short(char *buffer, const struct kernel_param *kp);
 #define param_check_short(name, p) __param_check(name, p, short)
 
-extern struct kernel_param_ops param_ops_ushort;
+extern const struct kernel_param_ops param_ops_ushort;
 extern int param_set_ushort(const char *val, const struct kernel_param *kp);
 extern int param_get_ushort(char *buffer, const struct kernel_param *kp);
 #define param_check_ushort(name, p) __param_check(name, p, unsigned short)
 
-extern struct kernel_param_ops param_ops_int;
+extern const struct kernel_param_ops param_ops_int;
 extern int param_set_int(const char *val, const struct kernel_param *kp);
 extern int param_get_int(char *buffer, const struct kernel_param *kp);
 #define param_check_int(name, p) __param_check(name, p, int)
 
-extern struct kernel_param_ops param_ops_uint;
+extern const struct kernel_param_ops param_ops_uint;
 extern int param_set_uint(const char *val, const struct kernel_param *kp);
 extern int param_get_uint(char *buffer, const struct kernel_param *kp);
 #define param_check_uint(name, p) __param_check(name, p, unsigned int)
 
-extern struct kernel_param_ops param_ops_long;
+extern const struct kernel_param_ops param_ops_long;
 extern int param_set_long(const char *val, const struct kernel_param *kp);
 extern int param_get_long(char *buffer, const struct kernel_param *kp);
 #define param_check_long(name, p) __param_check(name, p, long)
 
-extern struct kernel_param_ops param_ops_ulong;
+extern const struct kernel_param_ops param_ops_ulong;
 extern int param_set_ulong(const char *val, const struct kernel_param *kp);
 extern int param_get_ulong(char *buffer, const struct kernel_param *kp);
 #define param_check_ulong(name, p) __param_check(name, p, unsigned long)
 
-extern struct kernel_param_ops param_ops_ullong;
+extern const struct kernel_param_ops param_ops_ullong;
 extern int param_set_ullong(const char *val, const struct kernel_param *kp);
 extern int param_get_ullong(char *buffer, const struct kernel_param *kp);
 #define param_check_ullong(name, p) __param_check(name, p, unsigned long long)
 
-extern struct kernel_param_ops param_ops_charp;
+extern const struct kernel_param_ops param_ops_charp;
 extern int param_set_charp(const char *val, const struct kernel_param *kp);
 extern int param_get_charp(char *buffer, const struct kernel_param *kp);
 #define param_check_charp(name, p) __param_check(name, p, char *)
 
 /* We used to allow int as well as bool.  We're taking that away! */
-extern struct kernel_param_ops param_ops_bool;
+extern const struct kernel_param_ops param_ops_bool;
 extern int param_set_bool(const char *val, const struct kernel_param *kp);
 extern int param_get_bool(char *buffer, const struct kernel_param *kp);
 #define param_check_bool(name, p) __param_check(name, p, bool)
 
-extern struct kernel_param_ops param_ops_invbool;
+extern const struct kernel_param_ops param_ops_invbool;
 extern int param_set_invbool(const char *val, const struct kernel_param *kp);
 extern int param_get_invbool(char *buffer, const struct kernel_param *kp);
 #define param_check_invbool(name, p) __param_check(name, p, bool)
 
 /* An int, which can only be set like a bool (though it shows as an int). */
-extern struct kernel_param_ops param_ops_bint;
+extern const struct kernel_param_ops param_ops_bint;
 extern int param_set_bint(const char *val, const struct kernel_param *kp);
 #define param_get_bint param_get_int
 #define param_check_bint param_check_int
@@ -477,9 +477,9 @@ extern int param_set_bint(const char *val, const struct kernel_param *kp);
 			    perm, -1, 0);				\
 	__MODULE_PARM_TYPE(name, "array of " #type)
 
-extern struct kernel_param_ops param_array_ops;
+extern const struct kernel_param_ops param_array_ops;
 
-extern struct kernel_param_ops param_ops_string;
+extern const struct kernel_param_ops param_ops_string;
 extern int param_set_copystring(const char *val, const struct kernel_param *);
 extern int param_get_string(char *buffer, const struct kernel_param *kp);
 
diff --git a/kernel/params.c b/kernel/params.c
index a22d6a7..b7635c0 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -251,7 +251,7 @@ char *parse_args(const char *doing,
 		return scnprintf(buffer, PAGE_SIZE, format,		\
 				*((type *)kp->arg));			\
 	}								\
-	struct kernel_param_ops param_ops_##name = {			\
+	const struct kernel_param_ops param_ops_##name = {			\
 		.set = param_set_##name,				\
 		.get = param_get_##name,				\
 	};								\
@@ -303,7 +303,7 @@ static void param_free_charp(void *arg)
 	maybe_kfree_parameter(*((char **)arg));
 }
 
-struct kernel_param_ops param_ops_charp = {
+const struct kernel_param_ops param_ops_charp = {
 	.set = param_set_charp,
 	.get = param_get_charp,
 	.free = param_free_charp,
@@ -328,7 +328,7 @@ int param_get_bool(char *buffer, const struct kernel_param *kp)
 }
 EXPORT_SYMBOL(param_get_bool);
 
-struct kernel_param_ops param_ops_bool = {
+const struct kernel_param_ops param_ops_bool = {
 	.flags = KERNEL_PARAM_OPS_FL_NOARG,
 	.set = param_set_bool,
 	.get = param_get_bool,
@@ -356,7 +356,7 @@ int param_get_invbool(char *buffer, const struct kernel_param *kp)
 }
 EXPORT_SYMBOL(param_get_invbool);
 
-struct kernel_param_ops param_ops_invbool = {
+const struct kernel_param_ops param_ops_invbool = {
 	.set = param_set_invbool,
 	.get = param_get_invbool,
 };
@@ -379,7 +379,7 @@ int param_set_bint(const char *val, const struct kernel_param *kp)
 }
 EXPORT_SYMBOL(param_set_bint);
 
-struct kernel_param_ops param_ops_bint = {
+const struct kernel_param_ops param_ops_bint = {
 	.flags = KERNEL_PARAM_OPS_FL_NOARG,
 	.set = param_set_bint,
 	.get = param_get_int,
@@ -476,7 +476,7 @@ static void param_array_free(void *arg)
 			arr->ops->free(arr->elem + arr->elemsize * i);
 }
 
-struct kernel_param_ops param_array_ops = {
+const struct kernel_param_ops param_array_ops = {
 	.set = param_array_set,
 	.get = param_array_get,
 	.free = param_array_free,
@@ -504,7 +504,7 @@ int param_get_string(char *buffer, const struct kernel_param *kp)
 }
 EXPORT_SYMBOL(param_get_string);
 
-struct kernel_param_ops param_ops_string = {
+const struct kernel_param_ops param_ops_string = {
 	.set = param_set_copystring,
 	.get = param_get_string,
 };
diff --git a/net/sunrpc/auth.c b/net/sunrpc/auth.c
index 47f38be..02f5367 100644
--- a/net/sunrpc/auth.c
+++ b/net/sunrpc/auth.c
@@ -72,7 +72,7 @@ static int param_get_hashtbl_sz(char *buffer, const struct kernel_param *kp)
 
 #define param_check_hashtbl_sz(name, p) __param_check(name, p, unsigned int);
 
-static struct kernel_param_ops param_ops_hashtbl_sz = {
+static const struct kernel_param_ops param_ops_hashtbl_sz = {
 	.set = param_set_hashtbl_sz,
 	.get = param_get_hashtbl_sz,
 };
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 66891e3..b051728 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2982,7 +2982,7 @@ static int param_set_portnr(const char *val, const struct kernel_param *kp)
 			RPC_MAX_RESVPORT);
 }
 
-static struct kernel_param_ops param_ops_portnr = {
+static const struct kernel_param_ops param_ops_portnr = {
 	.set = param_set_portnr,
 	.get = param_get_uint,
 };
@@ -3001,7 +3001,7 @@ static int param_set_slot_table_size(const char *val,
 			RPC_MAX_SLOT_TABLE);
 }
 
-static struct kernel_param_ops param_ops_slot_table_size = {
+static const struct kernel_param_ops param_ops_slot_table_size = {
 	.set = param_set_slot_table_size,
 	.get = param_get_uint,
 };
@@ -3017,7 +3017,7 @@ static int param_set_max_slot_table_size(const char *val,
 			RPC_MAX_SLOT_TABLE_LIMIT);
 }
 
-static struct kernel_param_ops param_ops_max_slot_table_size = {
+static const struct kernel_param_ops param_ops_max_slot_table_size = {
 	.set = param_set_max_slot_table_size,
 	.get = param_get_uint,
 };
diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index e5f1561..45eb96d 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -667,7 +667,7 @@ static struct security_operations apparmor_ops = {
 static int param_set_aabool(const char *val, const struct kernel_param *kp);
 static int param_get_aabool(char *buffer, const struct kernel_param *kp);
 #define param_check_aabool param_check_bool
-static struct kernel_param_ops param_ops_aabool = {
+static const struct kernel_param_ops param_ops_aabool = {
 	.flags = KERNEL_PARAM_OPS_FL_NOARG,
 	.set = param_set_aabool,
 	.get = param_get_aabool
@@ -676,7 +676,7 @@ static struct kernel_param_ops param_ops_aabool = {
 static int param_set_aauint(const char *val, const struct kernel_param *kp);
 static int param_get_aauint(char *buffer, const struct kernel_param *kp);
 #define param_check_aauint param_check_uint
-static struct kernel_param_ops param_ops_aauint = {
+static const struct kernel_param_ops param_ops_aauint = {
 	.set = param_set_aauint,
 	.get = param_get_aauint
 };
@@ -684,7 +684,7 @@ static struct kernel_param_ops param_ops_aauint = {
 static int param_set_aalockpolicy(const char *val, const struct kernel_param *kp);
 static int param_get_aalockpolicy(char *buffer, const struct kernel_param *kp);
 #define param_check_aalockpolicy param_check_bool
-static struct kernel_param_ops param_ops_aalockpolicy = {
+static const struct kernel_param_ops param_ops_aalockpolicy = {
 	.flags = KERNEL_PARAM_OPS_FL_NOARG,
 	.set = param_set_aalockpolicy,
 	.get = param_get_aalockpolicy
diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index 686355f..e24121a 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -55,7 +55,7 @@ static int param_set_bufsize(const char *val, const struct kernel_param *kp)
 	return 0;
 }
 
-static struct kernel_param_ops param_ops_bufsize = {
+static const struct kernel_param_ops param_ops_bufsize = {
 	.set = param_set_bufsize,
 	.get = param_get_uint,
 };
diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index e1c2105..959df73 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -166,7 +166,7 @@ MODULE_PARM_DESC(beep_mode, "Select HDA Beep registration mode "
 
 #ifdef CONFIG_PM
 static int param_set_xint(const char *val, const struct kernel_param *kp);
-static struct kernel_param_ops param_ops_xint = {
+static const struct kernel_param_ops param_ops_xint = {
 	.set = param_set_xint,
 	.get = param_get_int,
 };
-- 
2.3.2.209.gd67f9d5.dirty

