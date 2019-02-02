Return-Path: <SRS0=M3au=QJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B90E0C282D7
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Feb 2019 19:17:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81F2F2082C
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Feb 2019 19:17:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="vuUu3+U1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbfBBTRo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 2 Feb 2019 14:17:44 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:55594 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726865AbfBBTRo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Feb 2019 14:17:44 -0500
X-IronPort-AV: E=Sophos;i="5.56,553,1539673200"; 
   d="scan'208";a="26075178"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES128-SHA; 02 Feb 2019 12:17:29 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.37) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sat, 2 Feb 2019 12:17:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PMQuUss+lDxND+rNXmxtq5+Te0Fk9NVfzwX969KnkUo=;
 b=vuUu3+U1MQ8dNvLmdZo2n1FXc1teaZDGc2gV/4EP/5zCe5iMgBfJStRnuBm2AqJxYVP/R/dRsh0VJunYGZ/U4OU4IJb94e7Brtl/un5zS/PBVQAAWRTJCC7f/6IaqCh3hlOm91pC0i1Hz26VRhTwzhOwatEbzDttTuSY9/JpKws=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3638.namprd11.prod.outlook.com (20.178.237.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.16; Sat, 2 Feb 2019 19:17:28 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1580.019; Sat, 2 Feb 2019
 19:17:28 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 13/15] staging: wilc1000: avoid use of interface names for
 validation
Thread-Topic: [PATCH 13/15] staging: wilc1000: avoid use of interface names
 for validation
Thread-Index: AQHUuyvv+Bw2c9knpUK1FH69+IwEsg==
Date:   Sat, 2 Feb 2019 19:17:27 +0000
Message-ID: <1549134974-5545-14-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3638;6:Q913C7/6sFwxLKMfLL3WMBoBRMEeEtxo70SHjd4oxARLTjQx4tvYxsFQ2vWY4fKWIqqIGBuDABGe40KWP0ZjWPt7vQGlOgYGoVPFlOJimmG9iPMrcM3M/xbCzLalSHMxPVop/7FaDQIDeVx8EyVOzOiAauCa6ZiNXhEIz6S9OzEwKdEJVVzo6mjrroB/Jumwfg03/9UPq1r+UG5fa16SiE5XkrBPGntfNrmcRP6mqIj8GDnRhv37gOAYtJxA5+HlRdqOrEaIAF/gAGTPvwnhQ0uFv1H5lN1XQ7Dm0C3IdBLjrYUDfunTkL2LTZj3k7O+vHjjbteKAV4XJQikwERbUfLbskR5yLlOnbmVUFhlR2WjhyyRO5XK0RunGrvtyv0l461riRvYtixAyToOC8UGBzJ7Pc63uFBAsLgsohtLTWyVsE30kzefgb5puWtE4RXJq1E4cT7oP46GH+mpKoshTQ==;5:aqcVMT0lb5f2XozCaql05e97ZiQ+30pN1PtDuREkDLfieUWXC5/Zv6WNr6E1UnVoy/01YkgGgujGv5rBN21Oj1DCrooOF0d/IkdSrHkupbW1Phi+EtJJiAkVMoxvTVYvKWNadCdqB8K5MSVjJxsls+qHySCOxwmZL41ujVbmb6MGneutj5FXFmp2nPDTXtSLayAs+LyhxOMAUmKfa79FwQ==;7:nnfw+sCkEwz920yWSaiaWdqdJNwcEm77XwhTKH1xW9DTEOobj9jYtzjwd7usM6Xbf3iPwI1Pzd0i5QZUy9vAC4XIse/AsZL5NTMEKAEdYbB9PuF4EXRc/00bMJoZIIq6Pdmi/1f4fnUS+ZQRcSUizQ==
x-ms-office365-filtering-correlation-id: bca2f285-c010-43be-2ace-08d689431204
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3638;
x-ms-traffictypediagnostic: BYAPR11MB3638:
x-microsoft-antispam-prvs: <BYAPR11MB3638CC3FEE995BD4CCA171FBE3930@BYAPR11MB3638.namprd11.prod.outlook.com>
x-forefront-prvs: 09368DB063
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(376002)(136003)(346002)(366004)(189003)(199004)(26005)(478600001)(7736002)(186003)(105586002)(106356001)(2351001)(476003)(6486002)(446003)(2616005)(486006)(6512007)(66066001)(11346002)(2906002)(14454004)(6436002)(72206003)(71200400001)(71190400001)(386003)(6506007)(5640700003)(2501003)(68736007)(3846002)(97736004)(102836004)(6916009)(36756003)(76176011)(78486014)(25786009)(107886003)(81156014)(81166006)(4326008)(86362001)(52116002)(53936002)(316002)(305945005)(14444005)(99286004)(256004)(8676002)(6116002)(8936002)(50226002)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3638;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 5udiX2vTAAvXbJBxyRoTgJ3xKjW2Phm8IwQd0PBu4adv0i/LNN4mg9X42KdiDlq4FA7P1L97WjZpRO5k4KBSC2yInyQ3fnogltBvZyEjZqbnWrNgv/yeUYPoqohuxzKrs8VL3RpjepbUfRMYFAyQVFAK3uIgQ95rtWPl0zWtALwzq3BnMoLQDU96jBUX4RzscNabeOLGs4MKCCFI1fWLru8lOJo/RiOgMDKyxjfHndWMnjbU0P+T8L1zy9Mfkq+kOM+FeU5jlQ9TqqcOFZO9sULxAEA9+ZZ2/eJ1x/D2mFUH6cN2rBN4RxtML+UZIzYY8Ghs5k1ZrrkIRBx7cuFKsMFnj50IuoEBIK/c0Zi4RIy78JCysJyvmCB4v+i+PDIEWvAMOJ27h8Ct/EhZnUsPDYejtI5p9SrwBTK2hj2IjJ0=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: bca2f285-c010-43be-2ace-08d689431204
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2019 19:17:25.8047
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3638
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Avoid use of interface name i.e 'wlan0' & 'p2p0' to check the interface
type in dev_state_ev_handler(). Now making use of netdev_ops and iface
type to know interface. Reorder the functions to avoid the forward
declaration after the above changes

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 144 +++++++++++++++++-------------=
----
 1 file changed, 70 insertions(+), 74 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc10=
