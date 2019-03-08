Return-Path: <SRS0=wltO=RL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEBF4C43381
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 15:25:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94DE520868
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 15:25:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=camlinlimited.onmicrosoft.com header.i=@camlinlimited.onmicrosoft.com header.b="jfdos3D9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbfCHPZt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Mar 2019 10:25:49 -0500
Received: from mail-eopbgr100066.outbound.protection.outlook.com ([40.107.10.66]:11645
        "EHLO GBR01-LO2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726424AbfCHPZt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Mar 2019 10:25:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=camlinlimited.onmicrosoft.com; s=selector1-camlintechnologies-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L8uXgU1/4In7BiyADkKVZAoGe1wiiQHWXMWbjJDSDWI=;
 b=jfdos3D9sEXkxxC2EVRR4x/GxcGLro51kYZdvOJTdXKnbLnJmew5eVGo2ZFZiNKOxgc027lJHZbRpCffPLh9KJ6Ah7nTGpLCxMwqLmFAzMaP1zofpzF74sD3yNE2zO+F68/ekSeX/adVYmwm31hx1yNOid1CKSMIhOudlHvfXlk=
Received: from LNXP123MB2185.GBRP123.PROD.OUTLOOK.COM (20.179.129.83) by
 LNXP123MB2106.GBRP123.PROD.OUTLOOK.COM (20.179.129.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1686.18; Fri, 8 Mar 2019 15:25:07 +0000
Received: from LNXP123MB2185.GBRP123.PROD.OUTLOOK.COM
 ([fe80::396a:e27e:d5dd:6bf0]) by LNXP123MB2185.GBRP123.PROD.OUTLOOK.COM
 ([fe80::396a:e27e:d5dd:6bf0%5]) with mapi id 15.20.1686.018; Fri, 8 Mar 2019
 15:25:07 +0000
From:   Piotr Figiel <p.figiel@camlintechnologies.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "arend.vanspriel@broadcom.com" <arend.vanspriel@broadcom.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
CC:     "franky.lin@broadcom.com" <franky.lin@broadcom.com>,
        "hante.meuleman@broadcom.com" <hante.meuleman@broadcom.com>,
        "chi-hsien.lin@cypress.com" <chi-hsien.lin@cypress.com>,
        "wright.feng@cypress.com" <wright.feng@cypress.com>,
        "brcm80211-dev-list@cypress.com" <brcm80211-dev-list@cypress.com>,
        Pawel Lenkow <p.lenkow@camlintechnologies.com>,
        Lech Perczak <l.perczak@camlintechnologies.com>,
        =?iso-8859-2?Q?Krzysztof_Drobi=F1ski?= 
        <k.drobinski@camlintechnologies.com>,
        Piotr Figiel <p.figiel@camlintechnologies.com>
Subject: [PATCH 2/3] brcmfmac: remove pending parameter from brcmf_usb_free_q
Thread-Topic: [PATCH 2/3] brcmfmac: remove pending parameter from
 brcmf_usb_free_q
Thread-Index: AQHU1cMcob53qBcu4EepzJ+soxNvRA==
Date:   Fri, 8 Mar 2019 15:25:06 +0000
Message-ID: <1552058658-23250-3-git-send-email-p.figiel@camlintechnologies.com>
References: <1552058658-23250-1-git-send-email-p.figiel@camlintechnologies.com>
In-Reply-To: <1552058658-23250-1-git-send-email-p.figiel@camlintechnologies.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [95.143.242.242]
x-clientproxiedby: DB6PR07CA0010.eurprd07.prod.outlook.com
 (2603:10a6:6:2d::20) To LNXP123MB2185.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:dc::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=p.figiel@camlintechnologies.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.7.4
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d9c6c8d7-a664-4286-6029-08d6a3da3e92
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:LNXP123MB2106;
x-ms-traffictypediagnostic: LNXP123MB2106:
x-microsoft-exchange-diagnostics: =?iso-8859-2?Q?1;LNXP123MB2106;23:tELjxLtU+8XRWf404igN51MQaqlfWr6wey/Vpc5?=
 =?iso-8859-2?Q?dBZTZ9P7g/YXcQLEWj4ob6Z4x0ZNH3LXBVmAPlRDF+sFKzKNrltc7UZkiB?=
 =?iso-8859-2?Q?6gdVv3TxdJgPUGMzFTXJJbFwWgWSlTVP8ccAxBQf2/LsGa+SE1YdFu39TL?=
 =?iso-8859-2?Q?F4D8sApjabbi+pzQShn+UdBXb7fHZluxaWIXM4ZjxPzDhjyXqvwwWwIYa7?=
 =?iso-8859-2?Q?nRW8wXif3cXPFRsVoPXcWPURyaaV+ozMWZifCgsUHs+xDxNq4sAMYzF5zT?=
 =?iso-8859-2?Q?8FpnIPPmqFsqfEse26P5lRuhEyP3yH89PE9RFA4PdpWyN6tlIc1OnDZU54?=
 =?iso-8859-2?Q?C6MBUvHEUBecSS7JDSd4ie4zhFMCvd9UYGFBE3lrqAhhjVZj6VUOOCQ4+k?=
 =?iso-8859-2?Q?887SNtOM19KYBO+x6VHomqVruJNsLktlPL61G3AM4X10LZU7vEjUk4FNCr?=
 =?iso-8859-2?Q?Rosq5n/xwddjkSfFCCSDGZ89vUR4E/AAh7MI5Td7T7OoRW0VEy8F5gw26R?=
 =?iso-8859-2?Q?Pkt3uUsK5Dvb0gJ57cxUvXipKGgjVKDBSVud+Hh4/N9B8Zm7OLWBhs7FAM?=
 =?iso-8859-2?Q?gF4hI+lLeyBgo/BvsMWsg3RnCr5GLnTMEIQRPNQI9nRvnrXOlWGmbTl+Sf?=
 =?iso-8859-2?Q?2Z0c8rIJwKa1Q+L04dVaS4PLsbYzY4hrrBRVrnwQ6vH08Qu69B6PDJ5V0p?=
 =?iso-8859-2?Q?rSa03II+XfS4tJMZzDpRsLZPwUdSroGLB2YzuxBokElmjNW5DaOJ7kWKeY?=
 =?iso-8859-2?Q?YE4mhEfISiscjOTYdHUy8LU/rNq9cFW77qj3RRZZpyqbdhwNP08hSVIufX?=
 =?iso-8859-2?Q?0Mk8PgWv4u7smzcspxBuUj8SJ+5CJqwMaO7tdP9CTLCqu2emuGida9wJbq?=
 =?iso-8859-2?Q?a4E7JPK4JklzeLYQT+BI/VbjGHUbgGnbjTOwK/LIKeOKDFZKP/0SYOddlL?=
 =?iso-8859-2?Q?DZTOLxQ5RsNgy9sfp+Yk6b8q/D1RLQn4TGhbBk6SprIwpRJg4CYukz4i1H?=
 =?iso-8859-2?Q?oBlQG9aLgtP9DXDyUAuQMbzE66111iv/maBfwsMhHccib4IYky9eY/7Vd7?=
 =?iso-8859-2?Q?6s5TWaiij8Zne0gO3Xq3TJHNN+otklJ0D8obkFJn1w+tHoHN6gYvBcgfVo?=
 =?iso-8859-2?Q?Ti4Mn+Gn6x8psOk5lcGl5PtpQMey+CzBvx9y+4ACVhR3rK+4QLxeSqOc5W?=
 =?iso-8859-2?Q?cw2GOBfImF6ZsErIkx9OAMLda92JqjQMRBk+Dui1OFQbW1zUXcsHyAhy/w?=
 =?iso-8859-2?Q?qXcw29Uwga42kDy0GPZlFn03mIznyG09HTITYzKHI/pytmY08YKYd8XloX?=
 =?iso-8859-2?Q?OGEKzPbV2AwH0SOnsNrCzC2?=
x-microsoft-antispam-prvs: <LNXP123MB21066EC548FD02A49FBAF79FE74D0@LNXP123MB2106.GBRP123.PROD.OUTLOOK.COM>
x-forefront-prvs: 0970508454
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(136003)(346002)(396003)(366004)(39850400004)(189003)(199004)(8676002)(305945005)(97736004)(105586002)(486006)(99286004)(81166006)(3846002)(14454004)(81156014)(6116002)(476003)(106356001)(102836004)(6506007)(66066001)(186003)(6512007)(36756003)(26005)(110136005)(54906003)(6486002)(5660300002)(52116002)(446003)(2616005)(11346002)(386003)(2906002)(53936002)(107886003)(76176011)(71190400001)(71200400001)(86362001)(2201001)(50226002)(6436002)(316002)(4326008)(68736007)(14444005)(256004)(25786009)(7736002)(2501003)(8936002)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:LNXP123MB2106;H:LNXP123MB2185.GBRP123.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: camlintechnologies.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: A3iI4jQrIcGPh2xhV92KC5cbfMvNlTXyzJmkiI4cl/FWO/3i6O/fHEoo4NWHQiQ/bIZddsSDManV9wYQ7sMWRWQZQggp8R6ztURvfdvGDOzqq2KSb/i7FUWsmByh7SeqK3NbG2E5kktXhtpCW/47E0B3GpGiP0LKSbHr51jzF017jY10DxWyuZ1LNiSY6YJg9yWPEFlJ4VH9Z2tUtIHtt5s/9Ih7BV95oejAdX38EoVKoeue0gvXPmOh+NC2p0ImcuLjF/I7iEG4gdeXEktu/BubyTJ8/kYqKDlRePLQ7F79qqT90BfxVcoh037A7SN4zURYpjI1IZt32oJrXAJEeBLGaAd2u/9YR/wB5uQf88KnFkon5W34QCj3mPz3+Sr2OcypMuyEK+6KCKYBDjFJCB7IA9WuvHO0X9I1cYgi7CI=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: camlintechnologies.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9c6c8d7-a664-4286-6029-08d6a3da3e92
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2019 15:25:06.9883
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fd4b1729-b18d-46d2-9ba0-2717b852b252
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LNXP123MB2106
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

brcmf_usb_free_q is no longer called with pending=3Dtrue thus this boolean
parameter is no longer needed.

Signed-off-by: Piotr Figiel <p.figiel@camlintechnologies.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c | 15 ++++++--------=
-
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c b/drive=
rs/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
index a775409..5ab397d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
@@ -445,9 +445,10 @@ brcmf_usbdev_qinit(struct list_head *q, int qsize)
=20
 }
=20
-static void brcmf_usb_free_q(struct list_head *q, bool pending)
+static void brcmf_usb_free_q(struct list_head *q)
 {
 	struct brcmf_usbreq *req, *next;
+
 	int i =3D 0;
 	list_for_each_entry_safe(req, next, q, list) {
 		if (!req->urb) {
@@ -455,12 +456,8 @@ static void brcmf_usb_free_q(struct list_head *q, bool=
 pending)
 			break;
 		}
 		i++;
-		if (pending) {
-			usb_kill_urb(req->urb);
-		} else {
-			usb_free_urb(req->urb);
-			list_del_init(&req->list);
-		}
+		usb_free_urb(req->urb);
+		list_del_init(&req->list);
 	}
 }
=20
@@ -1029,8 +1026,8 @@ static void brcmf_usb_detach(struct brcmf_usbdev_info=
 *devinfo)
 	brcmf_dbg(USB, "Enter, devinfo %p\n", devinfo);
=20
 	/* free the URBS */
-	brcmf_usb_free_q(&devinfo->rx_freeq, false);
-	brcmf_usb_free_q(&devinfo->tx_freeq, false);
+	brcmf_usb_free_q(&devinfo->rx_freeq);
+	brcmf_usb_free_q(&devinfo->tx_freeq);
=20
 	usb_free_urb(devinfo->ctl_urb);
 	usb_free_urb(devinfo->bulk_urb);
--=20
2.7.4

