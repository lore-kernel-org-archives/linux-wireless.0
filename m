Return-Path: <SRS0=qkCK=NK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50F3AECDE44
	for <linux-wireless@archiver.kernel.org>; Tue, 30 Oct 2018 04:23:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03EA12082D
	for <linux-wireless@archiver.kernel.org>; Tue, 30 Oct 2018 04:23:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="To+pJETE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 03EA12082D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbeJ3NOu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 30 Oct 2018 09:14:50 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:45172 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbeJ3NOu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Oct 2018 09:14:50 -0400
X-IronPort-AV: E=Sophos;i="5.54,442,1534834800"; 
   d="scan'208";a="22350499"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 29 Oct 2018 21:23:01 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.38) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Mon, 29 Oct 2018 21:23:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mDXsjNAsL7V85S8orWdBWIwEspqBZ8ccv6dlkoOIHpc=;
 b=To+pJETE+jPJieEDoTGnHpijn4b/MNrA6C8hDYl9Vqd5/vVjTMoUq+AtdIAkVGStQKKkiUhY4IoWUyhBWiyaI1+NW8cX9EXoujNyOf4Ucq1uIHfuAgOTBvJ9AFysWfr1wjHXDmFcMO/N0BPKkZfL7Kswv9e2qc70lHIsyKxZcj8=
