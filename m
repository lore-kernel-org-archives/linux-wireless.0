Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BD83C10F03
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 03:37:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B00A4214AE
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 03:37:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="YjOup/4Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388994AbfDYDhW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Apr 2019 23:37:22 -0400
Received: from mail-eopbgr710115.outbound.protection.outlook.com ([40.107.71.115]:28437
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388508AbfDYDhV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Apr 2019 23:37:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LCe1hkvG+Hij+WFf4A/3G//El9pfhCTtQN6FXuwXWRA=;
 b=YjOup/4ZDilEth02UvTWztVd24AO+yPrgm+iXmDGUVU/iT524Pw+Dr7mgbq2YOldCEaRZgAH10kXO3uuYQnSemKXTtFHWeiIuy55huxdXwOz06TrRjLTegDTYfD3Ll48irONOKrhHoravs2OxOdxC6LKNasrBVmdpPBL78FxOlM=
Received: from MN2PR06MB5806.namprd06.prod.outlook.com (20.179.145.207) by
 MN2PR06MB5424.namprd06.prod.outlook.com (20.178.240.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1813.12; Thu, 25 Apr 2019 03:37:17 +0000
Received: from MN2PR06MB5806.namprd06.prod.outlook.com
 ([fe80::1ca6:d3b:6b7a:65cb]) by MN2PR06MB5806.namprd06.prod.outlook.com
 ([fe80::1ca6:d3b:6b7a:65cb%5]) with mapi id 15.20.1813.017; Thu, 25 Apr 2019
 03:37:17 +0000
From:   Wright Feng <Wright.Feng@cypress.com>
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>,
        "franky.lin@broadcom.com" <franky.lin@broadcom.com>,
        "hante.meuleman@broadcom.com" <hante.meuleman@broadcom.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>
Subject: Re: [PATCH] brcmfmac: remove the duplicate line of sending mail box
 interrupt
Thread-Topic: [PATCH] brcmfmac: remove the duplicate line of sending mail box
 interrupt
Thread-Index: AQHU+LW5CM9dcu+U8kq8oKEmsooSE6ZKyn6AgAA4bQCAATv5gA==
Date:   Thu, 25 Apr 2019 03:37:16 +0000
Message-ID: <f25a4565-ef2e-4a1d-bd5b-76b3192eee50@cypress.com>
References: <1555901236-145920-1-git-send-email-wright.feng@cypress.com>
 <16a4dcd3418.2764.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
 <164b59e8-633b-84cc-179f-9bdd7ec696a7@broadcom.com>
In-Reply-To: <164b59e8-633b-84cc-179f-9bdd7ec696a7@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: TY1PR01CA0150.jpnprd01.prod.outlook.com
 (2603:1096:402:1::26) To MN2PR06MB5806.namprd06.prod.outlook.com
 (2603:10b6:208:127::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Wright.Feng@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [61.222.14.99]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 499e0056-9571-44a4-48bf-08d6c92f5020
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:MN2PR06MB5424;
x-ms-traffictypediagnostic: MN2PR06MB5424:
x-microsoft-antispam-prvs: <MN2PR06MB54247312009FCAE5AEC7933BFB3D0@MN2PR06MB5424.namprd06.prod.outlook.com>
x-forefront-prvs: 0018A2705B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(39860400002)(136003)(396003)(366004)(51914003)(189003)(199004)(6486002)(5660300002)(76176011)(316002)(71200400001)(256004)(4326008)(25786009)(229853002)(186003)(73956011)(71190400001)(305945005)(7736002)(6636002)(6436002)(6246003)(110136005)(14444005)(99286004)(6512007)(81156014)(53936002)(66446008)(54906003)(8936002)(66476007)(8676002)(66556008)(66946007)(64756008)(52116002)(72206003)(476003)(478600001)(14454004)(6116002)(86362001)(66066001)(486006)(81166006)(68736007)(2201001)(3846002)(11346002)(31696002)(36756003)(2616005)(6506007)(102836004)(26005)(53546011)(386003)(2501003)(31686004)(97736004)(446003)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR06MB5424;H:MN2PR06MB5806.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: X8LHTd3mT9MARxaYOu7zjky1zCLBoqT7XRjsQd18ADEhyvbBkJD/M4SrVX3iBljrYHtXu7dXUzzwOebSI3xrQ5JcaXpHqlTFvlVqIT27CmtOpL6QvRObJq47x3dVVGOW4AGwQpn0xfSW777N3bpgxpVeg1OS0a747VBc4j+RnPv8GMchwOxArx5K5qDo3wkRFitaLlK0vuMxNzSgSqBrIUjUkAsTyD8w3BETIwMm3qbEpGKxr4uKZA5pFkH6ppKTmG87Ic4zOYmOaW3phLFKAT9y6jfCGAz45e0jQItt9Azw86KfpackpmxgWJSeTRwhPRyhT1V3c1IjeT0uyXNGds/TKEjsQyPDLgZkuk8iSpb9hCDGBXrGcbcaKCGOb/fJhN0/iaYX4+7KyS+bUuxMNm5jSzXoiGSb6jE3toYstCk=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C7343BACCF7C76438B9E43F44577F49C@namprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 499e0056-9571-44a4-48bf-08d6c92f5020
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2019 03:37:16.8355
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR06MB5424
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

DQoNCk9uIDIwMTkvNC8yNCDkuIvljYggMDQ6NDYsIEFyZW5kIFZhbiBTcHJpZWwgd3JvdGU6DQo+
IE9uIDQvMjQvMjAxOSA3OjI0IEFNLCBBcmVuZCBWYW4gU3ByaWVsIHdyb3RlOg0KPj4gT24gQXBy
aWwgMjIsIDIwMTkgNDo0NzozMSBBTSBXcmlnaHQgRmVuZyA8V3JpZ2h0LkZlbmdAY3lwcmVzcy5j
b20+IHdyb3RlOg0KPj4NCj4+PiBUaGUgbGluZSBpcyBkdXBsaWNhdGUgc28gcmVtb3ZlIGl0IGZy
b20gcGNpZS5jLiBXZSBkb24ndCBuZWVkIHRvIHNlbmQNCj4+PiBob3N0IHRvIGRvbmdsZSBtYWls
IGJveCBpbnRlcnJ1cHQgdHdpY2UgYWZ0ZXIgd3JpdGluZyBkYXRhLg0KPj4NCj4+IEhpIFdyaWdo
dCwNCj4+DQo+PiBUaGFua3MgZm9yIHRoZSBwYXRjaC4gSSBhbSBhIGJpdCBlYXJseSBhcyBpdCBp
cyBub3QgdW5jb21tb24gdGhhdCANCj4+IGhhcmR3YXJlIHJlcXVpcmVzIGFuIGV4dHJhIGtpY2su
IE1pZ2h0IGJlIHRoZSBjYXNlIGhlcmUgZm9yIHNvbWUgDQo+PiBjaGlwcy4gV2lsbCBmb2xsb3ct
dXAgb24gaXQuDQo+IA0KPiBIaSBXcmlnaHQsDQo+IA0KPiBJIGNoZWNrZWQgaW4gb3VyIGRoZCBk
cml2ZXIgY29kZSBhbmQgaXQgYWxzbyBkb2VzIGEgZG91YmxlIHdyaXRlLiBUdXJucyANCj4gb3V0
IHRvIGJlIGEgaGFyZHdhcmUgd29ya2Fyb3VuZCBzbyB3ZSBuZWVkIHRvIGtlZXAgdGhpcy4gSXQg
aXMgd29ydGggYSANCj4gY29tbWVudCB0aG91Z2guDQo+IA0KSGkgQXJlbmQsDQoNClRoYW5rcyBm
b3IgdGhlIGluZm9ybWF0aW9uLg0KTlhQIGFuZCBJIHdvcmtlZCBvbiBzdXNwZW5kL3Jlc3VtZSBz
dHJlc3MgdGVzdCBpc3N1ZSB3aXRoIDFGRCg0MzU5YjEpDQp0d28gbW9udGhzIGFnbywgYW5kIHdl
IGZvdW5kIG9uZSBvZiByb290IGNhdXNlIGlzIGR1cGxpY2F0ZSBtYWlsYm94DQppbnRlcnJ1cHQu
DQpJJ3ZlIGNoZWNrZWQgdGhlIGhpc3Rvcnkgb2YgdGhlIGhhcmR3YXJlIGlzc3VlIGludGVybmFs
bHksIGFuZCBpdCBzZWVtcyB0aGF0DQp0aGUgaXNzdWUgaXMgb25seSBvbiBQQ0lFR0VOMiByZXZp
c2lvbiAxIHRvIDEzLg0KU28gaXMgdGhhdCBva2F5IHdlIGNhbiBza2lwIHRoZSBoYXJkd2FyZSB3
b3JrYXJvdW5kIHdoZW4gUENJRUdFTjINCnJldmlzaW9uIGlzIGdyZWF0ZXIgdGhhbiAxMyBhbmQg
YWRkIHRoZSBjb21tZW50IG9uIGl0IGluIG15IHBhdGNoIHYyPw0KDQpSZWdhcmRzLA0KV3JpZ2h0
DQo+IFRoYW5rcywNCj4gQXJlbmQNCg==
