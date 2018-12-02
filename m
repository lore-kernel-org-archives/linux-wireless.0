Return-Path: <SRS0=9n1M=OL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63ABDC65BAE
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:02:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A5EE2082F
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:02:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="gJDFsmEJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1A5EE2082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725774AbeLBSC0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 2 Dec 2018 13:02:26 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:62999 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbeLBSC0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Dec 2018 13:02:26 -0500
X-IronPort-AV: E=Sophos;i="5.56,307,1539673200"; 
   d="scan'208";a="23749565"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES128-SHA; 02 Dec 2018 11:02:24 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.37) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sun, 2 Dec 2018 11:02:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vlM32ZHb4cdB0IfziKhIcKf9Km8+dLyFRTKguu49Afw=;
 b=gJDFsmEJ/L5Ofrd5AXiXnPOBHpYtWRCMcHhh8azxVAor8AlCrKsnxjQOCBr0hoNhNg2t6ARxRIbyoq3vBMA5ayFJbzlyV1i3YFMtviKns7FbAeV83p4+t7wxJOf/6kPpOp66i3XDewAKVqcWxX6OyYNVeKExSG1jQr6CtRsh9po=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3334.namprd11.prod.outlook.com (20.177.185.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1382.19; Sun, 2 Dec 2018 18:02:22 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f%4]) with mapi id 15.20.1382.020; Sun, 2 Dec 2018
 18:02:22 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 03/29] staging: wilc1000: avoid the use of the static variable
 to configure wiphy struct
Thread-Topic: [PATCH 03/29] staging: wilc1000: avoid the use of the static
 variable to configure wiphy struct
Thread-Index: AQHUimksOLpIYfb32E+AYQewZHPHlA==
Date:   Sun, 2 Dec 2018 18:02:22 +0000
Message-ID: <1543773663-20561-4-git-send-email-ajay.kathat@microchip.com>
References: <1543773663-20561-1-git-send-email-ajay.kathat@microchip.com>
In-Reply-To: <1543773663-20561-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MAXPR0101CA0063.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::25) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [183.82.18.98]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3334;6:Fy7qKLqzW+/9Cfcl5dkS9TRXZHTa8ZXU3vk7lK7alv79nJm1KiP5yHa6ugHK0K2GSnhB1gDq1dudI+aQiGFiI27/1GV7LnYqvJHWYZ3FsfxS7pRgWVH7MNjelz1wE6HDuwo85vTDkLiYeuVYmjYZ5aXEGKaCrBI8b732igiXtoPtygl59Wel9Fe9kw1kXGSQfwb6RnICYsaoj0k842jHC+ku81Duk0QuxM6STn24jGYFqebXMBkvs+v6xCgGwHTvYg99GEbs3x6CZVy3e48PVhxub/Cw2YCfRIsofQyF1IJakSCqIjRhpWp00hzacwTJV3SruVLqq0WoNFzeP7NaTk3p0PYPklTZaxy1/5u1JUYdulKkbxmDGXgyvrAoPIkayHms1OzYbhgwOhFFio/zLSAjsMQ9b7ssjtihpibUMNWGggGBtewe0J9BYoGsEf2tDTVMUx4Cutp7G+/RjQql5A==;5:ceBcXVsJE/TeVjbvXsFNul8AhjFyiCG2jhiTQL4LHmMuZLA3qGvPqFBLMYNIcCfetfn5XVvSC8VKNMUxHI2hgNksDKPDIF54JXQHlzxv37jut1fdkyxAhNzdJUUbLGc0w6g21thYaXE1AeTzNamaMPM9fsveCZOTpyG+wZ44FXs=;7:44t/HvI2lF43NwayF27b/B2Yhx+ydAu0YPbfysMZCiNBPikJgIHtnS8K6vgzE2sj6zBIR+Te/E6nQKHYrp9uozT8ZY3GEsItQqQMjkh66GLpc8f83BOG81QKOLLjmfrNevER0p9HfBYqLLtkgkhEVw==
x-ms-office365-filtering-correlation-id: cf2b1df7-4b5d-44cb-b82a-08d658804f02
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3334;
x-ms-traffictypediagnostic: BYAPR11MB3334:
x-microsoft-antispam-prvs: <BYAPR11MB3334DC61E2C31997A53FBC45E3AD0@BYAPR11MB3334.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(10201501046)(3002001)(3231455)(999002)(944501491)(52105112)(93006095)(93001095)(148016)(149066)(150057)(6041310)(20161123558120)(20161123564045)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB3334;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB3334;
x-forefront-prvs: 087474FBFA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(366004)(376002)(396003)(39850400004)(199004)(189003)(107886003)(6916009)(386003)(5660300001)(5640700003)(446003)(4326008)(11346002)(6506007)(78486014)(2906002)(6512007)(53936002)(54906003)(3846002)(6116002)(2351001)(81166006)(316002)(81156014)(52116002)(8676002)(26005)(8936002)(256004)(14444005)(76176011)(6436002)(97736004)(106356001)(99286004)(486006)(6486002)(68736007)(105586002)(14454004)(478600001)(2616005)(7736002)(66066001)(36756003)(305945005)(72206003)(186003)(2501003)(86362001)(102836004)(476003)(71190400001)(25786009)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3334;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: KPxmS90EL/mFVAuc4ng2EsKgMYrwnF6PqFLS9/oHt3BnEYeJL3iFw/O2qrASAg12x2w0mcOabtCqMTnbhnEtK/HvXh6zGWVuRxsyyz5st+8mKd/qhxmv5ipiC1eyY9f22iULZeJU8Ucti5XFy27yEw4Lbn7/pSsvI27qm5Nql4Xd0Wce2jsw74Rbxy+zEBImRQcALEqWRSRL4s/tAtySLQcWfBxUycn7ja4az8M8e4lLIOA75eviig7kOkdBcL5JYrYfjiExPICGtM5DGj2wLKOF4rNw3kJkydJhYOa5eq8tMwNWSfUZ0JoxZXCICcDbP+j62J2hkUD5sd+c/qxvj97gmE+fGIf/HE5q9KKRlH4=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: cf2b1df7-4b5d-44cb-b82a-08d658804f02
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2018 18:02:22.7482
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3334
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Refactor code to avoid the use of static variables to configure the
'wiphy' structure. Now move static variables as part of 'priv' data so
it helped to maintain this information per interface.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 92 +++++--------------=
----
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     | 60 +++++++++++++++
 2 files changed, 80 insertions(+), 72 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/st=
