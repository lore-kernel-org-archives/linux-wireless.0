Return-Path: <SRS0=SE/f=NZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0398CC43441
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Nov 2018 10:54:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7C7122419
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Nov 2018 10:54:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="q/S54n3r"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A7C7122419
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=nxp.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732136AbeKNU5h (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 14 Nov 2018 15:57:37 -0500
Received: from mail-eopbgr00045.outbound.protection.outlook.com ([40.107.0.45]:55936
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727883AbeKNU5g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Nov 2018 15:57:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bt+l1Qfm63508voWjgVze7fC4nCGe6SIcbgJPSXxRBQ=;
 b=q/S54n3rMMxnMsVvQ4FAdL6RS+237ui6nXOqyqBhX4Ygke9v6/ARusMJNCtirna7aQBiTSvDl7s4O3F76mtgggleLnQtDdGHJRd1EDCDKePAOqkd8KVspXCu96rJyWTq2W0J+gylzjEunhrVxlf/30tGp8PlR89pA4sbwGNcook=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.5.23) by
 VI1PR0402MB3487.eurprd04.prod.outlook.com (52.134.4.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.28; Wed, 14 Nov 2018 10:54:48 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::a0db:beb4:1a2b:98d0]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::a0db:beb4:1a2b:98d0%5]) with mapi id 15.20.1294.045; Wed, 14 Nov 2018
 10:54:48 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] brcmfmac: Use standard SKB list accessors in
 brcmf_sdiod_sglist_rw.
Thread-Topic: [PATCH] brcmfmac: Use standard SKB list accessors in
 brcmf_sdiod_sglist_rw.
Thread-Index: AQHUeVZFLEQuKr9rgkeWKu/U2tpbiqVOoJGAgABX4ACAACN18A==
Date:   Wed, 14 Nov 2018 10:54:48 +0000
Message-ID: <VI1PR0402MB3600F31F8665EB1BDAFBAE36FFC30@VI1PR0402MB3600.eurprd04.prod.outlook.com>
References: <20181110.163402.130407398146253939.davem@davemloft.net>
 <VI1PR0402MB36009CD578B9CDBF4449130FFFC30@VI1PR0402MB3600.eurprd04.prod.outlook.com>
 <9667eb4f-36a1-0439-867b-1defc5946bc2@broadcom.com>
In-Reply-To: <9667eb4f-36a1-0439-867b-1defc5946bc2@broadcom.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [92.121.36.198]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;VI1PR0402MB3487;6:d1I5X6n1hEVVY90WxM5yGNxf5ywGAnT+iDCOvwpTdfJFEF0Gd0RX3aal5ivkLqOMJjMVPnm32qdFCy0y61f8zlgG/Gq6dM6Eq5AtYB4qSO83mJVAOs7trL0WmZBupU32BWwOOVTgVXcBcGf5H2KcU6kFbm2ceSUzrer0DtsKDnRpSnE0XBud/u8zR/jOBKwqwtD2B1hYNNvknQYCafQzA45rQc0zNfWMb2YDMaZCPFf8f7ySJhEWpj+g1UcQQZj9B9Voe7m+JryD8TkURzagJcN5UbrXTiJIvwjBSOmNefK0vsJYPNzqzhV1z5NPnsDfEELVHx42Z3K/xkW7Sip8jBHYKWv79HeK63L02c8MmVCotUX6rDLl9CZg9n+zbYfXvFjH8j2HCRwdThRbIpJrHD8PKQEAnZekjWj4h2Z2XDKcx13PlALNIBJblZ3f42TK46RxalbJ2WLhHes4ZizOBQ==;5:ePzp2SYjjQpou1ZkJNhmmLgpqjOKYgvPx9wfD0aHHcixImowK2YB1/eXdlyl32F9EqL8wbqn962/NpIOlDtnM8uAmEckeELG8s8MGtoau9YtjYxMPdIqwdcc9Xfp5999P2Qj8m13npMi1+DIkZdJOAS/k2TluICWK6Aacf9EhhM=;7:e+jTxS/DJaHfvFz0L9h8uTIseNFnFoDbJb+Es7apKrFbp6GFHZpch7EDIquYKYmlE3hdNwulbRs3NJtrYPtGlqyrMUuX/HeZoeFaD5x3nfQDJEXeXL2v6A0qFPhO9OYetPKqtdu43Yj30jHhua5vVg==
x-ms-exchange-antispam-srfa-diagnostics: SOS;
x-ms-office365-filtering-correlation-id: b9ee0a20-d85a-4683-b420-08d64a1f98ab
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(5600074)(711020)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:VI1PR0402MB3487;
x-ms-traffictypediagnostic: VI1PR0402MB3487:
x-microsoft-antispam-prvs: <VI1PR0402MB348785A57459BB63DFF6FB36FFC30@VI1PR0402MB3487.eurprd04.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(208715162771679)(9452136761055)(185117386973197);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(3002001)(93006095)(93001095)(3231410)(944501410)(52105112)(10201501046)(6055026)(148016)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123560045)(20161123564045)(20161123562045)(20161123558120)(201708071742011)(7699051)(76991095);SRVR:VI1PR0402MB3487;BCL:0;PCL:0;RULEID:;SRVR:VI1PR0402MB3487;
x-forefront-prvs: 085634EFF4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(376002)(396003)(39860400002)(366004)(199004)(189003)(86362001)(11346002)(81156014)(25786009)(97736004)(476003)(81166006)(446003)(71190400001)(71200400001)(486006)(76176011)(316002)(2501003)(8676002)(110136005)(26005)(4326008)(8936002)(256004)(2906002)(478600001)(14454004)(186003)(6246003)(6436002)(6506007)(53936002)(2900100001)(7696005)(68736007)(7736002)(55016002)(305945005)(3846002)(74316002)(6116002)(229853002)(33656002)(99286004)(105586002)(5660300001)(66066001)(53546011)(106356001)(9686003)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3487;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 5biupb/WDHVrkgv5cW/7tqYRiYfrEl0OS6GadtQj/YJhLqLdIL0Cj94ufkUfzPRqE6qgqpp6kC3+uAS1MuqnLP94Pn/OnM/u9Y+nQLEfLXwxpBxsv1f6Hd8HmZfoT4zYVJlu1HVj1KDjG49Epw822+4D7JtUaUt7j46T/OtFTtYTp0tJnLh7kIeefDN0wdjjihQPryFNMzYGZYSf68eJeTiUseaRllRRoldZDHqW578dvCIewJwXOijjwkNRIPX50IXE822z8tf+UQFWlvpOv5lonul/J5/81d+b2U+b6rwSnZ9Oz4quV4wyd6hWhaHgiLvJ5WYKP80xQsDithMlD3pETOH+OnlNEPljuWu+2uk=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9ee0a20-d85a-4683-b420-08d64a1f98ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2018 10:54:48.3974
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3487
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

