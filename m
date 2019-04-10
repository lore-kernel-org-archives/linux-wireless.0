Return-Path: <SRS0=qAu2=SM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F98CC10F11
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 18:31:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5EBA20830
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 18:31:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="veoc4zlG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730490AbfDJSbZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Apr 2019 14:31:25 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:37212 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728762AbfDJSbZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Apr 2019 14:31:25 -0400
X-IronPort-AV: E=Sophos;i="5.60,334,1549954800"; 
   d="scan'208";a="30055243"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 10 Apr 2019 11:31:24 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.106) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Wed, 10 Apr 2019 11:31:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/6RDb8/BFe/XPawGpcgzC3cOfvvt1DAozoZ9cFGthPE=;
 b=veoc4zlGcnoy2nWFwI5p3HsOiMOCRKQMJL33iCjKtpaMl/3LvVl1LWqQxhsAg7+kEps4z/ZW7RFyGyh3RSJy4mPchb0sAMuvbTGYimTyIUVDr3qwvQFiZHyA8HS1dUVikw7msklV3usriGOFE8Xqniu9m9Ts8AO/QABXCDZ0Gzg=
Received: from MWHPR11MB1373.namprd11.prod.outlook.com (10.169.234.7) by
 MWHPR11MB1536.namprd11.prod.outlook.com (10.172.54.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1792.14; Wed, 10 Apr 2019 18:31:21 +0000
Received: from MWHPR11MB1373.namprd11.prod.outlook.com
 ([fe80::583a:f4d8:147c:549]) by MWHPR11MB1373.namprd11.prod.outlook.com
 ([fe80::583a:f4d8:147c:549%5]) with mapi id 15.20.1771.016; Wed, 10 Apr 2019
 18:31:21 +0000
From:   <Adham.Abozaeid@microchip.com>
To:     <der.herr@hofr.at>
CC:     <hofrat@osadl.org>, <Ajay.Kathat@microchip.com>,
        <gregkh@linuxfoundation.org>, <linux-wireless@vger.kernel.org>,
        <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] staging: wilc1000: give usleep_range a range
Thread-Topic: [PATCH RFC] staging: wilc1000: give usleep_range a range
Thread-Index: AQHU7HE8koeh5e9EOkuq/fEUQd8KZ6YyUJwAgAC/8ACAAq2+AA==
Date:   Wed, 10 Apr 2019 18:31:21 +0000
Message-ID: <0360e5c6-28c8-db9e-1e8d-80445fe433c0@microchip.com>
References: <1554552067-15421-1-git-send-email-hofrat@osadl.org>
 <d38b17d8-5b0f-5b5e-2933-0626700e8546@microchip.com>
 <20190409013656.GA22293@osadl.at>
In-Reply-To: <20190409013656.GA22293@osadl.at>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.175.253.81]
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
x-clientproxiedby: BY5PR13CA0024.namprd13.prod.outlook.com
 (2603:10b6:a03:180::37) To MWHPR11MB1373.namprd11.prod.outlook.com
 (2603:10b6:300:24::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Adham.Abozaeid@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 16cd8ad3-6107-42b5-d631-08d6bde2ba85
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600139)(711020)(4605104)(2017052603328)(7193020);SRVR:MWHPR11MB1536;
x-ms-traffictypediagnostic: MWHPR11MB1536:
x-microsoft-antispam-prvs: <MWHPR11MB1536AC99B2FD7FF2987E274B8D2E0@MWHPR11MB1536.namprd11.prod.outlook.com>
x-forefront-prvs: 00032065B2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(346002)(136003)(39860400002)(396003)(199004)(189003)(14444005)(68736007)(305945005)(71200400001)(36756003)(7736002)(2906002)(106356001)(31686004)(71190400001)(65956001)(31696002)(256004)(97736004)(3846002)(65826007)(86362001)(66066001)(105586002)(6512007)(65806001)(2616005)(5660300002)(476003)(64126003)(53936002)(52116002)(14454004)(316002)(6116002)(76176011)(25786009)(6916009)(11346002)(6246003)(81166006)(99286004)(54906003)(478600001)(486006)(81156014)(8676002)(229853002)(58126008)(446003)(4326008)(26005)(6486002)(6436002)(6506007)(186003)(102836004)(72206003)(53546011)(8936002)(386003);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR11MB1536;H:MWHPR11MB1373.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +Idf6j9YXhatYoV8sTzI9eyT2RZsZzCV1bBUzEsRW6vdiQ8jcrtbHxtR7KZf8KSvUTBBUtPDZa/r6HL6z6nVA6lOlCbzy74bqpdNLuZjo11gy7nvJ0rylRtDXzIBH5VkWYmKllfCqn15FyatrzlUYz9O+n8xbf3VbRRMRTTNQwEODkVjWMaXMQlhjI7NoEbVuD8sdJCFBxfV+htQeY8XRLsSnl979zt5lXuwW2BSz8da9DXmQ39DTmPHHCnZfNvDYPwz+rC3lzv7cr3uMpm5BTM42x2aPWQDRCmUpHG75ycxYiP4XNu7tRSrR2GuAmBYtBi1a7EADd/P9JB04JqNbXv7G3aPHyty70yeWypYGgmNZl4lGJjUOHptIV5C+ZRXZmpPF8Qq+JuX5+MSwM5NgcgBL+qJt5BTuvbQLf39Iks=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BCB6276620694947A9014DB763EDF401@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 16cd8ad3-6107-42b5-d631-08d6bde2ba85
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Apr 2019 18:31:21.2898
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1536
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

