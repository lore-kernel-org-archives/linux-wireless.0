Return-Path: <SRS0=9n1M=OL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC978C64EB4
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:03:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 995C92080A
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:03:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="M2mSSu5I"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 995C92080A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725850AbeLBSDm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 2 Dec 2018 13:03:42 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:39814 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbeLBSDl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Dec 2018 13:03:41 -0500
X-IronPort-AV: E=Sophos;i="5.56,307,1539673200"; 
   d="scan'208";a="24755029"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES128-SHA; 02 Dec 2018 11:03:38 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.37) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sun, 2 Dec 2018 11:03:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n6fVIMwFcE6trYcn6TTc8Ak2w7/d48d63/inIQdJLF4=;
 b=M2mSSu5IGMqfFRqRQ4tzjrh7gM8Ea/SG2XeHgF2C5apElxMUw47YM+9+bFVXIXfhYhsnUNlHPSWJr8PV4BCIkZLs+gP0wVtqJgUIP0kOMWUrD4/VkF+Mk/dutvuZqVc9Ttmhy3D3OlCahq3ZkY/PfX08A65U7Nzk8WB5/nPmz58=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3096.namprd11.prod.outlook.com (20.177.227.78) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1382.21; Sun, 2 Dec 2018 18:03:35 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f%4]) with mapi id 15.20.1382.020; Sun, 2 Dec 2018
 18:03:35 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 28/29] staging: wilc1000: avoid extra buffer copy while
 connect cfg ops
Thread-Topic: [PATCH 28/29] staging: wilc1000: avoid extra buffer copy while
 connect cfg ops
Thread-Index: AQHUimlXlIKZOsDzm0qlFqEiavv2VA==
Date:   Sun, 2 Dec 2018 18:03:34 +0000
Message-ID: <1543773663-20561-29-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3096;6:PWAyai2mpkhF0abmTAxyC3PD1cRg6svnQCRlomGZAQNoytvup+oSxasB0vO1a1nJYO9l/SuhygZfvvd/KIii8/dcOpX4+tnyhWaOEM2CAUADoKu81uOIC9vqFNn6ANDNSh+SnkJswAtjWWayN+1k+Nnb3AMzxAJiMmOBBxjpeUsmxak6GK8jC+gXd03GQNeeybIi20oCOoxIiXc/VnCytJmwxRh8/rcWVz1X1z0gTEIxAK3N8GDNNY/0ZjG35d5R2Xk1tVAS6FpmHrM/dNPp4gzJd+h0xmV3jmB0/Ddha/UrE57Tqzp+q2Dng6h+/xHjLMqxLBwNCZXDmp80w0fumjunqiDstIUy6oMUDWxgVIn0VT2fvOB/nJk7QvWcgRphMT6+clfuIfUiy0nZaGfMr68pmRIrsiEUTCt7LOu2lw3j/Q1iaUtv4wZNDt/xc3kdU2hv3Dnord2CNGVs7Kf+1Q==;5:kp/9VGddXyzsNtTsUCuSKKNTGAPNpG6PBa/Wd8O8DUhglFmEPebH5J5f+bruKbseww2LDphYNsxnNlHst1+GiGDeZkBl6LxWSxX9KJ9nXCtbMrtPd6NZqSb033cKFxDa/YGxFsvylNypskC6Hq9IWkn4c50hxcWwp6e7L9tLQps=;7:4drCQJA61+RyUVO6W9buzX/sIIRGc12n4zQXQGyBjaYXkbL957WwNHaCugPA4I64g9eFl05Ys1kUJztIeRiF9iAeqmdCsvSKgoCUlVrK7N1o0KeqbX8EK50+22QiVPB6uX6KlI66trYIQSUDoJ7nAw==
x-ms-office365-filtering-correlation-id: cec368d1-f615-4a06-92f7-08d6588079ac
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3096;
x-ms-traffictypediagnostic: BYAPR11MB3096:
x-microsoft-antispam-prvs: <BYAPR11MB30963B6A134FC2EB6391D8DCE3AD0@BYAPR11MB3096.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(10201501046)(3002001)(3231455)(999002)(944501491)(52105112)(93006095)(93001095)(148016)(149066)(150057)(6041310)(20161123558120)(20161123560045)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB3096;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB3096;
x-forefront-prvs: 087474FBFA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39840400004)(366004)(396003)(136003)(376002)(346002)(189003)(199004)(6512007)(8936002)(107886003)(81156014)(53936002)(6916009)(81166006)(105586002)(8676002)(106356001)(68736007)(6436002)(6486002)(5660300001)(86362001)(2351001)(2906002)(5640700003)(72206003)(7736002)(478600001)(305945005)(14444005)(256004)(97736004)(14454004)(486006)(186003)(26005)(66066001)(476003)(2616005)(11346002)(446003)(4326008)(36756003)(78486014)(54906003)(2501003)(316002)(25786009)(3846002)(6116002)(76176011)(99286004)(386003)(6506007)(102836004)(71200400001)(52116002)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3096;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: rq4663rqJ97Gu6qGQlyjAb02P8OOIgIZtHcRi8XCP7zCWN66ZfRGXBCQZ3DwaowZzwl8A3+abYmiFikTHF1UFnIsex4MxSp/0z1guAMBhzkc4LQBhJpVB+lSD5yJWKsuA1vY/yWMl1BUeZS3yCNqGp3Z5HIPZbBdHKJpfkhfCUHY+K2MCjg99kx6HiJ6HnczWKxWw9iI38YtvajUrlLeNMkdfGpLyTcbEi4T5iBRgp8UYiVn1DYmXNZhH0KMsakWa1jEU1wBFeTGR/HPvamxWuR6eSywI7oWrXdg+BO3PqfEPOHBYsxMtb+/5a3EwBEspljajNufgOWlAxpgI1zRi3nWB6xJMR8rlx/+qb1v5js=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: cec368d1-f615-4a06-92f7-08d6588079ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2018 18:03:35.2083
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3096
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Refactor the code to avoid the use of an extra buffer to store the
connection related parameter. No need to call cfg80211_disconnected in
case of failure to send the wid command to firmware, an error status is
directly returned in cfg80211 connect callback.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c         | 129 +++---------------=
----
 drivers/staging/wilc1000/host_interface.h         |   2 +
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |   2 +
 3 files changed, 21 insertions(+), 112 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index 783c99b..f50728c 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -25,20 +25,6 @@ struct scan_attr {
 	struct hidden_network hidden_network;
 };
