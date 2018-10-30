Return-Path: <SRS0=qkCK=NK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AD54C6786F
	for <linux-wireless@archiver.kernel.org>; Tue, 30 Oct 2018 04:23:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5D6120823
	for <linux-wireless@archiver.kernel.org>; Tue, 30 Oct 2018 04:23:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="RaXXEadA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E5D6120823
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726223AbeJ3NOt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 30 Oct 2018 09:14:49 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:41576 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbeJ3NOt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Oct 2018 09:14:49 -0400
X-IronPort-AV: E=Sophos;i="5.54,442,1534834800"; 
   d="scan'208";a="23285776"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 29 Oct 2018 21:23:00 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.38) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Mon, 29 Oct 2018 21:22:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gqylKsKVuvKBvhUNCwLRJTQ+UCGrmmTqXVFD/SL/8q0=;
 b=RaXXEadA4QLf9Tev9USAJYeDucC0BGNN5aWqmTxa86i8KCxNo0kEdzjanCtPhYhKOftE89302t+ulI37mgWF2Yzv2u1Lxym+8C01fDHCnuMvKDMBFM+RMiBSUGIvvzLwxxzMZYI5rjBqs1u+vj414uiKkvWGBvuL4gaL+9dqgLo=
Received: from DM2PR11MB0255.namprd11.prod.outlook.com (10.160.135.27) by
 DM2PR11MB0256.namprd11.prod.outlook.com (10.160.136.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1250.30; Tue, 30 Oct 2018 04:22:56 +0000
Received: from DM2PR11MB0255.namprd11.prod.outlook.com
 ([fe80::5cab:d918:f310:6f0e]) by DM2PR11MB0255.namprd11.prod.outlook.com
 ([fe80::5cab:d918:f310:6f0e%10]) with mapi id 15.20.1250.034; Tue, 30 Oct
 2018 04:22:56 +0000
From:   <Adham.Abozaeid@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Ganesh.Krishna@microchip.com>, <Aditya.Shankar@microchip.com>,
        <Sripad.Balwadgi@microchip.com>,
        <Mrutyunjaya.Satapathy@microchip.com>, <johannes@sipsolutions.net>
Subject: [PATCH v2 1/4] staging: wilc1000: remove unused flags in
 handle_cfg_param()
Thread-Topic: [PATCH v2 1/4] staging: wilc1000: remove unused flags in
 handle_cfg_param()
Thread-Index: AQHUcAg7wLfjcrzavE2b+Y+MVnGcsA==
Date:   Tue, 30 Oct 2018 04:22:55 +0000
Message-ID: <20181030042243.2153-2-adham.abozaeid@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;DM2PR11MB0256;6:oXmI02fjR/EI4pN10ep1HTLd+CeQU+J4SD6cW1/m3VTYpu1EiR57uTaCpxieAHoqL/URY+/WPKKN9P/AN+CvGQnWhh7UlHgadDTBSQF/g5QwwhLGHc6JpuEh2Z2dS9oCZ7J8kS43WCjEvYeeNj3jlYJtcpw1OQanrGKjLfa4FKdvwpnho3LoSZ+d3t24GH6CM4D0M8arCdn80g6Z4vX/JvRASX8AfIOm1ANFk2adAZp0Ubug8efLr6e9AUGmC8t1eWOjtQRBcoHd/M976v2gxF+mDF/tJPK1ClYVV4W7rfkEwyYWt6YwvMhpbPuWhYwSw2H7V1/QWzHJVRGWLEfQV/eJS1yLrd+xyjQs7n4u2i0/Im1lo9ryZUAcQYEla4pVlFS+ntUrDkSavHTY8tU1N48UaMc6yDG6PJ4RzFv9iNYkS0eF+RdWYf07Mv5iPxnhDpilOW20q9RVjoRPSJJ44Q==;5:ybjH0PZp0T9+ovH5+hLiOtVMaig5qrrk1CQnbeYkn+9C8WGJMAIvgVGdNhD3ITvVoeUK0uVIiCeBL0RUH55OwQrH49VEQ9XKSvOJTaMYlBvSzDz6sHJXO7YAHBqb6OC+CnS9eZ4lZ9YQCKPMiEfdxdft8Gn/VFKrk3LmOJcJayI=;7:S04oKp4O1eOSVCnJVqJzlQp/uFjW9lLQjFJTyiRcmxjr8P1+rN+OCzZPc9KGesZVeh58e2aW3Zwyf1wItN3LEnAjsFV5kPy3nTzqb7H1nzMxM5b5V+QwRvkQWv1LSil0koFsw0CdlfjjEVBPEOKGMWnaTEILHxq46A2gBfcWlalC3M1a/wHLwH2MTKq5svUhRe8k/KY6uDzne3RKSPsxkqoB5oIVqebDGUrp9IlHqdWr1x0pjP12Q1eqpuMY/TcV
x-ms-office365-filtering-correlation-id: 82e8a9dc-4056-4f38-f50f-08d63e1f5d71
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:DM2PR11MB0256;
x-ms-traffictypediagnostic: DM2PR11MB0256:
x-ld-processed: 3f4057f3-b418-4d4e-ba84-d55b4e897d88,ExtAddr
x-microsoft-antispam-prvs: <DM2PR11MB0256083CCE0D77CABCA4C0738DCC0@DM2PR11MB0256.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(10201501046)(3002001)(93006095)(93001095)(3231382)(944501410)(52105095)(148016)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(20161123562045)(20161123564045)(20161123560045)(201708071742011)(7699051)(76991095);SRVR:DM2PR11MB0256;BCL:0;PCL:0;RULEID:;SRVR:DM2PR11MB0256;
x-forefront-prvs: 08417837C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39860400002)(136003)(366004)(376002)(396003)(189003)(199004)(5660300001)(36756003)(106356001)(14454004)(6486002)(105586002)(72206003)(71200400001)(2351001)(71190400001)(186003)(4744004)(66066001)(6916009)(446003)(3846002)(81156014)(8676002)(6116002)(1076002)(6512007)(81166006)(99286004)(5640700003)(26005)(97736004)(386003)(11346002)(476003)(6506007)(2900100001)(5250100002)(8936002)(25786009)(53936002)(486006)(102836004)(4326008)(551544002)(54906003)(478600001)(86362001)(305945005)(68736007)(6436002)(316002)(52116002)(256004)(76176011)(14444005)(7736002)(2906002)(2501003)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR11MB0256;H:DM2PR11MB0255.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: QaIqHZ+F+LVy+y76bfeAo5dvElZKC+v/xChTlqg62WINJeEJQaDpy+Qz6S3GfqvUcDG/4seuUBD8m2pjZ5zPBrgsXRFXyYy5Jo8XeI8qsLQzpGX0jiJLswS0M23r6y66aKC0Z+nMgcm97SmW2Lni+TmVD3wWuczwpmsqaKhaHfSb1TkZ6Tu8+k+H79/bZHp/3hBgfgUvOoRYoR6Wg0p2cbFaVkPKLi8f5lqMd5dPP9PAMxFTkvz3XohMC8rsO27q8s2YF8s3mu0yGytQaduOTm6Q2ZU9LuapZPLwTuOTGHx6VYtny1q/Btb/AoMYxBWy7pBdfswVsbfXf3U4DUiK2HvKc99Zl7ouI1qMFd/Cc40=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 82e8a9dc-4056-4f38-f50f-08d63e1f5d71
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2018 04:22:56.0137
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

