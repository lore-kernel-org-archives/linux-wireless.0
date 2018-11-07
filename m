Return-Path: <SRS0=0pA5=NS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FF0CC0044C
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Nov 2018 23:55:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2854F2077B
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Nov 2018 23:55:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="SzHrva6C"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2854F2077B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727810AbeKHJ2R (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Nov 2018 04:28:17 -0500
Received: from mail-eopbgr690085.outbound.protection.outlook.com ([40.107.69.85]:62433
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727591AbeKHJ2R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Nov 2018 04:28:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W116HvrE166/AJ6BuO1pYIv9jdkBDoH+NZlAA6B4D6g=;
 b=SzHrva6C1+0yOPKFCeANJ/fxft396NDzZGDDfrvePyib6NnZRYsg1arye/aftaNxPdACag5H9T1bZeIB49gsFVhn2NdmrEnZ5eLXimNS99eGcYQJsqbz/EGUwm80dV4z6c074Jl10ffaJcbQSGkCluuzUswzdyVzjjQoZAmo+dE=
Received: from MWHPR05MB3326.namprd05.prod.outlook.com (10.174.174.165) by
 MWHPR05MB3214.namprd05.prod.outlook.com (10.173.229.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.16; Wed, 7 Nov 2018 23:55:30 +0000
Received: from MWHPR05MB3326.namprd05.prod.outlook.com
 ([fe80::946e:2ae1:c8ec:d37a]) by MWHPR05MB3326.namprd05.prod.outlook.com
 ([fe80::946e:2ae1:c8ec:d37a%7]) with mapi id 15.20.1339.009; Wed, 7 Nov 2018
 23:55:30 +0000
From:   Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
To:     Tamizh chelvam <tamizhr@codeaurora.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/4] mac80211: Add api to support configuring TID specific
 configuration
Thread-Topic: [PATCH 3/4] mac80211: Add api to support configuring TID
 specific configuration
Thread-Index: AQHUajCPeKGkhYj8MEKxlUAfMbeIxKVFFlWA
Date:   Wed, 7 Nov 2018 23:55:29 +0000
Message-ID: <58a9731d-e7a7-282f-22f3-b697a93f7278@quantenna.com>
References: <1540230918-27712-1-git-send-email-tamizhr@codeaurora.org>
 <1540230918-27712-4-git-send-email-tamizhr@codeaurora.org>
In-Reply-To: <1540230918-27712-4-git-send-email-tamizhr@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR11CA0043.namprd11.prod.outlook.com
 (2603:10b6:a03:80::20) To MWHPR05MB3326.namprd05.prod.outlook.com
 (2603:10b6:301:3d::37)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=igor.mitsyanko.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [12.131.200.68]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;MWHPR05MB3214;6:1FfLXIOmsQX+3vXg9npnBRcFImaAjBqTgYR11+cCebpfffyXxW4FctGHP+xqQZQYDj8IAJk2kZ7GVCG5BIq06XsC3viht7TsA6tBmRNSF2x1MbUXtFzC67ALqwBH+SPoGIcMq6cOX+BLHxvolZDRsDXm5JJvpnTOG4nwZ9+OsCkGr5LOPOfq9j36t+IUd+b1Nj9yFUGb6dPRzwmaN6G0QTlm7hPnQ1yiATkE9AHs3SdqkaDP8VNa1f+qHou0Co2nGciexqPlSwSYsN1Ymxqz/pVMjOlLUo50SAfLz96A3OEdjqVvJeYBRzVT+exPalqRFy2KXkiHv0u38Bcnh8x9AbtIKLu+R7KcCHXCREcrOyYZMReelLbSa9rzwH7SWkWbO7VwIhFs9cjTJmjkh4tZrpBWJw71cUv4XjbAJfSRJtBmsEsumiLUnY1Wz6fLCm6km31MdJKr7mj6Kn7HAljIDw==;5:ElcUfHLjwitdVZCJcy64HnZBu+4IlEiKRUzec0c90Jqgs2JNvcSXxtc/l5zOHXrjasQzBAjdlLp0LRmUgciSIGM5Iuc4ubJe5iE4GLH9Qg90o6o9aRepcUWof2ezKErmjHHKtTQ2wgncosvLTPJoW7ub0M/A9IjA5QtAyITdG/I=;7:JmRZite/hPSD3eJ5W7wAdXpdCxJ4ZAvYAnHWXi1Z+VrOp9U6CS/H0iiH5XjnqHgAGRrxpw0rUsP1jB43sfOrcAwDT8XGaJXCHqJUJqXdsncAxXubASHvaBR/lFBdjyJ/YQJcFoFlfP4qgq68k9b7tQ==
x-ms-office365-filtering-correlation-id: aabd8a1d-5db7-4a14-eb39-08d6450c7f15
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:MWHPR05MB3214;
x-ms-traffictypediagnostic: MWHPR05MB3214:
x-microsoft-antispam-prvs: <MWHPR05MB321426CA65AD28BC5023DA81B0C40@MWHPR05MB3214.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3231382)(944501410)(52105095)(93006095)(93001095)(3002001)(10201501046)(148016)(149066)(150057)(6041310)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123560045)(20161123562045)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:MWHPR05MB3214;BCL:0;PCL:0;RULEID:;SRVR:MWHPR05MB3214;
x-forefront-prvs: 08497C3D99
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39850400004)(366004)(136003)(376002)(396003)(189003)(199004)(31686004)(478600001)(36756003)(53936002)(102836004)(7736002)(6246003)(81156014)(110136005)(81166006)(316002)(305945005)(53546011)(256004)(2501003)(31696002)(2906002)(71190400001)(106356001)(25786009)(6506007)(8936002)(386003)(2900100001)(2201001)(86362001)(6486002)(71200400001)(5660300001)(99286004)(66066001)(186003)(105586002)(8676002)(6512007)(4326008)(11346002)(14454004)(229853002)(6436002)(26005)(6116002)(476003)(52116002)(97736004)(2616005)(3846002)(486006)(446003)(68736007)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR05MB3214;H:MWHPR05MB3326.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: VPdrLR4JoFaJ4dzhIHEt0A1p8/MqM8SJCFld6hV+VNSUzIGoRLmGEseVzFPfGxupo77/mAPOaKZknDUF8u+ONQrNxXUhlCctgGErKKk8cjy8fYpH3rAP+Udqi7FXU/j4I8gkhRxm7F/KEgtXSJRz7Fl2ioiB87/8U2qyl3ujc//wehNP67yMGH00pm05tyeQjq/sHXQ7aTDbLYW/mhkHez80ktK1sCCWtym3zusHH4w9gOH1vSaXxGZHIXup7qlzC/eanzycrv0VzieQkKMvLqq5KNPBQGPXejBMpMitp8obn6eauigX8RqUMSQsXnOI1yw8sPy5HOUmI4bI0HLndPCE6CaosqOV8OpAi6Qa9E8=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <8809182432A5464CA38A4C0D3C79823E@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aabd8a1d-5db7-4a14-eb39-08d6450c7f15
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2018 23:55:29.8524
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR05MB3214
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

