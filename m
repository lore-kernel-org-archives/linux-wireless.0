Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:63128 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224AbbGJKOg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2015 06:14:36 -0400
Message-ID: <559F9AF8.5000208@rempel-privat.de> (sfid-20150710_121441_791659_EB4AFEDC)
Date: Fri, 10 Jul 2015 12:14:16 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: rolf.anderegg@weiss.ch, linux-wireless@vger.kernel.org
Subject: Re: ath9k_htc: virtual interfaces, AP connection drop & kernel warning
References: <559D41B3.4050604@weiss.ch>
In-Reply-To: <559D41B3.4050604@weiss.ch>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6PC5ui2VwGnKDN7jVEhUN21QDuIO2Fn3j"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6PC5ui2VwGnKDN7jVEhUN21QDuIO2Fn3j
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

Am 08.07.2015 um 17:28 schrieb Rolf Anderegg:
> I am having trouble with the following setup using ath9k_htc (AR9271): =
I
> would like to setup two virtual interfaces on a TP-Link Wireless USB
> adapter (TL-WN722N).
>=20
> ath0: AP (access point/master mode) with hostapd [1], on bridge br0
> ath1: STA (station/managed mode) with wpa_supplicant
>=20
> AP works fine when STA is omitted (or wpa_supplicant is stopped). But
> when I try to operate both simultaneously (on the same channel), while
> the STA is up and stable, the AP can no longer hold a connection for
> longer than a few seconds. The hostapd syslogs either say that
> connection is dropped due to inactivity or failure to authenticate.
> Also, sometimes a slowpath kernel warning is dumped [2].
> Kernel version is 3.12.10-rt15 (more environment info: [3]).
>=20
> When I try the same setup with a D-Link PCI card (DWL-G520) running wit=
h
> ath5k, AP and STA work smoothly side by side. So I'm wondering whether
> there are any known limitations or pitfalls when using virtual
> interfaces with ath9k_htc?
>=20
> Any hints or ideas would be greatly appreciated.
> Cheers,

First of all, you are using ancient kernel and firmware. Please update
it. Firmware should be at leas 1.4 and kernel probably 4.1 or later. i'm
not sure which include patch with support of RMW command introduced by
new FW.

Then you can try to disable LED blinking which is stealing your usb
bandwidth.

>=20
>=20
> [1] hostapd.conf:
> interface=3Dath0
> bridge=3Dbr0
> driver=3Dnl80211
> ssid=3DMAN301-0099_LAN
> hw_mode=3Dg
> channel=3D8
> auth_algs=3D3
> wmm_enabled=3D1
> wpa=3D3
> wpa_psk_file=3D/etc/hostapd.wpa_psk
> wpa_key_mgmt=3DWPA-PSK
> wpa_pairwise=3DTKIP CCMP
>=20
>=20
> [2] kernel warning:
> [ 4142.857848] ------------[ cut here ]------------
> [ 4142.857917] WARNING: CPU: 0 PID: 19211 at net/mac80211/agg-tx.c:699 =
ieee80211_start_tx_ba_cb+0xa5/0xf8 [mac80211]()
> [ 4142.857970] Modules linked in: bridge stp llc ipv6 snd_seq_dummy ppd=
ev snd_dice snd_firewire_lib snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm =
snd_page_alloc snd_seq_oss snd_seq_midi ath9k_htc snd_rawmidi ath9k_commo=
n ath9k_hw snd_seq_midi_event ath joydev snd_seq mac80211 microcode snd_s=
eq_device snd_timer cfg80211 rfkill snd serio_raw soundcore lpc_ich mfd_c=
ore parport_pc fuse w83627hf hwmon_vid shpchp coretemp lp parport firewir=
e_ohci ata_generic firewire_core pata_acpi r8169 mii
> [ 4142.857977] CPU: 0 PID: 19211 Comm: kworker/u8:0 Tainted: G        W=
    3.12.10-rt15 #2
> [ 4142.857980] Hardware name:                  /D510MO, BIOS MOPNV10N.8=
6A.0516.2011.0331.1730 03/31/2011
> [ 4142.858051] Workqueue: phy0 ieee80211_iface_work [mac80211]
> [ 4142.858063]  00000000 00000000 f625beb8 c15dba8f 00000000 f625bed0 c=
102d255 f95cfb0c
> [ 4142.858073]  00000000 f2e62534 f27f3ad0 f625bee0 c102d2e1 00000009 0=
0000000 f625bf00
> [ 4142.858082]  f95cfb0c f3f48c18 f2e62360 f27f3800 f26bfc80 f3f48c00 f=
3fb28c0 f625bf28
> [ 4142.858084] Call Trace:
> [ 4142.858096]  [<c15dba8f>] dump_stack+0x49/0x80
> [ 4142.858104]  [<c102d255>] warn_slowpath_common+0x66/0x7d
> [ 4142.858146]  [<f95cfb0c>] ? ieee80211_start_tx_ba_cb+0xa5/0xf8 [mac8=
0211]
> [ 4142.858152]  [<c102d2e1>] warn_slowpath_null+0x14/0x18
> [ 4142.858192]  [<f95cfb0c>] ieee80211_start_tx_ba_cb+0xa5/0xf8 [mac802=
11]
> [ 4142.858234]  [<f95d3183>] ieee80211_iface_work+0x99/0x253 [mac80211]=

