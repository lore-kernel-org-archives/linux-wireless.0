Return-Path: <SRS0=qkCK=NK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37661C2BC61
	for <linux-wireless@archiver.kernel.org>; Tue, 30 Oct 2018 04:23:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E98C22082D
	for <linux-wireless@archiver.kernel.org>; Tue, 30 Oct 2018 04:23:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="giO+XjYL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E98C22082D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbeJ3NOv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 30 Oct 2018 09:14:51 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:21644 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbeJ3NOv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Oct 2018 09:14:51 -0400
X-IronPort-AV: E=Sophos;i="5.54,442,1534834800"; 
   d="scan'208";a="22053468"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 29 Oct 2018 21:23:02 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.108) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Mon, 29 Oct 2018 21:23:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TifEg0fRo/Iyy8cHif+IAczPoTHWADUbbfMD0Ku+XRY=;
 b=giO+XjYLTdSno4TuQVoprTQ8Rb9cQRFgnrf6hSmrNiGW1ZtpuZskOKR78z2uy7RkbkgRAmkXmDy28q9v6TTBHJ9v2zbI54fv1WVVkoGKdHXGBql1rTNW+lAiX3z+hTr3qBA+SCTEkfq6r/esCcGP7Y3W/m+CKi7Ywumf+nWlOuY=
Received: from DM2PR11MB0255.namprd11.prod.outlook.com (10.160.135.27) by
 DM2PR11MB0256.namprd11.prod.outlook.com (10.160.136.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1250.30; Tue, 30 Oct 2018 04:22:58 +0000
Received: from DM2PR11MB0255.namprd11.prod.outlook.com
 ([fe80::5cab:d918:f310:6f0e]) by DM2PR11MB0255.namprd11.prod.outlook.com
 ([fe80::5cab:d918:f310:6f0e%10]) with mapi id 15.20.1250.034; Tue, 30 Oct
 2018 04:22:58 +0000
From:   <Adham.Abozaeid@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Ganesh.Krishna@microchip.com>, <Aditya.Shankar@microchip.com>,
        <Sripad.Balwadgi@microchip.com>,
        <Mrutyunjaya.Satapathy@microchip.com>, <johannes@sipsolutions.net>
Subject: [PATCH v2 3/4] staging: wilc1000: Don't keep a copy of wiphy
 parameters in the driver
Thread-Topic: [PATCH v2 3/4] staging: wilc1000: Don't keep a copy of wiphy
 parameters in the driver
Thread-Index: AQHUcAg800/W1Fyg106kOUe0yuf3CQ==
Date:   Tue, 30 Oct 2018 04:22:58 +0000
Message-ID: <20181030042243.2153-4-adham.abozaeid@microchip.com>
References: <20181030042243.2153-1-adham.abozaeid@microchip.com>
In-Reply-To: <20181030042243.2153-1-adham.abozaeid@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.175.253.81]
x-clientproxiedby: BYAPR07CA0025.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::38) To DM2PR11MB0255.namprd11.prod.outlook.com
 (2a01:111:e400:3c24::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Adham.Abozaeid@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM2PR11MB0256;6:1LtwhIgMC/yN3ttciSculWRgTp3ITCPmc5Y5R2co2bzFhg72gYzGZA0eJ43ji053E8I59XNGDc82JBWZDeKibg1rMVFvy9y/K7H3xdyj2Di9mA7v2b/2loBpa4/fFtQo47zOYCBpL0RB+YmL/WJjgTbtXAL+DvMU3a9VBCJPmmHKIEZQauSY+OY/K/ejuZ3WBSHaVKXdbCzU7cPCaUO6XzkKfGXNToone4OIw43KVe2f9/kUMsiqdv1g7pJmH/6e2A/C+/TJdudWrNFJVc76XRziL+hXUf044CELnPSWVSkPxeLZtxdEUmtzvx4m8smCc9IRVEl8bxcE4P+csu0TZ8Zc1qH/kTJapV4f8l13MmG7sSNR8LLZo2bWJuy4iRfwyMISgrGc2ExQ8PsbL9XBouvtauMyuwduVirN9x8zW6sw1SDqzSY/zboxqO52PHyepfWeFJm0ZCvQB+KGMwxhhQ==;5:okaQ+Y2CmyopkNLdUGEDIrXD7vW+9Y2WbPzPQabIq5BZ2YZqLq6FN5bkcqutd04ZM58aCm9jZFEF5LXjYhPE/RBHhwHJyj6SDq8XZmzErK7miKSnBBFpGPFMoZsLn9BKi1UOUiexPWvV5dyXw6ex/Vbf7gcSfBw0heA9xSWV/wc=;7:e0RV5hcGqayqnmcfrYlAoqhpfRR8Ir9IX3e5DNUWKoupdIh0XVrI/7r7fypKcFSu+LHoOK0gUM6BwLrdvHXS8JaN+pCbM8bA30MOyn2Y+0I6XXZG7bRLTHraF+WdW6MZLcqNjTdHewZhkyReCVMere+zHHSYdCaxSXbAKKbnCjcjah3FqrTcN/lyGSbzB1XEzHW381b1YQ0eb8KcaoIJtN0bWhFBhzQZDKEgoHc6zCUe63nRfJlGS4ouVcIipdt2
x-ms-office365-filtering-correlation-id: 0c38ac41-d5c6-43d7-aef4-08d63e1f5f1d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:DM2PR11MB0256;
x-ms-traffictypediagnostic: DM2PR11MB0256:
x-ld-processed: 3f4057f3-b418-4d4e-ba84-d55b4e897d88,ExtAddr
x-microsoft-antispam-prvs: <DM2PR11MB025686E7E4379296E1B5AACE8DCC0@DM2PR11MB0256.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(10201501046)(3002001)(93006095)(93001095)(3231382)(944501410)(52105095)(148016)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(20161123562045)(20161123564045)(20161123560045)(201708071742011)(7699051)(76991095);SRVR:DM2PR11MB0256;BCL:0;PCL:0;RULEID:;SRVR:DM2PR11MB0256;
x-forefront-prvs: 08417837C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39860400002)(136003)(366004)(376002)(396003)(189003)(199004)(5660300001)(36756003)(106356001)(14454004)(6486002)(105586002)(72206003)(71200400001)(2351001)(71190400001)(186003)(66066001)(6916009)(446003)(3846002)(81156014)(8676002)(6116002)(1076002)(6512007)(81166006)(99286004)(5640700003)(26005)(97736004)(386003)(11346002)(476003)(6506007)(2900100001)(5250100002)(8936002)(25786009)(53936002)(486006)(102836004)(4326008)(54906003)(478600001)(86362001)(305945005)(68736007)(6436002)(316002)(52116002)(256004)(76176011)(14444005)(7736002)(2906002)(2501003)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR11MB0256;H:DM2PR11MB0255.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 56xxHJOFTSt1wCt2E8X+wkldZqQHrUWTXiyF4HZXbxjnAPZxN8p0etxNf+6Op/HyRj1e/whsIw3kZzbiCCqIeA98DbkiehvXtvJaUgSiNQlx0IiDIS3k7quNE8baE1KO3WMyfhUsfuMoq6YNu3HzzF5qGSVJSLruYDR62ZVxxwU2NfMU/qxRZX8kU85UsGbmLPjqrKQWSmoaFwgeCCSGepvO+/l2P6BBnLqrqg1XGSdiaGe+XQjftWIeWf/6gSVSNbdPnwUZ1c6XAvAEXseXzUiU/BHBaeEgEhOJ+TvJyPoQKrQGW6T2jPjoPqdYqfq4Hf1ecdz4JkgOYDdn5cVvisfhl5a41UGyRBalBgC0Rhg=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c38ac41-d5c6-43d7-aef4-08d63e1f5f1d
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2018 04:22:58.4186
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM2PR11MB0256
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Adham Abozaeid <adham.abozaeid@micochip.com>

