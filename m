Return-Path: <SRS0=9n1M=OL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2768C04EB8
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:03:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BEE12082F
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:03:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="qDqSkJfU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9BEE12082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725823AbeLBSDO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 2 Dec 2018 13:03:14 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:54455 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbeLBSDO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Dec 2018 13:03:14 -0500
X-IronPort-AV: E=Sophos;i="5.56,307,1539673200"; 
   d="scan'208";a="21782561"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 02 Dec 2018 11:03:12 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.106) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sun, 2 Dec 2018 11:03:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rvKjIsycoDa89j1JM6MP0KHxl0asHd+Wdk3aWo5GHT0=;
 b=qDqSkJfUajYoosYBTYIWvTbtK6AUdesgtDJ+6H0yJXL/4x+ixKe8D4B/LAy/opt7MsvUCYHXZ46es3PAMkMhSxLF9hgEI9qlc3+EgfEi8oG11RzdnOTy9j4BybqOEsfhyAZi7QgbfgQEJ3MWstb77a9farV3ls03jygaKRdP5Y0=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2806.namprd11.prod.outlook.com (52.135.228.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1382.18; Sun, 2 Dec 2018 18:03:08 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f%4]) with mapi id 15.20.1382.020; Sun, 2 Dec 2018
 18:03:08 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 19/29] staging: wilc1000: refactor wilc_get_inactive_time() to
 avoid deferred handling
Thread-Topic: [PATCH 19/29] staging: wilc1000: refactor
 wilc_get_inactive_time() to avoid deferred handling
Thread-Index: AQHUimlIjY3qL0ugG0mrd0vznqezCA==
Date:   Sun, 2 Dec 2018 18:03:08 +0000
Message-ID: <1543773663-20561-20-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2806;6:cBVYCe09dZ381YrtRMsG/mboUm4qA6oLIiJwq5IeNZIb5Gtw7gZax1gtE5vQTZOYL15ry82mqtWzbXiDIaf6mgkSjKqAmMWg6vS0qBsWCfLNRWHQTynHeBwuABCPvbGyJPXL47RgDGGwI8J4WZeuMHi9BQ6ewC/OQIhtEbQwuiIQ6xtMpeJPjQuONd7tNBs88jKjrnOzdO2DjvArzSmU2N/a78A7JJZgBa+msrpDEsJ6QTNMyyIq1UVBfAjUr/A4DLYgHHszv/dy0IhA+xU/AygYsQrlI3o0uoWHVwPFgQlSfKIDkFBzR1c8hjRmYryDaZFddb8wh9Wh3mAF3aP/h1eMWhBTr2PG5jHUX0MLxIFVFB2WBLRMmPUhRxj11d/jEIg6zBAkzKPpALtY9kT8NlTFy1LZSXkUEQhWmtl6Nd7mzF44uAEvjJ6dGC+r4QPlWGkqKS/c81q6FkxBAERh9A==;5:XN595j2X9If4Q/fAdwbsLTcm9e3nUjmJrNGFAApAuReVu+ypcAe+r4h5wzEPms3vEezoUgZBJRIg+roqlZf9vvL4cyFbx0dwRfHwHrPdq+VxgQnyVCk48lepZgWEKQvy6eXqOkT2DCfQuky4WD/sgLBimZ2DCFWH4tiE+54lYgY=;7:4w4lBOT5+Qrm+wq8nPhNJ7xEzeIL7c7usDJBlHU/yFogbpozp+u0yUnoJbHQiTADVyPd/TiShDK+eDiM2Mu8rbN2uOHbaueSavZLvbp1/qp+kweVUBUauycbn0Ne0hnAX7elDiTB+K5JumriMp0s4Q==
x-ms-office365-filtering-correlation-id: ac570baf-5c91-4f2e-e016-08d658806a56
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2806;
x-ms-traffictypediagnostic: BYAPR11MB2806:
x-microsoft-antispam-prvs: <BYAPR11MB28068964B17487E8E80BE997E3AD0@BYAPR11MB2806.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3002001)(10201501046)(3231455)(999002)(944501491)(52105112)(148016)(149066)(150057)(6041310)(20161123562045)(20161123558120)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB2806;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB2806;
x-forefront-prvs: 087474FBFA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(366004)(39850400004)(396003)(136003)(199004)(189003)(186003)(4326008)(7736002)(26005)(14454004)(2906002)(107886003)(305945005)(386003)(53936002)(6506007)(36756003)(76176011)(6512007)(71190400001)(52116002)(71200400001)(5640700003)(14444005)(256004)(3846002)(6116002)(99286004)(5660300001)(78486014)(6486002)(446003)(11346002)(486006)(86362001)(105586002)(8676002)(97736004)(68736007)(316002)(2616005)(6436002)(476003)(54906003)(66066001)(25786009)(102836004)(81156014)(81166006)(8936002)(72206003)(2351001)(2501003)(478600001)(6916009)(106356001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2806;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: hTaeK6OSsj5iD86u6zCTBnKCzmBgBDvAL7D9XgxQ8HqMJvD4jAzbfXqnlslZoPxjcDdcnN8Av2ZRZ4Ey4dlWvxyrFyfyEPx20IzxqGgHkm9wrK17PjaKb7op/TT6Vgp6ixRMGGzPA43qEJhaflX8HLLuF5qZ6v97mfuyiQRXlT0KCZngfc0TUtHHhFDslV9amr0bitiR7NLIVjDOCUcoS54n6wQsspte/rQb4FQSemeG/BDH0a6rrHD9dopXndXS6Z8i/9aWUjlNr9mLUc/F4a9DT6KX6OLv5mG67wS2jxqjBInLlVeLBi22f1OEU0G7+4djin0i+L+tTyqxuLjrrsMNyVm66vaoE/ZLOAvpxFw=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ac570baf-5c91-4f2e-e016-08d658806a56
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2018 18:03:08.7193
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

Avoid handling of inactive time related wid command in deferred manner.
Instead of posting the wid to workqueue now handle directly from the
caller context.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 91 ++++++++-------------------=
----
 1 file changed, 23 insertions(+), 68 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index ab770d8..e3dc9b6 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -105,18 +105,12 @@ struct set_ip_addr {
 	u8 idx;
 };
=20
-struct sta_inactive_t {
-	u32 inactive_time;
-	u8 mac[6];
-};
-
 union message_body {
 	struct scan_attr scan_info;
 	struct connect_attr con_info;
 	struct rcvd_net_info net_info;
 	struct rcvd_async_info async_info;
 	struct key_attr key_info;
-	struct sta_inactive_t mac_info;
 	struct set_ip_addr ip_info;
 	struct set_multicast multicast_info;
 	struct get_mac_addr get_mac_info;
@@ -1678,48 +1672,6 @@ static void handle_get_statistics(struct work_struct=
 *work)
 		kfree(msg);
 }
=20
-static void handle_get_inactive_time(struct work_struct *work)
-{
-	struct host_if_msg *msg =3D container_of(work, struct host_if_msg, work);
-	struct wilc_vif *vif =3D msg->vif;
-	struct sta_inactive_t *hif_sta_inactive =3D &msg->body.mac_info;
-	int result;
-	struct wid wid;
-
-	wid.id =3D WID_SET_STA_MAC_INACTIVE_TIME;
-	wid.type =3D WID_STR;
-	wid.size =3D ETH_ALEN;
-	wid.val =3D kmalloc(wid.size, GFP_KERNEL);
-	if (!wid.val)
-		goto out;
-
-	ether_addr_copy(wid.val, hif_sta_inactive->mac);
-
-	result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
-				      wilc_get_vif_idx(vif));
-	kfree(wid.val);
-
-	if (result) {
-		netdev_err(vif->ndev, "Failed to set inactive mac\n");
-		goto out;
-	}
-
-	wid.id =3D WID_GET_INACTIVE_TIME;
-	wid.type =3D WID_INT;
-	wid.val =3D (s8 *)&hif_sta_inactive->inactive_time;
-	wid.size =3D sizeof(u32);
-
-	result =3D wilc_send_config_pkt(vif, WILC_GET_CFG, &wid, 1,
-				      wilc_get_vif_idx(vif));
-
-	if (result)
-		netdev_err(vif->ndev, "Failed to get inactive time\n");
-
-out:
-	/* free 'msg' data in caller */
-	complete(&msg->work_comp);
-}
-
 static void wilc_hif_pack_sta_param(u8 *cur_byte, const u8 *mac,
 				    struct station_parameters *params)
 {
@@ -2508,32 +2460,35 @@ int wilc_set_operation_mode(struct wilc_vif *vif, u=
32 mode)
 	return result;
 }
