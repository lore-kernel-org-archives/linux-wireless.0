Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:57419 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572Ab2ALVeX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jan 2012 16:34:23 -0500
Date: Thu, 12 Jan 2012 22:34:13 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: "Bouterse, Robert" <robert.bouterse@dmh-global.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: testing ibss, ad-hoc, 802.11n HT rates on OMAP3EVM
Message-ID: <20120112213413.GA15416@pandem0nium> (sfid-20120112_223433_006333_E176B647)
References: <110B6C33195F5F4790292BDD9E7DED401AB86BBF68@VA3DIAXVS371.RED001.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
In-Reply-To: <110B6C33195F5F4790292BDD9E7DED401AB86BBF68@VA3DIAXVS371.RED001.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Robert,

I have just tested your commands on my ath9k setup (not ath9k_htc) - i see
a tx bitrate of 300.0 Mbit/s here. My master is slight older (Jan 5th) and
has my mcs patches applied, but is otherwise "vanilla" wireless testing.

You may want to have a look in the ht_capabilities and rc_stats for the sta=
tion
to see if you see if the features are advertised or HT rates considered.

cat /sys/kernel/debug/ieee80211/phy*/netdev\:wlan0/stations/*/ht_capa
cat /sys/kernel/debug/ieee80211/phy*/netdev\:wlan0/stations/*/rc_stats

If you want to debug it yourself, you may also want to look into a dumpfile=
 with
wireshark to check beacons/probes/responses/etc.

There might also be something wrong with ath9k_htc, I don't really know this
driver ...

Cheers,
    Simon


On Thu, Jan 12, 2012 at 08:10:26AM -0800, Bouterse, Robert wrote:
> I am running tests using ad-hoc wireless networks on an omap3evm platform=
=2E I am using the HEAD of the master barnch of wirelss-testing as of Jan 1=
1, 2012.
> I have tried using both the minstrel, and ath9k rate control algorythms. =
I can't get the link to run using MCS rates, it is always 54Mb/s or less.
> Anyone have any idea what I am doing wrong?
> Here are the specifics of what I have done.
>=20
> /*-----------------------------------------------------------------------=
-----------------------------------------*/
> I am using a TP-Link TL-WN721N USB 802.11n adapter. I have also tried a R=
aLink WUBR-507N USN Adapter.
>=20
> /*-----------------------------------------------------------------------=
-----------------------------------------*/
> Script used to start ad-hoc network:
> # cat adhoc.sh
> #!/bin/sh
> iw wlan0 set type ibss
> iw wlan0 set channel 11 HT40-
> ifconfig wlan0 169.254.1.1
> iw wlan0 ibss join "batmanuel" 2462 HT40- 02:12:34:56:78:9A
>=20
> /*-----------------------------------------------------------------------=
-----------------------------------------*/
> Here is a run using 32K ping packets:
> # ping -c 3 -s 32768 169.254.1.2
> PING 169.254.1.2 (169.254.1.2): 32768 data bytes
> 32776 bytes from 169.254.1.2: seq=3D0 ttl=3D64 time=3D63.293 ms
> 32776 bytes from 169.254.1.2: seq=3D1 ttl=3D64 time=3D45.044 ms
> 32776 bytes from 169.254.1.2: seq=3D2 ttl=3D64 time=3D43.975 ms
>=20
> --- 169.254.1.2 ping statistics ---
> 3 packets transmitted, 3 packets received, 0% packet loss
> round-trip min/avg/max =3D 43.975/50.770/63.293 ms
> # iwconfig
> lo        no wireless extensions.
>=20
> sit0      no wireless extensions.
>=20
> wlan0     IEEE 802.11bgn  ESSID:"batmanuel"
>           Mode:Ad-Hoc  Frequency:2.462 GHz  Cell: 02:12:34:56:78:9A
>           Tx-Power=3D20 dBm
>           Retry  long limit:7   RTS thr:off   Fragment thr:off
>           Encryption key:off
>           Power Management:off
>=20
> eth0      no wireless extensions.
>=20
> # iw wlan0 station dump
> Station f4:ec:38:85:bc:2d (on wlan0)
>         inactive time:  78 ms
>         rx bytes:       232238
>         rx packets:     2056
>         tx bytes:       102474
>         tx packets:     74
>         tx retries:     0
>         tx failed:      0
>         signal:         -69 dBm
>         signal avg:     -68 dBm
>         tx bitrate:     36.0 MBit/s
>         authorized:     yes
>         authenticated:  yes
>         preamble:       long
>         WMM/WME:        yes
>         MFP:            no
>         TDLS peer:              no
>=20
> # iw phy phy0 info
> Wiphy phy0
>         Band 1:
>                 Capabilities: 0x116e
>                         HT20/HT40
>                         SM Power Save disabled
>                         RX HT20 SGI
>                         RX HT40 SGI
>                         RX STBC 1-stream
>                         Max AMSDU length: 3839 bytes
>                         DSSS/CCK HT40
>                 Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
>                 Minimum RX AMPDU time spacing: 8 usec (0x06)
>                 HT TX/RX MCS rate indexes supported: 0-7
>                 Frequencies:
>                         * 2412 MHz [1] (20.0 dBm)
>                         * 2417 MHz [2] (20.0 dBm)
>                         * 2422 MHz [3] (20.0 dBm)
>                         * 2427 MHz [4] (20.0 dBm)
>                         * 2432 MHz [5] (20.0 dBm)
>                         * 2437 MHz [6] (20.0 dBm)
>                         * 2442 MHz [7] (20.0 dBm)
>                         * 2447 MHz [8] (20.0 dBm)
>                         * 2452 MHz [9] (20.0 dBm)
>                         * 2457 MHz [10] (20.0 dBm)
>                         * 2462 MHz [11] (20.0 dBm)
>                         * 2467 MHz [12] (disabled)
>                         * 2472 MHz [13] (disabled)
>                         * 2484 MHz [14] (disabled)
>                 Bitrates (non-HT):
>                         * 1.0 Mbps
>                         * 2.0 Mbps (short preamble supported)
>                         * 5.5 Mbps (short preamble supported)
>                         * 11.0 Mbps (short preamble supported)
>                         * 6.0 Mbps
>                         * 9.0 Mbps
>                         * 12.0 Mbps
>                         * 18.0 Mbps
>                         * 24.0 Mbps
>                         * 36.0 Mbps
>                         * 48.0 Mbps
>                         * 54.0 Mbps
>         max # scan SSIDs: 4
>         max scan IEs length: 2257 bytes
>         Coverage class: 0 (up to 0m)
>         Supported Ciphers:
>                 * WEP40 (00-0f-ac:1)
>                 * WEP104 (00-0f-ac:5)
>                 * TKIP (00-0f-ac:2)
>                 * CCMP (00-0f-ac:4)
>                 * CMAC (00-0f-ac:6)
>         Available Antennas: TX 0 RX 0
>         Supported interface modes:
>                  * IBSS
>                  * managed
>                  * AP
>                  * AP/VLAN
>                  * monitor
>                  * mesh point
>                  * P2P-client
>                  * P2P-GO
>         software interface modes (can always be added):
>                  * AP/VLAN
>                  * monitor
>         interface combinations are not supported
>         Supported commands:
>                  * new_interface
>                  * set_interface
>                  * new_key
>                  * new_beacon
>                  * new_station
>                  * new_mpath
>                  * set_mesh_params
>                  * set_bss
>                  * authenticate
>                  * associate
>                  * deauthenticate
>                  * disassociate
>                  * join_ibss
>                  * join_mesh
>                  * remain_on_channel
>                  * set_tx_bitrate_mask
>                  * action
>                  * frame_wait_cancel
>                  * set_wiphy_netns
>                  * set_channel
>                  * set_wds_peer
>                  * Unknown command (84)
>                  * Unknown command (87)
>                  * Unknown command (85)
>                  * connect
>                  * disconnect
>         Supported TX frame types:
>                  * IBSS: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060=
 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
