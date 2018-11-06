Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A721C0044C
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 00:01:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 133812083D
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 00:01:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="psXnVsYX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 133812083D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbeKFJXk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 04:23:40 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:41791 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726680AbeKFJXk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 04:23:40 -0500
X-IronPort-AV: E=Sophos;i="5.54,469,1534834800"; 
   d="scan'208";a="22705233"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 05 Nov 2018 17:01:22 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.106) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Mon, 5 Nov 2018 17:01:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=89qkqBNoNN1aBsHPSP5V/3uuQKwj9TczfbC6RIkgfUo=;
 b=psXnVsYX9Xo6EU7mOZqZ2Gp4RqRBCqpPIMjT9S2SAvdRJg7ri2bsY+fivJMJBarHyOj4uVgbz/mhojVM6noK4RLjMdZoeYRPyKHi34lO3Q/m1Vf5dzW70023gs2fAMxp/o7NwQJ4Y5twVKAzIs4+lyIpkTM1q07rI7skHKrvSRs=
Received: from SN6PR11MB3407.namprd11.prod.outlook.com (52.135.111.96) by
 SN6PR11MB2639.namprd11.prod.outlook.com (52.135.91.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.26; Tue, 6 Nov 2018 00:01:18 +0000
Received: from SN6PR11MB3407.namprd11.prod.outlook.com
 ([fe80::a1c0:26cf:6e24:2feb]) by SN6PR11MB3407.namprd11.prod.outlook.com
 ([fe80::a1c0:26cf:6e24:2feb%2]) with mapi id 15.20.1250.028; Tue, 6 Nov 2018
 00:01:18 +0000
From:   <Adham.Abozaeid@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Ganesh.Krishna@microchip.com>, <Aditya.Shankar@microchip.com>,
        <johannes@sipsolutions.net>
Subject: [PATCH v3 2/4] staging: wilc1000: validate cfg parameters before
 scheduling the work
Thread-Topic: [PATCH v3 2/4] staging: wilc1000: validate cfg parameters before
 scheduling the work
Thread-Index: AQHUdWPXxcun4ZLEiEWHqfumlI+XRQ==
Date:   Tue, 6 Nov 2018 00:01:18 +0000
Message-ID: <20181106000109.6178-3-adham.abozaeid@microchip.com>
References: <20181106000109.6178-1-adham.abozaeid@microchip.com>
In-Reply-To: <20181106000109.6178-1-adham.abozaeid@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.175.253.81]
x-clientproxiedby: BYAPR11CA0084.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::25) To SN6PR11MB3407.namprd11.prod.outlook.com
 (2603:10b6:805:bd::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Adham.Abozaeid@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;SN6PR11MB2639;6:Gpm3RMUriaYL0qaqn0R660JTg0VFaugfYHpRLCopkZdxDmeBcI6WWFp0SHDkui+Zo24845SFxEh0FJ/ggjhExvqTBkdtnHejreQxQGj/cYCLy2SjM454kbnupeA4mF/LI+iC0MWuZdErs3bRMpHlly4B9G9RDY9BSPLo33rZFQ02Yb1UdmvCNBxENRqpV02k/sC7dA7Juv/jCQI2baJwUyG+wGKdihzmSykUOV1Fh/i3/DW+vuyhchxrwu79q/IuWpsws0Mo5O6W5ZkrZpexWxEwzB/Xe5bbgUfESRLBtLNcWHYbtUE0QjWUlshfphKskzOAtJuMfkWkDB2/Xgcp2Nm6iv5HKOf8wJgy7qqPgv4DlZqyI3R8KGs2uUdU7LrKn7kUjalxaDNAMEjPaYzlsLwlSPdCmgOeR16oSE6mRrQTYsSJUYQc7zJj88ITlu3dxk4LsVur0tbxnph9Ny74WQ==;5:/vPKJaP+diAy7cRzc+wX8FJJuDK1y2BMqF15AGk8dbe9yRg9AUb4BjKNFBJlyHkWfTOsQqdQliaQ5VFEa+gj7hkE36KuVUi92Y86GRvRS9Y5QSFMDZIdOSe7KFsQdvXwX91Oj6OETVd4+GBIYUylbmNB3yODmk1p5WDUv7CXDvI=;7:uhHrWlUjgvJ8Njr3ixzsJLEnzluoDMBPX60Q6F9zhI5iCL6Aum86OWBDFeFtaDadCq+184I4aaHPj71lIVCaY7M0U+1nXfEQziTxYzgaDzgAjAF8AfcSfroh4yh45pMDEV0qTkCUejj9AdNNsxPodw==
x-ms-office365-filtering-correlation-id: 5880cf0e-7982-4857-65b0-08d6437af9ef
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:SN6PR11MB2639;
x-ms-traffictypediagnostic: SN6PR11MB2639:
x-microsoft-antispam-prvs: <SN6PR11MB2639C7414D96943885D9F4908DCB0@SN6PR11MB2639.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3231382)(944501410)(52105095)(93006095)(93001095)(3002001)(10201501046)(148016)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123560045)(20161123564045)(20161123558120)(20161123562045)(201708071742011)(7699051)(76991095);SRVR:SN6PR11MB2639;BCL:0;PCL:0;RULEID:;SRVR:SN6PR11MB2639;
x-forefront-prvs: 0848C1A6AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(396003)(39860400002)(346002)(366004)(136003)(189003)(199004)(99286004)(1076002)(3846002)(6116002)(8676002)(6486002)(6436002)(36756003)(86362001)(5640700003)(316002)(54906003)(6506007)(5660300001)(76176011)(72206003)(71190400001)(6916009)(52116002)(386003)(71200400001)(15650500001)(53936002)(6512007)(81156014)(81166006)(8936002)(14454004)(2906002)(256004)(68736007)(66066001)(14444005)(486006)(4326008)(478600001)(102836004)(2501003)(186003)(26005)(305945005)(2351001)(11346002)(7736002)(2616005)(446003)(106356001)(105586002)(2900100001)(25786009)(97736004)(476003);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR11MB2639;H:SN6PR11MB3407.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: hNqpMKHwIyN16a6AiioNe+yPZ+T0Q8S1dqE3sYtgSbJiTlGG8wSjtglQLMscxUB7FlRwle7mkmUZzl8ZhH0XlZm6LdIV4uqHzKYXKZuZnrYy4YnGk0nhOqQVVwuIyF0dHTsOzAJc3OF/xW8F0b384iSVoIzhgnx6kqxM4KwWXOA5cmBfoy8XI0NktZfJXS4Cs84Z4+ApU9GJTRMPPqjzpJPefqKSrvS6oQcIy9phZWKMGegkmvUR0eYY17MzSwJtOPE3489AeSbtkcXXxP653xbUkANPCIeEAxbUHPaxATUiTM/fdHLYs8hNbqGh+HW/C3XNar7vE2Tn+Tu2zW0z7X3AVv4JyU2Chpl4IKrzvj4=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5880cf0e-7982-4857-65b0-08d6437af9ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2018 00:01:18.1343
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2639
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
index 4fbbbbd5a64b..26bb78a49d81 100644
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

