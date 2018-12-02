Return-Path: <SRS0=9n1M=OL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14E1FC64EB4
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:03:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6AFC2080A
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:03:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="UBzK6zjv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C6AFC2080A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725849AbeLBSDm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 2 Dec 2018 13:03:42 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:39822 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbeLBSDl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Dec 2018 13:03:41 -0500
X-IronPort-AV: E=Sophos;i="5.56,307,1539673200"; 
   d="scan'208";a="24755030"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES128-SHA; 02 Dec 2018 11:03:38 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.37) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sun, 2 Dec 2018 11:03:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ngiOMfuul7QGjUMjNM91IFBzHzeGFHMvwsDDt7TGl1w=;
 b=UBzK6zjvUpdQ+2E4dPXjUGj0/zXOIyGJ2wpLlTlCJ4WQntjZNfsXVnc2hgIH2NoMJhLjtgoIYgvUMOjbL9lr5LLze75xuvtl/AccNsWdbnFHVhUzCSPAH11+Fl2FiWHAuPhkeZwSgRcKO8GDdv4jf2AMEn1yZpODTVHHGLhRIGo=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2806.namprd11.prod.outlook.com (52.135.228.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1382.18; Sun, 2 Dec 2018 18:03:31 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f%4]) with mapi id 15.20.1382.020; Sun, 2 Dec 2018
 18:03:31 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 27/29] staging: wilc1000: handle connect ops callback from
 cfg80211 context
Thread-Topic: [PATCH 27/29] staging: wilc1000: handle connect ops callback
 from cfg80211 context
Thread-Index: AQHUimlVLL2WWmlQ3Ee+hX+9QxyJpg==
Date:   Sun, 2 Dec 2018 18:03:31 +0000
Message-ID: <1543773663-20561-28-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2806;6:v8XSjfwFwBXirxrYOdegqMOgOUgrQWU6OqfWq5x9uMFGE6bzSIyHfiu+Fh1v+Il2aFeY9aR370u5EFNTWv0I5JSSSvWOHjrIBFql++PphvRS+kIAKrTSejLKSBj9iQiKgan5Le2sOURfJFkHDHIqUesbxt+lrajy13PeKRilRborIUWu2j00iICqSnjGvGW2V0okMAigDvErNDQnesQlNj7NeUfQZgSmCdpSwmSdl6QlZBYqseaKtdiWfuKlehbbvWUQqBN85IAXr2r+Jul/cR7bFP8jOANq1vpAqtNeeIXC6TZD6RFd5P88r0VIMnKoCTZeLemziY2icwc4N/tu2yZN5tF1uNXlZ16Emce2krrDtBF6IeJpshqP3rZdTfpAa7zOUi+dM8N3tpmB0s+a7cf/kemk7novhjrF3oJr15GJ5NcC+ZyZej0K8uyGaXFaF7vk/aUaEdEAwPXN8jpLzA==;5:Z/AbQ0G1BuqNBLMMgMci0gqzak6iD5HnjOu3jY5rsgyN30Yefi7zexG6FFOCNon9rlTzNkOoAUoX2XZ9WPkUeqUVMftv5xk+9jtogPkXKaQ8TTRK9EsZf+bL4p9Kw1M9xj7tIuawmxcVubEtmuLVSdh9qiw7pwgF+wX0JSHLhpM=;7:b8u7ketKP/xLE1SOejflqKbGnUj1WajcZOhlNWkcsIGJClMhgpNS8i0aNMt4moMgtxxfYTmbPS9oRV/77CuGq0+P0JrW77wI9aknDpsYzrHOIIazj5C5PhreDAiZktdarwZU3RssB5btaRsHO9uqrg==
x-ms-office365-filtering-correlation-id: 00d76234-5ad6-4c45-9947-08d6588077f1
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2806;
x-ms-traffictypediagnostic: BYAPR11MB2806:
x-microsoft-antispam-prvs: <BYAPR11MB2806370DCBD97FA65DACAD57E3AD0@BYAPR11MB2806.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3002001)(10201501046)(3231455)(999002)(944501491)(52105112)(148016)(149066)(150057)(6041310)(20161123562045)(20161123558120)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB2806;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB2806;
x-forefront-prvs: 087474FBFA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(376002)(346002)(366004)(39850400004)(396003)(136003)(199004)(189003)(186003)(4326008)(7736002)(26005)(14454004)(2906002)(107886003)(305945005)(386003)(53936002)(6506007)(36756003)(76176011)(6512007)(71190400001)(52116002)(71200400001)(5640700003)(14444005)(256004)(3846002)(6116002)(99286004)(5660300001)(78486014)(6486002)(446003)(11346002)(486006)(86362001)(105586002)(8676002)(97736004)(68736007)(316002)(2616005)(6436002)(476003)(54906003)(66066001)(25786009)(102836004)(81156014)(81166006)(8936002)(72206003)(2351001)(2501003)(478600001)(6916009)(106356001)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2806;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: dYbaDdFzWB04sugwnq9r9EgVemMe1VwB873gPbOrFa+VDY/6HRAUTVH/Ih4tCcu6k4DQIhKfbH+qnSqp/SRmzLYStxQLFszGYj0boymBqsqL6HrgXCriJNWwVkDEuUNKidmCzfnUKl56FFkNoxfie/TA7YjFcVPm79oNcqclQbHWTc1/QPKO+rGpY2HfMIBpJFLyXwWwCYpbnzJkFIGZtTETsUW1FVtVdxQ7pKQLryp7jGMttL3fZbzgPxBo1r/NTcw9DI8WQYqVBU/eFIlIGFTgf6EPwwfm3EBtggwzDluwjxWLBvrhqiz59LvYblMeRLoRVw028XVT9m6CAKdaBzI+O+bea++KkLcStjfvyIM=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 00d76234-5ad6-4c45-9947-08d6588077f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2018 18:03:31.5327
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

