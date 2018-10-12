Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D6CBC6787C
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 22:08:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 196782087D
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 22:08:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="npdr5Zzb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 196782087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725894AbeJMFmi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Oct 2018 01:42:38 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:26999 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbeJMFmh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Oct 2018 01:42:37 -0400
X-IronPort-AV: E=Sophos;i="5.54,374,1534834800"; 
   d="scan'208";a="21609413"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 12 Oct 2018 15:08:02 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.108) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Fri, 12 Oct 2018 15:08:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OjBX5rhKWS1dUdtFYeFgj1kvSNcok+wLaVXVhZF6hso=;
 b=npdr5Zzb0p023jYc5eLPVpbUvzyOrIAH+xx+2pNPXnb1IMFCXmSAmC6JKfxlM3Kdp5mCGJO+njI7gI/a8tb6uJODNr5TEUM8A1LzT/KKUcFEVrSndlMvhQYlVlpCenhfMRqrirb3TuuR0LjmMlhpz02Lee3S0X8QqVvNWWCZhcg=
Received: from DM2PR11MB0255.namprd11.prod.outlook.com (10.160.135.27) by
 DM2PR11MB0208.namprd11.prod.outlook.com (10.160.132.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1185.25; Fri, 12 Oct 2018 22:08:00 +0000
Received: from DM2PR11MB0255.namprd11.prod.outlook.com
 ([fe80::c495:fe35:c61f:f850]) by DM2PR11MB0255.namprd11.prod.outlook.com
 ([fe80::c495:fe35:c61f:f850%3]) with mapi id 15.20.1207.029; Fri, 12 Oct 2018
 22:08:00 +0000
From:   <Adham.Abozaeid@microchip.com>
To:     <johannes@sipsolutions.net>, <Ajay.Kathat@microchip.com>,
        <linux-wireless@vger.kernel.org>
CC:     <kvalo@codeaurora.org>, <gregkh@linuxfoundation.org>,
        <Ganesh.Krishna@microchip.com>, <Aditya.Shankar@microchip.com>,
        <Venkateswara.Kaja@microchip.com>, <Claudiu.Beznea@microchip.com>
Subject: Re: [PATCH 04/19] wilc: add host_interface.c
Thread-Topic: [PATCH 04/19] wilc: add host_interface.c
Thread-Index: AQHUVYNXfYsd0dU0yEWHmbOkbZ9wFqUVfI/RgAOB7ICAALcTAIACj3iA
Date:   Fri, 12 Oct 2018 22:08:00 +0000
Message-ID: <5BC11B3B.20901@microchip.com>
References: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
         <1537957525-11467-5-git-send-email-ajay.kathat@microchip.com>
         (sfid-20180926_122554_993494_C8703D81)
 <1539009076.3687.64.camel@sipsolutions.net>     <5BBE5BCF.5020706@microchip.com>
 <1539241314.3687.190.camel@sipsolutions.net>
In-Reply-To: <1539241314.3687.190.camel@sipsolutions.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.175.253.81]
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
x-clientproxiedby: BN3PR03CA0060.namprd03.prod.outlook.com
 (2a01:111:e400:7a4d::20) To DM2PR11MB0255.namprd11.prod.outlook.com
 (2a01:111:e400:3c24::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Adham.Abozaeid@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM2PR11MB0208;6:YG5jkQjfPt7LDbJwv70bZwVQXazuZkm91CLJ1swLOqmOyF0NvLg4YtHD81Mjj5ajXGu/bz6WMTEqbscWPE7XnL8abyX9MyzYvF1tXXjChHPgLswOlkP6ryFmkjMlwaJMVFU2dOfsXoBb3gK8XoIBsUM3Gkp00gwAsKj7EbU9Zvp3v9Dj1TE/jHzmJlNKDhQAUTWoqZqVpzCmJkBjX5vHJDHRrZxrwhoAtdftUvt43PObu1ahJW8tNyOnJfepBCTUTkDuDzn/rYePDXhJ6D6We1rSih2nIM3aX24TqSPTJpsmjct3LRl2X1XIWJ0QDo+8/6F0l4xFekZcnxdHHxPw+NpMn+gwoB6Xa+QrCwIWOIRSw09sQuEHG/LlpZj0ruklYtEauv2ArBFERgEDv+8RyIvsLCUIlWy6/oU6Pq2JJqJHqpoFR4gch11rUNKuuyvZZ9QvzRXD1XWRTh1Qt5ow1NouWdveKo1TqhIveH3k3W8=;5:/yU3xuyxWIBoldtI3EC01bSCMZriHmkaqpj2A50Be28N31sdFm1TTI3EVtbiCM1B7rxGQWHRo4HUSy1TOzwEnTUhbL4S0HzCJBRAhGVZSrzJVwYohQQN9Jpp3Yntn2i52E41Ma6bTTKINEDQEVWVtJb9ycKd45t2oVBrQmUHQuk=;7:2xS+eIWsUXeEH5oqpMBRYq6s7qpxVWBULL7hauyEh5Mt0VqZOrDDoZqoZLxVQc7EOyChIAMMayk96MuyLs5daIvBrb0i+6Tj6AQ/kvZdr60gmVFPbT4bEwlFgbpSsb19F0Q1kUoI2ZMaHGu086kzhVUpesIExAsQIMVXuCPJ9bjB193VO1WLZCGBHitHiqJXZQfJgm3aHnECp3EQAueGh/bmPyM1YQbJSBKaYZ5elnTRYiKasSKhiy57rPwg6mfa
x-ms-office365-filtering-correlation-id: 4bc7bc9c-fc6b-4b16-6fd4-08d6308f2bf5
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:DM2PR11MB0208;
x-ms-traffictypediagnostic: DM2PR11MB0208:
x-microsoft-antispam-prvs: <DM2PR11MB020831C170711B403EE0DAEE8DE20@DM2PR11MB0208.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(93006095)(93001095)(10201501046)(3002001)(3231355)(944501410)(52105095)(149066)(150057)(6041310)(20161123558120)(20161123562045)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(201708071742011)(7699051);SRVR:DM2PR11MB0208;BCL:0;PCL:0;RULEID:;SRVR:DM2PR11MB0208;
x-forefront-prvs: 0823A5777B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(136003)(39860400002)(376002)(346002)(51914003)(189003)(199004)(65956001)(97736004)(33656002)(76176011)(305945005)(71190400001)(71200400001)(65816011)(52116002)(53936002)(105586002)(6436002)(2906002)(53546011)(6506007)(93886005)(386003)(25786009)(110136005)(54906003)(66066001)(58126008)(7736002)(6512007)(99286004)(65806001)(256004)(5250100002)(36756003)(229853002)(5660300001)(26005)(86362001)(2501003)(6246003)(186003)(8676002)(107886003)(8936002)(81166006)(3846002)(72206003)(476003)(486006)(14454004)(81156014)(478600001)(2900100001)(2616005)(6486002)(106356001)(102836004)(11346002)(316002)(446003)(4326008)(68736007)(64126003)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR11MB0208;H:DM2PR11MB0255.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: FYkSoRVe99Y9owFTzVkNTEWXkRbxHkEpXXibjqkud4e+o7q9R7W9VRE2bRXrfCut606aIcqQEZqA2Ls7y6habMY0G/RT36gupxUDBTxs7rQdBkrW63dJnq6M5uv0cjdoRO7caCoaKhNSG2IdA8jxR6KsqQobQ0nb/72HNoRl0ALI3eOOBJkcUSNO7BWCaue2KQKYixoo4MrZ5FswjfQoGohQhz7u7sUyr9fRD/aqu98L3bdnMV1XkVKHQVimcB5+pR+EBYqtZt/0s/ZKzME1/LhkDCgyEbJ6BPdqs973IFKMgN/POfPcxknamV5anp+R+w0WuZYxh1pmLhM8LyGZdqdo5jZI9no3GfBJ9TuPgQ4=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <B4D606EF53AA7C45BBB9636BF6167FBC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bc7bc9c-fc6b-4b16-6fd4-08d6308f2bf5
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2018 22:08:00.0789
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM2PR11MB0208
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

DQoNCk9uIDEwLzExLzIwMTggMTI6MDEgQU0sIEpvaGFubmVzIEJlcmcgd3JvdGU6DQo+IA0KPj4g
QWdyZWUuIHBhcmFtZXRlciB2YWxpZGF0aW9uIGNhbiBiZSBkb25lIGJlZm9yZSBzY2hlZHVsaW5n
IHRoZSB3b3JrLA0KPj4gYW5kIGhlbmNlIGFwcHJvcHJpYXRlIGVycm9yIGNhbiBiZSByZXR1cm5l
ZCB0byBjYWxsZXIgLg0KPiANCj4gDQo+PiBJZiBJIGdvdCB5b3VyIHBvaW50IGNvcnJlY3RseSwg
eW91IGFyZSByZWZlcnJpbmcgdG8gdGhlIGxpbmVzIHRoYXQNCj4+IHN0b3JlcyB0aGUgcGFyYW1l
dGVycyBpbnRvIHRoZSBoaWZfZHJ2LT5jZmdfdmFsdWVzLg0KPiANCj4gV2VsbCwgSSB3YXMgYWN0
dWFsbHkgdGhpbmtpbmcgdGhhdCBJJ20gbm90IGV2ZW4gc3VyZSB3aHkgeW91IHNjaGVkdWxlDQo+
IHdvcmsgYXQgYWxsIQ0KDQpEbyB5b3UgbWVhbiB3ZSBzaG91bGQgYmUgZG9pbmcgdGhlIHdvcmsg
ZnJvbSB0aGUgY2ZnIGNvbnRleHQ/DQpOb3RlIHRoYXQgdGhpcyBpcyBjYWxsZWQgY2ZnODAyMTFf
b3BzLnNldF93aXBoeV9wYXJhbXMoKSwgYW5kIGludm9sdmVzIGxvY2tpbmcgbXV0ZXhlcywgcGFj
a2luZyB0aGUgd2lkcywgYnVzIG9wZXJhdGlvbnMsIGFuZCB3YWl0aW5nIGZvciB0aGUgZGV2aWNl
IHRvIHJlc3BvbmQuDQoNCj4+IEluc3RlYWQgb2YgcGFja2luZyB0aGUgcGFyYW1ldGVycyBpbiBo
b3N0IHN0cnVjdHVyZXMgbGlrZSBzdHJ1Y3QNCj4+IGFkZF9zdGFfcGFyYW0sIHRoZW4gcmVwYWNr
aW5nIGl0IGluIHRoZSBkZXZpY2UgZm9ybWF0LCBpdCBjYW4gdXNlDQo+PiBzdHJ1Y3Qgc3RhdGlv
bl9wYXJhbWV0ZXJzIGFuZCBwYWNrIHRoZW0gZGlyZWN0bHkgaW50byB0aGUgZGV2aWNlDQo+PiBm
b3JtYXQNCj4gDQo+IE1ha2VzIHNlbnNlLiBBbHNvIG5vdGUgbXkgb3RoZXIgZW1haWwgb24gaG93
IHRoZXJlIHNob3VsZCBiZSBzdHJ1Y3RzDQo+IGludm9sdmVkLCByYXRoZXIgdGhhbiBvcGVuLWNv
ZGVkIFdJRCBlbnRyeSBsaXN0cy4NCg0KVGhhbmtzIGZvciB0aGUgc3VnZ2VzdGlvbi4gSSBhZ3Jl
ZSB0byB0aGF0IGFzIHdlbGwuDQo=
