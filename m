Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93FAF47986D;
	Tue, 22 Sep 2026 07:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790061794; cv=none; b=BwE7E7Yr+tcQyrlASXjU9XVr5w/PeRMNjtm4RxsnZf5LHRYOYxz0KWD9cLz5zUaObdqT72EO474kixfSzWmISxabM3XFO3KFcEToqJ8YHx96J7uC2jmy59JqSCs5+TkDQ/2R+UHH2ayyK7JGLUxXI3/7r4eFpu2YWmijTCqWXLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790061794; c=relaxed/simple;
	bh=oG0xvub+pWhjgDDUHqMEF75UKWqTKLX50Voi38p/N0k=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=jXzZIlNLvdA8v5ojrpbKSbPvYJAl6hU3zB6oBPCFn/bZazMdNr+ZMeGfR/uRNFrhXLvHY4n/Zf2W66rr+dg0SXGYCLWUVF5nkxsZ3a5j6YCZprSDRBn/ymI6XzQs2shBrp45pOgmCChIinVFPrnoFnqwvx3wRsYhYa/ePqg4exY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nkSLojwn; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nkSLojwn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790061791; x=1821597791;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=oG0xvub+pWhjgDDUHqMEF75UKWqTKLX50Voi38p/N0k=;
  b=nkSLojwnj8RN7U17+9aEYhw5GHQppC1bAqivcSeg2S3FBoY/5o6nT0bJ
   aGg1o+9S0agbW6fTsXNXuFUY+7o5zrxxsZJOnNo2+kB/fx4L3bgo7WFh+
   MLX8gBKjIokpJVWibnFnCuy/dyVfEz9xNOcrWV25ZD1jsGKBTbFWkgi8U
   dzFBxxocsWiowrJHR+qfSlx+nSyeoweB9DIm6GoOwEodL2vTwDzZv7joZ
   0F6r4RHLsILTWokT036HNp8JZIl6x5ME+HICuV7ghuBYDegjneHJj8QyI
   OxmJlUy2aSYbr9DmmeClHun2ncatl3FrX28zBkxFuhKoYmDR95dwwckWP
   Q==;
X-CSE-ConnectionGUID: RI2co96HQrK//6NaUJ9NHg==
X-CSE-MsgGUID: SaJWA5nfRaWDoQMWSmY4UQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="101230203"
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="101230203"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 00:23:11 -0700
X-CSE-ConnectionGUID: cH0olBJBTGy/6woawrGjpQ==
X-CSE-MsgGUID: 5kYOOCXET7GNklhLXKQ4dg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="300941614"
Received: from ly-workstation.sh.intel.com (HELO ly-workstation) ([10.239.182.64])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 00:23:08 -0700
Date: Tue, 22 Sep 2026 15:23:00 +0800
From: kernel test robot <yi1.lai@intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com,
	linux-arm-kernel@lists.infradead.org, arm@kernel.org,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev, brcm80211-dev-list.pdl@broadcom.com,
	yi1.lai@intel.com
Subject: [soc:board-remove-7.3] [net]  8d91a5ecce:
 EIP:kernfs_remove_by_name_ns
Message-ID: <202609221423.71fce5fb-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline



Hello,

kernel test robot noticed "EIP:kernfs_remove_by_name_ns" on:

commit: 8d91a5ecce11412c646ad1f1637334ef9546ea90 ("net: wireless: brcmfmac: remove platform data based probe") https://git.kernel.org/cgit/linux/kernel/git/soc/soc.git board-remove-7.3

in testcase: boot

config: i386-randconfig-011-20260914
compiler: clang-22
test machine: qemu-system-i386 -enable-kvm -cpu SandyBridge -smp 4 -m 4G

