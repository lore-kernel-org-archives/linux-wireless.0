Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:61342 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab3FDKJV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 06:09:21 -0400
Message-ID: <51ADBCC6.30302@blackshift.org> (sfid-20130604_120926_999915_28220215)
Date: Tue, 04 Jun 2013 12:09:10 +0200
From: Marc Kleine-Budde <mkl@blackshift.org>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org
Subject: Re: skb_under_panic in ath9k
References: <519D405B.2080806@blackshift.org>
In-Reply-To: <519D405B.2080806@blackshift.org>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2KBBIAECJLUTXTXOBORPV"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2KBBIAECJLUTXTXOBORPV
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On 05/23/2013 12:02 AM, Marc Kleine-Budde wrote:
> The system crashes repeatedly after about one week with the following
> oops:
>=20
> [633625.401875] skbuff: skb_under_panic: text:bf501028 len:128 put:8 he=
ad:d2788800 data:d27887fe tail:0xd278887e end:0xd2788f40 dev:wlan1
> [633625.414180] ------------[ cut here ]------------
> [633625.418909] kernel BUG at /build/buildd-linux_3.8.12-1-armel-7F6kBx=
/linux-3.8.12/net/core/skbuff.c:145!
> [633625.428430] Internal error: Oops - BUG: 0 [#1] ARM
> [633625.433322] Modules linked in:
> [...]
> [633625.583170] CPU: 0    Not tainted  (3.8-1-kirkwood #1 Debian 3.8.12=
-1)
> [633625.589821] PC is at skb_push+0x6c/0x84
> [633625.593763] LR is at skb_push+0x6c/0x84
> [633625.597707] pc : [<c0282990>]    lr : [<c0282990>]    psr: 20000013=

> [633625.597707] sp : c04c1d50  ip : 000008f8  fp : df04ea54
> [633625.609404] r10: 00000002  r9 : 00000008  r8 : df00dca8
> [633625.614734] r7 : 00000006  r6 : c04410a0  r5 : d278887e  r4 : d2788=
800
> [633625.621378] r3 : c04d328c  r2 : 20000093  r1 : 00000001  r0 : 00000=
079
> [633625.628015] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Se=
gment kernel
> [633625.635443] Control: 0005317f  Table: 1f224000  DAC: 00000017
> [633625.641295] Process swapper (pid: 0, stack limit =3D 0xc04c01b8)
> [633625.647241] Stack: (0xc04c1d50 to 0xc04c2000)
> [633625.657414] 1d40:                                     00000008 d278=
8800 d27887fe d278887e
> [633625.666101] 1d60: d2788f40 df04e000 df00dc00 df2e0c00 00000078 bf50=
1028 df2e0c00 dfba3120
> [633625.675025] 1d80: d278882a df04e9a0 00000000 bf504110 dfb3ce20 0000=
0201 00000000 00084502
> [633625.683954] 1da0: 00000001 df2e0c00 dfba3120 00000008 00000002 c04c=
1df4 00000000 00000001
> [633625.693553] 1dc0: 0000006a bf5058b0 00000000 c04c1df4 c04c1e30 dfba=
2300 c151ff18 df04e9a0
> [633625.702041] 1de0: c04c1e30 bf37560c 0000000c 00004288 c04c1e2c c151=
ff18 0000006a df2e0c00
> [633625.710540] 1e00: dfba2300 00000000 0000006a df04e462 00000000 0000=
0001 60000013 bf375760
> [633625.718904] 1e20: 00000001 c14c19a0 c14c0460 00000000 c04c1e30 c04c=
1e30 00000000 dfba2300
> [633625.727374] 1e40: df04e460 c151fc00 de5af200 00000002 00000002 dfba=
2300 dfba2308 dfba28a8
> [633625.787263] 1e60: c04c1e7c dfba28ac df2e0c00 bf376d58 c0508ae0 0000=
0000 0000012c 00000080
> [633625.798914] 1e80: 03c66eab c0508ae8 c04d4c68 c04d3494 00000000 0000=
0000 00000006 00000100
> [633625.810249] 1ea0: c052b3a0 00000009 c052b3c0 c0026e2c 00000001 0000=
0018 c04c0000 c0026644
> [633625.818620] 1ec0: c04d8f74 c1484260 1144b25a c04d8f74 00000000 0020=
0000 c04c1f4c 00000013
> [633625.831230] 1ee0: 00000000 fed20200 c04c1f4c 00000000 56251311 c04d=
0420 00000000 c0026a2c
> [633625.842695] 1f00: 00002000 c000f28c c004e27c c0271318 20000013 c000=
df94 c04c1f60 60000013
> [633625.853824] 1f20: 000e32dc 0002404f b5def004 0002404f c04d0698 0000=
0000 00000000 56251311
> [633625.864745] 1f40: c04d0420 00000000 00000003 c04c1f60 c004e27c c027=
1318 20000013 ffffffff
> [633625.875714] 1f60: b5ed22e0 0002404f 0084d405 00000000 00000000 c04d=
0698 00000000 c04d0698
> [633625.886646] 1f80: 00000000 c04d0420 004b8074 c0270e88 c04d0698 0000=
0000 c050918c c0271014
> [633625.898317] 1fa0: c04c0000 c0509b28 c04cc1cc c096f0e0 00004000 c000=
f484 c04c8c20 00000000
> [633625.909787] 1fc0: c04b9650 c0498764 ffffffff ffffffff c0498284 0000=
0000 00000000 c04b9650
> [633625.918159] 1fe0: 00000000 00053175 c04c8048 c04b964c c04cc1c4 0000=
8040 00000000 00000000
> [633625.926557] [<c0282990>] (skb_push+0x6c/0x84) from [<bf501028>] (ht=
c_issue_send.constprop.0+0x28/0x68 [ath9k_htc])
> [633625.937158] [<bf501028>] (htc_issue_send.constprop.0+0x28/0x68 [ath=
9k_htc]) from [<bf504110>] (ath9k_htc_tx_start+0x290/0x2a4 [ath9k_htc])
> [633625.949877] [<bf504110>] (ath9k_htc_tx_start+0x290/0x2a4 [ath9k_htc=
]) from [<bf5058b0>] (ath9k_htc_tx+0x98/0xcc [ath9k_htc])
> [633625.961458] [<bf5058b0>] (ath9k_htc_tx+0x98/0xcc [ath9k_htc]) from =
[<bf37560c>] (__ieee80211_tx+0x210/0x2a8 [mac80211])
> [633625.972695] [<bf37560c>] (__ieee80211_tx+0x210/0x2a8 [mac80211]) fr=
om [<bf375760>] (ieee80211_tx+0xbc/0xc4 [mac80211])
> [633625.983816] [<bf375760>] (ieee80211_tx+0xbc/0xc4 [mac80211]) from [=
<bf376d58>] (ieee80211_tx_pending+0xf0/0x194 [mac80211])
> [633625.995326] [<bf376d58>] (ieee80211_tx_pending+0xf0/0x194 [mac80211=
]) from [<c0026e2c>] (tasklet_action+0x84/0xcc)
> [633626.005905] [<c0026e2c>] (tasklet_action+0x84/0xcc) from [<c0026644=
>] (__do_softirq+0xdc/0x204)
> [633626.014750] [<c0026644>] (__do_softirq+0xdc/0x204) from [<c0026a2c>=
] (irq_exit+0x40/0x8c)
> [633626.023103] [<c0026a2c>] (irq_exit+0x40/0x8c) from [<c000f28c>] (ha=
ndle_IRQ+0x64/0x84)
> [633626.031193] [<c000f28c>] (handle_IRQ+0x64/0x84) from [<c000df94>] (=
__irq_svc+0x34/0x78)
> [633626.039412] [<c000df94>] (__irq_svc+0x34/0x78) from [<c0271318>] (c=
puidle_wrap_enter+0x54/0x9c)
> [633626.048331] [<c0271318>] (cpuidle_wrap_enter+0x54/0x9c) from [<c027=
0e88>] (cpuidle_enter_state+0x14/0x68)
> [633626.058162] [<c0270e88>] (cpuidle_enter_state+0x14/0x68) from [<c02=
71014>] (cpuidle_idle_call+0x138/0x25c)
> [633626.067998] [<c0271014>] (cpuidle_idle_call+0x138/0x25c) from [<c00=
0f484>] (cpu_idle+0x68/0xc8)
> [633626.076852] [<c000f484>] (cpu_idle+0x68/0xc8) from [<c0498764>] (st=
art_kernel+0x2b4/0x30c)
> [633626.146230] Code: e58dc014 e59f1014 e59f0014 eb0308b0 (e7f001f2)
> [633626.152520] ---[ end trace ee5dbceea3381e46 ]---
> [633626.157249] Kernel panic - not syncing: Fatal exception in interrup=
t

I got another crash with the same backtrace:

> [928701.926691] skbuff: skb_under_panic: text:bf3f0028 len:96 put:8 hea=
d:def9a600 data:def9a5fe tail:0xdef9a65e end:0xdef9a740 dev:wlan1
> [928701.938845] ------------[ cut here ]------------
> [928701.943572] kernel BUG at /build/buildd-linux_3.8.13-1-armel-0oa5Oc=
/linux-3.8.13/net/core/skbuff.c:145!
> [928701.953093] Internal error: Oops - BUG: 0 [#1] ARM
> [928701.957985] Modules linked in: sch_cbq rt2800usb rt2x00usb rt2800li=
b rt2x00lib crc_ccitt sit tunnel4 act_police cls_basic cls_flow cls_fw cl=
s_u32 sch_fq
> _codel sch_tbf sch_prio sch_htb sch_hfsc sch_ingress sch_sfq nf_conntra=
ck_sip xt_CHECKSUM ipt_rpfilter xt_statistic xt_CT xt_LOG xt_connlimit xt=
_realm xt_ad
> drtype xt_comment xt_recent xt_nat ipt_ULOG ipt_REJECT ipt_MASQUERADE i=
pt_ECN ipt_CLUSTERIP ipt_ah xt_set ip_set nf_nat_tftp nf_nat_snmp_basic n=
f_conntrack_
> snmp nf_nat_pptp nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_=
nat_amanda ts_kmp nf_conntrack_amanda nf_conntrack_sane nf_conntrack_tftp=
 nf_conntrac
> k_proto_sctp nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_netl=
ink nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_irc nf_co=
nntrack_h323
>  nf_conntrack_ftp xt_TPROXY nf_defrag_ipv6 nf_tproxy_core xt_time xt_TC=
PMSS xt_tcpmss xt_sctp xt_policy xt_pkttype xt_physdev xt_owner xt_NFQUEU=
E xt_NFLOG n
> fnetlink_log xt_multiport xt_mark xt_mac xt_limit xt_length xt_iprange =
xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp xt_conntrack xt_connmark x=
t_CLASSIFY x
> t_AUDIT xt_tcpudp xt_state iptable_raw iptable_nat nf_nat_ipv4 nf_nat n=
f_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack iptable_mangle nfnetlink ppp=
oe pppox ipt
> able_filter ip_tables x_tables fuse nfsd auth_rpcgss nfs_acl nfs lockd =
dns_resolver fscache sunrpc ppp_generic slhc 8021q garp tun bridge stp ll=
c ext2 dm_cr
> ypt sg arc4 ath9k_htc ath9k_common ath9k_hw ath cp210x mac80211 mct_u23=
2 hmac cfg80211 rfkill usbserial sha1_generic sd_mod crc_t10dif mv_cesa u=
sb_storage u
> sbhid hid ext4 jbd2 mbcache dm_mod mmc_block ehci_hcd sata_mv libata mv=
sdio usbcore scsi_mod usb_common mmc_core mv643xx_eth inet_lro libphy
> [928702.107833] CPU: 0    Not tainted  (3.8-2-kirkwood #1 Debian 3.8.13=
-1)
> [928702.114484] PC is at skb_push+0x6c/0x84
> [928702.118426] LR is at skb_push+0x6c/0x84
> [928702.122370] pc : [<c0282a7c>]    lr : [<c0282a7c>]    psr: 20000013=

> [928702.122370] sp : c04c1da0  ip : 000008f8  fp : df057a54
> [928702.134068] r10: 00000002  r9 : 00000030  r8 : dfb7b0a8
> [928702.139397] r7 : 00000006  r6 : c04410a0  r5 : def9a65e  r4 : def9a=
600
> [928702.146041] r3 : c04d328c  r2 : 20000093  r1 : 00000001  r0 : 00000=
078
> [928702.152687] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Se=
gment kernel
> [928702.160116] Control: 0005317f  Table: 1e324000  DAC: 00000017
> [928702.165975] Process swapper (pid: 0, stack limit =3D 0xc04c01b8)
> [928702.171923] Stack: (0xc04c1da0 to 0xc04c2000)
> [928702.185802] 1da0: 00000008 def9a600 def9a5fe def9a65e def9a740 df05=
7000 dfb7b000 dfa63800
> [928702.194801] 1dc0: 00000058 bf3f0028 dfa63800 dedf7120 def9a62a df05=
79a0 00000000 bf3f3110
> [928702.204372] 1de0: 1f904720 00000201 00000000 00300602 c0508880 dfa6=
3800 dedf7120 00000030
> [928702.213017] 1e00: 00000002 c04c1e44 00000000 00000001 0000004a bf3f=
48b0 00000000 c04c1e44
> [928702.221498] 1e20: c04c1e7c dedf6300 de9d6b18 df0579a0 c04c1e7c bf31=
160c 0000000c 00004288
> [928702.229985] 1e40: 00000007 de9d6b18 00000003 00000002 dedf6300 dedf=
6308 dedf68a8 c04c1e7c
> [928702.238815] 1e60: dedf68ac dfa63800 20000013 bf312d9c 00000001 0000=
0000 00000040 c04c1e7c
> [928702.247802] 1e80: c04c1e7c 00000000 ddeaa000 c04d3494 00000000 0000=
0000 00000006 00000100
> [928702.257007] 1ea0: c052b140 00000009 c052b160 c0026e2c 00000001 0000=
0018 c04c0000 c0026644
> [928702.266932] 1ec0: c04d8e74 c14a2360 1128d4b5 c04d8e74 00000000 0020=
0000 c04c1f4c 00000013
> [928702.275727] 1ee0: 00000000 fed20200 c04c1f4c 00000000 56251311 c04d=
0420 00000000 c0026a2c
> [928702.285474] 1f00: 00002000 c000f28c c004e27c c0271404 20000013 c000=
df94 c04c1f60 60000013
> [928702.333352] 1f20: 000459bb 00034cb4 57c485a3 00034cb4 c04d0698 0000=
0000 00000000 56251311
> [928702.345256] 1f40: c04d0420 00000000 00000003 c04c1f60 c004e27c c027=
1404 20000013 ffffffff
> [928702.357459] 1f60: 57c8df5e 00034cb4 0091cbfe 00000000 00000000 c04d=
0698 00000000 c04d0698
> [928702.365856] 1f80: 00000000 c04d0420 004b8074 c0270f74 c04d0698 0000=
0000 c0508f2c c0271100
> [928702.378646] 1fa0: c04c0000 c05098c8 c04cc1cc c096f0e0 00004000 c000=
f484 c04c8c20 00000000
> [928702.390861] 1fc0: c04b9650 c0498764 ffffffff ffffffff c0498284 0000=
0000 00000000 c04b9650
> [928702.402617] 1fe0: 00000000 00053175 c04c8048 c04b964c c04cc1c4 0000=
8040 00000000 00000000
> [928702.411182] [<c0282a7c>] (skb_push+0x6c/0x84) from [<bf3f0028>] (ht=
c_issue_send.constprop.0+0x28/0x68 [ath9k_htc])
> [928702.421866] [<bf3f0028>] (htc_issue_send.constprop.0+0x28/0x68 [ath=
9k_htc]) from [<bf3f3110>] (ath9k_htc_tx_start+0x290/0x2a4 [ath9k_htc])
> [928702.434567] [<bf3f3110>] (ath9k_htc_tx_start+0x290/0x2a4 [ath9k_htc=
]) from [<bf3f48b0>] (ath9k_htc_tx+0x98/0xcc [ath9k_htc])
> [928702.446402] [<bf3f48b0>] (ath9k_htc_tx+0x98/0xcc [ath9k_htc]) from =
[<bf31160c>] (__ieee80211_tx+0x210/0x2a8 [mac80211])
> [928702.457691] [<bf31160c>] (__ieee80211_tx+0x210/0x2a8 [mac80211]) fr=
om [<bf312d9c>] (ieee80211_tx_pending+0x134/0x194 [mac80211])
> [928702.469633] [<bf312d9c>] (ieee80211_tx_pending+0x134/0x194 [mac8021=
1]) from [<c0026e2c>] (tasklet_action+0x84/0xcc)
> [928702.480285] [<c0026e2c>] (tasklet_action+0x84/0xcc) from [<c0026644=
>] (__do_softirq+0xdc/0x204)
> [928702.489167] [<c0026644>] (__do_softirq+0xdc/0x204) from [<c0026a2c>=
] (irq_exit+0x40/0x8c)
> [928702.497533] [<c0026a2c>] (irq_exit+0x40/0x8c) from [<c000f28c>] (ha=
ndle_IRQ+0x64/0x84)
> [928702.505610] [<c000f28c>] (handle_IRQ+0x64/0x84) from [<c000df94>] (=
__irq_svc+0x34/0x78)
> [928702.513766] [<c000df94>] (__irq_svc+0x34/0x78) from [<c0271404>] (c=
puidle_wrap_enter+0x54/0x9c)
> [928702.522664] [<c0271404>] (cpuidle_wrap_enter+0x54/0x9c) from [<c027=
0f74>] (cpuidle_enter_state+0x14/0x68)
> [928702.532408] [<c0270f74>] (cpuidle_enter_state+0x14/0x68) from [<c02=
71100>] (cpuidle_idle_call+0x138/0x25c)
> [928702.542214] [<c0271100>] (cpuidle_idle_call+0x138/0x25c) from [<c00=
0f484>] (cpu_idle+0x68/0xc8)
> [928702.551090] [<c000f484>] (cpu_idle+0x68/0xc8) from [<c0498764>] (st=
art_kernel+0x2b4/0x30c)
> [928702.580308] Code: e58dc014 e59f1014 e59f0014 eb0308b0 (e7f001f2)
> [928702.586611] ---[ end trace 908fdc07dd882304 ]---
> [928702.591337] Kernel panic - not syncing: Fatal exception in interrup=
t

regards,
Marc


------enig2KBBIAECJLUTXTXOBORPV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJRrbzMAAoJEF5D1i44JRMaLfYP/i/xP7WoFSOd+ScFt+bf0vu3
96buVQsBd1LLlhh4VLUu8YQuNRaXyxeWgqhG45KmWkvyC7MSSXEEpjQ+f61T6dH6
zMBBgjECQmS26KOWPOj7q/bLX12H2yPp4+ZtI7ujp9eImVjiwCGGLxhopSwMLLxj
4/Z1PnIul0y1tMOii4nwJ/UuWXtdxZJVccGhrEsp2iSWq+ayNZx/48i1sYUd8iIu
S6XSrC3wVajUeA/uFmqE7TVDPjrg4+8IDiZuf/wXv+a+09GCF0OU08pCp1D3V0Fg
tbcJzq/ljSwp4zY9AHVTw1WF5xVrxcURVngyNGZl/H3xW92mcVxFrqzAc0t0hJ7T
RyMy83lcd69CqS/UQJAVXQ0Os2Oj2eDHwo1duuffVGDn1yq6LRL3uQjhIBKwXSA3
dm+K4wEwC+2K6XwyOPJXkKYHeghMSW+5S1L1SDKNYLFMhXVGx2fMYVI9HNYDQIse
qpd9I/+MLBZXujNFvLvGFgTuUyokuL6kxbR+TquP3BH1dhUDf92wWGC4uJJdpMaB
WcEHIYGP2gYcWRtfnmOM3BRnnx/tvOVJeV2Yqb5YZpECgmCkvkHwuhh37UbvvFYG
H2qYJBB+lkO+wUEV8pKesYbIVAwGfN3vpkjWzZC7+GpWGeP5Bbf9icEUfhZRV5aj
ChmCdtrjlxmHNZzz1T9M
=SorH
-----END PGP SIGNATURE-----

------enig2KBBIAECJLUTXTXOBORPV--
