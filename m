Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9ACDC169C4
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 18:40:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6363B20856
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 18:40:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="honZM4tU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729307AbfA2SkL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 13:40:11 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:38215 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727821AbfA2SkL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 13:40:11 -0500
X-IronPort-AV: E=Sophos;i="5.56,537,1539673200"; 
   d="scan'208";a="25906153"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES128-SHA; 29 Jan 2019 11:40:10 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.37) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Tue, 29 Jan 2019 11:40:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l3MOI3BfH5T8BD1yvuVBNI58Q/4T684SwpOo+TZqcEw=;
 b=honZM4tUs3y+VYL0LX9kT+ikLSH3hcX1LlHOeXP5MV99T2WfbGswN58AXE6ZETsVPXd6xSIlajC7mT6NrotXFDBkseV8H47mZjMAmXq+QXwHbQOS3ozOXYIWBdz8O45Rbs7HM5506aSa2pWWkWNhvT+M1iA2FZpl+KqUzkMqMrk=
Received: from MWHPR11MB1373.namprd11.prod.outlook.com (10.169.234.7) by
 MWHPR11MB1933.namprd11.prod.outlook.com (10.175.54.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1558.16; Tue, 29 Jan 2019 18:40:07 +0000
Received: from MWHPR11MB1373.namprd11.prod.outlook.com
 ([fe80::58dc:240f:c0ee:37ea]) by MWHPR11MB1373.namprd11.prod.outlook.com
 ([fe80::58dc:240f:c0ee:37ea%6]) with mapi id 15.20.1558.021; Tue, 29 Jan 2019
 18:40:07 +0000
From:   <Adham.Abozaeid@microchip.com>
To:     <dan.carpenter@oracle.com>
CC:     <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <gregkh@linuxfoundation.org>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: Re: [PATCH 1/1] staging: wilc1000: remove redundant reset of station
 statistics
Thread-Topic: [PATCH 1/1] staging: wilc1000: remove redundant reset of station
 statistics
Thread-Index: AQHUt1orshEXRJwd4U+dDCEbtFaKD6XF7bMAgACivoA=
Date:   Tue, 29 Jan 2019 18:40:04 +0000
Message-ID: <292a81c3-f9d6-9f19-966f-3c62acf09b70@microchip.com>
References: <20190128223111.19400-1-adham.abozaeid@microchip.com>
 <20190129083952.GM1795@kadam>
In-Reply-To: <20190129083952.GM1795@kadam>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.175.253.81]
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
x-clientproxiedby: BYAPR02CA0052.namprd02.prod.outlook.com
 (2603:10b6:a03:54::29) To MWHPR11MB1373.namprd11.prod.outlook.com
 (2603:10b6:300:24::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Adham.Abozaeid@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;MWHPR11MB1933;6:BZoIg0tpbwjTGLEYhJE8ADt7Wm50Z28xFg8REZ7AaV2fKzGp5AN7h+MlD9o5BWLKBS/k/FZlSrdL8UB4Z/YZP/pnoTBnA8BmQWy+X4PnvC+k+U4Nvf2E09ge3hJAGlNsYWPKIvQUliGlB39esIdoV/dIczHzrYeqNyXv2nfYWqFv6kIP6Y1tc82c9VLQ3JV1n7UDaXu5Te5zdjmiSJoF+3erAQXHbWN/pWcdpwDOgHOI8ORhs8ylG6P+07k6WgRCd0Q2VXxsJm581DtzkeMn0hC3xqUcG2XPvMoViPeg49pLuyN6Fkb8JcOrUuVkInvqKhBJIO25MofwfAWLL8CYuLYXglhs/G/0KbhUaGdKwsf+13Xd6vOqHT78c4MF5sRS6fErZh1l8g/uRfWU9HhgULl46f7kOTnyb6Dzw2QPfnjxZuzyH3AIcOgAY9zvyKj71Xn/sQxiQwZLSUCJc9P2VQ==;5:MtrC30II78jo4qiVWEGQ8WxtjStIKL6C+B7Vtlz5jWr+AwdVVyEu1RwlCp0kMjAacuI0gpiMVw5ulfCB/IRwONogztRJDDkfYnZ+OSQlJWBD7QAaIF/2PD7457+7oeq7TMRrM0tnacRSClVz9EeZ5iAmsygwytPL+caYxWijGKMKChqzwwK3QuoOWLuqZZ7p634dLKyv0yib6u6/DSDJiA==;7:rgMmMcZDXjA1hqTn0Mz/ekcDz3ugVqX1vEvKfB9ATO5W3AWlwg69vSk50NX7VMLEeX13rmF264iyHySJP1+OBb9Ztyb3T+BkPmL7prq4aKtnNqRm7CeUdaKDMV4YVSSzjal85sOqrhr0u0wbAnUwKw==
x-ms-office365-filtering-correlation-id: a0e99c73-d2f3-4f94-4531-08d686192bc3
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:MWHPR11MB1933;
x-ms-traffictypediagnostic: MWHPR11MB1933:
x-microsoft-antispam-prvs: <MWHPR11MB19335FAC8BD9A0B3220B354D8D970@MWHPR11MB1933.namprd11.prod.outlook.com>
x-forefront-prvs: 093290AD39
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(396003)(136003)(346002)(39860400002)(189003)(199004)(31686004)(8936002)(8676002)(81156014)(64126003)(229853002)(6116002)(3846002)(97736004)(105586002)(31696002)(54906003)(71200400001)(106356001)(86362001)(81166006)(316002)(71190400001)(58126008)(6666004)(36756003)(14454004)(386003)(53546011)(26005)(76176011)(186003)(2616005)(446003)(478600001)(102836004)(6506007)(52116002)(11346002)(256004)(486006)(6246003)(6512007)(99286004)(107886003)(53936002)(476003)(7736002)(6436002)(66066001)(65956001)(305945005)(72206003)(68736007)(6486002)(2906002)(65806001)(6916009)(25786009)(4326008)(65826007);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR11MB1933;H:MWHPR11MB1373.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: iZmAYmkQhstYrvJWsXlWpnwYy7gscRXthkIfNFWm3sInW5S0PJMjULx2aOXFRKDXQisFk0hlEsQ9l2FKsDgYj8DVLYxOtvhiv7+CK7kLESyxulMEErrglhmpHdjGdiSClAZFI9nlOz1PYTw+WrKBuOvOKbgxmK3fiH/aVhIbfxDv7ri0htAKMhZia5nwNTy1mb/Q4m2H42DPdsjiRk+EDF+iAIZ0De+8IO8fRVsdFKEvsTxhnI15yS5pycKCmHvKk1fUkJ4UEt4V9miHuh1CCaiAwqlkCSkWQUCnkrWTJz603/vKNZxzWe4EThr6ICcj5ARoE20ClPbozEmHKTpEZqBJqfGWixdrproCWBDUlOGDcQlNDoSXoE4MqSzrp9lT2kzU9S8JyTHbcOkaUT4IDxTrWv+5oMbjJFrgYcJ3Wtk=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C326D5A330E7AC4683F6C0251D7FC6F9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a0e99c73-d2f3-4f94-4531-08d686192bc3
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2019 18:39:55.2432
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1933
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

DQpPbiAxLzI5LzE5IDE6MzkgQU0sIERhbiBDYXJwZW50ZXIgd3JvdGU6DQo+IE9uIE1vbiwgSmFu
IDI4LCAyMDE5IGF0IDEwOjM4OjIwUE0gKzAwMDAsIEFkaGFtLkFib3phZWlkQG1pY3JvY2hpcC5j
b20gd3JvdGU6DQo+PiBGcm9tOiBBZGhhbSBBYm96YWVpZCA8YWRoYW0uYWJvemFlaWRAbWljcm9j
aGlwLmNvbT4NCj4+DQo+PiBEcml2ZXIgc2VuZHMgY29uZmlndXJhdGlvbiB3aWRzIHRvIHJlc2V0
IGNvbm5lY3Rpb24gc3RhdGlzdGljcyBpbiB0aGUNCj4+IGRldmljZSwgYnV0IHRoZSBkZXZpY2Ug
YWxyZWFkeSByZXNldHMgaXQgd2hlbiBzdGFydGluZyBhIG5ldyBjb25uZWN0aW9uDQo+Pg0KPj4g
U2lnbmVkLW9mZi1ieTogQWRoYW0gQWJvemFlaWQgPGFkaGFtLmFib3phZWlkQG1pY3JvY2hpcC5j
b20+DQo+PiAtLS0NCj4+ICBkcml2ZXJzL3N0YWdpbmcvd2lsYzEwMDAvaG9zdF9pbnRlcmZhY2Uu
YyB8IDIwICstLS0tLS0tLS0tLS0tLS0tLS0tDQo+PiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0
aW9uKCspLCAxOSBkZWxldGlvbnMoLSkNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFn
aW5nL3dpbGMxMDAwL2hvc3RfaW50ZXJmYWNlLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2lsYzEwMDAv
aG9zdF9pbnRlcmZhY2UuYw0KPj4gaW5kZXggZmJiNjFkZTIwMzA0Li4yODY2ODVlNDI2YzEgMTAw
NjQ0DQo+PiAtLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2lsYzEwMDAvaG9zdF9pbnRlcmZhY2UuYw0K
Pj4gKysrIGIvZHJpdmVycy9zdGFnaW5nL3dpbGMxMDAwL2hvc3RfaW50ZXJmYWNlLmMNCj4+IEBA
IC0zNDIsMjkgKzM0MiwxMSBAQCBzdGF0aWMgaW50IHdpbGNfc2VuZF9jb25uZWN0X3dpZChzdHJ1
Y3Qgd2lsY192aWYgKnZpZikNCj4+ICB7DQo+PiAgCWludCByZXN1bHQgPSAwOw0KPj4gIAlzdHJ1
Y3Qgd2lkIHdpZF9saXN0WzhdOw0KPiAgICAgICAgICAgICAgICAgICAgXl5eXl5eXl5eXl4NCj4g
V2UgY291bGQgbWFrZSB0aGlzIGFycmF5IHNtYWxsZXIgYXMgd2VsbC4NCkFncmVlLiBXaWxsIHNl
bmQgdjIgd2l0aCBzbWFsbGVyIGFycmF5Lg0KPg0KPj4gLQl1MzIgd2lkX2NudCA9IDAsIGR1bW15
dmFsID0gMDsNCj4+ICsJdTMyIHdpZF9jbnQgPSAwOw0KPiByZWdhcmRzLA0KPiBkYW4gY2FycGVu
dGVyDQoNClRoYW5rcywNCg0KQWRoYW0NCg0K
