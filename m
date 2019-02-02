Return-Path: <SRS0=M3au=QJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2CF9C282D7
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Feb 2019 19:16:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABAB72082C
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Feb 2019 19:16:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="pD3jhQED"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbfBBTQ6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 2 Feb 2019 14:16:58 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:13826 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726486AbfBBTQ6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Feb 2019 14:16:58 -0500
X-IronPort-AV: E=Sophos;i="5.56,553,1539673200"; 
   d="scan'208";a="26232209"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES128-SHA; 02 Feb 2019 12:16:56 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.37) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sat, 2 Feb 2019 12:16:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QNs9VYXk7y9W0v+lcK6c/tNsdVQmMKZ1/PAvw+oPK/0=;
 b=pD3jhQED6JnrbfCca1GHiY8MH3iHzbj94sUkbMNNrErN0ndXzlCqVedWiFgp4yj67kftZzuVWTTCSivo5P6eH1gRw6nUz9m4K0LSLoTYZgUnEKA4ZiR5RicY7Nsze7scsHcY1WAUYqGVR8mRwA5PUIdW2K8fL2YSQOJDMXojuac=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2998.namprd11.prod.outlook.com (20.177.224.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1558.21; Sat, 2 Feb 2019 19:16:53 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1580.019; Sat, 2 Feb 2019
 19:16:53 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 01/15] staging: wilc1000: avoid the use of 'wilc_wfi_mon'
 static variable
Thread-Topic: [PATCH 01/15] staging: wilc1000: avoid the use of 'wilc_wfi_mon'
 static variable
Thread-Index: AQHUuyvbBxPjnJCw40CWpECh2AMjPQ==
Date:   Sat, 2 Feb 2019 19:16:53 +0000
Message-ID: <1549134974-5545-2-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2998;6:yIn3o+fvLeY1y9AhvYxcfzrV4r3DlrGpjbjxoyP2UhFZz1VXbM4LKCM0MDxWwGHMYsmpVlRYmbjKShHG2T6fYvmBP+hPjR5wlY7ywMgYAzWV7lY7W78UuGli7rdkSmiIv1yI3QrVsG3mDlD5jhsMUD44hukN51Kffltlx/x//ML4IjTO3/20kRSODFJXJ8kEdzXKvYFgOXVYYTewpDI3N8dst/n7VGfBVOdr3nmaEeoqArEs6gtPrkC5aoH6kdKxDMDDbmvzo4xbsYKSsYG3MFjqdUYeywyQZo2gpBTAzeN6Rzds2s0rStM9B8RjqekgGTrW4A6OnEVQmlDKBSMLmMplwSm8q0A6UIsIrygbmmXdOe6NspYhKDw7W+JrdMktUpSwaE7wsbtcEFIV3i3dLJsp3E77k9Ajx8Cdjkq6o9wPReo2V/iIyyGpDCegQHWwmTr71WjhXd2aw8Taj3JS4A==;5:jijejbzigfTS7WnPP2JK/cev7Uz0JdEn7N+JNlWwTJ2MKfCzftqlA1QQsUkqmyoSb5DoATrr8P5OZNUTEY8gttXmfPp2q4cux9xZhSMEJyMFsaZKCMHSCNYvIrAcS+Z/ZnBelr6+4jmKCUZHSkP/Z1fsQKyMr56yS3+LrOVlemA8pFVlzaB9Eu6UaXiw+L8z1c1TLcWaeHuT7Hao/iNj/Q==;7:sxHf7AAdFr68H3rxeCMZ62VT30Zbn7htiEv/AHvL6Nb/7ypmtJmVlhTN0Hx/Y15lvLNVE6qnBNPlmqDDLJjvBCxI54DrShSC2TUU/NTu1T+z+hBAFGJn1NFRP8nHE/DxuTOSnA5yDUDZE6OH1jsnFA==
x-ms-office365-filtering-correlation-id: f6aa99fc-f7cb-45e0-5223-08d68942fd8f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2998;
x-ms-traffictypediagnostic: BYAPR11MB2998:
x-microsoft-antispam-prvs: <BYAPR11MB2998B185BF258ED059A85052E3930@BYAPR11MB2998.namprd11.prod.outlook.com>
x-forefront-prvs: 09368DB063
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(376002)(366004)(346002)(39850400004)(189003)(199004)(25786009)(107886003)(105586002)(78486014)(36756003)(50226002)(2501003)(6916009)(66066001)(8936002)(3846002)(4326008)(305945005)(7736002)(71200400001)(71190400001)(8676002)(6116002)(54906003)(81166006)(316002)(446003)(81156014)(6436002)(6486002)(2906002)(2616005)(486006)(476003)(76176011)(256004)(99286004)(11346002)(14444005)(52116002)(53936002)(72206003)(478600001)(186003)(386003)(26005)(14454004)(106356001)(86362001)(5640700003)(97736004)(2351001)(68736007)(6506007)(102836004)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2998;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: C/zX9lysMzr8DrkTEoE6gILfWOlAVh6lRxDjF5cYbP9qqgcG5ihZ+vfUkUWmah5t0Ly7b/H6Fpfgtd5hsC1CSCaFJeI53zpOpxzKbIQVheEIHMFYMLl7z1po2Nuq/FWrNyavf5EQ/mwzyJHotHEGA+0QyrSCIrBZTytrK1YwnAPtMV3A1Rm9Eb9BWubILg5+LaSpuSd8qeLKdEpJMiY6irOBLW8ZkvDT41dpLt2WRsZC4iMX9d2E6kuFe5fP0rZmmu2yKbdYI39EaE5DVMoyo/ODPseC9XXzH3GR2TH6SE+aMzMC+2KYU/SN8y6mN7j6p6b2JJ1T9qp1C1VEcBC/lbQkm+px4Fpm75kvhN6+aQJcF6t/sXalQQ1FROofcWGqeA3YCQFMT/B34/KwUXIcB1c1mz5uMmKonuRxf2XPl0M=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f6aa99fc-f7cb-45e0-5223-08d68942fd8f
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2019 19:16:51.3104
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

