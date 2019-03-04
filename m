Return-Path: <SRS0=K+dv=RH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 894CDC43381
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 15:42:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 434DE206B8
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 15:42:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=camlinlimited.onmicrosoft.com header.i=@camlinlimited.onmicrosoft.com header.b="SPNRRYsn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727150AbfCDPmy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Mar 2019 10:42:54 -0500
Received: from mail-eopbgr110064.outbound.protection.outlook.com ([40.107.11.64]:51468
        "EHLO GBR01-CWL-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726649AbfCDPmy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Mar 2019 10:42:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=camlinlimited.onmicrosoft.com; s=selector1-camlintechnologies-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KeBkBIoJ0xcRIIebnCpNXC0/r7pHkR01Ickw6aHGLcY=;
 b=SPNRRYsniCz1EUO8MwWl44Nvv/D9A3cqy2nlVcIgDpss5fyeNf53GM93ft/1VKDSVXn5awoKhojcLIVIw5bak+oz/CPl7SY+6TLuKwNlYZeZ4opJoofBkmpE/XhhEKk8OOtmNNnXBselXg5UX5aIU+atBytR1rp2JF5HSHhe8kk=
Received: from LNXP123MB2185.GBRP123.PROD.OUTLOOK.COM (20.179.129.83) by
 LNXP123MB2060.GBRP123.PROD.OUTLOOK.COM (20.179.128.207) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1665.18; Mon, 4 Mar 2019 15:42:49 +0000
Received: from LNXP123MB2185.GBRP123.PROD.OUTLOOK.COM
 ([fe80::396a:e27e:d5dd:6bf0]) by LNXP123MB2185.GBRP123.PROD.OUTLOOK.COM
 ([fe80::396a:e27e:d5dd:6bf0%4]) with mapi id 15.20.1665.019; Mon, 4 Mar 2019
 15:42:49 +0000
From:   Piotr Figiel <p.figiel@camlintechnologies.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "arend.vanspriel@broadcom.com" <arend.vanspriel@broadcom.com>,
        "franky.lin@broadcom.com" <franky.lin@broadcom.com>,
        "hante.meuleman@broadcom.com" <hante.meuleman@broadcom.com>,
        "chi-hsien.lin@cypress.com" <chi-hsien.lin@cypress.com>,
        "wright.feng@cypress.com" <wright.feng@cypress.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "brcm80211-dev-list@cypress.com" <brcm80211-dev-list@cypress.com>,
        Piotr Figiel <p.figiel@camlintechnologies.com>
Subject: [PATCH 1/2] brcmfmac: fix WARNING during USB disconnect in case of
 unempty psq
Thread-Topic: [PATCH 1/2] brcmfmac: fix WARNING during USB disconnect in case
 of unempty psq
Thread-Index: AQHU0qDr2CPRNnexZUaswBHrAuJLFg==
Date:   Mon, 4 Mar 2019 15:42:49 +0000
Message-ID: <1551714128-27412-2-git-send-email-p.figiel@camlintechnologies.com>
References: <1551714128-27412-1-git-send-email-p.figiel@camlintechnologies.com>
In-Reply-To: <1551714128-27412-1-git-send-email-p.figiel@camlintechnologies.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [95.143.242.242]
x-clientproxiedby: VI1PR08CA0217.eurprd08.prod.outlook.com
 (2603:10a6:802:15::26) To LNXP123MB2185.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:dc::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=p.figiel@camlintechnologies.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.7.4
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1d368949-1fc7-48eb-fef7-08d6a0b80e24
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:LNXP123MB2060;
x-ms-traffictypediagnostic: LNXP123MB2060:
x-microsoft-exchange-diagnostics: =?iso-8859-1?Q?1;LNXP123MB2060;23:gONTvdbws59AUMP3DhJ/mL1EA/rlICyOsZAOxLo?=
 =?iso-8859-1?Q?MhVoWbz7kmU5wu+lpugjDJtmH5b634/tdEOPpQ+7koIR0dm9pOtLuA3wdK?=
 =?iso-8859-1?Q?wTTOkwF6ouB2R79EN/JtyBczmYdRqWJQ/HkjSaSOv7m52udiYr5gvDWkVg?=
 =?iso-8859-1?Q?eZ4Crdoo1RM42LEMRAtuNOtRjFAZRalF0vSM2lvvhsHdnTZzcTToVlJw3W?=
 =?iso-8859-1?Q?hdPMpatmm8LS3NWa5oyLPD/WHgs14YvyISPCawS39Iwsh8efGsGeMuX0uI?=
 =?iso-8859-1?Q?tV6ljQUqaVa0d1tF7uwO/5WsNeFmds9R4XvdVSOEf/tx9L5QQBPqVh9lZ+?=
 =?iso-8859-1?Q?N26sj79TY/J7WtCMzJ20oOY3wYhINOJg7ffuWq/480KTBu7LBYtvNgVTP6?=
 =?iso-8859-1?Q?jMJhxxuilAYLDbGvlDwcgYJ8npvk3FW94TcHjiAcg51BDauGZHv1X1LyKS?=
 =?iso-8859-1?Q?ItjrnDDJJpGtMRur52e+KgXnd3MrvGSIg7LawNFTnmdNgZT0KTmS4VS3jZ?=
 =?iso-8859-1?Q?k+Th5qH0vPCkEOam1pgJdMrZ/aZWFWSVJT/mQgNXvwXjiCPY2ZDYInXx0N?=
 =?iso-8859-1?Q?q4+ldmJRvSb1Dg6KJypns6yPd6ITdi/XnLEa0uuvfvFAaSkRhtIGy0qKSu?=
 =?iso-8859-1?Q?UqoT12pUYlPlwYYKnq+C8+7zwjhELgrPqqGRsWrIahCqRZYbgQLixLzbOs?=
 =?iso-8859-1?Q?ZWOXOf9/aY6C4vfmC0EUavMshhiQRZQVfklvcJm+3J7JPzMNSAJxjmqkX6?=
 =?iso-8859-1?Q?Onc7p9lF5eI4TSlnDnFSoekPrpYXJRkvr0qj1dBbJHbLjjmPV43odfB9pf?=
 =?iso-8859-1?Q?cfTeqXVOPc9AkH0jLCQAqgBQAU9epwDaB4qgZSYU2Z26IYGFyON18k01fI?=
 =?iso-8859-1?Q?4kqDq2KpFUl+tvIGnQIYMZgyVdTdyQ+nLF77ZJginM2Vi+NlwgDGJgmGcD?=
 =?iso-8859-1?Q?L04P2T/TTsbHqMEh+Jj8YI0JpvJzoA867utsaFxL5c1DqRE6uCCjMH5i+N?=
 =?iso-8859-1?Q?syXSD2Z/Opfa1DcHFmgsc4jjkvD79cSkyJ7wHuFuRHe/dDTvMi6MyshlFH?=
 =?iso-8859-1?Q?Pl7ijauIjt4SHdDx5IF87nqaqBtWY4tHvHPJYBvAdJnF7xBlOUMeLvrU3N?=
 =?iso-8859-1?Q?4bQIGl7A7yPlayCCRVLY3f15pQdNMn7ZrWE5Z3ns7Ve8TIkv1FOw3+mQRb?=
 =?iso-8859-1?Q?NvJzo6yMYXgf3dGpdRUtDjAJ4V44tL7icLMOoTrEnxSgCz97DCodkwLcu1?=
 =?iso-8859-1?Q?Xhgmqsy33+qcAfS6OOys+vSmwWntaNpvl6rrxxT/kNXFYJBZLLx13kjKl/?=
 =?iso-8859-1?Q?oV9f3XM7yP0W3Rffw89kjCqmwX/PlvVSiNsBGmBmCJMH0lFP8FxtVjPXbl?=
 =?iso-8859-1?Q?RwFvCIrwEwCK4q6aX4AXBvOIY0rae?=
x-microsoft-antispam-prvs: <LNXP123MB20601CF8AB9039E0AC4BC640E7710@LNXP123MB2060.GBRP123.PROD.OUTLOOK.COM>
x-forefront-prvs: 09669DB681
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39850400004)(136003)(396003)(366004)(376002)(51234002)(189003)(199004)(478600001)(71190400001)(71200400001)(8936002)(107886003)(50226002)(54906003)(106356001)(105586002)(86362001)(14444005)(256004)(6486002)(81166006)(81156014)(5660300002)(4326008)(6436002)(53936002)(316002)(8676002)(36756003)(6512007)(14454004)(5640700003)(66066001)(97736004)(76176011)(99286004)(6916009)(3846002)(68736007)(446003)(11346002)(7736002)(25786009)(102836004)(52116002)(305945005)(2616005)(386003)(6506007)(45080400002)(486006)(2906002)(2501003)(476003)(6116002)(26005)(2351001)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:LNXP123MB2060;H:LNXP123MB2185.GBRP123.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: camlintechnologies.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: JguDLbctaTnj7d5ehE1dJIRN3ZEBEmD4zIkFJi5m08Dcow5p4N1ydxvOtc7cJNTJrsq5GKfvw8b2qhTbAHfcTmaPYbOLEA49KEQ7Oz8vSkSh/RZnzRUJriEpfMaxhn79Ee/52f7IvntwWAKMOuAeG1gZlASdAnnIxmQ94Fi/jKJ84QSoqhWaAAdSyP1ZbX/uI2+OXwiJVcwhMLa4kHPVDpARuBAf37nAhAXgFEQ9FskMjWQkIWu06BYSdl+C/JOG77B30yycXD0bh/3+S0JYWKiwOCfNzzEu9YNZZ+KCBtIMEPG0ndwQC+Tvq1bjPGdswzM38F5Rbm1alzY8MvhKTS58zUGWckl5L3DjMiMGajU+e+D5RoyJy5rygWwjcGkgfkm/4febMvPUKORu2dgueNuoFWGoDQkHxl4RKFYVuSA=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: camlintechnologies.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d368949-1fc7-48eb-fef7-08d6a0b80e24
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2019 15:42:49.3727
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fd4b1729-b18d-46d2-9ba0-2717b852b252
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LNXP123MB2060
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

