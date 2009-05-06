Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f166.google.com ([209.85.217.166]:49662 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbZEFSlU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 May 2009 14:41:20 -0400
Received: by gxk10 with SMTP id 10so469024gxk.13
        for <linux-wireless@vger.kernel.org>; Wed, 06 May 2009 11:41:20 -0700 (PDT)
Message-ID: <4A01D9C8.5070501@gmail.com>
Date: Wed, 06 May 2009 14:41:12 -0400
From: Will Keaney <keaneyw@gmail.com>
MIME-Version: 1.0
To: Linux Wireless <linux-wireless@vger.kernel.org>
Subject: Soft Lockup With rfkill_input and thinkpad_acpi
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig52E9F6362F0D8120B1293A13"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig52E9F6362F0D8120B1293A13
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

I have been unable to boot any wireless-testing kernel since
2.6.30-rc1.  After quite a lot of testing, I've narrowed the problem
down to a combination of two options. RFKILL_INPUT, in combination with
THINKPAD_ACPI, causes a soft lockup.  Either of these options are fine
if enabled individually, but when used in combination with each other
the system immediately locks up.  Right now, I have RFKILL and
THINKPAD_ACPI built into the kernel, and RFKILL_INPUT configured as a
module.  This enables me to boot and use my computer, but the system
locks up as soon as I modprobe rfkill_input.  The trace from the soft
lockup is below.
When I get some more time to focus on this, I'll try to do some
git-bisect work.  If anyone else can lend a hand on this, I'd appreciate =
it.

Thanks,

Will Keaney

BUG: soft lockup =EF=BF=BD CPU#0 stuck for 61s! [events/0:10]
Modules linked in: rfkill_input nvidia(P) oss_usb oss_hdaudio osscore cpu=
freq_ondemand acpi_cpufreq freq_table sdhci_pci video sdhci i2c_i801 yent=
a_socket mmc_core rsrc_nonstatic e1000e pcmcia_core i2c_core output rtc p=
cspkr ricoh_mmc battery processor ac button thermal evdev
Irq event stamp: 12860
Hardirqs last enabled at (12859): [<ffffffff8056ce0a>] _spin_unlock_irqre=
store+0x3f/0x81
Hardirqs last disabled at (12860):[<ffffffff8056d03d>] _spin_lock_irq+0x1=
2/0x49
Softirqs last enabled at (9806): [<ffffffff8024184f>] __do_softirq+0x247/=
0x264
Softirqs last disabled at (9793): [<ffffffff8020c43c>] call_softirq+0x1c/=
0x28
CPU 0:
Modules linked in: rfkill_input nvidia(P) oss_usb oss_hdaudio osscore cpu=
freq_ondemand acpi_cpufreq freq_table sdhci_pci video sdhci i2c_i801 yent=
a_socket mmc_core rsrc_nonstatic e1000e pcmcia_core i2c_core output rtc p=
cspkr ricoh_mmc battery processor ac button thermal evdev
Pid: 10, comm.: events/0 Tainted: P           2.6.30-rc4-wl-22697-gd0df3f=
8 #90 6459CTO
RIP: 0010:[<ffffffff80559748>]  [<ffffffff80559748>] __read_lock_failed+0=
x5/0x20
RSP: 0000:ffff88013b903d68  EFLAGS: 00000292
RAX: 0000000000000000 RBX: ffff88013b903d80 RCX: 0000000000000002
RDX: 0000000000000000 RSI: ffffffff806dafdd RDI: ffffffff80788078
RBP: ffffffff8020be4e R08: 0000000000000002 R09: 0000000000000000
R10: ffffffff80470bf2 R11: ffffffff80470bf2 R12: 0000000000000001
R13: 0000000000010bc0 R14: ffff88013b902000 R15: 0000000000000001
FS: 0000000000000000(0000) GS:ffff880028054000(0000) knlGS:00000000000000=
00
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00000000010e00f0 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Call Trace:
 [<ffffffff8036ec09>] ? _raw_read_lock+0x47/0x4c
 [<ffffffff8056d31a>] ? _read_lock+0x41/0x46
 [<ffffffff80470bf2>] ? led_trigger_event+0x22/0x77
 [<ffffffff80470bf2>] ? led_trigger_event+0x22/0x77
 [<ffffffff80557f8d>] ? rfkill_led_trigger+0x27/0x29
 [<ffffffff80558bb4>] ? rfkill_epo+0xb0/0xb5
 [<ffffffffa0016090>] ? rfkill_task_handler+0x90/0x1b0 [rfkill_input]
 [<ffffffff8024ce04>] ? worker_thread+0x27b/0x3b0
 [<ffffffff8024cda8>] ? worker_thread+0x21f/0x3b0
 [<ffffffffa0016000>] ? rfkill_task_handler+0x0/0x1b0 [rfkill_input]
 [<ffffffff802513d2>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff8024cb89>] ? worker_thread+0x0/0x3b0
 [<ffffffff80250f1d>] ? kthread+0x56/0x83
 [<ffffffff8020c33a>] ? child_rip+0xa/0x20
 [<ffffffff8020bd00>] ? restore_args+0x0/0x30
 [<ffffffff80250ea2>] ? kthreadd+0x10a/0x12f
 [<ffffffff80250ec7>] ? kthread+0x0/0x83
 [<ffffffff8020c330>] ? child_rip+0x0/0x20




--------------enig52E9F6362F0D8120B1293A13
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoB2cwACgkQjfayWCA8dDEG5ACdGxcYe3d+z2ZMgJglwsFOSpA7
hO8AnRVnBbr+oiW5pBRGU5UkIvOANb8H
=RWzX
-----END PGP SIGNATURE-----

--------------enig52E9F6362F0D8120B1293A13--
