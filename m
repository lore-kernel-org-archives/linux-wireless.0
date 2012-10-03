Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268Ab2JCOb1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Oct 2012 10:31:27 -0400
Date: Wed, 3 Oct 2012 16:30:30 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Pedro Francisco <pedrogfrancisco@gmail.com>
Cc: ML linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: unloading WiFi modules is usually triggering kernel crash
Message-ID: <20121003143029.GF2259@redhat.com> (sfid-20121003_163133_049694_5B331130)
References: <CAJZjf_wv=+HKLwnH-=rvx9h=0jEGzoCrd-a8GOW-QnXfOVgc_g@mail.gmail.com>
 <20120807102208.GA12589@redhat.com>
 <CAJZjf_xVOKjVYYXxsWf6Z+KaTDi_3ZDqvBMyzMETfbkpWUgWFQ@mail.gmail.com>
 <CAJZjf_xVzQmpLHd=KQ0qc77QxdpE0a7xjGTNo2Sw6BM8miwe7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJZjf_xVzQmpLHd=KQ0qc77QxdpE0a7xjGTNo2Sw6BM8miwe7A@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 26, 2012 at 01:47:18PM +0100, Pedro Francisco wrote:
> On Thu, Aug 30, 2012 at 4:58 PM, Pedro Francisco
> <pedrogfrancisco@gmail.com> wrote:
> > On Tue, Aug 7, 2012 at 11:22 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> >> On Tue, Jul 31, 2012 at 01:54:52PM +0100, Pedro Francisco wrote:
> >>> I've noticed in the past few days a pattern: sometimes nm-applet
> >>> starts showing empty bars for the signal strength.
> >>
> >> RSSI reporting problem or maybe NM issue. When you change kernel to
> >> older or newer does this problem go away ?
> >>
> >>> Running the script:
> >>> sudo ifconfig wlan0 down; sleep 1
> >>> sudo rmmod hp_wmi; sudo rmmod iwl3945; sudo rmmod iwlegacy; sudo rmmod
> >>> mac80211; sudo rmmod cfg80211
> >>> sleep 2; sudo rmmod rfkill; sync
> >>> sudo modprobe rfkill; sudo modprobe cfg80211; sudo modprobe mac80211;
> >>> sudo modprobe iwlegacy
> >>> sudo modprobe iwl3945; sudo modprobe hp_wmi; sleep 1; sudo ifconfig wlan0 up
> >>
> >> I run a bit modified script (I do not have hp_wmi.ko and rfkill.ko) for few
> >> hours, and did not get any WARNING/crash. I used 3.5, can you check if that
> >> problem is also fixed on your system on 3.5 or newer.
> >
> > On 3.5.2-3.fc17.i686.PAE everything seems stable. The problem I had
> > described hasn't happened recently.
> > I guess it got fixed in the meantime.
> 
> I was wrong, got it again.
> 
> So, to recap: once the network applet shows no signal, but only then,
> removing the wireless modules triggers an unrecoverable kernel panic.
> I still haven't compiled a relocatable x86 kernel to get a proper
> backtrace using kexec/kdump, sorry.
> 
> I found something else as well. Notice this output of "iwconfig" when
> everything is _normal_:
> $ iwconfig wlan0
> wlan0     IEEE 802.11abg  ESSID:"eduroam"
>           Mode:Managed  Frequency:2.437 GHz  Access Point: B8:62:1F:XX:XX:XX
>           Bit Rate=54 Mb/s   Tx-Power=15 dBm
>           Retry  long limit:7   RTS thr:off   Fragment thr:off
>           Power Management:off
>           Link Quality=58/70  Signal level=-52 dBm
>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
> 
> When I have the "empty signal bars" issue:
> $ iwconfig wlan0
> wlan0     IEEE 802.11abg  ESSID:off/any
>           Mode:Managed  Access Point: Not-Associated   Tx-Power=15 dBm
>           Retry  long limit:7   RTS thr:off   Fragment thr:off
>           Power Management:off
> 
> In case you're wondering, it is connected and streaming stuff :)
> 
> I can sometimes trigger it on purpose: I just have to roam to a 5GHz
> AP of the same ESS, cycle around 2GHz and back to 5GHz (using wpa_cli
> roam XX:XX:XX:XX:XX ). If I get "SME: Authentication request to the
> driver failed", then disabling NetworkManager (not wireless) and
> reenabling will _probably_ get the "empty signal bars" (I was just
> able to trigger the "empty signal bars" now after a clean boot).
> So I'm guessing something gets corrupted, which is why reloading the
> modules will crash.

We do not stop mac80211 timers on module unload. I reproduced below
warnings with iwlwifi on 3.5 kernel with DEBUG_OBJECTS enabled.
I forced roaming many times, and then do "modprobe -r iwlwifi".
Unfortunately those steps do not trigger warnings anytime, they
happened just once.

