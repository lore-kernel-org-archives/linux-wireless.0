Return-Path: <SRS0=J0pC=NX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C21BAC43441
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 05:45:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80AE421527
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 05:45:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="ZxwtBLNy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 80AE421527
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731120AbeKLPgo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 10:36:44 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:32648 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728269AbeKLPgn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 10:36:43 -0500
X-IronPort-AV: E=Sophos;i="5.54,494,1534834800"; 
   d="scan'208";a="23150803"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES128-SHA; 11 Nov 2018 22:45:04 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.37) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sun, 11 Nov 2018 22:45:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oYNFxSp1FcHbnkfC8bV2Z0Cm0vIcxQA/VssSkuTWuVY=;
 b=ZxwtBLNyRyvhZHg10owKBAZDCafQEKnYOyMb+klJMf3z6WcLoCNgiNQw0dTxfN3rHhW4PsGFRsGmFOxuI9YIEcZMt1wfeS8lJ8RtfnAGD6bQ6ctCBdD9jVuMi4vGnNK9hYVVV6j6cnFFHy9q0aUp9IYLIhLR9knWqYbxW03ZMlY=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2599.namprd11.prod.outlook.com (52.135.227.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.21; Mon, 12 Nov 2018 05:45:03 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7%6]) with mapi id 15.20.1294.044; Mon, 12 Nov 2018
 05:45:03 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 01/12] staging: wilc1000: use macro from ieee80211.h in
 register frame api's
Thread-Topic: [PATCH 01/12] staging: wilc1000: use macro from ieee80211.h in
 register frame api's
