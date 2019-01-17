Return-Path: <SRS0=z7UY=PZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B82E9C43444
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 13:21:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D6F020652
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 13:21:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="N3nQtyNt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727682AbfAQNVm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 17 Jan 2019 08:21:42 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:38991 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727729AbfAQNVl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Jan 2019 08:21:41 -0500
X-IronPort-AV: E=Sophos;i="5.56,489,1539673200"; 
   d="scan'208";a="25605810"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 17 Jan 2019 06:21:41 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.107) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 17 Jan 2019 06:21:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pEvY1Ac1TGUdD8QLYt1BgrWE7J6iLW9/U8++9v90NlA=;
 b=N3nQtyNtu3hNlZe37KmCs5woZ5ptQyPjAuvCNaOj1SzLDnrz9XFzJxKfiCvaV4DxdWGQEP7npsFeYp5hrW2vUb2ysVJBpZjvPm4W20UhxE3c3B/9dlV+dKgX/wmFxYrqDbNPePMLKU0uDI2G4jJC3D4ftX7pq3AHv2SpqQ6Q7n8=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2534.namprd11.prod.outlook.com (52.135.226.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.25; Thu, 17 Jan 2019 13:21:38 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::c110:8559:a438:491d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::c110:8559:a438:491d%3]) with mapi id 15.20.1516.019; Thu, 17 Jan 2019
 13:21:38 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 11/13] staging: wilc1000: remove 'disconnect_info' structure
Thread-Topic: [PATCH 11/13] staging: wilc1000: remove 'disconnect_info'
 structure
