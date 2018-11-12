Return-Path: <SRS0=J0pC=NX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76D15C43441
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 05:45:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1FCE621527
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 05:45:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="WPYdsVvU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1FCE621527
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731242AbeKLPhE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 10:37:04 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:20241 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728269AbeKLPhD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 10:37:03 -0500
X-IronPort-AV: E=Sophos;i="5.54,494,1534834800"; 
   d="scan'208";a="20255115"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 11 Nov 2018 22:45:23 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.105) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sun, 11 Nov 2018 22:45:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B0MB0Jnzeia7owSzdl3ELiMOPiFj3/jUBr/+R/j0fhk=;
 b=WPYdsVvUQ0bMIEc/2oGi6w7ekoFq8V/k2qvQatWc0V+tCVSLUEYihyJGVgjCPer6H6EDMbRx5qFsjwszIEJCSGb1cwxC7FWaCAH9IibAtaAVC2RRPUhLPz3tQYsKBBcZpAqgeGoc/huglZVEme8YPvii4WWXFEMxTO4dYMbF5EM=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2599.namprd11.prod.outlook.com (52.135.227.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.21; Mon, 12 Nov 2018 05:45:20 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7%6]) with mapi id 15.20.1294.044; Mon, 12 Nov 2018
 05:45:20 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 07/12] staging: wilc1000: use proper namespace for macros in
 wilc_wlan_if.h header
Thread-Topic: [PATCH 07/12] staging: wilc1000: use proper namespace for macros
 in wilc_wlan_if.h header
Thread-Index: AQHUekrmhVK7AUVCcUKmwdcpjqQovA==
Date:   Mon, 12 Nov 2018 05:45:20 +0000
Message-ID: <1542001458-20217-8-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2599;6:xJqBs18xXECubrZJyyMVGLIiaO8bdluwGKze79ZgT9EoCJ1cENqsLh/l6iFn7dgCes2wp40Ils27yAlnuLrPWoaVS+TJYdzBfMRaTiuGOXrb6T5p3d4XQav6Dv7cxh74BlN7EIR8nxClXG5Jwm4/XoYeiJtsOkkJVyh6+a8y3jyutwszQHyH7i/S/HFwrpjDeuI1dft08o7Nkp+mNNXoqQXVrs5X+G40zTYedT1eDd1PCVGbF+j5gWdGNyG9W23wvGgeOSlu0NOVA+RpaV37UCwBVEvcVVk7K1rOvopLOpwZHdFyLPKMbqegqeIOa40TZs7RD5IMVZn0WhizTOF8DK0oyJARlIjutTVzBpxoOrQupJu+Hzrb+T2rg/tc9Kb+DDFnWY8MPPEwPn663NlYk+muoB4VWCzsMT/PErwyf9BMSz2TX1lcgT92uMIbDUOEa8g8p1DyJtLrTemL/lWiQg==;5:sWnPMQ13pQ/kw1FGU4ZLkXwLKEMITNAjmdVFeqtGhzQcwtQjRHCj1lrUY5KsPTExoemoJ35N9jDKYSMQ+O3pHLINq//+h4e4L6jjiJmxRT6uo5t+/80fbFBAfvSvwXkIEQo7N65naOp0MpErBJ3Sb8eyfw8FVAcaza4tIjVJ/tw=;7:sOrtxO1MdlRiw69eYYMteSeALgAEPoHuC+KLp+afE4xs8fsvAY3JmPqEKA2CsO1PfMpfRvhOfn1wy0JFAnToaum0PZGIu9y+oVQdSWzLk7XAD2cuvz1KvBpdpWM4pT12QZJt0SE5XdZzGcxkpNLqdQ==
x-ms-office365-filtering-correlation-id: 92e18999-a094-4bb1-6447-08d648620842
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390040)(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2599;
x-ms-traffictypediagnostic: BYAPR11MB2599:
x-microsoft-antispam-prvs: <BYAPR11MB2599ED0119215C33C63A80ADE3C10@BYAPR11MB2599.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(21532816269658)(192374486261705);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(3002001)(3231402)(944501410)(52105112)(10201501046)(93006095)(93001095)(148016)(149066)(150057)(6041310)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123560045)(20161123562045)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB2599;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB2599;
x-forefront-prvs: 0854128AF0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(396003)(136003)(366004)(39860400002)(189003)(199004)(4326008)(25786009)(2906002)(6116002)(3846002)(72206003)(26005)(2351001)(14454004)(86362001)(575784001)(186003)(6436002)(478600001)(6486002)(105586002)(76176011)(106356001)(2501003)(107886003)(5640700003)(54906003)(52116002)(99286004)(102836004)(53936002)(14444005)(53946003)(256004)(6506007)(386003)(316002)(36756003)(486006)(8936002)(6916009)(11346002)(7736002)(305945005)(476003)(2616005)(68736007)(8676002)(71200400001)(97736004)(5660300001)(66066001)(446003)(81156014)(81166006)(6512007)(71190400001)(2900100001)(4744004)(579004);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2599;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 0brY1ziTJuIuu69AKdqhqeo7CDWTios39vGOff04+PUG62ai9pGK8Gtf4YHGcBE7UP6p4fn3XHr8losB9oKq1EM0gWts+d0j7pgg4WBTD8dT2SSAAYlGDi48zFB2VdZRKZA30b7sKC1WqLwZMnsjFdwJoQtWNLNG100hqwS2cAkLazWn/iv+4k+xiEQ/3ZWMlQT18MVLwy97c12vsuTXhzpTmMIxXcir0R1BK2Mpfo6N2X32vtkEYXDGRmnvuhdGakqt2pw3zuNWP68VvOoWx3GCi5SAWiCiHj0qqSgchNLD3vxCqOcXafB+id/ByOKynWXMoSuhPGqnu1IMegRgemFmA+TvM9mDYs9oopYS5Dc=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 92e18999-a094-4bb1-6447-08d648620842
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2018 05:45:20.6330
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

