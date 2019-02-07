Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CD5AC282C2
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 07:22:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBE492075C
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 07:22:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="FQuz4krB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbfBGHWn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 02:22:43 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:48985 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbfBGHWm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 02:22:42 -0500
X-IronPort-AV: E=Sophos;i="5.58,342,1544511600"; 
   d="scan'208";a="25947747"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES128-SHA; 07 Feb 2019 00:22:41 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.37) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 7 Feb 2019 00:22:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+rfhB4kj57y6C8d1chqVEqkYHtwJIk8ZLET+5Gscvm8=;
 b=FQuz4krBl42XZ2PWj9QFBjRqB4Jm4/2dWMsjCPc2/ooccMeJ3ZIGRRwiT0okatPmAYDKGuUD3q4BmpI2G/IljGzC6wbpOdus6flTmY+ljNEF67x/WTPi7MnbkxrDWFxhhI9s9G3Gp+qG+4QoxZLeWLVh2LW/jNXicOfbB0jrBRU=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3415.namprd11.prod.outlook.com (20.177.224.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.22; Thu, 7 Feb 2019 07:22:40 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1601.016; Thu, 7 Feb 2019
 07:22:40 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 6/9] staging: wilc1000: added 'wilc_' prefix for function in
 wilc_sdio.c file
Thread-Topic: [PATCH 6/9] staging: wilc1000: added 'wilc_' prefix for function
 in wilc_sdio.c file
Thread-Index: AQHUvrXoNvKNqj4xJkm1rv3RQIj0YA==
Date:   Thu, 7 Feb 2019 07:22:39 +0000
Message-ID: <1549519927-2651-7-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3415;6:rZQCibzvXcMVqt3uePG0ju0Erq04h9EvQJsajPssFRKa3amhHZ/BY1Kdh/K+Dz5AtW2gqDL8fQS8eqS6t9K2XFcke3yCzR2mEUnZSNr1N4cTH4OU+dqsODQczj3fuTUSOdd6hWQZNQrg6FXmYCkOVeVBIskmFZVNC9JUnGLxufsK+XjM0CRWYHUgPCCzWStXFPCkocXonpk/WN39q8zP1yRA2xsGOIP0hUsAndWeFWyAIGzpRBxepg1A0X//3H+pBN1Y4Cet9uNekOEmseBbmbVOj6Ia10ngCimv2INp9ohzVr2fOlcb2k7gkFCFQ0VufQLGPDP56Kj34fFtCWNrG3kwIuwOugHI4BK428mij9NahOWmrUXQWa6qo3rbS+hNxrZSJbibuZC/wfwfZfh9Ou7hP99MST8LCdklkdyWI6asadySk8JInNJ8f5l3GCUDchs1gTM/Ikok+PgfCBDF5A==;5:gqU2U14kMaHBv0uSOfGugCUEv7sgBpjhq/B0k3dPiuIKPEIrXtV5D8bgfQOomblFVS1mI6Ck1YGWEmDNUu4By8F3Qhgi0BS0ZHo1eSUm3X3zvhLuAj3rZrb6p8aU739PSKbITN+w2huiSd4SE5c0G4jTSBcEP0S1cfWfsFz7MzcJpcfrXg8oRiz50qX92lmfq4uwmYUAXRzXXoYeanuR5w==;7:pjpRPQIIcsb6Khkuanw91ORTpY4p/g5yCl108LvuXiSH/6mImEiBHymrJ295hLQEfOe70ixQAwoiJJWqCrSzhQRBb3ecr3flYjM93gI1fBY+WJZnBEcgOxAOTgq6dSuaxur5bIQ0Wi4+moUn822QNA==
x-ms-office365-filtering-correlation-id: fe1aee5d-7d1d-4c33-8ae6-08d68ccd0a46
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3415;
x-ms-traffictypediagnostic: BYAPR11MB3415:
x-microsoft-antispam-prvs: <BYAPR11MB34157FE6E946CD99343D4A52E3680@BYAPR11MB3415.namprd11.prod.outlook.com>
x-forefront-prvs: 0941B96580
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39860400002)(136003)(366004)(396003)(376002)(189003)(199004)(86362001)(5640700003)(478600001)(6116002)(446003)(3846002)(72206003)(6486002)(11346002)(6436002)(25786009)(2351001)(2616005)(476003)(6512007)(105586002)(106356001)(486006)(26005)(6506007)(102836004)(386003)(36756003)(71190400001)(30864003)(2501003)(97736004)(71200400001)(81156014)(305945005)(66066001)(54906003)(4326008)(186003)(68736007)(8936002)(81166006)(107886003)(52116002)(50226002)(53936002)(256004)(6916009)(14444005)(316002)(99286004)(14454004)(2906002)(76176011)(7736002)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3415;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: K0etkpnw+pUQpHXmJAEhTvJgek/oZtZiXBMAfEEVm4aCKgxUz2qojMpD7yaBBt9oeH36qdjiFdGmeUerS9XcOElSHxg8ToytfAQER5D48B59FUas8666tkq6H3rj6thufpjuLWzgmXnma0QGgeyM9p1xrobbsSxxv0KD8EyYik6yhhzBy4flYFJw/UlDvuuUmNAz6Qk4Wqra0uKfTra1jqcSSghSWlRMvMEt+pGpDUVORj+q1kvV8z0NJO6AnbbCCgL+uQz4ZpAmCQGrsDu5ax5kG5VNeJ0lFqf8rZChRzvCRNaLSpUcgL75QFypY7Gl8Dvbjl3I++uy+vn7rjsff1/ycK1nWGSbvYPu3Sb14QZFwCRWaWhJbm1rWdMO2c4s+gqhmnF13qCUbmZy2RK0GrweJzBHMUAbcprgNs5Pxc4=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: fe1aee5d-7d1d-4c33-8ae6-08d68ccd0a46
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2019 07:22:36.4656
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

