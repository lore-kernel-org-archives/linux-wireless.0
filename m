Return-Path: <SRS0=9n1M=OL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D622EC64EB4
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:03:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5ABB62080A
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:03:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="ElEMwvYN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5ABB62080A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725826AbeLBSDR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 2 Dec 2018 13:03:17 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:40381 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbeLBSDQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Dec 2018 13:03:16 -0500
X-IronPort-AV: E=Sophos;i="5.56,307,1539673200"; 
   d="scan'208";a="21024676"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 02 Dec 2018 11:03:14 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.107) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sun, 2 Dec 2018 11:03:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UoXt3BRimfdOpoh0CNxpwtetEwX20T3pvydZpw5/au8=;
 b=ElEMwvYNMbos3DHTyltyRPflTWFtnFt71nN3t0m1ffw4oxhhcuYVcKREPOCoH9NSDPOWtZTQ6VxP1XCV7/pWogjwJOLHFl7bnFQJEWQei+/JF0Ls1zgwrK0BL5veGikXfOZRqANIHmX0HriIjP79+TY0gRt8U9VQEIXEzPH3wNI=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2806.namprd11.prod.outlook.com (52.135.228.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1382.18; Sun, 2 Dec 2018 18:03:11 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f%4]) with mapi id 15.20.1382.020; Sun, 2 Dec 2018
 18:03:11 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 20/29] staging: wilc1000: handle key related cfg operation
 from cfg80211 context
Thread-Topic: [PATCH 20/29] staging: wilc1000: handle key related cfg
 operation from cfg80211 context
