Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14323C10F0E
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 07:36:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA9272083E
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 07:36:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="oLr7+Gl8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbfDIHgp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 03:36:45 -0400
Received: from mail-eopbgr710070.outbound.protection.outlook.com ([40.107.71.70]:11174
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726001AbfDIHgo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 03:36:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SCNIeg9obs4PXCejsFu3FGe7uDvz6JZwTevxDBVOS8E=;
 b=oLr7+Gl8+PSFo/P4eda8tj8xipOQV0rCf4Fyqkvp/hBANK0KwZrTsDL0Wtzi/fZxcOjBtK6AYwhNLKDFSddGlrokpB7DhyneMlV7caUhmT+f1VIqN2PHTnMpciOML3Vbx/o7MKJBLBm0DjUlzKVcy0ZJiSwz2MdACNhNBxhtQaw=
Received: from DM6PR05MB4284.namprd05.prod.outlook.com (20.176.78.21) by
 DM6PR05MB6010.namprd05.prod.outlook.com (20.178.29.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1792.14; Tue, 9 Apr 2019 07:36:36 +0000
Received: from DM6PR05MB4284.namprd05.prod.outlook.com
 ([fe80::bcb5:51c1:9a74:1aa]) by DM6PR05MB4284.namprd05.prod.outlook.com
 ([fe80::bcb5:51c1:9a74:1aa%2]) with mapi id 15.20.1792.009; Tue, 9 Apr 2019
 07:36:35 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB5103.namprd05.prod.outlook.com (20.177.250.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1792.8; Tue, 9 Apr 2019 07:35:09 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e%4]) with mapi id 15.20.1792.009; Tue, 9 Apr 2019
 07:35:09 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 1/3] qtnfmac: handle channel switch events for connected
 stations only
Thread-Topic: [PATCH 1/3] qtnfmac: handle channel switch events for connected
 stations only