Cleanup patch to have proper follow clear namespace in wilc_sdio.c file.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_sdio.c | 92 ++++++++++++++++++--------------=
----
 1 file changed, 46 insertions(+), 46 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc100=
0/wilc_sdio.c
index a62eabe..2ca6757 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -166,7 +166,7 @@ static void linux_sdio_remove(struct sdio_func *func)
 	wilc_netdev_cleanup(wilc);
 }
=20
-static int sdio_reset(struct wilc *wilc)
+static int wilc_sdio_reset(struct wilc *wilc)
 {
 	struct sdio_cmd52 cmd;
 	int ret;
@@ -201,7 +201,7 @@ static int wilc_sdio_suspend(struct device *dev)
 		chip_allow_sleep(wilc);
 	}
=20
-	ret =3D sdio_reset(wilc);
+	ret =3D wilc_sdio_reset(wilc);
 	if (ret) {
 		dev_err(&func->dev, "Fail reset sdio\n");
 		return ret;
@@ -245,7 +245,7 @@ static void wilc_sdio_disable_interrupt(struct wilc *de=
v)
  *
  ********************************************/
=20
-static int sdio_set_func0_csa_address(struct wilc *wilc, u32 adr)
+static int wilc_sdio_set_func0_csa_address(struct wilc *wilc, u32 adr)
 {
 	struct sdio_func *func =3D dev_to_sdio_func(wilc->dev);
 	struct sdio_cmd52 cmd;
@@ -286,7 +286,7 @@ static int sdio_set_func0_csa_address(struct wilc *wilc=
, u32 adr)
 	return 0;
 }
=20
-static int sdio_set_func0_block_size(struct wilc *wilc, u32 block_size)
+static int wilc_sdio_set_func0_block_size(struct wilc *wilc, u32 block_siz=
e)
 {
 	struct sdio_func *func =3D dev_to_sdio_func(wilc->dev);
 	struct sdio_cmd52 cmd;
@@ -322,7 +322,7 @@ static int sdio_set_func0_block_size(struct wilc *wilc,=
 u32 block_size)
  *
  ********************************************/
=20
-static int sdio_set_func1_block_size(struct wilc *wilc, u32 block_size)
+static int wilc_sdio_set_func1_block_size(struct wilc *wilc, u32 block_siz=
e)
 {
 	struct sdio_func *func =3D dev_to_sdio_func(wilc->dev);
 	struct sdio_cmd52 cmd;
@@ -356,7 +356,7 @@ static int sdio_set_func1_block_size(struct wilc *wilc,=
 u32 block_size)
  *      Sdio interfaces
  *
  ********************************************/
-static int sdio_write_reg(struct wilc *wilc, u32 addr, u32 data)
+static int wilc_sdio_write_reg(struct wilc *wilc, u32 addr, u32 data)
 {
 	struct sdio_func *func =3D dev_to_sdio_func(wilc->dev);
 	struct wilc_sdio *sdio_priv =3D wilc->bus_data;
@@ -384,7 +384,7 @@ static int sdio_write_reg(struct wilc *wilc, u32 addr, =
u32 data)
 		/**
 		 *      set the AHB address
 		 **/
-		if (!sdio_set_func0_csa_address(wilc, addr))
+		if (!wilc_sdio_set_func0_csa_address(wilc, addr))
 			goto fail;
=20
 		cmd.read_write =3D 1;
@@ -410,7 +410,7 @@ static int sdio_write_reg(struct wilc *wilc, u32 addr, =
u32 data)
 	return 0;
 }
=20
-static int sdio_write(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
+static int wilc_sdio_write(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 {
 	struct sdio_func *func =3D dev_to_sdio_func(wilc->dev);
 	struct wilc_sdio *sdio_priv =3D wilc->bus_data;
@@ -459,7 +459,7 @@ static int sdio_write(struct wilc *wilc, u32 addr, u8 *=
buf, u32 size)
 		cmd.buffer =3D buf;
 		cmd.block_size =3D block_size;
 		if (addr > 0) {
-			if (!sdio_set_func0_csa_address(wilc, addr))
+			if (!wilc_sdio_set_func0_csa_address(wilc, addr))
 				goto fail;
 		}
 		ret =3D wilc_sdio_cmd53(wilc, &cmd);
@@ -482,7 +482,7 @@ static int sdio_write(struct wilc *wilc, u32 addr, u8 *=
buf, u32 size)
 		cmd.block_size =3D block_size;
=20
 		if (addr > 0) {
-			if (!sdio_set_func0_csa_address(wilc, addr))
+			if (!wilc_sdio_set_func0_csa_address(wilc, addr))
 				goto fail;
 		}
 		ret =3D wilc_sdio_cmd53(wilc, &cmd);
@@ -500,7 +500,7 @@ static int sdio_write(struct wilc *wilc, u32 addr, u8 *=
buf, u32 size)
 	return 0;
 }
=20
-static int sdio_read_reg(struct wilc *wilc, u32 addr, u32 *data)
+static int wilc_sdio_read_reg(struct wilc *wilc, u32 addr, u32 *data)
 {
 	struct sdio_func *func =3D dev_to_sdio_func(wilc->dev);
 	struct wilc_sdio *sdio_priv =3D wilc->bus_data;
@@ -523,7 +523,7 @@ static int sdio_read_reg(struct wilc *wilc, u32 addr, u=
32 *data)
 	} else {
 		struct sdio_cmd53 cmd;
=20
-		if (!sdio_set_func0_csa_address(wilc, addr))
+		if (!wilc_sdio_set_func0_csa_address(wilc, addr))
 			goto fail;
=20
 		cmd.read_write =3D 0;
@@ -552,7 +552,7 @@ static int sdio_read_reg(struct wilc *wilc, u32 addr, u=
32 *data)
 	return 0;
 }
=20
-static int sdio_read(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
+static int wilc_sdio_read(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 {
 	struct sdio_func *func =3D dev_to_sdio_func(wilc->dev);
 	struct wilc_sdio *sdio_priv =3D wilc->bus_data;
@@ -601,7 +601,7 @@ static int sdio_read(struct wilc *wilc, u32 addr, u8 *b=
uf, u32 size)
 		cmd.buffer =3D buf;
 		cmd.block_size =3D block_size;
 		if (addr > 0) {
-			if (!sdio_set_func0_csa_address(wilc, addr))
+			if (!wilc_sdio_set_func0_csa_address(wilc, addr))
 				goto fail;
 		}
 		ret =3D wilc_sdio_cmd53(wilc, &cmd);
@@ -624,7 +624,7 @@ static int sdio_read(struct wilc *wilc, u32 addr, u8 *b=
uf, u32 size)
 		cmd.block_size =3D block_size;
=20
 		if (addr > 0) {
-			if (!sdio_set_func0_csa_address(wilc, addr))
+			if (!wilc_sdio_set_func0_csa_address(wilc, addr))
 				goto fail;
 		}
 		ret =3D wilc_sdio_cmd53(wilc, &cmd);
@@ -648,12 +648,12 @@ static int sdio_read(struct wilc *wilc, u32 addr, u8 =
*buf, u32 size)
  *
  ********************************************/
=20
-static int sdio_deinit(struct wilc *wilc)
+static int wilc_sdio_deinit(struct wilc *wilc)
 {
 	return 1;
 }
=20
-static int sdio_init(struct wilc *wilc, bool resume)
+static int wilc_sdio_init(struct wilc *wilc, bool resume)
 {
 	struct sdio_func *func =3D dev_to_sdio_func(wilc->dev);
 	struct wilc_sdio *sdio_priv =3D wilc->bus_data;
@@ -681,7 +681,7 @@ static int sdio_init(struct wilc *wilc, bool resume)
 	/**
 	 *      function 0 block size
 	 **/
-	if (!sdio_set_func0_block_size(wilc, WILC_SDIO_BLOCK_SIZE)) {
+	if (!wilc_sdio_set_func0_block_size(wilc, WILC_SDIO_BLOCK_SIZE)) {
 		dev_err(&func->dev, "Fail cmd 52, set func 0 block size...\n");
 		goto fail;
 	}
@@ -730,7 +730,7 @@ static int sdio_init(struct wilc *wilc, bool resume)
 	/**
 	 *      func 1 is ready, set func 1 block size
 	 **/
-	if (!sdio_set_func1_block_size(wilc, WILC_SDIO_BLOCK_SIZE)) {
+	if (!wilc_sdio_set_func1_block_size(wilc, WILC_SDIO_BLOCK_SIZE)) {
 		dev_err(&func->dev, "Fail set func 1 block size...\n");
 		goto fail;
 	}
@@ -753,7 +753,7 @@ static int sdio_init(struct wilc *wilc, bool resume)
 	 *      make sure can read back chip id correctly
 	 **/
 	if (!resume) {
-		if (!sdio_read_reg(wilc, 0x1000, &chipid)) {
+		if (!wilc_sdio_read_reg(wilc, 0x1000, &chipid)) {
 			dev_err(&func->dev, "Fail cmd read chip id...\n");
 			goto fail;
 		}
@@ -773,7 +773,7 @@ static int sdio_init(struct wilc *wilc, bool resume)
 	return 0;
 }
=20
-static int sdio_read_size(struct wilc *wilc, u32 *size)
+static int wilc_sdio_read_size(struct wilc *wilc, u32 *size)
 {
 	u32 tmp;
 	struct sdio_cmd52 cmd;
@@ -798,14 +798,14 @@ static int sdio_read_size(struct wilc *wilc, u32 *siz=
e)
 	return 1;
 }
=20
-static int sdio_read_int(struct wilc *wilc, u32 *int_status)
+static int wilc_sdio_read_int(struct wilc *wilc, u32 *int_status)
 {
 	struct sdio_func *func =3D dev_to_sdio_func(wilc->dev);
 	struct wilc_sdio *sdio_priv =3D wilc->bus_data;
 	u32 tmp;
 	struct sdio_cmd52 cmd;
=20
-	sdio_read_size(wilc, &tmp);
+	wilc_sdio_read_size(wilc, &tmp);
=20
 	/**
 	 *      Read IRQ flags
@@ -857,7 +857,7 @@ static int sdio_read_int(struct wilc *wilc, u32 *int_st=
atus)
 	return 1;
 }
=20
-static int sdio_clear_int_ext(struct wilc *wilc, u32 val)
+static int wilc_sdio_clear_int_ext(struct wilc *wilc, u32 val)
 {
 	struct sdio_func *func =3D dev_to_sdio_func(wilc->dev);
 	struct wilc_sdio *sdio_priv =3D wilc->bus_data;
@@ -982,7 +982,7 @@ static int sdio_clear_int_ext(struct wilc *wilc, u32 va=
l)
 	return 0;
 }
=20
-static int sdio_sync_ext(struct wilc *wilc, int nint)
+static int wilc_sdio_sync_ext(struct wilc *wilc, int nint)
 {
 	struct sdio_func *func =3D dev_to_sdio_func(wilc->dev);
 	struct wilc_sdio *sdio_priv =3D wilc->bus_data;
@@ -1003,13 +1003,13 @@ static int sdio_sync_ext(struct wilc *wilc, int nin=
t)
 	/**
 	 *      Disable power sequencer
 	 **/
-	if (!sdio_read_reg(wilc, WILC_MISC, &reg)) {
+	if (!wilc_sdio_read_reg(wilc, WILC_MISC, &reg)) {
 		dev_err(&func->dev, "Failed read misc reg...\n");
 		return 0;
 	}
=20
 	reg &=3D ~BIT(8);
-	if (!sdio_write_reg(wilc, WILC_MISC, reg)) {
+	if (!wilc_sdio_write_reg(wilc, WILC_MISC, reg)) {
 		dev_err(&func->dev, "Failed write misc reg...\n");
 		return 0;
 	}
@@ -1021,14 +1021,14 @@ static int sdio_sync_ext(struct wilc *wilc, int nin=
t)
 		/**
 		 *      interrupt pin mux select
 		 **/
-		ret =3D sdio_read_reg(wilc, WILC_PIN_MUX_0, &reg);
+		ret =3D wilc_sdio_read_reg(wilc, WILC_PIN_MUX_0, &reg);
 		if (!ret) {
 			dev_err(&func->dev, "Failed read reg (%08x)...\n",
 				WILC_PIN_MUX_0);
 			return 0;
 		}
 		reg |=3D BIT(8);
-		ret =3D sdio_write_reg(wilc, WILC_PIN_MUX_0, reg);
+		ret =3D wilc_sdio_write_reg(wilc, WILC_PIN_MUX_0, reg);
 		if (!ret) {
 			dev_err(&func->dev, "Failed write reg (%08x)...\n",
 				WILC_PIN_MUX_0);
@@ -1038,7 +1038,7 @@ static int sdio_sync_ext(struct wilc *wilc, int nint)
 		/**
 		 *      interrupt enable
 		 **/
-		ret =3D sdio_read_reg(wilc, WILC_INTR_ENABLE, &reg);
+		ret =3D wilc_sdio_read_reg(wilc, WILC_INTR_ENABLE, &reg);
 		if (!ret) {
 			dev_err(&func->dev, "Failed read reg (%08x)...\n",
 				WILC_INTR_ENABLE);
@@ -1047,14 +1047,14 @@ static int sdio_sync_ext(struct wilc *wilc, int nin=
t)
=20
 		for (i =3D 0; (i < 5) && (nint > 0); i++, nint--)
 			reg |=3D BIT((27 + i));
-		ret =3D sdio_write_reg(wilc, WILC_INTR_ENABLE, reg);
+		ret =3D wilc_sdio_write_reg(wilc, WILC_INTR_ENABLE, reg);
 		if (!ret) {
 			dev_err(&func->dev, "Failed write reg (%08x)...\n",
 				WILC_INTR_ENABLE);
 			return 0;
 		}
 		if (nint) {
-			ret =3D sdio_read_reg(wilc, WILC_INTR2_ENABLE, &reg);
+			ret =3D wilc_sdio_read_reg(wilc, WILC_INTR2_ENABLE, &reg);
 			if (!ret) {
 				dev_err(&func->dev,
 					"Failed read reg (%08x)...\n",
@@ -1065,7 +1065,7 @@ static int sdio_sync_ext(struct wilc *wilc, int nint)
 			for (i =3D 0; (i < 3) && (nint > 0); i++, nint--)
 				reg |=3D BIT(i);
=20
-			ret =3D sdio_read_reg(wilc, WILC_INTR2_ENABLE, &reg);
+			ret =3D wilc_sdio_read_reg(wilc, WILC_INTR2_ENABLE, &reg);
 			if (!ret) {
 				dev_err(&func->dev,
 					"Failed write reg (%08x)...\n",
@@ -1079,18 +1079,18 @@ static int sdio_sync_ext(struct wilc *wilc, int nin=
t)
=20
 /* Global sdio HIF function table */
 static const struct wilc_hif_func wilc_hif_sdio =3D {
-	.hif_init =3D sdio_init,
-	.hif_deinit =3D sdio_deinit,
-	.hif_read_reg =3D sdio_read_reg,
-	.hif_write_reg =3D sdio_write_reg,
-	.hif_block_rx =3D sdio_read,
-	.hif_block_tx =3D sdio_write,
-	.hif_read_int =3D sdio_read_int,
-	.hif_clear_int_ext =3D sdio_clear_int_ext,
-	.hif_read_size =3D sdio_read_size,
-	.hif_block_tx_ext =3D sdio_write,
-	.hif_block_rx_ext =3D sdio_read,
-	.hif_sync_ext =3D sdio_sync_ext,
+	.hif_init =3D wilc_sdio_init,
+	.hif_deinit =3D wilc_sdio_deinit,
+	.hif_read_reg =3D wilc_sdio_read_reg,
+	.hif_write_reg =3D wilc_sdio_write_reg,
+	.hif_block_rx =3D wilc_sdio_read,
+	.hif_block_tx =3D wilc_sdio_write,
+	.hif_read_int =3D wilc_sdio_read_int,
+	.hif_clear_int_ext =3D wilc_sdio_clear_int_ext,
+	.hif_read_size =3D wilc_sdio_read_size,
+	.hif_block_tx_ext =3D wilc_sdio_write,
+	.hif_block_rx_ext =3D wilc_sdio_read,
+	.hif_sync_ext =3D wilc_sdio_sync_ext,
 	.enable_interrupt =3D wilc_sdio_enable_interrupt,
 	.disable_interrupt =3D wilc_sdio_disable_interrupt,
 };
@@ -1103,7 +1103,7 @@ static int wilc_sdio_resume(struct device *dev)
 	dev_info(dev, "sdio resume\n");
 	sdio_release_host(func);
 	chip_wakeup(wilc);
-	sdio_init(wilc, true);
+	wilc_sdio_init(wilc, true);
=20
 	if (wilc->suspend_event)
 		host_wakeup_notify(wilc);
--=20
2.7.4

