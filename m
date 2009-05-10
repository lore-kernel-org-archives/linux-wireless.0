Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.230]:43450 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755509AbZEJSd2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 May 2009 14:33:28 -0400
Received: by rv-out-0506.google.com with SMTP id f9so1886747rvb.1
        for <linux-wireless@vger.kernel.org>; Sun, 10 May 2009 11:33:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1241958023.6051.14.camel@maxim-laptop>
References: <1241499867.4816.18.camel@maxim-laptop> <43e72e890905051146n48bdad57s9db40a6e016cb81b@mail.gmail.com>
	<1241606838.18657.1.camel@maxim-laptop> <1241642056.3289.6.camel@mj>
	<1241958023.6051.14.camel@maxim-laptop>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sun, 10 May 2009 11:33:09 -0700
Message-ID: <43e72e890905101133w2314250s7b95a8c100e83cce@mail.gmail.com>
Subject: Re: [BUG] Crda oopses the system
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Pavel Roskin <proski@gnu.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 10, 2009 at 5:20 AM, Maxim Levitsky <maximlevitsky@gmail.co=
m> wrote:
> On Wed, 2009-05-06 at 16:34 -0400, Pavel Roskin wrote:
>> gdb /lib/modules/`uname -r`/kernel/net/wireless/cfg80211.ko
>
> I have recompiled the kernel with debugging info.
>
> This is new backtrace:
>
>
>> May =C2=A07 10:27:05 maxim-laptop kernel: [ 5411.203085] -----------=
-[ cut here ]------------
>> May =C2=A07 10:27:05 maxim-laptop kernel: [ 5411.203096] kernel BUG =
at /home/maxim/software/kernel/linux-2.6/net/wireless/reg.c:2039!
>> May =C2=A07 10:27:05 maxim-laptop kernel: [ 5411.203103] invalid opc=
ode: 0000 [#1] PREEMPT SMP
>> May =C2=A07 10:27:05 maxim-laptop kernel: [ 5411.203115] last sysfs =
file: /sys/devices/platform/coretemp.1/temp1_input
>> May =C2=A07 10:27:05 maxim-laptop kernel: [ 5411.203121] CPU 0
>> May =C2=A07 10:27:05 maxim-laptop kernel: [ 5411.203127] Modules lin=
ked in: iwl3945 iwlcore mac80211 cfg80211 cpufreq_stats af_packet nvidi=
a(P) nfsd exportfs nfs lockd nfs_acl auth_rpcgss sunrpc usb_storage usb=
_libusual cpufreq_powersave cpufreq_conservative cpufreq_userspace acpi=
_cpufreq coretemp sbp2 snd_hda_codec_realtek snd_hda_intel joydev snd_h=
da_codec uvcvideo snd_hwdep videodev v4l1_compat acer_wmi rfkill v4l2_c=
ompat_ioctl32 sdhci_pci uhci_hcd snd_pcm backlight psmouse serio_raw oh=
ci1394 sdhci iTCO_wdt iTCO_vendor_support snd_timer snd_page_alloc ehci=
_hcd usbcore evdev wmi fuse [last unloaded: cfg80211]
>> May =C2=A07 10:27:05 maxim-laptop kernel: [ 5411.203258] Pid: 20876,=
 comm: crda Tainted: P =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 2.6.30-rc4-wl=
 #58 Aspire 5720
>> May =C2=A07 10:27:05 maxim-laptop kernel: [ 5411.203265] RIP: 0010:[=
<ffffffffa0c9611e>] =C2=A0[<ffffffffa0c9611e>] set_regdom+0x43e/0x4d0 [=
cfg80211]
>> May =C2=A07 10:27:05 maxim-laptop kernel: [ 5411.203291] RSP: 0018:f=
fff8800638c1978 =C2=A0EFLAGS: 00010246
>> May =C2=A07 10:27:05 maxim-laptop kernel: [ 5411.203296] RAX: ffff88=
005176df68 RBX: ffff880034b601a0 RCX: ffffffffa0ca9540
>> May =C2=A07 10:27:05 maxim-laptop kernel: [ 5411.203302] RDX: ffff88=
0034b60000 RSI: 0000000000000000 RDI: 0000000000000000
>> May =C2=A07 10:27:05 maxim-laptop kernel: [ 5411.203308] RBP: ffff88=
00638c1998 R08: 0000000000000001 R09: 0000000000000001
>> May =C2=A07 10:27:05 maxim-laptop kernel: [ 5411.203314] R10: 000000=
0000000000 R11: 0000000000000000 R12: ffff88004f889a90
>> May =C2=A07 10:27:05 maxim-laptop kernel: [ 5411.203320] R13: ffff88=
007e18e6e0 R14: 0000000000000001 R15: 0000000000000001
>> May =C2=A07 10:27:05 maxim-laptop kernel: [ 5411.203326] FS: =C2=A00=
0007f1c069c56f0(0000) GS:ffff880001025000(0000) knlGS:0000000000000000
>> May =C2=A07 10:27:05 maxim-laptop kernel: [ 5411.203333] CS: =C2=A00=
010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> May =C2=A07 10:27:05 maxim-laptop kernel: [ 5411.203338] CR2: 00007f=
1c0632fdb0 CR3: 000000007fa65000 CR4: 00000000000006e0
>> May =C2=A07 10:27:05 maxim-laptop kernel: [ 5411.203344] DR0: 000000=
0000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> May =C2=A07 10:27:05 maxim-laptop kernel: [ 5411.203350] DR3: 000000=
0000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> May =C2=A07 10:27:05 maxim-laptop kernel: [ 5411.203357] Process crd=
a (pid: 20876, threadinfo ffff8800638c0000, task ffff880067093e80)
>> May =C2=A07 10:27:05 maxim-laptop kernel: [ 5411.203362] Stack:
>> May =C2=A07 10:27:05 maxim-laptop kernel: [ 5411.203366] =C2=A000000=
00000000000 ffff88004f889a90 0000000000000000 ffff88007e18e6e0
>> May =C2=A07 10:27:05 maxim-laptop kernel: [ 5411.203379] =C2=A0ffff8=
800638c1a28 ffffffffa0c9c672 ffff88005e15ab40 ffff88004f889a90
>> May =C2=A07 10:27:05 maxim-laptop kernel: [ 5411.203393] =C2=A000000=
00000000000 ffff88007e18e6e4 ffff88007e18e6ec ffff88007e18e6f4
>> May =C2=A07 10:27:05 maxim-laptop kernel: [ 5411.203410] Call Trace:
>> May =C2=A07 10:27:05 maxim-laptop kernel: [ 5411.203416] =C2=A0[<fff=
fffffa0c9c672>] nl80211_set_reg+0x112/0x2c0 [cfg80211]
>> May =C2=A07 10:27:05 maxim-laptop kernel: [ 5411.203436] =C2=A0[<fff=
fffff80412c8f>] ? nla_parse+0xef/0x110
>> May =C2=A07 10:27:05 maxim-laptop kernel: [ 5411.203450] =C2=A0[<fff=
fffff8054dac6>] genl_rcv_msg+0x1b6/0x1f0
>> May =C2=A07 10:27:05 maxim-laptop kernel: [ 5411.203462] =C2=A0[<fff=
fffff8054d910>] ? genl_rcv_msg+0x0/0x1f0
>> May =C2=A07 10:27:05 maxim-laptop kernel: [ 5411.203471] =C2=A0[<fff=
fffff8054d0e9>] netlink_rcv_skb+0x89/0xb0
>> May =C2=A07 10:27:05 maxim-laptop kernel: [ 5411.203479] =C2=A0[<fff=
fffff8054d8ee>] genl_rcv+0x2e/0x50
>> May =C2=A07 10:27:05 maxim-laptop kernel: [ 5411.203488] =C2=A0[<fff=
fffff8054c917>] ? netlink_unicast+0x117/0x2e0
>> May =C2=A07 10:27:05 maxim-laptop kernel: [ 5411.203498] =C2=A0[<fff=
fffff8054cac4>] netlink_unicast+0x2c4/0x2e0
>> May =C2=A07 10:27:05 maxim-laptop kernel: [ 5411.203508] =C2=A0[<fff=
fffff8052c4b3>] ? __alloc_skb+0x73/0x160
>> May =C2=A07 10:27:05 maxim-laptop kernel: [ 5411.203519] =C2=A0[<fff=
fffff8054ccde>] netlink_sendmsg+0x1fe/0x300
>> May =C2=A07 10:27:05 maxim-laptop kernel: [ 5411.203528] =C2=A0[<fff=
fffff80522f07>] sock_sendmsg+0x127/0x140
>> May =C2=A07 10:27:05 maxim-laptop kernel: [ 5411.203537] =C2=A0[<fff=
fffff80522d61>] ? sock_recvmsg+0x141/0x160
>> May =C2=A07 10:27:05 maxim-laptop kernel: [ 5411.203546] =C2=A0[<fff=
fffff80260ad0>] ? autoremove_wake_function+0x0/0x40
>> May =C2=A07 10:27:05 maxim-laptop kernel: [ 5411.203558] =C2=A0[<fff=
fffff80293602>] ? __rcu_read_unlock+0xa2/0xc0
>> May =C2=A07 10:27:05 maxim-laptop kernel: [ 5411.203567] =C2=A0[<fff=
fffff802730e9>] ? trace_hardirqs_on_caller+0x29/0x1c0
>> May =C2=A07 10:27:05 maxim-laptop kernel: [ 5411.203578] =C2=A0[<fff=
fffff805219d0>] ? move_addr_to_kernel+0x30/0x40
>> May =C2=A07 10:27:05 maxim-laptop kernel: [ 5411.203588] =C2=A0[<fff=
fffff8052db51>] ? verify_iovec+0x41/0xd0
>> May =C2=A07 10:27:05 maxim-laptop kernel: [ 5411.203597] =C2=A0[<fff=
fffff805230ae>] sys_sendmsg+0x18e/0x320
>> May =C2=A07 10:27:05 maxim-laptop kernel: [ 5411.203607] =C2=A0[<fff=
fffff805c4505>] ? _spin_unlock_irqrestore+0x65/0x80
>> May =C2=A07 10:27:05 maxim-laptop kernel: [ 5411.203619] =C2=A0[<fff=
fffff805c77b1>] ? sub_preempt_count+0x51/0x60
>> May =C2=A07 10:27:05 maxim-laptop kernel: [ 5411.203628] =C2=A0[<fff=
fffff80403c21>] ? __up_read+0x91/0xb0
>> May =C2=A07 10:27:05 maxim-laptop kernel: [ 5411.203639] =C2=A0[<fff=
fffff802730e9>] ? trace_hardirqs_on_caller+0x29/0x1c0
>> May =C2=A07 10:27:05 maxim-laptop kernel: [ 5411.203648] =C2=A0[<fff=
fffff805c3e4e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>> May =C2=A07 10:27:05 maxim-laptop kernel: [ 5411.203658] =C2=A0[<fff=
fffff8020c15b>] system_call_fastpath+0x16/0x1b
>> May =C2=A07 10:27:05 maxim-laptop kernel: [ 5411.203670] Code: 90 91=
 00 00 00 0f be b0 90 00 00 00 48 c7 c7 60 1b ca a0 31 c0 e8 13 9f 92 d=
f e9 4f fe ff ff 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe <0f> 0b eb fe 48 8=
b 35 17 43 01 00 4c 89 e7 e8 df f8 ff ff 49 89
>> May =C2=A07 10:27:05 maxim-laptop kernel: [ 5411.203815] RIP =C2=A0[=
<ffffffffa0c9611e>] set_regdom+0x43e/0x4d0 [cfg80211]
>> May =C2=A07 10:27:05 maxim-laptop kernel: [ 5411.203834] =C2=A0RSP <=
ffff8800638c1978>
>> May =C2=A07 10:27:05 maxim-laptop kernel: [ 5411.203842] ---[ end tr=
ace 9723f71e550687a4 ]---
>>
>
>
> This is GDB output - can be inaccurate - I have pulled latest wireles=
s-testing , and rebuild kernel again.
> I will read the source, and try to fix this
> This is 100% reproducible
>
>
>
>> (gdb) l *nl80211_set_reg+0x112
>> 0x96a2 is in nl80211_set_reg (/home/maxim/software/kernel/linux-2.6/=
net/wireless/nl80211.c:2587).
>> 2582
>> 2583 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0BUG_ON(rule_idx !=3D num_rule=
s);
>> 2584
>> 2585 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mutex_lock(&cfg80211_mutex);
>> 2586 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0r =3D set_regdom(rd);
>> 2587 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mutex_unlock(&cfg80211_mutex)=
;
>> 2588 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return r;
>> 2589
>> 2590 =C2=A0 bad_reg:
>> 2591 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0kfree(rd);
>> (gdb)
>

Hm I don't see a BUG_ON at my net/wireless/reg.c:2039, can you please
try with wireless-testing or paste the line 2039 in your
net/wrieless/reg.c. Also if you can provide steps to how to get the
code you have and how to reproduce it would help.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
