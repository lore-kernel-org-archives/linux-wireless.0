Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44021 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750957Ab3G3TTF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jul 2013 15:19:05 -0400
Received: from deadeye.visitor.camp.ohm2013.org ([151.216.67.181] helo=deadeye.wl.decadent.org.uk)
	by shadbolt.decadent.org.uk with esmtps (TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <ben@decadent.org.uk>)
	id 1V4FRj-0003NP-OS
	for linux-wireless@vger.kernel.org; Tue, 30 Jul 2013 20:19:01 +0100
Received: from ben by deadeye.wl.decadent.org.uk with local (Exim 4.80)
	(envelope-from <ben@decadent.org.uk>)
	id 1V4FRg-00029y-2Z
	for linux-wireless@vger.kernel.org; Tue, 30 Jul 2013 21:18:56 +0200
Message-ID: <1375211931.2664.21.camel@deadeye.wl.decadent.org.uk> (sfid-20130730_211910_708043_1782E991)
Subject: Oops in nl80211_set_reg, Linux 3.10.3
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 30 Jul 2013 21:18:51 +0200
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-l2fvbMXzyUWuT+lBvpMI"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-l2fvbMXzyUWuT+lBvpMI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I was having trouble associating with a wireless network, and hit this
oops:

Jul 30 17:50:09 deadeye kernel: [79205.769051] wlan1: authenticate with a4:=
56:30:46:54:40
Jul 30 17:50:09 deadeye kernel: [79205.773509] wlan1: send auth to a4:56:30=
:46:54:40 (try 1/3)
Jul 30 17:50:09 deadeye kernel: [79205.773545] cfg80211: Calling CRDA to up=
date world regulatory domain
Jul 30 17:50:09 deadeye kernel: [79205.777747] cfg80211: World regulatory d=
omain updated:
Jul 30 17:50:09 deadeye kernel: [79205.777752] cfg80211:   (start_freq - en=
d_freq @ bandwidth), (max_antenna_gain, max_eirp)
Jul 30 17:50:09 deadeye kernel: [79205.777754] cfg80211:   (2402000 KHz - 2=
472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jul 30 17:50:09 deadeye kernel: [79205.777756] cfg80211:   (2457000 KHz - 2=
482000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jul 30 17:50:09 deadeye kernel: [79205.777759] cfg80211:   (2474000 KHz - 2=
494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Jul 30 17:50:09 deadeye kernel: [79205.777761] cfg80211:   (5170000 KHz - 5=
250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jul 30 17:50:09 deadeye kernel: [79205.777762] cfg80211:   (5735000 KHz - 5=
835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jul 30 17:50:09 deadeye kernel: [79205.777780] cfg80211: Calling CRDA for c=
ountry: GB
Jul 30 17:50:09 deadeye kernel: [79205.778936] wlan1: authenticated
Jul 30 17:50:09 deadeye kernel: [79205.779101] wlan1: associate with a4:56:=
30:46:54:40 (try 1/3)
Jul 30 17:50:09 deadeye NetworkManager[1100]: <info> (wlan1): roamed from B=
SSID A4:56:30:15:B4:8F (OHM2013) to (none) ((none))
Jul 30 17:50:09 deadeye NetworkManager[1100]: <info> (wlan1): supplicant in=
terface state: completed -> authenticating
Jul 30 17:50:09 deadeye NetworkManager[1100]: <info> (wlan1): supplicant in=
terface state: authenticating -> associating
Jul 30 17:50:09 deadeye kernel: [79205.783659] cfg80211: Regulatory domain =
changed to country: GB
Jul 30 17:50:09 deadeye kernel: [79205.783662] cfg80211:   (start_freq - en=
d_freq @ bandwidth), (max_antenna_gain, max_eirp)
Jul 30 17:50:09 deadeye kernel: [79205.783664] cfg80211:   (2402000 KHz - 2=
482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Jul 30 17:50:09 deadeye kernel: [79205.783665] cfg80211:   (5170000 KHz - 5=
250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Jul 30 17:50:09 deadeye kernel: [79205.783666] cfg80211:   (5250000 KHz - 5=
330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Jul 30 17:50:09 deadeye kernel: [79205.783667] cfg80211:   (5490000 KHz - 5=
710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
Jul 30 17:50:09 deadeye kernel: [79205.783669] cfg80211:   (57240000 KHz - =
65880000 KHz @ 2160000 KHz), (N/A, 4000 mBm)
Jul 30 17:50:09 deadeye kernel: [79205.794765] wlan1: RX AssocResp from a4:=
56:30:46:54:40 (capab=3D0x421 status=3D17 aid=3D0)
Jul 30 17:50:09 deadeye kernel: [79205.794770] wlan1: a4:56:30:46:54:40 den=
ied association (code=3D17)
Jul 30 17:50:09 deadeye kernel: [79205.827545] wlan1: deauthenticating from=
 a4:56:30:46:54:40 by local choice (reason=3D3)
Jul 30 17:50:09 deadeye NetworkManager[1100]: <info> (wlan1): supplicant in=
terface state: associating -> disconnected
Jul 30 17:50:09 deadeye NetworkManager[1100]: <info> (wlan1): supplicant in=
terface state: disconnected -> scanning
Jul 30 17:50:10 deadeye kernel: [79206.155383] wlan1: authenticate with f4:=
7f:35:5e:ba:70
Jul 30 17:50:10 deadeye kernel: [79206.158140] wlan1: send auth to f4:7f:35=
:5e:ba:70 (try 1/3)
Jul 30 17:50:10 deadeye kernel: [79206.160341] wlan1: authenticated
Jul 30 17:50:10 deadeye kernel: [79206.162981] wlan1: associate with f4:7f:=
35:5e:ba:70 (try 1/3)
Jul 30 17:50:10 deadeye kernel: [79206.200270] wlan1: RX AssocResp from f4:=
7f:35:5e:ba:70 (capab=3D0x421 status=3D17 aid=3D0)
Jul 30 17:50:10 deadeye kernel: [79206.200286] wlan1: f4:7f:35:5e:ba:70 den=
ied association (code=3D17)
Jul 30 17:50:10 deadeye NetworkManager[1100]: <info> (wlan1): supplicant in=
terface state: scanning -> authenticating
Jul 30 17:50:10 deadeye NetworkManager[1100]: <info> (wlan1): supplicant in=
terface state: authenticating -> associating
Jul 30 17:50:10 deadeye kernel: [79206.229284] wlan1: deauthenticating from=
 f4:7f:35:5e:ba:70 by local choice (reason=3D3)
Jul 30 17:50:10 deadeye NetworkManager[1100]: <info> (wlan1): supplicant in=
terface state: associating -> disconnected
Jul 30 17:50:10 deadeye NetworkManager[1100]: <info> (wlan1): supplicant in=
terface state: disconnected -> scanning
Jul 30 17:50:10 deadeye kernel: [79206.601352] wlan1: authenticate with a4:=
56:30:15:b4:8f
Jul 30 17:50:10 deadeye kernel: [79206.605532] wlan1: send auth to a4:56:30=
:15:b4:8f (try 1/3)
Jul 30 17:50:10 deadeye NetworkManager[1100]: <info> (wlan1): supplicant in=
terface state: scanning -> authenticating
Jul 30 17:50:10 deadeye kernel: [79206.708757] wlan1: authenticated
Jul 30 17:50:10 deadeye kernel: [79206.710848] wlan1: associate with a4:56:=
30:15:b4:8f (try 1/3)
Jul 30 17:50:10 deadeye NetworkManager[1100]: <info> (wlan1): supplicant in=
terface state: authenticating -> associating
Jul 30 17:50:10 deadeye kernel: [79206.724962] wlan1: RX AssocResp from a4:=
56:30:15:b4:8f (capab=3D0x1 status=3D0 aid=3D24)
Jul 30 17:50:10 deadeye kernel: [79206.728872] wlan1: associated
Jul 30 17:50:10 deadeye kernel: [79206.728944] cfg80211: Calling CRDA for c=
ountry: NL
Jul 30 17:50:10 deadeye NetworkManager[1100]: <info> (wlan1): supplicant in=
terface state: associating -> completed
Jul 30 17:50:10 deadeye kernel: [79206.736985] PGD 1d4b42067 PUD 1f957e067 =
PMD 0=20
Jul 30 17:50:10 deadeye kernel: [79206.737110] Oops: 0000 [#1] SMP=20
Jul 30 17:50:10 deadeye kernel: [79206.737201] Modules linked in: ip6table_=
filter ip6_tables ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat_ip=
v4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_RE=
JECT xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables=
 bridge stp llc snd_hrtimer rfcomm bnep cpufreq_userspace cpufreq_conservat=
ive cpufreq_powersave cpufreq_stats parport_pc ppdev lp parport uinput joyd=
ev snd_hda_codec_hdmi snd_hda_codec_conexant nfsd auth_rpcgss oid_registry =
nfs_acl nfs lockd dns_resolver fscache sunrpc thinkpad_acpi iTCO_wdt iTCO_v=
endor_support nvram snd_seq_midi snd_seq_midi_event coretemp snd_hda_intel =
snd_hda_codec uvcvideo snd_hwdep crc32c_intel snd_pcm_oss snd_mixer_oss vid=
eobuf2_vmalloc videobuf2_memops videobuf2_core videodev snd_pcm snd_rawmidi=
 media ghash_clmulni_intel snd_page_alloc arc4 snd_seq snd_seq_device snd_t=
imer btusb bluetooth iwldvm mac80211 ac aesni_intel snd battery aes_x86_64 =
ablk_helper cryptd lrw gf128mul glue_helper iwlwifi tpm_tis microcode tpm t=
pm_bios soundcore cfg80211 psmouse pcspkr evdev serio_raw i2c_i801 wmi rfki=
ll mei_me mei i915 lpc_ich mfd_core video button drm_kms_helper drm i2c_alg=
o_bit i2c_core vhost_net tun macvtap macvlan kvm_intel kvm mperf processor =
fuse autofs4 ext4 crc16 jbd2 mbcache btrfs xor zlib_deflate raid6_pq crc32c=
 libcrc32c dm_mod sg sr_mod sd_mod cdrom crc_t10dif thermal thermal_sys ahc=
i libahci libata ehci_pci ehci_hcd scsi_mod sdhci_pci sdhci mmc_core usbcor=
e usb_common e1000e ptp pps_core
Jul 30 17:50:10 deadeye kernel: [79206.740916] CPU: 3 PID: 525 Comm: crda N=
ot tainted 3.10-1-amd64 #1 Debian 3.10.3-1
Jul 30 17:50:10 deadeye kernel: [79206.741075] Hardware name: LENOVO 4180ET=
1/4180ET1, BIOS 83ET65WW (1.35 ) 10/06/2011
Jul 30 17:50:10 deadeye kernel: [79206.741234] task: ffff88016d38d0c0 ti: f=
fff88016d2c8000 task.ti: ffff88016d2c8000
Jul 30 17:50:10 deadeye kernel: [79206.741388] RIP: 0010:[<ffffffffa04a8715=
>]  [<ffffffffa04a8715>] nl80211_set_reg+0xd6/0x212 [cfg80211]
Jul 30 17:50:10 deadeye kernel: [79206.741612] RSP: 0018:ffff88016d2c9a10  =
EFLAGS: 00210246
Jul 30 17:50:10 deadeye kernel: [79206.741725] RAX: 0000000000000000 RBX: f=
fff880214a6c240 RCX: 00000000000000c0
Jul 30 17:50:10 deadeye kernel: [79206.741872] RDX: 0000000000000090 RSI: f=
fff880214a6c240 RDI: 0000000000000000
Jul 30 17:50:10 deadeye kernel: [79206.742019] RBP: 0000000000000004 R08: 0=
0000000000080d0 R09: 0000000000050008
Jul 30 17:50:10 deadeye kernel: [79206.742166] R10: ffff88021211a414 R11: 0=
001000800000034 R12: 0000000000000000
Jul 30 17:50:10 deadeye kernel: [79206.742314] R13: ffff88021211a414 R14: f=
fff88016d2c9a90 R15: ffffffffa04d23d0
Jul 30 17:50:10 deadeye kernel: [79206.742462] FS:  0000000000000000(0000) =
GS:ffff88021e2c0000(0063) knlGS:00000000f7262a00
Jul 30 17:50:10 deadeye kernel: [79206.742628] CS:  0010 DS: 002b ES: 002b =
CR0: 0000000080050033
Jul 30 17:50:10 deadeye kernel: [79206.742747] CR2: 0000000000000000 CR3: 0=
000000210354000 CR4: 00000000000407e0
Jul 30 17:50:10 deadeye kernel: [79206.742898] DR0: 0000000000000000 DR1: 0=
000000000000000 DR2: 0000000000000000
Jul 30 17:50:10 deadeye kernel: [79206.743046] DR3: 0000000000000000 DR6: 0=
0000000ffff0ff0 DR7: 0000000000000400
Jul 30 17:50:10 deadeye kernel: [79206.743191] Stack:
Jul 30 17:50:10 deadeye kernel: [79206.743238]  000000006d1a6400 ffffffff81=
67f760 ffff88021211a424 0000000000000108
Jul 30 17:50:10 deadeye kernel: [79206.743422]  ffff880212aba000 0000000000=
0000b4 ffffffff811d66f8 ffffffffa04d29d8
Jul 30 17:50:10 deadeye kernel: [79206.743599]  ffffffffa04d29d8 0000000000=
000000 ffff880212aba000 ffff8801d4ad78c0
Jul 30 17:50:10 deadeye kernel: [79206.743777] Call Trace:
Jul 30 17:50:10 deadeye kernel: [79206.743844]  [<ffffffff811d66f8>] ? nla_=
parse+0x54/0xb6
Jul 30 17:50:10 deadeye kernel: [79206.743970]  [<ffffffff812e84fe>] ? genl=
_family_rcv_msg+0x1cc/0x230
Jul 30 17:50:10 deadeye kernel: [79206.744110]  [<ffffffff812e86e4>] ? genl=
_rcv_msg+0x35/0x53
Jul 30 17:50:10 deadeye kernel: [79206.744228]  [<ffffffff812e86af>] ? genl=
_lock+0xc/0xc
Jul 30 17:50:10 deadeye kernel: [79206.744337]  [<ffffffff812e8135>] ? netl=
ink_rcv_skb+0x36/0x7c
Jul 30 17:50:10 deadeye kernel: [79206.744460]  [<ffffffff812e8325>] ? genl=
_rcv+0x1f/0x2c
Jul 30 17:50:10 deadeye kernel: [79206.744574]  [<ffffffff812e7999>] ? netl=
ink_unicast+0xa4/0x120
Jul 30 17:50:10 deadeye kernel: [79206.744702]  [<ffffffff812e7f43>] ? netl=
ink_sendmsg+0x52e/0x573
Jul 30 17:50:10 deadeye kernel: [79206.744829]  [<ffffffff8138801f>] ? _raw=
_spin_unlock_irqrestore+0xc/0xd
Jul 30 17:50:10 deadeye kernel: [79206.744971]  [<ffffffff812e6681>] ? netl=
ink_recvmsg+0x2b1/0x2d1
Jul 30 17:50:10 deadeye kernel: [79206.745101]  [<ffffffff812b5a3f>] ? sock=
_sendmsg+0x4f/0x6c
Jul 30 17:50:10 deadeye kernel: [79206.745225]  [<ffffffff81073936>] ? curr=
ent_kernel_time+0x11/0x35
Jul 30 17:50:10 deadeye kernel: [79206.745357]  [<ffffffff812b5c48>] ? ___s=
ys_sendmsg+0x1ec/0x27e
Jul 30 17:50:10 deadeye kernel: [79206.745486]  [<ffffffff810de4f3>] ? hand=
le_pte_fault+0x2c5/0x7a7
Jul 30 17:50:10 deadeye kernel: [79206.745615]  [<ffffffff810ded46>] ? hand=
le_mm_fault+0x1f1/0x238
Jul 30 17:50:10 deadeye kernel: [79206.745743]  [<ffffffff8138b1b3>] ? __do=
_page_fault+0x32d/0x3cb
Jul 30 17:50:10 deadeye kernel: [79206.745870]  [<ffffffff812b4de7>] ? move=
_addr_to_user+0x60/0x90
Jul 30 17:50:10 deadeye kernel: [79206.745998]  [<ffffffff812b5173>] ? SYSC=
_getsockname+0x8e/0xb7
Jul 30 17:50:10 deadeye kernel: [79206.746125]  [<ffffffff812b696a>] ? __sy=
s_sendmsg+0x39/0x57
Jul 30 17:50:10 deadeye kernel: [79206.746248]  [<ffffffff812dda04>] ? comp=
at_sys_socketcall+0x157/0x1af
Jul 30 17:50:10 deadeye kernel: [79206.746388]  [<ffffffff8138e9ec>] ? syse=
nter_dispatch+0x7/0x21
Jul 30 17:50:10 deadeye kernel: [79206.746509] Code: b6 fc 88 43 14 41 8a 4=
5 05 88 43 15 e8 6b 5c ff ff 84 c0 74 04 44 88 63 16 49 8b 46 20 45 31 e4 4=
8 8b 80 10 01 00 00 48 8d 68 04 <0f> b7 00 83 e8 04 89 44 24 04 e9 c3 00 00=
 00 0f b7 4d 00 48 8d=20
Jul 30 17:50:10 deadeye kernel: [79206.751445]  RSP <ffff88016d2c9a10>
Jul 30 17:50:10 deadeye kernel: [79206.756353] CR2: 0000000000000000
Jul 30 17:50:10 deadeye kernel: [79206.783728] ---[ end trace 6c1535d909d97=
f6d ]---

The code dump seems to match up to source like this:

	if (reg_supported_dfs_region(dfs_region))
		rd->dfs_region =3D dfs_region;
    f6f6:       e8 00 00 00 00          callq  reg_supported_dfs_region
    f6fb:       84 c0                   test   %al,%al
    f6fd:       74 04                   je     f703 <nl80211_set_reg+0xc4>
    f6ff:       44 88 63 16             mov    %r12b,0x16(%rbx)

	nla_for_each_nested(nl_reg_rule, info->attrs[NL80211_ATTR_REG_RULES],
			    rem_reg_rules) {
    f703:       49 8b 46 20             mov    0x20(%r14),%rax     info->at=
trs
    f707:       45 31 e4                xor    %r12d,%r12d
    f70a:       48 8b 80 10 01 00 00    mov    0x110(%rax),%rax    info->at=
trs[NL80211_ATTR_REG_RULES]
    f711:       48 8d 68 04             lea    0x4(%rax),%rbp
*   f715:       0f b7 00                movzwl (%rax),%eax         info->at=
trs[NL80211_ATTR_REG_RULES]->nla_len

So info->attrs[NL80211_ATTR_REG_RULES] =3D=3D NULL.  But the function
already checked that it wasn't!  So I don't know what's going on - could
be a memory corruption completely unrelated to nl80211.

Ben.

--=20
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camu=
s

--=-l2fvbMXzyUWuT+lBvpMI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUfgRm+e/yOyVhhEJAQq/pQ//TZBQEuLcyrNaJIw9Cq5RB8/cpJX/0B1Z
1e8j7rPEih1ELw5XfauDPoweczuc6JRPT0BNf2X5ql00wMAnQDlUBC4Any/boRbJ
+wTwjBEl1vAlrlptAA803MoO6RmVeZrQf8rJYAUudT8rXu+EVS/AO8OlLu/iWx3J
oaIglmED9K5SoFLvNofQiEPLC0oqrpIglvYmsJTQHWlwKZi86EbcYmOUS8Uswk+5
/PK3h/1ALERNMrYtYp8pNZINZP/23VQaaD2JwbnYyDd9ohDi8UECWcWnRjbalz2a
fWsJx36BOavmo1rotn/l0XPPS3NKg7z0EZHD4t9mCS7aT0WdLRzBtO6IDCmcuGnL
gBF72h3x7ZHDS2n+L7kDlnamKhEh2YXyXZJoPx/O9SsIPWv3o+mH2RsA315t2zgT
uhU0N0umLNSBPsklyT6vP4arMng5GVENuGZr/3attdk7ZZd0EL7y6gRNGgm0V2bj
6kzVZ2vJ3PCJcXiJedw/NEA7c/8Wn115HbOWK/342zNBW5BlSY3EKocU5VG3UMuW
lIjjlTbK7apX6I4fUCgBBAd98jer9f1OKeE01EfSwExLgQtPKC5tr1YFkfT7O2U9
nzTOVSXnN3SqePIaYYh3Gs7PkW1cz90Wo4ANAWBJH8DQ62vmLZ24W35FRo5cRQtG
5jp6RmSycWs=
=Mw1J
-----END PGP SIGNATURE-----

--=-l2fvbMXzyUWuT+lBvpMI--
