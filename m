Return-Path: <SRS0=z7UY=PZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ABAAC43444
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 13:21:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 221D720652
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 13:21:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="F+7Kc13i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727704AbfAQNVl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 17 Jan 2019 08:21:41 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:64005 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727641AbfAQNVi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Jan 2019 08:21:38 -0500
X-IronPort-AV: E=Sophos;i="5.56,489,1539673200"; 
   d="scan'208";a="26544598"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 17 Jan 2019 06:21:37 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.107) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 17 Jan 2019 06:21:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JTGd8FYlBaqipgb2NOhtwCQF4WnOwT63rlEiuGFx+MA=;
 b=F+7Kc13iND3HaN4TTXSqhEo16VzZNKmWlQvlmuZYuXmZgisH/4Nt0hr8h2EOsj/nBDrPs6zE+GJgo2y/QtIMqhuXkjD+H3WuB2rTeSP9FQt+ITDZJmyXp246yWDFyOEkAc5nM2TtDq7HWwmYO645hKmJ1bZLy0edb4dD9ns+pKo=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3464.namprd11.prod.outlook.com (20.177.187.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.26; Thu, 17 Jan 2019 13:21:35 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::c110:8559:a438:491d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::c110:8559:a438:491d%3]) with mapi id 15.20.1516.019; Thu, 17 Jan 2019
 13:21:35 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 10/13] staging: wilc1000: refactor information message parsing
 logic
Thread-Topic: [PATCH 10/13] staging: wilc1000: refactor information message
 parsing logic
Thread-Index: AQHUrmeSy0ebO3UF8Uuul/wVUyXpZA==
Date:   Thu, 17 Jan 2019 13:21:35 +0000
Message-ID: <1547731250-18518-11-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3464;6:o4H+/+hG5+ZPk9FBAhdxaXJPV0XMgPMylv/f227QhLsm7OZsHnZpZrisx7J116u4dK3UdlaCZmRRolw+MZorGJ3tcfi5ecpaq45sWXkFVpJj4SRWeLK6sRJSOnTNd8EIHEKWq99iu+pc0GEdqhHu6FnTTNswTkdfF5if9FVdnaLbxcwy4YnufNqO1Oe7j1dv7sAuNYNXIES/Xd4m/qOnghY84YBefgOIrGItpp+u8NG5LFRbhC0X60a0Fa7K0w/hkr3BVcmlahk/kMmNbbWgHWvc7oTrFnBxI07VK6TguHPAyl2SPTR9XrXE2KdSG5z8i94P+D4umf4aTc0q9rmXSf+EZH1aYj0dni+V/1Lumv0rEPLpBUgwz57Ski2X9b6gOY7BeHQ4HpxaLa1kSLRPRLcV/ACq4UAXIxZJXFWYdLdJ1vKdjvduJ/NXj/WanxSUzL4rvgdzP+aIqtrjWW6xkg==;5:8049sefcWrSYe/AOVJ9kFySM7NZKduQNDrW+nsI9qiSJn+T/GGsdgjv8apjk5GYE55MahisoF4Zxd65QEsnwTZNxjSpJM/ALy4EO0ehshMwjCTVSSishCnJycpe+aT2fUdcwvtuIbcLGrl2fi34dZta3+fnZBPe6NBtR2cjBvLez3AMjg4IfUX0jKsjaT4iva2jefsY0df+rowAUt0UY7A==;7:TE6/74nBl8F1DmGW59k5UzfpVHgzMI0rnogoi+RkdWQ//Ni8COOKh/82IblnV5KOcaD/LfDMEZi+FCd/+QY0Cs5CuEbtWHuS+zfO7zVPh3BgNyQDwh95kk/YPSHhKo24TQKu6VqLuP/tEMcC7Cfurg==
x-ms-office365-filtering-correlation-id: a84f9ec1-1cda-47dc-f05d-08d67c7eb44a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3464;
x-ms-traffictypediagnostic: BYAPR11MB3464:
x-microsoft-antispam-prvs: <BYAPR11MB3464431CEFD4B92DBB80DF0DE3830@BYAPR11MB3464.namprd11.prod.outlook.com>
x-forefront-prvs: 0920602B08
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(366004)(136003)(39860400002)(376002)(396003)(199004)(189003)(14454004)(68736007)(81166006)(81156014)(5660300001)(8936002)(2906002)(106356001)(8676002)(26005)(305945005)(7736002)(6486002)(6436002)(5640700003)(36756003)(86362001)(99286004)(478600001)(6916009)(15650500001)(50226002)(72206003)(78486014)(76176011)(2501003)(66066001)(4326008)(97736004)(486006)(25786009)(6506007)(476003)(102836004)(14444005)(256004)(386003)(53936002)(2616005)(54906003)(6512007)(71190400001)(71200400001)(105586002)(107886003)(3846002)(52116002)(186003)(2351001)(6116002)(316002)(11346002)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3464;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: tS4NfGFPbcZS0LYNpOTMEUkySajlZVSbFx607wzD1XN6qrrd/HgofrLXxcILruFVf6n9yLduhvKScBo3Slz4uKijMxhMEts0/4BU4qEMinJXnVp5xpavIrfidJnuyxbfpJnT9nU8en1hDi0oiwZSWRAVE6jcYHTxe75EnO5VnTxPQl0Giy3WBru7/8JJktgwPESuWve70ZHQ/goMrfmcbA7xAg+ZHgSgnNj6KMWDMxET5yaxOkbkmx751oqNowoA509Szffo+QtoOqlF+CR3N/Uz5O6/d/XUXxHrqCSRPjD89y2V9dRuMmnucvfaQgVB6ehiQ6ufCE+253euXElyR+aD+YlE83xKWAohysAXAB1xUNaN4ADnus+y0GlL3hOFNl0OP4d4uCKElG8Rg9HNGBjI/8PwktUJdov12FcOtAk=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a84f9ec1-1cda-47dc-f05d-08d67c7eb44a
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2019 13:21:33.2463
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3464
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Refactor code to avoid maintaining an unnecessary buffer to keep the
information type message ('I' msg type).

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 66 ++++++++-------------------=
----
 1 file changed, 16 insertions(+), 50 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index e37d8ab..a146b78 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -11,9 +11,8 @@
