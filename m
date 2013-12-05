Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:62870 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756754Ab3LEOwc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 09:52:32 -0500
Received: from [192.168.1.138] ([93.218.116.213]) by mail.gmx.com (mrgmx001)
 with ESMTPSA (Nemesis) id 0MgKUo-1WCHqU0aFa-00NiVs for
 <linux-wireless@vger.kernel.org>; Thu, 05 Dec 2013 15:52:30 +0100
Message-ID: <52A09324.6050706@rempel-privat.de> (sfid-20131205_155235_468092_4544165E)
Date: Thu, 05 Dec 2013 15:52:20 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: David Herrmann <dh.herrmann@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
CC: ath9k-devel@lists.ath9k.org
Subject: Re: [BUG] Atheros AR9280: NULL-deref during P2P setup
References: <CANq1E4Td-uDE7fR-5PkJEBZkMRQODs+i-jgytt4O2YewxT9yrA@mail.gmail.com>
In-Reply-To: <CANq1E4Td-uDE7fR-5PkJEBZkMRQODs+i-jgytt4O2YewxT9yrA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Es1oGeI0rkfLRHWS8bc4p3vcIodrW5fBI"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Es1oGeI0rkfLRHWS8bc4p3vcIodrW5fBI
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi David,

currently i work on other ath9k_htc related issue. If you or some body
else can work on this one it will be great.