Rename the macros defined in wilc_wlan_if.h header to have clear
namespace. As convention used 'WILC_FW_' prefix for constants defined for
firmware and 'WILC_' prefix for driver constants.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c         |   6 +-
 drivers/staging/wilc1000/linux_wlan.c             |  32 +++---
 drivers/staging/wilc1000/wilc_sdio.c              |   3 +-
 drivers/staging/wilc1000/wilc_spi.c               |   2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  14 +--
 drivers/staging/wilc1000/wilc_wlan.c              |  88 +++++++--------
 drivers/staging/wilc1000/wilc_wlan_if.h           | 128 +++++++++++-------=
----
 7 files changed, 138 insertions(+), 135 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index 46b1a00..4dfdc7c 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -684,7 +684,7 @@ static void handle_connect(struct work_struct *work)
 		cur_byte[conn_attr->ssid_len] =3D '\0';
 	}
 	cur_byte +=3D MAX_SSID_LEN;
-	*(cur_byte++) =3D INFRASTRUCTURE;
+	*(cur_byte++) =3D WILC_FW_BSS_TYPE_INFRA;
=20
 	if (conn_attr->ch >=3D 1 && conn_attr->ch <=3D 14) {
 		*(cur_byte++) =3D conn_attr->ch;
@@ -2321,9 +2321,9 @@ static void handle_power_management(struct work_struc=
t *work)
 	wid.id =3D WID_POWER_MANAGEMENT;
=20
 	if (pm_param->enabled)
-		power_mode =3D MIN_FAST_PS;
+		power_mode =3D WILC_FW_MIN_FAST_PS;
 	else
-		power_mode =3D NO_POWERSAVE;
+		power_mode =3D WILC_FW_NO_POWERSAVE;
=20
 	wid.val =3D &power_mode;
 	wid.size =3D sizeof(char);
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc10=
00/linux_wlan.c
index 6f0a2cd..c4787bb 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -338,7 +338,7 @@ static int linux_wlan_init_test_config(struct net_devic=
e *dev,
 	if (!wilc_wlan_cfg_set(vif, 0, WID_PC_TEST_MODE, c_val, 1, 0, 0))
 		goto fail;
=20
-	c_val[0] =3D INFRASTRUCTURE;
+	c_val[0] =3D WILC_FW_BSS_TYPE_INFRA;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_BSS_TYPE, c_val, 1, 0, 0))
 		goto fail;
=20
@@ -346,7 +346,7 @@ static int linux_wlan_init_test_config(struct net_devic=
e *dev,
 	if (!wilc_wlan_cfg_set(vif, 0, WID_CURRENT_TX_RATE, c_val, 1, 0, 0))
 		goto fail;
=20
-	c_val[0] =3D G_MIXED_11B_2_MODE;
+	c_val[0] =3D WILC_FW_OPER_MODE_G_MIXED_11B_2;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_11G_OPERATING_MODE, c_val, 1, 0,
 			       0))
 		goto fail;
@@ -355,19 +355,19 @@ static int linux_wlan_init_test_config(struct net_dev=
ice *dev,
 	if (!wilc_wlan_cfg_set(vif, 0, WID_CURRENT_CHANNEL, c_val, 1, 0, 0))
 		goto fail;
=20
-	c_val[0] =3D G_SHORT_PREAMBLE;
+	c_val[0] =3D WILC_FW_PREAMBLE_SHORT;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_PREAMBLE, c_val, 1, 0, 0))
 		goto fail;
=20
-	c_val[0] =3D AUTO_PROT;
+	c_val[0] =3D WILC_FW_11N_PROT_AUTO;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_PROT_MECH, c_val, 1, 0, 0))
 		goto fail;
=20
-	c_val[0] =3D ACTIVE_SCAN;
+	c_val[0] =3D WILC_FW_ACTIVE_SCAN;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_SCAN_TYPE, c_val, 1, 0, 0))
 		goto fail;
=20
-	c_val[0] =3D SITE_SURVEY_OFF;
+	c_val[0] =3D WILC_FW_SITE_SURVEY_OFF;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_SITE_SURVEY, c_val, 1, 0, 0))
 		goto fail;
=20
@@ -387,7 +387,7 @@ static int linux_wlan_init_test_config(struct net_devic=
e *dev,
 	if (!wilc_wlan_cfg_set(vif, 0, WID_QOS_ENABLE, c_val, 1, 0, 0))
 		goto fail;
=20
-	c_val[0] =3D NO_POWERSAVE;
+	c_val[0] =3D WILC_FW_NO_POWERSAVE;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_POWER_MANAGEMENT, c_val, 1, 0, 0))
 		goto fail;
=20
@@ -395,7 +395,7 @@ static int linux_wlan_init_test_config(struct net_devic=
e *dev,
 	if (!wilc_wlan_cfg_set(vif, 0, WID_11I_MODE, c_val, 1, 0, 0))
 		goto fail;
=20
-	c_val[0] =3D OPEN_SYSTEM;
+	c_val[0] =3D WILC_FW_AUTH_OPEN_SYSTEM;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_AUTH_TYPE, c_val, 1, 0, 0))
 		goto fail;
=20
@@ -429,7 +429,7 @@ static int linux_wlan_init_test_config(struct net_devic=
e *dev,
 	if (!wilc_wlan_cfg_set(vif, 0, WID_DTIM_PERIOD, c_val, 1, 0, 0))
 		goto fail;
=20
-	c_val[0] =3D NORMAL_ACK;
+	c_val[0] =3D WILC_FW_ACK_POLICY_NORMAL;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_ACK_POLICY, c_val, 1, 0, 0))
 		goto fail;
