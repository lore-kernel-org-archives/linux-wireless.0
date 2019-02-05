Return-Path: <SRS0=RZRw=QM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02F16C282CC
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 07:16:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9B4D2081B
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 07:16:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="Jis1zP+l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727503AbfBEHQD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 5 Feb 2019 02:16:03 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:40034 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbfBEHQC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Feb 2019 02:16:02 -0500
X-IronPort-AV: E=Sophos;i="5.56,562,1539673200"; 
   d="scan'208";a="25864257"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 05 Feb 2019 00:16:01 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.105) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Tue, 5 Feb 2019 00:16:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8wfKAu+ZdM7SyuK7O1msKomwsm1BhYEtmQIA6zvyzPo=;
 b=Jis1zP+ljEOabUxWE6UzGiPqhVtBidkbZ1Wrk07BFJOjCQipmUxfZqdVuhszHroGPT0ap0cFjbr2YbQ2g9B0S9hlRyoQDVPslySrWnvOSnCmuw2a/i05vBMTXQaq8hvVsZJ8P4KiQXCYaqr/O3S5arWz+LRormJHatWcAY3SXiY=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2984.namprd11.prod.outlook.com (20.177.224.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.20; Tue, 5 Feb 2019 07:15:59 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1580.019; Tue, 5 Feb 2019
 07:15:59 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 10/12] staging: wilc1000: move static variable 'wlan_channel'
 to 'wilc' struct
Thread-Topic: [PATCH 10/12] staging: wilc1000: move static variable
 'wlan_channel' to 'wilc' struct
