Return-Path: <SRS0=G8on=RY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1265C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Mar 2019 14:06:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F812218B0
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Mar 2019 14:06:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="TPbSCNzb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbfCUOG5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Mar 2019 10:06:57 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:56705 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727809AbfCUOG5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Mar 2019 10:06:57 -0400
X-IronPort-AV: E=Sophos;i="5.58,498,1544511600"; 
   d="scan'208";a="29814652"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 21 Mar 2019 07:06:56 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.49) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 21 Mar 2019 07:06:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e4WKldDK63BzDA4TGXY2irk01fQbi4u39n8WnhoM8/0=;
 b=TPbSCNzb3kl1EnN9dBnIVFz1OOzMLxC0z9/4y2zIHSgVoPRVaHIhLNJhjcTjXzf3k4U5xLxcSEPvm4ih5HCvNC9MRLWkQyk96h4i4glritCLjucHjlhRDbXemCiQaS9pYgNqBjsLWKKjJ3rhQl5HnRiF+dnHq6YOxc4Jp8fJt+Q=
Received: from BN7PR11MB2562.namprd11.prod.outlook.com (52.135.244.32) by
 BN7PR11MB2820.namprd11.prod.outlook.com (52.135.246.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1730.16; Thu, 21 Mar 2019 14:06:54 +0000
Received: from BN7PR11MB2562.namprd11.prod.outlook.com
 ([fe80::d155:ce52:7744:6c34]) by BN7PR11MB2562.namprd11.prod.outlook.com
 ([fe80::d155:ce52:7744:6c34%5]) with mapi id 15.20.1730.013; Thu, 21 Mar 2019
 14:06:54 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <kvalo@codeaurora.org>
CC:     <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>,
        <gregkh@linuxfoundation.org>, <Adham.Abozaeid@microchip.com>,
        <Venkateswara.Kaja@microchip.com>, <Nicolas.Ferre@microchip.com>,
        <Claudiu.Beznea@microchip.com>
Subject: Re: [PATCH 00/16] wilc1000: move out of staging
Thread-Topic: [PATCH 00/16] wilc1000: move out of staging
Thread-Index: AQHUwEbCCX3IcHjEkkah7YSVPvJ9TKYWSGkAgAABd3mAABQqgA==
Date:   Thu, 21 Mar 2019 14:06:54 +0000
Message-ID: <d72138a5-69f3-f1fb-f185-2715d6b588fe@microchip.com>
References: <1549696298-9795-1-git-send-email-ajay.kathat@microchip.com>
 <5ac9d9bb-08e4-c46f-ce0a-40630e1d958e@microchip.com>
 <871s30pevc.fsf@codeaurora.org>
In-Reply-To: <871s30pevc.fsf@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BM1PR01CA0163.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:68::33) To BN7PR11MB2562.namprd11.prod.outlook.com
 (2603:10b6:406:b0::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [49.205.217.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 23ad7933-2c50-4ad6-762e-08d6ae0678dc
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:BN7PR11MB2820;
x-ms-traffictypediagnostic: BN7PR11MB2820:
x-microsoft-antispam-prvs: <BN7PR11MB2820899CC809AD732F6A6DBCE3420@BN7PR11MB2820.namprd11.prod.outlook.com>
x-forefront-prvs: 0983EAD6B2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39860400002)(376002)(396003)(346002)(366004)(189003)(199004)(76176011)(72206003)(26005)(229853002)(52116002)(97736004)(81166006)(6436002)(81156014)(6486002)(186003)(3846002)(6916009)(71200400001)(71190400001)(31686004)(7736002)(478600001)(66066001)(8936002)(53546011)(14444005)(54906003)(256004)(305945005)(386003)(6506007)(68736007)(6246003)(107886003)(86362001)(486006)(106356001)(53936002)(11346002)(446003)(5660300002)(36756003)(316002)(2906002)(25786009)(105586002)(14454004)(2616005)(476003)(78486014)(8676002)(6116002)(6512007)(99286004)(31696002)(4326008)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR11MB2820;H:BN7PR11MB2562.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: fYOLf1CbAdetrYcCBnEye2Fc3PoUOQgxUFpD3wmoWNiTT7vmNtH548WZ7ZYCgLY2IWi2WtfYqCpRUikJfagxB3XOaG45QxatW8NhxSR7z7h7HUkW+fI3H/27Ivw3/f3//rs+fBwjGW0JndNbp0GW2RFhwHjgtqjDRSvSdCqixLsb14SjGSZKxvcDDN8Iu6r57yh6braI25Bjq34/RpFKIKZnQyZGpIUwFVtIMq1XeuIiWUN54rKkmpoWgbel65sJHMrJXmlf9VcZ33xW7uj8UpLmfE05YJchIocDWFJ3NQl1mlDJZqG1SM1qSwF/inVxbtUbz0YBZQRSZ8Ay6ZKaeBdLyJZ/8ulfkDi8YMlyx98Yi79CuxUD5rgLDC9n7iKado2rScA3BAYPevlw7APQtGuJsZMY62ytZEAu3yKxANA=
Content-Type: text/plain; charset="utf-8"
Content-ID: <29976F8A13671C48A8826D8EC8546A4B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 23ad7933-2c50-4ad6-762e-08d6ae0678dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2019 14:06:54.3376
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2820
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

DQoNCk9uIDMvMjEvMjAxOSA2OjI0IFBNLCBLYWxsZSBWYWxvIHdyb3RlOg0KPiANCj4gPEFqYXku
S2F0aGF0QG1pY3JvY2hpcC5jb20+IHdyaXRlczoNCj4gDQo+PiBIaSBLYWxsZS9Kb2hhbm5lcywN
Cj4+DQo+PiBPbiAyLzkvMjAxOSAxMjo0MiBQTSwgQWpheSBLYXRoYXQgLSBJMTU0ODEgd3JvdGU6
DQo+Pj4gRnJvbTogQWpheSBTaW5naCA8YWpheS5rYXRoYXRAbWljcm9jaGlwLmNvbT4NCj4+Pg0K
Pj4+IFRoaXMgcGF0Y2ggc2VyaWVzIGlzIHRvIHJldmlldyBhbmQgbW92ZSB3aWxjMTAwMCBkcml2
ZXIgb3V0IG9mIHN0YWdpbmcuDQo+Pj4gSW1wbGVtZW50ZWQgdGhlIGluaXRpYWwgcmVjZWl2ZWQg
cmV2aWV3IGNvbW1lbnRzWzFdIGFuZCBzdWJtaXR0aW5nIHRoZQ0KPj4+IGRyaXZlciBhZ2Fpbi4g
RHVyaW5nIHRoaXMgY2xlYW51cCBkZWxldGVkIGFyb3VuZCAzLjNrIGxpbmVzIG9mIGNvZGUuDQo+
Pj4NCj4+PiBCZWxvdyBhcmUgdGhlIG1ham9yIGl0ZW1zIGZpeGVkIGluIHJlY2VudCBjbGVhbnVw
Og0KPj4+ICAtIHJlbW92ZSB1c2Ugb2Ygc2hhZG93IGJ1ZmZlciB0byBrZWVwIHNjYW4gcmVzdWx0
Lg0KPj4+ICAtIHJlbW92ZSBpbnRlcm5hbCBtZXNzYWdpbmcgZmxvdyB0byBoYW5kbGUgY2ZnODAy
MTFfb3BzLg0KPj4+ICAtIG1ha2UgdXNlIG9mIGNmZzgwMjExIHByb3ZpZGVkIEFQSS4NCj4+PiAg
LSB1c2Ugc3RydWN0dXJlIGZvciBwYWNraW5nIGZpcm13YXJlIGNvbW1hbmRzLg0KPj4+ICAtIG1h
a2UgdXNlIG9mIGtlcm5lbCBwcm92aWRlZCBBUEkgYW5kIG1hY3Jvcy4NCj4+PiAgLSByZW1vdmUg
dW5uZWNlc3NhcnkgbG9ncyBtZXNzYWdlcy4NCj4+Pg0KPj4+IFBlbmRpbmcgYWN0aW9uIGl0ZW06
DQo+Pj4gIC0gZHluYW1pY2FsbHkgYWRkL3JlbW92ZSBwMnAgaW50ZXJmYWNlLg0KPj4+DQo+Pj4g
IFRoaXMgaXRlbSB3aWxsIHRha2Ugc29tZSB0aW1lLCB3ZSBhcmUgcGxhbm5pbmcgdG8gdGFrZSBp
dCB1cCBhZnRlcg0KPj4+ICBtYWlubGluZS4NCj4+Pg0KPj4+ICBXZSBob3BlIGl0IGNhbiBiZSBt
b3ZlIG91dCBzdGFnaW5nIGluIHY1LjEuDQo+Pj4gIFBsZWFzZSByZXZpZXcgYW5kIGNvbmZpcm0g
aWYgaXQgaXMgZ29vZCB0byBtb3ZlIG91dC4NCj4+DQo+PiBEbyB5b3UgaGF2ZSBhbnkgdXBkYXRl
IGZvciB0aGlzIHNlcmllcy4gUGxlYXNlIHByb3ZpZGUgeW91ciBpbnB1dHMgZm9yDQo+PiBuZXh0
IHN0ZXAuDQo+IA0KPiBydHc4OCBpcyB0YWtpbmcgcHJpb3JpdHkgaW4gdGhlIG5ldyBkcml2ZXJz
ICJxdWV1ZSIgc28gSSBkb3VidCBJIGNhbg0KPiB0YWtlIGEgbG9vayBhdCB0aGlzIGluIHRoZSBu
ZXh0IGZldyB3ZWVrcy4NCj4gDQoNClRoYW5rcyBLYWxsZS4gSSB3aWxsIHdhaXQgZm9yIHlvdXIg
bmV4dCB1cGRhdGUuDQoNClJlZ2FyZHMsDQpBamF5DQo=
