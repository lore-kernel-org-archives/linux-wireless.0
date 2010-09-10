Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:64734 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586Ab0IJFGL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Sep 2010 01:06:11 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 09 Sep 2010 22:06:05 -0700
Date: Fri, 10 Sep 2010 10:37:19 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: Ben Greear <greearb@candelatech.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k oops on rmmod
Message-ID: <20100910050719.GA3959@vmraj-lnx.users.atheros.com>
References: <4C891102.40406@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4C891102.40406@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following commit solves the issue.

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=8a2e8e5dec7e29c56a46ba176c664ab6a3d04118

Thanks,
Rajkumar

On Thu, Sep 09, 2010 at 10:23:22PM +0530, Ben Greear wrote:
> This is from yesterday's wireless-testing repository:
> 
> I had created two STA interfaces (they didn't really work, but they added ok it seems),
> and then attempted to rmmod ath9k.
> 
> ------------[ cut here ]------------
> kernel BUG at /home/greearb/git/linux.wireless-testing/kernel/workqueue.c:2853!
> invalid opcode: 0000 [#1] SMP
> last sysfs file: /sys/devices/system/cpu/cpu1/cache/index1/shared_cpu_map
> Modules linked in: aes_i586 aes_generic fuse 8021q garp stp llc michael_mic macvlan pktgen nfs lockd fscache nfs_acl auth_rpcgss sunrpc ipv6 uinput arc4 ecb 
> ath9k(-) mac80211 ath9k_common i2c_i801 e1000e ath9k_hw ath pcspkr cfg80211 iTCO_wdt iTCO_vendor_support microcode i915 drm_kms_helper drm i2c_algo_bit i2c_core 
> video output [last unloaded: ipt_addrtype]
> 
> Pid: 18706, comm: rmmod Not tainted 2.6.36-rc3-wl+ #4 PDSBM/PDSBM
> EIP: 0060:[<c0443483>] EFLAGS: 00010286 CPU: 0
> EIP is at destroy_workqueue+0x86/0xc8
> EAX: 00000020 EBX: f71f9c00 ECX: 0000000f EDX: f737e900
> ESI: c0943e84 EDI: f8ba0000 EBP: f49dbe90 ESP: f49dbe88
>   DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process rmmod (pid: 18706, ti=f49da000 task=f48d1a90 task.ti=f49da000)
> Stack:
>   f658c320 00000000 f49dbe9c f8a9313b f658d394 f49dbeb4 f8ad6706 f658c320
> <0> f658d394 f7100800 f8ba0000 f49dbec8 f8ae075a f7100860 f8ae7028 f7100800
> <0> f49dbedc c0585c49 f7100860 f8ae7058 f7100894 f49dbeec c0606fd6 f7100860
> Call Trace:
>   [<f8a9313b>] ? ieee80211_unregister_hw+0xce/0xf4 [mac80211]
>   [<f8ad6706>] ? ath9k_deinit_device+0x60/0x83 [ath9k]
>   [<f8ae075a>] ? ath_pci_remove+0x22/0x54 [ath9k]
>   [<c0585c49>] ? pci_device_remove+0x27/0xa3
>   [<c0606fd6>] ? __device_release_driver+0x59/0x9d
>   [<c0607081>] ? driver_detach+0x67/0x85
>   [<c060659d>] ? bus_remove_driver+0x69/0x85
>   [<c06074ae>] ? driver_unregister+0x4b/0x52
>   [<c0585e74>] ? pci_unregister_driver+0x2d/0x6e
>   [<f8ae0659>] ? ath_pci_exit+0xd/0xf [ath9k]
>   [<f8ae2be4>] ? ath9k_exit+0x8/0x2f [ath9k]
>   [<c04576ae>] ? sys_delete_module+0x16f/0x1c0
>   [<c0749f91>] ? do_page_fault+0x26a/0x2c5
>   [<c0749fbf>] ? do_page_fault+0x298/0x2c5
>   [<c0402f9c>] ? sysenter_do_call+0x12/0x28
> Code: 80 3c 94 c0 eb 0c 83 f8 20 75 05 8b 53 04 eb 02 31 d2 31 c9 83 7c 8a 10 00 74 04 0f 0b eb fe 41 83 f9 0f 75 ef 83 7a 4c 00 74 04 <0f> 0b eb fe 8d 4a 54 39 
> 4a 54 74 04 0f 0b eb fe 89 d9 89 f2 e8
> EIP: [<c0443483>] destroy_workqueue+0x86/0xc8 SS:ESP 0068:f49dbe88
> ---[ end trace dbb86888d9028055 ]---
> 
> -- 
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
