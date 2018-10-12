Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3CF9C6787C
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 21:55:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 297E1204EC
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 21:55:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="FfXo3Tur"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 297E1204EC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725970AbeJMF35 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Oct 2018 01:29:57 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:58636 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbeJMF35 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Oct 2018 01:29:57 -0400
X-IronPort-AV: E=Sophos;i="5.54,374,1534834800"; 
   d="scan'208";a="19429374"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 12 Oct 2018 14:55:24 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.38) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Fri, 12 Oct 2018 14:55:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jgAnb8VuW+3HvGyTBKO6Un5VfmRDxB613yw6GYPBNjo=;
 b=FfXo3Turb82rWGjsJ+tYApipXWkI/HRvOTRzhTJUDYQnYOJhhFh6h4nI5JdNrnzhh0AzNhLmoJLKy3/VquPglVDgI3f2Mgqde+pJ4OxFR10GvoeRnmg62zsusZR2EP4yFR47OOQF49elOOq0CtExyB523qcc+Hdz3lyfVXd47MY=
Received: from DM2PR11MB0255.namprd11.prod.outlook.com (10.160.135.27) by
 DM2PR11MB0106.namprd11.prod.outlook.com (10.160.26.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1228.25; Fri, 12 Oct 2018 21:55:20 +0000
Received: from DM2PR11MB0255.namprd11.prod.outlook.com
 ([fe80::c495:fe35:c61f:f850]) by DM2PR11MB0255.namprd11.prod.outlook.com
 ([fe80::c495:fe35:c61f:f850%3]) with mapi id 15.20.1207.029; Fri, 12 Oct 2018
 21:55:20 +0000
From:   <Adham.Abozaeid@microchip.com>
To:     <johannes@sipsolutions.net>, <Ajay.Kathat@microchip.com>,
        <linux-wireless@vger.kernel.org>
CC:     <kvalo@codeaurora.org>, <gregkh@linuxfoundation.org>,
        <Ganesh.Krishna@microchip.com>, <Aditya.Shankar@microchip.com>,
        <Venkateswara.Kaja@microchip.com>, <Claudiu.Beznea@microchip.com>
Subject: Re: [PATCH 04/19] wilc: add host_interface.c
Thread-Topic: [PATCH 04/19] wilc: add host_interface.c
Thread-Index: AQHUVYNXfYsd0dU0yEWHmbOkbZ9wFqUZANzTgANAnwA=
Date:   Fri, 12 Oct 2018 21:55:20 +0000
Message-ID: <5BC11842.1050700@microchip.com>
References: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
         <1537957525-11467-5-git-send-email-ajay.kathat@microchip.com>
         (sfid-20180926_122554_993494_C8703D81)
 <1539202484.3687.188.camel@sipsolutions.net>
In-Reply-To: <1539202484.3687.188.camel@sipsolutions.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.175.253.81]
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
x-clientproxiedby: BN3PR03CA0078.namprd03.prod.outlook.com
 (2a01:111:e400:7a4d::38) To DM2PR11MB0255.namprd11.prod.outlook.com
 (2a01:111:e400:3c24::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Adham.Abozaeid@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM2PR11MB0106;6:ZQOUu697x4Ou+Sx3DniYpFR7pEVIanMqkYUk7DJkv9J/CMOxSwpKe8iVrUL8YP8jS3knBj1gNVPBoCqin/NtRefwXiI2wDDqFnYnoX2GhscWgBD2enebyrIni96ZQOvKENJPDGHMLMxhTz6SujA0E8X6Fz5BesCqoH7gu277wGLBGf6tHa6790CmAa/Dst6A5D+1KXglmjUhbPjoqXk78kJvv6kaExH9dxCPVbH1f6Kgo506IAmimETbfLtlOWevyWmA8Nxx0Ar0LUgJ8wlPXS+4dljD5KfCgEiq05vtJ1raJ4e7THKoLxzAIbPRdTmA6WmWZe55iXEkJPTi+KZH0h3czO1vy1vTzk/V+LC0PMSUEhUXHh2Rvmzgp3ar12jHJn5Eog0CZJfHyunU0rXtuKBaux51FydPUlk9IKcqWdHXY6+/UzmU+E0iMvuwLu37Yk8rJIhNVYy4YMZZRfbaDA==;5:veVxtZYwmDWwymWlJsuKgpIZz2G82U1530DjSoaOg2eRYvbj71Ho+ODfi26tlZ4KKgTPu0tjd8pOfNXGXHn1rRhguc9Ck5aaMUwRwbRUXThsig1hu5YMo4keZgVeVBvjrybzVUd4nH9+d4vNMlABr7beopk1qW/oHMWXQyF10i4=;7:7DIbNLYbD8ilQ51ud671qCLqVtKInUJnilIk9DKQwqVhi3IMh6OMqbrZjHfUmwcE5X0LNwOWlvCEVubUbve5MrZr53YdCyNjaFSVylKQv0EeFqh3sxI6DQ2Jvg8Lk7Oupr1h/c9XcQ1UwQ/rUbGhchBvVGTH3YGwP8v/mFj+OxELCO2o4LwR5wrRxLAeSjfDmFl5Iglika4+/SW7EZjoC0UMPDWeTkIyBqvpCA3vNN6CiNGMmFSsL/99JKkIr0J8
x-ms-office365-filtering-correlation-id: 2d2af28b-2b41-40f4-da37-08d6308d6744
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:DM2PR11MB0106;
x-ms-traffictypediagnostic: DM2PR11MB0106:
x-microsoft-antispam-prvs: <DM2PR11MB0106B5F079338664AC958A228DE20@DM2PR11MB0106.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(93006095)(93001095)(10201501046)(3002001)(3231355)(944501410)(52105095)(149066)(150057)(6041310)(20161123562045)(20161123564045)(20161123560045)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991067);SRVR:DM2PR11MB0106;BCL:0;PCL:0;RULEID:;SRVR:DM2PR11MB0106;
x-forefront-prvs: 0823A5777B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(366004)(396003)(376002)(136003)(39860400002)(189003)(199004)(186003)(2900100001)(305945005)(7736002)(11346002)(26005)(97736004)(6486002)(86362001)(5250100002)(53936002)(2501003)(6512007)(476003)(2616005)(486006)(446003)(58126008)(110136005)(54906003)(36756003)(81156014)(478600001)(81166006)(8676002)(316002)(106356001)(105586002)(8936002)(65806001)(66066001)(80316001)(72206003)(65956001)(14454004)(25786009)(59896002)(3846002)(6116002)(71200400001)(71190400001)(33656002)(2906002)(5660300001)(64126003)(107886003)(6246003)(52116002)(99286004)(386003)(6436002)(4326008)(68736007)(65816011)(102836004)(256004)(53546011)(6506007)(76176011)(229853002)(87266011);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR11MB0106;H:DM2PR11MB0255.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: DfFYlyVYIv+Zs1rCZGcaucN1WSMUjde9U8TKSIF6sQn9dXEkYOCADJh9vOH9C6VM1Bdd1SKob5KeW+Z89osXVwJDQm6h/PhWIvRr5jZjSacoBJrCXtXrPjwCAFSi9aEcnheD5LhdDdplJORhYyjUIzHTSDSh+rOgUn2MwErFE3q6CTyByW6IWCy6A31cgsgxMYfgUEkJByaA+1yU9C9T0gqA21XgCMG/9YUCNSGpjQ1qh8SA3LOUPBVoLOOMpsLDrMfUe07WA4t7boT1TqCZbVexAr17KcK9t/lzgbu1uCi7Yv8mBSSeC2Ie2cFicVQhZAj0jpcJybQxh9KdmCmZty3hYR7e2o3PVCGqyIljRLo=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <5155932E07C4C34E87FF4F302E1F759F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d2af28b-2b41-40f4-da37-08d6308d6744
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2018 21:55:20.7326
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM2PR11MB0106
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

