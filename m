Return-Path: <SRS0=J0pC=NX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC6BDC43441
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 05:45:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7310621527
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 05:45:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="W1CaxG4L"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7310621527
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731284AbeKLPhI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 10:37:08 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:32674 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728269AbeKLPhI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 10:37:08 -0500
X-IronPort-AV: E=Sophos;i="5.54,494,1534834800"; 
   d="scan'208";a="23150822"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES128-SHA; 11 Nov 2018 22:45:28 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.37) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sun, 11 Nov 2018 22:45:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QN98gsJKH/Vql1KRpVW+wgph9+mID7akIV1jb18qeqU=;
 b=W1CaxG4LLwlVpb6L6mXOvcnyv53pmeuEANUSxRFqC7A3glavvjQUOqz/TuSpSTfHCRCv2l0b875PpWefw5X7RE9rbsuIC97bOu/K6axHJmkaJnblsuQ9Ht6GnVYO/sD+x05HPBIdeP3UbvZncxXHToLyHxz4UfkiSl8G8s2fdYc=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2599.namprd11.prod.outlook.com (52.135.227.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.21; Mon, 12 Nov 2018 05:45:26 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7%6]) with mapi id 15.20.1294.044; Mon, 12 Nov 2018
 05:45:26 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 09/12] staging: wilc1000: rename firmware related constants to
 follow better namespace
Thread-Topic: [PATCH 09/12] staging: wilc1000: rename firmware related
 constants to follow better namespace
Thread-Index: AQHUekrpaJ5VS0fHJUCysAisgY4MhQ==
Date:   Mon, 12 Nov 2018 05:45:26 +0000
Message-ID: <1542001458-20217-10-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2599;6:+QhxtZIZqw3UritGDOaqJRDnLrkQJN9OfJtDx5gF/hBocWV85KjHI7w8sRjmIN2iRFORl2G5O7pnndyox8NpWxyBed/9q3w/0efTllLQDjBo+X2j/KIHap0onlBY+vkXWVJGiQB/EDpfE6oMrX3/oXRDOLJzBiqD7ZN6TPSn7AgAut1j50G5+48OgPtPE7KeH720ZYAeqHTrUvy9+jEUBblC77bqWPqqg4fSW0xNAva9Lpuo/44KXdKYm4+2S1soiZ7Du/ZdgRAgiNuORydbufgPpvqcxR/Up+bfntA0Fcp5Pu/y1SdH33DVGHyEPm+aWF3hGUv6CDiBWOl9YGaJF2D1LJH8dlAOubO9+7ceY7lga9y/00O0p0EjtiQeUhFB1adzb6LZqJqqWjourmsljxuJ7lzr/DZtX8QfE3mC7+DGqeiwpftFX6iOKuOSfLN9Pnn18+4HH1mG0rstwrHyWg==;5:JSR1DyLUwocLNBF1HtsBb0nBY+zCqGa33R3jOLhbRnpbF4xnqcgkU0jUmXt6Ov1lyIU8EyVN2/zzXdZccB05PtWKl3m46flyBcHnPVFEtx7DWMRSq/80HqgUaXvpRR+bIBxFKX/PtE9KMTM+v0EMw50iWThhSe2Dsp5Gp6i6mQI=;7:cBNQxbQTM9DQUdBKKp09qZMDjeAYEQewgXLZydBZPcifK+Psnl+Whmj7Pxn8KtFaRIaKKKy7TF7wJv7qv7NXXSU4mAAxaCOpwY3h4xr8aCez8405E22t54uWa7QeI3s7wfemZuvEjJQaASZpe/H3OQ==
x-ms-office365-filtering-correlation-id: 85e8187d-9ad2-4bdc-d6fa-08d648620bc9
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390040)(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2599;
x-ms-traffictypediagnostic: BYAPR11MB2599:
x-microsoft-antispam-prvs: <BYAPR11MB2599360D75A7DBCB61DF9E6DE3C10@BYAPR11MB2599.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(3002001)(3231402)(944501410)(52105112)(10201501046)(93006095)(93001095)(148016)(149066)(150057)(6041310)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123560045)(20161123562045)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB2599;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB2599;
x-forefront-prvs: 0854128AF0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(396003)(136003)(366004)(39860400002)(189003)(199004)(4326008)(25786009)(2906002)(6116002)(3846002)(72206003)(26005)(2351001)(14454004)(86362001)(575784001)(186003)(6436002)(478600001)(6486002)(105586002)(76176011)(106356001)(2501003)(107886003)(5640700003)(54906003)(52116002)(99286004)(102836004)(53936002)(14444005)(256004)(6506007)(386003)(316002)(36756003)(486006)(8936002)(6916009)(11346002)(7736002)(305945005)(476003)(2616005)(68736007)(8676002)(71200400001)(97736004)(5660300001)(66066001)(446003)(81156014)(81166006)(6512007)(71190400001)(2900100001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2599;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: ywrF60ml4+SN9tP6YwaLJItKRuE6HLKhZXn/nXimag+nSt/W6BfpAANUySirOH4hoCxbngqCW3/xfWB8JqbzfHBgWIIMijZdB1U7jl27dLTyGDHjLZW5EBI3raQpYa3sduyexrynmLj6sdHyhnQus8LYzZY4SH7FjnPmm7ZFitr02zIIQ3bYyn9SqJHxoCjb1Qbd7/6xpqARl8mpRLIMv6egqu5GzM4NcxDEITonkxCuk1/ZhYSNYhiUZDvSHNI+LopG4ex7Np4B74+B9ZdzXa4fSBwnnJz39s89dJLDwY577qroiNoMVat0hdQ1zDzctK6X37aFMce0Y9shbRpoEC9zvsrqbMT1ZoOFOIcgp4o=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 85e8187d-9ad2-4bdc-d6fa-08d648620bc9
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2018 05:45:26.4668
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

Rename the firmware related macro by prefix with 'WILC_FW_' prefix for
a better namespace. Also, move them to wilc_wlan_if.h file along with other
FW related macros.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c         |  4 ++--
 drivers/staging/wilc1000/host_interface.h         |  6 ------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  8 ++++----
 drivers/staging/wilc1000/wilc_wlan_if.h           | 12 ++++++++++++
 4 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index 4dfdc7c..c238d39 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3485,11 +3485,11 @@ void wilc_frame_register(struct wilc_vif *vif, u16 =
frame_type, bool reg)
=20
 	switch (frame_type) {
 	case IEEE80211_STYPE_ACTION:
-		msg->body.reg_frame.reg_id =3D ACTION_FRM_IDX;
+		msg->body.reg_frame.reg_id =3D WILC_FW_ACTION_FRM_IDX;
 		break;
=20
 	case IEEE80211_STYPE_PROBE_REQ:
-		msg->body.reg_frame.reg_id =3D PROBE_REQ_IDX;
+		msg->body.reg_frame.reg_id =3D WILC_FW_PROBE_REQ_IDX;
 		break;
=20
 	default:
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wi=
lc1000/host_interface.h
index 91e60e3..610ca2b 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -15,13 +15,7 @@
 #define GO_MODE		0x03
 #define CLIENT_MODE	0x04
=20
-#define ACTION_FRM_IDX				0
-#define PROBE_REQ_IDX				1
 #define MAX_NUM_STA				9
-#define DEFAULT_SCAN				0
-#define USER_SCAN				BIT(0)
-#define OBSS_PERIODIC_SCAN			BIT(1)
-#define OBSS_ONETIME_SCAN			BIT(2)
 #define ADDKEY					0x1
 #define REMOVEKEY				0x2
 #define DEFAULTKEY				0x4
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/st=
aging/wilc1000/wilc_wfi_cfgoperations.c
index b882fe9..4cfa3ff4 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -612,15 +612,15 @@ static int scan(struct wiphy *wiphy, struct cfg80211_=
scan_request *request)
 							 &hidden_ntwk))
 				return -ENOMEM;
