Return-Path: <SRS0=RZRw=QM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29A24C282C4
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 02:56:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBC4E2081B
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 02:56:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="ycFJysKt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727216AbfBEC4Q (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Feb 2019 21:56:16 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:53359 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbfBEC4Q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Feb 2019 21:56:16 -0500
X-IronPort-AV: E=Sophos;i="5.56,560,1539673200"; 
   d="scan'208";a="23444775"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 04 Feb 2019 19:56:14 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.38) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Mon, 4 Feb 2019 19:56:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4UbeiGgRqi7Vnc2tSh+6WdnTblSk/jocrIWhOTlU1zE=;
 b=ycFJysKtMRyECs8HaQyrcgn1+EcTK3M/T18buvMe5F8+sQkaGhW3BI5xIdKELJ+CLpW7v3ukOLC3wMbakcc9uE43ACNRuDddZLXF2khQF5CWQ1FsnJB0NMPIywqwb69vW9TXm4sMs72EVUCK/M/nABzzYUvf2GI0WqH5tmeNMEk=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3415.namprd11.prod.outlook.com (20.177.224.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.22; Tue, 5 Feb 2019 02:56:12 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1580.019; Tue, 5 Feb 2019
 02:56:12 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <kvalo@codeaurora.org>
CC:     <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <gregkh@linuxfoundation.org>, <Adham.Abozaeid@microchip.com>,
        <johannes@sipsolutions.net>
Subject: Re: [PATCH 01/15] staging: wilc1000: avoid the use of 'wilc_wfi_mon'
 static variable
Thread-Topic: [PATCH 01/15] staging: wilc1000: avoid the use of 'wilc_wfi_mon'
 static variable
Thread-Index: AQHUuyvbBxPjnJCw40CWpECh2AMjPaXPp9E0gADehAA=
Date:   Tue, 5 Feb 2019 02:56:12 +0000
Message-ID: <58a5b3cc-38eb-fb14-98f9-ed5570dfe323@microchip.com>
References: <1549134974-5545-1-git-send-email-ajay.kathat@microchip.com>
 <1549134974-5545-2-git-send-email-ajay.kathat@microchip.com>
 <87lg2vsmft.fsf@purkki.adurom.net>
In-Reply-To: <87lg2vsmft.fsf@purkki.adurom.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR01CA0011.prod.exchangelabs.com (2603:10b6:a02:80::24)
 To BYAPR11MB2567.namprd11.prod.outlook.com (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [183.82.18.226]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3415;6:FKJYXAumfJSnn8Umiyc0FdhDTCAg4e9NcUHRoUF0OeKGtykKkH6SA/LffLl9BEaVHcHiVDFoSKda/abH6JFZMpG1ZJrgEtR11/6hoElU295m/h1dhDCQiL3HWmi6FT5fzG7IOSUue10WE4+Xgc6kVfWuvV9gUqwkfCb12+CoGeJqFN99W+H6wyn8rmAY7A6wyIY5KFoPPI2WSP+KIi2ulx0wU+QvYQqSs++8AJogstnkjDhBkG4juj38dSaWMC/xlIdZaYN113C4B8A0I8ncJRnYCzzdZKnqWoz+mCwYhkkKK5f2MI6fk7OKlFrIBZ1rCPM8sQSw9qLXXEV7clX/R88U6Z1wcup9itfdewsqQLe0I6F1gjvz5r9RFb/2IGH1ouM+JnU38JoqmxViw4jPclxiM02CAb4vVV0BeowlBtSaENC8AkcraGAqSMC/EtIm+tXHLORxDiB1yG7W6i7lyg==;5:x6f0/fbATJfyp62jfGtDeJwDy1ZMTc3S6N+HmubxVwODy0aRJinVWeUt2eGGcgbx6XTr5xpPC3N/3onRwbqaIaiN9RvdTx11f7QV1W3GB96YrrdRkr5i92QGT2Sq6d+FuK0R5iqGmBw0e5wO9KrP93FTe9FHK8XPif437ynXGtEmyo5CCVHWPruPl+yzQFgQfUnuGdGGYWmkFrew9nH+Eg==;7:rSDEx1iBB3U+7VYnmsWvoTOvQ2NCxaM91Nj+KlgWlNAuclS2EJlLnmjHwHbVWm3bmkpKlbI/uJxR3Cc+qsoO8jEHz+nzgJ6YAljiyg/k4AW3Auf1b7/zxirdrx841jFVsS+kbbAnsgiPVD77HY5RlA==
x-ms-office365-filtering-correlation-id: 33232e60-0be2-4195-abb3-08d68b157cbb
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3415;
x-ms-traffictypediagnostic: BYAPR11MB3415:
x-microsoft-antispam-prvs: <BYAPR11MB3415EF30F08ACCDB6CE5943AE36E0@BYAPR11MB3415.namprd11.prod.outlook.com>
x-forefront-prvs: 0939529DE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39860400002)(136003)(366004)(396003)(376002)(189003)(199004)(43544003)(229853002)(3846002)(6116002)(478600001)(6486002)(6436002)(72206003)(11346002)(446003)(186003)(476003)(25786009)(2616005)(6246003)(4744005)(6512007)(105586002)(106356001)(53546011)(26005)(102836004)(486006)(6506007)(386003)(36756003)(31686004)(66066001)(305945005)(71190400001)(54906003)(8936002)(81166006)(81156014)(68736007)(8676002)(71200400001)(7736002)(316002)(256004)(53936002)(52116002)(6916009)(76176011)(31696002)(99286004)(97736004)(2906002)(14454004)(86362001)(78486014)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3415;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: t1mmVOmhJv+0U3uQORqrSlK629DewYaIe1Ld+/2XvnpNwmYJqxFx9ibERQJc1JDBFM4fJznYhwo+1BW4UCwXxQ1wBNKUPWIbPXRyNWtdGR87Hh2fX8t8vm0o4F5OeufBphNfEFNTYsOQZWh+lkGCPJV53T+57byx1AzAWDoVToiI8oRiCsBUsDcNAJAGWdta3KYYC4/DEEHlX0UtjrSZicieosSLu+exo+0njAzL+ZzVuk+ZFsyykK5xD6kLOi3Dj+blogeUYmojvL8pjjmRpxE4h20QECyeA/vOU9r3qqbhGXDdA9WNO8VHZjIc7QRFgSbgYC0kvvZ3VEXCjBUbGUgrll3ZoJqGA/7nmzAG50Ku3VGweFJvz5iZfyU4QJVl9r85j8g7ytY9SSlgx7YVhdEjQpWgqQUGESJfsVKyCl4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4E8F1560C79817489B09621788BC3630@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 33232e60-0be2-4195-abb3-08d68b157cbb
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2019 02:56:10.3139
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3415
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

SGkgS2FsbGUsDQoNCk9uIDIvNC8yMDE5IDc6MDggUE0sIEthbGxlIFZhbG8gd3JvdGU6DQo+IDxB
amF5LkthdGhhdEBtaWNyb2NoaXAuY29tPiB3cml0ZXM6DQo+IA0KPj4gRnJvbTogQWpheSBTaW5n
aCA8YWpheS5rYXRoYXRAbWljcm9jaGlwLmNvbT4NCj4+DQo+PiBBdm9pZCB1c2Ugb2Ygc3RhdGlj
IHZhcmlhYmxlIGZvciBtb25pdG9yIG5ldF9kZXZpY2UgYW5kIG1vdmUgaXQgaW5zaWRlDQo+PiB3
aWxjIHN0cnVjdHVyZS4NCj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBBamF5IFNpbmdoIDxhamF5Lmth
dGhhdEBtaWNyb2NoaXAuY29tPg0KPiANCj4gWy4uLl0NCj4gDQo+PiAtLS0gYS9kcml2ZXJzL3N0
YWdpbmcvd2lsYzEwMDAvbGludXhfbW9uLmMNCj4+ICsrKyBiL2RyaXZlcnMvc3RhZ2luZy93aWxj
MTAwMC9saW51eF9tb24uYw0KPj4gQEAgLTE4LDggKzE4LDYgQEAgc3RydWN0IHdpbGNfd2ZpX3Jh
ZGlvdGFwX2NiX2hkciB7DQo+PiAgCXUxNiB0eF9mbGFnczsNCj4+ICB9IF9fcGFja2VkOw0KPj4g
IA0KPj4gLXN0YXRpYyBzdHJ1Y3QgbmV0X2RldmljZSAqd2lsY193ZmlfbW9uOyAvKiBnbG9iYWwg
bW9uaXRvciBuZXRkZXYgKi8NCj4+IC0NCj4+ICBzdGF0aWMgdTggc3JjYWRkWzZdOw0KPj4gIHN0
YXRpYyB1OCBic3NpZFs2XTsNCj4gDQo+IEkgaG9wZSB5b3UgYXJlIHdvcmtpbmcgb24gbW92aW5n
IHNyY2FkZCBhbmQgYnNzaWQgYXMgd2VsbCAoYXQgc29tZQ0KPiBwb2ludCkuDQo+IA0KDQpZZXMs
IEkgd2lsbCB0YWtlIGNhcmUgb2YgdGhpcyBiZWZvcmUgc3VibWl0dGluZyB0aGUgZHJpdmVyIGZv
ciBhbm90aGVyDQptYWlubGluZSByZXZpZXcuDQoNClJlZ2FyZHMsDQpBamF5DQo=