Refactor the connect related cfg callback to be called from cfg80211
context. No need to post connect command internally in case scan is in
progress instead simply return the error status in connect ops callback.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 104 +++++++++++++-------------=
----
 1 file changed, 44 insertions(+), 60 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index 6a908ea..783c99b 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -362,34 +362,16 @@ static void handle_scan(struct work_struct *work)
 	kfree(msg);
 }
=20
-static void handle_connect(struct work_struct *work)
+static int wilc_send_connect_wid(struct wilc_vif *vif,
+				 struct connect_attr *conn_attr)
 {
-	struct host_if_msg *msg =3D container_of(work, struct host_if_msg, work);
-	struct wilc_vif *vif =3D msg->vif;
-	struct connect_attr *conn_attr =3D &msg->body.con_info;
 	int result =3D 0;
 	struct wid wid_list[8];
 	u32 wid_cnt =3D 0, dummyval =3D 0;
 	u8 *cur_byte =3D NULL;
-	struct join_bss_param *bss_param;
+	struct join_bss_param *bss_param =3D conn_attr->params;
 	struct host_if_drv *hif_drv =3D vif->hif_drv;
=20
-	if (msg->vif->hif_drv->usr_scan_req.scan_result) {
-		result =3D wilc_enqueue_work(msg);
-		if (result)
-			goto error;
-
-		usleep_range(2 * 1000, 2 * 1000);
-		return;
-	}
-
-	bss_param =3D conn_attr->params;
-	if (!bss_param) {
-		netdev_err(vif->ndev, "Required BSSID not found\n");
-		result =3D -ENOENT;
-		goto error;
-	}
-
 	if (conn_attr->bssid) {
 		hif_drv->usr_conn_req.bssid =3D kmemdup(conn_attr->bssid, 6,
 						      GFP_KERNEL);
@@ -490,8 +472,8 @@ static void handle_connect(struct work_struct *work)
 		netdev_err(vif->ndev, "Channel out of range\n");
 		*(cur_byte++) =3D 0xFF;
 	}
-	*(cur_byte++)  =3D (bss_param->cap_info) & 0xFF;
-	*(cur_byte++)  =3D ((bss_param->cap_info) >> 8) & 0xFF;
+	put_unaligned_le16(bss_param->cap_info, cur_byte);
+	cur_byte +=3D 2;
=20
 	if (conn_attr->bssid)
 		memcpy(cur_byte, conn_attr->bssid, 6);
@@ -501,8 +483,8 @@ static void handle_connect(struct work_struct *work)
 		memcpy(cur_byte, conn_attr->bssid, 6);
 	cur_byte +=3D 6;
=20
-	*(cur_byte++)  =3D (bss_param->beacon_period) & 0xFF;
-	*(cur_byte++)  =3D ((bss_param->beacon_period) >> 8) & 0xFF;
+	put_unaligned_le16(bss_param->beacon_period, cur_byte);
+	cur_byte +=3D 2;
 	*(cur_byte++)  =3D  bss_param->dtim_period;
=20
 	memcpy(cur_byte, bss_param->supp_rates, MAX_RATES_SUPPORTED + 1);
@@ -533,10 +515,8 @@ static void handle_connect(struct work_struct *work)
 	*(cur_byte++) =3D bss_param->noa_enabled;
=20
 	if (bss_param->noa_enabled) {
-		*(cur_byte++) =3D (bss_param->tsf) & 0xFF;
-		*(cur_byte++) =3D ((bss_param->tsf) >> 8) & 0xFF;
-		*(cur_byte++) =3D ((bss_param->tsf) >> 16) & 0xFF;
-		*(cur_byte++) =3D ((bss_param->tsf) >> 24) & 0xFF;
+		put_unaligned_le32(bss_param->tsf, cur_byte);
+		cur_byte +=3D 4;
=20
 		*(cur_byte++) =3D bss_param->opp_enabled;
 		*(cur_byte++) =3D bss_param->idx;
@@ -616,8 +596,10 @@ static void handle_connect(struct work_struct *work)
 	kfree(conn_attr->ies);
 	conn_attr->ies =3D NULL;
=20
+	kfree(conn_attr);
 	kfree(cur_byte);
-	kfree(msg);
+
+	return result;
 }
=20
 static void handle_connect_timeout(struct work_struct *work)
@@ -1926,8 +1908,8 @@ int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid=
, const u8 *ssid,
 		      u8 channel, void *join_params)
 {
 	int result;
-	struct host_if_msg *msg;
 	struct host_if_drv *hif_drv =3D vif->hif_drv;
+	struct connect_attr *con_info;
=20
 	if (!hif_drv || !connect_result) {
 		netdev_err(vif->ndev,
@@ -1941,50 +1923,51 @@ int wilc_set_join_req(struct wilc_vif *vif, u8 *bss=
id, const u8 *ssid,
 		return -EFAULT;
 	}
=20
-	msg =3D wilc_alloc_work(vif, handle_connect, false);
-	if (IS_ERR(msg))
-		return PTR_ERR(msg);
+	if (hif_drv->usr_scan_req.scan_result) {
+		netdev_err(vif->ndev, "%s: Scan in progress\n", __func__);
+		return -EBUSY;
+	}
+
+	con_info =3D kzalloc(sizeof(*con_info), GFP_KERNEL);
+	if (!con_info)
+		return -ENOMEM;
=20
-	msg->body.con_info.security =3D security;
-	msg->body.con_info.auth_type =3D auth_type;
-	msg->body.con_info.ch =3D channel;
-	msg->body.con_info.result =3D connect_result;
-	msg->body.con_info.arg =3D user_arg;
-	msg->body.con_info.params =3D join_params;
+	con_info->security =3D security;
+	con_info->auth_type =3D auth_type;
+	con_info->ch =3D channel;
+	con_info->result =3D connect_result;
+	con_info->arg =3D user_arg;
+	con_info->params =3D join_params;
=20
 	if (bssid) {
-		msg->body.con_info.bssid =3D kmemdup(bssid, 6, GFP_KERNEL);
-		if (!msg->body.con_info.bssid) {
+		con_info->bssid =3D kmemdup(bssid, 6, GFP_KERNEL);
+		if (!con_info->bssid) {
 			result =3D -ENOMEM;
-			goto free_msg;
+			goto free_con_info;
 		}
 	}
=20
 	if (ssid) {
-		msg->body.con_info.ssid_len =3D ssid_len;
-		msg->body.con_info.ssid =3D kmemdup(ssid, ssid_len, GFP_KERNEL);
-		if (!msg->body.con_info.ssid) {
+		con_info->ssid_len =3D ssid_len;
+		con_info->ssid =3D kmemdup(ssid, ssid_len, GFP_KERNEL);
+		if (!con_info->ssid) {
 			result =3D -ENOMEM;
 			goto free_bssid;
 		}
 	}
=20
 	if (ies) {
-		msg->body.con_info.ies_len =3D ies_len;
-		msg->body.con_info.ies =3D kmemdup(ies, ies_len, GFP_KERNEL);
-		if (!msg->body.con_info.ies) {
+		con_info->ies_len =3D ies_len;
+		con_info->ies =3D kmemdup(ies, ies_len, GFP_KERNEL);
+		if (!con_info->ies) {
 			result =3D -ENOMEM;
 			goto free_ssid;
 		}
 	}
-	if (hif_drv->hif_state < HOST_IF_CONNECTING)
-		hif_drv->hif_state =3D HOST_IF_CONNECTING;
=20
-	result =3D wilc_enqueue_work(msg);
-	if (result) {
-		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
+	result =3D wilc_send_connect_wid(vif);
+	if (result)
 		goto free_ies;
-	}
=20
 	hif_drv->connect_timer_vif =3D vif;
 	mod_timer(&hif_drv->connect_timer,
@@ -1993,16 +1976,17 @@ int wilc_set_join_req(struct wilc_vif *vif, u8 *bss=
id, const u8 *ssid,
 	return 0;
=20
 free_ies:
-	kfree(msg->body.con_info.ies);
+	kfree(con_info->ies);
=20
 free_ssid:
-	kfree(msg->body.con_info.ssid);
+	kfree(con_info->ssid);
=20
 free_bssid:
-	kfree(msg->body.con_info.bssid);
+	kfree(con_info->bssid);
+
+free_con_info:
+	kfree(con_info);
=20
-free_msg:
-	kfree(msg);
 	return result;
 }
=20
--=20
2.7.4

