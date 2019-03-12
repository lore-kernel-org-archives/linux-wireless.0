Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D3EAC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 23:11:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42E28217D9
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 23:11:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbfCLXIP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 19:08:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:27628 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726755AbfCLXIO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 19:08:14 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2019 16:08:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,472,1544515200"; 
   d="scan'208";a="326744212"
Received: from romley-ivt3.sc.intel.com ([172.25.110.60])
  by fmsmga006.fm.intel.com with ESMTP; 12 Mar 2019 16:08:13 -0700
From:   Fenghua Yu <fenghua.yu@intel.com>
To:     "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, "H Peter Anvin" <hpa@zytor.com>,
        "Dave Hansen" <dave.hansen@intel.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Ashok Raj" <ashok.raj@intel.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Xiaoyao Li " <xiaoyao.li@intel.com>,
        "Michael Chan" <michael.chan@broadcom.com>,
        "Ravi V Shankar" <ravi.v.shankar@intel.com>
Cc:     "linux-kernel" <linux-kernel@vger.kernel.org>,
        "x86" <x86@kernel.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH v5 00/18] x86/split_lock: Enable #AC exception for split locked accesses
Date:   Tue, 12 Mar 2019 16:00:18 -0700
Message-Id: <1552431636-31511-1-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 2.5.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

==Introduction==

A split lock is any atomic operation whose operand crosses two cache
lines. Since the operand spans two cache lines and the operation must
be atomic, the system locks the bus while the CPU accesses the two cache
lines.

During bus locking, request from other CPUs or bus agents for control
of the bus are blocked. Blocking bus access from other CPUs plus
overhead of configuring bus locking protocol degrade not only the
performance of one CPU but overall system performance.

If operand is cacheable and completely contained in one cache line, atomic
operation is optimized by less expensive cache locking on Intel P6 and
recent processors. If split lock is detected and the two cache lines in the
operand can be merged into one cache line, cache locking instead of
more expensive bus locking will be used for atomic operation. Removing
split lock can improve overall performance.

Instructions that may cause split lock issue include lock add, lock btc,
xchg, lsl, far call, ltr, etc.

More information about split lock, bus locking, and cache locking can be
found in the latest Intel 64 and IA-32 Architecture Software Developer's
Manual.

==Split lock detection==

Currently we can trace split lock event counter sq_misc.split_lock
for debug purpose. But for system deployed in the field, this event
counter after the fact is insufficient. We need a mechanism that
detects split lock before it happens to ensure that bus lock is never
incurred due to split lock.

