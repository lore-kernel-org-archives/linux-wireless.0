Return-Path: <SRS0=qkCK=NK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF9D6C6786F
	for <linux-wireless@archiver.kernel.org>; Tue, 30 Oct 2018 03:20:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F1542064C
	for <linux-wireless@archiver.kernel.org>; Tue, 30 Oct 2018 03:20:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="P4bd8lXN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8F1542064C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbeJ3ML7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 30 Oct 2018 08:11:59 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:48519 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbeJ3ML7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Oct 2018 08:11:59 -0400
X-IronPort-AV: E=Sophos;i="5.54,442,1534834800"; 
   d="scan'208";a="19622493"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 29 Oct 2018 20:20:19 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.108) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Mon, 29 Oct 2018 20:20:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AfxGjk9Mb/kVPHb/1JY/Fr42NBz//ulHjwi8iGrmhP0=;
 b=P4bd8lXNbRlggtq4F9OlEEabDa58neaA67ofXgWHf/bwlZ/WF05uiAiDlFVzgo+kzRAwzIvNBAhhSQorPcjIzC4aL9T0b7Pvl0079gsd/AlCsSqcfVs3WZYairNgzIsOQSspFTIM6nhoijfjUvPRmwPcBKeraJt47M4lKSQhS4Y=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2824.namprd11.prod.outlook.com (52.135.228.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1273.26; Tue, 30 Oct 2018 03:20:17 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7%6]) with mapi id 15.20.1273.027; Tue, 30 Oct 2018
 03:20:16 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <kvalo@codeaurora.org>
CC:     <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <Ganesh.Krishna@microchip.com>,
        <Aditya.Shankar@microchip.com>, <Venkateswara.Kaja@microchip.com>,
        <Claudiu.Beznea@microchip.com>, <Adham.Abozaeid@microchip.com>
Subject: Re: [PATCH 03/19] wilc: add host_interface.h
Thread-Topic: [PATCH 03/19] wilc: add host_interface.h
Thread-Index: AQHUVYNGrs7nwv7BgkWLIhPVpguEy6UVeVTBgAGvNAD//6RFgIAAbziAgB9IeVWAAM9kAA==
Date:   Tue, 30 Oct 2018 03:20:16 +0000
Message-ID: <1dec28df-d069-6592-0001-1d4c8ce0093d@microchip.com>
References: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
 <1537957525-11467-4-git-send-email-ajay.kathat@microchip.com>
 <1539008417.3687.57.camel@sipsolutions.net>
 <f4ab9830-7892-a062-48c4-5c5c64b5caa0@microchip.com>
 <1539081379.3687.112.camel@sipsolutions.net>
 <1d77cb4d-92c9-0ea4-bdd3-f16a2421406f@microchip.com>
 <87r2g8er91.fsf@qca.qualcomm.com>
