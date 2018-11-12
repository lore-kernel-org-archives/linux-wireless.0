Return-Path: <SRS0=J0pC=NX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D770BC43441
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 07:29:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 960D321722
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 07:29:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="abiXhBix"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 960D321722
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbeKLRVs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 12:21:48 -0500
Received: from mail-eopbgr760131.outbound.protection.outlook.com ([40.107.76.131]:35520
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725871AbeKLRVs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 12:21:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yszK0sgGuc7rC0dOUh9okPjq2IPBgKxkWQICDZb1kG4=;
 b=abiXhBixCsfLOqUuj7YfMact/rILH2Rev7p/EqFA5M7vnXwrXry2R0i1FPXYNN0ScQ2r/yAuYBtnLLyOXZb6tTFknCEjFUt0xIxaDOctt+ISOWE8cjW7iDc5yjaZiO15Tb7SRaCyMkxA41D0h7W9GBULyl9nm02OvM+UuvmbjCQ=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1126.namprd06.prod.outlook.com (10.160.196.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.29; Mon, 12 Nov 2018 07:29:46 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979%3]) with mapi id 15.20.1294.044; Mon, 12 Nov 2018
 07:29:46 +0000
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
Subject: [PATCH V2 5/8] brcmfmac: allow GCI core enumuration
Thread-Topic: [PATCH V2 5/8] brcmfmac: allow GCI core enumuration
Thread-Index: AQHUell8qUxBrGET4EyJQkOGqtbdzg==
Date:   Mon, 12 Nov 2018 07:29:45 +0000
Message-ID: <1542007730-47284-6-git-send-email-chi-hsien.lin@cypress.com>
References: <1542007730-47284-1-git-send-email-chi-hsien.lin@cypress.com>
In-Reply-To: <1542007730-47284-1-git-send-email-chi-hsien.lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [12.110.209.245]
x-clientproxiedby: HK0PR03CA0084.apcprd03.prod.outlook.com
 (2603:1096:203:72::24) To BY1PR0601MB1436.namprd06.prod.outlook.com
 (2a01:111:e400:522c::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1126;6:qpEArRvOr2/p02mEHvZXrGZuZNF233UUcV5ukf1IU6OEi4JTUi84S7dtYtvpp2N4TFC+lQVhb4Uht/+ZQSx8mxNggPNTH2DVzPZRkur3fQODnHx60lgAv5VrdLcFoYX8o4QwySkcK3iaGD6fNYWd8O/+KhDtsFWvtoZ7Xf8CDBfGwEePvcDIhmbeObYIcQ6M1Vz7Zgm2jowutts6okhaVRKa3LUqvUqc5ny51wtuwOJalwmPr28rI1LVeBZ4fTYXH854HdHSlRTmwbuA3lJ0cXjmIomYnUcL44hzOeMw/k5lwJuxLAbxTld4G/wAfCYEq8J0HJ5qTNySNCWjYaoBvTHFd7x6lzg3Kyrx09gJHSK9ojSX3FT16Rxrb+HkYxFswuZ7mTbVgmY2qFuWlTU3WaxHIgWA5S0dGZ1E7RrSjdjv+xLrjTB4mh4O8EgEezBiMv5xsUAaMVW09EEHP31mTQ==;5:ocbf349Q/i3wbFZa2PqQS9eelRalIEE2opzRAa4L8koMiVAbU028NGlEpr1ymZds33vLN7XPLW9QMii6VUuJAciR3aWWlbam/UkF2n5TgyhRJxa8Z9E4bVyFHB4IWbP1mko35gEj7iEST+3hYRXumRzxaocRZqL+afWcX9fwHPA=;7:Ctog587jHovemhKKKoWUjgD5hQL0PlWFCBDe16W26pZTNxvMTAM9qlwaKGdGkysPzNttFxxZrUHY20p312N5dDa3LWNoOs12eMiXsp3b3Id7p+mkcubIX59ZwhrpnlNKRwUuJwmIzaovVcuhrJRrNQ==
x-ms-office365-filtering-correlation-id: 3587e413-cf60-41c8-3043-08d648709e63
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390040)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1126;
x-ms-traffictypediagnostic: BY1PR0601MB1126:
x-microsoft-antispam-prvs: <BY1PR0601MB11260064AA794C92FCE8D9C7BBC10@BY1PR0601MB1126.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(208715162771679)(258095267146985);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(3002001)(3231382)(944501410)(52105112)(93006095)(93001095)(10201501046)(6055026)(148016)(149066)(150057)(6041310)(20161123560045)(20161123564045)(20161123562045)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BY1PR0601MB1126;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1126;
x-forefront-prvs: 0854128AF0
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(346002)(396003)(376002)(39850400004)(136003)(189003)(199004)(25786009)(4326008)(2906002)(76176011)(3846002)(6116002)(99286004)(52116002)(81156014)(81166006)(478600001)(68736007)(8676002)(6486002)(14454004)(66066001)(5640700003)(6436002)(72206003)(8936002)(256004)(386003)(102836004)(6506007)(106356001)(105586002)(54906003)(6916009)(2351001)(86362001)(305945005)(2616005)(5660300001)(36756003)(7736002)(316002)(2900100001)(186003)(71200400001)(446003)(11346002)(476003)(486006)(71190400001)(53936002)(6512007)(2501003)(97736004)(26005)(107886003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1126;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: TRdUZ1+l0A85otosYHdisorKk3jSLPz29ZGdOhq9KXrMabwd6o0MtpgtiyqkdR2+PT0bqcP3OgOcJxFeN4stbRIVfT2LzIupIr0wTO5w3iwgZrhPUyOFLWCtEEIBEJV2B2NffgkBvq1dPlsF/PRcrywC54jLCsvXyBZhFLXBQK26RaZpv2iI0h2cm557EUCgOHDYrCMWFHUkFm+pduUuJZzVyvp4FoEAPFF/8xOhxPZ3tMK7y2oHlOEw8kv5KkKMu3MfbAESPagLZ3pUZr+FmqKcmf9RaySPbOqh2wHfmC4T9Sd4Uqf7oybzEfWjMWWj+uicfUGfeBNYgtBg5c07fl/okQVSBCSC41SW4mGCd3A=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3587e413-cf60-41c8-3043-08d648709e63
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2018 07:29:45.9899
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1126
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