Received: from DM2PR11MB0255.namprd11.prod.outlook.com (10.160.135.27) by
 DM2PR11MB0256.namprd11.prod.outlook.com (10.160.136.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1250.30; Tue, 30 Oct 2018 04:22:57 +0000
Received: from DM2PR11MB0255.namprd11.prod.outlook.com
 ([fe80::5cab:d918:f310:6f0e]) by DM2PR11MB0255.namprd11.prod.outlook.com
 ([fe80::5cab:d918:f310:6f0e%10]) with mapi id 15.20.1250.034; Tue, 30 Oct
 2018 04:22:57 +0000
From:   <Adham.Abozaeid@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Ganesh.Krishna@microchip.com>, <Aditya.Shankar@microchip.com>,
        <Sripad.Balwadgi@microchip.com>,
        <Mrutyunjaya.Satapathy@microchip.com>, <johannes@sipsolutions.net>
Subject: [PATCH v2 2/4] staging: wilc1000: validate cfg parameters before
 scheduling the work
Thread-Topic: [PATCH v2 2/4] staging: wilc1000: validate cfg parameters before
 scheduling the work
Thread-Index: AQHUcAg8FHYkGNpTbUGH58Q5DXqKFg==
Date:   Tue, 30 Oct 2018 04:22:57 +0000
Message-ID: <20181030042243.2153-3-adham.abozaeid@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;DM2PR11MB0256;6:JCgWJTDakfdgEcPFT5xCR9XV7YVoTep6FxaL3kOeYaZ0CKzZMXMEmhiXf5J2CiPybA2UQvjgt0j99NCXc8mhVMg1hYpxIqP3FK++DU97G5prCrxMWr65z9jRVP+c5cjpPJfbi/4DpDKtFrq47xTDY5STqf8glAfnf3/I734R5zq5ocdq7F9G0qsC/5GYxpydEtBeehDo5ed0TQPf3IQ+tIDNYpmE37STr30BNMUve/cgYNf3lEGEgzemCUKMe1eQAnNVPhvMoq93ni/d4HRi03UEqyrjIQn/hOQD+LHmanxaslVi4RGoVtOK+9yRsJnzNgCu83EK2fwtvElXJul70WhwtTE6vkN5/BmrNNbdUvW+03jZdTf2Uu1FG3XX0ow8w5VXO/3fBFg9weL0Auh3u/soN3eUpYhS1KKU0OpF/z2aPGnrutQNm6cM3s/qfIjKGK0KoNlgFz7499oM4UZ0bA==;5:+zQGA0Nwv9iwfJXYTetYNW90ohlTrrup3dg2NU0ugE/PdZzLosdKLn1TVfbxGttEDx1pYt1pUtcHYW33KkV7pKYxWUehe3zCjp4+hSUHdQD+z85eh3Y5Q+jlFZUlbROPDRTalnHjPWSLSVZtf4LKR6pGSvSaJ9fgc2ht3YZMKGg=;7:ST8ceS3OPuWzX8zvPW3Mt7dX6y09Rx6ojTHAPZ7/N4VACIw+HeWejO8csojRpkpT1xLcb70Iu9g1Ld2hMyQ1FIqe+cnhI0tnMvfkUzhA11ZEFMiP5+HSShLav5zOHGGXVXBh+dHHVo9PHAIkCfE70HDRdNBNupW8cUakIo9DsSi3do9zm4qVp+aKdtpmcVokrd3YOE9GiESj/7RkHq+og881l7a+Tj0rDSIReJ8i0H1e8+7T4Xueje4lrlTmn05J
x-ms-office365-filtering-correlation-id: dae7dbe8-5ff7-4eff-6d94-08d63e1f5e5d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:DM2PR11MB0256;
x-ms-traffictypediagnostic: DM2PR11MB0256:
x-ld-processed: 3f4057f3-b418-4d4e-ba84-d55b4e897d88,ExtAddr
x-microsoft-antispam-prvs: <DM2PR11MB0256D05F2FC40B4D36C7D2C98DCC0@DM2PR11MB0256.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(10201501046)(3002001)(93006095)(93001095)(3231382)(944501410)(52105095)(148016)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(20161123562045)(20161123564045)(20161123560045)(201708071742011)(7699051)(76991095);SRVR:DM2PR11MB0256;BCL:0;PCL:0;RULEID:;SRVR:DM2PR11MB0256;
x-forefront-prvs: 08417837C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39860400002)(136003)(366004)(376002)(396003)(189003)(199004)(5660300001)(36756003)(106356001)(14454004)(6486002)(105586002)(72206003)(71200400001)(2351001)(71190400001)(186003)(66066001)(6916009)(446003)(15650500001)(3846002)(81156014)(8676002)(6116002)(1076002)(6512007)(81166006)(99286004)(5640700003)(26005)(97736004)(386003)(11346002)(476003)(6506007)(2900100001)(5250100002)(8936002)(25786009)(53936002)(486006)(102836004)(4326008)(54906003)(478600001)(86362001)(305945005)(68736007)(6436002)(316002)(52116002)(256004)(76176011)(14444005)(7736002)(2906002)(2501003)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR11MB0256;H:DM2PR11MB0255.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 9Wr835LM6z4J8dMH+njEiFWHe7P9mtbfxGQnRXsDkrrJfzxLGmGP8ScCC4JZFMbBtGpbreb5T+dReyRv4r3ZgUznXqv+QhT9ggPVJPicN1M2Ji8Yd5DTdeRaiRjz1DnUQNuE7mC9R5owmTcPeIVTvbIh5T9xoe/GQlFYmb4dB70PrMjhowHLbiIu6vDFFmPgSM7Ad506YWgOfajahEI43YeXKm4WUt480xB5ySUtFY9dc/buMFqY9IxLM+qmhzV4cubpPfCsvywUIOZ0ApHh/Lf1YQNGNmqA/yoY7y9Umuq6plmX5/c9nEU+0hx0Kr56WwJ6MmEFEsaaDA1J4K1uoIC+Ow0vyErILxe1dmTVois=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: dae7dbe8-5ff7-4eff-6d94-08d63e1f5e5d
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2018 04:22:57.2016
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

Validate cfg parameters after being called by cfg80211 in set_wiphy_params
before scheduling the work executed in handle_cfg_param

Signed-off-by: Adham Abozaeid <adham.abozaeid@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c     | 61 ++++++-------------
 .../staging/wilc1000/wilc_wfi_cfgoperations.c | 50 ++++++++++++---
 2 files changed, 62 insertions(+), 49 deletions(-)
 mode change 100644 =3D> 100755 drivers/staging/wilc1000/wilc_wfi_cfgoperat=
