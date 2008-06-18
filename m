Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hiems2.ing.unibs.it ([192.167.23.204]:48268 "EHLO
	hiems2.ing.unibs.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbYFRQKf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jun 2008 12:10:35 -0400
Cc: "Michael Buesch" <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de
Message-Id: <A30D3F04-424C-48C2-8EB6-3838CE50CCD6@ing.unibs.it> (sfid-20080618_181041_087205_7AB19B04)
From: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
To: =?ISO-8859-1?Q?Stefanik_G=E1bor?= <netrolller.3d@gmail.com>
In-Reply-To: <69e28c910806151120p116cb57dgf29b68c205e44668@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v924)
Subject: Re: b43 open-firmware new snapshot
Date: Wed, 18 Jun 2008 18:02:33 +0200
References: <200806141553.42420.mb@bu3sch.de> <69e28c910806151120p116cb57dgf29b68c205e44668@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> This firmware does _only_ work on wireless core revisions 5, 6, 7,  
>> 8 or 10.
>
> There are reports of it working on rev.9 cores. Is that possible?
> (Resend of previous mail to the list.)
Hi there,

I get this
Jun 18 16:43:51 b43 kernel: [   21.152097] ssb: Core 0 found:  
ChipCommon (cc 0x800, rev 0x0D, vendor 0x4243)
Jun 18 16:43:51 b43 kernel: [   21.152113] ssb: Core 1 found: IEEE  
802.11 (cc 0x812, rev 0x09, vendor 0x4243)
Jun 18 16:43:51 b43 kernel: [   21.152122] ssb: Core 2 found: PCI (cc  
0x804, rev 0x0C, vendor 0x4243)
Jun 18 16:43:51 b43 kernel: [   21.152132] ssb: Core 3 found: PCMCIA  
(cc 0x80D, rev 0x07, vendor 0x4243)

it should be a rev.9 core. Well, I got it running in monitor mode, I  
clear saw tcpdump doing its work. But I think Michael is right, just  
after a while it crashed: before doing that syslog filled up with

[ 1213.209871] ------------[ cut here ]------------
[ 1213.209878] WARNING: at drivers/net/wireless/b43/xmit.c:49 b43_rx 
+0x1a5/0x630 [b43]()
[ 1213.209880] Modules linked in: b43 rfkill_input arc4 ecb  
crypto_blkcipher rfkill mac80211 cfg80211 input_polldev af_packet  
radeon drm speedstep_lib cpufreq_stats cpufreq_ondemand freq_table  
cpufreq_powersave cpufreq_userspace cpufreq_conservative container sbs  
sbshc loop serio_raw psmouse pcspkr usbhid hid ssb battery asus_laptop  
led_class ac button sis_agp agpgart evdev xfs ide_disk ide_cd_mod  
cdrom ata_generic pata_sis libata dock floppy skge ehci_hcd ohci_hcd  
usbcore sis5513 ide_core thermal processor fan fuse [last unloaded: b43]
[ 1213.209926] Pid: 0, comm: swapper Tainted: G        W 2.6.26-rc6-wl  
#1
[ 1213.209931]  [<c011a46f>] warn_on_slowpath+0x5f/0x90
[ 1213.209947]  [<c01138c2>] enqueue_task+0x12/0x30
[ 1213.209955]  [<c0113934>] activate_task+0x24/0x40
[ 1213.209963]  [<c0113b4e>] __wake_up_common+0x3e/0x70
[ 1213.209973]  [<c025c5c1>] sock_def_readable+0x41/0x50
[ 1213.209980]  [<c025b831>] sock_queue_rcv_skb+0xa1/0xe0
[ 1213.209986]  [<c029f090>] udp_queue_rcv_skb+0xb0/0x280
[ 1213.209997]  [<e09b892c>] ssb_pci_read32+0x1c/0x60 [ssb]
[ 1213.210010]  [<c0163972>] __slab_alloc+0xa2/0x410
[ 1213.210016]  [<e0b02990>] __ieee80211_rx_handle_packet+0x5e0/0x7b0  
[mac80211]
[ 1213.210038]  [<e0b2b7e5>] b43_rx+0x1a5/0x630 [b43]
[ 1213.210050]  [<e0b20000>] b43_chip_init+0xa10/0xa20 [b43]
[ 1213.210059]  [<e0b30165>] op32_fill_descriptor+0x45/0xe0 [b43]
[ 1213.210077]  [<e0b2fd6e>] b43_dma_rx+0x16e/0x400 [b43]
[ 1213.210097]  [<e0b21f58>] b43_interrupt_tasklet+0x378/0x910 [b43]
[ 1213.210106]  [<c01138c2>] enqueue_task+0x12/0x30
[ 1213.210111]  [<c0113934>] activate_task+0x24/0x40
[ 1213.210126]  [<c011edc4>] tasklet_action+0x34/0x70
[ 1213.210131]  [<c011ec72>] __do_softirq+0x42/0x90
[ 1213.210136]  [<c011ece7>] do_softirq+0x27/0x30
[ 1213.210139]  [<c011efe5>] irq_exit+0x45/0x60
[ 1213.210142]  [<c0105a59>] do_IRQ+0x39/0x70
[ 1213.210151]  [<c0103e23>] common_interrupt+0x23/0x30
[ 1213.210162]  [<e0813d0f>] acpi_idle_enter_simple+0x16e/0x1db  
[processor]
[ 1213.210177]  [<e08139b6>] acpi_idle_enter_bm+0xb7/0x2a2 [processor]
[ 1213.210187]  [<c0254258>] cpuidle_idle_call+0x68/0xa0
[ 1213.210193]  [<c02541f0>] cpuidle_idle_call+0x0/0xa0
[ 1213.210197]  [<c01026a4>] cpu_idle+0x24/0x70
[ 1213.210206]  =======================
[ 1213.210209] ---[ end trace 4d6796847711ea43 ]---

repeated hundreds of time. I'm using wireless-testing (git-pulled this  
morning) e latest firmware image. I succeeded to find three cards and  
they all are rev.9!

Regards,
FG

