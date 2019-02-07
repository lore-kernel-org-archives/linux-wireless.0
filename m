Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70757C282C2
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 07:22:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 363E02075C
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 07:22:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="yrHWFWYz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726728AbfBGHWi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 02:22:38 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:10628 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbfBGHWi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 02:22:38 -0500
X-IronPort-AV: E=Sophos;i="5.58,342,1544511600"; 
   d="scan'208";a="23532154"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 07 Feb 2019 00:22:37 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.108) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 7 Feb 2019 00:22:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z+vHQ1mj2EjPsMFWZFfPFFsz1Y8ZB6ftnSsUBCBYybo=;
 b=yrHWFWYz+tpNQUmY0j9nE02/YwA1nxVvFDm6qljDpdhIF+bH0QVTyE1wECSMFGKzQBBjNQjCwpBXosTclF32z+fASCycdcK/P5jgR0bWYTb5aEhpi58kXcqB9gfEPn3DQBw9fSAE6hIchjFdsRvwh2qtnDK29mTTqLKHhmzXF/8=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3415.namprd11.prod.outlook.com (20.177.224.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.22; Thu, 7 Feb 2019 07:22:36 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1601.016; Thu, 7 Feb 2019
 07:22:36 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 5/9] staging: wilc1000: avoid function forward declaration in
 wilc_sdio.c file
Thread-Topic: [PATCH 5/9] staging: wilc1000: avoid function forward
 declaration in wilc_sdio.c file
Thread-Index: AQHUvrXm9D8ud1/Hi0y6Oh4SPfjteg==
Date:   Thu, 7 Feb 2019 07:22:36 +0000
Message-ID: <1549519927-2651-6-git-send-email-ajay.kathat@microchip.com>
References: <1549519927-2651-1-git-send-email-ajay.kathat@microchip.com>
In-Reply-To: <1549519927-2651-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MAXPR0101CA0020.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:c::30) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.7.4
x-originating-ip: [223.237.230.157]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3415;6:UiA2Qj8+w6NL9ci2klR4TbUSeUsYJ4TiHNvAbrmH41QuHKjSoEPbcuR8nMSpDfQm/+86IMeDuq088kmoui2hH9sM/ZxJi7yfjGCo1bEmYaYXkouyciKg8Skxz8oESA8BFoV7VLt93fo6LziDLpqJodZlxbLshB7tZFbn3Af/N7RO28yCEqCa6u+MFfkIpqsa4GUwAP8tTOqUWNUSdp/7wMWy1jWPaiC482ZPJjYjEh8klsj6ZM+K3vDMDfzDLFfnqZMeRdNE3W3/Tf6xiKVaz8jzzrSrSakR0ctLfzlyy5YDNLjlnhcincOLgNEAK52xl/N7zcQqdXUWAziZmwdkzGbJCDBob7pAvyRXn1/Pj2xGHp70RLkF+p/evGzoJtytxH5vsiEQa0pUQLeQ3hsXM7mN5SwERveSY5r6L39MM+GR+/5ChjaFCAlbGqyxUK9vS+wC+KjJAUKQITvBcp40pg==;5:w2R0Os+TgdTusToAC7VVnffqNnmE3ygLcACEXMyB9ub8hsMj+rNxQNQlLHgi5ivKmPO+xTfGub4X4lpEX25YbgKjHVrl7E2mrREOYT6fGn5zym9GWrprnPdYTW33ANjTMXifdzrHAlakGYYl5a/ghgdshPPgM3P4BG6y/PtAPbo8qczRNUv1eiYzuCVAsV0zLUu7yd/72HwG76ZPRt9EMA==;7:KaULiWkacVlPnXp4xbogw/cZ2q9ADiYqhm5D3DYiYRyD6rAVnEeD+bbInF8KmnuixqyvI6v3Tz9GR2NggcpZkbLvzOm0q1EMgk+VY5Wu3OzCxf2xAi/mUblb6yCFrL+is9ms0Pm/SQaKRhBl431lrQ==
x-ms-office365-filtering-correlation-id: 3ef257f4-0884-41d5-11bc-08d68ccd085e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3415;
x-ms-traffictypediagnostic: BYAPR11MB3415:
x-microsoft-antispam-prvs: <BYAPR11MB34154CBF603566C187E21F65E3680@BYAPR11MB3415.namprd11.prod.outlook.com>
x-forefront-prvs: 0941B96580
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39860400002)(136003)(366004)(396003)(376002)(189003)(199004)(86362001)(5640700003)(478600001)(6116002)(446003)(3846002)(72206003)(6486002)(11346002)(6436002)(25786009)(2351001)(2616005)(476003)(6512007)(105586002)(106356001)(486006)(26005)(6506007)(102836004)(386003)(36756003)(71190400001)(2501003)(97736004)(71200400001)(81156014)(305945005)(66066001)(54906003)(4326008)(186003)(68736007)(8936002)(81166006)(107886003)(52116002)(50226002)(53936002)(256004)(6916009)(14444005)(316002)(99286004)(14454004)(2906002)(76176011)(7736002)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3415;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: b1S8U5HdCdxppjnxk/we3VQaf9FOdfGvpSB/YSWSOF6jhUzWARgY7l3fDKfrPLuTOrPahWqjzNmUGYF0IdjraxnOrEx98dF0ks2HnzoZOpG1JssbQ0pz21tfXQXbvcN4f8PQHD/eBGKsgl21oM7RfB5coJOceO/TSFQBM+sDmGepXYtLiLiuAUhReKleJfmdNo/YNUkn/H2INn7vwbU1x9PQT7drwR14DSuCkLAfjYX5SAQyzw3kx4m9J+6l/auDepB+w5AIYcELT+ntgTD5WZLklaj4K9xYrlKjeH2S5Wf5ACNu1W/hauC9baC/OmNSylobBc9T8M6sejFdkANTCTrYcUY7zNiOeo/iRQD26tWmoFeOCRvqYr9DrLsVaJV+gaavYATjA7YX3i0hNbhL2mlV4kgmyQa2Tg/BB1N6ITA=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ef257f4-0884-41d5-11bc-08d68ccd085e
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2019 07:22:33.1703
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3415
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Cleanup patch to avoid function forward declaration by reordering the
function.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_sdio.c | 91 +++++++++++++++++---------------=
----
 1 file changed, 43 insertions(+), 48 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc100=