Thread-Index: AQHUimlJPUERpJZfEEK33tNY0thdbQ==
Date:   Sun, 2 Dec 2018 18:03:11 +0000
Message-ID: <1543773663-20561-21-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2806;6:0ec1SLFgVN4DOB1FJLAowUzzcMYv+aRlNcEv3Xz6GH4ATXldYFZ9tslpXK2PunfeuMCDoFdcpKIm8PnxxfyBwC+5PP3uQooN0OKO+p8wIAmtVZirZ6S9qYQsfOoNc6yNif5k21y27E0H32VZ925gXQQBIyWwWw+ozojSOU59pscjy/m5yX2LlPzRFoBhH2afM0pBbDqL4YzNIXZpNH+axKiyE0I1PHLw5MtIZcVPpz70OnbWc9cO7IcN3JrkJS1lZAFRKcastMxyiH0Bgw/uzlJ3RPS+rctZtvOfvyEuNIEOTxPDMGVnIpxRnjb+K6Pvckr4Jd4erxsmuvQVFrzergpaZ/ALAxlcSABC0eLR5V9mDMfB3/Sn+/lEelL0xLIQu3SZSnGcQlJXcXZi5sGh5nOV2JOArmJJpei3DbIH9l8cpB+rmw/GKaJLVkPPhsQ96P0GiI09jQoEWYtKAlb9xA==;5:DD16+tKVl1uimYCiDevwVvg8uRClPKKz5rrpstVtRfP1JJHIVeLOMota2CSY1FYm52Tyo0Q0EV71B2seROrxzqSPne87nJObNTxOlbA0kX0R6+gHcTct4F0QgekDYHLbt96ogMu2pn3anQk1u569OR63Z/CFl3z1DIGppTiEWbc=;7:V32N7XSgQ3IGH+tPq4w/0GW2IdTwiaDqpd20LBny54cH2kgLxSFkaus8aaJv/Uq3t91S5qhuChQr7p4ZY3dsLy/4Dg+4E4W1jxFWqwHQy7RK0hcv9G7utHWo++m/3HTk0v0tbYQc61+8cRwufzKKJw==
x-ms-office365-filtering-correlation-id: 91d2f2e0-376d-4b64-ca77-08d658806c19
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2806;
x-ms-traffictypediagnostic: BYAPR11MB2806:
x-microsoft-antispam-prvs: <BYAPR11MB28061370ABB767E7BC04DD00E3AD0@BYAPR11MB2806.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3002001)(10201501046)(3231455)(999002)(944501491)(52105112)(148016)(149066)(150057)(6041310)(20161123562045)(20161123558120)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB2806;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB2806;
x-forefront-prvs: 087474FBFA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(366004)(39850400004)(396003)(136003)(199004)(189003)(186003)(4326008)(7736002)(26005)(14454004)(2906002)(107886003)(305945005)(386003)(53936002)(6506007)(36756003)(53946003)(76176011)(6512007)(71190400001)(52116002)(71200400001)(5640700003)(14444005)(256004)(3846002)(6116002)(99286004)(5660300001)(78486014)(6486002)(446003)(11346002)(486006)(86362001)(105586002)(8676002)(97736004)(68736007)(316002)(2616005)(6436002)(476003)(54906003)(4744004)(66066001)(25786009)(102836004)(81156014)(81166006)(8936002)(72206003)(2351001)(2501003)(478600001)(6916009)(106356001)(579004)(559001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2806;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: idlQTHEZJwihkx8Ws3skqkxgPq9FLgKkzoA0nAsmVyo2G9ls17xFLrx9/B2fMqwffl2LItHFozA64zn8BHirJRE9Qgk+HaUqvI2iO1SswDcez0hwMR2r59UtWJwGS+AUJGzxgaTAYEeB7LyhdORfM4eaXWLe6jJYPHADDRlSe/Tl9FBbeJGNVyQtdzbzKzOkW/ZVFDzuKAXwUOT4NgNVfD55vUe3kOFQdICL7TtF09fLQtvk6wTXrqtPeYdQodjqeOH4dSoZdeF9p+YXt9+quygb3UrZGP65xzNSpHvgdX1wIfFzg5tVQ3X7MBEmIFAV8hdNhK0l1S7RqeHgflvjqXa20UrhjpFY4FYTbgN8E4E=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 91d2f2e0-376d-4b64-ca77-08d658806c19
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2018 18:03:11.6164
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2806
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Refactor add/delete key operation to handle directly from cfg80211
context. Also, avoid an extra copy of the information in hif layer and
directly fill the buffer in firmware format.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c         | 691 ++++++------------=
----
 drivers/staging/wilc1000/host_interface.h         |  13 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |   4 +-
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |   2 +-
 4 files changed, 204 insertions(+), 506 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index e3dc9b6..596a321 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -37,12 +37,6 @@ union host_if_key_attr {
 	struct host_if_pmkid_attr pmkid;
 };
=20
-struct key_attr {
-	enum KEY_TYPE type;
-	u8 action;
-	union host_if_key_attr attr;
-};
-
 struct scan_attr {
 	u8 src;
 	u8 type;
@@ -100,6 +94,33 @@ struct wilc_drv_handler {
 	u8 mode;
 } __packed;
=20
+struct wilc_wep_key {
+	u8 index;
+	u8 key_len;
+	u8 key[0];
+} __packed;
+
+struct wilc_sta_wpa_ptk {
+	u8 mac_addr[ETH_ALEN];
+	u8 key_len;
+	u8 key[0];
+} __packed;
+
+struct wilc_ap_wpa_ptk {
+	u8 mac_addr[ETH_ALEN];
+	u8 index;
+	u8 key_len;
+	u8 key[0];
+} __packed;
+
+struct wilc_gtk_key {
+	u8 mac_addr[ETH_ALEN];
+	u8 rsc[8];
+	u8 index;
+	u8 key_len;
+	u8 key[0];
+} __packed;
+
 struct set_ip_addr {
 	u8 *ip_addr;
 	u8 idx;
@@ -110,7 +131,6 @@ union message_body {
 	struct connect_attr con_info;
 	struct rcvd_net_info net_info;
 	struct rcvd_async_info async_info;
-	struct key_attr key_info;
 	struct set_ip_addr ip_info;
 	struct set_multicast multicast_info;
 	struct get_mac_addr get_mac_info;
@@ -1275,264 +1295,6 @@ static void handle_rcvd_gnrl_async_info(struct work=
_struct *work)
 	kfree(msg);
 }
=20
-static int wilc_pmksa_key_copy(struct wilc_vif *vif, struct key_attr *hif_=
key)
-{
-	int i;
-	int ret;
-	struct wid wid;
-	u8 *key_buf;
-
-	key_buf =3D kmalloc((hif_key->attr.pmkid.numpmkid * PMKSA_KEY_LEN) + 1,
-			  GFP_KERNEL);
-	if (!key_buf)
-		return -ENOMEM;
-
-	key_buf[0] =3D hif_key->attr.pmkid.numpmkid;
-
-	for (i =3D 0; i < hif_key->attr.pmkid.numpmkid; i++) {
-		memcpy(key_buf + ((PMKSA_KEY_LEN * i) + 1),
-		       hif_key->attr.pmkid.pmkidlist[i].bssid, ETH_ALEN);
-		memcpy(key_buf + ((PMKSA_KEY_LEN * i) + ETH_ALEN + 1),
-		       hif_key->attr.pmkid.pmkidlist[i].pmkid, WLAN_PMKID_LEN);
-	}
-
-	wid.id =3D WID_PMKID_INFO;
-	wid.type =3D WID_STR;
-	wid.val =3D (s8 *)key_buf;
-	wid.size =3D (hif_key->attr.pmkid.numpmkid * PMKSA_KEY_LEN) + 1;
-
-	ret =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
-				   wilc_get_vif_idx(vif));
-
-	kfree(key_buf);
-
-	return ret;
-}
-
-static void handle_key(struct work_struct *work)
-{
-	struct host_if_msg *msg =3D container_of(work, struct host_if_msg, work);
-	struct wilc_vif *vif =3D msg->vif;
-	struct key_attr *hif_key =3D &msg->body.key_info;
-	int result =3D 0;
-	struct wid wid;
-	struct wid wid_list[5];
-	u8 *key_buf;
-	struct host_if_drv *hif_drv =3D vif->hif_drv;
-
-	switch (hif_key->type) {
-	case WILC_KEY_TYPE_WEP:
-
-		if (hif_key->action & WILC_ADD_KEY_AP) {
-			wid_list[0].id =3D WID_11I_MODE;
-			wid_list[0].type =3D WID_CHAR;
-			wid_list[0].size =3D sizeof(char);
-			wid_list[0].val =3D (s8 *)&hif_key->attr.wep.mode;
-
-			wid_list[1].id =3D WID_AUTH_TYPE;
-			wid_list[1].type =3D WID_CHAR;
-			wid_list[1].size =3D sizeof(char);
-			wid_list[1].val =3D (s8 *)&hif_key->attr.wep.auth_type;
-
-			key_buf =3D kmalloc(hif_key->attr.wep.key_len + 2,
-					  GFP_KERNEL);
-			if (!key_buf) {
-				result =3D -ENOMEM;
-				goto out_wep;
-			}
-
-			key_buf[0] =3D hif_key->attr.wep.index;
-			key_buf[1] =3D hif_key->attr.wep.key_len;
-
-			memcpy(&key_buf[2], hif_key->attr.wep.key,
-			       hif_key->attr.wep.key_len);
-
-			wid_list[2].id =3D WID_WEP_KEY_VALUE;
-			wid_list[2].type =3D WID_STR;
-			wid_list[2].size =3D hif_key->attr.wep.key_len + 2;
-			wid_list[2].val =3D (s8 *)key_buf;
-
-			result =3D wilc_send_config_pkt(vif, WILC_SET_CFG,
-						      wid_list, 3,
-						      wilc_get_vif_idx(vif));
-			kfree(key_buf);
-		} else if (hif_key->action & WILC_ADD_KEY) {
-			key_buf =3D kmalloc(hif_key->attr.wep.key_len + 2,
-					  GFP_KERNEL);
-			if (!key_buf) {
-				result =3D -ENOMEM;
-				goto out_wep;
-			}
-			key_buf[0] =3D hif_key->attr.wep.index;
-			memcpy(key_buf + 1, &hif_key->attr.wep.key_len, 1);
-			memcpy(key_buf + 2, hif_key->attr.wep.key,
-			       hif_key->attr.wep.key_len);
-
-			wid.id =3D WID_ADD_WEP_KEY;
-			wid.type =3D WID_STR;
-			wid.val =3D (s8 *)key_buf;
-			wid.size =3D hif_key->attr.wep.key_len + 2;
-
-			result =3D wilc_send_config_pkt(vif, WILC_SET_CFG,
-						      &wid, 1,
-						      wilc_get_vif_idx(vif));
-			kfree(key_buf);
-		} else if (hif_key->action & WILC_REMOVE_KEY) {
-			wid.id =3D WID_REMOVE_WEP_KEY;
-			wid.type =3D WID_STR;
-
-			wid.val =3D (s8 *)&hif_key->attr.wep.index;
-			wid.size =3D 1;
-
-			result =3D wilc_send_config_pkt(vif, WILC_SET_CFG,
-						      &wid, 1,
-						      wilc_get_vif_idx(vif));
-		} else if (hif_key->action & WILC_DEFAULT_KEY) {
-			wid.id =3D WID_KEY_ID;
-			wid.type =3D WID_CHAR;
-			wid.val =3D (s8 *)&hif_key->attr.wep.index;
-			wid.size =3D sizeof(char);
-
-			result =3D wilc_send_config_pkt(vif, WILC_SET_CFG,
-						      &wid, 1,
-						      wilc_get_vif_idx(vif));
-		}
-out_wep:
-		complete(&msg->work_comp);
-		break;
-
-	case WILC_KEY_TYPE_WPA_RX_GTK:
-		if (hif_key->action & WILC_ADD_KEY_AP) {
-			key_buf =3D kzalloc(RX_MIC_KEY_MSG_LEN, GFP_KERNEL);
-			if (!key_buf) {
-				result =3D -ENOMEM;
-				goto out_wpa_rx_gtk;
-			}
-
-			if (hif_key->attr.wpa.seq)
-				memcpy(key_buf + 6, hif_key->attr.wpa.seq, 8);
-
-			memcpy(key_buf + 14, &hif_key->attr.wpa.index, 1);
-			memcpy(key_buf + 15, &hif_key->attr.wpa.key_len, 1);
-			memcpy(key_buf + 16, hif_key->attr.wpa.key,
-			       hif_key->attr.wpa.key_len);
-
-			wid_list[0].id =3D WID_11I_MODE;
-			wid_list[0].type =3D WID_CHAR;
-			wid_list[0].size =3D sizeof(char);
-			wid_list[0].val =3D (s8 *)&hif_key->attr.wpa.mode;
-
-			wid_list[1].id =3D WID_ADD_RX_GTK;
-			wid_list[1].type =3D WID_STR;
-			wid_list[1].val =3D (s8 *)key_buf;
-			wid_list[1].size =3D RX_MIC_KEY_MSG_LEN;
-
-			result =3D wilc_send_config_pkt(vif, WILC_SET_CFG,
-						      wid_list, 2,
-						      wilc_get_vif_idx(vif));
-
-			kfree(key_buf);
-		} else if (hif_key->action & WILC_ADD_KEY) {
-			key_buf =3D kzalloc(RX_MIC_KEY_MSG_LEN, GFP_KERNEL);
-			if (!key_buf) {
-				result =3D -ENOMEM;
-				goto out_wpa_rx_gtk;
-			}
-
-			if (hif_drv->hif_state =3D=3D HOST_IF_CONNECTED)
-				memcpy(key_buf, hif_drv->assoc_bssid, ETH_ALEN);
-			else
-				netdev_err(vif->ndev, "Couldn't handle\n");
-
-			memcpy(key_buf + 6, hif_key->attr.wpa.seq, 8);
-			memcpy(key_buf + 14, &hif_key->attr.wpa.index, 1);
-			memcpy(key_buf + 15, &hif_key->attr.wpa.key_len, 1);
-			memcpy(key_buf + 16, hif_key->attr.wpa.key,
-			       hif_key->attr.wpa.key_len);
-
-			wid.id =3D WID_ADD_RX_GTK;
-			wid.type =3D WID_STR;
-			wid.val =3D (s8 *)key_buf;
-			wid.size =3D RX_MIC_KEY_MSG_LEN;
-
-			result =3D wilc_send_config_pkt(vif, WILC_SET_CFG,
-						      &wid, 1,
-						      wilc_get_vif_idx(vif));
-
-			kfree(key_buf);
-		}
-out_wpa_rx_gtk:
-		complete(&msg->work_comp);
-		break;
-
-	case WILC_KEY_TYPE_WPA_PTK:
-		if (hif_key->action & WILC_ADD_KEY_AP) {
-			key_buf =3D kmalloc(PTK_KEY_MSG_LEN + 1, GFP_KERNEL);
-			if (!key_buf) {
-				result =3D -ENOMEM;
-				goto out_wpa_ptk;
-			}
-
-			memcpy(key_buf, hif_key->attr.wpa.mac_addr, 6);
-			memcpy(key_buf + 6, &hif_key->attr.wpa.index, 1);
-			memcpy(key_buf + 7, &hif_key->attr.wpa.key_len, 1);
-			memcpy(key_buf + 8, hif_key->attr.wpa.key,
-			       hif_key->attr.wpa.key_len);
-
-			wid_list[0].id =3D WID_11I_MODE;
-			wid_list[0].type =3D WID_CHAR;
-			wid_list[0].size =3D sizeof(char);
-			wid_list[0].val =3D (s8 *)&hif_key->attr.wpa.mode;
-
-			wid_list[1].id =3D WID_ADD_PTK;
-			wid_list[1].type =3D WID_STR;
-			wid_list[1].val =3D (s8 *)key_buf;
-			wid_list[1].size =3D PTK_KEY_MSG_LEN + 1;
-
-			result =3D wilc_send_config_pkt(vif, WILC_SET_CFG,
-						      wid_list, 2,
-						      wilc_get_vif_idx(vif));
-			kfree(key_buf);
-		} else if (hif_key->action & WILC_ADD_KEY) {
-			key_buf =3D kmalloc(PTK_KEY_MSG_LEN, GFP_KERNEL);
-			if (!key_buf) {
-				result =3D -ENOMEM;
-				goto out_wpa_ptk;
-			}
-
-			memcpy(key_buf, hif_key->attr.wpa.mac_addr, 6);
-			memcpy(key_buf + 6, &hif_key->attr.wpa.key_len, 1);
-			memcpy(key_buf + 7, hif_key->attr.wpa.key,
-			       hif_key->attr.wpa.key_len);
-
-			wid.id =3D WID_ADD_PTK;
-			wid.type =3D WID_STR;
-			wid.val =3D (s8 *)key_buf;
-			wid.size =3D PTK_KEY_MSG_LEN;
-
-			result =3D wilc_send_config_pkt(vif, WILC_SET_CFG,
-						      &wid, 1,
-						      wilc_get_vif_idx(vif));
-			kfree(key_buf);
-		}
-
-out_wpa_ptk:
-		complete(&msg->work_comp);
-		break;
-
-	case WILC_KEY_TYPE_PMKSA:
-		result =3D wilc_pmksa_key_copy(vif, hif_key);
-		/*free 'msg', this case it not a sync call*/
-		kfree(msg);
-		break;
-	}
-
-	if (result)
-		netdev_err(vif->ndev, "Failed to send key config packet\n");
-
-	/* free 'msg' data in caller sync call */
-}
-
 static void handle_disconnect(struct work_struct *work)
 {
 	struct host_if_msg *msg =3D container_of(work, struct host_if_msg, work);
@@ -1944,145 +1706,107 @@ static void timer_connect_cb(struct timer_list *t=
)
=20
 int wilc_remove_wep_key(struct wilc_vif *vif, u8 index)
 {
+	struct wid wid;
 	int result;
-	struct host_if_msg *msg;
-	struct host_if_drv *hif_drv =3D vif->hif_drv;
=20
-	if (!hif_drv) {
-		result =3D -EFAULT;
-		netdev_err(vif->ndev, "%s: hif driver is NULL", __func__);
-		return result;
-	}
-
-	msg =3D wilc_alloc_work(vif, handle_key, true);
-	if (IS_ERR(msg))
-		return PTR_ERR(msg);
-
-	msg->body.key_info.type =3D WILC_KEY_TYPE_WEP;
-	msg->body.key_info.action =3D WILC_REMOVE_KEY;
-	msg->body.key_info.attr.wep.index =3D index;
+	wid.id =3D WID_REMOVE_WEP_KEY;
+	wid.type =3D WID_STR;
+	wid.size =3D sizeof(char);
+	wid.val =3D &index;
=20
-	result =3D wilc_enqueue_work(msg);
+	result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
+				      wilc_get_vif_idx(vif));
 	if (result)
-		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
-	else
-		wait_for_completion(&msg->work_comp);
-
-	kfree(msg);
+		netdev_err(vif->ndev,
+			   "Failed to send remove wep key config packet\n");
 	return result;
 }
=20
 int wilc_set_wep_default_keyid(struct wilc_vif *vif, u8 index)
 {
+	struct wid wid;
 	int result;
-	struct host_if_msg *msg;
-	struct host_if_drv *hif_drv =3D vif->hif_drv;
=20
-	if (!hif_drv) {
-		result =3D -EFAULT;
-		netdev_err(vif->ndev, "%s: hif driver is NULL\n", __func__);
-		return result;
-	}
-
-	msg =3D wilc_alloc_work(vif, handle_key, true);
-	if (IS_ERR(msg))
-		return PTR_ERR(msg);
-
-	msg->body.key_info.type =3D WILC_KEY_TYPE_WEP;
-	msg->body.key_info.action =3D WILC_DEFAULT_KEY;
-	msg->body.key_info.attr.wep.index =3D index;
-
-	result =3D wilc_enqueue_work(msg);
+	wid.id =3D WID_KEY_ID;
+	wid.type =3D WID_CHAR;
+	wid.size =3D sizeof(char);
+	wid.val =3D &index;
+	result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
+				      wilc_get_vif_idx(vif));
 	if (result)
-		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
-	else
-		wait_for_completion(&msg->work_comp);
+		netdev_err(vif->ndev,
+			   "Failed to send wep default key config packet\n");
=20
-	kfree(msg);
 	return result;
 }
=20
 int wilc_add_wep_key_bss_sta(struct wilc_vif *vif, const u8 *key, u8 len,
 			     u8 index)
 {
+	struct wid wid;
 	int result;
-	struct host_if_msg *msg;
-	struct host_if_drv *hif_drv =3D vif->hif_drv;
+	struct wilc_wep_key *wep_key;
=20
-	if (!hif_drv) {
-		netdev_err(vif->ndev, "%s: hif driver is NULL", __func__);
-		return -EFAULT;
-	}
-
-	msg =3D wilc_alloc_work(vif, handle_key, true);
-	if (IS_ERR(msg))
-		return PTR_ERR(msg);
+	wid.id =3D WID_ADD_WEP_KEY;
+	wid.type =3D WID_STR;
+	wid.size =3D sizeof(*wep_key) + len;
+	wep_key =3D kzalloc(wid.size, GFP_KERNEL);
+	if (!wep_key)
+		return -ENOMEM;
=20
-	msg->body.key_info.type =3D WILC_KEY_TYPE_WEP;
-	msg->body.key_info.action =3D WILC_ADD_KEY;
-	msg->body.key_info.attr.wep.key =3D kmemdup(key, len, GFP_KERNEL);
-	if (!msg->body.key_info.attr.wep.key) {
-		result =3D -ENOMEM;
-		goto free_msg;
-	}
+	wid.val =3D (u8 *)wep_key;
=20
-	msg->body.key_info.attr.wep.key_len =3D len;
-	msg->body.key_info.attr.wep.index =3D index;
+	wep_key->index =3D index;
+	wep_key->key_len =3D len;
+	memcpy(wep_key->key, key, len);
=20
-	result =3D wilc_enqueue_work(msg);
+	result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
+				      wilc_get_vif_idx(vif));
 	if (result)
-		goto free_key;
-
-	wait_for_completion(&msg->work_comp);
-
-free_key:
-	kfree(msg->body.key_info.attr.wep.key);
+		netdev_err(vif->ndev,
+			   "Failed to add wep key config packet\n");
=20
-free_msg:
-	kfree(msg);
+	kfree(wep_key);
 	return result;
 }
