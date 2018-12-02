Return-Path: <SRS0=9n1M=OL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F47FC65BB0
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:02:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD4E520881
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:02:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="MNsoJsMy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DD4E520881
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725783AbeLBSCf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 2 Dec 2018 13:02:35 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:23435 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbeLBSCf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Dec 2018 13:02:35 -0500
X-IronPort-AV: E=Sophos;i="5.56,307,1539673200"; 
   d="scan'208";a="23899243"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 02 Dec 2018 11:02:33 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.105) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sun, 2 Dec 2018 11:02:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YBcDDMMihiQDexbtHKuYu4BccgT6041L2wpKn531DhI=;
 b=MNsoJsMy862gjLVGY0m8Vay4B+43r4pJWKGBy/uc11aBb/fV1ab5TRVwj+wZhSjCwBxrIgr3y3qAxQWRPCDXNeYunU0AiN1381d5VOFLTLY8RP3NWrNeE4Oz5uFM22T/VQgmuDB+x+lRScQvTBVePA9PU1C8lpwMeCXeyzp1bc4=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3334.namprd11.prod.outlook.com (20.177.185.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1382.19; Sun, 2 Dec 2018 18:02:31 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f%4]) with mapi id 15.20.1382.020; Sun, 2 Dec 2018
 18:02:31 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 06/29] staging: wilc1000: handle setting power management from
 cfg80211 context
Thread-Topic: [PATCH 06/29] staging: wilc1000: handle setting power management
 from cfg80211 context
Thread-Index: AQHUimkxjU1/3pR4YE26Q30YVkx5Hg==
Date:   Sun, 2 Dec 2018 18:02:31 +0000
Message-ID: <1543773663-20561-7-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3334;6:NCm5FuNb+oXAXAPlab0VV5mR/Ni9FIjwlOcLkw0Qf4h2Pw5XYXNYuIUEHQEwsyIH9KtED9DFnmGTE+Xn0TrmbbM0NcWf2n8ktfJcecuYejrHGZ6IOGCB56mRD4dsdBnEF69ivqfL49emoYYyl7vukLs/toiRnhoY5Bibj68Vhs5J0+nU8nxJrB9niqMIyfmv8l1uk9OcEjbHASOEHtzeQvAKF2rjsu0J7yNztzB/SkV/ntZ9ckaATBLp0Fy/SN5XK5YeJgG2QlIbi8DbEChtthX1S7f7Wojs0aWgWFEEsVkfmcGBSqzt57DlUocnQVUFH9j6+K8U/hNlG+h7F+qJa2DvUw/191mcXBcDnn7oRrV7BK+lXeVXnrnWpiHMLZhqxYPfUHAYRxn+7wO5OUWbtHLIZkwylHc3tc4ERPBuRrVXPwvGpS+cQG9SqN7aIexioL8OG3IDDHtGbKNIo0XnGg==;5:Y68UjPIuiWYeHwHOD+V9+k31J+lSqfdmtGmO3IyGp1QqvDcQXLEQapEU/2Zz2YDQ6f7EYZCdjSlRP3Vbh10bxpGPPzrZVHFzekDVzfhsvGcJEU4qHxcCr+s/wF6tWVtXaQU5FRzcUwtAT0Bie3GT7gZVEu/h3VuyyEzcvEW/7p8=;7:0DvmJ/n+bVJv3slca9niOSxvT8c3kyT2OlIOhEEwmB1pFMPUHnDFjp6pHXriVhfxf7fjUO7/Dk0DFBuFTXh8Mt4SpuyEpFFNCWVIc4SUNOFyUJjhquW+IquZvDSLcC+mQZCv+2lMUKU6ElOL/kemfw==
x-ms-office365-filtering-correlation-id: da8edb75-5e7e-49c2-5c14-08d65880541d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3334;
x-ms-traffictypediagnostic: BYAPR11MB3334:
x-microsoft-antispam-prvs: <BYAPR11MB33344C6C0A5FE04F8D0A4AA8E3AD0@BYAPR11MB3334.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(10201501046)(3002001)(3231455)(999002)(944501491)(52105112)(93006095)(93001095)(148016)(149066)(150057)(6041310)(20161123558120)(20161123564045)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB3334;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB3334;
x-forefront-prvs: 087474FBFA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(136003)(346002)(366004)(376002)(396003)(39850400004)(199004)(189003)(107886003)(6916009)(386003)(5660300001)(5640700003)(446003)(4326008)(11346002)(6506007)(78486014)(2906002)(6512007)(53936002)(54906003)(3846002)(6116002)(2351001)(81166006)(316002)(81156014)(52116002)(8676002)(26005)(8936002)(256004)(76176011)(6436002)(97736004)(106356001)(99286004)(486006)(6486002)(68736007)(105586002)(14454004)(478600001)(2616005)(7736002)(66066001)(36756003)(305945005)(72206003)(186003)(2501003)(86362001)(102836004)(476003)(71190400001)(25786009)(71200400001)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3334;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: DdDl6e92O+B0MBXO/SStypAo8Pi/X10UJKUAfcZh0QySjaLc/D2wgqiNsLIvqmyJHwOh4O97TRKyRikRB8jLQgtG7hQtd2iU0rLmxHmTX9esz1qE4A9AzErN8hFScOG52fby7X0NnNqEuDf1BqX5LwbJgbJSKJ0yKL30T29WqzYA7+jTQV8LTolCffH7wqvxz28mQCwmEGl0I/XbEQnQz0dOQwFxEm/Uzy9BsouakF4aYz0bmx1R8CiOJyzcrKMrRhrAr3ZJKNdW3jlyoRjjA0KHSN85Wg3VYFAwAHXcXyQgPCwfhKOvgIAb3v/+Z41Yh37WEs/00ldxeN3aQDCl+bSHC4ijYVfEyo08zidhTWA=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: da8edb75-5e7e-49c2-5c14-08d65880541d
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2018 18:02:31.4215
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

