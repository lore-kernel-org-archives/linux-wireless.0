Return-Path: <SRS0=E2P1=NN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 575B9C0044C
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 03:22:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED1752081B
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 03:22:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="lj0X1+hr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ED1752081B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbeKBM2C (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 2 Nov 2018 08:28:02 -0400
Received: from mail-co1nam03on0099.outbound.protection.outlook.com ([104.47.40.99]:27825
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726241AbeKBM2C (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Nov 2018 08:28:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VnGWaYczwSOOS2ThG/eHREXvs08PLJaHiBjKoBzGtsg=;
 b=lj0X1+hr5mNoCNPLHmqd2OeVkur4Djbb5XSc7UBLKgAvavIbtNi1WAdjqaMe6ghd2PqdW/U+jX3W3KklDwpdhwRQvQ5owhdWzzwQnOUhcs9rIF2CrvManWS7OBNkSG2G607MErirVDT8Wyu4YUqScGW42m5QFQUquldSJSyBTQw=
Received: from BYAPR06MB3992.namprd06.prod.outlook.com (52.135.200.22) by
 BYAPR06MB4565.namprd06.prod.outlook.com (52.135.233.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1273.21; Fri, 2 Nov 2018 03:22:24 +0000
Received: from BYAPR06MB3992.namprd06.prod.outlook.com
 ([fe80::2147:2944:5ff:e986]) by BYAPR06MB3992.namprd06.prod.outlook.com
 ([fe80::2147:2944:5ff:e986%3]) with mapi id 15.20.1294.024; Fri, 2 Nov 2018
 03:22:24 +0000
From:   Wright Feng <Wright.Feng@cypress.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "franky.lin@broadcom.com" <franky.lin@broadcom.com>,
        "hante.meuleman@broadcom.com" <hante.meuleman@broadcom.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>
Subject: Re: [PATCH 3/3] brcmfmac: make firmware frameburst mode a module
 parameter
Thread-Topic: [PATCH 3/3] brcmfmac: make firmware frameburst mode a module
 parameter
Thread-Index: AQHUb3H+Fs3IQIbeVESAT2P4l9cinqU3qdSAgAQtygA=
Date:   Fri, 2 Nov 2018 03:22:24 +0000
Message-ID: <a3111390-cc3e-f6b7-03cf-dcb86cf0d289@cypress.com>
References: <1540808552-28738-1-git-send-email-wright.feng@cypress.com>
 <1540808552-28738-4-git-send-email-wright.feng@cypress.com>
 <7292b499-96a6-96be-f9b7-e59df353427f@broadcom.com>
In-Reply-To: <7292b499-96a6-96be-f9b7-e59df353427f@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: KAWPR01CA0070.jpnprd01.prod.outlook.com
 (2603:1096:402:b::30) To BYAPR06MB3992.namprd06.prod.outlook.com
 (2603:10b6:a02:90::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Wright.Feng@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [61.222.14.99]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR06MB4565;6:DIlQTQqDtO1VpEZoOEVOQHMQvhQxC5STIjTznglq8LxJmLTn3AFPDDPlVlKi0iAdBRm7RHhNj85EcdWQnxTltWLwqkNSlx6F6JSdTuSUwskT1TzZj7pc8uKKbbsP31g/+sz57rVBlXYgAZCUmHyyFZJ2NGUqnHX+AEvfsVb3aE7V4Cpoz1yxrRnxim0U/Vad6r7FeL4upL9J8/8L1unWa4epr4aIIZtwlgyzNSKnvWs8H/chEzyKMO0iXDD/8OL8jLVHMe39YrjR570rkAMyeVtqIgLGe/ypL9xukeRZyhkqUTHPq3+B4yAdCIl1dUKXIeYRAYLQnTpmrUOQSDd3UK3m9vrI3X16Bj4tIHxQx6JM7pGWfcacCcunrGnIff3szW/f9ilwJuPMRZ8noh5R73VDblxPU4f/zldob/8uGMKLA+x6qP39nVPFF8pOuvf1TNR5hlmQh0YIOkchWFZpwg==;5:tigD+VLNysdBY0TEfsZ4GbjxElS4unCUMjy8ZWXCDiHXIqJt5TEgx60FYeDzZwf47Xq8aYONsweEgTSdC/qbMPvIYZOvuzsXmjPrPJq4IviHKSsjMpkCt45PCMOrfLq9O93Jy7cEo1GCJDOZNvnZZPDJnujvohFNuTOSjP4keM0=;7:nOd0JX1gIr1BhgDwjMR1yCQAXKLkyIWRMK9VREYNjOoW74zL11BvqmqnumcZjhAxNayETGVfLfpPbuTRaZTCqFIIsukU+g8Dye5YcPBLpMxAqNxdqKYuUGIWqlxemx5NspXMi5ytb5IJgFGwMzfIxw==
x-ms-office365-filtering-correlation-id: 26c3425c-a282-4153-979d-08d640726823
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:BYAPR06MB4565;
x-ms-traffictypediagnostic: BYAPR06MB4565:
x-microsoft-antispam-prvs: <BYAPR06MB4565A96A045A234960054321FBCF0@BYAPR06MB4565.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(258095267146985);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(10201501046)(3231382)(944501410)(52105095)(3002001)(93006095)(93001095)(6055026)(148016)(149066)(150057)(6041310)(20161123560045)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(20161123558120)(201708071742011)(7699051)(76991095);SRVR:BYAPR06MB4565;BCL:0;PCL:0;RULEID:;SRVR:BYAPR06MB4565;
x-forefront-prvs: 08444C7C87
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(346002)(39860400002)(136003)(376002)(189003)(199004)(446003)(2501003)(5660300001)(76176011)(305945005)(68736007)(102836004)(36756003)(2906002)(6512007)(186003)(53936002)(71190400001)(97736004)(53546011)(31686004)(71200400001)(229853002)(478600001)(26005)(6506007)(99286004)(8936002)(2900100001)(14454004)(4326008)(31696002)(86362001)(11346002)(6116002)(486006)(81166006)(316002)(256004)(81156014)(476003)(110136005)(386003)(6246003)(8676002)(54906003)(52116002)(6486002)(72206003)(66066001)(3846002)(6436002)(25786009)(7736002)(106356001)(105586002)(2616005);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR06MB4565;H:BYAPR06MB3992.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: NW6WeUcajFcdPWmJxBi1MYI1iRlM2nH5wTtLP3FI7J+UOIuCSVlHRsdcSx2frpCmApwaJUC04CLwQqzSL3HSeXgwMxjsTKEdTD1SS1i82MY/XkYyDq+MeljGkTFoHqZKIApDMegiRCH7vohOjbviyZNQcmCMcLPiN8d1Iy+f5MzxZ1AydqEkamhFe3GTMDlABOB5UAlbCv+FuPxe4hqTeyfxLQKY7RQsJY+s9+DfFXLQ693D4ZvrY4Itl02m9xM2ohXfRggaO3+sveXLWnfYB0wMh4S8Y2KGstFtMtDEiQHdqgcln4IleCWvGY58W/iZiuRpWongJIb/x8ciLWnxr+vEo8a9jb9+LF8JJ42I/E0=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <2350E5BD865BD149B19A23A72FCDD4EF@namprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26c3425c-a282-4153-979d-08d640726823
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2018 03:22:24.1179
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR06MB4565
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

DQoNCk9uIDIwMTgvMTAvMzAg5LiL5Y2IIDA3OjMzLCBBcmVuZCB2YW4gU3ByaWVsIHdyb3RlOg0K
PiBPbiAxMC8yOS8yMDE4IDExOjI3IEFNLCBXcmlnaHQgRmVuZyB3cm90ZToNCj4+IFRoaXMgcGF0
Y2ggaXMgZm9yIGFkZGluZyBhIG5ldyBtb2R1bGUgcGFyYW1ldGVyICJmcmFtZWJ1cnN0Ii4NCj4+
IFdpdGggc2V0dGluZyAiZnJhbWVidXJzdD0xIiBpbiBtb2R1bGUgcGFyYW1ldGVycywgZmlybXdh
cmUgZnJhbWVidXJzdCANCj4+IG1vZGUNCj4+IHdpbGwgYmUgZW5hYmxlZC4gVGhlIGZlYXR1cmUg
Y2FuIGVuYWJsZSBwZXItcGFja2V0IGZyYW1lYnVyc3RpbmcgaW4NCj4+IGZpcm13YXJlIHNpZGUg
YW5kIGdldCBoaWdoZXIgVFggdGhyb3VnaHB1dCBpbiBIaWdoIFRocm91Z2hwdXQoSFQpIG1vZGUu
DQo+IA0KPiBJIGFtIG5vdCBzdXJlIGFib3V0IGV2ZXJ5IGZpcm13YXJlIGltYWdlLCBidXQgaW4g
cmVjZW50IGJyYW5jaGVzIGhlcmUgSSANCj4gc2VlIGZpcm13YXJlIGVuYWJsZXMgZnJhbWVidXJz
dCBieSBkZWZhdWx0LiBTbyBub3Qgc3VyZSBhYm91dCB0aGUgDQo+IG1vdGl2YXRpb24gdG8gYWRk
IHRoaXMuIFlvdSBjb3VsZCBhbHNvIGNvbnNpZGVyIGFkZGluZyB0aGlzIHRvIHRoZSANCj4gbmw4
MDIxMSBhcGkuIEkgYW0gc3VyZSBvdGhlciB2ZW5kb3JzIGhhdmUgc2ltaWxhciBmZWF0dXJlcy4N
Cj4gDQo+IFJlZ2FyZHMsDQo+IEFyZW5kDQo+IA0KVGhlIG5ld2VyIGZpcm13YXJlIG1heSBzZXQg
ZmlybXdhcmUgYnkgZGVmYXVsdCwgYnV0IFNvbWUNCmZpcm13YXJlcyBpbiB1cHN0cmVhbSBkbyBu
b3QsIGxpa2UgNy4zNS4zNDkuMjggZm9yIDQzNTQtc2Rpby4NCg0KQmVmb3JlIGFkZGluZyBuZXcg
QVBJIGluIG9wcyBhbmQgQVRUUiBpbiBubDgwMjExLCBJIHRoaW5rIGtlZXBpbmcgdGhlDQpmcmFt
ZWJ1cnN0IG1vZHVsZSBwYXJhbWV0ZXIgaXMgZ29vZCBmb3IgdXNlciB0byBlbmhhbmNlIFRYIHRo
cm91Z2hwdXQuDQpBbmQgSSB3aWxsIGZpbmQgdGltZSB0byBhZGQgbmV3IEFQSSBhZnRlciBmaW5p
c2hpbmcgbXkgaW50ZXJuYWwgdGFzay4NCg0KLVdyaWdodA0KPj4gU2lnbmVkLW9mZi1ieTogV3Jp
Z2h0IEZlbmcgPHdyaWdodC5mZW5nQGN5cHJlc3MuY29tPg0KPj4gLS0tDQo+PiDCoGRyaXZlcnMv
bmV0L3dpcmVsZXNzL2Jyb2FkY29tL2JyY204MDIxMS9icmNtZm1hYy9jZmc4MDIxMS5jIHwgNyAr
KysrKysrDQo+PiDCoGRyaXZlcnMvbmV0L3dpcmVsZXNzL2Jyb2FkY29tL2JyY204MDIxMS9icmNt
Zm1hYy9jb21tb24uY8KgwqAgfCA1ICsrKysrDQo+PiDCoGRyaXZlcnMvbmV0L3dpcmVsZXNzL2Jy
b2FkY29tL2JyY204MDIxMS9icmNtZm1hYy9jb21tb24uaMKgwqAgfCAyICsrDQo+PiDCoGRyaXZl
cnMvbmV0L3dpcmVsZXNzL2Jyb2FkY29tL2JyY204MDIxMS9icmNtZm1hYy9md2lsLmjCoMKgwqDC
oCB8IDEgKw0KPj4gwqA0IGZpbGVzIGNoYW5nZWQsIDE1IGluc2VydGlvbnMoKykNCj4gDQo=