Thread-Index: AQHUvSKlgFsEsEm8ZUaIyW1x7vlBqg==
Date:   Tue, 5 Feb 2019 07:15:59 +0000
Message-ID: <1549350913-645-11-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2984;6:amTnJ0DTRrwjlY5X3i/DpiULk4Na0bG+AVEfd32W8Tv8Y/Du5QrLCPLFgCegP1EdEJNYuSABBppgbciPBETW7+Y72bu2msO6bbZ4fQaixL9OjbUruuWw+GM6UYVpsZ6UW63X1Qgim8TnCoey+BDmuC8Km1uhvqJnWMHtrxgpTL5iZ3+jpVd/pTuylTo4n5XkcHIKKV7BgoOo8h2lYxNOumLx8lx0CcwlPRtsV87gWRJYkuupMw21KAz5yxMltEJioPUdHZuEIhzxAOYJq/n1dDHWA2bEg6bTcqls2txhAm6VrMfqSsnDMfTus07bJemkbzysDasbRWURAlaMMccZ66SssIGM/2AHeUtGXzNgak5tmyZ79PICO6ah8cklz9eO4WAa37fKtJEU73wsUERjPdO/mF1NAij3p9c2iBgfBf3BqyBfSnxgUkiFjj+Qg4SDMavDVfz8lZT0HwNopvXG1w==;5:Qw8AVMdvcFjg0fIOM8E+ww+xDbWZ0CL00qpYDIJqSOiKmgA6slWIvK1OSo9mfhzEt7VVRaFw37ItgKz71vMWodFQ/PNKpFlv1Ztgw4sMDZuDkWsbVuB92Cl5e2WreccdlxmLuk6/Ni3dU/4sXoMsebUzUO3in8fUPbR4MediWzwZNagydb6TaAEw3u3ppp9z0g4ABWYN4oXC7Uw3VdXT8g==;7:0ioaUvuQqcl0jBp1CLNkup4aCznKXxipD/3e9Be0pa/17QOLXGTfpRQJWC+vCXtAbA//GQpajiNZ8Wv7BORqhfgIWQfx1O6fRUcJEBGvFFsbBg1LopK7bZA5fvsZ5HtdZBeJsTGxH2z9/g/H00WJUA==
x-ms-office365-filtering-correlation-id: 2b2f0f46-806e-478b-0886-08d68b39c747
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2984;
x-ms-traffictypediagnostic: BYAPR11MB2984:
x-microsoft-antispam-prvs: <BYAPR11MB2984DD9CE73E4F3B41AF44EDE36E0@BYAPR11MB2984.namprd11.prod.outlook.com>
x-forefront-prvs: 0939529DE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(39860400002)(376002)(396003)(346002)(136003)(199004)(189003)(4326008)(36756003)(386003)(6116002)(3846002)(102836004)(14454004)(68736007)(97736004)(11346002)(78486014)(316002)(2351001)(5640700003)(478600001)(25786009)(6436002)(53936002)(71190400001)(26005)(71200400001)(6486002)(106356001)(72206003)(6916009)(446003)(8676002)(105586002)(305945005)(6512007)(186003)(6506007)(7736002)(486006)(476003)(66066001)(2616005)(8936002)(107886003)(52116002)(81166006)(81156014)(76176011)(2501003)(50226002)(256004)(14444005)(99286004)(54906003)(2906002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2984;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: utq6j/k26Fz3+UEtlGSEzXFFJ8wIOtkhQf5Q7zBPGQ/TBgcvMeD1TK7+VbK9ce9zGH66kvQsrQpWNy2NoGO8l6+LFmhRhHpKooEL1chgMDWZbHPgH5sa/3LY55//6tI4bN7xATQ5+OaXaqqzTu6dQOv/ND6+NaetfUeOFNuxNnmChnlCPDzXSWsF7EbvAS3HJqFPAvLSfmnQ7Lir+BqJvT6/YfY+TVbDEZpprqVY/hHUseNftDsf/sTErxHKmlGbOL8HQIjtHI4PhHDLrr3/Hw9Ch3pExDn/hynAUDP7qeAJBzQKrQ41v8tHdIuV0ZbPtYjkRighm8uz3kPdoqq8CYgSZriY0NLpTiX3rO2qOOMkl+wJU54bGG73c2HVEJF6PRiAcBJfyTNur7j2B3jYki5orYSpp/gc9SLKFf6l2+M=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b2f0f46-806e-478b-0886-08d68b39c747
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2019 07:15:57.2978
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2984
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Avoid use of static variable 'wlan_channel' by moving it inside the wilc
structure.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 36 ++++++++++++-------=
----
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  1 +
 2 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/st=
aging/wilc1000/wilc_wfi_cfgoperations.c
index 98121ec..f1ce34f 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -67,7 +67,6 @@ struct p2p_mgmt_data {
 	u8 *buff;
 };
=20
-static u8 wlan_channel =3D INVALID_CHANNEL;
 static u8 curr_channel;
 static u8 p2p_oui[] =3D {0x50, 0x6f, 0x9A, 0x09};
 static u8 p2p_vendor_spec[] =3D {0xdd, 0x05, 0x00, 0x08, 0x40, 0x03};
@@ -160,7 +159,7 @@ static void cfg_connect_result(enum conn_event conn_dis=
conn_evt, u8 mac_status,
 			wilc_wlan_set_bssid(priv->dev, NULL, WILC_STATION_MODE);
=20
 			if (vif->iftype !=3D WILC_CLIENT_MODE)
-				wlan_channel =3D INVALID_CHANNEL;
+				wl->sta_ch =3D INVALID_CHANNEL;
=20
 			netdev_err(dev, "Unspecified failure\n");
 		}
@@ -186,7 +185,7 @@ static void cfg_connect_result(enum conn_event conn_dis=
conn_evt, u8 mac_status,
 		wilc_wlan_set_bssid(priv->dev, NULL, WILC_STATION_MODE);
=20
 		if (vif->iftype !=3D WILC_CLIENT_MODE)
-			wlan_channel =3D INVALID_CHANNEL;
+			wl->sta_ch =3D INVALID_CHANNEL;
=20
 		if (wfi_drv->ifc_up && dev =3D=3D wl->vif[1]->ndev)
 			reason =3D 3;
@@ -431,7 +430,7 @@ static int connect(struct wiphy *wiphy, struct net_devi=
ce *dev,
 	curr_channel =3D ieee80211_frequency_to_channel(bss->channel->center_freq=
);
=20
 	if (vif->iftype !=3D WILC_CLIENT_MODE)
-		wlan_channel =3D curr_channel;
+		vif->wilc->sta_ch =3D curr_channel;
=20
 	wilc_wlan_set_bssid(dev, bss->bssid, WILC_STATION_MODE);
=20
@@ -447,7 +446,7 @@ static int connect(struct wiphy *wiphy, struct net_devi=
ce *dev,
 		netdev_err(dev, "wilc_set_join_req(): Error\n");
 		ret =3D -ENOENT;
 		if (vif->iftype !=3D WILC_CLIENT_MODE)
-			wlan_channel =3D INVALID_CHANNEL;
+			vif->wilc->sta_ch =3D INVALID_CHANNEL;
 		wilc_wlan_set_bssid(dev, NULL, WILC_STATION_MODE);
 		wfi_drv->conn_info.conn_result =3D NULL;
 		kfree(join_params);
@@ -485,7 +484,7 @@ static int disconnect(struct wiphy *wiphy, struct net_d=
evice *dev,
 	}
=20
 	if (vif->iftype !=3D WILC_CLIENT_MODE)
-		wlan_channel =3D INVALID_CHANNEL;
+		wilc->sta_ch =3D INVALID_CHANNEL;
 	wilc_wlan_set_bssid(priv->dev, NULL, WILC_STATION_MODE);
=20
 	priv->p2p.local_random =3D 0x01;
@@ -936,7 +935,7 @@ static int flush_pmksa(struct wiphy *wiphy, struct net_=
device *netdev)
 }
=20
 static inline void wilc_wfi_cfg_parse_ch_attr(u8 *buf, u8 ch_list_attr_idx=
,
-					      u8 op_ch_attr_idx)
+					      u8 op_ch_attr_idx, u8 sta_ch)
 {
 	int i =3D 0;
 	int j =3D 0;
@@ -947,7 +946,7 @@ static inline void wilc_wfi_cfg_parse_ch_attr(u8 *buf, =
u8 ch_list_attr_idx,
 		for (i =3D ch_list_attr_idx + 3; i < limit; i++) {
 			if (buf[i] =3D=3D 0x51) {
 				for (j =3D i + 2; j < ((i + 2) + buf[i + 1]); j++)
-					buf[j] =3D wlan_channel;
+					buf[j] =3D sta_ch;
 				break;
 			}
 		}
@@ -955,11 +954,11 @@ static inline void wilc_wfi_cfg_parse_ch_attr(u8 *buf=
, u8 ch_list_attr_idx,
=20
 	if (op_ch_attr_idx) {
 		buf[op_ch_attr_idx + 6] =3D 0x51;
-		buf[op_ch_attr_idx + 7] =3D wlan_channel;
+		buf[op_ch_attr_idx + 7] =3D sta_ch;
 	}
 }
=20
-static void wilc_wfi_cfg_parse_rx_action(u8 *buf, u32 len)
+static void wilc_wfi_cfg_parse_rx_action(u8 *buf, u32 len, u8 sta_ch)
 {
 	u32 index =3D 0;
 	u8 op_channel_attr_index =3D 0;
@@ -975,13 +974,13 @@ static void wilc_wfi_cfg_parse_rx_action(u8 *buf, u32=
 len)
 			op_channel_attr_index =3D index;
 		index +=3D buf[index + 1] + 3;
 	}
-	if (wlan_channel !=3D INVALID_CHANNEL)
+	if (sta_ch !=3D INVALID_CHANNEL)
 		wilc_wfi_cfg_parse_ch_attr(buf, channel_list_attr_index,
-					   op_channel_attr_index);
+					   op_channel_attr_index, sta_ch);
 }
=20
 static void wilc_wfi_cfg_parse_tx_action(u8 *buf, u32 len, bool oper_ch,
-					 u8 iftype)
+					 u8 iftype, u8 sta_ch)
 {
 	u32 index =3D 0;
 	u8 op_channel_attr_index =3D 0;
@@ -1000,9 +999,9 @@ static void wilc_wfi_cfg_parse_tx_action(u8 *buf, u32 =
len, bool oper_ch,
 			op_channel_attr_index =3D index;
 		index +=3D buf[index + 1] + 3;
 	}
-	if (wlan_channel !=3D INVALID_CHANNEL && oper_ch)
+	if (sta_ch !=3D INVALID_CHANNEL && oper_ch)
 		wilc_wfi_cfg_parse_ch_attr(buf, channel_list_attr_index,
-					   op_channel_attr_index);
+					   op_channel_attr_index, sta_ch);
 }
