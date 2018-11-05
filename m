Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B78CC0044C
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 22:49:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49E3E2085B
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 22:49:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="knqhn25B"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 49E3E2085B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388205AbeKFILY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 03:11:24 -0500
Received: from mail-eopbgr700040.outbound.protection.outlook.com ([40.107.70.40]:35920
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387965AbeKFILY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 03:11:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2yaNjQoRceQooR2Pbo/Ju1kWmwR6LJWc2GyiXwK53+Q=;
 b=knqhn25BhprP15e6gApElowYuWvZ469QdpXeBG528cuzcvT2XHtWbt5pEjpMKTX6jnwi+rTHsLUj0d8XjPRYX/qPbHqtjbTXoGnRbi09z+v5yfPF6sUB1lmf9yQ+ncF31yTBHBJnh0x9u8oE58wF9eJdSqjPk+L5PS7POlkBhAg=
Received: from MWHPR05MB3326.namprd05.prod.outlook.com (10.174.174.165) by
 MWHPR05MB3487.namprd05.prod.outlook.com (10.174.248.38) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.13; Mon, 5 Nov 2018 22:49:21 +0000
Received: from MWHPR05MB3326.namprd05.prod.outlook.com
 ([fe80::946e:2ae1:c8ec:d37a]) by MWHPR05MB3326.namprd05.prod.outlook.com
 ([fe80::946e:2ae1:c8ec:d37a%7]) with mapi id 15.20.1294.032; Mon, 5 Nov 2018
 22:49:21 +0000
From:   Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
To:     Ben Greear <greearb@candelatech.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Jouni Malinen <j@w1.fi>
Subject: Re: [RFC 0/3] cfg80211/nl80211/iw: add basic AMPDU/AMSDU controls
Thread-Topic: [RFC 0/3] cfg80211/nl80211/iw: add basic AMPDU/AMSDU controls
Thread-Index: AQHUdRQdP3Y7plTpG06kvM3cndpYM6VBoyiAgAADvQCAACKFgA==
Date:   Mon, 5 Nov 2018 22:49:21 +0000
Message-ID: <97d75b4c-3dc6-d863-c08b-bcc31da635b1@quantenna.com>
References: <20181105143027.17570-1-sergey.matyukevich.os@quantenna.com>
 <34042c1e8020bfb49ab97c9160ab50df044846af.camel@sipsolutions.net>
 <a65739ee-ab89-cf4d-af1b-f86fcc783bac@candelatech.com>
In-Reply-To: <a65739ee-ab89-cf4d-af1b-f86fcc783bac@candelatech.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR05CA0104.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::45) To MWHPR05MB3326.namprd05.prod.outlook.com
 (2603:10b6:301:3d::37)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=igor.mitsyanko.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [12.131.200.68]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;MWHPR05MB3487;6:M2tkeWjBrWauhNTZTzrvwIa+oom94SLgcjMH12A5PXga/bMDnpgHqkCl23U2zqq1ffL9tcldmtiylrjYDbLsJehcMdwjKTuFm6Q7orqVCC9Cux/F2LD5QDqoBB8nR2bmB4nmfHeNBIhfYoEH4Qek8V2EEiQOfWga46lIFlZWgkFl0qNmCc4amiVgyy7NqteRTYvI0RzQdZynIP8ajl2Rh8g/Qn+W403322cLrBi6UjVEVTuo7CvYLfCXMLsg5Qw5r+xaKlwrKS6wmKl38bftKqt0fV1hx7tHXnnJM5945wACLDqnFIHYWKOcifkBkOpFH3Lk2YGsS4fvFX2kRC/PL4zMPCbvhhE3xHsVW2WtfiHZY25ZtLR6LuSw6ksxrwuDveeoQqpH/vKwfktO2kYY/Ln+YS9/ogi8aPHNNmI0m2l/XLBqtBs1HtRZHomqLEllieFjgUHsks9/XfKrUR9Mfg==;5:Sf+Y5q6dB7MkOgqNfw6KFJefaEvkhYawEEoZBQQawHkOACW3wusr0JdagPQD7MqQjB59Vzt0xQRxGzHJJhDIg3f96doN6n5LEpd1kGJg3JkjQVPWq1zZXVdr23+/AvL4usulY7rc4t2A6FvgYFJHiNFz9+B2shOnC54wzyLjr4E=;7:3tsNuRA6Vf+TYc3PCseYh6XDSVOnQQ/Xq9y/G1Jy6KROgUqtqcI9ICnH5ymML0WqcQHiZjJ30H2GXD35PRt3REbk5slkgTZDYKJXeZW4Yjqp5Riijhy/+ex44oZn92aCkUF6Z/T2xBLZTcpZxhw/GA==
