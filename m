Return-Path: <SRS0=9n1M=OL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 812B0C64EB4
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:03:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31D7A2082F
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:03:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="0LBzaC7g"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 31D7A2082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725821AbeLBSDL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 2 Dec 2018 13:03:11 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:39796 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbeLBSDL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Dec 2018 13:03:11 -0500
X-IronPort-AV: E=Sophos;i="5.56,307,1539673200"; 
   d="scan'208";a="24755012"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES128-SHA; 02 Dec 2018 11:02:59 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.37) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sun, 2 Dec 2018 11:02:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C81+GM0mlqHKAtpvJHJiZwcf+mDIMTmPjcRCc3801fc=;
 b=0LBzaC7gS+8vT78pBhsUPyhHQCe+uWC7EhEN7XKWRXd0FA6QaztkqRT71ZHdnuP41HHOQwKRXGqZTtALTynpK61S0Z2/HVvJhDof1e8BFYLwm0JNCTz/ENc9cYFnpjH51WlyZ74nfWlR25+k5xaseXmu2zlMDt8ZgVl7vCp6Yc8=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2806.namprd11.prod.outlook.com (52.135.228.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1382.18; Sun, 2 Dec 2018 18:02:57 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f%4]) with mapi id 15.20.1382.020; Sun, 2 Dec 2018
 18:02:57 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 15/29] staging: wilc1000: refactor wilc_hif_set_cfg() to avoid
 deferred handling
Thread-Topic: [PATCH 15/29] staging: wilc1000: refactor wilc_hif_set_cfg() to
 avoid deferred handling
