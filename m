Return-Path: <SRS0=RZRw=QM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B1D7C282CB
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 07:15:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 255B52081B
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 07:15:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="vFshcT2t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbfBEHPm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 5 Feb 2019 02:15:42 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:40017 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726696AbfBEHPm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Feb 2019 02:15:42 -0500
X-IronPort-AV: E=Sophos;i="5.56,562,1539673200"; 
   d="scan'208";a="25864240"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 05 Feb 2019 00:15:41 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.105) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Tue, 5 Feb 2019 00:15:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zm4WWu9iLF1SygaMCtEOYKQTAqihB7EFsgji56a0NRM=;
 b=vFshcT2t/ZKi1G/4jHa8qAZBV9rf+HG+y1obvkS64OXRVwjGwdZpIZbM1zSmO87cXJHW3/6FCZ2z4mcF3/zPSLLdiCUSHEVlLkKgX7Qg+vgq237J74/lz1Hk70yZfuOeWWeDe2HYflHX7e6a5lAdKGBTSXOlK4mTkwOdO/MszZ0=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2982.namprd11.prod.outlook.com (20.177.224.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.20; Tue, 5 Feb 2019 07:15:39 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1580.019; Tue, 5 Feb 2019
 07:15:39 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 03/12] staging: wilc1000: refactor code to use cookie
 information
Thread-Topic: [PATCH 03/12] staging: wilc1000: refactor code to use cookie
 information