If you fix the issue in a separate patch/commit (i.e. not just a new version of the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <yi1.lai@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202609221423.71fce5fb-lkp@intel.com


[    5.486950][    T1] ------------[ cut here ]------------
[    5.488426][    T1] kernfs: can not remove 'uevent', no directory
[    5.489919][    T1] WARNING: fs/kernfs/dir.c:1786 at kernfs_remove_by_name_ns+0x7b/0xc0, CPU#0: swapper/0/1
[    5.492378][    T1] Modules linked in:
[    5.493281][    T1] CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted 7.3.0-rc2-00073-g8d91a5ecce11 #1 PREEMPTLAZY
[    5.495837][    T1] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[    5.498316][    T1] EIP: kernfs_remove_by_name_ns (kernfs/dir.c:1785)
[    5.499706][    T1] Code: 74 5a a8 03 75 5c ff 00 89 c1 89 c6 e8 5e f9 ff ff 89 f0 e8 d7 d8 ff ff 31 f6 eb 1c 53 68 30 84 07 c3 e8 08 1b d4 ff 83 c4 08 <0f> 0b be fe ff ff ff eb 14 be fe ff ff ff 89 f8 e8 70 da da ff 8b
All code
========
   0:	74 5a                	je     0x5c
   2:	a8 03                	test   $0x3,%al
   4:	75 5c                	jne    0x62
   6:	ff 00                	incl   (%rax)
   8:	89 c1                	mov    %eax,%ecx
   a:	89 c6                	mov    %eax,%esi
   c:	e8 5e f9 ff ff       	call   0xfffffffffffff96f
  11:	89 f0                	mov    %esi,%eax
  13:	e8 d7 d8 ff ff       	call   0xffffffffffffd8ef
  18:	31 f6                	xor    %esi,%esi
  1a:	eb 1c                	jmp    0x38
  1c:	53                   	push   %rbx
  1d:	68 30 84 07 c3       	push   $0xffffffffc3078430
  22:	e8 08 1b d4 ff       	call   0xffffffffffd41b2f
  27:	83 c4 08             	add    $0x8,%esp
  2a:*	0f 0b                	ud2		<-- trapping instruction
  2c:	be fe ff ff ff       	mov    $0xfffffffe,%esi
  31:	eb 14                	jmp    0x47
  33:	be fe ff ff ff       	mov    $0xfffffffe,%esi
  38:	89 f8                	mov    %edi,%eax
  3a:	e8 70 da da ff       	call   0xffffffffffdadaaf
  3f:	8b                   	.byte 0x8b

Code starting with the faulting instruction ===========================================
   0:	0f 0b                	ud2
   2:	be fe ff ff ff       	mov    $0xfffffffe,%esi
   7:	eb 14                	jmp    0x1d
   9:	be fe ff ff ff       	mov    $0xfffffffe,%esi
   e:	89 f8                	mov    %edi,%eax
  10:	e8 70 da da ff       	call   0xffffffffffdada85
  15:	8b                   	.byte 0x8b
[    5.504411][    T1] EAX: 00000000 EBX: c3095d8c ECX: 00000000 EDX: 00000000
[    5.506084][    T1] ESI: c35f2608 EDI: c01dd42c EBP: c0245c1c ESP: c0245c08
[    5.507830][    T1] DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068 EFLAGS: 00010282
[    5.509606][    T1] CR0: 80050033 CR2: ffd97000 CR3: 0386e000 CR4: 000406d0
[    5.511412][    T1] Call Trace:
[    5.512419][    T1]  driver_remove_file (sysfs/file.c:515 linux/sysfs.h:780 base/driver.c:126)
[    5.513635][    T1]  bus_remove_driver (base/bus.c:830)
[    5.514785][    T1]  driver_unregister (base/driver.c:202)
[    5.515927][    T1]  brcmfmac_module_init (base/platform.c:1005 net/wireless/broadcom/brcm80211/brcmfmac/common.c:580)
[    5.517104][    T1]  __initstub__kmod_brcmfmac__510_591_brcmfmac_module_init6 (net/wireless/broadcom/brcm80211/brcmfmac/common.c:591)
[    5.519013][    T1]  do_one_initcall (main.c:1357)
[    5.520164][    T1]  ? __initstub__kmod_ath6kl_sdio__508_1430_ath6kl_sdio_driver_init6 (usercopy_32.c:?)
[    5.522289][    T1]  ? __lock_acquire (locking/lockdep.c:4718)
[    5.523491][    T1]  ? __lock_acquire (locking/lockdep.c:4718)
[    5.525180][    T1]  ? lock_acquire (locking/lockdep.c:5942)
[    5.526824][    T1]  ? __lock_acquire (locking/lockdep.c:4718)
[    5.530956][    T1]  ? __lock_acquire (locking/lockdep.c:4718)
[    5.532755][    T1]  ? lock_acquire (locking/lockdep.c:5942)
[    5.534332][    T1]  ? lock_acquire (locking/lockdep.c:5942)
[    5.536001][    T1]  ? __this_cpu_preempt_check (smp_processor_id.c:64)
[    5.537894][    T1]  ? __this_cpu_preempt_check (smp_processor_id.c:64)
[    5.539914][    T1]  ? ktime_get (time/timekeeping.c:1002)
[    5.541408][    T1]  ? ktime_get (time/timekeeping.c:1002)
[    5.542911][    T1]  ? ktime_get (time/timekeeping.c:321 time/timekeeping.c:482 time/timekeeping.c:1004)
[    5.544554][    T1]  ? clockevents_program_event (time/clockevents.c:372)
[    5.546602][    T1]  ? irqentry_exit (linux/irq-entry-common.h:507)
[    5.548377][    T1]  ? __this_cpu_preempt_check (smp_processor_id.c:64)
[    5.550315][    T1]  ? lockdep_hardirqs_on (locking/lockdep.c:4516)
[    5.552128][    T1]  ? irqentry_exit (linux/irq-entry-common.h:507)
[    5.553774][    T1]  ? sysvec_apic_timer_interrupt (x86/kernel/apic/apic.c:1062)
[    5.559179][    T1]  ? trace_hardirqs_on (trace/trace_preemptirq.c:79)
[    5.560942][    T1]  ? vmware_sched_clock (vmware.c:?)
[    5.562784][    T1]  ? irqentry_exit (linux/irq-entry-common.h:507)
[    5.564594][    T1]  ? vmware_sched_clock (vmware.c:?)
[    5.566492][    T1]  ? sysvec_apic_timer_interrupt (x86/kernel/apic/apic.c:1062)
[    5.568555][    T1]  ? handle_exception (x86/entry/entry_32.S:1044)
[    5.570285][    T1]  ? parameq (params.c:98)
[    5.571797][    T1]  ? next_arg (cmdline.c:283)
[    5.573381][    T1]  ? parameq (linux/fortify-string.h:218 params.c:99)
[    5.574711][    T1]  ? parse_args (params.c:153)
[    5.579714][    T1]  do_initcall_level (main.c:1419)
[    5.581382][    T1]  do_initcalls (main.c:1435)
[    5.582841][    T1]  ? rest_init (main.c:?)
[    5.584478][    T1]  do_basic_setup (main.c:1455)
[    5.586016][    T1]  kernel_init_freeable (main.c:1670)
[    5.587875][    T1]  ? rest_init (main.c:?)
[    5.589472][    T1]  kernel_init (main.c:1560)
[    5.590987][    T1]  ret_from_fork (x86/kernel/process.c:158)
[    5.592643][    T1]  ? rest_init (main.c:?)
[    5.594157][    T1]  ret_from_fork_asm (x86/entry/entry_32.S:736)
[    5.595882][    T1]  entry_INT80_32 (x86/entry/entry_32.S:940)
[    5.597546][    T1] irq event stamp: 90237
[    5.598888][    T1] hardirqs last  enabled at (90251): __console_unlock (printk/printk.c:347)
[    5.600980][    T1] hardirqs last disabled at (90266): __console_unlock (printk/printk.c:345)
[    5.603033][    T1] softirqs last  enabled at (90070): __do_softirq (softirq.c:679)
[    5.604968][    T1] softirqs last disabled at (90061): __do_softirq (softirq.c:679)
[    5.606947][    T1] ---[ end trace 0000000000000000 ]---


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260922/202609221423.71fce5fb-lkp@intel.com



--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

