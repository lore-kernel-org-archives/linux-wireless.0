Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82AE1C169C4
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 07:43:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2071921917
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 07:43:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="WWTI14L7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbfBHHn4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 02:43:56 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:52542 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbfBHHnz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 02:43:55 -0500
X-IronPort-AV: E=Sophos;i="5.56,564,1539673200"; 
   d="scan'208";a="26456020"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 08 Feb 2019 00:43:54 -0700
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.38) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Fri, 8 Feb 2019 00:43:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9RPnOiplL4unVp56qxg/NDkYChGIj2cqISc0Qwm4aIA=;
 b=WWTI14L7cXlwgkGfqVTp3NMLD8S6ymiNUg3Bqf3nmrd/6ahnQbLnaCDbKL51TLPB/YUpTSQiDeVlU5rqmXODa/Taud7xwpPBfjd+0AGNtaw3eWWdjcimoIyMFPOrDTWohNnNOq8+1grEiQnYcUD4E3ltlfVFY4FxTnoFjlrmDBA=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2550.namprd11.prod.outlook.com (52.135.226.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.21; Fri, 8 Feb 2019 07:43:52 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1601.016; Fri, 8 Feb 2019
 07:43:52 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <Claudiu.Beznea@microchip.com>, <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>
Subject: Re: [PATCH v2 3/8] staging: wilc1000: move macro and function
 prototype from wilc_wlan_if.h file
Thread-Topic: [PATCH v2 3/8] staging: wilc1000: move macro and function
 prototype from wilc_wlan_if.h file
Thread-Index: AQHUvthVLu7U4pnwZ0OQawe5Ky0AxqXUShuAgAE70oA=
Date:   Fri, 8 Feb 2019 07:43:52 +0000
Message-ID: <3f415f62-0dbc-412f-d247-3b2bee1a89e2@microchip.com>
References: <1549538913-17463-1-git-send-email-ajay.kathat@microchip.com>
 <1549538913-17463-4-git-send-email-ajay.kathat@microchip.com>
 <2a6391ac-f0c5-e971-39a0-269b5ff4bb34@microchip.com>
In-Reply-To: <2a6391ac-f0c5-e971-39a0-269b5ff4bb34@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR0101CA0055.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::17) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [27.59.122.98]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2550;6:saAhdiBj11uwn1n16CNBhaXZp7MNutIa+BCS7QipQfb7wlSSi26Y6rrTeHrcEbH2fhHUJ2AC+zpSqKjnzqfu/tfvVhxh6S6E80XJY7l763IwhPK5hAodPZkaRwylxCyQ6vcfVp4ZRs7VayKq8xfkEJFm2dntlDatL6Lc0Yh0t0esESs9iVhI4xeLG/BdJ2N4ZpR8Yc9vG5tEqV9oCDbC0q+5My92Rb5aqlfTFKF8naAYt9mDhh70bygkrm1u8z/IWW4jKAlUewCXUzRzXrA6oApATgLFtlRHkZD6l0OuUU4WJL71QEa10Ly9SKZdAvMByg+/DWkLsaYbvctveX2O3Vc/0KSE69gcKbANjKXu/tZooz6JNHpFZ9nfIdMZVCwLXbMrtvlT5nR7c/ZxiHbluXXcG+I0pRdyw45jSgK5sGiwAUIDU2blTOquc6IJ8p5YZ5FVJwtv1Hie1mRdjvAMxg==;5:MxhrypWe5UvnrY1H2lUNRODCzRoTE2QmejvcwJyA0OeZoiHkE1Z+6UGekdPvnD5TDzw/tIudGPvST+eRd88XshvO5B1cFOqu/CIW6bckb2+UvTKXl8MTEzvavVKQe3i//XlNdN32J7+jsAt92f5ovvZLnUEQaLtTqSegJnTP/EZEwLlMCqBzH7kyqPxqeMi9im2/HHR1rpkNOtRH4uLfew==;7:hLT9nqTrOnyo6/Bft5ZWqN/zgVIAcPEeybHN/dc4wzHl1RnAuYYWrlfqCX7tdRzDHOB3EUZoQdk3Ai7NtunhOFwGevvup3Nv3JY5RZRLsUuAputPMbVCzt1nkAvEqlv1vfgD83jzqLXpIAR6mbpLwQ==
x-ms-office365-filtering-correlation-id: a6ba1587-7912-4dbb-d06e-08d68d992b7b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2550;
x-ms-traffictypediagnostic: BYAPR11MB2550:
x-microsoft-antispam-prvs: <BYAPR11MB25500B20BECED89875087942E3690@BYAPR11MB2550.namprd11.prod.outlook.com>
x-forefront-prvs: 094213BFEA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39860400002)(396003)(376002)(136003)(366004)(199004)(189003)(86362001)(6116002)(3846002)(11346002)(54906003)(2616005)(110136005)(476003)(446003)(81156014)(97736004)(81166006)(8676002)(478600001)(72206003)(305945005)(7736002)(14454004)(6486002)(8936002)(6436002)(52116002)(486006)(71200400001)(71190400001)(99286004)(31696002)(25786009)(186003)(4326008)(256004)(14444005)(76176011)(26005)(316002)(36756003)(2906002)(386003)(6506007)(105586002)(68736007)(2501003)(53546011)(6246003)(53936002)(102836004)(106356001)(6512007)(229853002)(31686004)(66066001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2550;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ZQsjbklVl5dT2HuUvLmDJRwiOtcN6lBBvL3P3580bSnYgJqxbupcUcfI5chvDlTrhTWzCwSJq0mB4KDL9T0gvyHwlboKqqLgZ4Cq2T+QFWHgi6228+uIlO7NRNC4chX5cWUe0kxStFAfvIv+UqRdRKL/ohUtzJ4uz72luJV8NYAI7F5X9oRvDkXyLaVL3fR9Jdh8opOGmTBD9MtfQeqb1thxe6nzMz5dpRjNgV5IDghVzD8VA59dbiZwN7ttYaPytnS0zTrilmYin/E+ajo/a7Ytp01oJGnehTdFiXDozhbAGPB5+goRRZb+6AvfNWEeKeiWYUprctY75OlbG/Y/mWNEYAzuY2dCLrEi7JBK8JeVIWVWfMT6XDTMUNRexuxEnaVzPT64ozJrbokYAJvR/noEFR21Qr/PrReK/3NloCQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <124F84FF1D80E24F979F8DD014D0968C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a6ba1587-7912-4dbb-d06e-08d68d992b7b
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2019 07:43:49.2412
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2550
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

T24gMi83LzIwMTkgNjoyMSBQTSwgQ2xhdWRpdSBCZXpuZWEgLSBNMTgwNjMgd3JvdGU6DQo+IA0K
PiANCj4gT24gMDcuMDIuMjAxOSAxMzoyOSwgQWpheS5LYXRoYXRAbWljcm9jaGlwLmNvbSB3cm90
ZToNCj4+IEZyb206IEFqYXkgU2luZ2ggPGFqYXkua2F0aGF0QG1pY3JvY2hpcC5jb20+DQo+Pg0K
Pj4gTW92ZSBkYXRhIHN0cnVjdHVyZSBhbmQgZnVuY3Rpb24gcHJvdG90eXBlIGZyb20gJ3dpbGNf
d2xhbl9pZi5oIGZpbGUuDQo+PiBOb3csIHRoaXMgZmlsZSBjb250YWlucyBjb25zdGFudCBzcGVj
aWZpYyB0byB0aGUgZmlybXdhcmUuDQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTogQWpheSBTaW5naCA8
YWpheS5rYXRoYXRAbWljcm9jaGlwLmNvbT4NCj4+IC0tLQ0KPj4gIGRyaXZlcnMvc3RhZ2luZy93
aWxjMTAwMC9ob3N0X2ludGVyZmFjZS5jIHwgIDEgKw0KPj4gIGRyaXZlcnMvc3RhZ2luZy93aWxj
MTAwMC9ob3N0X2ludGVyZmFjZS5oIHwgMTEgKysrKysrKysrKw0KPj4gIGRyaXZlcnMvc3RhZ2lu
Zy93aWxjMTAwMC9saW51eF93bGFuLmMgICAgIHwgIDIgKysNCj4+ICBkcml2ZXJzL3N0YWdpbmcv
d2lsYzEwMDAvd2lsY193bGFuLmggICAgICB8ICA5ICsrKysrKysrDQo+PiAgZHJpdmVycy9zdGFn
aW5nL3dpbGMxMDAwL3dpbGNfd2xhbl9pZi5oICAgfCAzNiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tDQo+PiAgNSBmaWxlcyBjaGFuZ2VkLCAyMyBpbnNlcnRpb25zKCspLCAzNiBkZWxl
dGlvbnMoLSkNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dpbGMxMDAwL2hv
c3RfaW50ZXJmYWNlLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2lsYzEwMDAvaG9zdF9pbnRlcmZhY2Uu
Yw0KPj4gaW5kZXggOWFiZTM0MS4uNTBkYzJkZCAxMDA2NDQNCj4+IC0tLSBhL2RyaXZlcnMvc3Rh
Z2luZy93aWxjMTAwMC9ob3N0X2ludGVyZmFjZS5jDQo+PiArKysgYi9kcml2ZXJzL3N0YWdpbmcv
d2lsYzEwMDAvaG9zdF9pbnRlcmZhY2UuYw0KPj4gQEAgLTEwLDYgKzEwLDcgQEANCj4+ICAjZGVm
aW5lIFdJTENfSElGX0NPTk5FQ1RfVElNRU9VVF9NUyAgICAgICAgICAgICA5NTAwDQo+PiAgDQo+
PiAgI2RlZmluZSBXSUxDX0ZBTFNFX0ZSTVdSX0NIQU5ORUwJCTEwMA0KPj4gKyNkZWZpbmUgV0lM
Q19NQVhfUkFURVNfU1VQUE9SVEVECQkxMg0KPj4gIA0KPj4gIHN0cnVjdCB3aWxjX3JjdmRfbWFj
X2luZm8gew0KPj4gIAl1OCBzdGF0dXM7DQo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5n
L3dpbGMxMDAwL2hvc3RfaW50ZXJmYWNlLmggYi9kcml2ZXJzL3N0YWdpbmcvd2lsYzEwMDAvaG9z
dF9pbnRlcmZhY2UuaA0KPj4gaW5kZXggYTAwNzYyNS4uNjc4ZTYyMyAxMDA2NDQNCj4+IC0tLSBh
L2RyaXZlcnMvc3RhZ2luZy93aWxjMTAwMC9ob3N0X2ludGVyZmFjZS5oDQo+PiArKysgYi9kcml2
ZXJzL3N0YWdpbmcvd2lsYzEwMDAvaG9zdF9pbnRlcmZhY2UuaA0KPj4gQEAgLTk3LDYgKzk3LDE3
IEBAIGVudW0gY29ubl9ldmVudCB7DQo+PiAgCUNPTk5fRElTQ09OTl9FVkVOVF9GT1JDRV8zMkJJ
VAkJPSAweEZGRkZGRkZGDQo+PiAgfTsNCj4+ICANCj4+ICtlbnVtIHsNCj4+ICsJV0lMQ19ISUZf
U0RJTyA9IDAsDQo+PiArCVdJTENfSElGX1NQSSA9IEJJVCgwKQ0KPiANCj4gQklUKDApPTEsIHNv
IHlvdSBjYW4gcmVtb3ZlIGl0IGFuZCB1c2Ugc2ltcGx5Og0KPiANCj4gZW51bSB7DQo+IAlXSUxD
X0hJRl9TRElPLA0KPiAJV0lMQ19ISUZfU1BJLA0KPiB9Ow0KPiANCg0KVGhhbmtzIENsYXVkaXUs
DQpTdXJlLCBJIHdpbGwgYmUgdGFraW5nIGNhcmUgb2YgaXQgaW4gZnV0dXJlIHBhdGNoZXMuDQoN
Cj4gDQo+PiArfTsNCj4+ICsNCj4+ICtlbnVtIHsNCj4+ICsJV0lMQ19NQUNfU1RBVFVTX0lOSVQg
PSAtMSwNCj4+ICsJV0lMQ19NQUNfU1RBVFVTX0RJU0NPTk5FQ1RFRCA9IDAsDQo+PiArCVdJTENf
TUFDX1NUQVRVU19DT05ORUNURUQgPSAxDQo+PiArfTsNCj4+ICsNCj4+ICBzdHJ1Y3Qgd2lsY19y
Y3ZkX25ldF9pbmZvIHsNCj4+ICAJczggcnNzaTsNCj4+ICAJdTggY2g7DQo+PiBkaWZmIC0tZ2l0
IGEvZHJpdmVycy9zdGFnaW5nL3dpbGMxMDAwL2xpbnV4X3dsYW4uYyBiL2RyaXZlcnMvc3RhZ2lu
Zy93aWxjMTAwMC9saW51eF93bGFuLmMNCj4+IGluZGV4IGYzZTUyYWYuLjFlYmYyYjggMTAwNjQ0
DQo+PiAtLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2lsYzEwMDAvbGludXhfd2xhbi5jDQo+PiArKysg
Yi9kcml2ZXJzL3N0YWdpbmcvd2lsYzEwMDAvbGludXhfd2xhbi5jDQo+PiBAQCAtMTIsNiArMTIs
OCBAQA0KPj4gIA0KPj4gICNpbmNsdWRlICJ3aWxjX3dmaV9jZmdvcGVyYXRpb25zLmgiDQo+PiAg
DQo+PiArI2RlZmluZSBXSUxDX01VTFRJQ0FTVF9UQUJMRV9TSVpFCTgNCj4+ICsNCj4+ICBzdGF0
aWMgaXJxcmV0dXJuX3QgaXNyX3VoX3JvdXRpbmUoaW50IGlycSwgdm9pZCAqdXNlcl9kYXRhKQ0K
Pj4gIHsNCj4+ICAJc3RydWN0IG5ldF9kZXZpY2UgKmRldiA9IHVzZXJfZGF0YTsNCj4+IGRpZmYg
LS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2lsYzEwMDAvd2lsY193bGFuLmggYi9kcml2ZXJzL3N0
YWdpbmcvd2lsYzEwMDAvd2lsY193bGFuLmgNCj4+IGluZGV4IGQ4ZmFiZTguLjFhMjdmNjIgMTAw
NjQ0DQo+PiAtLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2lsYzEwMDAvd2lsY193bGFuLmgNCj4+ICsr
KyBiL2RyaXZlcnMvc3RhZ2luZy93aWxjMTAwMC93aWxjX3dsYW4uaA0KPj4gQEAgLTI1MCw2ICsy
NTAsMTMgQEAgc3RydWN0IHdpbGNfaGlmX2Z1bmMgew0KPj4gIA0KPj4gICNkZWZpbmUgV0lMQ19N
QVhfQ0ZHX0ZSQU1FX1NJWkUJCTE0NjgNCj4+ICANCj4+ICtzdHJ1Y3QgdHhfY29tcGxldGVfZGF0
YSB7DQo+PiArCWludCBzaXplOw0KPj4gKwl2b2lkICpidWZmOw0KPj4gKwl1OCAqYnNzaWQ7DQo+
PiArCXN0cnVjdCBza19idWZmICpza2I7DQo+PiArfTsNCj4+ICsNCj4+ICBzdHJ1Y3Qgd2lsY19j
ZmdfY21kX2hkciB7DQo+PiAgCXU4IGNtZF90eXBlOw0KPj4gIAl1OCBzZXFfbm87DQo+PiBAQCAt
MzAxLDQgKzMwOCw2IEBAIHZvaWQgY2hpcF9hbGxvd19zbGVlcChzdHJ1Y3Qgd2lsYyAqd2lsYyk7
DQo+PiAgdm9pZCBjaGlwX3dha2V1cChzdHJ1Y3Qgd2lsYyAqd2lsYyk7DQo+PiAgaW50IHdpbGNf
c2VuZF9jb25maWdfcGt0KHN0cnVjdCB3aWxjX3ZpZiAqdmlmLCB1OCBtb2RlLCBzdHJ1Y3Qgd2lk
ICp3aWRzLA0KPj4gIAkJCSB1MzIgY291bnQsIHUzMiBkcnYpOw0KPj4gK2ludCB3aWxjX3dsYW5f
aW5pdChzdHJ1Y3QgbmV0X2RldmljZSAqZGV2KTsNCj4+ICt1MzIgd2lsY19nZXRfY2hpcGlkKHN0
cnVjdCB3aWxjICp3aWxjLCBib29sIHVwZGF0ZSk7DQo+PiAgI2VuZGlmDQo+PiBkaWZmIC0tZ2l0
IGEvZHJpdmVycy9zdGFnaW5nL3dpbGMxMDAwL3dpbGNfd2xhbl9pZi5oIGIvZHJpdmVycy9zdGFn
aW5nL3dpbGMxMDAwL3dpbGNfd2xhbl9pZi5oDQo+PiBpbmRleCA5YjhjY2U4Li5iMTVkZTM2IDEw
MDY0NA0KPj4gLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dpbGMxMDAwL3dpbGNfd2xhbl9pZi5oDQo+
PiArKysgYi9kcml2ZXJzL3N0YWdpbmcvd2lsYzEwMDAvd2lsY193bGFuX2lmLmgNCj4+IEBAIC0x
MSw0MSArMTEsOSBAQA0KPj4gIA0KPj4gIC8qKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKg0KPj4gICAqDQo+PiAtICogICAgICBIb3N0IEludGVyZmFjZSBEZWZpbmVz
DQo+PiAtICoNCj4+IC0gKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KiovDQo+PiAtDQo+PiAtZW51bSB7DQo+PiAtCVdJTENfSElGX1NESU8gPSAwLA0KPj4gLQlXSUxD
X0hJRl9TUEkgPSBCSVQoMCkNCj4+IC19Ow0KPj4gLQ0KPj4gLS8qKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKg0KPj4gLSAqDQo+PiAtICogICAgICBXbGFuIEludGVy
ZmFjZSBEZWZpbmVzDQo+PiAtICoNCj4+IC0gKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKiovDQo+PiAtDQo+PiAtZW51bSB7DQo+PiAtCVdJTENfTUFDX1NUQVRVU19J
TklUID0gLTEsDQo+PiAtCVdJTENfTUFDX1NUQVRVU19ESVNDT05ORUNURUQgPSAwLA0KPj4gLQlX
SUxDX01BQ19TVEFUVVNfQ09OTkVDVEVEID0gMQ0KPj4gLX07DQo+PiAtDQo+PiAtc3RydWN0IHR4
X2NvbXBsZXRlX2RhdGEgew0KPj4gLQlpbnQgc2l6ZTsNCj4+IC0Jdm9pZCAqYnVmZjsNCj4+IC0J
dTggKmJzc2lkOw0KPj4gLQlzdHJ1Y3Qgc2tfYnVmZiAqc2tiOw0KPj4gLX07DQo+PiAtDQo+PiAt
LyoqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqDQo+PiAtICoNCj4+
ICAgKiAgICAgIFdsYW4gQ29uZmlndXJhdGlvbiBJRA0KPj4gICAqDQo+PiAgICoqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqLw0KPj4gLSNkZWZpbmUgV0lMQ19NVUxU
SUNBU1RfVEFCTEVfU0laRQk4DQo+PiAtI2RlZmluZSBXSUxDX01BWF9SQVRFU19TVVBQT1JURUQg
ICAgIDEyDQo+PiAgDQo+PiAgZW51bSBic3NfdHlwZXMgew0KPj4gIAlXSUxDX0ZXX0JTU19UWVBF
X0lORlJBID0gMCwNCj4+IEBAIC04MzIsOCArODAwLDQgQEAgZW51bSB7DQo+PiAgCVdJRF9NQVgJ
CQkJPSAweEZGRkYNCj4+ICB9Ow0KPj4gIA0KPj4gLXN0cnVjdCB3aWxjOw0KPj4gLWludCB3aWxj
X3dsYW5faW5pdChzdHJ1Y3QgbmV0X2RldmljZSAqZGV2KTsNCj4+IC11MzIgd2lsY19nZXRfY2hp
cGlkKHN0cnVjdCB3aWxjICp3aWxjLCBib29sIHVwZGF0ZSk7DQo+PiAtDQo+PiAgI2VuZGlmDQo+
Pg0K