Thread-Index: AQHUvSKYI9HKTZSjE0uTwgzCE2iHAQ==
Date:   Tue, 5 Feb 2019 07:15:39 +0000
Message-ID: <1549350913-645-4-git-send-email-ajay.kathat@microchip.com>
References: <1549350913-645-1-git-send-email-ajay.kathat@microchip.com>
In-Reply-To: <1549350913-645-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MAXPR0101CA0066.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::28) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.7.4
x-originating-ip: [183.82.17.42]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2982;6:S4N+vnH1CA2eGvZGRWQT9Tasrs/I3CAFyUvWexgvi3kQrEORBMjmcmxj28ROrG+DISCbuaM5Vdnsg/3UIcpqhSbWI8ZFZR3hQ1srn6O6bJSI3MfRjUwuEi+rt9QJCwgZz51gNmczWW6lmza3aJGEaGWQH9wc90l3vkFvLC9lzas4Q/vRTt94zQSU6ZKChY3vNEI5b5wrE+hEwZAMmYDNqpLwzTHUM7TyPLkIx2Vay4/8MvTUJ8gbAmAqAMPQLigoVSSsWd+TBS5Yy7Z/CL0U9Kd0cdwzjhuxE/No93+HKqqsGnzehSgNPvvhfkUc24Z+ezNP8GDFrsupPyfDE8TNxL367YDwM67TtO29V4drfeCccuJmRmi387xspJpbihwHa8Gzt3RE9clS++w51ltbPkyGPPmThNWDbo60aSf8jhmk2CTDPTq5KKZIfvX9eFPvhdYhCriiZLliasNOMiC3Yg==;5:FfrgZRbsn91eNn3h+IWvOVXMK6nqembtUpnNXqMPhYiBGJsqLhhW/PA4+GNA5jLuDoPcPNq0uRFsvftGQrq1jmkNro9RjQ78JiF1UHaATGKMxqqUIO8v/uAm3wYgbQO28r2bAyKof2kNbDM8kECJWGzD10jY8whcRCAx+LZ+ZtSW7AOYXfI6lyGN3cLdW0Q7vlmcB3AAKT4Emt92tyxGYg==;7:X27ix002OULVaCMFlEdt1y76PFTq7IoE+vXhxGm5pgDDcvz/JcZLwZdqdg5SLVjuzroYLGkAIDYqNscWfr0AzfWoSxoyfNDeb6KUochOq3GCbMZK5SUv2D2MpahZmVUkaIb6iuC4DkWPoS2Xc7dlbA==
x-ms-office365-filtering-correlation-id: 3985e61d-0235-485c-a1d1-08d68b39bab7
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2982;
x-ms-traffictypediagnostic: BYAPR11MB2982:
x-microsoft-antispam-prvs: <BYAPR11MB298292630D8C98F710341AD4E36E0@BYAPR11MB2982.namprd11.prod.outlook.com>
x-forefront-prvs: 0939529DE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39860400002)(346002)(376002)(366004)(396003)(189003)(199004)(478600001)(36756003)(305945005)(102836004)(6486002)(81156014)(76176011)(81166006)(71190400001)(5640700003)(6436002)(186003)(14454004)(99286004)(52116002)(11346002)(386003)(446003)(26005)(2616005)(476003)(256004)(8676002)(6512007)(14444005)(316002)(6506007)(2906002)(53936002)(54906003)(3846002)(4326008)(25786009)(2351001)(106356001)(6116002)(7736002)(486006)(86362001)(2501003)(68736007)(50226002)(66066001)(97736004)(107886003)(105586002)(72206003)(78486014)(71200400001)(8936002)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2982;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 1qkNddNWUz0+EC+WJ/CPAk+8uZBn4ddNhMQTPp4qd6b7+SzXo4/1M3rNOtJWZ+tTKa/C2FDQYEQm63EjODxwH3lQffD2DGLFyquMySBtwPWV420l4X61hemHEvQzfsqfD6j6CLR+vDloggKdRSLBeGWzr8payMd9yYwrE7P3hG1WR6jLLH7ifssfmEAwuANd/wtai1EdH9iY03D6mcMBblW21kTwjXlTnFCv08+LPfvNyvgsImn8w32QdEIT01zaZk5TuHiq91SgyvG1zYJoY87KbtdsyLY05Gq6/BA7tP8UpP9cNipFoKzrJGoy3mYf0W1t1d5V1WUgFwJa9ECKqVnLwKGdhSzT6PkrdxCKRDAKDwrPhoYP57LFAFP9jwK1A71WoEF1vPyyeJigQuz8KUUIDf0lx7g4gSdvP2omwtU=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3985e61d-0235-485c-a1d1-08d68b39bab7
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2019 07:15:34.9365
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2982
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Make use of cookie information to pass to wpa_s and handle cookie value
received in the cfg80211_ops callbacks.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c         | 72 +++++++------------=
----
 drivers/staging/wilc1000/host_interface.h         | 13 ++--
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 51 ++++++++--------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  2 +-
 4 files changed, 53 insertions(+), 85 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index 97bf747..115b6f25 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -920,40 +920,22 @@ static int handle_remain_on_chan(struct wilc_vif *vif=
,
 	struct wid wid;
 	struct host_if_drv *hif_drv =3D vif->hif_drv;
=20
-	if (!hif_drv->remain_on_ch_pending) {
-		hif_drv->remain_on_ch.arg =3D hif_remain_ch->arg;
-		hif_drv->remain_on_ch.expired =3D hif_remain_ch->expired;
-		hif_drv->remain_on_ch.ready =3D hif_remain_ch->ready;
-		hif_drv->remain_on_ch.ch =3D hif_remain_ch->ch;
-		hif_drv->remain_on_ch.id =3D hif_remain_ch->id;
-	} else {
-		hif_remain_ch->ch =3D hif_drv->remain_on_ch.ch;
-	}
+	if (hif_drv->usr_scan_req.scan_result)
+		return -EBUSY;
=20
-	if (hif_drv->usr_scan_req.scan_result) {
-		hif_drv->remain_on_ch_pending =3D 1;
-		result =3D -EBUSY;
-		goto error;
-	}
-	if (hif_drv->hif_state =3D=3D HOST_IF_WAITING_CONN_RESP) {
-		result =3D -EBUSY;
-		goto error;
-	}
+	if (hif_drv->hif_state =3D=3D HOST_IF_WAITING_CONN_RESP)
+		return -EBUSY;
=20
-	if (vif->obtaining_ip || vif->connecting) {
-		result =3D -EBUSY;
-		goto error;
-	}
+	if (vif->obtaining_ip || vif->connecting)
+		return -EBUSY;
=20
 	remain_on_chan_flag =3D true;
 	wid.id =3D WID_REMAIN_ON_CHAN;
 	wid.type =3D WID_STR;
 	wid.size =3D 2;
 	wid.val =3D kmalloc(wid.size, GFP_KERNEL);
-	if (!wid.val) {
-		result =3D -ENOMEM;
-		goto error;
-	}
+	if (!wid.val)
+		return -ENOMEM;
=20
 	wid.val[0] =3D remain_on_chan_flag;
 	wid.val[1] =3D (s8)hif_remain_ch->ch;
@@ -961,21 +943,16 @@ static int handle_remain_on_chan(struct wilc_vif *vif=
,
 	result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 	kfree(wid.val);
-	if (result !=3D 0)
-		netdev_err(vif->ndev, "Failed to set remain on channel\n");
+	if (result)
+		return -EBUSY;
=20
-error:
+	hif_drv->remain_on_ch.arg =3D hif_remain_ch->arg;
+	hif_drv->remain_on_ch.expired =3D hif_remain_ch->expired;
+	hif_drv->remain_on_ch.ch =3D hif_remain_ch->ch;
+	hif_drv->remain_on_ch.cookie =3D hif_remain_ch->cookie;
 	hif_drv->remain_on_ch_timer_vif =3D vif;
-	mod_timer(&hif_drv->remain_on_ch_timer,
-		  jiffies + msecs_to_jiffies(hif_remain_ch->duration));
-
-	if (hif_drv->remain_on_ch.ready)
-		hif_drv->remain_on_ch.ready(hif_drv->remain_on_ch.arg);
=20
-	if (hif_drv->remain_on_ch_pending)
-		hif_drv->remain_on_ch_pending =3D 0;
-
-	return result;
+	return 0;
 }
=20
 static void handle_listen_state_expired(struct work_struct *work)
@@ -1012,7 +989,7 @@ static void handle_listen_state_expired(struct work_st=
ruct *work)
=20
 		if (hif_drv->remain_on_ch.expired) {
 			hif_drv->remain_on_ch.expired(hif_drv->remain_on_ch.arg,
-						      hif_remain_ch->id);
+						      hif_remain_ch->cookie);
 		}
 	} else {
 		netdev_dbg(vif->ndev, "Not in listen state\n");
@@ -1036,7 +1013,7 @@ static void listen_timer_cb(struct timer_list *t)
 	if (IS_ERR(msg))
 		return;
=20
-	msg->body.remain_on_ch.id =3D vif->hif_drv->remain_on_ch.id;
+	msg->body.remain_on_ch.cookie =3D vif->hif_drv->remain_on_ch.cookie;
=20
 	result =3D wilc_enqueue_work(msg);
 	if (result) {
@@ -1102,9 +1079,6 @@ static void handle_scan_complete(struct work_struct *=
work)
=20
 	handle_scan_done(msg->vif, SCAN_EVENT_DONE);
=20
-	if (msg->vif->hif_drv->remain_on_ch_pending)
-		handle_remain_on_chan(msg->vif,
-				      &msg->vif->hif_drv->remain_on_ch);
 	kfree(msg);
 }
=20
@@ -1842,10 +1816,9 @@ void wilc_scan_complete_received(struct wilc *wilc, =
u8 *buffer, u32 length)
 	}
 }