ions.c

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index 1a1ac5e936a7..0bb3b4f6d04e 100755
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -377,61 +377,41 @@ static void handle_cfg_param(struct work_struct *work=
)
 	if (param->flag & RETRY_SHORT) {
 		u16 retry_limit =3D param->short_retry_limit;
=20
-		if (retry_limit > 0 && retry_limit < 256) {
-			wid_list[i].id =3D WID_SHORT_RETRY_LIMIT;
-			wid_list[i].val =3D (s8 *)&param->short_retry_limit;
-			wid_list[i].type =3D WID_SHORT;
-			wid_list[i].size =3D sizeof(u16);
-			hif_drv->cfg_values.short_retry_limit =3D retry_limit;
-		} else {
-			netdev_err(vif->ndev, "Range(1~256) over\n");
-			goto unlock;
-		}
+		wid_list[i].id =3D WID_SHORT_RETRY_LIMIT;
+		wid_list[i].val =3D (s8 *)&param->short_retry_limit;
+		wid_list[i].type =3D WID_SHORT;
+		wid_list[i].size =3D sizeof(u16);
+		hif_drv->cfg_values.short_retry_limit =3D retry_limit;
 		i++;
 	}
 	if (param->flag & RETRY_LONG) {
 		u16 limit =3D param->long_retry_limit;
=20
-		if (limit > 0 && limit < 256) {
-			wid_list[i].id =3D WID_LONG_RETRY_LIMIT;
-			wid_list[i].val =3D (s8 *)&param->long_retry_limit;
-			wid_list[i].type =3D WID_SHORT;
-			wid_list[i].size =3D sizeof(u16);
-			hif_drv->cfg_values.long_retry_limit =3D limit;
-		} else {
-			netdev_err(vif->ndev, "Range(1~256) over\n");
-			goto unlock;
-		}
+		wid_list[i].id =3D WID_LONG_RETRY_LIMIT;
+		wid_list[i].val =3D (s8 *)&param->long_retry_limit;
+		wid_list[i].type =3D WID_SHORT;
+		wid_list[i].size =3D sizeof(u16);
+		hif_drv->cfg_values.long_retry_limit =3D limit;
 		i++;
 	}
 	if (param->flag & FRAG_THRESHOLD) {
 		u16 frag_th =3D param->frag_threshold;
=20
-		if (frag_th > 255 && frag_th < 7937) {
-			wid_list[i].id =3D WID_FRAG_THRESHOLD;
-			wid_list[i].val =3D (s8 *)&param->frag_threshold;
-			wid_list[i].type =3D WID_SHORT;
-			wid_list[i].size =3D sizeof(u16);
-			hif_drv->cfg_values.frag_threshold =3D frag_th;
-		} else {
-			netdev_err(vif->ndev, "Threshold Range fail\n");
-			goto unlock;
-		}
+		wid_list[i].id =3D WID_FRAG_THRESHOLD;
+		wid_list[i].val =3D (s8 *)&param->frag_threshold;
+		wid_list[i].type =3D WID_SHORT;
+		wid_list[i].size =3D sizeof(u16);
+		hif_drv->cfg_values.frag_threshold =3D frag_th;
 		i++;
 	}
 	if (param->flag & RTS_THRESHOLD) {
 		u16 rts_th =3D param->rts_threshold;
=20
-		if (rts_th > 255) {
-			wid_list[i].id =3D WID_RTS_THRESHOLD;
-			wid_list[i].val =3D (s8 *)&param->rts_threshold;
-			wid_list[i].type =3D WID_SHORT;
-			wid_list[i].size =3D sizeof(u16);
-			hif_drv->cfg_values.rts_threshold =3D rts_th;
-		} else {
-			netdev_err(vif->ndev, "Threshold Range fail\n");
-			goto unlock;
-		}
+		wid_list[i].id =3D WID_RTS_THRESHOLD;
+		wid_list[i].val =3D (s8 *)&param->rts_threshold;
+		wid_list[i].type =3D WID_SHORT;
+		wid_list[i].size =3D sizeof(u16);
+		hif_drv->cfg_values.rts_threshold =3D rts_th;
 		i++;
 	}
