Return-Path: <SRS0=K5U7=PM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E843CC43387
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Jan 2019 06:11:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ACEEA2070D
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Jan 2019 06:11:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="Y8DKW9W7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbfADGL0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 4 Jan 2019 01:11:26 -0500
Received: from mail-eopbgr750094.outbound.protection.outlook.com ([40.107.75.94]:53664
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726169AbfADGLZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 Jan 2019 01:11:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6XAPuw9j1TG7Z2dfIsTBPGsklP+jwXYGgfCzMR1yZX0=;
 b=Y8DKW9W7vwogNAOxm59HHXndnSmRhnw1AMNitRmwTUpYc1fftLXB0cSzxYb6vyV6iRcf9JNzEz4exFilyYG/Zc7T/b79Z/sv0Z6Gd4gPSiV7+FJF/KQyWp7kiUwgtUcuO2ikFtlEYW1RLGakY+Cryz6b6nYkio0GiqYEDl+rwzc=
Received: from DM6PR06MB5804.namprd06.prod.outlook.com (20.179.161.141) by
 DM6PR06MB5577.namprd06.prod.outlook.com (20.178.31.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1495.6; Fri, 4 Jan 2019 06:11:11 +0000
Received: from DM6PR06MB5804.namprd06.prod.outlook.com
 ([fe80::14e6:e072:bc55:7bea]) by DM6PR06MB5804.namprd06.prod.outlook.com
 ([fe80::14e6:e072:bc55:7bea%4]) with mapi id 15.20.1495.005; Fri, 4 Jan 2019
 06:11:11 +0000
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
Subject: [PATCH 3/6] brcmfmac: send port authorized event for FT-802.1X
Thread-Topic: [PATCH 3/6] brcmfmac: send port authorized event for FT-802.1X
Thread-Index: AQHUo/RKcZw/GSmVS0GrNDynXq4wyw==
Date:   Fri, 4 Jan 2019 06:11:11 +0000
Message-ID: <1546582221-143220-3-git-send-email-chi-hsien.lin@cypress.com>
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
x-microsoft-exchange-diagnostics: 1;DM6PR06MB5577;6:VZA82SlJ7KpLtpqYx1T4ez2IxN+VzpGKTCqbfyOo/W67FgTOptI6EedPd7KVthvQMMgt4NopQ4BeSpKrJNOqrZnf/3iJ/fvBuBYmcwxa07qys5rX5s7zp4S9j+mIkfPqsN9EgdcRMZIC43oyd/0uuspD11/PsnWjaoVq0wPQEfT/nCQj88jnolEOtnd/EdP2apQQeDaAsg0qEeokpRap8CgsSY2Ete2ZipGxY2uu05v/AHBpI15ALE7ILyF5kf5LCA3sN4+dQfb8grhqiPG6vBERIYnmvSxGtD4Z3uYthF5saJXh2OnSnyhbJ0rX4MHn/1Ys+xDhB5jmr8EPFKGAKEGGlF26vvEbDY9ZnFBI5XEqwU0BI6yYoed8Da9xmhwbS/6fBSZ+KccLXAt3/x0enuuOvN6N2eX6SYcC9bc4SKOx2cpjVDtZXOAE7X3dTvN8933XcpVhXjX1axXbjoSCqQ==;5:9Rl1yKdPiRKaBPNcavNn+3NQZOBewFYRGBpL0v7P7SfHeBqAvYmKpp6BJID5nW+Ho69vuwprOahOw/MleLPnj7Kq9HfaOl0K7kFvF3oMZaDlyuT6EMt+SqpVqhx1nEJRFtrDiU4/a/HNAsnqhRa+K7IAeGkCgXAKv/N+nfDu5bRtcgjnakqu1uifRwwelvWuq+BzBm83SglWM1gZRaQrWg==;7:rsN9Pb5FafNj6eHlKS6C+oij7URDTkgeOOntTNW/9iJ51yzF/8hn47K8/Dwd0vv5EqFnFVJlW1YSYZURFA5fGj/Exeh15YkOWJ22mnpfWm21c4p7sABdbjqojEk2ZFdvBw+SkbEzYADmjysr+LSHTA==
x-ms-office365-filtering-correlation-id: aab8a930-99d7-4c73-8ca7-08d6720b6c76
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:DM6PR06MB5577;
x-ms-traffictypediagnostic: DM6PR06MB5577:
x-microsoft-antispam-prvs: <DM6PR06MB557723FDB1F909DED280875CBB8E0@DM6PR06MB5577.namprd06.prod.outlook.com>
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(3230021)(908002)(999002)(5005026)(6040522)(8220060)(2401047)(8121501046)(3002001)(93006095)(93001095)(3231475)(944501520)(52105112)(10201501046)(6055026)(6041310)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(20161123562045)(20161123558120)(201708071742011)(7699051)(76991095);SRVR:DM6PR06MB5577;BCL:0;PCL:0;RULEID:;SRVR:DM6PR06MB5577;
x-forefront-prvs: 0907F58A24
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(39860400002)(136003)(366004)(346002)(396003)(199004)(189003)(54906003)(6436002)(446003)(106356001)(186003)(26005)(105586002)(102836004)(11346002)(6486002)(316002)(2501003)(6916009)(5640700003)(71190400001)(71200400001)(486006)(99286004)(476003)(2616005)(2906002)(97736004)(68736007)(6116002)(3846002)(36756003)(86362001)(575784001)(81166006)(81156014)(14454004)(478600001)(8676002)(72206003)(53936002)(4326008)(6512007)(107886003)(305945005)(25786009)(14444005)(76176011)(7736002)(256004)(66066001)(5660300001)(52116002)(8936002)(386003)(2351001)(6506007);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR06MB5577;H:DM6PR06MB5804.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: GCO+lzdnyum7Dq0tn8DxaYZMCdBSWtcYciCbF49mZSKAuWO+Yvc+Uoi5h7o+b1IXcFzVVsoCIv4W/AA4QvShQkKJpuDof7941grrei0JjrLbnyfnr23uHpyfMo3iE3MlFcJPI3n+s0HrQehJmculCtZKrJPKXLlorumo9eSCiucg6aC6RoVky9ELznh/27h2nHpckx1CD5zRIt/HBa6IcfYTmcWxXyPhBmeBhIrL4OJTr0V3bnj7it0dlqcf8gnEw3cx8nEAaYdeQNhrNC8HL6nH5pmOF+hmOkCubwjIvgbKQdlPUXSVhFW2iVZTXf9u
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aab8a930-99d7-4c73-8ca7-08d6720b6c76
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2019 06:11:11.8735
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR06MB5577
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Chung-Hsien Hsu <stanley.hsu@cypress.com>

With FT-802.1X, driver should send a port authorized event right after
sending a roamed event. It is used to indicate that a new AP is already
authorized so 802.1X is not required.

Signed-off-by: Chung-Hsien Hsu <stanley.hsu@cypress.com>
Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 8 ++++++++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h | 1 +
 2 files changed, 9 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/=
drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index ad0d775a1244..854abf010aa7 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -1607,6 +1607,7 @@ brcmf_set_key_mgmt(struct net_device *ndev, struct cf=
g80211_connect_params *sme)
 	u16 count;
=20
 	profile->use_fwsup =3D BRCMF_PROFILE_FWSUP_NONE;
+	profile->is_ft =3D false;
=20
 	if (!sme->crypto.n_akm_suites)
 		return 0;
@@ -1651,11 +1652,13 @@ brcmf_set_key_mgmt(struct net_device *ndev, struct =
cfg80211_connect_params *sme)
 			break;
 		case WLAN_AKM_SUITE_FT_8021X:
 			val =3D WPA2_AUTH_UNSPECIFIED | WPA2_AUTH_FT;
+			profile->is_ft =3D true;
 			if (sme->want_1x)
 				profile->use_fwsup =3D BRCMF_PROFILE_FWSUP_1X;
 			break;
 		case WLAN_AKM_SUITE_FT_PSK:
 			val =3D WPA2_AUTH_PSK | WPA2_AUTH_FT;
+			profile->is_ft =3D true;
 			break;
 		default:
 			brcmf_err("invalid cipher group (%d)\n",
@@ -5465,6 +5468,11 @@ brcmf_bss_roaming_done(struct brcmf_cfg80211_info *c=
fg,
 	cfg80211_roamed(ndev, &roam_info, GFP_KERNEL);
 	brcmf_dbg(CONN, "Report roaming result\n");
=20
+	if (profile->use_fwsup =3D=3D BRCMF_PROFILE_FWSUP_1X && profile->is_ft) {
+		cfg80211_port_authorized(ndev, profile->bssid, GFP_KERNEL);
+		brcmf_dbg(CONN, "Report port authorized\n");
+	}
+
 	set_bit(BRCMF_VIF_STATUS_CONNECTED, &ifp->vif->sme_state);
 	brcmf_dbg(TRACE, "Exit\n");
 	return err;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h b/=
drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
index 9a6287f084a9..6a7dec908b6f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
@@ -133,6 +133,7 @@ struct brcmf_cfg80211_profile {
 	struct brcmf_cfg80211_security sec;
 	struct brcmf_wsec_key key[BRCMF_MAX_DEFAULT_KEYS];
 	enum brcmf_profile_fwsup use_fwsup;
+	bool is_ft;
 };
=20
 /**
--=20
2.1.0