00/linux_wlan.c
index 484fe3d..dcd5861 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -12,71 +12,6 @@
=20
 #include "wilc_wfi_cfgoperations.h"
=20
-static int dev_state_ev_handler(struct notifier_block *this,
-				unsigned long event, void *ptr)
-{
-	struct in_ifaddr *dev_iface =3D ptr;
-	struct wilc_priv *priv;
-	struct host_if_drv *hif_drv;
-	struct net_device *dev;
-	struct wilc_vif *vif;
-	char wlan_dev_name[5] =3D "wlan0";
-
-	if (!dev_iface || !dev_iface->ifa_dev || !dev_iface->ifa_dev->dev)
-		return NOTIFY_DONE;
-
-	if (memcmp(dev_iface->ifa_label, "wlan0", 5) &&
-	    memcmp(dev_iface->ifa_label, "p2p0", 4))
-		return NOTIFY_DONE;
-
-	dev  =3D (struct net_device *)dev_iface->ifa_dev->dev;
-	if (!dev->ieee80211_ptr || !dev->ieee80211_ptr->wiphy)
-		return NOTIFY_DONE;
-
-	priv =3D wiphy_priv(dev->ieee80211_ptr->wiphy);
-	if (!priv)
-		return NOTIFY_DONE;
-
-	hif_drv =3D (struct host_if_drv *)priv->hif_drv;
-	vif =3D netdev_priv(dev);
-	if (!vif || !hif_drv)
-		return NOTIFY_DONE;
-
-	switch (event) {
-	case NETDEV_UP:
-		if (vif->iftype =3D=3D WILC_STATION_MODE ||
-		    vif->iftype =3D=3D WILC_CLIENT_MODE) {
-			hif_drv->ifc_up =3D 1;
-			vif->obtaining_ip =3D false;
-			del_timer(&vif->during_ip_timer);
-		}
-
-		if (vif->wilc->enable_ps)
-			wilc_set_power_mgmt(vif, 1, 0);
-
-		break;
-
-	case NETDEV_DOWN:
-		if (vif->iftype =3D=3D WILC_STATION_MODE ||
-		    vif->iftype =3D=3D WILC_CLIENT_MODE) {
-			hif_drv->ifc_up =3D 0;
-			vif->obtaining_ip =3D false;
-		}
-
-		if (memcmp(dev_iface->ifa_label, wlan_dev_name, 5) =3D=3D 0)
-			wilc_set_power_mgmt(vif, 0, 0);
-
-		wilc_resolve_disconnect_aberration(vif);
-
-		break;
-
-	default:
-		break;
-	}
-
-	return NOTIFY_DONE;
-}
-
 static irqreturn_t isr_uh_routine(int irq, void *user_data)
 {
 	struct net_device *dev =3D user_data;
@@ -921,6 +856,76 @@ void wilc_wfi_mgmt_rx(struct wilc *wilc, u8 *buff, u32=
 size)
 		wilc_wfi_p2p_rx(wilc->vif[1]->ndev, buff, size);
 }