=20
@@ -452,7 +452,7 @@ static int linux_wlan_init_test_config(struct net_devic=
e *dev,
 	if (!wilc_wlan_cfg_set(vif, 0, WID_BEACON_INTERVAL, c_val, 2, 0, 0))
 		goto fail;
=20
-	c_val[0] =3D REKEY_DISABLE;
+	c_val[0] =3D WILC_FW_REKEY_POLICY_DISABLE;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_REKEY_POLICY, c_val, 1, 0, 0))
 		goto fail;
=20
@@ -470,7 +470,7 @@ static int linux_wlan_init_test_config(struct net_devic=
e *dev,
 			       0))
 		goto fail;
=20
-	c_val[0] =3D G_SELF_CTS_PROT;
+	c_val[0] =3D WILC_FW_ERP_PROT_SELF_CTS;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_ERP_PROT_TYPE, c_val, 1, 0, 0))
 		goto fail;
=20
@@ -478,7 +478,7 @@ static int linux_wlan_init_test_config(struct net_devic=
e *dev,
 	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_ENABLE, c_val, 1, 0, 0))
 		goto fail;
=20
-	c_val[0] =3D HT_MIXED_MODE;
+	c_val[0] =3D WILC_FW_11N_OP_MODE_HT_MIXED;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_OPERATING_MODE, c_val, 1, 0,
 			       0))
 		goto fail;
@@ -488,12 +488,12 @@ static int linux_wlan_init_test_config(struct net_dev=
ice *dev,
 			       0))
 		goto fail;
=20
-	c_val[0] =3D DETECT_PROTECT_REPORT;
+	c_val[0] =3D WILC_FW_OBBS_NONHT_DETECT_PROTECT_REPORT;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_OBSS_NONHT_DETECTION, c_val, 1,
 			       0, 0))
 		goto fail;
=20
-	c_val[0] =3D RTS_CTS_NONHT_PROT;
+	c_val[0] =3D WILC_FW_HT_PROT_RTS_CTS_NONHT;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_HT_PROT_TYPE, c_val, 1, 0, 0))
 		goto fail;
=20
@@ -502,7 +502,7 @@ static int linux_wlan_init_test_config(struct net_devic=
e *dev,
 			       0))
 		goto fail;
=20
-	c_val[0] =3D MIMO_MODE;
+	c_val[0] =3D WILC_FW_SMPS_MODE_MIMO;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_SMPS_MODE, c_val, 1, 0, 0))
 		goto fail;
=20
@@ -1070,7 +1070,7 @@ int wilc_netdev_init(struct wilc **wilc, struct devic=
e *dev, int io_type,
 	wl->io_type =3D io_type;
 	wl->hif_func =3D ops;
 	wl->enable_ps =3D true;
-	wl->chip_ps_state =3D CHIP_WAKEDUP;
+	wl->chip_ps_state =3D WILC_CHIP_WAKEDUP;
 	INIT_LIST_HEAD(&wl->txq_head.list);
 	INIT_LIST_HEAD(&wl->rxq_head.list);
=20
diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc100=
0/wilc_sdio.c
index 779614e..27fdfbd 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -144,7 +144,8 @@ static int linux_sdio_probe(struct sdio_func *func,
 	}
=20
 	dev_dbg(&func->dev, "Initializing netdev\n");
-	ret =3D wilc_netdev_init(&wilc, &func->dev, HIF_SDIO, &wilc_hif_sdio);
+	ret =3D wilc_netdev_init(&wilc, &func->dev, WILC_HIF_SDIO,
+			       &wilc_hif_sdio);
 	if (ret) {
 		dev_err(&func->dev, "Couldn't initialize netdev\n");
 		kfree(sdio_priv);
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000=
/wilc_spi.c
index cef127b..35ff432 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -120,7 +120,7 @@ static int wilc_bus_probe(struct spi_device *spi)
 			dev_err(&spi->dev, "failed to get the irq gpio\n");
 	}
=20
-	ret =3D wilc_netdev_init(&wilc, NULL, HIF_SPI, &wilc_hif_spi);
+	ret =3D wilc_netdev_init(&wilc, NULL, WILC_HIF_SPI, &wilc_hif_spi);
 	if (ret) {
 		kfree(spi_priv);
 		return ret;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/st=
aging/wilc1000/wilc_wfi_cfgoperations.c
index 4b04775..b882fe9 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -612,14 +612,14 @@ static int scan(struct wiphy *wiphy, struct cfg80211_=
scan_request *request)
 							 &hidden_ntwk))
 				return -ENOMEM;