handle_cfg_param() receives a bit map that describes what to be changed.
Some of these bits flags aren't referred to from elsewhere and can be
removed.

Signed-off-by: Adham Abozaeid <adham.abozaeid@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 216 ----------------------
 drivers/staging/wilc1000/host_interface.h |  29 ---
 drivers/staging/wilc1000/wilc_wlan_if.h   |   9 -
 3 files changed, 254 deletions(-)
 mode change 100644 =3D> 100755 drivers/staging/wilc1000/host_interface.c
 mode change 100644 =3D> 100755 drivers/staging/wilc1000/host_interface.h
 mode change 100644 =3D> 100755 drivers/staging/wilc1000/wilc_wlan_if.h

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
old mode 100644
new mode 100755
index 01db8999335e..1a1ac5e936a7
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -374,64 +374,6 @@ static void handle_cfg_param(struct work_struct *work)
=20
 	mutex_lock(&hif_drv->cfg_values_lock);
=20
-	if (param->flag & BSS_TYPE) {
-		u8 bss_type =3D param->bss_type;
-
-		if (bss_type < 6) {
-			wid_list[i].id =3D WID_BSS_TYPE;
-			wid_list[i].val =3D (s8 *)&param->bss_type;
-			wid_list[i].type =3D WID_CHAR;
-			wid_list[i].size =3D sizeof(char);
-			hif_drv->cfg_values.bss_type =3D bss_type;
-		} else {
-			netdev_err(vif->ndev, "check value 6 over\n");
-			goto unlock;
-		}
-		i++;
-	}
-	if (param->flag & AUTH_TYPE) {
-		u8 auth_type =3D param->auth_type;
-
-		if (auth_type =3D=3D 1 || auth_type =3D=3D 2 || auth_type =3D=3D 5) {
-			wid_list[i].id =3D WID_AUTH_TYPE;
-			wid_list[i].val =3D (s8 *)&param->auth_type;
-			wid_list[i].type =3D WID_CHAR;
-			wid_list[i].size =3D sizeof(char);
-			hif_drv->cfg_values.auth_type =3D auth_type;
-		} else {
-			netdev_err(vif->ndev, "Impossible value\n");
-			goto unlock;
-		}
-		i++;
-	}
-	if (param->flag & AUTHEN_TIMEOUT) {
-		if (param->auth_timeout > 0) {
-			wid_list[i].id =3D WID_AUTH_TIMEOUT;
-			wid_list[i].val =3D (s8 *)&param->auth_timeout;
-			wid_list[i].type =3D WID_SHORT;
-			wid_list[i].size =3D sizeof(u16);
-			hif_drv->cfg_values.auth_timeout =3D param->auth_timeout;
-		} else {
-			netdev_err(vif->ndev, "Range(1 ~ 65535) over\n");
-			goto unlock;
-		}
-		i++;
-	}
-	if (param->flag & POWER_MANAGEMENT) {
-		u8 pm_mode =3D param->power_mgmt_mode;
-
-		if (pm_mode < 5) {
-			wid_list[i].id =3D WID_POWER_MANAGEMENT;
-			wid_list[i].val =3D (s8 *)&param->power_mgmt_mode;
-			wid_list[i].type =3D WID_CHAR;
-			wid_list[i].size =3D sizeof(char);
-			hif_drv->cfg_values.power_mgmt_mode =3D pm_mode;
-		} else {
-			netdev_err(vif->ndev, "Invalid power mode\n");
-			goto unlock;
-		}
-		i++;
-	}
 	if (param->flag & RETRY_SHORT) {
 		u16 retry_limit =3D param->short_retry_limit;
=20
@@ -492,160 +434,6 @@ static void handle_cfg_param(struct work_struct *work=
)
 		}
 		i++;
 	}