Avoid use of static variable for monitor net_device and move it inside
wilc structure.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_mon.c              | 52 +++++++++++--------=
----
 drivers/staging/wilc1000/linux_wlan.c             |  4 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  3 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.h |  7 +--
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  1 +
 5 files changed, 34 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc100=
0/linux_mon.c
index a634468..ed06834 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -18,8 +18,6 @@ struct wilc_wfi_radiotap_cb_hdr {
 	u16 tx_flags;
 } __packed;
=20
-static struct net_device *wilc_wfi_mon; /* global monitor netdev */
-
 static u8 srcadd[6];
 static u8 bssid[6];
=20
@@ -29,17 +27,17 @@ static u8 bssid[6];
 #define TX_RADIOTAP_PRESENT ((1 << IEEE80211_RADIOTAP_RATE) |	\
 			     (1 << IEEE80211_RADIOTAP_TX_FLAGS))
=20
-void wilc_wfi_monitor_rx(u8 *buff, u32 size)
+void wilc_wfi_monitor_rx(struct net_device *mon_dev, u8 *buff, u32 size)
 {
 	u32 header, pkt_offset;
 	struct sk_buff *skb =3D NULL;
 	struct wilc_wfi_radiotap_hdr *hdr;
 	struct wilc_wfi_radiotap_cb_hdr *cb_hdr;
=20
-	if (!wilc_wfi_mon)
+	if (!mon_dev)
 		return;
=20
-	if (!netif_running(wilc_wfi_mon))
+	if (!netif_running(mon_dev))
 		return;
=20
 	/* Get WILC header */
@@ -94,7 +92,7 @@ void wilc_wfi_monitor_rx(u8 *buff, u32 size)
 		hdr->rate =3D 5;
 	}
