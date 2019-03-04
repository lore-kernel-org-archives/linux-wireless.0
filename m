Return-Path: <SRS0=K+dv=RH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69D89C43381
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 15:42:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2449C206B8
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 15:42:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=camlinlimited.onmicrosoft.com header.i=@camlinlimited.onmicrosoft.com header.b="rHlNn3JC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727153AbfCDPm5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Mar 2019 10:42:57 -0500
Received: from mail-eopbgr110064.outbound.protection.outlook.com ([40.107.11.64]:51468
        "EHLO GBR01-CWL-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727131AbfCDPm5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Mar 2019 10:42:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=camlinlimited.onmicrosoft.com; s=selector1-camlintechnologies-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RQQlUjm39eDCenOuJsgfaRC2NvISi93yhNW1N2tMX6M=;
 b=rHlNn3JCFFNcYzkt6quVyucFVhaKAOQH6PX3MvtAxxneoOpHmLMyrx8Iy69/lKujdNiK4MnNJXWDDZFJlULZ5F1/VSH2xxMNeMmeM+rURUcYrnHZ2ZTfQUCRke2BcfRmwgSFeT2VKNuIZk9GIlUVoHf4qifCI1eesNlC8JIu8h0=
Received: from LNXP123MB2185.GBRP123.PROD.OUTLOOK.COM (20.179.129.83) by
 LNXP123MB2060.GBRP123.PROD.OUTLOOK.COM (20.179.128.207) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1665.18; Mon, 4 Mar 2019 15:42:52 +0000
Received: from LNXP123MB2185.GBRP123.PROD.OUTLOOK.COM
 ([fe80::396a:e27e:d5dd:6bf0]) by LNXP123MB2185.GBRP123.PROD.OUTLOOK.COM
 ([fe80::396a:e27e:d5dd:6bf0%4]) with mapi id 15.20.1665.019; Mon, 4 Mar 2019
 15:42:52 +0000
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
Subject: [PATCH 2/2] brcmfmac: fix NULL pointer derefence during USB
 disconnect
Thread-Topic: [PATCH 2/2] brcmfmac: fix NULL pointer derefence during USB
 disconnect
Thread-Index: AQHU0qDtaqcUu08ooEm5bJXHqZNFxg==
Date:   Mon, 4 Mar 2019 15:42:52 +0000
Message-ID: <1551714128-27412-3-git-send-email-p.figiel@camlintechnologies.com>
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
x-ms-office365-filtering-correlation-id: 353c6456-6f82-4502-003d-08d6a0b80fdc
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:LNXP123MB2060;
x-ms-traffictypediagnostic: LNXP123MB2060:
x-microsoft-exchange-diagnostics: =?iso-8859-1?Q?1;LNXP123MB2060;23:/DxkLzxQZNEJX4b0cy7gu2Ge7m8o+3vTv1SKU2/?=
 =?iso-8859-1?Q?Uj0X6jG8yQzj3JouUgfwJC+e+ZRHcPLJVwLT8IFvRK7fI0UpVd7NS4AN/h?=
 =?iso-8859-1?Q?/VaDXQ3ahyqW0vlk+C7Rz82Bf3lergq4S+zLj/xV+hKYyrO7+rxz8e9vbG?=
 =?iso-8859-1?Q?7Fte7/2kZNEY2jW/+VqMSS/a+3k3admTvmEkiI2MRu7CSiXzviEcpromCq?=
 =?iso-8859-1?Q?G2WSAFFlz9q4LJdrLk9eDGcAqq1mMtubw7+B/KK2cf7YJpMLPXLQL1jMpa?=
 =?iso-8859-1?Q?b3m/3ZPwpjj/DizAXM+l9TJ6MCyrNoRFok8BZJDtEbPcHoX6wDTmErdvSK?=
 =?iso-8859-1?Q?w4RqmYV/a2iCJQO4ZPs80hbXyLrgJe7mj4/rTZg/kiExSIyLrHN5VMNQYa?=
 =?iso-8859-1?Q?reX7BEiT+oPu01DpaWm7uWfSJFC7d6Yg8DV2beayyhs9xuO9PaQjQZIeKO?=
 =?iso-8859-1?Q?YcyJEWywqxpw2SQpOaLuEvRyzw5GD7My0cOwdpvAi9Zncb6n0Az5nKGaJb?=
 =?iso-8859-1?Q?K5GKS9WCKOnEcPTDHsa7GMOF+9cQRFINeZeyHWDVHkMTJrNRNbgXKuKaGp?=
 =?iso-8859-1?Q?m2IR8A6jSkUm1cUaiWPrncW/6Cm3wtPDrfjBHqRrVBNefWk8O0wODAU/Sx?=
 =?iso-8859-1?Q?mUZNmY+V+v5apBwKNcued1wtdjWKqyTUeSmeXOQoCro1dnmnKPeiqDreIe?=
 =?iso-8859-1?Q?EGJjMGNCEA4TiA/mA9WoiQzvq1GlLSrT7OJXnOgOAOLSu2oP/JLvSDYHqn?=
 =?iso-8859-1?Q?lc7GAepcuJUQtfJ/cV0fRKm0DDLFfuTHC+tiLSZMXNUt5SkMJRqMNXKl6N?=
 =?iso-8859-1?Q?W4Qmwd3ZcAuuOf0TxmSNk/xucnRnqphxo0dOEbO+feFqFNUIJDta5f4gw5?=
 =?iso-8859-1?Q?1v3PRejow5cTPjETZrwEwcY9tDAwWWxpRohcf4HPCbZF3x+CrHvylKruV3?=
 =?iso-8859-1?Q?FpiniK5QZpiENTH5m306iL9AToNecBk8lK9JoCLfVRE8vZkzV1h0BMDM1M?=
 =?iso-8859-1?Q?a0jxTfe+ptK3wqFQ0uiP5HuOD8UknDevP7pbQEyIDdwdnsw6sHhijUhHRk?=
 =?iso-8859-1?Q?kaydHhks+HNQxOHRKmmObakVfEnaCNGmszJkuMY81Y3DgyDsh3Lu85I5h7?=
 =?iso-8859-1?Q?5wxZfz2JstUz4Sno5lj53KLXs6aVkt0OvuWQ9dPN6Y8qjYFIF7p9Gza40B?=
 =?iso-8859-1?Q?5CJX9/wjnFnR1cFu8Mkjs+lf9R2O+gV0h09w7izGGw3ybaTd5k0qefS++f?=
 =?iso-8859-1?Q?P7tnOVWY1qR+PHETRAticZ1XGH3T6B6dsRLoUZxTFc1zJxe3Z1Ze0Wolnj?=
 =?iso-8859-1?Q?nB9qIFfY9vEHd7s9d7JZh+KcgiNNb5nkfbxk19x0qsVuvxRMfey0IkmP0Y?=
 =?iso-8859-1?Q?GWUbbjPxMZDuaxvfmYdcMUZCSaBneADE5KYdRi9Y8Z7XwsKxpSA=3D=3D?=
x-microsoft-antispam-prvs: <LNXP123MB206074C5B19F4134AF74CE05E7710@LNXP123MB2060.GBRP123.PROD.OUTLOOK.COM>
x-forefront-prvs: 09669DB681
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39850400004)(136003)(396003)(366004)(376002)(51234002)(189003)(199004)(478600001)(71190400001)(71200400001)(8936002)(107886003)(50226002)(54906003)(106356001)(105586002)(86362001)(5024004)(14444005)(256004)(6486002)(81166006)(81156014)(5660300002)(4326008)(6436002)(53936002)(316002)(8676002)(36756003)(6512007)(14454004)(5640700003)(66066001)(97736004)(76176011)(99286004)(6916009)(3846002)(68736007)(446003)(11346002)(7736002)(25786009)(102836004)(52116002)(305945005)(2616005)(386003)(6506007)(45080400002)(486006)(2906002)(2501003)(476003)(6116002)(26005)(2351001)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:LNXP123MB2060;H:LNXP123MB2185.GBRP123.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: camlintechnologies.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9jnT1AMHv3YjyJ64pBHNJPMci+EMQvC1jaJHPbIxoHRqKGjcwwwxkMyHJPyx1Y0qY7XgQv8dNPHyKcSRISiad/POiG6lNDGaCo1T1IFIJ8R9OK93xJ8r7+q13+7DSHMRvPg122jd+HfVoeVVA0zmBdB66QKH/PCeeCVcZM0dRAH2GrFTaLi1kSUFdyEIrLgv3UscHq8DKj4MlpZHdcvSJt7aBxbCopc2avirFt1AHRoL5UYa1sEOxjFBcC4mxkvVYKiFHQk+QEy/TNAWY85F/HRicyu8kGaHFkXLC33P0AaVgcEfU5X5yK4zi/8UnM8Ug/8F0PdksHxyRHuUJQsXaLCPo9URijrzznly4bY+R2wbcS1t+85k13kIfKPnGWgdv1zPt86B/+a3A1lOseThP/kyDiUSeaFV+/DS8RytWRc=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: camlintechnologies.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 353c6456-6f82-4502-003d-08d6a0b80fdc
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2019 15:42:52.3249
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fd4b1729-b18d-46d2-9ba0-2717b852b252
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LNXP123MB2060
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In case USB disconnect happens at the moment transmitting workqueue is in
progress the underlying interface may be gone causing a NULL pointer
dereference. Add synchronization of the workqueue destruction with the
detach implementation in core so that the transmitting workqueue is stopped
during detach before the interfaces are removed.

