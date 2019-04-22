Return-Path: <SRS0=tUzJ=SY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6246BC10F14
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Apr 2019 02:47:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 250ED2075A
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Apr 2019 02:47:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="NAf0RcDk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbfDVCrb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 21 Apr 2019 22:47:31 -0400
Received: from mail-eopbgr690137.outbound.protection.outlook.com ([40.107.69.137]:62390
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726284AbfDVCrb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 21 Apr 2019 22:47:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/tW2+ebD7I3OnlCUqqhJPFOGb9SA6FzaeQFrxzsyQGA=;
 b=NAf0RcDkaatGAJnmLOgzwvMH0NdJEUXai04FBkT8lMKT4Kk65Sz6vMbmlgFPW6BFYP6Mf7vonACdf4Cg59dkaUIX28tNqMZ5ED7zq/i5J8cD/Y6QYKLdSSNTW1IsD5ufCrfo/mcBKkoF+jjuOvLGZQWsOS64OKEtx6kSfuf2IRQ=
Received: from MN2PR06MB5806.namprd06.prod.outlook.com (20.179.145.207) by
 MN2PR06MB6192.namprd06.prod.outlook.com (20.178.247.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1813.12; Mon, 22 Apr 2019 02:47:28 +0000
Received: from MN2PR06MB5806.namprd06.prod.outlook.com
 ([fe80::1ca6:d3b:6b7a:65cb]) by MN2PR06MB5806.namprd06.prod.outlook.com
 ([fe80::1ca6:d3b:6b7a:65cb%5]) with mapi id 15.20.1813.017; Mon, 22 Apr 2019
 02:47:28 +0000
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
Subject: [PATCH] brcmfmac: remove the duplicate line of sending mail box
 interrupt
Thread-Topic: [PATCH] brcmfmac: remove the duplicate line of sending mail box
 interrupt
Thread-Index: AQHU+LW5CM9dcu+U8kq8oKEmsooSEw==
Date:   Mon, 22 Apr 2019 02:47:28 +0000
Message-ID: <1555901236-145920-1-git-send-email-wright.feng@cypress.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR03CA0032.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::45) To MN2PR06MB5806.namprd06.prod.outlook.com
 (2603:10b6:208:127::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Wright.Feng@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.1.0
x-originating-ip: [12.110.209.245]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 51c87ee6-c396-44f1-b49b-08d6c6ccdb99
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:MN2PR06MB6192;
x-ms-traffictypediagnostic: MN2PR06MB6192:
x-microsoft-antispam-prvs: <MN2PR06MB61926F61AD2186893E7D860EFB220@MN2PR06MB6192.namprd06.prod.outlook.com>
x-forefront-prvs: 00159D1518
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(39860400002)(366004)(136003)(346002)(396003)(189003)(199004)(71190400001)(6636002)(71200400001)(110136005)(54906003)(6486002)(2906002)(6436002)(97736004)(66066001)(6116002)(2501003)(305945005)(7736002)(316002)(3846002)(14454004)(6512007)(25786009)(72206003)(478600001)(53936002)(44832011)(66446008)(86362001)(486006)(66556008)(476003)(6506007)(102836004)(386003)(73956011)(50226002)(5660300002)(64756008)(66476007)(66946007)(4744005)(36756003)(99286004)(81156014)(81166006)(186003)(14444005)(8676002)(2616005)(26005)(8936002)(256004)(68736007)(52116002)(2201001)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR06MB6192;H:MN2PR06MB5806.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: qXKVCnX0IoRco0OJy0ciMYFQYeIjWhySmNHFzdeN0a3C/91Xcz0HiqXxsEC93eEvwlrtloRKQgTtAIGPgMVmLE417Oh6n8JIuJZD6Wk+numAaydgjpeMlmPXpn55Wi3nwtrwWNlGRyPv8myYS3xqNaRQ93zDxpGmY5tNRH6ROKUU62C2qBQnVhTwOrZwB6QyAy7gUIqxKdb+jjGJ+kX0g9vvusKhoKuNA1T4ZbfUF7BkW1jckf13cj4Cr4JkO6XITlGxsAVxeQ+IFsjtACMMiQU6aEoWUahujfgnO0W1PdRIDHMN6hbknsbsb0YK6hyFg8bWihKR+GHEIXoqk+qwJwZYZ3SJ9BIonnlnaY11RF/5ZgEcyw4EgPaEOkDoAbIoyrTx/IR6XFIjc456m/P89a4rM8xxaojlfeF1O6jVst4=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51c87ee6-c396-44f1-b49b-08d6c6ccdb99
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2019 02:47:28.2627
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR06MB6192
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

VGhlIGxpbmUgaXMgZHVwbGljYXRlIHNvIHJlbW92ZSBpdCBmcm9tIHBjaWUuYy4gV2UgZG9uJ3Qg
bmVlZCB0byBzZW5kDQpob3N0IHRvIGRvbmdsZSBtYWlsIGJveCBpbnRlcnJ1cHQgdHdpY2UgYWZ0
ZXIgd3JpdGluZyBkYXRhLg0KDQpTaWduZWQtb2ZmLWJ5OiBXcmlnaHQgRmVuZyA8d3JpZ2h0LmZl
bmdAY3lwcmVzcy5jb20+DQotLS0NCiBkcml2ZXJzL25ldC93aXJlbGVzcy9icm9hZGNvbS9icmNt
ODAyMTEvYnJjbWZtYWMvcGNpZS5jIHwgMSAtDQogMSBmaWxlIGNoYW5nZWQsIDEgZGVsZXRpb24o
LSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2Jyb2FkY29tL2JyY204MDIx
MS9icmNtZm1hYy9wY2llLmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9icm9hZGNvbS9icmNtODAy
MTEvYnJjbWZtYWMvcGNpZS5jDQppbmRleCBmZDM5NjhmLi5jYTYxOWE5IDEwMDY0NA0KLS0tIGEv
ZHJpdmVycy9uZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL3BjaWUuYw0K
KysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL3Bj
aWUuYw0KQEAgLTY5OCw3ICs2OTgsNiBAQCBicmNtZl9wY2llX3NlbmRfbWJfZGF0YShzdHJ1Y3Qg
YnJjbWZfcGNpZWRldl9pbmZvICpkZXZpbmZvLCB1MzIgaHRvZF9tYl9kYXRhKQ0KIA0KIAlicmNt
Zl9wY2llX3dyaXRlX3RjbTMyKGRldmluZm8sIGFkZHIsIGh0b2RfbWJfZGF0YSk7DQogCXBjaV93
cml0ZV9jb25maWdfZHdvcmQoZGV2aW5mby0+cGRldiwgQlJDTUZfUENJRV9SRUdfU0JNQlgsIDEp
Ow0KLQlwY2lfd3JpdGVfY29uZmlnX2R3b3JkKGRldmluZm8tPnBkZXYsIEJSQ01GX1BDSUVfUkVH
X1NCTUJYLCAxKTsNCiANCiAJcmV0dXJuIDA7DQogfQ0KLS0gDQoyLjEuMA0KDQo=