Refactor the code to handle the power management cfg operation from the
caller context.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 56 +++++++--------------------=
----
 1 file changed, 13 insertions(+), 43 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index 88d9010..4074a37 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -102,11 +102,6 @@ struct del_sta {
 	u8 mac_addr[ETH_ALEN];
 };
=20
-struct power_mgmt_param {
-	bool enabled;
-	u32 timeout;
-};
-
 struct set_ip_addr {
 	u8 *ip_addr;
 	u8 idx;
@@ -129,7 +124,6 @@ union message_body {
 	struct add_sta_param add_sta_info;
 	struct del_sta del_sta_info;
 	struct add_sta_param edit_sta_info;
-	struct power_mgmt_param pwr_mgmt_info;
 	struct sta_inactive_t mac_info;
 	struct set_ip_addr ip_info;
 	struct drv_handler drv;
@@ -2298,32 +2292,6 @@ static void listen_timer_cb(struct timer_list *t)
 	}
 }
=20
-static void handle_power_management(struct work_struct *work)
-{
-	struct host_if_msg *msg =3D container_of(work, struct host_if_msg, work);
-	struct wilc_vif *vif =3D msg->vif;
-	struct power_mgmt_param *pm_param =3D &msg->body.pwr_mgmt_info;
-	int result;
-	struct wid wid;
-	s8 power_mode;
-
-	wid.id =3D WID_POWER_MANAGEMENT;
-
-	if (pm_param->enabled)
-		power_mode =3D WILC_FW_MIN_FAST_PS;
-	else
-		power_mode =3D WILC_FW_NO_POWERSAVE;
-
-	wid.val =3D &power_mode;
-	wid.size =3D sizeof(char);
-
-	result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
-				      wilc_get_vif_idx(vif));
-	if (result)
-		netdev_err(vif->ndev, "Failed to send power management\n");
-	kfree(msg);
-}
-
 static void handle_set_mcast_filter(struct work_struct *work)
 {
 	struct host_if_msg *msg =3D container_of(work, struct host_if_msg, work);
@@ -3647,24 +3615,26 @@ int wilc_edit_station(struct wilc_vif *vif,
=20
 int wilc_set_power_mgmt(struct wilc_vif *vif, bool enabled, u32 timeout)
 {
+	struct wid wid;
 	int result;
-	struct host_if_msg *msg;
+	s8 power_mode;
=20
 	if (wilc_wlan_get_num_conn_ifcs(vif->wilc) =3D=3D 2 && enabled)
 		return 0;
=20
-	msg =3D wilc_alloc_work(vif, handle_power_management, false);
-	if (IS_ERR(msg))
-		return PTR_ERR(msg);
+	if (enabled)
+		power_mode =3D WILC_FW_MIN_FAST_PS;
+	else
+		power_mode =3D WILC_FW_NO_POWERSAVE;
=20
-	msg->body.pwr_mgmt_info.enabled =3D enabled;
-	msg->body.pwr_mgmt_info.timeout =3D timeout;
+	wid.id =3D WID_POWER_MANAGEMENT;
+	wid.val =3D &power_mode;
+	wid.size =3D sizeof(char);
+	result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
+				      wilc_get_vif_idx(vif));
+	if (result)
+		netdev_err(vif->ndev, "Failed to send power management\n");
=20
-	result =3D wilc_enqueue_work(msg);
-	if (result) {
-		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
-		kfree(msg);
-	}
 	return result;
 }
=20
--=20
2.7.4

