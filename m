Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A43AC46465
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 03:50:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01DA720862
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 03:50:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="AA7Sac5y"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 01DA720862
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387398AbeKFNNn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 08:13:43 -0500
Received: from mail-eopbgr810120.outbound.protection.outlook.com ([40.107.81.120]:58734
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728971AbeKFNNn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 08:13:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yps4oVlOT51g24lvIYUn+Se2kUM/8fyzB0DRw85/Czs=;
 b=AA7Sac5y73NNVhHcUuxOveRk3hJ6FsGVBJH0AkvwASM91F926OA3K8Jq2VRU+QyWlRCNpIgCtcJ/rvJ6035Ea/2SXUm2Mxcj7RG4Koh8spkeZYon0pG9SrS5EyFBiOVA8Fhyeixn6DSqSeoV+zzeL1EC0Nw0NdsaEWQx++PkRUo=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1142.namprd06.prod.outlook.com (10.160.196.153) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1273.27; Tue, 6 Nov 2018 03:50:21 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979%3]) with mapi id 15.20.1294.032; Tue, 6 Nov 2018
 03:50:21 +0000
From:   Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Subject: [PATCH 05/11] brcmfmac: allow GCI core enumuration
Thread-Topic: [PATCH 05/11] brcmfmac: allow GCI core enumuration
Thread-Index: AQHUdYPX7fFoiV5gjkm03Sx4slY+xw==
Date:   Tue, 6 Nov 2018 03:50:21 +0000
Message-ID: <1541476188-75475-6-git-send-email-chi-hsien.lin@cypress.com>
References: <1541476188-75475-1-git-send-email-chi-hsien.lin@cypress.com>
In-Reply-To: <1541476188-75475-1-git-send-email-chi-hsien.lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [12.110.209.245]
x-clientproxiedby: MWHPR2201CA0082.namprd22.prod.outlook.com
 (2603:10b6:301:5e::35) To BY1PR0601MB1436.namprd06.prod.outlook.com
 (2a01:111:e400:522c::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1142;6:bsU2m5/Q/9PHP8l2TRBtEvY6/S6qZAvDzNbgRrxKTo97M8+58u2Pms7TD3ZGI6wUEJbmslW7oW/GMOv1c9trvtKrwgam1rhKrTXR74UumvrUR9yIbywUXsX5xiRmiaNG1kEBIAivdVnvgfm5w6hTEgE7fOP6wSQYRKE+J1ooTX91WyHD/FkAiabPZr2HUYA/y33HeN3Dks3zX5eCJg6RAzwZzrbajCvw64oMWLccBSXml9B6h+FxXBJqnD0icUneigXZtn2YyMP8ocihyvljb5O+xuR3xF9z0q6I6B3n+Oo42OsnN7DQvleglDOxMCAwg972uTlihXs2Ae1lGUk+o/gzQZjo+qUKKFuHldAGpzMDWM0iXamOBgIvhPG5ApFiHEiI7AZ4fHsGtD+cxaKYt4Gneb2T5ZBYyDsFqEMzX5mpeuywcvWoAxDcFwdRboupab9+yNQPJaiekE+MCoPJ4w==;5:CfefuHztoI69bEluHHLxSha+MbY2sfbFpc2+w9kUStKk9fZ97HlLIdnK1KDIrl7iuFBHGHz0uETDOSnTa58VmREsxxyMJJYVtx2kHtPP8uoeiZh3K9iblz6NpKOiS7fgpx6LKVEQBVnMUC3HpbFQpwthT/YtikkX1yfct6lre3w=;7:6tbfTk7FaWzSo8Lb18ExAJVW2joxHtNBoJWxQgIMSgeNll7Kg8IJJAmPBP7fQxTCKOZ1xawFRoK6VWpW9gt4wFBQuWpaCb7h06R3TIXuDRCFboECm67Y9B4lWnuS8Hrl//+tPhwIq58JUKpf1iOyUQ==
x-ms-office365-filtering-correlation-id: bf6340dd-dd71-4dd8-6767-08d6439af99e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(5600074)(711020)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1142;
x-ms-traffictypediagnostic: BY1PR0601MB1142:
x-microsoft-antispam-prvs: <BY1PR0601MB1142F393B674BB509B625668BBCB0@BY1PR0601MB1142.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(258095267146985);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(10201501046)(3002001)(3231382)(944501410)(52105095)(6055026)(148016)(149066)(150057)(6041310)(20161123560045)(20161123562045)(20161123558120)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BY1PR0601MB1142;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1142;
x-forefront-prvs: 0848C1A6AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(376002)(366004)(39860400002)(346002)(199004)(189003)(6506007)(36756003)(386003)(102836004)(186003)(2906002)(6916009)(8936002)(54906003)(5660300001)(81156014)(5640700003)(81166006)(14454004)(26005)(8676002)(476003)(486006)(2351001)(2616005)(446003)(97736004)(11346002)(6436002)(106356001)(105586002)(6512007)(256004)(6486002)(4326008)(3846002)(6116002)(7736002)(68736007)(99286004)(72206003)(53936002)(305945005)(76176011)(66066001)(2501003)(107886003)(86362001)(316002)(71200400001)(71190400001)(52116002)(25786009)(478600001)(2900100001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1142;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 4qvYzd3R9Qijjqq/5kkZlDCqCYJ3SLJFSlkAalDGXBxxK1F9jJoea7X7Q1k6KWnmjtPSjg19NYEnVXfLCCjXOboXFwVbNiMfbz19CSjxQTnnlETScnOV5zEmS2j4CmaR+s+KWaYD7STyMyQlPFyhxn7l25EmR7WkRNRCfTo0Kd8ZQX3ptup2IBWDZ2chl/fwicUMNq2djijxhMOllHBBvj4PVND8wHYg371leMIHAdgrojXTBvgEdBtEAzf71rRY4eIV343toAPaW6nc/m4IhGSZuN53cN4UK/OMJLjklcAprk3ilQaT4lskXygMqhlwXduYQBcqcT0v/6hqqrQ/EieWZHlYuJN8pXUOZrwjTq8=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf6340dd-dd71-4dd8-6767-08d6439af99e
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2018 03:50:21.5919
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1142
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

GCI core is needed for ULP operation. Allow GCI core enumuration with
below changes:
 - Allow GCI to be added to core list even when it doesn't have a wrapper.
 - Allow 8K address space size.
 - Don't overwrite the address value when an additional size descriptor
   is in place.

Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c | 14 ++++++++-----=
-
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/driv=
ers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
index 60fd3018534e..7d5005d75e01 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
@@ -786,7 +786,7 @@ static int brcmf_chip_dmp_get_regaddr(struct brcmf_chip=
_priv *ci, u32 *eromaddr,
 				      u32 *regbase, u32 *wrapbase)
 {
 	u8 desc;
-	u32 val;
+	u32 val, szdesc;
 	u8 mpnum =3D 0;
 	u8 stype, sztype, wraptype;
=20
@@ -832,14 +832,15 @@ static int brcmf_chip_dmp_get_regaddr(struct brcmf_ch=
ip_priv *ci, u32 *eromaddr,
=20
 		/* next size descriptor can be skipped */
 		if (sztype =3D=3D DMP_SLAVE_SIZE_DESC) {
-			val =3D brcmf_chip_dmp_get_desc(ci, eromaddr, NULL);
+			szdesc =3D brcmf_chip_dmp_get_desc(ci, eromaddr, NULL);
 			/* skip upper size descriptor if present */
-			if (val & DMP_DESC_ADDRSIZE_GT32)
+			if (szdesc & DMP_DESC_ADDRSIZE_GT32)
 				brcmf_chip_dmp_get_desc(ci, eromaddr, NULL);
 		}
=20
-		/* only look for 4K register regions */
-		if (sztype !=3D DMP_SLAVE_SIZE_4K)
+		/* look for 4K or 8K register regions */
+		if (sztype !=3D DMP_SLAVE_SIZE_4K &&
+		    sztype !=3D DMP_SLAVE_SIZE_8K)
 			continue;
=20
 		stype =3D (val & DMP_SLAVE_TYPE) >> DMP_SLAVE_TYPE_S;
@@ -896,7 +897,8 @@ int brcmf_chip_dmp_erom_scan(struct brcmf_chip_priv *ci=
)
=20
 		/* need core with ports */
 		if (nmw + nsw =3D=3D 0 &&
-		    id !=3D BCMA_CORE_PMU)
+		    id !=3D BCMA_CORE_PMU &&
+		    id !=3D BCMA_CORE_GCI)
 			continue;
=20
 		/* try to obtain register address info */
--=20
2.1.0

