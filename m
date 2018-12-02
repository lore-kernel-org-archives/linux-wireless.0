Return-Path: <SRS0=9n1M=OL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F21CC04EB8
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:02:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7C342082F
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:02:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="vZAafs7a"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B7C342082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725793AbeLBSCp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 2 Dec 2018 13:02:45 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:39776 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbeLBSCp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Dec 2018 13:02:45 -0500
X-IronPort-AV: E=Sophos;i="5.56,307,1539673200"; 
   d="scan'208";a="24754991"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES128-SHA; 02 Dec 2018 11:02:42 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.37) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sun, 2 Dec 2018 11:02:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ME0kObpKBAx4a5Yq2g+DeF9rxVEHSn7WG6jW3xcSfs=;
 b=vZAafs7a8PvWJORTQD6i3hCIp9d6u/Qd1zy/vxf/wVz88lF/8Lj8asWatMg6CKKG2B0G1MHCZKqycdm8hyU/olw05z8eNcbc1UkuhoCFSL2/G0hi9+LzEhDbvTzRaAqqEXOeDXeiQEzXcjp3VPI9v7M7U5j1pOZnMg2dlZJQ/vQ=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3334.namprd11.prod.outlook.com (20.177.185.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1382.19; Sun, 2 Dec 2018 18:02:40 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f%4]) with mapi id 15.20.1382.020; Sun, 2 Dec 2018
 18:02:40 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 09/29] staging: wilc1000: handle delete station related
 callback ops from cfg80211 context
Thread-Topic: [PATCH 09/29] staging: wilc1000: handle delete station related
 callback ops from cfg80211 context
Thread-Index: AQHUimk3y4xd6sZZEECR5lInIFORTQ==
Date:   Sun, 2 Dec 2018 18:02:40 +0000
Message-ID: <1543773663-20561-10-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3334;6:O6GiOu3blnBv9OF5l625X1r3ZtAAi79JyDRSpIk8O2CnsS40B6zqrs/TdALQxXeCxFWAmfbui7x7wKWXk1wiXCIeAGbA1H9ilGe5LmcegeAR4RSr8ds6IR9GMDQS3woc194rv+KCQJ4IL9uNiYFr4HZ2dZJ4yBgnSih5XFy3ppjx57v0jSG1R3jxkhwqkCE5xv7a8MIViJSfonD/+SBLF4qtPATEAbFaL9R3rnr0QQHwHsjdMf/SLJfIYgbxN56/ahmI+M60RYfMK5l7DxZEuWECnTgudHWU+KYhXxS80GyqDWhkTO7rTKUGOy0/W7BSfgHmj1OdTZM8forqCdH6I7hLuVKhYUT89Ez3UIoMCO0hIH5ypIRZppGqyvC75q9gnPewswrkRmRsRRwoCeIt0kVotEYsa/ZnHOXsvEs+KO+qww7QeGhqVSJkTptZxb/oLOwrYf7biH3hjok+YrvqUw==;5:0VmBl2xjiUqm0W2vNU4hFkWb6Bs6ECUzTEEYgwHxEqdoXXQGOg44JiK5Nv+/aMkBEWBIvRTUQz2Xc8KTlYIl6xgyDUAgwxgA1iuJT4yxad8yqEzvJ/q/cEm/TdLghqIP9gXtfEpAL8fwFDnWU55IaQDvBP9uFEwP6xjS/cBmsgg=;7:jHFrBhqnVCEivxPlm1AObfFnaDtgCUHTz/xpDYtNsrVTg9VcEuu4UPWK1R/IKvGucvodt3mASbB8J4/0s2zcZELhpysKDWKfBbqtC4/YwPrwaCB3qM+YDvy3RIVSdw2UpqHo0SNODdmlJlCGDscI0Q==
x-ms-office365-filtering-correlation-id: 33709390-b755-4977-7f3e-08d65880593d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3334;
x-ms-traffictypediagnostic: BYAPR11MB3334:
x-microsoft-antispam-prvs: <BYAPR11MB3334D678EB0BF60B743AC8B6E3AD0@BYAPR11MB3334.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(10201501046)(3002001)(3231455)(999002)(944501491)(52105112)(93006095)(93001095)(148016)(149066)(150057)(6041310)(20161123558120)(20161123564045)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB3334;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB3334;
x-forefront-prvs: 087474FBFA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(366004)(376002)(396003)(39850400004)(199004)(189003)(107886003)(6916009)(386003)(5660300001)(5640700003)(446003)(4326008)(11346002)(6506007)(78486014)(2906002)(6512007)(53936002)(54906003)(3846002)(6116002)(2351001)(81166006)(316002)(81156014)(52116002)(8676002)(26005)(8936002)(256004)(14444005)(76176011)(6436002)(97736004)(106356001)(99286004)(486006)(6486002)(68736007)(105586002)(14454004)(478600001)(2616005)(7736002)(66066001)(36756003)(305945005)(72206003)(186003)(2501003)(86362001)(102836004)(476003)(71190400001)(25786009)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3334;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: Ulb8NdSwfEIhKqGkS1nXmmSHDmw/r7BSFVWkYSmtxR+z7vWrrXaHdx0g7EIMuM/ajbSO27kHieSVvjEXUMIjWgebY6PH7YD6Z414DR6yOs978n7tLyGvdLlsTydqrUDAinRq7wp7VboRUxeQm8mIQk7PfGlSgTPm9OEK6KRwBVp13J9MpZUJA+bQ4MiruG0+Ru/SkAp0zQ0q89mIB2x05+lyf2xt3VNHRiZ2abTjRuluIOfy4vbZVWX75hHVqw5NB7Db4oVlEDvYhc/LCi+si/sKbEeJ3uz4oWKGq+1zdy/hfw3/dfbU2yqN10RvfY+zLBT1h5hd9QtVcxg1nww7DI8QWcTUTMooHejwlHhQhG0=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 33709390-b755-4977-7f3e-08d65880593d
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2018 18:02:40.0477
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3334
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Refactor the code to handle delete/delete_all station operation callback
from cfg80211 context.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 147 +++++++-------------------=
----
 1 file changed, 33 insertions(+), 114 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index 40477ca..8ce56a3 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -94,12 +94,8 @@ struct set_multicast {
 };
