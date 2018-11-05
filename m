Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92C5CC0044C
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 04:42:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A1B520685
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 04:42:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="B0BbnNLG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4A1B520685
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbeKEOAd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 09:00:33 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:50740 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728165AbeKEOAd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 09:00:33 -0500
X-IronPort-AV: E=Sophos;i="5.54,466,1534834800"; 
   d="scan'208";a="22655283"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 04 Nov 2018 21:42:50 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.107) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sun, 4 Nov 2018 21:42:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k/i+6tNeXJc7xXb0o0RSwlBAHuAyOJEET1P84FCOSiE=;
 b=B0BbnNLGZKvdjjhwpMWvPhQ3eUBwUE0pIHSqAkTQBkCqSmQCIuwOoTSLtHPLKzEDwBY9mIhCx3vLbIARJ+05wsbMCAFFsjj5QOhXDSA+0paNN6SDdpXJ+W1k8Jw1VVxoBTutJfGxW7WWrhqpx6Ofk0Lfafvjs08+XMAnHdARgWY=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3304.namprd11.prod.outlook.com (20.177.185.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.26; Mon, 5 Nov 2018 04:42:46 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7%6]) with mapi id 15.20.1294.032; Mon, 5 Nov 2018
 04:42:46 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <joe@perches.com>, <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Ganesh.Krishna@microchip.com>, <Aditya.Shankar@microchip.com>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>
Subject: Re: [PATCH 4/8] staging: wilc1000: avoid line over 80 chars in
 wilc_parse_network_info()
Thread-Topic: [PATCH 4/8] staging: wilc1000: avoid line over 80 chars in
 wilc_parse_network_info()
Thread-Index: AQHUcgJD9vPPwH1+N0OaOZ3PcNN1IqVAAiiAgACdwwA=
Date:   Mon, 5 Nov 2018 04:42:46 +0000
Message-ID: <aa0f308c-fae0-15bd-0c44-b7ec4b095473@microchip.com>
References: <1541090691-31928-1-git-send-email-ajay.kathat@microchip.com>
 <1541090691-31928-5-git-send-email-ajay.kathat@microchip.com>
 <27e0dadbbe17f440aceb093fda31cf669f5e0a51.camel@perches.com>