=20
-			ret =3D wilc_scan(vif, USER_SCAN, ACTIVE_SCAN,
+			ret =3D wilc_scan(vif, USER_SCAN, WILC_FW_ACTIVE_SCAN,
 					scan_ch_list,
 					request->n_channels,
 					(const u8 *)request->ie,
 					request->ie_len, cfg_scan_result,
 					(void *)priv, &hidden_ntwk);
 		} else {
-			ret =3D wilc_scan(vif, USER_SCAN, ACTIVE_SCAN,
+			ret =3D wilc_scan(vif, USER_SCAN, WILC_FW_ACTIVE_SCAN,
 					scan_ch_list,
 					request->n_channels,
 					(const u8 *)request->ie,
@@ -647,7 +647,7 @@ static int connect(struct wiphy *wiphy, struct net_devi=
ce *dev,
 	u32 i;
 	u32 sel_bssi_idx =3D UINT_MAX;
 	u8 security =3D WILC_FW_SEC_NO;
-	enum authtype auth_type =3D ANY;
+	enum authtype auth_type =3D WILC_FW_AUTH_ANY;
 	u32 cipher_group;
=20
 	vif->connecting =3D true;
@@ -747,11 +747,11 @@ static int connect(struct wiphy *wiphy, struct net_de=
vice *dev,
=20
 	switch (sme->auth_type) {
 	case NL80211_AUTHTYPE_OPEN_SYSTEM:
-		auth_type =3D OPEN_SYSTEM;
+		auth_type =3D WILC_FW_AUTH_OPEN_SYSTEM;
 		break;
=20
 	case NL80211_AUTHTYPE_SHARED_KEY:
-		auth_type =3D SHARED_KEY;
+		auth_type =3D WILC_FW_AUTH_SHARED_KEY;
 		break;
=20
 	default:
@@ -760,7 +760,7 @@ static int connect(struct wiphy *wiphy, struct net_devi=
ce *dev,
=20
 	if (sme->crypto.n_akm_suites) {
 		if (sme->crypto.akm_suites[0] =3D=3D WLAN_AKM_SUITE_8021X)
-			auth_type =3D IEEE8021;
+			auth_type =3D WILC_FW_AUTH_IEEE8021;
 	}
=20
 	curr_channel =3D nw_info->ch;
@@ -909,7 +909,7 @@ static int add_key(struct wiphy *wiphy, struct net_devi=
ce *netdev, u8 key_index,
 			ret =3D wilc_add_wep_key_bss_ap(vif, params->key,
 						      params->key_len,
 						      key_index, mode,
-						      OPEN_SYSTEM);
+						      WILC_FW_AUTH_OPEN_SYSTEM);
 			break;
 		}
 		if (memcmp(params->key, priv->wep_key[key_index],
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc100=
0/wilc_wlan.c
index a48c906..d474b87 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -17,13 +17,13 @@ static inline bool is_wilc1000(u32 id)
 static inline void acquire_bus(struct wilc *wilc, enum bus_acquire acquire=
)
 {
 	mutex_lock(&wilc->hif_cs);
-	if (acquire =3D=3D ACQUIRE_AND_WAKEUP)
+	if (acquire =3D=3D WILC_BUS_ACQUIRE_AND_WAKEUP)
 		chip_wakeup(wilc);
 }
=20
 static inline void release_bus(struct wilc *wilc, enum bus_release release=
)
 {
-	if (release =3D=3D RELEASE_ALLOW_SLEEP)
+	if (release =3D=3D WILC_BUS_RELEASE_ALLOW_SLEEP)
 		chip_allow_sleep(wilc);
 	mutex_unlock(&wilc->hif_cs);
 }
@@ -399,7 +399,7 @@ void chip_wakeup(struct wilc *wilc)
 {
 	u32 reg, clk_status_reg;
=20
-	if ((wilc->io_type & 0x1) =3D=3D HIF_SPI) {
+	if ((wilc->io_type & 0x1) =3D=3D WILC_HIF_SPI) {
 		do {
 			wilc->hif_func->hif_read_reg(wilc, 1, &reg);
 			wilc->hif_func->hif_write_reg(wilc, 1, reg | BIT(1));
@@ -410,7 +410,7 @@ void chip_wakeup(struct wilc *wilc)
 				wilc_get_chipid(wilc, true);
 			} while (wilc_get_chipid(wilc, true) =3D=3D 0);
 		} while (wilc_get_chipid(wilc, true) =3D=3D 0);
-	} else if ((wilc->io_type & 0x1) =3D=3D HIF_SDIO) {
+	} else if ((wilc->io_type & 0x1) =3D=3D WILC_HIF_SDIO) {
 		wilc->hif_func->hif_write_reg(wilc, 0xfa, 1);
 		usleep_range(200, 400);
 		wilc->hif_func->hif_read_reg(wilc, 0xf0, &reg);
@@ -433,7 +433,7 @@ void chip_wakeup(struct wilc *wilc)
 		} while ((clk_status_reg & 0x1) =3D=3D 0);
 	}
=20
-	if (wilc->chip_ps_state =3D=3D CHIP_SLEEPING_MANUAL) {
+	if (wilc->chip_ps_state =3D=3D WILC_CHIP_SLEEPING_MANUAL) {
 		if (wilc_get_chipid(wilc, false) < 0x1002b0) {
 			u32 val32;
=20
@@ -446,37 +446,37 @@ void chip_wakeup(struct wilc *wilc)
 			wilc->hif_func->hif_write_reg(wilc, 0x1e9c, val32);
 		}
 	}
-	wilc->chip_ps_state =3D CHIP_WAKEDUP;
+	wilc->chip_ps_state =3D WILC_CHIP_WAKEDUP;
 }
 EXPORT_SYMBOL_GPL(chip_wakeup);
=20
 void wilc_chip_sleep_manually(struct wilc *wilc)
 {
-	if (wilc->chip_ps_state !=3D CHIP_WAKEDUP)
+	if (wilc->chip_ps_state !=3D WILC_CHIP_WAKEDUP)
 		return;
-	acquire_bus(wilc, ACQUIRE_ONLY);
+	acquire_bus(wilc, WILC_BUS_ACQUIRE_ONLY);
=20
 	chip_allow_sleep(wilc);
 	wilc->hif_func->hif_write_reg(wilc, 0x10a8, 1);
=20
-	wilc->chip_ps_state =3D CHIP_SLEEPING_MANUAL;
-	release_bus(wilc, RELEASE_ONLY);
+	wilc->chip_ps_state =3D WILC_CHIP_SLEEPING_MANUAL;
+	release_bus(wilc, WILC_BUS_RELEASE_ONLY);
 }
 EXPORT_SYMBOL_GPL(wilc_chip_sleep_manually);
=20
 void host_wakeup_notify(struct wilc *wilc)
 {
-	acquire_bus(wilc, ACQUIRE_ONLY);
+	acquire_bus(wilc, WILC_BUS_ACQUIRE_ONLY);
 	wilc->hif_func->hif_write_reg(wilc, 0x10b0, 1);
-	release_bus(wilc, RELEASE_ONLY);
+	release_bus(wilc, WILC_BUS_RELEASE_ONLY);
 }
 EXPORT_SYMBOL_GPL(host_wakeup_notify);
=20
 void host_sleep_notify(struct wilc *wilc)
 {
-	acquire_bus(wilc, ACQUIRE_ONLY);
+	acquire_bus(wilc, WILC_BUS_ACQUIRE_ONLY);
 	wilc->hif_func->hif_write_reg(wilc, 0x10ac, 1);
-	release_bus(wilc, RELEASE_ONLY);
+	release_bus(wilc, WILC_BUS_RELEASE_ONLY);
 }
 EXPORT_SYMBOL_GPL(host_sleep_notify);
=20
@@ -541,7 +541,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *t=
xq_count)
 		goto out;
 	vmm_table[i] =3D 0x0;
=20
-	acquire_bus(wilc, ACQUIRE_AND_WAKEUP);
+	acquire_bus(wilc, WILC_BUS_ACQUIRE_AND_WAKEUP);
 	counter =3D 0;
 	func =3D wilc->hif_func;
 	do {
@@ -584,7 +584,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *t=
xq_count)
 				entries =3D ((reg >> 3) & 0x3f);
 				break;
 			}
-			release_bus(wilc, RELEASE_ALLOW_SLEEP);
+			release_bus(wilc, WILC_BUS_RELEASE_ALLOW_SLEEP);
 		} while (--timeout);
 		if (timeout <=3D 0) {
 			ret =3D func->hif_write_reg(wilc, WILC_HOST_VMM_CTL, 0x0);
@@ -615,7 +615,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *t=
xq_count)
 		goto out_release_bus;
 	}
=20
-	release_bus(wilc, RELEASE_ALLOW_SLEEP);
+	release_bus(wilc, WILC_BUS_RELEASE_ALLOW_SLEEP);
=20
 	offset =3D 0;
 	i =3D 0;
@@ -667,7 +667,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *t=
xq_count)
 		kfree(tqe);
 	} while (--entries);
=20
-	acquire_bus(wilc, ACQUIRE_AND_WAKEUP);
+	acquire_bus(wilc, WILC_BUS_ACQUIRE_AND_WAKEUP);
=20
 	ret =3D func->hif_clear_int_ext(wilc, ENABLE_TX_VMM);
 	if (!ret)
@@ -676,7 +676,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *t=
xq_count)
 	ret =3D func->hif_block_tx_ext(wilc, 0, txb, offset);
=20
 out_release_bus:
-	release_bus(wilc, RELEASE_ALLOW_SLEEP);
+	release_bus(wilc, WILC_BUS_RELEASE_ALLOW_SLEEP);
=20
 out:
 	mutex_unlock(&wilc->txq_add_to_head_cs);
@@ -775,7 +775,7 @@ static void wilc_pllupdate_isr_ext(struct wilc *wilc, u=
32 int_stats)
=20
 	wilc->hif_func->hif_clear_int_ext(wilc, PLL_INT_CLR);
=20
-	if (wilc->io_type =3D=3D HIF_SDIO)
+	if (wilc->io_type =3D=3D WILC_HIF_SDIO)
 		mdelay(WILC_PLL_TO_SDIO);
 	else
 		mdelay(WILC_PLL_TO_SPI);
@@ -835,7 +835,7 @@ void wilc_handle_isr(struct wilc *wilc)
 {
 	u32 int_status;
=20
-	acquire_bus(wilc, ACQUIRE_AND_WAKEUP);
+	acquire_bus(wilc, WILC_BUS_ACQUIRE_AND_WAKEUP);
 	wilc->hif_func->hif_read_int(wilc, &int_status);
=20
 	if (int_status & PLL_INT_EXT)
@@ -850,7 +850,7 @@ void wilc_handle_isr(struct wilc *wilc)
 	if (!(int_status & (ALL_INT_EXT)))
 		wilc_unknown_isr_ext(wilc);
=20
-	release_bus(wilc, RELEASE_ALLOW_SLEEP);
+	release_bus(wilc, WILC_BUS_RELEASE_ALLOW_SLEEP);
 }
 EXPORT_SYMBOL_GPL(wilc_handle_isr);
=20
@@ -874,7 +874,7 @@ int wilc_wlan_firmware_download(struct wilc *wilc, cons=
t u8 *buffer,
 		memcpy(&size, &buffer[offset + 4], 4);
 		le32_to_cpus(&addr);
 		le32_to_cpus(&size);
-		acquire_bus(wilc, ACQUIRE_ONLY);
+		acquire_bus(wilc, WILC_BUS_ACQUIRE_ONLY);
 		offset +=3D 8;
 		while (((int)size) && (offset < buffer_size)) {
 			if (size <=3D blksz)
@@ -892,7 +892,7 @@ int wilc_wlan_firmware_download(struct wilc *wilc, cons=
t u8 *buffer,
 			offset +=3D size2;
 			size -=3D size2;
 		}
-		release_bus(wilc, RELEASE_ONLY);
+		release_bus(wilc, WILC_BUS_RELEASE_ONLY);
=20
 		if (!ret) {
 			ret =3D -EIO;
@@ -913,20 +913,20 @@ int wilc_wlan_start(struct wilc *wilc)
 	int ret;
 	u32 chipid;
=20
-	if (wilc->io_type =3D=3D HIF_SDIO) {
+	if (wilc->io_type =3D=3D WILC_HIF_SDIO) {
 		reg =3D 0;
 		reg |=3D BIT(3);
-	} else if (wilc->io_type =3D=3D HIF_SPI) {
+	} else if (wilc->io_type =3D=3D WILC_HIF_SPI) {
 		reg =3D 1;
 	}
-	acquire_bus(wilc, ACQUIRE_ONLY);
+	acquire_bus(wilc, WILC_BUS_ACQUIRE_ONLY);
 	ret =3D wilc->hif_func->hif_write_reg(wilc, WILC_VMM_CORE_CFG, reg);
 	if (!ret) {
-		release_bus(wilc, RELEASE_ONLY);
+		release_bus(wilc, WILC_BUS_RELEASE_ONLY);
 		return -EIO;
 	}
 	reg =3D 0;
-	if (wilc->io_type =3D=3D HIF_SDIO && wilc->dev_irq_num)
+	if (wilc->io_type =3D=3D WILC_HIF_SDIO && wilc->dev_irq_num)
 		reg |=3D WILC_HAVE_SDIO_IRQ_GPIO;
=20
 #ifdef WILC_DISABLE_PMU
@@ -954,7 +954,7 @@ int wilc_wlan_start(struct wilc *wilc)
=20
 	ret =3D wilc->hif_func->hif_write_reg(wilc, WILC_GP_REG_1, reg);
 	if (!ret) {
-		release_bus(wilc, RELEASE_ONLY);
+		release_bus(wilc, WILC_BUS_RELEASE_ONLY);
 		return -EIO;
 	}
=20
@@ -962,7 +962,7 @@ int wilc_wlan_start(struct wilc *wilc)
=20
 	ret =3D wilc->hif_func->hif_read_reg(wilc, 0x1000, &chipid);
 	if (!ret) {
-		release_bus(wilc, RELEASE_ONLY);
+		release_bus(wilc, WILC_BUS_RELEASE_ONLY);
 		return -EIO;
 	}
=20
@@ -976,7 +976,7 @@ int wilc_wlan_start(struct wilc *wilc)
 	reg |=3D BIT(10);
 	ret =3D wilc->hif_func->hif_write_reg(wilc, WILC_GLB_RESET_0, reg);
 	wilc->hif_func->hif_read_reg(wilc, WILC_GLB_RESET_0, &reg);
-	release_bus(wilc, RELEASE_ONLY);
+	release_bus(wilc, WILC_BUS_RELEASE_ONLY);
=20
 	return (ret < 0) ? ret : 0;
 }
@@ -987,18 +987,18 @@ int wilc_wlan_stop(struct wilc *wilc)
 	int ret;
 	u8 timeout =3D 10;
=20
-	acquire_bus(wilc, ACQUIRE_AND_WAKEUP);
+	acquire_bus(wilc, WILC_BUS_ACQUIRE_AND_WAKEUP);
=20
 	ret =3D wilc->hif_func->hif_read_reg(wilc, WILC_GLB_RESET_0, &reg);
 	if (!ret) {
-		release_bus(wilc, RELEASE_ALLOW_SLEEP);
+		release_bus(wilc, WILC_BUS_RELEASE_ALLOW_SLEEP);
 		return ret;
 	}
=20
 	reg &=3D ~BIT(10);
 	ret =3D wilc->hif_func->hif_write_reg(wilc, WILC_GLB_RESET_0, reg);
 	if (!ret) {
-		release_bus(wilc, RELEASE_ALLOW_SLEEP);
+		release_bus(wilc, WILC_BUS_RELEASE_ALLOW_SLEEP);
 		return ret;
 	}
=20
@@ -1006,7 +1006,7 @@ int wilc_wlan_stop(struct wilc *wilc)
 		ret =3D wilc->hif_func->hif_read_reg(wilc,
 						   WILC_GLB_RESET_0, &reg);
 		if (!ret) {
-			release_bus(wilc, RELEASE_ALLOW_SLEEP);
+			release_bus(wilc, WILC_BUS_RELEASE_ALLOW_SLEEP);
 			return ret;
 		}
=20
@@ -1021,7 +1021,7 @@ int wilc_wlan_stop(struct wilc *wilc)
 							   WILC_GLB_RESET_0,
 							   &reg);
 			if (!ret) {
-				release_bus(wilc, RELEASE_ALLOW_SLEEP);
+				release_bus(wilc, WILC_BUS_RELEASE_ALLOW_SLEEP);
 				return ret;
 			}
 			break;
@@ -1036,7 +1036,7 @@ int wilc_wlan_stop(struct wilc *wilc)
=20
 	ret =3D wilc->hif_func->hif_write_reg(wilc, WILC_GLB_RESET_0, reg);
=20
-	release_bus(wilc, RELEASE_ALLOW_SLEEP);
+	release_bus(wilc, WILC_BUS_RELEASE_ALLOW_SLEEP);
=20
 	return ret;
 }
@@ -1072,18 +1072,18 @@ void wilc_wlan_cleanup(struct net_device *dev)
 	kfree(wilc->tx_buffer);
 	wilc->tx_buffer =3D NULL;
=20
-	acquire_bus(wilc, ACQUIRE_AND_WAKEUP);
+	acquire_bus(wilc, WILC_BUS_ACQUIRE_AND_WAKEUP);
=20
 	ret =3D wilc->hif_func->hif_read_reg(wilc, WILC_GP_REG_0, &reg);
 	if (!ret)
-		release_bus(wilc, RELEASE_ALLOW_SLEEP);
+		release_bus(wilc, WILC_BUS_RELEASE_ALLOW_SLEEP);
=20
 	ret =3D wilc->hif_func->hif_write_reg(wilc, WILC_GP_REG_0,
 					(reg | ABORT_INT));
 	if (!ret)
-		release_bus(wilc, RELEASE_ALLOW_SLEEP);
+		release_bus(wilc, WILC_BUS_RELEASE_ALLOW_SLEEP);
=20
-	release_bus(wilc, RELEASE_ALLOW_SLEEP);
+	release_bus(wilc, WILC_BUS_RELEASE_ALLOW_SLEEP);
 	wilc->hif_func->hif_deinit(NULL);
 }
=20
@@ -1245,7 +1245,7 @@ static u32 init_chip(struct net_device *dev)
 	struct wilc_vif *vif =3D netdev_priv(dev);
 	struct wilc *wilc =3D vif->wilc;
=20
-	acquire_bus(wilc, ACQUIRE_ONLY);
+	acquire_bus(wilc, WILC_BUS_ACQUIRE_ONLY);
=20
 	chipid =3D wilc_get_chipid(wilc, true);
=20
@@ -1268,7 +1268,7 @@ static u32 init_chip(struct net_device *dev)
 		}
 	}