Fix following Oops:

Unable to handle kernel NULL pointer dereference at virtual address 0000000=
8
pgd =3D 9e6a802d
[00000008] *pgd=3D00000000
Internal error: Oops: 5 [#1] PREEMPT SMP ARM
Modules linked in: nf_log_ipv4 nf_log_common xt_LOG xt_limit iptable_mangle
xt_connmark xt_tcpudp xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ip=
v4
iptable_filter ip_tables x_tables usb_f_mass_storage usb_f_rndis u_ether
usb_serial_simple usbserial cdc_acm brcmfmac brcmutil smsc95xx usbnet
ci_hdrc_imx ci_hdrc ulpi usbmisc_imx 8250_exar 8250_pci 8250 8250_base
libcomposite configfs udc_core
CPU: 0 PID: 7 Comm: kworker/u8:0 Not tainted 4.19.23-00076-g03740aa-dirty #=
102
Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
Workqueue: brcmf_fws_wq brcmf_fws_dequeue_worker [brcmfmac]
PC is at brcmf_txfinalize+0x34/0x90 [brcmfmac]
LR is at brcmf_fws_dequeue_worker+0x218/0x33c [brcmfmac]
pc : [<7f0dee64>]    lr : [<7f0e4140>]    psr: 60010093
sp : ee8abef0  ip : 00000000  fp : edf38000
r10: ffffffed  r9 : edf38970  r8 : edf38004
r7 : edf3e970  r6 : 00000000  r5 : ede69000  r4 : 00000000
r3 : 00000a97  r2 : 00000000  r1 : 0000888e  r0 : ede69000
Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment none
Control: 10c5387d  Table: 7d03c04a  DAC: 00000051
Process kworker/u8:0 (pid: 7, stack limit =3D 0x24ec3e04)
Stack: (0xee8abef0 to 0xee8ac000)
bee0:                                     ede69000 00000000 ed56c3e0 7f0e41=
40
bf00: 00000001 00000000 edf38004 edf3e99c ed56c3e0 80d03d00 edfea43a edf3e9=
70
bf20: ee809880 ee804200 ee971100 00000000 edf3e974 00000000 ee804200 80135a=
70
bf40: 80d03d00 ee804218 ee809880 ee809894 ee804200 80d03d00 ee804218 ee8aa0=
00
bf60: 00000088 80135d5c 00000000 ee829f00 ee829dc0 00000000 ee809880 80135d=
30
bf80: ee829f1c ee873eac 00000000 8013b1a0 ee829dc0 8013b07c 00000000 000000=
00
bfa0: 00000000 00000000 00000000 801010e8 00000000 00000000 00000000 000000=
00
bfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 000000=
00
bfe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 000000=
00
[<7f0dee64>] (brcmf_txfinalize [brcmfmac]) from [<7f0e4140>] (brcmf_fws_deq=
ueue_worker+0x218/0x33c [brcmfmac])
[<7f0e4140>] (brcmf_fws_dequeue_worker [brcmfmac]) from [<80135a70>] (proce=
ss_one_work+0x138/0x3f8)
[<80135a70>] (process_one_work) from [<80135d5c>] (worker_thread+0x2c/0x554=
)
[<80135d5c>] (worker_thread) from [<8013b1a0>] (kthread+0x124/0x154)
[<8013b1a0>] (kthread) from [<801010e8>] (ret_from_fork+0x14/0x2c)
Exception stack(0xee8abfb0 to 0xee8abff8)
bfa0:                                     00000000 00000000 00000000 000000=
00
bfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 000000=
00
bfe0: 00000000 00000000 00000000 00000000 00000013 00000000
Code: e1530001 0a000007 e3560000 e1a00005 (05942008)
---[ end trace 079239dd31c86e90 ]---

Signed-off-by: Piotr Figiel <p.figiel@camlintechnologies.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c  | 11 +++++++++--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.h  |  6 ++++--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c  |  4 +++-
 .../net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c  | 16 ++++++++++++=
----
 .../net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.h  |  3 ++-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.c | 10 ++++++++--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h |  3 ++-
 7 files changed, 40 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c b/driv=
ers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
index 73d3c1a..98b1687 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
@@ -490,11 +490,18 @@ int brcmf_proto_bcdc_attach(struct brcmf_pub *drvr)
 	return -ENOMEM;
 }
