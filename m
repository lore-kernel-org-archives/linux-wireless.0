Return-Path: <SRS0=hbYo=M5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B1F1ECDE32
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 12:39:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A575C2150D
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 12:39:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ACKSYS.onmicrosoft.com header.i=@ACKSYS.onmicrosoft.com header.b="DDHXLdGQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A575C2150D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=acksys.fr
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbeJQUex (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Oct 2018 16:34:53 -0400
Received: from mail-eopbgr70098.outbound.protection.outlook.com ([40.107.7.98]:34312
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726990AbeJQUex (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Oct 2018 16:34:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ACKSYS.onmicrosoft.com; s=selector1-acksys-fr;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WRr6CYqqR85NgWXCRGBz06Frsb4CFnaFGghdW+1vuVo=;
 b=DDHXLdGQ4UWS5cBgAw2M1frMQSHbvgVkdDh4lb84UfxyMkq975i2x4q/BfxSd4R5wWnbvBotzm4S4YuxemvIkdbrij3yt9y2We5nBK5VUHLLW1DatXPqklDGYY/X0zIP/T+7wr7Ugh0oyDJj/4meyZmnYuYjAkvPyI18+wIvNyM=
Received: from AM4PR0101MB2305.eurprd01.prod.exchangelabs.com (10.165.38.134)
 by AM4PR0101MB2083.eurprd01.prod.exchangelabs.com (10.168.1.19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1228.26; Wed, 17 Oct
 2018 12:39:17 +0000
Received: from AM4PR0101MB2305.eurprd01.prod.exchangelabs.com
 ([fe80::8506:d3a9:7eb0:7874]) by
 AM4PR0101MB2305.eurprd01.prod.exchangelabs.com
 ([fe80::8506:d3a9:7eb0:7874%2]) with mapi id 15.20.1228.027; Wed, 17 Oct 2018
 12:39:17 +0000
From:   Jean-Pierre TOSONI <jp.tosoni@acksys.fr>
To:     Adam Cottrel <adam.cottrel@veea.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: Large number of crda failures
Thread-Topic: Large number of crda failures
Thread-Index: AdRlb5iQur/SKVJqRLukugrqJU4hCQAAJuMwACjCGZA=
Date:   Wed, 17 Oct 2018 12:39:16 +0000
Message-ID: <AM4PR0101MB2305F09BCC38C687899BFC16E4FF0@AM4PR0101MB2305.eurprd01.prod.exchangelabs.com>
References: <DM6PR04MB40597C0C909A0EA209361F75F2FE0@DM6PR04MB4059.namprd04.prod.outlook.com>
 <DM6PR04MB40596FE840A2426E81FB22A2F2FE0@DM6PR04MB4059.namprd04.prod.outlook.com>
In-Reply-To: <DM6PR04MB40596FE840A2426E81FB22A2F2FE0@DM6PR04MB4059.namprd04.prod.outlook.com>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jp.tosoni@acksys.fr; 
x-originating-ip: [195.6.104.67]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;AM4PR0101MB2083;6:HXM26lV4HdKgvfMykKP+J+NT44KMPayQrYtP/bWGlVpzRmkseVkKV6SEL6XkPYue1tZ+KuRABoJXojpb5svVKanLJB1QYttFvtUotzpt/7LlHYihpjp42FIS+DpehZs4Ac/pKnXeGgt2TG8OP/SyqYyv3UozTlXdLIce9sqX2+d7tbPsFl1ON2gjyH5lVEFqSrLtsIFVbmLN36JzXlld+7bPc5PeF7P3BcnyCHPsTF9eh3UoshbN4NuVHV2xP9DIxPlTgVaILX51tfrlMr1uoqeIlLgmyBtQixO95zLLlHKSRM9BsKbwBuuTIWEHpMWTR5RasKg3LppysbqL6iqi0b2z6VbZFW5Y8uJ1rTTbd13GaIoWEW2Pwx3pcNEntd8uiJ5BLmYnSl2dMM4GQbNQyN7K/f186mqhlfSBE0BPdccXOB5SXQwZ9XAPTAmScXSvZkhjZQ9U1s/ySB/pAjTjXA==;5:plykRV51eKeeJdgUJ091XZtTTLnQd1Qe8fy4GkaDRT2SvppPq3d6c7pIxPNeJDU3RTemYMXakn1LP9PNFL0SgaLKlkauEpvIZqPuBLBM4MCIu5Ww7O1NyqnBt5lr0tH+wJa1U3z37+i9uL1XeQtQMJp79Cszo8/mpE81wIuYDSY=;7:S3i0UAxqq1SO5VWkpGbdvoCr9N++Jzb003BUv0OKt2ucp/X4sVMbbL2JzImS+kQgPjE5MjWr/yYIyrVcASLBLD6/HBBMedM8WubYXBQqw89aaMl1IhrZzj2Wk3iWZ38a3ExVOQYnD+4JtmkWGf19FPATuiVwR+1waG1t/WcoONoSxRRXlnnGkQi9ENBh2grnHNtPT4onL5rk6Kmle47HkJLBAkHCTIpOIuSPlwcmiXVcziLyVYw/bPoV3QV7Cwk8
x-ms-exchange-antispam-srfa-diagnostics: SOS;
x-ms-office365-filtering-correlation-id: 40c87370-8ea1-4bed-73ba-08d6342d8d74
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:AM4PR0101MB2083;
x-ms-traffictypediagnostic: AM4PR0101MB2083:
x-microsoft-antispam-prvs: <AM4PR0101MB2083149BE687518F937F530EE4FF0@AM4PR0101MB2083.eurprd01.prod.exchangelabs.com>
x-exchange-antispam-report-test: UriScan:(9452136761055);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3002001)(3231355)(944501410)(52105095)(10201501046)(93006095)(93001095)(149066)(150057)(6041310)(20161123560045)(2016111802025)(20161123558120)(20161123564045)(20161123562045)(6043046)(201708071742011)(7699051)(76991095);SRVR:AM4PR0101MB2083;BCL:0;PCL:0;RULEID:;SRVR:AM4PR0101MB2083;
x-forefront-prvs: 08286A0BE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(39840400004)(136003)(396003)(376002)(366004)(55784004)(189003)(199004)(81166006)(2501003)(74482002)(256004)(81156014)(110136005)(71190400001)(106356001)(71200400001)(66066001)(3846002)(7736002)(2900100001)(6116002)(6246003)(5250100002)(74316002)(86362001)(105586002)(2906002)(5660300001)(53936002)(33656002)(8676002)(68736007)(102836004)(508600001)(14454004)(76176011)(26005)(229853002)(6436002)(305945005)(25786009)(186003)(7696005)(99286004)(8936002)(97736004)(11346002)(55016002)(316002)(476003)(6506007)(9686003)(446003)(486006);DIR:OUT;SFP:1102;SCL:1;SRVR:AM4PR0101MB2083;H:AM4PR0101MB2305.eurprd01.prod.exchangelabs.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:3;A:1;
received-spf: None (protection.outlook.com: acksys.fr does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: PL9Mdyn70+b0MQ4BjFAKhuMMSWsj2tl8PArMtWuEh7C/0oN7utpr4Z6SkWhPLBO/2EaFmnC9qKE30nM3ABSRuBafU88ojswiLq/Arvop7aJjeaBEPtc3VRs9ZZ3uwsqyhWjDkkMF3TogASyxbP9Hz4Bn5cel2P85qX68TzZhKxT9MXUEusk1yhIXrRkVPcZv7l4JzDB6IU4iPp1jUw7Rfky9bz0iw1LPwav96ZWHHjzSFbsMwrnIctf3bJ5ivSHtRytY2OIbwjUQRg8CvCsig9L1bWyr8KKquzuUxd9W08aRjLGZBfPh+ob/ttkuFjsjmYPO7qb5rYq/pFFtbN+2Wp2XVvVGUuTwVwZaTteD3vE=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: acksys.fr
X-MS-Exchange-CrossTenant-Network-Message-Id: 40c87370-8ea1-4bed-73ba-08d6342d8d74
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2018 12:39:16.9484
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f18a6414-d5f3-4b5c-9345-f30c01d87e32
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0101MB2083
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Q29kZSAyMzQgPT4gZXhpdCgtRUlOVkFMKQ0KQ291bGQgYmUgdGhhdCBjcmRhIGlzIHN0YXJ0ZWQg
aW4gYSBjb250ZXh0IHdoZXJlIHRoZSBDT1VOVFJZIGVudmlyb25tZW50IHZhcmlhYmxlIGlzIGlu
dmFsaWQsIG9yIHN0YXJ0ZWQgd2l0aCBhbiBhcmd1bWVudCAoY3JkYSBtdXN0IGJlIHJ1biB3aXRo
b3V0IGFyZ3VtZW50KS4NCg0KPiAtLS0tLU1lc3NhZ2UgZCdvcmlnaW5lLS0tLS0NCj4gRGXCoDog
bGludXgtd2lyZWxlc3Mtb3duZXJAdmdlci5rZXJuZWwub3JnIFttYWlsdG86bGludXgtd2lyZWxl
c3Mtb3duZXJAdmdlci5rZXJuZWwub3JnXSBEZSBsYSBwYXJ0IGRlDQo+IEFkYW0gQ290dHJlbA0K
PiBFbnZvecOpwqA6IG1hcmRpIDE2IG9jdG9icmUgMjAxOCAxODo1MQ0KPiDDgMKgOiBsaW51eC13
aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmcNCj4gT2JqZXTCoDogTGFyZ2UgbnVtYmVyIG9mIGNyZGEg
ZmFpbHVyZXMNCj4gDQo+IEhpLA0KPiANCj4gT24gc3RhcnQgdXAgSSBhbSBnZXR0aW5nIGEgbGFy
Z2UgbnVtYmVyIG9mIGVycm9yIGZhdWx0cyByZXBvcnRlZCB3aXRoIENSREE6LQ0KPiDinqIgaWVz
MDYwMDEzMyBzeXN0ZW1kLXVkZXZkWzM5NDldOiBQcm9jZXNzICcvc2Jpbi9jcmRhJyBmYWlsZWQg
d2l0aCBleGl0IGNvZGUgMjM0DQo+IFR5cGljYWxseSwgb3ZlciA1MCBsaW5lcyBhcmUgcmVwb3J0
ZWQgdG8gdGhlIHN5c2xvZ3MNCj4gDQo+IEhvd2V2ZXIsIG9uY2UgdGhlIHN5c3RlbSBoYXMgZnVs
bHkgc3RhcnRlZCwgSSBkbyBub3QgZ2V0IGFueSBpc3N1ZXMgd2l0aCBydW5uaW5nOi0NCj4g4p6i
IGl3IHJlZyBzZXQgWFgNCj4gDQo+IFRoZXNlIGVycm9ycyBhcmUgZG91YmxpbmcgdGhlIGJvb3Qg
dGltZSBmb3IgTGludXguIE15IGtlcm5lbCBpcyA0LjE0LjQgYW5kIEkgYW0gcnVubmluZyBhIERl
YmlhbiBiYXNlLg0KPiANCj4gUGxlYXNlIGNhbiBzb21lb25lIGFkdmlzZSB3aGF0IGlzIGdvaW5n
IHdyb25nPw0KPiANCj4gQmVzdCwNCj4gQWRhbQ0K
