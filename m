Return-Path: <SRS0=J0pC=NX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FA51C43441
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 05:45:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F10621527
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 05:45:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="iJb0ey7x"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1F10621527
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731223AbeKLPg7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 10:36:59 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:32662 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728269AbeKLPg7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 10:36:59 -0500
X-IronPort-AV: E=Sophos;i="5.54,494,1534834800"; 
   d="scan'208";a="23150815"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES128-SHA; 11 Nov 2018 22:45:19 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.37) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sun, 11 Nov 2018 22:45:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IqAtSX30llDiSvM5GaetI8jQjxUMqulUo5qLUCAN8uU=;
 b=iJb0ey7x1phmksd3LCKz0+/hDG3o7s0kVhrUdqvqFMSgyVhgJNm91Q4mdh8pm/h9LhORRGo0lohaFm5ZoLVZV91b4LkwXJpK+cnXNPERHruAOuvyaVGGeXFhdBiN201GFmcUEIqVTt5X7SMx0zzhLENJLgpanGfONdRLsdoeh2k=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2599.namprd11.prod.outlook.com (52.135.227.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.21; Mon, 12 Nov 2018 05:45:17 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7%6]) with mapi id 15.20.1294.044; Mon, 12 Nov 2018
 05:45:17 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 06/12] staging: wilc1000: restructure macros used to handle
 security type
Thread-Topic: [PATCH 06/12] staging: wilc1000: restructure macros used to
 handle security type
