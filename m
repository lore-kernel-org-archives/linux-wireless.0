Return-Path: <SRS0=z7UY=PZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86A47C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 13:21:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4859520652
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 13:21:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="XYcJgToK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbfAQNV0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 17 Jan 2019 08:21:26 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:44173 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfAQNV0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Jan 2019 08:21:26 -0500
X-IronPort-AV: E=Sophos;i="5.56,489,1539673200"; 
   d="scan'208";a="22718462"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 17 Jan 2019 06:21:23 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.38) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 17 Jan 2019 06:21:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HAqm2ew4XKEE2l60dmQTWNLhbuIqFvIvLJ85ypFBKDo=;
 b=XYcJgToKg53unl3j/zveIk+t6RZxoNhxflRQNIWLDIRVjdkazbv1pbuW/s5NK4R9gnDouNN/SxGvWjhoreAVGu1buWOiGIMDJDxj3sMf1wp0RyfG8r+KIjR+hn3eyRHZfL680IGOWrbfJ+EBiRsariRZ2/RvRc94IjnXNywzheo=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3464.namprd11.prod.outlook.com (20.177.187.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.26; Thu, 17 Jan 2019 13:21:21 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::c110:8559:a438:491d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::c110:8559:a438:491d%3]) with mapi id 15.20.1516.019; Thu, 17 Jan 2019
 13:21:21 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 05/13] staging: wilc1000: make use of
 cfg80211_inform_bss_frame()
Thread-Topic: [PATCH 05/13] staging: wilc1000: make use of
 cfg80211_inform_bss_frame()
Thread-Index: AQHUrmeJu5F/5nWsj0azrOS1sfGYMw==
Date:   Thu, 17 Jan 2019 13:21:21 +0000
Message-ID: <1547731250-18518-6-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3464;6:q2kRx9oW1MwOV7g0pWSKdEdWi+yNdsZdShPLgtf3gK9oQTts0/ULOnqTysfHEuWK89vXz1XMzomUYUJwuwihWXkEB4wduMqBAZ3vGrFeUxk53NmnwtLe8X3cbMobOkcs9XR0+EcSzXx3LynGNatAm0tPy8VpUNrQzAKjaIC70P+zjViwTSntptiT0khyUMY8rc8llRdXB5pvcExyUEm3VEaq9V8traza7LNFYuoMSFvGJiyJCnqu+nGO/131AbIPkyxKia9ZQVmxbh/0HHoMgxd9HBF4JtmGVaOpWf4qTRfQZcUMKVv6F3yroiEXMhEzaYPQPGbQxIsnr3/EP/CfwMHuEera1jkSbSSXc54dOHQYbrFHWqpROZiN9Xp8ZqgyE+uJ9KSZiB/+wbfY98dOnc+NXz3NvmKD8jDvjIilAvEzXIUScsbnf2rqBFGMvpPoCYtpLgB/Ru1I+0ghYpwx/Q==;5:DqqKY9UFEFj4cjlSt+OBMP7eaLmXUBsi8OPR1b7vw4kzTGLxZAxfYtXC8b8MKH+IXUWNEUUjjHg+68jFwVrF0sgJRCJwTsPbnPtLlOdHowygH8cKCqScZXmKy7qc5qF0oJ9MO1+2JoufSi9CqaocGi0jdBlRH7z5FlpOH/p5PnqaZtQ4fMHD5v9ru40eSM0HgT0Gf0/5u3DrVtZqwQu9uw==;7:H7J6vZmG63/izzDxM5O9sqOhkzMDAgy0B6eef03jlxFHXc1tcIWXzb8AhlXJ39Z26Avc8ny5QxcjOqlcH+iHe+BMi5YmNtDNY6OeVTRX1PbatJSAb0SBmSEWxV2C0hK0h19o4TvD8O3Gl0X3TuHYtA==
x-ms-office365-filtering-correlation-id: 1765b750-f76f-4ddb-06c8-08d67c7eabcb
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3464;
x-ms-traffictypediagnostic: BYAPR11MB3464:
x-microsoft-antispam-prvs: <BYAPR11MB346468E5411D66B54E24FB30E3830@BYAPR11MB3464.namprd11.prod.outlook.com>
x-forefront-prvs: 0920602B08
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(366004)(136003)(39860400002)(376002)(396003)(199004)(189003)(14454004)(68736007)(81166006)(81156014)(5660300001)(8936002)(2906002)(106356001)(8676002)(26005)(305945005)(7736002)(6486002)(6436002)(5640700003)(36756003)(86362001)(99286004)(478600001)(6916009)(50226002)(72206003)(78486014)(76176011)(2501003)(66066001)(4326008)(97736004)(486006)(25786009)(6506007)(476003)(102836004)(14444005)(256004)(386003)(53936002)(2616005)(54906003)(6512007)(71190400001)(71200400001)(105586002)(107886003)(3846002)(52116002)(186003)(2351001)(6116002)(316002)(11346002)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3464;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: jOPdvOH32Z9gxL6Q8JjolShrCKorJc0FJwtY3BZyzHFZo4KHPhDdYcl5v/bHE/lcxp9XG7IBtiADpin6uqs+KLRG9EALoZotF0iubg7mPshMsM6LqtD4bzFsiwjB0BQSaNOq8jGLdhZ8HYlArTBPq4oLvnNknnvxGKQ9a0O6F6eV8fLCdBSt/beWGXgCE2ZTiTwE/lmxn+ZsvtciFdhI8OmUMEsKaUfkgInulg9y3xKQcGuisLTePlYsKuwq1/CEoRdlIP2aaRjaRWrZq3fMRNzfQ+1c3Z5Zf3Dd/WG7dLJLkIxVs/jH1dtYg7GFW8941yb4IH0nCWrIktvi1J9JOQpj9K3T2FboLxov+6UXDIW+hu73qGThym+S1kO1hh2TsvqKcRDHZVleSFpZkxmD4w4EfVn8kcgMJJFLGWfVAAI=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1765b750-f76f-4ddb-06c8-08d67c7eabcb
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2019 13:21:18.8171
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