=20
-			ret =3D wilc_scan(vif, USER_SCAN, WILC_FW_ACTIVE_SCAN,
-					scan_ch_list,
+			ret =3D wilc_scan(vif, WILC_FW_USER_SCAN,
+					WILC_FW_ACTIVE_SCAN, scan_ch_list,
 					request->n_channels,
 					(const u8 *)request->ie,
 					request->ie_len, cfg_scan_result,
 					(void *)priv, &hidden_ntwk);
 		} else {
-			ret =3D wilc_scan(vif, USER_SCAN, WILC_FW_ACTIVE_SCAN,
-					scan_ch_list,
+			ret =3D wilc_scan(vif, WILC_FW_USER_SCAN,
+					WILC_FW_ACTIVE_SCAN, scan_ch_list,
 					request->n_channels,
 					(const u8 *)request->ie,
 					request->ie_len, cfg_scan_result,
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc=
1000/wilc_wlan_if.h
index 36d6905..f4f6ac6 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -209,6 +209,18 @@ enum {
 	WILC_FW_TX_RATE_MBPS_54 =3D 54
 };
=20
+enum {
+	WILC_FW_DEFAULT_SCAN =3D 0,
+	WILC_FW_USER_SCAN =3D BIT(0),
+	WILC_FW_OBSS_PERIODIC_SCAN =3D BIT(1),
+	WILC_FW_OBSS_ONETIME_SCAN =3D BIT(2)
+};
+
+enum {
+	WILC_FW_ACTION_FRM_IDX =3D 0,
+	WILC_FW_PROBE_REQ_IDX =3D 1
+};
+
 enum wid_type {
 	WID_CHAR		=3D 0,
 	WID_SHORT		=3D 1,
--=20
2.7.4

