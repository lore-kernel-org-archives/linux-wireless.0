Return-Path: <SRS0=Ta2d=QQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4AC8C282C4
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 07:12:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34AD420863
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 07:12:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="IMKxZjtU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbfBIHMj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Feb 2019 02:12:39 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:14137 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726755AbfBIHMj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Feb 2019 02:12:39 -0500
X-IronPort-AV: E=Sophos;i="5.58,350,1544511600"; 
   d="scan'208";a="23610413"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 09 Feb 2019 00:12:37 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.108) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sat, 9 Feb 2019 00:12:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RgejD6bRBWLUIOtytyIf4Y87wtDP2kdArI3lctw9N90=;
 b=IMKxZjtUZ2BRWaXUx7ySgPZc6mTKqR9LkqPM5XxBi0LYm7YxU3qvxf/fzrdakqev0xqfKWoGkKM1ow97sCPiIiIkh0llRle2YbWyl5PKmosrWx0nAyMC+ygUBYqtlMo68kJ+9S3svJN7OhVM/69IjvtjTDnk6mXdVrZBNP4RzCU=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3128.namprd11.prod.outlook.com (20.177.227.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.21; Sat, 9 Feb 2019 07:12:35 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1601.016; Sat, 9 Feb 2019
 07:12:35 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <kvalo@codeaurora.org>,
        <johannes@sipsolutions.net>, <Adham.Abozaeid@microchip.com>,
        <Venkateswara.Kaja@microchip.com>, <Nicolas.Ferre@microchip.com>,
        <Claudiu.Beznea@microchip.com>, <Ajay.Kathat@microchip.com>
Subject: [PATCH 08/16] wilc1000: add wilc_wfi_cfgoperations.c
Thread-Topic: [PATCH 08/16] wilc1000: add wilc_wfi_cfgoperations.c
Thread-Index: AQHUwEbUZnDnariVE0+WX3TFn+Ic+Q==
Date:   Sat, 9 Feb 2019 07:12:34 +0000
Message-ID: <1549696298-9795-9-git-send-email-ajay.kathat@microchip.com>
References: <1549696298-9795-1-git-send-email-ajay.kathat@microchip.com>
In-Reply-To: <1549696298-9795-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR0101CA0021.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:21::31) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.7.4
x-originating-ip: [183.82.17.42]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3128;6:/HTOr06CKdTwIozdLvMVzkMiRRwOfOl7KOrf76Cgl2AqoTdXiV+wGgo7TqpIvlvzIZydo/CCHpgB6DGlNtbztxIZUJH+OjxRoUDMAmtqa885uv16dJj21pAw6DbXAfMUEbmFYMVRhJ5IdslBiQP/mxmOCeRT3YdhoT7pSVhemr3JdvHuKgkS6A4Y7wnj9h+9hZcoZQgVtveS2ncr/OeITxW1LkU0dtuXANVMQ7C9CGFSBaYy76LUCZAriskviyIve+WXeEhLIAYSMVu0n1bsg+P5fUOLhJA6+gySfbZBGpUkzgwdyNTZz+G3KZbPrvRr/e+m7raVLlAZrcZ6mi0BXK/RevnT9veoOmCa2GrP7z1HDqQeepZNYop3ovgVTnTo51WrKpQ8O0Q7fd7MU6L3wEkfe7fmRjkvcbw4N4FUHknvJMs3AEOHIVfzd7FoG6+ZLEfgcRmNMigw0SiQUyZplA==;5:U8eXRbjrzkQb66ySSAplK8kOGB7GApgFxkqO+7LE/6YFE/eM9lDXzk61e0nZi5yvc2hoxXg+EwD4jmeLQYGFUqP5Fa7JJkgJ6dObC1RuiUSvY3TFMt2Hcun1g7LzSV/FAu0nmVG/qSYVSI/fJpnoIJjkkYrjF68Yhzhq09esg9QmAp4Eiy33s4DFUsJ4UwBrk/zVzqumG9QjIIZ/Sk2rrw==;7:hIM8g8/u6mgKobbowtTBq+91u9NufOiOYQrky101DGuSV8HRk7NLFKMopgsEysZA6IOFRUi6oRQ6SAvlOBX1ncziWjibRNCrdBEHP5Gn44H5e4OwvqkechskVqh0k1VQ8b2LBc6FvgYjJ9Evy4Nu4Q==
x-ms-office365-filtering-correlation-id: 25a8b413-40ec-41a2-f815-08d68e5df6c4
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3128;
x-ms-traffictypediagnostic: BYAPR11MB3128:
x-microsoft-antispam-prvs: <BYAPR11MB3128F0699BB6717D6B2C2A5FE36A0@BYAPR11MB3128.namprd11.prod.outlook.com>
x-forefront-prvs: 09435FCA72
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(366004)(39860400002)(376002)(396003)(136003)(199004)(189003)(4326008)(53946003)(8936002)(50226002)(476003)(52116002)(2616005)(2501003)(76176011)(305945005)(53936002)(6486002)(7736002)(66066001)(11346002)(2351001)(26005)(68736007)(6916009)(36756003)(6506007)(386003)(99286004)(6436002)(105586002)(102836004)(5640700003)(6512007)(8676002)(81156014)(81166006)(186003)(106356001)(446003)(97736004)(107886003)(478600001)(14444005)(256004)(30864003)(71200400001)(78486014)(25786009)(316002)(54906003)(72206003)(486006)(14454004)(2906002)(86362001)(3846002)(6116002)(71190400001)(569006);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3128;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: z1LC/KiRPeOp104HMeff2hm5T5T5E576bCZ/kp3dl3YOGhj11Si0P5D2Od7J0YHiP+0omnzivIzGIeEGx8YBsvuAqFa9jFWnKXwsaQEWK3pT183GwCU5kr//db6krr4bQHsjWKmbSddDx1F+I4NsigncqDjoly0qk9VjC/fNPnjp7aRgSsJL8AyAx9kZC6rxvjE6l5D+qG3aDpHOtdYDSpkv6tJJtxDkaKwvqC+9HI311BOC7J+potrgzU7esfnOAOFYZm13Dbn8SCcrOEc9IrTdRPyh747zMzzUKwuglZ1OKX9cptv8EgTv02njRD6EI0CvnHbqoJmxDj/XvImjQqUMvRiHW8zTp/7VOPUgwYEN+Kyp5XJejTOZ+dzVQYOcgx1jQosMv87kkj8S4tBB4BAhU8RtksP8xWan1BxFbT4=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 25a8b413-40ec-41a2-f815-08d68e5df6c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2019 07:12:31.4631
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3128
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Moved '/driver/staging/wilc1000/wilc_wfi_cfgoperations.c' to
'drivers/net/wireless/microchip/wilc1000/'.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 .../microchip/wilc1000/wilc_wfi_cfgoperations.c    | 1878 ++++++++++++++++=
++++
 1 file changed, 1878 insertions(+)
 create mode 100644 drivers/net/wireless/microchip/wilc1000/wilc_wfi_cfgope=
rations.c