T24gMTAvMjIvMjAxOCAxMDo1NSBBTSwgVGFtaXpoIGNoZWx2YW0gd3JvdGU6DQo+ICAgLyoqDQo+
ICAgICogZW51bSBpZWVlODAyMTFfdmlmX2ZsYWdzIC0gdmlydHVhbCBpbnRlcmZhY2UgZmxhZ3MN
Cj4gICAgKg0KPiBAQCAtMTU2NSw2ICsxNTk0LDggQEAgc3RydWN0IGllZWU4MDIxMV92aWYgew0K
PiANCj4gICAgICAgICAgYm9vbCB0eHFzX3N0b3BwZWRbSUVFRTgwMjExX05VTV9BQ1NdOw0KPiAN
Cj4gKyAgICAgICBzdHJ1Y3QgaWVlZTgwMjExX3RpZF9jb25mIHRpZF9jb25mOw0KPiArDQoNCldo
eSBpcyB0aGVyZSBvbmx5IG9uZSBUSUQgY29uZmlnPyBJZiBpZWVlODAyMTFfdmlmOjp0aWRfY29u
ZiBtZW1iZXIgaXMgDQp1c2VkIG9ubHkgdG8gcGFzcyBkYXRhIHRvIGRyaXZlciB0aHJvdWdoIGRy
dl9zZXRfdGlkX2NvbmYoKSwgYW5kIGRyaXZlciANCndpbGwgc2F2ZSBpdCBmb3IgYSBzcGVjaWZp
YyBUSUQsIHdoeSBkbyB3ZSBuZWVkIHRvIHNhdmUgaXQgaW4gc3RydWN0IA0KaWVlZTgwMjExX3Zp
ZiB0b28/DQo=