Thread-Index: AQHU7qbCco7z937WgE+zPUrTfnDjJA==
Date:   Tue, 9 Apr 2019 07:35:08 +0000
Message-ID: <20190409073500.16402-2-sergey.matyukevich.os@quantenna.com>
References: <20190409073500.16402-1-sergey.matyukevich.os@quantenna.com>
In-Reply-To: <20190409073500.16402-1-sergey.matyukevich.os@quantenna.com>
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
x-ms-office365-filtering-correlation-id: d9702b47-1b38-4bb0-ed35-08d6bcbde452
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600139)(711020)(4605104)(2017052603328)(7193020);SRVR:SN6PR05MB5103;
x-ms-traffictypediagnostic: SN6PR05MB5103:|DM6PR05MB6010:
x-moderation-data: 4/9/2019 7:36:34 AM
x-microsoft-antispam-prvs: <DM6PR05MB60108929B8AAAB0916A14C97A32D0@DM6PR05MB6010.namprd05.prod.outlook.com>
x-forefront-prvs: 000227DA0C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(376002)(346002)(366004)(39850400004)(136003)(189003)(199004)(7736002)(106356001)(5640700003)(52116002)(446003)(107886003)(486006)(105586002)(6436002)(66066001)(6486002)(53936002)(305945005)(103116003)(476003)(6512007)(6916009)(2351001)(186003)(4326008)(54906003)(25786009)(86362001)(316002)(11346002)(5660300002)(436003)(2616005)(99286004)(81166006)(386003)(81156014)(1076003)(2501003)(8676002)(478600001)(6506007)(26005)(8936002)(256004)(14444005)(3846002)(6116002)(102836004)(2906002)(50226002)(76176011)(68736007)(14454004)(36756003)(71190400001)(71200400001)(97736004);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR05MB6010;H:DM6PR05MB4284.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: xB4X0W2knUod3VxLHjPP2w+71TqNKnmd8cfnsRiZjOseg5jv7q0/BKFcEfjNJrmlPd2DJtlr1t35sU/dTARRbS2v0r5NxIsca+Evyoy3yACbWwJRHoBGmjNYuVZ0OaBgSmX3R7belfGrJ/2prHIGUJ/DlgjE1RIuVdGO0tFUndwEBlstqVssC3eBHznOCcxPiuDOTN56AtvdIB9fstdwkgCt2f0QPmESJzYNX8ARo2LLl8kKTru+0eevsI+ui1ru5/C87MC2P2d5h3R9rIZOe0wpUBy6nrBt5uVcsVPLSh/mCoGwI6f5gtdKhuzzUM7LNxa3v2rSZMRmAVTdNiy8OCs8upan03Vs3ICKwxJ27Pl7KPOD15KZRuJLLYtJyOa4ORnjjGGs8gnEb+EAF//88Jv60PHOD3jUqtHeQ19h3sk=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9702b47-1b38-4bb0-ed35-08d6bcbde452
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2019 07:36:35.8303
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR05MB6010
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Q2hhbm5lbCBzd2l0Y2ggZXZlbnRzIGZyb20gZmlybXdhcmUgc2hvdWxkIGJlIHByb2Nlc3NlZCBv
bmx5IHdoZW4gU1RBDQppcyBhbHJlYWR5IGNvbm5lY3RlZCB0byBCU1MuIE9uIGNvbm5lY3QgdGhp
cyBub3RpZmljYXRpb24gaXMgbm90IG5lZWRlZA0Kc2luY2UgZnVsbCBCU1MgaW5mbyB3aWxsIGJl
IHN1cHBsaWVkIGJ5IGNmZzgwMjExX2Nvbm5lY3RfcmVzdWx0Lg0KDQpTaWduZWQtb2ZmLWJ5OiBT
ZXJnZXkgTWF0eXVrZXZpY2ggPHNlcmdleS5tYXR5dWtldmljaC5vc0BxdWFudGVubmEuY29tPg0K
LS0tDQogZHJpdmVycy9uZXQvd2lyZWxlc3MvcXVhbnRlbm5hL3F0bmZtYWMvZXZlbnQuYyB8IDE2
ICsrKysrKysrKysrLS0tLS0NCiAxIGZpbGUgY2hhbmdlZCwgMTEgaW5zZXJ0aW9ucygrKSwgNSBk
ZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3F1YW50ZW5u
YS9xdG5mbWFjL2V2ZW50LmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9xdWFudGVubmEvcXRuZm1h
Yy9ldmVudC5jDQppbmRleCA2YzFiODg2MzM5YWMuLmI1N2M4YzE4YThkMCAxMDA2NDQNCi0tLSBh
L2RyaXZlcnMvbmV0L3dpcmVsZXNzL3F1YW50ZW5uYS9xdG5mbWFjL2V2ZW50LmMNCisrKyBiL2Ry
aXZlcnMvbmV0L3dpcmVsZXNzL3F1YW50ZW5uYS9xdG5mbWFjL2V2ZW50LmMNCkBAIC00OTMsMTQg
KzQ5MywyMCBAQCBxdG5mX2V2ZW50X2hhbmRsZV9mcmVxX2NoYW5nZShzdHJ1Y3QgcXRuZl93bWFj
ICptYWMsDQogDQogCWZvciAoaSA9IDA7IGkgPCBRVE5GX01BWF9JTlRGOyBpKyspIHsNCiAJCXZp
ZiA9ICZtYWMtPmlmbGlzdFtpXTsNCisNCiAJCWlmICh2aWYtPndkZXYuaWZ0eXBlID09IE5MODAy
MTFfSUZUWVBFX1VOU1BFQ0lGSUVEKQ0KIAkJCWNvbnRpbnVlOw0KIA0KLQkJaWYgKHZpZi0+bmV0
ZGV2KSB7DQotCQkJbXV0ZXhfbG9jaygmdmlmLT53ZGV2Lm10eCk7DQotCQkJY2ZnODAyMTFfY2hf
c3dpdGNoX25vdGlmeSh2aWYtPm5ldGRldiwgJmNoYW5kZWYpOw0KLQkJCW11dGV4X3VubG9jaygm
dmlmLT53ZGV2Lm10eCk7DQotCQl9DQorCQlpZiAodmlmLT53ZGV2LmlmdHlwZSA9PSBOTDgwMjEx
X0lGVFlQRV9TVEFUSU9OICYmDQorCQkgICAgIXZpZi0+d2Rldi5jdXJyZW50X2JzcykNCisJCQlj
b250aW51ZTsNCisNCisJCWlmICghdmlmLT5uZXRkZXYpDQorCQkJY29udGludWU7DQorDQorCQlt
dXRleF9sb2NrKCZ2aWYtPndkZXYubXR4KTsNCisJCWNmZzgwMjExX2NoX3N3aXRjaF9ub3RpZnko
dmlmLT5uZXRkZXYsICZjaGFuZGVmKTsNCisJCW11dGV4X3VubG9jaygmdmlmLT53ZGV2Lm10eCk7
DQogCX0NCiANCiAJcmV0dXJuIDA7DQotLSANCjIuMTEuMA0KDQo=
