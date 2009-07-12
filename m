Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:54186 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963AbZGLUL7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jul 2009 16:11:59 -0400
Received: by fg-out-1718.google.com with SMTP id e12so317133fga.17
        for <linux-wireless@vger.kernel.org>; Sun, 12 Jul 2009 13:11:57 -0700 (PDT)
MIME-Version: 1.0
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sun, 12 Jul 2009 22:11:37 +0200
Message-ID: <69e28c910907121311g2011c960g141bd35891c8ea25@mail.gmail.com>
Subject: [Bisected][Regression] Oops/panic when rmmoding rtl8187 on SMP since
	commit "rtl8187: Implement TX/RX blink for LED"
To: linux-wireless <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Larry Finger <larry.finger@gmail.com>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm getting a kernel oops/panic when unloading rtl8187. Bisect lead me
to commit "rtl8187: Implement TX/RX blink for LED", confirmed by local
backout.
My card is an RTL8187LvB, "Customer ID 0x00" (P5K Premium integrated
WiFi, made by Azurewave).

The log/backtrace varies from case to case - sometimes it's an oops,
other times a panic, and I've also seen a lockup without anything
printed. The error message usually (though not always) talks about a
corrupted stack. The message is usually not printed out in full, often
truncated mid-line. The following is an example log extracted using a
kdump kernel (but it varies significantly for each panic, this one for
example has no corrupted stack warning):

"usbcore: deregistering interface driver rtl8187
BUG: unable to handle kernel paging request at 18b8f4e0
IP: [<c03ebf7c>] _spin_lock_irqsave+0x2c/0x50
*pdpt = 0000000035068001 *pde = 0000000000000000
Oops: 0002 [#1] PREEMPT SMP
last sysfs file: /sys/firmware/edd/int13_dev84/raw_data
Modules linked in: rtl8187(-) eeprom_93cx6 ohci_hcd binfmt_misc
microcode fuse ext3 jbd mbcache loop dm_mod joydev rfcomm l2cap arc4
pata_acpi ecb snd_hda_codec_analog iwlagn iwlcore led_class
ata_generic snd_hda_intel btusb pcmcia snd_hda_codec mac80211 nvidiafb
ata_piix snd_hwdep fb_ddc bluetooth snd_pcm yenta_socket cfg80211
rtc_cmos snd_timer i2c_algo_bit snd rtc_core rsrc_nonstatic
ide_pci_generic ohci1394 asus_atk0110 iTCO_wdt r8169 soundcore
intel_agp vgastate ide_core rtc_lib ieee1394 hwmon rfkill pcmcia_core
button mii sky2 ahci sr_mod iTCO_vendor_support cdrom i2c_i801 agpgart
snd_page_alloc i2c_core sg usbhid hid sd_mod crc_t10dif pata_jmicron
ehci_hcd uhci_hcd usbcore edd reiserfs fan pata_amd libata scsi_mod
thermal processor

Pid: 0, comm: swapper Not tainted (2.6.31-rc2-wl-wireless16 #41) P5K Premium
EIP: 0060:[<c03ebf7c>] EFLAGS: 00010017 CPU: 3
EIP is at _spin_lock_irqsave+0x2c/0x50
EAX: 00000100 EBX: 18b8f4e0 ECX: 00000000 EDX: 00000001
ESI: 00000292 EDI: f763de94 EBP: f763de40 ESP: f763de38
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process swapper (pid: 0, ti=f763c000 task=f7631900 task.ti=f763c000)
Stack:
 18b8f4e0 f68c9e88 f763de54 c01524fa f6164080 f68c9e88 f763de94 f763de64
<0> c015255a 00000102 f7624000 f763dea8 c0149cf5 00000000 f763de98 c01649b3
<0> e8fef495 f68c9e88 c0152520 f7624e0c f7624c0c f7624a0c f762480c f763de94
Call Trace:
 [<c01524fa>] ? __queue_work+0x1a/0x40
 [<c015255a>] ? delayed_work_timer_fn+0x3a/0x50
 [<c0149cf5>] ? run_timer_softirq+0x135/0x200
 [<c01649b3>] ? tick_dev_program_event+0x33/0xc0
 [<c0152520>] ? delayed_work_timer_fn+0x0/0x50
 [<c0144667>] ? __do_softirq+0xe7/0x1f0
 [<c015a83e>] ? hrtimer_interrupt+0xde/0x220
 [<c03ec26f>] ? _spin_unlock+0xf/0x30
 [<c01447ad>] ? do_softirq+0x3d/0x40
 [<c014498d>] ? irq_exit+0x6d/0x90
 [<c0117f26>] ? smp_apic_timer_interrupt+0x56/0x90
 [<c015a718>] ? ktime_get_ts+0x48/0x50
 [<c01038b6>] ? apic_timer_interrupt+0x2a/0x30
 [<c015007b>] ? kernel_power_off+0x1b/0x40
 [<c0109f66>] ? mwait_idle+0x116/0x130
 [<c0101f42>] ? cpu_idle+0x52/0x90
 [<c03e6b29>] ? start_secondary+0x1c9/0x2c0
Code: 89 e5 83 ec 08 89 1c 24 89 c3 89 74 24 04 9c 58 8d 74 26 00 89
c6 fa 90 8d 74 26 00 b8 01 00 00 00 e8 c9 2a 00 00 b8 00 01 00 00 <f0>
66 0f c1 03 38 e0 74 06 f3 90 8a 03 eb f6 89 f0 8b 1c 24 8b
EIP: [<c03ebf7c>] _spin_lock_irqsave+0x2c/0x50 SS:ESP 0068:f763de38
CR2: 0000000018b8f4e0"

EIP is usually at _spin_unlock_irqsave (but "+0x2c/0x50" seems to be
completely random, different for every case), but I have seen other
outputs as well in a few cases. The call trace also varies, but it
never contains any reference to rtl8187and the top call is always
__queue_work. The trace itself also never includes _spin_lock_irqsave.
The panic type is sometimes "unable to handle kernel paging request',
in other cases it's a NULL pointer dereference, and I've seen other
values as well. This doesn't seem to happen when I boot with "nosmp
maxcpus=1", so it's probably SMP-specific. The panic message always
immediately follows "usbcore: deregistering interface driver rtl8187".

Reverting "rtl8187: Implement TX/RX blink for LED" makes the problem go away.

I suspect a locking problem in function rtl8187_leds_exit.

--Gábor

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
