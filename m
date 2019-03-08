Return-Path: <SRS0=wltO=RL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 591D4C43381
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 15:25:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2332320868
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 15:25:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=camlinlimited.onmicrosoft.com header.i=@camlinlimited.onmicrosoft.com header.b="SP1k+Odn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbfCHPZr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Mar 2019 10:25:47 -0500
Received: from mail-eopbgr100054.outbound.protection.outlook.com ([40.107.10.54]:14944
        "EHLO GBR01-LO2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726279AbfCHPZq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Mar 2019 10:25:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=camlinlimited.onmicrosoft.com; s=selector1-camlintechnologies-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iSog5YJ+q6BjwGhcnwT9lbkTmoNuFHhHL8RnzcTNavw=;
 b=SP1k+OdnN9MKcYRr/8AoEigTJck2RhESnY491FAE81bPpwFtQC6vMmAN8/D5W5p4YmlhEkLKH5NDDEX8sqeUEExLZ8SDhQVqjidN/gbexgqnrPxKBumbB61plUqapXjxCJcCv2IwzbdBVMbp1ywGCrrw8ASb51id3+tUqb+Mxqc=
Received: from LNXP123MB2185.GBRP123.PROD.OUTLOOK.COM (20.179.129.83) by
 LNXP123MB2106.GBRP123.PROD.OUTLOOK.COM (20.179.129.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1686.18; Fri, 8 Mar 2019 15:25:09 +0000
Received: from LNXP123MB2185.GBRP123.PROD.OUTLOOK.COM
 ([fe80::396a:e27e:d5dd:6bf0]) by LNXP123MB2185.GBRP123.PROD.OUTLOOK.COM
 ([fe80::396a:e27e:d5dd:6bf0%5]) with mapi id 15.20.1686.018; Fri, 8 Mar 2019
 15:25:09 +0000
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
Subject: [PATCH 3/3] brcmfmac: remove unused variable i from brcmf_usb_free_q
Thread-Topic: [PATCH 3/3] brcmfmac: remove unused variable i from
 brcmf_usb_free_q
Thread-Index: AQHU1cMd5vOYZC5mAU2ccGUUUcGOeg==
Date:   Fri, 8 Mar 2019 15:25:09 +0000
Message-ID: <1552058658-23250-4-git-send-email-p.figiel@camlintechnologies.com>
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
x-ms-office365-filtering-correlation-id: 7882a4d4-5f90-4408-6a9e-08d6a3da402f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:LNXP123MB2106;
x-ms-traffictypediagnostic: LNXP123MB2106:
x-microsoft-exchange-diagnostics: =?iso-8859-2?Q?1;LNXP123MB2106;23:axFqT5Cq98r8h8zWMg9dIXizT4oG1d4UH/ny+Xx?=
 =?iso-8859-2?Q?nkZL3gtvys6MhV/X9hVmEqEcAAiWymCWR/B6+RuUOLAbZRF+QPihcFtFLG?=
 =?iso-8859-2?Q?Y4zznV/IrRzbrbNVVIYhflRdtz0pnKqXHNP4/hnnBOGgsK3StRPqtctBFq?=
 =?iso-8859-2?Q?z/+N7X2srvgef69CrHn/tH8K3K2HWDATWFd/BD/5xTTQEpxf1gu7LP4D7Q?=
 =?iso-8859-2?Q?TPmB0OpIOB2V1ecOkcukk66425zB42rfbmm/wL6py+kwqtcUdNhmLqrfNf?=
 =?iso-8859-2?Q?v1ohmoZXsGkZRi8cakfXozUWUl7Av3vsPuZSmvvJ5ryVaOtskhQMXfS0Fm?=
 =?iso-8859-2?Q?OJH7nnTte3F8bD7YHz93EKGsYikefLvAqgxUAeaJbmkegjRuWhesjY2UKM?=
 =?iso-8859-2?Q?u99rKJj/HtO/Ec7iGOf2OjGK8iMxWkhyPB1Nu0L/0gXVVd+i1usCkrPfy3?=
 =?iso-8859-2?Q?46z1sCxuX6WHe+xj0hP1LoJGI9AxNaKv5LeMRgGE1CZO7thmFgtZMOjfPB?=
 =?iso-8859-2?Q?Y8MxfRrDs64ZVDik1ID1FJ08Fu0bk01HmPbXPyZpTVFUTSZGajDH8XE2CJ?=
 =?iso-8859-2?Q?AwmRLdiacGl7IBRRr0Hjq0fEaDnKASgii6B4mPpr9kWNndUqW/7R1zPbl0?=
 =?iso-8859-2?Q?+zAvSbz6y+op8Ow4I70uTAYhQYbFQGXsUHYXAH8zMHpBHT0JoSblGaEahV?=
 =?iso-8859-2?Q?JcdMButQE4CZfd+3RsQrOuKRFAQfYP+w5P8mHR5rVQRYlXqYS21fBtXmCU?=
 =?iso-8859-2?Q?0hMNVURntMhlgMgswcCy9lDZPGXhSIwOkAmQNXfb/Gmo87CK176Eo26ubX?=
 =?iso-8859-2?Q?u450KQAbb72P5ShW17K5gQig2igXqJVuGL8NVJGL/XH2o3bM0B5JH+j9uh?=
 =?iso-8859-2?Q?domVCJnVJ+r3uri/zUguRAcLn7HKTzkPovcc57DZsNB0VJ5acs+lmqhnkk?=
 =?iso-8859-2?Q?mdFmcge/TPm9lKLnDCOjgoPyDWcAAfY9MdIatmaF7hmAu8+SQ1Vi5deBR5?=
 =?iso-8859-2?Q?ZrU4aVHqc3hYS9JIzCRUDcAEnKdmwkTEabD+42YFwhMeGvowD9hglG4OAe?=
 =?iso-8859-2?Q?1pfKMLpFoMdExtXcfMxQCle9k3pqEW8BDv/7rLwU2aQWRceSOrIjEmjx43?=
 =?iso-8859-2?Q?ZSd4hYCysj5moBDg10kGUIa91lgtqA94LhK6gLzB5HO3veu0mHLpXnG6NC?=
 =?iso-8859-2?Q?dPou7jk0qqceJEIJu5DYDeOXdsL5Aop+nv43002P/bYMf+f5RXbxQKquAf?=
 =?iso-8859-2?Q?yWGlw3T1Lw28ZtyHCtNCBlMNgf4NfrN9JAJSXUM1qFMmJVEWbxYNOehG8e?=
 =?iso-8859-2?Q?1lr8auPUYU0or0WIkzJ1fWY?=
x-microsoft-antispam-prvs: <LNXP123MB21061B27589BB2079ACD1D7AE74D0@LNXP123MB2106.GBRP123.PROD.OUTLOOK.COM>
x-forefront-prvs: 0970508454
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(136003)(346002)(396003)(366004)(39850400004)(189003)(199004)(8676002)(305945005)(97736004)(105586002)(486006)(99286004)(81166006)(3846002)(14454004)(81156014)(6116002)(476003)(106356001)(102836004)(6506007)(66066001)(186003)(6512007)(36756003)(26005)(110136005)(54906003)(6486002)(5660300002)(52116002)(4744005)(446003)(2616005)(11346002)(386003)(2906002)(53936002)(107886003)(76176011)(71190400001)(71200400001)(86362001)(2201001)(50226002)(6436002)(316002)(4326008)(68736007)(256004)(25786009)(7736002)(2501003)(8936002)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:LNXP123MB2106;H:LNXP123MB2185.GBRP123.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: camlintechnologies.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: fBFhNPbfK2TUz+HT1/eKyTjOHtuJrH2d0PSFja2aBfPZtS45mW5+mjFKBjA0N8AnXIa/O3OQyprqZIQDeffuIzoqKA4yA6MBkjGBY/j+n+8+7WuCeNHL9OBUEW/l/cQEUA2cuCR9tbLwEO/SvfOsBjTMuXNWmpyU6nUZc4qow5TPBwiwD+c7Mj5P9fOIJEH+pOdaN78wwX3m35udeyyENQfxsHPU1S48oibhn8wuBDOzBqxiXXqkOAZ59aTVypgrLYdhMo7lAZgG/Kq87SCjEwmHOjCV2H5RDjAYZxdAe/AfJzgFHAPGvdp8rK5AR0M/R5lXPA9QDvxB33QeC4KMwrClrag2Cwv6iboRbW+sQsPAZXmE0TB9bOi+PzTRrrK5Nrh0kiEKWbNbKtL1cyNS0mEsmA6OFf9KUnjKUL9x5Fs=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: camlintechnologies.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7882a4d4-5f90-4408-6a9e-08d6a3da402f
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2019 15:25:09.8013
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fd4b1729-b18d-46d2-9ba0-2717b852b252
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LNXP123MB2106
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Variable i is not used so remove it.

Signed-off-by: Piotr Figiel <p.figiel@camlintechnologies.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c b/drive=
rs/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
index 5ab397d..c00b9fd 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
@@ -449,13 +449,11 @@ static void brcmf_usb_free_q(struct list_head *q)
 {
 	struct brcmf_usbreq *req, *next;
=20
-	int i =3D 0;
 	list_for_each_entry_safe(req, next, q, list) {
 		if (!req->urb) {
 			brcmf_err("bad req\n");
 			break;
 		}
-		i++;
 		usb_free_urb(req->urb);
 		list_del_init(&req->list);
 	}
--=20
2.7.4