=20
-struct connect_attr {
-	u8 *bssid;
-	u8 *ssid;
-	size_t ssid_len;
-	u8 *ies;
-	size_t ies_len;
-	u8 security;
-	wilc_connect_result result;
-	void *arg;
-	enum authtype auth_type;
-	u8 ch;
-	void *params;
-};
-
 struct rcvd_async_info {
 	u8 *buffer;
 	u32 len;
@@ -99,7 +85,6 @@ struct wilc_gtk_key {
=20
 union message_body {
 	struct scan_attr scan_info;
-	struct connect_attr con_info;
 	struct rcvd_net_info net_info;
 	struct rcvd_async_info async_info;
 	struct set_multicast multicast_info;
@@ -362,54 +347,15 @@ static void handle_scan(struct work_struct *work)
 	kfree(msg);
 }
=20
-static int wilc_send_connect_wid(struct wilc_vif *vif,
-				 struct connect_attr *conn_attr)
+static int wilc_send_connect_wid(struct wilc_vif *vif)
 {
 	int result =3D 0;
 	struct wid wid_list[8];
 	u32 wid_cnt =3D 0, dummyval =3D 0;
 	u8 *cur_byte =3D NULL;
-	struct join_bss_param *bss_param =3D conn_attr->params;
 	struct host_if_drv *hif_drv =3D vif->hif_drv;
-
-	if (conn_attr->bssid) {
-		hif_drv->usr_conn_req.bssid =3D kmemdup(conn_attr->bssid, 6,
-						      GFP_KERNEL);
-		if (!hif_drv->usr_conn_req.bssid) {
-			result =3D -ENOMEM;
-			goto error;
-		}
-	}
-
-	hif_drv->usr_conn_req.ssid_len =3D conn_attr->ssid_len;
-	if (conn_attr->ssid) {
-		hif_drv->usr_conn_req.ssid =3D kmalloc(conn_attr->ssid_len + 1,
-						     GFP_KERNEL);
-		if (!hif_drv->usr_conn_req.ssid) {
-			result =3D -ENOMEM;
-			goto error;
-		}
-		memcpy(hif_drv->usr_conn_req.ssid,
-		       conn_attr->ssid,
-		       conn_attr->ssid_len);
-		hif_drv->usr_conn_req.ssid[conn_attr->ssid_len] =3D '\0';
-	}
-
-	hif_drv->usr_conn_req.ies_len =3D conn_attr->ies_len;
-	if (conn_attr->ies) {
-		hif_drv->usr_conn_req.ies =3D kmemdup(conn_attr->ies,
-						    conn_attr->ies_len,
-						    GFP_KERNEL);
-		if (!hif_drv->usr_conn_req.ies) {
-			result =3D -ENOMEM;
-			goto error;
-		}
-	}
-
-	hif_drv->usr_conn_req.security =3D conn_attr->security;
-	hif_drv->usr_conn_req.auth_type =3D conn_attr->auth_type;
-	hif_drv->usr_conn_req.conn_result =3D conn_attr->result;
-	hif_drv->usr_conn_req.arg =3D conn_attr->arg;
+	struct user_conn_req *conn_attr =3D &hif_drv->usr_conn_req;
+	struct join_bss_param *bss_param =3D hif_drv->usr_conn_req.param;
=20
 	wid_list[wid_cnt].id =3D WID_SUCCESS_FRAME_COUNT;
 	wid_list[wid_cnt].type =3D WID_INT;
@@ -431,20 +377,20 @@ static int wilc_send_connect_wid(struct wilc_vif *vif=
,
=20
 	wid_list[wid_cnt].id =3D WID_INFO_ELEMENT_ASSOCIATE;
 	wid_list[wid_cnt].type =3D WID_BIN_DATA;
-	wid_list[wid_cnt].val =3D hif_drv->usr_conn_req.ies;
-	wid_list[wid_cnt].size =3D hif_drv->usr_conn_req.ies_len;
+	wid_list[wid_cnt].val =3D conn_attr->ies;
+	wid_list[wid_cnt].size =3D conn_attr->ies_len;
 	wid_cnt++;
=20
 	wid_list[wid_cnt].id =3D WID_11I_MODE;
 	wid_list[wid_cnt].type =3D WID_CHAR;
 	wid_list[wid_cnt].size =3D sizeof(char);
-	wid_list[wid_cnt].val =3D (s8 *)&hif_drv->usr_conn_req.security;
+	wid_list[wid_cnt].val =3D (s8 *)&conn_attr->security;
 	wid_cnt++;
=20
 	wid_list[wid_cnt].id =3D WID_AUTH_TYPE;
 	wid_list[wid_cnt].type =3D WID_CHAR;
 	wid_list[wid_cnt].size =3D sizeof(char);
-	wid_list[wid_cnt].val =3D (s8 *)&hif_drv->usr_conn_req.auth_type;
+	wid_list[wid_cnt].val =3D (s8 *)&conn_attr->auth_type;
 	wid_cnt++;
=20
 	wid_list[wid_cnt].id =3D WID_JOIN_REQ_EXTENDED;
@@ -494,7 +440,7 @@ static int wilc_send_connect_wid(struct wilc_vif *vif,
 	*(cur_byte++)  =3D bss_param->uapsd_cap;
=20
 	*(cur_byte++)  =3D bss_param->ht_capable;
-	hif_drv->usr_conn_req.ht_capable =3D bss_param->ht_capable;
+	conn_attr->ht_capable =3D bss_param->ht_capable;
=20
 	*(cur_byte++)  =3D  bss_param->rsn_found;
 	*(cur_byte++)  =3D  bss_param->rsn_grp_policy;
@@ -547,45 +493,16 @@ static int wilc_send_connect_wid(struct wilc_vif *vif=
,
 				      wilc_get_vif_idx(vif));
 	if (result) {
 		netdev_err(vif->ndev, "failed to send config packet\n");
-		result =3D -EFAULT;
+		kfree(cur_byte);
 		goto error;
 	} else {
 		hif_drv->hif_state =3D HOST_IF_WAITING_CONN_RESP;
 	}
=20
-error:
-	if (result) {
-		struct connect_info conn_info;
-
-		del_timer(&hif_drv->connect_timer);
-
-		memset(&conn_info, 0, sizeof(struct connect_info));
-
-		if (conn_attr->result) {
-			if (conn_attr->bssid)
-				memcpy(conn_info.bssid, conn_attr->bssid, 6);
-
-			if (conn_attr->ies) {
-				conn_info.req_ies_len =3D conn_attr->ies_len;
-				conn_info.req_ies =3D kmalloc(conn_attr->ies_len,
-							    GFP_KERNEL);
-				memcpy(conn_info.req_ies,
-				       conn_attr->ies,
-				       conn_attr->ies_len);
-			}
-
-			conn_attr->result(CONN_DISCONN_EVENT_CONN_RESP,
-					  &conn_info,
-					  WILC_MAC_STATUS_DISCONNECTED,
-					  NULL, conn_attr->arg);
-			hif_drv->hif_state =3D HOST_IF_IDLE;
-			kfree(conn_info.req_ies);
-			conn_info.req_ies =3D NULL;
+	kfree(cur_byte);
+	return 0;
=20
-		} else {
-			netdev_err(vif->ndev, "Connect callback is NULL\n");
-		}
-	}
+error:
=20
 	kfree(conn_attr->bssid);
 	conn_attr->bssid =3D NULL;
@@ -596,9 +513,6 @@ static int wilc_send_connect_wid(struct wilc_vif *vif,
 	kfree(conn_attr->ies);
 	conn_attr->ies =3D NULL;
=20
-	kfree(conn_attr);
-	kfree(cur_byte);
-
 	return result;
 }
=20
@@ -1909,7 +1823,7 @@ int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid=
, const u8 *ssid,
 {
 	int result;
 	struct host_if_drv *hif_drv =3D vif->hif_drv;
-	struct connect_attr *con_info;
+	struct user_conn_req *con_info =3D &hif_drv->usr_conn_req;
=20
 	if (!hif_drv || !connect_result) {
 		netdev_err(vif->ndev,
@@ -1928,23 +1842,17 @@ int wilc_set_join_req(struct wilc_vif *vif, u8 *bss=
id, const u8 *ssid,
 		return -EBUSY;
 	}
=20
-	con_info =3D kzalloc(sizeof(*con_info), GFP_KERNEL);
-	if (!con_info)
-		return -ENOMEM;
-
 	con_info->security =3D security;
 	con_info->auth_type =3D auth_type;
 	con_info->ch =3D channel;
-	con_info->result =3D connect_result;
+	con_info->conn_result =3D connect_result;
 	con_info->arg =3D user_arg;
-	con_info->params =3D join_params;
+	con_info->param =3D join_params;
=20
 	if (bssid) {
 		con_info->bssid =3D kmemdup(bssid, 6, GFP_KERNEL);
-		if (!con_info->bssid) {
-			result =3D -ENOMEM;
-			goto free_con_info;
-		}
+		if (!con_info->bssid)
+			return -ENOMEM;
 	}
=20
 	if (ssid) {
@@ -1984,9 +1892,6 @@ int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid=
, const u8 *ssid,
 free_bssid:
 	kfree(con_info->bssid);
=20
-free_con_info:
-	kfree(con_info);
-
 	return result;
 }
=20
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wi=
lc1000/host_interface.h
index ac4bdfe..9b396a79 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -191,7 +191,9 @@ struct user_conn_req {
 	size_t ies_len;
 	wilc_connect_result conn_result;
 	bool ht_capable;
+	u8 ch;
 	void *arg;
+	void *param;
 };
=20
 struct remain_ch {
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/st=
aging/wilc1000/wilc_wfi_cfgoperations.c
index 7cc985e..08d4461 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -719,6 +719,8 @@ static int connect(struct wiphy *wiphy, struct net_devi=
ce *dev,
=20
 		netdev_err(dev, "wilc_set_join_req(): Error\n");
 		ret =3D -ENOENT;
+		if (!wfi_drv->p2p_connect)
+			wlan_channel =3D INVALID_CHANNEL;
 		wilc_wlan_set_bssid(dev, null_bssid, WILC_STATION_MODE);
 		goto out_error;
 	}
--=20
2.7.4