>                  * managed: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0=
060 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
>                  * AP: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060 0=
x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
>                  * AP/VLAN: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0=
060 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
>                  * mesh point: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 =
0x0060 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
>                  * P2P-client: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 =
0x0060 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
>                  * P2P-GO: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x00=
60 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
>         Supported RX frame types:
>                  * IBSS: 0x00d0
>                  * managed: 0x0040 0x00d0
>                  * AP: 0x0000 0x0020 0x0040 0x00a0 0x00b0 0x00c0 0x00d0
>                  * AP/VLAN: 0x0000 0x0020 0x0040 0x00a0 0x00b0 0x00c0 0x0=
0d0
>                  * mesh point: 0x00b0 0x00c0 0x00d0
>                  * P2P-client: 0x0040 0x00d0
>                  * P2P-GO: 0x0000 0x0020 0x0040 0x00a0 0x00b0 0x00c0 0x00=
d0
>         Device supports RSN-IBSS.
>         HT Capability overrides:
>                  * MCS: ff ff ff ff ff ff ff ff ff ff
>                  * maximum A-MSDU length
>                  * supported channel width
>                  * short GI for 40 MHz
>                  * max A-MPDU length exponent
>                  * min MPDU start spacing
>         Device supports TX status socket option.
>         Device supports HT-IBSS.
>=20
> /*-----------------------------------------------------------------------=
-----------------------------------------*/
> # uname -a
> Linux Unknown 3.2.0 #4 SMP Wed Jan 11 14:21:02 EST 2012 armv7l GNU/Linux
>=20
> /*-----------------------------------------------------------------------=
-----------------------------------------*/
> iw version 3.2, git master
> http://git.sipsolutions.net/?p=3Diw.git;a=3Dtree;h=3D93fe6d1252ba6ed3f9e5=
3d900d4c0bf3eab218a9;hb=3D27bf109b996f24f352c6c3bfaf3e183172d33fa8
>=20
> /*-----------------------------------------------------------------------=
-----------------------------------------*/
> libnl-3.2.4
>=20
> /*-----------------------------------------------------------------------=
-----------------------------------------*/
> Kernel, HEAD of wireless-testing, merged with the HEAD of linux-omap:
> $ git log -n 4 --pretty=3Doneline
> 0795475c92fb5994489aea918c3e861ed1155917 Merge git://git.kernel.org/pub/s=
cm/linux/kernel/git/tmlind/linux-omap
> ebc06f464c410c1530f7db136ac615a34a4160ac Merge git://git.kernel.org/pub/s=
cm/linux/kernel/git/linville/wireless-testing
> 338ec0c7d78bb8bc8ffd76100b12cd21425e6837 Merge ssh://ra.kernel.org/pub/sc=
m/linux/kernel/git/linville/wireless-next
> 7289e07d894da2e36ec73d1a19d51d82079646a0 Merge ssh://ra.kernel.org/pub/sc=
m/linux/kernel/git/linville/wireless
>=20
> /*-----------------------------------------------------------------------=
-----------------------------------------*/
> # lsmod
> Module                  Size  Used by
> arc4                    1247  2
> ath9k_htc              92055  0
> mac80211              487752  1 ath9k_htc
> ath9k_common            3227  1 ath9k_htc
> ath9k_hw              472256  2 ath9k_htc,ath9k_common
> ath                    18991  3 ath9k_htc,ath9k_common,ath9k_hw
> cfg80211              189895  3 ath9k_htc,mac80211,ath
>=20
> /*-----------------------------------------------------------------------=
-----------------------------------------*/
> $ cat output/build/linux-omap-wireless-git/.config
> #
> # Automatically generated file; DO NOT EDIT.
> # Linux/arm 3.2.0 Kernel Configuration
> #
> CONFIG_ARM=3Dy
> CONFIG_SYS_SUPPORTS_APM_EMULATION=3Dy
> CONFIG_HAVE_SCHED_CLOCK=3Dy
> CONFIG_GENERIC_GPIO=3Dy
> # CONFIG_ARCH_USES_GETTIMEOFFSET is not set
> CONFIG_GENERIC_CLOCKEVENTS=3Dy
> CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=3Dy
> CONFIG_KTIME_SCALAR=3Dy
> CONFIG_HAVE_PROC_CPU=3Dy
> CONFIG_STACKTRACE_SUPPORT=3Dy
> CONFIG_LOCKDEP_SUPPORT=3Dy
> CONFIG_TRACE_IRQFLAGS_SUPPORT=3Dy
> CONFIG_HARDIRQS_SW_RESEND=3Dy
> CONFIG_GENERIC_IRQ_PROBE=3Dy
> CONFIG_RWSEM_GENERIC_SPINLOCK=3Dy
> CONFIG_ARCH_HAS_CPUFREQ=3Dy
> CONFIG_ARCH_HAS_CPU_IDLE_WAIT=3Dy
> CONFIG_GENERIC_HWEIGHT=3Dy
> CONFIG_GENERIC_CALIBRATE_DELAY=3Dy
> CONFIG_NEED_DMA_MAP_STATE=3Dy
> CONFIG_VECTORS_BASE=3D0xffff0000
> CONFIG_ARM_PATCH_PHYS_VIRT=3Dy
> CONFIG_GENERIC_BUG=3Dy
> CONFIG_DEFCONFIG_LIST=3D"/lib/modules/$UNAME_RELEASE/.config"
> CONFIG_HAVE_IRQ_WORK=3Dy
> CONFIG_IRQ_WORK=3Dy
>=20
> #
> # General setup
> #
> CONFIG_EXPERIMENTAL=3Dy
> CONFIG_INIT_ENV_ARG_LIMIT=3D32
> CONFIG_CROSS_COMPILE=3D"arm-none-linux-gnueabi-"
> CONFIG_LOCALVERSION=3D""
> CONFIG_LOCALVERSION_AUTO=3Dy
> CONFIG_HAVE_KERNEL_GZIP=3Dy
> CONFIG_HAVE_KERNEL_LZMA=3Dy
> CONFIG_HAVE_KERNEL_LZO=3Dy
> CONFIG_KERNEL_GZIP=3Dy
> # CONFIG_KERNEL_LZMA is not set
> # CONFIG_KERNEL_LZO is not set
> CONFIG_DEFAULT_HOSTNAME=3D"(none)"
> CONFIG_SWAP=3Dy
> CONFIG_SYSVIPC=3Dy
> CONFIG_SYSVIPC_SYSCTL=3Dy
> CONFIG_POSIX_MQUEUE=3Dy
> CONFIG_POSIX_MQUEUE_SYSCTL=3Dy
> CONFIG_BSD_PROCESS_ACCT=3Dy
> # CONFIG_BSD_PROCESS_ACCT_V3 is not set
> # CONFIG_FHANDLE is not set
> # CONFIG_TASKSTATS is not set
> # CONFIG_AUDIT is not set
> CONFIG_HAVE_GENERIC_HARDIRQS=3Dy
>=20
> #
> # IRQ subsystem
> #
> CONFIG_GENERIC_HARDIRQS=3Dy
> CONFIG_HAVE_SPARSE_IRQ=3Dy
> CONFIG_GENERIC_IRQ_SHOW=3Dy
> CONFIG_GENERIC_IRQ_CHIP=3Dy
> CONFIG_IRQ_DOMAIN=3Dy
> # CONFIG_SPARSE_IRQ is not set
>=20
> #
> # RCU Subsystem
> #
> CONFIG_TREE_RCU=3Dy
> # CONFIG_PREEMPT_RCU is not set
> # CONFIG_RCU_TRACE is not set
> CONFIG_RCU_FANOUT=3D32
> # CONFIG_RCU_FANOUT_EXACT is not set
> # CONFIG_RCU_FAST_NO_HZ is not set
> # CONFIG_TREE_RCU_TRACE is not set
> CONFIG_IKCONFIG=3Dy
> CONFIG_IKCONFIG_PROC=3Dy
> CONFIG_LOG_BUF_SHIFT=3D16
> # CONFIG_CGROUPS is not set
> # CONFIG_NAMESPACES is not set
> # CONFIG_SCHED_AUTOGROUP is not set
> # CONFIG_SYSFS_DEPRECATED is not set
> # CONFIG_RELAY is not set
> CONFIG_BLK_DEV_INITRD=3Dy
> CONFIG_INITRAMFS_SOURCE=3D""
> CONFIG_RD_GZIP=3Dy
> # CONFIG_RD_BZIP2 is not set
> # CONFIG_RD_LZMA is not set
> # CONFIG_RD_XZ is not set
> # CONFIG_RD_LZO is not set
> # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
> CONFIG_SYSCTL=3Dy
> CONFIG_ANON_INODES=3Dy
> CONFIG_EXPERT=3Dy
> CONFIG_UID16=3Dy
> # CONFIG_SYSCTL_SYSCALL is not set
> CONFIG_KALLSYMS=3Dy
> CONFIG_KALLSYMS_ALL=3Dy
> CONFIG_HOTPLUG=3Dy
> CONFIG_PRINTK=3Dy
> CONFIG_BUG=3Dy
> CONFIG_ELF_CORE=3Dy
> CONFIG_BASE_FULL=3Dy
> CONFIG_FUTEX=3Dy
> CONFIG_EPOLL=3Dy
> CONFIG_SIGNALFD=3Dy
> CONFIG_TIMERFD=3Dy
> CONFIG_EVENTFD=3Dy
> CONFIG_SHMEM=3Dy
> CONFIG_AIO=3Dy
> # CONFIG_EMBEDDED is not set
> CONFIG_HAVE_PERF_EVENTS=3Dy
> CONFIG_PERF_USE_VMALLOC=3Dy
>=20
> #
> # Kernel Performance Events And Counters
> #
> CONFIG_PERF_EVENTS=3Dy
> # CONFIG_PERF_COUNTERS is not set
> # CONFIG_DEBUG_PERF_USE_VMALLOC is not set
> CONFIG_VM_EVENT_COUNTERS=3Dy
> CONFIG_COMPAT_BRK=3Dy
> CONFIG_SLAB=3Dy
> # CONFIG_SLUB is not set
> # CONFIG_SLOB is not set
> CONFIG_PROFILING=3Dy
> CONFIG_TRACEPOINTS=3Dy
> CONFIG_OPROFILE=3Dy
> CONFIG_HAVE_OPROFILE=3Dy
> CONFIG_KPROBES=3Dy
> CONFIG_KRETPROBES=3Dy
> CONFIG_HAVE_KPROBES=3Dy
> CONFIG_HAVE_KRETPROBES=3Dy
> CONFIG_USE_GENERIC_SMP_HELPERS=3Dy
> CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=3Dy
> CONFIG_HAVE_CLK=3Dy
> CONFIG_HAVE_DMA_API_DEBUG=3Dy
> CONFIG_HAVE_HW_BREAKPOINT=3Dy
>=20
> #
> # GCOV-based kernel profiling
> #
> # CONFIG_GCOV_KERNEL is not set
> CONFIG_HAVE_GENERIC_DMA_COHERENT=3Dy
> CONFIG_SLABINFO=3Dy
> CONFIG_RT_MUTEXES=3Dy
> CONFIG_BASE_SMALL=3D0
> CONFIG_MODULES=3Dy
> CONFIG_MODULE_FORCE_LOAD=3Dy
> CONFIG_MODULE_UNLOAD=3Dy
> CONFIG_MODULE_FORCE_UNLOAD=3Dy
> CONFIG_MODVERSIONS=3Dy
> CONFIG_MODULE_SRCVERSION_ALL=3Dy
> CONFIG_STOP_MACHINE=3Dy
> CONFIG_BLOCK=3Dy
> CONFIG_LBDAF=3Dy
> # CONFIG_BLK_DEV_BSG is not set
> # CONFIG_BLK_DEV_BSGLIB is not set
> # CONFIG_BLK_DEV_INTEGRITY is not set
>=20
> #
> # IO Schedulers
> #
> CONFIG_IOSCHED_NOOP=3Dy
> CONFIG_IOSCHED_DEADLINE=3Dy
> CONFIG_IOSCHED_CFQ=3Dy
> # CONFIG_DEFAULT_DEADLINE is not set
> CONFIG_DEFAULT_CFQ=3Dy
> # CONFIG_DEFAULT_NOOP is not set
> CONFIG_DEFAULT_IOSCHED=3D"cfq"
> # CONFIG_INLINE_SPIN_TRYLOCK is not set
> # CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
> # CONFIG_INLINE_SPIN_LOCK is not set
> # CONFIG_INLINE_SPIN_LOCK_BH is not set
> # CONFIG_INLINE_SPIN_LOCK_IRQ is not set
> # CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
> # CONFIG_INLINE_SPIN_UNLOCK is not set
> # CONFIG_INLINE_SPIN_UNLOCK_BH is not set
> # CONFIG_INLINE_SPIN_UNLOCK_IRQ is not set
> # CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
> # CONFIG_INLINE_READ_TRYLOCK is not set
> # CONFIG_INLINE_READ_LOCK is not set
> # CONFIG_INLINE_READ_LOCK_BH is not set
> # CONFIG_INLINE_READ_LOCK_IRQ is not set
> # CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
> # CONFIG_INLINE_READ_UNLOCK is not set
> # CONFIG_INLINE_READ_UNLOCK_BH is not set
> # CONFIG_INLINE_READ_UNLOCK_IRQ is not set
> # CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
> # CONFIG_INLINE_WRITE_TRYLOCK is not set
> # CONFIG_INLINE_WRITE_LOCK is not set
> # CONFIG_INLINE_WRITE_LOCK_BH is not set
> # CONFIG_INLINE_WRITE_LOCK_IRQ is not set
> # CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
> # CONFIG_INLINE_WRITE_UNLOCK is not set
> # CONFIG_INLINE_WRITE_UNLOCK_BH is not set
> # CONFIG_INLINE_WRITE_UNLOCK_IRQ is not set
> # CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
> # CONFIG_MUTEX_SPIN_ON_OWNER is not set
> CONFIG_FREEZER=3Dy
>=20
> #
> # System Type
> #
> CONFIG_MMU=3Dy
> # CONFIG_ARCH_INTEGRATOR is not set
> # CONFIG_ARCH_REALVIEW is not set
> # CONFIG_ARCH_VERSATILE is not set
> # CONFIG_ARCH_VEXPRESS is not set
> # CONFIG_ARCH_AT91 is not set
> # CONFIG_ARCH_BCMRING is not set
> # CONFIG_ARCH_HIGHBANK is not set
> # CONFIG_ARCH_CLPS711X is not set
> # CONFIG_ARCH_CNS3XXX is not set
> # CONFIG_ARCH_GEMINI is not set
> # CONFIG_ARCH_PRIMA2 is not set
> # CONFIG_ARCH_EBSA110 is not set
> # CONFIG_ARCH_EP93XX is not set
> # CONFIG_ARCH_FOOTBRIDGE is not set
> # CONFIG_ARCH_MXC is not set
> # CONFIG_ARCH_MXS is not set
> # CONFIG_ARCH_NETX is not set
> # CONFIG_ARCH_H720X is not set
> # CONFIG_ARCH_IOP13XX is not set
> # CONFIG_ARCH_IOP32X is not set
> # CONFIG_ARCH_IOP33X is not set
> # CONFIG_ARCH_IXP23XX is not set
> # CONFIG_ARCH_IXP2000 is not set
> # CONFIG_ARCH_IXP4XX is not set
> # CONFIG_ARCH_DOVE is not set
> # CONFIG_ARCH_KIRKWOOD is not set
> # CONFIG_ARCH_LPC32XX is not set
> # CONFIG_ARCH_MV78XX0 is not set
> # CONFIG_ARCH_ORION5X is not set
> # CONFIG_ARCH_MMP is not set
> # CONFIG_ARCH_KS8695 is not set
> # CONFIG_ARCH_W90X900 is not set
> # CONFIG_ARCH_TEGRA is not set
> # CONFIG_ARCH_PICOXCELL is not set
> # CONFIG_ARCH_PNX4008 is not set
> # CONFIG_ARCH_PXA is not set
> # CONFIG_ARCH_MSM is not set
> # CONFIG_ARCH_SHMOBILE is not set
> # CONFIG_ARCH_RPC is not set
> # CONFIG_ARCH_SA1100 is not set
> # CONFIG_ARCH_S3C2410 is not set
> # CONFIG_ARCH_S3C64XX is not set
> # CONFIG_ARCH_S5P64X0 is not set
> # CONFIG_ARCH_S5PC100 is not set
> # CONFIG_ARCH_S5PV210 is not set
> # CONFIG_ARCH_EXYNOS is not set
> # CONFIG_ARCH_SHARK is not set
> # CONFIG_ARCH_TCC_926 is not set
> # CONFIG_ARCH_U300 is not set
> # CONFIG_ARCH_U8500 is not set
> # CONFIG_ARCH_NOMADIK is not set
> # CONFIG_ARCH_DAVINCI is not set
> CONFIG_ARCH_OMAP=3Dy
> # CONFIG_PLAT_SPEAR is not set
> # CONFIG_ARCH_VT8500 is not set
> # CONFIG_ARCH_ZYNQ is not set
> # CONFIG_GPIO_PCA953X is not set
> # CONFIG_KEYBOARD_GPIO_POLLED is not set
>=20
> #
> # TI OMAP Common Features
> #
> CONFIG_ARCH_OMAP_OTG=3Dy
> # CONFIG_ARCH_OMAP1 is not set
> CONFIG_ARCH_OMAP2PLUS=3Dy
>=20
> #
> # OMAP Feature Selections
> #
> CONFIG_OMAP_DEBUG_DEVICES=3Dy
> CONFIG_OMAP_DEBUG_LEDS=3Dy
> # CONFIG_OMAP_SMARTREFLEX is not set
> CONFIG_OMAP_RESET_CLOCKS=3Dy
> CONFIG_OMAP_MUX=3Dy
> CONFIG_OMAP_MUX_DEBUG=3Dy
> CONFIG_OMAP_MUX_WARNINGS=3Dy
> CONFIG_OMAP_MCBSP=3Dy
> # CONFIG_OMAP_MBOX_FWK is not set
> CONFIG_OMAP_32K_TIMER=3Dy
> # CONFIG_OMAP3_L2_AUX_SECURE_SAVE_RESTORE is not set
> CONFIG_OMAP_32K_TIMER_HZ=3D128
> CONFIG_OMAP_DM_TIMER=3Dy
> CONFIG_OMAP_PM_NOOP=3Dy
> CONFIG_MACH_OMAP_GENERIC=3Dy
>=20
> #
> # TI OMAP2/3/4 Specific Features
> #
> CONFIG_ARCH_OMAP2PLUS_TYPICAL=3Dy
> CONFIG_ARCH_OMAP2=3Dy
> CONFIG_ARCH_OMAP3=3Dy
> CONFIG_ARCH_OMAP4=3Dy
>=20
> #
> # OMAP Core Type
> #
> CONFIG_SOC_OMAP2420=3Dy
> CONFIG_SOC_OMAP2430=3Dy
> CONFIG_SOC_OMAP3430=3Dy
> CONFIG_SOC_OMAPTI81XX=3Dy
> CONFIG_SOC_OMAPAM33XX=3Dy
> CONFIG_OMAP_PACKAGE_ZAF=3Dy
> CONFIG_OMAP_PACKAGE_ZAC=3Dy
> CONFIG_OMAP_PACKAGE_CBB=3Dy
> CONFIG_OMAP_PACKAGE_CUS=3Dy
> CONFIG_OMAP_PACKAGE_CBP=3Dy
> CONFIG_OMAP_PACKAGE_CBL=3Dy
> CONFIG_OMAP_PACKAGE_CBS=3Dy
>=20
> #
> # OMAP Board Type
> #
> CONFIG_MACH_OMAP2_TUSB6010=3Dy
> CONFIG_MACH_OMAP_H4=3Dy
> CONFIG_MACH_OMAP_APOLLON=3Dy
> CONFIG_MACH_OMAP_2430SDP=3Dy
> CONFIG_MACH_OMAP3_BEAGLE=3Dy
> CONFIG_MACH_DEVKIT8000=3Dy
> CONFIG_MACH_OMAP_LDP=3Dy
> CONFIG_MACH_OMAP3530_LV_SOM=3Dy
> CONFIG_MACH_OMAP3_TORPEDO=3Dy
> CONFIG_MACH_ENCORE=3Dy
> CONFIG_MACH_OVERO=3Dy
> CONFIG_MACH_OMAP3EVM=3Dy
> CONFIG_MACH_OMAP3517EVM=3Dy
> # CONFIG_MACH_CRANEBOARD is not set
> CONFIG_MACH_OMAP3_PANDORA=3Dy
> CONFIG_MACH_OMAP3_TOUCHBOOK=3Dy
> CONFIG_MACH_OMAP_3430SDP=3Dy
> CONFIG_MACH_NOKIA_N800=3Dy
> CONFIG_MACH_NOKIA_N810=3Dy
> CONFIG_MACH_NOKIA_N810_WIMAX=3Dy
> CONFIG_MACH_NOKIA_N8X0=3Dy
> CONFIG_MACH_NOKIA_RM680=3Dy
> CONFIG_MACH_NOKIA_RX51=3Dy
> CONFIG_MACH_OMAP_ZOOM2=3Dy
> CONFIG_MACH_OMAP_ZOOM3=3Dy
> CONFIG_MACH_CM_T35=3Dy
> CONFIG_MACH_CM_T3517=3Dy
> CONFIG_MACH_CM_T3730=3Dy
> CONFIG_MACH_IGEP0020=3Dy
> CONFIG_MACH_IGEP0030=3Dy
> CONFIG_MACH_SBC3530=3Dy
> CONFIG_MACH_OMAP_3630SDP=3Dy
> CONFIG_MACH_TI8168EVM=3Dy
> CONFIG_MACH_TI8148EVM=3Dy
> CONFIG_MACH_OMAP_4430SDP=3Dy
> CONFIG_MACH_OMAP4_PANDA=3Dy
> CONFIG_MACH_PCM049=3Dy
> # CONFIG_OMAP3_EMU is not set
> # CONFIG_OMAP3_SDRC_AC_TIMING is not set
> # CONFIG_OMAP4_ERRATA_I688 is not set
>=20
> #
> # System MMU
> #
>=20
> #
> # Processor Type
> #
> CONFIG_CPU_V6=3Dy
> CONFIG_CPU_V7=3Dy
> CONFIG_CPU_32v6=3Dy
> CONFIG_CPU_32v6K=3Dy
> CONFIG_CPU_32v7=3Dy
> CONFIG_CPU_ABRT_EV6=3Dy
> CONFIG_CPU_ABRT_EV7=3Dy
> CONFIG_CPU_PABRT_V6=3Dy
> CONFIG_CPU_PABRT_V7=3Dy
> CONFIG_CPU_CACHE_V6=3Dy
> CONFIG_CPU_CACHE_V7=3Dy
> CONFIG_CPU_CACHE_VIPT=3Dy
> CONFIG_CPU_COPY_V6=3Dy
> CONFIG_CPU_TLB_V6=3Dy
> CONFIG_CPU_TLB_V7=3Dy
> CONFIG_CPU_HAS_ASID=3Dy
> CONFIG_CPU_CP15=3Dy
> CONFIG_CPU_CP15_MMU=3Dy
> CONFIG_CPU_USE_DOMAINS=3Dy
>=20
> #
> # Processor Features
> #
> CONFIG_ARM_THUMB=3Dy
> CONFIG_ARM_THUMBEE=3Dy
> # CONFIG_CPU_ICACHE_DISABLE is not set
> # CONFIG_CPU_DCACHE_DISABLE is not set
> # CONFIG_CPU_BPREDICT_DISABLE is not set
> CONFIG_OUTER_CACHE=3Dy
> CONFIG_OUTER_CACHE_SYNC=3Dy
> CONFIG_CACHE_L2X0=3Dy
> CONFIG_ARM_L1_CACHE_SHIFT=3D5
> CONFIG_ARM_DMA_MEM_BUFFERABLE=3Dy
> CONFIG_MULTI_IRQ_HANDLER=3Dy
> CONFIG_ARM_ERRATA_411920=3Dy
> # CONFIG_ARM_ERRATA_430973 is not set
> # CONFIG_ARM_ERRATA_458693 is not set
> # CONFIG_ARM_ERRATA_460075 is not set
> # CONFIG_ARM_ERRATA_742230 is not set
> # CONFIG_ARM_ERRATA_742231 is not set
> CONFIG_PL310_ERRATA_588369=3Dy
> CONFIG_ARM_ERRATA_720789=3Dy
> CONFIG_PL310_ERRATA_727915=3Dy
> # CONFIG_ARM_ERRATA_743622 is not set
> # CONFIG_ARM_ERRATA_751472 is not set
> # CONFIG_ARM_ERRATA_754322 is not set
> # CONFIG_ARM_ERRATA_754327 is not set
> # CONFIG_ARM_ERRATA_764369 is not set
> # CONFIG_PL310_ERRATA_769419 is not set
> CONFIG_ARM_GIC=3Dy
>=20
> #
> # Bus support
> #
> # CONFIG_PCI_SYSCALL is not set
> # CONFIG_ARCH_SUPPORTS_MSI is not set
> # CONFIG_PCCARD is not set
>=20
> #
> # Kernel Features
> #
> CONFIG_TICK_ONESHOT=3Dy
> CONFIG_NO_HZ=3Dy
> CONFIG_HIGH_RES_TIMERS=3Dy
> CONFIG_GENERIC_CLOCKEVENTS_BUILD=3Dy
> CONFIG_SMP=3Dy
> CONFIG_SMP_ON_UP=3Dy
> CONFIG_ARM_CPU_TOPOLOGY=3Dy
> # CONFIG_SCHED_MC is not set
> # CONFIG_SCHED_SMT is not set
> CONFIG_HAVE_ARM_SCU=3Dy
> CONFIG_HAVE_ARM_TWD=3Dy
> CONFIG_VMSPLIT_3G=3Dy
> # CONFIG_VMSPLIT_2G is not set
> # CONFIG_VMSPLIT_1G is not set
> CONFIG_PAGE_OFFSET=3D0xC0000000
> CONFIG_NR_CPUS=3D2
> CONFIG_HOTPLUG_CPU=3Dy
> CONFIG_LOCAL_TIMERS=3Dy
> CONFIG_PREEMPT_NONE=3Dy
> # CONFIG_PREEMPT_VOLUNTARY is not set
> # CONFIG_PREEMPT is not set
> CONFIG_HZ=3D128
> CONFIG_AEABI=3Dy
> # CONFIG_OABI_COMPAT is not set
> CONFIG_ARCH_HAS_HOLES_MEMORYMODEL=3Dy
> # CONFIG_ARCH_SPARSEMEM_DEFAULT is not set
> # CONFIG_ARCH_SELECT_MEMORY_MODEL is not set
> CONFIG_HAVE_ARCH_PFN_VALID=3Dy
> # CONFIG_HIGHMEM is not set
> CONFIG_SELECT_MEMORY_MODEL=3Dy
> CONFIG_FLATMEM_MANUAL=3Dy
> CONFIG_FLATMEM=3Dy
> CONFIG_FLAT_NODE_MEM_MAP=3Dy
> CONFIG_HAVE_MEMBLOCK=3Dy
> CONFIG_PAGEFLAGS_EXTENDED=3Dy
> CONFIG_SPLIT_PTLOCK_CPUS=3D999999
> # CONFIG_COMPACTION is not set
> # CONFIG_PHYS_ADDR_T_64BIT is not set
> CONFIG_ZONE_DMA_FLAG=3D0
> CONFIG_VIRT_TO_BUS=3Dy
> # CONFIG_KSM is not set
> CONFIG_DEFAULT_MMAP_MIN_ADDR=3D4096
> # CONFIG_CLEANCACHE is not set
> CONFIG_FORCE_MAX_ZONEORDER=3D11
> CONFIG_LEDS=3Dy
> CONFIG_ALIGNMENT_TRAP=3Dy
> # CONFIG_UACCESS_WITH_MEMCPY is not set
> # CONFIG_SECCOMP is not set
> # CONFIG_CC_STACKPROTECTOR is not set
> # CONFIG_DEPRECATED_PARAM_STRUCT is not set
>=20
> #
> # Boot options
> #
> CONFIG_USE_OF=3Dy
> CONFIG_ZBOOT_ROM_TEXT=3D0x0
> CONFIG_ZBOOT_ROM_BSS=3D0x0
> # CONFIG_ARM_APPENDED_DTB is not set
> CONFIG_CMDLINE=3D"root=3D/dev/mmcblk0p2 rootwait console=3DttyO2,115200"
> CONFIG_CMDLINE_FROM_BOOTLOADER=3Dy
> # CONFIG_CMDLINE_EXTEND is not set
> # CONFIG_CMDLINE_FORCE is not set
> # CONFIG_XIP_KERNEL is not set
> CONFIG_KEXEC=3Dy
> CONFIG_ATAGS_PROC=3Dy
> # CONFIG_CRASH_DUMP is not set
> # CONFIG_AUTO_ZRELADDR is not set
>=20
> #
> # CPU Power Management
> #
>=20
> #
> # CPU Frequency scaling
> #
> # CONFIG_CPU_FREQ is not set
> # CONFIG_CPU_IDLE is not set
>=20
> #
> # Floating point emulation
> #
>=20
> #
> # At least one emulation must be selected
> #
> CONFIG_VFP=3Dy
> CONFIG_VFPv3=3Dy
> CONFIG_NEON=3Dy
>=20
> #
> # Userspace binary formats
> #
> CONFIG_BINFMT_ELF=3Dy
> CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=3Dy
> CONFIG_HAVE_AOUT=3Dy
> # CONFIG_BINFMT_AOUT is not set
> CONFIG_BINFMT_MISC=3Dy
>=20
> #
> # Power management options
> #
> CONFIG_SUSPEND=3Dy
> CONFIG_SUSPEND_FREEZER=3Dy
> CONFIG_PM_SLEEP=3Dy
> CONFIG_PM_SLEEP_SMP=3Dy
> CONFIG_PM_RUNTIME=3Dy
> CONFIG_PM=3Dy
> CONFIG_PM_DEBUG=3Dy
> # CONFIG_PM_ADVANCED_DEBUG is not set
> # CONFIG_PM_TEST_SUSPEND is not set
> CONFIG_CAN_PM_TRACE=3Dy
> # CONFIG_APM_EMULATION is not set
> CONFIG_ARCH_HAS_OPP=3Dy
> CONFIG_PM_OPP=3Dy
> CONFIG_PM_CLK=3Dy
> CONFIG_CPU_PM=3Dy
> CONFIG_ARCH_SUSPEND_POSSIBLE=3Dy
> CONFIG_ARM_CPU_SUSPEND=3Dy
> CONFIG_NET=3Dy
>=20
> #
> # Networking options
> #
> CONFIG_PACKET=3Dy
> CONFIG_UNIX=3Dy
> CONFIG_XFRM=3Dy
> CONFIG_XFRM_USER=3Dy
> # CONFIG_XFRM_SUB_POLICY is not set
> CONFIG_XFRM_MIGRATE=3Dy
> # CONFIG_XFRM_STATISTICS is not set
> CONFIG_NET_KEY=3Dy
> CONFIG_NET_KEY_MIGRATE=3Dy
> CONFIG_INET=3Dy
> CONFIG_IP_MULTICAST=3Dy
> # CONFIG_IP_ADVANCED_ROUTER is not set
> CONFIG_IP_PNP=3Dy
> CONFIG_IP_PNP_DHCP=3Dy
> CONFIG_IP_PNP_BOOTP=3Dy
> CONFIG_IP_PNP_RARP=3Dy
> # CONFIG_NET_IPIP is not set
> # CONFIG_NET_IPGRE_DEMUX is not set
> # CONFIG_IP_MROUTE is not set
> # CONFIG_ARPD is not set
> # CONFIG_SYN_COOKIES is not set
> # CONFIG_INET_AH is not set
> # CONFIG_INET_ESP is not set
> # CONFIG_INET_IPCOMP is not set
> # CONFIG_INET_XFRM_TUNNEL is not set
> CONFIG_INET_TUNNEL=3Dy
> CONFIG_INET_XFRM_MODE_TRANSPORT=3Dy
> CONFIG_INET_XFRM_MODE_TUNNEL=3Dy
> CONFIG_INET_XFRM_MODE_BEET=3Dy
> # CONFIG_INET_LRO is not set
> CONFIG_INET_DIAG=3Dy
> CONFIG_INET_TCP_DIAG=3Dy
> # CONFIG_TCP_CONG_ADVANCED is not set
> CONFIG_TCP_CONG_CUBIC=3Dy
> CONFIG_DEFAULT_TCP_CONG=3D"cubic"
> # CONFIG_TCP_MD5SIG is not set
> CONFIG_IPV6=3Dy
> # CONFIG_IPV6_PRIVACY is not set
> # CONFIG_IPV6_ROUTER_PREF is not set
> # CONFIG_IPV6_OPTIMISTIC_DAD is not set
> # CONFIG_INET6_AH is not set
> # CONFIG_INET6_ESP is not set
> # CONFIG_INET6_IPCOMP is not set
> # CONFIG_IPV6_MIP6 is not set
> # CONFIG_INET6_XFRM_TUNNEL is not set
> # CONFIG_INET6_TUNNEL is not set
> CONFIG_INET6_XFRM_MODE_TRANSPORT=3Dy
> CONFIG_INET6_XFRM_MODE_TUNNEL=3Dy
> CONFIG_INET6_XFRM_MODE_BEET=3Dy
> # CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
> CONFIG_IPV6_SIT=3Dy
> # CONFIG_IPV6_SIT_6RD is not set
> CONFIG_IPV6_NDISC_NODETYPE=3Dy
> # CONFIG_IPV6_TUNNEL is not set
> # CONFIG_IPV6_MULTIPLE_TABLES is not set
> # CONFIG_IPV6_MROUTE is not set
> # CONFIG_NETLABEL is not set
> # CONFIG_NETWORK_SECMARK is not set
> # CONFIG_NETWORK_PHY_TIMESTAMPING is not set
> CONFIG_NETFILTER=3Dy
> # CONFIG_NETFILTER_DEBUG is not set
> CONFIG_NETFILTER_ADVANCED=3Dy
> CONFIG_BRIDGE_NETFILTER=3Dy
>=20
> #
> # Core Netfilter Configuration
> #
> # CONFIG_NETFILTER_NETLINK_QUEUE is not set
> # CONFIG_NETFILTER_NETLINK_LOG is not set
> # CONFIG_NF_CONNTRACK is not set
> # CONFIG_NETFILTER_XTABLES is not set
> # CONFIG_IP_VS is not set
>=20
> #
> # IP: Netfilter Configuration
> #
> # CONFIG_NF_DEFRAG_IPV4 is not set
> # CONFIG_IP_NF_QUEUE is not set
> # CONFIG_IP_NF_IPTABLES is not set
> # CONFIG_IP_NF_ARPTABLES is not set
>=20
> #
> # IPv6: Netfilter Configuration
> #
> # CONFIG_NF_DEFRAG_IPV6 is not set
> # CONFIG_IP6_NF_QUEUE is not set
> # CONFIG_IP6_NF_IPTABLES is not set
> # CONFIG_BRIDGE_NF_EBTABLES is not set
> # CONFIG_IP_DCCP is not set
> # CONFIG_IP_SCTP is not set
> # CONFIG_RDS is not set
> # CONFIG_TIPC is not set
> # CONFIG_ATM is not set
> # CONFIG_L2TP is not set
> CONFIG_STP=3Dy
> CONFIG_BRIDGE=3Dy
> CONFIG_BRIDGE_IGMP_SNOOPING=3Dy
> # CONFIG_NET_DSA is not set
> # CONFIG_VLAN_8021Q is not set
> # CONFIG_DECNET is not set
> CONFIG_LLC=3Dy
> # CONFIG_LLC2 is not set
> # CONFIG_IPX is not set
> # CONFIG_ATALK is not set
> # CONFIG_X25 is not set
> # CONFIG_LAPB is not set
> # CONFIG_ECONET is not set
> # CONFIG_WAN_ROUTER is not set
> # CONFIG_PHONET is not set
> # CONFIG_IEEE802154 is not set
> # CONFIG_NET_SCHED is not set
> # CONFIG_DCB is not set
> CONFIG_DNS_RESOLVER=3Dy
> CONFIG_BATMAN_ADV=3Dy
> CONFIG_BATMAN_ADV_DEBUG=3Dy
> CONFIG_RPS=3Dy
> CONFIG_RFS_ACCEL=3Dy
> CONFIG_XPS=3Dy
>=20
> #
> # Network testing
> #
> # CONFIG_NET_PKTGEN is not set
> # CONFIG_NET_TCPPROBE is not set
> # CONFIG_NET_DROP_MONITOR is not set
> # CONFIG_HAMRADIO is not set
> # CONFIG_CAN is not set
> # CONFIG_IRDA is not set
> CONFIG_BT=3Dm
> # CONFIG_BT_RFCOMM is not set
> # CONFIG_BT_BNEP is not set
> # CONFIG_BT_HIDP is not set
>=20
> #
> # Bluetooth device drivers
> #
> # CONFIG_BT_HCIBTUSB is not set
> # CONFIG_BT_HCIBTSDIO is not set
> CONFIG_BT_HCIUART=3Dm
> CONFIG_BT_HCIUART_H4=3Dy
> CONFIG_BT_HCIUART_BCSP=3Dy
> # CONFIG_BT_HCIUART_ATH3K is not set
> CONFIG_BT_HCIUART_LL=3Dy
> CONFIG_BT_HCIBCM203X=3Dm
> CONFIG_BT_HCIBPA10X=3Dm
> # CONFIG_BT_HCIBFUSB is not set
> # CONFIG_BT_HCIVHCI is not set
> # CONFIG_BT_MRVL is not set
> # CONFIG_AF_RXRPC is not set
> CONFIG_WIRELESS=3Dy
> CONFIG_WIRELESS_EXT=3Dy
> CONFIG_WEXT_CORE=3Dy
> CONFIG_WEXT_PROC=3Dy
> CONFIG_WEXT_SPY=3Dy
> CONFIG_CFG80211=3Dm
> # CONFIG_NL80211_TESTMODE is not set
> # CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
> # CONFIG_CFG80211_REG_DEBUG is not set
> CONFIG_CFG80211_DEFAULT_PS=3Dy
> CONFIG_CFG80211_DEBUGFS=3Dy
> # CONFIG_CFG80211_INTERNAL_REGDB is not set
> CONFIG_CFG80211_WEXT=3Dy
> CONFIG_WIRELESS_EXT_SYSFS=3Dy
> CONFIG_LIB80211=3Dm
> CONFIG_LIB80211_DEBUG=3Dy
> CONFIG_MAC80211=3Dm
> CONFIG_MAC80211_HAS_RC=3Dy
> CONFIG_MAC80211_RC_PID=3Dy
> CONFIG_MAC80211_RC_MINSTREL=3Dy
> CONFIG_MAC80211_RC_MINSTREL_HT=3Dy
> # CONFIG_MAC80211_RC_DEFAULT_PID is not set
> CONFIG_MAC80211_RC_DEFAULT_MINSTREL=3Dy
> CONFIG_MAC80211_RC_DEFAULT=3D"minstrel_ht"
> CONFIG_MAC80211_MESH=3Dy
> CONFIG_MAC80211_LEDS=3Dy
> CONFIG_MAC80211_DEBUGFS=3Dy
> CONFIG_MAC80211_DEBUG_MENU=3Dy
> # CONFIG_MAC80211_NOINLINE is not set
> CONFIG_MAC80211_VERBOSE_DEBUG=3Dy
> CONFIG_MAC80211_HT_DEBUG=3Dy
> # CONFIG_MAC80211_TKIP_DEBUG is not set
> CONFIG_MAC80211_IBSS_DEBUG=3Dy
> # CONFIG_MAC80211_VERBOSE_PS_DEBUG is not set
> CONFIG_MAC80211_VERBOSE_MPL_DEBUG=3Dy
> CONFIG_MAC80211_VERBOSE_MPATH_DEBUG=3Dy
> CONFIG_MAC80211_VERBOSE_MHWMP_DEBUG=3Dy
> # CONFIG_MAC80211_VERBOSE_TDLS_DEBUG is not set
> # CONFIG_MAC80211_DEBUG_COUNTERS is not set
> # CONFIG_WIMAX is not set
> # CONFIG_RFKILL is not set
> # CONFIG_RFKILL_REGULATOR is not set
> # CONFIG_NET_9P is not set
> # CONFIG_CAIF is not set
> # CONFIG_CEPH_LIB is not set
> # CONFIG_NFC is not set
>=20
> #
> # Device Drivers
> #
>=20
> #
> # Generic Driver Options
> #
> CONFIG_UEVENT_HELPER_PATH=3D"/sbin/hotplug"
> # CONFIG_DEVTMPFS is not set
> CONFIG_STANDALONE=3Dy
> CONFIG_PREVENT_FIRMWARE_BUILD=3Dy
> CONFIG_FW_LOADER=3Dy
> CONFIG_FIRMWARE_IN_KERNEL=3Dy
> CONFIG_EXTRA_FIRMWARE=3D""
> # CONFIG_DEBUG_DRIVER is not set
> # CONFIG_DEBUG_DEVRES is not set
> # CONFIG_SYS_HYPERVISOR is not set
> CONFIG_REGMAP=3Dy
> CONFIG_REGMAP_I2C=3Dy
> CONFIG_REGMAP_SPI=3Dm
>=20
> #
> # CBUS support
> #
> # CONFIG_CBUS is not set
> CONFIG_CONNECTOR=3Dy
> CONFIG_PROC_EVENTS=3Dy
> CONFIG_MTD=3Dy
> # CONFIG_MTD_TESTS is not set
> # CONFIG_MTD_REDBOOT_PARTS is not set
> CONFIG_MTD_CMDLINE_PARTS=3Dy
> # CONFIG_MTD_AFS_PARTS is not set
> # CONFIG_MTD_OF_PARTS is not set
> # CONFIG_MTD_AR7_PARTS is not set
>=20
> #
> # User Modules And Translation Layers
> #
> CONFIG_MTD_CHAR=3Dy
> CONFIG_MTD_BLKDEVS=3Dy
> CONFIG_MTD_BLOCK=3Dy
> # CONFIG_FTL is not set
> # CONFIG_NFTL is not set
> # CONFIG_INFTL is not set
> # CONFIG_RFD_FTL is not set
> # CONFIG_SSFDC is not set
> # CONFIG_SM_FTL is not set
> CONFIG_MTD_OOPS=3Dy
> # CONFIG_MTD_SWAP is not set
>=20
> #
> # RAM/ROM/Flash chip drivers
> #
> CONFIG_MTD_CFI=3Dy
> # CONFIG_MTD_JEDECPROBE is not set
> CONFIG_MTD_GEN_PROBE=3Dy
> # CONFIG_MTD_CFI_ADV_OPTIONS is not set
> CONFIG_MTD_MAP_BANK_WIDTH_1=3Dy
> CONFIG_MTD_MAP_BANK_WIDTH_2=3Dy
> CONFIG_MTD_MAP_BANK_WIDTH_4=3Dy
> # CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
> # CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
> # CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
> CONFIG_MTD_CFI_I1=3Dy
> CONFIG_MTD_CFI_I2=3Dy
> # CONFIG_MTD_CFI_I4 is not set
> # CONFIG_MTD_CFI_I8 is not set
> CONFIG_MTD_CFI_INTELEXT=3Dy
> # CONFIG_MTD_CFI_AMDSTD is not set
> # CONFIG_MTD_CFI_STAA is not set
> CONFIG_MTD_CFI_UTIL=3Dy
> # CONFIG_MTD_RAM is not set
> # CONFIG_MTD_ROM is not set
> # CONFIG_MTD_ABSENT is not set
>=20
> #
> # Mapping drivers for chip access
> #
> # CONFIG_MTD_COMPLEX_MAPPINGS is not set
> # CONFIG_MTD_PHYSMAP is not set
> # CONFIG_MTD_PHYSMAP_OF is not set
> # CONFIG_MTD_PLATRAM is not set
>=20
> #
> # Self-contained MTD device drivers
> #
> # CONFIG_MTD_DATAFLASH is not set
> # CONFIG_MTD_M25P80 is not set
> # CONFIG_MTD_SST25L is not set
> # CONFIG_MTD_SLRAM is not set
> # CONFIG_MTD_PHRAM is not set
> # CONFIG_MTD_MTDRAM is not set
> # CONFIG_MTD_BLOCK2MTD is not set
>=20
> #
> # Disk-On-Chip Device Drivers
> #
> # CONFIG_MTD_DOC2000 is not set
> # CONFIG_MTD_DOC2001 is not set
> # CONFIG_MTD_DOC2001PLUS is not set
> # CONFIG_MTD_DOCG3 is not set
> CONFIG_MTD_NAND_ECC=3Dy
> # CONFIG_MTD_NAND_ECC_SMC is not set
> CONFIG_MTD_NAND=3Dy
> # CONFIG_MTD_NAND_VERIFY_WRITE is not set
> # CONFIG_MTD_NAND_ECC_BCH is not set
> # CONFIG_MTD_SM_COMMON is not set
> # CONFIG_MTD_NAND_MUSEUM_IDS is not set
> # CONFIG_MTD_NAND_GPIO is not set
> CONFIG_MTD_NAND_OMAP2=3Dy
> CONFIG_MTD_NAND_IDS=3Dy
> # CONFIG_MTD_NAND_DISKONCHIP is not set
> # CONFIG_MTD_NAND_NANDSIM is not set
> # CONFIG_MTD_NAND_PLATFORM is not set
> # CONFIG_MTD_ALAUDA is not set
> CONFIG_MTD_ONENAND=3Dy
> CONFIG_MTD_ONENAND_VERIFY_WRITE=3Dy
> # CONFIG_MTD_ONENAND_GENERIC is not set
> CONFIG_MTD_ONENAND_OMAP2=3Dy
> # CONFIG_MTD_ONENAND_OTP is not set
> # CONFIG_MTD_ONENAND_2X_PROGRAM is not set
> # CONFIG_MTD_ONENAND_SIM is not set
>=20
> #
> # LPDDR flash memory drivers
> #
> # CONFIG_MTD_LPDDR is not set
> CONFIG_MTD_UBI=3Dy
> CONFIG_MTD_UBI_WL_THRESHOLD=3D4096
> CONFIG_MTD_UBI_BEB_RESERVE=3D1
> # CONFIG_MTD_UBI_GLUEBI is not set
> # CONFIG_MTD_UBI_DEBUG is not set
> CONFIG_DTC=3Dy
> CONFIG_OF=3Dy
>=20
> #
> # Device Tree and Open Firmware support
> #
> CONFIG_PROC_DEVICETREE=3Dy
> CONFIG_OF_FLATTREE=3Dy
> CONFIG_OF_EARLY_FLATTREE=3Dy
> CONFIG_OF_ADDRESS=3Dy
> CONFIG_OF_IRQ=3Dy
> CONFIG_OF_DEVICE=3Dy
> CONFIG_OF_GPIO=3Dy
> CONFIG_OF_I2C=3Dy
> CONFIG_OF_NET=3Dy
> CONFIG_OF_SPI=3Dy
> CONFIG_OF_MDIO=3Dy
> # CONFIG_PARPORT is not set
> CONFIG_BLK_DEV=3Dy
> # CONFIG_BLK_DEV_COW_COMMON is not set
> CONFIG_BLK_DEV_LOOP=3Dy
> CONFIG_BLK_DEV_LOOP_MIN_COUNT=3D8
> # CONFIG_BLK_DEV_CRYPTOLOOP is not set
> # CONFIG_BLK_DEV_DRBD is not set
> # CONFIG_BLK_DEV_NBD is not set
> # CONFIG_BLK_DEV_UB is not set
> CONFIG_BLK_DEV_RAM=3Dy
> CONFIG_BLK_DEV_RAM_COUNT=3D16
> CONFIG_BLK_DEV_RAM_SIZE=3D16384
> # CONFIG_BLK_DEV_XIP is not set
> # CONFIG_CDROM_PKTCDVD is not set
> # CONFIG_ATA_OVER_ETH is not set
> # CONFIG_MG_DISK is not set
> # CONFIG_BLK_DEV_RBD is not set
> # CONFIG_SENSORS_LIS3LV02D is not set
> # CONFIG_MISC_DEVICES is not set
>=20
> #
> # SCSI device support
> #
> CONFIG_SCSI_MOD=3Dy
> # CONFIG_RAID_ATTRS is not set
> CONFIG_SCSI=3Dy
> CONFIG_SCSI_DMA=3Dy
> # CONFIG_SCSI_TGT is not set
> # CONFIG_SCSI_NETLINK is not set
> CONFIG_SCSI_PROC_FS=3Dy
>=20
> #
> # SCSI support type (disk, tape, CD-ROM)
> #
> CONFIG_BLK_DEV_SD=3Dy
> # CONFIG_CHR_DEV_ST is not set
> # CONFIG_CHR_DEV_OSST is not set
> # CONFIG_BLK_DEV_SR is not set
> # CONFIG_CHR_DEV_SG is not set
> # CONFIG_CHR_DEV_SCH is not set
> CONFIG_SCSI_MULTI_LUN=3Dy
> # CONFIG_SCSI_CONSTANTS is not set
> # CONFIG_SCSI_LOGGING is not set
> CONFIG_SCSI_SCAN_ASYNC=3Dy
> CONFIG_SCSI_WAIT_SCAN=3Dm
>=20
> #
> # SCSI Transports
> #
> # CONFIG_SCSI_SPI_ATTRS is not set
> # CONFIG_SCSI_FC_ATTRS is not set
> # CONFIG_SCSI_ISCSI_ATTRS is not set
> # CONFIG_SCSI_SAS_ATTRS is not set
> # CONFIG_SCSI_SAS_LIBSAS is not set
> # CONFIG_SCSI_SRP_ATTRS is not set
> CONFIG_SCSI_LOWLEVEL=3Dy
> # CONFIG_ISCSI_TCP is not set
> # CONFIG_ISCSI_BOOT_SYSFS is not set
> # CONFIG_LIBFC is not set
> # CONFIG_LIBFCOE is not set
> # CONFIG_SCSI_DEBUG is not set
> # CONFIG_SCSI_DH is not set
> # CONFIG_SCSI_OSD_INITIATOR is not set
> # CONFIG_ATA is not set
> CONFIG_MD=3Dy
> # CONFIG_BLK_DEV_MD is not set
> # CONFIG_BLK_DEV_DM is not set
> # CONFIG_TARGET_CORE is not set
> CONFIG_NETDEVICES=3Dy
> CONFIG_NET_CORE=3Dy
> # CONFIG_BONDING is not set
> # CONFIG_DUMMY is not set
> # CONFIG_EQUALIZER is not set
> CONFIG_MII=3Dy
> # CONFIG_MACVLAN is not set
> # CONFIG_NETCONSOLE is not set
> # CONFIG_NETPOLL is not set
> # CONFIG_NET_POLL_CONTROLLER is not set
> # CONFIG_TUN is not set
> # CONFIG_VETH is not set
>=20
> #
> # CAIF transport drivers
> #
> CONFIG_ETHERNET=3Dy
> # CONFIG_NET_VENDOR_BROADCOM is not set
> # CONFIG_NET_VENDOR_CHELSIO is not set
> # CONFIG_DM9000 is not set
> # CONFIG_DNET is not set
> # CONFIG_NET_VENDOR_FARADAY is not set
> # CONFIG_NET_VENDOR_INTEL is not set
> # CONFIG_NET_VENDOR_MARVELL is not set
> # CONFIG_NET_VENDOR_MICREL is not set
> # CONFIG_NET_VENDOR_MICROCHIP is not set
> # CONFIG_NET_VENDOR_NATSEMI is not set
> # CONFIG_ETHOC is not set
> # CONFIG_NET_VENDOR_SEEQ is not set
> CONFIG_NET_VENDOR_SMSC=3Dy
> # CONFIG_SMC91X is not set
> # CONFIG_SMC911X is not set
> CONFIG_SMSC911X=3Dy
> # CONFIG_SMSC911X_ARCH_HOOKS is not set
> # CONFIG_NET_VENDOR_STMICRO is not set
> CONFIG_NET_VENDOR_TI=3Dy
> # CONFIG_TI_DAVINCI_EMAC is not set
> # CONFIG_TI_DAVINCI_MDIO is not set
> # CONFIG_TI_DAVINCI_CPDMA is not set
> CONFIG_PHYLIB=3Dy
>=20
> #
> # MII PHY device drivers
> #
> # CONFIG_MARVELL_PHY is not set
> # CONFIG_DAVICOM_PHY is not set
> # CONFIG_QSEMI_PHY is not set
> # CONFIG_LXT_PHY is not set
> # CONFIG_CICADA_PHY is not set
> # CONFIG_VITESSE_PHY is not set
> # CONFIG_SMSC_PHY is not set
> # CONFIG_BROADCOM_PHY is not set
> # CONFIG_ICPLUS_PHY is not set
> # CONFIG_REALTEK_PHY is not set
> # CONFIG_NATIONAL_PHY is not set
> # CONFIG_STE10XP is not set
> # CONFIG_LSI_ET1011C_PHY is not set
> # CONFIG_MICREL_PHY is not set
> # CONFIG_FIXED_PHY is not set
> # CONFIG_MDIO_BITBANG is not set
> # CONFIG_PPP is not set
> # CONFIG_SLIP is not set
>=20
> #
> # USB Network Adapters
> #
> # CONFIG_USB_CATC is not set
> # CONFIG_USB_KAWETH is not set
> # CONFIG_USB_PEGASUS is not set
> CONFIG_USB_RTL8150=3Dm
> CONFIG_USB_USBNET=3Dy
> CONFIG_USB_NET_AX8817X=3Dy
> CONFIG_USB_NET_CDCETHER=3Dy
> # CONFIG_USB_NET_CDC_EEM is not set
> CONFIG_USB_NET_CDC_NCM=3Dy
> # CONFIG_USB_NET_DM9601 is not set
> # CONFIG_USB_NET_SMSC75XX is not set
> # CONFIG_USB_NET_SMSC95XX is not set
> # CONFIG_USB_NET_GL620A is not set
> CONFIG_USB_NET_NET1080=3Dy
> # CONFIG_USB_NET_PLUSB is not set
> # CONFIG_USB_NET_MCS7830 is not set
> # CONFIG_USB_NET_RNDIS_HOST is not set
> CONFIG_USB_NET_CDC_SUBSET=3Dy
> CONFIG_USB_ALI_M5632=3Dy
> CONFIG_USB_AN2720=3Dy
> CONFIG_USB_BELKIN=3Dy
> CONFIG_USB_ARMLINUX=3Dy
> CONFIG_USB_EPSON2888=3Dy
> CONFIG_USB_KC2190=3Dy
> CONFIG_USB_NET_ZAURUS=3Dy
> # CONFIG_USB_NET_CX82310_ETH is not set
> # CONFIG_USB_NET_KALMIA is not set
> # CONFIG_USB_NET_INT51X1 is not set
> # CONFIG_USB_IPHETH is not set
> # CONFIG_USB_SIERRA_NET is not set
> # CONFIG_USB_VL600 is not set
> CONFIG_WLAN=3Dy
> # CONFIG_LIBERTAS_THINFIRM is not set
> # CONFIG_AT76C50X_USB is not set
> # CONFIG_USB_ZD1201 is not set
> # CONFIG_USB_NET_RNDIS_WLAN is not set
> # CONFIG_RTL8187 is not set
> # CONFIG_MAC80211_HWSIM is not set
> CONFIG_ATH_COMMON=3Dm
> CONFIG_ATH_DEBUG=3Dy
> CONFIG_ATH9K_HW=3Dm
> CONFIG_ATH9K_COMMON=3Dm
> CONFIG_ATH9K=3Dm
> CONFIG_ATH9K_AHB=3Dy
> CONFIG_ATH9K_DEBUGFS=3Dy
> # CONFIG_ATH9K_DFS_CERTIFIED is not set
> CONFIG_ATH9K_RATE_CONTROL=3Dy
> CONFIG_ATH9K_BTCOEX_SUPPORT=3Dy
> CONFIG_ATH9K_HTC=3Dm
> CONFIG_ATH9K_HTC_DEBUGFS=3Dy
> CONFIG_CARL9170=3Dm
> CONFIG_CARL9170_LEDS=3Dy
> CONFIG_CARL9170_DEBUGFS=3Dy
> CONFIG_CARL9170_WPC=3Dy
> # CONFIG_CARL9170_HWRNG is not set
> CONFIG_ATH6KL=3Dm
> CONFIG_ATH6KL_DEBUG=3Dy
> # CONFIG_B43 is not set
> # CONFIG_B43LEGACY is not set
> # CONFIG_BRCMFMAC is not set
> # CONFIG_HOSTAP is not set
> # CONFIG_IWM is not set
> CONFIG_LIBERTAS=3Dm
> CONFIG_LIBERTAS_USB=3Dm
> CONFIG_LIBERTAS_SDIO=3Dm
> # CONFIG_LIBERTAS_SPI is not set
> CONFIG_LIBERTAS_DEBUG=3Dy
> CONFIG_LIBERTAS_MESH=3Dy
> # CONFIG_P54_COMMON is not set
> CONFIG_RT2X00=3Dm
> CONFIG_RT2500USB=3Dm
> CONFIG_RT73USB=3Dm
> CONFIG_RT2800USB=3Dm
> CONFIG_RT2800USB_RT33XX=3Dy
> CONFIG_RT2800USB_RT35XX=3Dy
> CONFIG_RT2800USB_RT53XX=3Dy
> CONFIG_RT2800USB_UNKNOWN=3Dy
> CONFIG_RT2800_LIB=3Dm
> CONFIG_RT2X00_LIB_USB=3Dm
> CONFIG_RT2X00_LIB=3Dm
> CONFIG_RT2X00_LIB_FIRMWARE=3Dy
> CONFIG_RT2X00_LIB_CRYPTO=3Dy
> CONFIG_RT2X00_LIB_LEDS=3Dy
> # CONFIG_RT2X00_LIB_DEBUGFS is not set
> # CONFIG_RT2X00_DEBUG is not set
> # CONFIG_RTL8192CU is not set
> # CONFIG_WL1251 is not set
> # CONFIG_WL12XX_MENU is not set
> # CONFIG_ZD1211RW is not set
> # CONFIG_MWIFIEX is not set
>=20
> #
> # Enable WiMAX (Networking options) to see the WiMAX drivers
> #
> # CONFIG_WAN is not set
> # CONFIG_ISDN is not set
> # CONFIG_PHONE is not set
>=20
> #
> # Input device support
> #
> CONFIG_INPUT=3Dy
> # CONFIG_INPUT_FF_MEMLESS is not set
> # CONFIG_INPUT_POLLDEV is not set
> # CONFIG_INPUT_SPARSEKMAP is not set
>=20
> #
> # Userland interfaces
> #
> CONFIG_INPUT_MOUSEDEV=3Dy
> CONFIG_INPUT_MOUSEDEV_PSAUX=3Dy
> CONFIG_INPUT_MOUSEDEV_SCREEN_X=3D1024
> CONFIG_INPUT_MOUSEDEV_SCREEN_Y=3D768
> CONFIG_INPUT_JOYDEV=3Dy
> CONFIG_INPUT_EVDEV=3Dy
> # CONFIG_INPUT_EVBUG is not set
>=20
> #
> # Input Device Drivers
> #
> CONFIG_INPUT_KEYBOARD=3Dy
> # CONFIG_KEYBOARD_ADP5588 is not set
> # CONFIG_KEYBOARD_ADP5589 is not set
> CONFIG_KEYBOARD_ATKBD=3Dy
> # CONFIG_KEYBOARD_QT1070 is not set
> # CONFIG_KEYBOARD_QT2160 is not set
> # CONFIG_KEYBOARD_LKKBD is not set
> CONFIG_KEYBOARD_GPIO=3Dy
> # CONFIG_KEYBOARD_TCA6416 is not set
> # CONFIG_KEYBOARD_MATRIX is not set
> # CONFIG_KEYBOARD_LM8323 is not set
> # CONFIG_KEYBOARD_MAX7359 is not set
> # CONFIG_KEYBOARD_MCS is not set
> # CONFIG_KEYBOARD_MPR121 is not set
> # CONFIG_KEYBOARD_NEWTON is not set
> # CONFIG_KEYBOARD_OPENCORES is not set
> # CONFIG_KEYBOARD_STOWAWAY is not set
> # CONFIG_KEYBOARD_SUNKBD is not set
> # CONFIG_KEYBOARD_OMAP is not set
> # CONFIG_KEYBOARD_OMAP4 is not set
> CONFIG_KEYBOARD_TWL4030=3Dy
> # CONFIG_KEYBOARD_XTKBD is not set
> CONFIG_INPUT_MOUSE=3Dy
> CONFIG_MOUSE_PS2=3Dy
> CONFIG_MOUSE_PS2_ALPS=3Dy
> CONFIG_MOUSE_PS2_LOGIPS2PP=3Dy
> CONFIG_MOUSE_PS2_SYNAPTICS=3Dy
> CONFIG_MOUSE_PS2_TRACKPOINT=3Dy
> # CONFIG_MOUSE_PS2_ELANTECH is not set
> # CONFIG_MOUSE_PS2_SENTELIC is not set
> # CONFIG_MOUSE_PS2_TOUCHKIT is not set
> # CONFIG_MOUSE_SERIAL is not set
> # CONFIG_MOUSE_APPLETOUCH is not set
> # CONFIG_MOUSE_BCM5974 is not set
> # CONFIG_MOUSE_VSXXXAA is not set
> # CONFIG_MOUSE_GPIO is not set
> # CONFIG_MOUSE_SYNAPTICS_I2C is not set
> # CONFIG_INPUT_JOYSTICK is not set
> # CONFIG_INPUT_TABLET is not set
> CONFIG_INPUT_TOUCHSCREEN=3Dy
> CONFIG_TOUCHSCREEN_ADS7846=3Dy
> # CONFIG_TOUCHSCREEN_AD7877 is not set
> # CONFIG_TOUCHSCREEN_AD7879 is not set
> # CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
> # CONFIG_TOUCHSCREEN_BU21013 is not set
> # CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
> # CONFIG_TOUCHSCREEN_DYNAPRO is not set
> # CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
> # CONFIG_TOUCHSCREEN_EETI is not set
> # CONFIG_TOUCHSCREEN_FUJITSU is not set
> # CONFIG_TOUCHSCREEN_GUNZE is not set
> # CONFIG_TOUCHSCREEN_ELO is not set
> # CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
> # CONFIG_TOUCHSCREEN_MAX11801 is not set
> # CONFIG_TOUCHSCREEN_MCS5000 is not set
> # CONFIG_TOUCHSCREEN_MTOUCH is not set
> # CONFIG_TOUCHSCREEN_INEXIO is not set
> # CONFIG_TOUCHSCREEN_MK712 is not set
> # CONFIG_TOUCHSCREEN_PENMOUNT is not set
> # CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
> # CONFIG_TOUCHSCREEN_TOUCHWIN is not set
> # CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
> # CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
> # CONFIG_TOUCHSCREEN_TSC_SERIO is not set
> # CONFIG_TOUCHSCREEN_TSC2005 is not set
> # CONFIG_TOUCHSCREEN_TSC2007 is not set
> # CONFIG_TOUCHSCREEN_W90X900 is not set
> # CONFIG_TOUCHSCREEN_ST1232 is not set
> # CONFIG_TOUCHSCREEN_TPS6507X is not set
> CONFIG_INPUT_MISC=3Dy
> # CONFIG_INPUT_AD714X is not set
> # CONFIG_INPUT_BMA150 is not set
> # CONFIG_INPUT_MMA8450 is not set
> # CONFIG_INPUT_MPU3050 is not set
> # CONFIG_INPUT_ATI_REMOTE2 is not set
> # CONFIG_INPUT_KEYSPAN_REMOTE is not set
> # CONFIG_INPUT_KXTJ9 is not set
> # CONFIG_INPUT_POWERMATE is not set
> # CONFIG_INPUT_YEALINK is not set
> # CONFIG_INPUT_CM109 is not set
> CONFIG_INPUT_TWL4030_PWRBUTTON=3Dy
> # CONFIG_INPUT_TWL4030_VIBRA is not set
> # CONFIG_INPUT_TWL6040_VIBRA is not set
> # CONFIG_INPUT_UINPUT is not set
> # CONFIG_INPUT_PCF8574 is not set
> # CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
> # CONFIG_INPUT_ADXL34X is not set
> # CONFIG_INPUT_CMA3000 is not set
>=20
> #
> # Hardware I/O ports
> #
> CONFIG_SERIO=3Dy
> CONFIG_SERIO_SERPORT=3Dy
> CONFIG_SERIO_LIBPS2=3Dy
> # CONFIG_SERIO_RAW is not set
> # CONFIG_SERIO_ALTERA_PS2 is not set
> # CONFIG_SERIO_PS2MULT is not set
> # CONFIG_GAMEPORT is not set
>=20
> #
> # Character devices
> #
> CONFIG_VT=3Dy
> CONFIG_CONSOLE_TRANSLATIONS=3Dy
> CONFIG_VT_CONSOLE=3Dy
> CONFIG_VT_CONSOLE_SLEEP=3Dy
> CONFIG_HW_CONSOLE=3Dy
> CONFIG_VT_HW_CONSOLE_BINDING=3Dy
> CONFIG_UNIX98_PTYS=3Dy
> # CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
> # CONFIG_LEGACY_PTYS is not set
> # CONFIG_SERIAL_NONSTANDARD is not set
> # CONFIG_N_GSM is not set
> # CONFIG_TRACE_SINK is not set
> CONFIG_DEVKMEM=3Dy
>=20
> #
> # Serial drivers
> #
> CONFIG_SERIAL_8250=3Dy
> CONFIG_SERIAL_8250_CONSOLE=3Dy
> CONFIG_SERIAL_8250_NR_UARTS=3D32
> CONFIG_SERIAL_8250_RUNTIME_UARTS=3D4
> CONFIG_SERIAL_8250_EXTENDED=3Dy
> CONFIG_SERIAL_8250_MANY_PORTS=3Dy
> CONFIG_SERIAL_8250_SHARE_IRQ=3Dy
> CONFIG_SERIAL_8250_DETECT_IRQ=3Dy
> CONFIG_SERIAL_8250_RSA=3Dy
> # CONFIG_SERIAL_8250_DW is not set
>=20
> #
> # Non-8250 serial port support
> #
> # CONFIG_SERIAL_MAX3100 is not set
> # CONFIG_SERIAL_MAX3107 is not set
> CONFIG_SERIAL_CORE=3Dy
> CONFIG_SERIAL_CORE_CONSOLE=3Dy
> # CONFIG_SERIAL_OF_PLATFORM is not set
> CONFIG_SERIAL_OMAP=3Dy
> CONFIG_SERIAL_OMAP_CONSOLE=3Dy
> # CONFIG_SERIAL_TIMBERDALE is not set
> # CONFIG_SERIAL_ALTERA_JTAGUART is not set
> # CONFIG_SERIAL_ALTERA_UART is not set
> # CONFIG_SERIAL_IFX6X60 is not set
> # CONFIG_SERIAL_XILINX_PS_UART is not set
> # CONFIG_TTY_PRINTK is not set
> # CONFIG_HVC_DCC is not set
> # CONFIG_IPMI_HANDLER is not set
> CONFIG_HW_RANDOM=3Dy
> # CONFIG_HW_RANDOM_TIMERIOMEM is not set
> CONFIG_HW_RANDOM_OMAP=3Dy
> # CONFIG_R3964 is not set
> # CONFIG_RAW_DRIVER is not set
> # CONFIG_TCG_TPM is not set
> # CONFIG_RAMOOPS is not set
> CONFIG_I2C=3Dy
> CONFIG_I2C_BOARDINFO=3Dy
> CONFIG_I2C_COMPAT=3Dy
> CONFIG_I2C_CHARDEV=3Dy
> # CONFIG_I2C_MUX is not set
> CONFIG_I2C_HELPER_AUTO=3Dy
>=20
> #
> # I2C Hardware Bus support
> #
>=20
> #
> # I2C system bus drivers (mostly embedded / system-on-chip)
> #
> # CONFIG_I2C_DESIGNWARE_PLATFORM is not set
> # CONFIG_I2C_GPIO is not set
> # CONFIG_I2C_OCORES is not set
> CONFIG_I2C_OMAP=3Dy
> # CONFIG_I2C_PCA_PLATFORM is not set
> # CONFIG_I2C_PXA_PCI is not set
> # CONFIG_I2C_SIMTEC is not set
> # CONFIG_I2C_XILINX is not set
>=20
> #
> # External I2C/SMBus adapter drivers
> #
> # CONFIG_I2C_DIOLAN_U2C is not set
> # CONFIG_I2C_PARPORT_LIGHT is not set
> # CONFIG_I2C_TAOS_EVM is not set
> # CONFIG_I2C_TINY_USB is not set
>=20
> #
> # Other I2C/SMBus bus drivers
> #
> # CONFIG_I2C_STUB is not set
> # CONFIG_I2C_DEBUG_CORE is not set
> # CONFIG_I2C_DEBUG_ALGO is not set
> # CONFIG_I2C_DEBUG_BUS is not set
> CONFIG_SPI=3Dy
> # CONFIG_SPI_DEBUG is not set
> CONFIG_SPI_MASTER=3Dy
>=20
> #
> # SPI Master Controller Drivers
> #
> # CONFIG_SPI_ALTERA is not set
> # CONFIG_SPI_BITBANG is not set
> # CONFIG_SPI_GPIO is not set
> # CONFIG_SPI_OC_TINY is not set
> CONFIG_SPI_OMAP24XX=3Dy
> # CONFIG_SPI_PXA2XX_PCI is not set
> # CONFIG_SPI_XILINX is not set
> # CONFIG_SPI_DESIGNWARE is not set
>=20
> #
> # SPI Protocol Masters
> #
> # CONFIG_SPI_SPIDEV is not set
> # CONFIG_SPI_TLE62X0 is not set
>=20
> #
> # PPS support
> #
> # CONFIG_PPS is not set
>=20
> #
> # PPS generators support
> #
>=20
> #
> # PTP clock support
> #
>=20
> #
> # Enable Device Drivers -> PPS to see the PTP clock options.
> #
> CONFIG_ARCH_REQUIRE_GPIOLIB=3Dy
> CONFIG_GPIOLIB=3Dy
> CONFIG_DEBUG_GPIO=3Dy
> CONFIG_GPIO_SYSFS=3Dy
>=20
> #
> # Memory mapped GPIO drivers:
> #
> # CONFIG_GPIO_GENERIC_PLATFORM is not set
> # CONFIG_GPIO_IT8761E is not set
>=20
> #
> # I2C GPIO expanders:
> #
> # CONFIG_GPIO_MAX7300 is not set
> # CONFIG_GPIO_MAX732X is not set
> # CONFIG_GPIO_PCF857X is not set
> # CONFIG_GPIO_SX150X is not set
> CONFIG_GPIO_TWL4030=3Dy
> # CONFIG_GPIO_ADP5588 is not set
>=20
> #
> # PCI GPIO expanders:
> #
>=20
> #
> # SPI GPIO expanders:
> #
> # CONFIG_GPIO_MAX7301 is not set
> # CONFIG_GPIO_MCP23S08 is not set
> # CONFIG_GPIO_MC33880 is not set
> # CONFIG_GPIO_74X164 is not set
>=20
> #
> # AC97 GPIO expanders:
> #
>=20
> #
> # MODULbus GPIO expanders:
> #
> CONFIG_W1=3Dy
> CONFIG_W1_CON=3Dy
>=20
> #
> # 1-wire Bus Masters
> #
> # CONFIG_W1_MASTER_DS2490 is not set
> # CONFIG_W1_MASTER_DS2482 is not set
> # CONFIG_W1_MASTER_DS1WM is not set
> # CONFIG_W1_MASTER_GPIO is not set
> # CONFIG_HDQ_MASTER_OMAP is not set
>=20
> #
> # 1-wire Slaves
> #
> # CONFIG_W1_SLAVE_THERM is not set
> # CONFIG_W1_SLAVE_SMEM is not set
> # CONFIG_W1_SLAVE_DS2408 is not set
> # CONFIG_W1_SLAVE_DS2423 is not set
> # CONFIG_W1_SLAVE_DS2431 is not set
> # CONFIG_W1_SLAVE_DS2433 is not set
> # CONFIG_W1_SLAVE_DS2760 is not set
> # CONFIG_W1_SLAVE_DS2780 is not set
> # CONFIG_W1_SLAVE_BQ27000 is not set
> CONFIG_POWER_SUPPLY=3Dy
> # CONFIG_POWER_SUPPLY_DEBUG is not set
> # CONFIG_PDA_POWER is not set
> # CONFIG_TEST_POWER is not set
> # CONFIG_BATTERY_DS2780 is not set
> # CONFIG_BATTERY_DS2782 is not set
> # CONFIG_BATTERY_BQ20Z75 is not set
> # CONFIG_BATTERY_BQ27x00 is not set
> # CONFIG_BATTERY_MAX17040 is not set
> # CONFIG_BATTERY_MAX17042 is not set
> # CONFIG_CHARGER_ISP1704 is not set
> # CONFIG_CHARGER_MAX8903 is not set
> # CONFIG_CHARGER_TWL4030 is not set
> # CONFIG_CHARGER_GPIO is not set
> CONFIG_HWMON=3Dy
> # CONFIG_HWMON_VID is not set
> # CONFIG_HWMON_DEBUG_CHIP is not set
>=20
> #
> # Native drivers
> #
> # CONFIG_SENSORS_AD7314 is not set
> # CONFIG_SENSORS_AD7414 is not set
> # CONFIG_SENSORS_AD7418 is not set
> # CONFIG_SENSORS_ADCXX is not set
> # CONFIG_SENSORS_ADM1021 is not set
> # CONFIG_SENSORS_ADM1025 is not set
> # CONFIG_SENSORS_ADM1026 is not set
> # CONFIG_SENSORS_ADM1029 is not set
> # CONFIG_SENSORS_ADM1031 is not set
> # CONFIG_SENSORS_ADM9240 is not set
> # CONFIG_SENSORS_ADT7411 is not set
> # CONFIG_SENSORS_ADT7462 is not set
> # CONFIG_SENSORS_ADT7470 is not set
> # CONFIG_SENSORS_ADT7475 is not set
> # CONFIG_SENSORS_ASC7621 is not set
> # CONFIG_SENSORS_ATXP1 is not set
> # CONFIG_SENSORS_DS620 is not set
> # CONFIG_SENSORS_DS1621 is not set
> # CONFIG_SENSORS_F71805F is not set
> # CONFIG_SENSORS_F71882FG is not set
> # CONFIG_SENSORS_F75375S is not set
> # CONFIG_SENSORS_G760A is not set
> # CONFIG_SENSORS_GL518SM is not set
> # CONFIG_SENSORS_GL520SM is not set
> # CONFIG_SENSORS_GPIO_FAN is not set
> # CONFIG_SENSORS_IT87 is not set
> # CONFIG_SENSORS_JC42 is not set
> # CONFIG_SENSORS_LINEAGE is not set
> # CONFIG_SENSORS_LM63 is not set
> # CONFIG_SENSORS_LM70 is not set
> # CONFIG_SENSORS_LM73 is not set
> # CONFIG_SENSORS_LM75 is not set
> # CONFIG_SENSORS_LM77 is not set
> # CONFIG_SENSORS_LM78 is not set
> # CONFIG_SENSORS_LM80 is not set
> # CONFIG_SENSORS_LM83 is not set
> # CONFIG_SENSORS_LM85 is not set
> # CONFIG_SENSORS_LM87 is not set
> # CONFIG_SENSORS_LM90 is not set
> # CONFIG_SENSORS_LM92 is not set
> # CONFIG_SENSORS_LM93 is not set
> # CONFIG_SENSORS_LTC4151 is not set
> # CONFIG_SENSORS_LTC4215 is not set
> # CONFIG_SENSORS_LTC4245 is not set
> # CONFIG_SENSORS_LTC4261 is not set
> # CONFIG_SENSORS_LM95241 is not set
> # CONFIG_SENSORS_LM95245 is not set
> # CONFIG_SENSORS_MAX1111 is not set
> # CONFIG_SENSORS_MAX16065 is not set
> # CONFIG_SENSORS_MAX1619 is not set
> # CONFIG_SENSORS_MAX1668 is not set
> # CONFIG_SENSORS_MAX6639 is not set
> # CONFIG_SENSORS_MAX6642 is not set
> # CONFIG_SENSORS_MAX6650 is not set
> # CONFIG_SENSORS_NTC_THERMISTOR is not set
> # CONFIG_SENSORS_PC87360 is not set
> # CONFIG_SENSORS_PC87427 is not set
> # CONFIG_SENSORS_PCF8591 is not set
> # CONFIG_PMBUS is not set
> # CONFIG_SENSORS_SHT15 is not set
> # CONFIG_SENSORS_SHT21 is not set
> # CONFIG_SENSORS_SMM665 is not set
> # CONFIG_SENSORS_DME1737 is not set
> # CONFIG_SENSORS_EMC1403 is not set
> # CONFIG_SENSORS_EMC2103 is not set
> # CONFIG_SENSORS_EMC6W201 is not set
> # CONFIG_SENSORS_SMSC47M1 is not set
> # CONFIG_SENSORS_SMSC47M192 is not set
> # CONFIG_SENSORS_SMSC47B397 is not set
> # CONFIG_SENSORS_SCH56XX_COMMON is not set
> # CONFIG_SENSORS_SCH5627 is not set
> # CONFIG_SENSORS_SCH5636 is not set
> # CONFIG_SENSORS_ADS1015 is not set
> # CONFIG_SENSORS_ADS7828 is not set
> # CONFIG_SENSORS_ADS7871 is not set
> # CONFIG_SENSORS_AMC6821 is not set
> # CONFIG_SENSORS_THMC50 is not set
> # CONFIG_SENSORS_TMP102 is not set
> # CONFIG_SENSORS_TMP401 is not set
> # CONFIG_SENSORS_TMP421 is not set
> # CONFIG_SENSORS_VT1211 is not set
> # CONFIG_SENSORS_W83781D is not set
> # CONFIG_SENSORS_W83791D is not set
> # CONFIG_SENSORS_W83792D is not set
> # CONFIG_SENSORS_W83793 is not set
> # CONFIG_SENSORS_W83795 is not set
> # CONFIG_SENSORS_W83L785TS is not set
> # CONFIG_SENSORS_W83L786NG is not set
> # CONFIG_SENSORS_W83627HF is not set
> # CONFIG_SENSORS_W83627EHF is not set
> # CONFIG_THERMAL is not set
> CONFIG_WATCHDOG=3Dy
> # CONFIG_WATCHDOG_CORE is not set
> # CONFIG_WATCHDOG_NOWAYOUT is not set
>=20
> #
> # Watchdog Device Drivers
> #
> # CONFIG_SOFT_WATCHDOG is not set
> # CONFIG_DW_WATCHDOG is not set
> # CONFIG_MPCORE_WATCHDOG is not set
> CONFIG_OMAP_WATCHDOG=3Dy
> CONFIG_TWL4030_WATCHDOG=3Dy
> # CONFIG_MAX63XX_WATCHDOG is not set
>=20
> #
> # USB-based Watchdog Cards
> #
> # CONFIG_USBPCWATCHDOG is not set
> CONFIG_SSB_POSSIBLE=3Dy
>=20
> #
> # Sonics Silicon Backplane
> #
> # CONFIG_SSB is not set
> CONFIG_BCMA_POSSIBLE=3Dy
>=20
> #
> # Broadcom specific AMBA
> #
> # CONFIG_BCMA is not set
>=20
> #
> # Multifunction device drivers
> #
> CONFIG_MFD_CORE=3Dy
> # CONFIG_MFD_88PM860X is not set
> # CONFIG_MFD_SM501 is not set
> # CONFIG_MFD_ASIC3 is not set
> # CONFIG_HTC_EGPIO is not set
> # CONFIG_HTC_PASIC3 is not set
> # CONFIG_HTC_I2CPLD is not set
> # CONFIG_TPS6105X is not set
> # CONFIG_TPS65010 is not set
> # CONFIG_TPS6507X is not set
> # CONFIG_MFD_TPS6586X is not set
> # CONFIG_MFD_TPS65910 is not set
> # CONFIG_MFD_TPS65912_I2C is not set
> # CONFIG_MFD_TPS65912_SPI is not set
> CONFIG_MENELAUS=3Dy
> CONFIG_TWL4030_CORE=3Dy
> # CONFIG_TWL4030_MADC is not set
> CONFIG_TWL4030_POWER=3Dy
> CONFIG_MFD_TWL4030_AUDIO=3Dy
> # CONFIG_TWL6030_PWM is not set
> # CONFIG_TWL6040_CORE is not set
> # CONFIG_MFD_STMPE is not set
> # CONFIG_MFD_TC3589X is not set
> # CONFIG_MFD_TMIO is not set
> # CONFIG_MFD_T7L66XB is not set
> # CONFIG_MFD_TC6387XB is not set
> # CONFIG_MFD_TC6393XB is not set
> # CONFIG_PMIC_DA903X is not set
> # CONFIG_PMIC_ADP5520 is not set
> # CONFIG_MFD_MAX8925 is not set
> # CONFIG_MFD_MAX8997 is not set
> # CONFIG_MFD_MAX8998 is not set
> # CONFIG_MFD_WM8400 is not set
> # CONFIG_MFD_WM831X_I2C is not set
> # CONFIG_MFD_WM831X_SPI is not set
> # CONFIG_MFD_WM8350_I2C is not set
> # CONFIG_MFD_WM8994 is not set
> # CONFIG_MFD_PCF50633 is not set
> # CONFIG_MFD_MC13XXX is not set
> # CONFIG_ABX500_CORE is not set
> # CONFIG_EZX_PCAP is not set
> # CONFIG_MFD_WL1273_CORE is not set
> CONFIG_MFD_OMAP_USB_HOST=3Dy
> # CONFIG_MFD_AAT2870_CORE is not set
> CONFIG_REGULATOR=3Dy
> # CONFIG_REGULATOR_DEBUG is not set
> # CONFIG_REGULATOR_DUMMY is not set
> CONFIG_REGULATOR_FIXED_VOLTAGE=3Dy
> # CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
> # CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
> # CONFIG_REGULATOR_GPIO is not set
> # CONFIG_REGULATOR_BQ24022 is not set
> # CONFIG_REGULATOR_MAX1586 is not set
> # CONFIG_REGULATOR_MAX8649 is not set
> # CONFIG_REGULATOR_MAX8660 is not set
> # CONFIG_REGULATOR_MAX8952 is not set
> CONFIG_REGULATOR_TWL4030=3Dy
> # CONFIG_REGULATOR_LP3971 is not set
> # CONFIG_REGULATOR_LP3972 is not set
> CONFIG_REGULATOR_TPS65023=3Dy
> CONFIG_REGULATOR_TPS6507X=3Dy
> # CONFIG_REGULATOR_ISL6271A is not set
> # CONFIG_REGULATOR_AD5398 is not set
> # CONFIG_REGULATOR_TPS6524X is not set
> # CONFIG_MEDIA_SUPPORT is not set
>=20
> #
> # Graphics support
> #
> # CONFIG_DRM is not set
> # CONFIG_VGASTATE is not set
> # CONFIG_VIDEO_OUTPUT_CONTROL is not set
> CONFIG_FB=3Dy
> CONFIG_FIRMWARE_EDID=3Dy
> # CONFIG_FB_DDC is not set
> # CONFIG_FB_BOOT_VESA_SUPPORT is not set
> CONFIG_FB_CFB_FILLRECT=3Dm
> CONFIG_FB_CFB_COPYAREA=3Dm
> CONFIG_FB_CFB_IMAGEBLIT=3Dm
> # CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
> # CONFIG_FB_SYS_FILLRECT is not set
> # CONFIG_FB_SYS_COPYAREA is not set
> # CONFIG_FB_SYS_IMAGEBLIT is not set
> # CONFIG_FB_FOREIGN_ENDIAN is not set
> # CONFIG_FB_SYS_FOPS is not set
> # CONFIG_FB_WMT_GE_ROPS is not set
> # CONFIG_FB_SVGALIB is not set
> # CONFIG_FB_MACMODES is not set
> # CONFIG_FB_BACKLIGHT is not set
> CONFIG_FB_MODE_HELPERS=3Dy
> CONFIG_FB_TILEBLITTING=3Dy
>=20
> #
> # Frame buffer hardware drivers
> #
> # CONFIG_FB_UVESA is not set
> # CONFIG_FB_S1D13XXX is not set
> # CONFIG_FB_TMIO is not set
> # CONFIG_FB_SMSCUFX is not set
> # CONFIG_FB_UDL is not set
> # CONFIG_FB_VIRTUAL is not set
> # CONFIG_FB_METRONOME is not set
> # CONFIG_FB_BROADSHEET is not set
> # CONFIG_FB_OMAP_BOOTLOADER_INIT is not set
> CONFIG_OMAP2_VRAM=3Dy
> CONFIG_OMAP2_VRFB=3Dy
> CONFIG_OMAP2_DSS=3Dm
> CONFIG_OMAP2_VRAM_SIZE=3D0
> CONFIG_OMAP2_DSS_DEBUG_SUPPORT=3Dy
> # CONFIG_OMAP2_DSS_COLLECT_IRQ_STATS is not set
> CONFIG_OMAP2_DSS_DPI=3Dy
> CONFIG_OMAP2_DSS_RFBI=3Dy
> CONFIG_OMAP2_DSS_VENC=3Dy
> CONFIG_OMAP4_DSS_HDMI=3Dy
> CONFIG_OMAP2_DSS_SDI=3Dy
> CONFIG_OMAP2_DSS_DSI=3Dy
> # CONFIG_OMAP2_DSS_FAKE_VSYNC is not set
> CONFIG_OMAP2_DSS_MIN_FCK_PER_PCK=3D0
> CONFIG_OMAP2_DSS_SLEEP_AFTER_VENC_RESET=3Dy
> CONFIG_FB_OMAP2=3Dm
> CONFIG_FB_OMAP2_DEBUG_SUPPORT=3Dy
> CONFIG_FB_OMAP2_NUM_FBS=3D3
>=20
> #
> # OMAP2/3 Display Device Drivers
> #
> CONFIG_PANEL_GENERIC_DPI=3Dm
> # CONFIG_PANEL_DVI is not set
> # CONFIG_PANEL_LGPHILIPS_LB035Q02 is not set
> CONFIG_PANEL_SHARP_LS037V7DW01=3Dm
> CONFIG_PANEL_NEC_NL8048HL11_01B=3Dm
> # CONFIG_PANEL_PICODLP is not set
> CONFIG_PANEL_TAAL=3Dm
> CONFIG_PANEL_TPO_TD043MTEA1=3Dm
> CONFIG_PANEL_ACX565AKM=3Dm
> # CONFIG_PANEL_N8X0 is not set
> CONFIG_BACKLIGHT_LCD_SUPPORT=3Dy
> CONFIG_LCD_CLASS_DEVICE=3Dy
> # CONFIG_LCD_L4F00242T03 is not set
> # CONFIG_LCD_LMS283GF05 is not set
> # CONFIG_LCD_LTV350QV is not set
> # CONFIG_LCD_TDO24M is not set
> # CONFIG_LCD_VGG2432A4 is not set
> CONFIG_LCD_PLATFORM=3Dy
> # CONFIG_LCD_S6E63M0 is not set
> # CONFIG_LCD_LD9040 is not set
> # CONFIG_LCD_AMS369FG06 is not set
> CONFIG_BACKLIGHT_CLASS_DEVICE=3Dy
> CONFIG_BACKLIGHT_GENERIC=3Dy
> # CONFIG_BACKLIGHT_ADP8860 is not set
> # CONFIG_BACKLIGHT_ADP8870 is not set
>=20
> #
> # Display device support
> #
> CONFIG_DISPLAY_SUPPORT=3Dy
>=20
> #
> # Display hardware drivers
> #
>=20
> #
> # Console display driver support
> #
> CONFIG_DUMMY_CONSOLE=3Dy
> CONFIG_FRAMEBUFFER_CONSOLE=3Dy
> # CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
> CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=3Dy
> CONFIG_FONTS=3Dy
> CONFIG_FONT_8x8=3Dy
> CONFIG_FONT_8x16=3Dy
> # CONFIG_FONT_6x11 is not set
> # CONFIG_FONT_7x14 is not set
> # CONFIG_FONT_PEARL_8x8 is not set
> # CONFIG_FONT_ACORN_8x8 is not set
> # CONFIG_FONT_MINI_4x6 is not set
> # CONFIG_FONT_SUN8x16 is not set
> # CONFIG_FONT_SUN12x22 is not set
> # CONFIG_FONT_10x18 is not set
> CONFIG_LOGO=3Dy
> CONFIG_LOGO_LINUX_MONO=3Dy
> CONFIG_LOGO_LINUX_VGA16=3Dy
> CONFIG_LOGO_LINUX_CLUT224=3Dy
> CONFIG_SOUND=3Dm
> CONFIG_SOUND_OSS_CORE=3Dy
> CONFIG_SOUND_OSS_CORE_PRECLAIM=3Dy
> CONFIG_SND=3Dm
> CONFIG_SND_TIMER=3Dm
> CONFIG_SND_PCM=3Dm
> CONFIG_SND_HWDEP=3Dm
> CONFIG_SND_RAWMIDI=3Dm
> CONFIG_SND_JACK=3Dy
> # CONFIG_SND_SEQUENCER is not set
> CONFIG_SND_OSSEMUL=3Dy
> CONFIG_SND_MIXER_OSS=3Dm
> CONFIG_SND_PCM_OSS=3Dm
> CONFIG_SND_PCM_OSS_PLUGINS=3Dy
> # CONFIG_SND_HRTIMER is not set
> # CONFIG_SND_DYNAMIC_MINORS is not set
> CONFIG_SND_SUPPORT_OLD_API=3Dy
> CONFIG_SND_VERBOSE_PROCFS=3Dy
> CONFIG_SND_VERBOSE_PRINTK=3Dy
> CONFIG_SND_DEBUG=3Dy
> # CONFIG_SND_DEBUG_VERBOSE is not set
> # CONFIG_SND_PCM_XRUN_DEBUG is not set
> # CONFIG_SND_RAWMIDI_SEQ is not set
> # CONFIG_SND_OPL3_LIB_SEQ is not set
> # CONFIG_SND_OPL4_LIB_SEQ is not set
> # CONFIG_SND_SBAWE_SEQ is not set
> # CONFIG_SND_EMU10K1_SEQ is not set
> CONFIG_SND_DRIVERS=3Dy
> # CONFIG_SND_DUMMY is not set
> # CONFIG_SND_ALOOP is not set
> # CONFIG_SND_MTPAV is not set
> # CONFIG_SND_SERIAL_U16550 is not set
> # CONFIG_SND_MPU401 is not set
> CONFIG_SND_ARM=3Dy
> CONFIG_SND_SPI=3Dy
> CONFIG_SND_USB=3Dy
> CONFIG_SND_USB_AUDIO=3Dm
> # CONFIG_SND_USB_UA101 is not set
> # CONFIG_SND_USB_CAIAQ is not set
> # CONFIG_SND_USB_6FIRE is not set
> CONFIG_SND_SOC=3Dm
> # CONFIG_SND_SOC_CACHE_LZO is not set
> CONFIG_SND_OMAP_SOC=3Dm
> CONFIG_SND_OMAP_SOC_MCBSP=3Dm
> # CONFIG_SND_OMAP_SOC_N810 is not set
> # CONFIG_SND_OMAP_SOC_RX51 is not set
> # CONFIG_SND_OMAP_SOC_OVERO is not set
> # CONFIG_SND_OMAP_SOC_OMAP3EVM is not set
> # CONFIG_SND_OMAP_SOC_AM3517EVM is not set
> # CONFIG_SND_OMAP_SOC_SDP3430 is not set
> # CONFIG_SND_OMAP_SOC_SDP4430 is not set
> # CONFIG_SND_OMAP_SOC_OMAP4_HDMI is not set
> CONFIG_SND_OMAP_SOC_OMAP3_PANDORA=3Dm
> # CONFIG_SND_OMAP_SOC_OMAP3_BEAGLE is not set
> # CONFIG_SND_OMAP_SOC_ZOOM2 is not set
> # CONFIG_SND_OMAP_SOC_IGEP0020 is not set
> CONFIG_SND_SOC_I2C_AND_SPI=3Dm
> # CONFIG_SND_SOC_ALL_CODECS is not set
> CONFIG_SND_SOC_TWL4030=3Dm
> # CONFIG_SOUND_PRIME is not set
> CONFIG_HID_SUPPORT=3Dy
> CONFIG_HID=3Dy
> # CONFIG_HIDRAW is not set
>=20
> #
> # USB Input Devices
> #
> CONFIG_USB_HID=3Dy
> # CONFIG_HID_PID is not set
> # CONFIG_USB_HIDDEV is not set
>=20
> #
> # Special HID drivers
> #
> # CONFIG_HID_A4TECH is not set
> # CONFIG_HID_ACRUX is not set
> # CONFIG_HID_APPLE is not set
> # CONFIG_HID_BELKIN is not set
> # CONFIG_HID_CHERRY is not set
> # CONFIG_HID_CHICONY is not set
> # CONFIG_HID_PRODIKEYS is not set
> # CONFIG_HID_CYPRESS is not set
> # CONFIG_HID_DRAGONRISE is not set
> # CONFIG_HID_EMS_FF is not set
> # CONFIG_HID_EZKEY is not set
> # CONFIG_HID_HOLTEK is not set
> # CONFIG_HID_KEYTOUCH is not set
> # CONFIG_HID_KYE is not set
> # CONFIG_HID_UCLOGIC is not set
> # CONFIG_HID_WALTOP is not set
> # CONFIG_HID_GYRATION is not set
> # CONFIG_HID_TWINHAN is not set
> # CONFIG_HID_KENSINGTON is not set
> # CONFIG_HID_LCPOWER is not set
> # CONFIG_HID_LOGITECH is not set
> # CONFIG_HID_MICROSOFT is not set
> # CONFIG_HID_MONTEREY is not set
> # CONFIG_HID_MULTITOUCH is not set
> # CONFIG_HID_NTRIG is not set
> # CONFIG_HID_ORTEK is not set
> # CONFIG_HID_PANTHERLORD is not set
> # CONFIG_HID_PETALYNX is not set
> # CONFIG_HID_PICOLCD is not set
> # CONFIG_HID_PRIMAX is not set
> # CONFIG_HID_QUANTA is not set
> # CONFIG_HID_ROCCAT is not set
> # CONFIG_HID_SAMSUNG is not set
> # CONFIG_HID_SONY is not set
> # CONFIG_HID_SPEEDLINK is not set
> # CONFIG_HID_SUNPLUS is not set
> # CONFIG_HID_GREENASIA is not set
> # CONFIG_HID_SMARTJOYPLUS is not set
> # CONFIG_HID_TOPSEED is not set
> # CONFIG_HID_THRUSTMASTER is not set
> # CONFIG_HID_ZEROPLUS is not set
> # CONFIG_HID_ZYDACRON is not set
> CONFIG_USB_SUPPORT=3Dy
> CONFIG_USB_COMMON=3Dy
> CONFIG_USB_ARCH_HAS_HCD=3Dy
> CONFIG_USB_ARCH_HAS_OHCI=3Dy
> CONFIG_USB_ARCH_HAS_EHCI=3Dy
> # CONFIG_USB_ARCH_HAS_XHCI is not set
> CONFIG_USB=3Dy
> CONFIG_USB_DEBUG=3Dy
> CONFIG_USB_ANNOUNCE_NEW_DEVICES=3Dy
>=20
> #
> # Miscellaneous USB options
> #
> CONFIG_USB_DEVICEFS=3Dy
> CONFIG_USB_DEVICE_CLASS=3Dy
> # CONFIG_USB_DYNAMIC_MINORS is not set
> CONFIG_USB_SUSPEND=3Dy
> # CONFIG_USB_OTG is not set
> # CONFIG_USB_OTG_WHITELIST is not set
> # CONFIG_USB_OTG_BLACKLIST_HUB is not set
> # CONFIG_USB_DWC3 is not set
> CONFIG_USB_MON=3Dy
> # CONFIG_USB_WUSB is not set
> # CONFIG_USB_WUSB_CBAF is not set
>=20
> #
> # USB Host Controller Drivers
> #
> # CONFIG_USB_C67X00_HCD is not set
> CONFIG_USB_EHCI_HCD=3Dy
> CONFIG_USB_EHCI_ROOT_HUB_TT=3Dy
> CONFIG_USB_EHCI_TT_NEWSCHED=3Dy
> CONFIG_USB_EHCI_HCD_OMAP=3Dy
> # CONFIG_USB_OXU210HP_HCD is not set
> # CONFIG_USB_ISP116X_HCD is not set
> # CONFIG_USB_ISP1760_HCD is not set
> # CONFIG_USB_ISP1362_HCD is not set
> # CONFIG_USB_OHCI_HCD is not set
> # CONFIG_USB_SL811_HCD is not set
> # CONFIG_USB_R8A66597_HCD is not set
> # CONFIG_USB_HWA_HCD is not set
> CONFIG_USB_MUSB_HDRC=3Dy
> # CONFIG_USB_MUSB_TUSB6010 is not set
> CONFIG_USB_MUSB_OMAP2PLUS=3Dy
> # CONFIG_USB_MUSB_AM35X is not set
> # CONFIG_MUSB_PIO_ONLY is not set
> # CONFIG_USB_UX500_DMA is not set
> CONFIG_USB_INVENTRA_DMA=3Dy
> # CONFIG_USB_TI_CPPI_DMA is not set
> # CONFIG_USB_RENESAS_USBHS is not set
>=20
> #
> # USB Device Class drivers
> #
> # CONFIG_USB_ACM is not set
> # CONFIG_USB_PRINTER is not set
> CONFIG_USB_WDM=3Dy
> # CONFIG_USB_TMC is not set
>=20
> #
> # NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
> #
>=20
> #
> # also be needed; see USB_STORAGE Help for more info
> #
> CONFIG_USB_STORAGE=3Dy
> # CONFIG_USB_STORAGE_DEBUG is not set
> # CONFIG_USB_STORAGE_REALTEK is not set
> # CONFIG_USB_STORAGE_DATAFAB is not set
> # CONFIG_USB_STORAGE_FREECOM is not set
> # CONFIG_USB_STORAGE_ISD200 is not set
> # CONFIG_USB_STORAGE_USBAT is not set
> # CONFIG_USB_STORAGE_SDDR09 is not set
> # CONFIG_USB_STORAGE_SDDR55 is not set
> # CONFIG_USB_STORAGE_JUMPSHOT is not set
> # CONFIG_USB_STORAGE_ALAUDA is not set
> # CONFIG_USB_STORAGE_ONETOUCH is not set
> # CONFIG_USB_STORAGE_KARMA is not set
> # CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
> # CONFIG_USB_STORAGE_ENE_UB6250 is not set
> # CONFIG_USB_UAS is not set
> CONFIG_USB_LIBUSUAL=3Dy
>=20
> #
> # USB Imaging devices
> #
> # CONFIG_USB_MDC800 is not set
> # CONFIG_USB_MICROTEK is not set
>=20
> #
> # USB port drivers
> #
> # CONFIG_USB_SERIAL is not set
>=20
> #
> # USB Miscellaneous drivers
> #
> # CONFIG_USB_EMI62 is not set
> # CONFIG_USB_EMI26 is not set
> # CONFIG_USB_ADUTUX is not set
> # CONFIG_USB_SEVSEG is not set
> # CONFIG_USB_RIO500 is not set
> # CONFIG_USB_LEGOTOWER is not set
> # CONFIG_USB_LCD is not set
> # CONFIG_USB_LED is not set
> # CONFIG_USB_CYPRESS_CY7C63 is not set
> # CONFIG_USB_CYTHERM is not set
> # CONFIG_USB_IDMOUSE is not set
> # CONFIG_USB_FTDI_ELAN is not set
> # CONFIG_USB_APPLEDISPLAY is not set
> # CONFIG_USB_SISUSBVGA is not set
> # CONFIG_USB_LD is not set
> # CONFIG_USB_TRANCEVIBRATOR is not set
> # CONFIG_USB_IOWARRIOR is not set
> CONFIG_USB_TEST=3Dy
> # CONFIG_USB_ISIGHTFW is not set
> # CONFIG_USB_YUREX is not set
> CONFIG_USB_GADGET=3Dy
> CONFIG_USB_GADGET_DEBUG=3Dy
> CONFIG_USB_GADGET_DEBUG_FILES=3Dy
> CONFIG_USB_GADGET_DEBUG_FS=3Dy
> CONFIG_USB_GADGET_VBUS_DRAW=3D2
> CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=3D2
> # CONFIG_USB_FUSB300 is not set
> # CONFIG_USB_OMAP is not set
> # CONFIG_USB_R8A66597 is not set
> # CONFIG_USB_GADGET_MUSB_HDRC is not set
> # CONFIG_USB_M66592 is not set
> # CONFIG_USB_NET2272 is not set
> # CONFIG_USB_DUMMY_HCD is not set
> CONFIG_USB_GADGET_DUALSPEED=3Dy
> CONFIG_USB_ZERO=3Dm
> # CONFIG_USB_AUDIO is not set
> # CONFIG_USB_ETH is not set
> # CONFIG_USB_G_NCM is not set
> # CONFIG_USB_GADGETFS is not set
> # CONFIG_USB_FUNCTIONFS is not set
> # CONFIG_USB_FILE_STORAGE is not set
> # CONFIG_USB_MASS_STORAGE is not set
> # CONFIG_USB_G_SERIAL is not set
> # CONFIG_USB_MIDI_GADGET is not set
> # CONFIG_USB_G_PRINTER is not set
> # CONFIG_USB_CDC_COMPOSITE is not set
> # CONFIG_USB_G_ACM_MS is not set
> # CONFIG_USB_G_MULTI is not set
> # CONFIG_USB_G_HID is not set
> # CONFIG_USB_G_DBGP is not set
>=20
> #
> # OTG and related infrastructure
> #
> CONFIG_USB_OTG_UTILS=3Dy
> # CONFIG_USB_GPIO_VBUS is not set
> # CONFIG_ISP1301_OMAP is not set
> # CONFIG_USB_ULPI is not set
> CONFIG_TWL4030_USB=3Dy
> CONFIG_TWL6030_USB=3Dy
> CONFIG_NOP_USB_XCEIV=3Dy
> CONFIG_MMC=3Dy
> # CONFIG_MMC_DEBUG is not set
> CONFIG_MMC_UNSAFE_RESUME=3Dy
> # CONFIG_MMC_CLKGATE is not set
>=20
> #
> # MMC/SD/SDIO Card Drivers
> #
> CONFIG_MMC_BLOCK=3Dy
> CONFIG_MMC_BLOCK_MINORS=3D8
> CONFIG_MMC_BLOCK_BOUNCE=3Dy
> CONFIG_SDIO_UART=3Dy
> # CONFIG_MMC_TEST is not set
>=20
> #
> # MMC/SD/SDIO Host Controller Drivers
> #
> # CONFIG_MMC_SDHCI is not set
> # CONFIG_MMC_SDHCI_PXAV3 is not set
> # CONFIG_MMC_SDHCI_PXAV2 is not set
> CONFIG_MMC_OMAP=3Dy
> CONFIG_MMC_OMAP_HS=3Dy
> # CONFIG_MMC_SPI is not set
> # CONFIG_MMC_DW is not set
> # CONFIG_MMC_VUB300 is not set
> # CONFIG_MMC_USHC is not set
> # CONFIG_MEMSTICK is not set
> CONFIG_NEW_LEDS=3Dy
> CONFIG_LEDS_CLASS=3Dy
>=20
> #
> # LED drivers
> #
> # CONFIG_LEDS_LM3530 is not set
> # CONFIG_LEDS_PCA9532 is not set
> # CONFIG_LEDS_GPIO is not set
> # CONFIG_LEDS_LP3944 is not set
> # CONFIG_LEDS_LP5521 is not set
> # CONFIG_LEDS_LP5523 is not set
> # CONFIG_LEDS_PCA955X is not set
> # CONFIG_LEDS_DAC124S085 is not set
> # CONFIG_LEDS_REGULATOR is not set
> # CONFIG_LEDS_BD2802 is not set
> # CONFIG_LEDS_LT3593 is not set
> # CONFIG_LEDS_RENESAS_TPU is not set
> CONFIG_LEDS_TRIGGERS=3Dy
>=20
> #
> # LED Triggers
> #
> # CONFIG_LEDS_TRIGGER_TIMER is not set
> # CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
> # CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
> # CONFIG_LEDS_TRIGGER_GPIO is not set
> # CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set
>=20
> #
> # iptables trigger is under Netfilter config (LED target)
> #
> # CONFIG_ACCESSIBILITY is not set
> CONFIG_RTC_LIB=3Dy
> CONFIG_RTC_CLASS=3Dy
> CONFIG_RTC_HCTOSYS=3Dy
> CONFIG_RTC_HCTOSYS_DEVICE=3D"rtc0"
> # CONFIG_RTC_DEBUG is not set
>=20
> #
> # RTC interfaces
> #
> CONFIG_RTC_INTF_SYSFS=3Dy
> CONFIG_RTC_INTF_PROC=3Dy
> CONFIG_RTC_INTF_DEV=3Dy
> # CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
> # CONFIG_RTC_DRV_TEST is not set
>=20
> #
> # I2C RTC drivers
> #
> # CONFIG_RTC_DRV_DS1307 is not set
> # CONFIG_RTC_DRV_DS1374 is not set
> # CONFIG_RTC_DRV_DS1672 is not set
> # CONFIG_RTC_DRV_DS3232 is not set
> # CONFIG_RTC_DRV_MAX6900 is not set
> # CONFIG_RTC_DRV_RS5C372 is not set
> # CONFIG_RTC_DRV_ISL1208 is not set
> # CONFIG_RTC_DRV_ISL12022 is not set
> # CONFIG_RTC_DRV_X1205 is not set
> # CONFIG_RTC_DRV_PCF8563 is not set
> # CONFIG_RTC_DRV_PCF8583 is not set
> # CONFIG_RTC_DRV_M41T80 is not set
> # CONFIG_RTC_DRV_BQ32K is not set
> CONFIG_RTC_DRV_TWL92330=3Dy
> CONFIG_RTC_DRV_TWL4030=3Dy
> # CONFIG_RTC_DRV_S35390A is not set
> # CONFIG_RTC_DRV_FM3130 is not set
> # CONFIG_RTC_DRV_RX8581 is not set
> # CONFIG_RTC_DRV_RX8025 is not set
> # CONFIG_RTC_DRV_EM3027 is not set
> # CONFIG_RTC_DRV_RV3029C2 is not set
>=20
> #
> # SPI RTC drivers
> #
> # CONFIG_RTC_DRV_M41T93 is not set
> # CONFIG_RTC_DRV_M41T94 is not set
> # CONFIG_RTC_DRV_DS1305 is not set
> # CONFIG_RTC_DRV_DS1390 is not set
> # CONFIG_RTC_DRV_MAX6902 is not set
> # CONFIG_RTC_DRV_R9701 is not set
> # CONFIG_RTC_DRV_RS5C348 is not set
> # CONFIG_RTC_DRV_DS3234 is not set
> # CONFIG_RTC_DRV_PCF2123 is not set
>=20
> #
> # Platform RTC drivers
> #
> # CONFIG_RTC_DRV_CMOS is not set
> # CONFIG_RTC_DRV_DS1286 is not set
> # CONFIG_RTC_DRV_DS1511 is not set
> # CONFIG_RTC_DRV_DS1553 is not set
> # CONFIG_RTC_DRV_DS1742 is not set
> # CONFIG_RTC_DRV_STK17TA8 is not set
> # CONFIG_RTC_DRV_M48T86 is not set
> # CONFIG_RTC_DRV_M48T35 is not set
> # CONFIG_RTC_DRV_M48T59 is not set
> # CONFIG_RTC_DRV_MSM6242 is not set
> # CONFIG_RTC_DRV_BQ4802 is not set
> # CONFIG_RTC_DRV_RP5C01 is not set
> # CONFIG_RTC_DRV_V3020 is not set
>=20
> #
> # on-CPU RTC drivers
> #
> # CONFIG_DMADEVICES is not set
> # CONFIG_AUXDISPLAY is not set
> # CONFIG_UIO is not set
>=20
> #
> # Virtio drivers
> #
> # CONFIG_VIRTIO_BALLOON is not set
> # CONFIG_VIRTIO_MMIO is not set
> # CONFIG_STAGING is not set
> CONFIG_CLKDEV_LOOKUP=3Dy
>=20
> #
> # Hardware Spinlock drivers
> #
> # CONFIG_HWSPINLOCK_OMAP is not set
> CONFIG_CLKSRC_MMIO=3Dy
> CONFIG_IOMMU_SUPPORT=3Dy
> # CONFIG_OMAP_IOMMU is not set
> # CONFIG_VIRT_DRIVERS is not set
> # CONFIG_PM_DEVFREQ is not set
>=20
> #
> # File systems
> #
> CONFIG_EXT2_FS=3Dy
> # CONFIG_EXT2_FS_XATTR is not set
> # CONFIG_EXT2_FS_XIP is not set
> CONFIG_EXT3_FS=3Dy
> CONFIG_EXT3_DEFAULTS_TO_ORDERED=3Dy
> # CONFIG_EXT3_FS_XATTR is not set
> # CONFIG_EXT4_FS is not set
> CONFIG_JBD=3Dy
> # CONFIG_JBD_DEBUG is not set
> # CONFIG_REISERFS_FS is not set
> # CONFIG_JFS_FS is not set
> # CONFIG_XFS_FS is not set
> # CONFIG_GFS2_FS is not set
> # CONFIG_BTRFS_FS is not set
> # CONFIG_NILFS2_FS is not set
> CONFIG_FS_POSIX_ACL=3Dy
> CONFIG_FILE_LOCKING=3Dy
> CONFIG_FSNOTIFY=3Dy
> CONFIG_DNOTIFY=3Dy
> CONFIG_INOTIFY_USER=3Dy
> # CONFIG_FANOTIFY is not set
> CONFIG_QUOTA=3Dy
> # CONFIG_QUOTA_NETLINK_INTERFACE is not set
> CONFIG_PRINT_QUOTA_WARNING=3Dy
> # CONFIG_QUOTA_DEBUG is not set
> CONFIG_QUOTA_TREE=3Dy
> # CONFIG_QFMT_V1 is not set
> CONFIG_QFMT_V2=3Dy
> CONFIG_QUOTACTL=3Dy
> # CONFIG_AUTOFS4_FS is not set
> # CONFIG_FUSE_FS is not set
>=20
> #
> # Caches
> #
> # CONFIG_FSCACHE is not set
>=20
> #
> # CD-ROM/DVD Filesystems
> #
> # CONFIG_ISO9660_FS is not set
> # CONFIG_UDF_FS is not set
>=20
> #
> # DOS/FAT/NT Filesystems
> #
> CONFIG_FAT_FS=3Dy
> CONFIG_MSDOS_FS=3Dy
> CONFIG_VFAT_FS=3Dy
> CONFIG_FAT_DEFAULT_CODEPAGE=3D437
> CONFIG_FAT_DEFAULT_IOCHARSET=3D"iso8859-1"
> # CONFIG_NTFS_FS is not set
>=20
> #
> # Pseudo filesystems
> #
> CONFIG_PROC_FS=3Dy
> CONFIG_PROC_SYSCTL=3Dy
> CONFIG_PROC_PAGE_MONITOR=3Dy
> CONFIG_SYSFS=3Dy
> CONFIG_TMPFS=3Dy
> # CONFIG_TMPFS_POSIX_ACL is not set
> # CONFIG_TMPFS_XATTR is not set
> # CONFIG_HUGETLB_PAGE is not set
> # CONFIG_CONFIGFS_FS is not set
> CONFIG_MISC_FILESYSTEMS=3Dy
> # CONFIG_ADFS_FS is not set
> # CONFIG_AFFS_FS is not set
> # CONFIG_ECRYPT_FS is not set
> # CONFIG_HFS_FS is not set
> # CONFIG_HFSPLUS_FS is not set
> # CONFIG_BEFS_FS is not set
> # CONFIG_BFS_FS is not set
> # CONFIG_EFS_FS is not set
> CONFIG_JFFS2_FS=3Dy
> CONFIG_JFFS2_FS_DEBUG=3D0
> CONFIG_JFFS2_FS_WRITEBUFFER=3Dy
> # CONFIG_JFFS2_FS_WBUF_VERIFY is not set
> CONFIG_JFFS2_SUMMARY=3Dy
> CONFIG_JFFS2_FS_XATTR=3Dy
> CONFIG_JFFS2_FS_POSIX_ACL=3Dy
> CONFIG_JFFS2_FS_SECURITY=3Dy
> CONFIG_JFFS2_COMPRESSION_OPTIONS=3Dy
> CONFIG_JFFS2_ZLIB=3Dy
> CONFIG_JFFS2_LZO=3Dy
> CONFIG_JFFS2_RTIME=3Dy
> CONFIG_JFFS2_RUBIN=3Dy
> # CONFIG_JFFS2_CMODE_NONE is not set
> CONFIG_JFFS2_CMODE_PRIORITY=3Dy
> # CONFIG_JFFS2_CMODE_SIZE is not set
> # CONFIG_JFFS2_CMODE_FAVOURLZO is not set
> CONFIG_UBIFS_FS=3Dy
> # CONFIG_UBIFS_FS_XATTR is not set
> # CONFIG_UBIFS_FS_ADVANCED_COMPR is not set
> CONFIG_UBIFS_FS_LZO=3Dy
> CONFIG_UBIFS_FS_ZLIB=3Dy
> # CONFIG_UBIFS_FS_DEBUG is not set
> # CONFIG_LOGFS is not set
> CONFIG_CRAMFS=3Dy
> # CONFIG_SQUASHFS is not set
> # CONFIG_VXFS_FS is not set
> # CONFIG_MINIX_FS is not set
> # CONFIG_OMFS_FS is not set
> # CONFIG_HPFS_FS is not set
> # CONFIG_QNX4FS_FS is not set
> # CONFIG_ROMFS_FS is not set
> # CONFIG_PSTORE is not set
> # CONFIG_SYSV_FS is not set
> # CONFIG_UFS_FS is not set
> CONFIG_NETWORK_FILESYSTEMS=3Dy
> CONFIG_NFS_FS=3Dy
> CONFIG_NFS_V3=3Dy
> CONFIG_NFS_V3_ACL=3Dy
> CONFIG_NFS_V4=3Dy
> # CONFIG_NFS_V4_1 is not set
> CONFIG_ROOT_NFS=3Dy
> # CONFIG_NFS_USE_LEGACY_DNS is not set
> CONFIG_NFS_USE_KERNEL_DNS=3Dy
> # CONFIG_NFS_USE_NEW_IDMAPPER is not set
> # CONFIG_NFSD is not set
> CONFIG_LOCKD=3Dy
> CONFIG_LOCKD_V4=3Dy
> CONFIG_NFS_ACL_SUPPORT=3Dy
> CONFIG_NFS_COMMON=3Dy
> CONFIG_SUNRPC=3Dy
> CONFIG_SUNRPC_GSS=3Dy
> # CONFIG_CEPH_FS is not set
> # CONFIG_CIFS is not set
> # CONFIG_NCP_FS is not set
> # CONFIG_CODA_FS is not set
> # CONFIG_AFS_FS is not set
>=20
> #
> # Partition Types
> #
> CONFIG_PARTITION_ADVANCED=3Dy
> # CONFIG_ACORN_PARTITION is not set
> # CONFIG_OSF_PARTITION is not set
> # CONFIG_AMIGA_PARTITION is not set
> # CONFIG_ATARI_PARTITION is not set
> # CONFIG_MAC_PARTITION is not set
> CONFIG_MSDOS_PARTITION=3Dy
> # CONFIG_BSD_DISKLABEL is not set
> # CONFIG_MINIX_SUBPARTITION is not set
> # CONFIG_SOLARIS_X86_PARTITION is not set
> # CONFIG_UNIXWARE_DISKLABEL is not set
> # CONFIG_LDM_PARTITION is not set
> # CONFIG_SGI_PARTITION is not set
> # CONFIG_ULTRIX_PARTITION is not set
> # CONFIG_SUN_PARTITION is not set
> # CONFIG_KARMA_PARTITION is not set
> # CONFIG_EFI_PARTITION is not set
> # CONFIG_SYSV68_PARTITION is not set
> CONFIG_NLS=3Dy
> CONFIG_NLS_DEFAULT=3D"iso8859-1"
> CONFIG_NLS_CODEPAGE_437=3Dy
> # CONFIG_NLS_CODEPAGE_737 is not set
> # CONFIG_NLS_CODEPAGE_775 is not set
> # CONFIG_NLS_CODEPAGE_850 is not set
> # CONFIG_NLS_CODEPAGE_852 is not set
> # CONFIG_NLS_CODEPAGE_855 is not set
> # CONFIG_NLS_CODEPAGE_857 is not set
> # CONFIG_NLS_CODEPAGE_860 is not set
> # CONFIG_NLS_CODEPAGE_861 is not set
> # CONFIG_NLS_CODEPAGE_862 is not set
> # CONFIG_NLS_CODEPAGE_863 is not set
> # CONFIG_NLS_CODEPAGE_864 is not set
> # CONFIG_NLS_CODEPAGE_865 is not set
> # CONFIG_NLS_CODEPAGE_866 is not set
> # CONFIG_NLS_CODEPAGE_869 is not set
> # CONFIG_NLS_CODEPAGE_936 is not set
> # CONFIG_NLS_CODEPAGE_950 is not set
> # CONFIG_NLS_CODEPAGE_932 is not set
> # CONFIG_NLS_CODEPAGE_949 is not set
> # CONFIG_NLS_CODEPAGE_874 is not set
> # CONFIG_NLS_ISO8859_8 is not set
> # CONFIG_NLS_CODEPAGE_1250 is not set
> # CONFIG_NLS_CODEPAGE_1251 is not set
> # CONFIG_NLS_ASCII is not set
> CONFIG_NLS_ISO8859_1=3Dy
> # CONFIG_NLS_ISO8859_2 is not set
> # CONFIG_NLS_ISO8859_3 is not set
> # CONFIG_NLS_ISO8859_4 is not set
> # CONFIG_NLS_ISO8859_5 is not set
> # CONFIG_NLS_ISO8859_6 is not set
> # CONFIG_NLS_ISO8859_7 is not set
> # CONFIG_NLS_ISO8859_9 is not set
> # CONFIG_NLS_ISO8859_13 is not set
> # CONFIG_NLS_ISO8859_14 is not set
> # CONFIG_NLS_ISO8859_15 is not set
> # CONFIG_NLS_KOI8_R is not set
> # CONFIG_NLS_KOI8_U is not set
> # CONFIG_NLS_UTF8 is not set
>=20
> #
> # Kernel hacking
> #
> CONFIG_PRINTK_TIME=3Dy
> CONFIG_DEFAULT_MESSAGE_LOGLEVEL=3D4
> CONFIG_ENABLE_WARN_DEPRECATED=3Dy
> CONFIG_ENABLE_MUST_CHECK=3Dy
> CONFIG_FRAME_WARN=3D1024
> CONFIG_MAGIC_SYSRQ=3Dy
> # CONFIG_STRIP_ASM_SYMS is not set
> # CONFIG_UNUSED_SYMBOLS is not set
> CONFIG_DEBUG_FS=3Dy
> # CONFIG_HEADERS_CHECK is not set
> # CONFIG_DEBUG_SECTION_MISMATCH is not set
> CONFIG_DEBUG_KERNEL=3Dy
> # CONFIG_DEBUG_SHIRQ is not set
> # CONFIG_LOCKUP_DETECTOR is not set
> # CONFIG_HARDLOCKUP_DETECTOR is not set
> # CONFIG_DETECT_HUNG_TASK is not set
> CONFIG_SCHED_DEBUG=3Dy
> CONFIG_SCHEDSTATS=3Dy
> CONFIG_TIMER_STATS=3Dy
> # CONFIG_DEBUG_OBJECTS is not set
> # CONFIG_DEBUG_SLAB is not set
> # CONFIG_DEBUG_KMEMLEAK is not set
> # CONFIG_DEBUG_RT_MUTEXES is not set
> # CONFIG_RT_MUTEX_TESTER is not set
> CONFIG_DEBUG_SPINLOCK=3Dy
> CONFIG_DEBUG_MUTEXES=3Dy
> CONFIG_DEBUG_LOCK_ALLOC=3Dy
> CONFIG_PROVE_LOCKING=3Dy
> # CONFIG_PROVE_RCU is not set
> # CONFIG_SPARSE_RCU_POINTER is not set
> CONFIG_LOCKDEP=3Dy
> # CONFIG_LOCK_STAT is not set
> # CONFIG_DEBUG_LOCKDEP is not set
> CONFIG_TRACE_IRQFLAGS=3Dy
> # CONFIG_DEBUG_ATOMIC_SLEEP is not set
> # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
> CONFIG_STACKTRACE=3Dy
> # CONFIG_DEBUG_STACK_USAGE is not set
> # CONFIG_DEBUG_KOBJECT is not set
> # CONFIG_DEBUG_BUGVERBOSE is not set
> CONFIG_DEBUG_INFO=3Dy
> # CONFIG_DEBUG_INFO_REDUCED is not set
> # CONFIG_DEBUG_VM is not set
> # CONFIG_DEBUG_WRITECOUNT is not set
> # CONFIG_DEBUG_MEMORY_INIT is not set
> # CONFIG_DEBUG_LIST is not set
> # CONFIG_TEST_LIST_SORT is not set
> # CONFIG_DEBUG_SG is not set
> # CONFIG_DEBUG_NOTIFIERS is not set
> # CONFIG_DEBUG_CREDENTIALS is not set
> # CONFIG_BOOT_PRINTK_DELAY is not set
> # CONFIG_RCU_TORTURE_TEST is not set
> CONFIG_RCU_CPU_STALL_TIMEOUT=3D60
> # CONFIG_KPROBES_SANITY_TEST is not set
> # CONFIG_BACKTRACE_SELF_TEST is not set
> # CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
> # CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
> # CONFIG_DEBUG_PER_CPU_MAPS is not set
> # CONFIG_LKDTM is not set
> # CONFIG_CPU_NOTIFIER_ERROR_INJECT is not set
> # CONFIG_FAULT_INJECTION is not set
> # CONFIG_SYSCTL_SYSCALL_CHECK is not set
> # CONFIG_DEBUG_PAGEALLOC is not set
> CONFIG_NOP_TRACER=3Dy
> CONFIG_HAVE_FUNCTION_TRACER=3Dy
> CONFIG_HAVE_FUNCTION_GRAPH_TRACER=3Dy
> CONFIG_HAVE_DYNAMIC_FTRACE=3Dy
> CONFIG_HAVE_FTRACE_MCOUNT_RECORD=3Dy
> CONFIG_HAVE_C_RECORDMCOUNT=3Dy
> CONFIG_RING_BUFFER=3Dy
> CONFIG_EVENT_TRACING=3Dy
> CONFIG_EVENT_POWER_TRACING_DEPRECATED=3Dy
> CONFIG_CONTEXT_SWITCH_TRACER=3Dy
> CONFIG_RING_BUFFER_ALLOW_SWAP=3Dy
> CONFIG_TRACING=3Dy
> CONFIG_TRACING_SUPPORT=3Dy
> CONFIG_FTRACE=3Dy
> # CONFIG_FUNCTION_TRACER is not set
> # CONFIG_IRQSOFF_TRACER is not set
> # CONFIG_SCHED_TRACER is not set
> # CONFIG_ENABLE_DEFAULT_TRACERS is not set
> CONFIG_BRANCH_PROFILE_NONE=3Dy
> # CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
> # CONFIG_PROFILE_ALL_BRANCHES is not set
> # CONFIG_STACK_TRACER is not set
> # CONFIG_BLK_DEV_IO_TRACE is not set
> CONFIG_KPROBE_EVENT=3Dy
> # CONFIG_RING_BUFFER_BENCHMARK is not set
> # CONFIG_DYNAMIC_DEBUG is not set
> # CONFIG_DMA_API_DEBUG is not set
> # CONFIG_ATOMIC64_SELFTEST is not set
> # CONFIG_SAMPLES is not set
> CONFIG_HAVE_ARCH_KGDB=3Dy
> # CONFIG_KGDB is not set
> # CONFIG_TEST_KSTRTOX is not set
> # CONFIG_STRICT_DEVMEM is not set
> CONFIG_ARM_UNWIND=3Dy
> # CONFIG_DEBUG_USER is not set
> # CONFIG_DEBUG_LL is not set
> # CONFIG_ARM_KPROBES_TEST is not set
>=20
> #
> # Security options
> #
> CONFIG_KEYS=3Dy
> # CONFIG_ENCRYPTED_KEYS is not set
> # CONFIG_KEYS_DEBUG_PROC_KEYS is not set
> # CONFIG_SECURITY_DMESG_RESTRICT is not set
> CONFIG_SECURITY=3Dy
> # CONFIG_SECURITYFS is not set
> # CONFIG_SECURITY_NETWORK is not set
> # CONFIG_SECURITY_PATH is not set
> # CONFIG_SECURITY_TOMOYO is not set
> # CONFIG_SECURITY_APPARMOR is not set
> # CONFIG_IMA is not set
> # CONFIG_EVM is not set
> CONFIG_DEFAULT_SECURITY_DAC=3Dy
> CONFIG_DEFAULT_SECURITY=3D""
> CONFIG_CRYPTO=3Dy
>=20
> #
> # Crypto core or helper
> #
> CONFIG_CRYPTO_ALGAPI=3Dy
> CONFIG_CRYPTO_ALGAPI2=3Dy
> CONFIG_CRYPTO_AEAD2=3Dy
> CONFIG_CRYPTO_BLKCIPHER=3Dm
> CONFIG_CRYPTO_BLKCIPHER2=3Dy
> CONFIG_CRYPTO_HASH=3Dy
> CONFIG_CRYPTO_HASH2=3Dy
> CONFIG_CRYPTO_RNG2=3Dy
> CONFIG_CRYPTO_PCOMP2=3Dy
> CONFIG_CRYPTO_MANAGER=3Dm
> CONFIG_CRYPTO_MANAGER2=3Dy
> # CONFIG_CRYPTO_USER is not set
> CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=3Dy
> # CONFIG_CRYPTO_GF128MUL is not set
> # CONFIG_CRYPTO_NULL is not set
> # CONFIG_CRYPTO_PCRYPT is not set
> CONFIG_CRYPTO_WORKQUEUE=3Dy
> # CONFIG_CRYPTO_CRYPTD is not set
> # CONFIG_CRYPTO_AUTHENC is not set
> # CONFIG_CRYPTO_TEST is not set
>=20
> #
> # Authenticated Encryption with Associated Data
> #
> # CONFIG_CRYPTO_CCM is not set
> # CONFIG_CRYPTO_GCM is not set
> # CONFIG_CRYPTO_SEQIV is not set
>=20
> #
> # Block modes
> #
> # CONFIG_CRYPTO_CBC is not set
> # CONFIG_CRYPTO_CTR is not set
> # CONFIG_CRYPTO_CTS is not set
> CONFIG_CRYPTO_ECB=3Dm
> # CONFIG_CRYPTO_LRW is not set
> # CONFIG_CRYPTO_PCBC is not set
> # CONFIG_CRYPTO_XTS is not set
>=20
> #
> # Hash modes
> #
> # CONFIG_CRYPTO_HMAC is not set
> # CONFIG_CRYPTO_XCBC is not set
> # CONFIG_CRYPTO_VMAC is not set
>=20
> #
> # Digest
> #
> CONFIG_CRYPTO_CRC32C=3Dy
> # CONFIG_CRYPTO_GHASH is not set
> # CONFIG_CRYPTO_MD4 is not set
> # CONFIG_CRYPTO_MD5 is not set
> CONFIG_CRYPTO_MICHAEL_MIC=3Dy
> # CONFIG_CRYPTO_RMD128 is not set
> # CONFIG_CRYPTO_RMD160 is not set
> # CONFIG_CRYPTO_RMD256 is not set
> # CONFIG_CRYPTO_RMD320 is not set
> # CONFIG_CRYPTO_SHA1 is not set
> # CONFIG_CRYPTO_SHA256 is not set
> # CONFIG_CRYPTO_SHA512 is not set
> # CONFIG_CRYPTO_TGR192 is not set
> # CONFIG_CRYPTO_WP512 is not set
>=20
> #
> # Ciphers
> #
> CONFIG_CRYPTO_AES=3Dm
> # CONFIG_CRYPTO_ANUBIS is not set
> CONFIG_CRYPTO_ARC4=3Dm
> # CONFIG_CRYPTO_BLOWFISH is not set
> # CONFIG_CRYPTO_CAMELLIA is not set
> # CONFIG_CRYPTO_CAST5 is not set
> # CONFIG_CRYPTO_CAST6 is not set
> # CONFIG_CRYPTO_DES is not set
> # CONFIG_CRYPTO_FCRYPT is not set
> # CONFIG_CRYPTO_KHAZAD is not set
> # CONFIG_CRYPTO_SALSA20 is not set
> # CONFIG_CRYPTO_SEED is not set
> # CONFIG_CRYPTO_SERPENT is not set
> # CONFIG_CRYPTO_TEA is not set
> # CONFIG_CRYPTO_TWOFISH is not set
>=20
> #
> # Compression
> #
> CONFIG_CRYPTO_DEFLATE=3Dy
> # CONFIG_CRYPTO_ZLIB is not set
> CONFIG_CRYPTO_LZO=3Dy
>=20
> #
> # Random Number Generation
> #
> # CONFIG_CRYPTO_ANSI_CPRNG is not set
> # CONFIG_CRYPTO_USER_API_HASH is not set
> # CONFIG_CRYPTO_USER_API_SKCIPHER is not set
> CONFIG_CRYPTO_HW=3Dy
> # CONFIG_CRYPTO_DEV_OMAP_SHAM is not set
> # CONFIG_CRYPTO_DEV_OMAP_AES is not set
> CONFIG_BINARY_PRINTF=3Dy
>=20
> #
> # Library routines
> #
> CONFIG_BITREVERSE=3Dy
> CONFIG_CRC_CCITT=3Dy
> CONFIG_CRC16=3Dy
> CONFIG_CRC_T10DIF=3Dy
> CONFIG_CRC_ITU_T=3Dy
> CONFIG_CRC32=3Dy
> CONFIG_CRC7=3Dy
> CONFIG_LIBCRC32C=3Dy
> # CONFIG_CRC8 is not set
> CONFIG_ZLIB_INFLATE=3Dy
> CONFIG_ZLIB_DEFLATE=3Dy
> CONFIG_LZO_COMPRESS=3Dy
> CONFIG_LZO_DECOMPRESS=3Dy
> # CONFIG_XZ_DEC is not set
> # CONFIG_XZ_DEC_BCJ is not set
> CONFIG_DECOMPRESS_GZIP=3Dy
> CONFIG_HAS_IOMEM=3Dy
> CONFIG_HAS_IOPORT=3Dy
> CONFIG_HAS_DMA=3Dy
> CONFIG_CPU_RMAP=3Dy
> CONFIG_NLATTR=3Dy
> CONFIG_GENERIC_ATOMIC64=3Dy
> CONFIG_AVERAGE=3Dy
> # CONFIG_CORDIC is not set
>=20
> /*----------------------------------------*/
> Bob Bouterse
> Senior Software Engineer
> Multimedia Development Center
> D&M Holdings Inc.
> http://www.dm-holdings.com

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk8PUdUACgkQrzg/fFk7axbsLQCglGj4U/Mkz0I0bn/vYbomqBBq
aOEAoPAYv+4cZGjtf6cdAAZppXtlTji1
=hl0/
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
