Return-Path: <SRS0=J0pC=NX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D4B9C43441
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 05:45:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFE5921527
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 05:45:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="UcKNTumb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DFE5921527
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731172AbeKLPgy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 10:36:54 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:3001 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728269AbeKLPgy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 10:36:54 -0500
X-IronPort-AV: E=Sophos;i="5.54,494,1534834800"; 
   d="scan'208";a="22686985"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 11 Nov 2018 22:45:13 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.108) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sun, 11 Nov 2018 22:45:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3b5lsiR9N571Q4zTAmU4DdUZ3DivNL4v7eMM1hH1TKQ=;
 b=UcKNTumbxYQeR7skOy228C2pktBDk8G3733JcImoVivvG7PLFrDgz4AQZklOrqkmyGS8xNMxqoHFpzMJoINM7RsPbMwYDuOUFBZcZORZS4T/7t5mZCESgrZceOnSL2TZltfWPdcK3XAJLqRCDHOHbvZRo3jUpifmau5BdMtDpYU=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2599.namprd11.prod.outlook.com (52.135.227.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.21; Mon, 12 Nov 2018 05:45:11 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7%6]) with mapi id 15.20.1294.044; Mon, 12 Nov 2018
 05:45:11 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 04/12] staging: wilc1000: move sdio_cmd52 & sdio_cmd53 struct
 to source file
Thread-Topic: [PATCH 04/12] staging: wilc1000: move sdio_cmd52 & sdio_cmd53
 struct to source file
