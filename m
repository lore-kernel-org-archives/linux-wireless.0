Return-Path: <SRS0=9n1M=OL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6552C04EB8
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:03:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A47972080A
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:03:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="NcZ19Q5r"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A47972080A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725840AbeLBSDj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 2 Dec 2018 13:03:39 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:39814 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbeLBSDj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Dec 2018 13:03:39 -0500
X-IronPort-AV: E=Sophos;i="5.56,307,1539673200"; 
   d="scan'208";a="24755028"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES128-SHA; 02 Dec 2018 11:03:36 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.37) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sun, 2 Dec 2018 11:03:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PwaBd8+KtmpJSubPFMD7QKkdhLURYOWvykl/mkNivSA=;
 b=NcZ19Q5rkrTUwgUo0Py6eRHtwvwuEx5GyhbqsvUJZ/3BkW1w9qb8vOEbeGJc253CFZQraxAj1TnCBtFYb4p7iGiCon4qkQ7k2AbleTnm6PlJsKPmEKqqTZinYUzP5i9PREPHj4rlI82fPxmjN49RmmiaBFwJGho1ppAerLKnJS8=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2806.namprd11.prod.outlook.com (52.135.228.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1382.18; Sun, 2 Dec 2018 18:03:25 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f%4]) with mapi id 15.20.1382.020; Sun, 2 Dec 2018
 18:03:25 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 25/29] staging: wilc1000: handle get_station() ops callback in
 cfg80211 context
Thread-Topic: [PATCH 25/29] staging: wilc1000: handle get_station() ops
 callback in cfg80211 context
Thread-Index: AQHUimlS42/BdOhgUkGzrwNGJ2i80A==
Date:   Sun, 2 Dec 2018 18:03:25 +0000
Message-ID: <1543773663-20561-26-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2806;6:ePyQSA4YUSxr8XwGeWQSt3KTu9jiwwUUDnl/6MdwcmEHpAycCGOvci12BToJ730R0wwhDS825p5Jg88uC3RdSGo4KWbVnBB+nbxI8mrb4kkJLa+YI4HH8g0+DlCRO7ITf8GyNACGZD+jzNO8+sf+IA9fVUeb0qKGrnIIeYt33KXlP363CGaqohh6SAi8+G+R+Jrxlxj0rcGAlDl0fF39X+UgtwP1WKbi4T43Ers5CXc0M7PiqeR0Gpb/ladbtVZcb4daE+rGfZ2cacgJa4JNjjiMHM6L/1ySz2nMg8FO19qDgY6ZfixDxEaajWL/+RkjWeHx+CFj5Z+IJzj8yL375F0WKDDu8CO6wEAIzTL+1svT+PtPIGmKwxIHSJfBYrmGWKdHXA0sZegJphQxz1rGiWSqgbt1TSzLN3qFx+aPzMDEU1sVVY+CRU+G4XborRcMErY5p3/Yr3vEv4S51rz5cA==;5:A9IksV8gTQe4F2Mo+6Ai7WMLRgYcxZr3/KgqWQ+0oGwkA/ZuvwYmpEZZogG1ZE594wdOIjuzIGhF4O+LjtX13scqDRczaO6WXnvUJQk4WaiPNwgmZ8VowsVSQOJkBQQcTLpoxVO2+ujNYOvZLiMsUUvfhIvzfl7huuYgTj8fJP8=;7:X4mf1wU6Y2Dag5meiU8JDf0Yk7LONVzTofkMcLYz44868lFFoQo/U3hlUf3lFKX0325zNXjgsE98zxX8vAIWsNLPy4srn+VNm7nHSxgOPooyiXL7Fm05fd2Ak5+yY4VlkKITDzYXGlFxZPwgeN+f0g==
x-ms-office365-filtering-correlation-id: 95c1ec17-fd10-4e72-37ad-08d658807496
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2806;
x-ms-traffictypediagnostic: BYAPR11MB2806:
x-microsoft-antispam-prvs: <BYAPR11MB28067AFC188C5BFC90C7DE9EE3AD0@BYAPR11MB2806.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3002001)(10201501046)(3231455)(999002)(944501491)(52105112)(148016)(149066)(150057)(6041310)(20161123562045)(20161123558120)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB2806;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB2806;
x-forefront-prvs: 087474FBFA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(366004)(39850400004)(396003)(136003)(199004)(189003)(186003)(4326008)(7736002)(26005)(14454004)(2906002)(107886003)(305945005)(386003)(53936002)(6506007)(36756003)(76176011)(6512007)(71190400001)(52116002)(71200400001)(5640700003)(256004)(3846002)(6116002)(99286004)(5660300001)(78486014)(6486002)(446003)(11346002)(486006)(575784001)(86362001)(105586002)(8676002)(97736004)(68736007)(316002)(2616005)(6436002)(476003)(54906003)(66066001)(25786009)(102836004)(81156014)(81166006)(8936002)(72206003)(2351001)(2501003)(478600001)(6916009)(106356001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2806;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: ql9OqOQ9YTXi+Zqcb4L5ICGf2RY0vQs9Vbc2bpIHNxZl15olstD7+AmnCQJ5V230IJjOi+wuGKTZoNTRDc7w4UAdvvb0m1H3LXeZINfNV2d9bUbUFemBGPXMeFDa9NgLO237zO8IBjG11e0z/FeYoQLvP1Ysqg8rLvl8/W/BLVbfxeuPMd369WEBinJXAHgF+8Xb+la33n2VSo1mKRkUpgjpIE3dD3rLgEIzRXG00YetDx66NxiRmquG1iwDXcuBaq2UXrQAP/pXFleRHhsFD+1Y39JwmZ3xpf5kEW/pVyXEjon3SVmNVJK1Kb6w6RTXAj6tNB1OSq5Dj1uRHT/DlqhNLkPy3U9UyqRiHFBx4lU=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 95c1ec17-fd10-4e72-37ad-08d658807496
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2018 18:03:25.7395
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

Refactor code to handle the get_station() callback from cfg80211
context. Provided different API's to fetch the station statistics
information in sync or async call. From cfg80211 get_station() ops
callback calls the sync version of API.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c         | 38 +++++++++++--------=
----
 drivers/staging/wilc1000/host_interface.h         |  3 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  2 +-
 3 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index 4762925..7ab46ef 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1322,13 +1322,10 @@ void wilc_resolve_disconnect_aberration(struct wilc=
_vif *vif)
 		wilc_disconnect(vif, 1);
 }
