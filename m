Return-Path: <SRS0=TVdy=PP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 905E9C43387
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 09:16:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4FD56206B7
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 09:16:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="BehyUUzR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbfAGJQx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 7 Jan 2019 04:16:53 -0500
Received: from mail-eopbgr730127.outbound.protection.outlook.com ([40.107.73.127]:40112
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726402AbfAGJQw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Jan 2019 04:16:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EzqJvdwnxY3PPBSnkz+DXP5Pp89SL5kUF80Pt/00fr8=;
 b=BehyUUzRQi6dwfv2daRXs3B3qg36gG/2TAE76YGpmg7ewJWezBXAA4WMqiSUBsRgjm3XYYOPTQSbrEJi5OmRpCXeldyTV9r955KqTfwfM37llQ93jNHZeTydoI8ep6BKx4VgQ3JwFpvGDcor1yNUEaSkYi8BMYIuFVXOm07+AcY=
Received: from DM6PR06MB5804.namprd06.prod.outlook.com (20.179.161.141) by
 DM6PR06MB5418.namprd06.prod.outlook.com (20.178.30.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1495.6; Mon, 7 Jan 2019 09:16:49 +0000
Received: from DM6PR06MB5804.namprd06.prod.outlook.com
 ([fe80::14e6:e072:bc55:7bea]) by DM6PR06MB5804.namprd06.prod.outlook.com
 ([fe80::14e6:e072:bc55:7bea%4]) with mapi id 15.20.1495.011; Mon, 7 Jan 2019
 09:16:49 +0000
From:   Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
To:     James Hughes <james.hughes@raspberrypi.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Double Lo <Double.Lo@cypress.com>
Subject: Re: [PATCH 1/2] brcmfmac: fix system warning message during wowl
 suspend
Thread-Topic: [PATCH 1/2] brcmfmac: fix system warning message during wowl
 suspend
Thread-Index: AQHUozh22Qq2I1ZY/kmgrkvLrXjwA6WdTq8AgAY+RIA=
Date:   Mon, 7 Jan 2019 09:16:49 +0000
Message-ID: <017519b9-ee18-a473-6d70-ca86f2136ae1@cypress.com>
References: <1546501565-40752-1-git-send-email-chi-hsien.lin@cypress.com>
 <1546501565-40752-2-git-send-email-chi-hsien.lin@cypress.com>
 <CAE_XsM+mdHkwMF3PEimVJBpLd=oMmuvK1uDdA7y8uJT8hYNfbA@mail.gmail.com>
In-Reply-To: <CAE_XsM+mdHkwMF3PEimVJBpLd=oMmuvK1uDdA7y8uJT8hYNfbA@mail.gmail.com>
Reply-To: Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [61.222.14.99]
user-agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
x-clientproxiedby: TY2PR02CA0027.apcprd02.prod.outlook.com
 (2603:1096:404:a6::15) To DM6PR06MB5804.namprd06.prod.outlook.com
 (2603:10b6:5:1a6::13)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM6PR06MB5418;6:HHEviyxvrqsc7koSZ+93aT8e1SNx3HmI3nehzXNKd5ScV4VV4+rTOjMYq+EDoe6+tlqEAel425IRsavld2En0zXXBk/PtKRMtBzfA2gWkJFUETl3mwOsJPvzvSaTcIdpqRtg8r9NYvhNQKcG3Tk6+QF0G1sKErcdXIqu1yU8KRo02RzuSKl4ohZrJdIB5CJG8xrkhSauIn631UcjKVrcNI3vhbruKKvbFuOn5md2ZRgbmbqfBBnW4vSMKFd7su1j+efFqZyC8fnqgNs91xubQNHjF1Lyx5z5vpUfD+QQu/P76Mqt59BHWjouJZkCtoodzAZkDlmWlAS9hiwGktdR0oQphCjINUK7/7Qs+lVWcnmkg+vF4UxWKDp5Rfx2vzZ1NGvPb5C0EuZaiP8j7tFcHfIkgZyWrSmgjY2ww46znm2JuB6tXUfYNEBr0Twq2GpsO/yOczE71t0a0OvYnSdtLg==;5:yydLwmNtuS3cnXJU6kpEvCvECOwT+3pKPRaja6JA0B3u/JBg8NXLSHNbBv3q0eLyG7D8K1UJkWFsu2OoFrZe7My79EaG525bDztpikhZR0DkPMF5ITCFG9uQz2vg3xCpUzxl2lFAnfgRRkhnwUNVSzZd9Z5MKETELizNsBlFNWTQY72Dn7VzHnDuTbWG9fHRrv9wHhUSJ36fVQdlXu4I2A==;7:N1J+mgI/KRqeQFf2onAjnoPHcrzi38Sg4QEhozPcOLWl+H5z/R9736zYuk70Z27q0FDPb4byRFkFNYhUstIk0QGE5CFFb0H+Amrvr5OFZsdLjW8tkIEoXk65N2fzMmoT3NpCL/8hFS3en12dfPPbGw==
x-ms-office365-filtering-correlation-id: 70542520-72f6-45fe-c69e-08d67480daa7
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:DM6PR06MB5418;
x-ms-traffictypediagnostic: DM6PR06MB5418:
x-microsoft-antispam-prvs: <DM6PR06MB541818E5B3195529E24699C5BB890@DM6PR06MB5418.namprd06.prod.outlook.com>
x-forefront-prvs: 0910AAF391
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(136003)(39860400002)(396003)(376002)(189003)(199004)(71190400001)(5660300001)(65826007)(11346002)(97736004)(65956001)(65806001)(66066001)(71200400001)(4326008)(86362001)(25786009)(31696002)(6246003)(14454004)(6512007)(72206003)(3450700001)(478600001)(107886003)(305945005)(7736002)(8936002)(8676002)(81166006)(81156014)(6116002)(64126003)(2906002)(3846002)(53936002)(6916009)(486006)(36756003)(31686004)(58126008)(229853002)(316002)(54906003)(15650500001)(6436002)(6486002)(14444005)(256004)(52116002)(99286004)(386003)(53546011)(106356001)(6506007)(2616005)(446003)(105586002)(102836004)(186003)(26005)(68736007)(476003)(76176011)(43066004);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR06MB5418;H:DM6PR06MB5804.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: VG1vzkx3rRmMfFGltDCdMS5aNNGE5iyg3S28L1WzswuQuPNRZKQjd21XEOwmWzEzu4rztqIz0spTO3+3ozFFCZfrLYAV5kCWgPV2Iru9aZVd6KI9JopBApSx/P5vCqoAeUOEuZAH/FszPARFWDMk54ZUyMe4FoU+32omr4BXtm4rBQuqOIVrgpy5QExs5WKB+H3FgRDJE+NrXwGlnwniFRxsmC0BMw3+s6HHY4SAuJ9te9koVaVr2lVvlhzgnhwrkLX2Y1RZkuOsqNKPLVIMu1UQcP0tlLMgKhvTtJH1E363bndp5GappDXf4iAeD9ux
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <94D13BE49B93EA438104190F18B046A2@namprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70542520-72f6-45fe-c69e-08d67480daa7
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2019 09:16:49.6162
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR06MB5418
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

DQoNCk9uIDAxLzAzLzIwMTkgNTo1NiwgSmFtZXMgSHVnaGVzIHdyb3RlOg0KPiBPbiBUaHUsIDMg
SmFuIDIwMTkgYXQgMDc6NDYsIENoaS1Ic2llbiBMaW4gPENoaS1Ic2llbi5MaW5AY3lwcmVzcy5j
b20+IHdyb3RlOg0KPj4NCj4+IEZyb206IExvLUhzaWFuZyBMbyA8ZG91YmxlLmxvQGN5cHJlc3Mu
Y29tPg0KPj4NCj4+IFRoZXJlIGlzIGEgc3lzdGVtIHdhcm5pbmcgbWVzc2FnZSwgd2Fybl9zbG93
cGF0aC1mbXQsIGR1cmluZyBzdXNwZW5kDQo+PiB3aGlsZSB1c2luZyBzdXBwbGljYW50IGpvaW4g
QVAgYW5kIGVuYWJsZSB3b3dsIGZlYXR1cmUgYnkgSVcgY29tbWFuZC4NCj4+IEl0J3MgY3Vhc2Vk
IGJ5IGJyY21mX3Bub19yZW1vdmVfcmVxdWVzdCBwYXRoIGNhbid0IGZpbmQgdGhlIHJlcWlkLg0K
Pj4gVGhpcyBmaXggd2lsbCBub3QgZ28gdG8gcmVtb3ZlIHBubyByZXF1ZXN0IGZ1bmN0aW9uIGlm
IHRoZXJlIGlzIG5vDQo+PiBwbm8gc2Nhbi4NCj4gDQo+IFR5cG8gaW4gdGhlIGNvbW1pdCBtZXNz
YWdlIGBjdWFzZWRgDQoNCkphbWVzLA0KDQpUaGFua3MgZm9yIGNhdGNoaW5nIHRoaXMuIEkndmUg
c3VibWl0dGVkIFYyIHRvIGZpeCBib3RoIHR5cG9zLg0KDQo+IA0KPj4NCj4+IFNpZ25lZC1vZmYt
Ynk6IExvLUhzaWFuZyBMbyA8ZG91YmxlLmxvQGN5cHJlc3MuY29tPg0KPj4gU2lnbmVkLW9mZi1i
eTogQ2hpLUhzaWVuIExpbiA8Y2hpLWhzaWVuLmxpbkBjeXByZXNzLmNvbT4NCj4+IC0tLQ0KPj4g
ICBkcml2ZXJzL25ldC93aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvcG5vLmMg
fCA1ICsrKysrDQo+PiAgIDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKykNCj4+DQo+PiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21m
bWFjL3Buby5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21m
bWFjL3Buby5jDQo+PiBpbmRleCBmZmEyNDNlMmUyZDAuLjU1OTc0YTQzNzk2YSAxMDA2NDQNCj4+
IC0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2Jyb2FkY29tL2JyY204MDIxMS9icmNtZm1hYy9w
bm8uYw0KPj4gKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2Jy
Y21mbWFjL3Buby5jDQo+PiBAQCAtNDk2LDYgKzQ5NiwxMSBAQCBpbnQgYnJjbWZfcG5vX3N0b3Bf
c2NoZWRfc2NhbihzdHJ1Y3QgYnJjbWZfaWYgKmlmcCwgdTY0IHJlcWlkKQ0KPj4gICAgICAgICAg
YnJjbWZfZGJnKFRSQUNFLCAicmVxaWQ9JWxsdVxuIiwgcmVxaWQpOw0KPj4NCj4+ICAgICAgICAg
IHBpID0gaWZwX3RvX3BubyhpZnApOw0KPj4gKw0KPj4gKyAgICAgICAvKiBObyBQTk8gcmVxZXVz
ZXQgKi8NCj4gDQo+IFR5cG8uIGByZXFldXNldGANCj4gDQo+PiArICAgICAgIGlmICghcGktPm5f
cmVxcykNCj4+ICsgICAgICAgICAgICAgICByZXR1cm4gMDsNCj4+ICsNCj4+ICAgICAgICAgIGVy
ciA9IGJyY21mX3Bub19yZW1vdmVfcmVxdWVzdChwaSwgcmVxaWQpOw0KPj4gICAgICAgICAgaWYg
KGVycikNCj4+ICAgICAgICAgICAgICAgICAgcmV0dXJuIGVycjsNCj4+IC0tDQo+PiAyLjEuMA0K
Pj4NCg==