Am 05.12.2013 11:31, schrieb David Herrmann:
> Hi
>=20
> I'm testing wifi-P2P with an ath9k_htc device. The relevant log from wp=
a_cli is:
>=20
>> p2p_find
> OK
> <3>P2P-DEVICE-FOUND 12:68:3f:4e:39:f2 p2p_dev_addr=3D12:68:3f:4e:39:f2
> pri_dev_type=3D10-0050F204-5 name=3D'dvdhrm-nx' config_methods=3D0x188
> dev_capab=3D0x25 group_capab=3D0x0
> <3>P2P-PROV-DISC-SHOW-PIN 12:68:3f:4e:39:f2 33413853
> p2p_dev_addr=3D12:68:3f:4e:39:f2 pri_dev_type=3D10-0050F204-5
> name=3D'dvdhrm-nx' config_methods=3D0x188 dev_capab=3D0x25 group_capab=3D=
0x0
>> p2p_connect 12:68:3f:4e:39:f2 pin
> 98344376
> <3>P2P-FIND-STOPPED
> <3>P2P-GO-NEG-SUCCESS role=3DGO freq=3D2462 ht40=3D0
> peer_dev=3D12:68:3f:4e:39:f2 peer_iface=3D12:68:3f:4e:b9:f2
> wps_method=3DDisplay
>=20
> After the P2P-GO-NEG-SUCCESS I get a NULL-deref in the ath9k-htc
> driver, logs appended below. Kernel is 3.12.2 but I also get this with
> 3.11. I can test any -git trees if you want, but bisecting won't work
> as I don't know any working revision.
>=20
> Any hints are welcome!
> Thanks
> David
>=20
>=20
> Dec 05 11:13:46 david-ub kernel: BUG: unable to handle kernel NULL
> pointer dereference at 000000000000000c
> Dec 05 11:13:46 david-ub kernel: IP: [<ffffffffa0b6d9e2>]
> ar9002_hw_calibrate+0x3b2/0x430 [ath9k_hw]
> Dec 05 11:13:46 david-ub kernel: PGD 0.
> Dec 05 11:13:46 david-ub kernel: Oops: 0002 [#1] PREEMPT SMP.
> Dec 05 11:13:46 david-ub kernel: Modules linked in: ath9k_htc
> ath9k_common ath9k_hw ath btusb bluetooth crc16 uvcvideo
> videobuf2_vmalloc videobuf2_memops videobuf2_core videodev media
> x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm
> crct10dif_pclmul crct10dif_common crc32_pclmul ghash_clmulni_intel
> aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd
> joydev arc4 hid_sensor_hub nls_cp437 vfat fat hid_generic
> microread_mei microread crc_ccitt mei_phy hid_multitouch hci nfc
> iwldvm iTCO_wdt iTCO_vendor_support mac80211 iwlwifi microcode psmouse
> evdev snd_hda_codec_hdmi ums_realtek usbhid usb_storage serio_raw hid
> cfg80211 pcspkr i2c_i801 snd_hda_codec_realtek rfkill i915 fan thermal
> snd_hda_intel intel_agp intel_gtt drm_kms_helper snd_hda_codec drm
> battery video snd_hwdep snd_pcm i2c_algo_bit i2c_core
> Dec 05 11:13:46 david-ub kernel:  snd_page_alloc ac mei_me snd_timer
> snd mei button soundcore shpchp lpc_ich processor usbip_host(C)
> usbip_core(C) btrfs libcrc32c xor raid6_pq sd_mod crc32c_intel ahci
> libahci libata ehci_pci xhci_hcd ehci_hcd scsi_mod usbcore usb_common
> Dec 05 11:13:46 david-ub kernel: CPU: 1 PID: 6 Comm: kworker/u32:0
> Tainted: G         C   3.12.2-1-ARCH #1
> Dec 05 11:13:46 david-ub kernel: Hardware name: Intel Corporation 2012
> Client Platform/Latexo FFRD, BIOS ACRVMBY1.86C.0094.P02.1207301240
> 07/30/2012
> Dec 05 11:13:46 david-ub kernel: Workqueue: phy2 ath9k_htc_ani_work
> [ath9k_htc]
> Dec 05 11:13:46 david-ub kernel: task: ffff8801492dab70 ti:
> ffff880149352000 task.ti: ffff880149352000
> Dec 05 11:13:46 david-ub kernel: RIP: 0010:[<ffffffffa0b6d9e2>]
> [<ffffffffa0b6d9e2>] ar9002_hw_calibrate+0x3b2/0x430 [ath9k_hw]
> Dec 05 11:13:46 david-ub kernel: RSP: 0018:ffff880149353db0  EFLAGS:
> 00010286
> Dec 05 11:13:46 david-ub kernel: RAX: 0000000000000001 RBX:
> ffff880149294000 RCX: 00000000ffffffff
> Dec 05 11:13:46 david-ub kernel: RDX: 0000000000000000 RSI:
> 0000000000000046 RDI: 0000000000000246
> Dec 05 11:13:46 david-ub kernel: RBP: ffff880149353de8 R08:
> 0000000000000000 R09: 0000000000000001
> Dec 05 11:13:46 david-ub kernel: R10: 0000000000000002 R11:
> 0000000000000000 R12: 0000000000000000
> Dec 05 11:13:46 david-ub kernel: R13: ffff880149294220 R14:
> ffff8801492955c0 R15: 0000000000000000
> Dec 05 11:13:46 david-ub kernel: FS:  0000000000000000(0000)
> GS:ffff88014f220000(0000) knlGS:0000000000000000
> Dec 05 11:13:46 david-ub kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
> 0000000080050033
> Dec 05 11:13:46 david-ub kernel: CR2: 000000000000000c CR3:
> 000000000280d000 CR4: 00000000001407e0
> Dec 05 11:13:46 david-ub kernel: Stack:
> Dec 05 11:13:46 david-ub kernel:  00000000a0bdba8e ffff880100000000
> ffff880149294000 ffff88013e42dde0
> Dec 05 11:13:46 david-ub kernel:  0000000055554fb8 ffff88013e42d7c0
> 0000000000000000 ffff880149353e20
> Dec 05 11:13:46 david-ub kernel:  ffffffffa0bda99a ffff88014925db00
> ffff88014a811800 ffff88013e42dde0
> Dec 05 11:13:46 david-ub kernel: Call Trace:
> Dec 05 11:13:46 david-ub kernel:  [<ffffffffa0bda99a>]
> ath9k_htc_ani_work+0xea/0x1a0 [ath9k_htc]
> Dec 05 11:13:46 david-ub kernel:  [<ffffffff8107daf7>]
> process_one_work+0x167/0x450
> Dec 05 11:13:46 david-ub kernel:  [<ffffffff8107e501>] worker_thread+0x=
121/0x3a0
> Dec 05 11:13:46 david-ub kernel:  [<ffffffff8107e3e0>] ?
> manage_workers.isra.23+0x2b0/0x2b0
> Dec 05 11:13:46 david-ub kernel:  [<ffffffff81084e90>] kthread+0xc0/0xd=
0
> Dec 05 11:13:46 david-ub kernel:  [<ffffffff81084dd0>] ?
> kthread_create_on_node+0x120/0x120
> Dec 05 11:13:46 david-ub kernel:  [<ffffffff814fc33c>] ret_from_fork+0x=
7c/0xb0
> Dec 05 11:13:46 david-ub kernel:  [<ffffffff81084dd0>] ?
> kthread_create_on_node+0x120/0x120
> Dec 05 11:13:46 david-ub kernel: Code: d3 f8 83 e0 01 83 f8 01 83 de
> ff 83 c1 01 83 f9 03 75 eb 44 89 45 d0 40 0f b6 f6 48 89 df 41 ff 51
> 18 49 8b 06 44 8b 45 d0 8b 00 <41> 09 47 0c 49 8b 76 10 41 c7 46 08 03
> 00 00 00 48 89 b3 00 16.
> Dec 05 11:13:46 david-ub kernel: RIP  [<ffffffffa0b6d9e2>]
> ar9002_hw_calibrate+0x3b2/0x430 [ath9k_hw]
> Dec 05 11:13:46 david-ub kernel:  RSP <ffff880149353db0>
> Dec 05 11:13:46 david-ub kernel: CR2: 000000000000000c
> Dec 05 11:13:46 david-ub kernel: ---[ end trace 568b2b5d97c813d2 ]---
> Dec 05 11:13:46 david-ub kernel: BUG: unable to handle kernel paging
> request at ffffffffffffffd8
> Dec 05 11:13:46 david-ub kernel: IP: [<ffffffff810854f0>] kthread_data+=
0x10/0x20
>=20
>=20
> The log before the oops is just the USB-hotplug information:
>=20
> Dec 05 11:12:59 david-ub kernel: usb 1-3: new high-speed USB device
> number 3 using xhci_hcd
> Dec 05 11:12:59 david-ub kernel: usbip-host 1-3:1.0: 1-3 is not in
> match_busid table... skip!
> Dec 05 11:12:59 david-ub kernel: usb 1-3: ath9k_htc: Firmware
> htc_7010.fw requested
> Dec 05 11:12:59 david-ub kernel: usb 1-3: ath9k_htc: Transferred FW:
> htc_7010.fw, size: 72992
> Dec 05 11:12:59 david-ub kernel: ath9k_htc 1-3:1.0: ath9k_htc: HTC
> initialized with 45 credits
> Dec 05 11:13:00 david-ub kernel: ath9k_htc 1-3:1.0: ath9k_htc: FW Versi=
on: 1.3
> Dec 05 11:13:00 david-ub kernel: ath: EEPROM regdomain: 0x6a
> Dec 05 11:13:00 david-ub kernel: ath: EEPROM indicates we should
> expect a direct regpair map
> Dec 05 11:13:00 david-ub kernel: ath: Country alpha2 being used: 00
> Dec 05 11:13:00 david-ub kernel: ath: Regpair used: 0x6a
> Dec 05 11:13:00 david-ub kernel: ieee80211 phy2: Atheros AR9280 Rev:2
> Dec 05 11:13:02 david-ub kernel: IPv6: ADDRCONF(NETDEV_UP): wlan1:
> link is not ready
> Dec 05 11:13:46 david-ub kernel: IPv6: ADDRCONF(NETDEV_UP):
> p2p-wlan1-0: link is not ready
> Dec 05 11:13:46 david-ub kernel: IPv6: ADDRCONF(NETDEV_UP):
> p2p-wlan1-0: link is not ready
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
Regards,
Oleksij


--Es1oGeI0rkfLRHWS8bc4p3vcIodrW5fBI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlKgkyoACgkQHwImuRkmbWk1RwD/bH9ydYlCUKG+zkafQddnn6TH
gD9nLh9E7rBD2TwBMtkA/3qCNus9+WAAtEFVB0mEjwDfeBaOPM6qf4buB4nIxD+C
=2Lq0
-----END PGP SIGNATURE-----

--Es1oGeI0rkfLRHWS8bc4p3vcIodrW5fBI--
