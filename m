Return-Path: <SRS0=vb4L=PY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3C14C43387
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 04:00:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B20A72082F
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 04:00:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="tIMFolyo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731477AbfAPEAX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 15 Jan 2019 23:00:23 -0500
Received: from mail-eopbgr690065.outbound.protection.outlook.com ([40.107.69.65]:27360
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728227AbfAPEAX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Jan 2019 23:00:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Fos8zz+f+XBAjJF36lxbUl0Ds5k+Eu3o/hvPz0y5Yo=;
 b=tIMFolyo2O3NjfpV0szmbHXiEvD2QHM1Mb1coFo8N6lj1Uzhrkj4GTJzSeNdYT1HUbyzqNvmuOjDJuIdoJsPo+kfx+iM11uDq8jr7yocb6TWx8f8yHRItwkVb+dAIsqsxYSv73zUdKc4g5vWYJae5mhO0JOfGFT+kfHvJjahIAY=
Received: from DM6PR05MB6331.namprd05.prod.outlook.com (20.178.224.84) by
 DM6PR05MB4537.namprd05.prod.outlook.com (20.176.79.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.20; Wed, 16 Jan 2019 04:00:01 +0000
Received: from DM6PR05MB6331.namprd05.prod.outlook.com
 ([fe80::203b:2b2a:fe9e:54b2]) by DM6PR05MB6331.namprd05.prod.outlook.com
 ([fe80::203b:2b2a:fe9e:54b2%5]) with mapi id 15.20.1537.018; Wed, 16 Jan 2019
 04:00:01 +0000
Received: from MWHPR05MB3326.namprd05.prod.outlook.com (10.174.174.165) by
 MWHPR05MB3296.namprd05.prod.outlook.com (10.174.174.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.18; Wed, 16 Jan 2019 03:58:18 +0000
Received: from MWHPR05MB3326.namprd05.prod.outlook.com
 ([fe80::b1e5:7b4d:35e:d0ee]) by MWHPR05MB3326.namprd05.prod.outlook.com
 ([fe80::b1e5:7b4d:35e:d0ee%2]) with mapi id 15.20.1537.017; Wed, 16 Jan 2019
 03:58:18 +0000
From:   Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "wireless-regdb@lists.infradead.org" 
        <wireless-regdb@lists.infradead.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Tx power for slave devices in ETSI DFS region
Thread-Topic: Tx power for slave devices in ETSI DFS region
Thread-Index: AQHUkPmNfbbaw+xxokGgB1kXU/zmYqWwj1E9gADuDAA=
Date:   Wed, 16 Jan 2019 03:58:18 +0000
Message-ID: <cdcde7a4-a2b0-5d4b-83e6-cfbffdfe93d9@quantenna.com>
References: <423eaa39-fc06-6a5a-a8fd-5e15d503dff5@quantenna.com>
 <03c1e278fdd880bf7409c0b1c03366178b765cda.camel@sipsolutions.net>
In-Reply-To: <03c1e278fdd880bf7409c0b1c03366178b765cda.camel@sipsolutions.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR07CA0055.namprd07.prod.outlook.com
 (2603:10b6:a03:60::32) To MWHPR05MB3326.namprd05.prod.outlook.com
 (2603:10b6:301:3d::37)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=igor.mitsyanko.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [12.131.200.68]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM6PR05MB4537;6:vKo0KfV2siKJXiRmikRgWHHs69ED32tOrl11xXcRWjZVM8uflTKbxIPLrnFF9qFSsUysZMIf/FNezeqWEGGmMQLdBvc5IVGGI19iNBmqPaSzzip5Tgz4YSlK6bLwx3yqwEqPOAOAsgz0WmGDXsilikQfpMqWFOFHlHlnhQF45YnvZJVxTBwk/65zIBLcYj2d8gjjkYurA1BulsRPii15FePAkN/lRxia/SOPohnPhbj6hvHuukg1qlHeZx+URRg0j8B92RDIR5TK2cC8yNanrVm2uNKFRggcxZKk95QkBwYDKRK9/NS00mENOtlovtejIoR6nnYgKM0deEBIYthc+JiPfufGmEPUtLMJN5yhnsWVeSxN++7GARIV9ZXVT3FuT7RdD6IbdzSDp1poEFfXZCfQPMFCM6Kh4a/QW1XIakcxM7ah94nraoJ68HPG9erf0Ja1Ji7umx/EwCAqgm5lJg==;5:NIyrI6+rwt4OVw389GADjFL6cB7WxPLz3WKIZCY/79vyvloF7SEYZBe6NmRcTl+DrzlVmnyW1veSD57dOCKjtDFv107dQTRa4ngXr5xuvRs90Ss3pYgYnJhstMIthqwFYlXIrWLot64F7eqNy0fNb3HplML65Ojf0gZTegXCp93LT0ozjEkMpJ/D2Ln0FozpyOqJfFxqcKERUI+nBcB2Xw==;7:QyJVaiCtYcL2/KDFB5vH18jiMWMjPkUHApi/EBQvnOeZO4gHHcCU0PYoUExICAAWgvdzTIQcxA3iRZXJw+hifmKoc/nmCwKgqEFrcfuCmlRW46dAhwPzQ2PBMWwavHv8s6etLvGYcjxLSmJr5fE1Jg==
x-ms-office365-filtering-correlation-id: 45ab4366-ebb6-4a54-d757-08d67b66d918
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:MWHPR05MB3296;
x-ms-traffictypediagnostic: MWHPR05MB3296:|DM6PR05MB4537:
x-moderation-data: 1/16/2019 3:59:58 AM
x-microsoft-antispam-prvs: <DM6PR05MB4537576E2489395B3BA179DCB0820@DM6PR05MB4537.namprd05.prod.outlook.com>
x-forefront-prvs: 091949432C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(199004)(189003)(14454004)(36756003)(52116002)(26005)(7736002)(305945005)(102836004)(2906002)(31696002)(71190400001)(498600001)(110136005)(436003)(229853002)(11346002)(446003)(86362001)(217873002)(4326008)(71200400001)(76176011)(8936002)(2501003)(25786009)(186003)(81156014)(486006)(81166006)(8676002)(99286004)(6116002)(386003)(6506007)(53546011)(3846002)(66066001)(68736007)(97736004)(14444005)(6246003)(256004)(31686004)(6512007)(2616005)(53936002)(6436002)(6486002)(106356001)(5660300001)(105586002)(476003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR05MB4537;H:DM6PR05MB6331.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: WYzI0unQI1vRNuuY7xFNiMOpZLShBru79vuKmaSWIg0mYxI9gDmYo5NEKudeNOaqQ/gYrLBIs8ClsnXowjocS3WkxMCKeAe5GYAKM1v3kENJfKAfKpIB/SMl14BTWJ2xMkRh0QDbC5G71pAWSLHJId2oIcXDMPSCK67Arsvhhg9pTmV3hC0gM9JSTLM/bdvrfGflBAUrFPzkHHFVuE8T437/qt6fpBWPuXeVpAqcwCjnGJ3C1aCIVPZeQKBuNjx+VWx6qUHgwVuWqpQXaDVqqAuODyBDImMSEj384Ck7BGg/IPhXdezEV5B5ejwEMNebo1kGmELXBY0X0vDg0X60oE1r9AslHLFRGd804DGtPEvSAqx43z4h9FObFkVSe0asCp+7BKtGg9Bb86KjCtKyQZAqV2hQN5RhUf5zhtSCHRY=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <F5CFD8C6ECBC544EAC51B8C5DAF97B5D@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45ab4366-ebb6-4a54-d757-08d67b66d918
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2019 04:00:01.2166
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR05MB4537
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

T24gMS8xNS8xOSA1OjQ1IEFNLCBKb2hhbm5lcyBCZXJnIHdyb3RlOg0KPj4gUXVlc3Rpb24gaXM6
IGRvZXMgd2lyZWxlc3MgY29yZSBhc3N1bWVzIHRoYXQgZWFjaCBkZXZpY2UgY2FuIGRvIHJhZGFy
DQo+PiBkZXRlY3Rpb24gaW4gc2xhdmUgbW9kZXMgKGVnIGFjdGluZyBhcyBhIFNUQSkgYW5kIGl0
IGlzIGVuYWJsZWQgYnkNCj4+IGRlZmF1bHQ/IEkgY291bGRuJ3QgZmluZCBhbnkgbG9naWMgaW4g
a2VybmVsIHdoaWNoIHdvdWxkIGxpbWl0IDI3IGRibQ0KPj4gcG93ZXIgdG8gMjAgZm9yIFNUQSBk
ZXZpY2VzLg0KPiANCj4gTm8sIHdlIHNob3VsZG4ndCBhc3N1bWUgdGhhdCBpdCBjYW4gZG8gcmFk
YXIgZGV0ZWN0aW9uIGJ5IGl0c2VsZiAuLi4NCj4gDQo+IEkgZ3Vlc3Mgd2Ugc2hvdWxkIGhhdmUg
c29tZSBjb2RlPyBPciBqdXN0IGZpeCB0aGUgcmVnZGI/DQo+IA0KPiBqb2hhbm5lcw0KPiANCj4g
DQoNCk1heWJlIHdlIGhhdmUgdG8gZG8gYm90aCwgYXMgdGhlcmUgYXJlIG11bHRpcGxlIHRoaW5n
cyB0byBjb25zaWRlcjoNCi0gY3VycmVudCByZWdkYiB2YWx1ZXMgYXJlIGZpbmUgZm9yIEFQIG1v
ZGUNCi0gVHggcG93ZXIgdmFsdWVzIGNhbiBiZSAzIGRibSBoaWdoZXIgaWYgVFBDIGlzIHN1cHBv
cnRlZC4gVGhpcyBpcyANCm1lbnRpb25lZCBpbiBhIGNvbW1lbnQgaW4gcmVnZGIsIGJ1dCBub3Qg
dXNlZCBhbnl3aGVyZS4NCi0gaWYgU1RBIGRldGVjdHMgcmFkYXIsIG5vbi1vY2N1cGFuY3kgcGVy
aW9kIG11c3Qgc3RhcnQNCi0gd2hlbiBub24tb2NjdXBhbmN5IHBlcmlvZCBlbGFwc2VzLCBTVEEg
bXVzdCBkbyBDQUMgYmVmb3JlIHJldHVybmluZyB0byANCmNoYW5uZWwuIEkgZ3Vlc3MgQ0FDIG11
c3QgYmUgdHJpZ2dlcmVkIGJ5IHdwYV9zdXBwbGljYW50Pw0KDQoNCkknbSBub3Qgc3VyZSBob3cg
dG8gcHJlc2VudCBhZGRpdGlvbmFsIGluZm9ybWF0aW9uIGluIHJlZ2RiIHdoaWxlIA0KcHJlc2Vy
dmluZyBiYWNrd2FyZHMgY29tcGF0aWJpbGl0eS4gTWF5YmUgd2UgY2FuOg0KMS4gSGF2ZSBhIHNl
cGFyYXRlIHJ1bGUgbWFya2VkIHdpdGggTk9fUkRFVEVDVCBmbGFnIHdoaWNoIHdpbGwgYWR2ZXJ0
aXNlIA0KbG93ZXIgVHggcG93ZXIuIExpbnV4IHdpcmVsZXNzIGNvcmUgd2lsbCBoYXZlIHRvIHNl
bGVjdCBydWxlIHdpdGggDQpoaWdoZXN0IFR4IHBvd2VyIGlmIHBvc3NpYmxlLCBmb3IgYmV0dGVy
IHJlc3VsdHMuDQoyLiBGb3IgVFBDIDNkYm0gZ2FpbiwgaGF2ZSBhIGZsYWcgVFBDX0dBSU4NCkFz
IGFuIGV4YW1wbGUsIEFXIHJ1bGVzIHdpbGwgbG9vayBsaWtlOg0KDQpjb3VudHJ5IEFXOiBERlMt
RVRTSQ0KCSgyNDAyIC0gMjQ4MiBAIDQwKSwgKDIwKQ0KCSg1MTcwIC0gNTI1MCBAIDgwKSwgKDIw
KSwgQVVUTy1CVywgVFBDX0dBSU49Mw0KCSg1MjUwIC0gNTMzMCBAIDgwKSwgKDIwKSwgREZTLCBB
VVRPLUJXLCBUUENfR0FJTj0zDQoJKDU0OTAgLSA1NzEwIEAgMTYwKSwgKDI3KSwgREZTLCBUUENf
R0FJTj0zDQoJKDU0OTAgLSA1NzEwIEAgMTYwKSwgKDIwKSwgREZTLCBOT19SREVURUNULCBUUENf
R0FJTj0zDQoNCkxpbnV4IHdpcmVsZXNzIGNvcmUgd2lsbCBoYXZlIHRvIHVwZGF0ZSBUeCBwb3dl
ciB2YWx1ZXMgd2hlbiBzd2l0Y2hpbmcgDQpmcm9tIEFQIGFuZCBTVEEgbW9kZXMsIGFuZCBzb21l
aG93IG5vdGlmeSBkcml2ZXJzLg0K