Use cfg80211_inform_bss_frame() api instead of cfg80211_inform_bss() to
inform cfg80211 about the BSS frame, to avoid unnecessary parsing of
frame in driver.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c         | 144 +++++-------------=
----
 drivers/staging/wilc1000/host_interface.h         |  14 ++-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  42 +++----
 3 files changed, 50 insertions(+), 150 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index e7f8fab..68f58d1 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -72,7 +72,7 @@ struct wilc_gtk_key {
 } __packed;
=20
 union message_body {
-	struct rcvd_net_info net_info;
+	struct wilc_rcvd_net_info net_info;
 	struct rcvd_async_info async_info;
 	struct set_multicast multicast_info;
 	struct remain_ch remain_on_ch;
@@ -743,129 +743,38 @@ void *wilc_parse_join_bss_param(struct cfg80211_bss =
*bss)
 	return (void *)param;
 }
=20
-static inline u8 *get_bssid(struct ieee80211_mgmt *mgmt)
-{
-	if (ieee80211_has_fromds(mgmt->frame_control))
-		return mgmt->sa;
-	else if (ieee80211_has_tods(mgmt->frame_control))
-		return mgmt->da;
-	else
-		return mgmt->bssid;
-}
-
-static s32 wilc_parse_network_info(u8 *msg_buffer,
-				   struct network_info **ret_network_info)
+static void handle_rcvd_ntwrk_info(struct work_struct *work)
 {
-	struct network_info *info;
-	struct ieee80211_mgmt *mgt;
-	u8 *wid_val, *ies;
-	u16 wid_len, rx_len, ies_len;
-	u8 msg_type;
+	struct host_if_msg *msg =3D container_of(work, struct host_if_msg, work);
+	struct wilc_rcvd_net_info *rcvd_info =3D &msg->body.net_info;
+	struct user_scan_req *scan_req =3D &msg->vif->hif_drv->usr_scan_req;
+	const u8 *ch_elm;
+	u8 *ies;
+	int ies_len;
 	size_t offset;
-	const u8 *ch_elm, *tim_elm, *ssid_elm;
-
-	msg_type =3D msg_buffer[0];
-	if ('N' !=3D msg_type)
-		return -EFAULT;
-
-	wid_len =3D get_unaligned_le16(&msg_buffer[6]);
-	wid_val =3D &msg_buffer[8];
-
-	info =3D kzalloc(sizeof(*info), GFP_KERNEL);
-	if (!info)
-		return -ENOMEM;
=20
-	info->rssi =3D wid_val[0];
-
-	mgt =3D (struct ieee80211_mgmt *)&wid_val[1];
-	rx_len =3D wid_len - 1;
-
-	if (ieee80211_is_probe_resp(mgt->frame_control)) {
-		info->cap_info =3D le16_to_cpu(mgt->u.probe_resp.capab_info);
-		info->beacon_period =3D le16_to_cpu(mgt->u.probe_resp.beacon_int);
-		info->tsf =3D le64_to_cpu(mgt->u.probe_resp.timestamp);
-		info->tsf_lo =3D (u32)info->tsf;
+	if (ieee80211_is_probe_resp(rcvd_info->mgmt->frame_control))
 		offset =3D offsetof(struct ieee80211_mgmt, u.probe_resp.variable);
-	} else if (ieee80211_is_beacon(mgt->frame_control)) {
-		info->cap_info =3D le16_to_cpu(mgt->u.beacon.capab_info);
-		info->beacon_period =3D le16_to_cpu(mgt->u.beacon.beacon_int);
-		info->tsf =3D le64_to_cpu(mgt->u.beacon.timestamp);
-		info->tsf_lo =3D (u32)info->tsf;
+	else if (ieee80211_is_beacon(rcvd_info->mgmt->frame_control))
 		offset =3D offsetof(struct ieee80211_mgmt, u.beacon.variable);
-	} else {
-		/* only process probe response and beacon frame */
-		kfree(info);
-		return -EIO;
-	}
-
-	ether_addr_copy(info->bssid, get_bssid(mgt));
-
-	ies =3D mgt->u.beacon.variable;
-	ies_len =3D rx_len - offset;
-	if (ies_len <=3D 0) {
-		kfree(info);
-		return -EIO;
-	}
-
-	info->ies =3D kmemdup(ies, ies_len, GFP_KERNEL);
-	if (!info->ies) {
-		kfree(info);
-		return -ENOMEM;
-	}
-
-	info->ies_len =3D ies_len;
+	else
+		goto done;
=20
-	ssid_elm =3D cfg80211_find_ie(WLAN_EID_SSID, ies, ies_len);
-	if (ssid_elm) {
-		info->ssid_len =3D ssid_elm[1];
-		if (info->ssid_len <=3D IEEE80211_MAX_SSID_LEN)
-			memcpy(info->ssid, ssid_elm + 2, info->ssid_len);
-		else
-			info->ssid_len =3D 0;
-	}
+	ies =3D rcvd_info->mgmt->u.beacon.variable;
+	ies_len =3D rcvd_info->frame_len - offset;
+	if (ies_len <=3D 0)
+		goto done;
=20
 	ch_elm =3D cfg80211_find_ie(WLAN_EID_DS_PARAMS, ies, ies_len);
 	if (ch_elm && ch_elm[1] > 0)
-		info->ch =3D ch_elm[2];
-
-	tim_elm =3D cfg80211_find_ie(WLAN_EID_TIM, ies, ies_len);
-	if (tim_elm && tim_elm[1] >=3D 2)
-		info->dtim_period =3D tim_elm[3];
-
-	*ret_network_info =3D info;
-
-	return 0;
-}
-
-static void handle_rcvd_ntwrk_info(struct work_struct *work)
-{
-	struct host_if_msg *msg =3D container_of(work, struct host_if_msg, work);
-	struct wilc_vif *vif =3D msg->vif;
-	struct rcvd_net_info *rcvd_info =3D &msg->body.net_info;
-	struct network_info *info =3D NULL;
-	struct user_scan_req *scan_req =3D &vif->hif_drv->usr_scan_req;
-
-	if (!scan_req->scan_result)
-		goto done;
+		rcvd_info->ch =3D ch_elm[2];
=20
-	wilc_parse_network_info(rcvd_info->buffer, &info);
-	if (!info) {
-		netdev_err(vif->ndev, "%s: info is NULL\n",
-			   __func__);
-		goto done;
-	}
-
-	scan_req->scan_result(SCAN_EVENT_NETWORK_FOUND, info, scan_req->arg);
+	if (scan_req->scan_result)
+		scan_req->scan_result(SCAN_EVENT_NETWORK_FOUND, rcvd_info,
+				      scan_req->arg);
=20
 done:
-	kfree(rcvd_info->buffer);
-	rcvd_info->buffer =3D NULL;
-
-	if (info) {
-		kfree(info->ies);
-		kfree(info);
-	}
-
+	kfree(rcvd_info->mgmt);
 	kfree(msg);
 }
