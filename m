Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:37564 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbZEJMUa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 May 2009 08:20:30 -0400
Received: by fxm2 with SMTP id 2so2187858fxm.37
        for <linux-wireless@vger.kernel.org>; Sun, 10 May 2009 05:20:29 -0700 (PDT)
Subject: Re: [BUG] Crda oopses the system
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Pavel Roskin <proski@gnu.org>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1241642056.3289.6.camel@mj>
References: <1241499867.4816.18.camel@maxim-laptop>
	 <43e72e890905051146n48bdad57s9db40a6e016cb81b@mail.gmail.com>
	 <1241606838.18657.1.camel@maxim-laptop>  <1241642056.3289.6.camel@mj>
Content-Type: text/plain
Date: Sun, 10 May 2009 15:20:23 +0300
Message-Id: <1241958023.6051.14.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-05-06 at 16:34 -0400, Pavel Roskin wrote:
> gdb /lib/modules/`uname -r`/kernel/net/wireless/cfg80211.ko

I have recompiled the kernel with debugging info.

This is new backtrace:


> May  7 10:27:05 maxim-laptop kernel: [ 5411.203085] ------------[ cut here ]------------
> May  7 10:27:05 maxim-laptop kernel: [ 5411.203096] kernel BUG at /home/maxim/software/kernel/linux-2.6/net/wireless/reg.c:2039!
> May  7 10:27:05 maxim-laptop kernel: [ 5411.203103] invalid opcode: 0000 [#1] PREEMPT SMP 
> May  7 10:27:05 maxim-laptop kernel: [ 5411.203115] last sysfs file: /sys/devices/platform/coretemp.1/temp1_input
> May  7 10:27:05 maxim-laptop kernel: [ 5411.203121] CPU 0 
> May  7 10:27:05 maxim-laptop kernel: [ 5411.203127] Modules linked in: iwl3945 iwlcore mac80211 cfg80211 cpufreq_stats af_packet nvidia(P) nfsd exportfs nfs lockd nfs_acl auth_rpcgss sunrpc usb_storage usb_libusual cpufreq_powersave cpufreq_conservative cpufreq_userspace acpi_cpufreq coretemp sbp2 snd_hda_codec_realtek snd_hda_intel joydev snd_hda_codec uvcvideo snd_hwdep videodev v4l1_compat acer_wmi rfkill v4l2_compat_ioctl32 sdhci_pci uhci_hcd snd_pcm backlight psmouse serio_raw ohci1394 sdhci iTCO_wdt iTCO_vendor_support snd_timer snd_page_alloc ehci_hcd usbcore evdev wmi fuse [last unloaded: cfg80211]
> May  7 10:27:05 maxim-laptop kernel: [ 5411.203258] Pid: 20876, comm: crda Tainted: P           2.6.30-rc4-wl #58 Aspire 5720     
> May  7 10:27:05 maxim-laptop kernel: [ 5411.203265] RIP: 0010:[<ffffffffa0c9611e>]  [<ffffffffa0c9611e>] set_regdom+0x43e/0x4d0 [cfg80211]
> May  7 10:27:05 maxim-laptop kernel: [ 5411.203291] RSP: 0018:ffff8800638c1978  EFLAGS: 00010246
> May  7 10:27:05 maxim-laptop kernel: [ 5411.203296] RAX: ffff88005176df68 RBX: ffff880034b601a0 RCX: ffffffffa0ca9540
> May  7 10:27:05 maxim-laptop kernel: [ 5411.203302] RDX: ffff880034b60000 RSI: 0000000000000000 RDI: 0000000000000000
> May  7 10:27:05 maxim-laptop kernel: [ 5411.203308] RBP: ffff8800638c1998 R08: 0000000000000001 R09: 0000000000000001
> May  7 10:27:05 maxim-laptop kernel: [ 5411.203314] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88004f889a90
> May  7 10:27:05 maxim-laptop kernel: [ 5411.203320] R13: ffff88007e18e6e0 R14: 0000000000000001 R15: 0000000000000001
> May  7 10:27:05 maxim-laptop kernel: [ 5411.203326] FS:  00007f1c069c56f0(0000) GS:ffff880001025000(0000) knlGS:0000000000000000
> May  7 10:27:05 maxim-laptop kernel: [ 5411.203333] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> May  7 10:27:05 maxim-laptop kernel: [ 5411.203338] CR2: 00007f1c0632fdb0 CR3: 000000007fa65000 CR4: 00000000000006e0
> May  7 10:27:05 maxim-laptop kernel: [ 5411.203344] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> May  7 10:27:05 maxim-laptop kernel: [ 5411.203350] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> May  7 10:27:05 maxim-laptop kernel: [ 5411.203357] Process crda (pid: 20876, threadinfo ffff8800638c0000, task ffff880067093e80)
> May  7 10:27:05 maxim-laptop kernel: [ 5411.203362] Stack:
> May  7 10:27:05 maxim-laptop kernel: [ 5411.203366]  0000000000000000 ffff88004f889a90 0000000000000000 ffff88007e18e6e0
> May  7 10:27:05 maxim-laptop kernel: [ 5411.203379]  ffff8800638c1a28 ffffffffa0c9c672 ffff88005e15ab40 ffff88004f889a90
> May  7 10:27:05 maxim-laptop kernel: [ 5411.203393]  0000000000000000 ffff88007e18e6e4 ffff88007e18e6ec ffff88007e18e6f4
> May  7 10:27:05 maxim-laptop kernel: [ 5411.203410] Call Trace:
> May  7 10:27:05 maxim-laptop kernel: [ 5411.203416]  [<ffffffffa0c9c672>] nl80211_set_reg+0x112/0x2c0 [cfg80211]
> May  7 10:27:05 maxim-laptop kernel: [ 5411.203436]  [<ffffffff80412c8f>] ? nla_parse+0xef/0x110
> May  7 10:27:05 maxim-laptop kernel: [ 5411.203450]  [<ffffffff8054dac6>] genl_rcv_msg+0x1b6/0x1f0
> May  7 10:27:05 maxim-laptop kernel: [ 5411.203462]  [<ffffffff8054d910>] ? genl_rcv_msg+0x0/0x1f0
> May  7 10:27:05 maxim-laptop kernel: [ 5411.203471]  [<ffffffff8054d0e9>] netlink_rcv_skb+0x89/0xb0
> May  7 10:27:05 maxim-laptop kernel: [ 5411.203479]  [<ffffffff8054d8ee>] genl_rcv+0x2e/0x50
> May  7 10:27:05 maxim-laptop kernel: [ 5411.203488]  [<ffffffff8054c917>] ? netlink_unicast+0x117/0x2e0
> May  7 10:27:05 maxim-laptop kernel: [ 5411.203498]  [<ffffffff8054cac4>] netlink_unicast+0x2c4/0x2e0
> May  7 10:27:05 maxim-laptop kernel: [ 5411.203508]  [<ffffffff8052c4b3>] ? __alloc_skb+0x73/0x160
> May  7 10:27:05 maxim-laptop kernel: [ 5411.203519]  [<ffffffff8054ccde>] netlink_sendmsg+0x1fe/0x300
> May  7 10:27:05 maxim-laptop kernel: [ 5411.203528]  [<ffffffff80522f07>] sock_sendmsg+0x127/0x140
> May  7 10:27:05 maxim-laptop kernel: [ 5411.203537]  [<ffffffff80522d61>] ? sock_recvmsg+0x141/0x160
> May  7 10:27:05 maxim-laptop kernel: [ 5411.203546]  [<ffffffff80260ad0>] ? autoremove_wake_function+0x0/0x40
> May  7 10:27:05 maxim-laptop kernel: [ 5411.203558]  [<ffffffff80293602>] ? __rcu_read_unlock+0xa2/0xc0
> May  7 10:27:05 maxim-laptop kernel: [ 5411.203567]  [<ffffffff802730e9>] ? trace_hardirqs_on_caller+0x29/0x1c0
> May  7 10:27:05 maxim-laptop kernel: [ 5411.203578]  [<ffffffff805219d0>] ? move_addr_to_kernel+0x30/0x40
> May  7 10:27:05 maxim-laptop kernel: [ 5411.203588]  [<ffffffff8052db51>] ? verify_iovec+0x41/0xd0
> May  7 10:27:05 maxim-laptop kernel: [ 5411.203597]  [<ffffffff805230ae>] sys_sendmsg+0x18e/0x320
> May  7 10:27:05 maxim-laptop kernel: [ 5411.203607]  [<ffffffff805c4505>] ? _spin_unlock_irqrestore+0x65/0x80
> May  7 10:27:05 maxim-laptop kernel: [ 5411.203619]  [<ffffffff805c77b1>] ? sub_preempt_count+0x51/0x60
> May  7 10:27:05 maxim-laptop kernel: [ 5411.203628]  [<ffffffff80403c21>] ? __up_read+0x91/0xb0
> May  7 10:27:05 maxim-laptop kernel: [ 5411.203639]  [<ffffffff802730e9>] ? trace_hardirqs_on_caller+0x29/0x1c0
> May  7 10:27:05 maxim-laptop kernel: [ 5411.203648]  [<ffffffff805c3e4e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> May  7 10:27:05 maxim-laptop kernel: [ 5411.203658]  [<ffffffff8020c15b>] system_call_fastpath+0x16/0x1b
> May  7 10:27:05 maxim-laptop kernel: [ 5411.203670] Code: 90 91 00 00 00 0f be b0 90 00 00 00 48 c7 c7 60 1b ca a0 31 c0 e8 13 9f 92 df e9 4f fe ff ff 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe <0f> 0b eb fe 48 8b 35 17 43 01 00 4c 89 e7 e8 df f8 ff ff 49 89 
> May  7 10:27:05 maxim-laptop kernel: [ 5411.203815] RIP  [<ffffffffa0c9611e>] set_regdom+0x43e/0x4d0 [cfg80211]
> May  7 10:27:05 maxim-laptop kernel: [ 5411.203834]  RSP <ffff8800638c1978>
> May  7 10:27:05 maxim-laptop kernel: [ 5411.203842] ---[ end trace 9723f71e550687a4 ]---
> 


This is GDB output - can be inaccurate - I have pulled latest wireless-testing , and rebuild kernel again.
I will read the source, and try to fix this
This is 100% reproducible  



> (gdb) l *nl80211_set_reg+0x112
> 0x96a2 is in nl80211_set_reg (/home/maxim/software/kernel/linux-2.6/net/wireless/nl80211.c:2587).
> 2582	
> 2583		BUG_ON(rule_idx != num_rules);
> 2584	
> 2585		mutex_lock(&cfg80211_mutex);
> 2586		r = set_regdom(rd);
> 2587		mutex_unlock(&cfg80211_mutex);
> 2588		return r;
> 2589	
> 2590	 bad_reg:
> 2591		kfree(rd);
> (gdb) 


Best regards,
	Maxim Levitsky