-	if (param->flag & PREAMBLE) {
-		u16 preamble_type =3D param->preamble_type;
-
-		if (param->preamble_type < 3) {
-			wid_list[i].id =3D WID_PREAMBLE;
-			wid_list[i].val =3D (s8 *)&param->preamble_type;
-			wid_list[i].type =3D WID_CHAR;
-			wid_list[i].size =3D sizeof(char);
-			hif_drv->cfg_values.preamble_type =3D preamble_type;
-		} else {
-			netdev_err(vif->ndev, "Preamble Range(0~2) over\n");
-			goto unlock;
-		}
-		i++;
-	}
-	if (param->flag & SHORT_SLOT_ALLOWED) {
-		u8 slot_allowed =3D param->short_slot_allowed;
-
-		if (slot_allowed < 2) {
-			wid_list[i].id =3D WID_SHORT_SLOT_ALLOWED;
-			wid_list[i].val =3D (s8 *)&param->short_slot_allowed;
-			wid_list[i].type =3D WID_CHAR;
-			wid_list[i].size =3D sizeof(char);
-			hif_drv->cfg_values.short_slot_allowed =3D slot_allowed;
-		} else {
-			netdev_err(vif->ndev, "Short slot(2) over\n");
-			goto unlock;
-		}
-		i++;
-	}
-	if (param->flag & TXOP_PROT_DISABLE) {
-		u8 prot_disabled =3D param->txop_prot_disabled;
-
-		if (param->txop_prot_disabled < 2) {
-			wid_list[i].id =3D WID_11N_TXOP_PROT_DISABLE;
-			wid_list[i].val =3D (s8 *)&param->txop_prot_disabled;
-			wid_list[i].type =3D WID_CHAR;
-			wid_list[i].size =3D sizeof(char);
-			hif_drv->cfg_values.txop_prot_disabled =3D prot_disabled;
-		} else {
-			netdev_err(vif->ndev, "TXOP prot disable\n");
-			goto unlock;
-		}
-		i++;
-	}
-	if (param->flag & BEACON_INTERVAL) {
-		u16 beacon_interval =3D param->beacon_interval;
-
-		if (beacon_interval > 0) {
-			wid_list[i].id =3D WID_BEACON_INTERVAL;
-			wid_list[i].val =3D (s8 *)&param->beacon_interval;
-			wid_list[i].type =3D WID_SHORT;
-			wid_list[i].size =3D sizeof(u16);
-			hif_drv->cfg_values.beacon_interval =3D beacon_interval;
-		} else {
-			netdev_err(vif->ndev, "Beacon interval(1~65535)fail\n");
-			goto unlock;
-		}
-		i++;
-	}
-	if (param->flag & DTIM_PERIOD) {
-		if (param->dtim_period > 0 && param->dtim_period < 256) {
-			wid_list[i].id =3D WID_DTIM_PERIOD;
-			wid_list[i].val =3D (s8 *)&param->dtim_period;
-			wid_list[i].type =3D WID_CHAR;
-			wid_list[i].size =3D sizeof(char);
-			hif_drv->cfg_values.dtim_period =3D param->dtim_period;
-		} else {
-			netdev_err(vif->ndev, "DTIM range(1~255) fail\n");
-			goto unlock;
-		}
-		i++;
-	}
-	if (param->flag & SITE_SURVEY) {
-		enum site_survey enabled =3D param->site_survey_enabled;
-
-		if (enabled < 3) {
-			wid_list[i].id =3D WID_SITE_SURVEY;
-			wid_list[i].val =3D (s8 *)&param->site_survey_enabled;
-			wid_list[i].type =3D WID_CHAR;
-			wid_list[i].size =3D sizeof(char);
-			hif_drv->cfg_values.site_survey_enabled =3D enabled;
-		} else {
-			netdev_err(vif->ndev, "Site survey disable\n");
-			goto unlock;
-		}
-		i++;
-	}
-	if (param->flag & SITE_SURVEY_SCAN_TIME) {
-		u16 scan_time =3D param->site_survey_scan_time;
-
-		if (scan_time > 0) {
-			wid_list[i].id =3D WID_SITE_SURVEY_SCAN_TIME;
-			wid_list[i].val =3D (s8 *)&param->site_survey_scan_time;
-			wid_list[i].type =3D WID_SHORT;
-			wid_list[i].size =3D sizeof(u16);
-			hif_drv->cfg_values.site_survey_scan_time =3D scan_time;
-		} else {
-			netdev_err(vif->ndev, "Site scan time(1~65535) over\n");
-			goto unlock;
-		}
-		i++;
-	}
-	if (param->flag & ACTIVE_SCANTIME) {
-		u16 active_scan_time =3D param->active_scan_time;
-
-		if (active_scan_time > 0) {
-			wid_list[i].id =3D WID_ACTIVE_SCAN_TIME;
-			wid_list[i].val =3D (s8 *)&param->active_scan_time;
-			wid_list[i].type =3D WID_SHORT;
-			wid_list[i].size =3D sizeof(u16);
-			hif_drv->cfg_values.active_scan_time =3D active_scan_time;
-		} else {
-			netdev_err(vif->ndev, "Active time(1~65535) over\n");
-			goto unlock;
-		}
-		i++;
-	}
-	if (param->flag & PASSIVE_SCANTIME) {
-		u16 time =3D param->passive_scan_time;
-
-		if (time > 0) {
-			wid_list[i].id =3D WID_PASSIVE_SCAN_TIME;
-			wid_list[i].val =3D (s8 *)&param->passive_scan_time;
-			wid_list[i].type =3D WID_SHORT;
-			wid_list[i].size =3D sizeof(u16);
-			hif_drv->cfg_values.passive_scan_time =3D time;
-		} else {
-			netdev_err(vif->ndev, "Passive time(1~65535) over\n");
-			goto unlock;
-		}
-		i++;
-	}
-	if (param->flag & CURRENT_TX_RATE) {
-		enum current_tx_rate curr_tx_rate =3D param->curr_tx_rate;
-
-		if (curr_tx_rate =3D=3D AUTORATE || curr_tx_rate =3D=3D MBPS_1 ||
-		    curr_tx_rate =3D=3D MBPS_2 || curr_tx_rate =3D=3D MBPS_5_5 ||
-		    curr_tx_rate =3D=3D MBPS_11 || curr_tx_rate =3D=3D MBPS_6 ||
-		    curr_tx_rate =3D=3D MBPS_9 || curr_tx_rate =3D=3D MBPS_12 ||
-		    curr_tx_rate =3D=3D MBPS_18 || curr_tx_rate =3D=3D MBPS_24 ||
-		    curr_tx_rate =3D=3D MBPS_36 || curr_tx_rate =3D=3D MBPS_48 ||
-		    curr_tx_rate =3D=3D MBPS_54) {
-			wid_list[i].id =3D WID_CURRENT_TX_RATE;
-			wid_list[i].val =3D (s8 *)&curr_tx_rate;
-			wid_list[i].type =3D WID_SHORT;
-			wid_list[i].size =3D sizeof(u16);
-			hif_drv->cfg_values.curr_tx_rate =3D (u8)curr_tx_rate;
-		} else {
-			netdev_err(vif->ndev, "out of TX rate\n");
-			goto unlock;
-		}
-		i++;
-	}
=20
 	ret =3D wilc_send_config_pkt(vif, SET_CFG, wid_list,
 				   i, wilc_get_vif_idx(vif));
