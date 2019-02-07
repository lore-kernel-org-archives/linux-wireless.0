Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CFE9C282CC
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 09:39:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 678992084D
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 09:39:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="U4v0WCLx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbfBGJj5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 04:39:57 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:31549 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbfBGJj5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 04:39:57 -0500
X-IronPort-AV: E=Sophos;i="5.58,343,1544511600"; 
   d="scan'208";a="23536133"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 07 Feb 2019 02:39:56 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.106) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 7 Feb 2019 02:39:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U9SnsaopnDHWPfwNRN1jO/60Hb1Z4i2UvI0G6dotix4=;
 b=U4v0WCLx8ohBL4usohXvCKwNccRp/ekf7GY2nUIH/vb8EOvNY5ebLP5VaGWhhr2IOBebi/SYOnfA5Ifv7m+x+UdNrbrykZ28XuCbyeEkfgptLxuaI/6JL8L3vEjCdeIR7BV34l3Zm+14Y+X+0gi0ToymSy3LpVjjLbcVHmQI4WU=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2853.namprd11.prod.outlook.com (52.135.228.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.22; Thu, 7 Feb 2019 09:39:54 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1601.016; Thu, 7 Feb 2019
 09:39:54 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <dan.carpenter@oracle.com>
CC:     <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/9] staging: wilc1000: revert fix related to vif index
Thread-Topic: [PATCH 1/9] staging: wilc1000: revert fix related to vif index
Thread-Index: AQHUvrXdfdwvmGoLAEustPic2coPHaXT/F8AgAAYTwA=
Date:   Thu, 7 Feb 2019 09:39:54 +0000
Message-ID: <8952ae4a-52a9-354b-2368-76419d15e6af@microchip.com>
References: <1549519927-2651-1-git-send-email-ajay.kathat@microchip.com>
 <1549519927-2651-2-git-send-email-ajay.kathat@microchip.com>
 <20190207081242.GC1978@kadam>
In-Reply-To: <20190207081242.GC1978@kadam>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR0101CA0062.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::24) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [106.197.209.163]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2853;6:OUeGuxx2wHJQleGC8bgWbaw0m7OkQ6ZM6S3Z0LxABYPGjjcsYY6uiTU/EW4eZ+GzOMxUhqTO7yAbJ+UeqHIJkk/u2B7A7ZVd8k/ctPDfsC1WGf4l8NCMGYJuGk8e0Rf2mUxbhJJhcG2iLYebdbIhg275SfegWLJOqRxSTfCvtv+mLAgU+yzeoHTr/2yTlfgMvewZyfz/8tHHhct3UUnY7igb9QYpzj6cSk5VE5IGejdIvL9aPJEBj8iLaC4G/y21vG6RP18MKjHknZck86cvmDsN6WHdtMcIrzuvYabgbHJJF69GjpqDh5Z3IY/tAtK3kOiza6Js3APEIbVhyMH6AHOjnjkC04UPxI799MA3ELhysf8seAbShX0B3bZhZUR0uHxMPfhpCRQq9xmM8IaAPvpi8vDN8dWSHaPaviq3AyICG4hc4kR/EIVXA1ZTsm5C5Q4OelzzGLRx2IVypc0PFg==;5:cfZFsY3j3/JZC7IfgLzGDvXnZ+N0NJKZLIl4UvSppMxByRt8qr/rQBjbeUqAWndluUE/Ad3LK8m1xkYJT6ImhtnooY+Ehpcl/mD4jzi/pwuIwyfEl8AxQdPTEHjskiV2lADQYEnawWG3AMcwzdlLT3uuYxqNJ8CMhu7gWZwkt6dJdIVNMIdgI4Fgir48RHo1pnEF/fl5SSonLVAqXKEYZg==;7:Q4VuTCSe3sIfJeKy0t4GPw4cEN3ibM4JFybo2AE4hXceeekXk62rAz1h1KMLeYXsOhQxzytn+MpJC+XtNGoOrTOoGTCnSPzz0PC81tBTmFjGK76UlXZDgnT0v4sM+eVWdSdFKyqpJxOgpJuosDJIuw==
x-ms-office365-filtering-correlation-id: babe5ce2-f730-4c03-8792-08d68ce036d5
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2853;
x-ms-traffictypediagnostic: BYAPR11MB2853:
x-microsoft-antispam-prvs: <BYAPR11MB28533AD6A12E8410BC1571FEE3680@BYAPR11MB2853.namprd11.prod.outlook.com>
x-forefront-prvs: 0941B96580
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(136003)(366004)(376002)(346002)(396003)(199004)(189003)(256004)(81156014)(8676002)(81166006)(99286004)(31686004)(6916009)(8936002)(229853002)(97736004)(6486002)(102836004)(25786009)(11346002)(3846002)(53936002)(6436002)(6116002)(2616005)(4326008)(54906003)(486006)(478600001)(36756003)(72206003)(106356001)(305945005)(14454004)(316002)(105586002)(26005)(86362001)(186003)(6246003)(476003)(4744005)(31696002)(71190400001)(68736007)(6512007)(53546011)(386003)(6506007)(2906002)(66066001)(76176011)(7736002)(71200400001)(52116002)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2853;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9gyLKZdK69u9GE/OxDbE7O6a4gCPC0a2014qvKfz3/hLO+btW0QyrY4yrl+7t3Bwdo3WdZNfAbO94gU/NnSVHoRDIb5jT9t4G0tCAuNQ31oBcv44YcLWUrqLMpIY8kGU1cByNoTi9TOSFAwALtPmel2li6InRXZCCt3b+TTypDGJskdNBrbszliLVz4V457CWVzKJsLEq3CEF0RnZYLOBbYuqEd4UxSq0tlUVLpZGPqX0YykmU+0SkKKAwFIxoDfHj+IpkMcORxmrPRSnkrKCNqHL2KPSzhXLNG9T+nHYHz0Sx2p40JtFpCUVV/xa4BiacMzvh+zZtlUWW42MTis258+CNo8NTvYdFk1WsyhRKdAWuG862HzGkriKt0rkRdFNuN0PyhJG49q3ghNKqGyVnbxrwBqC9ZhSI0KJBc6/gs=
Content-Type: text/plain; charset="utf-8"
Content-ID: <05A674F2A44E1744A7E9118A8F475805@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: babe5ce2-f730-4c03-8792-08d68ce036d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2019 09:39:51.3061
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2853
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