host_if_drv.cfg_values is a write only member, and can be removed

Signed-off-by: Adham Abozaeid <adham.abozaeid@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 13 -------------
 drivers/staging/wilc1000/host_interface.h |  1 -
 2 files changed, 14 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index 0bb3b4f6d04e..cdc495287949 100755
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -375,43 +375,31 @@ static void handle_cfg_param(struct work_struct *work=
)
 	mutex_lock(&hif_drv->cfg_values_lock);
=20
 	if (param->flag & RETRY_SHORT) {
-		u16 retry_limit =3D param->short_retry_limit;
-
 		wid_list[i].id =3D WID_SHORT_RETRY_LIMIT;
 		wid_list[i].val =3D (s8 *)&param->short_retry_limit;
 		wid_list[i].type =3D WID_SHORT;
 		wid_list[i].size =3D sizeof(u16);
-		hif_drv->cfg_values.short_retry_limit =3D retry_limit;
 		i++;
 	}
 	if (param->flag & RETRY_LONG) {
-		u16 limit =3D param->long_retry_limit;
-
 		wid_list[i].id =3D WID_LONG_RETRY_LIMIT;
 		wid_list[i].val =3D (s8 *)&param->long_retry_limit;
 		wid_list[i].type =3D WID_SHORT;
 		wid_list[i].size =3D sizeof(u16);
-		hif_drv->cfg_values.long_retry_limit =3D limit;
 		i++;
 	}
 	if (param->flag & FRAG_THRESHOLD) {
-		u16 frag_th =3D param->frag_threshold;
-
 		wid_list[i].id =3D WID_FRAG_THRESHOLD;
 		wid_list[i].val =3D (s8 *)&param->frag_threshold;
 		wid_list[i].type =3D WID_SHORT;
 		wid_list[i].size =3D sizeof(u16);
-		hif_drv->cfg_values.frag_threshold =3D frag_th;
 		i++;
 	}
 	if (param->flag & RTS_THRESHOLD) {
-		u16 rts_th =3D param->rts_threshold;
-
 		wid_list[i].id =3D WID_RTS_THRESHOLD;
 		wid_list[i].val =3D (s8 *)&param->rts_threshold;
 		wid_list[i].type =3D WID_SHORT;
 		wid_list[i].size =3D sizeof(u16);
-		hif_drv->cfg_values.rts_threshold =3D rts_th;
 		i++;
 	}
=20
@@ -3139,7 +3127,6 @@ int wilc_init(struct net_device *dev, struct host_if_=
drv **hif_drv_handler)
 	mutex_lock(&hif_drv->cfg_values_lock);
=20
 	hif_drv->hif_state =3D HOST_IF_IDLE;
-	hif_drv->cfg_values.scan_source =3D DEFAULT_SCAN;
=20
 	hif_drv->p2p_timeout =3D 0;
=20
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wi=
lc1000/host_interface.h
index 5f894fe7c896..60cb1a1fee1a 100755
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -238,7 +238,6 @@ struct host_if_drv {
 	enum host_if_state hif_state;
=20
 	u8 assoc_bssid[ETH_ALEN];
-	struct cfg_param_attr cfg_values;
 	/*lock to protect concurrent setting of cfg params*/
 	struct mutex cfg_values_lock;
=20
--=20
2.17.1

