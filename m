Return-Path: <SRS0=oODW=OA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C37F2C43610
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 07:54:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FDA32145D
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 07:54:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="fLuHYyrt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7FDA32145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbeKUS1a (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 21 Nov 2018 13:27:30 -0500
Received: from mail-eopbgr750121.outbound.protection.outlook.com ([40.107.75.121]:39472
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728220AbeKUS11 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Nov 2018 13:27:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yszK0sgGuc7rC0dOUh9okPjq2IPBgKxkWQICDZb1kG4=;
 b=fLuHYyrtbXFQjgKAN80h7sxCnCvzKKSOYC1I4d7ku+daki8kBiWe4ZtfaDBH8CreCYUfHz/H7Ntaiyt1Smu5n2nIyumMU0SuWZA3lokgp+M9/XqvT7lBhiJFKX9DtFrP92RC+NWMPF1bd6xHw+9NSAk74Pyt/A56foMKVHzrVRQ=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1174.namprd06.prod.outlook.com (10.160.195.154) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1339.23; Wed, 21 Nov 2018 07:53:48 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::809a:6ca8:db12:f5ae]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::809a:6ca8:db12:f5ae%4]) with mapi id 15.20.1339.027; Wed, 21 Nov 2018
 07:53:48 +0000
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
Subject: [PATCH V4 5/8] brcmfmac: allow GCI core enumuration
Thread-Topic: [PATCH V4 5/8] brcmfmac: allow GCI core enumuration
Thread-Index: AQHUgW9V6xS6fJoicU2H9HD2snZdiw==
Date:   Wed, 21 Nov 2018 07:53:48 +0000
Message-ID: <1542786800-146083-6-git-send-email-chi-hsien.lin@cypress.com>
References: <1542786800-146083-1-git-send-email-chi-hsien.lin@cypress.com>
In-Reply-To: <1542786800-146083-1-git-send-email-chi-hsien.lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [12.110.209.245]
x-clientproxiedby: BYAPR03CA0024.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::37) To BY1PR0601MB1436.namprd06.prod.outlook.com
 (2a01:111:e400:522c::23)
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1174;6:nX4ICoRMWRLDuhSna/7J9aZ8ot1PTB4mqNVmL5seRigWhpLQQTO95Sc6JAyu8jsUMPTLBglAKYY83ae34xq0/E1KNZs435zHYetrLNmu8kl6ghYDU2gyWiHK802bitrvzoHwBvABWuFUsLIo8641AgFrZ6x8NwnodjEhC0yyOZHfo4xvAlG+YZPeVP3pS7CpOFK2m9a9FMAKB9HAKQx7qnYDT8GGiiaU+olEOTrBvDiMfYCVZhVrpzRKd1oPaa3pzCE8m05xDq6zfEulfwQZcLpawwN4vmWsH5uJtD9BG7SEGzRzE3y295q3PRrryLqEhLZtxv8tm23y5XDnGLV6RQThgNPrhIvKSqD/5xgUZHcKz7FOyEjma3ARRBwS0GoERS9DXuPY+IYHduPq5FT5+vt9lIxQcR39QcaGDrr19yxHLz6V2WjrWhkI4HFhsfkCEsiaalVRXk8bkaTG2PqoEA==;5:k9dxSI8zKS24Gah8htEF72RlaYkG5TqkSZ2w7iO4suvyG7wb1HW1XIeNWk/LyHMaxdDLw/ropGZbMfvMJlsLT5vlXzwfeAWRb51qeCYCtms0KgvEKlYUII+XXXOg+9D6z6ZOJxlj+ckncRhe6i+AKk6iZGOFP90F8Ml5A0a2qU4=;7:Z4IfEeV1J3MQpgLBv8Mqe9Y1bA+4OHhmXcIm7QMnavzyLMfzplGrWS+RBemgeAKd6q9YCXkFuAjQWhqdysPkPkl0Y/LWDAcLpEq6ZWrIvMTP9Z03ybr+TdhS4k4+J2iv82Kr5TFI9z42jgCzEPbdOA==
x-ms-office365-filtering-correlation-id: bc3a18b5-57f4-4b27-47d0-08d64f867805
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(5600074)(711020)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1174;
x-ms-traffictypediagnostic: BY1PR0601MB1174:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-microsoft-antispam-prvs: <BY1PR0601MB11748D40119C85ADECF70869BBDA0@BY1PR0601MB1174.namprd06.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(3002001)(93006095)(93001095)(3231442)(944501410)(52105112)(10201501046)(6055026)(148016)(149066)(150057)(6041310)(20161123562045)(20161123560045)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:BY1PR0601MB1174;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1174;
x-forefront-prvs: 08635C03D4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(366004)(376002)(396003)(346002)(189003)(199004)(107886003)(478600001)(36756003)(72206003)(97736004)(8676002)(81166006)(81156014)(186003)(68736007)(6916009)(8936002)(71190400001)(54906003)(2906002)(316002)(25786009)(2501003)(71200400001)(6116002)(3846002)(99286004)(6436002)(2351001)(256004)(305945005)(6486002)(76176011)(7736002)(105586002)(6506007)(4326008)(386003)(52116002)(5640700003)(102836004)(66066001)(2616005)(106356001)(476003)(14454004)(486006)(26005)(11346002)(86362001)(53936002)(2900100001)(446003)(6512007)(5660300001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1174;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: ItTE3RuYgqP+C29qjsMPjuSWzoVywZ/2zHdgsRMp2UuHMe9B2wvS4kbSUQcOQlMQVvrqqk7Q+Ul2Sq9fFSufCzCda2MhjsLJAMuBIGzZXfiwcdt15hEHtIstlMLtqNxbnoo8CTyLh+oBbFJKYbok+aXXRExlt/Aij4V3Ts2MFoGp4YQv9AfX/0PTXOWhEgntievpVoTxkbsPUidyBerCHzNhPuyeHFKCR9WGRNXBHPdxS5DMp0AxTb3HFjHl3nY2kWHe4ELawD0b75pm4DBNjOkM5sZcFZ5cz7oR6VRiozYMsIiDawwzKPYmJgYuHrd2D9gLGlL+JDDc/Z1imUg8Fb/NP6Ju/xS/A7u3jxvhP7c=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc3a18b5-57f4-4b27-47d0-08d64f867805
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2018 07:53:48.2171
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1174
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

