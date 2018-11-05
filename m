Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DE9AC0044C
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 22:49:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53B582081C
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 22:49:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="p/l5PeVf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 53B582081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388276AbeKFILb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 03:11:31 -0500
Received: from mail-eopbgr700041.outbound.protection.outlook.com ([40.107.70.41]:51980
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387965AbeKFILb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 03:11:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4OjvBmBxKDH8cNxC1DkyPK1tXfXE1lmSfNxI0/VwLNA=;
 b=p/l5PeVftowSh3YXLT+p2AgfVnrlXfuSRDCJyS0F19NeZh7Ip+2z7p8BRTouS+57gQz6vMbB7kIN+QB7gQUOOGHwDn7xgb25ZoqaSN160VBkE8TYI8r7ma2ajYxfq9cnYduslofZRKxoxZSiLQi0DtIbVwS9eCm8YnFO3iLsOzA=
Received: from MWHPR05MB3326.namprd05.prod.outlook.com (10.174.174.165) by
 MWHPR05MB3487.namprd05.prod.outlook.com (10.174.248.38) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.13; Mon, 5 Nov 2018 22:49:30 +0000
Received: from MWHPR05MB3326.namprd05.prod.outlook.com
 ([fe80::946e:2ae1:c8ec:d37a]) by MWHPR05MB3326.namprd05.prod.outlook.com
 ([fe80::946e:2ae1:c8ec:d37a%7]) with mapi id 15.20.1294.032; Mon, 5 Nov 2018
 22:49:30 +0000
From:   Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
To:     Ben Greear <greearb@candelatech.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Jouni Malinen <j@w1.fi>
Subject: Re: [RFC 0/3] cfg80211/nl80211/iw: add basic AMPDU/AMSDU controls
Thread-Topic: [RFC 0/3] cfg80211/nl80211/iw: add basic AMPDU/AMSDU controls
Thread-Index: AQHUdRQdP3Y7plTpG06kvM3cndpYM6VBoyiAgAADvQCAACKQAA==
Date:   Mon, 5 Nov 2018 22:49:30 +0000
Message-ID: <351ca1da-861b-76bf-3a38-cd6f2bd32d61@quantenna.com>
References: <20181105143027.17570-1-sergey.matyukevich.os@quantenna.com>
 <34042c1e8020bfb49ab97c9160ab50df044846af.camel@sipsolutions.net>
 <a65739ee-ab89-cf4d-af1b-f86fcc783bac@candelatech.com>
In-Reply-To: <a65739ee-ab89-cf4d-af1b-f86fcc783bac@candelatech.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR05CA0080.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::21) To MWHPR05MB3326.namprd05.prod.outlook.com
 (2603:10b6:301:3d::37)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=igor.mitsyanko.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [12.131.200.68]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;MWHPR05MB3487;6:gny++5r2I/XDoBK7M5gb+7N+MJAwjmE4cttCgfcPLCbJPAJPXCWRi50rN1oJg9ts6XmFG6QJsxI4tQ+X909fO7sNzXFHuXh8Lh4xUbng/c66S0XCYPXFUrZHBavEJUJ3V1VqGdlvDOW10rqdzM/mpGPaoj/wcs4vc+NqDi1jJOS5zSNuxcAET8Iq8NvpEa4vVGd3vhcRer1b3JJMTqFv+9WqO5R+r1Ni6+2laHZ/2JvB3O322HACH6kGSme3ywKZ+r/OipUAv1/0qsVDLxfzW+IW+duhXvzP02039nS8Ox8ZnBVl3LEdemWXRxaiiIWiQWCqeqb5WPi82N9wGMAzaJgsVcc5Vbyxf2J/Wb4EWexOhms4VV9tX4BEXKR7+6eD+jJXBfrbaiwvK50ufBnOUBfgAYe51ACUIR7y3JIfsixQA0tjn1IhtIjAHMBnnAaY93L3xj6RBfajWqo8Lnj98A==;5:Nak1W+ZHDTPRwRYrNTujE0IUc6Zf3zxFV0rFwlOn59t7twS3MdjPErRbtQPPQbYwUWxTYhWI8zLu7v6IvnbJO+IbSHOSZ/dyWs0nWNBdWbzkOFt/bUB9wG5kTfLStg+P9Fgckl/yOpsJY/7PEJ9lKGRskHyYCz3e4w5FDc1bQ3o=;7:PQ8hm+5FZmyv6qgiCdhFg6xDWXrPKFo9NMd55yR/oM0shD2ZU0khcUUAPh27mIyLgAci8EK0w2IpBpoFapzyNzlsXm3XCfZtBqYhDBuBKokWLxjLlP8ADd6XpGY7HcIPtv4eyFssFGLIgOiWJg6bOw==
