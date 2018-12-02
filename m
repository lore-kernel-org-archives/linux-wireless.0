Return-Path: <SRS0=9n1M=OL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD291C65BB2
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:02:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CB3B2082F
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:02:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="y6n/6fyh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9CB3B2082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725780AbeLBSCd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 2 Dec 2018 13:02:33 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:23435 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbeLBSCc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Dec 2018 13:02:32 -0500
X-IronPort-AV: E=Sophos;i="5.56,307,1539673200"; 
   d="scan'208";a="23899242"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 02 Dec 2018 11:02:30 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.108) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sun, 2 Dec 2018 11:02:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v0r6edAlUbQT4ka5eHUVWJFCCsGTXJ7BrR0gqPRhb80=;
 b=y6n/6fyhcOMeShDmWMRlSn+/qbigwmGV0M/E5AE1bBd0/TneMMMZG65Pqhc39+vUJnB09KkBXuGe8DRxau940okPEws9iM47QoqfoTN0r08ml4xVrA3BpyiUrpFgrIpH6Kk1iZOdTMvDaYuQ2PUahGo33imJNNBwi2TOC0am5nA=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3334.namprd11.prod.outlook.com (20.177.185.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1382.19; Sun, 2 Dec 2018 18:02:28 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f%4]) with mapi id 15.20.1382.020; Sun, 2 Dec 2018
 18:02:28 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 05/29] staging: wilc1000: handle tx power related callback
 from cfg80211 context
Thread-Topic: [PATCH 05/29] staging: wilc1000: handle tx power related
 callback from cfg80211 context
Thread-Index: AQHUimkwoshV31LXWEqXoDquSCWAwA==
Date:   Sun, 2 Dec 2018 18:02:28 +0000
Message-ID: <1543773663-20561-6-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3334;6:2voDG+aPfGW/AccEJe1l5HiyBL9w94hMrGdAUIfqLvC8hFhb1nLpLafv8m3VIv9aR6s59NzTYOx7unRncGZj4CR7J/i0ercYljqyeKK52BalCmvVgE4R6dmcuHDX9Xp2NQeQoDpacaZm6SAkm+tMiw6pRfcK5vGUIMcrW08ToW0c1n9ossbCkMRryKEswnyyc9mWhf7M0w8Oqs5SrVq+TJVr7kkPmPkkDOG6FqhjCPJNlOKIyzG98FhWgLHxNXkTvJaQ58EEkCwzwH/wa4r6oHDnxYE2VICfHx3SATK9x0K40Cl7lZHBtP5dWi+v9lIc1upt3/m47e6TOWajG+RTAZjU4P1myWQ2MardzzE0ED56K2Zpxh5nt4qNYBL7nlBOXWAwa1xJI5Y9Nl89pFg/TOSGaIwM/tRES4HAUDu/kUWVZOgGlwl4ZJA7TGm2yf/0t9ADjz4y+60h5td7dvAiFg==;5:m3NNz/5Lx6ofhjqc7+qh1/tv3aru+9KFXrARUqADHxqOi93AEPPGU7cI4QqcLhh35ulPKDseMpLsNinfYgMlB4QCmh24rGzebBfK6Mm9QUJXQXjjn2dkXk/o5cVlIERGH6Boao/ttY6iiwd3th6DBwtNLhowvFXYMiF4tSqJ6RY=;7:1Jppf4Y4EIplbTxRMCc2Lav/9tT+KUROEM0qWQfam6xkPVkHaaSdLdlWng0M8om/1lG2F4c5vnFHR2tgUtSrQ+MPeE8jekn/bonGiZ79XV29DR7i7M4UtvwurtcfQlo4qIRWH6wpZZIG5P8/5Sd//A==
x-ms-office365-filtering-correlation-id: ff4cf538-43ae-4b8f-5c64-08d65880526f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3334;
x-ms-traffictypediagnostic: BYAPR11MB3334:
x-microsoft-antispam-prvs: <BYAPR11MB33349100D39D44160ACF2B5CE3AD0@BYAPR11MB3334.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(10201501046)(3002001)(3231455)(999002)(944501491)(52105112)(93006095)(93001095)(148016)(149066)(150057)(6041310)(20161123558120)(20161123564045)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB3334;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB3334;
x-forefront-prvs: 087474FBFA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(366004)(376002)(396003)(39850400004)(199004)(189003)(107886003)(6916009)(386003)(5660300001)(5640700003)(446003)(4326008)(11346002)(6506007)(78486014)(2906002)(6512007)(53936002)(54906003)(3846002)(6116002)(2351001)(81166006)(316002)(81156014)(52116002)(8676002)(26005)(8936002)(256004)(76176011)(6436002)(97736004)(106356001)(99286004)(486006)(6486002)(68736007)(105586002)(14454004)(478600001)(2616005)(7736002)(66066001)(36756003)(305945005)(72206003)(186003)(2501003)(86362001)(102836004)(476003)(71190400001)(25786009)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3334;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: qjG5RKsowgVQ5hfynZ+4OYRDN230ZkuFsAYiqQN4/uh1n29azMxmhGkeUOHD0gSb1/4Mqh1uhyel8aNpk73HSnu108he4dHqdpkgUny2KLa32rxnDEcMkOjHFQoFRK9+AAfM9gJmXgPyKFSkS+DznmTaqZwgRQHR4A0k8f4Zf4nWTv8+9FGNjqjOOosWp/xFcJa0p4Ui/Qwi+T49fmDfhePb98fkQ+68FzICOY0GTsQlreWYRMXRjytDJvpIRMebbR3Fv66Vr2uoO7qOVaH+9zGby7Rr40GXDYYAfzuUGtsZpWhCYiFNEA5ulcM5KzPvaqjFqNQnqUWMDhdNoHbviAxEySVQtYJWDdTJ33QYQrs=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ff4cf538-43ae-4b8f-5c64-08d65880526f
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2018 18:02:28.4313
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