=20
-s32 wilc_get_inactive_time(struct wilc_vif *vif, const u8 *mac,
-			   u32 *out_val)
+s32 wilc_get_inactive_time(struct wilc_vif *vif, const u8 *mac, u32 *out_v=
al)
 {
+	struct wid wid;
 	s32 result;
-	struct host_if_msg *msg;
-	struct host_if_drv *hif_drv =3D vif->hif_drv;
-
-	if (!hif_drv) {
-		netdev_err(vif->ndev, "%s: hif driver is NULL", __func__);
-		return -EFAULT;
-	}
=20
-	msg =3D wilc_alloc_work(vif, handle_get_inactive_time, true);
-	if (IS_ERR(msg))
-		return PTR_ERR(msg);
+	wid.id =3D WID_SET_STA_MAC_INACTIVE_TIME;
+	wid.type =3D WID_STR;
+	wid.size =3D ETH_ALEN;
+	wid.val =3D kzalloc(wid.size, GFP_KERNEL);
+	if (!wid.val)
+		return -ENOMEM;
=20
-	memcpy(msg->body.mac_info.mac, mac, ETH_ALEN);
+	ether_addr_copy(wid.val, mac);
+	result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
+				      wilc_get_vif_idx(vif));
+	kfree(wid.val);
+	if (result) {
+		netdev_err(vif->ndev, "Failed to set inactive mac\n");
+		return result;
+	}
=20
-	result =3D wilc_enqueue_work(msg);
+	wid.id =3D WID_GET_INACTIVE_TIME;
+	wid.type =3D WID_INT;
+	wid.val =3D (s8 *)out_val;
+	wid.size =3D sizeof(u32);
+	result =3D wilc_send_config_pkt(vif, WILC_GET_CFG, &wid, 1,
+				      wilc_get_vif_idx(vif));
 	if (result)
-		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
-	else
-		wait_for_completion(&msg->work_comp);
-
-	*out_val =3D msg->body.mac_info.inactive_time;
-	kfree(msg);
+		netdev_err(vif->ndev, "Failed to get inactive time\n");
=20
 	return result;
 }
--=20
2.7.4