=20
-	skb->dev =3D wilc_wfi_mon;
+	skb->dev =3D mon_dev;
 	skb_reset_mac_header(skb);
 	skb->ip_summed =3D CHECKSUM_UNNECESSARY;
 	skb->pkt_type =3D PACKET_OTHERHOST;
@@ -156,12 +154,10 @@ static netdev_tx_t wilc_wfi_mon_xmit(struct sk_buff *=
skb,
 	struct sk_buff *skb2;
 	struct wilc_wfi_radiotap_cb_hdr *cb_hdr;
=20
-	if (!wilc_wfi_mon)
-		return -EFAULT;
-
-	mon_priv =3D netdev_priv(wilc_wfi_mon);
+	mon_priv =3D netdev_priv(dev);
 	if (!mon_priv)
 		return -EFAULT;
+
 	rtap_len =3D ieee80211_get_radiotap_len(skb->data);
 	if (skb->len < rtap_len)
 		return -1;
@@ -187,7 +183,7 @@ static netdev_tx_t wilc_wfi_mon_xmit(struct sk_buff *sk=
b,
 		cb_hdr->rate =3D 5;
 		cb_hdr->tx_flags =3D 0x0004;
=20
-		skb2->dev =3D wilc_wfi_mon;
+		skb2->dev =3D dev;
 		skb_reset_mac_header(skb2);
 		skb2->ip_summed =3D CHECKSUM_UNNECESSARY;
 		skb2->pkt_type =3D PACKET_OTHERHOST;
@@ -223,51 +219,53 @@ static const struct net_device_ops wilc_wfi_netdev_op=
s =3D {
=20
 };
=20
-struct net_device *wilc_wfi_init_mon_interface(const char *name,
+struct net_device *wilc_wfi_init_mon_interface(struct wilc *wl,
+					       const char *name,
 					       struct net_device *real_dev)
 {
 	struct wilc_wfi_mon_priv *priv;
=20
 	/*If monitor interface is already initialized, return it*/
-	if (wilc_wfi_mon)
-		return wilc_wfi_mon;
+	if (wl->monitor_dev)
+		return wl->monitor_dev;
=20
-	wilc_wfi_mon =3D alloc_etherdev(sizeof(struct wilc_wfi_mon_priv));
-	if (!wilc_wfi_mon)
+	wl->monitor_dev =3D alloc_etherdev(sizeof(struct wilc_wfi_mon_priv));
+	if (!wl->monitor_dev)
 		return NULL;
-	wilc_wfi_mon->type =3D ARPHRD_IEEE80211_RADIOTAP;
-	strncpy(wilc_wfi_mon->name, name, IFNAMSIZ);
-	wilc_wfi_mon->name[IFNAMSIZ - 1] =3D 0;
-	wilc_wfi_mon->netdev_ops =3D &wilc_wfi_netdev_ops;
=20
-	if (register_netdevice(wilc_wfi_mon)) {
+	wl->monitor_dev->type =3D ARPHRD_IEEE80211_RADIOTAP;
+	strncpy(wl->monitor_dev->name, name, IFNAMSIZ);
+	wl->monitor_dev->name[IFNAMSIZ - 1] =3D 0;
+	wl->monitor_dev->netdev_ops =3D &wilc_wfi_netdev_ops;
+
+	if (register_netdevice(wl->monitor_dev)) {
 		netdev_err(real_dev, "register_netdevice failed\n");
 		return NULL;
 	}
-	priv =3D netdev_priv(wilc_wfi_mon);
+	priv =3D netdev_priv(wl->monitor_dev);
 	if (!priv)
 		return NULL;
=20
 	priv->real_ndev =3D real_dev;
=20
-	return wilc_wfi_mon;
+	return wl->monitor_dev;
 }
=20
-void wilc_wfi_deinit_mon_interface(void)
+void wilc_wfi_deinit_mon_interface(struct wilc *wl)
 {
 	bool rollback_lock =3D false;
=20
-	if (wilc_wfi_mon) {
+	if (wl->monitor_dev) {
 		if (rtnl_is_locked()) {
 			rtnl_unlock();
 			rollback_lock =3D true;
 		}
-		unregister_netdev(wilc_wfi_mon);
+		unregister_netdev(wl->monitor_dev);
=20
 		if (rollback_lock) {
 			rtnl_lock();
 			rollback_lock =3D false;
 		}
-		wilc_wfi_mon =3D NULL;
+		wl->monitor_dev =3D NULL;
 	}
 }
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc10=
00/linux_wlan.c
index 87ec048..1362d8f 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -920,7 +920,7 @@ static int wilc_mac_close(struct net_device *ndev)
 		netdev_dbg(ndev, "Deinitializing wilc1000\n");
 		wl->close =3D 1;
 		wilc_wlan_deinitialize(ndev);
-		wilc_wfi_deinit_mon_interface();
+		wilc_wfi_deinit_mon_interface(wl);
 	}
=20
 	vif->mac_opened =3D 0;
@@ -976,7 +976,7 @@ void wilc_wfi_mgmt_rx(struct wilc *wilc, u8 *buff, u32 =
size)
 	for (i =3D 0; i < wilc->vif_num; i++) {
 		vif =3D netdev_priv(wilc->vif[i]->ndev);
 		if (vif->monitor_flag) {
-			wilc_wfi_monitor_rx(buff, size);
+			wilc_wfi_monitor_rx(wilc->monitor_dev, buff, size);
 			return;
 		}
 	}
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/st=
aging/wilc1000/wilc_wfi_cfgoperations.c
index 79753ad..cd3df42 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1617,7 +1617,8 @@ static struct wireless_dev *add_virtual_intf(struct w=
iphy *wiphy,
 	struct net_device *new_ifc;
=20
 	if (type =3D=3D NL80211_IFTYPE_MONITOR) {
-		new_ifc =3D wilc_wfi_init_mon_interface(name, vif->ndev);
+		new_ifc =3D wilc_wfi_init_mon_interface(vif->wilc, name,
+						      vif->ndev);
 		if (new_ifc) {
 			vif =3D netdev_priv(priv->wdev->netdev);
 			vif->monitor_flag =3D 1;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h b/drivers/st=
aging/wilc1000/wilc_wfi_cfgoperations.h
index 4812c8e..31dfa1f 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
@@ -13,9 +13,10 @@ struct wireless_dev *wilc_create_wiphy(struct net_device=
 *net,
 void wilc_free_wiphy(struct net_device *net);
 void wilc_deinit_host_int(struct net_device *net);
 int wilc_init_host_int(struct net_device *net);
-void wilc_wfi_monitor_rx(u8 *buff, u32 size);
-void wilc_wfi_deinit_mon_interface(void);
-struct net_device *wilc_wfi_init_mon_interface(const char *name,
+void wilc_wfi_monitor_rx(struct net_device *mon_dev, u8 *buff, u32 size);
+void wilc_wfi_deinit_mon_interface(struct wilc *wl);
+struct net_device *wilc_wfi_init_mon_interface(struct wilc *wl,
+					       const char *name,
 					       struct net_device *real_dev);
 void wilc_mgmt_frame_register(struct wiphy *wiphy, struct wireless_dev *wd=
ev,
 			      u16 frame_type, bool reg);
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/stagin=
g/wilc1000/wilc_wfi_netdevice.h
index 59e8352..cc06ef9 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -270,6 +270,7 @@ struct wilc {
 	enum chip_ps_states chip_ps_state;
 	struct wilc_cfg cfg;
 	void *bus_data;
+	struct net_device *monitor_dev;
 };
=20
 struct wilc_wfi_mon_priv {
--=20
2.7.4