=20
 struct del_all_sta {
-	u8 del_all_sta[WILC_MAX_NUM_STA][ETH_ALEN];
 	u8 assoc_sta;
-};
-
-struct del_sta {
-	u8 mac_addr[ETH_ALEN];
+	u8 mac[WILC_MAX_NUM_STA][ETH_ALEN];
 };
=20
 struct set_ip_addr {
@@ -121,7 +117,6 @@ union message_body {
 	struct cfg_param_attr cfg_info;
 	struct channel_attr channel_info;
 	struct beacon_attr beacon_info;
-	struct del_sta del_sta_info;
 	struct sta_inactive_t mac_info;
 	struct set_ip_addr ip_info;
 	struct drv_handler drv;
@@ -132,7 +127,6 @@ union message_body {
 	struct remain_ch remain_on_ch;
 	struct reg_frame reg_frame;
 	char *data;
-	struct del_all_sta del_all_sta_info;
 };
=20
 struct host_if_msg {
@@ -1989,78 +1983,6 @@ static void wilc_hif_pack_sta_param(u8 *cur_byte, co=
nst u8 *mac,
 	put_unaligned_le16(params->sta_flags_set, cur_byte);
 }
=20
-static void handle_del_all_sta(struct work_struct *work)
-{
-	struct host_if_msg *msg =3D container_of(work, struct host_if_msg, work);
-	struct wilc_vif *vif =3D msg->vif;
-	struct del_all_sta *param =3D &msg->body.del_all_sta_info;
-	int result;
-	struct wid wid;
-	u8 *curr_byte;
-	u8 i;
-	u8 zero_buff[6] =3D {0};
-
-	wid.id =3D WID_DEL_ALL_STA;
-	wid.type =3D WID_STR;
-	wid.size =3D (param->assoc_sta * ETH_ALEN) + 1;
-
-	wid.val =3D kmalloc((param->assoc_sta * ETH_ALEN) + 1, GFP_KERNEL);
-	if (!wid.val)
-		goto error;
-
-	curr_byte =3D wid.val;
-
-	*(curr_byte++) =3D param->assoc_sta;
-
-	for (i =3D 0; i < WILC_MAX_NUM_STA; i++) {
-		if (memcmp(param->del_all_sta[i], zero_buff, ETH_ALEN))
-			memcpy(curr_byte, param->del_all_sta[i], ETH_ALEN);
-		else
-			continue;
-
-		curr_byte +=3D ETH_ALEN;
-	}
-
-	result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
-				      wilc_get_vif_idx(vif));
-	if (result)
-		netdev_err(vif->ndev, "Failed to send delete all station\n");
-
-error:
-	kfree(wid.val);
-
-	/* free 'msg' data in caller */
-	complete(&msg->work_comp);
-}
-
-static void handle_del_station(struct work_struct *work)
-{
-	struct host_if_msg *msg =3D container_of(work, struct host_if_msg, work);
-	struct wilc_vif *vif =3D msg->vif;
-	struct del_sta *param =3D &msg->body.del_sta_info;
-	int result;
-	struct wid wid;
-
-	wid.id =3D WID_REMOVE_STA;
-	wid.type =3D WID_BIN;
-	wid.size =3D ETH_ALEN;
-
-	wid.val =3D kmalloc(wid.size, GFP_KERNEL);
-	if (!wid.val)
-		goto error;
-
-	ether_addr_copy(wid.val, param->mac_addr);
-
-	result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
-				      wilc_get_vif_idx(vif));
-	if (result)
-		netdev_err(vif->ndev, "Failed to del station\n");
-
-error:
-	kfree(wid.val);
-	kfree(msg);
-}
-
 static int handle_remain_on_chan(struct wilc_vif *vif,
 				 struct remain_ch *hif_remain_ch)
 {
@@ -3448,65 +3370,62 @@ int wilc_add_station(struct wilc_vif *vif, const u8=
 *mac,
=20
 int wilc_del_station(struct wilc_vif *vif, const u8 *mac_addr)
 {
+	struct wid wid;
 	int result;
-	struct host_if_msg *msg;
-	struct del_sta *del_sta_info;
-
-	msg =3D wilc_alloc_work(vif, handle_del_station, false);
-	if (IS_ERR(msg))
-		return PTR_ERR(msg);
=20
-	del_sta_info =3D &msg->body.del_sta_info;
+	wid.id =3D WID_REMOVE_STA;
+	wid.type =3D WID_BIN;
+	wid.size =3D ETH_ALEN;
+	wid.val =3D kzalloc(wid.size, GFP_KERNEL);
+	if (!wid.val)
+		return -ENOMEM;
=20
 	if (!mac_addr)
-		eth_broadcast_addr(del_sta_info->mac_addr);
+		eth_broadcast_addr(wid.val);
 	else
-		memcpy(del_sta_info->mac_addr, mac_addr, ETH_ALEN);
+		ether_addr_copy(wid.val, mac_addr);
+
+	result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
+				      wilc_get_vif_idx(vif));
+	if (result)
+		netdev_err(vif->ndev, "Failed to del station\n");
+
+	kfree(wid.val);
=20
-	result =3D wilc_enqueue_work(msg);
-	if (result) {
-		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
-		kfree(msg);
-	}
 	return result;
 }
=20
 int wilc_del_allstation(struct wilc_vif *vif, u8 mac_addr[][ETH_ALEN])
 {
+	struct wid wid;
 	int result;
-	struct host_if_msg *msg;
-	struct del_all_sta *del_all_sta_info;
-	u8 zero_addr[ETH_ALEN] =3D {0};
 	int i;
+	u8 zero_addr[ETH_ALEN] =3D {0};
 	u8 assoc_sta =3D 0;
+	struct del_all_sta del_sta;
=20
-	msg =3D wilc_alloc_work(vif, handle_del_all_sta, true);
-	if (IS_ERR(msg))
-		return PTR_ERR(msg);
-
-	del_all_sta_info =3D &msg->body.del_all_sta_info;
-
+	memset(&del_sta, 0x0, sizeof(del_sta));
 	for (i =3D 0; i < WILC_MAX_NUM_STA; i++) {
 		if (memcmp(mac_addr[i], zero_addr, ETH_ALEN)) {
-			memcpy(del_all_sta_info->del_all_sta[i], mac_addr[i],
-			       ETH_ALEN);
 			assoc_sta++;
+			ether_addr_copy(del_sta.mac[i], mac_addr[i]);
 		}
 	}
-	if (!assoc_sta) {
-		kfree(msg);
+
+	if (!assoc_sta)
 		return 0;
-	}
=20
-	del_all_sta_info->assoc_sta =3D assoc_sta;
-	result =3D wilc_enqueue_work(msg);
+	del_sta.assoc_sta =3D assoc_sta;
=20
-	if (result)
-		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
-	else
-		wait_for_completion(&msg->work_comp);
+	wid.id =3D WID_DEL_ALL_STA;
+	wid.type =3D WID_STR;
+	wid.size =3D (assoc_sta * ETH_ALEN) + 1;
+	wid.val =3D (u8 *)&del_sta;
=20
-	kfree(msg);
+	result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
+				      wilc_get_vif_idx(vif));
+	if (result)
+		netdev_err(vif->ndev, "Failed to send delete all station\n");
=20
 	return result;
 }
--=20
2.7.4