0/wilc_sdio.c
index e2f739f..a62eabe 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -51,10 +51,6 @@ struct sdio_cmd53 {
=20
 static const struct wilc_hif_func wilc_hif_sdio;
=20
-static int sdio_write_reg(struct wilc *wilc, u32 addr, u32 data);
-static int sdio_read_reg(struct wilc *wilc, u32 addr, u32 *data);
-static int sdio_init(struct wilc *wilc, bool resume);
-
 static void wilc_sdio_interrupt(struct sdio_func *func)
 {
 	sdio_release_host(func);
@@ -215,50 +211,6 @@ static int wilc_sdio_suspend(struct device *dev)
 	return 0;
 }
=20
-static int wilc_sdio_resume(struct device *dev)
-{
-	struct sdio_func *func =3D dev_to_sdio_func(dev);
-	struct wilc *wilc =3D sdio_get_drvdata(func);
-
-	dev_info(dev, "sdio resume\n");
-	sdio_release_host(func);
-	chip_wakeup(wilc);
-	sdio_init(wilc, true);
-
-	if (wilc->suspend_event)
-		host_wakeup_notify(wilc);
-
-	chip_allow_sleep(wilc);
-
-	return 0;
-}
-
-static const struct of_device_id wilc_of_match[] =3D {
-	{ .compatible =3D "microchip,wilc1000-sdio", },
-	{ /* sentinel */ }
-};
-MODULE_DEVICE_TABLE(of, wilc_of_match);
-
-static const struct dev_pm_ops wilc_sdio_pm_ops =3D {
-	.suspend =3D wilc_sdio_suspend,
-	.resume =3D wilc_sdio_resume,
-};
-
-static struct sdio_driver wilc_sdio_driver =3D {
-	.name		=3D SDIO_MODALIAS,
-	.id_table	=3D wilc_sdio_ids,
-	.probe		=3D linux_sdio_probe,
-	.remove		=3D linux_sdio_remove,
-	.drv =3D {
-		.pm =3D &wilc_sdio_pm_ops,
-		.of_match_table =3D wilc_of_match,
-	}
-};
-module_driver(wilc_sdio_driver,
-	      sdio_register_driver,
-	      sdio_unregister_driver);
-MODULE_LICENSE("GPL");
-
 static int wilc_sdio_enable_interrupt(struct wilc *dev)
 {
 	struct sdio_func *func =3D container_of(dev->dev, struct sdio_func, dev);
@@ -1143,3 +1095,46 @@ static const struct wilc_hif_func wilc_hif_sdio =3D =
{
 	.disable_interrupt =3D wilc_sdio_disable_interrupt,
 };
=20
+static int wilc_sdio_resume(struct device *dev)
+{
+	struct sdio_func *func =3D dev_to_sdio_func(dev);
+	struct wilc *wilc =3D sdio_get_drvdata(func);
+
+	dev_info(dev, "sdio resume\n");
+	sdio_release_host(func);
+	chip_wakeup(wilc);
+	sdio_init(wilc, true);
+
+	if (wilc->suspend_event)
+		host_wakeup_notify(wilc);
+
+	chip_allow_sleep(wilc);
+
+	return 0;
+}
+
+static const struct of_device_id wilc_of_match[] =3D {
+	{ .compatible =3D "microchip,wilc1000-sdio", },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, wilc_of_match);
+
+static const struct dev_pm_ops wilc_sdio_pm_ops =3D {
+	.suspend =3D wilc_sdio_suspend,
+	.resume =3D wilc_sdio_resume,
+};
+
+static struct sdio_driver wilc_sdio_driver =3D {
+	.name		=3D SDIO_MODALIAS,
+	.id_table	=3D wilc_sdio_ids,
+	.probe		=3D linux_sdio_probe,
+	.remove		=3D linux_sdio_remove,
+	.drv =3D {
+		.pm =3D &wilc_sdio_pm_ops,
+		.of_match_table =3D wilc_of_match,
+	}
+};
+module_driver(wilc_sdio_driver,
+	      sdio_register_driver,
+	      sdio_unregister_driver);
+MODULE_LICENSE("GPL");
--=20
2.7.4

