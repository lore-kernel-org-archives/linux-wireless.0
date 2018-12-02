Return-Path: <SRS0=9n1M=OL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F281C04EB8
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:03:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF9FE2082F
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:03:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="Zjwt9jlP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DF9FE2082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725818AbeLBSDK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 2 Dec 2018 13:03:10 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:63033 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbeLBSDK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Dec 2018 13:03:10 -0500
X-IronPort-AV: E=Sophos;i="5.56,307,1539673200"; 
   d="scan'208";a="23749589"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES128-SHA; 02 Dec 2018 11:03:07 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.37) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sun, 2 Dec 2018 11:03:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RH1T78XcWMR6XyC9gVs3Bqc8tRB7iAjvZtx1Xh9a+JY=;
 b=Zjwt9jlPfl4aD1pS1FKSoTNEwd7KilxCX9loJzcVHZHEpkgfXIr+WqEL2yDTeYC0LfbdxFewTThQ5PTG2etdMDLVFApaQ0FYvLWOPcR8VLh5KQ+zMsKv/dkFhPshdOOZbD3OM222YuK5kcidtk1TH8uFqSQA+pkYXYkiIi8nqWc=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2806.namprd11.prod.outlook.com (52.135.228.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1382.18; Sun, 2 Dec 2018 18:03:05 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f%4]) with mapi id 15.20.1382.020; Sun, 2 Dec 2018
 18:03:05 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 18/29] staging: wilc1000: refactor wilc_set_wfi_drv_handler()
 to avoid deferred handling
Thread-Topic: [PATCH 18/29] staging: wilc1000: refactor
 wilc_set_wfi_drv_handler() to avoid deferred handling
