Return-Path: <SRS0=/7yp=NT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BEF4ECDE4B
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 21:50:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3765D2081C
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 21:50:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="l6T/FBfV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3765D2081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbeKIH1x (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 02:27:53 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:2002 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbeKIH1x (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 02:27:53 -0500
X-IronPort-AV: E=Sophos;i="5.54,480,1534834800"; 
   d="scan'208";a="22879527"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES128-SHA; 08 Nov 2018 14:50:27 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.37) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 8 Nov 2018 14:50:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lEhbYjPu1w3y79Lc8Hi9WLBo8mJODf0/K0v5NvbLAtc=;
 b=l6T/FBfVouxU6knmeGiNlQ9f/BuZGvpL1CdsA8gk5bC/QTLvw0AKYEHFiaYAy8o1OjUpMJE39Oi4cKhguKHyrL7fcn1wUxL43xCi9lxlciPd65FSIAkzVZV9jmlSmWFfT5N7U31+ZJVCEgnbg134MpcPQV0smAKV1o8C9yBB6xY=
Received: from SN6PR11MB3407.namprd11.prod.outlook.com (52.135.111.96) by
 SN6PR11MB3488.namprd11.prod.outlook.com (52.135.112.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.30; Thu, 8 Nov 2018 21:50:25 +0000
Received: from SN6PR11MB3407.namprd11.prod.outlook.com
 ([fe80::7d22:c5b8:9e2e:2281]) by SN6PR11MB3407.namprd11.prod.outlook.com
 ([fe80::7d22:c5b8:9e2e:2281%2]) with mapi id 15.20.1294.034; Thu, 8 Nov 2018
 21:50:25 +0000
From:   <Adham.Abozaeid@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Ganesh.Krishna@microchip.com>, <Aditya.Shankar@microchip.com>,
        <johannes@sipsolutions.net>, <adham.abozaeid@micochip.com>
Subject: [PATCH v4 1/3] staging: wilc1000: validate cfg parameters before
 scheduling the work
Thread-Topic: [PATCH v4 1/3] staging: wilc1000: validate cfg parameters before
 scheduling the work
Thread-Index: AQHUd60OPPKaRhG55ECM4r3T1Ef7vA==
Date:   Thu, 8 Nov 2018 21:50:25 +0000
Message-ID: <20181108214915.3733-2-adham.abozaeid@microchip.com>
References: <20181108214915.3733-1-adham.abozaeid@microchip.com>
In-Reply-To: <20181108214915.3733-1-adham.abozaeid@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.175.253.81]
x-clientproxiedby: BYAPR07CA0013.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::26) To SN6PR11MB3407.namprd11.prod.outlook.com
 (2603:10b6:805:bd::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Adham.Abozaeid@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;SN6PR11MB3488;6:GvAquuirBpQ3WORDLWHxzoLsWbSCsprlgDwOfqe6IaA6necZykdvwZRGabtisbrxjin+d0t4GnmAojM99shbQTz6I9eWQbW9l+uDhXgybERXbhVarn5ANY9kHuQE7vYTXCkog4EoDCulZ+Fc6nY70BHE45Lv6tz7rkxCeoftieHnDz0GSTNbB6+YxelhnmMfYSJkLlEXYQvm0iIkjhV7UNHu99PIakD1bFHLM5S67FSwExYfSZo2oe0LfetyPfkjdcDEA1ql8YXI/r413a6y7zJ8Gb+ZozbZBghCbEjjewoeApM7t0tNI6LI4GbA3TdEFxoJz6jKu2MWmcf0gPjvfLHY0jBhNwnkLm8Ym7TLLjbV8vCPowM16Oltylt7286jSVPT1FKdQn+ldy55c6K4dCnHIAFs1lfWqxYHnEiNJQB0PI/6aKLopdu/qt70Xe/v5NmMsXboV3RfKCx1ke222g==;5:BybZuY0VpkmHpEZQqCzBK/iim75O0XGs++ANCzdb7C/KXVgrxH7XnN8oNpD95Pm3zS1WC30WvNcufhs2jp+ZKVoaw4oAbjSFOza3Lzfmroo//ppusT6GWy5hAzVLO1RyfSZO0wfmPFAd/9uj+bH7Co5qhFNJI4ak7jDpeiyyPPs=;7:4JaLRjARlHaki7RTOFVSB04Em1PiOb5suAUJluxbtgXnVG4ZHGhWYeWqLEr1r3K2ewvCXmDle0vEhJLs4e9Ya/N63ozIVdsqk5X6rB2mKWIttZRCkR/Rf09IGCUaU8Sk0SCNBxxzKbbsfgYbs2UHaw==
x-ms-office365-filtering-correlation-id: 275bca13-4d13-42da-470a-08d645c43097
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:SN6PR11MB3488;
x-ms-traffictypediagnostic: SN6PR11MB3488:
x-microsoft-antispam-prvs: <SN6PR11MB348861641C194EA519AD45888DC50@SN6PR11MB3488.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(10201501046)(3002001)(3231382)(944501410)(52105095)(148016)(149066)(150057)(6041310)(20161123558120)(20161123564045)(20161123562045)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:SN6PR11MB3488;BCL:0;PCL:0;RULEID:;SRVR:SN6PR11MB3488;
x-forefront-prvs: 0850800A29
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(366004)(396003)(39860400002)(136003)(376002)(199004)(189003)(5640700003)(52116002)(76176011)(386003)(6506007)(1076002)(6436002)(14454004)(6486002)(25786009)(7736002)(6916009)(99286004)(305945005)(6512007)(81156014)(81166006)(66066001)(8676002)(186003)(8936002)(478600001)(68736007)(97736004)(26005)(2501003)(5660300001)(53936002)(3846002)(6116002)(102836004)(15650500001)(4326008)(106356001)(71200400001)(71190400001)(476003)(105586002)(2351001)(2616005)(54906003)(316002)(14444005)(486006)(86362001)(256004)(446003)(2906002)(36756003)(72206003)(2900100001)(11346002);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR11MB3488;H:SN6PR11MB3407.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: QcTxEnxN14pJKXrLmHXbatnQ60qPernQyuphnnC4p22WbQ1oE3H+l+ALE/cfmCPRDiFet+3V/Z4G1pIsBsgrR+qZH/3mPRzPRJKtzdDX9jJ9BD+zJAAEeevWSnmTUEvnVrUVzWvkms/ogdW6+SHydqfiIQTSOCrp94Bv/nDdENva7DFgyupW4554er74zxOMFnoWKAlwxYKR+yPoU4ta85vJnrQYoiTiaaMMeC8mYkwYMAyf+2lWODyfxPM6lkfCdC+SjjTL5NhyHo6SApHKw6OhXgbB9jyrYo2pFTAnBTL6WFe2XvA8gXK+GDzMI7Jni5w9G2JcwcPxMv4HM4Vhxegc6azj4T3OH1ubq0Y6hJg=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 275bca13-4d13-42da-470a-08d645c43097
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2018 21:50:25.2818
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3488
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Adham Abozaeid <adham.abozaeid@micochip.com>

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