SGkgRGFuLA0KDQpPbiAyLzcvMjAxOSAxOjQyIFBNLCBEYW4gQ2FycGVudGVyIHdyb3RlOg0KPiBU
aGlzIHBhdGNoIHdhcyB2ZXJ5IGNvbmZ1c2luZyB0byByZXZpZXcuLi4NCg0KQXBvbG9naWVzIGZv
ciB0aGUgY29uZnVzaW9uLg0KDQo+IEZyb20gYSBwcm9jZXNzIHBlcnNwZWN0aXZlLCB5b3UgcmVh
bGx5IHNob3VsZCBmb2xkIHBhdGNoZXMgMSBhbmQgMg0KPiB0b2dldGhlci4gIE90aGVyd2lzZSB3
ZSdyZSByZS1pbnRyb2R1Y2luZyBhIGJ1Zy4NCg0KUGF0Y2ggMSBhbmQgUGF0Y2ggMiBib3RoIGFy
ZSByZXF1aXJlZCBpZiBjb21taXQgMGU0OTA2NTdjNzIxICgic3RhZ2luZzoNCndpbGMxMDAwOiBG
aXggcHJvYmxlbSB3aXRoIHdyb25nIHZpZiBpbmRleCIpIGlzIGFwcGxpZWQgZWxzZSBQYXRjaCAy
IGlzDQplbm91Z2ggZm9yIGNvbXBsZXRlIGZpeC4gRm9yIHRoZSBhYm92ZSByZWFzb24sIEkgaGF2
ZSBkaXZpZGVkIHRoZSBmaXhlcw0KaW50byAyIHBhdGNoZXMuDQpQbGVhc2Ugc3VnZ2VzdCwgaWYg
SSBzaG91bGQgZ28gYWhlYWQgYW5kIHN1Ym1pdCB0aGlzIGluIGEgc2luZ2xlIHBhdGNoLg0KU2hv
dWxkIEkgcHV0IDIgJ0ZpeGVzOicgdGFnIGluIHRoYXQgbWVyZ2UgY29tbWl0IG9yIG9ubHkgMGU0
OTA2NTdjNzIxDQpjb21taXQgaXMgZW5vdWdoLg0KDQpSZWdhcmRzLA0KQWpheQ0K