=20
 int wilc_add_wep_key_bss_ap(struct wilc_vif *vif, const u8 *key, u8 len,
 			    u8 index, u8 mode, enum authtype auth_type)
 {
+	struct wid wid_list[3];
 	int result;
-	struct host_if_msg *msg;
-	struct host_if_drv *hif_drv =3D vif->hif_drv;
-
-	if (!hif_drv) {
-		netdev_err(vif->ndev, "%s: hif driver is NULL\n", __func__);
-		return -EFAULT;
-	}
-
-	msg =3D wilc_alloc_work(vif, handle_key, true);
-	if (IS_ERR(msg))
-		return PTR_ERR(msg);
-
-	msg->body.key_info.type =3D WILC_KEY_TYPE_WEP;
-	msg->body.key_info.action =3D WILC_ADD_KEY_AP;
-	msg->body.key_info.attr.wep.key =3D kmemdup(key, len, GFP_KERNEL);
-	if (!msg->body.key_info.attr.wep.key) {
-		result =3D -ENOMEM;
-		goto free_msg;
-	}
+	struct wilc_wep_key *wep_key;
+
+	wid_list[0].id =3D WID_11I_MODE;
+	wid_list[0].type =3D WID_CHAR;
+	wid_list[0].size =3D sizeof(char);
+	wid_list[0].val =3D &mode;
+
+	wid_list[1].id =3D WID_AUTH_TYPE;
+	wid_list[1].type =3D WID_CHAR;
+	wid_list[1].size =3D sizeof(char);
+	wid_list[1].val =3D (s8 *)&auth_type;
+
+	wid_list[2].id =3D WID_WEP_KEY_VALUE;
+	wid_list[2].type =3D WID_STR;
+	wid_list[2].size =3D sizeof(*wep_key) + len;
+	wep_key =3D kzalloc(wid_list[2].size, GFP_KERNEL);
+	if (!wep_key)
+		return -ENOMEM;
=20
-	msg->body.key_info.attr.wep.key_len =3D len;
-	msg->body.key_info.attr.wep.index =3D index;
-	msg->body.key_info.attr.wep.mode =3D mode;
-	msg->body.key_info.attr.wep.auth_type =3D auth_type;
+	wid_list[2].val =3D (u8 *)wep_key;
=20
-	result =3D wilc_enqueue_work(msg);
+	wep_key->index =3D index;
+	wep_key->key_len =3D len;
+	memcpy(wep_key->key, key, len);
+	result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, wid_list,
+				      ARRAY_SIZE(wid_list),
+				      wilc_get_vif_idx(vif));
 	if (result)