Intel introduces a mechanism to detect split lock via Alignment Check
(#AC) exception before badly aligned atomic instructions might impact
whole system performance in Tremont and other future processors. 

This capability is critical for real time system designers who build
consolidated real time systems. These systems run hard real time
code on some cores and run "untrusted" user processes on some
other cores. The hard real time cannot afford to have any bus lock from
the untrusted processes to hurt real time performance. To date the
designers have been unable to deploy these solutions as they have no
way to prevent the "untrusted" user code from generating split lock and
bus lock to block the hard real time code to access memory during bus
locking.

This capability may also find usage in cloud. A user process with split
lock running in one guest can block other cores from accessing shared
memory during its split locked memory access. That may cause overall
system performance degradation.

Split lock may open a security hole where malicious user code may slow
down overall system by executing instructions with split lock.

==Enumerate #AC for split lock==

A control bit (bit 29) in TEST_CTL MSR 0x33 will be introduced in
future x86 processors. When the bit 29 is set, the processor causes
#AC exception for split locked accesses at all CPL.

The split lock detection feature is enumerated through bit 5 in
MSR IA32_CORE_CAPABILITY (0xCF). The MSR 0xCF itself is enumerated by
CPUID.(EAX=0x7,ECX=0):EDX[30].

The enumeration method is published in the latest Intel Software
Developer's Manual.

A few processors don't follow the above enumeration. For those processors,
we can enable #AC for split lock based on their FMS numbers. We will
enable split lock detection on those processors in the future once their
FMS numbers are public.

==Handle Split Lock===

There may be different considerations to handle split lock, e.g. how
to handle split lock issue in firmware after kernel enables #AC for
split lock.

But we use a simple way to handle split lock which is suggested
by Thomas Gleixner and Dave Hansen:

- If split lock happens in kernel, a warning is issued and #AC for
split lock is disabled on the local CPU. The split lock issue should
be fixed in kernel.

- If split lock happens in user process, the process is killed by
SIGBUS. Unless the issue is fixed, the process cannot run in the
system.

- If split lock happens in firmware, system may hang in firmware. The
issue should be fixed in firmware.

- Enable split lock detection by default once the feature is enumerated.

- Disable split lock detection by "clearcpuid=split_lock_detect" during
boot time.

- Disable/enable split lock detection by interface
/sys/devices/system/cpu/split_lock_detect during run time.

==Expose to guest==

To expose this feature to guest, we need to
1. report the new CPUID bit to guest.
2. emulate IA32_CORE_CAPABILITIES MSR.
3. emulate TEST_CTL MSR. We must do it. Since this patch
series enable split lock detection in host kernel by default, if we do
not emualte TEST_CTL MSR for guest, guest will run with the value set
by host without knowing that. So guest will run with split lock detection
enabled due to the host's value. Thus guest running with buggy firmware
and old kernel will fail because they lack the ability to handle #AC for
split lock. So we should emulate TEST_CTL MSR and separate its value
between host and guest.

==Patches==
Patch 1-4: Fix a few existing split lock issues.
Patch 5-8: Enumerate features and define MSR TEST_CTL.
Patch 9: Handle #AC for split lock
Patch 10-11: Enable split lock detection in KVM.
Patch 12: Enable #AC for split lock by default after #AC handler and KVM
are installed
Patch 13: /sys interface to enable/disable split lock detection
Patch 14-18: Extend "clearcpuid=" option.

==Changelog==
v5:
- Fix wlcore issue from Paolo Bonzini
- Fix b44 issue from Peter Zijlstra
- Change init sequence by Dave Hansen
- Fix KVM issues from Paolo Bonzini
- Re-order patch sequence

v4:
- Remove "setcpuid=" option
- Enable IA32_CORE_CAPABILITY enumeration for split lock
- Handle CPUID faulting by Peter Zijlstra
- Enable /sys interface to enable/disable split lock detection

v3:
- Handle split lock as suggested by Thomas Gleixner.
- Fix a few potential spit lock issues suggested by Thomas Gleixner.
- Support kernel option "setcpuid=" suggested by Dave Hanson and Thomas
Gleixner.
- Support flag string in "clearcpuid=" suggested by Dave Hanson and
Thomas Gleixner.

v2:
- Remove code that handles split lock issue in firmware and fix
x86_capability issue mainly based on comments from Thomas Gleixner and
Peter Zijlstra.

In previous version:
Comments from Dave Hansen:
- Enumerate feature in X86_FEATURE_SPLIT_LOCK_AC
- Separate #AC handler from do_error_trap
- Use CONFIG to configure inherit BIOS setting, enable, or disable split
  lock. Remove kernel parameter "split_lock_ac="
- Change config interface to debugfs from sysfs
- Fix a few bisectable issues
- Other changes.

Comment from Tony Luck and Dave Hansen:
- Dump right information in #AC handler

Comment from Alan Cox and Dave Hansen:
- Description of split lock in patch 0

Others:
- Remove tracing because we can trace split lock in existing
  sq_misc.split_lock.
- Add CONFIG to configure either panic or re-execute faulting instruction
  for split lock in kernel.
- other minor changes.

Fenghua Yu (13):
  x86/common: Align cpu_caps_cleared and cpu_caps_set to unsigned long
  x86/split_lock: Align x86_capability to unsigned long to avoid split
    locked access
  x86/cpufeatures: Enumerate IA32_CORE_CAPABILITIES MSR
  x86/msr-index: Define IA32_CORE_CAPABILITY MSR and #AC exception for
    split lock bit
  x86/split_lock: Enumerate #AC for split lock by MSR
    IA32_CORE_CAPABILITY
  x86/split_lock: Define MSR TEST_CTL register
  x86/split_lock: Handle #AC exception for split lock
  x86/split_lock: Enable #AC for split lock by default
  x86/split_lock: Add a sysfs interface to allow user to enable or
    disable split lock detection on all CPUs during run time
  x86/clearcpuid: Support multiple clearcpuid options
  x86/clearcpuid: Support feature flag string in kernel option
    clearcpuid
  x86/clearcpuid: Apply cleared feature bits that are forced set before
  Change document for kernel option clearcpuid

Paolo Bonzini (1):
  wlcore: simplify/fix/optimize reg_ch_conf_pending operations

Peter Zijlstra (2):
  drivers/net/b44: Align pwol_mask to unsigned long for better
    performance
  x86/clearcpuid: Clear CPUID bit in CPUID faulting

Xiaoyao Li (2):
  kvm/x86: Emulate MSR IA32_CORE_CAPABILITY
  kvm/vmx: Emulate MSR TEST_CTL

 .../admin-guide/kernel-parameters.txt         |   6 +-
 arch/x86/include/asm/cmdline.h                |   3 +
 arch/x86/include/asm/cpu.h                    |   7 +
 arch/x86/include/asm/cpufeature.h             |   5 +
 arch/x86/include/asm/cpufeatures.h            |   2 +
 arch/x86/include/asm/kvm_host.h               |   2 +
 arch/x86/include/asm/msr-index.h              |   7 +
 arch/x86/include/asm/processor.h              |   4 +-
 arch/x86/kernel/cpu/common.c                  |  14 +-
 arch/x86/kernel/cpu/cpuid-deps.c              | 157 ++++++++++++----
 arch/x86/kernel/cpu/intel.c                   | 177 +++++++++++++++++-
 arch/x86/kernel/cpu/scattered.c               |  17 ++
 arch/x86/kernel/fpu/init.c                    |  33 +++-
 arch/x86/kernel/process.c                     |   3 +
 arch/x86/kernel/traps.c                       |  42 +++++
 arch/x86/kvm/cpuid.c                          |   6 +
 arch/x86/kvm/vmx/vmx.c                        |  35 ++++
 arch/x86/kvm/vmx/vmx.h                        |   1 +
 arch/x86/kvm/x86.c                            |  39 ++++
 arch/x86/lib/cmdline.c                        |  17 +-
 drivers/net/ethernet/broadcom/b44.c           |   4 +-
 drivers/net/wireless/ti/wlcore/cmd.c          |  15 +-
 drivers/net/wireless/ti/wlcore/wlcore.h       |   4 +-
 23 files changed, 526 insertions(+), 74 deletions(-)

-- 
2.19.1

