Return-Path: <SRS0=EMXR=RQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25AA9C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 09:53:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDDAD2183F
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 09:53:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=camlinlimited.onmicrosoft.com header.i=@camlinlimited.onmicrosoft.com header.b="qH4/zGBC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbfCMJxq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Mar 2019 05:53:46 -0400
Received: from mail-eopbgr100053.outbound.protection.outlook.com ([40.107.10.53]:11232
        "EHLO GBR01-LO2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726477AbfCMJxp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Mar 2019 05:53:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=camlinlimited.onmicrosoft.com; s=selector1-camlintechnologies-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C2cXHWdHUz5kEzZWlLBDgmeUHWKqwOByTTnEvEH94FU=;
 b=qH4/zGBCiWibvjhYvaH8iGE9S66rfhl2CFXY9j2jv3J06N/WcVCR8q3lDDgign6cy4fuOnPPAmBjhgZDhpq4QWrkA+A4f67SZ9KhosCacqqU87DAyviOnUvhpFx+YsJmG20K4oVS41QYxioh/ZlhoalevUKU24WO3k+UlIB+h4k=
Received: from LNXP123MB1963.GBRP123.PROD.OUTLOOK.COM (20.179.128.81) by
 LNXP123MB1756.GBRP123.PROD.OUTLOOK.COM (20.176.159.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1686.18; Wed, 13 Mar 2019 09:52:01 +0000
Received: from LNXP123MB1963.GBRP123.PROD.OUTLOOK.COM
 ([fe80::9cd1:578e:30c0:f5d9]) by LNXP123MB1963.GBRP123.PROD.OUTLOOK.COM
 ([fe80::9cd1:578e:30c0:f5d9%2]) with mapi id 15.20.1709.011; Wed, 13 Mar 2019
 09:52:01 +0000
From:   Piotr Figiel <p.figiel@camlintechnologies.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "arend.vanspriel@broadcom.com" <arend.vanspriel@broadcom.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
CC:     "franky.lin@broadcom.com" <franky.lin@broadcom.com>,
        "hante.meuleman@broadcom.com" <hante.meuleman@broadcom.com>,
        "chi-hsien.lin@cypress.com" <chi-hsien.lin@cypress.com>,
        "wright.feng@cypress.com" <wright.feng@cypress.com>,
        "brcm80211-dev-list@cypress.com" <brcm80211-dev-list@cypress.com>,
        =?iso-8859-2?Q?Krzysztof_Drobi=F1ski?= 
        <k.drobinski@camlintechnologies.com>,
        Pawel Lenkow <p.lenkow@camlintechnologies.com>,
        Lech Perczak <l.perczak@camlintechnologies.com>,
        Piotr Figiel <p.figiel@camlintechnologies.com>
Subject: [PATCH] brcmfmac: fix Oops when bringing up interface during USB
 disconnect
Thread-Topic: [PATCH] brcmfmac: fix Oops when bringing up interface during USB
 disconnect
Thread-Index: AQHU2YJnyjZb+Ok88ESkcNkrkDVjFw==
Date:   Wed, 13 Mar 2019 09:52:01 +0000
Message-ID: <1552470712-3496-1-git-send-email-p.figiel@camlintechnologies.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [95.143.242.242]
x-clientproxiedby: DB6PR06CA0021.eurprd06.prod.outlook.com (2603:10a6:6:1::34)
 To LNXP123MB1963.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:d8::17)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=p.figiel@camlintechnologies.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.7.4
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bc5e433d-a95a-43e6-7ab5-08d6a7998a52
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:LNXP123MB1756;
x-ms-traffictypediagnostic: LNXP123MB1756:
x-microsoft-exchange-diagnostics: =?iso-8859-2?Q?1;LNXP123MB1756;23:P/gXvW1Q6vkvI92E1LkE6GFVe566SbBRSm/9hCF?=
 =?iso-8859-2?Q?tx+Y7mJZd51yqD0XImRLlwkLXf+I/st4MEAKtFhs3Uu5doYdgukGSOftNO?=
 =?iso-8859-2?Q?/xK4BfYF5a6IiHmf98Sa1yw1rs6D/kGSk1jZ3NlYZxXvNObHgfQ2GgU+A0?=
 =?iso-8859-2?Q?Y0gQvjq2Z43KgP/DsbwMDwoDqivvJremoVn3mvPO6O7kjrmPOeth+0Aotp?=
 =?iso-8859-2?Q?5MKi16UnKdwCeUhxYWmEZlrjqGCgL7JoydierJzXLpi8xFuTH/WLAKIynR?=
 =?iso-8859-2?Q?ap/hmhtRuyueCWZJaEcj7KakXn3TREY3L1QVyHNElRXGf897HQp4MVhpIy?=
 =?iso-8859-2?Q?b8knyfXumR0tSbswbSphwMeDHBwoCVWNGH9bGKZDN7P6jRcgCW3lZ98UE+?=
 =?iso-8859-2?Q?yb0d6KWw9cie+25kd2sOtr3OT5AVnKouf0EIAM2o/9VpPWhZsdkZZs5Fpc?=
 =?iso-8859-2?Q?oVH/mM8hdbu9NwO79+0mM2xqqC4qt3oZw/mBQ3FxtSbNdmuCIbPyOfFOaS?=
 =?iso-8859-2?Q?iB0OtaMvUXIrKhjalD5zybibxuxFZ2/Au0EH9su6CMuOVZiGWkYafB8irG?=
 =?iso-8859-2?Q?473FPxxMV9kTpWENbidSm7pXdMmwtWDR9CSIBxQlcPpwhr3Y4w+Os6bnej?=
 =?iso-8859-2?Q?CAZ9U8+9iWxMrZQ8gfbZEymNunfSBrGmee8VoHFlWT9zFw6/zePxMGviwD?=
 =?iso-8859-2?Q?qsh1ziHnypLBgQMaIXtomgM3msFci1ZKlOeEv+4iBwtbszwoRoEY3S4Lv0?=
 =?iso-8859-2?Q?AyQ05s8nBBnCX7f++uMJEgO1RM1Nr58Ag0OKeUZ1Mfe7CHK/QlzzQqfmlD?=
 =?iso-8859-2?Q?XlSg9d9NXUpL4QsWRVW71l7+qXjIRY3JXe8fGjdbeQoifek1fK/jpobAsG?=
 =?iso-8859-2?Q?unRa1T5V1sU9iB/qmpvX38SANtSDIxeEdQmN6DwMQkgtMvr2Iqd07QLHZV?=
 =?iso-8859-2?Q?48CUZSkVYDlEQ35L6KWMa3CtNmmPLeN6RxQn01MyTf6ughCGSWmYjDiI0o?=
 =?iso-8859-2?Q?vCurONunB5gNZn9cKFdo+dK+KNj1FqcA6wHkDsnN5WYBd9EMSI7j/sgw0b?=
 =?iso-8859-2?Q?q0rhizleqyKmXiDz9O9UcU40hw/g+vyIghykpVMgiz65VuRzVYJz2pZP7R?=
 =?iso-8859-2?Q?eKyFsU0kIQCnVjN+7XRr293657I+5doznojL1tIcOToMU5x55ToQILBI8x?=
 =?iso-8859-2?Q?BuJiwg0PoUeUfzh5Y784efpw75GdLcexAQbOwbREw2WvPAwewdbhAje51z?=
 =?iso-8859-2?Q?+6b2RU2MjqZuLLXlBpxssL6zUFknR+de9O9RVTv/tpYWiMSEseUvHSlXbQ?=
 =?iso-8859-2?Q?HpkMUtxf07PdJGKlHbTWykOD8m6ebzPWwBeHitiTjX2DolW5SrIepY5CMJ?=
 =?iso-8859-2?Q?nZglttz9iQvZo+DSbTBfYzbgp7yX+?=
x-microsoft-antispam-prvs: <LNXP123MB175632FE504FACA3ECD659C8E74A0@LNXP123MB1756.GBRP123.PROD.OUTLOOK.COM>
x-forefront-prvs: 09752BC779
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(396003)(376002)(346002)(39850400004)(136003)(366004)(199004)(189003)(6512007)(2906002)(2201001)(6116002)(3846002)(86362001)(4326008)(25786009)(50226002)(305945005)(476003)(71200400001)(71190400001)(486006)(68736007)(7736002)(53936002)(2616005)(107886003)(97736004)(14454004)(478600001)(2501003)(14444005)(256004)(316002)(102836004)(81166006)(66066001)(110136005)(8676002)(54906003)(81156014)(45080400002)(106356001)(5660300002)(105586002)(6436002)(6486002)(8936002)(99286004)(52116002)(6506007)(36756003)(386003)(26005)(186003)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:LNXP123MB1756;H:LNXP123MB1963.GBRP123.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: camlintechnologies.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: mMYWoJGxR2nidcil2zXZO+n7oO91e7XAeUG95tk2zV5gcTCEAX5baQ4QJFqQCMNv2bCu3X5SCxE6btVnNkLQWiiSsLBlTxBwuTjuo9c3SS/MlEoQNUFchxczJyoLdeJttwZS78iVcA6WrqPz+JG52efSQ3t4bXKjvbKlroDzT9ifLT65tS0LotJmCYs2799MX9ELG4fvnz5Pf9bQIoE5OKtvOuf18Fm4NHRVqQ2oFjTCDSFuMpv5RaA9OxJsOD8WlblU6QwK2uCv9IsSRTpKwKy/y20obm0i4QhlvzSbGqM1qGEGBTVqhyHxHG9IFObYpljTodx5iLXVKsAZuwgI7RbiR73YFioY35dAYQ1IX4DdP15+LDUPPN+fkr4BIU64QsjfIt81Q1aidIb+ox+m4H5pLXg5bCoOWuMkFmk+1d0=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: camlintechnologies.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc5e433d-a95a-43e6-7ab5-08d6a7998a52
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2019 09:52:01.4771
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fd4b1729-b18d-46d2-9ba0-2717b852b252
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LNXP123MB1756
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fix a race which leads to an Oops with NULL pointer dereference.  The
dereference is in brcmf_config_dongle() when cfg_to_ndev() attempts to get
net_device structure of interface with index 0 via if2bss mapping. This
shouldn't fail because of check for bus being ready in brcmf_netdev_open(),
but it's not synchronised with USB disconnect and there is a race: after
the check the bus can be marked down and the mapping for interface 0 may be
gone.

Solve this by modifying disconnect handling so that the removal of mapping
of ifidx to brcmf_if structure happens after netdev removal (which is
synchronous with brcmf_netdev_open() thanks to rtln being locked in
devinet_ioctl()). This assures brcmf_netdev_open() returns before the
mapping is removed during disconnect.

Unable to handle kernel NULL pointer dereference at virtual address 0000000=
8
pgd =3D bcae2612
[00000008] *pgd=3D8be73831
Internal error: Oops: 17 [#1] PREEMPT SMP ARM
Modules linked in: brcmfmac brcmutil nf_log_ipv4 nf_log_common xt_LOG xt_li=
mit
iptable_mangle xt_connmark xt_tcpudp xt_conntrack nf_conntrack nf_defrag_ip=
v6
nf_defrag_ipv4 iptable_filter ip_tables x_tables usb_f_mass_storage usb_f_r=
ndis
u_ether usb_serial_simple usbserial cdc_acm smsc95xx usbnet ci_hdrc_imx ci_=
hdrc
usbmisc_imx ulpi 8250_exar 8250_pci 8250 8250_base libcomposite configfs
udc_core [last unloaded: brcmutil]
CPU: 2 PID: 24478 Comm: ifconfig Not tainted 4.19.23-00078-ga62866d-dirty #=
115
Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
PC is at brcmf_cfg80211_up+0x94/0x29c [brcmfmac]
LR is at brcmf_cfg80211_up+0x8c/0x29c [brcmfmac]
pc : [<7f26a91c>]    lr : [<7f26a914>]    psr: a0070013
sp : eca99d28  ip : 00000000  fp : ee9c6c00
r10: 00000036  r9 : 00000000  r8 : ece4002c
r7 : edb5b800  r6 : 00000000  r5 : 80f08448  r4 : edb5b968
r3 : ffffffff  r2 : 00000000  r1 : 00000002  r0 : 00000000
Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
Control: 10c5387d  Table: 7ca0c04a  DAC: 00000051
Process ifconfig (pid: 24478, stack limit =3D 0xd9e85a0e)
Stack: (0xeca99d28 to 0xeca9a000)
9d20:                   00000000 80f873b0 0000000d 80f08448 eca99d68 50d45f=
32
9d40: 7f27de94 ece40000 80f08448 80f08448 7f27de94 ece4002c 00000000 000000=
36
9d60: ee9c6c00 7f27262c 00001002 50d45f32 ece40000 00000000 80f08448 807720=
08
9d80: 00000001 00001043 00001002 ece40000 00000000 50d45f32 ece40000 000000=
01
9da0: 80f08448 00001043 00001002 807723d0 00000000 50d45f32 80f08448 eca99e=
58
9dc0: 80f87113 50d45f32 80f08448 ece40000 ece40138 00001002 80f08448 000000=
00
9de0: 00000000 80772434 edbd5380 eca99e58 edbd5380 80f08448 ee9c6c0c 80805f=
70
9e00: 00000000 ede08e00 00008914 ece40000 00000014 ee9c6c0c 600c0013 000010=
43
9e20: 0208a8c0 ffffffff 00000000 50d45f32 eca98000 80f08448 7ee9fc38 000089=
14
9e40: 80f68e40 00000051 eca98000 00000036 00000003 80808b9c 6e616c77 000000=
30
9e60: 00000000 00000000 00001043 0208a8c0 ffffffff 00000000 80f08448 000000=
00
9e80: 00000000 816d8b20 600c0013 00000001 ede09320 801763d4 00000000 50d45f=
32
9ea0: eca98000 80f08448 7ee9fc38 50d45f32 00008914 80f08448 7ee9fc38 80f68e=
40
9ec0: ed531540 8074721c 00000800 00000001 00000000 6e616c77 00000030 000000=
00
9ee0: 00000000 00001002 0208a8c0 ffffffff 00000000 50d45f32 80f08448 7ee9fc=
38
9f00: ed531560 ec8fc900 80285a6c 80285138 edb910c0 00000000 ecd91008 ede08e=
00
9f20: 80f08448 00000000 00000000 816d8b20 600c0013 00000001 ede09320 801763=
d4
9f40: 00000000 50d45f32 00021000 edb91118 edb910c0 80f08448 01b29000 edb911=
18
9f60: eca99f7c 50d45f32 00021000 ec8fc900 00000003 ec8fc900 00008914 7ee9fc=
38
9f80: eca98000 00000036 00000003 80285a6c 00086364 7ee9fe1c 000000c3 000000=
36
9fa0: 801011c4 80101000 00086364 7ee9fe1c 00000003 00008914 7ee9fc38 000863=
64
9fc0: 00086364 7ee9fe1c 000000c3 00000036 0008630c 7ee9fe1c 7ee9fc38 000000=
03
9fe0: 000a42b8 7ee9fbd4 00019914 76e09acc 600c0010 00000003 00000000 000000=
00
[<7f26a91c>] (brcmf_cfg80211_up [brcmfmac]) from [<7f27262c>] (brcmf_netdev=
_open+0x74/0xe8 [brcmfmac])
[<7f27262c>] (brcmf_netdev_open [brcmfmac]) from [<80772008>] (__dev_open+0=
xcc/0x150)
[<80772008>] (__dev_open) from [<807723d0>] (__dev_change_flags+0x168/0x1b4=
)
[<807723d0>] (__dev_change_flags) from [<80772434>] (dev_change_flags+0x18/=
0x48)
[<80772434>] (dev_change_flags) from [<80805f70>] (devinet_ioctl+0x67c/0x79=
c)
[<80805f70>] (devinet_ioctl) from [<80808b9c>] (inet_ioctl+0x210/0x3d4)
[<80808b9c>] (inet_ioctl) from [<8074721c>] (sock_ioctl+0x350/0x524)
[<8074721c>] (sock_ioctl) from [<80285138>] (do_vfs_ioctl+0xb0/0x9b0)
[<80285138>] (do_vfs_ioctl) from [<80285a6c>] (ksys_ioctl+0x34/0x5c)
[<80285a6c>] (ksys_ioctl) from [<80101000>] (ret_fast_syscall+0x0/0x28)
Exception stack(0xeca99fa8 to 0xeca99ff0)
9fa0:                   00086364 7ee9fe1c 00000003 00008914 7ee9fc38 000863=
64
9fc0: 00086364 7ee9fe1c 000000c3 00000036 0008630c 7ee9fe1c 7ee9fc38 000000=
03
9fe0: 000a42b8 7ee9fbd4 00019914 76e09acc
Code: e5970328 eb002021 e1a02006 e3a01002 (e5909008)
---[ end trace 5cbac2333f3ac5df ]---

Signed-off-by: Piotr Figiel <p.figiel@camlintechnologies.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/driv=
ers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 00e8947..52da307 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -841,17 +841,17 @@ static void brcmf_del_if(struct brcmf_pub *drvr, s32 =
bsscfgidx,
 			 bool rtnl_locked)
 {
 	struct brcmf_if *ifp;
+	int ifidx;
=20
 	ifp =3D drvr->iflist[bsscfgidx];
-	drvr->iflist[bsscfgidx] =3D NULL;
 	if (!ifp) {
 		bphy_err(drvr, "Null interface, bsscfgidx=3D%d\n", bsscfgidx);
 		return;
 	}
 	brcmf_dbg(TRACE, "Enter, bsscfgidx=3D%d, ifidx=3D%d\n", bsscfgidx,
 		  ifp->ifidx);
-	if (drvr->if2bss[ifp->ifidx] =3D=3D bsscfgidx)
-		drvr->if2bss[ifp->ifidx] =3D BRCMF_BSSIDX_INVALID;
+	ifidx =3D ifp->ifidx;
+
 	if (ifp->ndev) {
 		if (bsscfgidx =3D=3D 0) {
 			if (ifp->ndev->netdev_ops =3D=3D &brcmf_netdev_ops_pri) {
@@ -879,6 +879,10 @@ static void brcmf_del_if(struct brcmf_pub *drvr, s32 b=
sscfgidx,
 		brcmf_p2p_ifp_removed(ifp, rtnl_locked);
 		kfree(ifp);
 	}
+
+	drvr->iflist[bsscfgidx] =3D NULL;
+	if (drvr->if2bss[ifidx] =3D=3D bsscfgidx)
+		drvr->if2bss[ifidx] =3D BRCMF_BSSIDX_INVALID;
 }
=20
 void brcmf_remove_interface(struct brcmf_if *ifp, bool rtnl_locked)
--=20
2.7.4

