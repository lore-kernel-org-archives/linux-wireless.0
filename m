Return-Path: <SRS0=ivqe=NJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5652C2BC61
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 21:32:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 814542082D
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 21:32:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="pBl/I9dr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 814542082D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbeJ3GXB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 30 Oct 2018 02:23:01 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:46170 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727312AbeJ3GXA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Oct 2018 02:23:00 -0400
X-IronPort-AV: E=Sophos;i="5.54,441,1534834800"; 
   d="scan'208";a="22491735"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 29 Oct 2018 14:32:30 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.49) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Mon, 29 Oct 2018 14:32:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NJin8OnnnubZE8E34XkRilSMOgQE3AQXUmP6ACK5LWs=;
 b=pBl/I9drJznZR/utrAwN0Wb535vBJP636KAKh+A94XImkupxN5HA1OJHKfGUBzuN61W6ByF9bk6N+tzeiVupcDh0c7RjvPAPGA6zV8e0N3tknwwy/AvIRL/7lW2JjL7WS60EWV6CD/I8QLjtk92/wooucUd7lpssHCSVqow3lOI=
Received: from BY1PR11MB0246.namprd11.prod.outlook.com (10.160.205.26) by
 BY1PR11MB0326.namprd11.prod.outlook.com (10.160.206.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1273.19; Mon, 29 Oct 2018 21:32:28 +0000
Received: from BY1PR11MB0246.namprd11.prod.outlook.com
 ([fe80::55ee:9e5e:5291:a83]) by BY1PR11MB0246.namprd11.prod.outlook.com
 ([fe80::55ee:9e5e:5291:a83%4]) with mapi id 15.20.1250.034; Mon, 29 Oct 2018
 21:32:28 +0000
From:   <Adham.Abozaeid@microchip.com>
To:     <johannes@sipsolutions.net>, <Ajay.Kathat@microchip.com>,
        <linux-wireless@vger.kernel.org>
CC:     <kvalo@codeaurora.org>, <gregkh@linuxfoundation.org>,
        <Ganesh.Krishna@microchip.com>, <Aditya.Shankar@microchip.com>,
        <Venkateswara.Kaja@microchip.com>, <Claudiu.Beznea@microchip.com>
Subject: Re: [PATCH 04/19] wilc: add host_interface.c
Thread-Topic: [PATCH 04/19] wilc: add host_interface.c
Thread-Index: AQHUVYNXfYsd0dU0yEWHmbOkbZ9wFqUVfI/RgAOB7ICAALcTAIACGiCAgAj9CACAADQ4AIABR3sAgABy2YCAECCFAIAAFvaA
Date:   Mon, 29 Oct 2018 21:32:28 +0000
Message-ID: <3fa12173-6459-fa3d-54a6-3c73fb05d39a@microchip.com>
References: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
 <1537957525-11467-5-git-send-email-ajay.kathat@microchip.com>
 <1539009076.3687.64.camel@sipsolutions.net> <5BBE5BCF.5020706@microchip.com>
 <1539241314.3687.190.camel@sipsolutions.net> <5BC11B3B.20901@microchip.com>
 <5c6c7a4d3471a2784d0b203beccd4de9c55b211e.camel@sipsolutions.net>
 <5BC8D148.7050804@microchip.com>
 <492fb11bbe66cdea676e126a70a1ba9e1af3c97b.camel@sipsolutions.net>
 <5BCA4455.1020307@microchip.com>
 <7f6ec3536d71bf62e64f2592f5e1eabe05256563.camel@sipsolutions.net>
In-Reply-To: <7f6ec3536d71bf62e64f2592f5e1eabe05256563.camel@sipsolutions.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.175.253.81]
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:58.0) Gecko/20100101
 Thunderbird/58.0