=20
 static void wilc_wfi_cfg_parse_rx_vendor_spec(struct wilc_priv *priv, u8 *=
buff,
@@ -1037,7 +1036,8 @@ static void wilc_wfi_cfg_parse_rx_vendor_spec(struct =
wilc_priv *priv, u8 *buff,
 			if (buff[i] =3D=3D P2PELEM_ATTR_ID &&
 			    !(memcmp(p2p_oui, &buff[i + 2], 4))) {
 				wilc_wfi_cfg_parse_rx_action(&buff[i + 6],
-							     size - (i + 6));
+							     size - (i + 6),
+							     vif->wilc->sta_ch);
 				break;
 			}
 		}
@@ -1195,6 +1195,7 @@ static void wilc_wfi_cfg_tx_vendor_spec(struct wilc_p=
riv *priv,
 	size_t len =3D params->len;
 	u32 i;
 	u8 subtype =3D buf[P2P_PUB_ACTION_SUBTYPE];
+	struct wilc_vif *vif =3D netdev_priv(priv->dev);
=20
 	if (subtype =3D=3D GO_NEG_REQ || subtype =3D=3D GO_NEG_RSP) {
 		if (priv->p2p.local_random =3D=3D 1 &&
@@ -1219,7 +1220,8 @@ static void wilc_wfi_cfg_tx_vendor_spec(struct wilc_p=
riv *priv,
 				oper_ch =3D true;
=20
 			wilc_wfi_cfg_parse_tx_action(tx_buff, len - (i + 6),
-						     oper_ch, iftype);
+						     oper_ch, iftype,
+						     vif->wilc->sta_ch);
=20
 			break;
 		}
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/stagin=
g/wilc1000/wilc_wfi_netdevice.h
index 3a78ffd..29f220d 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -273,6 +273,7 @@ struct wilc {
 	struct net_device *monitor_dev;
 	/* deinit lock */
 	struct mutex deinit_lock;
+	u8 sta_ch;
 };
=20
 struct wilc_wfi_mon_priv {
--=20
2.7.4

