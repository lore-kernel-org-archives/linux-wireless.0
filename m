Return-Path: <SRS0=z7UY=PZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6204CC43444
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 13:21:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2471620851
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 13:21:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="kvR/LFQv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727496AbfAQNVd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 17 Jan 2019 08:21:33 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:61724 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfAQNVc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Jan 2019 08:21:32 -0500
X-IronPort-AV: E=Sophos;i="5.56,489,1539673200"; 
   d="scan'208";a="25443289"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 17 Jan 2019 06:21:13 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.108) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 17 Jan 2019 06:21:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=thoU+mYwBX0/vkq59HdpDdJM30T+ruC2ktlXazH5GFo=;
 b=kvR/LFQvLUslrJT78/sWaCkR7eB/dHXO2dXzN+fmR7TTw3h9pskF7X+4Yt/AX4ChdoLypcnvNii2oXkz2qZXkBJlGPncMLSHUQ4S9rHTZAQa2bQZ9l1n8iM9Nd7/kNX1trdml1nK0ry8ostp4TvWzpHvZ712IqjIlvZjXScEoYc=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3431.namprd11.prod.outlook.com (20.177.225.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1516.17; Thu, 17 Jan 2019 13:21:10 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::c110:8559:a438:491d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::c110:8559:a438:491d%3]) with mapi id 15.20.1516.019; Thu, 17 Jan 2019
 13:21:10 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 01/13] staging: wilc1000: make use of get_unaligned_le16/le32
 to pack data
Thread-Topic: [PATCH 01/13] staging: wilc1000: make use of
 get_unaligned_le16/le32 to pack data
Thread-Index: AQHUrmeCf0jbUuJWz0+R9tLVCLxR/g==
Date:   Thu, 17 Jan 2019 13:21:10 +0000
Message-ID: <1547731250-18518-2-git-send-email-ajay.kathat@microchip.com>
References: <1547731250-18518-1-git-send-email-ajay.kathat@microchip.com>
In-Reply-To: <1547731250-18518-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR01CA0138.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:35::32) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.7.4
x-originating-ip: [49.205.218.18]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3431;6:ukiYAGo7ADg4LhfaELyTYvF+U2cFK5mjTj89soRbZrDhAWulhxEOyVaNY67OJebBKSx0S1de3jnNxUKJvnMVGUGISCkVYbox5eFLR7dF4+Y/0Qr0LdpExnhxaF5ghXrNO/EuKXDknIdY6KcaE/yHGbHLFNG/NfPoMNqNibsugseiGGfDmwDyi0n1oyf9dgJRYXoyIubwnYBBwZn4FlDbo8vML+xvGwh1z4NkQSSmBvk3PUEeIy3Lpk5kaDY8nFyaF40QuTbsVugHYR1P9y9MMMWALvPeiD0X7Rkl91AWdmcRuUWFia4rg0rCLhFM8YGbhkHfgKMvgObyG0FHE11MUb1IXt7r5BYRwelLveShMRrAYR+pRy+mhe+rtBNPHb7b6dBbWwm7iYscaYJSqx6k8TQkuIiHGE3YUBw2Q81+A0OocT1g9AFNBdgv570RVhM0sEHr/nH+ojCGEV68S1FwyQ==;5:OuxcCUQsVEuxtZ8QJMKvYeXz5PkRdNoCtWLDrmcsyquTvT5TphMio01hx5FotivAzfurxCzqgAwIl+JCgu0/qpEbdU9+CtxBP1tYRTgsDYOsQRk4IpGrRelpkbmSGVqIo4hwFZNw2ZGdvS1s0D5TAZbG/MIGT1lPHrRFDMoj3ZuBCkwVJjYoKv+MYKUKSIfiPZJnFyAhyS6VXBqhIbMW2A==;7:7uM9bTwrt4tuXVCbqVoHq8H8aftbsco1on2Ro+rRsfBs90rCq5aJklpR6fG4ohGHII+nW0sljHPSbo4+JXFrKTPsgv4gx1bVvEraR3ZhICBoca/y0E3zwNM7Yy4Nz8tgkW5MeYvBzzG6c5T7c7gceA==
x-ms-office365-filtering-correlation-id: 35c4e64a-fce1-4b92-1357-08d67c7ea4fd
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3431;
x-ms-traffictypediagnostic: BYAPR11MB3431:
x-microsoft-antispam-prvs: <BYAPR11MB34310C2ABF6C674636711B79E3830@BYAPR11MB3431.namprd11.prod.outlook.com>
x-forefront-prvs: 0920602B08
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(346002)(396003)(366004)(136003)(189003)(199004)(6512007)(52116002)(102836004)(68736007)(97736004)(6486002)(53936002)(106356001)(5640700003)(6436002)(2351001)(476003)(2906002)(76176011)(105586002)(186003)(486006)(6506007)(26005)(386003)(256004)(6916009)(2616005)(446003)(11346002)(107886003)(14444005)(478600001)(6116002)(66066001)(86362001)(71200400001)(72206003)(305945005)(3846002)(36756003)(4326008)(2501003)(25786009)(54906003)(81166006)(81156014)(316002)(8936002)(50226002)(71190400001)(8676002)(7736002)(14454004)(78486014)(5660300001)(99286004);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3431;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 5I7IbGkp1La690AMrhenkT0fSdkgX1K2xR/jdKw7lgskKBOdcGQvr2EylxqSmqtGq9c59ChI2mvwEW6dy7ORmeMq7oPidiirs3RN77mS/Lc0GcGdxpIjpVCUj0X8ckcoHtS09oBG6RQo92xU3m6ykwpzkUmZylzYpyPbMG/wQ/p3mPTnh7iRNGSz2bZWEspwE9CH99Xv22WpSI5D5QJMfCi4xAVqTCSAc9BW/n0VVZcZUgS9jGXzTPJ9DI9wrvhBOrLJUj7i8VWfaIiPBGxq4644oH3BTHx5MM1AxICvlae6Tj2o8OcdOHQ2uYFy69fz07dPwHrarHoSbx0i/vPIBOlvE9BpCpwgsY2wosCQpFla/T8chWw9kc5yVr/nn0GNCVQH1GOPMt6P6ndTB6NBmcvJCI7BwnHswCuUfanPcWc=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 35c4e64a-fce1-4b92-1357-08d67c7ea4fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2019 13:21:07.2360
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3431
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Make use of get_unaligned_le16/le32 framework api's to pack data.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 15 +++------------
 drivers/staging/wilc1000/wilc_wlan_cfg.c  | 27 +++++++++++++--------------
 2 files changed, 16 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index c05c120..a718842 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2154,10 +2154,7 @@ void wilc_network_info_received(struct wilc *wilc, u=
8 *buffer, u32 length)
 	struct host_if_drv *hif_drv;
 	struct wilc_vif *vif;