brcmu_pkt_buf_free_skb emits WARNING when attempting to free a sk_buff
which is part of any queue. After USB disconnect this may have happened
when brcmf_fws_hanger_cleanup() is called as per-interface psq was never
cleaned when removing the interface.
Change brcmf_fws_macdesc_cleanup() in a way that it removes the
corresponding packets from hanger table (to avoid double-free when
brcmf_fws_hanger_cleanup() is called) and add a call to clean-up the
interface specific packet queue.

Below is a WARNING during USB disconnect with Raspberry Pi WiFi dongle
running in AP mode. This was reproducible when the interface was
transmitting during the disconnect and is fixed with this commit.

------------[ cut here ]------------
WARNING: CPU: 0 PID: 1171 at drivers/net/wireless/broadcom/brcm80211/brcmut=
il/utils.c:49 brcmu_pkt_buf_free_skb+0x3c/0x40
Modules linked in: nf_log_ipv4 nf_log_common xt_LOG xt_limit iptable_mangle=
 xt_connmark xt_tcpudp xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_i=
pv4 iptable_filter ip_tables x_tables usb_f_mass_storage usb_f_rndis u_ethe=
r cdc_acm smsc95xx usbnet ci_hdrc_imx ci_hdrc ulpi usbmisc_imx 8250_exar 82=
50_pci 8250 8250_base libcomposite configfs udc_core
CPU: 0 PID: 1171 Comm: kworker/0:0 Not tainted 4.19.23-00075-gde33ed8 #99
Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
Workqueue: usb_hub_wq hub_event
[<8010ff84>] (unwind_backtrace) from [<8010bb64>] (show_stack+0x10/0x14)
[<8010bb64>] (show_stack) from [<80840278>] (dump_stack+0x88/0x9c)
[<80840278>] (dump_stack) from [<8011f5ec>] (__warn+0xfc/0x114)
[<8011f5ec>] (__warn) from [<8011f71c>] (warn_slowpath_null+0x40/0x48)
[<8011f71c>] (warn_slowpath_null) from [<805a476c>] (brcmu_pkt_buf_free_skb=
+0x3c/0x40)
[<805a476c>] (brcmu_pkt_buf_free_skb) from [<805bb6c4>] (brcmf_fws_cleanup+=
0x1e4/0x22c)
[<805bb6c4>] (brcmf_fws_cleanup) from [<805bc854>] (brcmf_fws_del_interface=
+0x58/0x68)
[<805bc854>] (brcmf_fws_del_interface) from [<805b66ac>] (brcmf_remove_inte=
rface+0x40/0x150)
[<805b66ac>] (brcmf_remove_interface) from [<805b6870>] (brcmf_detach+0x6c/=
0xb0)
[<805b6870>] (brcmf_detach) from [<805bdbb8>] (brcmf_usb_disconnect+0x30/0x=
4c)
[<805bdbb8>] (brcmf_usb_disconnect) from [<805e5d64>] (usb_unbind_interface=
+0x5c/0x1e0)
[<805e5d64>] (usb_unbind_interface) from [<804aab10>] (device_release_drive=
r_internal+0x154/0x1ec)
[<804aab10>] (device_release_driver_internal) from [<804a97f4>] (bus_remove=
_device+0xcc/0xf8)
[<804a97f4>] (bus_remove_device) from [<804a6fc0>] (device_del+0x118/0x308)
[<804a6fc0>] (device_del) from [<805e488c>] (usb_disable_device+0xa0/0x1c8)
[<805e488c>] (usb_disable_device) from [<805dcf98>] (usb_disconnect+0x70/0x=
1d8)
[<805dcf98>] (usb_disconnect) from [<805ddd84>] (hub_event+0x464/0xf50)
[<805ddd84>] (hub_event) from [<80135a70>] (process_one_work+0x138/0x3f8)
[<80135a70>] (process_one_work) from [<80135d5c>] (worker_thread+0x2c/0x554=
)
[<80135d5c>] (worker_thread) from [<8013b1a0>] (kthread+0x124/0x154)
[<8013b1a0>] (kthread) from [<801010e8>] (ret_from_fork+0x14/0x2c)
Exception stack(0xecf8dfb0 to 0xecf8dff8)
dfa0:                                     00000000 00000000 00000000 000000=
00
dfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 000000=
00
dfe0: 00000000 00000000 00000000 00000000 00000013 00000000
---[ end trace 38d234018e9e2a90 ]---
------------[ cut here ]------------

