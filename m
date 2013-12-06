Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35417 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150Ab3LFBKF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 20:10:05 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Vojvf-00073T-DT
	for linux-wireless@vger.kernel.org; Fri, 06 Dec 2013 02:10:03 +0100
Received: from 70-35-43-50.static.wiline.com ([70.35.43.50])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 06 Dec 2013 02:10:03 +0100
Received: from jlopex by 70-35-43-50.static.wiline.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 06 Dec 2013 02:10:03 +0100
To: linux-wireless@vger.kernel.org
From: Javier Lopez <jlopex@cozybit.com>
Subject: Re: Using wmediumd in kernel 3.10
Date: Fri, 6 Dec 2013 01:04:32 +0000 (UTC)
Message-ID: <loom.20131206T020025-333@post.gmane.org> (sfid-20131206_021010_159565_531584AC)
References: <1386259047.2121.YahooMailNeo@web172705.mail.ir2.yahoo.com>			 (sfid-20131205_165733_059424_F6F2D350) <1386259875.4182.15.camel@jlt4.sipsolutions.net>		 <1386260074.45953.YahooMailNeo@web172706.mail.ir2.yahoo.com>	 <1386260744.4182.18.camel@jlt4.sipsolutions.net>	 <1386261738.73311.YahooMailNeo@web172703.mail.ir2.yahoo.com> <1386265226.4182.20.camel@jlt4.sipsolutions.net> <1386279479.16148.YahooMailNeo@web172701.mail.ir2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dani Camps <danicamps81@...> writes:

> 
> Hi,
> 
> I tried with kernel 3.12 but I still get the same error. Just to clarify,
if wmediumd would work properly you
> should see in the ping approximately half of the packets being dropped,
because the configuration file
> has 0.5 drop probability for all rates. If you see that the ping proceeds
normally is because the error
> happened and wmediumd de-registered.
> 
> I attach the error I see in syslog.
> 
> Best Regards
> 
> Daniel
> 

Hi Dani, Johannes,

I was able to reproduce your issue with latest version of wireless-testing
and wmediumd.

The problem is that txi->rate_driver_data[0] is not set on
hwsim_tx_info_frame_received_nl(). Later mac80211_hwsim_monitor_ack()
crashes while accessing that information.

I'm preparing a patch to fix this.

Jlo 
 