Thread-Index: AQHUekrg7zuwIXbBSkqdc6QAGUB6NQ==
Date:   Mon, 12 Nov 2018 05:45:11 +0000
Message-ID: <1542001458-20217-5-git-send-email-ajay.kathat@microchip.com>
References: <1542001458-20217-1-git-send-email-ajay.kathat@microchip.com>
In-Reply-To: <1542001458-20217-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR01CA0135.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:35::29) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [27.59.94.109]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2599;6:5bm4MMyayqavPMXn31jKvJDCUWrqiLI6Jg6c7ml/WWZk+2NAKYBs4Ww/LYv5QUgCJ6TEKMruR+L85vVsJhS+mt8NzydO0bffquK93/SXF5R2HUpGZRQLPzUAg6FlZQJZKAXEx4X7OuWRYjrsXpJHhwBZMEPgWlh9aLewPtU6R2IGHSxNgety5PhOY4l+2AjBNYhr4N+dQO5InDZEMlOruxJWCedH7LttwElnskzuMmuzyQqf2SAqJgYR81NHBL6y++feeY9wcGpey7SF34S12JxLZCCfmLE7qPIK27qEln+QzMQBJCadK+7PxA92IWrZ1BjTUqYKzW6w7mGwiKJIh7AP8ARh1XQzXRKXN+LOvC5d9OMvgwdBWeuQjrq+FTkHzunXpqgIN2hlrR5QBB/hfN1JoIFtwFFZs1mtlDcyE23jsRzb9FtAD3p9zlY/IfdQ8mizj/2/B4H7hrcEBnpeQw==;5:9XvdBzRDItvdI9SfpDRGq9LSnHr6VOe15RLZEBZiuCy80yDCmYQpgB0vqgZOkgAk/cooobqRRNomB0e8bRK+fpED8dQtMsDuSh2y847Ri9DfMbwYqvgOhSwsYXdd4EnqIOHXOC6oJH8q8JNQB6V0HgKrTyqktAvkWJC/EiogauI=;7:7ud1kQR1vCuopJTjXuBVNbDWjDdu9ExPy805GkHTVC4wXygAImttEMET2NC2ZD5vtzMUBGOX2F57zjqCewkt34FgPedXQORzYJKUUKlk74CA8WALQTuaISFR36BgnfxDTadC7DjRrLJ8pVjDb/NZlw==
x-ms-office365-filtering-correlation-id: 070305e9-cd24-4d87-afcb-08d648620309
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390040)(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2599;
x-ms-traffictypediagnostic: BYAPR11MB2599:
x-microsoft-antispam-prvs: <BYAPR11MB25991D5E134160597C8CB26CE3C10@BYAPR11MB2599.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(3002001)(3231402)(944501410)(52105112)(10201501046)(93006095)(93001095)(148016)(149066)(150057)(6041310)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123560045)(20161123562045)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB2599;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB2599;
x-forefront-prvs: 0854128AF0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(396003)(136003)(366004)(39860400002)(189003)(199004)(4326008)(25786009)(2906002)(6116002)(3846002)(72206003)(26005)(2351001)(14454004)(86362001)(186003)(6436002)(478600001)(6486002)(105586002)(76176011)(106356001)(2501003)(107886003)(5640700003)(54906003)(52116002)(99286004)(102836004)(53936002)(256004)(6506007)(386003)(316002)(36756003)(486006)(8936002)(6916009)(11346002)(7736002)(305945005)(476003)(2616005)(68736007)(8676002)(71200400001)(97736004)(5660300001)(66066001)(446003)(81156014)(81166006)(6512007)(71190400001)(2900100001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2599;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: jkXV024cFy57M+1Orx/5usYx8etvChmyhQWMSrEmycAtU/zW/o3ZL0VpjhpwefiSgoc0mqpiWD66ZOH2MWvfrU7D2D2qW/ABuHxYEbefI4gM+EDhFcyiZfnrR06MmV7ikMtzADvZwjWMcXNI8OcVxCdHppHvHmzLV2gW47NquNrQVSwIa09Dn6uQC61npjYjEr2LSTbDYKh1AQKBN5rEn2weXl5TETMZAGy/6g1uivj7Sf0mg/E82Il8AB/FQYkT3hS3ctDnUPuaQN38oPFKr4AVcAxlbvZcs+cHURnpQT+KIvaU8XgfandsvoNYn/sqEVBXLtV80FC+xwKT9eTRwyvUWJBRuaWnGDoIC5dV61A=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 070305e9-cd24-4d87-afcb-08d648620309
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2018 05:45:11.6736
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2599
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Moved sdio_cmd52 & sdio_cmd53 struct from wilc_wlan_if.h, as its used in
wilc_sdio.cfile.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_sdio.c    | 19 +++++++++++++++++++
 drivers/staging/wilc1000/wilc_wlan_if.h | 19 -------------------
 2 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc100=
0/wilc_sdio.c
index ca351c9..779614e 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -30,6 +30,25 @@ struct wilc_sdio {
 	int has_thrpt_enh3;
 };
=20
+struct sdio_cmd52 {
+	u32 read_write:		1;
+	u32 function:		3;
+	u32 raw:		1;
+	u32 address:		17;
+	u32 data:		8;
+};
+
+struct sdio_cmd53 {
+	u32 read_write:		1;
+	u32 function:		3;
+	u32 block_mode:		1;
+	u32 increment:		1;
+	u32 address:		17;
+	u32 count:		9;
+	u8 *buffer;
+	u32 block_size;
+};
+
 static const struct wilc_hif_func wilc_hif_sdio;
=20
 static int sdio_write_reg(struct wilc *wilc, u32 addr, u32 data);
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc=
1000/wilc_wlan_if.h
index 4f258bf..dc40743 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -24,25 +24,6 @@
  *
  ********************************************/
=20
-struct sdio_cmd52 {
-	u32 read_write:		1;
-	u32 function:		3;
-	u32 raw:		1;
-	u32 address:		17;
-	u32 data:		8;
-};
-
-struct sdio_cmd53 {
-	u32 read_write:		1;
-	u32 function:		3;
-	u32 block_mode:		1;
-	u32 increment:		1;
-	u32 address:		17;
-	u32 count:		9;
-	u8 *buffer;
-	u32 block_size;
-};
-
 #define MAC_STATUS_INIT			-1
 #define MAC_STATUS_CONNECTED		1
 #define MAC_STATUS_DISCONNECTED		0
--=20
2.7.4