Thread-Index: AQHUekrbiCfNsEguAUmYJfp1aXypGg==
Date:   Mon, 12 Nov 2018 05:45:03 +0000
Message-ID: <1542001458-20217-2-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2599;6:ZyLO6NJjhhX0SLCU4qdVxwz+7X3iuxqYENZv5DUczkQWRYEltdxEFSgjGosH4XwK2cBdtCqFSH1lNJ9jQB9T0dm6H4BM8NZEfTkrVBMjSN/y/xuGvv16HnhBWhYK4LHkBa77Xt1o5WaCtOWQXIGwHwc/Ae+dQIBaFSuFbqknjOkaxFGTyeBAgWgYq6auDfUx7HGowXfKv5hMVoJ5UXoQWCZoB1HhgyqNNlob3QLlQx9nkZeUilC0o49Vlhwx65IU9Kg1LQYdUHut7NeHQmdwGHVeeiJuFo+djnk1elxI52waXBlcs1bTAgnEyRH0bIQeIcOStmXAM/5xhIrAbEOFkjkGsstFB3xIHeeBXKDMN7bTD06N5xupYWTCHQzNBbKlASkjMnVXR9Q3Q5HBnVPhxne+H3Ad4eNSUkL3WKcWxcV3xK+2mMXx1G3UFFXwGuQgoe/KxFKZMh31eZzIBVG+xQ==;5:YfJ1OS8MRhlAqhcsS1VSPrxQUDAPe+MLVkA3kMpABNTMFM7NeQNyxM79KZY+d7pbFAgNVQ3oRgPCvfR7H3V5Orn3iMvCA8PoKAoE+yxw0IRpsSDhLKjcO8fFFQA7dP+zPiM+mc1M1iGPBn8m6wcw2xBlxkTMbuiHTZoeAeCj/Ps=;7:6+fjOXUM+cr5Ch3oAqWEGctCLNe2bPk6Zg+/2wPgT0jxjlieersEjI8FPiOzqHwyhIfl6W8kqdD07N47VL9jtMb+lWa1y4jEM4BNp1Wry7IZpgyJHIwsNRiuVMgLa4w8pEibEFaRsemsuErvwJJr2A==
x-ms-office365-filtering-correlation-id: 47a846c0-2d0a-49fc-e5f3-08d64861fe04
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390040)(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2599;
x-ms-traffictypediagnostic: BYAPR11MB2599:
x-microsoft-antispam-prvs: <BYAPR11MB259907A6E5B0FABB8A648E1FE3C10@BYAPR11MB2599.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(3002001)(3231402)(944501410)(52105112)(10201501046)(93006095)(93001095)(148016)(149066)(150057)(6041310)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123560045)(20161123562045)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB2599;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB2599;
x-forefront-prvs: 0854128AF0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(396003)(136003)(366004)(39860400002)(189003)(199004)(4326008)(25786009)(2906002)(6116002)(3846002)(72206003)(26005)(2351001)(14454004)(86362001)(575784001)(186003)(6436002)(478600001)(6486002)(105586002)(76176011)(106356001)(2501003)(107886003)(5640700003)(54906003)(52116002)(99286004)(102836004)(53936002)(256004)(6506007)(386003)(316002)(36756003)(486006)(8936002)(6916009)(11346002)(7736002)(305945005)(476003)(2616005)(68736007)(8676002)(71200400001)(97736004)(5660300001)(66066001)(446003)(81156014)(81166006)(6512007)(71190400001)(2900100001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2599;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 3CSYBG0hTAzaxCTGe8Sbu6gOdxh4AwgMJYf5jrBtLl/5WMkTv0GcgZTclfieTQpaa7IRTfv8wy7y7qxzWghjAJf2tp0Pau76DLRY+s2xItt2KzZ7eJOGUOgVQ7YHkxgOeMKNq7b3X2rsoGdLs9+PEoTilZzZNarh9OINnkXbEmcmcQvkyhufejmzL6xL3kVh80qoR2XJHZ7wN2itEu1TGdVdxyzOZS+rG46yh/UvC3uVyq0BOq8afEbnGGsyIbEBvaD+2amkPRsLGuvyCFVoqKzfMXuF2+9JuBInMV6NB1qt+FXIKDkLXyP78aH3dj8H1Cgv7/Y7oFzbDZscS5dEt4Qu19hEOFpe3LjnidZd8g4=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 47a846c0-2d0a-49fc-e5f3-08d64861fe04
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2018 05:45:03.2376
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

Make use of ieee80211.h provided macros and removed the extra macro
defined for the same purpose.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c         | 4 ++--
 drivers/staging/wilc1000/host_interface.h         | 3 ---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 4 ++--
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index 2bf91df..eb13b41 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3483,11 +3483,11 @@ void wilc_frame_register(struct wilc_vif *vif, u16 =
frame_type, bool reg)
 		return;
=20
 	switch (frame_type) {
-	case ACTION:
+	case IEEE80211_STYPE_ACTION:
 		msg->body.reg_frame.reg_id =3D ACTION_FRM_IDX;
 		break;
=20
-	case PROBE_REQ:
+	case IEEE80211_STYPE_PROBE_REQ:
 		msg->body.reg_frame.reg_id =3D PROBE_REQ_IDX;
 		break;
=20
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wi=
lc1000/host_interface.h
index 523b46b..0185fc6 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -14,9 +14,6 @@
 #define STATION_MODE	0x02
 #define GO_MODE		0x03
 #define CLIENT_MODE	0x04
-#define ACTION		0xD0
-#define PROBE_REQ	0x40
-#define PROBE_RESP	0x50
=20
 #define ACTION_FRM_IDX				0
 #define PROBE_REQ_IDX				1
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/st=
aging/wilc1000/wilc_wfi_cfgoperations.c
index a6f4fad..f92ecf6c 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1700,12 +1700,12 @@ void wilc_mgmt_frame_register(struct wiphy *wiphy, =
struct wireless_dev *wdev,
 		return;
=20
 	switch (frame_type) {
-	case PROBE_REQ:
+	case IEEE80211_STYPE_PROBE_REQ:
 		vif->frame_reg[0].type =3D frame_type;
 		vif->frame_reg[0].reg =3D reg;
 		break;
=20
-	case ACTION:
+	case IEEE80211_STYPE_ACTION:
 		vif->frame_reg[1].type =3D frame_type;
 		vif->frame_reg[1].reg =3D reg;
 		break;
--=20
2.7.4