Thread-Index: AQHUimlGQnnLxfVs8kWnTqBnbz8MmA==
Date:   Sun, 2 Dec 2018 18:03:05 +0000
Message-ID: <1543773663-20561-19-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2806;6:kSC9lRkTAPVlldgyy0oB4ifRZj1Fm69C6IWV+80L5VcNhC7Gmy7Oc8//LZNJx4tKdhUKTfJ3kjp+Rjg4H2PbV22NSN3YhbXcTmUneInk67uK7e5WcQBsaxNtMs2Vhdg+/jJ9VyPObFcVvS2LlJilHarEEz12ktqT54JT3/HUUGwr7Zs94hXz3VTf/PORvW/12mGxqxZvCg8olH0ms7ndtOeQFobcDvgqE6qMM6pAFFYxPOOWs/cp62X/Awa8FnjDAqExPBDh6zlvdxI7oIaoiepkVx8IXjDdc63BQ6+3Orj0Don+E2WMHNFHOvviFV61LLX0pnNk6f5EwirQ0mLsP2GlPUivxItFyM+Idj7wajwJzXHGtw2K/IQsHL7x7ba++CMordyXLCsLAo6tY3ECHS424SIl9Vu+aPbT/A2k8D20O/da9tnsxwA0IxfDuHmAHaqfpTP606852JXy1cKFuQ==;5:da5/y2Eb/tTXmFOBTbhUnYdj7ykYYzHZY6Rj+1/PlxWaPnNg9xHchvpWnHKbakECqZWXi/4vG+t3b1ClyHtvCkR9M7ZKbIYjf7rRHIy9SDQYerTXNOAbHWR39V+G58MqFLkBRKEONnvzT23h0de2P4TBpBtWxMcNcMiOYAZ9Ycs=;7:uNOHWPhJP1V26L3V6zDFZcdAuDT3bjw9nTcKINZ3suQjNOut1Ur5+mWxBALRQgg4poZvHXa1ty0i5u7PDKBCTEKgmj2Q1t3IdyEiVU5Mm7OLAV2sbwrrP9KKolshzJ6QXUr7arZwBZLo4wJ96cqWDA==
x-ms-office365-filtering-correlation-id: 7152ea16-917c-43f2-470f-08d6588068b1
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2806;
x-ms-traffictypediagnostic: BYAPR11MB2806:
x-microsoft-antispam-prvs: <BYAPR11MB28069155C920BD0E1F14E3C7E3AD0@BYAPR11MB2806.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3002001)(10201501046)(3231455)(999002)(944501491)(52105112)(148016)(149066)(150057)(6041310)(20161123562045)(20161123558120)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB2806;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB2806;
x-forefront-prvs: 087474FBFA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(366004)(39850400004)(396003)(136003)(199004)(189003)(186003)(4326008)(7736002)(26005)(14454004)(2906002)(107886003)(305945005)(386003)(53936002)(6506007)(36756003)(76176011)(6512007)(71190400001)(52116002)(71200400001)(5640700003)(14444005)(256004)(3846002)(6116002)(99286004)(5660300001)(78486014)(6486002)(446003)(11346002)(486006)(86362001)(105586002)(8676002)(97736004)(68736007)(316002)(2616005)(6436002)(476003)(54906003)(66066001)(25786009)(102836004)(81156014)(81166006)(8936002)(72206003)(2351001)(2501003)(478600001)(6916009)(106356001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2806;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 9v4CcYtBTofA95ABIV0qMSazNEHYSyffSdP7923tomM8Ul0Wy3V9RbAYuNRN80s2tSHZ1WH89XFCBGg6Rbvyud3cVOGVjUVlw/L4XPKkSnX/FnQS20tk0b/ObKnAN1DAwJOEntUjasoptPunFQLKWNikSTgvHDjsog0TUrdGLNcPLF7VsMVXNnmGXXlbwcVOfgtNqtlDcQgRpXB1vcoYGB3sP7Woz/Gd2RpTjl0r7bF5n/CyqkCv4hshXKlxPQkKD4HFErAqFBC535Ff9Poj6b8mocnO0wV9rd/3+iFC6dzQ7gCveAd6KrSp4/wg45DjxIajYFEqxS+eiAvaPVLTjE9BoYZGGiOds2PuGY+eRbA=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7152ea16-917c-43f2-470f-08d6588068b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2018 18:03:05.7752
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

Avoid handling of WID_SET_DRV_HANDLER wid command in deferred approach.
Instead of posting the wid to work queue now handle directly from the
caller context. Remove 'is_sync' parameter from the API as it's not
required anymore.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c         | 82 ++++++-------------=
----
 drivers/staging/wilc1000/host_interface.h         |  8 +--
 drivers/staging/wilc1000/linux_wlan.c             |  3 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  2 +-
 4 files changed, 23 insertions(+), 72 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index 312c01e..ab770d8 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -95,6 +95,11 @@ struct wilc_reg_frame {
 	__le32 frame_type;
 } __packed;
=20
+struct wilc_drv_handler {
+	__le32 handler;
+	u8 mode;
+} __packed;
+
 struct set_ip_addr {
 	u8 *ip_addr;
 	u8 idx;
@@ -113,7 +118,6 @@ union message_body {
 	struct key_attr key_info;
 	struct sta_inactive_t mac_info;
 	struct set_ip_addr ip_info;
-	struct drv_handler drv;
 	struct set_multicast multicast_info;
 	struct get_mac_addr get_mac_info;
 	struct ba_session_info session_info;
@@ -221,49 +225,6 @@ static struct wilc_vif *wilc_get_vif_from_idx(struct w=
ilc *wilc, int idx)
 	return wilc->vif[index];
 }
=20
-static void handle_set_wfi_drv_handler(struct work_struct *work)
-{
-	struct host_if_msg *msg =3D container_of(work, struct host_if_msg, work);
-	struct wilc_vif *vif =3D msg->vif;
-	struct drv_handler *hif_drv_handler =3D &msg->body.drv;
-	int ret;
-	struct wid wid;
-	u8 *currbyte, *buffer;
-	struct host_if_drv *hif_drv;
-
-	if (!vif->hif_drv || !hif_drv_handler)
-		goto free_msg;
-
-	hif_drv	=3D vif->hif_drv;
-
-	buffer =3D kzalloc(WILC_DRV_HANDLER_SIZE, GFP_KERNEL);
-	if (!buffer)
-		goto free_msg;
-
-	currbyte =3D buffer;
-	put_unaligned_le32(hif_drv->driver_handler_id, currbyte);
-	currbyte +=3D 4;
-	*currbyte =3D (hif_drv_handler->name | (hif_drv_handler->mode << 1));
-
-	wid.id =3D WID_SET_DRV_HANDLER;
-	wid.type =3D WID_STR;
-	wid.val =3D (s8 *)buffer;
-	wid.size =3D WILC_DRV_HANDLER_SIZE;
-
-	ret =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
-				   hif_drv->driver_handler_id);
-	if (ret)
-		netdev_err(vif->ndev, "Failed to set driver handler\n");
-
-	kfree(buffer);
-
-free_msg:
-	if (msg->is_sync)
-		complete(&msg->work_comp);
-
-	kfree(msg);
-}
-
 static void handle_get_mac_address(struct work_struct *work)
 {
 	struct host_if_msg *msg =3D container_of(work, struct host_if_msg, work);
@@ -2503,28 +2464,25 @@ int wilc_set_mac_chnl_num(struct wilc_vif *vif, u8 =
channel)
 }
=20
 int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index, u8 mode,
-			     u8 ifc_id, bool is_sync)
+			     u8 ifc_id)
 {
+	struct wid wid;
+	struct host_if_drv *hif_drv =3D vif->hif_drv;
 	int result;
-	struct host_if_msg *msg;
-
-	msg =3D wilc_alloc_work(vif, handle_set_wfi_drv_handler, is_sync);
-	if (IS_ERR(msg))
-		return PTR_ERR(msg);
+	struct wilc_drv_handler drv;
=20
-	msg->body.drv.handler =3D index;
-	msg->body.drv.mode =3D mode;
-	msg->body.drv.name =3D ifc_id;
+	wid.id =3D WID_SET_DRV_HANDLER;
+	wid.type =3D WID_STR;
+	wid.size =3D sizeof(drv);
+	wid.val =3D (u8 *)&drv;
=20
-	result =3D wilc_enqueue_work(msg);
-	if (result) {
-		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
-		kfree(msg);
-		return result;
-	}
+	drv.handler =3D cpu_to_le32(index);
+	drv.mode =3D (ifc_id | (mode << 1));
=20
-	if (is_sync)
-		wait_for_completion(&msg->work_comp);
+	result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
+				      hif_drv->driver_handler_id);
+	if (result)
+		netdev_err(vif->ndev, "Failed to set driver handler\n");
=20
 	return result;
 }
