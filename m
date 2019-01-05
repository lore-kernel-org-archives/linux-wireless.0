Return-Path: <SRS0=nI2m=PN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F04DC43387
	for <linux-wireless@archiver.kernel.org>; Sat,  5 Jan 2019 16:31:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68F092087F
	for <linux-wireless@archiver.kernel.org>; Sat,  5 Jan 2019 16:31:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbfAEQaQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 5 Jan 2019 11:30:16 -0500
Received: from mail-oln040092064058.outbound.protection.outlook.com ([40.92.64.58]:6235
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726238AbfAEQaP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Jan 2019 11:30:15 -0500
Received: from VE1EUR01FT014.eop-EUR01.prod.protection.outlook.com
 (10.152.2.60) by VE1EUR01HT052.eop-EUR01.prod.protection.outlook.com
 (10.152.3.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1471.13; Sat, 5 Jan
 2019 16:30:11 +0000
Received: from DB7PR07MB5353.eurprd07.prod.outlook.com (10.152.2.59) by
 VE1EUR01FT014.mail.protection.outlook.com (10.152.2.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1471.13 via Frontend Transport; Sat, 5 Jan 2019 16:30:11 +0000
Received: from DB7PR07MB5353.eurprd07.prod.outlook.com
 ([fe80::e1f9:8635:f629:eb8e]) by DB7PR07MB5353.eurprd07.prod.outlook.com
 ([fe80::e1f9:8635:f629:eb8e%4]) with mapi id 15.20.1516.000; Sat, 5 Jan 2019
 16:30:11 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
To:     Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] rtlwifi: rtl8723ae: Take the FW LPS mode handling out
Thread-Topic: [PATCH 1/4] rtlwifi: rtl8723ae: Take the FW LPS mode handling
 out
Thread-Index: AQHUpCvPwWPgT51ue0O3JoR8mq9joKWf+NyAgACTEgCAAE7WAIAABL2A
Date:   Sat, 5 Jan 2019 16:30:11 +0000
Message-ID: <DB7PR07MB53539F1836CE716739F2409AE48F0@DB7PR07MB5353.eurprd07.prod.outlook.com>
References: <DB7PR07MB5353320B147CD781B7993783E48E0@DB7PR07MB5353.eurprd07.prod.outlook.com>
 <f6406c9c-d095-6c9b-55af-0b2fd05c06bb@lwfinger.net>
 <DB7PR07MB5353984E3E78E24150ED3187E48F0@DB7PR07MB5353.eurprd07.prod.outlook.com>
 <7c1f25bc-dfc6-56e2-745c-4607f0f41159@lwfinger.net>
In-Reply-To: <7c1f25bc-dfc6-56e2-745c-4607f0f41159@lwfinger.net>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5PR04CA0011.eurprd04.prod.outlook.com
 (2603:10a6:206:1::24) To DB7PR07MB5353.eurprd07.prod.outlook.com
 (2603:10a6:10:6e::26)
x-incomingtopheadermarker: OriginalChecksum:CB70B3DBDADE2AA4AF829BD3D2C4122C4C49029F5CD07C1DE3AD5ABA3A21D3E2;UpperCasedChecksum:DD6CF3A682E9AAD283E1C17B8DA8930F847F4E701AAD92FA58125F26BFC1B14F;SizeAsReceived:9124;Count:64
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [R41dlNFRIEDU1rT3vJNW9/YirhgufDYo]
x-microsoft-original-message-id: <32bbd903-67b0-96bd-eb3a-fdc2b7e37ef0@hotmail.de>
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;VE1EUR01HT052;6:KhHaZaGl1BcZiP00a/8CMLnEHuUo8dIVTkCapE2B6ipLxUmWc3zNqaMV6IjXC5cgmsnNdGr+P36DOiXrtrse+bg6L1XcPCglnIro5yIzRkxG3IuFBJOt6zkQfbnr3xiwFQbL/xZDq0tKHOVS0npp7PGrAAUt9b4NcMVjt6Xbac7lVTehspai0hROvK0KGU/lBlUrc6IImHDy06iNeIPYfJZD3MWIjIkCfJybuXQvGxkhyGibvjJSdWurvr8JQwletOD0OncD/RQ+69neu688BgyhmGLEABrQ0ruPTSk65Vckfclv6b4LeHExqAhPnhaGdqUX+cp8PYJwTXGZEkjYEWSHd7393FmNt+b7m8WFbOOsylyeoG6w62NtS8fFVwNywQGkn5WATKmkETBMQFlbn8OXhAaRkgJRph02Tj/MKI+vRuai/g8a4bvZrqGlkG/0YCMundAS8Vl5Jepxmhx+HA==;5:btkCXBZ6SIBROhyitvUCGB6YSrKemax3xExq1siKMgeNcQc4fOdGs1sv1k5ow3tL7a3DpwxxcOjxoKtAueIENr+1IgvhSaGLb00VJ400VQxIISRvAMkOmazbj72Hk/s0nojkKMSJG+Pwpzoy6y8xX4hQw8ClWrJN3vohKk2hC+Y=;7:MvOroMq/GGUpeccwgoPxNmAokZEM5rHtBUZam2cuKbbhzzzGp66pmwlHrRir8bWlIWZdhlczjN2/zq1rcMog445Nvt2q9lf5sMBTPebKpPR1jmECGqRWfNCWFeY/NoWf86RTttXaGsLMeYtHZ+rdbQ==
x-incomingheadercount: 64
x-eopattributedmessage: 0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(201702061078)(5061506573)(5061507331)(1603103135)(2017031320274)(2017031323274)(2017031324274)(2017031322404)(1601125500)(1603101475)(1701031045);SRVR:VE1EUR01HT052;
x-ms-traffictypediagnostic: VE1EUR01HT052:
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(4566010)(82015058);SRVR:VE1EUR01HT052;BCL:0;PCL:0;RULEID:;SRVR:VE1EUR01HT052;
x-microsoft-antispam-message-info: 2HtWXOiFKp7PgAh+Myzs30xS14Ecbc1eRdDSSJu1CWI7ZL8HYP+lC2vuCzvvuJcU
Content-Type: text/plain; charset="utf-8"
Content-ID: <6618B1DC5EB6214386C1429A0A8D4981@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: d4d70346-2c10-4f39-8c00-e767963926d9
X-MS-Exchange-CrossTenant-Network-Message-Id: b2e04df9-420e-45b7-39c5-08d6732b1043
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: d4d70346-2c10-4f39-8c00-e767963926d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2019 16:30:10.9226
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1EUR01HT052
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

T24gMS81LzE5IDU6MTMgUE0sIExhcnJ5IEZpbmdlciB3cm90ZToNCj4+IGJ1dCB0aGlzIHdvcmtz
Og0KPj4NCj4+IG1vZHByb2JlIHJ0bDg3MjNhZSBkZWJ1Z19tYXNrPTB4RkZGRkZGRkYgZGVidWdf
bGV2ZWw9NSBzd2xwcz0xIGZ3bHBzPTANCj4gDQo+IFllcywgSSB0aGluayB0aGF0IGlzIGEgYmV0
dGVyIHRoaW5nIHRvIGRvIG5vdy4gSWYgYW5kIHdoZW4gUmVhbHRlayBmaW5kcyBhIGZpcm13YXJl
IGJ1ZywgYW5kIHdoZW4gdGhlIG5ldyBmaXJtd2FyZSBpcyByZWFkaWx5IGF2YWlsYWJsZSwgdGhl
biB0aGVyZSB3aWxsIG5vdCBiZSBhIGxvdCBvZiBjb2RlIHRvIHJlaW5zdGFsbC4NCj4gDQoNCk9r
YXksIG15IGFzc3VtcHRpb24gb2YgaG93IHRoZSBmaXJtd2FyZSBidWcgIndvcmtzIiBpcyB0aGlz
Og0KDQpPbmNlIHRoZSBmaXJtd2FyZSBlbnRlcnMgcG93ZXIgc2F2ZSBtb2RlLCBpdCB3aWxsIGRl
bGl2ZXIgZXhhY3RseSBvbmUgKG9yIG1heWJlIHR3bykNClJ4IGludGVycnVwdHMuIElmIG9uZSBv
ZiB0aG9zZSB0cmlnZ2VycyB0aGUgZHJpdmVyIHRvIGxlYXZlIHRoZSBwb3dlciBzYXZlIG1vZGUg
YWdhaW4sDQp0aGUgZmlybXdhcmUgY29udGludWVzIHRvIHdvcmsuDQpJZiB0aG9zZSBhcmUgb25s
eSBiZWFjb25zLCB0aGV5IHdvbid0IGxlYXZlIHRoZSBwb3dlciBzYXZlIG1vZGUuICBUaGVuIHRo
ZSBmaXJtd2FyZQ0Kd2lsbCB1c3VhbGx5IG5vdCByZWNvdmVyLg0KU2luY2UgcHJpb3IgdG8gY29t
bWl0IDg3M2ZmZTE1NGFlMCAoInJ0bHdpZmk6IEZpeCBsb2dpYyBlcnJvciBpbiBlbnRlci9leGl0
IHBvd2VyLXNhdmUgbW9kZSIpDQp0aGUgcG93ZXIgc2F2ZSBtb2RlIHdhcyBvbmx5IGFjdGl2YXRl
ZCB3aGVuIHRoZXJlIF9pc18gYnVzeSB0cmFmZmljLCB0aGUgbmV4dA0KcGFja2V0IGRpZCB1c3Vh
bGx5IHdha2UgdGhlIGZpcm13YXJlLCByYXJlbHkgaXQgZGlkIGZyZWV6ZSBob3dldmVyLg0KT3Ro
ZXIgdGhpbmdzIGxpa2UgY2hhbmdpbmcgdGhlIGNja19wYWNrZXRfZGV0ZWN0aW9uX3RocmVzaG9s
ZCBvciByZWZyZXNoX3JhdGVfYWRhcHRpdmVfbWFzaw0KY2FuIGFsc28ga2ljayB0aGUgZmlybXdh
cmUgYmFjayB0byBsaWZlLg0KDQpIb3BlIHRoaXMgaGVscHMgdG8gdHJhY2sgZG93biB0aGUgcm9v
dCBjYXVzZSBvZiB0aGlzIGJ1Zy4NCg0KDQpUaGFua3MNCkJlcm5kLg0K