diff --git a/drivers/net/wireless/microchip/wilc1000/wilc_wfi_cfgoperations=
.c b/drivers/net/wireless/microchip/wilc1000/wilc_wfi_cfgoperations.c
new file mode 100644
index 0000000..5e7a467
--- /dev/null
+++ b/drivers/net/wireless/microchip/wilc1000/wilc_wfi_cfgoperations.c
@@ -0,0 +1,1878 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2012 - 2018 Microchip Technology Inc., and its subsidiari=
es.
+ * All rights reserved.
+ */
+
+#include "wilc_wfi_cfgoperations.h"
+
+#define FRAME_TYPE_ID			0
+#define ACTION_CAT_ID			24
+#define ACTION_SUBTYPE_ID		25
+#define P2P_PUB_ACTION_SUBTYPE		30
+
+#define ACTION_FRAME			0xd0
+#define GO_INTENT_ATTR_ID		0x04
+#define CHANLIST_ATTR_ID		0x0b
+#define OPERCHAN_ATTR_ID		0x11
+#define PUB_ACTION_ATTR_ID		0x04
+#define P2PELEM_ATTR_ID			0xdd
+
+#define GO_NEG_REQ			0x00
+#define GO_NEG_RSP			0x01
+#define GO_NEG_CONF			0x02
+#define P2P_INV_REQ			0x03
+#define P2P_INV_RSP			0x04
+#define PUBLIC_ACT_VENDORSPEC		0x09
+#define GAS_INITIAL_REQ			0x0a
+#define GAS_INITIAL_RSP			0x0b
+
+#define WILC_INVALID_CHANNEL		0
+
+static const struct ieee80211_txrx_stypes
+	wilc_wfi_cfg80211_mgmt_types[NUM_NL80211_IFTYPES] =3D {
+	[NL80211_IFTYPE_STATION] =3D {
+		.tx =3D 0xffff,
+		.rx =3D BIT(IEEE80211_STYPE_ACTION >> 4) |
+			BIT(IEEE80211_STYPE_PROBE_REQ >> 4)
+	},
+	[NL80211_IFTYPE_AP] =3D {
+		.tx =3D 0xffff,
+		.rx =3D BIT(IEEE80211_STYPE_ASSOC_REQ >> 4) |
+			BIT(IEEE80211_STYPE_REASSOC_REQ >> 4) |
+			BIT(IEEE80211_STYPE_PROBE_REQ >> 4) |
+			BIT(IEEE80211_STYPE_DISASSOC >> 4) |
+			BIT(IEEE80211_STYPE_AUTH >> 4) |
+			BIT(IEEE80211_STYPE_DEAUTH >> 4) |
+			BIT(IEEE80211_STYPE_ACTION >> 4)
+	},
+	[NL80211_IFTYPE_P2P_CLIENT] =3D {
+		.tx =3D 0xffff,
+		.rx =3D BIT(IEEE80211_STYPE_ACTION >> 4) |
+			BIT(IEEE80211_STYPE_PROBE_REQ >> 4) |
+			BIT(IEEE80211_STYPE_ASSOC_REQ >> 4) |
+			BIT(IEEE80211_STYPE_REASSOC_REQ >> 4) |
+			BIT(IEEE80211_STYPE_DISASSOC >> 4) |
+			BIT(IEEE80211_STYPE_AUTH >> 4) |
+			BIT(IEEE80211_STYPE_DEAUTH >> 4)
+	}
+};
+
+static const struct wiphy_wowlan_support wowlan_support =3D {
+	.flags =3D WIPHY_WOWLAN_ANY
+};
+
+struct wilc_p2p_mgmt_data {
+	int size;
+	u8 *buff;
+};
+
+static const u8 p2p_oui[] =3D {0x50, 0x6f, 0x9A, 0x09};
+static const u8 p2p_vendor_spec[] =3D {0xdd, 0x05, 0x00, 0x08, 0x40, 0x03}=
;
+
+#define WILC_IP_TIMEOUT_MS		15000
+
+static void clear_during_ip(struct timer_list *t)
+{
+	struct wilc_vif *vif =3D from_timer(vif, t, during_ip_timer);
+
+	vif->obtaining_ip =3D false;
+}
+
+static void cfg_scan_result(enum scan_event scan_event,
+			    struct wilc_rcvd_net_info *info, void *user_void)
+{
+	struct wilc_priv *priv =3D user_void;
+
+	if (!priv->cfg_scanning)
+		return;
+
+	if (scan_event =3D=3D SCAN_EVENT_NETWORK_FOUND) {
+		s32 freq;
+		struct ieee80211_channel *channel;
+		struct cfg80211_bss *bss;
+		struct wiphy *wiphy =3D priv->dev->ieee80211_ptr->wiphy;
+
+		if (!wiphy || !info)
+			return;
+
+		freq =3D ieee80211_channel_to_frequency((s32)info->ch,
+						      NL80211_BAND_2GHZ);
+		channel =3D ieee80211_get_channel(wiphy, freq);
+		if (!channel)
+			return;
+
+		bss =3D cfg80211_inform_bss_frame(wiphy, channel, info->mgmt,
+						info->frame_len,
+						(s32)info->rssi * 100,
+						GFP_KERNEL);
+		if (!bss)
+			cfg80211_put_bss(wiphy, bss);
+	} else if (scan_event =3D=3D SCAN_EVENT_DONE) {
+		mutex_lock(&priv->scan_req_lock);
+
+		if (priv->scan_req) {
+			struct cfg80211_scan_info info =3D {
+				.aborted =3D false,
+			};
+
+			cfg80211_scan_done(priv->scan_req, &info);
+			priv->cfg_scanning =3D false;
+			priv->scan_req =3D NULL;
+		}
+		mutex_unlock(&priv->scan_req_lock);
+	} else if (scan_event =3D=3D SCAN_EVENT_ABORTED) {
+		mutex_lock(&priv->scan_req_lock);
+
+		if (priv->scan_req) {
+			struct cfg80211_scan_info info =3D {
+				.aborted =3D false,
+			};
+
+			cfg80211_scan_done(priv->scan_req, &info);
+			priv->cfg_scanning =3D false;
+			priv->scan_req =3D NULL;
+		}
+		mutex_unlock(&priv->scan_req_lock);
+	}
+}
+
+static void cfg_connect_result(enum conn_event conn_disconn_evt, u8 mac_st=
atus,
+			       void *priv_data)
+{
+	struct wilc_priv *priv =3D priv_data;
+	struct net_device *dev =3D priv->dev;
+	struct wilc_vif *vif =3D netdev_priv(dev);
+	struct wilc *wl =3D vif->wilc;
+	struct host_if_drv *wfi_drv =3D priv->hif_drv;
+	struct wilc_conn_info *conn_info =3D &wfi_drv->conn_info;
+
+	vif->connecting =3D false;
+
+	if (conn_disconn_evt =3D=3D CONN_DISCONN_EVENT_CONN_RESP) {
+		u16 connect_status =3D conn_info->status;
+
+		if (mac_status =3D=3D WILC_MAC_STATUS_DISCONNECTED &&
+		    connect_status =3D=3D WLAN_STATUS_SUCCESS) {
+			connect_status =3D WLAN_STATUS_UNSPECIFIED_FAILURE;
+			wilc_wlan_set_bssid(priv->dev, NULL, WILC_STATION_MODE);
+
+			if (vif->iftype !=3D WILC_CLIENT_MODE)
+				wl->sta_ch =3D WILC_INVALID_CHANNEL;
+
+			netdev_err(dev, "Unspecified failure\n");
+		}
+
+		if (connect_status =3D=3D WLAN_STATUS_SUCCESS)
+			memcpy(priv->associated_bss, conn_info->bssid,
+			       ETH_ALEN);
+
+		cfg80211_connect_result(dev, conn_info->bssid,
+					conn_info->req_ies,
+					conn_info->req_ies_len,
+					conn_info->resp_ies,
+					conn_info->resp_ies_len, connect_status,
+					GFP_KERNEL);
+	} else if (conn_disconn_evt =3D=3D CONN_DISCONN_EVENT_DISCONN_NOTIF) {
+		u16 reason =3D 0;
+
+		vif->obtaining_ip =3D false;
+		priv->p2p.local_random =3D 0x01;
+		priv->p2p.recv_random =3D 0x00;
+		priv->p2p.is_wilc_ie =3D false;
+		eth_zero_addr(priv->associated_bss);
+		wilc_wlan_set_bssid(priv->dev, NULL, WILC_STATION_MODE);
+
+		if (vif->iftype !=3D WILC_CLIENT_MODE)
+			wl->sta_ch =3D WILC_INVALID_CHANNEL;
+
+		if (wfi_drv->ifc_up && dev =3D=3D wl->vif[1]->ndev)
+			reason =3D 3;
+		else if (!wfi_drv->ifc_up && dev =3D=3D wl->vif[1]->ndev)
+			reason =3D 1;
+
+		cfg80211_disconnected(dev, reason, NULL, 0, false, GFP_KERNEL);
+	}
+}
+
+static int set_channel(struct wiphy *wiphy,
+		       struct cfg80211_chan_def *chandef)
+{
+	u32 channelnum =3D 0;
+	struct wilc_priv *priv =3D wiphy_priv(wiphy);
+	struct wilc_vif *vif =3D netdev_priv(priv->dev);
+	int result =3D 0;
+
+	channelnum =3D ieee80211_frequency_to_channel(chandef->chan->center_freq)=
;
+
+	vif->wilc->op_ch =3D channelnum;
+	result =3D wilc_set_mac_chnl_num(vif, channelnum);
+
+	if (result !=3D 0)
+		netdev_err(priv->dev, "Error in setting channel\n");
+
+	return result;
+}
+
+static inline int
+wilc_wfi_cfg_alloc_fill_ssid(struct cfg80211_scan_request *request,
+			     struct wilc_probe_ssid *search)
+{
+	int i;
+	int slot_id =3D 0;
+
+	search->ssid_info =3D kcalloc(request->n_ssids,
+				    sizeof(*search->ssid_info), GFP_KERNEL);
+	if (!search->ssid_info)
+		goto out;
+
+	search->n_ssids =3D request->n_ssids;
+
+	for (i =3D 0; i < request->n_ssids; i++) {
+		if (request->ssids[i].ssid_len > 0) {
+			struct wilc_probe_ssid_info *info;
+
+			info =3D &search->ssid_info[slot_id];
+			info->ssid =3D kmemdup(request->ssids[i].ssid,
+					     request->ssids[i].ssid_len,
+					     GFP_KERNEL);
+			if (!info->ssid)
+				goto out_free;
+
+			info->ssid_len =3D request->ssids[i].ssid_len;
+			slot_id++;
+		} else {
+			search->n_ssids -=3D 1;
+		}
+	}
+	return 0;
+
+out_free:
+
+	for (i =3D 0; i < slot_id; i++)
+		kfree(search->ssid_info[i].ssid);
+
+	kfree(search->ssid_info);
+out:
+
+	return -ENOMEM;
+}
+
+static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request=
)
+{
+	struct wilc_priv *priv =3D wiphy_priv(wiphy);
+	struct wilc_vif *vif =3D netdev_priv(priv->dev);
+	u32 i;
+	int ret =3D 0;
+	u8 scan_ch_list[WILC_MAX_NUM_SCANNED_CH];
+	struct wilc_probe_ssid probe_ssid;
+
+	if (request->n_channels > WILC_MAX_NUM_SCANNED_CH) {
+		netdev_err(priv->dev, "Requested scanned channels over\n");
+		return -EINVAL;
+	}
+
+	priv->scan_req =3D request;
+	priv->cfg_scanning =3D true;
+	for (i =3D 0; i < request->n_channels; i++) {
+		u16 freq =3D request->channels[i]->center_freq;
+
+		scan_ch_list[i] =3D ieee80211_frequency_to_channel(freq);
+	}
+
+	if (request->n_ssids >=3D 1) {
+		if (wilc_wfi_cfg_alloc_fill_ssid(request, &probe_ssid)) {
+			ret =3D -ENOMEM;
+			goto out;
+		}
+
+		ret =3D wilc_scan(vif, WILC_FW_USER_SCAN,
+				WILC_FW_ACTIVE_SCAN, scan_ch_list,
+				request->n_channels,
+				(const u8 *)request->ie,
+				request->ie_len, cfg_scan_result,
+				(void *)priv, &probe_ssid);
+	} else {
+		ret =3D wilc_scan(vif, WILC_FW_USER_SCAN,
+				WILC_FW_ACTIVE_SCAN, scan_ch_list,
+				request->n_channels,
+				(const u8 *)request->ie,
+				request->ie_len, cfg_scan_result,
+				(void *)priv, NULL);
+	}
+
+out:
+	if (ret) {
+		priv->scan_req =3D NULL;
+		priv->cfg_scanning =3D false;
+	}
+
+	return ret;
+}
+
+static int connect(struct wiphy *wiphy, struct net_device *dev,
+		   struct cfg80211_connect_params *sme)
+{
+	struct wilc_priv *priv =3D wiphy_priv(wiphy);
+	struct wilc_vif *vif =3D netdev_priv(priv->dev);
+	struct host_if_drv *wfi_drv =3D priv->hif_drv;
+	int ret;
+	u32 i;
+	u8 security =3D WILC_FW_SEC_NO;
+	enum authtype auth_type =3D WILC_FW_AUTH_ANY;
+	u32 cipher_group;
+	struct cfg80211_bss *bss;
+	void *join_params;
+	u8 ch;
+
+	vif->connecting =3D true;
+
+	memset(priv->wep_key, 0, sizeof(priv->wep_key));
+	memset(priv->wep_key_len, 0, sizeof(priv->wep_key_len));
+
+	cipher_group =3D sme->crypto.cipher_group;
+	if (cipher_group !=3D 0) {
+		if (cipher_group =3D=3D WLAN_CIPHER_SUITE_WEP40) {
+			security =3D WILC_FW_SEC_WEP;
+
+			priv->wep_key_len[sme->key_idx] =3D sme->key_len;
+			memcpy(priv->wep_key[sme->key_idx], sme->key,
+			       sme->key_len);
+
+			wilc_set_wep_default_keyid(vif, sme->key_idx);
+			wilc_add_wep_key_bss_sta(vif, sme->key, sme->key_len,
+						 sme->key_idx);
+		} else if (cipher_group =3D=3D WLAN_CIPHER_SUITE_WEP104) {
+			security =3D WILC_FW_SEC_WEP_EXTENDED;
+
+			priv->wep_key_len[sme->key_idx] =3D sme->key_len;
+			memcpy(priv->wep_key[sme->key_idx], sme->key,
+			       sme->key_len);
+
+			wilc_set_wep_default_keyid(vif, sme->key_idx);
+			wilc_add_wep_key_bss_sta(vif, sme->key, sme->key_len,
+						 sme->key_idx);
+		} else if (sme->crypto.wpa_versions & NL80211_WPA_VERSION_2) {
+			if (cipher_group =3D=3D WLAN_CIPHER_SUITE_TKIP)
+				security =3D WILC_FW_SEC_WPA2_TKIP;
+			else
+				security =3D WILC_FW_SEC_WPA2_AES;
+		} else if (sme->crypto.wpa_versions & NL80211_WPA_VERSION_1) {
+			if (cipher_group =3D=3D WLAN_CIPHER_SUITE_TKIP)
+				security =3D WILC_FW_SEC_WPA_TKIP;
+			else
+				security =3D WILC_FW_SEC_WPA_AES;
+		} else {
+			ret =3D -ENOTSUPP;
+			netdev_err(dev, "%s: Unsupported cipher\n",
+				   __func__);
+			goto out_error;
+		}
+	}
+
+	if ((sme->crypto.wpa_versions & NL80211_WPA_VERSION_1) ||
+	    (sme->crypto.wpa_versions & NL80211_WPA_VERSION_2)) {
+		for (i =3D 0; i < sme->crypto.n_ciphers_pairwise; i++) {
+			u32 ciphers_pairwise =3D sme->crypto.ciphers_pairwise[i];
+
+			if (ciphers_pairwise =3D=3D WLAN_CIPHER_SUITE_TKIP)
+				security |=3D WILC_FW_TKIP;
+			else
+				security |=3D WILC_FW_AES;
+		}
+	}
+
+	switch (sme->auth_type) {
+	case NL80211_AUTHTYPE_OPEN_SYSTEM:
+		auth_type =3D WILC_FW_AUTH_OPEN_SYSTEM;
+		break;
+
+	case NL80211_AUTHTYPE_SHARED_KEY:
+		auth_type =3D WILC_FW_AUTH_SHARED_KEY;
+		break;
+
+	default:
+		break;
+	}
+
+	if (sme->crypto.n_akm_suites) {
+		if (sme->crypto.akm_suites[0] =3D=3D WLAN_AKM_SUITE_8021X)
+			auth_type =3D WILC_FW_AUTH_IEEE8021;
+	}
+
+	if (wfi_drv->usr_scan_req.scan_result) {
+		netdev_err(vif->ndev, "%s: Scan in progress\n", __func__);
+		ret =3D -EBUSY;
+		goto out_error;
+	}
+
+	bss =3D cfg80211_get_bss(wiphy, sme->channel, sme->bssid, sme->ssid,
+			       sme->ssid_len, IEEE80211_BSS_TYPE_ANY,
+			       IEEE80211_PRIVACY(sme->privacy));
+	if (!bss) {
+		ret =3D -EINVAL;
+		goto out_error;
+	}
+
+	if (ether_addr_equal_unaligned(vif->bssid, bss->bssid)) {
+		ret =3D -EALREADY;
+		goto out_put_bss;
+	}
+
+	join_params =3D wilc_parse_join_bss_param(bss, &sme->crypto);
+	if (!join_params) {
+		netdev_err(dev, "%s: failed to construct join param\n",
+			   __func__);
+		ret =3D -EINVAL;
+		goto out_put_bss;
+	}
+
+	ch =3D ieee80211_frequency_to_channel(bss->channel->center_freq);
+	vif->wilc->op_ch =3D ch;
+	if (vif->iftype !=3D WILC_CLIENT_MODE)
+		vif->wilc->sta_ch =3D ch;
+
+	wilc_wlan_set_bssid(dev, bss->bssid, WILC_STATION_MODE);
+
+	wfi_drv->conn_info.security =3D security;
+	wfi_drv->conn_info.auth_type =3D auth_type;
+	wfi_drv->conn_info.ch =3D ch;
+	wfi_drv->conn_info.conn_result =3D cfg_connect_result;
+	wfi_drv->conn_info.arg =3D priv;
+	wfi_drv->conn_info.param =3D join_params;
+
+	ret =3D wilc_set_join_req(vif, bss->bssid, sme->ie, sme->ie_len);
+	if (ret) {
+		netdev_err(dev, "wilc_set_join_req(): Error\n");
+		ret =3D -ENOENT;
+		if (vif->iftype !=3D WILC_CLIENT_MODE)
+			vif->wilc->sta_ch =3D WILC_INVALID_CHANNEL;
+		wilc_wlan_set_bssid(dev, NULL, WILC_STATION_MODE);
+		wfi_drv->conn_info.conn_result =3D NULL;
+		kfree(join_params);
+		goto out_put_bss;
+	}
+	kfree(join_params);
+	cfg80211_put_bss(wiphy, bss);
+	return 0;
+
+out_put_bss:
+	cfg80211_put_bss(wiphy, bss);
+
+out_error:
+	vif->connecting =3D false;
+	return ret;
+}
+
+static int disconnect(struct wiphy *wiphy, struct net_device *dev,
+		      u16 reason_code)
+{
+	struct wilc_priv *priv =3D wiphy_priv(wiphy);
+	struct wilc_vif *vif =3D netdev_priv(priv->dev);
+	struct wilc *wilc =3D vif->wilc;
+	int ret;
+
+	vif->connecting =3D false;
+
+	if (!wilc)
+		return -EIO;
+
+	if (wilc->close) {
+		/* already disconnected done */
+		cfg80211_disconnected(dev, 0, NULL, 0, true, GFP_KERNEL);
+		return 0;
+	}
+
+	if (vif->iftype !=3D WILC_CLIENT_MODE)
+		wilc->sta_ch =3D WILC_INVALID_CHANNEL;
+	wilc_wlan_set_bssid(priv->dev, NULL, WILC_STATION_MODE);
+
+	priv->p2p.local_random =3D 0x01;
+	priv->p2p.recv_random =3D 0x00;
+	priv->p2p.is_wilc_ie =3D false;
+	priv->hif_drv->p2p_timeout =3D 0;
+
+	ret =3D wilc_disconnect(vif);
+	if (ret !=3D 0) {
+		netdev_err(priv->dev, "Error in disconnecting\n");
+		ret =3D -EINVAL;
+	}
+
+	return ret;
+}
+
+static inline void wilc_wfi_cfg_copy_wep_info(struct wilc_priv *priv,
+					      u8 key_index,
+					      struct key_params *params)
+{
+	priv->wep_key_len[key_index] =3D params->key_len;
+	memcpy(priv->wep_key[key_index], params->key, params->key_len);
+}
+
+static int wilc_wfi_cfg_allocate_wpa_entry(struct wilc_priv *priv, u8 idx)
+{
+	if (!priv->wilc_gtk[idx]) {
+		priv->wilc_gtk[idx] =3D kzalloc(sizeof(*priv->wilc_gtk[idx]),
+					      GFP_KERNEL);
+		if (!priv->wilc_gtk[idx])
+			return -ENOMEM;
+	}
+
+	if (!priv->wilc_ptk[idx]) {
+		priv->wilc_ptk[idx] =3D kzalloc(sizeof(*priv->wilc_ptk[idx]),
+					      GFP_KERNEL);
+		if (!priv->wilc_ptk[idx])
+			return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static int wilc_wfi_cfg_copy_wpa_info(struct wilc_wfi_key *key_info,
+				      struct key_params *params)
+{
+	kfree(key_info->key);
+
+	key_info->key =3D kmemdup(params->key, params->key_len, GFP_KERNEL);
+	if (!key_info->key)
+		return -ENOMEM;
+
+	kfree(key_info->seq);
+
+	if (params->seq_len > 0) {
+		key_info->seq =3D kmemdup(params->seq, params->seq_len,
+					GFP_KERNEL);
+		if (!key_info->seq)
+			return -ENOMEM;
+	}
+
+	key_info->cipher =3D params->cipher;
+	key_info->key_len =3D params->key_len;
+	key_info->seq_len =3D params->seq_len;
+
+	return 0;
+}
+
+static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_=
index,
+		   bool pairwise, const u8 *mac_addr, struct key_params *params)
+
+{
+	int ret =3D 0, keylen =3D params->key_len;
+	struct wilc_priv *priv =3D wiphy_priv(wiphy);
+	const u8 *rx_mic =3D NULL;
+	const u8 *tx_mic =3D NULL;
+	u8 mode =3D WILC_FW_SEC_NO;
+	u8 op_mode;
+	struct wilc_vif *vif =3D netdev_priv(netdev);
+
+	switch (params->cipher) {
+	case WLAN_CIPHER_SUITE_WEP40:
+	case WLAN_CIPHER_SUITE_WEP104:
+		if (priv->wdev->iftype =3D=3D NL80211_IFTYPE_AP) {
+			wilc_wfi_cfg_copy_wep_info(priv, key_index, params);
+
+			if (params->cipher =3D=3D WLAN_CIPHER_SUITE_WEP40)
+				mode =3D WILC_FW_SEC_WEP;
+			else
+				mode =3D WILC_FW_SEC_WEP_EXTENDED;
+
+			ret =3D wilc_add_wep_key_bss_ap(vif, params->key,
+						      params->key_len,
+						      key_index, mode,
+						      WILC_FW_AUTH_OPEN_SYSTEM);
+			break;
+		}
+		if (memcmp(params->key, priv->wep_key[key_index],
+			   params->key_len)) {
+			wilc_wfi_cfg_copy_wep_info(priv, key_index, params);
+
+			ret =3D wilc_add_wep_key_bss_sta(vif, params->key,
+						       params->key_len,
+						       key_index);
+		}
+
+		break;
+
+	case WLAN_CIPHER_SUITE_TKIP:
+	case WLAN_CIPHER_SUITE_CCMP:
+		if (priv->wdev->iftype =3D=3D NL80211_IFTYPE_AP ||
+		    priv->wdev->iftype =3D=3D NL80211_IFTYPE_P2P_GO) {
+			struct wilc_wfi_key *key;
+
+			ret =3D wilc_wfi_cfg_allocate_wpa_entry(priv, key_index);
+			if (ret)
+				return -ENOMEM;
+
+			if (params->key_len > 16 &&
+			    params->cipher =3D=3D WLAN_CIPHER_SUITE_TKIP) {
+				tx_mic =3D params->key + 24;
+				rx_mic =3D params->key + 16;
+				keylen =3D params->key_len - 16;
+			}
+
+			if (!pairwise) {
+				if (params->cipher =3D=3D WLAN_CIPHER_SUITE_TKIP)
+					mode =3D WILC_FW_SEC_WPA_TKIP;
+				else
+					mode =3D WILC_FW_SEC_WPA2_AES;
+
+				priv->wilc_groupkey =3D mode;
+
+				key =3D priv->wilc_gtk[key_index];
+			} else {
+				if (params->cipher =3D=3D WLAN_CIPHER_SUITE_TKIP)
+					mode =3D WILC_FW_SEC_WPA_TKIP;
+				else
+					mode =3D priv->wilc_groupkey | WILC_FW_AES;
+
+				key =3D priv->wilc_ptk[key_index];
+			}
+			ret =3D wilc_wfi_cfg_copy_wpa_info(key, params);
+			if (ret)
+				return -ENOMEM;
+
+			op_mode =3D WILC_AP_MODE;
+		} else {
+			if (params->key_len > 16 &&
+			    params->cipher =3D=3D WLAN_CIPHER_SUITE_TKIP) {
+				rx_mic =3D params->key + 24;
+				tx_mic =3D params->key + 16;
+				keylen =3D params->key_len - 16;
+			}
+
+			op_mode =3D WILC_STATION_MODE;
+		}
+
+		if (!pairwise)
+			ret =3D wilc_add_rx_gtk(vif, params->key, keylen,
+					      key_index, params->seq_len,
+					      params->seq, rx_mic, tx_mic,
+					      op_mode, mode);
+		else
+			ret =3D wilc_add_ptk(vif, params->key, keylen, mac_addr,
+					   rx_mic, tx_mic, op_mode, mode,
+					   key_index);
+
+		break;
+
+	default:
+		netdev_err(netdev, "%s: Unsupported cipher\n", __func__);
+		ret =3D -ENOTSUPP;
+	}
+
+	return ret;
+}
+
+static int del_key(struct wiphy *wiphy, struct net_device *netdev,
+		   u8 key_index,
+		   bool pairwise,
+		   const u8 *mac_addr)
+{
+	struct wilc_priv *priv =3D wiphy_priv(wiphy);
+	struct wilc_vif *vif =3D netdev_priv(netdev);
+	struct wilc *wl =3D vif->wilc;
+
+	if (netdev =3D=3D wl->vif[0]->ndev) {
+		if (priv->wilc_gtk[key_index]) {
+			kfree(priv->wilc_gtk[key_index]->key);
+			priv->wilc_gtk[key_index]->key =3D NULL;
+			kfree(priv->wilc_gtk[key_index]->seq);
+			priv->wilc_gtk[key_index]->seq =3D NULL;
+
+			kfree(priv->wilc_gtk[key_index]);
+			priv->wilc_gtk[key_index] =3D NULL;
+		}
+
+		if (priv->wilc_ptk[key_index]) {
+			kfree(priv->wilc_ptk[key_index]->key);
+			priv->wilc_ptk[key_index]->key =3D NULL;
+			kfree(priv->wilc_ptk[key_index]->seq);
+			priv->wilc_ptk[key_index]->seq =3D NULL;
+			kfree(priv->wilc_ptk[key_index]);
+			priv->wilc_ptk[key_index] =3D NULL;
+		}
+	}
+
+	if (key_index <=3D 3 && priv->wep_key_len[key_index]) {
+		memset(priv->wep_key[key_index], 0,
+		       priv->wep_key_len[key_index]);
+		priv->wep_key_len[key_index] =3D 0;
+		wilc_remove_wep_key(vif, key_index);
+	}
+
+	return 0;
+}
+
+static int get_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_=
index,
+		   bool pairwise, const u8 *mac_addr, void *cookie,
+		   void (*callback)(void *cookie, struct key_params *))
+{
+	struct wilc_priv *priv =3D wiphy_priv(wiphy);
+	struct  key_params key_params;
+
+	if (!pairwise) {
+		key_params.key =3D priv->wilc_gtk[key_index]->key;
+		key_params.cipher =3D priv->wilc_gtk[key_index]->cipher;
+		key_params.key_len =3D priv->wilc_gtk[key_index]->key_len;
+		key_params.seq =3D priv->wilc_gtk[key_index]->seq;
+		key_params.seq_len =3D priv->wilc_gtk[key_index]->seq_len;
+	} else {
+		key_params.key =3D priv->wilc_ptk[key_index]->key;
+		key_params.cipher =3D priv->wilc_ptk[key_index]->cipher;
+		key_params.key_len =3D priv->wilc_ptk[key_index]->key_len;
+		key_params.seq =3D priv->wilc_ptk[key_index]->seq;
+		key_params.seq_len =3D priv->wilc_ptk[key_index]->seq_len;
+	}
+
+	callback(cookie, &key_params);
+
+	return 0;
+}
+
+static int set_default_key(struct wiphy *wiphy, struct net_device *netdev,
+			   u8 key_index, bool unicast, bool multicast)
+{
+	struct wilc_priv *priv =3D wiphy_priv(wiphy);
+	struct wilc_vif *vif =3D netdev_priv(priv->dev);
+
+	wilc_set_wep_default_keyid(vif, key_index);
+
+	return 0;
+}
+
+static int get_station(struct wiphy *wiphy, struct net_device *dev,
+		       const u8 *mac, struct station_info *sinfo)
+{
+	struct wilc_priv *priv =3D wiphy_priv(wiphy);
+	struct wilc_vif *vif =3D netdev_priv(dev);
+	u32 i =3D 0;
+	u32 associatedsta =3D ~0;
+	u32 inactive_time =3D 0;
+
+	if (vif->iftype =3D=3D WILC_AP_MODE || vif->iftype =3D=3D WILC_GO_MODE) {
+		for (i =3D 0; i < NUM_STA_ASSOCIATED; i++) {
+			if (!(memcmp(mac,
+				     priv->assoc_stainfo.sta_associated_bss[i],
+				     ETH_ALEN))) {
+				associatedsta =3D i;
+				break;
+			}
+		}
+
+		if (associatedsta =3D=3D ~0) {
+			netdev_err(dev, "sta required is not associated\n");
+			return -ENOENT;
+		}
+
+		sinfo->filled |=3D BIT_ULL(NL80211_STA_INFO_INACTIVE_TIME);
+
+		wilc_get_inactive_time(vif, mac, &inactive_time);
+		sinfo->inactive_time =3D 1000 * inactive_time;
+	} else if (vif->iftype =3D=3D WILC_STATION_MODE) {
+		struct rf_info stats;
+
+		wilc_get_statistics(vif, &stats);
+
+		sinfo->filled |=3D BIT_ULL(NL80211_STA_INFO_SIGNAL) |
+				 BIT_ULL(NL80211_STA_INFO_RX_PACKETS) |
+				 BIT_ULL(NL80211_STA_INFO_TX_PACKETS) |
+				 BIT_ULL(NL80211_STA_INFO_TX_FAILED) |
+				 BIT_ULL(NL80211_STA_INFO_TX_BITRATE);
+
+		sinfo->signal =3D stats.rssi;
+		sinfo->rx_packets =3D stats.rx_cnt;
+		sinfo->tx_packets =3D stats.tx_cnt + stats.tx_fail_cnt;
+		sinfo->tx_failed =3D stats.tx_fail_cnt;
+		sinfo->txrate.legacy =3D stats.link_speed * 10;
+
+		if (stats.link_speed > TCP_ACK_FILTER_LINK_SPEED_THRESH &&
+		    stats.link_speed !=3D DEFAULT_LINK_SPEED)
+			wilc_enable_tcp_ack_filter(vif, true);
+		else if (stats.link_speed !=3D DEFAULT_LINK_SPEED)
+			wilc_enable_tcp_ack_filter(vif, false);
+	}
+	return 0;
+}
+
+static int change_bss(struct wiphy *wiphy, struct net_device *dev,
+		      struct bss_parameters *params)
+{
+	return 0;
+}
+
+static int set_wiphy_params(struct wiphy *wiphy, u32 changed)
+{
+	int ret;
+	struct cfg_param_attr cfg_param_val;
+	struct wilc_priv *priv =3D wiphy_priv(wiphy);
+	struct wilc_vif *vif =3D netdev_priv(priv->dev);
+
+	cfg_param_val.flag =3D 0;
+
+	if (changed & WIPHY_PARAM_RETRY_SHORT) {
+		netdev_dbg(vif->ndev,
+			   "Setting WIPHY_PARAM_RETRY_SHORT %d\n",
+			   wiphy->retry_short);
+		cfg_param_val.flag  |=3D WILC_CFG_PARAM_RETRY_SHORT;
+		cfg_param_val.short_retry_limit =3D wiphy->retry_short;
+	}
+	if (changed & WIPHY_PARAM_RETRY_LONG) {
+		netdev_dbg(vif->ndev,
+			   "Setting WIPHY_PARAM_RETRY_LONG %d\n",
+			   wiphy->retry_long);
+		cfg_param_val.flag |=3D WILC_CFG_PARAM_RETRY_LONG;
+		cfg_param_val.long_retry_limit =3D wiphy->retry_long;
+	}
+	if (changed & WIPHY_PARAM_FRAG_THRESHOLD) {
+		if (wiphy->frag_threshold > 255 &&
+		    wiphy->frag_threshold < 7937) {
+			netdev_dbg(vif->ndev,
+				   "Setting WIPHY_PARAM_FRAG_THRESHOLD %d\n",
+				   wiphy->frag_threshold);
+			cfg_param_val.flag |=3D WILC_CFG_PARAM_FRAG_THRESHOLD;
+			cfg_param_val.frag_threshold =3D wiphy->frag_threshold;
+		} else {
+			netdev_err(vif->ndev,
+				   "Fragmentation threshold out of range\n");
+			return -EINVAL;
+		}
+	}
+
+	if (changed & WIPHY_PARAM_RTS_THRESHOLD) {
+		if (wiphy->rts_threshold > 255) {
+			netdev_dbg(vif->ndev,
+				   "Setting WIPHY_PARAM_RTS_THRESHOLD %d\n",
+				   wiphy->rts_threshold);
+			cfg_param_val.flag |=3D WILC_CFG_PARAM_RTS_THRESHOLD;
+			cfg_param_val.rts_threshold =3D wiphy->rts_threshold;
+		} else {
+			netdev_err(vif->ndev, "RTS threshold out of range\n");
+			return -EINVAL;
+		}
+	}
+
+	ret =3D wilc_hif_set_cfg(vif, &cfg_param_val);
+	if (ret)
+		netdev_err(priv->dev, "Error in setting WIPHY PARAMS\n");
+
+	return ret;
+}
+
+static int set_pmksa(struct wiphy *wiphy, struct net_device *netdev,
+		     struct cfg80211_pmksa *pmksa)
+{
+	struct wilc_priv *priv =3D wiphy_priv(wiphy);
+	struct wilc_vif *vif =3D netdev_priv(priv->dev);
+	u32 i;
+	int ret =3D 0;
+	u8 flag =3D 0;
+
+	for (i =3D 0; i < priv->pmkid_list.numpmkid; i++)	{
+		if (!memcmp(pmksa->bssid, priv->pmkid_list.pmkidlist[i].bssid,
+			    ETH_ALEN)) {
+			flag =3D PMKID_FOUND;
+			break;
+		}
+	}
+	if (i < WILC_MAX_NUM_PMKIDS) {
+		memcpy(priv->pmkid_list.pmkidlist[i].bssid, pmksa->bssid,
+		       ETH_ALEN);
+		memcpy(priv->pmkid_list.pmkidlist[i].pmkid, pmksa->pmkid,
+		       WLAN_PMKID_LEN);
+		if (!(flag =3D=3D PMKID_FOUND))
+			priv->pmkid_list.numpmkid++;
+	} else {
+		netdev_err(netdev, "Invalid PMKID index\n");
+		ret =3D -EINVAL;
+	}
+
+	if (!ret)
+		ret =3D wilc_set_pmkid_info(vif, &priv->pmkid_list);
+
+	return ret;
+}
+
+static int del_pmksa(struct wiphy *wiphy, struct net_device *netdev,
+		     struct cfg80211_pmksa *pmksa)
+{
+	u32 i;
+	int ret =3D 0;
+	struct wilc_priv *priv =3D wiphy_priv(wiphy);
+
+	for (i =3D 0; i < priv->pmkid_list.numpmkid; i++)	{
+		if (!memcmp(pmksa->bssid, priv->pmkid_list.pmkidlist[i].bssid,
+			    ETH_ALEN)) {
+			memset(&priv->pmkid_list.pmkidlist[i], 0,
+			       sizeof(struct wilc_pmkid));
+			break;
+		}
+	}
+
+	if (i < priv->pmkid_list.numpmkid && priv->pmkid_list.numpmkid > 0) {
+		for (; i < (priv->pmkid_list.numpmkid - 1); i++) {
+			memcpy(priv->pmkid_list.pmkidlist[i].bssid,
+			       priv->pmkid_list.pmkidlist[i + 1].bssid,
+			       ETH_ALEN);
+			memcpy(priv->pmkid_list.pmkidlist[i].pmkid,
+			       priv->pmkid_list.pmkidlist[i + 1].pmkid,
+			       WLAN_PMKID_LEN);
+		}
+		priv->pmkid_list.numpmkid--;
+	} else {
+		ret =3D -EINVAL;
+	}
+
+	return ret;
+}
+
+static int flush_pmksa(struct wiphy *wiphy, struct net_device *netdev)
+{
+	struct wilc_priv *priv =3D wiphy_priv(wiphy);
+
+	memset(&priv->pmkid_list, 0, sizeof(struct wilc_pmkid_attr));
+
+	return 0;
+}
+
+static inline void wilc_wfi_cfg_parse_ch_attr(u8 *buf, u8 ch_list_attr_idx=
,
+					      u8 op_ch_attr_idx, u8 sta_ch)
+{
+	int i =3D 0;
+	int j =3D 0;
+
+	if (ch_list_attr_idx) {
+		u8 limit =3D ch_list_attr_idx + 3 + buf[ch_list_attr_idx + 1];
+
+		for (i =3D ch_list_attr_idx + 3; i < limit; i++) {
+			if (buf[i] =3D=3D 0x51) {
+				for (j =3D i + 2; j < ((i + 2) + buf[i + 1]); j++)
+					buf[j] =3D sta_ch;
+				break;
+			}
+		}
+	}
+
+	if (op_ch_attr_idx) {
+		buf[op_ch_attr_idx + 6] =3D 0x51;
+		buf[op_ch_attr_idx + 7] =3D sta_ch;
+	}
+}
+
+static void wilc_wfi_cfg_parse_rx_action(u8 *buf, u32 len, u8 sta_ch)
+{
+	u32 index =3D 0;
+	u8 op_channel_attr_index =3D 0;
+	u8 channel_list_attr_index =3D 0;
+
+	while (index < len) {
+		if (buf[index] =3D=3D GO_INTENT_ATTR_ID)
+			buf[index + 3] =3D (buf[index + 3]  & 0x01) | (0x00 << 1);
+
+		if (buf[index] =3D=3D  CHANLIST_ATTR_ID)
+			channel_list_attr_index =3D index;
+		else if (buf[index] =3D=3D  OPERCHAN_ATTR_ID)
+			op_channel_attr_index =3D index;
+		index +=3D buf[index + 1] + 3;
+	}
+	if (sta_ch !=3D WILC_INVALID_CHANNEL)
+		wilc_wfi_cfg_parse_ch_attr(buf, channel_list_attr_index,
+					   op_channel_attr_index, sta_ch);
+}
+
+static void wilc_wfi_cfg_parse_tx_action(u8 *buf, u32 len, bool oper_ch,
+					 u8 iftype, u8 sta_ch)
+{
+	u32 index =3D 0;
+	u8 op_channel_attr_index =3D 0;
+	u8 channel_list_attr_index =3D 0;
+
+	while (index < len) {
+		if (buf[index] =3D=3D GO_INTENT_ATTR_ID) {
+			buf[index + 3] =3D (buf[index + 3]  & 0x01) | (0x0f << 1);
+
+			break;
+		}
+
+		if (buf[index] =3D=3D  CHANLIST_ATTR_ID)
+			channel_list_attr_index =3D index;
+		else if (buf[index] =3D=3D  OPERCHAN_ATTR_ID)
+			op_channel_attr_index =3D index;
+		index +=3D buf[index + 1] + 3;
+	}
+	if (sta_ch !=3D WILC_INVALID_CHANNEL && oper_ch)
+		wilc_wfi_cfg_parse_ch_attr(buf, channel_list_attr_index,
+					   op_channel_attr_index, sta_ch);
+}
+
+static void wilc_wfi_cfg_parse_rx_vendor_spec(struct wilc_priv *priv, u8 *=
buff,
+					      u32 size)
+{
+	int i;
+	u8 subtype;
+	struct wilc_vif *vif =3D netdev_priv(priv->dev);
+
+	subtype =3D buff[P2P_PUB_ACTION_SUBTYPE];
+	if ((subtype =3D=3D GO_NEG_REQ || subtype =3D=3D GO_NEG_RSP) &&
+	    !priv->p2p.is_wilc_ie) {
+		for (i =3D P2P_PUB_ACTION_SUBTYPE; i < size; i++) {
+			if (!memcmp(p2p_vendor_spec, &buff[i], 6)) {
+				priv->p2p.recv_random =3D buff[i + 6];
+				priv->p2p.is_wilc_ie =3D true;
+				break;
+			}
+		}
+	}
+
+	if (priv->p2p.local_random <=3D priv->p2p.recv_random) {
+		netdev_dbg(vif->ndev,
+			   "PEER WILL BE GO LocaRand=3D%02x RecvRand %02x\n",
+			   priv->p2p.local_random, priv->p2p.recv_random);
+		return;
+	}
+
+	if (subtype =3D=3D GO_NEG_REQ || subtype =3D=3D GO_NEG_RSP ||
+	    subtype =3D=3D P2P_INV_REQ || subtype =3D=3D P2P_INV_RSP) {
+		for (i =3D P2P_PUB_ACTION_SUBTYPE + 2; i < size; i++) {
+			if (buff[i] =3D=3D P2PELEM_ATTR_ID &&
+			    !(memcmp(p2p_oui, &buff[i + 2], 4))) {
+				wilc_wfi_cfg_parse_rx_action(&buff[i + 6],
+							     size - (i + 6),
+							     vif->wilc->sta_ch);
+				break;
+			}
+		}
+	}
+}
+
+void wilc_wfi_p2p_rx(struct net_device *dev, u8 *buff, u32 size)
+{
+	struct wilc_priv *priv =3D wiphy_priv(dev->ieee80211_ptr->wiphy);
+	struct host_if_drv *wfi_drv =3D priv->hif_drv;
+	struct wilc_vif *vif =3D netdev_priv(dev);
+	struct wilc *wl =3D vif->wilc;
+	u32 header, pkt_offset;
+	s32 freq;
+	__le16 fc;
+
+	memcpy(&header, (buff - HOST_HDR_OFFSET), HOST_HDR_OFFSET);
+	le32_to_cpus(&header);
+	pkt_offset =3D GET_PKT_OFFSET(header);
+
+	if (pkt_offset & IS_MANAGMEMENT_CALLBACK) {
+		bool ack =3D false;
+
+		if (buff[FRAME_TYPE_ID] =3D=3D IEEE80211_STYPE_PROBE_RESP ||
+		    pkt_offset & IS_MGMT_STATUS_SUCCES)
+			ack =3D true;
+
+		cfg80211_mgmt_tx_status(priv->wdev, priv->tx_cookie, buff, size,
+					ack, GFP_KERNEL);
+		return;
+	}
+
+	freq =3D ieee80211_channel_to_frequency(wl->op_ch, NL80211_BAND_2GHZ);
+
+	fc =3D ((struct ieee80211_hdr *)buff)->frame_control;
+	if (!ieee80211_is_action(fc)) {
+		cfg80211_rx_mgmt(priv->wdev, freq, 0, buff, size, 0);
+		return;
+	}
+
+	if (priv->cfg_scanning &&
+	    time_after_eq(jiffies, (unsigned long)wfi_drv->p2p_timeout)) {
+		netdev_dbg(dev, "Receiving action wrong ch\n");
+		return;
+	}
+	if (buff[ACTION_CAT_ID] =3D=3D PUB_ACTION_ATTR_ID) {
+		u8 subtype =3D buff[P2P_PUB_ACTION_SUBTYPE];
+
+		switch (buff[ACTION_SUBTYPE_ID]) {
+		case GAS_INITIAL_REQ:
+		case GAS_INITIAL_RSP:
+			break;
+
+		case PUBLIC_ACT_VENDORSPEC:
+			if (!memcmp(p2p_oui, &buff[ACTION_SUBTYPE_ID + 1], 4))
+				wilc_wfi_cfg_parse_rx_vendor_spec(priv, buff,
+								  size);
+
+			if ((subtype =3D=3D GO_NEG_REQ || subtype =3D=3D GO_NEG_RSP) &&
+			    priv->p2p.is_wilc_ie)
+				size -=3D 7;
+
+			break;
+
+		default:
+			netdev_dbg(dev,
+				   "%s: Not handled action frame type:%x\n",
+				   __func__, buff[ACTION_SUBTYPE_ID]);
+			break;
+		}
+	}
+
+	cfg80211_rx_mgmt(priv->wdev, freq, 0, buff, size, 0);
+}
+
+static void wilc_wfi_mgmt_tx_complete(void *priv, int status)
+{
+	struct wilc_p2p_mgmt_data *pv_data =3D priv;
+
+	kfree(pv_data->buff);
+	kfree(pv_data);
+}
+
+static void wilc_wfi_remain_on_channel_expired(void *data, u64 cookie)
+{
+	struct wilc_priv *priv =3D data;
+	struct wilc_wfi_p2p_listen_params *params =3D &priv->remain_on_ch_params;
+
+	if (cookie !=3D params->listen_cookie)
+		return;
+
+	priv->p2p_listen_state =3D false;
+
+	cfg80211_remain_on_channel_expired(priv->wdev, params->listen_cookie,
+					   params->listen_ch, GFP_KERNEL);
+}
+
+static int remain_on_channel(struct wiphy *wiphy,
+			     struct wireless_dev *wdev,
+			     struct ieee80211_channel *chan,
+			     unsigned int duration, u64 *cookie)
+{
+	int ret =3D 0;
+	struct wilc_priv *priv =3D wiphy_priv(wiphy);
+	struct wilc_vif *vif =3D netdev_priv(priv->dev);
+	u64 id;
+
+	if (wdev->iftype =3D=3D NL80211_IFTYPE_AP) {
+		netdev_dbg(vif->ndev, "Required while in AP mode\n");
+		return ret;
+	}
+
+	id =3D ++priv->inc_roc_cookie;
+	if (id =3D=3D 0)
+		id =3D ++priv->inc_roc_cookie;
+
+	ret =3D wilc_remain_on_channel(vif, id, duration, chan->hw_value,
+				     wilc_wfi_remain_on_channel_expired,
+				     (void *)priv);
+	if (ret)
+		return ret;
+
+	vif->wilc->op_ch =3D chan->hw_value;
+
+	priv->remain_on_ch_params.listen_ch =3D chan;
+	priv->remain_on_ch_params.listen_cookie =3D id;
+	*cookie =3D id;
+	priv->p2p_listen_state =3D true;
+	priv->remain_on_ch_params.listen_duration =3D duration;
+
+	cfg80211_ready_on_channel(wdev, *cookie, chan, duration, GFP_KERNEL);
+	mod_timer(&vif->hif_drv->remain_on_ch_timer,
+		  jiffies + msecs_to_jiffies(duration));
+
+	return ret;
+}
+
+static int cancel_remain_on_channel(struct wiphy *wiphy,
+				    struct wireless_dev *wdev,
+				    u64 cookie)
+{
+	struct wilc_priv *priv =3D wiphy_priv(wiphy);
+	struct wilc_vif *vif =3D netdev_priv(priv->dev);
+
+	if (cookie !=3D priv->remain_on_ch_params.listen_cookie)
+		return -ENOENT;
+
+	return wilc_listen_state_expired(vif, cookie);
+}
+
+static void wilc_wfi_cfg_tx_vendor_spec(struct wilc_priv *priv,
+					struct wilc_p2p_mgmt_data *mgmt_tx,
+					struct cfg80211_mgmt_tx_params *params,
+					u8 iftype, u32 buf_len)
+{
+	const u8 *buf =3D params->buf;
+	size_t len =3D params->len;
+	u32 i;
+	u8 subtype =3D buf[P2P_PUB_ACTION_SUBTYPE];
+	struct wilc_vif *vif =3D netdev_priv(priv->dev);
+
+	if (subtype =3D=3D GO_NEG_REQ || subtype =3D=3D GO_NEG_RSP) {
+		if (priv->p2p.local_random =3D=3D 1 &&
+		    priv->p2p.recv_random < priv->p2p.local_random) {
+			get_random_bytes(&priv->p2p.local_random, 1);
+			priv->p2p.local_random++;
+		}
+	}
+
+	if (priv->p2p.local_random <=3D priv->p2p.recv_random ||
+	    !(subtype =3D=3D GO_NEG_REQ || subtype =3D=3D GO_NEG_RSP ||
+	      subtype =3D=3D P2P_INV_REQ || subtype =3D=3D P2P_INV_RSP))
+		return;
+
+	for (i =3D P2P_PUB_ACTION_SUBTYPE + 2; i < len; i++) {
+		if (buf[i] =3D=3D P2PELEM_ATTR_ID &&
+		    !memcmp(p2p_oui, &buf[i + 2], 4)) {
+			bool oper_ch =3D false;
+			u8 *tx_buff =3D &mgmt_tx->buff[i + 6];
+
+			if (subtype =3D=3D P2P_INV_REQ || subtype =3D=3D P2P_INV_RSP)
+				oper_ch =3D true;
+
+			wilc_wfi_cfg_parse_tx_action(tx_buff, len - (i + 6),
+						     oper_ch, iftype,
+						     vif->wilc->sta_ch);
+
+			break;
+		}
+	}
+
+	if (subtype !=3D P2P_INV_REQ && subtype !=3D P2P_INV_RSP) {
+		int vendor_spec_len =3D sizeof(p2p_vendor_spec);
+
+		memcpy(&mgmt_tx->buff[len], p2p_vendor_spec,
+		       vendor_spec_len);
+		mgmt_tx->buff[len + vendor_spec_len] =3D priv->p2p.local_random;
+		mgmt_tx->size =3D buf_len;
+	}
+}
+
+static int mgmt_tx(struct wiphy *wiphy,
+		   struct wireless_dev *wdev,
+		   struct cfg80211_mgmt_tx_params *params,
+		   u64 *cookie)
+{
+	struct ieee80211_channel *chan =3D params->chan;
+	unsigned int wait =3D params->wait;
+	const u8 *buf =3D params->buf;
+	size_t len =3D params->len;
+	const struct ieee80211_mgmt *mgmt;
+	struct wilc_p2p_mgmt_data *mgmt_tx;
+	struct wilc_priv *priv =3D wiphy_priv(wiphy);
+	struct host_if_drv *wfi_drv =3D priv->hif_drv;
+	struct wilc_vif *vif =3D netdev_priv(wdev->netdev);
+	u32 buf_len =3D len + sizeof(p2p_vendor_spec) + sizeof(priv->p2p.local_ra=
ndom);
+	int ret =3D 0;
+
+	*cookie =3D prandom_u32();
+	priv->tx_cookie =3D *cookie;
+	mgmt =3D (const struct ieee80211_mgmt *)buf;
+
+	if (!ieee80211_is_mgmt(mgmt->frame_control))
+		goto out;
+
+	mgmt_tx =3D kmalloc(sizeof(*mgmt_tx), GFP_KERNEL);
+	if (!mgmt_tx) {
+		ret =3D -ENOMEM;
+		goto out;
+	}
+
+	mgmt_tx->buff =3D kmalloc(buf_len, GFP_KERNEL);
+	if (!mgmt_tx->buff) {
+		ret =3D -ENOMEM;
+		kfree(mgmt_tx);
+		goto out;
+	}
+
+	memcpy(mgmt_tx->buff, buf, len);
+	mgmt_tx->size =3D len;
+
+	if (ieee80211_is_probe_resp(mgmt->frame_control)) {
+		wilc_set_mac_chnl_num(vif, chan->hw_value);
+		vif->wilc->op_ch =3D chan->hw_value;
+		goto out_txq_add_pkt;
+	}
+
+	if (!ieee80211_is_action(mgmt->frame_control))
+		goto out_txq_add_pkt;
+
+	if (buf[ACTION_CAT_ID] =3D=3D PUB_ACTION_ATTR_ID) {
+		if (buf[ACTION_SUBTYPE_ID] !=3D PUBLIC_ACT_VENDORSPEC ||
+		    buf[P2P_PUB_ACTION_SUBTYPE] !=3D GO_NEG_CONF) {
+			wilc_set_mac_chnl_num(vif, chan->hw_value);
+			vif->wilc->op_ch =3D chan->hw_value;
+		}
+		switch (buf[ACTION_SUBTYPE_ID]) {
+		case GAS_INITIAL_REQ:
+		case GAS_INITIAL_RSP:
+			break;
+
+		case PUBLIC_ACT_VENDORSPEC:
+			if (!memcmp(p2p_oui, &buf[ACTION_SUBTYPE_ID + 1], 4))
+				wilc_wfi_cfg_tx_vendor_spec(priv, mgmt_tx,
+							    params, vif->iftype,
+							    buf_len);
+			else
+				netdev_dbg(vif->ndev,
+					   "Not a P2P public action frame\n");
+
+			break;
+
+		default:
+			netdev_dbg(vif->ndev,
+				   "%s: Not handled action frame type:%x\n",
+				   __func__, buf[ACTION_SUBTYPE_ID]);
+			break;
+		}
+	}
+
+	wfi_drv->p2p_timeout =3D (jiffies + msecs_to_jiffies(wait));
+
+out_txq_add_pkt:
+
+	wilc_wlan_txq_add_mgmt_pkt(wdev->netdev, mgmt_tx,
+				   mgmt_tx->buff, mgmt_tx->size,
+				   wilc_wfi_mgmt_tx_complete);
+
+out:
+
+	return ret;
+}
+
+static int mgmt_tx_cancel_wait(struct wiphy *wiphy,
+			       struct wireless_dev *wdev,
+			       u64 cookie)
+{
+	struct wilc_priv *priv =3D wiphy_priv(wiphy);
+	struct host_if_drv *wfi_drv =3D priv->hif_drv;
+
+	wfi_drv->p2p_timeout =3D jiffies;
+
+	if (!priv->p2p_listen_state) {
+		struct wilc_wfi_p2p_listen_params *params;
+
+		params =3D &priv->remain_on_ch_params;
+
+		cfg80211_remain_on_channel_expired(priv->wdev,
+						   params->listen_cookie,
+						   params->listen_ch,
+						   GFP_KERNEL);
+	}
+
+	return 0;
+}
+
+void wilc_mgmt_frame_register(struct wiphy *wiphy, struct wireless_dev *wd=
ev,
+			      u16 frame_type, bool reg)
+{
+	struct wilc_priv *priv =3D wiphy_priv(wiphy);
+	struct wilc_vif *vif =3D netdev_priv(priv->wdev->netdev);
+	struct wilc *wl =3D vif->wilc;
+
+	if (!frame_type)
+		return;
+
+	switch (frame_type) {
+	case IEEE80211_STYPE_PROBE_REQ:
+		vif->frame_reg[0].type =3D frame_type;
+		vif->frame_reg[0].reg =3D reg;
+		break;
+
+	case IEEE80211_STYPE_ACTION:
+		vif->frame_reg[1].type =3D frame_type;
+		vif->frame_reg[1].reg =3D reg;
+		break;
+
+	default:
+		break;
+	}
+
+	if (!wl->initialized)
+		return;
+	wilc_frame_register(vif, frame_type, reg);
+}
+
+static int set_cqm_rssi_config(struct wiphy *wiphy, struct net_device *dev=
,
+			       s32 rssi_thold, u32 rssi_hyst)
+{
+	return 0;
+}
+
+static int dump_station(struct wiphy *wiphy, struct net_device *dev,
+			int idx, u8 *mac, struct station_info *sinfo)
+{
+	struct wilc_priv *priv =3D wiphy_priv(wiphy);
+	struct wilc_vif *vif =3D netdev_priv(priv->dev);
+	int ret;
+
+	if (idx !=3D 0)
+		return -ENOENT;
+
+	sinfo->filled |=3D BIT_ULL(NL80211_STA_INFO_SIGNAL);
+
+	ret =3D wilc_get_rssi(vif, &sinfo->signal);
+	if (ret)
+		return ret;
+
+	memcpy(mac, priv->associated_bss, ETH_ALEN);
+	return 0;
+}
+
+static int set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
+			  bool enabled, int timeout)
+{
+	struct wilc_priv *priv =3D wiphy_priv(wiphy);
+	struct wilc_vif *vif =3D netdev_priv(priv->dev);
+
+	if (!priv->hif_drv)
+		return -EIO;
+
+	if (vif->wilc->enable_ps)
+		wilc_set_power_mgmt(vif, enabled, timeout);
+
+	return 0;
+}
+
+static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev=
,
+			       enum nl80211_iftype type,
+			       struct vif_params *params)
+{
+	struct wilc_priv *priv =3D wiphy_priv(wiphy);
+	struct wilc_vif *vif =3D netdev_priv(dev);
+	struct wilc *wl =3D vif->wilc;
+
+	priv->p2p.local_random =3D 0x01;
+	priv->p2p.recv_random =3D 0x00;
+	priv->p2p.is_wilc_ie =3D false;
+	vif->obtaining_ip =3D false;
+	del_timer(&vif->during_ip_timer);
+
+	switch (type) {
+	case NL80211_IFTYPE_STATION:
+		vif->connecting =3D false;
+		dev->ieee80211_ptr->iftype =3D type;
+		priv->wdev->iftype =3D type;
+		vif->monitor_flag =3D 0;
+		vif->iftype =3D WILC_STATION_MODE;
+		wilc_set_operation_mode(vif, WILC_STATION_MODE);
+
+		memset(priv->assoc_stainfo.sta_associated_bss, 0,
+		       WILC_MAX_NUM_STA * ETH_ALEN);
+
+		wl->enable_ps =3D true;
+		wilc_set_power_mgmt(vif, 1, 0);
+		break;
+
+	case NL80211_IFTYPE_P2P_CLIENT:
+		vif->connecting =3D false;
+		dev->ieee80211_ptr->iftype =3D type;
+		priv->wdev->iftype =3D type;
+		vif->monitor_flag =3D 0;
+		vif->iftype =3D WILC_CLIENT_MODE;
+		wilc_set_operation_mode(vif, WILC_STATION_MODE);
+
+		wl->enable_ps =3D false;
+		wilc_set_power_mgmt(vif, 0, 0);
+		break;
+
+	case NL80211_IFTYPE_AP:
+		wl->enable_ps =3D false;
+		dev->ieee80211_ptr->iftype =3D type;
+		priv->wdev->iftype =3D type;
+		vif->iftype =3D WILC_AP_MODE;
+
+		if (wl->initialized) {
+			wilc_set_wfi_drv_handler(vif, wilc_get_vif_idx(vif),
+						 0, vif->ifc_id);
+			wilc_set_operation_mode(vif, WILC_AP_MODE);
+			wilc_set_power_mgmt(vif, 0, 0);
+		}
+		break;
+
+	case NL80211_IFTYPE_P2P_GO:
+		vif->obtaining_ip =3D true;
+		mod_timer(&vif->during_ip_timer,
+			  jiffies + msecs_to_jiffies(WILC_IP_TIMEOUT_MS));
+		wilc_set_operation_mode(vif, WILC_AP_MODE);
+		dev->ieee80211_ptr->iftype =3D type;
+		priv->wdev->iftype =3D type;
+		vif->iftype =3D WILC_GO_MODE;
+
+		wl->enable_ps =3D false;
+		wilc_set_power_mgmt(vif, 0, 0);
+		break;
+
+	default:
+		netdev_err(dev, "Unknown interface type=3D %d\n", type);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int start_ap(struct wiphy *wiphy, struct net_device *dev,
+		    struct cfg80211_ap_settings *settings)
+{
+	struct wilc_vif *vif =3D netdev_priv(dev);
+	struct wilc *wl =3D vif->wilc;
+	int ret;
+
+	ret =3D set_channel(wiphy, &settings->chandef);
+	if (ret !=3D 0)
+		netdev_err(dev, "Error in setting channel\n");
+
+	wilc_wlan_set_bssid(dev, wl->vif[vif->idx]->src_addr, WILC_AP_MODE);
+	wilc_set_power_mgmt(vif, 0, 0);
+
+	return wilc_add_beacon(vif, settings->beacon_interval,
+				   settings->dtim_period, &settings->beacon);
+}
+
+static int change_beacon(struct wiphy *wiphy, struct net_device *dev,
+			 struct cfg80211_beacon_data *beacon)
+{
+	struct wilc_priv *priv =3D wiphy_priv(wiphy);
+	struct wilc_vif *vif =3D netdev_priv(priv->dev);
+
+	return wilc_add_beacon(vif, 0, 0, beacon);
+}
+
+static int stop_ap(struct wiphy *wiphy, struct net_device *dev)
+{
+	int ret;
+	struct wilc_priv *priv =3D wiphy_priv(wiphy);
+	struct wilc_vif *vif =3D netdev_priv(priv->dev);
+
+	wilc_wlan_set_bssid(dev, NULL, WILC_AP_MODE);
+
+	ret =3D wilc_del_beacon(vif);
+
+	if (ret)
+		netdev_err(dev, "Host delete beacon fail\n");
+
+	return ret;
+}
+
+static int add_station(struct wiphy *wiphy, struct net_device *dev,
+		       const u8 *mac, struct station_parameters *params)
+{
+	int ret =3D 0;
+	struct wilc_priv *priv =3D wiphy_priv(wiphy);
+	struct wilc_vif *vif =3D netdev_priv(dev);
+
+	if (vif->iftype =3D=3D WILC_AP_MODE || vif->iftype =3D=3D WILC_GO_MODE) {
+		memcpy(priv->assoc_stainfo.sta_associated_bss[params->aid], mac,
+		       ETH_ALEN);
+
+		ret =3D wilc_add_station(vif, mac, params);
+		if (ret)
+			netdev_err(dev, "Host add station fail\n");
+	}
+
+	return ret;
+}
+
+static int del_station(struct wiphy *wiphy, struct net_device *dev,
+		       struct station_del_parameters *params)
+{
+	const u8 *mac =3D params->mac;
+	int ret =3D 0;
+	struct wilc_priv *priv =3D wiphy_priv(wiphy);
+	struct wilc_vif *vif =3D netdev_priv(dev);
+	struct sta_info *info;
+
+	if (!(vif->iftype =3D=3D WILC_AP_MODE || vif->iftype =3D=3D WILC_GO_MODE)=
)
+		return ret;
+
+	info =3D &priv->assoc_stainfo;
+
+	if (!mac)
+		ret =3D wilc_del_allstation(vif, info->sta_associated_bss);
+
+	ret =3D wilc_del_station(vif, mac);
+	if (ret)
+		netdev_err(dev, "Host delete station fail\n");
+	return ret;
+}
+
+static int change_station(struct wiphy *wiphy, struct net_device *dev,
+			  const u8 *mac, struct station_parameters *params)
+{
+	int ret =3D 0;
+	struct wilc_vif *vif =3D netdev_priv(dev);
+
+	if (vif->iftype =3D=3D WILC_AP_MODE || vif->iftype =3D=3D WILC_GO_MODE) {
+		ret =3D wilc_edit_station(vif, mac, params);
+		if (ret)
+			netdev_err(dev, "Host edit station fail\n");
+	}
+	return ret;
+}
+
+static struct wireless_dev *add_virtual_intf(struct wiphy *wiphy,
+					     const char *name,
+					     unsigned char name_assign_type,
+					     enum nl80211_iftype type,
+					     struct vif_params *params)
+{
+	struct wilc_priv *priv =3D wiphy_priv(wiphy);
+	struct wilc_vif *vif =3D netdev_priv(priv->wdev->netdev);
+	struct net_device *new_ifc;
+
+	if (type =3D=3D NL80211_IFTYPE_MONITOR) {
+		new_ifc =3D wilc_wfi_init_mon_interface(vif->wilc, name,
+						      vif->ndev);
+		if (new_ifc) {
+			vif =3D netdev_priv(priv->wdev->netdev);
+			vif->monitor_flag =3D 1;
+		}
+	}
+	return priv->wdev;
+}
+
+static int del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev=
)
+{
+	return 0;
+}
+
+static int wilc_suspend(struct wiphy *wiphy, struct cfg80211_wowlan *wow)
+{
+	struct wilc_priv *priv =3D wiphy_priv(wiphy);
+	struct wilc_vif *vif =3D netdev_priv(priv->dev);
+
+	if (!wow && wilc_wlan_get_num_conn_ifcs(vif->wilc))
+		vif->wilc->suspend_event =3D true;
+	else
+		vif->wilc->suspend_event =3D false;
+
+	return 0;
+}
+
+static int wilc_resume(struct wiphy *wiphy)
+{
+	struct wilc_priv *priv =3D wiphy_priv(wiphy);
+	struct wilc_vif *vif =3D netdev_priv(priv->dev);
+
+	netdev_info(vif->ndev, "cfg resume\n");
+	return 0;
+}
+
+static void wilc_set_wakeup(struct wiphy *wiphy, bool enabled)
+{
+	struct wilc_priv *priv =3D wiphy_priv(wiphy);
+	struct wilc_vif *vif =3D netdev_priv(priv->dev);
+
+	netdev_info(vif->ndev, "cfg set wake up =3D %d\n", enabled);
+}
+
+static int set_tx_power(struct wiphy *wiphy, struct wireless_dev *wdev,
+			enum nl80211_tx_power_setting type, int mbm)
+{
+	int ret;
+	s32 tx_power =3D MBM_TO_DBM(mbm);
+	struct wilc_priv *priv =3D wiphy_priv(wiphy);
+	struct wilc_vif *vif =3D netdev_priv(priv->dev);
+
+	if (tx_power < 0)
+		tx_power =3D 0;
+	else if (tx_power > 18)
+		tx_power =3D 18;
+	ret =3D wilc_set_tx_power(vif, tx_power);
+	if (ret)
+		netdev_err(vif->ndev, "Failed to set tx power\n");
+
+	return ret;
+}
+
+static int get_tx_power(struct wiphy *wiphy, struct wireless_dev *wdev,
+			int *dbm)
+{
+	int ret;
+	struct wilc_priv *priv =3D wiphy_priv(wiphy);
+	struct wilc_vif *vif =3D netdev_priv(priv->dev);
+	struct wilc *wl =3D vif->wilc;
+
+	/* If firmware is not started, return. */
+	if (!wl->initialized)
+		return -EIO;
+
+	ret =3D wilc_get_tx_power(vif, (u8 *)dbm);
+	if (ret)
+		netdev_err(vif->ndev, "Failed to get tx power\n");
+
+	return ret;
+}
+
+static const struct cfg80211_ops wilc_cfg80211_ops =3D {
+	.set_monitor_channel =3D set_channel,
+	.scan =3D scan,
+	.connect =3D connect,
+	.disconnect =3D disconnect,
+	.add_key =3D add_key,
+	.del_key =3D del_key,
+	.get_key =3D get_key,
+	.set_default_key =3D set_default_key,
+	.add_virtual_intf =3D add_virtual_intf,
+	.del_virtual_intf =3D del_virtual_intf,
+	.change_virtual_intf =3D change_virtual_intf,
+
+	.start_ap =3D start_ap,
+	.change_beacon =3D change_beacon,
+	.stop_ap =3D stop_ap,
+	.add_station =3D add_station,
+	.del_station =3D del_station,
+	.change_station =3D change_station,
+	.get_station =3D get_station,
+	.dump_station =3D dump_station,
+	.change_bss =3D change_bss,
+	.set_wiphy_params =3D set_wiphy_params,
+
+	.set_pmksa =3D set_pmksa,
+	.del_pmksa =3D del_pmksa,
+	.flush_pmksa =3D flush_pmksa,
+	.remain_on_channel =3D remain_on_channel,
+	.cancel_remain_on_channel =3D cancel_remain_on_channel,
+	.mgmt_tx_cancel_wait =3D mgmt_tx_cancel_wait,
+	.mgmt_tx =3D mgmt_tx,
+	.mgmt_frame_register =3D wilc_mgmt_frame_register,
+	.set_power_mgmt =3D set_power_mgmt,
+	.set_cqm_rssi_config =3D set_cqm_rssi_config,
+
+	.suspend =3D wilc_suspend,
+	.resume =3D wilc_resume,
+	.set_wakeup =3D wilc_set_wakeup,
+	.set_tx_power =3D set_tx_power,
+	.get_tx_power =3D get_tx_power,
+
+};
+
+static struct wireless_dev *wilc_wfi_cfg_alloc(void)
+{
+	struct wireless_dev *wdev;
+
+	wdev =3D kzalloc(sizeof(*wdev), GFP_KERNEL);
+	if (!wdev)
+		goto out;
+
+	wdev->wiphy =3D wiphy_new(&wilc_cfg80211_ops, sizeof(struct wilc_priv));
+	if (!wdev->wiphy)
+		goto free_mem;
+
+	return wdev;
+
+free_mem:
+	kfree(wdev);
+out:
+	return NULL;
+}
+
+struct wireless_dev *wilc_create_wiphy(struct net_device *net,
+				       struct device *dev)
+{
+	struct wilc_priv *priv;
+	struct wireless_dev *wdev;
+	int ret;
+
+	wdev =3D wilc_wfi_cfg_alloc();
+	if (!wdev) {
+		netdev_err(net, "wiphy new allocate failed\n");
+		return NULL;
+	}
+
+	priv =3D wdev_priv(wdev);
+	priv->wdev =3D wdev;
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
+	wdev->wiphy->max_scan_ssids =3D WILC_MAX_NUM_PROBED_SSID;
+#ifdef CONFIG_PM
+	wdev->wiphy->wowlan =3D &wowlan_support;
+#endif
+	wdev->wiphy->max_num_pmkids =3D WILC_MAX_NUM_PMKIDS;
+	wdev->wiphy->max_scan_ie_len =3D 1000;
+	wdev->wiphy->signal_type =3D CFG80211_SIGNAL_TYPE_MBM;
+	memcpy(priv->cipher_suites, wilc_cipher_suites,
+	       sizeof(wilc_cipher_suites));
+	wdev->wiphy->cipher_suites =3D priv->cipher_suites;
+	wdev->wiphy->n_cipher_suites =3D ARRAY_SIZE(wilc_cipher_suites);
+	wdev->wiphy->mgmt_stypes =3D wilc_wfi_cfg80211_mgmt_types;
+
+	wdev->wiphy->max_remain_on_channel_duration =3D 500;
+	wdev->wiphy->interface_modes =3D BIT(NL80211_IFTYPE_STATION) |
+					BIT(NL80211_IFTYPE_AP) |
+					BIT(NL80211_IFTYPE_MONITOR) |
+					BIT(NL80211_IFTYPE_P2P_GO) |
+					BIT(NL80211_IFTYPE_P2P_CLIENT);
+	wdev->wiphy->flags |=3D WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
+	wdev->iftype =3D NL80211_IFTYPE_STATION;
+
+	set_wiphy_dev(wdev->wiphy, dev);
+
+	ret =3D wiphy_register(wdev->wiphy);
+	if (ret) {
+		netdev_err(net, "Cannot register wiphy device\n");
+		wiphy_free(wdev->wiphy);
+		kfree(wdev);
+		return NULL;
+	}
+
+	priv->dev =3D net;
+	return wdev;
+}
+
+int wilc_init_host_int(struct net_device *net)
+{
+	int ret;
+	struct wilc_priv *priv =3D wdev_priv(net->ieee80211_ptr);
+	struct wilc_vif *vif =3D netdev_priv(priv->dev);
+
+	timer_setup(&vif->during_ip_timer, clear_during_ip, 0);
+
+	priv->p2p_listen_state =3D false;
+
+	mutex_init(&priv->scan_req_lock);
+	ret =3D wilc_init(net, &priv->hif_drv);
+	if (ret)
+		netdev_err(net, "Error while initializing hostinterface\n");
+
+	return ret;
+}
+
+void wilc_deinit_host_int(struct net_device *net)
+{
+	int ret;
+	struct wilc_priv *priv =3D wdev_priv(net->ieee80211_ptr);
+	struct wilc_vif *vif =3D netdev_priv(priv->dev);
+
+	priv->p2p_listen_state =3D false;
+
+	mutex_destroy(&priv->scan_req_lock);
+	ret =3D wilc_deinit(vif);
+
+	del_timer_sync(&vif->during_ip_timer);
+
+	if (ret)
+		netdev_err(net, "Error while deinitializing host interface\n");
+}
+
+void wilc_free_wiphy(struct net_device *net)
+{
+	if (!net)
+		return;
+
+	if (!net->ieee80211_ptr)
+		return;
+
+	if (!net->ieee80211_ptr->wiphy)
+		return;
+
+	wiphy_unregister(net->ieee80211_ptr->wiphy);
+
+	wiphy_free(net->ieee80211_ptr->wiphy);
+	kfree(net->ieee80211_ptr);
+}
--=20
2.7.4