-		goto free_key;
-
-	wait_for_completion(&msg->work_comp);
-
-free_key:
-	kfree(msg->body.key_info.attr.wep.key);
+		netdev_err(vif->ndev,
+			   "Failed to add wep ap key config packet\n");
=20
-free_msg:
-	kfree(msg);
+	kfree(wep_key);
 	return result;
 }
=20
@@ -2090,65 +1814,72 @@ int wilc_add_ptk(struct wilc_vif *vif, const u8 *pt=
k, u8 ptk_key_len,
 		 const u8 *mac_addr, const u8 *rx_mic, const u8 *tx_mic,
 		 u8 mode, u8 cipher_mode, u8 index)
 {
-	int result;
-	struct host_if_msg *msg;
-	struct host_if_drv *hif_drv =3D vif->hif_drv;
-	u8 key_len =3D ptk_key_len;
-
-	if (!hif_drv) {
-		netdev_err(vif->ndev, "%s: hif driver is NULL", __func__);
-		return -EFAULT;
-	}
+	int result =3D 0;
+	u8 t_key_len  =3D ptk_key_len + RX_MIC_KEY_LEN + TX_MIC_KEY_LEN;
=20
-	if (rx_mic)
-		key_len +=3D RX_MIC_KEY_LEN;
+	if (mode =3D=3D WILC_AP_MODE) {
+		struct wid wid_list[2];
+		struct wilc_ap_wpa_ptk *key_buf;
=20
-	if (tx_mic)
-		key_len +=3D TX_MIC_KEY_LEN;
+		wid_list[0].id =3D WID_11I_MODE;
+		wid_list[0].type =3D WID_CHAR;
+		wid_list[0].size =3D sizeof(char);
+		wid_list[0].val =3D (s8 *)&cipher_mode;
=20
-	msg =3D wilc_alloc_work(vif, handle_key, true);
-	if (IS_ERR(msg))
-		return PTR_ERR(msg);
+		key_buf =3D kzalloc(sizeof(*key_buf) + t_key_len, GFP_KERNEL);
+		if (!key_buf)
+			return -ENOMEM;
=20
-	msg->body.key_info.type =3D WILC_KEY_TYPE_WPA_PTK;
-	if (mode =3D=3D WILC_AP_MODE) {
-		msg->body.key_info.action =3D WILC_ADD_KEY_AP;
-		msg->body.key_info.attr.wpa.index =3D index;
-	}
-	if (mode =3D=3D WILC_STATION_MODE)
-		msg->body.key_info.action =3D WILC_ADD_KEY;
+		ether_addr_copy(key_buf->mac_addr, mac_addr);
+		key_buf->index =3D index;
+		key_buf->key_len =3D t_key_len;
+		memcpy(&key_buf->key[0], ptk, ptk_key_len);
+
+		if (rx_mic)
+			memcpy(&key_buf->key[ptk_key_len], rx_mic,
+			       RX_MIC_KEY_LEN);
+
+		if (tx_mic)
+			memcpy(&key_buf->key[ptk_key_len + RX_MIC_KEY_LEN],
+			       tx_mic, TX_MIC_KEY_LEN);
+
+		wid_list[1].id =3D WID_ADD_PTK;
+		wid_list[1].type =3D WID_STR;
+		wid_list[1].size =3D sizeof(*key_buf) + t_key_len;
+		wid_list[1].val =3D (u8 *)key_buf;
+		result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, wid_list,
+					      ARRAY_SIZE(wid_list),
+					      wilc_get_vif_idx(vif));
+		kfree(key_buf);
+	} else if (mode =3D=3D WILC_STATION_MODE) {
+		struct wid wid;
+		struct wilc_sta_wpa_ptk *key_buf;
=20
-	msg->body.key_info.attr.wpa.key =3D kmemdup(ptk, ptk_key_len, GFP_KERNEL)=
;
-	if (!msg->body.key_info.attr.wpa.key) {
-		result =3D -ENOMEM;
-		goto free_msg;
-	}
+		key_buf =3D kzalloc(sizeof(*key_buf) + t_key_len, GFP_KERNEL);
+		if (!key_buf)
+			return -ENOMEM;
=20
-	if (rx_mic)
-		memcpy(msg->body.key_info.attr.wpa.key + 16, rx_mic,
-		       RX_MIC_KEY_LEN);
+		ether_addr_copy(key_buf->mac_addr, mac_addr);
+		key_buf->key_len =3D t_key_len;
+		memcpy(&key_buf->key[0], ptk, ptk_key_len);
=20
-	if (tx_mic)
-		memcpy(msg->body.key_info.attr.wpa.key + 24, tx_mic,
-		       TX_MIC_KEY_LEN);
+		if (rx_mic)
+			memcpy(&key_buf->key[ptk_key_len], rx_mic,
+			       RX_MIC_KEY_LEN);
=20
-	msg->body.key_info.attr.wpa.key_len =3D key_len;
-	msg->body.key_info.attr.wpa.mac_addr =3D mac_addr;
-	msg->body.key_info.attr.wpa.mode =3D cipher_mode;
+		if (tx_mic)
+			memcpy(&key_buf->key[ptk_key_len + RX_MIC_KEY_LEN],
+			       tx_mic, TX_MIC_KEY_LEN);
=20
-	result =3D wilc_enqueue_work(msg);
-	if (result) {
-		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
-		goto free_key;
+		wid.id =3D WID_ADD_PTK;
+		wid.type =3D WID_STR;
+		wid.size =3D sizeof(*key_buf) + t_key_len;
+		wid.val =3D (s8 *)key_buf;
+		result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
+					      wilc_get_vif_idx(vif));
+		kfree(key_buf);
 	}