=20
-void brcmf_proto_bcdc_detach(struct brcmf_pub *drvr)
+void brcmf_proto_bcdc_detach_pre_delif(struct brcmf_pub *drvr)
+{
+	struct brcmf_bcdc *bcdc =3D drvr->proto->pd;
+
+	brcmf_fws_detach_pre_delif(bcdc->fws);
+}
+
+void brcmf_proto_bcdc_detach_post_delif(struct brcmf_pub *drvr)
 {
 	struct brcmf_bcdc *bcdc =3D drvr->proto->pd;
=20
 	drvr->proto->pd =3D NULL;
-	brcmf_fws_detach(bcdc->fws);
+	brcmf_fws_detach_post_delif(bcdc->fws);
 	kfree(bcdc);
 }
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.h b/driv=
ers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.h
index 3b0e9ef..4bc5224 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.h
@@ -18,14 +18,16 @@
=20
 #ifdef CONFIG_BRCMFMAC_PROTO_BCDC
 int brcmf_proto_bcdc_attach(struct brcmf_pub *drvr);
-void brcmf_proto_bcdc_detach(struct brcmf_pub *drvr);
+void brcmf_proto_bcdc_detach_pre_delif(struct brcmf_pub *drvr);
+void brcmf_proto_bcdc_detach_post_delif(struct brcmf_pub *drvr);
 void brcmf_proto_bcdc_txflowblock(struct device *dev, bool state);
 void brcmf_proto_bcdc_txcomplete(struct device *dev, struct sk_buff *txp,
 				 bool success);
 struct brcmf_fws_info *drvr_to_fws(struct brcmf_pub *drvr);
 #else
 static inline int brcmf_proto_bcdc_attach(struct brcmf_pub *drvr) { return=
 0; }
