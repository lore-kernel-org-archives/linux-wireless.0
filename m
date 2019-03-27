Return-Path: <SRS0=A7Z7=R6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CFDCC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 20:28:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D8EE20700
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 20:28:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="omu7UQ8Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727283AbfC0U2n (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Mar 2019 16:28:43 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:34350 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725841AbfC0U2n (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Mar 2019 16:28:43 -0400
X-IronPort-AV: E=Sophos;i="5.60,277,1549954800"; 
   d="scan'208";a="27133857"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 27 Mar 2019 13:28:43 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.107) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Wed, 27 Mar 2019 13:28:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IPjA9ixTX1VptHETtFMJFO3Ag+Cb23PPdVFn4D2lGzU=;
 b=omu7UQ8ZOZB3WAg/BC+V5KgDtcTTy1+wyT6bsUG+1tL3LTAKpsSAwmJpU6RKBNvWZ1cUZwda8nIdI1qJJGK7sj+J0oHmJC9nBexjNI0W3qMZr3hoGaxneFvTk0n8D+DMLUlt7hoL/JWgrthaGKX//TWtbVeZVAbsm+6al/3Irh0=
Received: from MWHPR11MB1373.namprd11.prod.outlook.com (10.169.234.7) by
 MWHPR11MB1711.namprd11.prod.outlook.com (10.169.235.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1750.15; Wed, 27 Mar 2019 20:28:34 +0000
Received: from MWHPR11MB1373.namprd11.prod.outlook.com
 ([fe80::583a:f4d8:147c:549]) by MWHPR11MB1373.namprd11.prod.outlook.com
 ([fe80::583a:f4d8:147c:549%4]) with mapi id 15.20.1730.019; Wed, 27 Mar 2019
 20:28:34 +0000
From:   <Adham.Abozaeid@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <johannes@sipsolutions.net>, <Ajay.Kathat@microchip.com>,
        <Adham.Abozaeid@microchip.com>
Subject: [PATCH] staging: wilc1000: assign scan result callback before
 starting the scan
Thread-Topic: [PATCH] staging: wilc1000: assign scan result callback before
 starting the scan
Thread-Index: AQHU5Numz5v6b7W4wka4UktQkIio3A==
Date:   Wed, 27 Mar 2019 20:28:34 +0000
Message-ID: <20190327202827.6791-1-adham.abozaeid@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.175.253.81]
x-clientproxiedby: BYAPR07CA0050.namprd07.prod.outlook.com
 (2603:10b6:a03:60::27) To MWHPR11MB1373.namprd11.prod.outlook.com
 (2603:10b6:300:24::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Adham.Abozaeid@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9e75780a-1da9-44de-43e0-08d6b2f2c8c0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:MWHPR11MB1711;
x-ms-traffictypediagnostic: MWHPR11MB1711:
x-microsoft-antispam-prvs: <MWHPR11MB1711F583DF7D93FB18798CA48D580@MWHPR11MB1711.namprd11.prod.outlook.com>
x-forefront-prvs: 0989A7979C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(396003)(366004)(136003)(376002)(346002)(189003)(199004)(1076003)(5660300002)(6486002)(6506007)(81156014)(26005)(7736002)(53936002)(386003)(68736007)(106356001)(86362001)(5640700003)(50226002)(97736004)(107886003)(52116002)(105586002)(6436002)(8936002)(81166006)(102836004)(8676002)(186003)(66066001)(72206003)(99286004)(4326008)(71190400001)(71200400001)(6512007)(3846002)(54906003)(14454004)(478600001)(256004)(6116002)(2906002)(25786009)(316002)(305945005)(36756003)(2501003)(6916009)(2616005)(476003)(486006)(2351001);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR11MB1711;H:MWHPR11MB1373.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: P3qfjIpHCRaEa2Dys0kC56hA/3rSAtXGhRRYYiw5y8yhJHwUAcoE36TU71A6cq0xufbphrypuElMkvo/CLSf58cD8llViGTwWUXCSsmSnptc0/suJJXbUE10FEogO/juyEmWIfNAJKYtcpmIsR4Jr5qF8i31Dw4kFgEOEept+T7UszV2uyzcQG3KEptw0V3GanMsv1bp7Ss1oYY4djEG8jDNxtfxsVmhjb6PjaFVYQmhYuutE7S3XToo+T5TYo75XUHxn+t3dVO9yPietevq/eNjrCuQOr82roiCqYGd+AZB/8SO4bQ3m4GyLf4sWDA+U3/sQd1hMQKtBdWohup6S6ADj3Uf5ntLzyzem9PDcDGQauhUSgZMmf1NEw07oGDTR5FES4CVwIRgeKEphvHrLtxpPPEKm5gHM7Ksi5qZ5gI=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e75780a-1da9-44de-43e0-08d6b2f2c8c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2019 20:28:34.2579
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1711
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Adham Abozaeid <adham.abozaeid@microchip.com>

When scan is triggered, sometimes scan results are received before the scan
result callback is assigned, causing the recieved results to be ignored.

Signed-off-by: Adham Abozaeid <adham.abozaeid@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index 91ea16a6ae2e..e1a35bb426f9 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -313,6 +313,9 @@ int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 =
scan_type,
 	wid_list[index].val =3D (s8 *)&scan_source;
 	index++;
=20
+	hif_drv->usr_scan_req.scan_result =3D scan_result_fn;
+	hif_drv->usr_scan_req.arg =3D user_arg;
+
 	result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, wid_list,
 				      index,
 				      wilc_get_vif_idx(vif));
@@ -321,8 +324,6 @@ int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 =
scan_type,
 		goto error;
 	}
=20
-	hif_drv->usr_scan_req.scan_result =3D scan_result_fn;
-	hif_drv->usr_scan_req.arg =3D user_arg;
 	hif_drv->scan_timer_vif =3D vif;
 	mod_timer(&hif_drv->scan_timer,
 		  jiffies + msecs_to_jiffies(WILC_HIF_SCAN_TIMEOUT_MS));
--=20
2.17.1