x-clientproxiedby: BYAPR08CA0032.namprd08.prod.outlook.com
 (2603:10b6:a03:100::45) To BY1PR11MB0246.namprd11.prod.outlook.com
 (2a01:111:e400:5010::26)
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BY1PR11MB0326;6:zgqWPQHAsoXbpaaQvdD9xo4e4xZcqI6Cx7tGdkRlYAiDSw/TdOQSj4XFzQquMy4fysyIurgkIv5ItbLut0dddiQrUvo2RGukPyEyilUVISaRToIbcnhcWAZoMVcag4yvg3El00xY1Re4kl3ukwo75G/OWZuuTF9QUqXklpxSReepntzmZcAujQsNQNNP9L713fCxO0xMcmPzQ+yZ3QtS/es0ULAg+7+YHKtTJGY3u9mcvr+Q0lXg+HAfU0ND6eDUndNlleeV23n6wOBE8JgK6EDYBUC87napHUVX67TE3qhrhQE824H2jPoAzO/9WwqKTTLzMp+DfOmLG+2iy9prjR1Nv/N/Prk1ekhUgXH/FkFb5Ka994tOpxa9b3yqfsxr2T++sRSQAK6THnJiVvxZS+bwAY9xmA0wEZbBpzQUoyFv7/Ppf+vzKYiySUC1OcGh8efhJbT7Wn6jXleXJNGOsA==;5:bMwzCS//klguftY2OGc2Wk8Pqhp6DHS17J1P2Jy6A0HqCvcjX4ZHfAdPEmKl419HBgSbP9pyJTAJq29kxd2dw8lNUkWA72QhankYUABbxtNpiyjEtEiO9QUkr0XTXE5QVY1FqoJc6xERtO3KkJtFVmDgGxu5G8enavW2F6y6jpE=;7:VhSkq5//78FsUcop1k0qvO48Xd99fXAv+o/+W6RayZaDST/AD8updqlAxEVamoIe4+0XFSxMpoMZxgNYjQ+Fz95ycYCe0f0kXj72qUNIBAK3V6ZeavZ+8Viy7dJwcxVikEgZZc5hBJCWmtAp3PuS+A==
x-ms-office365-filtering-correlation-id: 7fcb9e15-62ff-4420-be11-08d63de605e3
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BY1PR11MB0326;
x-ms-traffictypediagnostic: BY1PR11MB0326:
x-microsoft-antispam-prvs: <BY1PR11MB0326A40DA6967E13A8B080598DF30@BY1PR11MB0326.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(10201501046)(3002001)(3231382)(944501410)(52105095)(148016)(149066)(150057)(6041310)(20161123564045)(20161123560045)(20161123562045)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BY1PR11MB0326;BCL:0;PCL:0;RULEID:;SRVR:BY1PR11MB0326;
x-forefront-prvs: 084080FC15
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(346002)(136003)(39860400002)(396003)(376002)(199004)(189003)(81156014)(25786009)(478600001)(2501003)(2900100001)(105586002)(106356001)(53546011)(6506007)(316002)(386003)(2906002)(186003)(71200400001)(256004)(66066001)(65806001)(86362001)(65956001)(71190400001)(476003)(486006)(11346002)(446003)(229853002)(5250100002)(4326008)(26005)(68736007)(31696002)(3846002)(14454004)(97736004)(6246003)(110136005)(64126003)(54906003)(2616005)(6486002)(6346003)(5660300001)(6116002)(65826007)(81166006)(76176011)(53936002)(6512007)(8936002)(58126008)(102836004)(93886005)(7736002)(305945005)(31686004)(72206003)(36756003)(107886003)(8676002)(52116002)(99286004)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY1PR11MB0326;H:BY1PR11MB0246.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Adham.Abozaeid@microchip.com; 
x-microsoft-antispam-message-info: HAnwm+fdFCUK7diUePPhaz4bIhDFs59YGqcmjT4DrdaWeNTkflcVoEFkydv/iBDf1QHS49QGBX2eP3vncrPa/W7KpD6Ai28luPpK7MdgckG+u/clGrxZjVtZObmM7TWinWTsegldAisX9EZJMCAMUq8hr1565CcuPcbrBMMfeGVKtLHFwuXjeJcCGJDvYWSm57s6ipWQsbQr5MOmIpZOHl0YhVFoLArkTKjTvhi0l47BnOz12CCtFeCWqGYnJinmEx/DT4s/qpURYw+h0W9GxSN8uC2xn9+TeasVAC7f8JGzOnEPBwUBrk5TmmQ6N2LFsUfVgWcNWOhaZNr48IvQZETLg+112gQ+fPVss8/C32E=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <52F88E6E05027B4B95B99CF288512DE2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fcb9e15-62ff-4420-be11-08d63de605e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2018 21:32:28.1806
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB0326
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