> [ 4142.858243]  [<c1040112>] process_one_work+0x146/0x253
> [ 4142.858249]  [<c10405ab>] worker_thread+0x137/0x1d9
> [ 4142.858255]  [<c1040474>] ? rescuer_thread+0x22f/0x22f
> [ 4142.858260]  [<c1044a1e>] kthread+0x74/0x79
> [ 4142.858268]  [<c15e4e77>] ret_from_kernel_thread+0x1b/0x28
> [ 4142.858274]  [<c10449aa>] ? __kthread_parkme+0x59/0x59
> [ 4142.858289] ---[ end trace 0000000000000003 ]---
>=20
>=20
> [3] environment summary:
> :~$ uname -srvmpio
> Linux 3.12.10-rt15 #2 SMP PREEMPT RT Tue Jun 9 16:17:55 CEST 2015 i686 =
i686 i686 GNU/Linux
>=20
> :~$ lsusb -s 1:3
> Bus 001 Device 003: ID 0cf3:9271 Atheros Communications, Inc. AR9271 80=
2.11n
>=20
> :~$ wpa_supplicant -v
> wpa_supplicant v2.4
>=20
> :~$ sudo wpa_cli status
> Selected interface 'ath1'
> bssid=3Db8:a3:86:14:d3:ee
> freq=3D2447
> ssid=3DKakofon
> id=3D0
> id_str=3Dath1
> mode=3Dstation
> pairwise_cipher=3DCCMP
> group_cipher=3DTKIP
> key_mgmt=3DWPA2-PSK
> wpa_state=3DCOMPLETED
> ip_address=3D192.168.1.102
> address=3Dc6:4a:00:1b:c2:98
>=20
> :~$ hostapd -v
> hostapd v2.4
>=20
> :~$ sudo hostapd_cli status
> Selected interface 'ath0'
> state=3DENABLED
> phy=3Dphy0
> freq=3D2447
> num_sta_non_erp=3D0
> num_sta_no_short_slot_time=3D0
> num_sta_no_short_preamble=3D0
> olbc=3D0
> num_sta_ht_no_gf=3D0
> num_sta_no_ht=3D0
> num_sta_ht_20_mhz=3D0
> num_sta_ht40_intolerant=3D0
> olbc_ht=3D0
> ht_op_mode=3D0x0
> cac_time_seconds=3D0
> cac_time_left_seconds=3DN/A
> channel=3D8
> secondary_channel=3D0
> ieee80211n=3D0
> ieee80211ac=3D0
> vht_oper_chwidth=3D0
> vht_oper_centr_freq_seg0_idx=3D0
> vht_oper_centr_freq_seg1_idx=3D0
> bss[0]=3Dath0
> bssid[0]=3Dc0:4a:00:1b:c2:98
> ssid[0]=3DMAN301-0099_LAN
> num_sta[0]=3D0
>=20
> :~$ cat /sys/module/ath9k_htc/parameters/nohwcrypt
> 1
>=20
> :~$ lsmod | grep ath9k
> ath9k_htc              46002  0
> ath9k_common            2153  1 ath9k_htc
> ath9k_hw              370729  2 ath9k_common,ath9k_htc
> ath                    12554  3 ath9k_common,ath9k_htc,ath9k_hw
> mac80211              366454  1 ath9k_htc
> cfg80211              330733  3 ath,mac80211,ath9k_htc
>=20
>=20
> [4]: pre/post-up commands:
> Creating ath0 (preup):
> iw dev wlan0 interface add ath0 type __ap
>=20
> Starting hostapd (postup):
> hostapd -B -P /var/run/hostapd.br_ap.pid /etc/hostapd.conf
>=20
> Creating ath1 (preup):
> iw dev wlan0 interface add ath1 type station
> ip link set ath1 address ${ALT_HW_ADDR}
>=20
> Starting wpa_supplicant (postup):
> wpa_supplicant -Dnl80211 -P/var/run/wpa_supplicant.pid -c /etc/wpa_supp=
licant.conf -B -d -iath1
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
Regards,
Oleksij


--6PC5ui2VwGnKDN7jVEhUN21QDuIO2Fn3j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAlWfmv0ACgkQHwImuRkmbWn8MQD9HrsvL1pTn7LbSo7nGhBGCXbX
boKdEsABbxACZI8TuEYA/i7lJQEkmM7qsCPryQhZwGYS8Kz/yQ43rBHGe65TL7q1
=5QNU
-----END PGP SIGNATURE-----

--6PC5ui2VwGnKDN7jVEhUN21QDuIO2Fn3j--
