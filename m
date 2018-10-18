Return-Path: <SRS0=Zpd3=M6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEF20C5ACCC
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 18:30:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5874C20658
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 18:30:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="ynSAbDV1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5874C20658
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728478AbeJSCc6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Oct 2018 22:32:58 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:58371 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726132AbeJSCc6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Oct 2018 22:32:58 -0400
X-IronPort-AV: E=Sophos;i="5.54,397,1534834800"; 
   d="scan'208";a="21770746"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 18 Oct 2018 11:30:43 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.38) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 18 Oct 2018 11:30:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mgM3yelSrekZNMs0CjwWQpYaSnnHy6lnEUuwJRs4qv4=;
 b=ynSAbDV1n2JEeyP75qdE013GO7WxXImVJiQ0U4aKnZJ0l9f70AzCcqyKwZssi4daDEs5An6KNnjsuIUhDwywLxt+DSI06SwZoOVCx5KOXDAOqfPkrSMSHMADeRaVmg38SAC+GuOE/NZqpifEqxsnVlPujnDtyeKtazh58PtUtzc=
Received: from DM2PR11MB0255.namprd11.prod.outlook.com (10.160.135.27) by
 DM2PR11MB0222.namprd11.prod.outlook.com (10.160.132.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1228.26; Thu, 18 Oct 2018 18:30:37 +0000
Received: from DM2PR11MB0255.namprd11.prod.outlook.com
 ([fe80::5cab:d918:f310:6f0e]) by DM2PR11MB0255.namprd11.prod.outlook.com
 ([fe80::5cab:d918:f310:6f0e%9]) with mapi id 15.20.1228.032; Thu, 18 Oct 2018
 18:30:37 +0000
From:   <Adham.Abozaeid@microchip.com>
To:     <johannes@sipsolutions.net>, <Ajay.Kathat@microchip.com>,
        <linux-wireless@vger.kernel.org>
CC:     <kvalo@codeaurora.org>, <gregkh@linuxfoundation.org>,
        <Ganesh.Krishna@microchip.com>, <Aditya.Shankar@microchip.com>,
        <Venkateswara.Kaja@microchip.com>, <Claudiu.Beznea@microchip.com>
Subject: Re: [PATCH 04/19] wilc: add host_interface.c
Thread-Topic: [PATCH 04/19] wilc: add host_interface.c
Thread-Index: AQHUVYNXfYsd0dU0yEWHmbOkbZ9wFqUVfI/RgAOB7ICAALcTAIACGiCAgAj9CACAAKmRAA==
Date:   Thu, 18 Oct 2018 18:30:37 +0000
Message-ID: <5BC8D148.7050804@microchip.com>
References: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
         <1537957525-11467-5-git-send-email-ajay.kathat@microchip.com>
         (sfid-20180926_122554_993494_C8703D81)
 <1539009076.3687.64.camel@sipsolutions.net>
                 <5BBE5BCF.5020706@microchip.com>
         <1539241314.3687.190.camel@sipsolutions.net>
 <5BC11B3B.20901@microchip.com>
 <5c6c7a4d3471a2784d0b203beccd4de9c55b211e.camel@sipsolutions.net>
In-Reply-To: <5c6c7a4d3471a2784d0b203beccd4de9c55b211e.camel@sipsolutions.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.175.253.81]
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
x-clientproxiedby: BN3PR03CA0051.namprd03.prod.outlook.com
 (2a01:111:e400:7a4d::11) To DM2PR11MB0255.namprd11.prod.outlook.com
 (2a01:111:e400:3c24::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Adham.Abozaeid@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM2PR11MB0222;6:zAa7Q4r8JQDVShEqxw1X1ZXqk358LrvuguEt4ddz0YC03vi6YZAgAidikaJcWaK79rXcFOIeLOUTHlToEFS07LIhj3+Io1wfk1KoEPdCiwNT8WwGZrN3847Ac2cQoW6+1KEmT5NJ053Ki48t+0L7UmsL8rtLvXdAZG96pk3ymCpiHpRc8FxC0e7FWu3/mctYWTM1x3kA/yXkih6xeS09cL7xnb22ur9cone4W12TroQSZD5OzkW5+/Gh6AztVEENnj0wDmfHYYZn5TGh/ughq4UNq/PR5qzB4PWZdBJjIxzfgxPn3ln/eiYCVH0OOkzHR+jBSC1ukcQo5yngKeh57oGUOCQWNeTkSyjF3F0mlwhy/LPgkUyXSOGKGUKaSyHaM8svkYpXgV2ZalSX4EIQvmnJkGkww3KF0umM25sU8MfxFw1Ok/lgxl1DpnCgo9UZPCSPYS/otCZ8EEikrQUuAw==;5:++6QYRugiYVR7ykXxQQKkKafnwtrbe7XjZJ/8Tfk7OC2ppCf2SoS31PuT1K31uLB2d3iD0A1vw4KCpZuAtA7QCdNqBIJAMlSIxX19LZA2nDlxx/9FLzUVuy0mXkqplodBg/KzvWnjLiZTT77VN160nbWv77eR2bMX+9aAB2bND8=;7:ecWxUL6kx/bzA7iBp4/CjMOSB1Na0wohDYXKSbAM3iNGNIqfO8egBkNzXZxiOgYqHRyaS+HNSW/SKLrMbi5/02p9m5ukBLbNjaxmMim4A2PjKYvxeNWJJcnQOzh2KVuSeQJXo9T4ty2OIhAnCjgsQm0O7XeR0DLeB9zp9Gt1NG2xUFmFf/sjw/zYons6XHufi8/TuoIDk4SGsFw4oVqX2vkCKYMO8Xsw6xldzTd/4ZmpNW4kWGX2jvhFyrQQGnHF
x-ms-office365-filtering-correlation-id: bd87437b-e86a-40c9-541f-08d63527cc5e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:DM2PR11MB0222;
x-ms-traffictypediagnostic: DM2PR11MB0222:
x-microsoft-antispam-prvs: <DM2PR11MB0222D1D7FDCCDB5967FA77788DF80@DM2PR11MB0222.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(93006095)(93001095)(10201501046)(3231355)(944501410)(52105095)(3002001)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(20161123564045)(20161123562045)(20161123558120)(20161123560045)(201708071742011)(7699051)(76991095);SRVR:DM2PR11MB0222;BCL:0;PCL:0;RULEID:;SRVR:DM2PR11MB0222;
x-forefront-prvs: 08296C9B35
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(366004)(376002)(39860400002)(346002)(136003)(189003)(199004)(110136005)(7736002)(446003)(25786009)(2616005)(86362001)(107886003)(4326008)(26005)(11346002)(5660300001)(486006)(54906003)(186003)(80316001)(8676002)(508600001)(476003)(105586002)(93886005)(66066001)(81156014)(81166006)(65956001)(65806001)(4001150100001)(6436002)(14454004)(59896002)(5250100002)(97736004)(8936002)(2501003)(3846002)(6116002)(65816011)(316002)(6246003)(53936002)(68736007)(58126008)(72206003)(106356001)(229853002)(33656002)(87266011)(76176011)(2906002)(53546011)(6506007)(386003)(99286004)(6486002)(71190400001)(52116002)(2900100001)(64126003)(71200400001)(102836004)(305945005)(6512007)(36756003)(256004);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR11MB0222;H:DM2PR11MB0255.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: E/7srrg/u13sl05yRXLbJXpakyrflX0bIzXKInrj7fw0W0/WVDNz8mwatBpZa+sBUzZ8dDf223v5mpIyRsW38PAjojYwgOJ+zhI/FtB2OKVvLjoAdewO8azdN8DYuYvah/+IfrKFev7GxPsrcxqLdazftKOkW9LfYYiIpprZCJWlIOFKAWo2EQqxRPyiNIkHJfwSeNIOe8ShnLEcaaZmF2LG6B4BOqShcLifHoXOMV+yFtKH+Z0aRJn/IMgtjFj9ph2gbn/gFshP+zzb1GUHl5jLauna1jQWiNMuRfSkXcVhyxT1jUPHKbzA2jVwiMfs3JK1r/Sxq1NGNSihlWPTyx304E98vPDZqD/XcCutG9U=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <790FB6A01B6A0041B56ED69F54D5E76B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: bd87437b-e86a-40c9-541f-08d63527cc5e
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2018 18:30:37.5890
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM2PR11MB0222
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

DQoNCk9uIDEwLzE4LzIwMTggMDE6MjMgQU0sIEpvaGFubmVzIEJlcmcgd3JvdGU6DQo+IE9uIEZy
aSwgMjAxOC0xMC0xMiBhdCAyMjowOCArMDAwMCwgQWRoYW0uQWJvemFlaWRAbWljcm9jaGlwLmNv
bSB3cm90ZToNCj4+DQo+PiBPbiAxMC8xMS8yMDE4IDEyOjAxIEFNLCBKb2hhbm5lcyBCZXJnIHdy
b3RlOg0KPj4+DQo+Pj4+IEFncmVlLiBwYXJhbWV0ZXIgdmFsaWRhdGlvbiBjYW4gYmUgZG9uZSBi
ZWZvcmUgc2NoZWR1bGluZyB0aGUgd29yaywNCj4+Pj4gYW5kIGhlbmNlIGFwcHJvcHJpYXRlIGVy
cm9yIGNhbiBiZSByZXR1cm5lZCB0byBjYWxsZXIgLg0KPj4+DQo+Pj4NCj4+Pj4gSWYgSSBnb3Qg
eW91ciBwb2ludCBjb3JyZWN0bHksIHlvdSBhcmUgcmVmZXJyaW5nIHRvIHRoZSBsaW5lcyB0aGF0
DQo+Pj4+IHN0b3JlcyB0aGUgcGFyYW1ldGVycyBpbnRvIHRoZSBoaWZfZHJ2LT5jZmdfdmFsdWVz
Lg0KPj4+DQo+Pj4gV2VsbCwgSSB3YXMgYWN0dWFsbHkgdGhpbmtpbmcgdGhhdCBJJ20gbm90IGV2
ZW4gc3VyZSB3aHkgeW91IHNjaGVkdWxlDQo+Pj4gd29yayBhdCBhbGwhDQo+Pg0KPj4gRG8geW91
IG1lYW4gd2Ugc2hvdWxkIGJlIGRvaW5nIHRoZSB3b3JrIGZyb20gdGhlIGNmZyBjb250ZXh0Pw0K
Pj4gTm90ZSB0aGF0IHRoaXMgaXMgY2FsbGVkIGNmZzgwMjExX29wcy5zZXRfd2lwaHlfcGFyYW1z
KCksIGFuZCBpbnZvbHZlcw0KPj4gbG9ja2luZyBtdXRleGVzLCBwYWNraW5nIHRoZSB3aWRzLCBi
dXMgb3BlcmF0aW9ucywgYW5kIHdhaXRpbmcgZm9yIHRoZQ0KPj4gZGV2aWNlIHRvIHJlc3BvbmQu
DQo+IA0KPiBUaGF0ICpzaG91bGQqIGJlIGZpbmUgLSBob3cgbG9uZyBkbyB5b3UgZXhwZWN0IHRo
YXQgdG8gdGFrZT8NCj4gDQoNCkl0IGRlcGVuZHMgb24gdGhlIElPIGJ1cyB1c2VkIChTUEkvU0RJ
TyksIGNsb2NrIHNwZWVkLi4gZXRjDQpJdCB3b3VsZCBhbHNvIHZhcnkgYWNjb3JkaW5nIHRvIHRo
ZSBkYXRhIHBhY2tldHMgYmVpbmcgdHJhbnNmZXJyZWQgd2l0aCB0aGUgZGV2aWNlLg0KSWYgdGhl
cmUncyBoZWF2eSBkYXRhIHRyYW5zZmVyLCBjb25maWd1cmF0aW9uIHBhY2tldHMgd291bGQgdGFr
ZSBsb25nZXIgdG8gYmUgc2VudCwgYW5kIGZvciB0aGVpciByZXNwb25zZSB0byBiZSByZWNlaXZl
ZC4NCg0KDQpUaGFua3MsDQpBZGhhbQ0K
