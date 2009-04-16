Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:42144 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968AbZDPVgV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 17:36:21 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFT/RFC V4] rtl8187: Implement TX/RX blink for LED
Date: Thu, 16 Apr 2009 18:36:22 -0300
Cc: "Hin-Tak Leung" <htl10@users.sourceforge.net>,
	linux-wireless@vger.kernel.org
References: <49e77515.23coopDn30jOxqMR%Larry.Finger@lwfinger.net>
In-Reply-To: <49e77515.23coopDn30jOxqMR%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Message-Id: <200904161836.23574.herton@mandriva.com.br> (sfid-20090416_233625_727112_7C75052D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Quinta-feira 16 Abril 2009, =E0s 15:12:37, Larry Finger escreveu:
> The following patch implements some control over the LED on RTL8187B =
and
> RTL8187L devices. Triggers are registered for TX and RX. Whenever the
> trigger event occurs, the LED is turned off for 1/20 second, then tur=
ned
> back on.
>
> Note: For those RTL8187X devices that are built into the computer and=
 have
> a LED that is expected to be controlled with a radio switch, this pat=
ch
> will not operate that LED. That will take a separate patch to be prep=
ared
> later.
>
> Please test and comment.
>
> The behavior described above is found for my Level One RTL8187B. Prio=
r to
> this patch, the LED was on continuously. On a Netgear WG111V2 RTL8187=
L, the
> LED blinks erratically. Before the patch, the LED was off.
>
> If you test, please report the status of the LED before and after app=
lying
> the patch. In addition, find the line that looks like "rtl8187: Custo=
mer ID
> 0x00" in the dmesg output and report it. I also need to know if you h=
ave a
> B or L model.
>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>
> V2 fixed a locking problem that caused the RTL8187L to fail.
>
> V3 removes the code that turned the LED on at device startup, and tur=
ns
> it off when the driver is unloaded.
>
> V4 turns the TX LED on when registered and turns it off in
> rtl8187_leds_exit(). In addition, it corrects a typo in V3.

All looks fine now, but sorry I got a new problem :)
Now that I'm able to rmmod rtl8187 after 2.6.30-rc2 sync in wireless-te=
sting,=20
I got an oops when inserting/removing rtl8187 in sequence (modprobe rtl=
8187;=20
modprobe -r rtl8187)

