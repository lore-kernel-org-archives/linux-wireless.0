Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:54391 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757776AbaDHVMI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2014 17:12:08 -0400
Message-ID: <53446607.1060609@candelatech.com> (sfid-20140408_231213_154583_EA8ACCB7)
Date: Tue, 08 Apr 2014 14:11:35 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>
CC: ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath10k: ieee80211_restart_work called with hardware scan in progress
References: <53399E42.2090504@candelatech.com> <CA+BoTQmfBGJxwFnpq+7dE7MgL_db5gkCvRVfhk9YFAAPLZQwHQ@mail.gmail.com>
In-Reply-To: <CA+BoTQmfBGJxwFnpq+7dE7MgL_db5gkCvRVfhk9YFAAPLZQwHQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/31/2014 10:32 PM, Michal Kazior wrote:
> On 31 March 2014 18:56, Ben Greear <greearb@candelatech.com> wrote:
>> This came from a customer (demo) system.  Firmware is 10.1.389 based, modified
>> by us.  It has lots of known issues, but I haven't seen the warning
>> below before, and not sure it is specifically a bug with ath10k or not.
> 
> Hmm..

We are seeing crashes that are probably related to this fairly often.

Johannes:  Do you have any suggestion as to how to go about fixing this?

The crash we just saw looks like this:

