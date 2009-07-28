Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49464 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703AbZG1Q2x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2009 12:28:53 -0400
Subject: Re: WARNING: at net/mac80211/agg-tx.c:145
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Backlund <tmb@mandriva.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4A6F264E.70501@mandriva.org>
References: <4A6F264E.70501@mandriva.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-wt47ZHGvJSMYMkxi96o5"
Date: Tue, 28 Jul 2009 18:28:20 +0200
Message-Id: <1248798501.13742.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-wt47ZHGvJSMYMkxi96o5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-07-28 at 19:24 +0300, Thomas Backlund wrote:
> Hi,
>=20
> Is this known?

I think so. The problem is that on a hw restart the driver clears
aggregation but mac80211 thinks the session is still up, I think.

johannes

> I got this today on a Intel 4965 with a 2.6.31-rc4 based kernel=20
> configured with PREEMPT.
>=20
> Arch is x86_64 and firmware 228.61.2.24
>=20
> iwlagn 0000:04:00.0: Stopping AGG while state not IWL_AGG_ON
> iwlagn 0000:04:00.0: queue number out of range: 0, must be 7 to 14
> ------------[ cut here ]------------
> WARNING: at net/mac80211/agg-tx.c:145=20
> ___ieee80211_stop_tx_ba_session+0x91/0xa0 [mac80211]()
> Hardware name: TravelMate 5720
> Modules linked in: cryptd aes_x86_64 aes_generic af_packet ipv6 btusb=20
> bluetooth firewire_ohci firewire_core arc4 ecb crc_itu_t tg3 serio_raw=20
> sdhci_pci sdhci ohci1394 libphy ieee1394 iwlagn snd_hda_codec_realtek=20
> sr_mod iwlcore sg snd_hda_intel snd_hda_codec acer_wmi iTCO_wdt=20
> iTCO_vendor_support mac80211 snd_hwdep snd_seq_dummy snd_seq_oss=20
> snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss led_class snd_pcm=20
> snd_timer snd_mixer_oss snd cfg80211 soundcore i2c_i801 rfkill=20
> snd_page_alloc binfmt_misc fuse ext3 jbd jfs pcmcia yenta_socket=20
> rsrc_nonstatic pcmcia_core cpufreq_ondemand cpufreq_conservative=20
> cpufreq_powersave acpi_cpufreq freq_table tifm_sd mmc_block mmc_core=20
> tifm_7xx1 tifm_core nvram radeon uvcvideo nsc_ircc videodev v4l1_compat=20
> ttm v4l2_compat_ioctl32 drm irda crc_ccitt i2c_algo_bit uhci_hcd=20
> i2c_core ehci_hcd joydev evdev container battery usbcore video output=20
> thermal processor button ac pcspkr rtc_cmos wmi ata_piix ahci libata=20
> sd_mod scsi_mod crc_t10dif ext4 jbd2 crc16
> Pid: 0, comm: swapper Not tainted 2.6.31-tmb-desktop-0.rc4.3mdv #1
> Call Trace:
>   <IRQ>  [<ffffffff81043818>] warn_slowpath_common+0x78/0xb0
>   [<ffffffff8104385f>] warn_slowpath_null+0xf/0x20
>   [<ffffffffa0445121>] ___ieee80211_stop_tx_ba_session+0x91/0xa0 [mac8021=
1]
>   [<ffffffffa0445326>] sta_addba_resp_timer_expired+0x56/0x90 [mac80211]
>   [<ffffffffa04452d0>] ? sta_addba_resp_timer_expired+0x0/0x90 [mac80211]
>   [<ffffffff8104e1ae>] run_timer_softirq+0x13e/0x210
>   [<ffffffff8104912f>] __do_softirq+0xaf/0x140
>   [<ffffffff8100fa2a>] ? timer_interrupt+0x1a/0x30
>   [<ffffffff8100d06c>] call_softirq+0x1c/0x30
>   [<ffffffff8100f075>] do_softirq+0x45/0x80
>   [<ffffffff81049575>] irq_exit+0x95/0xa0
>   [<ffffffff8100e600>] do_IRQ+0x70/0xe0
>   [<ffffffff8100c8d3>] ret_from_intr+0x0/0xa
>   <EOI>  [<ffffffffa00fa57a>] ? acpi_idle_enter_bm+0x26c/0x297 [processor=
]
>   [<ffffffffa00fa570>] ? acpi_idle_enter_bm+0x262/0x297 [processor]
>   [<ffffffff81240efb>] ? cpuidle_idle_call+0x9b/0xf0
>   [<ffffffff8100aa32>] ? cpu_idle+0x62/0xd0
>   [<ffffffff812daa81>] ? rest_init+0x81/0x90
>   [<ffffffff814b6acf>] ? start_kernel+0x356/0x361
>   [<ffffffff814b6128>] ? x86_64_start_reservations+0x125/0x129
>   [<ffffffff814b620d>] ? x86_64_start_kernel+0xe1/0xe8
> ---[ end trace 60c73ee4e29d40fe ]---
>=20
>=20
>=20
> About 1 hour before this I had this in dmesg:
>=20
> iwlagn 0000:04:00.0: iwl_tx_agg_start on ra =3D 00:19:5b:51:dc:27 tid =3D=
 0
> iwlagn 0000:04:00.0: Microcode HW error detected.  Restarting.
>=20
>=20
>=20
> --
> Thomas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--=-wt47ZHGvJSMYMkxi96o5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKbychAAoJEODzc/N7+QmaXWAQAK0EjefZY85K/0PQnR7c3rY5
lBJ4o5gLuFDM1yJTe0AWSGR3etD2ZOrr0fTn5n3PWmTohVRFGHz+Lf8Zr802i4y6
nyQT7M7oWGqDMUSCuRZuKL1rnOALrHbqIWLptTdpiUp1TfGwwUyOSQ7zjzsRANsi
I09O45K1HqPcbFqwBPOuNNL7Ui0rrTC4R6xjyMfkum1cNIMjjDAWuVnyQC9pJ1cH
G2KUURVLYtlIxvti3gvmFDP4cPtlwppYSuWB9/Gy/4N/q7FZJYOojb+n7otdmpHx
tPj//aszSM4L8VSSehptuQyumy0hMm6w1T/egGbhjB6hC2Gt+rmP+mP1WfJq7CxO
02ZAuitxKM6L5b20J/6JXfTPJkw7JkjA9xFDPloNNeB84UHlWZBiuTXlS+QHetnp
VWmoxGxfBWupbCyBvvIfg9fP4V+inGihLDe3qQxTdxnnLKZ46+lH848sAf5SbTLi
oaLwN8gxviHG9HYIJV4NDMVhPVpiLN2nRl0+Pwj6jJ3Ssd4dVaM9WHnPkIZGh6Ls
HOF9jKDlu7u8QEZlbPcUfZikmDLHFW6mWnQ4xlw1K5EZ42vicuEv5hSNNTb/17wy
ZsHVbWnF39rYNKSexlVcHrZrXP3CjeESOe1UwnvqRDqSY6Pq2zDqMgf1ryCB+hrf
8W2tBUYs4RLDQMieM1nP
=jQMc
-----END PGP SIGNATURE-----

--=-wt47ZHGvJSMYMkxi96o5--

