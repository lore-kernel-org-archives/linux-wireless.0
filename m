Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46663 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093AbZAZSTt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2009 13:19:49 -0500
Subject: Re: [PATCH] mac80211: don't try to powersave/config disabled
	interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1232993518.4533.27.camel@johannes.local> (sfid-20090126_191208_293454_F0BA7B43)
References: <1232993518.4533.27.camel@johannes.local>
	 (sfid-20090126_191208_293454_F0BA7B43)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-hORw6h8InjqstUEFaFcK"
Date: Mon, 26 Jan 2009 19:19:36 +0100
Message-Id: <1232993976.4533.29.camel@johannes.local> (sfid-20090126_192014_780768_722EDDB6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hORw6h8InjqstUEFaFcK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Should fix warnings like this:

[20661.028030] ------------[ cut here ]------------
[20661.028035] WARNING: at net/mac80211/main.c:161 ieee80211_if_config+0x20=
4/0x250 [mac80211]()
[20661.028039] Hardware name: MacBook5,1
[20661.028041] Modules linked in: zd1211rw mac80211 cfg80211 sha256_generic=
 af_packet binfmt_misc rfcomm l2cap kvm_intel kvm acpi_cpufreq cpufreq_user=
space cpufreq_powersave fuse loop btusb bluetooth bcm5974 snd_hda_codec_rea=
ltek hid_apple usbhid arc4 snd_hda_intel snd_hda_codec snd_hwdep uvcvideo s=
nd_pcm_oss snd_mixer_oss rfkill videodev v4l1_compat v4l2_compat_ioctl32 sn=
d_pcm joydev snd_seq_oss snd_seq_midi_event snd_seq snd_timer snd_seq_devic=
e sg applesmc hwmon snd input_polldev mbp_nvidia_bl soundcore ehci_hcd ohci=
_hcd sr_mod backlight ssb cdrom snd_page_alloc usbcore evdev sd_mod unix [l=
ast unloaded: cfg80211]
[20661.028122] Pid: 3997, comm: phy0 Tainted: G        W  2.6.29-rc2-wl-119=
79-gc32422d-dirty #21
[20661.028125] Call Trace:
[20661.028134]  [<ffffffff802467f0>] warn_slowpath+0xd0/0x130
[20661.028140]  [<ffffffff8027525f>] ? __lock_acquired+0x18f/0x290
[20661.028146]  [<ffffffff80508afb>] ? __qdisc_run+0xeb/0x2a0
[20661.028150]  [<ffffffff80508afb>] ? __qdisc_run+0xeb/0x2a0
[20661.028155]  [<ffffffff8024d336>] ? local_bh_enable+0x96/0x120
[20661.028160]  [<ffffffff80272a49>] ? trace_hardirqs_on_caller+0x29/0x1e0
[20661.028165]  [<ffffffff804f4e4e>] ? dev_queue_xmit+0x14e/0x4b0
[20661.028170]  [<ffffffff80272c0d>] ? trace_hardirqs_on+0xd/0x10
[20661.028174]  [<ffffffff8024d336>] ? local_bh_enable+0x96/0x120
[20661.028177]  [<ffffffff804f4e4e>] ? dev_queue_xmit+0x14e/0x4b0
[20661.028191]  [<ffffffffa11f2d24>] ieee80211_if_config+0x204/0x250 [mac80=
211]
[20661.028209]  [<ffffffffa1210081>] ? ieee80211_tx_skb+0x61/0x70 [mac80211=
]
[20661.028223]  [<ffffffffa11f922a>] ? ieee80211_send_nullfunc+0xda/0x110 [=
mac80211]
[20661.028237]  [<ffffffffa11f936e>] ieee80211_start_scan+0x10e/0x290 [mac8=
0211]
[20661.028252]  [<ffffffffa1201300>] ? ieee80211_sta_work+0x0/0x340 [mac802=
11]
[20661.028267]  [<ffffffffa12013d6>] ieee80211_sta_work+0xd6/0x340 [mac8021=
1]
[20661.028281]  [<ffffffffa1201300>] ? ieee80211_sta_work+0x0/0x340 [mac802=
11]
[20661.028286]  [<ffffffff8025a735>] run_workqueue+0x105/0x250
[20661.028291]  [<ffffffff8025a6e3>] ? run_workqueue+0xb3/0x250
[20661.028296]  [<ffffffff8025a92f>] worker_thread+0xaf/0x130
[20661.028301]  [<ffffffff8025f480>] ? autoremove_wake_function+0x0/0x40
[20661.028306]  [<ffffffff8025a880>] ? worker_thread+0x0/0x130
[20661.028310]  [<ffffffff8025efb9>] kthread+0x49/0x90
[20661.028315]  [<ffffffff8020cdba>] child_rip+0xa/0x20
[20661.028319]  [<ffffffff8020c780>] ? restore_args+0x0/0x30
[20661.028322]  [<ffffffff8025ef70>] ? kthread+0x0/0x90
[20661.028326]  [<ffffffff8020cdb0>] ? child_rip+0x0/0x20
[20661.028329] ---[ end trace b62cb281890fe250 ]---


--=-hORw6h8InjqstUEFaFcK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJff61AAoJEKVg1VMiehFY5UEP/itOtSEDkkvgsmblhschDarJ
KUw9LpnBq8L5SOwjZ9W/N8PFxqZiCsyx1X/0DOUB0bJY2h2ZeAvqbMV45O1GXd2c
0LTOYyxMqiWemJJne7ca/G4z0cSc/GMF/P2TMb0FJxEOuEG2oQ9dQfhHzrwpESIk
KthSSoY7oRhG/A24eo8FKg8hzUJEg3k27+OB7CMLfW1XlI/fyoYqi0B+eMpakvWd
G0gymtY11uypFp68UuTRNb6S78ZeID78K0HJgpuZvgxS27nZFKSPPty5+3//MC+4
62lfnWx9Lq66YCv7iN1aDR/o/+SsglxCl9U+gakeubnxKlUFymI3id0OsLqJ/6bC
uAZeXFBXgjErWrmMYLkd8lwu3inan8IyyM2a3F6otgCfmIlOjx0R0tp34nepUoq9
sd+bIvb1Gvjv7rpC0GnBl5y2dVdvz6s0UUHGM/vms6ouVUW3ALgK6lyNlBeyN2Ii
/xsByg17uA62vit3sPiVje4rZAgRfUMM2KxASmP4dI7n3+55daeraT7aqKAV1qHR
fIsLsP+sOc0PXxnz+xlbHU507zp/9tru3f0pWGckV1Rc4h9cOmnmXYBII9ndO4ZO
j+nuK+5N64Mth04KX5X1EtRPCW22bYxUGJ4/JeWfnKOE+NezW8zRlqMw2FCEOJz5
I69tOzgTfZttyDUg8b6D
=5oox
-----END PGP SIGNATURE-----

--=-hORw6h8InjqstUEFaFcK--