Thread-Index: AQHUrmeTWC9Qt3UxPkWlQPTsUOVQsA==
Date:   Thu, 17 Jan 2019 13:21:38 +0000
Message-ID: <1547731250-18518-12-git-send-email-ajay.kathat@microchip.com>
References: <1547731250-18518-1-git-send-email-ajay.kathat@microchip.com>
In-Reply-To: <1547731250-18518-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR01CA0138.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:35::32) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.7.4
x-originating-ip: [49.205.218.18]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2534;6:oIm3zRRC2QdseEhDBpX2M92gj76hM8tTY4ePILs18Mp9DyLTiwHRcxEkeX/CDZ6PNW3lmDvai1VYg2DxG6u+hq+SImR0tUcP63k2+75OLZ8RLatLfmH+nROCO3BHnj06QrZA9VKa9WRN7zrRJosytNbaPVfb98b1MT4vSFFFTyxg7vlfp8VTM6GhWbhxS4YDNxPXgKb/1yOp75w+QfaN4ctMcNoKt5fpWdRaevROu7CRLIG8pdNt98iNLkeGkArbW54HecsVwn0J9hEPdv4qmx6Y0A3uvXsMAFwm0JZlwoXi1a/+uMmX+01C/u4EojmTGoZB8ussB8Sj7mutizZPfOITuS5xoch1GMdJ9ycOrb8MB7wywwNLJmh6RIBDonru4jQy4tgYme/60saHgzbw0nNiA4Yg9eP6HQ0ALbZ+RNw1yAtDkgOW3l8LzR9vzXtOysBZdTcNe+etGYgEk/m1lA==;5:vsp5iwVfp6HMfLTzpCvHbhiqduXA7KdrJVW7XVF64SNcdGvZph/e4j7ZOsIUXBhTB+xhcej+NCmBIkrB9goaHeebfl3NTAwQYsONUwE+7va59EtS34BLqsLU/olbbwjdhRS1HVJ+6Tu2aT4sy4B2s3VcBvpk9Fv7BQrP4Thqr+HDl2XwJ6ca+JVvcO7wQO6mzpbv6CfNpKyJfO8HApA9Cw==;7:5rbSaArW5oauMxsIT0AGVO/3n96zU9qZXkdrojHahMrfxeTmScW8gkyMKQw0r74wZ1ACycoD/xntDShA3ENwVwmLVqT2GEZSK3/Ng+z7jGI10u3nBUEHExpVbPttek3pG9hQi5Jqh7ZjdS9GIpB40w==
x-ms-office365-filtering-correlation-id: 05319e21-bfc1-4fce-c8a8-08d67c7eb620
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2534;
x-ms-traffictypediagnostic: BYAPR11MB2534:
x-microsoft-antispam-prvs: <BYAPR11MB25346BE5C5138AAAA66B5011E3830@BYAPR11MB2534.namprd11.prod.outlook.com>
x-forefront-prvs: 0920602B08
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(136003)(346002)(39860400002)(376002)(199004)(189003)(6916009)(6116002)(3846002)(386003)(6506007)(14454004)(2616005)(66066001)(7736002)(78486014)(71190400001)(71200400001)(5660300001)(102836004)(476003)(305945005)(52116002)(76176011)(446003)(106356001)(81166006)(81156014)(486006)(11346002)(316002)(8936002)(54906003)(8676002)(99286004)(50226002)(2351001)(72206003)(478600001)(68736007)(25786009)(186003)(5640700003)(2906002)(26005)(105586002)(53936002)(6512007)(36756003)(6436002)(6486002)(256004)(4326008)(107886003)(2501003)(86362001)(97736004);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2534;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: worDRZzwAbNgW+cpphh4F9equjFMrCOxTs3IsXvq1gaMtIXEiTc7GqYJ5/dXNUrCZGz3A0y5GD14FSyz8duu8p64ruKd4cnRJkqoag5A0SOngfXjPN7bnlbXEwHybQ0fS9AmliFSgVYg6hPm9KpKD/G8gEkb0RydNV2yVAX/sEtW/6KfllVUXbsZistLenuCkpZD7/10sXSsgTaXwpA30Pa2VKKBj5kHr6QUESWAxIpf/qL0UEfi/TJD8r+rUSSDYM8qoVS1rCmtltlZW3IzX83tQiY0POJIxPHI1yi9m3hah4NN1AEUjTg9ho4ML3RBhPSEk9GPglqj0TAqfDqd4A5IM7aVigy0p0UE+kiVT787SMJBDWxaMKtHvBuRQ+2kYeP4CXF//gh2J1tHuvrLQpAKRV4A4Zqm8SSAxhrfBkQ=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 05319e21-bfc1-4fce-c8a8-08d67c7eb620
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2019 13:21:36.2244
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2534
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Remove 'disconnect_info' struct use because its passed values are not
required in cfg_connect_result().

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c         | 24 +++++--------------=
----
 drivers/staging/wilc1000/host_interface.h         |  9 +--------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 12 ++++++------
 3 files changed, 12 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index a146b78..fa3af2c 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -427,7 +427,7 @@ static void handle_connect_timeout(struct work_struct *=
work)
 	if (hif_drv->conn_info.conn_result) {
 		hif_drv->conn_info.conn_result(CONN_DISCONN_EVENT_CONN_RESP,
 					       WILC_MAC_STATUS_DISCONNECTED,
-					       NULL, hif_drv->conn_info.arg);
+					       hif_drv->conn_info.arg);
=20
 	} else {
 		netdev_err(vif->ndev, "%s: conn_result is NULL\n", __func__);
@@ -689,7 +689,7 @@ static inline void host_int_parse_assoc_resp_info(struc=
t wilc_vif *vif,
 	}
=20
 	del_timer(&hif_drv->connect_timer);
-	conn_info->conn_result(CONN_DISCONN_EVENT_CONN_RESP, mac_status, NULL,
+	conn_info->conn_result(CONN_DISCONN_EVENT_CONN_RESP, mac_status,
 			       hif_drv->conn_info.arg);
=20
 	if (mac_status =3D=3D WILC_MAC_STATUS_CONNECTED &&
@@ -717,27 +717,19 @@ static inline void host_int_parse_assoc_resp_info(str=
uct wilc_vif *vif,
=20
 static inline void host_int_handle_disconnect(struct wilc_vif *vif)
 {
-	struct disconnect_info disconn_info;
 	struct host_if_drv *hif_drv =3D vif->hif_drv;
=20
-	memset(&disconn_info, 0, sizeof(struct disconnect_info));
-
 	if (hif_drv->usr_scan_req.scan_result) {
 		del_timer(&hif_drv->scan_timer);
 		handle_scan_done(vif, SCAN_EVENT_ABORTED);
 	}
=20
-	disconn_info.reason =3D 0;
-	disconn_info.ie =3D NULL;
-	disconn_info.ie_len =3D 0;
-
 	if (hif_drv->conn_info.conn_result) {
 		vif->obtaining_ip =3D false;
 		wilc_set_power_mgmt(vif, 0, 0);
=20
 		hif_drv->conn_info.conn_result(CONN_DISCONN_EVENT_DISCONN_NOTIF,
-					       0, &disconn_info,
-					       hif_drv->conn_info.arg);
+					       0, hif_drv->conn_info.arg);
 	} else {
 		netdev_err(vif->ndev, "%s: conn_result is NULL\n", __func__);
 	}
@@ -786,7 +778,6 @@ int wilc_disconnect(struct wilc_vif *vif)
 {
 	struct wid wid;
 	struct host_if_drv *hif_drv =3D vif->hif_drv;
-	struct disconnect_info disconn_info;
 	struct user_scan_req *scan_req;
 	struct wilc_conn_info *conn_info;
 	int result;
@@ -807,11 +798,6 @@ int wilc_disconnect(struct wilc_vif *vif)
 		return result;
 	}
=20
-	memset(&disconn_info, 0, sizeof(struct disconnect_info));
-
-	disconn_info.reason =3D 0;
-	disconn_info.ie =3D NULL;
-	disconn_info.ie_len =3D 0;
 	scan_req =3D &hif_drv->usr_scan_req;
 	conn_info =3D &hif_drv->conn_info;
=20
@@ -825,8 +811,8 @@ int wilc_disconnect(struct wilc_vif *vif)
 		if (hif_drv->hif_state =3D=3D HOST_IF_WAITING_CONN_RESP)
 			del_timer(&hif_drv->connect_timer);
=20
-		conn_info->conn_result(CONN_DISCONN_EVENT_DISCONN_NOTIF,
-				       0, &disconn_info, conn_info->arg);
+		conn_info->conn_result(CONN_DISCONN_EVENT_DISCONN_NOTIF, 0,
+				       conn_info->arg);
 	} else {
 		netdev_err(vif->ndev, "%s: conn_result is NULL\n", __func__);
 	}
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wi=
lc1000/host_interface.h
index 459a084..363db0b 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -35,12 +35,6 @@ enum {
=20
 #define WILC_MAX_ASSOC_RESP_FRAME_SIZE   256
=20
-struct disconnect_info {
-	u16 reason;
-	u8 *ie;
-	size_t ie_len;
-};
-
 struct assoc_resp {
 	__le16 capab_info;
 	__le16 status_code;
@@ -143,8 +137,7 @@ struct wilc_conn_info {
 	u8 *resp_ies;
 	u16 resp_ies_len;
 	u16 status;
-	void (*conn_result)(enum conn_event evt, u8 status,
-			    struct disconnect_info *info, void *priv_data);
+	void (*conn_result)(enum conn_event evt, u8 status, void *priv_data);
 	void *arg;
 	void *param;
 };
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/st=
aging/wilc1000/wilc_wfi_cfgoperations.c
index bc1d7a7..79753ad 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -140,7 +140,6 @@ static void cfg_scan_result(enum scan_event scan_event,
 }
=20
 static void cfg_connect_result(enum conn_event conn_disconn_evt, u8 mac_st=
atus,
-			       struct disconnect_info *disconn_info,
 			       void *priv_data)
 {
 	struct wilc_priv *priv =3D priv_data;
@@ -177,6 +176,8 @@ static void cfg_connect_result(enum conn_event conn_dis=
conn_evt, u8 mac_status,
 					conn_info->resp_ies_len, connect_status,
 					GFP_KERNEL);
 	} else if (conn_disconn_evt =3D=3D CONN_DISCONN_EVENT_DISCONN_NOTIF) {
+		u16 reason =3D 0;
+
 		vif->obtaining_ip =3D false;
 		priv->p2p.local_random =3D 0x01;
 		priv->p2p.recv_random =3D 0x00;
@@ -186,14 +187,13 @@ static void cfg_connect_result(enum conn_event conn_d=
isconn_evt, u8 mac_status,
=20
 		if (!wfi_drv->p2p_connect)
 			wlan_channel =3D INVALID_CHANNEL;
+
 		if (wfi_drv->ifc_up && dev =3D=3D wl->vif[1]->ndev)
-			disconn_info->reason =3D 3;
+			reason =3D 3;
 		else if (!wfi_drv->ifc_up && dev =3D=3D wl->vif[1]->ndev)
-			disconn_info->reason =3D 1;
+			reason =3D 1;
=20
-		cfg80211_disconnected(dev, disconn_info->reason,
-				      disconn_info->ie, disconn_info->ie_len,
-				      false, GFP_KERNEL);
+		cfg80211_disconnected(dev, reason, NULL, 0, false, GFP_KERNEL);
 	}
 }
=20
--=20
2.7.4