In-Reply-To: <87r2g8er91.fsf@qca.qualcomm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR0101CA0023.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:21::33) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [183.82.16.19]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2824;6:PEzQLLEZhl6pC8wHwX8Nn5T8L2y+GAJPROcJw2HkJWfzbyl/V0yJk/zUIdjnex7Ssv/tIGVBpkhZ6SYvqdkZe+ZRsQa1VUq9FU0hv/yBRwhpJv/pt3PIyPT+dqYl4NMpgdI1rtr0EI4AaJ8POwrgSlqkb4INSHawU6xYpFo28ZPAdU0xR9D+FSCLqzPhv290Z1YiDgFPe5qCwumAxFgh5ikKfDRDtlhAD1YMcxSiF9XF4Ml9yu1VfDRo7VF/Ks/xulB8H8V8Z8x7Dzue6nrPb9HPL1dqA5FkiMNqlLCjX3wo2IBS4wCL9AHpfGfDXFiCrv3gkcm3nvzNiyQ8+oGp8xdmkXx5R3lgwdEN6XRLcSPgdhl3k8w6/evl1Tj5rWw7ozlL7wenCHXCYSEc7Rv5emoa6N3sCDAypbg9CtyYk35T33OeQkhsvL9X7a/KDRgnJmtp378KfgK8Mwy2W7KNOA==;5:ToPI9ZTMhGX/YNxM65MWWZ/PQxASeTdSANKP/0/7O4sZ6448IRUgGQeQRg1HNuzl0SBETrvt6mkrgVQnEzcdcAqkJu757fCIlFxJIYIUQV3EjnSx7FJz1BBcuSqD+/95SsQ1vUhoca0mbrsEnOVCSMZ6OyRog0hkDHQHchK3X7M=;7:KJ0u0RoqsjyH6ZBF3Y2zTbThB++voXMNOgEM+zSkN+9GNyPJnapwY3gbWue1V1FbmTt7ZQbCeSzYOp0X3RBk6wuCXtT74GHJRtncZ3BoLYQB/YrDh3K2c+pWG0IDRPBc7bmZNsJExb6F2H7jNwMyCQ==
x-ms-office365-filtering-correlation-id: db42b98c-3df8-4b0c-8dcf-08d63e169cd9
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2824;
x-ms-traffictypediagnostic: BYAPR11MB2824:
x-microsoft-antispam-prvs: <BYAPR11MB28242F553E2185BB7C40B675E3CC0@BYAPR11MB2824.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(163750095850)(17755550239193);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(10201501046)(3002001)(93006095)(93001095)(3231382)(944501410)(52105095)(148016)(149066)(150057)(6041310)(20161123564045)(20161123562045)(20161123558120)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB2824;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB2824;
x-forefront-prvs: 08417837C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(396003)(366004)(346002)(136003)(39860400002)(189003)(199004)(71200400001)(97736004)(476003)(486006)(186003)(2616005)(3846002)(86362001)(446003)(93886005)(54906003)(14454004)(2900100001)(71190400001)(6116002)(11346002)(2906002)(316002)(72206003)(31696002)(478600001)(6512007)(8676002)(53936002)(25786009)(8936002)(31686004)(99286004)(6506007)(386003)(81166006)(81156014)(68736007)(102836004)(6436002)(105586002)(4326008)(76176011)(6486002)(52116002)(106356001)(5660300001)(7736002)(6246003)(6916009)(26005)(107886003)(66066001)(53546011)(305945005)(36756003)(256004)(14444005)(5250100002)(78486012)(229853002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2824;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: ycyVop/M3jwRRQOPXpljMwGWXQ7c9v1WIMhr8AfYfGEV8eeeyGAT2rrq88y7MO5LC6KNSIGxIWWouyKLxOu9LzAD9kz5xYT/uis+S923pjwX8Kw7jK5aAzP3350tZu4AD7dDVdZD3NcACObLh4kdMZ2BEi6/lbezFkjd7Dxqymr5hpTY7xcOnP3+l+wHHE10GGLs6+vTRFMG7zvmUbk67YBOvjdNOdtMNUPDXD7xMXLc3LqLuTzIcwKDFEh7l9q43C6i2haiVz55sRhVDb4YXHRlbQBg/j6tIkoEQuIC3HMS3cfjfqsJuBENm9NOM9Z/2cIQBoc2qY9IdEp/pJhTrxzy8dFEI1zNnV7KDF5TXTQ=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <CB8B981215AFE749A1986392912F248B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: db42b98c-3df8-4b0c-8dcf-08d63e169cd9
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2018 03:20:16.9025
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2824
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

DQpPbiAxMC8yOS8yMDE4IDg6MjYgUE0sIEthbGxlIFZhbG8gd3JvdGU6DQo+IEFqYXkgU2luZ2gg
PGFqYXkua2F0aGF0QG1pY3JvY2hpcC5jb20+IHdyaXRlczoNCj4NCj4+IE9uIDEwLzkvMjAxOCA0
OjA2IFBNLCBKb2hhbm5lcyBCZXJnIHdyb3RlOg0KPj4+IE9uIFR1ZSwgMjAxOC0xMC0wOSBhdCAx
NjowNCArMDUzMCwgQWpheSBTaW5naCB3cm90ZToNCj4+Pg0KPj4+Pj4+ICt0eXBlZGVmIHZvaWQg
KCp3aWxjX3JlbWFpbl9vbl9jaGFuX2V4cGlyZWQpKHZvaWQgKiwgdTMyKTsNCj4+Pj4+PiArdHlw
ZWRlZiB2b2lkICgqd2lsY19yZW1haW5fb25fY2hhbl9yZWFkeSkodm9pZCAqKTsNCj4+Pj4gSSB0
aGluayBhcyBwZXIgY29kaW5nIHN0eWxlIHRoZSB0eXBlZGVmIGZvciBmdW5jdGlvbiBwb2ludGVy
IGFyZSBhbGxvd2VkLg0KPj4+IFRydWUsIEkgZ3Vlc3MsIGJ1dCB3aHkgZG8geW91IG5lZWQgdGhl
bT8NCj4+IEFjdHVhbGx5IHRoZXNlIGZ1bmN0aW9uIHBvaW50ZXIgYXJlIHVzZWQgaW4gbXVsdGlw
bGUgcGxhY2VzIGkuZSBpbnNpZGUNCj4+IHRoZSBzdHJ1Y3QgYW5kIGFsc28gZm9yIHBhc3Npbmcg
YXMgdGhlIGFyZ3VtZW50IGZvciB0aGUgZnVuY3Rpb24uIFNvIGkNCj4+IHRoaW5rIGl0cyBiZXR0
ZXIgdG8ga2VlcCB0aGVtIGFzIHR5cGVkZWYgdG8gc2ltcGxpZnkgYW5kIGF2b2lkIGFueSAnbGlu
ZQ0KPj4gb3ZlciA4MCBjaGFycycgY2hlY2twYXRjaCBpc3N1ZS4gQnV0IGFueXdheSBpZiB5b3Ug
c3VnZ2VzdCB3ZSBjYW4gbW9kaWZ5DQo+PiB0byByZW1vdmUgdGhlc2UgdHlwZWRlZnMgLg0KPiBQ
bGVhc2UgcmVtb3ZlIHRoZW0sIHRoZXkganVzdCBtYWtlIHRoZSBjb2RlIGhhcmRlciB0byByZWFk
Lg0KDQpTdXJlLCBJIHdpbGwgcmVtb3ZlIGl0Lg0KDQpSZWdhcmRzLA0KQWpheQ0KDQo=