In-Reply-To: <27e0dadbbe17f440aceb093fda31cf669f5e0a51.camel@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MAXPR0101CA0034.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:d::20) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [49.205.216.87]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3304;6:nsOFadZq/9jNW/sz2rnyE9J2+UcD5UEnia53tpZaJ+nRgwoDTpCwHBm0k84ZCH898HjTrA+0wS9pB7b7msHBYQUjGhwjibGUNaqoabkGZnnORpADJjp+YSOjWnvnRS+p9KO5IwRtgqW2tmW6dF49+aI+Ydle2eCy08ynd4VFF/z7tkiXW17Hgj1GS+i2LvSpkP4k4SLfIiIR9o+R5/tOl7KrItUPxUM3fpytmYOg72WdE3ZG/XDH7xZQGPM0Mqkcfo4FvSmO/OWHARPQ59N4/l5/+Mg9SxBNwEA0xbl9/C/wVdNoquiAk79ez4bScKzack3yaiimNvAitpPIRWv5ZaHkYwm3U0ro0uA/j03rEt4d9DX+QnJW105qjEfrMCa4dztrgjcgQN9bLnhixLl7SpT3ngmLhxHlZj4BimHDVSl3ZJoPVeEKMfxTtwAdPyUe1stijviddGGSG8YelSO/fw==;5:UNioYUuMmeO/KGBVe6vSTE0bDn+lhc0f6GkLqtrjvEiJqBV4GAAN8SctLOavP1uhjD+5ZzUq0JuwrHsSDVrc9A/aaKN9hUsJM7JT5H0p/67YtksJvur8s3RZE/3x9tbDgFY8wtdEWAdLm9J91Rb3NPvh0Go0P+5IGF6pLD7JN7g=;7:UUIeqcbyeKwJg77f0bWgj362kyC8aLWrPWmaFOZad3HH+JWf5Sl0a7vQB+0wAnyl4SwUtK5B0MQYlUZs22cm4pYfIBro/Th+NwVtcYolw+i8xL42KTESaZwfaZkajkzYWuuXztbUhjJoi/6UVSyhZw==
x-ms-office365-filtering-correlation-id: 8be40e07-a505-489c-4142-08d642d921d1
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3304;
x-ms-traffictypediagnostic: BYAPR11MB3304:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-microsoft-antispam-prvs: <BYAPR11MB3304958FB1E42C93D0B6E4CCE3CA0@BYAPR11MB3304.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(3231382)(944501410)(52105095)(93006095)(93001095)(10201501046)(3002001)(148016)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(20161123562045)(20161123564045)(20161123560045)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB3304;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB3304;
x-forefront-prvs: 08476BC6EF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(396003)(136003)(366004)(39860400002)(199004)(189003)(14454004)(11346002)(31696002)(316002)(110136005)(68736007)(54906003)(26005)(2616005)(6436002)(2501003)(97736004)(102836004)(476003)(486006)(78486014)(6486002)(229853002)(71190400001)(99286004)(5660300001)(256004)(71200400001)(186003)(86362001)(52116002)(305945005)(66066001)(106356001)(36756003)(72206003)(2900100001)(8936002)(446003)(76176011)(6246003)(7736002)(53936002)(4326008)(478600001)(25786009)(2906002)(81156014)(81166006)(6512007)(105586002)(386003)(6506007)(6116002)(53546011)(3846002)(31686004)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3304;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: y9Ow4phiBZ1rIDgxFdooAzBBKjN77hxT0YrSzPZQQuofEsF4NGh8NeL904dwiPIfDa3u528g+G3NjOB7Iyi0Uc6rEYPp4VrT/0gV4OpMHdGRkKskaTfjAjmNBwitixqgCoze/4bTEsGTcc1DC+QayKKrJT3pVnkGb75FWyRle1zyV9yvdkYPAOCMHYXKlpsro6wZ1W+8eJIU2kCFh/1vmTFy7c47/4Fbg/HmJnuVs4G0lkH28VP9BWk0yJsjmZ7SDwDtsi1Gw9JEO5PdRkEoFIhuRiW189Cl9a8U22sZK2QE5qeOODOobjlD9+j+zCOM3JNLfqPvr+9JVxvQLkFp+FIYXNQ4rkksajo0/qPMHb0=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <E2B23C782340BC469972B63C4E54E355@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8be40e07-a505-489c-4142-08d642d921d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2018 04:42:46.7195
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3304
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

SGkgSm9lLA0KDQpPbiAxMS81LzIwMTggMTI6NDcgQU0sIEpvZSBQZXJjaGVzIHdyb3RlOg0KPiBP
biBUaHUsIDIwMTgtMTEtMDEgYXQgMTY6NDUgKzAwMDAsIEFqYXkuS2F0aGF0QG1pY3JvY2hpcC5j
b20gd3JvdGU6DQo+PiBGcm9tOiBBamF5IFNpbmdoIDxhamF5LmthdGhhdEBtaWNyb2NoaXAuY29t
Pg0KPj4NCj4+IFVzZSBzaG9ydGVyIG5hbWUgZm9yICduZXR3b3JrX2luZm8nIHZhcmlhYmxlIHRv
IGF2b2lkIGxpbmUgb3ZlciA4MCBjaGFycw0KPj4gaXNzdWUuDQo+IFRoaXMgc2VlbXMgY29tcGxl
dGVseSB1bm5lY2Vzc2FyeSBhcyBwYXRjaCA3LzggYW5kIDgvOA0KPiByZW1vdmVzIHRoZSBmaWxl
Lg0KPg0KQXMgd2lsY19wYXJzZV9uZXR3b3JrX2luZm8oKSBpcyBtb3ZlZCB0byBhIGRpZmZlcmVu
dCBmaWxlIGluIHBhdGNoIzcuDQpTbyB0byBzZXBhcmF0ZSB0aGUgdmFyaWFibGUgbmFtZSBjaGFu
Z2VzIGZyb20gdGhlIGZ1bmN0aW9uIG1vdmVtZW50IEkNCmhhdmUgZGl2aWRlZCB0aGVtIGludG8g
MiBkaWZmZXJlbnQgcGF0Y2hlcy4NCg0KUmVnYXJkcywNCkFqYXkNCg0K
