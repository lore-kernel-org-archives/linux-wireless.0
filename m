Return-Path: <SRS0=pyzf=O5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63DB0C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 06:18:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24D8D20869
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 06:18:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="QE8LeNJp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730500AbeLTGSl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Dec 2018 01:18:41 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:4845 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726604AbeLTGSl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Dec 2018 01:18:41 -0500
X-IronPort-AV: E=Sophos;i="5.56,376,1539673200"; 
   d="scan'208";a="22509129"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 19 Dec 2018 23:18:41 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.107) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Wed, 19 Dec 2018 23:18:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gXh1uHh0i3MCj7G4bbRJbysQ/Y63hC22qMI74WsKwwM=;
 b=QE8LeNJp4bI+kfRWI7Wi5RchItmZKV3NvCvx87LjXfHJK480rg5tmQTWqASF9eWltWsktJxJLUf6WdWd1LtA5qCksEX70ov0OevEnvd9hDPW5A/gSIIrsFCOWXQkFTlCxgap8DcLOwAHNLElrw/l+FgA1r835Z6SiDAeYmjjWTY=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3334.namprd11.prod.outlook.com (20.177.185.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1425.19; Thu, 20 Dec 2018 06:18:37 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::2de1:50ef:4103:516b]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::2de1:50ef:4103:516b%2]) with mapi id 15.20.1425.025; Thu, 20 Dec 2018
 06:18:37 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <colin.king@canonical.com>, <Adham.Abozaeid@microchip.com>,
        <gregkh@linuxfoundation.org>, <linux-wireless@vger.kernel.org>,
        <devel@driverdev.osuosl.org>
CC:     <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: wilc1000: fix missing read_write setting when
 reading data
Thread-Topic: [PATCH] staging: wilc1000: fix missing read_write setting when
 reading data
