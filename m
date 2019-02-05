Return-Path: <SRS0=RZRw=QM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C533DC282CC
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 07:15:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EEF32081B
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 07:15:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="2mD6cfcu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727305AbfBEHPt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 5 Feb 2019 02:15:49 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:39559 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbfBEHPt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Feb 2019 02:15:49 -0500
X-IronPort-AV: E=Sophos;i="5.56,562,1539673200"; 
   d="scan'208";a="26155322"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 05 Feb 2019 00:15:48 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.105) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Tue, 5 Feb 2019 00:15:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P/+aU0HVV/cWS60AnnXabj+rfGTyhh/ZyFOZjYXq8Vw=;
 b=2mD6cfcuIgkoM8KpTlKdz6gHorXJ3/4/3GslS30z/7mzAITJlrRoxqSBvZ4T98moCXsDWuBMjirLKlt8kFYNp3wNJ7usiPVWC8432+RLBtQOYchbZhDs5iVp7MwBj2W7nqaB1mYSDaIhjq4iDIzVMers4MaaF12RYDgcaa+mcYE=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2982.namprd11.prod.outlook.com (20.177.224.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.20; Tue, 5 Feb 2019 07:15:46 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1580.019; Tue, 5 Feb 2019
 07:15:46 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 05/12] staging: wilc1000: avoid use of interface names for
 validation
Thread-Topic: [PATCH 05/12] staging: wilc1000: avoid use of interface names
 for validation
Thread-Index: AQHUvSKduSYTQ4cmgkSeAf1fJ4XsDg==
Date:   Tue, 5 Feb 2019 07:15:46 +0000
Message-ID: <1549350913-645-6-git-send-email-ajay.kathat@microchip.com>
References: <1549350913-645-1-git-send-email-ajay.kathat@microchip.com>
In-Reply-To: <1549350913-645-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MAXPR0101CA0066.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::28) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.7.4
x-originating-ip: [183.82.17.42]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2982;6:MyfWzGiDuHXSUh714T0A08S4UIqI8u394lu0ktTsa4GcuncDxDaNd2sbgPHmmHCxqAwme9RAhaQ1OD8H8uj4Jzplnx9Mtt3LWRy/6nBErUi0EPEWrcH5fNVVoIUqqsiaVb7gxw0wssUwYloDckwiVn7Olwhr2qS1JtaiYT4vfWmhoyUa31W1nRbnVz6HnzGoictjRg+Wj2EV42V4GvlbaDPVnuwgLx9CeipwqiTCekEP1Bl6E3fDDNGfquPmfjjNvX3JHgOxPop3kPLGdfI0aXVZYV/4Twd8d8fLhN+/kw4FFM8svVJOU9mvACc7YEjv1VjzZV+WbtVBBWf36WJm5gXx0MnZkUWyL7dxQi+wu6mY2UrDZinNiaMEVfBO8w0VbfpYUAmezL6otFPrOEsC1qr0HRaMalbbHW16oqogPKb50FlOHdHXi+tBfF+NbAp9s559bTbSW8q2wGbYvLHo1Q==;5:UO550/eDw6H50LSsYCX6LOuGprEjMS2p8LmyN3FNnLhHME5yAkrfVQahtHwfJryXjL8tmUC+O7AAiaIGxGissdL3hxflkguC2zn3zyHI1odWYEndkOYHs1Im0NHKXmEEERTR5Gd8yuy2vyeXAHdKq6iuclK17DRnkaIdIMmY1q1K9AldpZ+fkPx0OTpERITa3BQSeJARqmZ/TSC8YvWPag==;7:UwkU71nCIQHHLULkYIod59u60Mu3/+aJyaSMuLWqwaoK9KlKfSyprbScEx31U7rNuT7TJ0Qyh6+qRWwz2WKlu6cbg+CFyeCsyxromkIzO3D439py4+ywSuuEtp9Q7LCifoZqBWj+JcepteMwR/eGcQ==
x-ms-office365-filtering-correlation-id: f67be220-0b18-4995-5544-08d68b39bf0c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2982;
x-ms-traffictypediagnostic: BYAPR11MB2982:
x-microsoft-antispam-prvs: <BYAPR11MB2982A08124D2477D92FB0220E36E0@BYAPR11MB2982.namprd11.prod.outlook.com>
x-forefront-prvs: 0939529DE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39860400002)(346002)(376002)(366004)(396003)(189003)(199004)(478600001)(36756003)(305945005)(102836004)(6486002)(81156014)(76176011)(81166006)(71190400001)(5640700003)(6436002)(186003)(14454004)(99286004)(52116002)(11346002)(386003)(446003)(26005)(2616005)(476003)(256004)(8676002)(6512007)(14444005)(316002)(6506007)(2906002)(53936002)(54906003)(3846002)(4326008)(25786009)(2351001)(106356001)(6116002)(7736002)(486006)(86362001)(2501003)(68736007)(50226002)(66066001)(97736004)(107886003)(105586002)(72206003)(78486014)(71200400001)(8936002)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2982;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 4qFIWtu1L+2VRahS7hn7NP5twPiuZ6KgwKQVL84ow2N0/HVCWzncP6kIjmA5uj+MaL4rp+DXst/4OduqnIzseryW/OvzOADYEikH4IaWJYUVsUicSv4fW0zuCVRekb0amg0r/Y4yfRUW6vteVw3m0rR22u66+hCFKccN/I2jPW5Cy8P3J5YR10M93sI98EfR/PVdBAmg6nRahKjAt6eiwv2LYUIRLF13d7f7ZEY7cFpoSAXPRmKHqcbAXkm+79zXAvipRKVpP2Vnxk5Sk75b4ZqL/xkq/NLNDOzOV6GHocL4nXyyJMYVGhQudHdlTak+ZPcUnjWrIgCX064vGeYXtx2sSg+mNoJPKUn5buO7vkZEX62ab1ta30HUYzsTFjqrdKLOvlzILh4wNWtZ+KD8gxBfYu8ilXrDMT1TR48eWRM=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f67be220-0b18-4995-5544-08d68b39bf0c
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2019 07:15:42.4466
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2982
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
index 86a38f1..56272b3 100644
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