DQoNCk9uIDEwLzEwLzIwMTggMDE6MTQgUE0sIEpvaGFubmVzIEJlcmcgd3JvdGU6DQo+IExvb2tp
bmcgYXQgYWxsIHRoaXMgd2lkX2xpc3Qgc3R1ZmYgYWdhaW4sDQo+IA0KPj4gKwl3aWRfbGlzdFt3
aWRfY250XS5pZCA9IFdJRF9TVUNDRVNTX0ZSQU1FX0NPVU5UOw0KPj4gKwl3aWRfbGlzdFt3aWRf
Y250XS50eXBlID0gV0lEX0lOVDsNCj4+ICsJd2lkX2xpc3Rbd2lkX2NudF0uc2l6ZSA9IHNpemVv
Zih1MzIpOw0KPj4gKwl3aWRfbGlzdFt3aWRfY250XS52YWwgPSAoczggKikoJihkdW1teXZhbCkp
Ow0KPj4gKwl3aWRfY250Kys7DQo+IA0KPiBEb2Vzbid0IHRoYXQgaGF2ZSBlbmRpYW4gaXNzdWVz
Pw0KPiANCj4+ICsJd2lkX2xpc3Rbd2lkX2NudF0uaWQgPSBXSURfUkVDRUlWRURfRlJBR01FTlRf
Q09VTlQ7DQo+PiArCXdpZF9saXN0W3dpZF9jbnRdLnR5cGUgPSBXSURfSU5UOw0KPj4gKwl3aWRf
bGlzdFt3aWRfY250XS5zaXplID0gc2l6ZW9mKHUzMik7DQo+PiArCXdpZF9saXN0W3dpZF9jbnRd
LnZhbCA9IChzOCAqKSgmKGR1bW15dmFsKSk7DQo+PiArCXdpZF9jbnQrKzsNCj4gDQo+IEJ1dCBJ
J20gbm90IHJlYWxseSBzdXJlIHdoYXQgdGhlIHBvaW50ZXIgZG9lcywgdGJoLg0KDQpIZXJlIHRo
ZSBkcml2ZXIgaXMgY29uZmlndXJpbmcgcGFyYW1ldGVycyBpbiB0aGUgZGV2aWNlIGJ5IHNlbmRp
bmcgYSBXSUQgY29tbWFuZCBmb3IgZWFjaCBwYXJhbWV0ZXJzLg0KVGhlIHZhbCBwb2ludGVyIHBv
aW50cyB0byB0aGUgdmFsdWUgb2YgdGhlIHBhcmFtZXRlciB0byBiZSBzZXQsIGFuZCBoZXJlIGFs
bCBwYXJhbWV0ZXJzIGJlaW5nIHNldCB0byAwIHdlcmUgc2hhcmluZyB0aGUgZHVtbXl2YWwgdmFy
aWFibGUuDQpMb29raW5nIGFnYWluIGF0IHRoaXMsIHRoZXNlIGNvbnN0YW50IHBhcmFtZXRlcnMg
Y2FuIGJlIG9taXR0ZWQgZnJvbSB0aGUgZHJpdmVyIGFuZCBkb25lIG9uIHRoZSBkZXZpY2UgaW5z
dGVhZC4NCg0KPiANCj4+ICsJd2lkX2xpc3Rbd2lkX2NudF0uaWQgPSBXSURfSk9JTl9SRVFfRVhU
RU5ERUQ7DQo+PiArCXdpZF9saXN0W3dpZF9jbnRdLnR5cGUgPSBXSURfU1RSOw0KPj4gKwl3aWRf
bGlzdFt3aWRfY250XS5zaXplID0gMTEyOw0KPj4gKwl3aWRfbGlzdFt3aWRfY250XS52YWwgPSBr
bWFsbG9jKHdpZF9saXN0W3dpZF9jbnRdLnNpemUsIEdGUF9LRVJORUwpOw0KPiANCj4gSSB0aGlu
ayB5b3Ugc2hvdWxkIGRlY2xhcmUgYSBzdHJ1Y3R1cmUgZm9yIHRoZXNlIDExMiBieXRlcywgY2xl
YXJseSBpdCdzDQo+IHNvbWV0aGluZyBsaWtlDQo+IA0KPj4gKwlpZiAoY29ubl9hdHRyLT5zc2lk
KSB7DQo+PiArCQltZW1jcHkoY3VyX2J5dGUsIGNvbm5fYXR0ci0+c3NpZCwgY29ubl9hdHRyLT5z
c2lkX2xlbik7DQo+PiArCQljdXJfYnl0ZVtjb25uX2F0dHItPnNzaWRfbGVuXSA9ICdcMCc7DQo+
PiArCX0NCj4+ICsJY3VyX2J5dGUgKz0gTUFYX1NTSURfTEVOOw0KPiANCj4gdTggc3NpZFszMl07
DQo+IA0KPj4gKwkqKGN1cl9ieXRlKyspID0gSU5GUkFTVFJVQ1RVUkU7DQo+IA0KPiB1OCB0eXBl
Ow0KPiANCj4+ICsNCj4+ICsJaWYgKGNvbm5fYXR0ci0+Y2ggPj0gMSAmJiBjb25uX2F0dHItPmNo
IDw9IDE0KSB7DQo+PiArCQkqKGN1cl9ieXRlKyspID0gY29ubl9hdHRyLT5jaDsNCj4+ICsJfSBl
bHNlIHsNCj4+ICsJCW5ldGRldl9lcnIodmlmLT5uZGV2LCAiQ2hhbm5lbCBvdXQgb2YgcmFuZ2Vc
biIpOw0KPj4gKwkJKihjdXJfYnl0ZSsrKSA9IDB4RkY7DQo+PiArCX0NCj4gDQo+IHU4IGNoYW5u
ZWw7DQo+IA0KPj4gKwkqKGN1cl9ieXRlKyspICA9IChic3NfcGFyYW0tPmNhcF9pbmZvKSAmIDB4
RkY7DQo+PiArCSooY3VyX2J5dGUrKykgID0gKChic3NfcGFyYW0tPmNhcF9pbmZvKSA+PiA4KSAm
IDB4RkY7DQo+IA0KPiBfX2xlMTYgY2FwX2luZm87DQo+IA0KPj4gKwlpZiAoY29ubl9hdHRyLT5i
c3NpZCkNCj4+ICsJCW1lbWNweShjdXJfYnl0ZSwgY29ubl9hdHRyLT5ic3NpZCwgNik7DQo+PiAr
CWN1cl9ieXRlICs9IDY7DQo+IA0KPiB1OCBic3NpZFtFVEhfQUxFTl07DQo+IA0KPj4gKwlpZiAo
Y29ubl9hdHRyLT5ic3NpZCkNCj4+ICsJCW1lbWNweShjdXJfYnl0ZSwgY29ubl9hdHRyLT5ic3Np
ZCwgNik7DQo+PiArCWN1cl9ieXRlICs9IDY7DQo+IA0KPiBhZ2Fpbj8NCg0KQWdyZWUuIENhbiBi
ZSBjaGFuZ2VkIHRvIGF2b2lkIGR1cGxpY2F0aW9uLiBSZXF1aXJlcyBhIG1hdGNoaW5nIGNoYW5n
ZSBvbiB0aGUgZGV2aWNlLg0KDQo+IA0KPj4gKwkqKGN1cl9ieXRlKyspICA9IChic3NfcGFyYW0t
PmJlYWNvbl9wZXJpb2QpICYgMHhGRjsNCj4+ICsJKihjdXJfYnl0ZSsrKSAgPSAoKGJzc19wYXJh
bS0+YmVhY29uX3BlcmlvZCkgPj4gOCkgJiAweEZGOw0KPiANCj4gX19sZTE2IGJlYWNvbl9wZXJp
b2Q7DQo+IA0KPj4gKwkqKGN1cl9ieXRlKyspICA9ICBic3NfcGFyYW0tPmR0aW1fcGVyaW9kOw0K
PiANCj4gdTggZHRpbV9wZXJpb2Q7DQo+IA0KPiBldGMuDQo+IA0KPiBEZWNsYXJpbmcgaXQgYXMg
YSBzdHJ1Y3QgYWxzbyBtZWFucyB5b3UgZG9uJ3QgaGF2ZSB0byBkbyBhbGwgdGhlDQo+IHB1dF9s
ZTE2X3VuYWxpZ25lZCgpIG9yIHdoYXRldmVyLCBidXQgY2FuIGp1c3QgZmlsbCB0aGUgc3RydWN0
IHByb3Blcmx5Lg0KPiANCg0KQWdyZWUuIFRoZSBpZGVhIHdhcyBvZiBwYWNraW5nIHRoZSBwYXJh
bWV0ZXJzIG1hbnVhbGx5IHdhcyB0byBhdm9pZCBzdHJ1Y3QgcGFkZGluZyBpc3N1ZXMsIGJ1dCBJ
IGNhbiBkZWNsYXJlIHRoZSBzdHJ1Y3QgYXMgcGFja2VkIGluc3RlYWQNCiANClRoYW5rcywNCkFk
aGFtDQo=