> El Jueves 5 de diciembre de 2013 18:40, Johannes Berg <johannes <at>
sipsolutions.net> escribió:
> On Thu, 2013-12-05 at 16:42 +0000, Dani Camps wrote:
> > ping -I mesh0 192.168.77.11
> 
> Works fine for me. Maybe you should try a later backports version, e.g.
> 3.12? I don't remember fixing anything, but I don't see any issues
> either.
> 
> johannes
> 
> Dec  5 13:28:21 mininet-vm kernel: [  261.300120] mac80211_hwsim: received
a REGISTER, switching to
> wmediumd mode with pid 1561
> Dec  5 13:28:44 mininet-vm kernel: [  284.292247] BUG: unable to handle
kernel NULL pointer dereference at 00000004
> Dec  5 13:28:44 mininet-vm kernel: [  284.292247] IP: [<f81ddf99>]
> mac80211_hwsim_monitor_ack.isra.19.part.20+0x49/0x120 [mac80211_hwsim]
> Dec  5 13:28:44 mininet-vm kernel: [  284.292247] *pde = 7ebc1067
> Dec  5 13:28:44 mininet-vm kernel: [  284.292247] Oops: 0000 [#1] SMP
> Dec  5 13:28:44 mininet-vm kernel: [  284.292247] Modules linked in: arc4
mac80211_hwsim mac80211
> cfg80211 compat vesafb ppdev joydev snd_intel8x0 snd_ac97_codec ac97_bus
binfmt_misc snd_pcm
> psmouse serio_raw parport_pc snd_timer snd soundcore snd_page_alloc
i2c_piix4 lp parport usbhid hid
> ahci libahci e1000
> Dec  5 13:28:44 mininet-vm kernel: [  284.292247]
> Dec  5 13:28:44 mininet-vm kernel: [  284.292247] Pid: 1561, comm:
wmediumd Tainted: G        W   3.0.0-12-generic
> #20-Ubuntu innotek GmbH VirtualBox/VirtualBox
> Dec  5 13:28:44 mininet-vm kernel: [  284.292247] EIP: 0060:[<f81ddf99>]
EFLAGS: 00010287 CPU: 0
> Dec  5 13:28:44 mininet-vm kernel: [  284.292247] EIP is at
> mac80211_hwsim_monitor_ack.isra.19.part.20+0x49/0x120 [mac80211_hwsim]
> Dec  5 13:28:44 mininet-vm kernel: [  284.292247] EAX: f28e3640 EBX:
f2dc3900 ECX: f2dc3900 EDX: 00000016
> Dec  5 13:28:44 mininet-vm kernel: [  284.292247] ESI: f28e3c58 EDI:
00000004 EBP: f2d0bc34 ESP: f2d0bc28
> Dec  5 13:28:44 mininet-vm kernel: [  284.292247]  DS: 007b ES: 007b FS:
00d8 GS: 00e0 SS: 0068
> Dec  5 13:28:44 mininet-vm kernel: [  284.292247] Process wmediumd (pid:
1561, ti=f2d0a000 task=f2986600 task.ti=f2d0a000)
> Dec  5 13:28:44 mininet-vm kernel: [  284.292247] Stack:
> Dec  5 13:28:44 mininet-vm kernel: [  284.292247]  f2dc3c00 f2dc3c2c
f2dc3c21 f2d0bc60 f81de54c 00000004
> f2d0bc8c f2dc3c00
> Dec  5 13:28:44 mininet-vm kernel: [  284.292247]  f29295a0 f2dc3c00
00000000 f81e3260 f81e31c0 00000000
> f2d0bcbc c145d4f4
> Dec  5 13:28:44 mininet-vm kernel: [  284.292247]  00000038 f81e32a0
00000008 f81e32a0 00000004 c1943e40
> f28e3410 f2dc3600
> Dec  5 13:28:44 mininet-vm kernel: [  284.292247] Call Trace:
> Dec  5 13:28:44 mininet-vm kernel: [  284.292247]  [<f81de54c>]
> hwsim_tx_info_frame_received_nl+0x1dc/0x1e0 [mac80211_hwsim]
> Dec  5 13:28:44 mininet-vm kernel: [  284.292247]  [<c145d4f4>]
genl_rcv_msg+0x1c4/0x240
> Dec  5 13:28:44 mininet-vm kernel: [  284.292247]  [<c145d330>] ?
genl_rcv+0x30/0x30
> Dec  5 13:28:44 mininet-vm kernel: [  284.292247]  [<c145ce9e>]
netlink_rcv_skb+0x8e/0xb0
> Dec  5 13:28:44 mininet-vm kernel: [  284.292247]  [<c145d31c>]
genl_rcv+0x1c/0x30
> Dec  5 13:28:44 mininet-vm kernel: [  284.292247]  [<c145c8a9>]
netlink_unicast+0x239/0x290
> Dec  5 13:28:44 mininet-vm kernel: [  284.292247]  [<c145cb5b>]
netlink_sendmsg+0x25b/0x2e0
> Dec  5 13:28:44 mininet-vm kernel: [  284.292247]  [<c1425d7c>]
sock_sendmsg+0xec/0x110
> Dec  5 13:28:44 mininet-vm kernel: [  284.292247]  [<c10320d2>] ?
check_preempt_curr+0x72/0x90
> Dec  5 13:28:44 mininet-vm kernel: [  284.292247]  [<c128836f>] ?
__copy_from_user_ll+0x1f/0x40
> Dec  5 13:28:44 mininet-vm kernel: [  284.292247]  [<c1288502>] ?
_copy_from_user+0x42/0x60
> Dec  5 13:28:44 mininet-vm kernel: [  284.292247]  [<c1430d44>] ?
verify_iovec+0x44/0xb0
> Dec  5 13:28:44 mininet-vm kernel: [  284.292247]  [<c1427590>]
__sys_sendmsg+0x270/0x280
> Dec  5 13:28:44 mininet-vm kernel: [  284.292247]  [<c1041600>] ?
default_wake_function+0x10/0x20
> Dec  5 13:28:44 mininet-vm kernel: [  284.292247]  [<c102e277>] ?
__wake_up_common+0x47/0x70
> Dec  5 13:28:44 mininet-vm kernel: [  284.292247]  [<c102fa85>] ?
__wake_up+0x45/0x60
> Dec  5 13:28:44 mininet-vm kernel: [  284.292247]  [<c1311049>] ?
tty_wakeup+0x39/0x70
> Dec  5 13:28:44 mininet-vm kernel: [  284.292247]  [<c131ab29>] ?
pty_write+0x69/0x70
> Dec  5 13:28:44 mininet-vm kernel: [  284.292247]  [<c1026018>] ?
default_spin_lock_flags+0x8/0x10
> Dec  5 13:28:44 mininet-vm kernel: [  284.292247]  [<c152c6fd>] ?
_raw_spin_lock_irqsave+0x2d/0x40
> Dec  5 13:28:44 mininet-vm kernel: [  284.292247]  [<c102fa85>] ?
__wake_up+0x45/0x60
> Dec  5 13:28:44 mininet-vm kernel: [  284.292247]  [<c115bc88>] ?
fsnotify+0x198/0x250
> Dec  5 13:28:44 mininet-vm kernel: [  284.292247]  [<c142839b>]
sys_sendmsg+0x3b/0x60
> Dec  5 13:28:44 mininet-vm kernel: [  284.292247]  [<c1428a23>]
sys_socketcall+0x263/0x2c0
> Dec  5 13:28:44 mininet-vm kernel: [  284.292247]  [<c152c8e4>]
syscall_call+0x7/0xb
> Dec  5 13:28:44 mininet-vm kernel: [  284.292247] Code: 84 bd 00 00 00 ba
16 00 00 00 e8 23 f2 24 c9 c6 00 00 c6 40 01 00
> 66 c7 40 02 16 00 c7 40 04 0a 00 00 00 c6 40 10 00 c6 40 11 00 <0f> b7 17
8d 7b 18 66 c7 40 14 80 00 66 89 50 12 ba 0a 00 00 00
> Dec  5 13:28:44 mininet-vm kernel: [  284.292247] EIP: [<f81ddf99>]
> mac80211_hwsim_monitor_ack.isra.19.part.20+0x49/0x120 [mac80211_hwsim]
SS:ESP 0068:f2d0bc28
> Dec  5 13:28:44 mininet-vm kernel: [  284.292247] CR2: 0000000000000004
> Dec  5 13:28:44 mininet-vm kernel: [  284.493005] ---[ end trace
a7919e7f17c0a728 ]---
> Dec  5 13:28:44 mininet-vm kernel: [  284.496382] mac80211_hwsim: wmediumd
released netlink socket,
> switching to perfect channel medium
> 




