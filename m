Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30AA6C64EB8
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 17:15:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3850214DA
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 17:15:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="hdoP9fxj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C3850214DA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbeJJAdp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Oct 2018 20:33:45 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:1522 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbeJJAdp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Oct 2018 20:33:45 -0400
X-IronPort-AV: E=Sophos;i="5.54,361,1534834800"; 
   d="scan'208";a="21409301"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES128-SHA; 09 Oct 2018 10:15:46 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.37) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Tue, 9 Oct 2018 10:15:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=guU2+XZZH9tU5roCFBWQBLS0wpprHxw9LiyWAwCiXso=;
 b=hdoP9fxj6DUEeyPPVESzSmED5vx6149jSfdEi3u6kqorohm9uWWKKXpGdHSr3QwB398+Z5T8HS7yOkz32i0yaTbbCiGINdHdPh0yNWgeRDuUq130swRXqnyrmDx2EEGF5McyC78t2t+2xIb5HRaUSC++hfKrDq8rRgRGugcnIHI=
Received: from DM2PR11MB0255.namprd11.prod.outlook.com (10.160.135.27) by
 DM2PR11MB0076.namprd11.prod.outlook.com (10.160.28.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.23; Tue, 9 Oct 2018 17:15:43 +0000
Received: from DM2PR11MB0255.namprd11.prod.outlook.com
 ([fe80::c495:fe35:c61f:f850]) by DM2PR11MB0255.namprd11.prod.outlook.com
 ([fe80::c495:fe35:c61f:f850%3]) with mapi id 15.20.1207.024; Tue, 9 Oct 2018
 17:15:43 +0000
From:   <Adham.Abozaeid@microchip.com>
To:     <johannes@sipsolutions.net>, <Ajay.Kathat@microchip.com>,
        <linux-wireless@vger.kernel.org>
CC:     <kvalo@codeaurora.org>, <gregkh@linuxfoundation.org>,
        <Ganesh.Krishna@microchip.com>, <Aditya.Shankar@microchip.com>,
        <Venkateswara.Kaja@microchip.com>, <Claudiu.Beznea@microchip.com>
Subject: Re: [PATCH 12/19] wilc: add wilc_wfi_cfgoperations.c
Thread-Topic: [PATCH 12/19] wilc: add wilc_wfi_cfgoperations.c
Thread-Index: AQHUVYNjmo/tPFE0lEmad1H8ViJjG6UVg8bJgADg4gCAADsvAIAAnIiA
Date:   Tue, 9 Oct 2018 17:15:42 +0000
Message-ID: <5BBCE23B.6050003@microchip.com>
References: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
         <1537957525-11467-13-git-send-email-ajay.kathat@microchip.com>
         (sfid-20180926_122625_015616_502D99E2)
 <1539010630.3687.86.camel@sipsolutions.net>
         <5BBC2D46.1060903@microchip.com>
 <1539071724.3687.87.camel@sipsolutions.net>
In-Reply-To: <1539071724.3687.87.camel@sipsolutions.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.175.253.81]
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
x-clientproxiedby: DM5PR20CA0020.namprd20.prod.outlook.com
 (2603:10b6:3:93::30) To DM2PR11MB0255.namprd11.prod.outlook.com
 (2a01:111:e400:3c24::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM2PR11MB0076;6:v07rOYxJRH1UCh6Iz+D0fc4nM22b99O5f51ReOo5fFXuJZs6CqIe27NabZ0xsdKjYVe8ot2ZvolikKZd+wHKNieMz5dasweVSTGpPgHnR/8VuzV6Z5hneuVcJ/17ywS/08j3ziAVF3ojeVRTT79N5KVbnnck4oDvkejHhhDDdhj3KM03ntu1SgZQmDCYNasDhpyMMRglSD5Tw2yL91ow8tgENFnUpCxvBUPiVPQ/8xJlgKwl7wbBPDWTUKw0g4R5FQo+1HWmmWf/pb1LLmRe/ZXb1TYK3G3/4vgyl0WB5rBi0JPQtud6adaSiGi16yptl8oo3GLKhOMqleVcdCBm1zCc2rQVdVYfIUDtqPrhfJNDOQH4kfkxNdN0JHsE5ePZemIjGl95rZvk2zj5VuLZ1hzSc+9T6yLrYfPCj9B+F3rJm08MyxDXf6ztULgH+eJRqGou2z9rJwDOzcwxBP49/Q==;5:eDWUFGPIafXlwWhxl4gmNHFL6HQum/ep2UaJjocibR+FO0fzGC1wJR1rKfjLjArUFJKGObD9FNgnn4SAPBo32Q3MPZCA2NR/0RHb70bTx3M37SSzcSBB1VRuY1kyYh6QNCWQ8kn2/7v9wCikfmTrlzBEhDZOO+QNllfHu8mrwqQ=;7:4lNQoxL+ce4Q2fNeQztSG6Fj8A5tScXgD3YLe1ba/IsCVMlQE5RKeoF7PcDuh1NUyoW/cs3j7Xkj6pWx7kfdxy/hnjTi4M71/7jglyOjy1Zkkdo74ccP+4BkqzwR7t04IFw94a9E+l8s3A+7HG96DqYPpdQBTuWBjW6YuR7M723i+rnDGzkoKwoqq7uiC8bityqDbjYCmDHNhftccNgBgi+fxIyEQHFRwvRjkkPEEQBcg7wja92vyBZKo9a2XG1S
x-ms-office365-filtering-correlation-id: 8076b8e1-2b2c-45d2-a234-08d62e0ad76d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:DM2PR11MB0076;
x-ms-traffictypediagnostic: DM2PR11MB0076:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Adham.Abozaeid@microchip.com; 
x-microsoft-antispam-prvs: <DM2PR11MB007610382F9C3DD7975AB2048DE70@DM2PR11MB0076.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3231355)(944501410)(52105095)(3002001)(93006095)(93001095)(10201501046)(149066)(150057)(6041310)(20161123560045)(20161123564045)(20161123562045)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991055);SRVR:DM2PR11MB0076;BCL:0;PCL:0;RULEID:;SRVR:DM2PR11MB0076;
x-forefront-prvs: 08200063E9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(346002)(136003)(366004)(396003)(199004)(189003)(52314003)(81156014)(71190400001)(476003)(86362001)(105586002)(106356001)(64126003)(54906003)(2906002)(14454004)(36756003)(6486002)(229853002)(97736004)(6436002)(14444005)(256004)(52116002)(102836004)(76176011)(87266011)(99286004)(26005)(186003)(65816011)(58126008)(71200400001)(486006)(80316001)(446003)(11346002)(2616005)(6512007)(7736002)(305945005)(33656002)(59896002)(93886005)(316002)(6246003)(53936002)(110136005)(2900100001)(5250100002)(107886003)(25786009)(4326008)(2501003)(478600001)(8936002)(6116002)(66066001)(68736007)(65956001)(65806001)(3846002)(53546011)(8676002)(5660300001)(6506007)(81166006)(72206003)(386003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR11MB0076;H:DM2PR11MB0255.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: inH5C0vvi/JzruZ9kVEsZ/6DNAnxqCH6QQjXBYiKLEm+H4q3/pgnfIt9sKH8KxCO8ISZdslDjXmTMRbYMEvMurYxh/OSTlzEVbn7cnfXXF+TqiGZrq/TNAkidrc0PV6StILfgaEH0ea0qKwJObEg34Cg8vs+5VsR8cDkjx0Hn1FwLAI2iPvK4AxFnIDUubiK7DZoIMCEZRS3m7O61n4pXAEnWrbxH7Kfk2GWJPUW2q0fkU0desRsqkO2UkB+ghTZCQ+euYjVGzrUaQhufsHBvQFKam/FLYQW+fDAGeWd8gv+Wj7ungr3EH3TnparNFW3tZBDPQVncR5iPVchDXoYNbbWP+qHbvfoED/sWDISI+8=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <1FBE5A70A0DB4144B57C01B98C84503A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8076b8e1-2b2c-45d2-a234-08d62e0ad76d
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2018 17:15:42.7768
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM2PR11MB0076
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

DQoNCk9uIDEwLzA5LzIwMTggMTI6NTUgQU0sIEpvaGFubmVzIEJlcmcgd3JvdGU6DQo+IE9uIFR1
ZSwgMjAxOC0xMC0wOSBhdCAwNDoyMyArMDAwMCwgQWRoYW0uQWJvemFlaWRAbWljcm9jaGlwLmNv
bSB3cm90ZToNCj4+DQo+Pj4gSSBkb24ndCBrbm93IHdoYXQgeW91IG5lZWQgdGhlIHNoYWRvdyBz
dHVmZiBmb3IsIGJ1dCB5b3Ugc2hvdWxkIHJlbW92ZQ0KPj4+IGl0IGFueXdheSwgYW5kIHVzZSB0
aGUgY2ZnODAyMTEgZnVuY3Rpb25hbGl0eSBpbnN0ZWFkLiBJZiBub3QNCj4+PiBzdWZmaWNpZW50
LCBwcm9wb3NlIHBhdGNoZXMgdG8gaW1wcm92ZSBpdD8NCj4+DQo+PiBUaGUgcG9pbnQgYmVoaW5k
IHVzaW5nIGEgc2hhZG93IGJ1ZmZlciB3YXMgdG8ga2VlcCB0aGUgc2NhbiByZXN1bHRzDQo+PiBj
b25zaXN0ZW50IGJldHdlZW4gY29uc2VjdXRpdmUgc2NhbnMsIGFuZCBzbW9vdGggb3V0IHRoZSBj
YXNlcyB3aGVyZQ0KPj4gYW4gQVAgaXNuJ3QgZm91bmQgbW9tZW50YXJpbHkgZHVyaW5nIHNjYW5u
aW5nLg0KPj4gSW4gdGhpcyBpbXBsZW1lbnRhdGlvbiwgQVBzIGZvdW5kIGR1cmluZyBzY2Fubmlu
ZyBhcmUgYWRkZWQgdG8gdGhlDQo+PiBzaGFkb3cgbGlzdCwgYW5kIHJlbW92ZWQgaWYgbm90IGZv
dW5kIGFnYWluIGZvciBhIHBlcmlvZCBvZiB0aW1lLg0KPj4NCj4+IEknbSBub3QgbXVjaCBpbiBm
YXZvdXIgb2YgdGhpcyBpbXBsZW1lbnRhdGlvbiBuZWl0aGVyIHNpbmNlIGl0DQo+PiBjb21wbGlj
YXRlcyB0aGUgZHJpdmVyJ3MgbG9naWMsIGJ1dCBpdCB3YXMgc2VydmluZyB0aGUgcHVycG9zZS4N
Cj4gDQo+IFlvdSByZWFsbHkgc2hvdWxkIHJlbW92ZSBpdCAtIGNmZzgwMjExICphbmQqIHdwYV9z
IGFscmVhZHkgZG8gdGhpcyBpZg0KPiByZXF1aXJlZC4NCj4gDQo+IGpvaGFubmVzDQo+IA0KDQpU
aGFua3MgSm9oYW5uZXMgZm9yIHRoZSB0aXAuIEkgZGlkIHNvbWUgcmVzZWFyY2gsIGFuZCBJIGJl
bGlldmUgeW91IGFyZQ0KcmVmZXJyaW5nIHRvIHVzaW5nIGJzc19leHBpcmVfYWdlIGFuZCBic3Nf
ZXhwaXJlX2NvdW50Lg0KV2UnbGwgZ28gYWhlYWQgYW5kIHJlbW92ZSB0aGF0Lg0KDQpUaGFua3Ms
DQpBZGhhbQ0K
