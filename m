Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34807 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbbDTXap (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2015 19:30:45 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	keescook@chromium.org, casey@schaufler-ca.com,
	cocci@systeme.lip6.fr, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH v1 0/6] module params: few simplifications
Date: Mon, 20 Apr 2015 16:30:31 -0700
Message-Id: <1429572637-30234-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20150421_013103_117090_0ACD9A04)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@suse.com>

Here are a few simplifications on the sig_force module parameter code.
I'm digging through this as long term I'd like enable standard use of
the crypto code for module loading for firmware loading and later
any file requested (non firmware) to replace udev deamons such as
CRDA which should no longer be needed.

Short term this means seeing what code we could re-use and the option
to only force enable/passively enable signing is one of the options
I'd like to see we keep for firmware signing. The same grammar as used
for module signing can be used, but instead of copy+pasting code I
decided to take generalize the feature option of sig_force, make it
generic, learn from its implmentation of using const, making that
generic and lastly to simplify this even further to one line code
as I had done for the early_param_on_off() stuff recently. Since I'm
also adding an on_off() case for module parameters I had to find a
example simple use case for that, picked workqueue for that.

We might later be able to use SmPL grammar to replace a lot of old code
with these helpers (including early_param_on_off) but will let others look
into that as I'd like to complete other tasks.

All this goes test compiled on x86_64 on:

  * allnoconfig
  * allmodconfig
  * allyesconfig

This series was based on top of linux-next next-20150420.

Luis R. Rodriguez (6):
  kernel/params: constify struct kernel_param_ops uses
  kernel/module.c: use generic module param operaters for sig_enforce
  kernel/params.c: generalize bool_enable_only
  moduleparam.h: add module_param_config_*() helpers
  kernel/workqueue.c: use module_param_config_on_off() for
    power_efficient
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
 kernel/module.c                         | 37 +----------------
 kernel/params.c                         | 44 ++++++++++++++++----
 kernel/workqueue.c                      |  8 +---
 net/sunrpc/auth.c                       |  2 +-
 net/sunrpc/xprtsock.c                   |  6 +--
 security/apparmor/lsm.c                 |  6 +--
 security/integrity/ima/ima_crypto.c     |  2 +-
 sound/pci/hda/hda_intel.c               |  2 +-
 29 files changed, 141 insertions(+), 109 deletions(-)

-- 
2.3.2.209.gd67f9d5.dirty