x-ms-office365-filtering-correlation-id: 49ea61f7-c701-4996-4a17-08d64370f25d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:MWHPR05MB3487;
x-ms-traffictypediagnostic: MWHPR05MB3487:
x-microsoft-antispam-prvs: <MWHPR05MB34877B2AA8A80C9123D984BBB0CA0@MWHPR05MB3487.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(131327999870524);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3231382)(944501410)(52105095)(93006095)(93001095)(10201501046)(3002001)(148016)(149066)(150057)(6041310)(20161123560045)(20161123564045)(20161123562045)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:MWHPR05MB3487;BCL:0;PCL:0;RULEID:;SRVR:MWHPR05MB3487;
x-forefront-prvs: 08476BC6EF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(376002)(39850400004)(136003)(366004)(189003)(199004)(186003)(31686004)(2501003)(52116002)(81156014)(476003)(486006)(76176011)(25786009)(446003)(2616005)(8676002)(66066001)(81166006)(11346002)(5660300001)(7736002)(229853002)(386003)(53546011)(305945005)(105586002)(106356001)(26005)(102836004)(71190400001)(6506007)(71200400001)(4326008)(6486002)(6246003)(2906002)(36756003)(478600001)(86362001)(31696002)(3846002)(316002)(2900100001)(68736007)(6116002)(14444005)(53936002)(99286004)(256004)(6512007)(8936002)(97736004)(14454004)(110136005)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR05MB3487;H:MWHPR05MB3326.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: t20HFJPPVdehUrAhJW7g/OptbCbE5H2/EOJgnnzpP0YXd1RkRfKBcsKXHW2pyxLv2sh7sveTYGNfN0KZK+KPWfbEkd/t4syPC0rc0BxQe2L6s88hZqE1bXm1sv62qmXcC5+OgAR9Fe6QkO+YlIe2NVAw26lukukW/5cVZQAcUc5wxEhhQOxvHzhzKMmvsXp6SNfW0Xf2nv9lVFASMDI2mCWbE9dBPOQ20LxTrJE0S/MSF+azZTxbAjvocgm5PPqznvxRw0veFUawqMg1/BX/NYwriCpRSum90EsRerIn9Be83IdOMrlRIi5s46kTmDrUyZ1w9is806EIQItbYDMXTO6cHMOJ4LTG1Bd49IjuzOM=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <85E1FE29BA3D6A44B28A88E2A8F4285D@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49ea61f7-c701-4996-4a17-08d64370f25d
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2018 22:49:30.2903
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR05MB3487
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

T24gMTEvMDUvMjAxOCAxMjo0NSBQTSwgQmVuIEdyZWVhciB3cm90ZToNCj4+DQo+PiBJIHNlZSB5
b3UgZG9uJ3QgaW1wbGVtZW50IGl0IHRoaXMgd2F5IGluIHRoZSBkcml2ZXIsIGJ1dCB3b3VsZG4n
dCBpdA0KPj4gbWFrZSBtb3JlIHNlbnNlIHRvIGhhdmUgdGhpcyBhcyBhIHBlci1TVEEgKFJBKSBz
ZXR0aW5nPyBUaGF0J3MgcmVhbGx5DQo+PiB0aGUgZ3JhbnVsYXJpdHkgaXQgY2FuIGJlIGRvbmUg
b24sIEkgdGhpbms/DQo+Pg0KPj4gQXJndWFibHkgZXZlbiBwZXItUkEvVElELCB0aG91Z2ggdGhh
dCBzZWVtcyBhIGxpdHRsZSBleGNlc3NpdmU/DQo+IA0KPiBJIGxpa2UgdGhlIGlkZWEgb2YgcHJv
dmlkaW5nIHRoaXMgQVBJIHBlciBwZWVyL3RpZC7CoCBBbmQsIGp1c3QgYWxsb3cNCj4gcGVlciA9
PSAtMSwgdGlkID09IC0xIG9yIHNpbWlsYXIgdG8gbWVhbiAnYWxsJyBzbyB0aGF0IHlvdSBjYW4g
c3RpbGwgc2V0IA0KPiB0aGUgZW50aXJlIGRldmljZQ0KPiB0byBvbmUgcGFydGljdWxhciBzZXR0
aW5nIHcvb3V0IGhhdmluZyB0byBpdGVyYXRlIHRocm91Z2ggYWxsIHBlZXJzIGlmIHlvdQ0KPiBk
b24ndCB3YW50IHRvIGl0ZXJhdGUuLi4NCg0KTWF5YmUgSSdtIHdyb25nLCBidXQgaXNuJ3QgdGhl
IHNldHRpbmcgd2UncmUgZGlzY3Vzc2luZyBhcmUgZm9yIHRoZSANCmRldmljZSBpdHNlbGYsIG5v
dCBmb3IgaXRzIHBlZXJzPyBJIG1lYW4sIGRpc2FibGluZyBBTVNEVSwgQU1QRFUgaW1wbGllcyAN
CndlIG5lZWQgdG8gdXBkYXRlIGNhcGFiaWxpdGllcyBhZHZlcnRpc2VkIGluIG91ciBpbmZvcm1h
dGlvbiBlbGVtZW50cywgDQp3aGljaCBhcmUgY29tbW9uIGZvciBhbGwgZGV2aWNlcywgYW5kIGl0
IGFmZmVjdHMgYm90aCBUeCBhbmQgUnguDQoNCkFuZCBwZXItbm9kZS9wZXItVElEIGFnZ3JlZ2F0
aW9uIHNldHRpbmdzIGFyZSBhIHNlcGFyYXRlIGNvbmZpZ3VyYXRpb24gDQpvcHRpb24gcmVsYXRl
ZCB0byByYXRlIGFkYXB0YXRpb24gb24gVHggcGF0aCBvbmx5Li4NCg==