RnJvbTogQXJlbmQgdmFuIFNwcmllbCBbbWFpbHRvOmFyZW5kLnZhbnNwcmllbEBicm9hZGNvbS5j
b21dIFNlbnQ6IDIwMTjlubQxMeaciDE05pelIDE2OjQwDQo+IFRvOiBBbmR5IER1YW4gPGZ1Z2Fu
Zy5kdWFuQG54cC5jb20+OyBEYXZpZCBNaWxsZXINCj4gPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBu
ZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IENjOiBsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5v
cmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSF0gYnJjbWZtYWM6IFVzZSBzdGFuZGFyZCBTS0IgbGlz
dCBhY2Nlc3NvcnMgaW4NCj4gYnJjbWZfc2Rpb2Rfc2dsaXN0X3J3Lg0KPiANCj4gT24gMTEvMTQv
MjAxOCA0OjI4IEFNLCBBbmR5IER1YW4gd3JvdGU6DQo+ID4gRnJvbTogRGF2aWQgTWlsbGVyIDxk
YXZlbUBkYXZlbWxvZnQubmV0PiBTZW50OiAyMDE45bm0MTHmnIgxMeaXpSA4OjM0DQo+ID4+IFsg
QXMgSSBhbSB0cnlpbmcgdG8gcmVtb3ZlIGRpcmVjdCBTS0IgbGlzdCBwb2ludGVyIGFjY2Vzc2Vz
IEkgYW0NCj4gPj4gICBjb21taXR0aW5nIHRoaXMgdG8gbmV0LW5leHQuICBJZiB0aGlzIGNhdXNl
cyBhIGxvdCBvZiBncmllZiBJDQo+ID4+ICAgY2FuIGFuZCB3aWxsIHJldmVydCwganVzdCBsZXQg
bWUga25vdy4gXQ0KPiANCj4gWy4uLl0NCj4gDQo+ID4NCj4gPiBJIGp1c3QgaGF2ZSBiY200MzM5
IGluIGhhbmRzLCB0ZXN0IHRoZSBwYXRjaCBvbiBpLk1YN0Qgc2RiIGJvYXJkIHdpdGgNCj4gYmNt
NDMzOSwgaXQgd29ya3MgZmluZSB3aXRoIGlwZXJmIHRlc3RpbmcuDQo+ID4NCj4gPiBUZXN0ZWQt
Ynk6IEZ1Z2FuZyBEdWFuIDxmdWdhbmcuZHVhbkBueHAuY29tPg0KPiANCj4gVGhhbmtzLCBBbmR5
DQo+IA0KPiBDYW4geW91IGRvIG9uZSBtb3JlIGNoZWNrPyBQbGVhc2UgaW5zZXJ0IGJyY21mbWFj
IHdpdGggbW9kdWxlIHBhcmFtZXRlcg0KPiBkZWJ1Zz0yIGFuZCBsZXQgbWUga25vdyBpZiB0aGUg
Zm9sbG93aW5nIGxvZyBtZXNzYWdlIGlzIHNlZW46DQo+IA0KPiBicmNtZm1hYzogYnJjbWZfc2Rp
b2Rfc2d0YWJsZV9hbGxvYzogbmVudHM9WA0KPiANCj4gSWYgbm90IHNlZW4sIHRoZSBkcml2ZXIg
ZG9lcyBub3QgZ28gdGhyb3VnaCB0aGUgcGF0Y2hlZCBjb2RlLg0KTXkga2VybmVsIGRvbid0IGVu
YWJsZSBkZWJ1ZyBhbmQgREVCVUcgYW5kIENPTkZJR19CUkNNX1RSQUNJTkcsIEkgYWRkIHRoZSBk
ZWJ1ZyBpbmZvIGluIHRoZSBicmNtZl9zZGlvZF9zZ3RhYmxlX2FsbG9jKCksIGFuZCB0aGUgbG9n
IHNob3cgdGhlIGRyaXZlciBnbyB0aHJvdWdoIHRoZSBzZyBwYXRoOg0KTG9nOiBicmNtZl9zZGlv
ZF9zZ3RhYmxlX2FsbG9jOiBtYXhfc2VnczoxMjgsIHNnX3N1cHBvcnQ6MSwgbmVudHM9MzUNCg0K