aging/wilc1000/wilc_wfi_cfgoperations.c
index 1dec6bb..69b181f 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -32,14 +32,6 @@
 #define nl80211_SCAN_RESULT_EXPIRE	(3 * HZ)
 #define SCAN_RESULT_EXPIRE		(40 * HZ)
=20
-static const u32 cipher_suites[] =3D {
-	WLAN_CIPHER_SUITE_WEP40,
-	WLAN_CIPHER_SUITE_WEP104,
-	WLAN_CIPHER_SUITE_TKIP,
-	WLAN_CIPHER_SUITE_CCMP,
-	WLAN_CIPHER_SUITE_AES_CMAC,
-};
-
 static const struct ieee80211_txrx_stypes
 	wilc_wfi_cfg80211_mgmt_types[NUM_NL80211_IFTYPES] =3D {
 	[NL80211_IFTYPE_STATION] =3D {
@@ -73,53 +65,6 @@ static const struct wiphy_wowlan_support wowlan_support =
=3D {
 	.flags =3D WIPHY_WOWLAN_ANY
 };
=20
-#define CHAN2G(_channel, _freq, _flags) {	 \
-		.band             =3D NL80211_BAND_2GHZ, \
-		.center_freq      =3D (_freq),		 \
-		.hw_value         =3D (_channel),		 \
-		.flags            =3D (_flags),		 \
-		.max_antenna_gain =3D 0,			 \
-		.max_power        =3D 30,			 \
-}
-
-static struct ieee80211_channel ieee80211_2ghz_channels[] =3D {
-	CHAN2G(1,  2412, 0),
-	CHAN2G(2,  2417, 0),
-	CHAN2G(3,  2422, 0),
-	CHAN2G(4,  2427, 0),
-	CHAN2G(5,  2432, 0),
-	CHAN2G(6,  2437, 0),
-	CHAN2G(7,  2442, 0),
-	CHAN2G(8,  2447, 0),
-	CHAN2G(9,  2452, 0),
-	CHAN2G(10, 2457, 0),
-	CHAN2G(11, 2462, 0),
-	CHAN2G(12, 2467, 0),
-	CHAN2G(13, 2472, 0),
-	CHAN2G(14, 2484, 0),
-};
-
-#define RATETAB_ENT(_rate, _hw_value, _flags) {	\
-		.bitrate  =3D (_rate),			\
-		.hw_value =3D (_hw_value),		\
-		.flags    =3D (_flags),			\
-}
-
-static struct ieee80211_rate ieee80211_bitrates[] =3D {
-	RATETAB_ENT(10,  0,  0),
-	RATETAB_ENT(20,  1,  0),
-	RATETAB_ENT(55,  2,  0),
-	RATETAB_ENT(110, 3,  0),
-	RATETAB_ENT(60,  9,  0),
-	RATETAB_ENT(90,  6,  0),
-	RATETAB_ENT(120, 7,  0),
-	RATETAB_ENT(180, 8,  0),
-	RATETAB_ENT(240, 9,  0),
-	RATETAB_ENT(360, 10, 0),
-	RATETAB_ENT(480, 11, 0),
-	RATETAB_ENT(540, 12, 0),
-};
-
 struct p2p_mgmt_data {
 	int size;
 	u8 *buff;
@@ -130,13 +75,6 @@ static u8 curr_channel;
 static u8 p2p_oui[] =3D {0x50, 0x6f, 0x9A, 0x09};
 static u8 p2p_vendor_spec[] =3D {0xdd, 0x05, 0x00, 0x08, 0x40, 0x03};
=20
-static struct ieee80211_supported_band wilc_band_2ghz =3D {
-	.channels =3D ieee80211_2ghz_channels,
-	.n_channels =3D ARRAY_SIZE(ieee80211_2ghz_channels),
-	.bitrates =3D ieee80211_bitrates,
-	.n_bitrates =3D ARRAY_SIZE(ieee80211_bitrates),
-};
-
 #define AGING_TIME	(9 * 1000)
 #define DURING_IP_TIME_OUT	15000
=20
@@ -2110,14 +2048,6 @@ static struct wireless_dev *wilc_wfi_cfg_alloc(void)
 	if (!wdev->wiphy)
 		goto free_mem;
=20
-	wilc_band_2ghz.ht_cap.ht_supported =3D 1;
-	wilc_band_2ghz.ht_cap.cap |=3D (1 << IEEE80211_HT_CAP_RX_STBC_SHIFT);
-	wilc_band_2ghz.ht_cap.mcs.rx_mask[0] =3D 0xff;
-	wilc_band_2ghz.ht_cap.ampdu_factor =3D IEEE80211_HT_MAX_AMPDU_8K;
-	wilc_band_2ghz.ht_cap.ampdu_density =3D IEEE80211_HT_MPDU_DENSITY_NONE;
-
-	wdev->wiphy->bands[NL80211_BAND_2GHZ] =3D &wilc_band_2ghz;
-
 	return wdev;
=20
 free_mem:
@@ -2141,6 +2071,22 @@ struct wireless_dev *wilc_create_wiphy(struct net_de=
vice *net,
=20
 	priv =3D wdev_priv(wdev);
 	priv->wdev =3D wdev;
+
+	memcpy(priv->bitrates, wilc_bitrates, sizeof(wilc_bitrates));
+	memcpy(priv->channels, wilc_2ghz_channels, sizeof(wilc_2ghz_channels));
+	priv->band.bitrates =3D priv->bitrates;
+	priv->band.n_bitrates =3D ARRAY_SIZE(priv->bitrates);
+	priv->band.channels =3D priv->channels;
+	priv->band.n_channels =3D ARRAY_SIZE(wilc_2ghz_channels);
+
+	priv->band.ht_cap.ht_supported =3D 1;
+	priv->band.ht_cap.cap |=3D (1 << IEEE80211_HT_CAP_RX_STBC_SHIFT);
+	priv->band.ht_cap.mcs.rx_mask[0] =3D 0xff;
+	priv->band.ht_cap.ampdu_factor =3D IEEE80211_HT_MAX_AMPDU_8K;
+	priv->band.ht_cap.ampdu_density =3D IEEE80211_HT_MPDU_DENSITY_NONE;
+
+	wdev->wiphy->bands[NL80211_BAND_2GHZ] =3D &priv->band;
+
 	wdev->wiphy->max_scan_ssids =3D WILC_MAX_NUM_PROBED_SSID;
 #ifdef CONFIG_PM
 	wdev->wiphy->wowlan =3D &wowlan_support;
@@ -2148,8 +2094,10 @@ struct wireless_dev *wilc_create_wiphy(struct net_de=
vice *net,
 	wdev->wiphy->max_num_pmkids =3D WILC_MAX_NUM_PMKIDS;
 	wdev->wiphy->max_scan_ie_len =3D 1000;
 	wdev->wiphy->signal_type =3D CFG80211_SIGNAL_TYPE_MBM;
-	wdev->wiphy->cipher_suites =3D cipher_suites;
-	wdev->wiphy->n_cipher_suites =3D ARRAY_SIZE(cipher_suites);
+	memcpy(priv->cipher_suites, wilc_cipher_suites,
+	       sizeof(wilc_cipher_suites));
+	wdev->wiphy->cipher_suites =3D priv->cipher_suites;
+	wdev->wiphy->n_cipher_suites =3D ARRAY_SIZE(wilc_cipher_suites);
 	wdev->wiphy->mgmt_stypes =3D wilc_wfi_cfg80211_mgmt_types;
=20
 	wdev->wiphy->max_remain_on_channel_duration =3D 500;
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/stagin=
g/wilc1000/wilc_wfi_netdevice.h
index c6dad12..e71d949 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -74,6 +74,61 @@ struct wilc_p2p_var {
 	bool is_wilc_ie;
 };
=20
+static const u32 wilc_cipher_suites[] =3D {
+	WLAN_CIPHER_SUITE_WEP40,
+	WLAN_CIPHER_SUITE_WEP104,
+	WLAN_CIPHER_SUITE_TKIP,
+	WLAN_CIPHER_SUITE_CCMP,
+	WLAN_CIPHER_SUITE_AES_CMAC
+};
+
+#define CHAN2G(_channel, _freq, _flags) {	 \
+	.band             =3D NL80211_BAND_2GHZ, \
+	.center_freq      =3D (_freq),		 \
+	.hw_value         =3D (_channel),		 \
+	.flags            =3D (_flags),		 \
+	.max_antenna_gain =3D 0,			 \
+	.max_power        =3D 30,			 \
+}
+
+static const struct ieee80211_channel wilc_2ghz_channels[] =3D {
+	CHAN2G(1,  2412, 0),
+	CHAN2G(2,  2417, 0),
+	CHAN2G(3,  2422, 0),
+	CHAN2G(4,  2427, 0),
+	CHAN2G(5,  2432, 0),
+	CHAN2G(6,  2437, 0),
+	CHAN2G(7,  2442, 0),
+	CHAN2G(8,  2447, 0),
+	CHAN2G(9,  2452, 0),
+	CHAN2G(10, 2457, 0),
+	CHAN2G(11, 2462, 0),
+	CHAN2G(12, 2467, 0),
+	CHAN2G(13, 2472, 0),
+	CHAN2G(14, 2484, 0)
+};
+
+#define RATETAB_ENT(_rate, _hw_value, _flags) {	\
+	.bitrate  =3D (_rate),			\
+	.hw_value =3D (_hw_value),		\
+	.flags    =3D (_flags),			\
+}
+
+static struct ieee80211_rate wilc_bitrates[] =3D {
+	RATETAB_ENT(10,  0,  0),
+	RATETAB_ENT(20,  1,  0),
+	RATETAB_ENT(55,  2,  0),
+	RATETAB_ENT(110, 3,  0),
+	RATETAB_ENT(60,  9,  0),
+	RATETAB_ENT(90,  6,  0),
+	RATETAB_ENT(120, 7,  0),
+	RATETAB_ENT(180, 8,  0),
+	RATETAB_ENT(240, 9,  0),
+	RATETAB_ENT(360, 10, 0),
+	RATETAB_ENT(480, 11, 0),
+	RATETAB_ENT(540, 12, 0)
+};
+
 struct wilc_priv {
 	struct wireless_dev *wdev;
 	struct cfg80211_scan_request *scan_req;
@@ -104,6 +159,11 @@ struct wilc_priv {
 	struct network_info scanned_shadow[MAX_NUM_SCANNED_NETWORKS_SHADOW];
 	int scanned_cnt;
 	struct wilc_p2p_var p2p;
+
+	struct ieee80211_channel channels[ARRAY_SIZE(wilc_2ghz_channels)];
+	struct ieee80211_rate bitrates[ARRAY_SIZE(wilc_bitrates)];
+	struct ieee80211_supported_band band;
+	u32 cipher_suites[ARRAY_SIZE(wilc_cipher_suites)];
 };
=20
 struct frame_reg {
--=20
2.7.4

