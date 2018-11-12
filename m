Return-Path: <SRS0=J0pC=NX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B973AC43441
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 03:03:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74D6A208A3
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 03:03:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="WAcjmCfj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 74D6A208A3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730420AbeKLMyU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 07:54:20 -0500
Received: from mail-eopbgr790098.outbound.protection.outlook.com ([40.107.79.98]:31340
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725928AbeKLMyT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 07:54:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jwzJBD0qjno3sEj9f/7bmGb0i+0IHd9abDQVdGdgHLA=;
 b=WAcjmCfj0+nNT60REWJXJcUkzt+FOoo1Ze5STwrlVJxwJpjTy187+g/+XTYDnsl44SqD1EE4fV+2tMxg5ORhcoaHslbTxe+/rJOacIUbtiOQnMqSvgnADXmvboiHv10PDqdlbJNlkmL8JXT0ygynFLOQC/HEIQSw9hR3M5L3qmE=
Received: from BYAPR06MB3992.namprd06.prod.outlook.com (52.135.200.22) by
 BYAPR06MB4616.namprd06.prod.outlook.com (52.135.234.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.26; Mon, 12 Nov 2018 03:03:12 +0000
Received: from BYAPR06MB3992.namprd06.prod.outlook.com
 ([fe80::2147:2944:5ff:e986]) by BYAPR06MB3992.namprd06.prod.outlook.com
 ([fe80::2147:2944:5ff:e986%3]) with mapi id 15.20.1294.044; Mon, 12 Nov 2018
 03:03:12 +0000
From:   Wright Feng <Wright.Feng@cypress.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH 1/5] brcmfmac: set apsta to 1 when AP start on primary
 interface.
Thread-Topic: [PATCH 1/5] brcmfmac: set apsta to 1 when AP start on primary
 interface.
Thread-Index: AQHUdxXcUiiIoVomxEqDI4GLO2p64qVHZuoAgAQTXoA=
Date:   Mon, 12 Nov 2018 03:03:12 +0000
Message-ID: <37f04e33-a91c-d797-c2b2-a57b032d4907@cypress.com>
References: <1541648845-194984-1-git-send-email-chi-hsien.lin@cypress.com>
 <1541648845-194984-2-git-send-email-chi-hsien.lin@cypress.com>
 <fa3b98cf-666c-2919-2484-9d496e926a5b@broadcom.com>
In-Reply-To: <fa3b98cf-666c-2919-2484-9d496e926a5b@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: OSAPR01CA0119.jpnprd01.prod.outlook.com
 (2603:1096:604:e::35) To BYAPR06MB3992.namprd06.prod.outlook.com
 (2603:10b6:a02:90::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Wright.Feng@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [61.222.14.99]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR06MB4616;6:rUKMauexjf5Isq/8WaehokIBF2+UKCHqnOlXb/EYof3Vv6Ll77M2y4JdGKxry4z/DquwhmYbL9wQu/Dcc/3mnc37is6p7ft9LUm+47aZkaesIUVzbsI4LO3vV7so77PqscpJPDHdIMNYwSEIHnCKuGE4WPvVi5a80raqTldeJyKYru/oAI5xReI2tNWZ/F24gJ8Q+2JQwsrJccfkQRtGURm0Dytdd1dEXqlB4uiHAOIckrY/oA13fB0Cz4n60B0Kr9DV8wj6XMY0akDY+YYSrvmWSXWd+mkZBbZRgAAmTG/HnIJjEwMb+mb6apXe1WnyMZUI5UfAvf0JbdOXy0fQ0KPQEJvXNPz4oRVuFE/s0IKth0dB3W+PKDvlc73zGDazg9/RtADIgt6iXvg6NudTEYkbSdMi43Fhp6UAaF7dYwJJxyjRLygg04LsgwkgP/ohk39pMs5EKIC1SEfoSajSBg==;5:WWNOnnbQNKckT5QaE37SNXOhAep5ZJTJQMIEq4INhXAEYwkAV6MflVWDjzAtKPPPwgRNb2qeQgHbrltPO9Ut5SMdgrPuU/U7qkTUYcP184Z9IwnchWjwcbe83vC071DyMEgGX6EK+Ugww0PIbVos4U/+n2elun5v0bxVDdIepI4=;7:EL1RWLFPBwi7J6PzEQ3r/iBdET5EOrWVm6M54/U5x9x+CnU4p4KLKmWGBDtJwqSiHLsQcFqjhzjOphNMyx1o2a+ydqthTwewVKqHuStPNUhg+RPnIf/HZ6RyHfbSzuuOVBR0nEKBwy66gbv69oKJZw==
x-ms-office365-filtering-correlation-id: 33fefdd3-1872-455f-9955-08d6484b61f3
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390040)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:BYAPR06MB4616;
x-ms-traffictypediagnostic: BYAPR06MB4616:
x-microsoft-antispam-prvs: <BYAPR06MB461602ADD0F3AE453F2D1A9AFBC10@BYAPR06MB4616.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(258095267146985);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(3002001)(3231382)(944501410)(52105112)(10201501046)(93006095)(93001095)(6055026)(148016)(149066)(150057)(6041310)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(20161123562045)(20161123560045)(201708071742011)(7699051)(76991095);SRVR:BYAPR06MB4616;BCL:0;PCL:0;RULEID:;SRVR:BYAPR06MB4616;
x-forefront-prvs: 0854128AF0
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(136003)(39860400002)(376002)(396003)(366004)(189003)(199004)(36756003)(106356001)(229853002)(8676002)(105586002)(31696002)(6486002)(81156014)(14454004)(8936002)(81166006)(31686004)(2906002)(7736002)(256004)(14444005)(71200400001)(68736007)(86362001)(3846002)(6116002)(71190400001)(305945005)(25786009)(316002)(52116002)(76176011)(97736004)(6436002)(2900100001)(486006)(5660300001)(11346002)(54906003)(446003)(110136005)(476003)(2616005)(72206003)(4326008)(478600001)(186003)(2501003)(99286004)(6246003)(26005)(6512007)(386003)(53936002)(102836004)(6506007)(53546011)(66066001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR06MB4616;H:BYAPR06MB3992.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 0q68+h1PFAOYLMgEEYM6YFxihul8i5tAgo78toaz+nH7K7h706sg5sZl4DjUMQrP61foIKGgbrNVHxJN2MtRiRAfhC38b52GNWQynzUBvYurzCioSWIHCbvsiqBja6ie2fOnuZK+ew6trnNPdfcG+i1gq2J0wTmsy4x/n0GHIN5ZU/pfOcy/d6ONdgKiV4k3dxJypvXBbv69PoDzC7+tDYjZidX5/8DEo6jRX/RWnSd7kXD02OIZJWsKMepQ0BInSMqVJvWDvxoA0vwk2hCGA5I4zS8VYN/lznTs1RSvdf/EuVgh+KogzEk5zjn0rGfCCXfcxhquclTlFebtrlQVei7tWJOzsMw1c05VsZYCht4=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <5A419CB116090D4FA36D13974D84BAA5@namprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33fefdd3-1872-455f-9955-08d6484b61f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2018 03:03:12.6199
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR06MB4616
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

DQoNCk9uIDIwMTgvMTEvOSDkuIvljYggMDg6NDgsIEFyZW5kIHZhbiBTcHJpZWwgd3JvdGU6DQo+
IE9uIDExLzgvMjAxOCA0OjQ4IEFNLCBDaGktSHNpZW4gTGluIHdyb3RlOg0KPj4gRnJvbTogV3Jp
Z2h0IEZlbmcgPHdyaWdodC5mZW5nQGN5cHJlc3MuY29tPg0KPj4NCj4+IEFQU1RBIGNhbiB3b3Jr
IG9uIHR3byBiYW5kIGNvbmN1cnJlbnRseSB3aXRoIHVzaW5nIFZTREIoVmlydHVhbA0KPj4gU2lt
dWx0YW5lb3VzIER1YWwtQmFuZCkgb3IgUlNEQihSZWFsIFNpbXVsdGFuZW91cyBEdWFsLUJhbmQp
IGZlYXR1cmVzLg0KPj4gSW4gdGhpcyBjYXNlLCB3ZSBoYXZlIHRvIGtlZXAgYXBzdGEgaXMgMSBp
biBmaXJtd2FyZSBzaWRlLiBIb3dldmVyLCBpZg0KPj4gd2Ugc3RhcnQgd3BhX3N1cHBsaWNhbnQg
b24gd2xhbjAgYW5kIHRoZW4gc3RhcnQgaG9zdGFwZCBvbiB3bGFuIDEsIHRoZQ0KPj4gYXBzdGEg
d2lsbCBiZSBzZXQgdG8gMCwgYW5kIHdlIHdpbGwgc2VlIGRhdGEgc3RhbGwgb24gd2xhbjAoc3Rh
dGlvbikNCj4+IFNvIHRoYXQsIHdlIG9ubHkgc2V0IGFwc3RhIHRvIDEgd2hlbiBBUCBzdGFydCBv
biBwcmltYXJ5IGludGVyZmFjZS4NCj4gDQo+IFRoZSBkZXNjcmlwdGlvbiBtYWtlcyBteSBoZWFk
IHNwaW4uIEZyb20gcmVhZGluZyB0aGUgY29tbWl0IG1lc3NhZ2UgSSANCj4gdGhpbmsgdGhlIGNv
ZGUgc2hvdWxkIGFkZCBhICFWU0RCIGNoZWNrIGluc3RlYWQgb2YgZHJvcHBpbmcgdGhlICFSU0RC
IA0KPiBjaGVjay4gV291bGQgeW91IGFncmVlPw0KPiANCj4gUmVnYXJkcywNCj4gQXJlbmQNCkkg
d2lsbCByZXZpc2UgdGhlIGNvbW1pdCBtZXNzYWdlIGFzIGJlbG93IGFuZCBhZGQgdHdvIGNoZWNr
cyAoIU1DSEFOIGFuZCANCiFSU0RCKWluIHYyLiBMZXQgbWUga25vdyBpZiB5b3UgaGF2ZSBjb25j
ZXJuIGFib3V0IHRoYXQuDQoNCldoZW4gc3RhcnRpbmcgc3RhdGlvbiBtb2RlIG9uIHdsYW4wIGFu
ZCBBUCBtb2RlIG9uIHdsYW4xLCB0aGUNCmFwc3RhIHdpbGwgYmUgZGlzYWJsZWQgYW5kIGNhdXNl
IGRhdGEgc3RhbGwgb24gd2xhbjAoc3RhdGlvbikNClRoZSBhcHN0YSBmZWF0dXJlIHdpdGggTUNI
QU4oTXVsdGktQ2hhbm5lbCBDb25jdXJyZW50KSBvciBSU0RCKFJlYWwNClNpbXVsdGFuZW91cyBE
dWFsLUJhbmQpIGNhbiBtYWtlIFNUQStBUCB3b3JrIG9uIHR3byBiYW5kcyBjb25jdXJyZW50bHku
DQpCZWNhdXNlIG9mIHRoYXQsIHdlIGtlZXAgYXBzdGEgZW5hYmxlZCBpZiBmaXJtd2FyZSBzdXBw
b3J0cyBNQ0hBTiBvcg0KUlNEQiBmZWF0dXJlcy4NCg0KLSBXcmlnaHQNCj4gDQo+PiBTaWduZWQt
b2ZmLWJ5OiBXcmlnaHQgRmVuZyA8d3JpZ2h0LmZlbmdAY3lwcmVzcy5jb20+DQo+PiBTaWduZWQt
b2ZmLWJ5OiBDaGktSHNpZW4gTGluIDxjaGktaHNpZW4ubGluQGN5cHJlc3MuY29tPg0KPj4gLS0t
DQo+PiDCoGRyaXZlcnMvbmV0L3dpcmVsZXNzL2Jyb2FkY29tL2JyY204MDIxMS9icmNtZm1hYy9j
Zmc4MDIxMS5jIHwgNCArLS0tDQo+PiDCoDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwg
MyBkZWxldGlvbnMoLSkNCj4gDQo=