@@ -3372,11 +3160,7 @@ int wilc_init(struct net_device *dev, struct host_if=
_drv **hif_drv_handler)
 	mutex_lock(&hif_drv->cfg_values_lock);
=20
 	hif_drv->hif_state =3D HOST_IF_IDLE;
-	hif_drv->cfg_values.site_survey_enabled =3D SITE_SURVEY_OFF;
 	hif_drv->cfg_values.scan_source =3D DEFAULT_SCAN;
-	hif_drv->cfg_values.active_scan_time =3D ACTIVE_SCAN_TIME;
-	hif_drv->cfg_values.passive_scan_time =3D PASSIVE_SCAN_TIME;
-	hif_drv->cfg_values.curr_tx_rate =3D AUTORATE;
=20
 	hif_drv->p2p_timeout =3D 0;
=20
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wi=
lc1000/host_interface.h
old mode 100644
new mode 100755
index 33fb7318734b..5f894fe7c896
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -103,26 +103,11 @@ enum current_tx_rate {
 struct cfg_param_attr {
 	u32 flag;
 	u8 ht_enable;
-	u8 bss_type;
-	u8 auth_type;
-	u16 auth_timeout;
-	u8 power_mgmt_mode;
 	u16 short_retry_limit;
 	u16 long_retry_limit;
 	u16 frag_threshold;
 	u16 rts_threshold;
-	u16 preamble_type;
-	u8 short_slot_allowed;
-	u8 txop_prot_disabled;
-	u16 beacon_interval;
-	u16 dtim_period;
-	enum site_survey site_survey_enabled;
-	u16 site_survey_scan_time;
 	u8 scan_source;
-	u16 active_scan_time;
-	u16 passive_scan_time;
-	enum current_tx_rate curr_tx_rate;
-
 };
=20
 enum cfg_param {
@@ -130,20 +115,6 @@ enum cfg_param {
 	RETRY_LONG		=3D BIT(1),
 	FRAG_THRESHOLD		=3D BIT(2),
 	RTS_THRESHOLD		=3D BIT(3),
-	BSS_TYPE		=3D BIT(4),
-	AUTH_TYPE		=3D BIT(5),
-	AUTHEN_TIMEOUT		=3D BIT(6),
-	POWER_MANAGEMENT	=3D BIT(7),
-	PREAMBLE		=3D BIT(8),
-	SHORT_SLOT_ALLOWED	=3D BIT(9),
-	TXOP_PROT_DISABLE	=3D BIT(10),
-	BEACON_INTERVAL		=3D BIT(11),
-	DTIM_PERIOD		=3D BIT(12),
-	SITE_SURVEY		=3D BIT(13),
-	SITE_SURVEY_SCAN_TIME	=3D BIT(14),
-	ACTIVE_SCANTIME		=3D BIT(15),
-	PASSIVE_SCANTIME	=3D BIT(16),
-	CURRENT_TX_RATE		=3D BIT(17),
 	HT_ENABLE		=3D BIT(18),
 };
=20
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc=
1000/wilc_wlan_if.h
old mode 100644
new mode 100755
index ce2066b74287..4f258bf6a48d
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -698,13 +698,8 @@ enum {
 	WID_LONG_RETRY_LIMIT		=3D 0x1003,
 	WID_BEACON_INTERVAL		=3D 0x1006,
 	WID_MEMORY_ACCESS_16BIT		=3D 0x1008,
-	WID_RX_SENSE			=3D 0x100B,
-	WID_ACTIVE_SCAN_TIME		=3D 0x100C,
-	WID_PASSIVE_SCAN_TIME		=3D 0x100D,
=20
-	WID_SITE_SURVEY_SCAN_TIME	=3D 0x100E,
 	WID_JOIN_START_TIMEOUT		=3D 0x100F,
-	WID_AUTH_TIMEOUT		=3D 0x1010,
 	WID_ASOC_TIMEOUT		=3D 0x1011,
 	WID_11I_PROTOCOL_TIMEOUT	=3D 0x1012,
 	WID_EAPOL_RESPONSE_TIMEOUT	=3D 0x1013,
@@ -739,11 +734,8 @@ enum {
 	WID_HW_RX_COUNT			=3D 0x2015,
 	WID_MEMORY_ADDRESS		=3D 0x201E,
 	WID_MEMORY_ACCESS_32BIT		=3D 0x201F,
-	WID_RF_REG_VAL			=3D 0x2021,
=20
 	/* NMAC Integer WID list */
-	WID_11N_PHY_ACTIVE_REG_VAL	=3D 0x2080,
-
 	/* Custom Integer WID list */
 	WID_GET_INACTIVE_TIME		=3D 0x2084,
 	WID_SET_OPERATION_MODE		=3D 0X2086,
@@ -764,7 +756,6 @@ enum {
 	WID_SUPP_PASSWORD		=3D 0x3011,
 	WID_SITE_SURVEY_RESULTS		=3D 0x3012,
 	WID_RX_POWER_LEVEL		=3D 0x3013,
-	WID_DEL_ALL_RX_BA		=3D 0x3014,
 	WID_SET_STA_MAC_INACTIVE_TIME	=3D 0x3017,
 	WID_ADD_WEP_KEY			=3D 0x3019,
 	WID_REMOVE_WEP_KEY		=3D 0x301A,
--=20
2.17.1

