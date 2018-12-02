Return-Path: <SRS0=9n1M=OL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 337D2C64EB4
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:03:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E787E2082F
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:03:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="ewYdIPka"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E787E2082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725812AbeLBSDE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 2 Dec 2018 13:03:04 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:52852 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbeLBSDE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Dec 2018 13:03:04 -0500
X-IronPort-AV: E=Sophos;i="5.56,307,1539673200"; 
   d="scan'208";a="23451108"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 02 Dec 2018 11:03:02 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.108) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sun, 2 Dec 2018 11:03:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ndCiTukvZ5mXd5y4wgAYSyRWQiOqPTb/omz8u5EH7T8=;
 b=ewYdIPkagwHd2JKDUWYk+PP3ZMbYbFCkr4/GQWW1aZ+of1w05KV0u69iRG9eMLyJeKEglgmzsIAVloLYdXdJBbDAjPQzMMVr3qDD46ThubvK/54T906TRH4uSrHiBQnmCHFJG6sa5FtBjXj44OTs5ZOyJMxyVD2QEgC3wKutRck=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2806.namprd11.prod.outlook.com (52.135.228.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1382.18; Sun, 2 Dec 2018 18:03:00 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f%4]) with mapi id 15.20.1382.020; Sun, 2 Dec 2018
 18:03:00 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 16/29] staging: wilc1000: handle station dump cfg ops from
 cfg80211 context
Thread-Topic: [PATCH 16/29] staging: wilc1000: handle station dump cfg ops
 from cfg80211 context
Thread-Index: AQHUimlCsVBtmfm3zk6CrdvyYxIHqw==
Date:   Sun, 2 Dec 2018 18:02:59 +0000
Message-ID: <1543773663-20561-17-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2806;6:DHv0eddppDVRTW1s3m8XBwVRV+rKoHufgHg7xIwixptRxEKtbiqPQR7OutWi5sPexIOheJSkH/JcXNP/aRQ1E0KneoWF4ItS5bmAIRUsf7R6bwUEKs+gblk354vdmeHl8b/ZTmn3BevDx76PD7zDYj/Y5/TCQXFV+vZaUGWoiUZW2KDNqvBb6qMC1SDIMrcWDmxN8mIPL1FMNgDR7xk6flEqm2jyjzrSSKOT2A1T8rwpz7HGi3STyCm5nw8VbL6t2y0gQTVK1jShN2Xf6E9BHP1RZSoqyCbLLUgVVCmV7e78zaHeLkwwJFmlPv9Ge5aDlUItXS8mC+rrxnJTl38m2HY9Z6R8G4+0EOQkwTXiRgdTVumXYFuLei8WiqxF43WJTv2Rd3IDU5iRG19j0u6Zsop3JsxjZ0pvi6wQ4dZQrbbDyL+ulcxLdGK3kS0FDz+jeFyZeORhINw55RgW5kQZgg==;5:HUWhB1dfq+j/G46y/qb5xPxOk56dy24JxqnySFiyNXrHsbL+k+Shu0kotptBI4hslerYJr1mxsfeUkRQLHtINsO6jfzNFxkRuOu/6UoBMagzT42uVhbfC9YzBpLh8yABnHCiRzdEXo08184qPtH7xoxxReTuj0af9/DecTJhBCk=;7:rJQBplxOGOCqbqX70YpGbebq3YiO0RsFvLaZCAB4nab/FeBvPfleuk/XqArH8G/RsGvSZZ6H+7zp8/goC4AgkDT5fSoaQntqeT7wriFsVCg4Eeir4WpufXi80eo1DRunIM5o5lWI6Zqn/P/VcZZY0g==
x-ms-office365-filtering-correlation-id: 8ed142f5-a4de-4297-ff5b-08d658806533
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2806;
x-ms-traffictypediagnostic: BYAPR11MB2806:
x-microsoft-antispam-prvs: <BYAPR11MB28062B0A6CCF65D46BB3C66DE3AD0@BYAPR11MB2806.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3002001)(10201501046)(3231455)(999002)(944501491)(52105112)(148016)(149066)(150057)(6041310)(20161123562045)(20161123558120)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB2806;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB2806;
x-forefront-prvs: 087474FBFA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(366004)(39850400004)(396003)(136003)(199004)(189003)(186003)(4326008)(7736002)(26005)(14454004)(2906002)(107886003)(305945005)(386003)(53936002)(6506007)(36756003)(76176011)(6512007)(71190400001)(52116002)(71200400001)(5640700003)(14444005)(256004)(3846002)(6116002)(99286004)(5660300001)(78486014)(6486002)(446003)(11346002)(486006)(86362001)(105586002)(8676002)(97736004)(68736007)(316002)(2616005)(6436002)(476003)(54906003)(66066001)(25786009)(102836004)(81156014)(81166006)(8936002)(72206003)(2351001)(2501003)(478600001)(6916009)(106356001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2806;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: fgA2HuDSlpyb0R9Fr2o5hBxhlwgQ0ZftUucer773bx6YTGv4FTCVjSfdQqtaqtttbiY2JptwnJQ59htzPH71tXUNMZFf/xKZrn6MJSGhLUHP7KWXON2tOboKQsQ7ReguKAFBbDxlqOEUwXHKVtY7qe8ixt3mUvceGzcHcWl793zFt7CQBzuZ3mENkJo4XbiwMLdaNtDxGEqNYsONOQSWgHXCQJKhzcJ3vfymkhjJAejV6tK2K66pJdo4PHVeaSyASGE07UuLic/6le72CZEfM15mnXlPrVw0tjRc2ZqjbIzz7otIIlaw0hXiyhfF5pRrxLfRfBd1lOeRvSm2RwzfjBlCs8xnZjQJ5NCq3ex1OSo=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ed142f5-a4de-4297-ff5b-08d658806533
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2018 18:02:59.9200
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

Refactor code to handle dump_station() callback from cfg80211 context.
Instead of deferring issue of wid command now send it directly from cfg
context. Also making use of wilc_get_rssi() error status in case there
is a failure to post the wid command to the firmware.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c         | 51 ++++---------------=
----
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  5 ++-
 2 files changed, 13 insertions(+), 43 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index 6b1c9e3..1910f9a 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1678,27 +1678,6 @@ void wilc_resolve_disconnect_aberration(struct wilc_=
vif *vif)
 		wilc_disconnect(vif, 1);
 }
