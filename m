Return-Path: <SRS0=mfDp=N2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CD1DC43441
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Nov 2018 08:08:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3FCB223CB
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Nov 2018 08:08:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="xV4Hk9eA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B3FCB223CB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728519AbeKOSPk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 15 Nov 2018 13:15:40 -0500
Received: from mail-eopbgr790124.outbound.protection.outlook.com ([40.107.79.124]:16785
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728280AbeKOSPk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Nov 2018 13:15:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OtIO557EYHbgKfkFEHqibx66wp9OqiowqL9p7ladfV8=;
 b=xV4Hk9eA4sl6bJxP6X+Sn/uhoycJxOAK/Vy2UVduaP3YxGBC0wNmyHSq4GIcm53fKjbhZm5k2NEGopP/x+mO5Fr4pYZwC9PKS66zJcA9vbdfL3MjyqJQglBnwwoAfD2g5Jsm2W1SqSn4Y8l2eihfRKgL9DmE1znKTTCDVGvJ67s=
Received: from BYAPR06MB3992.namprd06.prod.outlook.com (52.135.200.22) by
 BYAPR06MB4551.namprd06.prod.outlook.com (52.135.233.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.28; Thu, 15 Nov 2018 08:08:51 +0000
Received: from BYAPR06MB3992.namprd06.prod.outlook.com
 ([fe80::2147:2944:5ff:e986]) by BYAPR06MB3992.namprd06.prod.outlook.com
 ([fe80::2147:2944:5ff:e986%3]) with mapi id 15.20.1294.045; Thu, 15 Nov 2018
 08:08:51 +0000
From:   Wright Feng <Wright.Feng@cypress.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Double Lo <Double.Lo@cypress.com>,
        Madhan Mohan R <MadhanMohan.R@cypress.com>
Subject: Re: [PATCH V2 8/8] brcmfmac: disable command decode in sdio_aos
Thread-Topic: [PATCH V2 8/8] brcmfmac: disable command decode in sdio_aos
Thread-Index: AQHUelmHUuhQfMYWHUCpxi6O/o91vqVL8bmAgASOaQA=
Date:   Thu, 15 Nov 2018 08:08:51 +0000
Message-ID: <8f006c17-6ffa-5d1e-592f-11def51c11a6@cypress.com>
References: <1542007730-47284-1-git-send-email-chi-hsien.lin@cypress.com>
 <1542007730-47284-9-git-send-email-chi-hsien.lin@cypress.com>
 <45d702d0-9761-add6-5ae1-97c1ebdef331@broadcom.com>
In-Reply-To: <45d702d0-9761-add6-5ae1-97c1ebdef331@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: TYAPR03CA0011.apcprd03.prod.outlook.com
 (2603:1096:404:14::23) To BYAPR06MB3992.namprd06.prod.outlook.com
 (2603:10b6:a02:90::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Wright.Feng@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [61.222.14.99]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR06MB4551;6:L2blvzv2+DD3ZLFF/9nWu06fxvpUCq5uaLdDcAISgylGT9eGp6kf4s9W+LMLrV2zjrq2vnLcKSMdj5ET/mdcW8fGAFJBMcS0oTQIdLo4kp1/+eBTFlD3B6/bdGm0WulMZGoOBVXHyVqoFhQDAxNTDGl9i4XRJeyeRVIFa0V4OIh8l20h4/eZiLy1TgPLg3ItUfWPzLRvuKpNLooRxRosNWYqpti4EBNSy+/fXc87BZISidheEEV1OXitWQFMLZ/IZvgzEbJQTKiGvaDhf6CQ3gLnf42yZT8hFARwt7Z1MuIgaOUbPx4F3kdd1LRs0y6N+g5vfgpjbAn8WJgshcTCQN0MkT8kj29n0hgT5/rGSwAWz5BTK+s3pCMiHmz1BbWqkr1i3VexgIuz8sRJtWgDC/mgWZGzSBXworSw3SFVW8QRjWvzB7s1yiJb8dVLlZbgN9FMRIth6bvCk7f8snZ81g==;5:nsyiVOPHkrFdzsVzYkreu7tpojtwUwFOUBe4AXlzB0ccrgOZirL66f8mkRHOk2HrczYh0K8eHvxVyMIh/frv9T52awznIEIE14TLbvsmEdUQRLBDLPBVsb8h5L/3Hz9BcDWX+0ITPcvxv9LyZEZNGD2zKFRwOTZT5xT7opbvwTk=;7:S8jgAr6TcXMWd04stQJiRh8q37o4D+A4uVEShlpTL+mubC3wsiW6nMe+qJYB2jsM+mZUhPJppO6Ln16E7rjn+h30gC9WxD1QhesEV8UVJW7eEP9qyjodDCewx1LzFB6AmrJPqS6FJUBg+QiIznWbNQ==
x-ms-office365-filtering-correlation-id: 66abc423-76db-413b-fd04-08d64ad19381
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(5600074)(711020)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BYAPR06MB4551;
x-ms-traffictypediagnostic: BYAPR06MB4551:
x-microsoft-antispam-prvs: <BYAPR06MB455157648844D110D5EB1499FBDC0@BYAPR06MB4551.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(258095267146985);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(10201501046)(93006095)(93001095)(3231415)(944501410)(52105112)(3002001)(6055026)(148016)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(20161123558120)(20161123560045)(20161123562045)(201708071742011)(7699051)(76991095);SRVR:BYAPR06MB4551;BCL:0;PCL:0;RULEID:;SRVR:BYAPR06MB4551;
x-forefront-prvs: 08572BD77F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(39860400002)(136003)(346002)(376002)(366004)(189003)(199004)(2501003)(66066001)(2900100001)(5660300001)(97736004)(99286004)(86362001)(76176011)(6506007)(386003)(53546011)(476003)(2616005)(11346002)(551934003)(486006)(14444005)(256004)(72206003)(2906002)(52116002)(102836004)(446003)(14454004)(31696002)(54906003)(229853002)(31686004)(316002)(81166006)(81156014)(6116002)(7736002)(478600001)(26005)(110136005)(186003)(8936002)(305945005)(3846002)(71190400001)(8676002)(71200400001)(53936002)(107886003)(6246003)(106356001)(6436002)(105586002)(68736007)(25786009)(4326008)(36756003)(6512007)(6486002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR06MB4551;H:BYAPR06MB3992.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: z8M34b128Bixa16D9qRfTNeTYEL9LQ6mX2LNH9ERC9uQ1n2om2jlgDGnrhllA+dy+IDLEMx5rcQU9r5x/QfWI1g1JUpqB4IqXIv2YBA6LPk7Q1PHyUkNiOMi/Nnok4Hja40YBB/+rte6OTB8llQtSOfTTV6H5oofTFmpvpjwe53fu6D41gPaqejDJdIqNNkz2TKflIM6z2RiwELmZfpOBTjezTPMYVJ0NW6iSY1Nh4zgM5Mbmw75ez1mRjiOe9K18YEAvf7YzTYZitjD6rJ8x2d4ISOpnIcP8PuoMa+mz5fnVHB5UyQcB51IIUDPIaGU4B3TPWa1jE5leH4y4ZfkmnEtPQZWhKqxwOgMVMp0XtU=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <6937CBCF2778DA4EA0F210BD91143DF1@namprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66abc423-76db-413b-fd04-08d64ad19381
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2018 08:08:51.0393
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR06MB4551
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

DQoNCk9uIDIwMTgvMTEvMTIg5LiL5Y2IIDA2OjMzLCBBcmVuZCB2YW4gU3ByaWVsIHdyb3RlOg0K
PiBPbiAxMS8xMi8yMDE4IDg6MzAgQU0sIENoaS1Ic2llbiBMaW4gd3JvdGU6DQo+PiBGcm9tOiBX
cmlnaHQgRmVuZyA8d3JpZ2h0LmZlbmdAY3lwcmVzcy5jb20+DQo+Pg0KPj4gQU9TIGlzIGEgcGFy
dCBvZiB0aGUgU0RJT0QgY29yZSB0aGF0IGJlY29tZXMgYWN0aXZlIHdoZW4gdGhlIHJlc3Qgb2YN
Cj4+IFNESU9EIGlzIHNsZWVwaW5nIHRvIGtlZXAgU0RJTyBidXMgYWxpdmUgcmVzcG9uZGluZyB0
byByZWR1Y2VkIHNldCBvZg0KPj4gY29tbWFuZHMuDQo+Pg0KPj4gVHJhbnNhY3Rpb24gYmV0d2Vl
biBBT1MgYW5kIFNESU9EIGlzIG5vdCBwcm90ZWN0ZWQsIGFuZCBpZiBjbWQgNTIgaXMNCj4+IHJl
Y2VpdmVkIGluIEFPUyBhbmQgaW4gdGhlIG1pZGRsZSBvZiByZXNwb25zZSBzdGF0ZSBjaGFuZ2Vk
IGZyb20gQU9TIHRvDQo+PiBTRElPRCwgcmVzcG9uc2UgaXMgY29ycnVwdGVkIGFuZCBpdCBjYXVz
ZXMgdG8gU0RJTyBIb3N0IGNvbnRyb2xsZXIgdG8NCj4+IGhhbmcuDQo+IA0KPiBKdXN0IG9uZSBx
dWVzdGlvbi4gVGhlIGFib3ZlIHNvdW5kIHByZXR0eSBnZW5lcmljIHNvIGRvZXMgaXQgYXBwbHkg
dG8NCj4gYW55IFNESU8gY2hpcCB3aXRoIEFPUyBsb2dpYz8NCj4gDQpXZSBmb3VuZCB0aGlzIGlz
c3VlIHdoZW4gdmVyaWZ5aW5nIFNSIGZlYXR1cmUgd2l0aCBzb21lIFNESU8gY2FyZHMod2hhdA0K
d2UgaGFkKSwgbm90IHN1cmUgd2hldGhlciBldmVyeSBTRElPIGNhcmQgaGFzIHNhbWUgcHJvYmxl
bS4gU28gd2UNCm9ubHkgY2hhbmdlIHRob3NlIGNoaXAncyB3YWtlLXVwIG1lY2hhbmlzbSB0byBu
b0NtZERlY29kZSBtb2RlIGFuZCBsZXQNClNESU9EX0FPUyBqdXN0IGdlbmVyYXRlcyBhIHdha2Ut
dXAgcmVxdWVzdCB3aXRob3V0IHJlc3BvbmRpbmcuDQoNCi1XcmlnaHQNCj4gUmVnYXJkcywNCj4g
QXJlbmQNCj4gDQo+IA0KPiANCg0K