Thread-Index: AQHUimlBqAvdDE4SvkaLd/T9aHySXQ==
Date:   Sun, 2 Dec 2018 18:02:57 +0000
Message-ID: <1543773663-20561-16-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2806;6:Wr1vgu1dt5AC+8I78L10ATxYOx8w+9GOEN8TIVZhhqXfebtqMPCaIHfXalB8HehkDyk/918hPWy6B+vyDIYokgRkh3fdZU0aXMMl6SopUGtebmFxdSKFl1QD5Xtlvdm3+Aoo33JIZdHtvGMFSPhIuomU5TS1Gp51dda7x2hSO6entjzUod+BWe9jEu5pjl2LXNRFpCipYxpd3nYzSfKZar4IUOoqT/zRylQoo8LN7bg6iDuMmjiCh73oP6TnUX/7JVRB76YqYDUpnThpVuQarA7SINggtJaWbDuEbfZcWzebxYiafzKnO3czO3jnFk8Sr6c9IKiO1bvw2M/PT7LnXZDN3Zf/fm3w1JVpL9eKyyHYoThyEnEMCcxNCZPX3039m+9ov4rUe+2K7gR6l7X8VisZUM1xLY9BtLetYWrQx2Y+BTHFp2NtHBjlJDBT8VKkCe9799uRlcy15GC/X/TFKQ==;5:knKn1KtjoslCaL0aH6Ftxm/jnMYYMPER85iY41V4RDa5mULTEsRLCATV1IS5hoYSkbWDARWLpbgbtG3I3T/S8yl+JsaEpvDhGHCGaTwYb3q3MiyRY6tDq6MF7x4K5nIinxJpIG0CBLsq3/0hP+27mn4l+P2KrdAgRNUD09f3XpI=;7:M77ekKbfOGJ05sbAe1l0mZ5XU7XCX6svEoped+wD3DlyeLACA89c/zfGlzYfPkqYqd8XUyU1aQoD8IxL27akkKUdKlMy/zHeblkkQdRCKOURmXC1Bs0cvMqmtyan/w5IZax9E78QSTBgc2XJ+njiyw==
x-ms-office365-filtering-correlation-id: 8f2cfee4-1648-4281-4943-08d658806393
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2806;
x-ms-traffictypediagnostic: BYAPR11MB2806:
x-microsoft-antispam-prvs: <BYAPR11MB2806FD8E4F43CE4A4DD9FAA7E3AD0@BYAPR11MB2806.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3002001)(10201501046)(3231455)(999002)(944501491)(52105112)(148016)(149066)(150057)(6041310)(20161123562045)(20161123558120)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB2806;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB2806;
x-forefront-prvs: 087474FBFA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(366004)(39850400004)(396003)(136003)(199004)(189003)(186003)(4326008)(7736002)(26005)(14454004)(2906002)(107886003)(305945005)(386003)(53936002)(6506007)(36756003)(76176011)(6512007)(71190400001)(52116002)(71200400001)(5640700003)(14444005)(256004)(3846002)(6116002)(99286004)(5660300001)(78486014)(6486002)(446003)(11346002)(486006)(86362001)(105586002)(8676002)(97736004)(68736007)(316002)(2616005)(6436002)(476003)(54906003)(66066001)(25786009)(102836004)(81156014)(81166006)(8936002)(72206003)(2351001)(2501003)(478600001)(6916009)(106356001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2806;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: dqVWuUr9tEQYCWrVRLyhpPXD5MV6BXTMH+mctpCPlFO5267HFdsPnJgIuZwT/Z0PM+B9sM46IGsbHY57tbDtDpLQtwJiwIIXW+pnEeA7MP5HKWIHgGLti7RMz+U5zlz6RmwsuQWjpHRyhDckQ47no7k/LbIq+hoNR31MpMrj/14hlMmL0UHi+7KsnRXc8tyHPbqdSuU+eUyPgHIYtxGzT9yN5RY6NfI/Uv6wQLlVIErO9Ka9OYcVjoSnB+8/up/Bl31l20czVeup/kaD/644U09dnxw2qn62KoEHs0o7qW3pOE1a9MYQJ1A5QFiCZalFklpjdLodpsndyMOqx5pHCZrH65quAQkws2wKz772m80=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f2cfee4-1648-4281-4943-08d658806393
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2018 18:02:57.2291
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

Avoid handling configuration params wid command in deferred approach.
Instead of posting to workqueue now handle directly from the caller
context. Reduce the size of wid array from 32 to 4 as maximum only 4 wid
used at a time.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 95 +++++++++++----------------=
----
 1 file changed, 32 insertions(+), 63 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index f6bd76c..6b1c9e3 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -107,7 +107,6 @@ union message_body {
 	struct rcvd_net_info net_info;
 	struct rcvd_async_info async_info;
 	struct key_attr key_info;
-	struct cfg_param_attr cfg_info;
 	struct sta_inactive_t mac_info;
 	struct set_ip_addr ip_info;
 	struct drv_handler drv;
@@ -306,53 +305,6 @@ static void handle_get_mac_address(struct work_struct =
*work)
 	/* free 'msg' data later, in caller */
 }
=20
-static void handle_cfg_param(struct work_struct *work)
-{
-	struct host_if_msg *msg =3D container_of(work, struct host_if_msg, work);
-	struct wilc_vif *vif =3D msg->vif;
-	struct cfg_param_attr *param =3D &msg->body.cfg_info;
-	int ret;
-	struct wid wid_list[32];
-	int i =3D 0;
-
-	if (param->flag & WILC_CFG_PARAM_RETRY_SHORT) {
-		wid_list[i].id =3D WID_SHORT_RETRY_LIMIT;
-		wid_list[i].val =3D (s8 *)&param->short_retry_limit;
-		wid_list[i].type =3D WID_SHORT;
-		wid_list[i].size =3D sizeof(u16);
-		i++;
-	}
-	if (param->flag & WILC_CFG_PARAM_RETRY_LONG) {
-		wid_list[i].id =3D WID_LONG_RETRY_LIMIT;
-		wid_list[i].val =3D (s8 *)&param->long_retry_limit;
-		wid_list[i].type =3D WID_SHORT;
-		wid_list[i].size =3D sizeof(u16);
-		i++;
-	}
-	if (param->flag & WILC_CFG_PARAM_FRAG_THRESHOLD) {
-		wid_list[i].id =3D WID_FRAG_THRESHOLD;
-		wid_list[i].val =3D (s8 *)&param->frag_threshold;
-		wid_list[i].type =3D WID_SHORT;
-		wid_list[i].size =3D sizeof(u16);
-		i++;
-	}
-	if (param->flag & WILC_CFG_PARAM_RTS_THRESHOLD) {
-		wid_list[i].id =3D WID_RTS_THRESHOLD;
-		wid_list[i].val =3D (s8 *)&param->rts_threshold;
-		wid_list[i].type =3D WID_SHORT;
-		wid_list[i].size =3D sizeof(u16);
-		i++;
-	}
-
-	ret =3D wilc_send_config_pkt(vif, WILC_SET_CFG, wid_list,
-				   i, wilc_get_vif_idx(vif));
-
-	if (ret)
-		netdev_err(vif->ndev, "Error in setting CFG params\n");
-
-	kfree(msg);
-}
-
 static int handle_scan_done(struct wilc_vif *vif, enum scan_event evt)
 {
 	int result =3D 0;
@@ -2797,26 +2749,43 @@ int wilc_scan(struct wilc_vif *vif, u8 scan_source,=
 u8 scan_type,
 	return result;
 }
=20
-int wilc_hif_set_cfg(struct wilc_vif *vif,
-		     struct cfg_param_attr *cfg_param)
+int wilc_hif_set_cfg(struct wilc_vif *vif, struct cfg_param_attr *param)
 {
-	struct host_if_msg *msg;
-	struct host_if_drv *hif_drv =3D vif->hif_drv;
+	struct wid wid_list[4];
+	int i =3D 0;
 	int result;
=20
-	if (!hif_drv) {
-		netdev_err(vif->ndev, "%s: hif driver is NULL", __func__);
-		return -EFAULT;
+	if (param->flag & WILC_CFG_PARAM_RETRY_SHORT) {
+		wid_list[i].id =3D WID_SHORT_RETRY_LIMIT;
+		wid_list[i].val =3D (s8 *)&param->short_retry_limit;
+		wid_list[i].type =3D WID_SHORT;
+		wid_list[i].size =3D sizeof(u16);
+		i++;
+	}
+	if (param->flag & WILC_CFG_PARAM_RETRY_LONG) {
+		wid_list[i].id =3D WID_LONG_RETRY_LIMIT;
+		wid_list[i].val =3D (s8 *)&param->long_retry_limit;
+		wid_list[i].type =3D WID_SHORT;
+		wid_list[i].size =3D sizeof(u16);
+		i++;
+	}
+	if (param->flag & WILC_CFG_PARAM_FRAG_THRESHOLD) {
+		wid_list[i].id =3D WID_FRAG_THRESHOLD;
+		wid_list[i].val =3D (s8 *)&param->frag_threshold;
+		wid_list[i].type =3D WID_SHORT;
+		wid_list[i].size =3D sizeof(u16);
+		i++;
+	}
+	if (param->flag & WILC_CFG_PARAM_RTS_THRESHOLD) {
+		wid_list[i].id =3D WID_RTS_THRESHOLD;
+		wid_list[i].val =3D (s8 *)&param->rts_threshold;
+		wid_list[i].type =3D WID_SHORT;
+		wid_list[i].size =3D sizeof(u16);
+		i++;
 	}
=20
-	msg =3D wilc_alloc_work(vif, handle_cfg_param, false);
-	if (IS_ERR(msg))
-		return PTR_ERR(msg);
-
-	msg->body.cfg_info =3D *cfg_param;
-	result =3D wilc_enqueue_work(msg);
-	if (result)
-		kfree(msg);
+	result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, wid_list,
+				      i, wilc_get_vif_idx(vif));
=20
 	return result;
 }
--=20
2.7.4