iwlwifi 0000:02:00.0: ACTIVATE a non DRIVER active station id 0 addr 6c:50:4d:3f:79:73
------------[ cut here ]------------
WARNING: at lib/debugobjects.c:261 debug_print_object+0x8e/0xb0()
Hardware name: SandyBridge Platform
ODEBUG: free active (active state 0) object type: timer_list hint:
ieee80211_sta_conn_mon_timer+0x0/0x40 [mac80211]
Modules linked in: autofs4 sunrpc cpufreq_ondemand acpi_cpufreq
freq_table mperf ipv6 uinput arc4 sg iwlwifi(-) mac80211 cfg80211 rfkill
coretemp kvm_intel kvm crc32c_intel ghash_clmulni_intel microcode pcspkr
lpc_ich mfd_core i2c_i801 e1000e ext4 mbcache jbd2 sd_mod crc_t10dif
sr_mod cdrom aesni_intel cryptd aes_x86_64 aes_generic ahci libahci i915
drm_kms_helper drm i2c_algo_bit i2c_core video dm_mirror dm_region_hash
dm_log dm_mod [last unloaded: scsi_wait_scan]
Pid: 3064, comm: modprobe Not tainted 3.5.0 #1
Call Trace:
 [<ffffffff810535af>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff810536a6>] warn_slowpath_fmt+0x46/0x50
 [<ffffffff812901be>] debug_print_object+0x8e/0xb0
 [<ffffffffa03a09b0>] ? ieee80211_chswitch_timer+0x40/0x40 [mac80211]
 [<ffffffff81290a0d>] __debug_check_no_obj_freed+0x10d/0x200
 [<ffffffff81290b1d>] debug_check_no_obj_freed+0x1d/0x30
 [<ffffffff8117a2b0>] kfree+0xc0/0x330
 [<ffffffff810b9083>] ? __lock_release+0x133/0x1a0
 [<ffffffff815555f0>] ? _raw_spin_unlock_irqrestore+0x40/0x80
 [<ffffffff814957c4>] netdev_release+0x44/0x60
 [<ffffffff813704b7>] device_release+0x27/0xa0
 [<ffffffff8127da42>] kobject_cleanup+0x82/0x1b0
 [<ffffffff8127db7d>] kobject_release+0xd/0x10
 [<ffffffff8127d8cc>] kobject_put+0x2c/0x60
 [<ffffffff8147e371>] netdev_run_todo+0x101/0x180
 [<ffffffff8148f5ae>] rtnl_unlock+0xe/0x10
 [<ffffffffa0366178>] ieee80211_unregister_hw+0x58/0x120 [mac80211]
 [<ffffffffa040912b>] iwlagn_mac_unregister+0x2b/0x40 [iwlwifi]
 [<ffffffffa03fdf59>] iwl_op_mode_dvm_stop+0x49/0xf0 [iwlwifi]
 [<ffffffffa041f730>] iwl_drv_stop+0x40/0x60 [iwlwifi]
 [<ffffffffa0430a39>] iwl_pci_remove+0x25/0x3c [iwlwifi]
 [<ffffffff812aafc2>] pci_device_remove+0x52/0x120
 [<ffffffff813741cc>] __device_release_driver+0x7c/0xe0
 [<ffffffff81374308>] driver_detach+0xd8/0xe0
 [<ffffffff81372f61>] bus_remove_driver+0x91/0x110
 [<ffffffff81374fd2>] driver_unregister+0x62/0xa0
 [<ffffffff812ab2b4>] pci_unregister_driver+0x44/0xa0
 [<ffffffffa041f3d5>] iwl_pci_unregister_driver+0x15/0x20 [iwlwifi]
 [<ffffffffa0430a01>] iwl_exit+0x9/0x1c [iwlwifi]
 [<ffffffff810c50f1>] sys_delete_module+0x1d1/0x2c0
 [<ffffffff81555855>] ? retint_swapgs+0x13/0x1b
 [<ffffffff810e169c>] ? __audit_syscall_entry+0xcc/0x210
 [<ffffffff812896ce>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8155de69>] system_call_fastpath+0x16/0x1b
