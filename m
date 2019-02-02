Return-Path: <SRS0=M3au=QJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEB6CC282D7
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Feb 2019 19:17:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 884BE2082C
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Feb 2019 19:17:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="LF9NnUN/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbfBBTRK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 2 Feb 2019 14:17:10 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:12667 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726784AbfBBTRK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Feb 2019 14:17:10 -0500
X-IronPort-AV: E=Sophos;i="5.56,553,1539673200"; 
   d="scan'208";a="26232214"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES128-SHA; 02 Feb 2019 12:17:09 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.37) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sat, 2 Feb 2019 12:17:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HY8yqSaUMdNKviwoaHd/tppUcmbpgwyyEqKZWq474sE=;
 b=LF9NnUN/Dee/gEcOfdqJDQpfRYSbhsgc4AU0U16aj6B7VpFuHsbOBTP4C3DZz8ynpldN+15xZ2i/NgvtVVl5A1Y/ThjxMFVBB4D7pbWj8syUDtBx6bqulgwfZ9jSrtu4/4SAYy9+VV4zix4DE9Y/dp7OiOMNB37SMYzKChJAhaM=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2998.namprd11.prod.outlook.com (20.177.224.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1558.21; Sat, 2 Feb 2019 19:17:08 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1580.019; Sat, 2 Feb 2019
 19:17:08 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 06/15] staging: wilc1000: make use of iface type to identify
 p2p interface
Thread-Topic: [PATCH 06/15] staging: wilc1000: make use of iface type to
 identify p2p interface
Thread-Index: AQHUuyvjJZwJW3nTWkS6DFmJssE7qA==
Date:   Sat, 2 Feb 2019 19:17:07 +0000
Message-ID: <1549134974-5545-7-git-send-email-ajay.kathat@microchip.com>
References: <1549134974-5545-1-git-send-email-ajay.kathat@microchip.com>
In-Reply-To: <1549134974-5545-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR0101CA0011.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:21::21) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.7.4
x-originating-ip: [49.205.218.11]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2998;6:oBvqZrdCldX6w2jEkSeOBKjc+kkTQF92W/dzFHY8O64Lg3GC4R96cFNyrXBuXYlnatHwwMYLCCmiH9lZVUR0DWJL4N6Vc3AVAlcoN0OI8EaOjdz15zzh8N+B3X/CPuUfmHOPvfaLOQATbPhyEwCEGkIXsnhcwj1VLvAvidV6yxeEwt6ye9g7ttStKXsZ7u/jVtmElF8CASYL3DIYAqWMwjP4qYByPB/ppIcsCTio/AcrdL77NHDpHuKS4Zbj/swLqjdOdI/Z+h0e0QIhbZ/1QFC8aRXX+s1z/JiaVgDCEb3qKAWy0K1vBecPcLHnfCJB4ssJIXEh+UTMsHeeoQsxfvtRWQBkZRmc0UDmKHXWi1T2cH/G4bWrpAyLtRYSTDuek1geUGtYRXH9xa9YGeSLYBoCubY857seCx197g2iH53SWwYvJem/NDCBgOTMmt+DujOYpEuJiap42LbtmTEVJA==;5:m/Mtj2LXoWy/QCuPRJlUfXL439M3/DRj4QbNlOT3alVSpDDJu7VdSnZAgt+uuzf7JUbHNqcGWVlocRaJ3BWTvvF+phyHZkNIqE2X3wJOq/KhXp9ub+h832Fw01W2iierQfJ/NqhIkS8H4Cimd3AJ7ztwurYRIP+Qn20HuIgLl0tgXP0r+WralaGGxvxvWs6ltmKdYVNM//55YuZKMWWABw==;7:KTdVe0+/hkzJcP40xYNJZyO6JRHezNI4oo3funAwdA/s0z+57gCB3/yNkjOFmAg7r9Nlpmi7BgToa4dVXyG1MWcTcOz2dF5uDZS1QqKc3MZx2dqyq52m1RO1sDVTfr9WSmoI5Xc+jNMgHfHljuV/iQ==
x-ms-office365-filtering-correlation-id: 770ebfe9-caf6-4a89-1c0a-08d68943060b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2998;
x-ms-traffictypediagnostic: BYAPR11MB2998:
x-microsoft-antispam-prvs: <BYAPR11MB2998825788E67A1F97541812E3930@BYAPR11MB2998.namprd11.prod.outlook.com>
x-forefront-prvs: 09368DB063
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(376002)(366004)(346002)(39850400004)(189003)(199004)(25786009)(107886003)(105586002)(78486014)(36756003)(50226002)(2501003)(6916009)(66066001)(8936002)(3846002)(4326008)(305945005)(7736002)(71200400001)(71190400001)(8676002)(6116002)(54906003)(81166006)(316002)(446003)(81156014)(6436002)(6486002)(2906002)(2616005)(486006)(476003)(76176011)(256004)(99286004)(11346002)(14444005)(52116002)(53936002)(72206003)(478600001)(186003)(386003)(26005)(14454004)(106356001)(86362001)(5640700003)(97736004)(2351001)(68736007)(6506007)(102836004)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2998;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: UiVBgjLlRA9bQuldjdLcbpR/tvIXHD58EBFR0WO/nnOuxCdzP4C6gNoOUDzI1oYnFD17RNlPEbNys1kX9i78xj/SprafwxL2EPTfIYi9kXPbT9F+Eu08GYVdUg3oI3yuQR3jz6Fiem9CdqYttQxcXWdL5hsgSE9GSgowAAIjnnJ9inDybb6E8s7jYSyN1wdQv1EW2bYfD1sI7v5XqnHPrRapTiXnlJZZ7ZJ6dDG6doi3bWzddl6nDnISxs+D+Pq8MAXIkBBuh1Zq8HUKb3ykCVq1MjwSOcaicYuVWqnsaLrSsxXXa8UQb5bP5Hex8k3ooT6sX8Z+1+9NmSlKgzCkv6V02rH3cg/kkXxYFpgBTWmMuHdK0zMiV0Qb+J2rx9u+w9BSXPU9H1DcEuNCTudJV+EYT5LDdsz04Uj6Ko88/+E=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 770ebfe9-caf6-4a89-1c0a-08d68943060b
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2019 19:17:05.3703
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2998
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Remove SSID string compare instead use interface type check for p2p
client interface.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.h         |  1 -
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 19 ++++++-------------
 2 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wi=
