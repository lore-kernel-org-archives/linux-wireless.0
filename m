Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost06.isp.att.net ([204.127.217.106]:37154 "EHLO
	fmailhost06.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516AbZDPX0r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 19:26:47 -0400
Message-ID: <49E7BEA5.9010405@lwfinger.net> (sfid-20090417_012651_829665_EA2E81C4)
Date: Thu, 16 Apr 2009 18:26:29 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
CC: Hin-Tak Leung <htl10@users.sourceforge.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFT/RFC V4] rtl8187: Implement TX/RX blink for LED
References: <49e77515.23coopDn30jOxqMR%Larry.Finger@lwfinger.net> <200904161836.23574.herton@mandriva.com.br>
In-Reply-To: <200904161836.23574.herton@mandriva.com.br>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Herton Ronaldo Krzesinski wrote:
> Em Quinta-feira 16 Abril 2009, =E0s 15:12:37, Larry Finger escreveu:
>> The following patch implements some control over the LED on RTL8187B=
 and
>> RTL8187L devices. Triggers are registered for TX and RX. Whenever th=
e
>> trigger event occurs, the LED is turned off for 1/20 second, then tu=
rned
>> back on.
>>
>> Note: For those RTL8187X devices that are built into the computer an=
d have
>> a LED that is expected to be controlled with a radio switch, this pa=
tch
>> will not operate that LED. That will take a separate patch to be pre=
pared
>> later.
>>
>> Please test and comment.
>>
>> The behavior described above is found for my Level One RTL8187B. Pri=
or to
>> this patch, the LED was on continuously. On a Netgear WG111V2 RTL818=
7L, the
>> LED blinks erratically. Before the patch, the LED was off.
>>
>> If you test, please report the status of the LED before and after ap=
plying
>> the patch. In addition, find the line that looks like "rtl8187: Cust=
omer ID
>> 0x00" in the dmesg output and report it. I also need to know if you =
have a
>> B or L model.
>>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> ---
>>
>> V2 fixed a locking problem that caused the RTL8187L to fail.
>>
>> V3 removes the code that turned the LED on at device startup, and tu=
rns
>> it off when the driver is unloaded.
>>
>> V4 turns the TX LED on when registered and turns it off in
>> rtl8187_leds_exit(). In addition, it corrects a typo in V3.
>=20
> All looks fine now, but sorry I got a new problem :)
> Now that I'm able to rmmod rtl8187 after 2.6.30-rc2 sync in wireless-=
testing,=20
> I got an oops when inserting/removing rtl8187 in sequence (modprobe r=
tl8187;=20
> modprobe -r rtl8187)
>=20
> BUG: unable to handle kernel NULL pointer dereference at 00000024
> IP: [<d89b853f>] rtl8187_led_brightness_set+0x5f/0x70 [rtl8187]
> *pde =3D 00000000
> Oops: 0000 [#1] SMP
> last sysfs file: /sys/module/rtl8187/refcnt
> Modules linked in: rtl8187(-) mac80211 led_class eeprom_93cx6 cfg8021=
1=20
> af_packet ipv6 binfmt_misc loop dm_mod sha256_generic sha1_generic pa=
dlock_sha=20
> padlock_aes aes_generic nvram arc4 ecb uvcvideo snd_hda_codec_realtek=
 videodev=20
> v4l1_compat snd_hda_intel snd_hda_codec snd_hwdep snd_seq_dummy snd_s=
eq_oss=20
> snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss 8139cp 8139too =
snd_pcm=20
> mii snd_timer snd_mixer_oss snd i2c_viapro shpchp video soundcore=20
> snd_page_alloc pci_hotplug sg i2c_core pcspkr evdev ehci_hcd uhci_hcd=
 output=20
> rtc_cmos thermal ac battery processor button usbcore ata_generic=20
> ide_pci_generic pata_acpi via82cxxx ide_gd_mod ide_core pata_via liba=
ta sd_mod=20
> scsi_mod crc_t10dif ext4 jbd2 crc16 [last unloaded: cfg80211]
>=20
> Pid: 4607, comm: modprobe Not tainted (2.6.30-rc2-wl #4) Positivo Mob=
ile
> EIP: 0060:[<d89b853f>] EFLAGS: 00010286 CPU: 0
> EIP is at rtl8187_led_brightness_set+0x5f/0x70 [rtl8187]
> EAX: 00000000 EBX: d78e7940 ECX: 00000032 EDX: d78e7d88
> ESI: 00000000 EDI: d78e7cbc EBP: d6863e2c ESP: d6863e24
>  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> Process modprobe (pid: 4607, ti=3Dd6862000 task=3Dd792ca40 task.ti=3D=
d6862000)
> Stack:
>  5cf2b074 d78e7cbc d6863e48 c037152f 5cf2b074 5cf2b074 d78e7cbc d78e7=
ce8
>  d78e7180 d6863e5c d8992156 5cf2b074 d78e7940 d74adb00 d6863e74 d89b8=
57a
>  5cf2b074 d78e7180 d74adb00 d89bb7e0 d6863e88 d89b8cb3 5cf2b074 d74ad=
b00
> Call Trace:
>  [<c037152f>] ? led_trigger_set+0xcf/0xe0
>  [<d8992156>] ? led_classdev_unregister+0x56/0xb0 [led_class]
>  [<d89b857a>] ? rtl8187_leds_exit+0x2a/0x80 [rtl8187]
>  [<d89b8cb3>] ? rtl8187_disconnect+0x23/0x68 [rtl8187]
>  [<d8b734ac>] ? usb_unbind_interface+0x4c/0x140 [usbcore]
>  [<c032ef2f>] ? __device_release_driver+0x5f/0xb0
>  [<c032f027>] ? driver_detach+0xa7/0xc0
>  [<c032de5c>] ? bus_remove_driver+0x8c/0x100
>  [<c032f841>] ? driver_unregister+0x41/0x60
>  [<d8b73257>] ? usb_deregister+0xa7/0xd0 [usbcore]
>  [<d89b8c6b>] ? rtl8187_exit+0x1b/0x40 [rtl8187]
>  [<c01719d5>] ? sys_delete_module+0x185/0x240
>  [<c01c17c3>] ? do_munmap+0x243/0x2a0
>  [<c042c72a>] ? do_page_fault+0x1da/0x320
>  [<c01045bb>] ? sysenter_do_call+0x12/0x28
> Code: 00 00 00 75 30 83 c4 04 5b 5d c3 90 8b 40 24 8d 93 88 04 00 00 =
e8 32 d7=20
> 79 e7 8b 83 74 03 00 00 8d 93 48 04 00 00 b9 32 00 00 00 <8b> 40 24 e=
8 19 d7=20
> 79 e7 eb c4 e8 72 85 78 e7 66 90 55 89 e5 83
> EIP: [<d89b853f>] rtl8187_led_brightness_set+0x5f/0x70 [rtl8187] SS:E=
SP=20
> 0068:d6863e24
> CR2: 0000000000000024
> ---[ end trace ae006a68f9740f08 ]---
>=20
> this is because priv->dev is only set at rtl8187_start, which only ru=
ns after=20
> you bring the interface up. One possible fix:
>=20
> diff -p -up ./drivers/net/wireless/rtl818x/rtl8187_leds.c.orig=20
> ./drivers/net/wireless/rtl818x/rtl8187_leds.c
> --- ./drivers/net/wireless/rtl818x/rtl8187_leds.c.orig	2009-04-16=20
> 17:21:56.000000000 -0300
> +++ ./drivers/net/wireless/rtl818x/rtl8187_leds.c	2009-04-16=20
> 18:16:50.000000000 -0300
> @@ -107,7 +107,7 @@ static void rtl8187_led_brightness_set(s
>  	if (brightness =3D=3D LED_OFF) {
>  		queue_delayed_work(hw->workqueue, &priv->led_off, 0);
>  		/* The LED is off for 1/20 sec so that it just blinks. */
> -		queue_delayed_work(priv->dev->workqueue, &priv->led_on, HZ / 20);
> +		queue_delayed_work(hw->workqueue, &priv->led_on, HZ / 20);
>  	} else
>  		queue_delayed_work(hw->workqueue, &priv->led_on, 0);
>  }

I have no idea why that one was different. That is fixed - in addition,=
 I also
check that led->dev is non-NULL in led_off as well as led_on. I was abl=
e to
insmod/rmmod rtl8187 about 10 times in a row without any problems. Than=
ks for
finding this problem.
>=20
> You can add Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva=
=2Ecom.br>=20
> to the patch (or Tested-by/Reviewed-by, what's more appropriate, now =
hopefully=20
> we will have the last version of the patch :) )

I think a signed-off-by is appropriate. I usually get it right in 4 tri=
es. ;)

Larry

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