=20
-static void handle_get_statistics(struct work_struct *work)
+int wilc_get_statistics(struct wilc_vif *vif, struct rf_info *stats)
 {
-	struct host_if_msg *msg =3D container_of(work, struct host_if_msg, work);
-	struct wilc_vif *vif =3D msg->vif;
 	struct wid wid_list[5];
 	u32 wid_cnt =3D 0, result;
-	struct rf_info *stats =3D (struct rf_info *)msg->body.data;
=20
 	wid_list[wid_cnt].id =3D WID_LINKSPEED;
 	wid_list[wid_cnt].type =3D WID_CHAR;
@@ -1364,8 +1361,10 @@ static void handle_get_statistics(struct work_struct=
 *work)
 				      wid_cnt,
 				      wilc_get_vif_idx(vif));
=20
-	if (result)
+	if (result) {
 		netdev_err(vif->ndev, "Failed to send scan parameters\n");
+		return result;
+	}
=20
 	if (stats->link_speed > TCP_ACK_FILTER_LINK_SPEED_THRESH &&
 	    stats->link_speed !=3D DEFAULT_LINK_SPEED)
@@ -1373,11 +1372,18 @@ static void handle_get_statistics(struct work_struc=
t *work)
 	else if (stats->link_speed !=3D DEFAULT_LINK_SPEED)
 		wilc_enable_tcp_ack_filter(vif, false);
=20
-	/* free 'msg' for async command, for sync caller will free it */
-	if (msg->is_sync)
-		complete(&msg->work_comp);
-	else
-		kfree(msg);
+	return result;
+}
+
+static void handle_get_statistics(struct work_struct *work)
+{
+	struct host_if_msg *msg =3D container_of(work, struct host_if_msg, work);
+	struct wilc_vif *vif =3D msg->vif;
+	struct rf_info *stats =3D (struct rf_info *)msg->body.data;
+
+	wilc_get_statistics(vif, stats);
+
+	kfree(msg);
 }
=20
 static void wilc_hif_pack_sta_param(u8 *cur_byte, const u8 *mac,
@@ -2149,13 +2155,12 @@ int wilc_get_rssi(struct wilc_vif *vif, s8 *rssi_le=
vel)
 	return result;
 }
=20
-int
-wilc_get_statistics(struct wilc_vif *vif, struct rf_info *stats, bool is_s=
ync)
+int wilc_get_stats_async(struct wilc_vif *vif, struct rf_info *stats)
 {
 	int result;
 	struct host_if_msg *msg;
=20
-	msg =3D wilc_alloc_work(vif, handle_get_statistics, is_sync);
+	msg =3D wilc_alloc_work(vif, handle_get_statistics, false);
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
=20
@@ -2168,11 +2173,6 @@ wilc_get_statistics(struct wilc_vif *vif, struct rf_=
info *stats, bool is_sync)
 		return result;
 	}
=20
-	if (is_sync) {
-		wait_for_completion(&msg->work_comp);
-		kfree(msg);
-	}
-
 	return result;
 }
=20
@@ -2297,7 +2297,7 @@ static void get_periodic_rssi(struct timer_list *t)
 	}
=20
 	if (vif->hif_drv->hif_state =3D=3D HOST_IF_CONNECTED)
-		wilc_get_statistics(vif, &vif->periodic_stat, false);
+		wilc_get_stats_async(vif, &vif->periodic_stat);
=20
 	mod_timer(&vif->periodic_rssi, jiffies + msecs_to_jiffies(5000));
 }
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wi=
lc1000/host_interface.h
index 953f0ea..20af5c4 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -297,8 +297,7 @@ void wilc_frame_register(struct wilc_vif *vif, u16 fram=
e_type, bool reg);
 int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index, u8 mode,
 			     u8 ifc_id);
 int wilc_set_operation_mode(struct wilc_vif *vif, u32 mode);
-int wilc_get_statistics(struct wilc_vif *vif, struct rf_info *stats,
-			bool is_sync);
+int wilc_get_statistics(struct wilc_vif *vif, struct rf_info *stats);
 void wilc_resolve_disconnect_aberration(struct wilc_vif *vif);
 int wilc_get_vif_idx(struct wilc_vif *vif);
 int wilc_set_tx_power(struct wilc_vif *vif, u8 tx_power);
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/st=
aging/wilc1000/wilc_wfi_cfgoperations.c
index 4c9444e..045e365 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1039,7 +1039,7 @@ static int get_station(struct wiphy *wiphy, struct ne=
t_device *dev,
 	} else if (vif->iftype =3D=3D WILC_STATION_MODE) {
 		struct rf_info stats;
=20
-		wilc_get_statistics(vif, &stats, true);
+		wilc_get_statistics(vif, &stats);
=20
 		sinfo->filled |=3D BIT_ULL(NL80211_STA_INFO_SIGNAL) |
 				 BIT_ULL(NL80211_STA_INFO_RX_PACKETS) |
--=20
2.7.4

