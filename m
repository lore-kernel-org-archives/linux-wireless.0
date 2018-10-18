Return-Path: <SRS0=Zpd3=M6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EC14C5ACCC
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 10:18:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2EA4120838
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 10:18:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=appriver3651002525.onmicrosoft.com header.i=@appriver3651002525.onmicrosoft.com header.b="F67tZ+q7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2EA4120838
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=veea.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727653AbeJRSSu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Oct 2018 14:18:50 -0400
Received: from mail-bl2nam02on0070.outbound.protection.outlook.com ([104.47.38.70]:7689
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727451AbeJRSSu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Oct 2018 14:18:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=appriver3651002525.onmicrosoft.com; s=selector1-veea-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LiSFTLL0k+Ya63wIWlMiEOZ31MThfxLv8/FWa+JjEJA=;
 b=F67tZ+q7Vs3ATPMylhnA8KZBKCQWaHFDxlYl9EVnNmdM0XpXQlg46aqmgtQhjtSi7YAUj1xf23pV0jpUWIDNMkNDZvtOu5lrFY/VFLvwfk1Rq8+DCw3ZQviS3klfRF2Bn3sho3zj3l3lY9+XRbSFTfq6y9LTKWMe9sgsowh8PYg=
Received: from DM6PR04MB4059.namprd04.prod.outlook.com (20.176.87.148) by
 DM6PR04MB5147.namprd04.prod.outlook.com (20.176.111.208) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1250.20; Thu, 18 Oct 2018 10:18:28 +0000
Received: from DM6PR04MB4059.namprd04.prod.outlook.com
 ([fe80::e50f:8171:cba0:82e0]) by DM6PR04MB4059.namprd04.prod.outlook.com
 ([fe80::e50f:8171:cba0:82e0%5]) with mapi id 15.20.1228.032; Thu, 18 Oct 2018
 10:18:27 +0000
From:   Adam Cottrel <adam.cottrel@veea.com>
To:     Jean-Pierre TOSONI <jp.tosoni@acksys.fr>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: Large number of crda failures
Thread-Topic: Large number of crda failures
Thread-Index: AdRlb5iQur/SKVJqRLukugrqJU4hCQAAJuMwACjCGZAAANUmcA==
Date:   Thu, 18 Oct 2018 10:18:27 +0000
Message-ID: <DM6PR04MB40592205C91A6026E694E88CF2F80@DM6PR04MB4059.namprd04.prod.outlook.com>
References: <DM6PR04MB40597C0C909A0EA209361F75F2FE0@DM6PR04MB4059.namprd04.prod.outlook.com>
 <DM6PR04MB40596FE840A2426E81FB22A2F2FE0@DM6PR04MB4059.namprd04.prod.outlook.com>
 <AM4PR0101MB2305F09BCC38C687899BFC16E4FF0@AM4PR0101MB2305.eurprd01.prod.exchangelabs.com>
In-Reply-To: <AM4PR0101MB2305F09BCC38C687899BFC16E4FF0@AM4PR0101MB2305.eurprd01.prod.exchangelabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=adam.cottrel@veea.com; 
x-originating-ip: [217.138.78.198]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM6PR04MB5147;6:mjLq2blj0/JWQ6rhiixzHRllmEJDaVyXzbkdP1Y8SceaG2QapmDaaJDkIxtRosJX2HQvVA7nVY3M1iQeFJ4uu0zd1T1S1H69ri8B85NgMRCm3VEkV9FdDVGkMOdc6mvMJ6a/8WYQlRjlNtC6D+Byldklrlrj655fFSy0o9XpgFUY36ixOyz/nuCKw0Nidqw1lgd0oaQ9cQBO4ZCvDvaO06H70xYgw4S0b6FA31nk8EH8NRtxH2I/2fzAWHzTApqvYhx7odt4ey/PHEcTlJLXAw9sjzuYPHCkG3MAXTAI6UgOp2m9JVQeAkX/pNM7sJHDnP7we7Nw+TaervEjP0q4RN3wjCKnEXsPrIBF0wSKzf70goUg1EZ6w0veRd2TZFi1KcXzRfQvb3rQvchP+glQP4ahFPfq0Q/qD1lHFIY8oZ03U4DBDgOQ/rWT9/IARtJxOQkT/V20Cr4NPlBsq9QPEg==;5:QcgOa03jNz5DA5xCgqRwmha7Zm9diswhr87VbLfW5dBrDwb6JfyBCTKDK9zFNnsiiZlYD34klwRkzADJGZncVb8UTy/l9C3lP5YyE7Cpq63XlHlqKBtmA+eg25wsDS/FCayhobkiHC8I/3VSoPNGWQeXXNO2rrh9NoYhYTs4+eM=;7:YuOIBbGm+wsYE8JInqf2cy5a8T0JDNu6ZOym2BM/CF8soYEhmv/1Z0S8okSz/w+EXJaRuNtN8pCBizvjVy2EO5mithVonDeTCKcUT+hFS1RumaGduTdgjZu0fShU8e2EPtYLsvh4sPpxrHDM8PD5pT8kxp7akl/Ou7KftkFf5zgJiDoYrAi9J9RGfjvMxnZKNRULHL+QQkWLHZz6lhiydiynQiA4YLJzXEmYO4c8Gip4GvJy3y8RqZx3/Dm0n8t2
x-ms-exchange-antispam-srfa-diagnostics: SOS;
x-ms-office365-filtering-correlation-id: 275ccbd1-6777-43a7-b0fb-08d634e30bad
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(7021145)(8989299)(5600074)(711020)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(2017052603328)(7153060)(7193020);SRVR:DM6PR04MB5147;
x-ms-traffictypediagnostic: DM6PR04MB5147:
x-microsoft-antispam-prvs: <DM6PR04MB5147914CA55F03D26E01B52EF2F80@DM6PR04MB5147.namprd04.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(20558992708506);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(93006095)(93001095)(10201501046)(3002001)(3231355)(944501410)(52105095)(149066)(150057)(6041310)(20161123564045)(20161123562045)(20161123558120)(2016111802025)(20161123560045)(6043046)(201708071742011)(7699051)(76991095);SRVR:DM6PR04MB5147;BCL:0;PCL:0;RULEID:;SRVR:DM6PR04MB5147;
x-forefront-prvs: 08296C9B35
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(346002)(39840400004)(376002)(396003)(199004)(189003)(508600001)(97736004)(2906002)(8676002)(345774005)(316002)(476003)(486006)(44832011)(2501003)(5660300001)(71200400001)(55016002)(2900100001)(14454004)(5250100002)(71190400001)(68736007)(413944005)(6116002)(229853002)(86362001)(53936002)(26005)(11346002)(9686003)(3846002)(33656002)(14444005)(6436002)(256004)(6246003)(186003)(446003)(74316002)(81156014)(76176011)(305945005)(102836004)(106356001)(7696005)(110136005)(6506007)(7736002)(105586002)(25786009)(81166006)(66066001)(8936002)(99286004);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR04MB5147;H:DM6PR04MB4059.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: veea.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 5i232ZnUDV6BTe0SBYnW9v6H820ZUGQujxYtDeKkZ7Tr2E8/6O8NIbQLkRgBqqnfE7zM7eYEoxWjlF2YX92f2v1ejobYZ4F1Zu4iX2b7HKqgVWa3SHD76b3i0KDzTyXnMZRqiuAbOSEkybRoehjhcD7A7YAo9nqayJr3uNGm1PleNH9BROzZHjfeBskpoG4JVBoycbtiGfBqqi15VXpd70ZMxDsnbqTQ3lcqf2rsJiMSSxXoJaNoHb7mgc7PB2j1cE6DQb3UJUFTosSiJHZ1x6ksl6vWkYZWPlz6qjweKQCNg5Z137MJKh/outPks0Y5b2rewddBFepofZu5s57245U06DoKcX07x2KJUoxKJw0=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: veea.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 275ccbd1-6777-43a7-b0fb-08d634e30bad
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2018 10:18:27.5205
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c2b413f9-36a4-4dff-917c-a42674ced891
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5147
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

RGVhciBKZWFuLVBpZXJyZSwNCg0KVGhhbmsgeW91IGZvciBnZXR0aW5nIGJhY2sgdG8gbWUuDQoN
Ck15IHJlZ3VsYXRvcnkgc2V0dGluZ3MgYXJlIHdvcmtpbmcsIGFuZCBzbyB0aGUgZXJyb3JzIG1p
Z2h0IG5vdCBiZSB2ZXJ5IGltcG9ydGFudCAtIGhvd2V2ZXIsIGl0IGlzIGltcG9ydGFudCB0aGF0
IGtub3cgd2h5IHRoZXkgYXJlIGhhcHBlbmluZy4NCg0KPiBDb2RlIDIzNCA9PiBleGl0KC1FSU5W
QUwpDQo+IENvdWxkIGJlIHRoYXQgY3JkYSBpcyBzdGFydGVkIGluIGEgY29udGV4dCB3aGVyZSB0
aGUgQ09VTlRSWSBlbnZpcm9ubWVudA0KPiB2YXJpYWJsZSBpcyBpbnZhbGlkLCBvciBzdGFydGVk
IHdpdGggYW4gYXJndW1lbnQgKGNyZGEgbXVzdCBiZSBydW4gd2l0aG91dA0KPiBhcmd1bWVudCku
DQoNClRoaXMgaXMgdmVyeSBhIGdvb2Qgc3VnZ2VzdGlvbiAtIEkgY2FuIHNlZSB0aGF0IG15IENP
VU5UUlkgZW52aXJvbm1lbnQgaXMgbm90IHNldC4gSG93ZXZlciwgd2hlbiBJIHNldCBDT1VOVFJZ
IHRoZSBlcnJvciBjb2RlIGdldHMgcmVwbGFjZWQgd2l0aCAtNy4NCg0KVGhlIENSREEgYWx3YXlz
IHJlcG9ydHMgZXJyb3JzIG9uIHN0YXJ0dXAsIGJ1dCBteSB3aXJlbGVzcyByZWd1bGF0b3J5IGRv
bWFpbnMgYXJlIHdvcmtpbmcgbm9ybWFsbHkuIEZvciBleGFtcGxlIEkgY2FuIGNoYW5nZSB0aGVt
IHVzaW5nIHRoZSBmb2xsb3dpbmcgY29tbWFuZHM6LQ0KICMgaXcgcmVnIHNldCBYWA0KICMgaXcg
cmVnIGdldCANCg0KV2h5IGRvIEkgc3RpbGwgZ2V0IHdhcm5pbmdzIGlmIHRoZSB1bmRlcmx5aW5n
IG1lY2hhbmlzbSBpcyB3b3JraW5nIE9LPw0KDQpCZXN0LA0KQWRhbQ0K