=20
-	id =3D buffer[length - 4];
-	id |=3D (buffer[length - 3] << 8);
-	id |=3D (buffer[length - 2] << 16);
-	id |=3D (buffer[length - 1] << 24);
+	id =3D get_unaligned_le32(&buffer[length - 4]);
 	vif =3D wilc_get_vif_from_idx(wilc, id);
 	if (!vif)
 		return;
@@ -2197,10 +2194,7 @@ void wilc_gnrl_async_info_received(struct wilc *wilc=
, u8 *buffer, u32 length)
=20
 	mutex_lock(&hif_deinit_lock);
=20
-	id =3D buffer[length - 4];
-	id |=3D (buffer[length - 3] << 8);
-	id |=3D (buffer[length - 2] << 16);
-	id |=3D (buffer[length - 1] << 24);
+	id =3D get_unaligned_le32(&buffer[length - 4]);
 	vif =3D wilc_get_vif_from_idx(wilc, id);
 	if (!vif) {
 		mutex_unlock(&hif_deinit_lock);
@@ -2251,10 +2245,7 @@ void wilc_scan_complete_received(struct wilc *wilc, =
u8 *buffer, u32 length)
 	struct host_if_drv *hif_drv;
 	struct wilc_vif *vif;
=20
-	id =3D buffer[length - 4];
-	id |=3D buffer[length - 3] << 8;
-	id |=3D buffer[length - 2] << 16;
-	id |=3D buffer[length - 1] << 24;
+	id =3D get_unaligned_le32(&buffer[length - 4]);
 	vif =3D wilc_get_vif_from_idx(wilc, id);
 	if (!vif)
 		return;
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wil=
c1000/wilc_wlan_cfg.c
index 8390766..67e9f93 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -168,7 +168,7 @@ static void wilc_wlan_parse_response_frame(struct wilc =
*wl, u8 *info, int size)
=20
 	while (size > 0) {
 		i =3D 0;
-		wid =3D info[0] | (info[1] << 8);
+		wid =3D get_unaligned_le16(info);
=20
 		switch (GET_WID_TYPE(wid)) {
 		case WID_CHAR:
@@ -187,12 +187,13 @@ static void wilc_wlan_parse_response_frame(struct wil=
c *wl, u8 *info, int size)
=20
 		case WID_SHORT:
 			do {
-				if (wl->cfg.hw[i].id =3D=3D WID_NIL)
+				struct wilc_cfg_hword *hw =3D &wl->cfg.hw[i];
+
+				if (hw->id =3D=3D WID_NIL)
 					break;
=20
-				if (wl->cfg.hw[i].id =3D=3D wid) {
-					wl->cfg.hw[i].val =3D (info[4] |
-							     (info[5] << 8));
+				if (hw->id =3D=3D wid) {
+					hw->val =3D get_unaligned_le16(&info[4]);
 					break;
 				}
 				i++;
@@ -202,14 +203,13 @@ static void wilc_wlan_parse_response_frame(struct wil=
c *wl, u8 *info, int size)
=20
 		case WID_INT:
 			do {
-				if (wl->cfg.w[i].id =3D=3D WID_NIL)
+				struct wilc_cfg_word *w =3D &wl->cfg.w[i];
+
+				if (w->id =3D=3D WID_NIL)
 					break;
=20
-				if (wl->cfg.w[i].id =3D=3D wid) {
-					wl->cfg.w[i].val =3D (info[4] |
-							    (info[5] << 8) |
-							    (info[6] << 16) |
-							    (info[7] << 24));
+				if (w->id =3D=3D wid) {
+					w->val =3D get_unaligned_le32(&info[4]);
 					break;
 				}
 				i++;
@@ -244,7 +244,7 @@ static void wilc_wlan_parse_info_frame(struct wilc *wl,=
 u8 *info)
 {
 	u32 wid, len;
=20
-	wid =3D info[0] | (info[1] << 8);
+	wid =3D get_unaligned_le16(info);
=20
 	len =3D info[2];
=20
@@ -371,8 +371,7 @@ int wilc_wlan_cfg_get_wid_value(struct wilc *wl, u16 wi=
d, u8 *buffer,
 				break;
=20
 			if (id =3D=3D wid) {
-				u32 size =3D (wl->cfg.s[i].str[0] |
-					    (wl->cfg.s[i].str[1] << 8));
+				u16 size =3D get_unaligned_le16(wl->cfg.s[i].str);
=20
 				if (buffer_size >=3D size) {
 					memcpy(buffer, &wl->cfg.s[i].str[2],
--=20
2.7.4