Signed-off-by: Piotr Figiel <p.figiel@camlintechnologies.com>
---
 .../broadcom/brcm80211/brcmfmac/fwsignal.c         | 42 ++++++++++++------=
----
 1 file changed, 24 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c b/=
drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
index abeb305..d48b8b2 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
@@ -580,24 +580,6 @@ static bool brcmf_fws_ifidx_match(struct sk_buff *skb,=
 void *arg)
 	return ifidx =3D=3D *(int *)arg;
 }
=20
-static void brcmf_fws_psq_flush(struct brcmf_fws_info *fws, struct pktq *q=
,
-				int ifidx)
-{
-	bool (*matchfn)(struct sk_buff *, void *) =3D NULL;
-	struct sk_buff *skb;
-	int prec;
-
-	if (ifidx !=3D -1)
-		matchfn =3D brcmf_fws_ifidx_match;
-	for (prec =3D 0; prec < q->num_prec; prec++) {
-		skb =3D brcmu_pktq_pdeq_match(q, prec, matchfn, &ifidx);
-		while (skb) {
-			brcmu_pkt_buf_free_skb(skb);
-			skb =3D brcmu_pktq_pdeq_match(q, prec, matchfn, &ifidx);
-		}
-	}
-}
-
 static void brcmf_fws_hanger_init(struct brcmf_fws_hanger *hanger)
 {
 	int i;
@@ -669,6 +651,28 @@ static inline int brcmf_fws_hanger_poppkt(struct brcmf=
_fws_hanger *h,
 	return 0;
 }
=20
+static void brcmf_fws_psq_flush(struct brcmf_fws_info *fws, struct pktq *q=
,
+				int ifidx)
+{
+	bool (*matchfn)(struct sk_buff *, void *) =3D NULL;
+	struct sk_buff *skb;
+	int prec;
+	u32 hslot;
+
+	if (ifidx !=3D -1)
+		matchfn =3D brcmf_fws_ifidx_match;
+	for (prec =3D 0; prec < q->num_prec; prec++) {
+		skb =3D brcmu_pktq_pdeq_match(q, prec, matchfn, &ifidx);
+		while (skb) {
+			hslot =3D brcmf_skb_htod_tag_get_field(skb, HSLOT);
+			brcmf_fws_hanger_poppkt(&fws->hanger, hslot, &skb,
+						true);
+			brcmu_pkt_buf_free_skb(skb);
+			skb =3D brcmu_pktq_pdeq_match(q, prec, matchfn, &ifidx);
+		}
+	}
+}
+
 static int brcmf_fws_hanger_mark_suppressed(struct brcmf_fws_hanger *h,
 					    u32 slot_id)
 {
@@ -2200,6 +2204,8 @@ void brcmf_fws_del_interface(struct brcmf_if *ifp)
 	brcmf_fws_lock(fws);
 	ifp->fws_desc =3D NULL;
 	brcmf_dbg(TRACE, "deleting %s\n", entry->name);
+	brcmf_fws_macdesc_cleanup(fws, &fws->desc.iface[ifp->ifidx],
+				  ifp->ifidx);
 	brcmf_fws_macdesc_deinit(entry);
 	brcmf_fws_cleanup(fws, ifp->ifidx);
 	brcmf_fws_unlock(fws);
--=20
2.7.4