x-ms-office365-filtering-correlation-id: d763ad76-95cd-4c84-9e16-08d64370ec9b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:MWHPR05MB3487;
x-ms-traffictypediagnostic: MWHPR05MB3487:
x-microsoft-antispam-prvs: <MWHPR05MB34878DB24D673B9D391CC6BEB0CA0@MWHPR05MB3487.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(131327999870524);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3231382)(944501410)(52105095)(93006095)(93001095)(10201501046)(3002001)(148016)(149066)(150057)(6041310)(20161123560045)(20161123564045)(20161123562045)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:MWHPR05MB3487;BCL:0;PCL:0;RULEID:;SRVR:MWHPR05MB3487;
x-forefront-prvs: 08476BC6EF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(376002)(39850400004)(136003)(366004)(189003)(199004)(186003)(31686004)(2501003)(52116002)(81156014)(476003)(486006)(76176011)(25786009)(446003)(2616005)(8676002)(66066001)(81166006)(11346002)(5660300001)(7736002)(229853002)(386003)(53546011)(305945005)(105586002)(106356001)(26005)(102836004)(71190400001)(6506007)(71200400001)(4326008)(6486002)(6246003)(2906002)(36756003)(478600001)(86362001)(31696002)(3846002)(316002)(2900100001)(68736007)(6116002)(14444005)(53936002)(99286004)(256004)(6512007)(8936002)(97736004)(14454004)(110136005)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR05MB3487;H:MWHPR05MB3326.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 7cfNV1sqqf2kfzg/u/4hd+Y6tIa7uslpdtCsHbkJkJO1XfYnNrGxel/7EdGUpOycf5akeRXl8i8m53SW+ceC/f6xc2BfExaB2VqL3LahSu4znjIgnYbcY/oUfXiG+/mji6qxXaiKj6SFIfm5WL1bDlhGmF5pBxYT169SL8P3bjPhchppDrakPpzk/hBEXGH4OyoCpH1vJxVNvDyB/Eg8ddyX8NlETL0yBrkTSJlWq/P8Cq9muzpIFy6tBemLcdVKNQehlRW3byPF/tgjqlUw1w0DyfZ/yG46V/y0awflEp+Y4H0Izsr/B4efCiJUIS5J5IXmnbqfREWhD6H4hEYS4Qz0agSaK6mbMhBj4cPZKV0=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <FF30453CD96A164CA97046BFF83D5C5A@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d763ad76-95cd-4c84-9e16-08d64370ec9b
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2018 22:49:21.0307
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
b24ndCB3YW50IHRvIGl0ZXJhdGUuLi4NCg0KTWF5ZSBJJ20gd3JvbmcsIGJ1dCBpc24ndCB0aGUg
c2V0dGluZyB3ZSdyZSBkaXNjdXNzaW5nIGFyZSBmb3IgdGhlIA0KZGV2aWNlIGl0c2VsZiwgbm90
IGZvciBpdHMgcGVlcnM/IEkgbWVhbiwgZGlzYWJsaW5nIEFNU0RVLCBBTVBEVSBpbXBsaWVzIA0K
d2UgbmVlZCB0byB1cGRhdGUgY2FwYWJpbGl0aWVzIGFkdmVydGlzZWQgaW4gb3VyIGluZm9ybWF0
aW9uIGVsZW1lbnRzLCANCndoaWNoIGFyZSBjb21tb24gZm9yIGFsbCBkZXZpY2VzLCBhbmQgaXQg
YWZmZWN0cyBib3RoIFR4IGFuZCBSeC4NCg0KQW5kIHBlci1ub2RlL3Blci1USUQgYWdncmVnYXRp
b24gc2V0dGluZ3MgYXJlIGEgc2VwYXJhdGUgY29uZmlndXJhdGlvbiANCm9wdGlvbiByZWxhdGVk
IHRvIHJhdGUgYWRhcHRhdGlvbiBvbiBUeCBwYXRoIG9ubHkuLg0K