---[ end trace 8070f580fc119b8b ]---
------------[ cut here ]------------
WARNING: at lib/debugobjects.c:261 debug_print_object+0x8e/0xb0()
Hardware name: SandyBridge Platform
ODEBUG: free active (active state 0) object type: timer_list hint:
ieee80211_sta_bcn_mon_timer+0x0/0x40 [mac80211]
Modules linked in: autofs4 sunrpc cpufreq_ondemand acpi_cpufreq
freq_table mperf ipv6 uinput arc4 sg iwlwifi(-) mac80211 cfg80211 rfkill
coretemp kvm_intel kvm crc32c_intel ghash_clmulni_intel microcode pcspkr
lpc_ich mfd_core i2c_i801 e1000e ext4 mbcache jbd2 sd_mod crc_t10dif
sr_mod cdrom aesni_intel cryptd aes_x86_64 aes_generic ahci libahci i915
drm_kms_helper drm i2c_algo_bit i2c_core video dm_mirror dm_region_hash
dm_log dm_mod [last unloaded: scsi_wait_scan]
Pid: 3064, comm: modprobe Tainted: G        W    3.5.0 #1
Call Trace:
 [<ffffffff810535af>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff810536a6>] warn_slowpath_fmt+0x46/0x50
 [<ffffffff812901be>] debug_print_object+0x8e/0xb0
 [<ffffffffa03a09f0>] ? ieee80211_sta_conn_mon_timer+0x40/0x40
[mac80211]
 [<ffffffff81290a0d>] __debug_check_no_obj_freed+0x10d/0x200
 [<ffffffff81290b1d>] debug_check_no_obj_freed+0x1d/0x30
 [<ffffffff8117a2b0>] kfree+0xc0/0x330
 [<ffffffff810b9083>] ? __lock_release+0x133/0x1a0
 [<ffffffff815555f0>] ? _raw_spin_unlock_irqrestore+0x40/0x80
 [<ffffffff814957c4>] netdev_release+0x44/0x60
 [<ffffffff813704b7>] device_release+0x27/0xa0
 [<ffffffff8127da42>] kobject_cleanup+0x82/0x1b0
 [<ffffffff8127db7d>] kobject_release+0xd/0x10
 [<ffffffff8127d8cc>] kobject_put+0x2c/0x60
 [<ffffffff8147e371>] netdev_run_todo+0x101/0x180
 [<ffffffff8148f5ae>] rtnl_unlock+0xe/0x10
 [<ffffffffa0366178>] ieee80211_unregister_hw+0x58/0x120 [mac80211]
 [<ffffffffa040912b>] iwlagn_mac_unregister+0x2b/0x40 [iwlwifi]
 [<ffffffffa03fdf59>] iwl_op_mode_dvm_stop+0x49/0xf0 [iwlwifi]
 [<ffffffffa041f730>] iwl_drv_stop+0x40/0x60 [iwlwifi]
 [<ffffffffa0430a39>] iwl_pci_remove+0x25/0x3c [iwlwifi]
 [<ffffffff812aafc2>] pci_device_remove+0x52/0x120
 [<ffffffff813741cc>] __device_release_driver+0x7c/0xe0
 [<ffffffff81374308>] driver_detach+0xd8/0xe0
 [<ffffffff81372f61>] bus_remove_driver+0x91/0x110
 [<ffffffff81374fd2>] driver_unregister+0x62/0xa0
 [<ffffffff812ab2b4>] pci_unregister_driver+0x44/0xa0
 [<ffffffffa041f3d5>] iwl_pci_unregister_driver+0x15/0x20 [iwlwifi]
 [<ffffffffa0430a01>] iwl_exit+0x9/0x1c [iwlwifi]
 [<ffffffff810c50f1>] sys_delete_module+0x1d1/0x2c0
 [<ffffffff81555855>] ? retint_swapgs+0x13/0x1b
 [<ffffffff810e169c>] ? __audit_syscall_entry+0xcc/0x210
 [<ffffffff812896ce>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8155de69>] system_call_fastpath+0x16/0x1b
---[ end trace 8070f580fc119b8c ]---
Bridge firewalling registered

> misc:" is getting 10 "invalid misc" packets in 10 seconds normal?
> Several 'VAL=`date`; VAL="$VAL $(iwconfig wlan0 |grep "Invalid
> misc")"; echo $VAL' follow:
> Seg Set 24 15:06:36 WEST 2012 Tx excessive retries:5 Invalid misc:133
> Missed beacon:0
> Seg Set 24 15:06:46 WEST 2012 Tx excessive retries:5 Invalid misc:143
> Missed beacon:0
> Seg Set 24 15:07:00 WEST 2012 Tx excessive retries:5 Invalid misc:148
> Missed beacon:0
> Seg Set 24 15:21:46 WEST 2012 Tx excessive retries:22 Invalid misc:495
> Missed beacon:0
> Seg Set 24 15:24:41 WEST 2012 Tx excessive retries:24 Invalid misc:593
> Missed beacon:0

I see lot of that. This can be caused by noisy radio environment, but also
can be a firmware/driver bug. Unfortunately those kind of bugs are not
easy to fix.

Stanislaw
