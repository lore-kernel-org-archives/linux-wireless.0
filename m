Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:50721 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab2JIJPD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Oct 2012 05:15:03 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so3332836eek.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Oct 2012 02:15:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121003143029.GF2259@redhat.com>
References: <CAJZjf_wv=+HKLwnH-=rvx9h=0jEGzoCrd-a8GOW-QnXfOVgc_g@mail.gmail.com>
 <20120807102208.GA12589@redhat.com> <CAJZjf_xVOKjVYYXxsWf6Z+KaTDi_3ZDqvBMyzMETfbkpWUgWFQ@mail.gmail.com>
 <CAJZjf_xVzQmpLHd=KQ0qc77QxdpE0a7xjGTNo2Sw6BM8miwe7A@mail.gmail.com> <20121003143029.GF2259@redhat.com>
From: Pedro Francisco <pedrogfrancisco@gmail.com>
Date: Tue, 9 Oct 2012 10:14:40 +0100
Message-ID: <CAJZjf_xZC2473B2SQAKFfc7m6SSeEK7z7N-GaUsZUNV-K9c=Ww@mail.gmail.com> (sfid-20121009_111509_536106_62ED6313)
Subject: Re: unloading WiFi modules is usually triggering kernel crash
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: ML linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 3, 2012 at 3:30 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Wed, Sep 26, 2012 at 01:47:18PM +0100, Pedro Francisco wrote:
>> On Thu, Aug 30, 2012 at 4:58 PM, Pedro Francisco
>> <pedrogfrancisco@gmail.com> wrote:
>> > On Tue, Aug 7, 2012 at 11:22 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>> >> On Tue, Jul 31, 2012 at 01:54:52PM +0100, Pedro Francisco wrote:
>> >>> I've noticed in the past few days a pattern: sometimes nm-applet
>> >>> starts showing empty bars for the signal strength.
>> >>
>> >> RSSI reporting problem or maybe NM issue. When you change kernel to
>> >> older or newer does this problem go away ?
>> >>
>> >>> Running the script:
>> >>> sudo ifconfig wlan0 down; sleep 1
>> >>> sudo rmmod hp_wmi; sudo rmmod iwl3945; sudo rmmod iwlegacy; sudo rmmod
>> >>> mac80211; sudo rmmod cfg80211
>> >>> sleep 2; sudo rmmod rfkill; sync
>> >>> sudo modprobe rfkill; sudo modprobe cfg80211; sudo modprobe mac80211;
>> >>> sudo modprobe iwlegacy
>> >>> sudo modprobe iwl3945; sudo modprobe hp_wmi; sleep 1; sudo ifconfig wlan0 up
>> >>
>> >> I run a bit modified script (I do not have hp_wmi.ko and rfkill.ko) for few
>> >> hours, and did not get any WARNING/crash. I used 3.5, can you check if that
>> >> problem is also fixed on your system on 3.5 or newer.
>> >
>> > On 3.5.2-3.fc17.i686.PAE everything seems stable. The problem I had
>> > described hasn't happened recently.
>> > I guess it got fixed in the meantime.
>>
>> I was wrong, got it again.
>>
>> So, to recap: once the network applet shows no signal, but only then,
>> removing the wireless modules triggers an unrecoverable kernel panic.
>> I still haven't compiled a relocatable x86 kernel to get a proper
>> backtrace using kexec/kdump, sorry.
>>
>> I found something else as well. Notice this output of "iwconfig" when
>> everything is _normal_:
>> $ iwconfig wlan0
>> wlan0     IEEE 802.11abg  ESSID:"eduroam"
>>           Mode:Managed  Frequency:2.437 GHz  Access Point: B8:62:1F:XX:XX:XX
>>           Bit Rate=54 Mb/s   Tx-Power=15 dBm
>>           Retry  long limit:7   RTS thr:off   Fragment thr:off
>>           Power Management:off
>>           Link Quality=58/70  Signal level=-52 dBm
>>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>>           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
>>
>> When I have the "empty signal bars" issue:
>> $ iwconfig wlan0
>> wlan0     IEEE 802.11abg  ESSID:off/any
>>           Mode:Managed  Access Point: Not-Associated   Tx-Power=15 dBm
>>           Retry  long limit:7   RTS thr:off   Fragment thr:off
>>           Power Management:off
>>
>> In case you're wondering, it is connected and streaming stuff :)
>>
>> I can sometimes trigger it on purpose: I just have to roam to a 5GHz
>> AP of the same ESS, cycle around 2GHz and back to 5GHz (using wpa_cli
>> roam XX:XX:XX:XX:XX ). If I get "SME: Authentication request to the
>> driver failed", then disabling NetworkManager (not wireless) and
>> reenabling will _probably_ get the "empty signal bars" (I was just
>> able to trigger the "empty signal bars" now after a clean boot).
>> So I'm guessing something gets corrupted, which is why reloading the
>> modules will crash.
>
> We do not stop mac80211 timers on module unload. I reproduced below
> warnings with iwlwifi on 3.5 kernel with DEBUG_OBJECTS enabled.
> I forced roaming many times, and then do "modprobe -r iwlwifi".
> Unfortunately those steps do not trigger warnings anytime, they
> happened just once.
>
> iwlwifi 0000:02:00.0: ACTIVATE a non DRIVER active station id 0 addr 6c:50:4d:3f:79:73
> ------------[ cut here ]------------
> WARNING: at lib/debugobjects.c:261 debug_print_object+0x8e/0xb0()
> Hardware name: SandyBridge Platform
> ODEBUG: free active (active state 0) object type: timer_list hint:
> ieee80211_sta_conn_mon_timer+0x0/0x40 [mac80211]
> Modules linked in: autofs4 sunrpc cpufreq_ondemand acpi_cpufreq
> freq_table mperf ipv6 uinput arc4 sg iwlwifi(-) mac80211 cfg80211 rfkill
> coretemp kvm_intel kvm crc32c_intel ghash_clmulni_intel microcode pcspkr
> lpc_ich mfd_core i2c_i801 e1000e ext4 mbcache jbd2 sd_mod crc_t10dif
> sr_mod cdrom aesni_intel cryptd aes_x86_64 aes_generic ahci libahci i915
> drm_kms_helper drm i2c_algo_bit i2c_core video dm_mirror dm_region_hash
> dm_log dm_mod [last unloaded: scsi_wait_scan]
> Pid: 3064, comm: modprobe Not tainted 3.5.0 #1
> Call Trace:
>  [<ffffffff810535af>] warn_slowpath_common+0x7f/0xc0
>  [<ffffffff810536a6>] warn_slowpath_fmt+0x46/0x50
>  [<ffffffff812901be>] debug_print_object+0x8e/0xb0
>  [<ffffffffa03a09b0>] ? ieee80211_chswitch_timer+0x40/0x40 [mac80211]
>  [<ffffffff81290a0d>] __debug_check_no_obj_freed+0x10d/0x200
>  [<ffffffff81290b1d>] debug_check_no_obj_freed+0x1d/0x30
>  [<ffffffff8117a2b0>] kfree+0xc0/0x330
>  [<ffffffff810b9083>] ? __lock_release+0x133/0x1a0
>  [<ffffffff815555f0>] ? _raw_spin_unlock_irqrestore+0x40/0x80
>  [<ffffffff814957c4>] netdev_release+0x44/0x60
>  [<ffffffff813704b7>] device_release+0x27/0xa0
>  [<ffffffff8127da42>] kobject_cleanup+0x82/0x1b0
>  [<ffffffff8127db7d>] kobject_release+0xd/0x10
>  [<ffffffff8127d8cc>] kobject_put+0x2c/0x60
>  [<ffffffff8147e371>] netdev_run_todo+0x101/0x180
>  [<ffffffff8148f5ae>] rtnl_unlock+0xe/0x10
>  [<ffffffffa0366178>] ieee80211_unregister_hw+0x58/0x120 [mac80211]
>  [<ffffffffa040912b>] iwlagn_mac_unregister+0x2b/0x40 [iwlwifi]
>  [<ffffffffa03fdf59>] iwl_op_mode_dvm_stop+0x49/0xf0 [iwlwifi]
>  [<ffffffffa041f730>] iwl_drv_stop+0x40/0x60 [iwlwifi]
>  [<ffffffffa0430a39>] iwl_pci_remove+0x25/0x3c [iwlwifi]
>  [<ffffffff812aafc2>] pci_device_remove+0x52/0x120
>  [<ffffffff813741cc>] __device_release_driver+0x7c/0xe0
>  [<ffffffff81374308>] driver_detach+0xd8/0xe0
>  [<ffffffff81372f61>] bus_remove_driver+0x91/0x110
>  [<ffffffff81374fd2>] driver_unregister+0x62/0xa0
>  [<ffffffff812ab2b4>] pci_unregister_driver+0x44/0xa0
>  [<ffffffffa041f3d5>] iwl_pci_unregister_driver+0x15/0x20 [iwlwifi]
>  [<ffffffffa0430a01>] iwl_exit+0x9/0x1c [iwlwifi]
>  [<ffffffff810c50f1>] sys_delete_module+0x1d1/0x2c0
>  [<ffffffff81555855>] ? retint_swapgs+0x13/0x1b
>  [<ffffffff810e169c>] ? __audit_syscall_entry+0xcc/0x210
>  [<ffffffff812896ce>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>  [<ffffffff8155de69>] system_call_fastpath+0x16/0x1b
> ---[ end trace 8070f580fc119b8b ]---
> ------------[ cut here ]------------
> WARNING: at lib/debugobjects.c:261 debug_print_object+0x8e/0xb0()
> Hardware name: SandyBridge Platform
> ODEBUG: free active (active state 0) object type: timer_list hint:
> ieee80211_sta_bcn_mon_timer+0x0/0x40 [mac80211]
> Modules linked in: autofs4 sunrpc cpufreq_ondemand acpi_cpufreq
> freq_table mperf ipv6 uinput arc4 sg iwlwifi(-) mac80211 cfg80211 rfkill
> coretemp kvm_intel kvm crc32c_intel ghash_clmulni_intel microcode pcspkr
> lpc_ich mfd_core i2c_i801 e1000e ext4 mbcache jbd2 sd_mod crc_t10dif
> sr_mod cdrom aesni_intel cryptd aes_x86_64 aes_generic ahci libahci i915
> drm_kms_helper drm i2c_algo_bit i2c_core video dm_mirror dm_region_hash
> dm_log dm_mod [last unloaded: scsi_wait_scan]
> Pid: 3064, comm: modprobe Tainted: G        W    3.5.0 #1
> Call Trace:
>  [<ffffffff810535af>] warn_slowpath_common+0x7f/0xc0
>  [<ffffffff810536a6>] warn_slowpath_fmt+0x46/0x50
>  [<ffffffff812901be>] debug_print_object+0x8e/0xb0
>  [<ffffffffa03a09f0>] ? ieee80211_sta_conn_mon_timer+0x40/0x40
> [mac80211]
>  [<ffffffff81290a0d>] __debug_check_no_obj_freed+0x10d/0x200
>  [<ffffffff81290b1d>] debug_check_no_obj_freed+0x1d/0x30
>  [<ffffffff8117a2b0>] kfree+0xc0/0x330
>  [<ffffffff810b9083>] ? __lock_release+0x133/0x1a0
>  [<ffffffff815555f0>] ? _raw_spin_unlock_irqrestore+0x40/0x80
>  [<ffffffff814957c4>] netdev_release+0x44/0x60
>  [<ffffffff813704b7>] device_release+0x27/0xa0
>  [<ffffffff8127da42>] kobject_cleanup+0x82/0x1b0
>  [<ffffffff8127db7d>] kobject_release+0xd/0x10
>  [<ffffffff8127d8cc>] kobject_put+0x2c/0x60
>  [<ffffffff8147e371>] netdev_run_todo+0x101/0x180
>  [<ffffffff8148f5ae>] rtnl_unlock+0xe/0x10
>  [<ffffffffa0366178>] ieee80211_unregister_hw+0x58/0x120 [mac80211]
>  [<ffffffffa040912b>] iwlagn_mac_unregister+0x2b/0x40 [iwlwifi]
>  [<ffffffffa03fdf59>] iwl_op_mode_dvm_stop+0x49/0xf0 [iwlwifi]
>  [<ffffffffa041f730>] iwl_drv_stop+0x40/0x60 [iwlwifi]
>  [<ffffffffa0430a39>] iwl_pci_remove+0x25/0x3c [iwlwifi]
>  [<ffffffff812aafc2>] pci_device_remove+0x52/0x120
>  [<ffffffff813741cc>] __device_release_driver+0x7c/0xe0
>  [<ffffffff81374308>] driver_detach+0xd8/0xe0
>  [<ffffffff81372f61>] bus_remove_driver+0x91/0x110
>  [<ffffffff81374fd2>] driver_unregister+0x62/0xa0
>  [<ffffffff812ab2b4>] pci_unregister_driver+0x44/0xa0
>  [<ffffffffa041f3d5>] iwl_pci_unregister_driver+0x15/0x20 [iwlwifi]
>  [<ffffffffa0430a01>] iwl_exit+0x9/0x1c [iwlwifi]
>  [<ffffffff810c50f1>] sys_delete_module+0x1d1/0x2c0
>  [<ffffffff81555855>] ? retint_swapgs+0x13/0x1b
>  [<ffffffff810e169c>] ? __audit_syscall_entry+0xcc/0x210
>  [<ffffffff812896ce>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>  [<ffffffff8155de69>] system_call_fastpath+0x16/0x1b
> ---[ end trace 8070f580fc119b8c ]---
> Bridge firewalling registered
>

Hi!
I was finally able to compile a relocatable kernel: here's what I got,
after a crash on iwlegacy module removal:
# crash vmcore /usr/lib/debug/lib/modules/`uname -r`/vmlinux

crash 6.0.8-1.fc18 [note, I'm on FC17 but had to install FC18's crash
to workaround a log structure change in 3.5 kernel]
(...)
This GDB was configured as "i686-pc-linux-gnu"...


============ CRASH 1 ============
      KERNEL: /usr/lib/debug/lib/modules/3.5.4-2.pedro.fc17.i686.PAE/vmlinux
    DUMPFILE: vmcore  [PARTIAL DUMP]
        CPUS: 2
        DATE: Tue Oct  9 09:17:35 2012
      UPTIME: 00:12:47
LOAD AVERAGE: 0.50, 0.62, 0.60
       TASKS: 322
    NODENAME: s2
     RELEASE: 3.5.4-2.pedro.fc17.i686.PAE
     VERSION: #1 SMP Mon Oct 8 23:15:44 WEST 2012
     MACHINE: i686  (1496 Mhz)
      MEMORY: 2 GB
       PANIC: "Oops: 0000 [#1] SMP " (check log for details)
         PID: 0
     COMMAND: "swapper/1"
        TASK: f4104240  (1 of 2)  [THREAD_INFO: f4146000]
         CPU: 1
       STATE: TASK_RUNNING (PANIC)

crash> bt
PID: 0      TASK: f4104240  CPU: 1   COMMAND: "swapper/1"
 #0 [f4147db4] crash_kexec at c04a7d59
 #1 [f4147e04] timerqueue_add at c0675503
 #2 [f4147e14] ktime_get at c04921ee
 #3 [f4147e30] bad_area_nosemaphore at c0958328
 #4 [f4147e3c] do_page_fault at c0964c25
 #5 [f4147eb8] error_code (via page_fault) at c0961eb1
    EAX: 6b6b6b6b  EBX: 00072420  ECX: 00000001  EDX: f4178930  EBP: f4147f30
    DS:  007b      ESI: 00000024  ES:  007b      EDI: 00072420  GS:  00e0
    CS:  0060      EIP: c0457993  ERR: ffffffff  EFLAGS: 00010003
 #6 [f4147eec] get_next_timer_interrupt at c0457993
 #7 [f4147f34] tick_nohz_stop_sched_tick.isra.11 at c049a19a
 #8 [f4147f78] tick_nohz_idle_enter at c049a661
 #9 [f4147f80] cpu_idle at c04195da


============ CRASH 2 ============

      KERNEL: /usr/lib/debug/lib/modules/3.5.4-2.pedro.fc17.i686.PAE/vmlinux
    DUMPFILE: vmcore
        CPUS: 2
        DATE: Tue Oct  9 09:29:35 2012
      UPTIME: 00:10:22
LOAD AVERAGE: 0.30, 0.78, 0.67
       TASKS: 323
    NODENAME: s2
     RELEASE: 3.5.4-2.pedro.fc17.i686.PAE
     VERSION: #1 SMP Mon Oct 8 23:15:44 WEST 2012
     MACHINE: i686  (1496 Mhz)
      MEMORY: 2 GB
       PANIC: "kernel BUG at kernel/timer.c:1091!"
         PID: 6563
     COMMAND: "rpm" <-- ?
        TASK: eaa5dcc0  [THREAD_INFO: f414a000]
         CPU: 0
       STATE: TASK_RUNNING (PANIC)

crash> bt
PID: 6563   TASK: eaa5dcc0  CPU: 0   COMMAND: "rpm"
bt: cannot resolve stack trace:
 #0 [f414bd58] __schedule at c095fba6
 #1 [f414bdd4] sched_clock_local at c047a56d
bt: text symbols on stack:
    [f414bd5c] kmap_atomic_prot at c0441244
    [f414bd70] __kunmap_atomic at c04410dd
    [f414bd80] get_page_from_freelist at c0504e40
    [f414bdcc] sched_clock at c0417a28
    [f414bdd4] sched_clock_local at c047a572
    [f414be28] update_curr at c047cdb2
    [f414be60] clear_nohz_tick_stopped.part.37 at c0958f63
    [f414be6c] trigger_load_balance at c047ff73
    [f414be88] scheduler_tick at c04774e5
    [f414beac] timerqueue_add at c0675508
    [f414bec0] ktime_get at c04921f0
    [f414bed4] lapic_next_event at c042f75b
    [f414bedc] clockevents_program_event at c049877d
    [f414bef4] tick_program_event at c0499a79
    [f414bf04] hrtimer_interrupt at c046bcc8
    [f414bf54] irq_exit at c045001d
    [f414bf5c] smp_apic_timer_interrupt at c042fdbe
    [f414bf74] apic_timer_interrupt at c0961c85
    [f414bfa8] sysenter_past_esp at c0968322
bt: possible exception frame:
  USER-MODE EXCEPTION FRAME AT f414bfb4:
    EAX: 0000002d  EBX: 09fba000  ECX: 45a4bff4  EDX: 09fba000
    DS:  007b      ESI: 09f99000  ES:  007b      EDI: 09fba000
    SS:  007b      ESP: bff95804  EBP: bff95804  GS:  0033
    CS:  0073      EIP: b7720424  ERR: 0000002d  EFLAGS: 00000202



So, I'm guessing this means it is related to what you found on iwlwifi
(even if I'm on iwlegacy)?
The crash kernel crashed again but I can try to add a script to try to
recover dmesg -- I believe slub_debug caught something as well...

-- 
Pedro
