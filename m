Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 701EEC65C20
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 19:19:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AD652089D
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 19:19:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="wt9VnyN2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2AD652089D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbeJICcV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 22:32:21 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:30708 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727002AbeJIBr7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 21:47:59 -0400
X-IronPort-AV: E=Sophos;i="5.54,357,1534834800"; 
   d="scan'208";a="21344463"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 08 Oct 2018 11:34:55 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.49) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Mon, 8 Oct 2018 11:34:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yFMmu7ZoGeqI4hPGjkt6FSn97GEy3sX8/R2W+LtKSC0=;
 b=wt9VnyN2bI9tpf+t33zLmUbUvuJ13kZkyLZ4B2j2WWqbh2KIo+omQuk7l8KrWIPqPHEhApiafEh4StgDdLMKj/pM6Mu6lV/X8Czw6HN7TDRKL0K+VBWblPrZ6Cf7UzA9QxA0Pn1OlwwE/1NPTn1wmVUg+jmxmi7ygqddOQU+CWM=
Received: from DM2PR11MB0255.namprd11.prod.outlook.com (10.160.135.27) by
 DM2PR11MB0222.namprd11.prod.outlook.com (10.160.132.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.21; Mon, 8 Oct 2018 18:34:52 +0000
Received: from DM2PR11MB0255.namprd11.prod.outlook.com
 ([fe80::c495:fe35:c61f:f850]) by DM2PR11MB0255.namprd11.prod.outlook.com
 ([fe80::c495:fe35:c61f:f850%3]) with mapi id 15.20.1207.024; Mon, 8 Oct 2018
 18:34:52 +0000
From:   <Adham.Abozaeid@microchip.com>
To:     <kvalo@codeaurora.org>, <Ajay.Kathat@microchip.com>
CC:     <linux-wireless@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <Ganesh.Krishna@microchip.com>, <Aditya.Shankar@microchip.com>,
        <Venkateswara.Kaja@microchip.com>, <Claudiu.Beznea@microchip.com>
Subject: Re: [RFC 00/19] wilc: added driver for wilc module
Thread-Topic: [RFC 00/19] wilc: added driver for wilc module
Thread-Index: AQHUVYNNXLDJJANiYUeWMsjNKi4pIaUSOgTjgAKngYCAACe2aIAAtu0A
Date:   Mon, 8 Oct 2018 18:34:51 +0000
Message-ID: <5BBBA348.3070503@microchip.com>
References: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
        <87zhvrdz0q.fsf@kamboji.qca.qualcomm.com>
        <20181008104757.5e27eacb@ajaysk-VirtualBox>
 <87o9c4zy53.fsf@codeaurora.org>
In-Reply-To: <87o9c4zy53.fsf@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.175.253.81]
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
x-clientproxiedby: CY4PR22CA0063.namprd22.prod.outlook.com
 (2603:10b6:903:ae::25) To DM2PR11MB0255.namprd11.prod.outlook.com
 (2a01:111:e400:3c24::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Adham.Abozaeid@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM2PR11MB0222;6:0ZHnGwzw3Q2tMNz8r1F+dP69wt7H/5L4U1CSOr9Xul/ygMaOgvpuWEBFYPqfzoZTESn+UwVDCl3ZwBKWMrRFxdzUQwC6HAqPf71vMRoYgO08KlZdgMOQUnZ8UtwEUlXGoaZ/FVMSq9EEnJmgNK0yLeU5Jb1mkkG9Gnc2nVzknxN/XEURBOdAl1bJBdRP2+whsuyX5BGzVCHgstwVRvakyr31j0Pk6p/0G1NoghOO1zAhR87yHDHwGqFunaNCcHkrCK2qt6DwuNYXzrjqwiaRkZm123vUA3o6j6k5wgUdZkcBf8Tqi5+hTK2/kZK8S0RhEuNDjlU94x+VUULo+Se1LxY48SNVu7G35ubZ8/G7QGCg/7gLU6gqri9TiK/nal1mjBoqs/gukjLAn9tfhnG1o0tGrBaHz6l7Blhn1x/ePCfK7EtFQfGxjNaEBW8zBY7ZuVK4oT/8XK/P0JKgGj8zRQ==;5:1XnSnTKF5S9CmuEo7JdJEF0cPm4t/golbnw0zA3ovqJQPs7kU24K71nA7VSCQmfrGkm/+6m47DB4Dx1BipSVpehY1+z4T0lfunlL28EZr5gjtYtTGerDd6pCtYydLJXoZK1aZB5t38VR03bcjy64LJqmp2WI+YeO5WZx7ujWQ20=;7:Nx42+iPZQIeT1+NAN52mT9YM1sJ1fkJhbnA1kZtbjsv24kBfiG9AN/LZ2FKc+t+nmwBaYfC9wv+NSKglJw8RBpbVZd8+3JstnxkP4AB5M4N2sqyZ5BQ0MNpWCewecRd1KQDPZ2S4Cdjv6702O6Gg/JV3LGEi6jYi7QHWSW6Zz8TCslSq7EBBaPb/SV1lEI1Td42qH9173fDAzY9Z7RRJeYrqFY7tnSd+YQISJGNQ3TD1b8teRf+CZG1OnDpxV12D
x-ms-office365-filtering-correlation-id: 0a0e1b5c-9b1e-47d7-7162-08d62d4cbbe0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:DM2PR11MB0222;
x-ms-traffictypediagnostic: DM2PR11MB0222:
x-ld-processed: 3f4057f3-b418-4d4e-ba84-d55b4e897d88,ExtAddr
x-microsoft-antispam-prvs: <DM2PR11MB0222E090076D2CD0044CE7328DE60@DM2PR11MB0222.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3231355)(944501410)(52105095)(3002001)(93006095)(93001095)(10201501046)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123560045)(20161123562045)(20161123558120)(20161123564045)(201708071742011)(7699051);SRVR:DM2PR11MB0222;BCL:0;PCL:0;RULEID:;SRVR:DM2PR11MB0222;
x-forefront-prvs: 081904387B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(39860400002)(346002)(376002)(366004)(136003)(189003)(199004)(80316001)(102836004)(8676002)(93886005)(81156014)(81166006)(305945005)(446003)(97736004)(7736002)(36756003)(478600001)(5250100002)(87266011)(76176011)(65816011)(6246003)(52116002)(316002)(59896002)(186003)(99286004)(6512007)(53936002)(4326008)(107886003)(105586002)(106356001)(25786009)(33656002)(386003)(26005)(53546011)(6506007)(256004)(5660300001)(110136005)(2900100001)(6636002)(58126008)(64126003)(54906003)(486006)(66066001)(65956001)(65806001)(2906002)(68736007)(229853002)(8936002)(71200400001)(71190400001)(3846002)(6436002)(6116002)(6486002)(11346002)(72206003)(2616005)(14454004)(476003)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR11MB0222;H:DM2PR11MB0255.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: fQzOXy8iHimHRwWMZ065KdbsVw4eCPdaNvCzxYt55ABdR+Qr6tt6CuJo//y0tZMx+H2qfWCBV+o5Y+hmctPnDyQissKKPb+9DDxZCEQdYVjLK+FvLdxKFnawxfi+vY1mPbvmUYHRGzlgvqLU/5hiuOHSUKj00/pYD+ekckqRY3rCM+6MMjfoyBewIzs7f/v1VmtSs0pUDHmcXMlYQrc8/yWGN+z0lenxo4s5yUOkWDJAMb4c7T4gEKrb+9PkadH5MPvVhlkoQAjkEpIUil5lLR6FcueQZQi2RWQHPjBh4YDdc0yuLUCfkc+d8aiZ4BP/lHprqC9XngZ9AWvn0MpGPIV0DJRDsSv0FaCrInYdhaI=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <D413AAFA39CA274B86703E5EA5D27232@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a0e1b5c-9b1e-47d7-7162-08d62d4cbbe0
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2018 18:34:52.0222
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM2PR11MB0222
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

