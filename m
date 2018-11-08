Return-Path: <SRS0=/7yp=NT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1433DC0044C
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 00:56:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCAC52086C
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 00:56:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="NjSn5Mrw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BCAC52086C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbeKHK3C (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Nov 2018 05:29:02 -0500
Received: from mail-eopbgr810041.outbound.protection.outlook.com ([40.107.81.41]:4184
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727786AbeKHK3B (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Nov 2018 05:29:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RlK3KgIBiHZeRaqgWiyUEDHjchLivnlG68uCtQXk7uI=;
 b=NjSn5Mrw7IuDRp3ogNbzCHg2FomyakgBc7j31G/qDYl9vy1N/Gorr/LoOlRy3j5qBamJk7vZHVsXuOZ71nDC5n9/TgH8S4Qr9plaDwsoJRkLo348gbuR3M6RgrLySniH+qquPgq1O89+/6xFya4uFjJxcz0wfgANpu0nSrnCZjk=
Received: from MWHPR05MB3326.namprd05.prod.outlook.com (10.174.174.165) by
 MWHPR05MB3440.namprd05.prod.outlook.com (10.174.248.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.14; Thu, 8 Nov 2018 00:55:25 +0000
Received: from MWHPR05MB3326.namprd05.prod.outlook.com
 ([fe80::946e:2ae1:c8ec:d37a]) by MWHPR05MB3326.namprd05.prod.outlook.com
 ([fe80::946e:2ae1:c8ec:d37a%7]) with mapi id 15.20.1339.009; Thu, 8 Nov 2018
 00:55:25 +0000
From:   Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
To:     Tamizh chelvam <tamizhr@codeaurora.org>
CC:     "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Ben Greear <greearb@candelatech.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: Re: [PATCH 0/4] cfg80211/mac80211: Add support for TID specific
 configuration
Thread-Topic: [PATCH 0/4] cfg80211/mac80211: Add support for TID specific
 configuration
Thread-Index: AQHUajCMPH74nell30OOvFt68zLh96VFJxGA
Date:   Thu, 8 Nov 2018 00:55:25 +0000
Message-ID: <2008ad85-3f13-cc6b-3fc2-d614f8422d68@quantenna.com>
References: <1540230918-27712-1-git-send-email-tamizhr@codeaurora.org>
In-Reply-To: <1540230918-27712-1-git-send-email-tamizhr@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR03CA0018.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::31) To MWHPR05MB3326.namprd05.prod.outlook.com
 (2603:10b6:301:3d::37)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=igor.mitsyanko.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [12.131.200.68]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;MWHPR05MB3440;6:bWVWOVBaEwzBV8FpI8LM6DvvUV3bPSk/0sjbi3ZfX48/C/PtE5V0smIy1CdMuROVb4uzsZ8/DLAH5zdEW0PletcjGjVCzZoahV/n8Eh43OZLpF4WZk/VuU1PKxrIjOomT2A05xrXS7pCoMkrUYFHUTAsfVf1XjLMA36WV33eXLexbxHtWBMsVZBhU/np8fx6J+7FMez5CT7E8fFCTNq0ETy1zuf0FN7ZMMTnNRhlZAXnb4AF713qlCxXGb6vKiy4LGMnR5dX39LYT5DC+iYXZ4U5cutSiIlX15wW+5p4qQIddsWiZfsFRPCy9Df2i6Z6DLHymwxMaEZVb43TWN7B3tzsZCAPXUgzvot11acceLGtcCs2N8G2Bt1CjIU5XeWlHChogIaOkeewJHOrGMZLZkJ+78jPVitf6elmsAato585purA2ovN+zZKclxfZTx2sr9PDhmhzQoCWbPMjgjtqw==;5:KRe3/jXJHYAlQXkn6XklL1aALwp1IG6+vDr3bpCHKoC7xCh7OiAvHM0l9sdtRGngpuQFuJl57k45vuDXg1Yvcid7VMUukP61Nj1GQzTi7vD7/7UIUyWGglbjDWSygKcK/utcbpBcV0zFrpQVNOkvy5Cs/249GH3ctbd8tLaHOpU=;7:SJg1teX09OT9RZVA61JphvtFfl882FUV33GRhW8VOmIZwW48OHu07vQT03cw3E2Vz/xx2U7451s8p4h2Bqj2cBcSMAotuJL/7cLnDo3LrpyvVw9g1znCtPAdotkqtF7wH5f1VrnAZJO2mY9XkKYlkQ==
x-ms-office365-filtering-correlation-id: 33314ca8-63a5-4634-9547-08d64514de24
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:MWHPR05MB3440;
x-ms-traffictypediagnostic: MWHPR05MB3440:
x-microsoft-antispam-prvs: <MWHPR05MB34401B841CC25B0F63A23AFCB0C50@MWHPR05MB3440.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(269456686620040);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(10201501046)(3231382)(944501410)(52105095)(93006095)(93001095)(3002001)(148016)(149066)(150057)(6041310)(20161123560045)(20161123564045)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(201708071742011)(7699051)(76991095);SRVR:MWHPR05MB3440;BCL:0;PCL:0;RULEID:;SRVR:MWHPR05MB3440;
x-forefront-prvs: 0850800A29
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(376002)(39850400004)(346002)(396003)(189003)(199004)(4326008)(31686004)(25786009)(106356001)(8676002)(14444005)(99286004)(52116002)(105586002)(8936002)(81156014)(5660300001)(107886003)(54906003)(256004)(36756003)(6916009)(81166006)(478600001)(446003)(486006)(76176011)(11346002)(7736002)(305945005)(316002)(6512007)(2900100001)(2616005)(66066001)(14454004)(6486002)(476003)(6436002)(86362001)(31696002)(386003)(6246003)(53936002)(102836004)(97736004)(2906002)(53546011)(6506007)(229853002)(71200400001)(68736007)(6116002)(71190400001)(186003)(3846002)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR05MB3440;H:MWHPR05MB3326.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: xdix4+8bSbGSCg5CO9rK9h0vIiZ/+usSsE7d7P4uHijKq5VIFCa8RCTKQKEfQLrOPF6T9lKQ1fmJ/gJmErEWLyWvcMe8lv2bNAft/8d2mplPaqm3KcDsN8xPzyKCDbHPZddtVFGwbGQ2WDn5RjYOqjVXw+kAd2F7E7zPcDmle2RTstyYZiej1m5LE6GnYX4ysOA4piw4M7HMABRiW9EICXptMTuL3qwmiXwGOpJfoYgYrDiYzNkKxT5xF04xz3N6pITVMyaV4/thVhdO9gt7HKL5m5HLLwkcs3nG3euC4KeAkLhKFRjgp8C77YHZrPLh4FWPtte0t95vdx/VNF/BE8evwDz7VsIhMwyYpVH70Sw=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <465B98ACDD0BCB40985AC886ABB4557C@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33314ca8-63a5-4634-9547-08d64514de24
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2018 00:55:25.3219
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR05MB3440
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

T24gMTAvMjIvMjAxOCAxMDo1NSBBTSwgVGFtaXpoIGNoZWx2YW0gd3JvdGU6DQo+IA0KPiBBZGQg
aW5mcmFzdHJ1Y3R1cmUgZm9yIHBlciBUSUQgYWdncmVnYXRpb24vcmV0cnkgY291bnQgY29uZmln
dXJhdGlvbnMNCj4gc3VjaCBhcyByZXRyeSBjb3VudCBhbmQgQU1QRFUgYWdncmVnYXRpb24gY29u
dHJvbChkaXNhYmxlL2VuYWJsZSkuDQo+IEluIHNvbWUgc2NlbmFyaW8gcmVkdWNpbmcgdGhlIG51
bWJlciBvZiByZXRyeSBjb3VudCBmb3IgYSBzcGVjaWZpYyBkYXRhDQo+IHRyYWZmaWMgY2FuIHJl
ZHVjZSB0aGUgbGF0ZW5jeSBieSBwcm9jZWVkaW5nIHdpdGggdGhlIG5leHQgcGFja2V0DQo+IGlu
c3RlYWQgb2YgcmV0cnlpbmcgdGhlIHNhbWUgcGFja2V0IG1vcmUgdGltZS4gVGhpcyB3aWxsIGJl
IHVzZWZ1bA0KPiB3aGVyZSB0aGUgbmV4dCBwYWNrZXQgY2FuIHJlc3VtZSB0aGUgb3BlcmF0aW9u
IHdpdGhvdXQgYW4gaXNzdWUuDQo+IEhlcmUgYWRkZWQgTkw4MDIxMV9DTURfU0VUX1RJRF9DT05G
SUcgdG8gc3VwcG9ydCB0aGlzIG9wZXJhdGlvbiBieQ0KPiBhY2NlcHRpbmcgcmV0cnkgY291bnQg
YW5kIEFNUERVIGFnZ3JlZ2F0aW9uIGNvbnRyb2wuDQo+IFRoaXMgY29tbWFuZCBjYW4gYWNjZXB0
IFNUQSBtYWMgYWRkcmVlc3MgdG8gbWFrZSB0aGUgY29uZmlndXJhdGlvbg0KPiBzdGF0aW9uIHNw
ZWNpZmljIHJhdGhlciB0aGFuIGFwcGx5aW5nIHRvIGFsbCB0aGUgY29ubmVjdGVkIHN0YXRpb25z
DQo+IHRvIHRoZSBuZXRkZXYuDQo+IA0KDQpJdCdzIG5vdCBpbW1lZGlhdGVseSBjbGVhciBob3cg
dG8gbWFrZSB1c2Ugb2YgdGhlc2Ugc2V0dGluZ3MsIGhlcmUgYXJlIA0Kc2V2ZXJhbCBjb21tZW50
czoNCg0KMS4gV2hhdCBtYXggcmV0cnkgY291bnQgbGltaXQgc2hvdWxkIGFjdHVhbGx5IGJlIGFw
cGxpZWQgdG8/IFJldHJpZXMgDQpkZWNpc2lvbnMgYXJlIGluIGEgcmF0ZSBhZGFwdGF0aW9uIGRv
bWFpbiwgaXQgc2hvdWxkIGtub3cgaG93IG1hbnkgDQpyZXRyaWVzIHNob3VsZCBiZSBkb25lIG9u
IGVhY2ggcmF0ZSwgc2luZ2xlICJtYXggcmV0cnkiIHZhbHVlIHdpbGwgbm90IA0Kc3VmZmljZS4g
Rm9yIGV4YW1wbGUsIGl0IGNhbiByZXRyeSB0d2ljZSBvbiBNQ1M5LCB0d2ljZSBvbiBNQ1M3LCB0
aHJlZSANCnRpbWVzIG9uIE1DUzUgb3Igc29tZXRoaW5nIGxpa2UgdGhhdC4NCg0KSSdtIG5vdCBm
YW1pbGlhciB3aXRoIHdoYXQgQVRIMTBrIGlzIGRvaW5nLCA0dGggcGF0Y2ggZGVmaW5lcyANCkFU
SDEwS19NQVhfUkVUUllfQ09VTlQ9MzAsIHdoYXQgZG9lcyBpdCBhY3R1YWxseSBtZWFuPyBJdCdz
IHVubGlrZWx5ICJkbyANCjMwIHJldHJpZXMgb24gdGhlIHNhbWUgcmF0ZSIuIERvZXMgcmV0cnkg
bGltaXQgc2V0dGluZyBpbnRlcmFjdHMgd2l0aCANCnJhdGUgYWRhcHRhdGlvbiBzb21laG93IGlu
IGF0aDEwaz8NCg0KTWF5YmUgaXQgbWFrZXMgc2Vuc2UgdG8gZXh0ZW5kIG1heCByZXRyeSB2YWx1
ZSBzcGVjaWZpY2F0aW9uIHRvIG1ha2UgaXQgDQpwb3NzaWJsZSB0byBkZWZpbmUgcGVyLXJhdGU/
IEknbSBub3Qgc3VyZSBob3cgbXVjaCBmbGV4aWJpbGl0eSB3ZSB3YW50IA0KaGVyZSwgc29tZXRo
aW5nIGxpa2UgcmV0cnkgdmFsdWUgcGVyIE1DUzpCVzpTR0k/DQoNCjIuIEFNUERVL0FNU0RVIC0g
dGhlIHdheSBpdCBpcywgaXQgaXMgYWxzbyByZWxldmFudCB0byByYXRlIGluIFR4IA0KZGlyZWN0
aW9uIG9ubHksIGNvcnJlY3Q/IFdlIGtlZXAgYWR2ZXJ0aXNlZCBjYXBhYmlsaXRpZXMgaW50YWN0
IGFuZCBwZWVyIA0KaGFzIGFsbCByaWdodHMgdG8gc2VuZCBBTVBEVXMvQU1TRFVzIG9mIHdoYXRl
dmVyIHNpemUgdGhhdCB3YXMgYWR2ZXJ0aXNlZC4NCkFkZGl0aW9uYWxseSwgcG9zdGVkIHBhdGNo
ZXMgZG8gbm90IGRvIGFueXRoaW5nIHdpdGggZXN0YWJsaXNoZWQgDQpibG9ja2FjayBhZ3JlZW1l
bnQuDQoNCjMgV2l0aCBhYm92ZSBiZWluZyBzYWlkLCBwZXJoYXBzIGl0IHdvdWxkIG1ha2Ugc2Vu
c2UgZm9yIHRoaXMgbmV3IA0KaW50ZXJmYWNlIHRvIGluZGljYXRlIGV4cGxpY2l0bHkgdGhhdCBp
dCdzIHJlbGF0ZWQgdG8gVHggcmF0ZT8gVGhhdCBjYW4gDQpiZSBjb250cm9sbGVkIHBlci1USUQs
IHBlci1ub2RlIG9yIGdsb2JhbGx5LCBkZXBlbmRpbmcgb24gZGV2aWNlIA0KY2FwYWJpbGl0aWVz
Lg0KU29tZSBvdGhlciBzZXR0aW5ncyB0aGF0IG1heSBiZSB1c2VmdWwgYXJlIGZpeGVkIE1DUywg
TUNTIGxpbWl0LCBTR0kgDQpvbi9vZmYsIGJhbmR3aWR0aCwgbWF5YmUgZXZlbiBwcm92aWRlIHJh
dGUgcmV0cnkgcnVsZXMuDQoNCkkgZG9uJ3Qgc2VlIGhvdyBpdCBjYW4gYmUgdXNlZCBpbiByZWFs
IHByb2R1Y3QsIHVubGVzcyB0aGVyZSBpcyBhbiANCmV4dGVybmFsIHJhdGUgYWRhcHRhdGlvbiBs
b2dpYyBvZiBzb21lIGtpbmQuIEJ1dCBkZWZpbml0ZWx5IGl0IHdpbGwgYmUgDQp1c2VmdWwgZm9y
IHRlc3RpbmcsIGFuZCBjYW4gYmUgdXNlZCBmb3IgV0ZBIGNlcnRpZmljYXRpb24uDQo=