=20
@@ -441,7 +421,6 @@ static void handle_cfg_param(struct work_struct *work)
 	if (ret)
 		netdev_err(vif->ndev, "Error in setting CFG params\n");
=20
-unlock:
 	mutex_unlock(&hif_drv->cfg_values_lock);
 	kfree(msg);
 }
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/st=
aging/wilc1000/wilc_wfi_cfgoperations.c
old mode 100644
new mode 100755
index 4fbbbbd5a64b..26bb78a49d81
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1149,21 +1149,55 @@ static int set_wiphy_params(struct wiphy *wiphy, u3=
2 changed)
 	cfg_param_val.flag =3D 0;
=20
 	if (changed & WIPHY_PARAM_RETRY_SHORT) {
-		cfg_param_val.flag  |=3D RETRY_SHORT;
-		cfg_param_val.short_retry_limit =3D wiphy->retry_short;
+		if (wiphy->retry_short > 0 && wiphy->retry_short < 256) {
+			netdev_dbg(vif->ndev,
+				   "Setting WIPHY_PARAM_RETRY_SHORT %d\n",
+				   wiphy->retry_short);
+			cfg_param_val.flag  |=3D RETRY_SHORT;
+			cfg_param_val.short_retry_limit =3D wiphy->retry_short;
+		} else {
+			netdev_err(vif->ndev, "Short retry limit out of range\n");
+			return -EINVAL;
+		}
 	}
 	if (changed & WIPHY_PARAM_RETRY_LONG) {
-		cfg_param_val.flag |=3D RETRY_LONG;
-		cfg_param_val.long_retry_limit =3D wiphy->retry_long;
+		if (wiphy->retry_long > 0 && wiphy->retry_long < 256) {
+			netdev_dbg(vif->ndev,
+				   "Setting WIPHY_PARAM_RETRY_LONG %d\n",
+				   wiphy->retry_long);
+			cfg_param_val.flag |=3D RETRY_LONG;
+			cfg_param_val.long_retry_limit =3D wiphy->retry_long;
+		} else {
+			netdev_err(vif->ndev, "Long retry limit out of range\n");
+			return -EINVAL;
+		}
 	}
 	if (changed & WIPHY_PARAM_FRAG_THRESHOLD) {
-		cfg_param_val.flag |=3D FRAG_THRESHOLD;
-		cfg_param_val.frag_threshold =3D wiphy->frag_threshold;
+		if (wiphy->frag_threshold > 255 &&
+		    wiphy->frag_threshold < 7937) {
+			netdev_dbg(vif->ndev,
+				   "Setting WIPHY_PARAM_FRAG_THRESHOLD %d\n",
+				   wiphy->frag_threshold);
+			cfg_param_val.flag |=3D FRAG_THRESHOLD;
+			cfg_param_val.frag_threshold =3D wiphy->frag_threshold;
+		} else {
+			netdev_err(vif->ndev,
+				   "Fragmentation threshold out of range\n");
+			return -EINVAL;
+		}
 	}
=20
 	if (changed & WIPHY_PARAM_RTS_THRESHOLD) {
-		cfg_param_val.flag |=3D RTS_THRESHOLD;
-		cfg_param_val.rts_threshold =3D wiphy->rts_threshold;
+		if (wiphy->rts_threshold > 255) {
+			netdev_dbg(vif->ndev,
+				   "Setting WIPHY_PARAM_RTS_THRESHOLD %d\n",
+				   wiphy->rts_threshold);
+			cfg_param_val.flag |=3D RTS_THRESHOLD;
+			cfg_param_val.rts_threshold =3D wiphy->rts_threshold;
+		} else {
+			netdev_err(vif->ndev, "RTS threshold out of range\n");
+			return -EINVAL;
+		}
 	}
=20
 	ret =3D wilc_hif_set_cfg(vif, &cfg_param_val);
--=20
2.17.1

