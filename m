Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:37291 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759219Ab3EWOAk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 May 2013 10:00:40 -0400
Message-ID: <519E2100.7040004@iki.fi> (sfid-20130523_160049_712668_24A3CC28)
Date: Thu, 23 May 2013 17:00:32 +0300
From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: larry.finger@lwfinger.net,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: usb.c:undefined reference to `usb_get_from_anchor'
References: <519ce4ab.6n3vpm6hBzLEHbPh%fengguang.wu@intel.com> <20130522184217.GH2113@tuxdriver.com>
In-Reply-To: <20130522184217.GH2113@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22.05.2013 21:42, John W. Linville wrote:
> Is this a missing Kconfig option?  Or a missing header file?  Or...?
> 

Appears to happen because config has CONFIG_USB=m and CONFIG_RTLWIFI=y. In rtlwifi/Makefile we have:

ifneq ($(CONFIG_USB),)
rtlwifi-objs	+= usb.o
endif

and that causes the problem (rtlwifi is built-in with usb support, but usb is build as module).

Maybe some sort of Kconfig hack can workaround this?

-Jussi

> On Wed, May 22, 2013 at 11:30:51PM +0800, kbuild test robot wrote:
>> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux master
>> head:   519fe2ecb755b875d9814cdda19778c2e88c6901
>> commit: 872de8ff04922e4ad95c5af39131ae9fbefe6ac5 rtlwifi: usb: use usb_alloc_coherent for RX buffers
>> date:   8 weeks ago
>> config: x86_64-randconfig-c06-0522 (attached as .config)
>>
>> All error/warnings:
>>
>>    drivers/built-in.o: In function `_rtl_rx_completed':
>>    usb.c:(.text+0x1f0e34): undefined reference to `usb_anchor_urb'
>>    usb.c:(.text+0x1f0e49): undefined reference to `usb_submit_urb'
>>    usb.c:(.text+0x1f0fdf): undefined reference to `usb_anchor_urb'
>>    usb.c:(.text+0x1f1001): undefined reference to `usb_unanchor_urb'
>>    drivers/built-in.o: In function `_usb_writeN_sync':
>>    usb.c:(.text+0x1f124c): undefined reference to `usb_control_msg'
>>    drivers/built-in.o: In function `_rtl_usb_cleanup_rx.isra.9':
>>    usb.c:(.text+0x1f12a1): undefined reference to `usb_kill_anchored_urbs'
>>    usb.c:(.text+0x1f12cb): undefined reference to `usb_free_coherent'
>>    usb.c:(.text+0x1f12db): undefined reference to `usb_free_urb'
>>>> usb.c:(.text+0x1f12eb): undefined reference to `usb_get_from_anchor'
>>    drivers/built-in.o: In function `rtl_usb_cleanup':
>>    usb.c:(.text+0x1f1426): undefined reference to `usb_kill_anchored_urbs'
>>    usb.c:(.text+0x1f1450): undefined reference to `usb_kill_anchored_urbs'
>>    drivers/built-in.o: In function `rtl_usb_disconnect':
>>    (.text+0x1f161c): undefined reference to `usb_put_dev'
>>    drivers/built-in.o: In function `rtl_usb_tx':
>>    usb.c:(.text+0x1f18a2): undefined reference to `usb_alloc_urb'
>>    usb.c:(.text+0x1f193d): undefined reference to `usb_anchor_urb'
>>    usb.c:(.text+0x1f1952): undefined reference to `usb_submit_urb'
>>    usb.c:(.text+0x1f196a): undefined reference to `usb_free_urb'
>>    usb.c:(.text+0x1f1a51): undefined reference to `usb_unanchor_urb'
>>    drivers/built-in.o: In function `rtl_usb_probe':
>>    (.text+0x1f1f45): undefined reference to `usb_get_dev'
>>    drivers/built-in.o: In function `rtl_usb_probe':
>>    (.text+0x1f2786): undefined reference to `usb_put_dev'
>>    drivers/built-in.o: In function `_usb_read_sync':
>>    usb.c:(.text+0x1f2ae9): undefined reference to `usb_control_msg'
>>    drivers/built-in.o: In function `_usb_write_async':
>>    usb.c:(.text+0x1f2ccc): undefined reference to `usb_alloc_urb'
>>    usb.c:(.text+0x1f2d4f): undefined reference to `usb_submit_urb'
>>    usb.c:(.text+0x1f2d63): undefined reference to `usb_free_urb'
>>    drivers/built-in.o: In function `rtl_usb_start':
>>    usb.c:(.text+0x1f3071): undefined reference to `usb_anchor_urb'
>>    usb.c:(.text+0x1f3086): undefined reference to `usb_submit_urb'
>>    usb.c:(.text+0x1f30aa): undefined reference to `usb_free_urb'
>>    usb.c:(.text+0x1f30d3): undefined reference to `usb_alloc_urb'
>>    usb.c:(.text+0x1f310e): undefined reference to `usb_alloc_coherent'
>>    usb.c:(.text+0x1f314e): undefined reference to `usb_free_urb'
>>    usb.c:(.text+0x1f3166): undefined reference to `usb_kill_anchored_urbs'
>>    drivers/built-in.o: In function `free_rx_struct':
>>    gdm_usb.c:(.text+0x33ca76): undefined reference to `usb_free_urb'
>>    drivers/built-in.o: In function `free_tx_struct':
>>    gdm_usb.c:(.text+0x33cad6): undefined reference to `usb_free_urb'
>>    drivers/built-in.o: In function `gdm_usb_disconnect':
>>    gdm_usb.c:(.text+0x33ce09): undefined reference to `usb_put_dev'
>>    drivers/built-in.o: In function `alloc_rx_struct':
>>    gdm_usb.c:(.text+0x33cee1): undefined reference to `usb_alloc_urb'
>>    gdm_usb.c:(.text+0x33cf61): undefined reference to `usb_free_urb'
>>    drivers/built-in.o: In function `alloc_tx_struct':
>>    gdm_usb.c:(.text+0x33cff5): undefined reference to `usb_alloc_urb'
>>    gdm_usb.c:(.text+0x33d086): undefined reference to `usb_free_urb'
>>    drivers/built-in.o: In function `gdm_usb_probe':
>>    gdm_usb.c:(.text+0x33d0f3): undefined reference to `usb_get_dev'
>>    drivers/built-in.o: In function `gdm_usb_receive':
>>    gdm_usb.c:(.text+0x33d63f): undefined reference to `usb_submit_urb'
>>    drivers/built-in.o: In function `gdm_usb_rcv_complete':
>>    gdm_usb.c:(.text+0x33d8a2): undefined reference to `usb_submit_urb'
>>    gdm_usb.c:(.text+0x33d92d): undefined reference to `usb_unlink_urb'
>>    drivers/built-in.o: In function `k_mode_thread':
>>    gdm_usb.c:(.text+0x33db62): undefined reference to `usb_submit_urb'
>>    gdm_usb.c:(.text+0x33dc24): undefined reference to `usb_submit_urb'
>>    drivers/built-in.o: In function `gdm_usb_send':
>>    gdm_usb.c:(.text+0x33de70): undefined reference to `usb_submit_urb'
>>    gdm_usb.c:(.text+0x33e01d): undefined reference to `usb_unlink_urb'
>>    drivers/built-in.o: In function `gdm_wibro_send':
>>    usb_boot.c:(.text+0x33e204): undefined reference to `usb_bulk_msg'
>>    drivers/built-in.o: In function `em_wait_ack':
>>    usb_boot.c:(.text+0x33e3dd): undefined reference to `usb_bulk_msg'
>>    drivers/built-in.o: In function `usb_gdm_wimax_init':
>>    gdm_usb.c:(.init.text+0xfbda): undefined reference to `usb_register_driver'
>>    drivers/built-in.o: In function `usb_gdm_wimax_exit':
>>    gdm_usb.c:(.exit.text+0x2238): undefined reference to `usb_deregister'
>>
>> ---
>> 0-DAY kernel build testing backend              Open Source Technology Center
>> http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
> 
>> #
>> # Automatically generated file; DO NOT EDIT.
>> # Linux/x86_64 3.9.0-rc1 Kernel Configuration
>> #
>> CONFIG_64BIT=y
>> CONFIG_X86_64=y
>> CONFIG_X86=y
>> CONFIG_INSTRUCTION_DECODER=y
>> CONFIG_OUTPUT_FORMAT="elf64-x86-64"
>> CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
>> CONFIG_LOCKDEP_SUPPORT=y
>> CONFIG_STACKTRACE_SUPPORT=y
>> CONFIG_HAVE_LATENCYTOP_SUPPORT=y
>> CONFIG_MMU=y
>> CONFIG_NEED_DMA_MAP_STATE=y
>> CONFIG_NEED_SG_DMA_LENGTH=y
>> CONFIG_GENERIC_BUG=y
>> CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
>> CONFIG_GENERIC_HWEIGHT=y
>> CONFIG_RWSEM_XCHGADD_ALGORITHM=y
>> CONFIG_GENERIC_CALIBRATE_DELAY=y
>> CONFIG_ARCH_HAS_CPU_RELAX=y
>> CONFIG_ARCH_HAS_DEFAULT_IDLE=y
>> CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
>> CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
>> CONFIG_HAVE_SETUP_PER_CPU_AREA=y
>> CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
>> CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
>> CONFIG_ARCH_HIBERNATION_POSSIBLE=y
>> CONFIG_ARCH_SUSPEND_POSSIBLE=y
>> CONFIG_ZONE_DMA32=y
>> CONFIG_AUDIT_ARCH=y
>> CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
>> CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
>> CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
>> CONFIG_ARCH_SUPPORTS_UPROBES=y
>> CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
>> CONFIG_CONSTRUCTORS=y
>> CONFIG_IRQ_WORK=y
>> CONFIG_BUILDTIME_EXTABLE_SORT=y
>>
>> #
>> # General setup
>> #
>> CONFIG_EXPERIMENTAL=y
>> CONFIG_BROKEN_ON_SMP=y
>> CONFIG_INIT_ENV_ARG_LIMIT=32
>> CONFIG_CROSS_COMPILE=""
>> CONFIG_LOCALVERSION=""
>> CONFIG_LOCALVERSION_AUTO=y
>> CONFIG_HAVE_KERNEL_GZIP=y
>> CONFIG_HAVE_KERNEL_BZIP2=y
>> CONFIG_HAVE_KERNEL_LZMA=y
>> CONFIG_HAVE_KERNEL_XZ=y
>> CONFIG_HAVE_KERNEL_LZO=y
>> # CONFIG_KERNEL_GZIP is not set
>> # CONFIG_KERNEL_BZIP2 is not set
>> CONFIG_KERNEL_LZMA=y
>> # CONFIG_KERNEL_XZ is not set
>> # CONFIG_KERNEL_LZO is not set
>> CONFIG_DEFAULT_HOSTNAME="(none)"
>> # CONFIG_SYSVIPC is not set
>> CONFIG_POSIX_MQUEUE=y
>> CONFIG_FHANDLE=y
>> # CONFIG_AUDIT is not set
>> CONFIG_HAVE_GENERIC_HARDIRQS=y
>>
>> #
>> # IRQ subsystem
>> #
>> CONFIG_GENERIC_HARDIRQS=y
>> CONFIG_GENERIC_IRQ_PROBE=y
>> CONFIG_GENERIC_IRQ_SHOW=y
>> CONFIG_IRQ_DOMAIN=y
>> # CONFIG_IRQ_DOMAIN_DEBUG is not set
>> CONFIG_IRQ_FORCED_THREADING=y
>> CONFIG_SPARSE_IRQ=y
>> CONFIG_CLOCKSOURCE_WATCHDOG=y
>> CONFIG_ARCH_CLOCKSOURCE_DATA=y
>> CONFIG_ALWAYS_USE_PERSISTENT_CLOCK=y
>> CONFIG_GENERIC_TIME_VSYSCALL=y
>> CONFIG_GENERIC_CLOCKEVENTS=y
>> CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
>> CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
>> CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
>> CONFIG_GENERIC_CMOS_UPDATE=y
>>
>> #
>> # Timers subsystem
>> #
>> # CONFIG_NO_HZ is not set
>> # CONFIG_HIGH_RES_TIMERS is not set
>>
>> #
>> # CPU/Task time and stats accounting
>> #
>> CONFIG_VIRT_CPU_ACCOUNTING=y
>> # CONFIG_TICK_CPU_ACCOUNTING is not set
>> CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
>> # CONFIG_IRQ_TIME_ACCOUNTING is not set
>> CONFIG_BSD_PROCESS_ACCT=y
>> CONFIG_BSD_PROCESS_ACCT_V3=y
>> # CONFIG_TASKSTATS is not set
>>
>> #
>> # RCU Subsystem
>> #
>> CONFIG_TREE_PREEMPT_RCU=y
>> # CONFIG_TINY_PREEMPT_RCU is not set
>> CONFIG_PREEMPT_RCU=y
>> CONFIG_RCU_STALL_COMMON=y
>> CONFIG_CONTEXT_TRACKING=y
>> CONFIG_CONTEXT_TRACKING_FORCE=y
>> CONFIG_RCU_FANOUT=64
>> CONFIG_RCU_FANOUT_LEAF=16
>> # CONFIG_RCU_FANOUT_EXACT is not set
>> # CONFIG_TREE_RCU_TRACE is not set
>> # CONFIG_RCU_BOOST is not set
>> CONFIG_RCU_NOCB_CPU=y
>> CONFIG_IKCONFIG=y
>> CONFIG_IKCONFIG_PROC=y
>> CONFIG_LOG_BUF_SHIFT=17
>> CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
>> CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
>> CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
>> CONFIG_CGROUPS=y
>> CONFIG_CGROUP_DEBUG=y
>> CONFIG_CGROUP_FREEZER=y
>> CONFIG_CGROUP_DEVICE=y
>> CONFIG_CPUSETS=y
>> # CONFIG_PROC_PID_CPUSET is not set
>> # CONFIG_CGROUP_CPUACCT is not set
>> CONFIG_RESOURCE_COUNTERS=y
>> # CONFIG_MEMCG is not set
>> # CONFIG_CGROUP_HUGETLB is not set
>> # CONFIG_CGROUP_PERF is not set
>> # CONFIG_CGROUP_SCHED is not set
>> CONFIG_CHECKPOINT_RESTORE=y
>> # CONFIG_NAMESPACES is not set
>> CONFIG_UIDGID_CONVERTED=y
>> # CONFIG_UIDGID_STRICT_TYPE_CHECKS is not set
>> # CONFIG_SCHED_AUTOGROUP is not set
>> # CONFIG_SYSFS_DEPRECATED is not set
>> CONFIG_RELAY=y
>> CONFIG_BLK_DEV_INITRD=y
>> CONFIG_INITRAMFS_SOURCE=""
>> CONFIG_RD_GZIP=y
>> # CONFIG_RD_BZIP2 is not set
>> # CONFIG_RD_LZMA is not set
>> CONFIG_RD_XZ=y
>> CONFIG_RD_LZO=y
>> # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
>> CONFIG_ANON_INODES=y
>> CONFIG_EXPERT=y
>> CONFIG_HAVE_UID16=y
>> CONFIG_UID16=y
>> CONFIG_SYSCTL_EXCEPTION_TRACE=y
>> CONFIG_KALLSYMS=y
>> CONFIG_KALLSYMS_ALL=y
>> CONFIG_HOTPLUG=y
>> CONFIG_PRINTK=y
>> CONFIG_BUG=y
>> CONFIG_PCSPKR_PLATFORM=y
>> CONFIG_HAVE_PCSPKR_PLATFORM=y
>> CONFIG_BASE_FULL=y
>> CONFIG_FUTEX=y
>> CONFIG_EPOLL=y
>> # CONFIG_SIGNALFD is not set
>> CONFIG_TIMERFD=y
>> CONFIG_EVENTFD=y
>> # CONFIG_SHMEM is not set
>> # CONFIG_AIO is not set
>> # CONFIG_EMBEDDED is not set
>> CONFIG_HAVE_PERF_EVENTS=y
>>
>> #
>> # Kernel Performance Events And Counters
>> #
>> CONFIG_PERF_EVENTS=y
>> # CONFIG_DEBUG_PERF_USE_VMALLOC is not set
>> CONFIG_VM_EVENT_COUNTERS=y
>> CONFIG_PCI_QUIRKS=y
>> CONFIG_SLUB_DEBUG=y
>> CONFIG_COMPAT_BRK=y
>> # CONFIG_SLAB is not set
>> CONFIG_SLUB=y
>> # CONFIG_SLOB is not set
>> # CONFIG_PROFILING is not set
>> CONFIG_TRACEPOINTS=y
>> CONFIG_HAVE_OPROFILE=y
>> CONFIG_OPROFILE_NMI_TIMER=y
>> # CONFIG_KPROBES is not set
>> # CONFIG_JUMP_LABEL is not set
>> # CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
>> CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
>> CONFIG_ARCH_USE_BUILTIN_BSWAP=y
>> CONFIG_HAVE_IOREMAP_PROT=y
>> CONFIG_HAVE_KPROBES=y
>> CONFIG_HAVE_KRETPROBES=y
>> CONFIG_HAVE_OPTPROBES=y
>> CONFIG_HAVE_KPROBES_ON_FTRACE=y
>> CONFIG_HAVE_ARCH_TRACEHOOK=y
>> CONFIG_HAVE_DMA_ATTRS=y
>> CONFIG_GENERIC_SMP_IDLE_THREAD=y
>> CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
>> CONFIG_HAVE_DMA_API_DEBUG=y
>> CONFIG_HAVE_HW_BREAKPOINT=y
>> CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
>> CONFIG_HAVE_USER_RETURN_NOTIFIER=y
>> CONFIG_HAVE_PERF_EVENTS_NMI=y
>> CONFIG_HAVE_PERF_REGS=y
>> CONFIG_HAVE_PERF_USER_STACK_DUMP=y
>> CONFIG_HAVE_ARCH_JUMP_LABEL=y
>> CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
>> CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
>> CONFIG_HAVE_CMPXCHG_LOCAL=y
>> CONFIG_HAVE_CMPXCHG_DOUBLE=y
>> CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
>> CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
>> CONFIG_HAVE_VIRT_TO_BUS=y
>> CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
>> CONFIG_SECCOMP_FILTER=y
>> CONFIG_HAVE_CONTEXT_TRACKING=y
>> CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
>> CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
>> CONFIG_MODULES_USE_ELF_RELA=y
>> CONFIG_OLD_SIGSUSPEND3=y
>> CONFIG_COMPAT_OLD_SIGACTION=y
>>
>> #
>> # GCOV-based kernel profiling
>> #
>> CONFIG_GCOV_KERNEL=y
>> CONFIG_GCOV_PROFILE_ALL=y
>> # CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
>> CONFIG_SLABINFO=y
>> CONFIG_RT_MUTEXES=y
>> CONFIG_BASE_SMALL=0
>> CONFIG_MODULES=y
>> CONFIG_MODULE_FORCE_LOAD=y
>> # CONFIG_MODULE_UNLOAD is not set
>> # CONFIG_MODVERSIONS is not set
>> # CONFIG_MODULE_SRCVERSION_ALL is not set
>> CONFIG_MODULE_SIG=y
>> CONFIG_MODULE_SIG_FORCE=y
>> # CONFIG_MODULE_SIG_ALL is not set
>>
>> #
>> # Do not forget to sign required modules with scripts/sign-file
>> #
>> # CONFIG_MODULE_SIG_SHA1 is not set
>> # CONFIG_MODULE_SIG_SHA224 is not set
>> # CONFIG_MODULE_SIG_SHA256 is not set
>> # CONFIG_MODULE_SIG_SHA384 is not set
>> CONFIG_MODULE_SIG_SHA512=y
>> CONFIG_MODULE_SIG_HASH="sha512"
>> # CONFIG_BLOCK is not set
>> CONFIG_ASN1=y
>> CONFIG_UNINLINE_SPIN_UNLOCK=y
>> CONFIG_FREEZER=y
>>
>> #
>> # Processor type and features
>> #
>> # CONFIG_ZONE_DMA is not set
>> # CONFIG_SMP is not set
>> # CONFIG_X86_MPPARSE is not set
>> # CONFIG_X86_EXTENDED_PLATFORM is not set
>> # CONFIG_X86_INTEL_LPSS is not set
>> # CONFIG_SCHED_OMIT_FRAME_POINTER is not set
>> CONFIG_PARAVIRT_GUEST=y
>> # CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
>> # CONFIG_XEN is not set
>> # CONFIG_XEN_PRIVILEGED_GUEST is not set
>> CONFIG_KVM_GUEST=y
>> CONFIG_PARAVIRT=y
>> CONFIG_PARAVIRT_CLOCK=y
>> # CONFIG_PARAVIRT_DEBUG is not set
>> CONFIG_NO_BOOTMEM=y
>> # CONFIG_MEMTEST is not set
>> # CONFIG_MK8 is not set
>> # CONFIG_MPSC is not set
>> # CONFIG_MCORE2 is not set
>> # CONFIG_MATOM is not set
>> CONFIG_GENERIC_CPU=y
>> CONFIG_X86_INTERNODE_CACHE_SHIFT=6
>> CONFIG_X86_L1_CACHE_SHIFT=6
>> CONFIG_X86_TSC=y
>> CONFIG_X86_CMPXCHG64=y
>> CONFIG_X86_CMOV=y
>> CONFIG_X86_MINIMUM_CPU_FAMILY=64
>> CONFIG_X86_DEBUGCTLMSR=y
>> # CONFIG_PROCESSOR_SELECT is not set
>> CONFIG_CPU_SUP_INTEL=y
>> CONFIG_CPU_SUP_AMD=y
>> CONFIG_CPU_SUP_CENTAUR=y
>> CONFIG_HPET_TIMER=y
>> CONFIG_HPET_EMULATE_RTC=y
>> CONFIG_DMI=y
>> # CONFIG_GART_IOMMU is not set
>> CONFIG_CALGARY_IOMMU=y
>> # CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT is not set
>> CONFIG_SWIOTLB=y
>> CONFIG_IOMMU_HELPER=y
>> CONFIG_NR_CPUS=1
>> # CONFIG_PREEMPT_NONE is not set
>> # CONFIG_PREEMPT_VOLUNTARY is not set
>> CONFIG_PREEMPT=y
>> CONFIG_PREEMPT_COUNT=y
>> CONFIG_X86_LOCAL_APIC=y
>> CONFIG_X86_IO_APIC=y
>> CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
>> # CONFIG_X86_MCE is not set
>> # CONFIG_I8K is not set
>> # CONFIG_MICROCODE is not set
>> # CONFIG_X86_MSR is not set
>> # CONFIG_X86_CPUID is not set
>> CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
>> CONFIG_ARCH_DMA_ADDR_T_64BIT=y
>> CONFIG_DIRECT_GBPAGES=y
>> CONFIG_ARCH_SPARSEMEM_ENABLE=y
>> CONFIG_ARCH_SPARSEMEM_DEFAULT=y
>> CONFIG_ARCH_SELECT_MEMORY_MODEL=y
>> CONFIG_ARCH_MEMORY_PROBE=y
>> CONFIG_ARCH_PROC_KCORE_TEXT=y
>> CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
>> CONFIG_SELECT_MEMORY_MODEL=y
>> CONFIG_SPARSEMEM_MANUAL=y
>> CONFIG_SPARSEMEM=y
>> CONFIG_HAVE_MEMORY_PRESENT=y
>> CONFIG_SPARSEMEM_EXTREME=y
>> CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
>> CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
>> # CONFIG_SPARSEMEM_VMEMMAP is not set
>> CONFIG_HAVE_MEMBLOCK=y
>> CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
>> CONFIG_ARCH_DISCARD_MEMBLOCK=y
>> CONFIG_MEMORY_ISOLATION=y
>> CONFIG_HAVE_BOOTMEM_INFO_NODE=y
>> CONFIG_MEMORY_HOTPLUG=y
>> CONFIG_MEMORY_HOTPLUG_SPARSE=y
>> CONFIG_MEMORY_HOTREMOVE=y
>> CONFIG_PAGEFLAGS_EXTENDED=y
>> CONFIG_SPLIT_PTLOCK_CPUS=999999
>> # CONFIG_COMPACTION is not set
>> CONFIG_MIGRATION=y
>> CONFIG_PHYS_ADDR_T_64BIT=y
>> CONFIG_ZONE_DMA_FLAG=0
>> CONFIG_VIRT_TO_BUS=y
>> # CONFIG_KSM is not set
>> CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
>> # CONFIG_TRANSPARENT_HUGEPAGE is not set
>> # CONFIG_CROSS_MEMORY_ATTACH is not set
>> CONFIG_NEED_PER_CPU_KM=y
>> CONFIG_CLEANCACHE=y
>> # CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
>> CONFIG_X86_RESERVE_LOW=64
>> # CONFIG_MTRR is not set
>> CONFIG_ARCH_RANDOM=y
>> CONFIG_X86_SMAP=y
>> # CONFIG_EFI is not set
>> CONFIG_SECCOMP=y
>> CONFIG_CC_STACKPROTECTOR=y
>> # CONFIG_HZ_100 is not set
>> # CONFIG_HZ_250 is not set
>> CONFIG_HZ_300=y
>> # CONFIG_HZ_1000 is not set
>> CONFIG_HZ=300
>> # CONFIG_SCHED_HRTICK is not set
>> CONFIG_KEXEC=y
>> # CONFIG_CRASH_DUMP is not set
>> CONFIG_PHYSICAL_START=0x1000000
>> # CONFIG_RELOCATABLE is not set
>> CONFIG_PHYSICAL_ALIGN=0x1000000
>> CONFIG_COMPAT_VDSO=y
>> # CONFIG_CMDLINE_BOOL is not set
>> CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
>> CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
>>
>> #
>> # Power management and ACPI options
>> #
>> # CONFIG_SUSPEND is not set
>> CONFIG_PM_RUNTIME=y
>> CONFIG_PM=y
>> CONFIG_PM_DEBUG=y
>> CONFIG_PM_ADVANCED_DEBUG=y
>> CONFIG_ACPI=y
>> # CONFIG_ACPI_PROCFS is not set
>> # CONFIG_ACPI_PROCFS_POWER is not set
>> # CONFIG_ACPI_EC_DEBUGFS is not set
>> CONFIG_ACPI_PROC_EVENT=y
>> CONFIG_ACPI_AC=y
>> CONFIG_ACPI_BATTERY=y
>> CONFIG_ACPI_BUTTON=y
>> # CONFIG_ACPI_VIDEO is not set
>> CONFIG_ACPI_FAN=y
>> # CONFIG_ACPI_DOCK is not set
>> CONFIG_ACPI_I2C=y
>> CONFIG_ACPI_PROCESSOR=y
>> # CONFIG_ACPI_IPMI is not set
>> # CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
>> CONFIG_ACPI_THERMAL=y
>> # CONFIG_ACPI_CUSTOM_DSDT is not set
>> # CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
>> CONFIG_ACPI_BLACKLIST_YEAR=0
>> # CONFIG_ACPI_DEBUG is not set
>> # CONFIG_ACPI_PCI_SLOT is not set
>> CONFIG_X86_PM_TIMER=y
>> # CONFIG_ACPI_CONTAINER is not set
>> # CONFIG_ACPI_HOTPLUG_MEMORY is not set
>> # CONFIG_ACPI_SBS is not set
>> # CONFIG_ACPI_HED is not set
>> # CONFIG_ACPI_CUSTOM_METHOD is not set
>> # CONFIG_ACPI_APEI is not set
>> CONFIG_SFI=y
>>
>> #
>> # CPU Frequency scaling
>> #
>> CONFIG_CPU_FREQ=y
>> CONFIG_CPU_FREQ_TABLE=m
>> CONFIG_CPU_FREQ_GOV_COMMON=y
>> # CONFIG_CPU_FREQ_STAT is not set
>> # CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
>> # CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
>> # CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
>> # CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
>> CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE=y
>> CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
>> CONFIG_CPU_FREQ_GOV_POWERSAVE=m
>> CONFIG_CPU_FREQ_GOV_USERSPACE=m
>> CONFIG_CPU_FREQ_GOV_ONDEMAND=m
>> CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
>>
>> #
>> # x86 CPU frequency scaling drivers
>> #
>> # CONFIG_X86_INTEL_PSTATE is not set
>> # CONFIG_X86_PCC_CPUFREQ is not set
>> # CONFIG_X86_ACPI_CPUFREQ is not set
>> # CONFIG_X86_SPEEDSTEP_CENTRINO is not set
>> # CONFIG_X86_P4_CLOCKMOD is not set
>>
>> #
>> # shared options
>> #
>> # CONFIG_X86_SPEEDSTEP_LIB is not set
>> CONFIG_CPU_IDLE=y
>> # CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
>> CONFIG_CPU_IDLE_GOV_LADDER=y
>> # CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
>> # CONFIG_INTEL_IDLE is not set
>>
>> #
>> # Memory power savings
>> #
>> CONFIG_I7300_IDLE_IOAT_CHANNEL=y
>> CONFIG_I7300_IDLE=y
>>
>> #
>> # Bus options (PCI etc.)
>> #
>> CONFIG_PCI=y
>> CONFIG_PCI_DIRECT=y
>> # CONFIG_PCI_MMCONFIG is not set
>> CONFIG_PCI_DOMAINS=y
>> CONFIG_PCI_CNB20LE_QUIRK=y
>> # CONFIG_PCIEPORTBUS is not set
>> CONFIG_ARCH_SUPPORTS_MSI=y
>> CONFIG_PCI_MSI=y
>> # CONFIG_PCI_DEBUG is not set
>> # CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
>> # CONFIG_PCI_STUB is not set
>> # CONFIG_HT_IRQ is not set
>> CONFIG_PCI_ATS=y
>> # CONFIG_PCI_IOV is not set
>> CONFIG_PCI_PRI=y
>> CONFIG_PCI_PASID=y
>> # CONFIG_PCI_IOAPIC is not set
>> CONFIG_PCI_LABEL=y
>> # CONFIG_ISA_DMA_API is not set
>> CONFIG_AMD_NB=y
>> # CONFIG_PCCARD is not set
>> # CONFIG_HOTPLUG_PCI is not set
>> CONFIG_RAPIDIO=y
>> CONFIG_RAPIDIO_DISC_TIMEOUT=30
>> # CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS is not set
>> CONFIG_RAPIDIO_DMA_ENGINE=y
>> CONFIG_RAPIDIO_DEBUG=y
>> CONFIG_RAPIDIO_TSI57X=y
>> CONFIG_RAPIDIO_CPS_XX=y
>> CONFIG_RAPIDIO_TSI568=y
>> CONFIG_RAPIDIO_CPS_GEN2=y
>> CONFIG_RAPIDIO_TSI500=y
>>
>> #
>> # Executable file formats / Emulations
>> #
>> CONFIG_BINFMT_ELF=y
>> CONFIG_COMPAT_BINFMT_ELF=y
>> CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
>> # CONFIG_HAVE_AOUT is not set
>> # CONFIG_BINFMT_MISC is not set
>> # CONFIG_COREDUMP is not set
>> CONFIG_IA32_EMULATION=y
>> CONFIG_IA32_AOUT=y
>> CONFIG_X86_X32=y
>> CONFIG_COMPAT=y
>> CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
>> CONFIG_KEYS_COMPAT=y
>> CONFIG_HAVE_TEXT_POKE_SMP=y
>> CONFIG_X86_DEV_DMA_OPS=y
>> CONFIG_NET=y
>> CONFIG_COMPAT_NETLINK_MESSAGES=y
>>
>> #
>> # Networking options
>> #
>> # CONFIG_PACKET is not set
>> CONFIG_UNIX=y
>> CONFIG_UNIX_DIAG=m
>> CONFIG_XFRM=y
>> CONFIG_XFRM_ALGO=y
>> CONFIG_XFRM_SUB_POLICY=y
>> CONFIG_XFRM_MIGRATE=y
>> CONFIG_NET_KEY=y
>> # CONFIG_NET_KEY_MIGRATE is not set
>> # CONFIG_INET is not set
>> CONFIG_NETWORK_SECMARK=y
>> # CONFIG_NETWORK_PHY_TIMESTAMPING is not set
>> CONFIG_NETFILTER=y
>> CONFIG_NETFILTER_DEBUG=y
>> # CONFIG_NETFILTER_ADVANCED is not set
>> # CONFIG_BRIDGE_NF_EBTABLES is not set
>> CONFIG_ATM=m
>> CONFIG_ATM_LANE=m
>> CONFIG_STP=y
>> CONFIG_BRIDGE=y
>> CONFIG_HAVE_NET_DSA=y
>> CONFIG_NET_DSA=y
>> CONFIG_NET_DSA_TAG_DSA=y
>> CONFIG_NET_DSA_TAG_EDSA=y
>> CONFIG_NET_DSA_TAG_TRAILER=y
>> # CONFIG_VLAN_8021Q is not set
>> CONFIG_DECNET=m
>> # CONFIG_DECNET_ROUTER is not set
>> CONFIG_LLC=y
>> # CONFIG_LLC2 is not set
>> CONFIG_IPX=y
>> CONFIG_IPX_INTERN=y
>> CONFIG_ATALK=y
>> CONFIG_DEV_APPLETALK=m
>> CONFIG_IPDDP=m
>> # CONFIG_IPDDP_ENCAP is not set
>> # CONFIG_IPDDP_DECAP is not set
>> CONFIG_X25=m
>> CONFIG_LAPB=m
>> CONFIG_PHONET=y
>> CONFIG_IEEE802154=y
>> # CONFIG_MAC802154 is not set
>> # CONFIG_NET_SCHED is not set
>> CONFIG_DCB=y
>> CONFIG_DNS_RESOLVER=y
>> CONFIG_BATMAN_ADV=y
>> CONFIG_BATMAN_ADV_DEBUG=y
>> CONFIG_OPENVSWITCH=y
>> CONFIG_VSOCKETS=m
>> # CONFIG_NETPRIO_CGROUP is not set
>> CONFIG_BQL=y
>> CONFIG_BPF_JIT=y
>>
>> #
>> # Network testing
>> #
>> CONFIG_NET_PKTGEN=m
>> # CONFIG_HAMRADIO is not set
>> CONFIG_CAN=y
>> CONFIG_CAN_RAW=m
>> # CONFIG_CAN_BCM is not set
>> # CONFIG_CAN_GW is not set
>>
>> #
>> # CAN Device Drivers
>> #
>> # CONFIG_CAN_VCAN is not set
>> # CONFIG_CAN_DEV is not set
>> CONFIG_CAN_DEBUG_DEVICES=y
>> CONFIG_IRDA=m
>>
>> #
>> # IrDA protocols
>> #
>> # CONFIG_IRLAN is not set
>> CONFIG_IRDA_ULTRA=y
>>
>> #
>> # IrDA options
>> #
>> CONFIG_IRDA_CACHE_LAST_LSAP=y
>> CONFIG_IRDA_FAST_RR=y
>> CONFIG_IRDA_DEBUG=y
>>
>> #
>> # Infrared-port device drivers
>> #
>>
>> #
>> # SIR device drivers
>> #
>>
>> #
>> # Dongle support
>> #
>> CONFIG_KINGSUN_DONGLE=m
>> CONFIG_KSDAZZLE_DONGLE=m
>> CONFIG_KS959_DONGLE=m
>>
>> #
>> # FIR device drivers
>> #
>> CONFIG_USB_IRDA=m
>> CONFIG_SIGMATEL_FIR=m
>> CONFIG_VLSI_FIR=m
>> CONFIG_MCS_FIR=m
>> CONFIG_BT=y
>> CONFIG_BT_RFCOMM=y
>> CONFIG_BT_BNEP=y
>> CONFIG_BT_BNEP_MC_FILTER=y
>> CONFIG_BT_BNEP_PROTO_FILTER=y
>> CONFIG_BT_HIDP=m
>>
>> #
>> # Bluetooth device drivers
>> #
>> CONFIG_BT_HCIBTUSB=m
>> CONFIG_BT_HCIBCM203X=m
>> CONFIG_BT_HCIBPA10X=m
>> CONFIG_BT_HCIBFUSB=m
>> CONFIG_BT_HCIVHCI=y
>> CONFIG_BT_MRVL=y
>> # CONFIG_BT_ATH3K is not set
>> CONFIG_WIRELESS=y
>> CONFIG_WIRELESS_EXT=y
>> CONFIG_WEXT_CORE=y
>> CONFIG_WEXT_PROC=y
>> CONFIG_WEXT_SPY=y
>> CONFIG_WEXT_PRIV=y
>> CONFIG_CFG80211=y
>> CONFIG_NL80211_TESTMODE=y
>> CONFIG_CFG80211_DEVELOPER_WARNINGS=y
>> CONFIG_CFG80211_REG_DEBUG=y
>> CONFIG_CFG80211_CERTIFICATION_ONUS=y
>> CONFIG_CFG80211_DEFAULT_PS=y
>> # CONFIG_CFG80211_DEBUGFS is not set
>> # CONFIG_CFG80211_INTERNAL_REGDB is not set
>> # CONFIG_CFG80211_WEXT is not set
>> CONFIG_LIB80211=y
>> CONFIG_LIB80211_CRYPT_WEP=y
>> CONFIG_LIB80211_CRYPT_CCMP=y
>> CONFIG_LIB80211_CRYPT_TKIP=y
>> CONFIG_LIB80211_DEBUG=y
>> CONFIG_MAC80211=y
>> CONFIG_MAC80211_HAS_RC=y
>> CONFIG_MAC80211_RC_PID=y
>> # CONFIG_MAC80211_RC_MINSTREL is not set
>> CONFIG_MAC80211_RC_DEFAULT_PID=y
>> CONFIG_MAC80211_RC_DEFAULT="pid"
>> CONFIG_MAC80211_MESH=y
>> CONFIG_MAC80211_LEDS=y
>> CONFIG_MAC80211_DEBUGFS=y
>> # CONFIG_MAC80211_MESSAGE_TRACING is not set
>> # CONFIG_MAC80211_DEBUG_MENU is not set
>> # CONFIG_WIMAX is not set
>> # CONFIG_RFKILL is not set
>> CONFIG_NET_9P=m
>> CONFIG_NET_9P_VIRTIO=m
>> CONFIG_NET_9P_DEBUG=y
>> # CONFIG_CAIF is not set
>> CONFIG_NFC=m
>> CONFIG_NFC_NCI=m
>> CONFIG_NFC_HCI=m
>> CONFIG_NFC_SHDLC=y
>> # CONFIG_NFC_LLCP is not set
>>
>> #
>> # Near Field Communication (NFC) devices
>> #
>> CONFIG_NFC_PN533=m
>> CONFIG_NFC_PN544=m
>> # CONFIG_NFC_PN544_I2C is not set
>> # CONFIG_NFC_MICROREAD is not set
>> CONFIG_HAVE_BPF_JIT=y
>>
>> #
>> # Device Drivers
>> #
>>
>> #
>> # Generic Driver Options
>> #
>> CONFIG_UEVENT_HELPER_PATH=""
>> CONFIG_DEVTMPFS=y
>> # CONFIG_DEVTMPFS_MOUNT is not set
>> CONFIG_STANDALONE=y
>> CONFIG_PREVENT_FIRMWARE_BUILD=y
>> CONFIG_FW_LOADER=y
>> CONFIG_FIRMWARE_IN_KERNEL=y
>> CONFIG_EXTRA_FIRMWARE=""
>> CONFIG_FW_LOADER_USER_HELPER=y
>> # CONFIG_DEBUG_DRIVER is not set
>> CONFIG_DEBUG_DEVRES=y
>> # CONFIG_SYS_HYPERVISOR is not set
>> # CONFIG_GENERIC_CPU_DEVICES is not set
>> CONFIG_REGMAP=y
>> CONFIG_REGMAP_I2C=y
>> CONFIG_REGMAP_MMIO=m
>> CONFIG_REGMAP_IRQ=y
>> CONFIG_DMA_SHARED_BUFFER=y
>>
>> #
>> # Bus devices
>> #
>> CONFIG_CONNECTOR=m
>> # CONFIG_MTD is not set
>> CONFIG_PARPORT=m
>> CONFIG_PARPORT_PC=m
>> # CONFIG_PARPORT_PC_FIFO is not set
>> CONFIG_PARPORT_PC_SUPERIO=y
>> # CONFIG_PARPORT_GSC is not set
>> CONFIG_PARPORT_AX88796=m
>> # CONFIG_PARPORT_1284 is not set
>> CONFIG_PARPORT_NOT_PC=y
>> CONFIG_PNP=y
>> CONFIG_PNP_DEBUG_MESSAGES=y
>>
>> #
>> # Protocols
>> #
>> CONFIG_PNPACPI=y
>>
>> #
>> # Misc devices
>> #
>> CONFIG_SENSORS_LIS3LV02D=m
>> CONFIG_AD525X_DPOT=m
>> CONFIG_AD525X_DPOT_I2C=m
>> CONFIG_IBM_ASM=m
>> CONFIG_PHANTOM=y
>> CONFIG_SGI_IOC4=m
>> # CONFIG_TIFM_CORE is not set
>> CONFIG_ICS932S401=y
>> CONFIG_ATMEL_SSC=y
>> CONFIG_ENCLOSURE_SERVICES=m
>> # CONFIG_CS5535_MFGPT is not set
>> CONFIG_HP_ILO=m
>> CONFIG_APDS9802ALS=y
>> CONFIG_ISL29003=m
>> CONFIG_ISL29020=y
>> CONFIG_SENSORS_TSL2550=m
>> # CONFIG_SENSORS_BH1780 is not set
>> # CONFIG_SENSORS_BH1770 is not set
>> # CONFIG_SENSORS_APDS990X is not set
>> # CONFIG_HMC6352 is not set
>> CONFIG_DS1682=m
>> CONFIG_VMWARE_BALLOON=m
>> # CONFIG_BMP085_I2C is not set
>> CONFIG_PCH_PHUB=m
>> CONFIG_USB_SWITCH_FSA9480=m
>> # CONFIG_C2PORT is not set
>>
>> #
>> # EEPROM support
>> #
>> CONFIG_EEPROM_AT24=m
>> CONFIG_EEPROM_LEGACY=m
>> CONFIG_EEPROM_MAX6875=y
>> CONFIG_EEPROM_93CX6=y
>> CONFIG_CB710_CORE=y
>> # CONFIG_CB710_DEBUG is not set
>> CONFIG_CB710_DEBUG_ASSUMPTIONS=y
>>
>> #
>> # Texas Instruments shared transport line discipline
>> #
>> CONFIG_SENSORS_LIS3_I2C=m
>>
>> #
>> # Altera FPGA firmware download module
>> #
>> CONFIG_ALTERA_STAPL=m
>> # CONFIG_VMWARE_VMCI is not set
>> CONFIG_HAVE_IDE=y
>>
>> #
>> # SCSI device support
>> #
>> CONFIG_SCSI_MOD=y
>> # CONFIG_SCSI_DMA is not set
>> # CONFIG_SCSI_NETLINK is not set
>> CONFIG_FUSION=y
>> CONFIG_FUSION_MAX_SGE=128
>> CONFIG_FUSION_LOGGING=y
>>
>> #
>> # IEEE 1394 (FireWire) support
>> #
>> # CONFIG_FIREWIRE is not set
>> CONFIG_FIREWIRE_NOSY=y
>> CONFIG_I2O=y
>> CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
>> CONFIG_I2O_EXT_ADAPTEC=y
>> CONFIG_I2O_EXT_ADAPTEC_DMA64=y
>> CONFIG_I2O_CONFIG=m
>> # CONFIG_I2O_CONFIG_OLD_IOCTL is not set
>> CONFIG_I2O_BUS=y
>> CONFIG_I2O_PROC=y
>> CONFIG_MACINTOSH_DRIVERS=y
>> CONFIG_NETDEVICES=y
>> CONFIG_NET_CORE=y
>> # CONFIG_DUMMY is not set
>> CONFIG_EQUALIZER=m
>> CONFIG_MII=y
>> CONFIG_NET_TEAM=y
>> CONFIG_NET_TEAM_MODE_BROADCAST=y
>> CONFIG_NET_TEAM_MODE_ROUNDROBIN=y
>> CONFIG_NET_TEAM_MODE_ACTIVEBACKUP=y
>> CONFIG_NET_TEAM_MODE_LOADBALANCE=m
>> CONFIG_MACVLAN=y
>> CONFIG_MACVTAP=y
>> # CONFIG_NETCONSOLE is not set
>> # CONFIG_NETPOLL is not set
>> # CONFIG_NET_POLL_CONTROLLER is not set
>> CONFIG_NTB_NETDEV=m
>> CONFIG_RIONET=m
>> CONFIG_RIONET_TX_SIZE=128
>> CONFIG_RIONET_RX_SIZE=128
>> CONFIG_TUN=y
>> CONFIG_VETH=y
>> # CONFIG_VIRTIO_NET is not set
>> CONFIG_SUNGEM_PHY=m
>> CONFIG_ARCNET=y
>> CONFIG_ARCNET_1201=y
>> # CONFIG_ARCNET_1051 is not set
>> CONFIG_ARCNET_RAW=y
>> CONFIG_ARCNET_CAP=m
>> # CONFIG_ARCNET_COM90xx is not set
>> CONFIG_ARCNET_COM90xxIO=m
>> CONFIG_ARCNET_RIM_I=y
>> # CONFIG_ARCNET_COM20020 is not set
>> # CONFIG_ATM_DRIVERS is not set
>>
>> #
>> # CAIF transport drivers
>> #
>>
>> #
>> # Distributed Switch Architecture drivers
>> #
>> CONFIG_NET_DSA_MV88E6XXX=y
>> CONFIG_NET_DSA_MV88E6060=m
>> CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
>> CONFIG_NET_DSA_MV88E6131=y
>> CONFIG_NET_DSA_MV88E6123_61_65=y
>> CONFIG_ETHERNET=y
>> CONFIG_MDIO=y
>> # CONFIG_NET_VENDOR_3COM is not set
>> # CONFIG_NET_VENDOR_ADAPTEC is not set
>> CONFIG_NET_VENDOR_ALTEON=y
>> # CONFIG_ACENIC is not set
>> # CONFIG_NET_VENDOR_AMD is not set
>> CONFIG_NET_VENDOR_ATHEROS=y
>> # CONFIG_ATL2 is not set
>> CONFIG_ATL1=m
>> CONFIG_ATL1E=m
>> CONFIG_ATL1C=m
>> CONFIG_NET_CADENCE=y
>> CONFIG_ARM_AT91_ETHER=m
>> CONFIG_MACB=m
>> # CONFIG_NET_VENDOR_BROADCOM is not set
>> # CONFIG_NET_VENDOR_BROCADE is not set
>> CONFIG_NET_CALXEDA_XGMAC=y
>> CONFIG_NET_VENDOR_CHELSIO=y
>> CONFIG_CHELSIO_T1=y
>> CONFIG_CHELSIO_T1_1G=y
>> CONFIG_CHELSIO_T4=m
>> CONFIG_CHELSIO_T4VF=y
>> CONFIG_NET_VENDOR_CISCO=y
>> CONFIG_ENIC=m
>> CONFIG_DNET=y
>> # CONFIG_NET_VENDOR_DEC is not set
>> CONFIG_NET_VENDOR_DLINK=y
>> CONFIG_DL2K=m
>> CONFIG_SUNDANCE=y
>> # CONFIG_SUNDANCE_MMIO is not set
>> CONFIG_NET_VENDOR_EMULEX=y
>> CONFIG_BE2NET=y
>> # CONFIG_NET_VENDOR_EXAR is not set
>> CONFIG_NET_VENDOR_HP=y
>> CONFIG_HP100=y
>> CONFIG_NET_VENDOR_INTEL=y
>> CONFIG_E100=m
>> # CONFIG_E1000 is not set
>> # CONFIG_E1000E is not set
>> CONFIG_IGB=y
>> CONFIG_IGBVF=y
>> CONFIG_IXGB=y
>> # CONFIG_IXGBE is not set
>> CONFIG_IXGBEVF=y
>> # CONFIG_NET_VENDOR_I825XX is not set
>> CONFIG_IP1000=y
>> CONFIG_JME=y
>> # CONFIG_NET_VENDOR_MARVELL is not set
>> CONFIG_NET_VENDOR_MELLANOX=y
>> # CONFIG_MLX4_EN is not set
>> # CONFIG_MLX4_CORE is not set
>> # CONFIG_NET_VENDOR_MICREL is not set
>> CONFIG_FEALNX=y
>> # CONFIG_NET_VENDOR_NATSEMI is not set
>> # CONFIG_NET_VENDOR_NVIDIA is not set
>> # CONFIG_NET_VENDOR_OKI is not set
>> CONFIG_ETHOC=m
>> CONFIG_NET_PACKET_ENGINE=y
>> CONFIG_HAMACHI=m
>> CONFIG_YELLOWFIN=m
>> # CONFIG_NET_VENDOR_QLOGIC is not set
>> # CONFIG_NET_VENDOR_REALTEK is not set
>> # CONFIG_NET_VENDOR_RDC is not set
>> CONFIG_NET_VENDOR_SEEQ=y
>> CONFIG_NET_VENDOR_SILAN=y
>> CONFIG_SC92031=m
>> # CONFIG_NET_VENDOR_SIS is not set
>> # CONFIG_SFC is not set
>> CONFIG_NET_VENDOR_SMSC=y
>> CONFIG_EPIC100=y
>> # CONFIG_SMSC9420 is not set
>> CONFIG_NET_VENDOR_STMICRO=y
>> # CONFIG_STMMAC_ETH is not set
>> CONFIG_NET_VENDOR_SUN=y
>> CONFIG_HAPPYMEAL=m
>> CONFIG_SUNGEM=m
>> CONFIG_CASSINI=m
>> CONFIG_NIU=m
>> # CONFIG_NET_VENDOR_TEHUTI is not set
>> # CONFIG_NET_VENDOR_TI is not set
>> CONFIG_NET_VENDOR_VIA=y
>> CONFIG_VIA_RHINE=m
>> # CONFIG_VIA_RHINE_MMIO is not set
>> CONFIG_VIA_VELOCITY=m
>> CONFIG_NET_VENDOR_WIZNET=y
>> CONFIG_WIZNET_W5100=y
>> CONFIG_WIZNET_W5300=m
>> # CONFIG_WIZNET_BUS_DIRECT is not set
>> CONFIG_WIZNET_BUS_INDIRECT=y
>> # CONFIG_WIZNET_BUS_ANY is not set
>> CONFIG_FDDI=y
>> # CONFIG_DEFXX is not set
>> # CONFIG_SKFP is not set
>> # CONFIG_NET_SB1000 is not set
>> CONFIG_PHYLIB=y
>>
>> #
>> # MII PHY device drivers
>> #
>> CONFIG_AT803X_PHY=m
>> # CONFIG_AMD_PHY is not set
>> # CONFIG_MARVELL_PHY is not set
>> # CONFIG_DAVICOM_PHY is not set
>> CONFIG_QSEMI_PHY=y
>> CONFIG_LXT_PHY=y
>> # CONFIG_CICADA_PHY is not set
>> # CONFIG_VITESSE_PHY is not set
>> CONFIG_SMSC_PHY=m
>> CONFIG_BROADCOM_PHY=m
>> CONFIG_BCM87XX_PHY=y
>> # CONFIG_ICPLUS_PHY is not set
>> CONFIG_REALTEK_PHY=m
>> # CONFIG_NATIONAL_PHY is not set
>> CONFIG_STE10XP=m
>> CONFIG_LSI_ET1011C_PHY=y
>> CONFIG_MICREL_PHY=y
>> # CONFIG_FIXED_PHY is not set
>> CONFIG_MDIO_BITBANG=m
>> # CONFIG_PLIP is not set
>> # CONFIG_PPP is not set
>>
>> #
>> # USB Network Adapters
>> #
>> CONFIG_USB_CATC=m
>> CONFIG_USB_KAWETH=m
>> # CONFIG_USB_PEGASUS is not set
>> CONFIG_USB_RTL8150=m
>> # CONFIG_USB_USBNET is not set
>> CONFIG_USB_CDC_PHONET=m
>> CONFIG_USB_IPHETH=m
>> CONFIG_WLAN=y
>> # CONFIG_LIBERTAS_THINFIRM is not set
>> CONFIG_ATMEL=y
>> CONFIG_PCI_ATMEL=y
>> CONFIG_AT76C50X_USB=m
>> # CONFIG_PRISM54 is not set
>> CONFIG_USB_ZD1201=m
>> # CONFIG_USB_NET_RNDIS_WLAN is not set
>> CONFIG_RTL8180=m
>> # CONFIG_RTL8187 is not set
>> # CONFIG_ADM8211 is not set
>> CONFIG_MAC80211_HWSIM=y
>> CONFIG_MWL8K=y
>> CONFIG_ATH_COMMON=m
>> CONFIG_ATH_CARDS=m
>> # CONFIG_ATH_DEBUG is not set
>> # CONFIG_ATH5K is not set
>> # CONFIG_ATH5K_PCI is not set
>> CONFIG_ATH9K_HW=m
>> CONFIG_ATH9K_COMMON=m
>> CONFIG_ATH9K_BTCOEX_SUPPORT=y
>> # CONFIG_ATH9K is not set
>> CONFIG_ATH9K_HTC=m
>> # CONFIG_ATH9K_HTC_DEBUGFS is not set
>> CONFIG_CARL9170=m
>> # CONFIG_CARL9170_LEDS is not set
>> # CONFIG_CARL9170_DEBUGFS is not set
>> CONFIG_CARL9170_WPC=y
>> # CONFIG_CARL9170_HWRNG is not set
>> CONFIG_ATH6KL=m
>> CONFIG_ATH6KL_USB=m
>> # CONFIG_ATH6KL_DEBUG is not set
>> CONFIG_ATH6KL_TRACING=y
>> # CONFIG_ATH6KL_REGDOMAIN is not set
>> CONFIG_AR5523=m
>> CONFIG_WIL6210=m
>> # CONFIG_WIL6210_ISR_COR is not set
>> # CONFIG_B43 is not set
>> # CONFIG_B43LEGACY is not set
>> CONFIG_BRCMUTIL=m
>> CONFIG_BRCMFMAC=m
>> # CONFIG_BRCMFMAC_USB is not set
>> CONFIG_BRCM_TRACING=y
>> # CONFIG_BRCMDBG is not set
>> CONFIG_HOSTAP=y
>> # CONFIG_HOSTAP_FIRMWARE is not set
>> CONFIG_HOSTAP_PLX=m
>> # CONFIG_HOSTAP_PCI is not set
>> CONFIG_IPW2100=y
>> CONFIG_IPW2100_MONITOR=y
>> # CONFIG_IPW2100_DEBUG is not set
>> CONFIG_LIBIPW=y
>> CONFIG_LIBIPW_DEBUG=y
>> CONFIG_IWLWIFI=m
>> # CONFIG_IWLDVM is not set
>> CONFIG_IWLMVM=m
>> CONFIG_IWLWIFI_OPMODE_MODULAR=y
>>
>> #
>> # Debugging Options
>> #
>> CONFIG_IWLWIFI_DEBUG=y
>> # CONFIG_IWLWIFI_DEBUGFS is not set
>> CONFIG_IWLWIFI_DEBUG_EXPERIMENTAL_UCODE=y
>> CONFIG_IWLWIFI_DEVICE_TRACING=y
>> CONFIG_IWLWIFI_DEVICE_TESTMODE=y
>> # CONFIG_IWLWIFI_P2P is not set
>> CONFIG_IWLEGACY=y
>> # CONFIG_IWL4965 is not set
>> CONFIG_IWL3945=y
>>
>> #
>> # iwl3945 / iwl4965 Debugging Options
>> #
>> CONFIG_IWLEGACY_DEBUG=y
>> CONFIG_IWLEGACY_DEBUGFS=y
>> CONFIG_LIBERTAS=m
>> CONFIG_LIBERTAS_USB=m
>> CONFIG_LIBERTAS_DEBUG=y
>> # CONFIG_LIBERTAS_MESH is not set
>> # CONFIG_P54_COMMON is not set
>> CONFIG_RT2X00=y
>> CONFIG_RT2400PCI=y
>> CONFIG_RT2500PCI=y
>> # CONFIG_RT61PCI is not set
>> CONFIG_RT2800PCI=y
>> # CONFIG_RT2800PCI_RT33XX is not set
>> # CONFIG_RT2800PCI_RT35XX is not set
>> # CONFIG_RT2800PCI_RT53XX is not set
>> CONFIG_RT2800PCI_RT3290=y
>> # CONFIG_RT2500USB is not set
>> CONFIG_RT73USB=m
>> # CONFIG_RT2800USB is not set
>> CONFIG_RT2800_LIB=y
>> CONFIG_RT2X00_LIB_PCI=y
>> CONFIG_RT2X00_LIB_USB=m
>> CONFIG_RT2X00_LIB=y
>> CONFIG_RT2X00_LIB_FIRMWARE=y
>> CONFIG_RT2X00_LIB_CRYPTO=y
>> CONFIG_RT2X00_LIB_LEDS=y
>> # CONFIG_RT2X00_LIB_DEBUGFS is not set
>> CONFIG_RT2X00_DEBUG=y
>> CONFIG_RTLWIFI=y
>> CONFIG_RTLWIFI_DEBUG=y
>> CONFIG_RTL8192CE=m
>> # CONFIG_RTL8192SE is not set
>> CONFIG_RTL8192DE=y
>> # CONFIG_RTL8723AE is not set
>> # CONFIG_RTL8192CU is not set
>> CONFIG_RTL8192C_COMMON=m
>> # CONFIG_WL_TI is not set
>> # CONFIG_ZD1211RW is not set
>> # CONFIG_MWIFIEX is not set
>>
>> #
>> # Enable WiMAX (Networking options) to see the WiMAX drivers
>> #
>> # CONFIG_WAN is not set
>> CONFIG_IEEE802154_DRIVERS=y
>> CONFIG_IEEE802154_FAKEHARD=y
>> # CONFIG_ISDN is not set
>>
>> #
>> # Input device support
>> #
>> CONFIG_INPUT=y
>> CONFIG_INPUT_FF_MEMLESS=m
>> CONFIG_INPUT_POLLDEV=m
>> CONFIG_INPUT_SPARSEKMAP=m
>> CONFIG_INPUT_MATRIXKMAP=m
>>
>> #
>> # Userland interfaces
>> #
>> CONFIG_INPUT_MOUSEDEV=m
>> CONFIG_INPUT_MOUSEDEV_PSAUX=y
>> CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
>> CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
>> # CONFIG_INPUT_JOYDEV is not set
>> # CONFIG_INPUT_EVDEV is not set
>> CONFIG_INPUT_EVBUG=m
>>
>> #
>> # Input Device Drivers
>> #
>> CONFIG_INPUT_KEYBOARD=y
>> CONFIG_KEYBOARD_ADP5520=m
>> CONFIG_KEYBOARD_ADP5588=m
>> CONFIG_KEYBOARD_ADP5589=m
>> CONFIG_KEYBOARD_ATKBD=y
>> CONFIG_KEYBOARD_QT1070=m
>> CONFIG_KEYBOARD_QT2160=m
>> CONFIG_KEYBOARD_LKKBD=m
>> CONFIG_KEYBOARD_TCA6416=m
>> CONFIG_KEYBOARD_TCA8418=m
>> CONFIG_KEYBOARD_LM8323=m
>> CONFIG_KEYBOARD_LM8333=m
>> # CONFIG_KEYBOARD_MAX7359 is not set
>> CONFIG_KEYBOARD_MCS=m
>> CONFIG_KEYBOARD_MPR121=m
>> CONFIG_KEYBOARD_NEWTON=m
>> CONFIG_KEYBOARD_OPENCORES=m
>> CONFIG_KEYBOARD_STOWAWAY=m
>> CONFIG_KEYBOARD_SUNKBD=m
>> CONFIG_KEYBOARD_STMPE=m
>> CONFIG_KEYBOARD_XTKBD=m
>> # CONFIG_INPUT_MOUSE is not set
>> CONFIG_INPUT_JOYSTICK=y
>> CONFIG_JOYSTICK_ANALOG=m
>> CONFIG_JOYSTICK_A3D=m
>> CONFIG_JOYSTICK_ADI=m
>> CONFIG_JOYSTICK_COBRA=m
>> # CONFIG_JOYSTICK_GF2K is not set
>> CONFIG_JOYSTICK_GRIP=m
>> CONFIG_JOYSTICK_GRIP_MP=m
>> CONFIG_JOYSTICK_GUILLEMOT=m
>> CONFIG_JOYSTICK_INTERACT=m
>> CONFIG_JOYSTICK_SIDEWINDER=m
>> CONFIG_JOYSTICK_TMDC=m
>> CONFIG_JOYSTICK_IFORCE=m
>> # CONFIG_JOYSTICK_IFORCE_USB is not set
>> CONFIG_JOYSTICK_IFORCE_232=y
>> CONFIG_JOYSTICK_WARRIOR=m
>> CONFIG_JOYSTICK_MAGELLAN=m
>> CONFIG_JOYSTICK_SPACEORB=m
>> CONFIG_JOYSTICK_SPACEBALL=m
>> CONFIG_JOYSTICK_STINGER=m
>> CONFIG_JOYSTICK_TWIDJOY=m
>> # CONFIG_JOYSTICK_ZHENHUA is not set
>> CONFIG_JOYSTICK_DB9=m
>> CONFIG_JOYSTICK_GAMECON=m
>> CONFIG_JOYSTICK_TURBOGRAFX=m
>> CONFIG_JOYSTICK_AS5011=m
>> # CONFIG_JOYSTICK_JOYDUMP is not set
>> CONFIG_JOYSTICK_XPAD=m
>> # CONFIG_JOYSTICK_XPAD_FF is not set
>> # CONFIG_JOYSTICK_XPAD_LEDS is not set
>> CONFIG_INPUT_TABLET=y
>> # CONFIG_TABLET_USB_ACECAD is not set
>> CONFIG_TABLET_USB_AIPTEK=m
>> CONFIG_TABLET_USB_GTCO=m
>> CONFIG_TABLET_USB_HANWANG=m
>> CONFIG_TABLET_USB_KBTAB=m
>> CONFIG_TABLET_USB_WACOM=m
>> CONFIG_INPUT_TOUCHSCREEN=y
>> CONFIG_TOUCHSCREEN_AD7879=m
>> CONFIG_TOUCHSCREEN_AD7879_I2C=m
>> CONFIG_TOUCHSCREEN_ATMEL_MXT=m
>> CONFIG_TOUCHSCREEN_BU21013=m
>> CONFIG_TOUCHSCREEN_CYTTSP_CORE=m
>> # CONFIG_TOUCHSCREEN_CYTTSP_I2C is not set
>> # CONFIG_TOUCHSCREEN_DYNAPRO is not set
>> CONFIG_TOUCHSCREEN_HAMPSHIRE=m
>> CONFIG_TOUCHSCREEN_EETI=m
>> CONFIG_TOUCHSCREEN_FUJITSU=m
>> CONFIG_TOUCHSCREEN_ILI210X=m
>> CONFIG_TOUCHSCREEN_GUNZE=m
>> CONFIG_TOUCHSCREEN_ELO=m
>> CONFIG_TOUCHSCREEN_WACOM_W8001=m
>> CONFIG_TOUCHSCREEN_WACOM_I2C=m
>> # CONFIG_TOUCHSCREEN_MAX11801 is not set
>> CONFIG_TOUCHSCREEN_MCS5000=m
>> # CONFIG_TOUCHSCREEN_MMS114 is not set
>> # CONFIG_TOUCHSCREEN_MTOUCH is not set
>> CONFIG_TOUCHSCREEN_INEXIO=m
>> CONFIG_TOUCHSCREEN_MK712=m
>> # CONFIG_TOUCHSCREEN_PENMOUNT is not set
>> CONFIG_TOUCHSCREEN_EDT_FT5X06=m
>> # CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
>> CONFIG_TOUCHSCREEN_TOUCHWIN=m
>> CONFIG_TOUCHSCREEN_TI_AM335X_TSC=m
>> CONFIG_TOUCHSCREEN_PIXCIR=m
>> # CONFIG_TOUCHSCREEN_WM831X is not set
>> CONFIG_TOUCHSCREEN_WM97XX=m
>> # CONFIG_TOUCHSCREEN_WM9705 is not set
>> CONFIG_TOUCHSCREEN_WM9712=y
>> CONFIG_TOUCHSCREEN_WM9713=y
>> CONFIG_TOUCHSCREEN_USB_COMPOSITE=m
>> # CONFIG_TOUCHSCREEN_USB_EGALAX is not set
>> # CONFIG_TOUCHSCREEN_USB_PANJIT is not set
>> CONFIG_TOUCHSCREEN_USB_3M=y
>> # CONFIG_TOUCHSCREEN_USB_ITM is not set
>> # CONFIG_TOUCHSCREEN_USB_ETURBO is not set
>> # CONFIG_TOUCHSCREEN_USB_GUNZE is not set
>> # CONFIG_TOUCHSCREEN_USB_DMC_TSC10 is not set
>> CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
>> CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
>> CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
>> CONFIG_TOUCHSCREEN_USB_GOTOP=y
>> # CONFIG_TOUCHSCREEN_USB_JASTEC is not set
>> # CONFIG_TOUCHSCREEN_USB_ELO is not set
>> CONFIG_TOUCHSCREEN_USB_E2I=y
>> # CONFIG_TOUCHSCREEN_USB_ZYTRONIC is not set
>> # CONFIG_TOUCHSCREEN_USB_ETT_TC45USB is not set
>> # CONFIG_TOUCHSCREEN_USB_NEXIO is not set
>> CONFIG_TOUCHSCREEN_USB_EASYTOUCH=y
>> CONFIG_TOUCHSCREEN_TOUCHIT213=m
>> CONFIG_TOUCHSCREEN_TSC_SERIO=m
>> CONFIG_TOUCHSCREEN_TSC2007=m
>> CONFIG_TOUCHSCREEN_ST1232=m
>> CONFIG_TOUCHSCREEN_STMPE=m
>> CONFIG_TOUCHSCREEN_TPS6507X=m
>> CONFIG_INPUT_MISC=y
>> CONFIG_INPUT_88PM80X_ONKEY=m
>> CONFIG_INPUT_AD714X=m
>> CONFIG_INPUT_AD714X_I2C=m
>> CONFIG_INPUT_BMA150=m
>> CONFIG_INPUT_PCSPKR=m
>> CONFIG_INPUT_MMA8450=m
>> CONFIG_INPUT_MPU3050=m
>> CONFIG_INPUT_APANEL=m
>> # CONFIG_INPUT_ATLAS_BTNS is not set
>> CONFIG_INPUT_ATI_REMOTE2=m
>> # CONFIG_INPUT_KEYSPAN_REMOTE is not set
>> # CONFIG_INPUT_KXTJ9 is not set
>> CONFIG_INPUT_POWERMATE=m
>> # CONFIG_INPUT_YEALINK is not set
>> CONFIG_INPUT_CM109=m
>> CONFIG_INPUT_RETU_PWRBUTTON=m
>> CONFIG_INPUT_UINPUT=m
>> # CONFIG_INPUT_PCF50633_PMU is not set
>> CONFIG_INPUT_PCF8574=m
>> CONFIG_INPUT_PWM_BEEPER=m
>> # CONFIG_INPUT_DA9055_ONKEY is not set
>> CONFIG_INPUT_WM831X_ON=m
>> CONFIG_INPUT_ADXL34X=m
>> # CONFIG_INPUT_ADXL34X_I2C is not set
>> CONFIG_INPUT_CMA3000=m
>> CONFIG_INPUT_CMA3000_I2C=m
>>
>> #
>> # Hardware I/O ports
>> #
>> CONFIG_SERIO=y
>> CONFIG_SERIO_I8042=y
>> CONFIG_SERIO_CT82C710=m
>> # CONFIG_SERIO_PARKBD is not set
>> CONFIG_SERIO_PCIPS2=m
>> CONFIG_SERIO_LIBPS2=y
>> CONFIG_SERIO_RAW=m
>> CONFIG_SERIO_ALTERA_PS2=m
>> CONFIG_SERIO_PS2MULT=m
>> # CONFIG_SERIO_ARC_PS2 is not set
>> CONFIG_GAMEPORT=m
>> CONFIG_GAMEPORT_NS558=m
>> CONFIG_GAMEPORT_L4=m
>> # CONFIG_GAMEPORT_EMU10K1 is not set
>> CONFIG_GAMEPORT_FM801=m
>>
>> #
>> # Character devices
>> #
>> # CONFIG_TTY is not set
>> CONFIG_DEVKMEM=y
>> CONFIG_PRINTER=m
>> # CONFIG_LP_CONSOLE is not set
>> # CONFIG_PPDEV is not set
>> CONFIG_IPMI_HANDLER=y
>> CONFIG_IPMI_PANIC_EVENT=y
>> CONFIG_IPMI_PANIC_STRING=y
>> # CONFIG_IPMI_DEVICE_INTERFACE is not set
>> CONFIG_IPMI_SI=y
>> CONFIG_IPMI_WATCHDOG=m
>> CONFIG_IPMI_POWEROFF=y
>> CONFIG_HW_RANDOM=m
>> CONFIG_HW_RANDOM_TIMERIOMEM=m
>> CONFIG_HW_RANDOM_INTEL=m
>> CONFIG_HW_RANDOM_AMD=m
>> CONFIG_HW_RANDOM_VIA=m
>> CONFIG_HW_RANDOM_VIRTIO=m
>> CONFIG_NVRAM=m
>> CONFIG_APPLICOM=y
>> # CONFIG_HPET is not set
>> CONFIG_HANGCHECK_TIMER=m
>> # CONFIG_TCG_TPM is not set
>> # CONFIG_TELCLOCK is not set
>> CONFIG_DEVPORT=y
>> CONFIG_I2C=y
>> CONFIG_I2C_BOARDINFO=y
>> CONFIG_I2C_COMPAT=y
>> CONFIG_I2C_CHARDEV=y
>> CONFIG_I2C_MUX=y
>>
>> #
>> # Multiplexer I2C Chip support
>> #
>> # CONFIG_I2C_MUX_PCA9541 is not set
>> # CONFIG_I2C_MUX_PCA954x is not set
>> # CONFIG_I2C_HELPER_AUTO is not set
>> CONFIG_I2C_SMBUS=m
>>
>> #
>> # I2C Algorithms
>> #
>> CONFIG_I2C_ALGOBIT=y
>> CONFIG_I2C_ALGOPCF=y
>> CONFIG_I2C_ALGOPCA=y
>>
>> #
>> # I2C Hardware Bus support
>> #
>>
>> #
>> # PC SMBus host controller drivers
>> #
>> CONFIG_I2C_ALI1535=m
>> CONFIG_I2C_ALI1563=m
>> CONFIG_I2C_ALI15X3=y
>> # CONFIG_I2C_AMD756 is not set
>> CONFIG_I2C_AMD8111=m
>> CONFIG_I2C_I801=y
>> # CONFIG_I2C_ISCH is not set
>> CONFIG_I2C_ISMT=y
>> # CONFIG_I2C_PIIX4 is not set
>> CONFIG_I2C_NFORCE2=m
>> CONFIG_I2C_NFORCE2_S4985=m
>> CONFIG_I2C_SIS5595=m
>> CONFIG_I2C_SIS630=m
>> CONFIG_I2C_SIS96X=m
>> CONFIG_I2C_VIA=y
>> # CONFIG_I2C_VIAPRO is not set
>>
>> #
>> # ACPI drivers
>> #
>> # CONFIG_I2C_SCMI is not set
>>
>> #
>> # I2C system bus drivers (mostly embedded / system-on-chip)
>> #
>> CONFIG_I2C_DESIGNWARE_CORE=y
>> CONFIG_I2C_DESIGNWARE_PCI=y
>> # CONFIG_I2C_EG20T is not set
>> CONFIG_I2C_INTEL_MID=m
>> # CONFIG_I2C_OCORES is not set
>> # CONFIG_I2C_PCA_PLATFORM is not set
>> # CONFIG_I2C_PXA_PCI is not set
>> CONFIG_I2C_SIMTEC=m
>> CONFIG_I2C_XILINX=m
>>
>> #
>> # External I2C/SMBus adapter drivers
>> #
>> # CONFIG_I2C_DIOLAN_U2C is not set
>> CONFIG_I2C_PARPORT=m
>> # CONFIG_I2C_PARPORT_LIGHT is not set
>> # CONFIG_I2C_TINY_USB is not set
>> CONFIG_I2C_VIPERBOARD=m
>>
>> #
>> # Other I2C/SMBus bus drivers
>> #
>> # CONFIG_I2C_STUB is not set
>> # CONFIG_I2C_DEBUG_CORE is not set
>> # CONFIG_I2C_DEBUG_ALGO is not set
>> # CONFIG_I2C_DEBUG_BUS is not set
>> # CONFIG_SPI is not set
>> # CONFIG_HSI is not set
>>
>> #
>> # PPS support
>> #
>> CONFIG_PPS=y
>> # CONFIG_PPS_DEBUG is not set
>> CONFIG_NTP_PPS=y
>>
>> #
>> # PPS clients support
>> #
>> # CONFIG_PPS_CLIENT_KTIMER is not set
>> CONFIG_PPS_CLIENT_PARPORT=m
>> CONFIG_PPS_CLIENT_GPIO=m
>>
>> #
>> # PPS generators support
>> #
>>
>> #
>> # PTP clock support
>> #
>> CONFIG_PTP_1588_CLOCK=y
>>
>> #
>> # Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
>> #
>> # CONFIG_PTP_1588_CLOCK_PCH is not set
>> CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
>> CONFIG_GPIO_DEVRES=y
>> # CONFIG_GPIOLIB is not set
>> CONFIG_W1=y
>> CONFIG_W1_CON=y
>>
>> #
>> # 1-wire Bus Masters
>> #
>> CONFIG_W1_MASTER_MATROX=y
>> # CONFIG_W1_MASTER_DS2490 is not set
>> CONFIG_W1_MASTER_DS2482=y
>> CONFIG_W1_MASTER_DS1WM=m
>>
>> #
>> # 1-wire Slaves
>> #
>> CONFIG_W1_SLAVE_THERM=m
>> # CONFIG_W1_SLAVE_SMEM is not set
>> # CONFIG_W1_SLAVE_DS2408 is not set
>> # CONFIG_W1_SLAVE_DS2413 is not set
>> CONFIG_W1_SLAVE_DS2423=y
>> CONFIG_W1_SLAVE_DS2431=m
>> CONFIG_W1_SLAVE_DS2433=m
>> # CONFIG_W1_SLAVE_DS2433_CRC is not set
>> CONFIG_W1_SLAVE_DS2760=m
>> CONFIG_W1_SLAVE_DS2780=y
>> CONFIG_W1_SLAVE_DS2781=y
>> # CONFIG_W1_SLAVE_DS28E04 is not set
>> CONFIG_W1_SLAVE_BQ27000=y
>> CONFIG_POWER_SUPPLY=y
>> CONFIG_POWER_SUPPLY_DEBUG=y
>> CONFIG_PDA_POWER=m
>> CONFIG_WM831X_BACKUP=y
>> # CONFIG_WM831X_POWER is not set
>> CONFIG_WM8350_POWER=m
>> # CONFIG_TEST_POWER is not set
>> CONFIG_BATTERY_DS2760=m
>> # CONFIG_BATTERY_DS2780 is not set
>> CONFIG_BATTERY_DS2781=y
>> CONFIG_BATTERY_DS2782=m
>> # CONFIG_BATTERY_SBS is not set
>> # CONFIG_BATTERY_BQ27x00 is not set
>> CONFIG_BATTERY_MAX17040=m
>> CONFIG_BATTERY_MAX17042=y
>> CONFIG_CHARGER_PCF50633=m
>> # CONFIG_CHARGER_ISP1704 is not set
>> # CONFIG_CHARGER_MAX8903 is not set
>> CONFIG_CHARGER_LP8727=m
>> # CONFIG_CHARGER_BQ2415X is not set
>> CONFIG_CHARGER_SMB347=m
>> # CONFIG_BATTERY_GOLDFISH is not set
>> # CONFIG_POWER_RESET is not set
>> # CONFIG_POWER_AVS is not set
>> CONFIG_HWMON=m
>> CONFIG_HWMON_VID=m
>> # CONFIG_HWMON_DEBUG_CHIP is not set
>>
>> #
>> # Native drivers
>> #
>> CONFIG_SENSORS_ABITUGURU=m
>> # CONFIG_SENSORS_ABITUGURU3 is not set
>> CONFIG_SENSORS_AD7414=m
>> # CONFIG_SENSORS_AD7418 is not set
>> # CONFIG_SENSORS_ADM1021 is not set
>> CONFIG_SENSORS_ADM1025=m
>> CONFIG_SENSORS_ADM1026=m
>> CONFIG_SENSORS_ADM1029=m
>> CONFIG_SENSORS_ADM1031=m
>> # CONFIG_SENSORS_ADM9240 is not set
>> # CONFIG_SENSORS_ADT7410 is not set
>> # CONFIG_SENSORS_ADT7411 is not set
>> CONFIG_SENSORS_ADT7462=m
>> CONFIG_SENSORS_ADT7470=m
>> # CONFIG_SENSORS_ADT7475 is not set
>> CONFIG_SENSORS_ASC7621=m
>> # CONFIG_SENSORS_K8TEMP is not set
>> CONFIG_SENSORS_K10TEMP=m
>> # CONFIG_SENSORS_FAM15H_POWER is not set
>> CONFIG_SENSORS_ASB100=m
>> CONFIG_SENSORS_ATXP1=m
>> CONFIG_SENSORS_DS620=m
>> CONFIG_SENSORS_DS1621=m
>> CONFIG_SENSORS_DA9055=m
>> CONFIG_SENSORS_I5K_AMB=m
>> CONFIG_SENSORS_F71805F=m
>> CONFIG_SENSORS_F71882FG=m
>> CONFIG_SENSORS_F75375S=m
>> # CONFIG_SENSORS_FSCHMD is not set
>> CONFIG_SENSORS_G760A=m
>> # CONFIG_SENSORS_GL518SM is not set
>> # CONFIG_SENSORS_GL520SM is not set
>> CONFIG_SENSORS_HIH6130=m
>> # CONFIG_SENSORS_CORETEMP is not set
>> # CONFIG_SENSORS_IBMAEM is not set
>> CONFIG_SENSORS_IBMPEX=m
>> # CONFIG_SENSORS_IT87 is not set
>> # CONFIG_SENSORS_JC42 is not set
>> # CONFIG_SENSORS_LINEAGE is not set
>> # CONFIG_SENSORS_LM63 is not set
>> CONFIG_SENSORS_LM73=m
>> CONFIG_SENSORS_LM75=m
>> CONFIG_SENSORS_LM77=m
>> CONFIG_SENSORS_LM78=m
>> # CONFIG_SENSORS_LM80 is not set
>> CONFIG_SENSORS_LM83=m
>> CONFIG_SENSORS_LM85=m
>> # CONFIG_SENSORS_LM87 is not set
>> CONFIG_SENSORS_LM90=m
>> CONFIG_SENSORS_LM92=m
>> CONFIG_SENSORS_LM93=m
>> # CONFIG_SENSORS_LTC4151 is not set
>> CONFIG_SENSORS_LTC4215=m
>> # CONFIG_SENSORS_LTC4245 is not set
>> CONFIG_SENSORS_LTC4261=m
>> CONFIG_SENSORS_LM95241=m
>> # CONFIG_SENSORS_LM95245 is not set
>> # CONFIG_SENSORS_MAX16065 is not set
>> # CONFIG_SENSORS_MAX1619 is not set
>> # CONFIG_SENSORS_MAX1668 is not set
>> CONFIG_SENSORS_MAX197=m
>> CONFIG_SENSORS_MAX6639=m
>> CONFIG_SENSORS_MAX6642=m
>> # CONFIG_SENSORS_MAX6650 is not set
>> # CONFIG_SENSORS_MAX6697 is not set
>> CONFIG_SENSORS_MCP3021=m
>> # CONFIG_SENSORS_NTC_THERMISTOR is not set
>> CONFIG_SENSORS_PC87360=m
>> CONFIG_SENSORS_PC87427=m
>> CONFIG_SENSORS_PCF8591=m
>> CONFIG_PMBUS=m
>> # CONFIG_SENSORS_PMBUS is not set
>> CONFIG_SENSORS_ADM1275=m
>> # CONFIG_SENSORS_LM25066 is not set
>> # CONFIG_SENSORS_LTC2978 is not set
>> CONFIG_SENSORS_MAX16064=m
>> # CONFIG_SENSORS_MAX34440 is not set
>> CONFIG_SENSORS_MAX8688=m
>> CONFIG_SENSORS_UCD9000=m
>> CONFIG_SENSORS_UCD9200=m
>> CONFIG_SENSORS_ZL6100=m
>> CONFIG_SENSORS_SHT21=m
>> CONFIG_SENSORS_SIS5595=m
>> # CONFIG_SENSORS_SMM665 is not set
>> CONFIG_SENSORS_DME1737=m
>> CONFIG_SENSORS_EMC1403=m
>> # CONFIG_SENSORS_EMC2103 is not set
>> CONFIG_SENSORS_EMC6W201=m
>> CONFIG_SENSORS_SMSC47M1=m
>> # CONFIG_SENSORS_SMSC47M192 is not set
>> CONFIG_SENSORS_SMSC47B397=m
>> # CONFIG_SENSORS_SCH56XX_COMMON is not set
>> # CONFIG_SENSORS_ADS1015 is not set
>> CONFIG_SENSORS_ADS7828=m
>> CONFIG_SENSORS_AMC6821=m
>> CONFIG_SENSORS_INA209=m
>> CONFIG_SENSORS_INA2XX=m
>> # CONFIG_SENSORS_THMC50 is not set
>> CONFIG_SENSORS_TMP102=m
>> CONFIG_SENSORS_TMP401=m
>> CONFIG_SENSORS_TMP421=m
>> # CONFIG_SENSORS_VIA_CPUTEMP is not set
>> CONFIG_SENSORS_VIA686A=m
>> CONFIG_SENSORS_VT1211=m
>> CONFIG_SENSORS_VT8231=m
>> CONFIG_SENSORS_W83781D=m
>> CONFIG_SENSORS_W83791D=m
>> CONFIG_SENSORS_W83792D=m
>> CONFIG_SENSORS_W83793=m
>> CONFIG_SENSORS_W83795=m
>> CONFIG_SENSORS_W83795_FANCTRL=y
>> CONFIG_SENSORS_W83L785TS=m
>> # CONFIG_SENSORS_W83L786NG is not set
>> # CONFIG_SENSORS_W83627HF is not set
>> # CONFIG_SENSORS_W83627EHF is not set
>> # CONFIG_SENSORS_WM831X is not set
>> CONFIG_SENSORS_WM8350=m
>> CONFIG_SENSORS_APPLESMC=m
>>
>> #
>> # ACPI drivers
>> #
>> # CONFIG_SENSORS_ACPI_POWER is not set
>> # CONFIG_SENSORS_ATK0110 is not set
>> CONFIG_THERMAL=y
>> CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
>> # CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
>> # CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
>> # CONFIG_THERMAL_GOV_FAIR_SHARE is not set
>> CONFIG_THERMAL_GOV_STEP_WISE=y
>> # CONFIG_THERMAL_GOV_USER_SPACE is not set
>> # CONFIG_CPU_THERMAL is not set
>> # CONFIG_THERMAL_EMULATION is not set
>> # CONFIG_INTEL_POWERCLAMP is not set
>> # CONFIG_WATCHDOG is not set
>> CONFIG_SSB_POSSIBLE=y
>>
>> #
>> # Sonics Silicon Backplane
>> #
>> CONFIG_SSB=y
>> CONFIG_SSB_PCIHOST_POSSIBLE=y
>> # CONFIG_SSB_PCIHOST is not set
>> # CONFIG_SSB_SILENT is not set
>> # CONFIG_SSB_DEBUG is not set
>> CONFIG_BCMA_POSSIBLE=y
>>
>> #
>> # Broadcom specific AMBA
>> #
>> # CONFIG_BCMA is not set
>>
>> #
>> # Multifunction device drivers
>> #
>> CONFIG_MFD_CORE=y
>> # CONFIG_MFD_88PM860X is not set
>> CONFIG_MFD_88PM800=m
>> # CONFIG_MFD_88PM805 is not set
>> # CONFIG_MFD_SM501 is not set
>> CONFIG_MFD_RTSX_PCI=y
>> CONFIG_MFD_TI_AM335X_TSCADC=m
>> CONFIG_HTC_PASIC3=m
>> CONFIG_MFD_LM3533=m
>> # CONFIG_TPS6105X is not set
>> CONFIG_TPS6507X=m
>> CONFIG_MFD_TPS65217=m
>> CONFIG_MFD_TPS6586X=y
>> CONFIG_MFD_TPS80031=y
>> # CONFIG_TWL4030_CORE is not set
>> # CONFIG_TWL6040_CORE is not set
>> CONFIG_MFD_STMPE=y
>>
>> #
>> # STMPE Interface Drivers
>> #
>> # CONFIG_STMPE_I2C is not set
>> # CONFIG_MFD_TC3589X is not set
>> # CONFIG_MFD_TMIO is not set
>> CONFIG_MFD_SMSC=y
>> # CONFIG_PMIC_DA903X is not set
>> # CONFIG_MFD_DA9052_I2C is not set
>> CONFIG_MFD_DA9055=y
>> CONFIG_PMIC_ADP5520=y
>> # CONFIG_MFD_LP8788 is not set
>> # CONFIG_MFD_MAX77686 is not set
>> # CONFIG_MFD_MAX77693 is not set
>> CONFIG_MFD_MAX8907=m
>> # CONFIG_MFD_MAX8925 is not set
>> # CONFIG_MFD_MAX8997 is not set
>> # CONFIG_MFD_MAX8998 is not set
>> # CONFIG_MFD_SEC_CORE is not set
>> CONFIG_MFD_ARIZONA=y
>> CONFIG_MFD_ARIZONA_I2C=y
>> CONFIG_MFD_WM5102=y
>> CONFIG_MFD_WM5110=y
>> CONFIG_MFD_WM8400=y
>> CONFIG_MFD_WM831X=y
>> CONFIG_MFD_WM831X_I2C=y
>> CONFIG_MFD_WM8350=y
>> CONFIG_MFD_WM8350_I2C=y
>> CONFIG_MFD_WM8994=y
>> CONFIG_MFD_PCF50633=y
>> CONFIG_PCF50633_ADC=m
>> CONFIG_PCF50633_GPIO=y
>> # CONFIG_MFD_MC13XXX_I2C is not set
>> # CONFIG_ABX500_CORE is not set
>> CONFIG_MFD_CS5535=y
>> # CONFIG_LPC_SCH is not set
>> CONFIG_LPC_ICH=y
>> # CONFIG_MFD_RDC321X is not set
>> CONFIG_MFD_JANZ_CMODIO=m
>> CONFIG_MFD_VX855=m
>> # CONFIG_MFD_WL1273_CORE is not set
>> CONFIG_MFD_TPS65090=y
>> # CONFIG_MFD_RC5T583 is not set
>> # CONFIG_MFD_PALMAS is not set
>> CONFIG_MFD_VIPERBOARD=m
>> CONFIG_MFD_RETU=y
>> CONFIG_MFD_AS3711=y
>> # CONFIG_REGULATOR is not set
>> CONFIG_MEDIA_SUPPORT=y
>>
>> #
>> # Multimedia core support
>> #
>> CONFIG_MEDIA_CAMERA_SUPPORT=y
>> # CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
>> # CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
>> # CONFIG_MEDIA_RADIO_SUPPORT is not set
>> CONFIG_MEDIA_RC_SUPPORT=y
>> # CONFIG_MEDIA_CONTROLLER is not set
>> CONFIG_VIDEO_DEV=y
>> CONFIG_VIDEO_V4L2=y
>> # CONFIG_VIDEO_ADV_DEBUG is not set
>> CONFIG_VIDEO_FIXED_MINOR_RANGES=y
>> CONFIG_V4L2_MEM2MEM_DEV=y
>> CONFIG_VIDEOBUF_GEN=y
>> CONFIG_VIDEOBUF_DMA_CONTIG=y
>> CONFIG_VIDEOBUF2_CORE=y
>> CONFIG_VIDEOBUF2_MEMOPS=y
>> CONFIG_VIDEOBUF2_DMA_CONTIG=m
>> CONFIG_VIDEOBUF2_VMALLOC=y
>> # CONFIG_VIDEO_V4L2_INT_DEVICE is not set
>> # CONFIG_TTPCI_EEPROM is not set
>>
>> #
>> # Media drivers
>> #
>> CONFIG_RC_CORE=y
>> CONFIG_RC_MAP=m
>> CONFIG_RC_DECODERS=y
>> CONFIG_LIRC=m
>> # CONFIG_IR_LIRC_CODEC is not set
>> CONFIG_IR_NEC_DECODER=m
>> CONFIG_IR_RC5_DECODER=m
>> # CONFIG_IR_RC6_DECODER is not set
>> CONFIG_IR_JVC_DECODER=m
>> # CONFIG_IR_SONY_DECODER is not set
>> CONFIG_IR_RC5_SZ_DECODER=m
>> # CONFIG_IR_SANYO_DECODER is not set
>> # CONFIG_IR_MCE_KBD_DECODER is not set
>> CONFIG_RC_DEVICES=y
>> CONFIG_RC_ATI_REMOTE=m
>> # CONFIG_IR_ENE is not set
>> # CONFIG_IR_IMON is not set
>> CONFIG_IR_MCEUSB=m
>> # CONFIG_IR_ITE_CIR is not set
>> # CONFIG_IR_FINTEK is not set
>> # CONFIG_IR_NUVOTON is not set
>> CONFIG_IR_REDRAT3=m
>> CONFIG_IR_STREAMZAP=m
>> # CONFIG_IR_WINBOND_CIR is not set
>> CONFIG_IR_IGUANA=m
>> # CONFIG_IR_TTUSBIR is not set
>> # CONFIG_RC_LOOPBACK is not set
>> CONFIG_IR_GPIO_CIR=m
>> # CONFIG_MEDIA_USB_SUPPORT is not set
>> CONFIG_MEDIA_PCI_SUPPORT=y
>>
>> #
>> # Media capture support
>> #
>> CONFIG_V4L_PLATFORM_DRIVERS=y
>> CONFIG_VIDEO_CAFE_CCIC=m
>> CONFIG_VIDEO_TIMBERDALE=y
>> CONFIG_SOC_CAMERA=m
>> CONFIG_SOC_CAMERA_PLATFORM=m
>> # CONFIG_V4L_MEM2MEM_DRIVERS is not set
>> CONFIG_V4L_TEST_DRIVERS=y
>> CONFIG_VIDEO_MEM2MEM_TESTDEV=y
>>
>> #
>> # Supported MMC/SDIO adapters
>> #
>> # CONFIG_MEDIA_PARPORT_SUPPORT is not set
>>
>> #
>> # Media ancillary drivers (tuners, sensors, i2c, frontends)
>> #
>> CONFIG_MEDIA_SUBDRV_AUTOSELECT=y
>> CONFIG_VIDEO_IR_I2C=y
>>
>> #
>> # Audio decoders, processors and mixers
>> #
>>
>> #
>> # RDS decoders
>> #
>>
>> #
>> # Video decoders
>> #
>> CONFIG_VIDEO_ADV7180=y
>>
>> #
>> # Video and audio decoders
>> #
>>
>> #
>> # Video encoders
>> #
>>
>> #
>> # Camera sensor devices
>> #
>> CONFIG_VIDEO_OV7670=m
>>
>> #
>> # Flash devices
>> #
>>
>> #
>> # Video improvement chips
>> #
>>
>> #
>> # Miscelaneous helper chips
>> #
>>
>> #
>> # Sensors used on soc_camera driver
>> #
>>
>> #
>> # soc_camera sensor drivers
>> #
>> CONFIG_SOC_CAMERA_IMX074=m
>> CONFIG_SOC_CAMERA_MT9M001=m
>> CONFIG_SOC_CAMERA_MT9M111=m
>> CONFIG_SOC_CAMERA_MT9T031=m
>> # CONFIG_SOC_CAMERA_MT9T112 is not set
>> # CONFIG_SOC_CAMERA_MT9V022 is not set
>> CONFIG_SOC_CAMERA_OV2640=m
>> # CONFIG_SOC_CAMERA_OV5642 is not set
>> # CONFIG_SOC_CAMERA_OV6650 is not set
>> # CONFIG_SOC_CAMERA_OV772X is not set
>> CONFIG_SOC_CAMERA_OV9640=m
>> CONFIG_SOC_CAMERA_OV9740=m
>> CONFIG_SOC_CAMERA_RJ54N1=m
>> CONFIG_SOC_CAMERA_TW9910=m
>>
>> #
>> # Tools to develop new frontends
>> #
>> # CONFIG_DVB_DUMMY_FE is not set
>>
>> #
>> # Graphics support
>> #
>> CONFIG_AGP=m
>> CONFIG_AGP_AMD64=m
>> CONFIG_AGP_INTEL=m
>> # CONFIG_AGP_SIS is not set
>> CONFIG_AGP_VIA=m
>> CONFIG_VGA_ARB=y
>> CONFIG_VGA_ARB_MAX_GPUS=16
>> # CONFIG_VGA_SWITCHEROO is not set
>> # CONFIG_DRM is not set
>> # CONFIG_VGASTATE is not set
>> CONFIG_VIDEO_OUTPUT_CONTROL=m
>> # CONFIG_FB is not set
>> # CONFIG_EXYNOS_VIDEO is not set
>> CONFIG_BACKLIGHT_LCD_SUPPORT=y
>> CONFIG_LCD_CLASS_DEVICE=y
>> CONFIG_LCD_PLATFORM=y
>> CONFIG_BACKLIGHT_CLASS_DEVICE=m
>> CONFIG_BACKLIGHT_GENERIC=m
>> CONFIG_BACKLIGHT_LM3533=m
>> CONFIG_BACKLIGHT_PWM=m
>> # CONFIG_BACKLIGHT_APPLE is not set
>> # CONFIG_BACKLIGHT_SAHARA is not set
>> # CONFIG_BACKLIGHT_WM831X is not set
>> CONFIG_BACKLIGHT_ADP5520=m
>> CONFIG_BACKLIGHT_ADP8860=m
>> # CONFIG_BACKLIGHT_ADP8870 is not set
>> CONFIG_BACKLIGHT_PCF50633=m
>> CONFIG_BACKLIGHT_LM3630=m
>> CONFIG_BACKLIGHT_LM3639=m
>> CONFIG_BACKLIGHT_LP855X=m
>> CONFIG_BACKLIGHT_TPS65217=m
>> CONFIG_BACKLIGHT_AS3711=m
>> CONFIG_SOUND=y
>> CONFIG_SOUND_OSS_CORE=y
>> # CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
>> CONFIG_SND=y
>> CONFIG_SND_TIMER=y
>> CONFIG_SND_PCM=y
>> CONFIG_SND_HWDEP=y
>> CONFIG_SND_RAWMIDI=y
>> CONFIG_SND_JACK=y
>> CONFIG_SND_SEQUENCER=y
>> # CONFIG_SND_SEQ_DUMMY is not set
>> CONFIG_SND_OSSEMUL=y
>> # CONFIG_SND_MIXER_OSS is not set
>> CONFIG_SND_PCM_OSS=y
>> # CONFIG_SND_PCM_OSS_PLUGINS is not set
>> # CONFIG_SND_SEQUENCER_OSS is not set
>> # CONFIG_SND_DYNAMIC_MINORS is not set
>> CONFIG_SND_SUPPORT_OLD_API=y
>> # CONFIG_SND_VERBOSE_PROCFS is not set
>> # CONFIG_SND_VERBOSE_PRINTK is not set
>> # CONFIG_SND_DEBUG is not set
>> CONFIG_SND_VMASTER=y
>> CONFIG_SND_KCTL_JACK=y
>> CONFIG_SND_DMA_SGBUF=y
>> CONFIG_SND_RAWMIDI_SEQ=y
>> CONFIG_SND_OPL3_LIB_SEQ=y
>> # CONFIG_SND_OPL4_LIB_SEQ is not set
>> # CONFIG_SND_SBAWE_SEQ is not set
>> # CONFIG_SND_EMU10K1_SEQ is not set
>> CONFIG_SND_MPU401_UART=y
>> CONFIG_SND_OPL3_LIB=y
>> CONFIG_SND_VX_LIB=m
>> CONFIG_SND_AC97_CODEC=y
>> # CONFIG_SND_DRIVERS is not set
>> CONFIG_SND_TEA575X=y
>> CONFIG_SND_PCI=y
>> CONFIG_SND_AD1889=y
>> # CONFIG_SND_ALS300 is not set
>> CONFIG_SND_ALI5451=y
>> CONFIG_SND_ASIHPI=y
>> CONFIG_SND_ATIIXP=m
>> CONFIG_SND_ATIIXP_MODEM=m
>> CONFIG_SND_AU8810=m
>> CONFIG_SND_AU8820=m
>> # CONFIG_SND_AU8830 is not set
>> CONFIG_SND_AW2=y
>> CONFIG_SND_AZT3328=y
>> CONFIG_SND_BT87X=m
>> CONFIG_SND_BT87X_OVERCLOCK=y
>> # CONFIG_SND_CA0106 is not set
>> # CONFIG_SND_CMIPCI is not set
>> CONFIG_SND_OXYGEN_LIB=m
>> CONFIG_SND_OXYGEN=m
>> # CONFIG_SND_CS4281 is not set
>> CONFIG_SND_CS46XX=y
>> CONFIG_SND_CS46XX_NEW_DSP=y
>> CONFIG_SND_CS5535AUDIO=y
>> CONFIG_SND_CTXFI=y
>> CONFIG_SND_DARLA20=m
>> # CONFIG_SND_GINA20 is not set
>> # CONFIG_SND_LAYLA20 is not set
>> CONFIG_SND_DARLA24=m
>> CONFIG_SND_GINA24=m
>> # CONFIG_SND_LAYLA24 is not set
>> # CONFIG_SND_MONA is not set
>> CONFIG_SND_MIA=y
>> CONFIG_SND_ECHO3G=m
>> CONFIG_SND_INDIGO=m
>> CONFIG_SND_INDIGOIO=m
>> CONFIG_SND_INDIGODJ=y
>> # CONFIG_SND_INDIGOIOX is not set
>> # CONFIG_SND_INDIGODJX is not set
>> # CONFIG_SND_EMU10K1 is not set
>> # CONFIG_SND_EMU10K1X is not set
>> CONFIG_SND_ENS1370=m
>> # CONFIG_SND_ENS1371 is not set
>> CONFIG_SND_ES1938=m
>> CONFIG_SND_ES1968=y
>> # CONFIG_SND_ES1968_INPUT is not set
>> CONFIG_SND_ES1968_RADIO=y
>> CONFIG_SND_FM801=y
>> CONFIG_SND_FM801_TEA575X_BOOL=y
>> CONFIG_SND_HDA_INTEL=m
>> CONFIG_SND_HDA_PREALLOC_SIZE=64
>> # CONFIG_SND_HDA_HWDEP is not set
>> CONFIG_SND_HDA_INPUT_BEEP=y
>> CONFIG_SND_HDA_INPUT_BEEP_MODE=1
>> # CONFIG_SND_HDA_INPUT_JACK is not set
>> # CONFIG_SND_HDA_PATCH_LOADER is not set
>> # CONFIG_SND_HDA_CODEC_REALTEK is not set
>> CONFIG_SND_HDA_CODEC_ANALOG=y
>> CONFIG_SND_HDA_CODEC_SIGMATEL=y
>> # CONFIG_SND_HDA_CODEC_VIA is not set
>> # CONFIG_SND_HDA_CODEC_HDMI is not set
>> CONFIG_SND_HDA_CODEC_CIRRUS=y
>> CONFIG_SND_HDA_CODEC_CONEXANT=y
>> CONFIG_SND_HDA_CODEC_CA0110=y
>> CONFIG_SND_HDA_CODEC_CA0132=y
>> # CONFIG_SND_HDA_CODEC_CA0132_DSP is not set
>> # CONFIG_SND_HDA_CODEC_CMEDIA is not set
>> # CONFIG_SND_HDA_CODEC_SI3054 is not set
>> CONFIG_SND_HDA_GENERIC=y
>> CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
>> CONFIG_SND_HDSP=m
>> CONFIG_SND_HDSPM=m
>> CONFIG_SND_ICE1712=y
>> # CONFIG_SND_ICE1724 is not set
>> # CONFIG_SND_INTEL8X0 is not set
>> # CONFIG_SND_INTEL8X0M is not set
>> CONFIG_SND_KORG1212=m
>> CONFIG_SND_LOLA=m
>> CONFIG_SND_LX6464ES=y
>> CONFIG_SND_MAESTRO3=y
>> # CONFIG_SND_MAESTRO3_INPUT is not set
>> # CONFIG_SND_MIXART is not set
>> # CONFIG_SND_NM256 is not set
>> CONFIG_SND_PCXHR=y
>> # CONFIG_SND_RIPTIDE is not set
>> CONFIG_SND_RME32=m
>> CONFIG_SND_RME96=m
>> CONFIG_SND_RME9652=y
>> # CONFIG_SND_SONICVIBES is not set
>> # CONFIG_SND_TRIDENT is not set
>> # CONFIG_SND_VIA82XX is not set
>> # CONFIG_SND_VIA82XX_MODEM is not set
>> CONFIG_SND_VIRTUOSO=m
>> CONFIG_SND_VX222=m
>> CONFIG_SND_YMFPCI=m
>> CONFIG_SND_USB=y
>> CONFIG_SND_USB_AUDIO=m
>> CONFIG_SND_USB_UA101=m
>> # CONFIG_SND_USB_USX2Y is not set
>> CONFIG_SND_USB_CAIAQ=m
>> # CONFIG_SND_USB_CAIAQ_INPUT is not set
>> CONFIG_SND_USB_US122L=m
>> CONFIG_SND_USB_6FIRE=m
>> # CONFIG_SND_SOC is not set
>> CONFIG_SOUND_PRIME=m
>> CONFIG_AC97_BUS=y
>>
>> #
>> # HID support
>> #
>> CONFIG_HID=m
>> CONFIG_HIDRAW=y
>> # CONFIG_UHID is not set
>> CONFIG_HID_GENERIC=m
>>
>> #
>> # Special HID drivers
>> #
>> CONFIG_HID_APPLE=m
>> CONFIG_HID_ELECOM=m
>> CONFIG_HID_ICADE=m
>> CONFIG_HID_MAGICMOUSE=m
>> # CONFIG_HID_PS3REMOTE is not set
>> # CONFIG_HID_TIVO is not set
>> # CONFIG_HID_WACOM is not set
>> CONFIG_HID_WIIMOTE=m
>> CONFIG_HID_WIIMOTE_EXT=y
>>
>> #
>> # USB HID support
>> #
>> # CONFIG_USB_HID is not set
>> CONFIG_HID_PID=y
>>
>> #
>> # USB HID Boot Protocol drivers
>> #
>> CONFIG_USB_KBD=m
>> CONFIG_USB_MOUSE=m
>>
>> #
>> # I2C HID support
>> #
>> CONFIG_I2C_HID=m
>> CONFIG_USB_ARCH_HAS_OHCI=y
>> CONFIG_USB_ARCH_HAS_EHCI=y
>> CONFIG_USB_ARCH_HAS_XHCI=y
>> CONFIG_USB_SUPPORT=y
>> CONFIG_USB_COMMON=m
>> CONFIG_USB_ARCH_HAS_HCD=y
>> CONFIG_USB=m
>> CONFIG_USB_DEBUG=y
>> # CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set
>>
>> #
>> # Miscellaneous USB options
>> #
>> CONFIG_USB_DYNAMIC_MINORS=y
>> # CONFIG_USB_SUSPEND is not set
>> CONFIG_USB_OTG_WHITELIST=y
>> # CONFIG_USB_OTG_BLACKLIST_HUB is not set
>> CONFIG_USB_DWC3=m
>> CONFIG_USB_DWC3_HOST=y
>> CONFIG_USB_DWC3_DEBUG=y
>> # CONFIG_USB_DWC3_VERBOSE is not set
>> CONFIG_USB_MON=m
>> CONFIG_USB_WUSB=m
>> CONFIG_USB_WUSB_CBAF=m
>> CONFIG_USB_WUSB_CBAF_DEBUG=y
>>
>> #
>> # USB Host Controller Drivers
>> #
>> CONFIG_USB_C67X00_HCD=m
>> CONFIG_USB_XHCI_HCD=m
>> CONFIG_USB_XHCI_PLATFORM=m
>> # CONFIG_USB_XHCI_HCD_DEBUGGING is not set
>> CONFIG_USB_EHCI_HCD=m
>> CONFIG_USB_EHCI_ROOT_HUB_TT=y
>> CONFIG_USB_EHCI_TT_NEWSCHED=y
>> CONFIG_USB_EHCI_PCI=m
>> CONFIG_USB_OXU210HP_HCD=m
>> # CONFIG_USB_ISP116X_HCD is not set
>> CONFIG_USB_ISP1760_HCD=m
>> CONFIG_USB_ISP1362_HCD=m
>> CONFIG_USB_OHCI_HCD=m
>> # CONFIG_USB_OHCI_HCD_SSB is not set
>> CONFIG_USB_OHCI_HCD_PLATFORM=y
>> CONFIG_USB_EHCI_HCD_PLATFORM=m
>> # CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
>> # CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
>> CONFIG_USB_OHCI_LITTLE_ENDIAN=y
>> # CONFIG_USB_UHCI_HCD is not set
>> CONFIG_USB_U132_HCD=m
>> # CONFIG_USB_SL811_HCD is not set
>> CONFIG_USB_R8A66597_HCD=m
>> CONFIG_USB_WHCI_HCD=m
>> # CONFIG_USB_HWA_HCD is not set
>> CONFIG_USB_HCD_SSB=m
>> CONFIG_USB_CHIPIDEA=m
>> # CONFIG_USB_CHIPIDEA_HOST is not set
>> # CONFIG_USB_CHIPIDEA_DEBUG is not set
>>
>> #
>> # USB Device Class drivers
>> #
>> CONFIG_USB_PRINTER=m
>> CONFIG_USB_WDM=m
>> # CONFIG_USB_TMC is not set
>>
>> #
>> # NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
>> #
>>
>> #
>> # also be needed; see USB_STORAGE Help for more info
>> #
>>
>> #
>> # USB Imaging devices
>> #
>> # CONFIG_USB_MDC800 is not set
>>
>> #
>> # USB port drivers
>> #
>> CONFIG_USB_USS720=m
>>
>> #
>> # USB Miscellaneous drivers
>> #
>> CONFIG_USB_EMI62=m
>> CONFIG_USB_EMI26=m
>> CONFIG_USB_ADUTUX=m
>> CONFIG_USB_SEVSEG=m
>> CONFIG_USB_RIO500=m
>> CONFIG_USB_LEGOTOWER=m
>> CONFIG_USB_LCD=m
>> CONFIG_USB_LED=m
>> # CONFIG_USB_CYPRESS_CY7C63 is not set
>> CONFIG_USB_CYTHERM=m
>> CONFIG_USB_IDMOUSE=m
>> CONFIG_USB_FTDI_ELAN=m
>> CONFIG_USB_APPLEDISPLAY=m
>> # CONFIG_USB_SISUSBVGA is not set
>> CONFIG_USB_LD=m
>> # CONFIG_USB_TRANCEVIBRATOR is not set
>> CONFIG_USB_IOWARRIOR=m
>> # CONFIG_USB_TEST is not set
>> # CONFIG_USB_ISIGHTFW is not set
>> # CONFIG_USB_YUREX is not set
>> # CONFIG_USB_EZUSB_FX2 is not set
>> CONFIG_USB_HSIC_USB3503=m
>>
>> #
>> # USB Physical Layer drivers
>> #
>> # CONFIG_OMAP_USB3 is not set
>> # CONFIG_OMAP_CONTROL_USB is not set
>> # CONFIG_USB_ISP1301 is not set
>> # CONFIG_USB_RCAR_PHY is not set
>> CONFIG_USB_ATM=m
>> # CONFIG_USB_SPEEDTOUCH is not set
>> # CONFIG_USB_CXACRU is not set
>> # CONFIG_USB_UEAGLEATM is not set
>> CONFIG_USB_XUSBATM=m
>> # CONFIG_USB_GADGET is not set
>>
>> #
>> # OTG and related infrastructure
>> #
>> CONFIG_USB_OTG_UTILS=y
>> # CONFIG_NOP_USB_XCEIV is not set
>> CONFIG_UWB=y
>> CONFIG_UWB_HWA=m
>> CONFIG_UWB_WHCI=m
>> CONFIG_UWB_I1480U=m
>> # CONFIG_MMC is not set
>> CONFIG_MEMSTICK=y
>> # CONFIG_MEMSTICK_DEBUG is not set
>>
>> #
>> # MemoryStick drivers
>> #
>> # CONFIG_MEMSTICK_UNSAFE_RESUME is not set
>>
>> #
>> # MemoryStick Host Controller Drivers
>> #
>> # CONFIG_MEMSTICK_TIFM_MS is not set
>> CONFIG_MEMSTICK_JMICRON_38X=y
>> CONFIG_MEMSTICK_R592=m
>> # CONFIG_MEMSTICK_REALTEK_PCI is not set
>> CONFIG_NEW_LEDS=y
>> CONFIG_LEDS_CLASS=y
>>
>> #
>> # LED drivers
>> #
>> # CONFIG_LEDS_LM3530 is not set
>> CONFIG_LEDS_LM3533=m
>> CONFIG_LEDS_LM3642=m
>> CONFIG_LEDS_PCA9532=m
>> # CONFIG_LEDS_LP3944 is not set
>> CONFIG_LEDS_LP55XX_COMMON=y
>> CONFIG_LEDS_LP5521=y
>> # CONFIG_LEDS_LP5523 is not set
>> # CONFIG_LEDS_CLEVO_MAIL is not set
>> # CONFIG_LEDS_PCA955X is not set
>> # CONFIG_LEDS_PCA9633 is not set
>> CONFIG_LEDS_WM831X_STATUS=m
>> CONFIG_LEDS_WM8350=m
>> CONFIG_LEDS_PWM=y
>> # CONFIG_LEDS_BD2802 is not set
>> # CONFIG_LEDS_INTEL_SS4200 is not set
>> CONFIG_LEDS_ADP5520=m
>> # CONFIG_LEDS_TCA6507 is not set
>> # CONFIG_LEDS_LM355x is not set
>> # CONFIG_LEDS_OT200 is not set
>> # CONFIG_LEDS_BLINKM is not set
>> CONFIG_LEDS_TRIGGERS=y
>>
>> #
>> # LED Triggers
>> #
>> CONFIG_LEDS_TRIGGER_TIMER=y
>> CONFIG_LEDS_TRIGGER_ONESHOT=m
>> # CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
>> # CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
>> # CONFIG_LEDS_TRIGGER_CPU is not set
>> CONFIG_LEDS_TRIGGER_DEFAULT_ON=m
>>
>> #
>> # iptables trigger is under Netfilter config (LED target)
>> #
>> CONFIG_LEDS_TRIGGER_TRANSIENT=y
>> CONFIG_ACCESSIBILITY=y
>> # CONFIG_INFINIBAND is not set
>> # CONFIG_EDAC is not set
>> CONFIG_RTC_LIB=y
>> CONFIG_RTC_CLASS=y
>> # CONFIG_RTC_DEBUG is not set
>>
>> #
>> # RTC interfaces
>> #
>> CONFIG_RTC_INTF_SYSFS=y
>> # CONFIG_RTC_INTF_PROC is not set
>> # CONFIG_RTC_INTF_DEV is not set
>> CONFIG_RTC_DRV_TEST=y
>>
>> #
>> # I2C RTC drivers
>> #
>> CONFIG_RTC_DRV_88PM80X=m
>> CONFIG_RTC_DRV_DS1307=y
>> # CONFIG_RTC_DRV_DS1374 is not set
>> CONFIG_RTC_DRV_DS1672=m
>> # CONFIG_RTC_DRV_DS3232 is not set
>> CONFIG_RTC_DRV_MAX6900=m
>> CONFIG_RTC_DRV_MAX8907=m
>> CONFIG_RTC_DRV_RS5C372=m
>> CONFIG_RTC_DRV_ISL1208=m
>> CONFIG_RTC_DRV_ISL12022=m
>> CONFIG_RTC_DRV_X1205=m
>> CONFIG_RTC_DRV_PCF8523=y
>> # CONFIG_RTC_DRV_PCF8563 is not set
>> CONFIG_RTC_DRV_PCF8583=m
>> CONFIG_RTC_DRV_M41T80=y
>> # CONFIG_RTC_DRV_M41T80_WDT is not set
>> CONFIG_RTC_DRV_BQ32K=m
>> CONFIG_RTC_DRV_TPS6586X=y
>> CONFIG_RTC_DRV_TPS80031=y
>> CONFIG_RTC_DRV_S35390A=y
>> CONFIG_RTC_DRV_FM3130=m
>> CONFIG_RTC_DRV_RX8581=y
>> CONFIG_RTC_DRV_RX8025=y
>> CONFIG_RTC_DRV_EM3027=y
>> # CONFIG_RTC_DRV_RV3029C2 is not set
>>
>> #
>> # SPI RTC drivers
>> #
>>
>> #
>> # Platform RTC drivers
>> #
>> CONFIG_RTC_DRV_CMOS=y
>> CONFIG_RTC_DRV_DS1286=m
>> CONFIG_RTC_DRV_DS1511=m
>> CONFIG_RTC_DRV_DS1553=m
>> # CONFIG_RTC_DRV_DS1742 is not set
>> CONFIG_RTC_DRV_DA9055=m
>> CONFIG_RTC_DRV_STK17TA8=m
>> CONFIG_RTC_DRV_M48T86=y
>> CONFIG_RTC_DRV_M48T35=m
>> CONFIG_RTC_DRV_M48T59=y
>> CONFIG_RTC_DRV_MSM6242=y
>> CONFIG_RTC_DRV_BQ4802=y
>> # CONFIG_RTC_DRV_RP5C01 is not set
>> CONFIG_RTC_DRV_V3020=y
>> CONFIG_RTC_DRV_DS2404=m
>> CONFIG_RTC_DRV_WM831X=y
>> CONFIG_RTC_DRV_WM8350=m
>> # CONFIG_RTC_DRV_PCF50633 is not set
>>
>> #
>> # on-CPU RTC drivers
>> #
>>
>> #
>> # HID Sensor RTC drivers
>> #
>> CONFIG_DMADEVICES=y
>> CONFIG_DMADEVICES_DEBUG=y
>> # CONFIG_DMADEVICES_VDEBUG is not set
>>
>> #
>> # DMA Devices
>> #
>> # CONFIG_INTEL_MID_DMAC is not set
>> # CONFIG_INTEL_IOATDMA is not set
>> CONFIG_DW_DMAC=y
>> # CONFIG_DW_DMAC_BIG_ENDIAN_IO is not set
>> CONFIG_TIMB_DMA=y
>> CONFIG_PCH_DMA=y
>> CONFIG_DMA_ENGINE=y
>>
>> #
>> # DMA Clients
>> #
>> CONFIG_NET_DMA=y
>> CONFIG_ASYNC_TX_DMA=y
>> CONFIG_DMATEST=y
>> CONFIG_AUXDISPLAY=y
>> # CONFIG_KS0108 is not set
>> CONFIG_UIO=m
>> CONFIG_UIO_CIF=m
>> # CONFIG_UIO_PDRV is not set
>> CONFIG_UIO_PDRV_GENIRQ=m
>> # CONFIG_UIO_DMEM_GENIRQ is not set
>> CONFIG_UIO_AEC=m
>> CONFIG_UIO_SERCOS3=m
>> CONFIG_UIO_PCI_GENERIC=m
>> # CONFIG_UIO_NETX is not set
>> CONFIG_VIRTIO=y
>>
>> #
>> # Virtio drivers
>> #
>> # CONFIG_VIRTIO_PCI is not set
>> CONFIG_VIRTIO_BALLOON=y
>> CONFIG_VIRTIO_MMIO=y
>> # CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set
>>
>> #
>> # Microsoft Hyper-V guest support
>> #
>> # CONFIG_HYPERV is not set
>> CONFIG_STAGING=y
>> CONFIG_ET131X=y
>> # CONFIG_SLICOSS is not set
>> # CONFIG_USBIP_CORE is not set
>> CONFIG_W35UND=m
>> # CONFIG_PRISM2_USB is not set
>> CONFIG_ECHO=m
>> CONFIG_COMEDI=m
>> # CONFIG_COMEDI_DEBUG is not set
>> CONFIG_COMEDI_DEFAULT_BUF_SIZE_KB=2048
>> CONFIG_COMEDI_DEFAULT_BUF_MAXSIZE_KB=20480
>> CONFIG_COMEDI_MISC_DRIVERS=y
>> CONFIG_COMEDI_KCOMEDILIB=m
>> CONFIG_COMEDI_BOND=m
>> # CONFIG_COMEDI_TEST is not set
>> # CONFIG_COMEDI_PARPORT is not set
>> # CONFIG_COMEDI_SERIAL2002 is not set
>> CONFIG_COMEDI_SKEL=m
>> CONFIG_COMEDI_PCI_DRIVERS=y
>> CONFIG_COMEDI_8255_PCI=m
>> CONFIG_COMEDI_ADDI_WATCHDOG=m
>> CONFIG_COMEDI_ADDI_APCI_035=m
>> CONFIG_COMEDI_ADDI_APCI_1032=m
>> # CONFIG_COMEDI_ADDI_APCI_1500 is not set
>> # CONFIG_COMEDI_ADDI_APCI_1516 is not set
>> CONFIG_COMEDI_ADDI_APCI_1564=m
>> CONFIG_COMEDI_ADDI_APCI_16XX=m
>> CONFIG_COMEDI_ADDI_APCI_2032=m
>> CONFIG_COMEDI_ADDI_APCI_2200=m
>> CONFIG_COMEDI_ADDI_APCI_3120=m
>> # CONFIG_COMEDI_ADDI_APCI_3501 is not set
>> CONFIG_COMEDI_ADDI_APCI_3XXX=m
>> CONFIG_COMEDI_ADL_PCI6208=m
>> # CONFIG_COMEDI_ADL_PCI7X3X is not set
>> CONFIG_COMEDI_ADL_PCI8164=m
>> # CONFIG_COMEDI_ADL_PCI9111 is not set
>> # CONFIG_COMEDI_ADL_PCI9118 is not set
>> CONFIG_COMEDI_ADV_PCI1710=m
>> CONFIG_COMEDI_ADV_PCI1723=m
>> CONFIG_COMEDI_ADV_PCI_DIO=m
>> CONFIG_COMEDI_AMPLC_DIO200_PCI=m
>> CONFIG_COMEDI_AMPLC_PC236_PCI=m
>> # CONFIG_COMEDI_AMPLC_PC263_PCI is not set
>> CONFIG_COMEDI_AMPLC_PCI224=m
>> CONFIG_COMEDI_AMPLC_PCI230=m
>> CONFIG_COMEDI_CONTEC_PCI_DIO=m
>> # CONFIG_COMEDI_DAS08_PCI is not set
>> # CONFIG_COMEDI_DT3000 is not set
>> # CONFIG_COMEDI_DYNA_PCI10XX is not set
>> CONFIG_COMEDI_UNIOXX5=m
>> CONFIG_COMEDI_GSC_HPDI=m
>> CONFIG_COMEDI_ICP_MULTI=m
>> CONFIG_COMEDI_II_PCI20KC=m
>> # CONFIG_COMEDI_DAQBOARD2000 is not set
>> CONFIG_COMEDI_JR3_PCI=m
>> # CONFIG_COMEDI_KE_COUNTER is not set
>> CONFIG_COMEDI_CB_PCIDAS64=m
>> CONFIG_COMEDI_CB_PCIDAS=m
>> CONFIG_COMEDI_CB_PCIDDA=m
>> CONFIG_COMEDI_CB_PCIMDAS=m
>> CONFIG_COMEDI_CB_PCIMDDA=m
>> CONFIG_COMEDI_ME4000=m
>> CONFIG_COMEDI_ME_DAQ=m
>> CONFIG_COMEDI_NI_6527=m
>> # CONFIG_COMEDI_NI_65XX is not set
>> CONFIG_COMEDI_NI_660X=m
>> # CONFIG_COMEDI_NI_670X is not set
>> # CONFIG_COMEDI_NI_LABPC is not set
>> CONFIG_COMEDI_NI_PCIDIO=m
>> CONFIG_COMEDI_NI_PCIMIO=m
>> CONFIG_COMEDI_RTD520=m
>> CONFIG_COMEDI_S526=m
>> CONFIG_COMEDI_S626=m
>> # CONFIG_COMEDI_SSV_DNP is not set
>> CONFIG_COMEDI_MITE=m
>> CONFIG_COMEDI_NI_TIOCMD=m
>> # CONFIG_COMEDI_USB_DRIVERS is not set
>> CONFIG_COMEDI_8255=m
>> CONFIG_COMEDI_FC=m
>> CONFIG_COMEDI_AMPLC_DIO200=m
>> CONFIG_COMEDI_AMPLC_PC236=m
>> CONFIG_COMEDI_NI_TIO=m
>> CONFIG_ASUS_OLED=m
>> CONFIG_PANEL=m
>> CONFIG_PANEL_PARPORT=0
>> CONFIG_PANEL_PROFILE=5
>> # CONFIG_PANEL_CHANGE_MESSAGE is not set
>> # CONFIG_R8187SE is not set
>> CONFIG_RTL8192U=m
>> # CONFIG_RTLLIB is not set
>> # CONFIG_R8712U is not set
>> CONFIG_TRANZPORT=m
>> CONFIG_LINE6_USB=m
>> CONFIG_LINE6_USB_IMPULSE_RESPONSE=y
>> CONFIG_VT6655=m
>> # CONFIG_VT6656 is not set
>> CONFIG_DX_SEP=m
>> # CONFIG_ZSMALLOC is not set
>> CONFIG_CRYSTALHD=y
>> # CONFIG_ACPI_QUICKSTART is not set
>> CONFIG_BCM_WIMAX=m
>> CONFIG_FT1000=m
>> CONFIG_FT1000_USB=m
>>
>> #
>> # Speakup console speech
>> #
>> CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=m
>> # CONFIG_STAGING_MEDIA is not set
>>
>> #
>> # Android
>> #
>> # CONFIG_ANDROID is not set
>> CONFIG_USB_WPAN_HCD=m
>> CONFIG_WIMAX_GDM72XX=y
>> CONFIG_WIMAX_GDM72XX_QOS=y
>> CONFIG_WIMAX_GDM72XX_K_MODE=y
>> CONFIG_WIMAX_GDM72XX_WIMAX2=y
>> CONFIG_WIMAX_GDM72XX_USB=y
>> # CONFIG_NET_VENDOR_SILICOM is not set
>> CONFIG_CED1401=m
>> CONFIG_X86_PLATFORM_DEVICES=y
>> # CONFIG_ACERHDF is not set
>> # CONFIG_ASUS_LAPTOP is not set
>> CONFIG_CHROMEOS_LAPTOP=y
>> CONFIG_DELL_LAPTOP=m
>> # CONFIG_FUJITSU_LAPTOP is not set
>> # CONFIG_FUJITSU_TABLET is not set
>> # CONFIG_HP_ACCEL is not set
>> # CONFIG_PANASONIC_LAPTOP is not set
>> # CONFIG_THINKPAD_ACPI is not set
>> CONFIG_SENSORS_HDAPS=m
>> # CONFIG_INTEL_MENLOW is not set
>> # CONFIG_ACPI_WMI is not set
>> # CONFIG_TOPSTAR_LAPTOP is not set
>> # CONFIG_TOSHIBA_BT_RFKILL is not set
>> # CONFIG_ACPI_CMPC is not set
>> # CONFIG_INTEL_IPS is not set
>> CONFIG_IBM_RTL=m
>> # CONFIG_XO15_EBOOK is not set
>> # CONFIG_SAMSUNG_LAPTOP is not set
>> CONFIG_SAMSUNG_Q10=m
>> # CONFIG_APPLE_GMUX is not set
>>
>> #
>> # Hardware Spinlock drivers
>> #
>> CONFIG_CLKEVT_I8253=y
>> CONFIG_I8253_LOCK=y
>> CONFIG_CLKBLD_I8253=y
>> # CONFIG_MAILBOX is not set
>> # CONFIG_IOMMU_SUPPORT is not set
>>
>> #
>> # Remoteproc drivers
>> #
>> CONFIG_REMOTEPROC=y
>> CONFIG_STE_MODEM_RPROC=y
>>
>> #
>> # Rpmsg drivers
>> #
>> CONFIG_VIRT_DRIVERS=y
>> # CONFIG_PM_DEVFREQ is not set
>> CONFIG_EXTCON=y
>>
>> #
>> # Extcon Device Drivers
>> #
>> # CONFIG_MEMORY is not set
>> # CONFIG_IIO is not set
>> CONFIG_NTB=m
>> CONFIG_VME_BUS=y
>>
>> #
>> # VME Bridge Drivers
>> #
>> CONFIG_VME_CA91CX42=y
>> CONFIG_VME_TSI148=y
>>
>> #
>> # VME Board Drivers
>> #
>> CONFIG_VMIVME_7805=y
>>
>> #
>> # VME Device Drivers
>> #
>> CONFIG_VME_USER=m
>> CONFIG_PWM=y
>> CONFIG_IPACK_BUS=m
>> CONFIG_BOARD_TPCI200=m
>>
>> #
>> # Firmware Drivers
>> #
>> # CONFIG_EDD is not set
>> CONFIG_FIRMWARE_MEMMAP=y
>> CONFIG_DELL_RBU=y
>> CONFIG_DCDBAS=m
>> CONFIG_DMIID=y
>> CONFIG_DMI_SYSFS=y
>> # CONFIG_ISCSI_IBFT_FIND is not set
>> # CONFIG_GOOGLE_FIRMWARE is not set
>>
>> #
>> # File systems
>> #
>> CONFIG_DCACHE_WORD_ACCESS=y
>> # CONFIG_FS_POSIX_ACL is not set
>> CONFIG_EXPORTFS=y
>> # CONFIG_FILE_LOCKING is not set
>> CONFIG_FSNOTIFY=y
>> CONFIG_DNOTIFY=y
>> CONFIG_INOTIFY_USER=y
>> # CONFIG_FANOTIFY is not set
>> # CONFIG_QUOTA is not set
>> # CONFIG_QUOTACTL is not set
>> # CONFIG_AUTOFS4_FS is not set
>> # CONFIG_FUSE_FS is not set
>>
>> #
>> # Caches
>> #
>> CONFIG_FSCACHE=y
>> # CONFIG_FSCACHE_STATS is not set
>> CONFIG_FSCACHE_HISTOGRAM=y
>> # CONFIG_FSCACHE_DEBUG is not set
>> # CONFIG_FSCACHE_OBJECT_LIST is not set
>>
>> #
>> # Pseudo filesystems
>> #
>> CONFIG_PROC_FS=y
>> CONFIG_PROC_KCORE=y
>> # CONFIG_PROC_SYSCTL is not set
>> # CONFIG_PROC_PAGE_MONITOR is not set
>> CONFIG_SYSFS=y
>> CONFIG_HUGETLBFS=y
>> CONFIG_HUGETLB_PAGE=y
>> CONFIG_CONFIGFS_FS=m
>> CONFIG_MISC_FILESYSTEMS=y
>> # CONFIG_ECRYPT_FS is not set
>> CONFIG_PSTORE=y
>> # CONFIG_PSTORE_CONSOLE is not set
>> CONFIG_PSTORE_RAM=m
>> # CONFIG_NETWORK_FILESYSTEMS is not set
>> CONFIG_NLS=y
>> CONFIG_NLS_DEFAULT="iso8859-1"
>> CONFIG_NLS_CODEPAGE_437=y
>> CONFIG_NLS_CODEPAGE_737=y
>> CONFIG_NLS_CODEPAGE_775=y
>> CONFIG_NLS_CODEPAGE_850=y
>> CONFIG_NLS_CODEPAGE_852=y
>> # CONFIG_NLS_CODEPAGE_855 is not set
>> CONFIG_NLS_CODEPAGE_857=y
>> CONFIG_NLS_CODEPAGE_860=m
>> CONFIG_NLS_CODEPAGE_861=m
>> # CONFIG_NLS_CODEPAGE_862 is not set
>> CONFIG_NLS_CODEPAGE_863=m
>> CONFIG_NLS_CODEPAGE_864=y
>> CONFIG_NLS_CODEPAGE_865=y
>> CONFIG_NLS_CODEPAGE_866=m
>> CONFIG_NLS_CODEPAGE_869=y
>> CONFIG_NLS_CODEPAGE_936=y
>> CONFIG_NLS_CODEPAGE_950=y
>> CONFIG_NLS_CODEPAGE_932=m
>> CONFIG_NLS_CODEPAGE_949=y
>> CONFIG_NLS_CODEPAGE_874=y
>> # CONFIG_NLS_ISO8859_8 is not set
>> # CONFIG_NLS_CODEPAGE_1250 is not set
>> CONFIG_NLS_CODEPAGE_1251=y
>> # CONFIG_NLS_ASCII is not set
>> CONFIG_NLS_ISO8859_1=y
>> # CONFIG_NLS_ISO8859_2 is not set
>> CONFIG_NLS_ISO8859_3=y
>> CONFIG_NLS_ISO8859_4=y
>> CONFIG_NLS_ISO8859_5=y
>> CONFIG_NLS_ISO8859_6=y
>> CONFIG_NLS_ISO8859_7=y
>> # CONFIG_NLS_ISO8859_9 is not set
>> CONFIG_NLS_ISO8859_13=m
>> # CONFIG_NLS_ISO8859_14 is not set
>> CONFIG_NLS_ISO8859_15=m
>> # CONFIG_NLS_KOI8_R is not set
>> # CONFIG_NLS_KOI8_U is not set
>> # CONFIG_NLS_MAC_ROMAN is not set
>> # CONFIG_NLS_MAC_CELTIC is not set
>> CONFIG_NLS_MAC_CENTEURO=m
>> CONFIG_NLS_MAC_CROATIAN=y
>> # CONFIG_NLS_MAC_CYRILLIC is not set
>> # CONFIG_NLS_MAC_GAELIC is not set
>> CONFIG_NLS_MAC_GREEK=y
>> CONFIG_NLS_MAC_ICELAND=y
>> CONFIG_NLS_MAC_INUIT=m
>> CONFIG_NLS_MAC_ROMANIAN=m
>> # CONFIG_NLS_MAC_TURKISH is not set
>> CONFIG_NLS_UTF8=y
>>
>> #
>> # Kernel hacking
>> #
>> CONFIG_TRACE_IRQFLAGS_SUPPORT=y
>> CONFIG_PRINTK_TIME=y
>> CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
>> CONFIG_ENABLE_WARN_DEPRECATED=y
>> # CONFIG_ENABLE_MUST_CHECK is not set
>> CONFIG_FRAME_WARN=2048
>> CONFIG_MAGIC_SYSRQ=y
>> CONFIG_STRIP_ASM_SYMS=y
>> # CONFIG_READABLE_ASM is not set
>> CONFIG_UNUSED_SYMBOLS=y
>> CONFIG_DEBUG_FS=y
>> # CONFIG_HEADERS_CHECK is not set
>> # CONFIG_DEBUG_SECTION_MISMATCH is not set
>> CONFIG_DEBUG_KERNEL=y
>> CONFIG_DEBUG_SHIRQ=y
>> # CONFIG_LOCKUP_DETECTOR is not set
>> CONFIG_PANIC_ON_OOPS=y
>> CONFIG_PANIC_ON_OOPS_VALUE=1
>> # CONFIG_DETECT_HUNG_TASK is not set
>> # CONFIG_SCHED_DEBUG is not set
>> # CONFIG_SCHEDSTATS is not set
>> CONFIG_TIMER_STATS=y
>> # CONFIG_DEBUG_OBJECTS is not set
>> # CONFIG_SLUB_DEBUG_ON is not set
>> CONFIG_SLUB_STATS=y
>> CONFIG_HAVE_DEBUG_KMEMLEAK=y
>> # CONFIG_DEBUG_KMEMLEAK is not set
>> # CONFIG_DEBUG_PREEMPT is not set
>> # CONFIG_DEBUG_RT_MUTEXES is not set
>> # CONFIG_RT_MUTEX_TESTER is not set
>> CONFIG_DEBUG_SPINLOCK=y
>> CONFIG_DEBUG_MUTEXES=y
>> CONFIG_DEBUG_LOCK_ALLOC=y
>> CONFIG_PROVE_LOCKING=y
>> CONFIG_LOCKDEP=y
>> CONFIG_LOCK_STAT=y
>> # CONFIG_DEBUG_LOCKDEP is not set
>> CONFIG_TRACE_IRQFLAGS=y
>> CONFIG_DEBUG_ATOMIC_SLEEP=y
>> CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
>> CONFIG_STACKTRACE=y
>> # CONFIG_DEBUG_STACK_USAGE is not set
>> # CONFIG_DEBUG_KOBJECT is not set
>> # CONFIG_DEBUG_BUGVERBOSE is not set
>> # CONFIG_DEBUG_INFO is not set
>> CONFIG_DEBUG_VM=y
>> # CONFIG_DEBUG_VM_RB is not set
>> # CONFIG_DEBUG_VIRTUAL is not set
>> # CONFIG_DEBUG_WRITECOUNT is not set
>> CONFIG_DEBUG_MEMORY_INIT=y
>> # CONFIG_DEBUG_LIST is not set
>> CONFIG_TEST_LIST_SORT=y
>> CONFIG_DEBUG_SG=y
>> CONFIG_DEBUG_NOTIFIERS=y
>> # CONFIG_DEBUG_CREDENTIALS is not set
>> CONFIG_ARCH_WANT_FRAME_POINTERS=y
>> CONFIG_FRAME_POINTER=y
>> # CONFIG_BOOT_PRINTK_DELAY is not set
>>
>> #
>> # RCU Debugging
>> #
>> CONFIG_PROVE_RCU=y
>> CONFIG_PROVE_RCU_REPEATEDLY=y
>> # CONFIG_PROVE_RCU_DELAY is not set
>> CONFIG_SPARSE_RCU_POINTER=y
>> CONFIG_RCU_TORTURE_TEST=m
>> CONFIG_RCU_CPU_STALL_TIMEOUT=21
>> # CONFIG_RCU_CPU_STALL_VERBOSE is not set
>> # CONFIG_RCU_CPU_STALL_INFO is not set
>> # CONFIG_RCU_TRACE is not set
>> # CONFIG_BACKTRACE_SELF_TEST is not set
>> # CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
>> # CONFIG_NOTIFIER_ERROR_INJECTION is not set
>> CONFIG_FAULT_INJECTION=y
>> # CONFIG_FAILSLAB is not set
>> CONFIG_FAIL_PAGE_ALLOC=y
>> # CONFIG_FAULT_INJECTION_DEBUG_FS is not set
>> # CONFIG_LATENCYTOP is not set
>> # CONFIG_DEBUG_PAGEALLOC is not set
>> CONFIG_USER_STACKTRACE_SUPPORT=y
>> CONFIG_NOP_TRACER=y
>> CONFIG_HAVE_FUNCTION_TRACER=y
>> CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
>> CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
>> CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
>> CONFIG_HAVE_DYNAMIC_FTRACE=y
>> CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
>> CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
>> CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
>> CONFIG_HAVE_FENTRY=y
>> CONFIG_HAVE_C_RECORDMCOUNT=y
>> CONFIG_TRACE_CLOCK=y
>> CONFIG_RING_BUFFER=y
>> CONFIG_EVENT_TRACING=y
>> CONFIG_CONTEXT_SWITCH_TRACER=y
>> CONFIG_TRACING=y
>> CONFIG_GENERIC_TRACER=y
>> CONFIG_TRACING_SUPPORT=y
>> CONFIG_FTRACE=y
>> # CONFIG_FUNCTION_TRACER is not set
>> # CONFIG_IRQSOFF_TRACER is not set
>> # CONFIG_PREEMPT_TRACER is not set
>> # CONFIG_SCHED_TRACER is not set
>> # CONFIG_FTRACE_SYSCALLS is not set
>> # CONFIG_TRACER_SNAPSHOT is not set
>> CONFIG_BRANCH_PROFILE_NONE=y
>> # CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
>> # CONFIG_PROFILE_ALL_BRANCHES is not set
>> # CONFIG_STACK_TRACER is not set
>> # CONFIG_UPROBE_EVENT is not set
>> # CONFIG_PROBE_EVENTS is not set
>> # CONFIG_FTRACE_STARTUP_TEST is not set
>> CONFIG_MMIOTRACE=y
>> CONFIG_MMIOTRACE_TEST=m
>> CONFIG_RING_BUFFER_BENCHMARK=y
>> CONFIG_RBTREE_TEST=m
>> # CONFIG_INTERVAL_TREE_TEST is not set
>> CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
>> CONFIG_DYNAMIC_DEBUG=y
>> # CONFIG_DMA_API_DEBUG is not set
>> CONFIG_ATOMIC64_SELFTEST=y
>> # CONFIG_SAMPLES is not set
>> CONFIG_HAVE_ARCH_KGDB=y
>> # CONFIG_KGDB is not set
>> CONFIG_HAVE_ARCH_KMEMCHECK=y
>> # CONFIG_KMEMCHECK is not set
>> CONFIG_TEST_KSTRTOX=m
>> # CONFIG_STRICT_DEVMEM is not set
>> # CONFIG_X86_VERBOSE_BOOTUP is not set
>> # CONFIG_EARLY_PRINTK is not set
>> CONFIG_DEBUG_STACKOVERFLOW=y
>> # CONFIG_X86_PTDUMP is not set
>> # CONFIG_DEBUG_RODATA is not set
>> # CONFIG_DEBUG_SET_MODULE_RONX is not set
>> # CONFIG_DEBUG_NX_TEST is not set
>> # CONFIG_DEBUG_TLBFLUSH is not set
>> # CONFIG_IOMMU_STRESS is not set
>> CONFIG_HAVE_MMIOTRACE_SUPPORT=y
>> CONFIG_IO_DELAY_TYPE_0X80=0
>> CONFIG_IO_DELAY_TYPE_0XED=1
>> CONFIG_IO_DELAY_TYPE_UDELAY=2
>> CONFIG_IO_DELAY_TYPE_NONE=3
>> # CONFIG_IO_DELAY_0X80 is not set
>> # CONFIG_IO_DELAY_0XED is not set
>> CONFIG_IO_DELAY_UDELAY=y
>> # CONFIG_IO_DELAY_NONE is not set
>> CONFIG_DEFAULT_IO_DELAY_TYPE=2
>> CONFIG_DEBUG_BOOT_PARAMS=y
>> CONFIG_CPA_DEBUG=y
>> # CONFIG_OPTIMIZE_INLINING is not set
>> # CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
>> # CONFIG_DEBUG_NMI_SELFTEST is not set
>>
>> #
>> # Security options
>> #
>> CONFIG_KEYS=y
>> CONFIG_ENCRYPTED_KEYS=y
>> CONFIG_KEYS_DEBUG_PROC_KEYS=y
>> # CONFIG_SECURITY_DMESG_RESTRICT is not set
>> # CONFIG_SECURITY is not set
>> CONFIG_SECURITYFS=y
>> CONFIG_DEFAULT_SECURITY_DAC=y
>> CONFIG_DEFAULT_SECURITY=""
>> CONFIG_CRYPTO=y
>>
>> #
>> # Crypto core or helper
>> #
>> CONFIG_CRYPTO_ALGAPI=y
>> CONFIG_CRYPTO_ALGAPI2=y
>> CONFIG_CRYPTO_AEAD=y
>> CONFIG_CRYPTO_AEAD2=y
>> CONFIG_CRYPTO_BLKCIPHER=y
>> CONFIG_CRYPTO_BLKCIPHER2=y
>> CONFIG_CRYPTO_HASH=y
>> CONFIG_CRYPTO_HASH2=y
>> CONFIG_CRYPTO_RNG=y
>> CONFIG_CRYPTO_RNG2=y
>> CONFIG_CRYPTO_PCOMP2=y
>> CONFIG_CRYPTO_MANAGER=y
>> CONFIG_CRYPTO_MANAGER2=y
>> # CONFIG_CRYPTO_USER is not set
>> CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
>> CONFIG_CRYPTO_GF128MUL=y
>> CONFIG_CRYPTO_NULL=m
>> CONFIG_CRYPTO_WORKQUEUE=y
>> CONFIG_CRYPTO_CRYPTD=y
>> CONFIG_CRYPTO_AUTHENC=y
>> # CONFIG_CRYPTO_TEST is not set
>> CONFIG_CRYPTO_ABLK_HELPER_X86=y
>> CONFIG_CRYPTO_GLUE_HELPER_X86=y
>>
>> #
>> # Authenticated Encryption with Associated Data
>> #
>> CONFIG_CRYPTO_CCM=y
>> CONFIG_CRYPTO_GCM=m
>> CONFIG_CRYPTO_SEQIV=y
>>
>> #
>> # Block modes
>> #
>> CONFIG_CRYPTO_CBC=y
>> CONFIG_CRYPTO_CTR=y
>> CONFIG_CRYPTO_CTS=m
>> CONFIG_CRYPTO_ECB=y
>> CONFIG_CRYPTO_LRW=y
>> # CONFIG_CRYPTO_PCBC is not set
>> CONFIG_CRYPTO_XTS=y
>>
>> #
>> # Hash modes
>> #
>> CONFIG_CRYPTO_HMAC=y
>> CONFIG_CRYPTO_XCBC=y
>> CONFIG_CRYPTO_VMAC=m
>>
>> #
>> # Digest
>> #
>> CONFIG_CRYPTO_CRC32C=y
>> # CONFIG_CRYPTO_CRC32C_INTEL is not set
>> CONFIG_CRYPTO_CRC32=y
>> CONFIG_CRYPTO_CRC32_PCLMUL=y
>> CONFIG_CRYPTO_GHASH=m
>> CONFIG_CRYPTO_MD4=m
>> # CONFIG_CRYPTO_MD5 is not set
>> CONFIG_CRYPTO_MICHAEL_MIC=y
>> CONFIG_CRYPTO_RMD128=m
>> # CONFIG_CRYPTO_RMD160 is not set
>> CONFIG_CRYPTO_RMD256=m
>> # CONFIG_CRYPTO_RMD320 is not set
>> CONFIG_CRYPTO_SHA1=m
>> # CONFIG_CRYPTO_SHA1_SSSE3 is not set
>> CONFIG_CRYPTO_SHA256=y
>> CONFIG_CRYPTO_SHA512=y
>> # CONFIG_CRYPTO_TGR192 is not set
>> CONFIG_CRYPTO_WP512=y
>> CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=m
>>
>> #
>> # Ciphers
>> #
>> CONFIG_CRYPTO_AES=y
>> CONFIG_CRYPTO_AES_X86_64=y
>> CONFIG_CRYPTO_AES_NI_INTEL=y
>> CONFIG_CRYPTO_ANUBIS=y
>> CONFIG_CRYPTO_ARC4=y
>> CONFIG_CRYPTO_BLOWFISH=y
>> CONFIG_CRYPTO_BLOWFISH_COMMON=y
>> CONFIG_CRYPTO_BLOWFISH_X86_64=y
>> # CONFIG_CRYPTO_CAMELLIA is not set
>> CONFIG_CRYPTO_CAMELLIA_X86_64=y
>> CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
>> CONFIG_CRYPTO_CAST_COMMON=y
>> CONFIG_CRYPTO_CAST5=y
>> CONFIG_CRYPTO_CAST5_AVX_X86_64=y
>> CONFIG_CRYPTO_CAST6=y
>> # CONFIG_CRYPTO_CAST6_AVX_X86_64 is not set
>> CONFIG_CRYPTO_DES=m
>> CONFIG_CRYPTO_FCRYPT=m
>> CONFIG_CRYPTO_KHAZAD=y
>> # CONFIG_CRYPTO_SALSA20 is not set
>> CONFIG_CRYPTO_SALSA20_X86_64=y
>> CONFIG_CRYPTO_SEED=m
>> CONFIG_CRYPTO_SERPENT=y
>> # CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
>> CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
>> # CONFIG_CRYPTO_TEA is not set
>> CONFIG_CRYPTO_TWOFISH=y
>> CONFIG_CRYPTO_TWOFISH_COMMON=y
>> CONFIG_CRYPTO_TWOFISH_X86_64=y
>> CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=m
>> CONFIG_CRYPTO_TWOFISH_AVX_X86_64=m
>>
>> #
>> # Compression
>> #
>> CONFIG_CRYPTO_DEFLATE=y
>> # CONFIG_CRYPTO_ZLIB is not set
>> CONFIG_CRYPTO_LZO=m
>>
>> #
>> # Random Number Generation
>> #
>> CONFIG_CRYPTO_ANSI_CPRNG=m
>> CONFIG_CRYPTO_USER_API=y
>> CONFIG_CRYPTO_USER_API_HASH=y
>> CONFIG_CRYPTO_USER_API_SKCIPHER=y
>> CONFIG_CRYPTO_HW=y
>> # CONFIG_CRYPTO_DEV_PADLOCK is not set
>> CONFIG_ASYMMETRIC_KEY_TYPE=y
>> CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
>> CONFIG_PUBLIC_KEY_ALGO_RSA=y
>> CONFIG_X509_CERTIFICATE_PARSER=y
>> CONFIG_HAVE_KVM=y
>> CONFIG_VIRTUALIZATION=y
>> # CONFIG_VHOST_NET is not set
>> CONFIG_BINARY_PRINTF=y
>>
>> #
>> # Library routines
>> #
>> CONFIG_BITREVERSE=y
>> CONFIG_GENERIC_STRNCPY_FROM_USER=y
>> CONFIG_GENERIC_STRNLEN_USER=y
>> CONFIG_GENERIC_FIND_FIRST_BIT=y
>> CONFIG_GENERIC_PCI_IOMAP=y
>> CONFIG_GENERIC_IOMAP=y
>> CONFIG_GENERIC_IO=y
>> CONFIG_CRC_CCITT=y
>> CONFIG_CRC16=y
>> # CONFIG_CRC_T10DIF is not set
>> CONFIG_CRC_ITU_T=y
>> CONFIG_CRC32=y
>> # CONFIG_CRC32_SELFTEST is not set
>> # CONFIG_CRC32_SLICEBY8 is not set
>> # CONFIG_CRC32_SLICEBY4 is not set
>> CONFIG_CRC32_SARWATE=y
>> # CONFIG_CRC32_BIT is not set
>> CONFIG_CRC7=y
>> CONFIG_LIBCRC32C=y
>> # CONFIG_CRC8 is not set
>> CONFIG_ZLIB_INFLATE=y
>> CONFIG_ZLIB_DEFLATE=y
>> CONFIG_LZO_COMPRESS=y
>> CONFIG_LZO_DECOMPRESS=y
>> CONFIG_XZ_DEC=y
>> CONFIG_XZ_DEC_X86=y
>> CONFIG_XZ_DEC_POWERPC=y
>> # CONFIG_XZ_DEC_IA64 is not set
>> # CONFIG_XZ_DEC_ARM is not set
>> # CONFIG_XZ_DEC_ARMTHUMB is not set
>> # CONFIG_XZ_DEC_SPARC is not set
>> CONFIG_XZ_DEC_BCJ=y
>> # CONFIG_XZ_DEC_TEST is not set
>> CONFIG_DECOMPRESS_GZIP=y
>> CONFIG_DECOMPRESS_XZ=y
>> CONFIG_DECOMPRESS_LZO=y
>> CONFIG_REED_SOLOMON=m
>> CONFIG_REED_SOLOMON_ENC8=y
>> CONFIG_REED_SOLOMON_DEC8=y
>> CONFIG_HAS_IOMEM=y
>> CONFIG_HAS_IOPORT=y
>> CONFIG_HAS_DMA=y
>> CONFIG_CHECK_SIGNATURE=y
>> CONFIG_DQL=y
>> CONFIG_NLATTR=y
>> CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
>> CONFIG_AVERAGE=y
>> CONFIG_CLZ_TAB=y
>> # CONFIG_CORDIC is not set
>> # CONFIG_DDR is not set
>> CONFIG_MPILIB=y
>> CONFIG_OID_REGISTRY=y
> 
> 

