Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 526A3C10F0E
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 07:36:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 234FE2083E
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 07:36:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="PeTvfYOP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbfDIHg4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 03:36:56 -0400
Received: from mail-eopbgr810058.outbound.protection.outlook.com ([40.107.81.58]:51869
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726001AbfDIHgz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 03:36:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sAkLR4bUChppUGLyquX3xqgO/+Hjd4EVCok41jNT1dI=;
 b=PeTvfYOPTQQpVUo8hCVTNguCiK4CvYuelQULi8REwy+zAPANM6socU3jnfRZK+tflj2Tyqk8dTfcCUHBbbdY1hafV+qcTZjKpHauxFS7id4QScJ7wt0iIAIETw+zHwRg0r6hVXM5fnUiY4YoWBjhcpVO/HgBKOPTXuahxuqMH2E=
Received: from BL0PR05MB5156.namprd05.prod.outlook.com (20.177.242.11) by
 BL0PR05MB5618.namprd05.prod.outlook.com (10.167.240.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1792.11; Tue, 9 Apr 2019 07:36:36 +0000
Received: from BL0PR05MB5156.namprd05.prod.outlook.com
 ([fe80::fc36:5780:46d5:6142]) by BL0PR05MB5156.namprd05.prod.outlook.com
 ([fe80::fc36:5780:46d5:6142%5]) with mapi id 15.20.1792.009; Tue, 9 Apr 2019
 07:36:36 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB5103.namprd05.prod.outlook.com (20.177.250.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1792.8; Tue, 9 Apr 2019 07:35:07 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e%4]) with mapi id 15.20.1792.009; Tue, 9 Apr 2019
 07:35:07 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 0/3] qtnfmac: debugfs update and other misc fixes
Thread-Topic: [PATCH 0/3] qtnfmac: debugfs update and other misc fixes
Thread-Index: AQHU7qbBNj+E9e3c8UWEIt07lI0MnA==
Date:   Tue, 9 Apr 2019 07:35:07 +0000
Message-ID: <20190409073500.16402-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR08CA0016.namprd08.prod.outlook.com
 (2603:10b6:a03:100::29) To SN6PR05MB4928.namprd05.prod.outlook.com
 (2603:10b6:805:9d::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.11.0
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8601662e-8e98-45ae-e569-08d6bcbde338
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600139)(711020)(4605104)(2017052603328)(7193020);SRVR:SN6PR05MB5103;
x-ms-traffictypediagnostic: SN6PR05MB5103:|BL0PR05MB5618:
x-moderation-data: 4/9/2019 7:36:33 AM
x-microsoft-antispam-prvs: <BL0PR05MB5618B32AE3FFFBB47FDDE106A32D0@BL0PR05MB5618.namprd05.prod.outlook.com>
x-forefront-prvs: 000227DA0C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(39850400004)(346002)(396003)(376002)(189003)(199004)(106356001)(97736004)(316002)(105586002)(66066001)(2351001)(256004)(36756003)(6512007)(53936002)(2501003)(386003)(6116002)(52116002)(102836004)(71200400001)(71190400001)(99286004)(4326008)(3846002)(6506007)(1076003)(107886003)(14454004)(54906003)(478600001)(6436002)(6486002)(2616005)(2906002)(25786009)(186003)(86362001)(476003)(5640700003)(103116003)(50226002)(81166006)(26005)(6916009)(436003)(305945005)(7736002)(8676002)(8936002)(68736007)(81156014)(5660300002)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR05MB5618;H:BL0PR05MB5156.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: rbEQw6wbJ29H85ftCDduuTXgThNTlJXt9tJ6qcq39jbNW7EpJbl+I6QVeTjaU8a65k5eqyAWKRsFIsQikPFFe9rZY5O5jn3MS9LSCdo8+H/Yz4mmzZ3E/5fsHIJ21XfEJrZSV2UUSydkRdst6gmsXADLCNK32ygLXWMf8Bny+zDR+7VG1k2oi5csIoi7sGZfA2fuH3KxZH5ay2wvEykNHOE41JVnr67YffqyftvH7AdjSI9F7zLhoXepsL65+L81casjyaNT4p603A/+Y5VHNQmc1NT6z22YQq0Kv5hYMgHb27g9zzUfTC+qpjlXGvEG3IGFpwLf3y6NeN45rV7CXj6EBkwEHWq2O+itBS3Ir4ByY6Kc8Zkmf/mNPQJOopftX6s4XNIQi2+/8ioo8qVoPFaHHZmvb1cvGt1oZBrTgFM=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8601662e-8e98-45ae-e569-08d6bcbde338
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2019 07:36:36.0357
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB5618
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

