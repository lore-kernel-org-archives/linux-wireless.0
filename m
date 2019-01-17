Return-Path: <SRS0=z7UY=PZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 553FEC43387
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 13:21:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 102C820652
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 13:21:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="EDpAC9Oc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbfAQNVQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 17 Jan 2019 08:21:16 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:40711 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfAQNVP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Jan 2019 08:21:15 -0500
X-IronPort-AV: E=Sophos;i="5.56,489,1539673200"; 
   d="scan'208";a="23513313"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES128-SHA; 17 Jan 2019 06:21:16 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.37) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 17 Jan 2019 06:21:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y2ameHaKLtn8MYGbtlWBXkgvcGJj2jYXD14VyVUtpQ4=;
 b=EDpAC9OcO1SGyW5aOIzNVuS2QlhZJfOR6iU6ZclORg5QXfmgLZ4yaJacv8Izet+x888mtiE99V++/xmdwBCjEM36EFk1UbgJUaa/dk9YQTPDbTgx+oflkoo3VhQMgjbvA9vvugUNlpakBRZRe+C/B5wQc2f2t5AxRBUo6SPAdTo=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3464.namprd11.prod.outlook.com (20.177.187.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.26; Thu, 17 Jan 2019 13:21:13 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::c110:8559:a438:491d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::c110:8559:a438:491d%3]) with mapi id 15.20.1516.019; Thu, 17 Jan 2019
 13:21:13 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 02/13] staging: wilc1000: refactor wilc_wlan_set_bssid()
Thread-Topic: [PATCH 02/13] staging: wilc1000: refactor wilc_wlan_set_bssid()
Thread-Index: AQHUrmeEpUEEBcWdOEu0Z2yKBjTivQ==
Date:   Thu, 17 Jan 2019 13:21:13 +0000
Message-ID: <1547731250-18518-3-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3464;6:C6soLa1UYaydypQhJQ3AUUolWM27aXOUvolpKxxLYoTE8V7obF3uUpATGOeXxe0BsNbbya0Ln8HUsnCc9uo8hiflYqSaFX9urIK8L6iiCuZMmmtlSuaRhuH3nWZFlH0UBQKLH9mz56scdw3SQ6yA9xKPm3oMQTy5v7VhLPaa2nwp3ApWQrwYy2rr01rZ4WznP95qAo9t65bAIz594lAz82DdYRo/XoWqPDZrxlmmh8nOIBDYm7BTdTI+eas7xc/FQzQSswQoRzPSSv3b8vTMdDEJiSUmJUBMQohn3kYKkZh0e92aaETorsnib4NBEA1hSrO7nogceuV7eYoVXzlZRQ+x125QVqw4W2JILb4QUNpJSOKROXsXF9qbFjZyKWdyN3QBhT+Q6dnjoPp/va8UkHHOC9pu7YJY0KPtdue3ixhmDXx7bK7dSHY9NrR9E8m4CJISC2U+MemcxrCCw4U3YA==;5:AO5UkQu1qiznBeZENdiiVG/p80t7RWdu3l4P9vFjGJoYO2iOG1zGkMwJJdbXr3klp+VbNFY9NL4RL6Tf0Q/pShTl3ZVrgCJjl5MW7XoUK6EOHG53ctKVFE1MQBbMRXx/7gyZLE2BgkqBFUtdebeKpH4xG3ONkD7ryJlUnLSdBAKQjZC0CI7mYJ2gThhbCxbcU99M+hptQShtcIdy54XVKg==;7:11SC1+ra523dDneVBiPrxh6j8C4jMSKeks8z/F+q/LuFuNSIHc2rJseMykd0zWB7zktMecN/VJ6iOLccJT9pr+WXzUuxLapdRxW/MIrl4rrT7AXLN12OtPe58LyxKKP8nXqMvG6evakSNHqfgxQfhg==
x-ms-office365-filtering-correlation-id: 24761285-b00e-4f2f-f18d-08d67c7ea6d9
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3464;
x-ms-traffictypediagnostic: BYAPR11MB3464:
x-microsoft-antispam-prvs: <BYAPR11MB3464A2A976DAF2D776EDD575E3830@BYAPR11MB3464.namprd11.prod.outlook.com>
x-forefront-prvs: 0920602B08
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(366004)(136003)(39860400002)(376002)(396003)(199004)(189003)(14454004)(68736007)(81166006)(81156014)(5660300001)(8936002)(2906002)(106356001)(8676002)(26005)(305945005)(7736002)(6486002)(6436002)(5640700003)(36756003)(86362001)(99286004)(478600001)(6916009)(50226002)(72206003)(78486014)(76176011)(2501003)(66066001)(4326008)(97736004)(486006)(25786009)(6506007)(476003)(102836004)(14444005)(256004)(386003)(53936002)(2616005)(54906003)(6512007)(71190400001)(71200400001)(105586002)(107886003)(3846002)(52116002)(186003)(2351001)(6116002)(316002)(11346002)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3464;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 7p5dHVhE3NLvj3hGGTWICG+R3wSYS+VvDjTLRwOrUMWV3xcSR7T6jXqTywpiE8/QTuJll8ebIQE6RpYsQZCdBRN7Z9NbshrEjgJGYsMF4cpFtOa80aNCtIcNQVJTI/j6WjRqMxi2qa32UX/x+yxjYI7V+ljz6WPP5ste+JP23PYLU+kUr1U9h2ldThB9Jwh7y9y7tYrBBg3ZCfjHRWRa4PpQU1tyVaFZx7X/K3xTgUvD0WO7Q8E3TFAIMmPZkKwkn217uA+XXqP5gEsn1xiOG+cLwmE4oGNmtxqojV3UD2DgpOs9XZ/UdZufMXY+JGeDS3HcLUN7Jy07xOPa0ydafzp0OfZOOXSucwWPbD2U/ap5bKboQm1BA/ow7RZUXo4vAgG+xUfKk1Esd5PIsJO+iMH6ZgWaiOsRzCdmqWziv2I=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 24761285-b00e-4f2f-f18d-08d67c7ea6d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2019 13:21:10.5973
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3464
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Refactor code by making use of eth_zero_addr() to clear the mac address
value in wilc_wlan_set_bssid().

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_wlan.c             |  6 +++++-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 16 +++++-----------
 2 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc10=