lc1000/host_interface.h
index 7f3fc4c..8fa97a7 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -153,7 +153,6 @@ struct host_if_drv {
 	struct remain_ch remain_on_ch;
 	u8 remain_on_ch_pending;
 	u64 p2p_timeout;
-	u8 p2p_connect;
=20
 	enum host_if_state hif_state;
=20
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/st=
aging/wilc1000/wilc_wfi_cfgoperations.c
index 95230d7..faffcc8 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -159,7 +159,7 @@ static void cfg_connect_result(enum conn_event conn_dis=
conn_evt, u8 mac_status,
 			connect_status =3D WLAN_STATUS_UNSPECIFIED_FAILURE;
 			wilc_wlan_set_bssid(priv->dev, NULL, WILC_STATION_MODE);
=20
-			if (!wfi_drv->p2p_connect)
+			if (vif->iftype !=3D WILC_CLIENT_MODE)
 				wlan_channel =3D INVALID_CHANNEL;
=20
 			netdev_err(dev, "Unspecified failure\n");
@@ -185,7 +185,7 @@ static void cfg_connect_result(enum conn_event conn_dis=
conn_evt, u8 mac_status,
 		eth_zero_addr(priv->associated_bss);
 		wilc_wlan_set_bssid(priv->dev, NULL, WILC_STATION_MODE);
=20
-		if (!wfi_drv->p2p_connect)
+		if (vif->iftype !=3D WILC_CLIENT_MODE)
 			wlan_channel =3D INVALID_CHANNEL;
=20
 		if (wfi_drv->ifc_up && dev =3D=3D wl->vif[1]->ndev)
@@ -329,11 +329,6 @@ static int connect(struct wiphy *wiphy, struct net_dev=
ice *dev,
=20
 	vif->connecting =3D true;
=20
-	if (!(strncmp(sme->ssid, "DIRECT-", 7)))
-		wfi_drv->p2p_connect =3D 1;
-	else
-		wfi_drv->p2p_connect =3D 0;
-
 	memset(priv->wep_key, 0, sizeof(priv->wep_key));
 	memset(priv->wep_key_len, 0, sizeof(priv->wep_key_len));
=20
@@ -436,7 +431,7 @@ static int connect(struct wiphy *wiphy, struct net_devi=
ce *dev,
=20
 	curr_channel =3D ieee80211_frequency_to_channel(bss->channel->center_freq=
);
=20
-	if (!wfi_drv->p2p_connect)
+	if (vif->iftype !=3D WILC_CLIENT_MODE)
 		wlan_channel =3D curr_channel;
=20
 	wilc_wlan_set_bssid(dev, bss->bssid, WILC_STATION_MODE);
@@ -452,7 +447,7 @@ static int connect(struct wiphy *wiphy, struct net_devi=
ce *dev,
 	if (ret) {
 		netdev_err(dev, "wilc_set_join_req(): Error\n");
 		ret =3D -ENOENT;
-		if (!wfi_drv->p2p_connect)
+		if (vif->iftype !=3D WILC_CLIENT_MODE)
 			wlan_channel =3D INVALID_CHANNEL;
 		wilc_wlan_set_bssid(dev, NULL, WILC_STATION_MODE);
 		wfi_drv->conn_info.conn_result =3D NULL;
@@ -477,7 +472,6 @@ static int disconnect(struct wiphy *wiphy, struct net_d=
evice *dev,
 	struct wilc_priv *priv =3D wiphy_priv(wiphy);
 	struct wilc_vif *vif =3D netdev_priv(priv->dev);
 	struct wilc *wilc =3D vif->wilc;
-	struct host_if_drv *wfi_drv;
 	int ret;
=20
 	vif->connecting =3D false;
@@ -491,15 +485,14 @@ static int disconnect(struct wiphy *wiphy, struct net=
_device *dev,
 		return 0;
 	}
=20
-	wfi_drv =3D (struct host_if_drv *)priv->hif_drv;
-	if (!wfi_drv->p2p_connect)
+	if (vif->iftype !=3D WILC_CLIENT_MODE)
 		wlan_channel =3D INVALID_CHANNEL;
 	wilc_wlan_set_bssid(priv->dev, NULL, WILC_STATION_MODE);
=20
 	priv->p2p.local_random =3D 0x01;
 	priv->p2p.recv_random =3D 0x00;
 	priv->p2p.is_wilc_ie =3D false;
-	wfi_drv->p2p_timeout =3D 0;
+	priv->hif_drv->p2p_timeout =3D 0;
=20
 	ret =3D wilc_disconnect(vif);
 	if (ret !=3D 0) {
--=20
2.7.4