Thread-Index: AQHUekrkDj0FgRItGUedl5uhmTXIjA==
Date:   Mon, 12 Nov 2018 05:45:17 +0000
Message-ID: <1542001458-20217-7-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2599;6:9hZHnMlIOpZNLGomP5ztA84tsVWwrZ6QfYJPpBZul6Ftd3m9OhhfFIj+0vSO0o/INdy/szRxAnolTsiBjL0Pdglwq4JXwNlFcXj1uTQ3Icl+YSeEubpcLoaSspBDTGeiGfM25cCACW9whbi99/eFscwKvjAyBhd9FKCbfphBhhgg4BxCIF7nMPj14fLVoP711MouYpcqZCC/emLD9r4l4Ig6NBhWgczAVAw6YuDw3MUet+6LUwrI23S2VXjvovTLnAvn5KS1z2IPA4SOld8ThBfcIGTF+uIjMy32Jte6vJGyT/9djVtXI2HlWj4osV+KbLqSC/rjPGjvfMEZQg/qa3Jh4mUzusPicOV5a2f39VEk3r2nTmVCEtOGPTEgCNGqYrJG6ZotGM0qQPUOls53ol8X06Ty46GDZ68FT1+4SN/iUKa5SSNwmPVsitaNfqeEmHLuHf5auWV3D5dNX2uAoQ==;5:8PAoVPmj5zBxjG99BVcFSEpWP0lJjkRtJWbNOt+iBExGSaYnkRp+EGCb+4fM9owa3VJ7eMTRZZOKN4b8CKqHPoR5Efa/PF309UIpj3bXjQh/bv8dhU9Y6PrK0gcmlh8qaOGs5DwiMj2WvPIo03YzBsF/4XqpmxYGS+cgXr8y+mk=;7:8hiF7zOgoPjP9akNULgZ7haAGxr5vsarud51pe4qh9nhyPTLmzCTyE2ljdei2j5CvzMeg9ujsHZeNqZWJu9HPYB4Dtvme3eEQiUr/fsmkbbDR26ub4EPLIqNfpOas7/7gTxKVX6/zQgm2yNBhzWuYg==
x-ms-office365-filtering-correlation-id: 2edc0128-1a23-46b8-f60d-08d648620686
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390040)(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2599;
x-ms-traffictypediagnostic: BYAPR11MB2599:
x-microsoft-antispam-prvs: <BYAPR11MB25999B546E46F0FA71C742CCE3C10@BYAPR11MB2599.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(192374486261705)(21532816269658);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(3002001)(3231402)(944501410)(52105112)(10201501046)(93006095)(93001095)(148016)(149066)(150057)(6041310)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123560045)(20161123562045)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB2599;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB2599;
x-forefront-prvs: 0854128AF0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(396003)(136003)(366004)(39860400002)(189003)(199004)(4326008)(25786009)(2906002)(6116002)(3846002)(72206003)(26005)(2351001)(14454004)(86362001)(575784001)(186003)(6436002)(478600001)(6486002)(105586002)(15650500001)(76176011)(106356001)(2501003)(107886003)(5640700003)(54906003)(52116002)(99286004)(102836004)(53936002)(14444005)(256004)(6506007)(386003)(316002)(36756003)(486006)(8936002)(6916009)(11346002)(7736002)(305945005)(476003)(2616005)(68736007)(8676002)(71200400001)(97736004)(5660300001)(66066001)(446003)(81156014)(81166006)(6512007)(71190400001)(2900100001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2599;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: DFly7RAbIyY2MwRZrAxQV5QmNRUmdvn43/qYpjhygi+1Wf7eyBPd//FwoACJM0E/KyPHA3K+LACaOXGuzLYwC/ceMFXD5TY86pvEsFnbjMteRsIk6A4sOwmf6aWyFaQIPXfRlPVmercLCpRP3/xgvH3CW7PseiRrDZglk062nzLlYnliEfZFFb/C1NV8kGaohKQhdU4ZKxIutzNliOSU3UaPrvUNMnoOYbpSycLL6ZqMppLd59uoV+jZSCFSiXfqOg8xXZnJDGbPenXgPG0MIjL/fV08UmQGkJcOEq3Qdd2MCmTUSCE1vv2VHI0KQlaDeoM+vMNFM78FTSry5+MYFFn1nX1jjpbhAHXPSDlj0Vg=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2edc0128-1a23-46b8-f60d-08d648620686
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2018 05:45:17.5788
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

Restructure the code to have a proper namespace for macro defined to
handle the security types. Move them as part of wilc_wlan_if.h header as
along with other macro defined for firmware.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_wlan.c             |  2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 43 +++++++++----------=
----
 drivers/staging/wilc1000/wilc_wlan_if.h           | 29 ++++++++++-----
 3 files changed, 38 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc10=
00/linux_wlan.c
index 274c4f6..6f0a2cd 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -391,7 +391,7 @@ static int linux_wlan_init_test_config(struct net_devic=
e *dev,
 	if (!wilc_wlan_cfg_set(vif, 0, WID_POWER_MANAGEMENT, c_val, 1, 0, 0))
 		goto fail;
=20
-	c_val[0] =3D NO_SECURITY; /* NO_ENCRYPT, 0x79 */
+	c_val[0] =3D WILC_FW_SEC_NO;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_11I_MODE, c_val, 1, 0, 0))
 		goto fail;
=20
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/st=
aging/wilc1000/wilc_wfi_cfgoperations.c
index 9038f8c..4b04775 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -6,15 +6,6 @@
=20
 #include "wilc_wfi_cfgoperations.h"
=20
-#define NO_ENCRYPT		0
-#define ENCRYPT_ENABLED		BIT(0)
-#define WEP			BIT(1)
-#define WEP_EXTENDED		BIT(2)
-#define WPA			BIT(3)
-#define WPA2			BIT(4)
-#define AES			BIT(5)
-#define TKIP			BIT(6)
-
 #define FRAME_TYPE_ID			0
 #define ACTION_CAT_ID			24
 #define ACTION_SUBTYPE_ID		25
