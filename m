Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:35449 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758112AbbDVV50 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2015 17:57:26 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: rusty@rustcorp.com.au
Cc: akpm@linux-foundation.org, mingo@kernel.org, tj@kernel.org,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	keescook@chromium.org, casey@schaufler-ca.com,
	cocci@systeme.lip6.fr, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH v2 0/8] module params: few simplifications
Date: Wed, 22 Apr 2015 14:55:03 -0700
Message-Id: <1429739711-9415-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20150422_235732_388840_8BDB04FC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@suse.com>

This v2 splits out the #ifdef'ery eyesores out into separate
patches to make it clear this is a separate atomic operation
which requires review in and of itself. It also makes some
clarifications about how the module_param_config_*() can help
with eyesores, and also documents our paranoia over avoiding
bool_enable_only for now on CONFIG_MODULE_SIG_FORCE kernels.

It could be that we are comfortable with bool_enable_only's
implementation even for CONFIG_MODULE_SIG_FORCE kernels -- but
I'd rather let someone dealing with policy decide that.

Luis R. Rodriguez (8):
  kernel/params: constify struct kernel_param_ops uses
  kernel/module.c: use generic module param operaters for sig_enforce
  kernel/params.c: generalize bool_enable_only
  moduleparam.h: add module_param_config_*() helpers
  kernel/workqueue.c: remove ifdefs over wq_power_efficient
  kernel/workqueue.c: use module_param_config_on_off() for
    power_efficient
  kernel/module.c: avoid ifdefs for sig_enforce declaration
  kernel/module.c: use module_param_config_on() for sig_enforce

 arch/s390/kernel/perf_cpum_sf.c         |  2 +-
 arch/x86/kvm/mmu_audit.c                |  2 +-
 arch/x86/platform/uv/uv_nmi.c           |  2 +-
 drivers/block/null_blk.c                |  4 +-
 drivers/char/ipmi/ipmi_watchdog.c       |  6 +--
 drivers/dma/dmatest.c                   |  4 +-
 drivers/ide/ide.c                       |  2 +-
 drivers/infiniband/ulp/srp/ib_srp.c     |  4 +-
 drivers/input/misc/ati_remote2.c        |  4 +-
 drivers/input/mouse/psmouse-base.c      |  2 +-
 drivers/misc/lis3lv02d/lis3lv02d.c      |  2 +-
 drivers/mtd/ubi/block.c                 |  2 +-
 drivers/net/wireless/ath/wil6210/main.c |  4 +-
 drivers/power/test_power.c              | 16 ++++----
 drivers/thermal/intel_powerclamp.c      |  4 +-
 drivers/tty/hvc/hvc_iucv.c              |  2 +-
 drivers/tty/sysrq.c                     |  2 +-
 drivers/video/fbdev/uvesafb.c           |  2 +-
 drivers/virtio/virtio_mmio.c            |  2 +-
 fs/nfs/super.c                          |  2 +-
 include/linux/moduleparam.h             | 73 ++++++++++++++++++++++++++-------
 kernel/module.c                         | 40 ++----------------
 kernel/params.c                         | 44 ++++++++++++++++----
 kernel/workqueue.c                      |  8 +---
 net/sunrpc/auth.c                       |  2 +-
 net/sunrpc/xprtsock.c                   |  6 +--
 security/apparmor/lsm.c                 |  6 +--
 security/integrity/ima/ima_crypto.c     |  2 +-
 sound/pci/hda/hda_intel.c               |  2 +-
 29 files changed, 143 insertions(+), 110 deletions(-)

-- 
2.3.2.209.gd67f9d5.dirty

