Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A741C43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 18:20:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BA7120855
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 18:20:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="xHzSHmfA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1BA7120855
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728606AbeKJECF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 23:02:05 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:42620 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727961AbeKJECE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 23:02:04 -0500
X-IronPort-AV: E=Sophos;i="5.54,484,1534834800"; 
   d="scan'208";a="20925195"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 09 Nov 2018 11:20:20 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.106) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Fri, 9 Nov 2018 11:20:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+3gTE5JQhB7vSm5YzqT3HNKg3Twpa62QwIHOEqiGGOc=;
 b=xHzSHmfAPEBYLMuXS2laZ2elL+k+lCq7V5SR3kpe86bpgJnNqnTchv0VzkLhIHMi+p03CIFKQyWeE34To1jJGpumqQjPTsMuFlP4M1tteBiEm1/7DeAR4r6jVPvVJR9hSu+VkchdYxduEh2tiaN4MIIEH/kdqNyEHpsgGz+XWrI=
Received: from SN6PR11MB3407.namprd11.prod.outlook.com (52.135.111.96) by
 SN6PR11MB3392.namprd11.prod.outlook.com (52.135.111.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.26; Fri, 9 Nov 2018 18:20:15 +0000
Received: from SN6PR11MB3407.namprd11.prod.outlook.com
 ([fe80::7d22:c5b8:9e2e:2281]) by SN6PR11MB3407.namprd11.prod.outlook.com
 ([fe80::7d22:c5b8:9e2e:2281%2]) with mapi id 15.20.1294.034; Fri, 9 Nov 2018
 18:20:15 +0000
From:   <Adham.Abozaeid@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Ganesh.Krishna@microchip.com>, <Aditya.Shankar@microchip.com>,
        <johannes@sipsolutions.net>
Subject: [PATCH v5 1/3] staging: wilc1000: validate cfg parameters before
 scheduling the work
Thread-Topic: [PATCH v5 1/3] staging: wilc1000: validate cfg parameters before
 scheduling the work
Thread-Index: AQHUeFjcb7oe3q8UC0Sr223yHpSU2A==
Date:   Fri, 9 Nov 2018 18:20:15 +0000
Message-ID: <20181109182008.4328-2-adham.abozaeid@microchip.com>
References: <20181109182008.4328-1-adham.abozaeid@microchip.com>
In-Reply-To: <20181109182008.4328-1-adham.abozaeid@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.175.253.81]
x-clientproxiedby: BYAPR02CA0011.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::24) To SN6PR11MB3407.namprd11.prod.outlook.com
 (2603:10b6:805:bd::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Adham.Abozaeid@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;SN6PR11MB3392;6:FTnRtE7cJm3EKPY5v+71ZKYNk4A96RmE7XXZReWymIBLbVPDrtkh8/oZOFWQhSiQ2B8B2OZ4CqjyhtNuyCH4t6x6riNxSEqYPqIAmImKm1yM3sGTI8+pDl5eCNE2pZrdBnc4qS3EkORp34p9tUOmO+/ZzBPNzSprZhI3taZsi3r90vb/3ylVUuER3YGsGiQMjEjLAp1SB+smS9b2JhK+MvHmplVnEb6TNOE8VDcoGwTvXZbsTnukCzPQsIXuZtCvlXWDT/PouU2exV9H99jJtdfodPCC++knSBNTM/NZ2lRDQzXQXM77tPg2PtjqM8NGqfTN4dHl0sr42AwlZsdg7hv0o1X8yBOE5IbMpRk1V/IWhY7yFpsv+PjxWNzvsSvh9xkCf/wenrXF1s+qdMDCbEC6Lr9np+ALU+goB96MIIBzecs9iFtcaveee+jh28NBNzLr80o2Ph2j7ZK9WBnWlA==;5:gX+h3aoWuVbK4mVDcvJ5ENIBvVPb7YR/Y42lvYBH95H+/Eylv1o9dcHxfteK6geBHgzes7WkOPlC/AFuCwyOmRLaCQe2WU2riPp36UuWEKlu31I9SouNHvNwnF9o3owkx83X5GwlTp3Wl+mxmBKYOpEBwb3gXe7AEjM3plCISsw=;7:yy+DFBVrPpauUKhR57/UBbYHDLHrKPajh7N12O/23vAcw8NCYAKgMGkJI9QVlBzZ5S+pBq25EOff2TxAb4owORy/OcRIPodAyMiko1SANeso8jOFfil3FO+Bch2YLfhBHSan5MULy0uF4L1mJ5qBKw==
x-ms-office365-filtering-correlation-id: d4753bc3-cc64-413b-02f4-08d6466fff36
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:SN6PR11MB3392;
x-ms-traffictypediagnostic: SN6PR11MB3392:
x-microsoft-antispam-prvs: <SN6PR11MB3392F9B73E19A6968EE734278DC60@SN6PR11MB3392.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(93006095)(93001095)(10201501046)(3002001)(3231382)(944501410)(52105095)(148016)(149066)(150057)(6041310)(20161123564045)(20161123562045)(20161123558120)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:SN6PR11MB3392;BCL:0;PCL:0;RULEID:;SRVR:SN6PR11MB3392;
x-forefront-prvs: 08512C5403
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(396003)(346002)(376002)(39860400002)(199004)(189003)(14454004)(5640700003)(6436002)(386003)(52116002)(102836004)(76176011)(14444005)(53936002)(256004)(2900100001)(81166006)(2351001)(6512007)(81156014)(6506007)(4326008)(72206003)(36756003)(25786009)(6486002)(8936002)(8676002)(71200400001)(478600001)(68736007)(2906002)(1076002)(86362001)(5660300001)(6116002)(6916009)(3846002)(71190400001)(66066001)(476003)(2616005)(105586002)(11346002)(446003)(26005)(106356001)(99286004)(486006)(15650500001)(305945005)(54906003)(2501003)(316002)(97736004)(186003)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR11MB3392;H:SN6PR11MB3407.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: +YWHwKzm0vM7Zrfg3nGfmH69GrGI6R0QHru8taDI3qBkKZKq2U5Og5UkGcdvZjPWB0CTw0FHe+9tvjc8kLqYpQM5gumxMQeWbOdx07hFW7OCCbM8j49zKHkJVgZIWbqaRTRqSq/rdJuhqsWA1HhAt3JmNDwOf02EWYOhokIYjHNL9fcs6u7qIJCnoX0D+hAg174Z1K53BtvMojyvAwWYert6MeG3VrQC2FDPKLraRRjiwIxxyDERoobxP/UCSSg4G9lqNIqWHcU/IJ3zhJDrGYAKjPHJVBsJ14m/ZJMSQykOKL2ygirpBZlM+cHTbQn4/zMYR+YpmqHMFBLji3lPZuLgfZ5ta+1hBnpsqUZfQgI=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d4753bc3-cc64-413b-02f4-08d6466fff36
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2018 18:20:15.8266
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3392
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Adham Abozaeid <adham.abozaeid@microchip.com>

Validate cfg parameters after being called by cfg80211 in set_wiphy_params
before scheduling the work executed in handle_cfg_param

Signed-off-by: Adham Abozaeid <adham.abozaeid@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c     | 61 ++++++-------------
 .../staging/wilc1000/wilc_wfi_cfgoperations.c | 32 ++++++++--
 2 files changed, 48 insertions(+), 45 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index b89116c57064..c1215c194907 100644
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
index 4fbbbbd5a64b..a6f4fad43bf7 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1149,21 +1149,45 @@ static int set_wiphy_params(struct wiphy *wiphy, u3=
2 changed)
 	cfg_param_val.flag =3D 0;
=20
 	if (changed & WIPHY_PARAM_RETRY_SHORT) {
+		netdev_dbg(vif->ndev,
+			   "Setting WIPHY_PARAM_RETRY_SHORT %d\n",
+			   wiphy->retry_short);
 		cfg_param_val.flag  |=3D RETRY_SHORT;
 		cfg_param_val.short_retry_limit =3D wiphy->retry_short;
 	}
 	if (changed & WIPHY_PARAM_RETRY_LONG) {
+		netdev_dbg(vif->ndev,
+			   "Setting WIPHY_PARAM_RETRY_LONG %d\n",
+			   wiphy->retry_long);
 		cfg_param_val.flag |=3D RETRY_LONG;
 		cfg_param_val.long_retry_limit =3D wiphy->retry_long;
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

