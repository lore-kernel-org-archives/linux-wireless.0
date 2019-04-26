Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2EFDC43219
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 03:12:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6DBF20678
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 03:12:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="IaeHT1B/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbfDZDMf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 23:12:35 -0400
Received: from mail-eopbgr720102.outbound.protection.outlook.com ([40.107.72.102]:29715
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726065AbfDZDMf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 23:12:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+OHZ5rlRaicsBsxaWc8nSs7RekTCg5UGSYxv3mjxYN0=;
 b=IaeHT1B/cERs8pWGnQGblqQXLYAuKWnasfsgdy+p171LMyEYHO/2G7iMIme1R1x3+nnVV6jaxdQkbuaYi519eLvKaNLaQS2cqRSNJOV2mjj/3YpgmJOpbKXpzwD952bxjq+vC3CN94JZHuUiDestIsuB14+8FHUUcfLIwVglZSw=
Received: from MN2PR06MB5806.namprd06.prod.outlook.com (20.179.145.207) by
 MN2PR06MB6253.namprd06.prod.outlook.com (20.178.246.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1813.12; Fri, 26 Apr 2019 03:12:32 +0000
Received: from MN2PR06MB5806.namprd06.prod.outlook.com
 ([fe80::1ca6:d3b:6b7a:65cb]) by MN2PR06MB5806.namprd06.prod.outlook.com
 ([fe80::1ca6:d3b:6b7a:65cb%5]) with mapi id 15.20.1813.017; Fri, 26 Apr 2019
 03:12:32 +0000
From:   Wright Feng <Wright.Feng@cypress.com>
To:     "arend.vanspriel@broadcom.com" <arend.vanspriel@broadcom.com>,
        "franky.lin@broadcom.com" <franky.lin@broadcom.com>,
        "hante.meuleman@broadcom.com" <hante.meuleman@broadcom.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
CC:     Wright Feng <Wright.Feng@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>
Subject: [PATCH v3] brcmfmac: send mailbox interrupt twice for specific
 hardware device
Thread-Topic: [PATCH v3] brcmfmac: send mailbox interrupt twice for specific
 hardware device
Thread-Index: AQHU+93jhlFeXo5BSkq18cF+pcABDQ==
Date:   Fri, 26 Apr 2019 03:12:32 +0000
Message-ID: <1556248345-146837-1-git-send-email-wright.feng@cypress.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN6PR04CA0103.namprd04.prod.outlook.com
 (2603:10b6:805:f2::44) To MN2PR06MB5806.namprd06.prod.outlook.com
 (2603:10b6:208:127::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Wright.Feng@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.1.0
x-originating-ip: [12.110.209.245]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b67be936-7ed6-44d7-aad8-08d6c9f505c7
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:MN2PR06MB6253;
x-ms-traffictypediagnostic: MN2PR06MB6253:
x-microsoft-antispam-prvs: <MN2PR06MB625326816C8D1E61990E28D1FB3E0@MN2PR06MB6253.namprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1388;
x-forefront-prvs: 001968DD50
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(376002)(346002)(366004)(39860400002)(199004)(189003)(3846002)(71200400001)(52116002)(73956011)(386003)(6116002)(71190400001)(102836004)(26005)(478600001)(6506007)(64756008)(53936002)(316002)(6636002)(14444005)(6486002)(6436002)(6512007)(15650500001)(66556008)(66446008)(256004)(2201001)(72206003)(66476007)(66946007)(54906003)(110136005)(99286004)(86362001)(14454004)(4326008)(186003)(486006)(44832011)(476003)(2906002)(97736004)(25786009)(2501003)(50226002)(5660300002)(81156014)(81166006)(36756003)(66066001)(68736007)(8676002)(7736002)(8936002)(305945005)(2616005);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR06MB6253;H:MN2PR06MB5806.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: KzsNHh6e0Xydkb0tExP3b44WqUk1TRZy8JY1vEeDv/2jdC3rWPPJFSch1a1j4ZkhgnSPrnotdFigMhG25vhW5SVU7LrYRHP/V6bDUMxYNEcDYXupBtDI7IHGLfv1qdCO+7gon2yKJhova9GDy3n44aEEgCqsJsqKi5JaBdVsvd+GKPjEOvZxQfoYbd3IKRmOw/eJNFKzEj2mLpQW/5wJ6sZf0CwnsjWMixdhcgab/65KNnMY0hmqThSufaPuxq03d0TNH1RzW4Zm8BwoZGsXfhT5OLd5QcX68esSYL0GFTa4kBj9v9DF9up42RdC66gy5fI+3H9xx7+mZgVWsiQy1XblApuoXUEMunW0m18nwwN5ekkks8c1kvtLPoM0Cm74NMl35Qq8RsAbw1EAJTpVCksBVtuJALl95m9nWsDzlqQ=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b67be936-7ed6-44d7-aad8-08d6c9f505c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2019 03:12:32.4628
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR06MB6253
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rm9yIFBDSUUgd2lyZWxlc3MgZGV2aWNlIHdpdGggY29yZSByZXZpc2lvbiBsZXNzIHRoYW4gMTQs
IGRldmljZSBtYXkgbWlzcw0KUENJRSB0byBTeXN0ZW0gQmFja3BsYW5lIEludGVycnVwdCB2aWEg
UENJRXRvU0JNYWlsYm94LiBTbyBhZGQgc2VuZGluZw0KbWFpbCBib3ggaW50ZXJydXB0IHR3aWNl
IGFzIGEgaGFyZHdhcmUgd29ya2Fyb3VuZC4NCg0KU2lnbmVkLW9mZi1ieTogV3JpZ2h0IEZlbmcg
PHdyaWdodC5mZW5nQGN5cHJlc3MuY29tPg0KLS0tDQp2MjogYWRkIGNvbW1lbnQgYW5kIGNoZWNr
IGZvciBQQ0lFIGNvcmUgcmV2aXNpb24NCnYzOiBmaXggY29tcGlsZSBlcnJvcg0KLS0tDQogZHJp
dmVycy9uZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL3BjaWUuYyB8IDcg
KysrKysrLQ0KIDEgZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkN
Cg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2Jyb2FkY29tL2JyY204MDIxMS9i
cmNtZm1hYy9wY2llLmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEv
YnJjbWZtYWMvcGNpZS5jDQppbmRleCBmZDM5NjhmLi5kN2QzZTkzIDEwMDY0NA0KLS0tIGEvZHJp
dmVycy9uZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL3BjaWUuYw0KKysr
IGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL3BjaWUu
Yw0KQEAgLTY3NSw2ICs2NzUsNyBAQCBzdGF0aWMgaW50DQogYnJjbWZfcGNpZV9zZW5kX21iX2Rh
dGEoc3RydWN0IGJyY21mX3BjaWVkZXZfaW5mbyAqZGV2aW5mbywgdTMyIGh0b2RfbWJfZGF0YSkN
CiB7DQogCXN0cnVjdCBicmNtZl9wY2llX3NoYXJlZF9pbmZvICpzaGFyZWQ7DQorCXN0cnVjdCBi
cmNtZl9jb3JlICpjb3JlOw0KIAl1MzIgYWRkcjsNCiAJdTMyIGN1cl9odG9kX21iX2RhdGE7DQog
CXUzMiBpOw0KQEAgLTY5OCw3ICs2OTksMTEgQEAgYnJjbWZfcGNpZV9zZW5kX21iX2RhdGEoc3Ry
dWN0IGJyY21mX3BjaWVkZXZfaW5mbyAqZGV2aW5mbywgdTMyIGh0b2RfbWJfZGF0YSkNCiANCiAJ
YnJjbWZfcGNpZV93cml0ZV90Y20zMihkZXZpbmZvLCBhZGRyLCBodG9kX21iX2RhdGEpOw0KIAlw
Y2lfd3JpdGVfY29uZmlnX2R3b3JkKGRldmluZm8tPnBkZXYsIEJSQ01GX1BDSUVfUkVHX1NCTUJY
LCAxKTsNCi0JcGNpX3dyaXRlX2NvbmZpZ19kd29yZChkZXZpbmZvLT5wZGV2LCBCUkNNRl9QQ0lF
X1JFR19TQk1CWCwgMSk7DQorDQorCS8qIFNlbmQgbWFpbGJveCBpbnRlcnJ1cHQgdHdpY2UgYXMg
YSBoYXJkd2FyZSB3b3JrYXJvdW5kICovDQorCWNvcmUgPSBicmNtZl9jaGlwX2dldF9jb3JlKGRl
dmluZm8tPmNpLCBCQ01BX0NPUkVfUENJRTIpOw0KKwlpZiAoY29yZS0+cmV2IDw9IDEzKQ0KKwkJ
cGNpX3dyaXRlX2NvbmZpZ19kd29yZChkZXZpbmZvLT5wZGV2LCBCUkNNRl9QQ0lFX1JFR19TQk1C
WCwgMSk7DQogDQogCXJldHVybiAwOw0KIH0NCi0tIA0KMi4xLjANCg0K