BUG: unable to handle kernel paging request at 0000000000007ee0
IP: [<ffffffffa02bde7a>] cfg80211_scan_done+0x16/0x5e [cfg80211]
PGD 0
Oops: 0000 [#1] PREEMPT SMP
Modules linked in: nf_nat_ipv4 nf_nat 8021q garp stp mrp llc fuse macvlan pktgen ip6table_filter ip6_tables ebtable_nat ebtables f71882fg snd_hda_codec_realtek
snd_hda_codec_generic ath9k iTCO_wdt gpio_ich iTCO_vendor_support ppdev ath9k_common ath10k_pci snd_hda_intel ath9k_hw snd_hda_codec coretemp hwmon snd_hwdep
intel_powerclamp snd_seq snd_seq_device ath10k_core ath snd_pcm kvm mac80211 snd_timer snd soundcore cfg80211 i2c_i801 microcode serio_raw pcspkr lpc_ich e1000e
ptp pps_core shpchp parport_pc parport uinput ipv6 i915 i2c_algo_bit drm_kms_helper ata_generic pata_acpi drm i2c_core video [last unloaded: iptable_nat]
CPU: 1 PID: 12693 Comm: kworker/u8:0 Tainted: G        WC 3.14.0-wl-ath+ #7
Hardware name: To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M., BIOS 4.6.3 03/06/2012
Workqueue: phy0 ieee80211_scan_work [mac80211]
task: ffff8800bb1cc980 ti: ffff8800b95de000 task.ti: ffff8800b95de000
RIP: 0010:[<ffffffffa02bde7a>]  [<ffffffffa02bde7a>] cfg80211_scan_done+0x16/0x5e [cfg80211]
RSP: 0018:ffff8800b95dfd68  EFLAGS: 00010206
RAX: 0000000000007e00 RBX: ffff8800bb3f8f00 RCX: 0000000180100000
RDX: 0000000180100001 RSI: 0000000000000000 RDI: 0000000000008000
RBP: ffff8800b95dfd78 R08: ffff88022300cc18 R09: 0000000000000000
R10: ffffffffa03604a7 R11: ffff880205461200 R12: ffff880221775300
R13: ffff88020eefc801 R14: 0000000000000022 R15: ffff880221775328
FS:  0000000000000000(0000) GS:ffff88022bc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000007ee0 CR3: 0000000001a0d000 CR4: 00000000000007e0
Stack:
 ffff8802217745e0 ffff880221775300 ffff8800b95dfdc8 ffffffffa036050b
 ffff8800b95dfda8 0000000000000292 ffff8800b95dfda8 ffff8802217745e0
 ffff8802217753d8 ffff88020eefc800 ffff880221775300 ffff880221775328
Call Trace:
 [<ffffffffa036050b>] __ieee80211_scan_completed+0xef/0x1a8 [mac80211]
 [<ffffffffa03611b8>] ieee80211_scan_work+0x3e4/0x3fb [mac80211]
 [<ffffffffa037e82a>] ? sdata_unlock+0xd/0xf [mac80211]
 [<ffffffff810d52af>] process_one_work+0x162/0x216
 [<ffffffff810d5724>] worker_thread+0x12f/0x1fd
 [<ffffffff810d55f5>] ? rescuer_thread+0x268/0x268
 [<ffffffff810d55f5>] ? rescuer_thread+0x268/0x268
 [<ffffffff810da37f>] kthread+0xa0/0xa8
 [<ffffffff810da2df>] ? __kthread_parkme+0x5c/0x5c
 [<ffffffff815b5f8c>] ret_from_fork+0x7c/0xb0
 [<ffffffff810da2df>] ? __kthread_parkme+0x5c/0x5c
Code: fe ff ff 48 83 c4 28 4c 89 e0 5b 41 5c 41 5d 41 5e 41 5f 5d c3 55 48 89 e5 41 54 41 88 f4 53 48 89 fb 48 8b 7f 40 e8 1a f3 ff ff <48> 3b 98 e0 00 00 00 74
11 be f1 00 00 00 48 c7 c7 4b 94 2d a0
RIP  [<ffffffffa02bde7a>] cfg80211_scan_done+0x16/0x5e [cfg80211]
 RSP <ffff8800b95dfd68>
CR2: 0000000000007ee0
ath10k: Creating vdev id: 30  map: 3221225472
ath10k: mac vdev create 30 (add interface) type 2 subtype 0
Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 1
Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
drm_kms_helper: panic occurred, switching back to text console
Rebooting in 10 seconds..


Thanks,
Ben

> 
> 
>> Mar 31 13:49:54 ct521-5332 kernel: ath10k: could not start hw scan (-108)
>> Mar 31 13:49:54 ct521-5332 kernel: ath10k: could not start hw scan (-108)
>> Mar 31 13:49:54 ct521-5332 kernel: ath10k: could not start hw scan (-108)
>> Mar 31 13:49:54 ct521-5332 kernel: ath10k: could not start hw scan (-108)
>> Mar 31 13:49:54 ct521-5332 kernel: ath10k: could not start hw scan (-108)
>> Mar 31 13:49:54 ct521-5332 kernel: ath10k: could not start hw scan (-108)
> 
> -108 = ESHUTDOWN. This can be a result of calling ath10k_halt() IOW
> driver is stopping by mac80211 request or ath10k_core_restart() was
> called. I suppose the latter is the case here.
> 
> ath10k_halt() calls ieee80211_scan_completed(hw, true) if necessary.
> But since it only sets 1 or 2 bits in local->scanning in mac80211 and
> schedules local->scan_work I suspect you can end up having
> local->restart_work scheduled sooner in some cases (both use different
> workqueues: scan_work uses per-hw queue, restart_work uses global
> system queue) and see the following:
> 
>> Mar 31 13:49:54 ct521-5332 kernel: ieee80211_restart_work called with hardware scan in progress
>> Mar 31 13:49:54 ct521-5332 kernel: Modules linked in: nf_nat_ipv4 nf_nat fuse 8021q mrp garp stp llc macvlan pktgen coretemp hwmon sunrpc ipv6 uinput
>> snd_hda_codec_realtek snd_hda_codec_generic ath10k_pci ath10k_core snd_hda_intel mac80211 snd_hda_codec snd_hwdep snd_seq snd_seq_device iTCO_wdt e1000e
>> microcode ath gpio_ich snd_pcm iTCO_vendor_support ppdev ptp snd_timer parport_pc snd cfg80211 parport serio_raw pps_core soundcore pcspkr i2c_i801 lpc_ich i915
>> drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: iptable_nat]
>> Mar 31 13:49:54 ct521-5332 kernel: CPU: 0 PID: 11818 Comm: kworker/0:0 Tainted: G        WC   3.14.0-rc7-wl-ath+ #4
>> Mar 31 13:49:54 ct521-5332 kernel: Hardware name: To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M., BIOS 4.6.3 09/05/2011
>> Mar 31 13:49:54 ct521-5332 kernel: Workqueue: events ieee80211_restart_work [mac80211]
>> Mar 31 13:49:54 ct521-5332 kernel: 0000000000000009 ffff8800bd865d68 ffffffff815ab0a5 ffff88022bc0ec38
>> Mar 31 13:49:54 ct521-5332 kernel: ffff8800bd865db8 ffff8800bd865da8 ffffffff810c1aa8 ffff8800bd865d88
>> Mar 31 13:49:54 ct521-5332 kernel: ffffffffa03858ce ffff8802214d5650 ffff8802214d45e0 ffff8802214d5650
>> Mar 31 13:49:54 ct521-5332 kernel: Call Trace:
>> Mar 31 13:49:54 ct521-5332 kernel: [<ffffffff815ab0a5>] dump_stack+0x4e/0x71
>> Mar 31 13:49:54 ct521-5332 kernel: [<ffffffff810c1aa8>] warn_slowpath_common+0x77/0x91
>> Mar 31 13:49:54 ct521-5332 kernel: [<ffffffffa03858ce>] ? ieee80211_restart_work+0x49/0x68 [mac80211]
>> Mar 31 13:49:54 ct521-5332 kernel: [<ffffffff810c1b56>] warn_slowpath_fmt+0x41/0x43
>> Mar 31 13:49:54 ct521-5332 kernel: [<ffffffffa03858ce>] ieee80211_restart_work+0x49/0x68 [mac80211]
>> Mar 31 13:49:54 ct521-5332 kernel: [<ffffffff810d52af>] process_one_work+0x162/0x216
>> Mar 31 13:49:54 ct521-5332 kernel: [<ffffffff810d5724>] worker_thread+0x12f/0x1fd
>> Mar 31 13:49:54 ct521-5332 kernel: [<ffffffff810d55f5>] ? rescuer_thread+0x268/0x268
>> Mar 31 13:49:54 ct521-5332 kernel: [<ffffffff810d55f5>] ? rescuer_thread+0x268/0x268
>> Mar 31 13:49:54 ct521-5332 kernel: [<ffffffff810da37f>] kthread+0xa0/0xa8
>> Mar 31 13:49:54 ct521-5332 kernel: [<ffffffff810da2df>] ? __kthread_parkme+0x5c/0x5c
>> Mar 31 13:49:54 ct521-5332 kernel: [<ffffffff815b5b4c>] ret_from_fork+0x7c/0xb0
>> Mar 31 13:49:54 ct521-5332 kernel: [<ffffffff810da2df>] ? __kthread_parkme+0x5c/0x5c
>> Mar 31 13:49:54 ct521-5332 kernel: ---[ end trace fd8ccdaa79168e68 ]---
> 
> It seems to me that any mac80211-driver can hit this as long as it
> requests a restart during a scan while something queued via
> ieee80211_queue_work() blocks (that something could be driver worker)
> long enough.


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