=20
@@ -2143,9 +2052,12 @@ void wilc_network_info_received(struct wilc *wilc, u=
8 *buffer, u32 length)
 	if (IS_ERR(msg))
 		return;
=20
-	msg->body.net_info.len =3D length;
-	msg->body.net_info.buffer =3D kmemdup(buffer, length, GFP_KERNEL);
-	if (!msg->body.net_info.buffer) {
+	msg->body.net_info.frame_len =3D get_unaligned_le16(&buffer[6]) - 1;
+	msg->body.net_info.rssi =3D buffer[8];
+	msg->body.net_info.mgmt =3D kmemdup(&buffer[9],
+					  msg->body.net_info.frame_len,
+					  GFP_KERNEL);
+	if (!msg->body.net_info.mgmt) {
 		kfree(msg);
 		return;
 	}
@@ -2153,7 +2065,7 @@ void wilc_network_info_received(struct wilc *wilc, u8=
 *buffer, u32 length)
 	result =3D wilc_enqueue_work(msg);
 	if (result) {
 		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
-		kfree(msg->body.net_info.buffer);
+		kfree(msg->body.net_info.mgmt);
 		kfree(msg);
 	}
 }
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wi=
lc1000/host_interface.h
index 6a09a52..76da172 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -127,7 +127,14 @@ enum conn_event {
 	CONN_DISCONN_EVENT_FORCE_32BIT		=3D 0xFFFFFFFF
 };