-static inline void brcmf_proto_bcdc_detach(struct brcmf_pub *drvr) {}
+static void brcmf_proto_bcdc_detach_pre_delif(struct brcmf_pub *drvr) {};
+static inline void brcmf_proto_bcdc_detach_post_delif(struct brcmf_pub *dr=
vr) {}
 #endif
=20
 #endif /* BRCMFMAC_BCDC_H */
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/driv=
ers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 4fbe879..00e8947 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -1299,6 +1299,8 @@ void brcmf_detach(struct device *dev)
=20
 	brcmf_bus_change_state(bus_if, BRCMF_BUS_DOWN);
=20
+	brcmf_proto_detach_pre_delif(drvr);
+
 	/* make sure primary interface removed last */
 	for (i =3D BRCMF_MAX_IFS-1; i > -1; i--)
 		brcmf_remove_interface(drvr->iflist[i], false);
@@ -1308,7 +1310,7 @@ void brcmf_detach(struct device *dev)
=20
 	brcmf_bus_stop(drvr->bus_if);
=20
-	brcmf_proto_detach(drvr);
+	brcmf_proto_detach_post_delif(drvr);
=20
 	bus_if->drvr =3D NULL;
 	wiphy_free(drvr->wiphy);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c b/=
drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
index d48b8b2..c22c49a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
@@ -2443,17 +2443,25 @@ struct brcmf_fws_info *brcmf_fws_attach(struct brcm=
f_pub *drvr)
 	return fws;