DQoNCk9uIDEwLzA4LzIwMTggMTI6MzggQU0sIEthbGxlIFZhbG8gd3JvdGU6DQo+IEFqYXkgU2lu
Z2ggPGFqYXkua2F0aGF0QG1pY3JvY2hpcC5jb20+IHdyaXRlczoNCj4gDQo+PiBPbiBTYXQsIDYg
T2N0IDIwMTggMTU6NDU6NDEgKzAzMDANCj4+IEthbGxlIFZhbG8gPGt2YWxvQGNvZGVhdXJvcmEu
b3JnPiB3cm90ZToNCj4+DQo+Pj4gQWpheSBTaW5naCA8YWpheS5rYXRoYXRAbWljcm9jaGlwLmNv
bT4gd3JpdGVzOg0KPj4+DQo+Pj4+IFRoaXMgcGF0Y2ggc2V0IGNvbnRhaW5zIHRoZSBkcml2ZXIg
ZmlsZXMgZnJvbQ0KPj4+PiAnZHJpdmVyL3N0YWdpbmcvd2lsYzEwMDAnLiBSZW5hbWVkIHRoZSBk
cml2ZXIgZnJvbSAnd2lsYzEwMDAnIHRvDQo+Pj4+ICd3aWxjJyB0byBoYXZlIGdlbmVyaWMgbmFt
ZSwgYXMgdGhlIHNhbWUgZHJpdmVyIHdpbGwgYmUgdXNlZCBieQ0KPj4+PiBvdGhlciB3aWxjIGZh
bWlseSBtZW1iZXJzLiAgDQo+Pj4NCj4+PiBJJ20gd29ycmllZCB0aGF0IHRoZSBuYW1lICd3aWxj
JyBpcyBqdXN0IHRvbyBnZW5lcmljLCBJIGxpa2VkIHRoZQ0KPj4+IG9yaWdpbmFsIG5hbWUgd2ls
YzEwMDAgbXVjaCBtb3JlLiBRdWl0ZSBvZnRlbiB3aGVuIHdlIGhhdmUgYSBuZXcNCj4+PiBnZW5l
cmF0aW9uIG9mIHdpcmVsZXNzIGRldmljZXMgdGhlcmUncyBhbHNvIGEgbmV3IGRyaXZlciwgc28g
aW4gdGhlDQo+Pj4gbG9uZyBydW4gSSdtIHdvcnJpZWQgdGhhdCBhIGdlbmVyaWMgbmFtZSBsaWtl
ICd3aWxjJyBjb3VsZCBiZSBhDQo+Pj4gc291cmNlIG9mIGNvbmZ1c2lvbi4gSSB0aGluayBpdCdz
IG11Y2ggc21hbGxlciBwcm9ibGVtIGlmDQo+Pj4gJ3dpbGMxMDAwJyAodGhlIGRyaXZlcikgYWxz
byBzdXBwb3J0cyB3aWxjMzAwMCAodGhlIGRldmljZSksIHBlb3BsZQ0KPj4+IGFyZSBhbHJlYWR5
IHVzZWQgdG8gdGhhdC4gDQoNCj4gSWYgSSdtIHVuZGVyc3RhbmRpbmcgY29ycmVjdGx5IHlvdSBh
cmUgd29ycmllZCB0aGF0ICd3aWxjMTAwMC1zcGkua28nDQo+IGFsc28gc3VwcG9ydHMgd2lsYzMw
MDAgZGV2aWNlcywgYnV0IEkgZG9uJ3Qgc2VlIHRoYXQgYXMgYSBwcm9ibGVtLiBJDQo+IHRoaW5r
IGl0J3MgdmVyeSBjb21tb24gKG5vdCBqdXN0IGluIHdpcmVsZXNzKSB0aGF0IHRoZSBtYXJrZXRp
bmcgbmFtZXMNCj4gZG9uJ3QgYWx3YXlzIG1hdGNoIHdpdGggZHJpdmVyIG5hbWVzLg0KPiANCg0K
SXQncyBoaWdobHkgdW5saWtlbHkgdGhhdCBtaWNyb2NoaXAgd2lsbCBoYXZlIGEgbmV3IGdlbmVy
YXRpb24gb2Ygd2lsYyBkZXZpY2VzIG90aGVyIHRoYW4gd2lsYzEwMDAgYW5kIHdpbGMzMDAwLCBz
aW5jZSBhIG5ldyBmYW1pbHkgaXMgYWxyZWFkeSBpbiBkZXZlbG9wbWVudC4NCkFuZCBpbiBjYXNl
IGEgbmV3IGdlbmVyYXRpb24gd2FzIGRldmVsb3BlZCwgaXQgd2lsbCBiZSBiZXN0IHRvIHN1cHBv
cnQgaXQgaW4gdGhlIGN1cnJlbnQgZHJpdmVyIGJlY2F1c2Ugb2YgdGhlIHNpbWlsYXJpdGllcyBi
ZXR3ZWVuIHdpbGMgZGV2aWNlcy4NCg0KSSdtIGFmcmFpZCB0aGF0IGl0IG1pZ2h0IGJlIG1vcmUg
Y29uZnVzaW5nIGZvciB1c2VycyB0byB1c2Ugd2lsYzEwMDAgbmFtaW5nIHdoaWxlIHRoZXkgYXJl
IHVzaW5nIHdpbGMzMDAwIGhhcmR3YXJlLiBJdCdzIG5vdCBvbmx5IHRoYXQgdGhlIG5hbWUgdGhh
dCBpcyBkaWZmZXJlbnQgZnJvbSB0aGUgbWFya2V0aW5nIG5hbWUsIGJ1dCBpdCBhbHNvIHJlZmVy
cyB0byBhbm90aGVyIGV4aXN0aW5nIHByb2R1Y3QuDQoNClRoYW5rcywNCkFkaGFtDQo=