00/linux_wlan.c
index 7216890..5b554c6 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -198,7 +198,11 @@ void wilc_wlan_set_bssid(struct net_device *wilc_netde=
v, u8 *bssid, u8 mode)
 {
 	struct wilc_vif *vif =3D netdev_priv(wilc_netdev);
=20
-	memcpy(vif->bssid, bssid, 6);
+	if (bssid)
+		ether_addr_copy(vif->bssid, bssid);
+	else
+		eth_zero_addr(vif->bssid);
+
 	vif->mode =3D mode;
 }
=20
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/st=
aging/wilc1000/wilc_wfi_cfgoperations.c
index ac47dda..987e5ff 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -390,7 +390,6 @@ static void cfg_connect_result(enum conn_event conn_dis=
conn_evt,
 	struct wilc_vif *vif =3D netdev_priv(dev);
 	struct wilc *wl =3D vif->wilc;
 	struct host_if_drv *wfi_drv =3D priv->hif_drv;
-	u8 null_bssid[ETH_ALEN] =3D {0};
=20
 	vif->connecting =3D false;
=20
@@ -402,8 +401,7 @@ static void cfg_connect_result(enum conn_event conn_dis=
conn_evt,
 		if (mac_status =3D=3D WILC_MAC_STATUS_DISCONNECTED &&
 		    conn_info->status =3D=3D WLAN_STATUS_SUCCESS) {
 			connect_status =3D WLAN_STATUS_UNSPECIFIED_FAILURE;
-			wilc_wlan_set_bssid(priv->dev, null_bssid,
-					    WILC_STATION_MODE);
+			wilc_wlan_set_bssid(priv->dev, NULL, WILC_STATION_MODE);
=20
 			if (!wfi_drv->p2p_connect)
 				wlan_channel =3D INVALID_CHANNEL;
@@ -445,7 +443,7 @@ static void cfg_connect_result(enum conn_event conn_dis=
conn_evt,
 		priv->p2p.recv_random =3D 0x00;
 		priv->p2p.is_wilc_ie =3D false;
 		eth_zero_addr(priv->associated_bss);
-		wilc_wlan_set_bssid(priv->dev, null_bssid, WILC_STATION_MODE);
+		wilc_wlan_set_bssid(priv->dev, NULL, WILC_STATION_MODE);
=20
 		if (!wfi_drv->p2p_connect)
 			wlan_channel =3D INVALID_CHANNEL;
@@ -720,13 +718,11 @@ static int connect(struct wiphy *wiphy, struct net_de=
vice *dev,
 				nw_info->ch,
 				nw_info->join_params);
 	if (ret) {
-		u8 null_bssid[ETH_ALEN] =3D {0};
-
 		netdev_err(dev, "wilc_set_join_req(): Error\n");
 		ret =3D -ENOENT;
 		if (!wfi_drv->p2p_connect)
 			wlan_channel =3D INVALID_CHANNEL;
-		wilc_wlan_set_bssid(dev, null_bssid, WILC_STATION_MODE);
+		wilc_wlan_set_bssid(dev, NULL, WILC_STATION_MODE);
 		goto out_error;
 	}
 	return 0;
@@ -744,7 +740,6 @@ static int disconnect(struct wiphy *wiphy, struct net_d=
evice *dev,
 	struct wilc *wilc =3D vif->wilc;
 	struct host_if_drv *wfi_drv;
 	int ret;
-	u8 null_bssid[ETH_ALEN] =3D {0};
=20
 	vif->connecting =3D false;
=20
@@ -760,7 +755,7 @@ static int disconnect(struct wiphy *wiphy, struct net_d=
evice *dev,
 	wfi_drv =3D (struct host_if_drv *)priv->hif_drv;
 	if (!wfi_drv->p2p_connect)
 		wlan_channel =3D INVALID_CHANNEL;
-	wilc_wlan_set_bssid(priv->dev, null_bssid, WILC_STATION_MODE);
+	wilc_wlan_set_bssid(priv->dev, NULL, WILC_STATION_MODE);
=20
 	priv->p2p.local_random =3D 0x01;
 	priv->p2p.recv_random =3D 0x00;
@@ -1805,9 +1800,8 @@ static int stop_ap(struct wiphy *wiphy, struct net_de=
vice *dev)
 	int ret;
 	struct wilc_priv *priv =3D wiphy_priv(wiphy);
 	struct wilc_vif *vif =3D netdev_priv(priv->dev);
-	u8 null_bssid[ETH_ALEN] =3D {0};
=20
-	wilc_wlan_set_bssid(dev, null_bssid, WILC_AP_MODE);
+	wilc_wlan_set_bssid(dev, NULL, WILC_AP_MODE);
=20
 	ret =3D wilc_del_beacon(vif);
=20
--=20
2.7.4