=20
 fail:
-	brcmf_fws_detach(fws);
+	brcmf_fws_detach_pre_delif(fws);
+	brcmf_fws_detach_post_delif(fws);
 	return ERR_PTR(rc);
 }
=20
-void brcmf_fws_detach(struct brcmf_fws_info *fws)
+void brcmf_fws_detach_pre_delif(struct brcmf_fws_info *fws)
 {
 	if (!fws)
 		return;
-
-	if (fws->fws_wq)
+	if (fws->fws_wq) {
 		destroy_workqueue(fws->fws_wq);
+		fws->fws_wq =3D NULL;
+	}
+}
+
+void brcmf_fws_detach_post_delif(struct brcmf_fws_info *fws)
+{
+	if (!fws)
+		return;
=20
 	/* cleanup */
 	brcmf_fws_lock(fws);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.h b/=
drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.h
index 4e68357..749c06d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.h
@@ -19,7 +19,8 @@
 #define FWSIGNAL_H_
=20
 struct brcmf_fws_info *brcmf_fws_attach(struct brcmf_pub *drvr);
-void brcmf_fws_detach(struct brcmf_fws_info *fws);
+void brcmf_fws_detach_pre_delif(struct brcmf_fws_info *fws);
+void brcmf_fws_detach_post_delif(struct brcmf_fws_info *fws);
 void brcmf_fws_debugfs_create(struct brcmf_pub *drvr);
 bool brcmf_fws_queue_skbs(struct brcmf_fws_info *fws);
 bool brcmf_fws_fc_active(struct brcmf_fws_info *fws);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.c b/dri=
vers/net/wireless/broadcom/brcm80211/brcmfmac/proto.c
index 024c643..c7964cc 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.c
@@ -67,16 +67,22 @@ int brcmf_proto_attach(struct brcmf_pub *drvr)
 	return -ENOMEM;
 }
=20
-void brcmf_proto_detach(struct brcmf_pub *drvr)
+void brcmf_proto_detach_post_delif(struct brcmf_pub *drvr)
 {
 	brcmf_dbg(TRACE, "Enter\n");
=20
 	if (drvr->proto) {
 		if (drvr->bus_if->proto_type =3D=3D BRCMF_PROTO_BCDC)
-			brcmf_proto_bcdc_detach(drvr);
+			brcmf_proto_bcdc_detach_post_delif(drvr);
 		else if (drvr->bus_if->proto_type =3D=3D BRCMF_PROTO_MSGBUF)
 			brcmf_proto_msgbuf_detach(drvr);
 		kfree(drvr->proto);
 		drvr->proto =3D NULL;
 	}
 }
+
+void brcmf_proto_detach_pre_delif(struct brcmf_pub *drvr)
+{
+	if (drvr->proto && drvr->bus_if->proto_type =3D=3D BRCMF_PROTO_BCDC)
+		brcmf_proto_bcdc_detach_pre_delif(drvr);
+}
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h b/dri=
vers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h
index d3c3b9a..72355ae 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h
@@ -54,7 +54,8 @@ struct brcmf_proto {
=20
=20
 int brcmf_proto_attach(struct brcmf_pub *drvr);
-void brcmf_proto_detach(struct brcmf_pub *drvr);
+void brcmf_proto_detach_pre_delif(struct brcmf_pub *drvr);
+void brcmf_proto_detach_post_delif(struct brcmf_pub *drvr);
=20
 static inline int brcmf_proto_hdrpull(struct brcmf_pub *drvr, bool do_fws,
 				      struct sk_buff *skb,
--=20
2.7.4