=20
+static const struct net_device_ops wilc_netdev_ops =3D {
+	.ndo_init =3D mac_init_fn,
+	.ndo_open =3D wilc_mac_open,
+	.ndo_stop =3D wilc_mac_close,
+	.ndo_start_xmit =3D wilc_mac_xmit,
+	.ndo_get_stats =3D mac_stats,
+	.ndo_set_rx_mode  =3D wilc_set_multicast_list,
+};
+
+static int dev_state_ev_handler(struct notifier_block *this,
+				unsigned long event, void *ptr)
+{
+	struct in_ifaddr *dev_iface =3D ptr;
+	struct wilc_priv *priv;
+	struct host_if_drv *hif_drv;
+	struct net_device *dev;
+	struct wilc_vif *vif;
+
+	if (!dev_iface || !dev_iface->ifa_dev || !dev_iface->ifa_dev->dev)
+		return NOTIFY_DONE;
+
+	dev  =3D (struct net_device *)dev_iface->ifa_dev->dev;
+	if (dev->netdev_ops !=3D &wilc_netdev_ops)
+		return NOTIFY_DONE;
+
+	if (!dev->ieee80211_ptr || !dev->ieee80211_ptr->wiphy)
+		return NOTIFY_DONE;
+
+	priv =3D wiphy_priv(dev->ieee80211_ptr->wiphy);
+	if (!priv)
+		return NOTIFY_DONE;
+
+	hif_drv =3D (struct host_if_drv *)priv->hif_drv;
+	vif =3D netdev_priv(dev);
+	if (!vif || !hif_drv)
+		return NOTIFY_DONE;
+
+	switch (event) {
+	case NETDEV_UP:
+		if (vif->iftype =3D=3D WILC_STATION_MODE ||
+		    vif->iftype =3D=3D WILC_CLIENT_MODE) {
+			hif_drv->ifc_up =3D 1;
+			vif->obtaining_ip =3D false;
+			del_timer(&vif->during_ip_timer);
+		}
+
+		if (vif->wilc->enable_ps)
+			wilc_set_power_mgmt(vif, 1, 0);
+
+		break;
+
+	case NETDEV_DOWN:
+		if (vif->iftype =3D=3D WILC_STATION_MODE ||
+		    vif->iftype =3D=3D WILC_CLIENT_MODE) {
+			hif_drv->ifc_up =3D 0;
+			vif->obtaining_ip =3D false;
+			wilc_set_power_mgmt(vif, 0, 0);
+		}
+
+		wilc_resolve_disconnect_aberration(vif);
+
+		break;
+
+	default:
+		break;
+	}
+
+	return NOTIFY_DONE;
+}
+
 static struct notifier_block g_dev_notifier =3D {
 	.notifier_call =3D dev_state_ev_handler
 };
@@ -957,15 +962,6 @@ void wilc_netdev_cleanup(struct wilc *wilc)
 }
 EXPORT_SYMBOL_GPL(wilc_netdev_cleanup);
=20
-static const struct net_device_ops wilc_netdev_ops =3D {
-	.ndo_init =3D mac_init_fn,
-	.ndo_open =3D wilc_mac_open,
-	.ndo_stop =3D wilc_mac_close,
-	.ndo_start_xmit =3D wilc_mac_xmit,
-	.ndo_get_stats =3D mac_stats,
-	.ndo_set_rx_mode  =3D wilc_set_multicast_list,
-};
-
 int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 		     const struct wilc_hif_func *ops)
 {
--=20
2.7.4