Thread-Index: AQHUl7g/9r1F4tx1xkKJ/5VExv7rrKWHKDyA
Date:   Thu, 20 Dec 2018 06:18:37 +0000
Message-ID: <f385b84e-3724-cdaf-323c-7a9c9337b98b@microchip.com>
References: <20181219163007.5329-1-colin.king@canonical.com>
In-Reply-To: <20181219163007.5329-1-colin.king@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR01CA0119.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:35::13) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [27.59.115.204]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3334;6:/cRGmWWNPu/aHlN9eke1rB5ngKfB/WQMsFxj1aYESpTBfXLvVC4gJNZgU848xHU4ato1ui2mtJ5AjJj+3KFDNwnK0Bo9C+MgVVk9AUGOkpKTrBLLg/16DOL8/LfL4byrzuPBghRDHuCFVjw7bCEhIxUt4MxaaU9SsLKmqBTURzvAOO8qsAt5BckTZJZzw68bNWpoOresu6UES3tnO7DRObLjRV6OO8hHQTYJ0j0LqNpx3JNaXYrrBfGI4vdMM15dmQEx4saPGS0n3+MASUnJ4zpF9GQR/85y8qzJlJ8OR1y3dH9LUMi5SoN/DTO4t5XIRxJ7Llb+qzIGUEOvf0VHEbYFu5W8T9IBHcpo1xfAk2z95m04UsTuVAHmHzDEj9EhMpbKr+4sxXOfDAwHBJqHP0bI4DcviUItlmCIGXSYDr7Kq6JVH8VSSlh3XXpIK0ShFlWeeP3SxRLAEvffm/nMPw==;5:lXRoSzII6+mnjfYWEyh9v9WQaSIZ0qX05TzL2RlmqP11GGEq5DE6JW/mCRuKfc5271tOioIdqqK3zOJLG6ZgrjV/gbSDJqHEb9o2Y6i5s1tzIkoMGCizvOtATjB9akc6641MCDrKT1ZGTv7qX6VglWtdxbpHINQrA3cw6zNALXo=;7:Q3CmDvTJwkvEuW/lQ54UHNVZOgKlzjs9mo7u62Z1YxSLRcO7laegdqEWQadE3PccjiK1c3A2o6g3EsEVVeYkr+sYqiy49jfWzurdTI/rrz4aXk7AIihVWdCzm0u0PBmT+CYhBY40/qK8YeZEbFvs1A==
x-ms-office365-filtering-correlation-id: 783c884d-4187-4202-ee07-08d66642fa45
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3334;
x-ms-traffictypediagnostic: BYAPR11MB3334:
x-microsoft-antispam-prvs: <BYAPR11MB3334B115C0A8256F8B4AD5A2E3BF0@BYAPR11MB3334.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(3230021)(999002)(5005026)(6040522)(2401047)(8121501046)(3231475)(944501520)(52105112)(93006095)(93001095)(10201501046)(3002001)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(20161123562045)(20161123560045)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB3334;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB3334;
x-forefront-prvs: 0892FA9A88
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(396003)(366004)(136003)(39860400002)(199004)(189003)(53546011)(186003)(6506007)(478600001)(386003)(305945005)(102836004)(66066001)(54906003)(229853002)(2906002)(97736004)(4326008)(26005)(256004)(6246003)(7736002)(72206003)(6436002)(31686004)(2501003)(53936002)(76176011)(6116002)(3846002)(71200400001)(71190400001)(81156014)(6486002)(6512007)(8676002)(52116002)(14454004)(68736007)(36756003)(446003)(25786009)(99286004)(2201001)(5660300001)(110136005)(316002)(476003)(106356001)(486006)(8936002)(31696002)(2616005)(86362001)(11346002)(81166006)(105586002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3334;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: EdHYgfi4Qe1afUW1IKnqNh2vEh2lpYYfC6BxolN9xkNVfcA5mbRgNhX0syq55vP+P4HchOWCWvdjzQfC/QYD0GxG9xDNIQObhXstu7TbcVhkLd0jUI2yDDZR7jDoLayYUyX+8VE0zb8wDT5VCkvKEPEXdUBtLZ+Q8I5ZoZlyl0VdItCTdKUlEETXBQB6oT+fooSKp7PJ1LCDSGXcQqro78SSd1dQuHEeACWTpuLis8+H4oVKMoGVOnSoK46Q/khC+hh0hentBfpqRQzqEnvRgsXk637D6e5y/hkKbWor4SWxjhwUS5P0q3pBZCW7Xnly
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <D31BB210B716C04E8ECFCF4BD18316A0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 783c884d-4187-4202-ee07-08d66642fa45
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Dec 2018 06:18:37.4765
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3334
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

DQoNCk9uIDEyLzE5LzIwMTggMTA6MDAgUE0sIENvbGluIEtpbmcgd3JvdGU6DQo+IEZyb206IENv
bGluIElhbiBLaW5nIDxjb2xpbi5raW5nQGNhbm9uaWNhbC5jb20+DQo+IA0KPiBDdXJyZW50bHkg
dGhlIGNtZC5yZWFkX3dyaXRlIHNldHRpbmcgaXMgbm90IGluaXRpYWxpemVkIHNvIGl0IGNvbnRh
aW5zDQo+IGdhcmJhZ2UgZnJvbSB0aGUgc3RhY2suICBGaXggdGhpcyBieSBzZXR0aW5nIGl0IHRv
IDAgdG8gaW5kaWNhdGUgYQ0KPiByZWFkIGlzIHJlcXVpcmVkLg0KPiANCj4gRGV0ZWN0ZWQgYnkg
Q292ZXJpdHlTY2FuLCBDSUQjMTM1NzkyNSAoIlVuaW5pdGlhbGl6ZWQgc2NhbGFyIHZhcmlhYmxl
IikNCj4gDQo+IEZpeGVzOiBjNWM3N2JhMThlYTYgKCJzdGFnaW5nOiB3aWxjMTAwMDogQWRkIFNE
SU8vU1BJIDgwMi4xMSBkcml2ZXIiKQ0KDQpBY2tlZC1ieTogQWpheSBTaW5naCA8YWpheS5rYXRo
YXRAbWljcm9jaGlwLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogQ29saW4gSWFuIEtpbmcgPGNvbGlu
LmtpbmdAY2Fub25pY2FsLmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL3N0YWdpbmcvd2lsYzEwMDAv
d2lsY19zZGlvLmMgfCAxICsNCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKQ0KPiAN
Cj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93aWxjMTAwMC93aWxjX3NkaW8uYyBiL2Ry
aXZlcnMvc3RhZ2luZy93aWxjMTAwMC93aWxjX3NkaW8uYw0KPiBpbmRleCAyN2ZkZmJkZGE1YzAu
LmUyZjczOWZlZjIxYyAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dpbGMxMDAwL3dp
bGNfc2Rpby5jDQo+ICsrKyBiL2RyaXZlcnMvc3RhZ2luZy93aWxjMTAwMC93aWxjX3NkaW8uYw0K
PiBAQCAtODYxLDYgKzg2MSw3IEBAIHN0YXRpYyBpbnQgc2Rpb19yZWFkX2ludChzdHJ1Y3Qgd2ls
YyAqd2lsYywgdTMyICppbnRfc3RhdHVzKQ0KPiAgCWlmICghc2Rpb19wcml2LT5pcnFfZ3Bpbykg
ew0KPiAgCQlpbnQgaTsNCj4gIA0KPiArCQljbWQucmVhZF93cml0ZSA9IDA7DQo+ICAJCWNtZC5m
dW5jdGlvbiA9IDE7DQo+ICAJCWNtZC5hZGRyZXNzID0gMHgwNDsNCj4gIAkJY21kLmRhdGEgPSAw
Ow0KPiANCg==
