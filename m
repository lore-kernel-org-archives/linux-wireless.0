Return-Path: <SRS0=9n1M=OL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1281EC65BAE
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:03:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDC082080A
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:03:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="tXBfBpE7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CDC082080A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725830AbeLBSDh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 2 Dec 2018 13:03:37 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:39814 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbeLBSDh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Dec 2018 13:03:37 -0500
X-IronPort-AV: E=Sophos;i="5.56,307,1539673200"; 
   d="scan'208";a="24755026"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES128-SHA; 02 Dec 2018 11:03:35 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.37) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sun, 2 Dec 2018 11:03:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nVyokLjFi1f34+1ALmXatJtBvE3VVxuX+WRlVJJhmsE=;
 b=tXBfBpE7wRJa7XHn9tvCCm6qVOguw01mbcSrcvaR7gHr7NXD4Z1csK7++wHx/sWoCH92/f/UyxosKS0Add9heXdeM5cjpBFjtRiRkYFdWXByiXKlABj7rWrAHgbaku03zF1xBiBizc8bqKoZM1Qy0ULYIO4qaJkBX4eaGcPLKJw=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2806.namprd11.prod.outlook.com (52.135.228.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1382.18; Sun, 2 Dec 2018 18:03:20 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f%4]) with mapi id 15.20.1382.020; Sun, 2 Dec 2018
 18:03:20 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 23/29] staging: wilc1000: use correct 'struct remain_ch'
 variable in scan complete
Thread-Topic: [PATCH 23/29] staging: wilc1000: use correct 'struct remain_ch'
 variable in scan complete
Thread-Index: AQHUimlOjfJFSoedCkuc0JLcN5W2Pw==
Date:   Sun, 2 Dec 2018 18:03:20 +0000
Message-ID: <1543773663-20561-24-git-send-email-ajay.kathat@microchip.com>
References: <1543773663-20561-1-git-send-email-ajay.kathat@microchip.com>
In-Reply-To: <1543773663-20561-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MAXPR0101CA0063.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::25) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [183.82.18.98]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2806;6:WXMT4tpNE61yxk7xBj+RGmxxDNfMIvxdCISyeypu+8TIz7HX3hkHNr8feRr/b/EP/4OgcogEj0NDRJHfs2hm/HyersoHH9X8XfyurHmojJy2m5u8WiY4jJ2i/w+e9iubAqDUWgfeowfxnWHcY0QgYUry08/SVgfeYCP0wjvKZO4KTJGrtsrSHKt3iwFcZe95xK+Bk86e33SVuGTyKq/Kylww0oVeNLSiTfEFmT9lKv864x9/M6BpyoOxQ0VZPuVWBpDBa4Ie+Oxr+h1CnKJmyf082mPxeKbzNw0LNVEjDUl2nDOVmYYrTCxmeHoGaS8FH30D34kIq6PsOMR5jDVesQpQL8MWvEPg0hnewfCpXHTMFAkaQFGl/2kCIKPVjb7T9jz5iaYXgzgyq1+/AdEoypNbXerP3Bc4YQRp38qeWvetllyuhdx/o5x8Ppt2GrH30AfdnOhwMoDH0IJpAEeoyw==;5:qEWfwF3cfARaujdasK4Ed/mnCleaYVQz7gSvUkWc8DxsQwePtCrMvZoqY2c+tOqhXXTFcEBuNDVIHNFUA3T7yOFbjS4/CC3K1tZ9B7BC4+tQkVLtueAwZDnc4GV2MWJmac0X+rQXqeBt7cLDLGVgPBtLkhW4Ql2rxAz74EsgiFU=;7:CKy3RzJRoJ2hk4R7o0wzUFEUAX/3ZqhgdUQbOsevEQqJ4Fzc9IwecQvjBUuoZpfwKpcWQb3LjWhdvSpH3x9emlMAVEcz+kRu6vcwMEi4ybq9lfsGQ+yAgtxJM1M9fTRR8ZoGIXafYsW+YsJGPpGhVw==
x-ms-office365-filtering-correlation-id: 1a6190c9-0f86-4599-cb3a-08d658807121
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2806;
x-ms-traffictypediagnostic: BYAPR11MB2806:
x-microsoft-antispam-prvs: <BYAPR11MB2806079D9119911B3226B9B9E3AD0@BYAPR11MB2806.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3002001)(10201501046)(3231455)(999002)(944501491)(52105112)(148016)(149066)(150057)(6041310)(20161123562045)(20161123558120)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB2806;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB2806;
x-forefront-prvs: 087474FBFA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(366004)(39850400004)(396003)(136003)(199004)(189003)(186003)(4326008)(7736002)(26005)(14454004)(2906002)(107886003)(305945005)(386003)(53936002)(6506007)(36756003)(76176011)(6512007)(71190400001)(52116002)(71200400001)(5640700003)(14444005)(256004)(3846002)(6116002)(99286004)(5660300001)(78486014)(6486002)(446003)(11346002)(486006)(575784001)(86362001)(105586002)(8676002)(97736004)(68736007)(316002)(2616005)(6436002)(476003)(54906003)(66066001)(25786009)(102836004)(81156014)(81166006)(8936002)(72206003)(2351001)(2501003)(478600001)(6916009)(106356001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2806;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: zD5wXyQIUJl0c9mGpIwwEsJY9vJYWDax3bmM1FOH7T8y7RacZsUQ5R8gnrbli+f9LPBjpLeR/Vh7ui3P2k/LVLLpC1w4hntmJI6cx1ItUbthNdJFgU9x0i1NhY70VgqhRvTpjFRQjFwOPkJJ5EfBifSbVbeV/Efp8mxVb7k2f+4gkJplwL9vXDyE7dEaaxdE0pSogSLagu6gKQeDZolooSJnIY2EYh1smRJv+gS3/fg4RHsBU6l8FRCQUkXb/ZFKMBa3DogcNhEa/oYnbE0AFMXMsUSkFBQuNC98DiqA9xpuQKLgmKoXHzDtIjLOvoQsCx4VhvmNLet47ZtocrtDsCdKC3YWMclyhvRkZVQ1wRo=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a6190c9-0f86-4599-cb3a-08d658807121
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2018 18:03:20.1145
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2806
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Use the correct reference to remain_ch variable in scan complete.
Passing 'msg->body.remain_on_ch' to handle_remain_on_chan is not
correct. So used the correct reference used to store roc related
information during the scan.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index dc02561..9139e0e 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1613,7 +1613,8 @@ static void handle_scan_complete(struct work_struct *=
work)
 	handle_scan_done(msg->vif, SCAN_EVENT_DONE);
=20
 	if (msg->vif->hif_drv->remain_on_ch_pending)
-		handle_remain_on_chan(msg->vif, &msg->body.remain_on_ch);
+		handle_remain_on_chan(msg->vif,
+				      &msg->vif->hif_drv->remain_on_ch);
 	kfree(msg);
 }
=20
--=20
2.7.4

