Return-Path: <SRS0=oODW=OA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00DB8C18E01
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 06:57:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2D5020672
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 06:57:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="IFzd/y00"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B2D5020672
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728136AbeKURan (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 21 Nov 2018 12:30:43 -0500
Received: from mail-eopbgr680102.outbound.protection.outlook.com ([40.107.68.102]:59472
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728028AbeKURam (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Nov 2018 12:30:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yszK0sgGuc7rC0dOUh9okPjq2IPBgKxkWQICDZb1kG4=;
 b=IFzd/y00eBBAOXOL7lJqx++l+WUMaqZ//j2XqiObUIfnMcm3RZjKdELgJHQwueE4qka68n50dKdZkhT/kqvrzERVkymr1ob5eIAKfXXoUWISzNTbDXQr7COFwWiXA0S3Qt5t4MZJ+ao8qB/Y8+ZC5MEnywZLUYhXCqqw0w5cm+M=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1349.namprd06.prod.outlook.com (10.161.206.147) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1361.15; Wed, 21 Nov 2018 06:57:16 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::809a:6ca8:db12:f5ae]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::809a:6ca8:db12:f5ae%4]) with mapi id 15.20.1339.027; Wed, 21 Nov 2018
 06:57:16 +0000
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
Subject: [PATCH 5/8] brcmfmac: allow GCI core enumuration
Thread-Topic: [PATCH 5/8] brcmfmac: allow GCI core enumuration
Thread-Index: AQHUgWdw+wcKRPXid0aREvgv3qBPlQ==
Date:   Wed, 21 Nov 2018 06:57:16 +0000
Message-ID: <1542783402-112482-6-git-send-email-chi-hsien.lin@cypress.com>
References: <1542783402-112482-1-git-send-email-chi-hsien.lin@cypress.com>
In-Reply-To: <1542783402-112482-1-git-send-email-chi-hsien.lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [12.110.209.245]
x-clientproxiedby: BYAPR02CA0069.namprd02.prod.outlook.com
 (2603:10b6:a03:54::46) To BY1PR0601MB1436.namprd06.prod.outlook.com
 (2a01:111:e400:522c::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1349;6:nJ8YVh5XtEk3EH1dY4SsKHMYn8J6IIhMMAXrm4zvCdk8G6n8tHlwzhdAUMkgi/JGuWJHeBc0gAHSz+SRqq1A1ocKvYOiwd1tQymBDOWn/+skfGeafqHByxznd/L4JkIuL37cS0iVXXVXp0a8lo5hFQM1H9TWDRSBEEce0J+GQzLE3aF8w6xkaxkDoj4sblgvae1XCwQn08YIqQzRhJacXCoIZhKozpW5a/ZvJviV9N90yS6shF6EtCIo6K7+YdRmhg4tfze12lmNFWRJ8FBg+tSb7m3+1bjDJ/eBf8qGy628eZge6HXuFKEwHBBrPdwsJbTOT+k44lLN3XXi+V7Hxfjox0DPp0/VdXsGC+RF/XB2grBvgyjuyu0o6X+Rgd7QnS2Dp9MN1ambhLxv8UTOu1HcAe9CFwQAuLn9rDyCUnaNHE35TEG7IK7wa7M7zcC0MhjnKwG7Xr4k7FcylxdUNg==;5:RPyJ1vk2viFcd3sAHLpD3AD3vxYf8mlvzWRWS1r3VgWck/O0YTQogPrItZowGxZ8pReTM2/NiXRh2x4ku0agwZDE3oEEROJCA9MR7xnM531Wrr/XDKURD7Octmy5sjWAD+heEyR7CLZKAJcxg4h12YRJvbAdU4ulJDszCpYN/pI=;7:Imbe/x1pN8en5H7M5uaVkdPzJlffvDnYjI1zzf8HySd0+XEx2S7PSJF/AnlP4Hb1d40NbaBbha5YFuWnwZUbqhEAIDO1Sa9G+U7sXo8L2KR9BKWEMm+/E3NCc73UED9AUO6YFTeqZWUbmiHZhj83Vw==
x-ms-office365-filtering-correlation-id: 57cb6549-b3d9-4b12-ee5f-08d64f7e922e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1349;
x-ms-traffictypediagnostic: BY1PR0601MB1349:
x-microsoft-antispam-prvs: <BY1PR0601MB1349678516B455689AEC26C9BBDA0@BY1PR0601MB1349.namprd06.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3002001)(3231442)(944501410)(52105112)(10201501046)(6055026)(148016)(149066)(150057)(6041310)(20161123562045)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123560045)(20161123558120)(201708071742011)(7699051)(76991095);SRVR:BY1PR0601MB1349;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1349;
x-forefront-prvs: 08635C03D4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(346002)(376002)(136003)(396003)(366004)(189003)(199004)(5640700003)(446003)(478600001)(316002)(54906003)(97736004)(6486002)(2351001)(6436002)(6512007)(486006)(5660300001)(86362001)(6116002)(256004)(476003)(105586002)(3846002)(72206003)(2906002)(11346002)(106356001)(2616005)(25786009)(305945005)(7736002)(66066001)(2900100001)(76176011)(6916009)(68736007)(107886003)(26005)(36756003)(6506007)(8676002)(186003)(8936002)(2501003)(386003)(4326008)(14454004)(102836004)(81166006)(81156014)(71190400001)(71200400001)(99286004)(53936002)(52116002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1349;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: /TwxIy4aAaopR2JH7YmAJsD4pVonodl8sAjjy9pX9jHi1+4J8NTijka8IZvFv3CIsjs2qMMZQFTE61cIjVks52MaiqdPdfoC/AoyC/dgbMh4u5+gPYGJ/OWfhKagcqQ9yJZ941CDcN5B5MuNK3Gc8HdSPrUQ9OoNen1Jmtv23QJmSNfM7IN2gaWsGthkc+2oU30jIPRCzQ/KNz/9GPyL/ZvJpG6RI4ugg5X+1kYtfeAfgRNWM6GMs26SZV+ut/wPW2T+TzbwGietztNhGnBEWshYtMV1aGv58nHLv497ySVQYO5bWPCHKkltashIEDa53hAfnZg51q1VESQxnfiZfOY67nCeADXiNbsveJwKpMs=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57cb6549-b3d9-4b12-ee5f-08d64f7e922e
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2018 06:57:16.5589
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1349
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

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c | 14 ++++++++-----=
-
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/driv=
ers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
index a3c857721446..a8d3b96b727f 100644
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

