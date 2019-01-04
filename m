Return-Path: <SRS0=K5U7=PM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DB26C43387
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Jan 2019 06:11:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A4F52070D
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Jan 2019 06:11:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="SundCMUk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727203AbfADGLb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 4 Jan 2019 01:11:31 -0500
Received: from mail-eopbgr750094.outbound.protection.outlook.com ([40.107.75.94]:53664
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726106AbfADGLa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 Jan 2019 01:11:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L/pfoaxQ43Jn0h7Nl6HrRc2ACESBqs58pNdBv6KanZI=;
 b=SundCMUkCj6md6PSk62SitGGbhlfHOMxEU7RQktoZVyFirZPucGmd3s3oWE4xgmfxycSqGBdBO004CktGWdC1AkwMw6XKZrp+8pSGoSmApE0a1Tu7nFLkO/s/9j3jlq4c9wIRTpxwK9R1JnujeI2+Eq7i1xouT0ADY3UfaTdiuw=
Received: from DM6PR06MB5804.namprd06.prod.outlook.com (20.179.161.141) by
 DM6PR06MB5577.namprd06.prod.outlook.com (20.178.31.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1495.6; Fri, 4 Jan 2019 06:11:16 +0000
Received: from DM6PR06MB5804.namprd06.prod.outlook.com
 ([fe80::14e6:e072:bc55:7bea]) by DM6PR06MB5804.namprd06.prod.outlook.com
 ([fe80::14e6:e072:bc55:7bea%4]) with mapi id 15.20.1495.005; Fri, 4 Jan 2019
 06:11:16 +0000
From:   Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Stanley Hsu <Stanley.Hsu@cypress.com>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Subject: [PATCH 6/6] brcmfmac: add support for SAE authentication offload
Thread-Topic: [PATCH 6/6] brcmfmac: add support for SAE authentication offload
Thread-Index: AQHUo/RNhmsxZzUrEUSyqHD3Q3AqWw==
Date:   Fri, 4 Jan 2019 06:11:16 +0000
Message-ID: <1546582221-143220-6-git-send-email-chi-hsien.lin@cypress.com>
References: <1546582221-143220-1-git-send-email-chi-hsien.lin@cypress.com>
In-Reply-To: <1546582221-143220-1-git-send-email-chi-hsien.lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [12.110.209.245]
x-clientproxiedby: BYAPR05CA0038.namprd05.prod.outlook.com
 (2603:10b6:a03:74::15) To DM6PR06MB5804.namprd06.prod.outlook.com
 (2603:10b6:5:1a6::13)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM6PR06MB5577;6:5/vyPIPT56fydBYlJceIehLez3h3saaK8z/ph0XV6XKOyvgw4jxkgbmVDnM+AGvHnY6Y7iKUXwwMKtITItiAy/k+Ki3gWUVTScn2eUuxs2WGDGBwLn+3FzyxHwx4yo0KBtxrjyVQ7g/sGiFTMpIKUsxrtboviOqFkGbJDjnqIZkNxxS97X2H5DwGp06wcMtb+txBL4GP5AJ55QtZHT3dfJOU9T24+8ndzQBWJX/LH4V9RhhY0ddJmU5Lhfaz9XIJSfnX9/fplICduiyXpq/veWTx83/vjRZ2QaYnFb8xbv8MFM92Sbzjm/IcAyuw0MNQBfJD2pNur1xfSUx1PshICulQY+p+v/11MQHnHxExDJFV5WosiIvFUhrNi1euipYkXQrC2p8/5aK3yo6oXaFgkSsh7zafvAK4+UDWCBGU3puThlO3r/ssxE5qC4vTmZ1REe8vh0hfJ2RmgQHkEFAkDA==;5:r12q5AxLekXUDSqvfsWwDXDJYewrT5YKcdK38jkiwarFx6X6je+FbDvJQYKNTihd1G6G0OrivgzUMU4zC2kHgeWokbYk8OStVhHjiwlsPKibVRm9w9Z0Pw3oEfdgXaFHBWyCI62xUVzR6Yfa90TfutW+EisTPGoirCfeXcmVQX233Wb92P80lowEkBwydqyu20UNib9j2F/097WdU205sQ==;7:bA8i1jHoo679EhDfrjle4jkmb27pbW5cxalKJ6pJafcHndnC/dxdTbpt7Vu+MKLjjVXR3FY9VmUQg6v86vj9hMwKDZ/xHkCmSFN5vhjbdFSHBA/jszXazA1WBia28jjsp4jlNgBc9LtcAgYJMzc+Dg==
x-ms-office365-filtering-correlation-id: b25fb2a9-a9f5-4604-f2a3-08d6720b6f86
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:DM6PR06MB5577;
x-ms-traffictypediagnostic: DM6PR06MB5577:
x-microsoft-antispam-prvs: <DM6PR06MB55772A17F333858BC0BD7C8DBB8E0@DM6PR06MB5577.namprd06.prod.outlook.com>
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(3230021)(908002)(999002)(5005026)(6040522)(8220060)(2401047)(8121501046)(3002001)(93006095)(93001095)(3231475)(944501520)(52105112)(10201501046)(6055026)(6041310)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(20161123562045)(20161123558120)(201708071742011)(7699051)(76991095);SRVR:DM6PR06MB5577;BCL:0;PCL:0;RULEID:;SRVR:DM6PR06MB5577;
x-forefront-prvs: 0907F58A24
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(39860400002)(136003)(366004)(346002)(396003)(199004)(189003)(54906003)(6436002)(446003)(106356001)(186003)(26005)(105586002)(102836004)(11346002)(6486002)(316002)(2501003)(6916009)(5640700003)(71190400001)(71200400001)(486006)(99286004)(476003)(2616005)(2906002)(97736004)(68736007)(6116002)(3846002)(36756003)(86362001)(575784001)(81166006)(81156014)(14454004)(478600001)(8676002)(72206003)(53936002)(4326008)(6512007)(107886003)(305945005)(25786009)(551544002)(14444005)(76176011)(7736002)(256004)(66066001)(5660300001)(52116002)(8936002)(386003)(2351001)(6506007);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR06MB5577;H:DM6PR06MB5804.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: pMp2yUptyZyo649ldlyCmSMXk2xgwV9VRnn4YxDtuxWdngGjApEHXTNqrhCn2LLgZHxQ4Fr1a5ilfZrkMu5/oRINfctnPDIeBi2T71CbMw/ygX9K3IpHMy8PAC1uqRrVk1I8/dpD4ZTEGM6pS9wpg4R9L1kRssHSN2C1zH2CPLaTwI7P8Vm6uzVxiodHxHKivRNNYxj3XZQhAd6LbzQKhZT/Y7+OHOW969OoCiSFUS2fAxFVPersSkWTmDPVOnKcI/5h4hD766r+GhHa5qKizj5Gy9WB3l4Pq3M96VCrExGPRj5c2ez2YWhLBRyRZ4Xm
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b25fb2a9-a9f5-4604-f2a3-08d6720b6f86
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2019 06:11:16.4878
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR06MB5577
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Chung-Hsien Hsu <stanley.hsu@cypress.com>

The firmware may have SAE authentication code built-in. This is
detected by the driver and indicated in the wiphy features flags.
User-space can use this flag to determine whether or not to provide
the password material for SAE authentication in the nl80211 CONNECT
command.

Signed-off-by: Chung-Hsien Hsu <stanley.hsu@cypress.com>
Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 72 ++++++++++++++++++=
++--
 .../broadcom/brcm80211/brcmfmac/cfg80211.h         |  3 +-
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c |  1 +
 .../wireless/broadcom/brcm80211/brcmfmac/feature.h |  4 +-
 .../broadcom/brcm80211/brcmfmac/fwil_types.h       | 13 ++++
 .../broadcom/brcm80211/include/brcmu_wifi.h        |  2 +
 6 files changed, 88 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/=
drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 854abf010aa7..8e48887e9d14 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -1256,6 +1256,30 @@ static int brcmf_set_pmk(struct brcmf_if *ifp, const=
 u8 *pmk_data, u16 pmk_len)
 	return err;
 }
=20
+static int brcmf_set_sae_password(struct brcmf_if *ifp, const u8 *pwd_data=
,
+				  u16 pwd_len)
+{
+	struct brcmf_wsec_sae_pwd_le sae_pwd;
+	int err;
+
+	if (pwd_len > BRCMF_WSEC_MAX_SAE_PASSWORD_LEN) {
+		brcmf_err("sae_password must be less than %d\n",
+			  BRCMF_WSEC_MAX_SAE_PASSWORD_LEN);
+		return -EINVAL;
+	}
+
+	sae_pwd.key_len =3D cpu_to_le16(pwd_len);
+	memcpy(sae_pwd.key, pwd_data, pwd_len);
+
+	err =3D brcmf_fil_iovar_data_set(ifp, "sae_password", &sae_pwd,
+				       sizeof(sae_pwd));
+	if (err < 0)
+		brcmf_err("failed to set SAE password in firmware (len=3D%u)\n",
+			  pwd_len);
+
+	return err;
+}
+
 static void brcmf_link_down(struct brcmf_cfg80211_vif *vif, u16 reason)
 {
 	struct brcmf_cfg80211_info *cfg =3D wiphy_to_cfg(vif->wdev.wiphy);
@@ -1470,6 +1494,8 @@ static s32 brcmf_set_wpa_version(struct net_device *n=
dev,
 		val =3D WPA_AUTH_PSK | WPA_AUTH_UNSPECIFIED;
 	else if (sme->crypto.wpa_versions & NL80211_WPA_VERSION_2)
 		val =3D WPA2_AUTH_PSK | WPA2_AUTH_UNSPECIFIED;
+	else if (sme->crypto.wpa_versions & NL80211_WPA_VERSION_3)
+		val =3D WPA3_AUTH_SAE_PSK;
 	else
 		val =3D WPA_AUTH_DISABLED;
 	brcmf_dbg(CONN, "setting wpa_auth to 0x%0x\n", val);
@@ -1500,6 +1526,10 @@ static s32 brcmf_set_auth_type(struct net_device *nd=
ev,
 		val =3D 1;
 		brcmf_dbg(CONN, "shared key\n");
 		break;
+	case NL80211_AUTHTYPE_SAE:
+		val =3D 3;
+		brcmf_dbg(CONN, "SAE authentication\n");
+		break;
 	default:
 		val =3D 2;
 		brcmf_dbg(CONN, "automatic, auth type (%d)\n", sme->auth_type);
@@ -1665,6 +1695,16 @@ brcmf_set_key_mgmt(struct net_device *ndev, struct c=
fg80211_connect_params *sme)
 				  sme->crypto.cipher_group);
 			return -EINVAL;
 		}
+	} else if (val & WPA3_AUTH_SAE_PSK) {
+		switch (sme->crypto.akm_suites[0]) {
+		case WLAN_AKM_SUITE_SAE:
+			val =3D WPA3_AUTH_SAE_PSK;
+			break;
+		default:
+			brcmf_err("invalid cipher group (%d)\n",
+				  sme->crypto.cipher_group);
+			return -EINVAL;
+		}
 	}
=20
 	if (profile->use_fwsup =3D=3D BRCMF_PROFILE_FWSUP_1X)
@@ -1734,7 +1774,8 @@ brcmf_set_sharedkey(struct net_device *ndev,
 	brcmf_dbg(CONN, "wpa_versions 0x%x cipher_pairwise 0x%x\n",
 		  sec->wpa_versions, sec->cipher_pairwise);
=20
-	if (sec->wpa_versions & (NL80211_WPA_VERSION_1 | NL80211_WPA_VERSION_2))
+	if (sec->wpa_versions & (NL80211_WPA_VERSION_1 | NL80211_WPA_VERSION_2 |
+				 NL80211_WPA_VERSION_3))
 		return 0;
=20
 	if (!(sec->cipher_pairwise &
@@ -1939,7 +1980,13 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct n=
et_device *ndev,
 		goto done;
 	}
=20
-	if (sme->crypto.psk) {
+	if (sme->crypto.sae_pwd) {
+		brcmf_dbg(INFO, "using SAE offload\n");
+		profile->use_fwsup =3D BRCMF_PROFILE_FWSUP_SAE;
+	}
+
+	if (sme->crypto.psk &&
+	    profile->use_fwsup !=3D BRCMF_PROFILE_FWSUP_SAE) {
 		if (WARN_ON(profile->use_fwsup !=3D BRCMF_PROFILE_FWSUP_NONE)) {
 			err =3D -EINVAL;
 			goto done;
@@ -1957,12 +2004,23 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct =
net_device *ndev,
 		}
 	}
=20
-	if (profile->use_fwsup =3D=3D BRCMF_PROFILE_FWSUP_PSK) {
+	if (profile->use_fwsup =3D=3D BRCMF_PROFILE_FWSUP_PSK)
 		err =3D brcmf_set_pmk(ifp, sme->crypto.psk,
 				    BRCMF_WSEC_MAX_PSK_LEN);
-		if (err)
+	else if (profile->use_fwsup =3D=3D BRCMF_PROFILE_FWSUP_SAE) {
+		/* clean up user-space RSNE */
+		if (brcmf_fil_iovar_data_set(ifp, "wpaie", NULL, 0)) {
+			brcmf_err("failed to clean up user-space RSNE\n");
 			goto done;
+		}
+		err =3D brcmf_set_sae_password(ifp, sme->crypto.sae_pwd,
+					     sme->crypto.sae_pwd_len);
+		if (!err && sme->crypto.psk)
+			err =3D brcmf_set_pmk(ifp, sme->crypto.psk,
+					    BRCMF_WSEC_MAX_PSK_LEN);
 	}
+	if (err)
+		goto done;
=20
 	/* Join with specific BSSID and cached SSID
 	 * If SSID is zero join based on BSSID only
@@ -5279,7 +5337,8 @@ static bool brcmf_is_linkup(struct brcmf_cfg80211_vif=
 *vif,
 	if (event =3D=3D BRCMF_E_SET_SSID && status =3D=3D BRCMF_E_STATUS_SUCCESS=
) {
 		brcmf_dbg(CONN, "Processing set ssid\n");
 		memcpy(vif->profile.bssid, e->addr, ETH_ALEN);
-		if (vif->profile.use_fwsup !=3D BRCMF_PROFILE_FWSUP_PSK)
+		if (vif->profile.use_fwsup !=3D BRCMF_PROFILE_FWSUP_PSK &&
+		    vif->profile.use_fwsup !=3D BRCMF_PROFILE_FWSUP_SAE)
 			return true;
=20
 		set_bit(BRCMF_VIF_STATUS_ASSOC_SUCCESS, &vif->sme_state);
@@ -6573,6 +6632,9 @@ static int brcmf_setup_wiphy(struct wiphy *wiphy, str=
uct brcmf_if *ifp)
 				      NL80211_EXT_FEATURE_4WAY_HANDSHAKE_STA_PSK);
 		wiphy_ext_feature_set(wiphy,
 				      NL80211_EXT_FEATURE_4WAY_HANDSHAKE_STA_1X);
+		if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_SAE))
+			wiphy_ext_feature_set(wiphy,
+					      NL80211_EXT_FEATURE_SAE_OFFLOAD);
 	}
 	wiphy->mgmt_stypes =3D brcmf_txrx_stypes;
 	wiphy->max_remain_on_channel_duration =3D 5000;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h b/=
drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
index 6a7dec908b6f..c9d4b839b60d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
@@ -118,7 +118,8 @@ struct brcmf_cfg80211_security {
 enum brcmf_profile_fwsup {
 	BRCMF_PROFILE_FWSUP_NONE,
 	BRCMF_PROFILE_FWSUP_PSK,
-	BRCMF_PROFILE_FWSUP_1X
+	BRCMF_PROFILE_FWSUP_1X,
+	BRCMF_PROFILE_FWSUP_SAE
 };
=20
 /**
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c b/d=
rivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
index 4c5a3995dc35..e8b4eb0b67f9 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
@@ -50,6 +50,7 @@ static const struct brcmf_feat_fwcap brcmf_fwcap_map[] =
=3D {
 	{ BRCMF_FEAT_P2P, "p2p" },
 	{ BRCMF_FEAT_MONITOR, "monitor" },
 	{ BRCMF_FEAT_MONITOR_FMT_RADIOTAP, "rtap" },
+	{ BRCMF_FEAT_SAE, "sae" },
 };
=20
 #ifdef DEBUG
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h b/d=
rivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
index 0b4974df353a..d8b6ba9d0967 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
@@ -35,6 +35,7 @@
  * FWSUP: Firmware supplicant.
  * MONITOR: firmware can pass monitor packets to host.
  * MONITOR_FMT_RADIOTAP: firmware provides monitor packets with radiotap h=
eader
+ * SAE: simultaneous authentication of equals
  */
 #define BRCMF_FEAT_LIST \
 	BRCMF_FEAT_DEF(MBSS) \
@@ -52,7 +53,8 @@
 	BRCMF_FEAT_DEF(GSCAN) \
 	BRCMF_FEAT_DEF(FWSUP) \
 	BRCMF_FEAT_DEF(MONITOR) \
-	BRCMF_FEAT_DEF(MONITOR_FMT_RADIOTAP)
+	BRCMF_FEAT_DEF(MONITOR_FMT_RADIOTAP) \
+	BRCMF_FEAT_DEF(SAE)
=20
 /*
  * Quirks:
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h =
b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
index 39ac1bbb6cc0..d81ad6542513 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
@@ -72,6 +72,8 @@
 #define BRCMF_WSEC_MAX_PSK_LEN		32
 #define	BRCMF_WSEC_PASSPHRASE		BIT(0)
=20
+#define BRCMF_WSEC_MAX_SAE_PASSWORD_LEN 128
+
 /* primary (ie tx) key */
 #define BRCMF_PRIMARY_KEY		(1 << 1)
 #define DOT11_BSSTYPE_ANY		2
@@ -529,6 +531,17 @@ struct brcmf_wsec_pmk_le {
 	u8 key[2 * BRCMF_WSEC_MAX_PSK_LEN + 1];
 };
=20
+/**
+ * struct brcmf_wsec_sae_pwd_le - firmware SAE password material.
+ *
+ * @key_len: number of octets in key materials.
+ * @key: SAE password material.
+ */
+struct brcmf_wsec_sae_pwd_le {
+	__le16 key_len;
+	u8 key[BRCMF_WSEC_MAX_SAE_PASSWORD_LEN];
+};
+
 /* Used to get specific STA parameters */
 struct brcmf_scb_val_le {
 	__le32 val;
diff --git a/drivers/net/wireless/broadcom/brcm80211/include/brcmu_wifi.h b=
/drivers/net/wireless/broadcom/brcm80211/include/brcmu_wifi.h
index dddebaa60352..60d7e3221b35 100644
--- a/drivers/net/wireless/broadcom/brcm80211/include/brcmu_wifi.h
+++ b/drivers/net/wireless/broadcom/brcm80211/include/brcmu_wifi.h
@@ -242,6 +242,8 @@ static inline bool ac_bitmap_tst(u8 bitmap, int prec)
 #define WPA2_AUTH_FT		0x4000	/* Fast BSS Transition */
 #define WPA2_AUTH_PSK_SHA256	0x8000	/* PSK with SHA256 key derivation */
=20
+#define WPA3_AUTH_SAE_PSK	0x40000	/* SAE with 4-way handshake */
+
 #define DOT11_DEFAULT_RTS_LEN		2347
 #define DOT11_DEFAULT_FRAG_LEN		2346
=20
--=20
2.1.0