=20
 #define FALSE_FRMWR_CHANNEL			100
=20
-struct rcvd_async_info {
-	u8 *buffer;
-	u32 len;
+struct wilc_rcvd_mac_info {
+	u8 status;
 };
=20
 struct set_multicast {
@@ -71,7 +70,7 @@ struct wilc_gtk_key {
=20
 union message_body {
 	struct wilc_rcvd_net_info net_info;
-	struct rcvd_async_info async_info;
+	struct wilc_rcvd_mac_info mac_info;
 	struct set_multicast multicast_info;
 	struct remain_ch remain_on_ch;
 	char *data;
@@ -755,55 +754,30 @@ static void handle_rcvd_gnrl_async_info(struct work_s=
truct *work)
 {
 	struct host_if_msg *msg =3D container_of(work, struct host_if_msg, work);
 	struct wilc_vif *vif =3D msg->vif;
-	struct rcvd_async_info *rcvd_info =3D &msg->body.async_info;
-	u8 msg_type;
-	u8 mac_status;
+	struct wilc_rcvd_mac_info *mac_info =3D &msg->body.mac_info;
 	struct host_if_drv *hif_drv =3D vif->hif_drv;
=20
-	if (!rcvd_info->buffer) {
-		netdev_err(vif->ndev, "%s: buffer is NULL\n", __func__);
-		goto free_msg;
-	}
-
 	if (!hif_drv) {
 		netdev_err(vif->ndev, "%s: hif driver is NULL\n", __func__);
-		goto free_rcvd_info;
+		goto free_msg;
 	}
=20
-	if (hif_drv->hif_state =3D=3D HOST_IF_WAITING_CONN_RESP ||
-	    hif_drv->hif_state =3D=3D HOST_IF_CONNECTED ||
-	    hif_drv->usr_scan_req.scan_result) {
-		if (!hif_drv->conn_info.conn_result) {
-			netdev_err(vif->ndev, "%s: conn_result is NULL\n",
-				   __func__);
-			goto free_rcvd_info;
-		}
-
-		msg_type =3D rcvd_info->buffer[0];
-
-		if ('I' !=3D msg_type) {
-			netdev_err(vif->ndev, "Received Message incorrect.\n");
-			goto free_rcvd_info;
-		}
+	if (!hif_drv->conn_info.conn_result) {
+		netdev_err(vif->ndev, "%s: conn_result is NULL\n", __func__);
+		goto free_msg;
+	}
=20
-		mac_status  =3D rcvd_info->buffer[7];
-		if (hif_drv->hif_state =3D=3D HOST_IF_WAITING_CONN_RESP) {
-			host_int_parse_assoc_resp_info(vif, mac_status);
-		} else if ((mac_status =3D=3D WILC_MAC_STATUS_DISCONNECTED) &&
-			   (hif_drv->hif_state =3D=3D HOST_IF_CONNECTED)) {
+	if (hif_drv->hif_state =3D=3D HOST_IF_WAITING_CONN_RESP) {
+		host_int_parse_assoc_resp_info(vif, mac_info->status);
+	} else if (mac_info->status =3D=3D WILC_MAC_STATUS_DISCONNECTED) {
+		if (hif_drv->hif_state =3D=3D HOST_IF_CONNECTED) {
 			host_int_handle_disconnect(vif);
-		} else if ((mac_status =3D=3D WILC_MAC_STATUS_DISCONNECTED) &&
-			   (hif_drv->usr_scan_req.scan_result)) {
+		} else if (hif_drv->usr_scan_req.scan_result) {
 			del_timer(&hif_drv->scan_timer);
-			if (hif_drv->usr_scan_req.scan_result)
-				handle_scan_done(vif, SCAN_EVENT_ABORTED);
+			handle_scan_done(vif, SCAN_EVENT_ABORTED);
 		}
 	}
=20
-free_rcvd_info:
-	kfree(rcvd_info->buffer);
-	rcvd_info->buffer =3D NULL;
-
 free_msg:
 	kfree(msg);
 }
@@ -1864,18 +1838,10 @@ void wilc_gnrl_async_info_received(struct wilc *wil=
c, u8 *buffer, u32 length)
 		return;
 	}
=20
-	msg->body.async_info.len =3D length;
-	msg->body.async_info.buffer =3D kmemdup(buffer, length, GFP_KERNEL);
-	if (!msg->body.async_info.buffer) {
-		kfree(msg);
-		mutex_unlock(&hif_deinit_lock);
-		return;
-	}
-
+	msg->body.mac_info.status =3D buffer[7];
 	result =3D wilc_enqueue_work(msg);
 	if (result) {
 		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
-		kfree(msg->body.async_info.buffer);
 		kfree(msg);
 	}
=20
--=20
2.7.4