BUG: unable to handle kernel NULL pointer dereference at 00000024
IP: [<d89b853f>] rtl8187_led_brightness_set+0x5f/0x70 [rtl8187]
*pde =3D 00000000
Oops: 0000 [#1] SMP
last sysfs file: /sys/module/rtl8187/refcnt
Modules linked in: rtl8187(-) mac80211 led_class eeprom_93cx6 cfg80211=20
af_packet ipv6 binfmt_misc loop dm_mod sha256_generic sha1_generic padl=
ock_sha=20
padlock_aes aes_generic nvram arc4 ecb uvcvideo snd_hda_codec_realtek v=
ideodev=20
v4l1_compat snd_hda_intel snd_hda_codec snd_hwdep snd_seq_dummy snd_seq=
_oss=20
snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss 8139cp 8139too sn=
d_pcm=20
mii snd_timer snd_mixer_oss snd i2c_viapro shpchp video soundcore=20
snd_page_alloc pci_hotplug sg i2c_core pcspkr evdev ehci_hcd uhci_hcd o=
utput=20
rtc_cmos thermal ac battery processor button usbcore ata_generic=20
ide_pci_generic pata_acpi via82cxxx ide_gd_mod ide_core pata_via libata=
 sd_mod=20
scsi_mod crc_t10dif ext4 jbd2 crc16 [last unloaded: cfg80211]

Pid: 4607, comm: modprobe Not tainted (2.6.30-rc2-wl #4) Positivo Mobil=
e
EIP: 0060:[<d89b853f>] EFLAGS: 00010286 CPU: 0
EIP is at rtl8187_led_brightness_set+0x5f/0x70 [rtl8187]
EAX: 00000000 EBX: d78e7940 ECX: 00000032 EDX: d78e7d88
ESI: 00000000 EDI: d78e7cbc EBP: d6863e2c ESP: d6863e24
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Process modprobe (pid: 4607, ti=3Dd6862000 task=3Dd792ca40 task.ti=3Dd6=
862000)
Stack:
 5cf2b074 d78e7cbc d6863e48 c037152f 5cf2b074 5cf2b074 d78e7cbc d78e7ce=
8
 d78e7180 d6863e5c d8992156 5cf2b074 d78e7940 d74adb00 d6863e74 d89b857=
a
 5cf2b074 d78e7180 d74adb00 d89bb7e0 d6863e88 d89b8cb3 5cf2b074 d74adb0=
0
Call Trace:
 [<c037152f>] ? led_trigger_set+0xcf/0xe0
 [<d8992156>] ? led_classdev_unregister+0x56/0xb0 [led_class]
 [<d89b857a>] ? rtl8187_leds_exit+0x2a/0x80 [rtl8187]
 [<d89b8cb3>] ? rtl8187_disconnect+0x23/0x68 [rtl8187]
 [<d8b734ac>] ? usb_unbind_interface+0x4c/0x140 [usbcore]
 [<c032ef2f>] ? __device_release_driver+0x5f/0xb0
 [<c032f027>] ? driver_detach+0xa7/0xc0
 [<c032de5c>] ? bus_remove_driver+0x8c/0x100
 [<c032f841>] ? driver_unregister+0x41/0x60
 [<d8b73257>] ? usb_deregister+0xa7/0xd0 [usbcore]
 [<d89b8c6b>] ? rtl8187_exit+0x1b/0x40 [rtl8187]
 [<c01719d5>] ? sys_delete_module+0x185/0x240
 [<c01c17c3>] ? do_munmap+0x243/0x2a0
 [<c042c72a>] ? do_page_fault+0x1da/0x320
 [<c01045bb>] ? sysenter_do_call+0x12/0x28
Code: 00 00 00 75 30 83 c4 04 5b 5d c3 90 8b 40 24 8d 93 88 04 00 00 e8=
 32 d7=20
79 e7 8b 83 74 03 00 00 8d 93 48 04 00 00 b9 32 00 00 00 <8b> 40 24 e8 =
19 d7=20
79 e7 eb c4 e8 72 85 78 e7 66 90 55 89 e5 83
EIP: [<d89b853f>] rtl8187_led_brightness_set+0x5f/0x70 [rtl8187] SS:ESP=
=20
0068:d6863e24
CR2: 0000000000000024
---[ end trace ae006a68f9740f08 ]---

this is because priv->dev is only set at rtl8187_start, which only runs=
 after=20
you bring the interface up. One possible fix:

diff -p -up ./drivers/net/wireless/rtl818x/rtl8187_leds.c.orig=20
=2E/drivers/net/wireless/rtl818x/rtl8187_leds.c
--- ./drivers/net/wireless/rtl818x/rtl8187_leds.c.orig	2009-04-16=20
17:21:56.000000000 -0300
+++ ./drivers/net/wireless/rtl818x/rtl8187_leds.c	2009-04-16=20
18:16:50.000000000 -0300
@@ -107,7 +107,7 @@ static void rtl8187_led_brightness_set(s
 	if (brightness =3D=3D LED_OFF) {
 		queue_delayed_work(hw->workqueue, &priv->led_off, 0);
 		/* The LED is off for 1/20 sec so that it just blinks. */
-		queue_delayed_work(priv->dev->workqueue, &priv->led_on, HZ / 20);
+		queue_delayed_work(hw->workqueue, &priv->led_on, HZ / 20);
 	} else
 		queue_delayed_work(hw->workqueue, &priv->led_on, 0);
 }

You can add Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.c=
om.br>=20
to the patch (or Tested-by/Reviewed-by, what's more appropriate, now ho=
pefully=20
we will have the last version of the patch :) )

<snip>

--
[]'s
Herton
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