=20
-	wait_for_completion(&msg->work_comp);
-
-free_key:
-	kfree(msg->body.key_info.attr.wpa.key);
-
-free_msg:
-	kfree(msg);
 	return result;
 }
=20
@@ -2157,108 +1888,76 @@ int wilc_add_rx_gtk(struct wilc_vif *vif, const u8=
 *rx_gtk, u8 gtk_key_len,
 		    const u8 *rx_mic, const u8 *tx_mic, u8 mode,
 		    u8 cipher_mode)
 {
-	int result;
-	struct host_if_msg *msg;
-	struct host_if_drv *hif_drv =3D vif->hif_drv;
-	u8 key_len =3D gtk_key_len;
+	int result =3D 0;
+	struct wilc_gtk_key *gtk_key;
+	int t_key_len =3D gtk_key_len + RX_MIC_KEY_LEN + TX_MIC_KEY_LEN;
=20
-	if (!hif_drv) {
-		netdev_err(vif->ndev, "%s: hif driver is NULL", __func__);
-		return -EFAULT;
-	}
+	gtk_key =3D kzalloc(sizeof(*gtk_key) + t_key_len, GFP_KERNEL);
+	if (!gtk_key)
+		return -ENOMEM;
=20
-	msg =3D wilc_alloc_work(vif, handle_key, true);
-	if (IS_ERR(msg))
-		return PTR_ERR(msg);
+	/* fill bssid value only in station mode */
+	if (mode =3D=3D WILC_STATION_MODE &&
+	    vif->hif_drv->hif_state =3D=3D HOST_IF_CONNECTED)
+		memcpy(gtk_key->mac_addr, vif->hif_drv->assoc_bssid, ETH_ALEN);
+
+	if (key_rsc)
+		memcpy(gtk_key->rsc, key_rsc, 8);
+	gtk_key->index =3D index;
+	gtk_key->key_len =3D t_key_len;
+	memcpy(&gtk_key->key[0], rx_gtk, gtk_key_len);
=20
 	if (rx_mic)
-		key_len +=3D RX_MIC_KEY_LEN;
+		memcpy(&gtk_key->key[gtk_key_len], rx_mic, RX_MIC_KEY_LEN);
=20
 	if (tx_mic)
-		key_len +=3D TX_MIC_KEY_LEN;
-
-	if (key_rsc) {
-		msg->body.key_info.attr.wpa.seq =3D kmemdup(key_rsc,
-							  key_rsc_len,
-							  GFP_KERNEL);
-		if (!msg->body.key_info.attr.wpa.seq) {
-			result =3D -ENOMEM;
-			goto free_msg;
-		}
-	}
-
-	msg->body.key_info.type =3D WILC_KEY_TYPE_WPA_RX_GTK;
+		memcpy(&gtk_key->key[gtk_key_len + RX_MIC_KEY_LEN],
+		       tx_mic, TX_MIC_KEY_LEN);
=20
 	if (mode =3D=3D WILC_AP_MODE) {
-		msg->body.key_info.action =3D WILC_ADD_KEY_AP;
-		msg->body.key_info.attr.wpa.mode =3D cipher_mode;
-	}
-	if (mode =3D=3D WILC_STATION_MODE)
-		msg->body.key_info.action =3D WILC_ADD_KEY;
+		struct wid wid_list[2];
=20
-	msg->body.key_info.attr.wpa.key =3D kmemdup(rx_gtk, key_len, GFP_KERNEL);
-	if (!msg->body.key_info.attr.wpa.key) {
-		result =3D -ENOMEM;
-		goto free_seq;
-	}
+		wid_list[0].id =3D WID_11I_MODE;
+		wid_list[0].type =3D WID_CHAR;
+		wid_list[0].size =3D sizeof(char);
+		wid_list[0].val =3D (s8 *)&cipher_mode;
=20
-	if (rx_mic)
-		memcpy(msg->body.key_info.attr.wpa.key + 16, rx_mic,
-		       RX_MIC_KEY_LEN);
+		wid_list[1].id =3D WID_ADD_RX_GTK;
+		wid_list[1].type =3D WID_STR;
+		wid_list[1].size =3D sizeof(*gtk_key) + t_key_len;
+		wid_list[1].val =3D (u8 *)gtk_key;
=20
-	if (tx_mic)
-		memcpy(msg->body.key_info.attr.wpa.key + 24, tx_mic,
-		       TX_MIC_KEY_LEN);
-
-	msg->body.key_info.attr.wpa.index =3D index;
-	msg->body.key_info.attr.wpa.key_len =3D key_len;
-	msg->body.key_info.attr.wpa.seq_len =3D key_rsc_len;
+		result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, wid_list,
+					      ARRAY_SIZE(wid_list),
+					      wilc_get_vif_idx(vif));
+		kfree(gtk_key);
+	} else if (mode =3D=3D WILC_STATION_MODE) {
+		struct wid wid;
=20
-	result =3D wilc_enqueue_work(msg);
-	if (result) {
-		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
-		goto free_key;
+		wid.id =3D WID_ADD_RX_GTK;
+		wid.type =3D WID_STR;
+		wid.size =3D sizeof(*gtk_key) + t_key_len;
+		wid.val =3D (u8 *)gtk_key;
+		result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
+					      wilc_get_vif_idx(vif));
+		kfree(gtk_key);
 	}