=20
-static void handle_get_rssi(struct work_struct *work)
-{
-	struct host_if_msg *msg =3D container_of(work, struct host_if_msg, work);
-	struct wilc_vif *vif =3D msg->vif;
-	int result;
-	struct wid wid;
-
-	wid.id =3D WID_RSSI;
-	wid.type =3D WID_CHAR;
-	wid.val =3D msg->body.data;
-	wid.size =3D sizeof(char);
-
-	result =3D wilc_send_config_pkt(vif, WILC_GET_CFG, &wid, 1,
-				      wilc_get_vif_idx(vif));
-	if (result)
-		netdev_err(vif->ndev, "Failed to get RSSI value\n");
-
-	complete(&msg->work_comp);
-	/* free 'msg' data in caller */
-}
-
 static void handle_get_statistics(struct work_struct *work)
 {
 	struct host_if_msg *msg =3D container_of(work, struct host_if_msg, work);
@@ -2620,34 +2599,22 @@ s32 wilc_get_inactive_time(struct wilc_vif *vif, co=
nst u8 *mac,
=20
 int wilc_get_rssi(struct wilc_vif *vif, s8 *rssi_level)
 {
+	struct wid wid;
 	int result;
-	struct host_if_msg *msg;
=20
 	if (!rssi_level) {
 		netdev_err(vif->ndev, "%s: RSSI level is NULL\n", __func__);
 		return -EFAULT;
 	}
=20
-	msg =3D wilc_alloc_work(vif, handle_get_rssi, true);
-	if (IS_ERR(msg))
-		return PTR_ERR(msg);
-
-	msg->body.data =3D kzalloc(sizeof(s8), GFP_KERNEL);
-	if (!msg->body.data) {
-		kfree(msg);
-		return -ENOMEM;
-	}
-
-	result =3D wilc_enqueue_work(msg);
-	if (result) {
-		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
-	} else {
-		wait_for_completion(&msg->work_comp);
-		*rssi_level =3D *msg->body.data;
-	}
-
-	kfree(msg->body.data);
-	kfree(msg);
+	wid.id =3D WID_RSSI;
+	wid.type =3D WID_CHAR;
+	wid.size =3D sizeof(char);
+	wid.val =3D rssi_level;
+	result =3D wilc_send_config_pkt(vif, WILC_GET_CFG, &wid, 1,
+				      wilc_get_vif_idx(vif));
+	if (result)
+		netdev_err(vif->ndev, "Failed to get RSSI value\n");
=20
 	return result;
 }
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/st=
aging/wilc1000/wilc_wfi_cfgoperations.c
index 18370ef..4802ce9 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1659,13 +1659,16 @@ static int dump_station(struct wiphy *wiphy, struct=
 net_device *dev,
 {
 	struct wilc_priv *priv =3D wiphy_priv(wiphy);
 	struct wilc_vif *vif =3D netdev_priv(priv->dev);
+	int ret;
=20
 	if (idx !=3D 0)
 		return -ENOENT;
=20
 	sinfo->filled |=3D BIT_ULL(NL80211_STA_INFO_SIGNAL);
=20
-	wilc_get_rssi(vif, &sinfo->signal);
+	ret =3D wilc_get_rssi(vif, &sinfo->signal);
+	if (ret)
+		return ret;
=20
 	memcpy(mac, priv->associated_bss, ETH_ALEN);
 	return 0;
--=20
2.7.4