@@ -2814,7 +2772,7 @@ int wilc_deinit(struct wilc_vif *vif)
 	del_timer_sync(&vif->periodic_rssi);
 	del_timer_sync(&hif_drv->remain_on_ch_timer);
=20
-	wilc_set_wfi_drv_handler(vif, 0, 0, 0, true);
+	wilc_set_wfi_drv_handler(vif, 0, 0, 0);
=20
 	if (hif_drv->usr_scan_req.scan_result) {
 		hif_drv->usr_scan_req.scan_result(SCAN_EVENT_ABORTED, NULL,
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wi=
lc1000/host_interface.h
index e958357..7748f65 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -214,12 +214,6 @@ struct user_conn_req {
 	void *arg;
 };
=20
-struct drv_handler {
-	u32 handler;
-	u8 mode;
-	u8 name;
-};
-
 struct get_mac_addr {
 	u8 *mac_addr;
 };
@@ -333,7 +327,7 @@ int wilc_remain_on_channel(struct wilc_vif *vif, u32 se=
ssion_id,
 int wilc_listen_state_expired(struct wilc_vif *vif, u32 session_id);
 void wilc_frame_register(struct wilc_vif *vif, u16 frame_type, bool reg);
 int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index, u8 mode,
-			     u8 ifc_id, bool is_sync);
+			     u8 ifc_id);
 int wilc_set_operation_mode(struct wilc_vif *vif, u32 mode);
 int wilc_get_statistics(struct wilc_vif *vif, struct rf_info *stats,
 			bool is_sync);
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc10=
00/linux_wlan.c
index 142816a..7216890 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -754,8 +754,7 @@ static int wilc_mac_open(struct net_device *ndev)
 	for (i =3D 0; i < wl->vif_num; i++) {
 		if (ndev =3D=3D wl->vif[i]->ndev) {
 			wilc_set_wfi_drv_handler(vif, wilc_get_vif_idx(vif),
-						 vif->iftype, vif->ifc_id,
-						 false);
+						 vif->iftype, vif->ifc_id);
 			wilc_set_operation_mode(vif, vif->iftype);
 			break;
 		}
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/st=
aging/wilc1000/wilc_wfi_cfgoperations.c
index 4802ce9..3ed8ca9 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1739,7 +1739,7 @@ static int change_virtual_intf(struct wiphy *wiphy, s=
truct net_device *dev,
=20
 		if (wl->initialized) {
 			wilc_set_wfi_drv_handler(vif, wilc_get_vif_idx(vif),
-						 0, vif->ifc_id, false);
+						 0, vif->ifc_id);
 			wilc_set_operation_mode(vif, WILC_AP_MODE);
 			wilc_set_power_mgmt(vif, 0, 0);
 		}
--=20
2.7.4