=20
-	release_bus(wilc, RELEASE_ONLY);
+	release_bus(wilc, WILC_BUS_RELEASE_ONLY);
=20
 	return ret;
 }
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc=
1000/wilc_wlan_if.h
index a3da6e7..c7e745d 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -15,8 +15,10 @@
  *
  ********************************************/
=20
-#define HIF_SDIO		(0)
-#define HIF_SPI			BIT(0)
+enum {
+	WILC_HIF_SDIO =3D 0,
+	WILC_HIF_SPI =3D BIT(0)
+};
=20
 /********************************************
  *
@@ -51,51 +53,51 @@ typedef void (*wilc_tx_complete_func_t)(void *, int);
 #define MAX_RATES_SUPPORTED     12
=20
 enum bss_types {
-	INFRASTRUCTURE		=3D 0,
-	INDEPENDENT,
-	AP,
+	WILC_FW_BSS_TYPE_INFRA =3D 0,
+	WILC_FW_BSS_TYPE_INDEPENDENT,
+	WILC_FW_BSS_TYPE_AP,
 };
=20
 enum {
-	B_ONLY_MODE		=3D 0,    /* 1, 2 M, otherwise 5, 11 M */
-	G_ONLY_MODE,			/* 6,12,24 otherwise 9,18,36,48,54 */
-	G_MIXED_11B_1_MODE,		/* 1,2,5.5,11 otherwise all on */
-	G_MIXED_11B_2_MODE,		/* 1,2,5,11,6,12,24 otherwise all on */
+	WILC_FW_OPER_MODE_B_ONLY =3D 0,	 /* 1, 2 M, otherwise 5, 11 M */
+	WILC_FW_OPER_MODE_G_ONLY,	 /* 6,12,24 otherwise 9,18,36,48,54 */
+	WILC_FW_OPER_MODE_G_MIXED_11B_1, /* 1,2,5.5,11 otherwise all on */
+	WILC_FW_OPER_MODE_G_MIXED_11B_2, /* 1,2,5,11,6,12,24 otherwise all on */
 };
