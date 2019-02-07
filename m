Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 794A2C282CC
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 11:29:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49D5D21872
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 11:29:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="JWrl6xjc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbfBGL3X (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 06:29:23 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:21405 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726965AbfBGL3W (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 06:29:22 -0500
X-IronPort-AV: E=Sophos;i="5.56,564,1539673200"; 
   d="scan'208";a="27383693"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 07 Feb 2019 04:29:21 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.105) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 7 Feb 2019 04:29:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cFta4Ih6QzZtjVebbTl/H7wybiKCFV5tw/NfcoFHJKM=;
 b=JWrl6xjcedZi4yQJCfm7VigP/79o6oakm+HiKsCc3AsjQCOQga6LE/9grIyUppt5DQqbR6peMYmImLSoh8GKOcphHCvGxiiVztSeXV+/Nz/0+YfRqntqoocx+1yzerch3lYP5gGmRuu+4mV3seRP9P4ebrkmWh3n7uv7/95StHw=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2792.namprd11.prod.outlook.com (52.135.228.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.21; Thu, 7 Feb 2019 11:29:20 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1601.016; Thu, 7 Feb 2019
 11:29:20 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH v2 8/8] staging: wilc1000: rename linux_wlan.c and linux_mon.c
Thread-Topic: [PATCH v2 8/8] staging: wilc1000: rename linux_wlan.c and
 linux_mon.c
