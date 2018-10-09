Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCE95C64EAD
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 04:23:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40FEE213A2
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 04:23:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="1jPwuK1Q"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 40FEE213A2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725887AbeJILil (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Oct 2018 07:38:41 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:35600 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725803AbeJILik (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Oct 2018 07:38:40 -0400
X-IronPort-AV: E=Sophos;i="5.54,359,1534834800"; 
   d="scan'208";a="20927576"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 08 Oct 2018 21:23:42 -0700
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.49) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Mon, 8 Oct 2018 21:23:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lnTotBCl131NI/5JvR/fu1Ie93A15xM6oHqGVJFnHjI=;
 b=1jPwuK1QETtNdlFs7zKIHHRA66VCjF4Cpx5j+ZmqlFXHYORhCFZnHD7Gj7VxfI6vo01wyY8KzuI5ZvsxLTPF7D/zh053H7+roH9H/5u/m0lbr2En/oAXGQ41T2jesNvEYjI82Fgz996Wq0FkwdF61rsbgWSKmBn6OlGre/2XQuM=
Received: from DM2PR11MB0255.namprd11.prod.outlook.com (10.160.135.27) by
 DM2PR11MB0059.namprd11.prod.outlook.com (10.160.28.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1164.25; Tue, 9 Oct 2018 04:23:40 +0000
Received: from DM2PR11MB0255.namprd11.prod.outlook.com
 ([fe80::c495:fe35:c61f:f850]) by DM2PR11MB0255.namprd11.prod.outlook.com
 ([fe80::c495:fe35:c61f:f850%3]) with mapi id 15.20.1207.024; Tue, 9 Oct 2018
 04:23:40 +0000
From:   <Adham.Abozaeid@microchip.com>
To:     <johannes@sipsolutions.net>, <Ajay.Kathat@microchip.com>,
        <linux-wireless@vger.kernel.org>
CC:     <kvalo@codeaurora.org>, <gregkh@linuxfoundation.org>,
        <Ganesh.Krishna@microchip.com>, <Aditya.Shankar@microchip.com>,
        <Venkateswara.Kaja@microchip.com>, <Claudiu.Beznea@microchip.com>
Subject: Re: [PATCH 12/19] wilc: add wilc_wfi_cfgoperations.c
Thread-Topic: [PATCH 12/19] wilc: add wilc_wfi_cfgoperations.c
Thread-Index: AQHUVYNjmo/tPFE0lEmad1H8ViJjG6UVg8bJgADg4gA=
Date:   Tue, 9 Oct 2018 04:23:40 +0000
Message-ID: <5BBC2D46.1060903@microchip.com>
References: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
         <1537957525-11467-13-git-send-email-ajay.kathat@microchip.com>
         (sfid-20180926_122625_015616_502D99E2)
 <1539010630.3687.86.camel@sipsolutions.net>
In-Reply-To: <1539010630.3687.86.camel@sipsolutions.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.175.253.81]
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
x-clientproxiedby: DM5PR20CA0008.namprd20.prod.outlook.com
 (2603:10b6:3:93::18) To DM2PR11MB0255.namprd11.prod.outlook.com
 (2a01:111:e400:3c24::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Adham.Abozaeid@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM2PR11MB0059;6:dLYZBY+N5bntgXtrFgdplaZ/NChqi2P1sguBRfMk4WtiJtmFbgGKop292ldhOLDCWjwSdQXZmNOYyXbr0mI/8YgFYE2GstVa/KRfybhn64XmNVTRY/oVxOWpWSeYLV/OvHPCemCHhop1aolY0dbc9a0dwX8YU9E8FhspeK3vu1CvIXgfH1r4qnQ2y+U9k7QU9rm4B6dAGh0jlAzK48Pq3IkkGoVTrLotY9f8QH4KIfhcs9ifpN+FNK4l8QdbKAHPc9sXueUgDcdHhkYCKOyr/HPTADpR/OnZgTX9SgunXiSI4UF3C8cSyOW7AeHP/09vzTaGY3r4GBfuJUp1ZJBKfs6JlMrrfg3XeQts25vBGm0xYUDTzwbedpWL4Na+CXBfQUNhn0bkMeAXdQ76JW7bJ5XxZJLEk+pJT+n+24gNGJfVgT08ATFN/cXuzIpGhQFxbxL+Vu80ipecCLmfOa1G8w==;5:BtHoxu/mk/uhvv9/b2oL7io0wL0aKE2+5Rxn5IOR5IrpR31addpn2TvuSHJjnE66gv/SXjmN1Hs0h7kR3MNCdvdJyIREh3tfM3DNWRG4bdNnnGzItmOwjkZVIvECPMqhOEiZ4m9gnouEV0PTkMyytnVTskfNSve4KD1TJMJ1tGA=;7:v6OgzPuhsy2e4l44epYT+4MXAdr8fLwRQ96Y7+ZXBvcecIR3HrTutz4MDeKa2DjFazfy98NbRviGrwS3LWZ7vDDW6kG/g2anhXEPDTgLiCjB/7TbXM4gy1+o1hI0jMAMsLiiqF6b98HA/iX9m7RySUx5Xsb0xPVSIkEZYm51+H12v/zqYWVg/GJrpxOD/bLCOjWaxinA6O4zsubDGYUA1XciOQOm9dRelRug0gyetc7VkBqk1xEARRYIvl+AVg96
x-ms-office365-filtering-correlation-id: 9730093c-6fe8-433e-add7-08d62d9efbde
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:DM2PR11MB0059;
x-ms-traffictypediagnostic: DM2PR11MB0059:
x-microsoft-antispam-prvs: <DM2PR11MB00599253A4FCF42957E507238DE70@DM2PR11MB0059.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3231355)(944501410)(52105095)(3002001)(93006095)(93001095)(10201501046)(149066)(150057)(6041310)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(20161123562045)(20161123560045)(201708071742011)(7699051)(76991055);SRVR:DM2PR11MB0059;BCL:0;PCL:0;RULEID:;SRVR:DM2PR11MB0059;
x-forefront-prvs: 08200063E9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(366004)(39860400002)(136003)(396003)(376002)(52314003)(189003)(199004)(105586002)(53546011)(26005)(386003)(106356001)(316002)(6486002)(256004)(53936002)(97736004)(2906002)(305945005)(33656002)(6436002)(6116002)(3846002)(8676002)(8936002)(6506007)(102836004)(81156014)(81166006)(7736002)(186003)(476003)(2900100001)(65956001)(71190400001)(4326008)(36756003)(107886003)(80316001)(229853002)(52116002)(5660300001)(11346002)(25786009)(2616005)(6512007)(87266011)(54906003)(110136005)(2501003)(6246003)(71200400001)(58126008)(14454004)(72206003)(76176011)(486006)(99286004)(86362001)(68736007)(64126003)(478600001)(65816011)(66066001)(5250100002)(446003)(59896002)(65806001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR11MB0059;H:DM2PR11MB0255.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: ILE71a1f9akPF/YwFf8kgw+Yj/Dakku/gzmPLkiFrhr57j8Jz462Iq3/vvfZ/cMQBCQ0RR96ojRbSTRddzJP2DHKPlDF+looUC09Eg8NdFyCr738w0i6SvOhadnobhDTQ3sPN0C2nuy/I0jM4stn6DJbVPogBntsM0xHVq1kYtNHdoEnEl2vjC0xZEMwr9aNYI79Vopq2KGlDQober7b1VflMUxkStixmu5/1e8nJCDcZIZ76EAYBGZngaUkTH2RvlTj9lmZe/nxlBhACwkf8p7yQ0GnUWPHMAd8wqqoo6diX34wc8fHDql4twsK7p8CeaU81nTD+ah0nz85tbq4JNSa/+u2Xf421+sCzCYPWdU=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <EFB259B4FDAEF3429BA68D3D2DB392C2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9730093c-6fe8-433e-add7-08d62d9efbde
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2018 04:23:40.0649
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM2PR11MB0059
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

DQoNCk9uIDEwLzA4LzIwMTggMDc6NTcgQU0sIEpvaGFubmVzIEJlcmcgd3JvdGU6DQo+IE9uIFdl
ZCwgMjAxOC0wOS0yNiBhdCAxNTo1NSArMDUzMCwgQWpheSBTaW5naCB3cm90ZToNCj4+DQo+PiAr
c3RhdGljIHZvaWQgY2xlYXJfc2hhZG93X3NjYW4oc3RydWN0IHdpbGNfcHJpdiAqcHJpdikNCj4+
ICt7DQo+PiArCWludCBpOw0KPj4gKw0KPj4gKwlmb3IgKGkgPSAwOyBpIDwgcHJpdi0+c2Nhbm5l
ZF9jbnQ7IGkrKykgew0KPj4gKwkJa2ZyZWUocHJpdi0+c2Nhbm5lZF9zaGFkb3dbaV0uaWVzKTsN
Cj4+ICsJCXByaXYtPnNjYW5uZWRfc2hhZG93W2ldLmllcyA9IE5VTEw7DQo+PiArDQo+PiArCQlr
ZnJlZShwcml2LT5zY2FubmVkX3NoYWRvd1tpXS5qb2luX3BhcmFtcyk7DQo+PiArCQlwcml2LT5z
Y2FubmVkX3NoYWRvd1tpXS5qb2luX3BhcmFtcyA9IE5VTEw7DQo+PiArCX0NCj4+ICsJcHJpdi0+
c2Nhbm5lZF9jbnQgPSAwOw0KPj4gK30NCj4gDQo+IFRoaXMgc2VlbXMgdW5saWtlbHkgdG8gYmUg
YSBnb29kIGlkZWEgLSB3aHkga2VlcCB0aGluZ3MgYXJvdW5kIGluIHRoZQ0KPiBkcml2ZXI/DQo+
IA0KPiANCj4+ICtzdGF0aWMgdm9pZCByZWZyZXNoX3NjYW4oc3RydWN0IHdpbGNfcHJpdiAqcHJp
diwgYm9vbCBkaXJlY3Rfc2NhbikNCj4+ICt7DQo+PiArCXN0cnVjdCB3aXBoeSAqd2lwaHkgPSBw
cml2LT5kZXYtPmllZWU4MDIxMV9wdHItPndpcGh5Ow0KPj4gKwlpbnQgaTsNCj4+ICsNCj4+ICsJ
Zm9yIChpID0gMDsgaSA8IHByaXYtPnNjYW5uZWRfY250OyBpKyspIHsNCj4+ICsJCXN0cnVjdCBu
ZXR3b3JrX2luZm8gKm5ldHdvcmtfaW5mbzsNCj4+ICsJCXMzMiBmcmVxOw0KPj4gKwkJc3RydWN0
IGllZWU4MDIxMV9jaGFubmVsICpjaGFubmVsOw0KPj4gKwkJaW50IHJzc2k7DQo+PiArCQlzdHJ1
Y3QgY2ZnODAyMTFfYnNzICpic3M7DQo+PiArDQo+PiArCQluZXR3b3JrX2luZm8gPSAmcHJpdi0+
c2Nhbm5lZF9zaGFkb3dbaV07DQo+PiArDQo+PiArCQlpZiAoIW1lbWNtcCgiRElSRUNULSIsIG5l
dHdvcmtfaW5mby0+c3NpZCwgNykgJiYgIWRpcmVjdF9zY2FuKQ0KPj4gKwkJCWNvbnRpbnVlOw0K
PiANCj4gRXJyLCBubz8gRG9uJ3QgZG8gdGhhdD8gV2hhdCdzIHRoZSBwb2ludD8NCj4gDQo+IEkg
ZG9uJ3Qga25vdyB3aGF0IHlvdSBuZWVkIHRoZSBzaGFkb3cgc3R1ZmYgZm9yLCBidXQgeW91IHNo
b3VsZCByZW1vdmUNCj4gaXQgYW55d2F5LCBhbmQgdXNlIHRoZSBjZmc4MDIxMSBmdW5jdGlvbmFs
aXR5IGluc3RlYWQuIElmIG5vdA0KPiBzdWZmaWNpZW50LCBwcm9wb3NlIHBhdGNoZXMgdG8gaW1w
cm92ZSBpdD8NCg0KVGhlIHBvaW50IGJlaGluZCB1c2luZyBhIHNoYWRvdyBidWZmZXIgd2FzIHRv
IGtlZXAgdGhlIHNjYW4gcmVzdWx0cyBjb25zaXN0ZW50IGJldHdlZW4gY29uc2VjdXRpdmUgc2Nh
bnMsIGFuZCBzbW9vdGggb3V0IHRoZSBjYXNlcyB3aGVyZSBhbiBBUCBpc24ndCBmb3VuZCBtb21l
bnRhcmlseSBkdXJpbmcgc2Nhbm5pbmcuDQpJbiB0aGlzIGltcGxlbWVudGF0aW9uLCBBUHMgZm91
bmQgZHVyaW5nIHNjYW5uaW5nIGFyZSBhZGRlZCB0byB0aGUgc2hhZG93IGxpc3QsIGFuZCByZW1v
dmVkIGlmIG5vdCBmb3VuZCBhZ2FpbiBmb3IgYSBwZXJpb2Qgb2YgdGltZS4NCg0KSSdtIG5vdCBt
dWNoIGluIGZhdm91ciBvZiB0aGlzIGltcGxlbWVudGF0aW9uIG5laXRoZXIgc2luY2UgaXQgY29t
cGxpY2F0ZXMgdGhlIGRyaXZlcidzIGxvZ2ljLCBidXQgaXQgd2FzIHNlcnZpbmcgdGhlIHB1cnBv
c2UuDQoNCj4gDQo+PiArCQkJaWYgKG1lbWNtcCgiRElSRUNULSIsIG5ldHdvcmtfaW5mby0+c3Np
ZCwgNykpDQo+PiArCQkJCXJldHVybjsNCj4gDQo+IHNhbWUgaGVyZQ0KPiANCj4gDQo+IGpvaGFu
bmVzDQo+IA0KDQpUaGFua3MsDQpBZGhhbQ0K