=20
 enum {
-	G_SHORT_PREAMBLE	=3D 0,	/* Short Preamble */
-	G_LONG_PREAMBLE		=3D 1,	/* Long Preamble */
-	G_AUTO_PREAMBLE		=3D 2,	/* Auto Preamble Selection */
+	WILC_FW_PREAMBLE_SHORT =3D 0,	/* Short Preamble */
+	WILC_FW_PREAMBLE_LONG =3D 1,	/* Long Preamble */
+	WILC_FW_PREAMBLE_AUTO =3D 2,	/* Auto Preamble Selection */
 };
=20
 enum {
-	PASSIVE_SCAN		=3D 0,
-	ACTIVE_SCAN		=3D 1,
+	WILC_FW_PASSIVE_SCAN =3D 0,
+	WILC_FW_ACTIVE_SCAN =3D 1,
 };
=20
 enum {
-	NO_POWERSAVE		=3D 0,
-	MIN_FAST_PS		=3D 1,
-	MAX_FAST_PS		=3D 2,
-	MIN_PSPOLL_PS		=3D 3,
-	MAX_PSPOLL_PS		=3D 4
+	WILC_FW_NO_POWERSAVE =3D 0,
+	WILC_FW_MIN_FAST_PS =3D 1,
+	WILC_FW_MAX_FAST_PS =3D 2,
+	WILC_FW_MIN_PSPOLL_PS =3D 3,
+	WILC_FW_MAX_PSPOLL_PS =3D 4
 };