Avoid the use of internal work queue to defer the handling of tx power
related cfg operations callback. Now issuing the wid command to firmware
directly from the caller context.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 85 +++++----------------------=
----
 1 file changed, 14 insertions(+), 71 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index e179a8e..88d9010 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -117,10 +117,6 @@ struct sta_inactive_t {
 	u8 mac[6];
 };
=20
-struct tx_power {
-	u8 tx_pwr;
-};
-
 union message_body {
 	struct scan_attr scan_info;
 	struct connect_attr con_info;
@@ -145,7 +141,6 @@ union message_body {
 	struct reg_frame reg_frame;
 	char *data;
 	struct del_all_sta del_all_sta_info;
-	struct tx_power tx_power;
 };
=20
 struct host_if_msg {
@@ -2371,48 +2366,6 @@ static void handle_set_mcast_filter(struct work_stru=
ct *work)
 	kfree(msg);
 }
=20
-static void handle_set_tx_pwr(struct work_struct *work)
-{
-	struct host_if_msg *msg =3D container_of(work, struct host_if_msg, work);
-	struct wilc_vif *vif =3D msg->vif;
-	u8 tx_pwr =3D msg->body.tx_power.tx_pwr;
-	int ret;
-	struct wid wid;
-
-	wid.id =3D WID_TX_POWER;
-	wid.type =3D WID_CHAR;
-	wid.val =3D &tx_pwr;
-	wid.size =3D sizeof(char);
-
-	ret =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
-				   wilc_get_vif_idx(vif));
-	if (ret)
-		netdev_err(vif->ndev, "Failed to set TX PWR\n");
-	kfree(msg);
-}
-
-/* Note: 'msg' will be free after using data */
-static void handle_get_tx_pwr(struct work_struct *work)
-{
-	struct host_if_msg *msg =3D container_of(work, struct host_if_msg, work);
-	struct wilc_vif *vif =3D msg->vif;
-	u8 *tx_pwr =3D &msg->body.tx_power.tx_pwr;
-	int ret;
-	struct wid wid;
-
-	wid.id =3D WID_TX_POWER;
-	wid.type =3D WID_CHAR;
-	wid.val =3D (s8 *)tx_pwr;
-	wid.size =3D sizeof(char);
-
-	ret =3D wilc_send_config_pkt(vif, WILC_GET_CFG, &wid, 1,
-				   wilc_get_vif_idx(vif));
-	if (ret)
-		netdev_err(vif->ndev, "Failed to get TX PWR\n");
-
-	complete(&msg->work_comp);
-}
-
 static void handle_scan_timer(struct work_struct *work)
 {
 	struct host_if_msg *msg =3D container_of(work, struct host_if_msg, work);
@@ -3740,19 +3693,15 @@ int wilc_setup_multicast_filter(struct wilc_vif *vi=
f, bool enabled, u32 count,
 int wilc_set_tx_power(struct wilc_vif *vif, u8 tx_power)
 {
 	int ret;
-	struct host_if_msg *msg;
-
-	msg =3D wilc_alloc_work(vif, handle_set_tx_pwr, false);
-	if (IS_ERR(msg))
-		return PTR_ERR(msg);
+	struct wid wid;
=20
-	msg->body.tx_power.tx_pwr =3D tx_power;
+	wid.id =3D WID_TX_POWER;
+	wid.type =3D WID_CHAR;
+	wid.val =3D &tx_power;
+	wid.size =3D sizeof(char);
=20
-	ret =3D wilc_enqueue_work(msg);
-	if (ret) {
-		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
-		kfree(msg);
-	}
+	ret =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
+				   wilc_get_vif_idx(vif));
=20
 	return ret;
 }
@@ -3760,21 +3709,15 @@ int wilc_set_tx_power(struct wilc_vif *vif, u8 tx_p=
ower)
 int wilc_get_tx_power(struct wilc_vif *vif, u8 *tx_power)
 {
 	int ret;
-	struct host_if_msg *msg;
+	struct wid wid;
=20
-	msg =3D wilc_alloc_work(vif, handle_get_tx_pwr, true);
-	if (IS_ERR(msg))
-		return PTR_ERR(msg);
+	wid.id =3D WID_TX_POWER;
+	wid.type =3D WID_CHAR;
+	wid.val =3D tx_power;
+	wid.size =3D sizeof(char);
=20
-	ret =3D wilc_enqueue_work(msg);
-	if (ret) {
-		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
-	} else {
-		wait_for_completion(&msg->work_comp);
-		*tx_power =3D msg->body.tx_power.tx_pwr;
-	}
+	ret =3D wilc_send_config_pkt(vif, WILC_GET_CFG, &wid, 1,
+				   wilc_get_vif_idx(vif));
=20
-	/* free 'msg' after copying data */
-	kfree(msg);
 	return ret;
 }
--=20
2.7.4