=20
-typedef void (*wilc_scan_result)(enum scan_event, struct network_info *,
+struct wilc_rcvd_net_info {
+	s8 rssi;
+	u8 ch;
+	u16 frame_len;
+	struct ieee80211_mgmt *mgmt;
+};
+
+typedef void (*wilc_scan_result)(enum scan_event, struct wilc_rcvd_net_inf=
o *,
 				 void *);
=20
 typedef void (*wilc_connect_result)(enum conn_event,
@@ -139,11 +146,6 @@ typedef void (*wilc_connect_result)(enum conn_event,
 typedef void (*wilc_remain_on_chan_expired)(void *, u32);
 typedef void (*wilc_remain_on_chan_ready)(void *);
=20
-struct rcvd_net_info {
-	u8 *buffer;
-	u32 len;
-};
-
 struct hidden_net_info {
 	u8  *ssid;
 	u8 ssid_len;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/st=
aging/wilc1000/wilc_wfi_cfgoperations.c
index 381dfd8..5da03bb 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -82,48 +82,34 @@ static void clear_during_ip(struct timer_list *t)
 }
=20
 static void cfg_scan_result(enum scan_event scan_event,
-			    struct network_info *network_info,
-			    void *user_void)
+			    struct wilc_rcvd_net_info *info, void *user_void)
 {
-	struct wilc_priv *priv;
-	struct wiphy *wiphy;
-	s32 freq;
-	struct ieee80211_channel *channel;
-	struct cfg80211_bss *bss;
+	struct wilc_priv *priv =3D user_void;
=20
-	priv =3D user_void;
 	if (!priv->cfg_scanning)
 		return;
=20
 	if (scan_event =3D=3D SCAN_EVENT_NETWORK_FOUND) {
-		wiphy =3D priv->dev->ieee80211_ptr->wiphy;
-
-		if (!wiphy || !network_info)
-			return;
+		s32 freq;
+		struct ieee80211_channel *channel;
+		struct cfg80211_bss *bss;
+		struct wiphy *wiphy =3D priv->dev->ieee80211_ptr->wiphy;
=20
-		if (wiphy->signal_type =3D=3D CFG80211_SIGNAL_TYPE_UNSPEC &&
-		    (((s32)network_info->rssi * 100) < 0 ||
-		    ((s32)network_info->rssi * 100) > 100))
+		if (!wiphy || !info)
 			return;
=20
-		freq =3D ieee80211_channel_to_frequency((s32)network_info->ch,
+		freq =3D ieee80211_channel_to_frequency((s32)info->ch,
 						      NL80211_BAND_2GHZ);
 		channel =3D ieee80211_get_channel(wiphy, freq);
 		if (!channel)
 			return;
=20
-		bss =3D cfg80211_inform_bss(wiphy,
-					  channel,
-					  CFG80211_BSS_FTYPE_UNKNOWN,
-					  network_info->bssid,
-					  network_info->tsf,
-					  network_info->cap_info,
-					  network_info->beacon_period,
-					  (const u8 *)network_info->ies,
-					  (size_t)network_info->ies_len,
-					  (s32)network_info->rssi * 100,
-					  GFP_KERNEL);
-		cfg80211_put_bss(wiphy, bss);
+		bss =3D cfg80211_inform_bss_frame(wiphy, channel, info->mgmt,
+						info->frame_len,
+						(s32)info->rssi * 100,
+						GFP_KERNEL);
+		if (!bss)
+			cfg80211_put_bss(wiphy, bss);
 	} else if (scan_event =3D=3D SCAN_EVENT_DONE) {
 		mutex_lock(&priv->scan_req_lock);
=20
--=20
2.7.4