=20
 enum chip_ps_states {
-	CHIP_WAKEDUP		=3D 0,
-	CHIP_SLEEPING_AUTO      =3D 1,
-	CHIP_SLEEPING_MANUAL	=3D 2
+	WILC_CHIP_WAKEDUP =3D 0,
+	WILC_CHIP_SLEEPING_AUTO =3D 1,
+	WILC_CHIP_SLEEPING_MANUAL =3D 2
 };
=20
 enum bus_acquire {
-	ACQUIRE_ONLY            =3D 0,
-	ACQUIRE_AND_WAKEUP	=3D 1,
+	WILC_BUS_ACQUIRE_ONLY =3D 0,
+	WILC_BUS_ACQUIRE_AND_WAKEUP =3D 1,
 };
=20
 enum bus_release {
-	RELEASE_ONLY		=3D 0,
-	RELEASE_ALLOW_SLEEP	=3D 1,
+	WILC_BUS_RELEASE_ONLY =3D 0,
+	WILC_BUS_RELEASE_ALLOW_SLEEP =3D 1,
 };
=20
 enum {
@@ -122,73 +124,73 @@ enum {
 };
=20
 enum authtype {
-	OPEN_SYSTEM		=3D 1,
-	SHARED_KEY		=3D 2,
-	ANY			=3D 3,
-	IEEE8021		=3D 5
+	WILC_FW_AUTH_OPEN_SYSTEM =3D 1,
+	WILC_FW_AUTH_SHARED_KEY =3D 2,
+	WILC_FW_AUTH_ANY =3D 3,
+	WILC_FW_AUTH_IEEE8021 =3D 5
 };
=20
 enum site_survey {
-	SITE_SURVEY_1CH		=3D 0,
-	SITE_SURVEY_ALL_CH	=3D 1,
-	SITE_SURVEY_OFF		=3D 2
+	WILC_FW_SITE_SURVEY_1CH =3D 0,
+	WILC_FW_SITE_SURVEY_ALL_CH =3D 1,
+	WILC_FW_SITE_SURVEY_OFF =3D 2
 };
=20
 enum {
-	NORMAL_ACK		=3D 0,
-	NO_ACK,
+	WILC_FW_ACK_POLICY_NORMAL =3D 0,
+	WILC_FW_ACK_NO_POLICY,
 };
=20
 enum {
-	REKEY_DISABLE		=3D 1,
-	REKEY_TIME_BASE,
-	REKEY_PKT_BASE,
-	REKEY_TIME_PKT_BASE
+	WILC_FW_REKEY_POLICY_DISABLE =3D 1,
+	WILC_FW_REKEY_POLICY_TIME_BASE,
+	WILC_FW_REKEY_POLICY_PKT_BASE,
+	WILC_FW_REKEY_POLICY_TIME_PKT_BASE
 };
=20
 enum {
-	FILTER_NO		=3D 0x00,
-	FILTER_AP_ONLY		=3D 0x01,
-	FILTER_STA_ONLY		=3D 0x02
+	WILC_FW_FILTER_NO =3D 0x00,
+	WILC_FW_FILTER_AP_ONLY =3D 0x01,
+	WILC_FW_FILTER_STA_ONLY =3D 0x02
 };
=20
 enum {
-	AUTO_PROT		=3D 0,	/* Auto */
-	NO_PROT,			/* Do not use any protection */
-	ERP_PROT,			/* Protect all ERP frame exchanges */
-	HT_PROT,			/* Protect all HT frame exchanges  */
-	GF_PROT,			/* Protect all GF frame exchanges  */
+	WILC_FW_11N_PROT_AUTO =3D 0,	/* Auto */
+	WILC_FW_11N_NO_PROT,		/* Do not use any protection */
+	WILC_FW_11N_PROT_ERP,		/* Protect all ERP frame exchanges */
+	WILC_FW_11N_PROT_HT,		/* Protect all HT frame exchanges  */
+	WILC_FW_11N_PROT_GF		/* Protect all GF frame exchanges  */
 };
=20
 enum {
-	G_SELF_CTS_PROT,
-	G_RTS_CTS_PROT,
+	WILC_FW_ERP_PROT_SELF_CTS,
+	WILC_FW_ERP_PROT_RTS_CTS,
 };
=20
 enum {
-	HT_MIXED_MODE		=3D 1,
-	HT_ONLY_20MHZ_MODE,
-	HT_ONLY_20_40MHZ_MODE,
+	WILC_FW_11N_OP_MODE_HT_MIXED =3D 1,
+	WILC_FW_11N_OP_MODE_HT_ONLY_20MHZ,
+	WILC_FW_11N_OP_MODE_HT_ONLY_20_40MHZ,
 };
=20
 enum {
-	NO_DETECT		=3D 0,
-	DETECT_ONLY		=3D 1,
-	DETECT_PROTECT		=3D 2,
-	DETECT_PROTECT_REPORT	=3D 3,
+	WILC_FW_OBBS_NONHT_NO_DETECT =3D 0,
+	WILC_FW_OBBS_NONHT_DETECT_ONLY =3D 1,
+	WILC_FW_OBBS_NONHT_DETECT_PROTECT =3D 2,
+	WILC_FW_OBBS_NONHT_DETECT_PROTECT_REPORT =3D 3,
 };
=20
 enum {
-	RTS_CTS_NONHT_PROT	=3D 0,	/* RTS-CTS at non-HT rate */
-	FIRST_FRAME_NONHT_PROT,		/* First frame at non-HT rate */
-	LSIG_TXOP_PROT,                 /* LSIG TXOP Protection */
-	FIRST_FRAME_MIXED_PROT,		/* First frame at Mixed format */
+	WILC_FW_HT_PROT_RTS_CTS_NONHT =3D 0,  /* RTS-CTS at non-HT rate */
+	WILC_FW_HT_PROT_FIRST_FRAME_NONHT,  /* First frame at non-HT rate */
+	WILC_FW_HT_PROT_LSIG_TXOP,	    /* LSIG TXOP Protection */
+	WILC_FW_HT_PROT_FIRST_FRAME_MIXED,  /* First frame at Mixed format */
 };
=20
 enum {
-	STATIC_MODE		=3D 1,
-	DYNAMIC_MODE		=3D 2,
-	MIMO_MODE		=3D 3,	/* power save disable */
+	WILC_FW_SMPS_MODE_STATIC =3D 1,
+	WILC_FW_SMPS_MODE_DYNAMIC =3D 2,
+	WILC_FW_SMPS_MODE_MIMO =3D 3,	/* power save disable */
 };
=20
 enum wid_type {
--=20
2.7.4