SGVsbG8gS2FsbGUgYW5kIGFsbCwNCg0KSGVyZSBpcyB0aGUgcGF0Y2ggc2V0IHdpdGggbWlub3Ig
Zml4ZXMgYW5kIGVuaGFuY2VtZW50cyBmb3IgcXRuZm1hYyBkcml2ZXIsDQp0aGF0IHdlcmUgbm90
IGluY2x1ZGVkIGludG8gdGhlIHByZXZpb3VzIGxhcmdlciBzZXJpZXMuDQoNClRoZSBtYWpvciBj
aGFuZ2VzIGluY2x1ZGUgdGhlIGZvbGxvd2luZyBpdGVtczoNCi0gdXBkYXRpbmcgZGVidWdmcyBz
dHJ1Y3R1cmUgdG8gc3VwcG9ydCBtdWx0aXBsZSBjYXJkcyBvbiBhIHNpbmdsZSBob3N0DQotIGFk
ZCBrZXJuZWwgbW9kdWxlIHBhcmFtIHRvIGNvbnRyb2wgREZTIHNsYXZlIHJhZGFyIGRldGVjdGlv
biBiZWhhdmlvcg0KDQpSZWdhcmRzLA0KU2VyZ2V5DQoNCg0KSWdvciBNaXRzeWFua28gKDEpOg0K
ICBxdG5mbWFjOiBhbGxvdyB0byBjb250cm9sIERGUyBzbGF2ZSByYWRhciBkZXRlY3Rpb24NCg0K
U2VyZ2V5IE1hdHl1a2V2aWNoICgyKToNCiAgcXRuZm1hYzogaGFuZGxlIGNoYW5uZWwgc3dpdGNo
IGV2ZW50cyBmb3IgY29ubmVjdGVkIHN0YXRpb25zIG9ubHkNCiAgcXRuZm1hYzogbW9kaWZ5IGRl
YnVnZnMgdG8gc3VwcG9ydCBtdWx0aXBsZSBjYXJkcw0KDQogZHJpdmVycy9uZXQvd2lyZWxlc3Mv
cXVhbnRlbm5hL3F0bmZtYWMvY2ZnODAyMTEuYyB8ICAyICstDQogZHJpdmVycy9uZXQvd2lyZWxl
c3MvcXVhbnRlbm5hL3F0bmZtYWMvY29tbWFuZHMuYyB8ICA0ICsrLQ0KIGRyaXZlcnMvbmV0L3dp
cmVsZXNzL3F1YW50ZW5uYS9xdG5mbWFjL2NvbW1hbmRzLmggfCAgMyArLQ0KIGRyaXZlcnMvbmV0
L3dpcmVsZXNzL3F1YW50ZW5uYS9xdG5mbWFjL2NvcmUuYyAgICAgfCAzNSArKysrKysrKysrKysr
KysrKysrKysrKw0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3F1YW50ZW5uYS9xdG5mbWFjL2NvcmUu
aCAgICAgfCAgMiArKw0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3F1YW50ZW5uYS9xdG5mbWFjL2Rl
YnVnLmMgICAgfCAgNCArKy0NCiBkcml2ZXJzL25ldC93aXJlbGVzcy9xdWFudGVubmEvcXRuZm1h
Yy9ldmVudC5jICAgIHwgMTYgKysrKysrKy0tLS0NCiBkcml2ZXJzL25ldC93aXJlbGVzcy9xdWFu
dGVubmEvcXRuZm1hYy9xbGluay5oICAgIHwgIDQgKystDQogOCBmaWxlcyBjaGFuZ2VkLCA2MCBp
bnNlcnRpb25zKCspLCAxMCBkZWxldGlvbnMoLSkNCg0KLS0gDQoyLjExLjANCg0K
