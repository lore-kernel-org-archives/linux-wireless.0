Return-Path: <SRS0=6Uy3=QL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A2B2C282C4
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 12:25:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 335A12082E
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 12:25:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="Dac+DQv/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729686AbfBDMZK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Feb 2019 07:25:10 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:42612 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727418AbfBDMZK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Feb 2019 07:25:10 -0500
X-IronPort-AV: E=Sophos;i="5.56,560,1539673200"; 
   d="scan'208";a="24202310"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES128-SHA; 04 Feb 2019 05:25:09 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.37) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Mon, 4 Feb 2019 05:25:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KhBi3DLro8s88sBRSJIznt8qMMSrC0hVkQ2wlziWvQM=;
 b=Dac+DQv/Mpa5yI20kXlUB8YpyfrEgrwOLXjT9aENmlqRx5vX3546dkUUMyQBysUxusyBa4mWSKnDFB1ZIkGaxNcw65GSy3H8XumhDP8tVQ9LvLC75F6M9LUYK++AoqcK5Z0nkPBpueuhleqRY7K55g4aVJ8UZmCloh7LzWstRIg=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2837.namprd11.prod.outlook.com (52.135.228.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.22; Mon, 4 Feb 2019 12:25:07 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1580.019; Mon, 4 Feb 2019
 12:25:07 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
        <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>,
        <Adham.Abozaeid@microchip.com>
CC:     <dan.carpenter@oracle.com>
Subject: Re: [PATCH 08/15] staging: wilc1000: use correct condition in loops
 for 'vif_num' count
Thread-Topic: [PATCH 08/15] staging: wilc1000: use correct condition in loops
 for 'vif_num' count
Thread-Index: AQHUuyvnTipBfoysokuAty4Jr8EL5aXPTM6AgAAYtACAAAFngIAAH10AgAAMqAA=
Date:   Mon, 4 Feb 2019 12:25:07 +0000
Message-ID: <b9c5b807-834a-7a8e-767c-7a2524aeceee@microchip.com>
References: <1549134974-5545-1-git-send-email-ajay.kathat@microchip.com>
 <1549134974-5545-9-git-send-email-ajay.kathat@microchip.com>
 <20190204081357.GC2563@kadam>
 <fdcab6a0-cf91-dc85-d674-ce4a3c9bd54d@microchip.com>
 <20190204094723.GD2581@kadam> <20190204113938.GA24343@kroah.com>
In-Reply-To: <20190204113938.GA24343@kroah.com>
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
x-originating-ip: [183.82.18.226]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2837;6:iIUnjYygFwQIAmu9wLumhWt+Y5WFRRfFCr3D9kCbcRv/4h6xWk6a2bEQfJOFrwSPKTwxkey5i16Tobdyts6+C8SEKly5Cty9m7CTJFDE3zxeZ5kb2iNL3E6m7I6FYEQE6x4JvUatgkCEYJSCps5KzDyPHIi9ODB6HpytIJPh95Y+DRew8zaM3pw9jpEW5zCYLDtmDhuTjqHcyGEYLrMGOJxfHXY3M/PyKlhIKQEm+aXUAxFWbfyawpaFLZ4f7BYHX9q36K//RSgvrp7lOxJsYNpfJSWhsayivg83z7AJkY0oidIMRrjrN5Xlhis1DUU8vf7W4L10f2JHk3MX2SWIM+tkD9VcUlnXp2gALQwQii9buB2HXMflgfX4UmjO/0nMeomhqpPELyvNHAnfa+rumqmhekPqZ4USXXNjlEUH1cqZrMIOM+OFH76yCcxjxaj5A5o7LWnV4d3nfTqstorD6Q==;5:D598n+i949+JMtyJUeLqVC+cTiANu6Sw4REE2woWA1OvZmF7WU52GfCkUkzTEcjQkiy2tAM/euLe4Gnd+Z8qYJnABRPI9Mfav5HeTdW2fIQhXQzei2NS6eCWDIkSUIRlZxBxoG4sn6t28ywYJQ91w1JMYmQ+d5DPxD/6qgMNQyIx4uRZmTJmqblouuUfJYgiPS315ANX6VGmX/VsrWGNNg==;7:TzwcZg5hHr38Dj0/ow3QDz2O2Nk3kLL2KcbsFng6Ct4hIiAXsBmrEv0RSPZtkcioFpoaYHcQxMI66AwI/RNbo2Rs3CoG4ySNvTnBgI8a+tncbA9qxQSMRQQefMqQGZgfmmNY13Ac5wDWQOADG7bxeA==
x-ms-office365-filtering-correlation-id: 3eca512e-e5c3-4c32-b93e-08d68a9bcc68
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2837;
x-ms-traffictypediagnostic: BYAPR11MB2837:
x-microsoft-antispam-prvs: <BYAPR11MB283713540AB5603C4AE19C9AE36D0@BYAPR11MB2837.namprd11.prod.outlook.com>
x-forefront-prvs: 0938781D02
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(366004)(376002)(39860400002)(136003)(396003)(189003)(199004)(229853002)(102836004)(386003)(3846002)(53546011)(6506007)(6116002)(7736002)(71190400001)(71200400001)(68736007)(305945005)(2501003)(256004)(31686004)(2906002)(53936002)(106356001)(105586002)(26005)(6636002)(6512007)(97736004)(446003)(11346002)(2616005)(476003)(486006)(6486002)(186003)(6436002)(31696002)(8936002)(110136005)(72206003)(36756003)(4326008)(316002)(478600001)(2201001)(93886005)(86362001)(25786009)(6246003)(81166006)(76176011)(8676002)(78486014)(81156014)(14454004)(66066001)(99286004)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2837;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: omhuwIqvJ/wR/La22fQ2wXAl4p9WId36nOhdxD1ou7mmOvMid4mGk2i0+0HRqdXOjeVdmMx+LbsxC2wNLsYGMSMJ1cn1l+Ddw9uj4bifN1e4RGmoxRVb5P5RJ74Pu9s5CCqSlD9pzr88dGjTYK841Igp8u3XcvJWSaiRdWxitZ0ngudYpb8jBEwAZUugTvMiFsFW9juGHWjQKcdBncyzAYHp/N/R2fuJU8EpqFQZTz0m5qKBrT9i/17lJt0mVvfaolYTkD1SwNjgqr6B9/CeC219/FQUwpfKUmzklZGI4AS27gdC87HFSu6kmnfTPlQUf3x4ApY31sp8VDgFsLIGWAxGT/JgeLqqEzBfEVO3thJppj45cWqzhKxp2FgUgENAaIOtJ44R8SmWmcm68+Vj39alOYSD3E2Y573d1VrGGMA=
Content-Type: text/plain; charset="utf-8"
Content-ID: <42B32171FF6CAE478C66484D98D8969E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3eca512e-e5c3-4c32-b93e-08d68a9bcc68
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2019 12:25:05.0887
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2837
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

SGkgR3JlZywNCg0KT24gMi80LzIwMTkgNTowOSBQTSwgR3JlZyBLSCB3cm90ZToNCj4gT24gTW9u
LCBGZWIgMDQsIDIwMTkgYXQgMTI6NDc6MjNQTSArMDMwMCwgRGFuIENhcnBlbnRlciB3cm90ZToN
Cj4+IE9uIE1vbiwgRmViIDA0LCAyMDE5IGF0IDA5OjQyOjM2QU0gKzAwMDAsIEFqYXkuS2F0aGF0
QG1pY3JvY2hpcC5jb20gd3JvdGU6DQo+Pj4NCj4+Pg0KPj4+IE9uIDIvNC8yMDE5IDE6NDMgUE0s
IERhbiBDYXJwZW50ZXIgd3JvdGU6DQo+Pj4+IE9uIFNhdCwgRmViIDAyLCAyMDE5IGF0IDA3OjE3
OjEzUE0gKzAwMDAsIEFqYXkuS2F0aGF0QG1pY3JvY2hpcC5jb20gd3JvdGU6DQo+Pj4+PiBGcm9t
OiBBamF5IFNpbmdoIDxhamF5LmthdGhhdEBtaWNyb2NoaXAuY29tPg0KPj4+Pj4NCj4+Pj4+IFRo
ZSB2YWx1ZSBvZiAndmlmX251bScoaW50ZXJmYWNlIGNvdW50KSBzdGFydHMgd2l0aCAwLCBzbyBt
b2RpZmllZCB0aGUNCj4+Pj4+IGxvb3AgY29uZGl0aW9ucyB0byBleGVjdXRlIGZvciBhbGwgaW50
ZXJmYWNlLg0KPj4+Pj4NCj4+Pj4+IFNpZ25lZC1vZmYtYnk6IEFqYXkgU2luZ2ggPGFqYXkua2F0
aGF0QG1pY3JvY2hpcC5jb20+DQo+Pj4+DQo+Pj4+IFRoZSByaWdodCB0aGluZyB0byBkbyBpcyB0
byBjaGFuZ2UgLT52aWZfbnVtID0gaSArIDEgaW4NCj4+Pj4gd2lsY19uZXRkZXZfaW5pdCgpLiAg
VGhhdCdzIGhvdyBpdCB3YXMgb3JpZ2luYWxseS4gIFBsZWFzZSwgYWRkIGENCj4+Pj4gRml4ZXMg
dGFnLg0KPj4+Pg0KPj4+PiBGaXhlczogNzM1YmIzOWNhM2JlICgic3RhZ2luZzogd2lsYzEwMDA6
IHNpbXBsaWZ5IHZpZltpXS0+bmRldiBhY2Nlc3NlcyIpDQo+Pj4+DQo+Pj4NCj4+PiBUaGFua3Mu
IFN1cmUsIEkgd2lsbCBhZGQgRml4ZXMgdGFnIGFuZCByZXN1Ym1pdCB0aGUgY2hhbmdlcy4NCj4+
Pg0KPj4+IENhbiBvdGhlciBwYXRjaGVzIGZyb20gdGhlIHNlcmllcyBiZSBhcHBsaWVkIGV4Y2x1
ZGluZyB0aGlzIG9yIHNob3VsZCBJDQo+Pj4gcmVzdWJtaXQgdGhlIGNvbXBsZXRlIHNlcmllcz8N
Cj4+PiBQbGVhc2Ugc3VnZ2VzdC4NCj4+DQo+PiBJIGRvbid0IGhhdmUgYW4gb3BpbmlvbiBvbiB0
aGF0LiAgSSBndWVzcyBpZiB5b3UganVzdCByZXNlbmQgdGhlbSBhbGwsDQo+PiB0aGF0J3MgdGhl
IGVhc2llc3QgZm9yIEdyZWcuDQo+IA0KPiBJIHRvb2sgdGhlIGZpcnN0IDcgcGF0Y2hlcyBoZXJl
LCBzbyBqdXN0IGEgcmVzcGluIG9mIHRoZSByZW1haW5pbmcgb25lcw0KPiB3b3VsZCBiZSBmaW5l
Lg0KPiANCg0KVGhhbmtzIGFsb3QuDQpUaGlzIHBhdGNoIHdpbGwgdGFrZSBzb21lIHRpbWUgZm9y
IG1vZGlmaWNhdGlvbi4gQXMgcmVtYWluaW5nIHBhdGNoZXMNCmFyZSBub3QgZGVwZW5kZW50IG9u
IHRoaXMuIEkgd2lsbCByZXNlbmQgdGhlbS4NCg0KUmVnYXJkcywNCkFqYXkNCg==