@@ -655,7 +646,7 @@ static int connect(struct wiphy *wiphy, struct net_devi=
ce *dev,
 	int ret;
 	u32 i;
 	u32 sel_bssi_idx =3D UINT_MAX;
-	u8 security =3D NO_ENCRYPT;
+	u8 security =3D WILC_FW_SEC_NO;
 	enum authtype auth_type =3D ANY;
 	u32 cipher_group;
=20
@@ -703,9 +694,9 @@ static int connect(struct wiphy *wiphy, struct net_devi=
ce *dev,
 	memset(priv->wep_key_len, 0, sizeof(priv->wep_key_len));
=20
 	cipher_group =3D sme->crypto.cipher_group;
-	if (cipher_group !=3D NO_ENCRYPT) {
+	if (cipher_group !=3D 0) {
 		if (cipher_group =3D=3D WLAN_CIPHER_SUITE_WEP40) {
-			security =3D ENCRYPT_ENABLED | WEP;
+			security =3D WILC_FW_SEC_WEP;
=20
 			priv->wep_key_len[sme->key_idx] =3D sme->key_len;
 			memcpy(priv->wep_key[sme->key_idx], sme->key,
@@ -715,7 +706,7 @@ static int connect(struct wiphy *wiphy, struct net_devi=
ce *dev,
 			wilc_add_wep_key_bss_sta(vif, sme->key, sme->key_len,
 						 sme->key_idx);
 		} else if (cipher_group =3D=3D WLAN_CIPHER_SUITE_WEP104) {
-			security =3D ENCRYPT_ENABLED | WEP | WEP_EXTENDED;
+			security =3D WILC_FW_SEC_WEP_EXTENDED;
=20
 			priv->wep_key_len[sme->key_idx] =3D sme->key_len;
 			memcpy(priv->wep_key[sme->key_idx], sme->key,
@@ -726,14 +717,14 @@ static int connect(struct wiphy *wiphy, struct net_de=
vice *dev,
 						 sme->key_idx);
 		} else if (sme->crypto.wpa_versions & NL80211_WPA_VERSION_2) {
 			if (cipher_group =3D=3D WLAN_CIPHER_SUITE_TKIP)
-				security =3D ENCRYPT_ENABLED | WPA2 | TKIP;
+				security =3D WILC_FW_SEC_WPA2_TKIP;
 			else
-				security =3D ENCRYPT_ENABLED | WPA2 | AES;
+				security =3D WILC_FW_SEC_WPA2_AES;
 		} else if (sme->crypto.wpa_versions & NL80211_WPA_VERSION_1) {
 			if (cipher_group =3D=3D WLAN_CIPHER_SUITE_TKIP)
-				security =3D ENCRYPT_ENABLED | WPA | TKIP;
+				security =3D WILC_FW_SEC_WPA_TKIP;
 			else
-				security =3D ENCRYPT_ENABLED | WPA | AES;
+				security =3D WILC_FW_SEC_WPA_AES;
 		} else {
 			ret =3D -ENOTSUPP;
 			netdev_err(dev, "%s: Unsupported cipher\n",
@@ -748,9 +739,9 @@ static int connect(struct wiphy *wiphy, struct net_devi=
ce *dev,
 			u32 ciphers_pairwise =3D sme->crypto.ciphers_pairwise[i];
=20
 			if (ciphers_pairwise =3D=3D WLAN_CIPHER_SUITE_TKIP)
-				security =3D security | TKIP;
+				security |=3D WILC_FW_TKIP;
 			else
-				security =3D security | AES;
+				security |=3D WILC_FW_AES;
 		}
 	}
=20
@@ -900,7 +891,7 @@ static int add_key(struct wiphy *wiphy, struct net_devi=
ce *netdev, u8 key_index,
 	struct wilc_priv *priv =3D wiphy_priv(wiphy);
 	const u8 *rx_mic =3D NULL;
 	const u8 *tx_mic =3D NULL;
-	u8 mode =3D NO_ENCRYPT;
+	u8 mode =3D WILC_FW_SEC_NO;
 	u8 op_mode;
 	struct wilc_vif *vif =3D netdev_priv(netdev);
=20
@@ -911,9 +902,9 @@ static int add_key(struct wiphy *wiphy, struct net_devi=
ce *netdev, u8 key_index,
 			wilc_wfi_cfg_copy_wep_info(priv, key_index, params);
=20
 			if (params->cipher =3D=3D WLAN_CIPHER_SUITE_WEP40)
-				mode =3D ENCRYPT_ENABLED | WEP;
+				mode =3D WILC_FW_SEC_WEP;
 			else
-				mode =3D ENCRYPT_ENABLED | WEP | WEP_EXTENDED;
+				mode =3D WILC_FW_SEC_WEP_EXTENDED;
=20
 			ret =3D wilc_add_wep_key_bss_ap(vif, params->key,
 						      params->key_len,
@@ -951,18 +942,18 @@ static int add_key(struct wiphy *wiphy, struct net_de=
vice *netdev, u8 key_index,
=20
 			if (!pairwise) {
 				if (params->cipher =3D=3D WLAN_CIPHER_SUITE_TKIP)
-					mode =3D ENCRYPT_ENABLED | WPA | TKIP;
+					mode =3D WILC_FW_SEC_WPA_TKIP;
 				else
-					mode =3D ENCRYPT_ENABLED | WPA2 | AES;
+					mode =3D WILC_FW_SEC_WPA2_AES;
=20
 				priv->wilc_groupkey =3D mode;
=20
 				key =3D priv->wilc_gtk[key_index];
 			} else {
 				if (params->cipher =3D=3D WLAN_CIPHER_SUITE_TKIP)
-					mode =3D ENCRYPT_ENABLED | WPA | TKIP;
+					mode =3D WILC_FW_SEC_WPA_TKIP;
 				else
-					mode =3D priv->wilc_groupkey | AES;
+					mode =3D priv->wilc_groupkey | WILC_FW_AES;
=20
 				key =3D priv->wilc_ptk[key_index];
 			}
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc=
1000/wilc_wlan_if.h
index 923b07c..a3da6e7 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -99,15 +99,26 @@ enum bus_release {
 };
=20
 enum {
-	NO_SECURITY		=3D 0,
-	WEP_40			=3D 0x3,
-	WEP_104			=3D 0x7,
-	WPA_AES			=3D 0x29,
-	WPA_TKIP		=3D 0x49,
-	WPA_AES_TKIP		=3D 0x69,	/* Aes or Tkip */
-	WPA2_AES		=3D 0x31,
-	WPA2_TKIP		=3D 0x51,
-	WPA2_AES_TKIP		=3D 0x71,	/* Aes or Tkip */
+	WILC_FW_NO_ENCRYPT =3D 0,
+	WILC_FW_ENCRYPT_ENABLED =3D BIT(0),
+	WILC_FW_WEP =3D BIT(1),
+	WILC_FW_WEP_EXTENDED =3D BIT(2),
+	WILC_FW_WPA =3D BIT(3),
+	WILC_FW_WPA2 =3D BIT(4),
+	WILC_FW_AES =3D BIT(5),
+	WILC_FW_TKIP =3D BIT(6)
+};
+
+enum {
+	WILC_FW_SEC_NO =3D WILC_FW_NO_ENCRYPT,
+	WILC_FW_SEC_WEP =3D WILC_FW_WEP | WILC_FW_ENCRYPT_ENABLED,
+	WILC_FW_SEC_WEP_EXTENDED =3D WILC_FW_WEP_EXTENDED | WILC_FW_SEC_WEP,
+	WILC_FW_SEC_WPA =3D WILC_FW_WPA | WILC_FW_ENCRYPT_ENABLED,
+	WILC_FW_SEC_WPA_AES =3D WILC_FW_AES | WILC_FW_SEC_WPA,
+	WILC_FW_SEC_WPA_TKIP =3D WILC_FW_TKIP | WILC_FW_SEC_WPA,
+	WILC_FW_SEC_WPA2 =3D WILC_FW_WPA2 | WILC_FW_ENCRYPT_ENABLED,
+	WILC_FW_SEC_WPA2_AES =3D WILC_FW_AES | WILC_FW_SEC_WPA2,
+	WILC_FW_SEC_WPA2_TKIP =3D WILC_FW_TKIP | WILC_FW_SEC_WPA2
 };
=20
 enum authtype {
--=20
2.7.4