SGkgTmljb2xhcw0KDQpPbiA0LzgvMTkgNjozNiBQTSwgTmljaG9sYXMgTWMgR3VpcmUgd3JvdGU6
DQo+IE9uIE1vbiwgQXByIDA4LCAyMDE5IGF0IDA5OjEwOjAwUE0gKzAwMDAsIEFkaGFtLkFib3ph
ZWlkQG1pY3JvY2hpcC5jb20gd3JvdGU6DQo+PiBIaSBOaWNob2xhcw0KPj4NCj4+IE9uIDQvNi8x
OSA1OjAxIEFNLCBOaWNob2xhcyBNYyBHdWlyZSB3cm90ZToNCj4+PiBFeHRlcm5hbCBFLU1haWwN
Cj4+Pg0KPj4+DQo+Pj4gU29tZW9uZSB0aGF0IGtub3dzIHRoZSBtb3RpdmF0aW9uIGZvciBzZXR0
aW5nIHRoZSB0aW1lIHRvIDIgbWlsbGlzZWNvbmQNCj4+PiBtaWdodCBuZWVkIHRvIGNoZWNrIGlm
IHRoZSAyIG1pbGxpc2Vjb25kcyB3aGVyZSBzZWVuIGFzIHRvbGxlcmFibGUgbWF4IG9yDQo+Pj4g
bWluIC0gSSdtIGFzc3VtaW5nIGl0IHdhcyB0aGUgbWluIHNvIGV4dGVuZGluZy4NCj4+IDIgbXNl
YyBpcyB0aGUgdGltZSB0aGUgY2hpcCB0YWtlcyB0byB3YWtlIHVwIGZyb20gc2xlZXAuDQo+Pg0K
Pj4gSW5jcmVhc2luZyB0aGUgbWF4aW11bSB0byA1IG1zZWMgd2lsbCBpbXBhY3QgdGhlIHRocm91
Z2hwdXQgc2luY2UgdGhpcyBjYWxsIGlzIG9uIHRoZSB0cmFuc21pdCBwYXRoLg0KPj4NCj4gb2sg
LSB3b3VsZCBpdCBiZSB0b2xsZXJhYmxlIHRvIG1ha2UgaXQgMiAtIDIuNSBtcyA/DQo+IGV2ZW4g
dGhhdCB3b3VsZCBhbGxvdyBmb3IgdGhlIGhydGltZXIgc3Vic3lzdGVtIHRvIG9wdGltaXplDQo+
IGEgbG90LiBJbiBhbnkgY2FzZSB0aGUgbWluPT1tYXggY2FzZSBnaXZlcyB5b3UgdmVyeSBsaXR0
bGUNCj4gaWYgeW91IHJ1biBhIHRlc3QtY2FzZSB3aXRoIHVzbGVlcF9yYW5nZSgxMDAwLDEwMDAp
IGFuZA0KPiBhIGxvb3Agd2l0aCB1c2xlZXBfcmFuZ2UoMTAwMCwyMDAwKSBhbmQgbG9vayBhdCB0
aGUgZGlzdHJpYnV0aW9uDQo+IHlvdSB3aWxsIGhhdmUgYSBoYXJkIHRpbWUgc2VlaW5nIGFueSBk
aWZmZXJlbmNlLg0KDQp5ZXMsIEkgYmVsaWV2ZSAyLjUgc2hvdWxkbid0IGJlIGEgcHJvYmxlbS4N
Cg0KVGhhbmtzLA0KDQpBZGhhbQ0KDQoNCg==