=20
-	wait_for_completion(&msg->work_comp);
-
-free_key:
-	kfree(msg->body.key_info.attr.wpa.key);
-
-free_seq:
-	kfree(msg->body.key_info.attr.wpa.seq);
-
-free_msg:
-	kfree(msg);
 	return result;
 }
=20
-int wilc_set_pmkid_info(struct wilc_vif *vif,
-			struct host_if_pmkid_attr *pmkid)
+int wilc_set_pmkid_info(struct wilc_vif *vif, struct wilc_pmkid_attr *pmki=
d)
 {
+	struct wid wid;
 	int result;
-	struct host_if_msg *msg;
-	int i;
-
-	msg =3D wilc_alloc_work(vif, handle_key, false);
-	if (IS_ERR(msg))
-		return PTR_ERR(msg);
-
-	msg->body.key_info.type =3D WILC_KEY_TYPE_PMKSA;
-	msg->body.key_info.action =3D WILC_ADD_KEY;
=20
-	for (i =3D 0; i < pmkid->numpmkid; i++) {
-		memcpy(msg->body.key_info.attr.pmkid.pmkidlist[i].bssid,
-		       &pmkid->pmkidlist[i].bssid, ETH_ALEN);
-		memcpy(msg->body.key_info.attr.pmkid.pmkidlist[i].pmkid,
-		       &pmkid->pmkidlist[i].pmkid, WLAN_PMKID_LEN);
-	}
+	wid.id =3D WID_PMKID_INFO;
+	wid.type =3D WID_STR;
+	wid.size =3D (pmkid->numpmkid * sizeof(struct wilc_pmkid)) + 1;
+	wid.val =3D (u8 *)pmkid;
=20
-	result =3D wilc_enqueue_work(msg);
-	if (result) {
-		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
-		kfree(msg);
-	}
+	result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
+				      wilc_get_vif_idx(vif));
=20
 	return result;
 }
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wi=
lc1000/host_interface.h
index 7748f65..477372b 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -117,15 +117,15 @@ enum host_if_state {
 	HOST_IF_FORCE_32BIT		=3D 0xFFFFFFFF
 };
