Return-Path: <SRS0=+bZT=NF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9509AECDE47
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Oct 2018 21:11:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E4272083E
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Oct 2018 21:11:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="2iwM7uFU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4E4272083E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbeJZFpW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Oct 2018 01:45:22 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:49536 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726556AbeJZFpV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Oct 2018 01:45:21 -0400
X-IronPort-AV: E=Sophos;i="5.54,425,1534834800"; 
   d="scan'208";a="22149269"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 25 Oct 2018 14:11:03 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.49) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 25 Oct 2018 14:11:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=id8ls3nfVSG+4D+/MZmq6XcxFF+3JXFRsWnLRDkjRLY=;
 b=2iwM7uFUK+SKCIhVZfzwZ7cmCK42lel3AOVmtUxnXXz6jru1zmZOZOwjr5g4nYrhIb/0c1MkHyz28cvLTBfngor6re2i0HZpFYIbplaKl21ymQwkBBAz81pb/EtE7SOvcE/aNWPwEkSkKBDjoXVzYFpNgtbUGhK6y9DaNbYID2A=
Received: from DM2PR11MB0255.namprd11.prod.outlook.com (10.160.135.27) by
 DM2PR11MB0350.namprd11.prod.outlook.com (10.160.136.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1273.18; Thu, 25 Oct 2018 21:11:01 +0000
Received: from DM2PR11MB0255.namprd11.prod.outlook.com
 ([fe80::5cab:d918:f310:6f0e]) by DM2PR11MB0255.namprd11.prod.outlook.com
 ([fe80::5cab:d918:f310:6f0e%10]) with mapi id 15.20.1250.028; Thu, 25 Oct
 2018 21:11:01 +0000
From:   <Adham.Abozaeid@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Ganesh.Krishna@microchip.com>, <Venkateswara.Kaja@microchip.com>,
        <Aditya.Shankar@microchip.com>, <Sripad.Balwadgi@microchip.com>,
        <Mrutyunjaya.Satapathy@microchip.com>, <johannes@sipsolutions.net>,
        <Adham.Abozaeid@microchip.com>
Subject: [PATCH 2/4] stagign: wilc1000: validate cfg parameters before
 scheduling the work
Thread-Topic: [PATCH 2/4] stagign: wilc1000: validate cfg parameters before
 scheduling the work
Thread-Index: AQHUbKc6eLOkXRU1kU6WoAUOYekHJg==
Date:   Thu, 25 Oct 2018 21:11:00 +0000
Message-ID: <20181025210849.20006-3-adham.abozaeid@microchip.com>
References: <20181025210849.20006-1-adham.abozaeid@microchip.com>
In-Reply-To: <20181025210849.20006-1-adham.abozaeid@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.175.253.81]
x-clientproxiedby: BYAPR02CA0030.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::43) To DM2PR11MB0255.namprd11.prod.outlook.com
 (2a01:111:e400:3c24::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Adham.Abozaeid@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM2PR11MB0350;6:4gC59Ifm0NBecMf4N7I5i6/WtT46nF0U6wYFvvoYTzE2I6X+nFh2XZ4Yvxp3CPz4BjLrx6EDLHD808yTqlHt56TFDE5tduFQ2xcLhTGEci/m764POwg4FMxCG6hVQNPfwOM9ropc4e3dPj8rTRm4xrFjYNoDqJ/gy6estvcGWk2hvNIF5npZuGGhBwJ6xypahXxUKWPK3RFUGUDjxkyg/tkKxM7mI83rbdGSjwr4WTL8Hzijhk8pYGc2k9VyiPyKSsIJ5hrmpQmEWx5sHGmxWwfrMIa30bxqZ1RleFq9s/IBk1fEIVJuCnWq2M7A9xRAAAh6+2YEMnFs4j3LKbprEqQZef9S6Z7S6AWVjqPCdzX4+v+mod1DofsmFcjv2yRJ5eMPdEoO5Rbm6EUdSHcRHNal4d0h8+02bQO/IRHnhOp1ddvCy50rTEXHNjUZWrp+pOTwZ/4nw8SY61i4syFW9w==;5:LnNglF9zOoQnUhAI0jECNDvKyih/1j6nAtUZlI8tB524hVxvO+OPZipUPfTuSXn4LUDgMoH9D9rOj0tD36B0jtHmk1/nt4LdJ7X1jbzCBxKLBR9FrXOsMhVrJ8cHoQIHlwGlTeinaSRhPVHQkG/QgKYEH/lK67t9FkVbZEb6Rgw=;7:StO9+1HjdH7oV+kQkhG5Ar00tKiJfNuageoYRMQtbm/E9z2hrkC7Y/Q8jUpsTKt6aN0IQqMgKF5OCG4ZXtYLgH1EuiY5hm6W4na6DC/KXqaqU9PP9Wdy75gGkWZp1GOEZDav/xupD00kowQn6feWGA==
x-ms-office365-filtering-correlation-id: 33d0e0cc-1822-410f-5540-08d63abe5d3a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:DM2PR11MB0350;
x-ms-traffictypediagnostic: DM2PR11MB0350:
x-ld-processed: 3f4057f3-b418-4d4e-ba84-d55b4e897d88,ExtAddr
x-microsoft-antispam-prvs: <DM2PR11MB0350710CFED4948D8A84AE0A8DF70@DM2PR11MB0350.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(3231355)(944501410)(52105095)(3002001)(93006095)(93001095)(10201501046)(148016)(149066)(150057)(6041310)(20161123560045)(20161123564045)(20161123562045)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:DM2PR11MB0350;BCL:0;PCL:0;RULEID:;SRVR:DM2PR11MB0350;
x-forefront-prvs: 083691450C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(366004)(136003)(346002)(39860400002)(376002)(199004)(189003)(386003)(11346002)(6506007)(2900100001)(14444005)(3846002)(6116002)(71200400001)(446003)(68736007)(36756003)(81166006)(5250100002)(81156014)(2906002)(2616005)(476003)(4326008)(71190400001)(1076002)(5660300001)(52116002)(105586002)(86362001)(8676002)(15650500001)(256004)(478600001)(76176011)(66066001)(99286004)(26005)(53936002)(102836004)(6512007)(54906003)(2351001)(2501003)(316002)(25786009)(97736004)(106356001)(72206003)(6436002)(5640700003)(6916009)(14454004)(305945005)(186003)(107886003)(8936002)(6486002)(7736002)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR11MB0350;H:DM2PR11MB0255.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: hpe0o7D1TkKa4oqfdYSr6AZkaDuRO4SZlyfwobjaAgoeOJdM/8kZHEEgObxhlRyQVQlg3zzJzXjxw6dEWczrk0FK7r/Yf14d+cGjqpmZHQBqVGWtVg1yBTUUf91MIezxeUoP0ru0vkvb1nC4+KJahQLSpohZfj/NzCEIkLEazETsp1agGPAmxfv8NlX1YdCMvVs/x/n250wFq4j0wsfrDXC2UCQyYP7t6iinvFUoZnkPxIJQnONax4gzpwnzR0VL9Frru28L+tFigH/XT39rJLz+DoZo/h0KTDmCQrU5BN1LyUKW33wMNLgjjjCQ3DE1sA1o8F8FKIBvSABx+2AbRpno+2993iMFkzHosLVnQZU=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 33d0e0cc-1822-410f-5540-08d63abe5d3a
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2018 21:11:00.7319
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM2PR11MB0350
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

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