T24gMTAvMjkvMTggMToxMCBQTSwgSm9oYW5uZXMgQmVyZyB3cm90ZToNCj4+PiBJJ2QgYXJndWUg
Zm9yIHRyeWluZyBpdCB0aG91Z2ggYXMgaXQgbWFrZXMgdGhlIGNvZGUgTVVDSCBzaW1wbGVyLg0K
Pj4gSSB0b3RhbGx5IGFncmVlIHRoYXQgaXQgd2lsbCBiZSBzaW1wbGVyIHRvIGRvIHRoZSB3b3Jr
IGRpcmVjdGx5IGZyb20NCj4+IHRoZSBjZmcgY29udGV4dCByYXRoZXIgdGhhbiBzY2hlZHVsaW5n
IGl0Lg0KPj4gT24gYSBjb3J0ZXggQTUgTVBVIGFuZCBTUEkgYnVzIHJ1bm5pbmcgb24gNDhNaHos
IHRoaXMgdGFrZXMgMjBtcyBpbg0KPj4gdGhlIGlkbGUgY2FzZSwgYW5kIDEwMCB0byAzMDBtcyBp
biBjYXNlIG9mIGRhdGEgYmVpbmcgdHJhbnNmZXJyZWQgaW4NCj4+IHBhcmFsbGVsLg0KPiBUaGF0
IGRvZXMgc291bmQgcHJldHR5IHNsb3cgLi4uIGJ1dCBPVE9ILCBtb3N0bHkgd3BhX3MgZXRjLiB3
b3VsZCBleHBlY3QNCj4gdGhpcyB0byBhY3R1YWxseSBjb21wbGV0ZSBiZWZvcmUgdGhlIG5leHQg
c3RlcCwgc28gaWYgdGhpcyBpcyBzbG93IGFuZA0KPiB3cGFfcy9ob3N0YXBkIGlzIG11Y2ggZmFz
dGVyLCBpdCBtaWdodCBzZW5kIHlvdSBhIGxvdCBvZiB0aGluZ3MgdG8gZG8NCj4gYW5kIHNvIHlv
dSdkIGVuZCB1cCBiZWluZyBzbG93IGFueXdheT8NCkNvcnJlY3QuIFRoZSBzcGVlZCBvZiBleGVj
dXRpbmcgdGhlIHdvcmsgd2lsbCBiZSB0aGUgc2FtZSBpbiBib3RoIGNhc2VzIChtYXliZSBhIGxp
dHRsZSBzbG93ZXIgaW4gY2FzZSBvZiBkZWZlcnJpbmcgdGhlIHdvcmspDQpUaGUgaW50dWl0aW9u
IGhlcmUgd2FzIHRvIGRvIG1pbmltdW0gd29yayBpbiB0aGUgY2ZnJ3MgY29udGV4dCwgYnV0IHNp
bmNlIHRoaXMgaXNuJ3QgYSBjb25jZXJuLCBJIGNhbiBza2lwIGRlZmVycmluZyB0aGUgd29yay4N
Cg0KVGhhbmtzLA0KQWRoYW0NCg==