=20
-int wilc_remain_on_channel(struct wilc_vif *vif, u32 session_id,
+int wilc_remain_on_channel(struct wilc_vif *vif, u64 cookie,
 			   u32 duration, u16 chan,
-			   void (*expired)(void *, u32),
-			   void (*ready)(void *),
+			   void (*expired)(void *, u64),
 			   void *user_arg)
 {
 	struct remain_ch roc;
@@ -1853,10 +1826,9 @@ int wilc_remain_on_channel(struct wilc_vif *vif, u32=
 session_id,
=20
 	roc.ch =3D chan;
 	roc.expired =3D expired;
-	roc.ready =3D ready;
 	roc.arg =3D user_arg;
 	roc.duration =3D duration;
-	roc.id =3D session_id;
+	roc.cookie =3D cookie;
 	result =3D handle_remain_on_chan(vif, &roc);
 	if (result)
 		netdev_err(vif->ndev, "%s: failed to set remain on channel\n",
@@ -1865,7 +1837,7 @@ int wilc_remain_on_channel(struct wilc_vif *vif, u32 =
session_id,
 	return result;
 }
=20
-int wilc_listen_state_expired(struct wilc_vif *vif, u32 session_id)
+int wilc_listen_state_expired(struct wilc_vif *vif, u64 cookie)
 {
 	int result;
 	struct host_if_msg *msg;
@@ -1882,7 +1854,7 @@ int wilc_listen_state_expired(struct wilc_vif *vif, u=
32 session_id)
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
=20
-	msg->body.remain_on_ch.id =3D session_id;
+	msg->body.remain_on_ch.cookie =3D cookie;
=20
 	result =3D wilc_enqueue_work(msg);
 	if (result) {
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wi=
lc1000/host_interface.h
index 0feb63f..994e641 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -140,10 +140,9 @@ struct wilc_conn_info {
 struct remain_ch {
 	u16 ch;
 	u32 duration;
-	void (*expired)(void *priv, u32 session_id);
-	void (*ready)(void *priv);
+	void (*expired)(void *priv, u64 cookie);
 	void *arg;
-	u32 id;
+	u32 cookie;
 };
=20
 struct wilc;
@@ -151,7 +150,6 @@ struct host_if_drv {
 	struct user_scan_req usr_scan_req;
 	struct wilc_conn_info conn_info;
 	struct remain_ch remain_on_ch;
-	u8 remain_on_ch_pending;
 	u64 p2p_timeout;
=20
 	enum host_if_state hif_state;
@@ -227,12 +225,11 @@ int wilc_edit_station(struct wilc_vif *vif, const u8 =
*mac,
 int wilc_set_power_mgmt(struct wilc_vif *vif, bool enabled, u32 timeout);
 int wilc_setup_multicast_filter(struct wilc_vif *vif, u32 enabled, u32 cou=
nt,
 				u8 *mc_list);
-int wilc_remain_on_channel(struct wilc_vif *vif, u32 session_id,
+int wilc_remain_on_channel(struct wilc_vif *vif, u64 cookie,
 			   u32 duration, u16 chan,
-			   void (*expired)(void *, u32),
-			   void (*ready)(void *),
+			   void (*expired)(void *, u64),
 			   void *user_arg);
-int wilc_listen_state_expired(struct wilc_vif *vif, u32 session_id);
+int wilc_listen_state_expired(struct wilc_vif *vif, u64 cookie);
 void wilc_frame_register(struct wilc_vif *vif, u16 frame_type, bool reg);
 int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index, u8 mode,
 			     u8 ifc_id);
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/st=
aging/wilc1000/wilc_wfi_cfgoperations.c
index 08b60ddd..f719b74 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1119,27 +1119,12 @@ static void wilc_wfi_mgmt_tx_complete(void *priv, i=
nt status)
 	kfree(pv_data);
 }
=20
-static void wilc_wfi_remain_on_channel_ready(void *priv_data)
-{
-	struct wilc_priv *priv;
-
-	priv =3D priv_data;
-
-	priv->p2p_listen_state =3D true;
-
-	cfg80211_ready_on_channel(priv->wdev,
-				  priv->remain_on_ch_params.listen_cookie,
-				  priv->remain_on_ch_params.listen_ch,
-				  priv->remain_on_ch_params.listen_duration,
-				  GFP_KERNEL);
-}
-
-static void wilc_wfi_remain_on_channel_expired(void *data, u32 session_id)
+static void wilc_wfi_remain_on_channel_expired(void *data, u64 cookie)
 {
 	struct wilc_priv *priv =3D data;
 	struct wilc_wfi_p2p_listen_params *params =3D &priv->remain_on_ch_params;
=20
-	if (session_id !=3D params->listen_session_id)
+	if (cookie !=3D params->listen_cookie)
 		return;
=20
 	priv->p2p_listen_state =3D false;
@@ -1156,24 +1141,36 @@ static int remain_on_channel(struct wiphy *wiphy,
 	int ret =3D 0;
 	struct wilc_priv *priv =3D wiphy_priv(wiphy);
 	struct wilc_vif *vif =3D netdev_priv(priv->dev);
+	u64 id;
=20
 	if (wdev->iftype =3D=3D NL80211_IFTYPE_AP) {
 		netdev_dbg(vif->ndev, "Required while in AP mode\n");
 		return ret;
 	}
=20
+	id =3D ++priv->inc_roc_cookie;
+	if (id =3D=3D 0)
+		id =3D ++priv->inc_roc_cookie;
+
+	ret =3D wilc_remain_on_channel(vif, id, duration, chan->hw_value,
+				     wilc_wfi_remain_on_channel_expired,
+				     (void *)priv);
+	if (ret)
+		return ret;
+
 	curr_channel =3D chan->hw_value;
=20
 	priv->remain_on_ch_params.listen_ch =3D chan;
-	priv->remain_on_ch_params.listen_cookie =3D *cookie;
+	priv->remain_on_ch_params.listen_cookie =3D id;
+	*cookie =3D id;
+	priv->p2p_listen_state =3D true;
 	priv->remain_on_ch_params.listen_duration =3D duration;
-	priv->remain_on_ch_params.listen_session_id++;
=20
-	return wilc_remain_on_channel(vif,
-				priv->remain_on_ch_params.listen_session_id,
-				duration, chan->hw_value,
-				wilc_wfi_remain_on_channel_expired,
-				wilc_wfi_remain_on_channel_ready, (void *)priv);
+	cfg80211_ready_on_channel(wdev, *cookie, chan, duration, GFP_KERNEL);
+	mod_timer(&vif->hif_drv->remain_on_ch_timer,
+		  jiffies + msecs_to_jiffies(duration));
+
+	return ret;
 }
=20
 static int cancel_remain_on_channel(struct wiphy *wiphy,
@@ -1183,8 +1180,10 @@ static int cancel_remain_on_channel(struct wiphy *wi=
phy,
 	struct wilc_priv *priv =3D wiphy_priv(wiphy);
 	struct wilc_vif *vif =3D netdev_priv(priv->dev);
=20
-	return wilc_listen_state_expired(vif,
-			priv->remain_on_ch_params.listen_session_id);
+	if (cookie !=3D priv->remain_on_ch_params.listen_cookie)
+		return -ENOENT;
+
+	return wilc_listen_state_expired(vif, cookie);
 }
=20
 static void wilc_wfi_cfg_tx_vendor_spec(struct wilc_priv *priv,
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/stagin=
g/wilc1000/wilc_wfi_netdevice.h
index cc06ef9..a06b0c0 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -65,7 +65,6 @@ struct wilc_wfi_p2p_listen_params {
 	struct ieee80211_channel *listen_ch;
 	u32 listen_duration;
 	u64 listen_cookie;
-	u32 listen_session_id;
 };
=20
 struct wilc_p2p_var {
@@ -161,6 +160,7 @@ struct wilc_priv {
 	struct ieee80211_rate bitrates[ARRAY_SIZE(wilc_bitrates)];
 	struct ieee80211_supported_band band;
 	u32 cipher_suites[ARRAY_SIZE(wilc_cipher_suites)];
+	u64 inc_roc_cookie;
 };
=20
 struct frame_reg {
--=20
2.7.4