Thread-Index: AQHUvtheGFgRMxrtYkW5lXuL+y5aOA==
Date:   Thu, 7 Feb 2019 11:29:20 +0000
Message-ID: <1549538913-17463-9-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2792;6:umOtvKeuBKn+pLSkT5oB5hB6dRIfSc7uPvG0Yx+qTwUatLKkjn+UuNA+7TTDmoGPFEOEzVQdw7fO4adnhU6FRLy8pmh9dwEk40xaGcMTSU/6937mhczeLIdnzbiVutibJfYvTlPW0J1KL5P5EPwV4cizaEWd/SzQ6vvP4aDPRC2R1zueTKj28ksHKh5ivGzpQV72PfvIdfChC6oZgYe+HXEWw+Kd+sUFzTF0OT3B0qpoInj+dx8fq4rWJ4oGEofltpOVIZzF/d2y9/V3pSKqho4YYZ300WjHCWsHKEMshhMQJg/+y2yHznlygAFgMW7n2g5Vsx/y5rVs4tzthWlb6q0pkm2qlDeZTguAkPzqKWvmJP5HhI98QWCG++3a6cflb75u0H+f1p6aQC5SPR8hu7svmHV7WpQgntmE1+Z3M+Dwv80O1O/ZqHdVfdDkxvGMlKw/kCkZT9923VCCDtwPMg==;5:te0mXxSUEY/Z5AUO7gngIPSq+48Cse/kbWdYr443GZIR4ZyliSKOENmZFD47WsF/oleSZOdg0a63SsijXCNmTxFvfxgl3MGpK3W31tfqr4qlFgDZOI7342f0ffN+QzMtB6OztLp1giAux9UZo4vSI7OlXnnU8P8hGN9VS3gLLG/WOGYcEaqoHN+s+Y8oDOr3LgOEUn6Viqm1KzbeDBQ60Q==;7:jY1pn+3vZu26uNS8NlWySHTmTaEapSdcVS/br6DcGhbl1env3xhwSTQ+9so1UrMDNyJFnPByPeEUNKKkEc8PVUmXZu9dwozXJCM/5cWbSQljlAW8sxT+uPOeKPsbYs6zVk6CbzIh0YF1gPYe6GohTA==
x-ms-office365-filtering-correlation-id: 08c355f6-4feb-4ce4-8ff3-08d68cef8054
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2792;
x-ms-traffictypediagnostic: BYAPR11MB2792:
x-microsoft-antispam-prvs: <BYAPR11MB2792625661017CFD76A411B9E3680@BYAPR11MB2792.namprd11.prod.outlook.com>
x-forefront-prvs: 0941B96580
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(346002)(366004)(376002)(39860400002)(189003)(199004)(2501003)(256004)(14444005)(7736002)(68736007)(107886003)(81166006)(81156014)(305945005)(186003)(8676002)(8936002)(66066001)(50226002)(97736004)(52116002)(4326008)(11346002)(86362001)(316002)(25786009)(476003)(2616005)(54906003)(478600001)(6486002)(105586002)(486006)(6916009)(106356001)(6436002)(14454004)(6512007)(53936002)(2906002)(2351001)(71200400001)(71190400001)(6116002)(3846002)(386003)(6506007)(446003)(76176011)(36756003)(26005)(5640700003)(102836004)(99286004)(72206003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2792;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: sbr54T5oI67wZ9xTYFE3d+6IUO3jdVaBMSxSLQGDoQw7mK5kY8Gws8JvzUpwqK9J8SPugfTAFsmMdb0Nwv253f1asMPgj7E/mgUFSbtPfzDSMeJdLm//wW/DNcxkgnm+xK/3tZkxmOEthePiI/3yaQpNI4hvLjmgzGIDPC+gxX8XqmX9jkt5I6W70HZFnATPZadm7O5n2zM8CFuuFBfiEtTqTFbuEEGC/sFimNdfsVSYIezsH1ZOVTFMTbzGMflS74Dbr4h2+phr+L7ex2ygCSJvVhQbo4IGmRurHg3ahhs0/igkFF6yVEcWVP5sQ3G8PiZOOY3vt9dFs9mYh2XG8WRc9WJdybg71G0ovOdc+RYKyDgu2ax4F6SmYjRArOPyiqrESreOvp5JWNgWJ0BdiPB30tX6nhUX4nlSVnh0G10=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 08c355f6-4feb-4ce4-8ff3-08d68cef8054
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2019 11:29:17.3424
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

Rename linux_wlan.c and linux_mon.c to wilc_netdev.c and wilc_mon.c to
include 'wilc_' prefix.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/Makefile                        | 2 +-
 drivers/staging/wilc1000/{linux_mon.c =3D> wilc_mon.c}     | 0
 drivers/staging/wilc1000/{linux_wlan.c =3D> wilc_netdev.c} | 0
 3 files changed, 1 insertion(+), 1 deletion(-)
 rename drivers/staging/wilc1000/{linux_mon.c =3D> wilc_mon.c} (100%)
 rename drivers/staging/wilc1000/{linux_wlan.c =3D> wilc_netdev.c} (100%)

diff --git a/drivers/staging/wilc1000/Makefile b/drivers/staging/wilc1000/M=
akefile
index 72a4daa..2ad3fee 100644
--- a/drivers/staging/wilc1000/Makefile
+++ b/drivers/staging/wilc1000/Makefile
@@ -4,7 +4,7 @@ obj-$(CONFIG_WILC1000) +=3D wilc1000.o
 ccflags-y +=3D -DFIRMWARE_1002=3D\"atmel/wilc1002_firmware.bin\" \
 		-DFIRMWARE_1003=3D\"atmel/wilc1003_firmware.bin\"
=20
-wilc1000-objs :=3D wilc_wfi_cfgoperations.o linux_wlan.o linux_mon.o \
+wilc1000-objs :=3D wilc_wfi_cfgoperations.o wilc_netdev.o wilc_mon.o \
 			host_interface.o wilc_wlan_cfg.o wilc_wlan.o
=20
 obj-$(CONFIG_WILC1000_SDIO) +=3D wilc1000-sdio.o
diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc100=
0/wilc_mon.c
similarity index 100%
rename from drivers/staging/wilc1000/linux_mon.c
rename to drivers/staging/wilc1000/wilc_mon.c
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc10=
00/wilc_netdev.c
similarity index 100%
rename from drivers/staging/wilc1000/linux_wlan.c
rename to drivers/staging/wilc1000/wilc_netdev.c
--=20
2.7.4