=20
-struct host_if_pmkid {
+struct wilc_pmkid {
 	u8 bssid[ETH_ALEN];
 	u8 pmkid[WLAN_PMKID_LEN];
-};
+} __packed;
=20
-struct host_if_pmkid_attr {
+struct wilc_pmkid_attr {
 	u8 numpmkid;
-	struct host_if_pmkid pmkidlist[WILC_MAX_NUM_PMKIDS];
-};
+	struct wilc_pmkid pmkidlist[WILC_MAX_NUM_PMKIDS];
+} __packed;
=20
 struct cfg_param_attr {
 	u32 flag;
@@ -288,8 +288,7 @@ int wilc_add_rx_gtk(struct wilc_vif *vif, const u8 *rx_=
gtk, u8 gtk_key_len,
 		    u8 index, u32 key_rsc_len, const u8 *key_rsc,
 		    const u8 *rx_mic, const u8 *tx_mic, u8 mode,
 		    u8 cipher_mode);
-int wilc_set_pmkid_info(struct wilc_vif *vif,
-			struct host_if_pmkid_attr *pmkid);
+int wilc_set_pmkid_info(struct wilc_vif *vif, struct wilc_pmkid_attr *pmki=
d);
 int wilc_get_mac_address(struct wilc_vif *vif, u8 *mac_addr);
 int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
 		      size_t ssid_len, const u8 *ies, size_t ies_len,
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/st=
aging/wilc1000/wilc_wfi_cfgoperations.c
index 3ed8ca9..4c9444e 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1171,7 +1171,7 @@ static int del_pmksa(struct wiphy *wiphy, struct net_=
device *netdev,
 		if (!memcmp(pmksa->bssid, priv->pmkid_list.pmkidlist[i].bssid,
 			    ETH_ALEN)) {
 			memset(&priv->pmkid_list.pmkidlist[i], 0,
-			       sizeof(struct host_if_pmkid));
+			       sizeof(struct wilc_pmkid));
 			break;
 		}
 	}
@@ -1197,7 +1197,7 @@ static int flush_pmksa(struct wiphy *wiphy, struct ne=
t_device *netdev)
 {
 	struct wilc_priv *priv =3D wiphy_priv(wiphy);
=20
-	memset(&priv->pmkid_list, 0, sizeof(struct host_if_pmkid_attr));
+	memset(&priv->pmkid_list, 0, sizeof(struct wilc_pmkid_attr));
=20
 	return 0;
 }
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/stagin=
g/wilc1000/wilc_wfi_netdevice.h
index 02970c3..c6685c0 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -144,7 +144,7 @@ struct wilc_priv {
 	struct sk_buff *skb;
 	struct net_device *dev;
 	struct host_if_drv *hif_drv;
-	struct host_if_pmkid_attr pmkid_list;
+	struct wilc_pmkid_attr pmkid_list;
 	u8 wep_key[4][WLAN_KEY_LEN_WEP104];
 	u8 wep_key_len[4];
 	/* The real interface that the monitor is on */
--=20
2.7.4

