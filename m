Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gw90.de ([188.40.100.199]:60704 "EHLO mail.gw90.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088Ab3GSJsc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jul 2013 05:48:32 -0400
Message-ID: <1374227275.6102.74.camel@mattotaupa> (sfid-20130719_114835_367682_486DBA45)
Subject: Re: Connection not established with Realtek RTL8188CUS based USB
 device (EDIMAX)
From: Paul Menzel <paulepanter@users.sourceforge.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 19 Jul 2013 11:47:55 +0200
In-Reply-To: <1371681372.11916.5.camel@mattotaupa>
References: <1371326265.9845.54.camel@mattotaupa>
	 <51BCD7BA.1040900@lwfinger.net> <1371681372.11916.5.camel@mattotaupa>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-49OlvDHWvZ0dgITYkazq"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-49OlvDHWvZ0dgITYkazq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Am Donnerstag, den 20.06.2013, 00:36 +0200 schrieb Paul Menzel:
> Am Samstag, den 15.06.2013, 16:08 -0500 schrieb Larry Finger:
> > On 06/15/2013 02:57 PM, Paul Menzel wrote:
>=20
> > > hopefully I am contacting the correct list. I am not able to use the
> > > Realtek RTL8188CUS based USB WLAN device Edimax EW-7811Un.
> > >
> > >          Bus 002 Device 005: ID 7392:7811 Edimax Technology Co., Ltd =
EW-7811Un 802.11n Wireless Adapter [Realtek RTL8188CUS]
> > >
> > > The device did not work with Debian Wheezy with Linux 3.2.x, Debian
> > > Sid/unstable with Linux 3.9.x, Ubuntu 12.04 with Linux 3.2.12 to 3.5 =
and
> > > Ubuntu 13.04 with Linux 3.8. The person, from whom the device is from=
,
> > > claims the device once worked with Ubuntu, but I do not know which
> > > version and what WLAN type(?) this was with.
> > >
> > > The behavior is always the same. The device is detected and the
> > > NetworkManager applet `nm-applet` is also able to detect the availabl=
e
> > > networks. But wanting to connect to one and entering the correct
> > > password, the connection cannot be established and I am asked for the
> > > password again. I tested this with different systems and different
> > > networks and also with wpa_supplicant. A Ralink based WLAN USB device
> > > works just fine.
> > >
> > > The Realtek RTL8188CUS WLAN device works also fine under Microsoft
> > > Windows, so the device is functional.
> >=20
> > Use a compat-wireless package from 3.10-rc1 or later. If that fails, th=
en I will=20
> > give you a debug sequence to run.
>=20
> I just built Linux 3.10-rc6+ (containing the patch you attached in your
> other reply)
>=20
>         $ git describe
>         v3.10-rc6-84-gc069114
>=20
> and it still fails. Though with a different error message.
>=20
>         kernel: [  174.729668] rtlwifi:rtl_watchdog_wq_callback():<0-0> A=
P off, try to reconnect now
>         kernel: [  174.729753] wlan1: Connection to AP yy:yy:yy:yy:yy:yy =
lost
>         wpa_supplicant[5247]: wlan1: WPA: 4-Way Handshake failed - pre-sh=
ared key may be incorrect
>         wpa_supplicant[5247]: wlan1: CTRL-EVENT-DISCONNECTED bssid=3Dyy:y=
y:yy:yy:yy:yy reason=3D4
>=20
> I am pretty sure I am using a WPA2 WLAN. The NetworkManager developer
> Dan Williams confirmed that [1].
>=20
> Please find the parts from `/var/log/syslog` attached.
>=20
> It also contains a backtrace, which I reported a bug about already
> somewhere. (I=E2=80=99ll get the reference later.)
>=20
>         [  168.601781] ------------[ cut here ]------------
>         [  168.601805] WARNING: at kernel/workqueue.c:1365 __queue_work+0=
x177/0x1d1()
>         [  168.601809] Modules linked in: arc4 rtl8192cu rtlwifi mac80211=
 cfg80211 rtl8192c_common ip6table_filter ip6_tables iptable_filter ip_tabl=
es x_tables binfmt_misc reiserfs xfs crc32c libcrc32c w83627ehf hwmon_vid l=
oop firewire_sbp2 firewire_core crc_itu_t fuse radeon snd_hda_codec_realtek=
 snd_hda_intel snd_hda_codec backlight snd_hwdep drm_kms_helper snd_pcm snd=
_page_alloc ttm snd_seq_midi snd_seq_midi_event snd_rawmidi drm snd_seq snd=
_seq_device snd_timer kvm_amd kvm snd i2c_algo_bit soundcore psmouse proces=
sor button serio_raw evdev ext3 mbcache jbd sha256_generic cbc dm_crypt dm_=
mod raid1 md_mod usbhid sd_mod crc_t10dif r8169 mii fan thermal thermal_sys=
 ahci libahci libata scsi_mod sp5100_tco
>         [  168.601896] CPU: 1 PID: 39 Comm: kworker/1:2 Not tainted 3.10.=
0-rc6+ #103
>         [  168.601900] Hardware name: ASROCK E350M1, BIOS 4.0-4334-geca6d=
02 06/19/2013
>         [  168.601912] Workqueue: rtl92c_usb rtl_watchdog_wq_callback [rt=
lwifi]
>         [  168.601916]  f66e17b8 c1023f9b c10364f3 f66e6f00 f4032840 f2c5=
1084 00000001 c1023fbb
>         [  168.601925]  00000009 00000000 c10364f3 f66d8f80 00000008 0000=
0297 f2c51084 00000008
>         [  168.601933]  f2c50e00 c1036585 f4032840 f2c50d80 00000000 0000=
0000 f8429287 00000000
>         [  168.601942] Call Trace:
>         [  168.601952]  [<c1023f9b>] ? warn_slowpath_common+0x4d/0x60
>         [  168.601958]  [<c10364f3>] ? __queue_work+0x177/0x1d1
>         [  168.601964]  [<c1023fbb>] ? warn_slowpath_null+0xd/0x10
>         [  168.601969]  [<c10364f3>] ? __queue_work+0x177/0x1d1
>         [  168.601975]  [<c1036585>] ? queue_work_on+0x2b/0x36
>         [  168.601984]  [<f8429287>] ? rtl_watchdog_wq_callback+0x1d9/0x3=
7f [rtlwifi]
>         [  168.601992]  [<c1042a00>] ? finish_task_switch+0x37/0x89
>         [  168.601998]  [<c12fe282>] ? __schedule+0x441/0x4c7
>         [  168.602004]  [<c1037459>] ? process_one_work+0x14c/0x230
>         [  168.602010]  [<c1037871>] ? worker_thread+0x107/0x1bd
>         [  168.602015]  [<c103776a>] ? rescuer_thread+0x210/0x210
>         [  168.602021]  [<c103b099>] ? kthread+0x68/0x6d
>         [  168.602027]  [<c1302f37>] ? ret_from_kernel_thread+0x1b/0x28
>         [  168.602032]  [<c103b031>] ? __kthread_parkme+0x50/0x50
>         [  168.602036] ---[ end trace 40aa884081d482ce ]---

the device still does not work with Linux 3.10. Larry, could you please
give me the instructions how to debug this? That would be great.


Thanks,

Paul


> [1] https://mail.gnome.org/archives/networkmanager-list/2013-June/msg0011=
2.html

--=-49OlvDHWvZ0dgITYkazq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlHpC0sACgkQPX1aK2wOHVg/EQCgghyiDbDRxzTDJiz2cpjLG75+
GhAAnR6h1hzsUwf+VQ4s3crKbiqdwj+f
=RnZf
-----END PGP SIGNATURE-----

--=-49OlvDHWvZ0dgITYkazq--

