Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8636AC282C4
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 11:29:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 454E921872
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 11:29:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="G18lvhJs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbfBGL3K (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 06:29:10 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:24901 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726579AbfBGL3K (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 06:29:10 -0500
X-IronPort-AV: E=Sophos;i="5.58,343,1544511600"; 
   d="scan'208";a="23538665"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 07 Feb 2019 04:29:09 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.108) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 7 Feb 2019 04:29:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z+vHQ1mj2EjPsMFWZFfPFFsz1Y8ZB6ftnSsUBCBYybo=;
 b=G18lvhJsQXVZW/K+hYjPp68UTSaezot6yT4NrPUgtKLzOfNt6LR/0g4PMWT7oUeBqnffI2NX3iCmq+e91xleIOxheWEZm3PM8k/437xMsEhY3Q6xTlZIsNPpsi/FSWsfj/8STE0TSvD++hUyM322AMOunW4qcRi+kLlJFKakUQk=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2792.namprd11.prod.outlook.com (52.135.228.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.21; Thu, 7 Feb 2019 11:29:08 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1601.016; Thu, 7 Feb 2019
 11:29:08 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH v2 4/8] staging: wilc1000: avoid function forward declaration
 in wilc_sdio.c file
Thread-Topic: [PATCH v2 4/8] staging: wilc1000: avoid function forward
 declaration in wilc_sdio.c file
Thread-Index: AQHUvthWQawKIMjv30morbkucThMRg==
Date:   Thu, 7 Feb 2019 11:29:07 +0000
Message-ID: <1549538913-17463-5-git-send-email-ajay.kathat@microchip.com>
References: <1549538913-17463-1-git-send-email-ajay.kathat@microchip.com>
In-Reply-To: <1549538913-17463-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR0101CA0060.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::22) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.7.4
x-originating-ip: [27.59.126.210]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2792;6:QeB46xcIN+0oMexgqebtosfOIa87kAgpLX160m397+GkYsWYyXC0TL/Vs+O2DU/MEm53ZcnC+N9/tZuTc96A83VMoRwhG+cV7xdptWASP3gPZ76OruxqLdavju+ZZ8bO+uzPpi8YXsFCcIAahEVfOEHc6U5E4ajQgZ4YvEZF0sKiTttWTtZ1GwHiGgNJU/B+Mh9gV5ziWUHEZmPKBxKi/qB3YHHoFs1YRQneNcZmWzTv8EFDTUXBewzrikQ0lmEp7RzHQj5GNy4XcOoKejPP3hzxm5hkh1vHJa6dUAU2xH71QqAon50+5an/OzWuonvbGG3YYmWH1A0KQ1QLM+c74Jg4+ZOAlYywutBUHQA3nlUPm6gNk9qC5TtUyo/gEevYswbTqHruz0zrwKfKiuDtQGzF74cz1V/EKCQfq+Yqu4yzx6j/sKwO4sbGhCGn3qwoILv5HiNui0SbBrpQ0H8XrQ==;5:v3HJAcUXVBJmZW6NCnrzKBniPtbGpgybcCSPEvQZfq4K7uE2vr29Vps5E0P+97bOsAj0AqYQQ/6qselxVHEtZfjKn+QQ4DUH5GM/+PWg8eCMxWVNyBCnBsYOhV0VCAbOfznl6ql6sllHml/XvuTOwLaJnWAiUCcfTzw9j2H2fAhBpKsWp+XyjtPTbG7hJpi2Dd8ROgh0Y6BGFzhPd5oFOQ==;7:Rg/95th2RcZU6PUTzEfbcUr7DhKjoryRsz/ouG5oDoGztFrXedfPPkcRlfG159Nww6KM/IJNGDjmP/5BSlfX52bpQWxLuhtpg01YuOxhSx2bBO6onBhkDxiNWrMq3W5fn+UOFdgGB6jcam0niGsHRg==
x-ms-office365-filtering-correlation-id: 3075790e-a5bf-48b7-ad98-08d68cef7916
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2792;
x-ms-traffictypediagnostic: BYAPR11MB2792:
x-microsoft-antispam-prvs: <BYAPR11MB27928399FB2D112D0444154AE3680@BYAPR11MB2792.namprd11.prod.outlook.com>
x-forefront-prvs: 0941B96580
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(346002)(366004)(376002)(39860400002)(189003)(199004)(2501003)(256004)(14444005)(7736002)(68736007)(107886003)(81166006)(81156014)(305945005)(186003)(8676002)(8936002)(66066001)(50226002)(97736004)(52116002)(4326008)(11346002)(86362001)(316002)(25786009)(476003)(2616005)(54906003)(478600001)(6486002)(105586002)(486006)(6916009)(106356001)(6436002)(14454004)(6512007)(53936002)(2906002)(2351001)(71200400001)(71190400001)(6116002)(3846002)(386003)(6506007)(446003)(76176011)(36756003)(26005)(5640700003)(102836004)(99286004)(72206003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2792;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: aqMk7pu9s2gsELHu73FQfle8wAg8Qe8oSO/VKoDh/RSU2yyzzopFDxg7mwVtj4RxIsv8+cGRj66aXYeu3B3AYbuIRgd7E2vER1596y22zKDeiSuqek1wzbNzSw1RpgpNbmsHejBg1pOB6x0QA6uqeXf9g8koP/e0qZ75tHz1IyvmKl3yeH12vhEljWMR0/oG/2ly+5hRUENlS0Ri/bdTMQ5vJ4kdF+krQdNq7i9EEerHXSW7JuF6Y3OuAoJBl5WptWsYN3VqTmiczjAGgaDZEra7dDqGac6FvUetNFVBTWVG1LXQn5nWV1tTFh6/xxhf6ulYVnUotnVbaeciqnmT0yI4wJ1eeCviF4x5DD1UhxmuDDYheV7njc0j01SgibG6dR5J1HWV+tH8SKWYzLXPhgCKSPdBlasWdGhMpPcWypE=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3075790e-a5bf-48b7-ad98-08d68cef7916
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2019 11:29:05.3489
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2792
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

