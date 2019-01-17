Return-Path: <SRS0=z7UY=PZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 165C2C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 13:21:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF1E020652
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 13:21:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="EWKtZPiv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727488AbfAQNVX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 17 Jan 2019 08:21:23 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:44173 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfAQNVW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Jan 2019 08:21:22 -0500
X-IronPort-AV: E=Sophos;i="5.56,489,1539673200"; 
   d="scan'208";a="22718460"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES128-SHA; 17 Jan 2019 06:21:21 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.37) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 17 Jan 2019 06:21:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3nnjlxEPuGgYVKUvPNJRIBTFG+EA8L4VIxiIorG0Yww=;
 b=EWKtZPivz5IJNIR3ZkJq3hgsrd9vAT3gXZYtBX9kYKKojRRSLJA4eXopDarF8d+f1GG+lZuW2+VZ3Xf6LK3ePgB+3lN/1/EzT7kqA3TP6H4Kat+BI+p4er2M11PAhoffg+SXwaotjOeJyDcGNR6JHxMrnBst/kY4rzfx7Mfj3Zc=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3464.namprd11.prod.outlook.com (20.177.187.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.26; Thu, 17 Jan 2019 13:21:18 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::c110:8559:a438:491d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::c110:8559:a438:491d%3]) with mapi id 15.20.1516.019; Thu, 17 Jan 2019
 13:21:18 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 04/13] staging: wilc1000: remove the use of scan shadow buffer
Thread-Topic: [PATCH 04/13] staging: wilc1000: remove the use of scan shadow
 buffer
Thread-Index: AQHUrmeH3W/rhk6ZG0yty+NGF3xkMg==
Date:   Thu, 17 Jan 2019 13:21:18 +0000
Message-ID: <1547731250-18518-5-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3464;6:jdybL8Z5r1tLb8zq4ifTSUvAbANjNyqB11BTngpYIgygzRZQmWg0a9FlylD/yLk9X2lLEoSZuowH3dYH2W/qBnGw6NhWRidRwPuQRMgnZzO4UhORd202cZm1XtkHAFtPvhjGt56cWEe/BnxwWAv48IpJHre1cmQnRvwlqPhHr0FSHCf8oSf9UA/OpyL5RHxA78aKkaeQF3ohxg9vHZDs55j5Zz9oZLtOkm/WSWhm2NoirAzGqz4S8RI+2xYAtKHGoeX8vqldzccQxsbBIdmDT1CCS+fW3NgDLaiLy5PLBqOi/FjC2CpJTVlhyjOEbA0/MZOhVvkQ0n31vuZ9dAwTuir0GwRNn4CyxphHVSO+b5jBL34bBSZHwfBq7eYr2jk3flSLsixNSu7xD4ezlNbo6HlFcgB0+6Yb7bTmppwvo8N3uvfmkeQ0Nssy8p2ijVaseKMQmJVYQdvPPEvzBPJpMw==;5:e4JRbFkKhu/1dVDCDT1Wqmfu2pO4wvv+xn42jHQ7y+dY+YuySQ98rkpH/BCcD9gKn3zC20yWOzp9MFgwZt7Ovtyxp7FuwuAfVCJwimFMtlgQWjof9S1Iih0Sx4kpLs5Khs6NZopHN5JLiLHljNYEFaZPKK/GzHi7ZOGd/EeFEiqBQlgY9SpUsYsrZi188UMF5ixh/I4A18J9mpTowmHZag==;7:BIpIIYHiaIGH/8c0xT3RbQvi3Zem3iEiqNj2HqecIct2x/55hSIp1B7flBzY4DXeS33i2mP9Y0SNtxfU0sbxbHDa/Bfij7vw1zb3wo1oG0sRfOq9vJJUQ1Gb2z8JfD8dwre7CPD5SlgTo3Z158UAEQ==
x-ms-office365-filtering-correlation-id: 0b5e6f22-977a-4c3c-ecd1-08d67c7eaa02
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3464;
x-ms-traffictypediagnostic: BYAPR11MB3464:
x-microsoft-antispam-prvs: <BYAPR11MB346417CC713B996EE9673444E3830@BYAPR11MB3464.namprd11.prod.outlook.com>
x-forefront-prvs: 0920602B08
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(366004)(136003)(39860400002)(376002)(396003)(199004)(189003)(14454004)(68736007)(81166006)(81156014)(5660300001)(8936002)(2906002)(53946003)(106356001)(8676002)(26005)(305945005)(7736002)(6486002)(6436002)(5640700003)(36756003)(86362001)(99286004)(478600001)(6916009)(30864003)(50226002)(72206003)(78486014)(76176011)(2501003)(66066001)(4326008)(97736004)(486006)(25786009)(6506007)(476003)(102836004)(14444005)(256004)(386003)(53936002)(2616005)(54906003)(6512007)(71190400001)(71200400001)(105586002)(107886003)(3846002)(52116002)(186003)(2351001)(6116002)(316002)(11346002)(446003)(579004);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3464;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 1J3715w8Fla5CTvoPGfVqVkrpyKET9I5rlYa/TxRbudQWj1sleZ/PAj3xUJ/6kV5dzw+nYJnTuNEIugxEhX6V1VScaYjKcn6a28G+LVVwVlFFUjXXW4F+eytAnzTeQVFjCH8p+70af6dqTKgrsxaqeCv4c/Mgi1mtyixmLNS1OMnedCRVXPYRIkcsUqb/Fqu9zhihMlaEH/w/+9bLcyyY55hyIyuOaoPXfQyfJyjDdw4QVu+SeGkseaIMf5qOL4d06w1muq4ntPmx/Z79XfCusckoZ3HROsJkt3fpBT3yqGwkPlTABZ/rg1O6EkYGmWEWbKcdzbN69fMgea+QayxqOKYJmg7MGQnPVVn18oZpsmUM/zJ49L58bzdbUwJoKaTOSXQuBu/n3f8fM6wZbp1wYf2pqcV8zdwZyAJh0GkXO0=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b5e6f22-977a-4c3c-ecd1-08d67c7eaa02
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2019 13:21:16.0872
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

Remove scan shadow buffer, which is used to store a copy of scan
results. Instead, use cfg80211 provided API's to retrieve required
info. Remove the helper functions which are operating on shadow buffer,
as it's not require now.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c         |  94 ++----
 drivers/staging/wilc1000/host_interface.h         |  24 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 359 +++---------------=
----
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |   3 -
 4 files changed, 86 insertions(+), 394 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index a718842..e7f8fab 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -210,7 +210,7 @@ static int handle_scan_done(struct wilc_vif *vif, enum =
scan_event evt)
=20
 	scan_req =3D &hif_drv->usr_scan_req;
 	if (scan_req->scan_result) {
-		scan_req->scan_result(evt, NULL, scan_req->arg, NULL);
+		scan_req->scan_result(evt, NULL, scan_req->arg);
 		scan_req->scan_result =3D NULL;
 	}
=20
@@ -564,10 +564,10 @@ static void handle_connect_timeout(struct work_struct=
 *work)
 	kfree(msg);
 }
=20
-static void host_int_fill_join_bss_param(struct join_bss_param *param, u8 =
*ies,
-					 u16 *out_index, u8 *pcipher_tc,
-					 u8 *auth_total_cnt, u32 tsf_lo,
-					 u8 *rates_no)
+static void host_int_fill_join_bss_param(struct join_bss_param *param,
+					 const u8 *ies, u16 *out_index,
+					 u8 *pcipher_tc, u8 *auth_total_cnt,
+					 u32 tsf_lo, u8 *rates_no)
 {
 	u8 ext_rates_no;
 	u16 offset;
@@ -700,31 +700,44 @@ static void host_int_fill_join_bss_param(struct join_=
bss_param *param, u8 *ies,
 	*out_index =3D index;
 }
=20
-static void *host_int_parse_join_bss_param(struct network_info *info)
+void *wilc_parse_join_bss_param(struct cfg80211_bss *bss)
 {
 	struct join_bss_param *param;
 	u16 index =3D 0;
 	u8 rates_no =3D 0;
 	u8 pcipher_total_cnt =3D 0;
 	u8 auth_total_cnt =3D 0;
+	const u8 *tim_elm, *ssid_elm;
+	const struct cfg80211_bss_ies *ies =3D bss->ies;
=20
 	param =3D kzalloc(sizeof(*param), GFP_KERNEL);
 	if (!param)
 		return NULL;
=20
-	param->dtim_period =3D info->dtim_period;
-	param->beacon_period =3D info->beacon_period;
-	param->cap_info =3D info->cap_info;
-	memcpy(param->bssid, info->bssid, 6);
-	memcpy((u8 *)param->ssid, info->ssid, info->ssid_len + 1);
-	param->ssid_len =3D info->ssid_len;
+	param->beacon_period =3D bss->beacon_interval;
+	param->cap_info =3D bss->capability;
+	ether_addr_copy(param->bssid, bss->bssid);
+
+	ssid_elm =3D cfg80211_find_ie(WLAN_EID_SSID, ies->data, ies->len);
+	if (ssid_elm) {
+		param->ssid_len =3D ssid_elm[1];
+		if (param->ssid_len <=3D IEEE80211_MAX_SSID_LEN)
+			memcpy(param->ssid, ssid_elm + 2, param->ssid_len);
+		else
+			param->ssid_len =3D 0;
+	}
+
+	tim_elm =3D cfg80211_find_ie(WLAN_EID_TIM, ies->data, ies->len);
+	if (tim_elm && tim_elm[1] >=3D 2)
+		param->dtim_period =3D tim_elm[3];
+
 	memset(param->rsn_pcip_policy, 0xFF, 3);
 	memset(param->rsn_auth_policy, 0xFF, 3);
=20
-	while (index < info->ies_len)
-		host_int_fill_join_bss_param(param, info->ies, &index,
+	while (index < ies->len)
+		host_int_fill_join_bss_param(param, ies->data, &index,
 					     &pcipher_total_cnt,
-					     &auth_total_cnt, info->tsf_lo,
+					     &auth_total_cnt, ies->tsf,
 					     &rates_no);
=20
 	return (void *)param;
@@ -829,57 +842,20 @@ static void handle_rcvd_ntwrk_info(struct work_struct=
 *work)
 	struct host_if_msg *msg =3D container_of(work, struct host_if_msg, work);
 	struct wilc_vif *vif =3D msg->vif;
 	struct rcvd_net_info *rcvd_info =3D &msg->body.net_info;
-	u32 i;
-	bool found;
 	struct network_info *info =3D NULL;
-	void *params;
-	struct host_if_drv *hif_drv =3D vif->hif_drv;
-	struct user_scan_req *scan_req =3D &hif_drv->usr_scan_req;
-
-	found =3D true;
+	struct user_scan_req *scan_req =3D &vif->hif_drv->usr_scan_req;
=20
 	if (!scan_req->scan_result)
 		goto done;
=20
 	wilc_parse_network_info(rcvd_info->buffer, &info);
-	if (!info || !scan_req->scan_result) {
-		netdev_err(vif->ndev, "%s: info or scan result NULL\n",
+	if (!info) {
+		netdev_err(vif->ndev, "%s: info is NULL\n",
 			   __func__);
 		goto done;
 	}
=20
-	for (i =3D 0; i < scan_req->ch_cnt; i++) {
-		if (memcmp(scan_req->net_info[i].bssid, info->bssid, 6) =3D=3D 0) {
-			if (info->rssi <=3D scan_req->net_info[i].rssi) {
-				goto done;
-			} else {
-				scan_req->net_info[i].rssi =3D info->rssi;
-				found =3D false;
-				break;
-			}
-		}
-	}
-
-	if (found) {
-		if (scan_req->ch_cnt < MAX_NUM_SCANNED_NETWORKS) {
-			scan_req->net_info[scan_req->ch_cnt].rssi =3D info->rssi;
-
-			memcpy(scan_req->net_info[scan_req->ch_cnt].bssid,
-			       info->bssid, 6);
-
-			scan_req->ch_cnt++;
-
-			info->new_network =3D true;
-			params =3D host_int_parse_join_bss_param(info);
-
-			scan_req->scan_result(SCAN_EVENT_NETWORK_FOUND, info,
-					       scan_req->arg, params);
-		}
-	} else {
-		info->new_network =3D false;
-		scan_req->scan_result(SCAN_EVENT_NETWORK_FOUND, info,
-				      scan_req->arg, NULL);
-	}
+	scan_req->scan_result(SCAN_EVENT_NETWORK_FOUND, info, scan_req->arg);
=20
 done:
 	kfree(rcvd_info->buffer);
@@ -1150,8 +1126,7 @@ int wilc_disconnect(struct wilc_vif *vif)
=20
 	if (scan_req->scan_result) {
 		del_timer(&hif_drv->scan_timer);
-		scan_req->scan_result(SCAN_EVENT_ABORTED, NULL, scan_req->arg,
-				      NULL);
+		scan_req->scan_result(SCAN_EVENT_ABORTED, NULL, scan_req->arg);
 		scan_req->scan_result =3D NULL;
 	}
=20
@@ -2131,8 +2106,7 @@ int wilc_deinit(struct wilc_vif *vif)
=20
 	if (hif_drv->usr_scan_req.scan_result) {
 		hif_drv->usr_scan_req.scan_result(SCAN_EVENT_ABORTED, NULL,
-						  hif_drv->usr_scan_req.arg,
-						  NULL);
+						  hif_drv->usr_scan_req.arg);
 		hif_drv->usr_scan_req.scan_result =3D NULL;
 	}
=20
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wi=
lc1000/host_interface.h
index 9b396a79..6a09a52 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -19,7 +19,6 @@ enum {
=20
 #define WILC_MAX_NUM_STA			9
 #define MAX_NUM_SCANNED_NETWORKS		100
-#define MAX_NUM_SCANNED_NETWORKS_SHADOW		130
 #define WILC_MAX_NUM_PROBED_SSID		10
=20
 #define TX_MIC_KEY_LEN				8
@@ -29,8 +28,6 @@ enum {
 #define WILC_ADD_STA_LENGTH			40
 #define WILC_NUM_CONCURRENT_IFC			2
=20
-#define NUM_RSSI                5
-
 enum {
 	WILC_SET_CFG =3D 0,
 	WILC_GET_CFG
@@ -38,12 +35,6 @@ enum {
=20
 #define WILC_MAX_ASSOC_RESP_FRAME_SIZE   256
=20
-struct rssi_history_buffer {
-	bool full;
-	u8 index;
-	s8 samples[NUM_RSSI];
-};
-
 struct network_info {
 	s8 rssi;
 	u16 cap_info;
@@ -53,15 +44,9 @@ struct network_info {
 	u16 beacon_period;
 	u8 dtim_period;
 	u8 ch;
-	unsigned long time_scan_cached;
-	unsigned long time_scan;
-	bool new_network;
-	u8 found;
 	u32 tsf_lo;
 	u8 *ies;
 	u16 ies_len;
-	void *join_params;
-	struct rssi_history_buffer rssi_history;
 	u64 tsf;
 };
=20
@@ -129,11 +114,6 @@ enum cfg_param {
 	WILC_CFG_PARAM_RTS_THRESHOLD =3D BIT(3)
 };
=20
-struct found_net_info {
-	u8 bssid[6];
-	s8 rssi;
-};
-
 enum scan_event {
 	SCAN_EVENT_NETWORK_FOUND	=3D 0,
 	SCAN_EVENT_DONE			=3D 1,
@@ -148,7 +128,7 @@ enum conn_event {
 };
=20
 typedef void (*wilc_scan_result)(enum scan_event, struct network_info *,
-				 void *, void *);
+				 void *);
=20
 typedef void (*wilc_connect_result)(enum conn_event,
 				     struct connect_info *,
@@ -178,7 +158,6 @@ struct user_scan_req {
 	wilc_scan_result scan_result;
 	void *arg;
 	u32 ch_cnt;
-	struct found_net_info net_info[MAX_NUM_SCANNED_NETWORKS];
 };
=20
 struct user_conn_req {
@@ -307,4 +286,5 @@ int wilc_get_tx_power(struct wilc_vif *vif, u8 *tx_powe=
r);
 void wilc_scan_complete_received(struct wilc *wilc, u8 *buffer, u32 length=
);
 void wilc_network_info_received(struct wilc *wilc, u8 *buffer, u32 length)=
;
 void wilc_gnrl_async_info_received(struct wilc *wilc, u8 *buffer, u32 leng=
th);
+void *wilc_parse_join_bss_param(struct cfg80211_bss *bss);
 #endif
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/st=
aging/wilc1000/wilc_wfi_cfgoperations.c
index 987e5ff..381dfd8 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -29,9 +29,6 @@
=20
 #define INVALID_CHANNEL			0
=20
-#define nl80211_SCAN_RESULT_EXPIRE	(3 * HZ)
-#define SCAN_RESULT_EXPIRE		(40 * HZ)
-
 static const struct ieee80211_txrx_stypes
 	wilc_wfi_cfg80211_mgmt_types[NUM_NL80211_IFTYPES] =3D {
 	[NL80211_IFTYPE_STATION] =3D {
@@ -75,115 +72,8 @@ static u8 curr_channel;
 static u8 p2p_oui[] =3D {0x50, 0x6f, 0x9A, 0x09};
 static u8 p2p_vendor_spec[] =3D {0xdd, 0x05, 0x00, 0x08, 0x40, 0x03};
=20
-#define AGING_TIME	(9 * 1000)
 #define DURING_IP_TIME_OUT	15000
=20
-static void clear_shadow_scan(struct wilc_priv *priv)
-{
-	int i;
-
-	for (i =3D 0; i < priv->scanned_cnt; i++) {
-		kfree(priv->scanned_shadow[i].ies);
-		priv->scanned_shadow[i].ies =3D NULL;
-
-		kfree(priv->scanned_shadow[i].join_params);
-		priv->scanned_shadow[i].join_params =3D NULL;
-	}
-	priv->scanned_cnt =3D 0;
-}
-
-static u32 get_rssi_avg(struct network_info *network_info)
-{
-	u8 i;
-	int rssi_v =3D 0;
-	u8 num_rssi =3D (network_info->rssi_history.full) ?
-		       NUM_RSSI : (network_info->rssi_history.index);
-
-	for (i =3D 0; i < num_rssi; i++)
-		rssi_v +=3D network_info->rssi_history.samples[i];
-
-	rssi_v /=3D num_rssi;
-	return rssi_v;
-}
-
-static void refresh_scan(struct wilc_priv *priv, bool direct_scan)
-{
-	struct wiphy *wiphy =3D priv->dev->ieee80211_ptr->wiphy;
-	int i;
-
-	for (i =3D 0; i < priv->scanned_cnt; i++) {
-		struct network_info *network_info;
-		s32 freq;
-		struct ieee80211_channel *channel;
-		int rssi;
-		struct cfg80211_bss *bss;
-
-		network_info =3D &priv->scanned_shadow[i];
-
-		if (!memcmp("DIRECT-", network_info->ssid, 7) && !direct_scan)
-			continue;
-
-		freq =3D ieee80211_channel_to_frequency((s32)network_info->ch,
-						      NL80211_BAND_2GHZ);
-		channel =3D ieee80211_get_channel(wiphy, freq);
-		rssi =3D get_rssi_avg(network_info);
-		bss =3D cfg80211_inform_bss(wiphy,
-					  channel,
-					  CFG80211_BSS_FTYPE_UNKNOWN,
-					  network_info->bssid,
-					  network_info->tsf,
-					  network_info->cap_info,
-					  network_info->beacon_period,
-					  (const u8 *)network_info->ies,
-					  (size_t)network_info->ies_len,
-					  (s32)rssi * 100,
-					  GFP_KERNEL);
-		cfg80211_put_bss(wiphy, bss);
-	}
-}
-
-static void reset_shadow_found(struct wilc_priv *priv)
-{
-	int i;
-
-	for (i =3D 0; i < priv->scanned_cnt; i++)
-		priv->scanned_shadow[i].found =3D 0;
-}
-
-static void update_scan_time(struct wilc_priv *priv)
-{
-	int i;
-
-	for (i =3D 0; i < priv->scanned_cnt; i++)
-		priv->scanned_shadow[i].time_scan =3D jiffies;
-}
-
-static void remove_network_from_shadow(struct timer_list *t)
-{
-	struct wilc_priv *priv =3D from_timer(priv, t, aging_timer);
-	unsigned long now =3D jiffies;
-	int i, j;
-
-	for (i =3D 0; i < priv->scanned_cnt; i++) {
-		if (!time_after(now, priv->scanned_shadow[i].time_scan +
-				(unsigned long)(SCAN_RESULT_EXPIRE)))
-			continue;
-		kfree(priv->scanned_shadow[i].ies);
-		priv->scanned_shadow[i].ies =3D NULL;
-
-		kfree(priv->scanned_shadow[i].join_params);
-
-		for (j =3D i; (j < priv->scanned_cnt - 1); j++)
-			priv->scanned_shadow[j] =3D priv->scanned_shadow[j + 1];
-
-		priv->scanned_cnt--;
-	}
-
-	if (priv->scanned_cnt !=3D 0)
-		mod_timer(&priv->aging_timer,
-			  jiffies + msecs_to_jiffies(AGING_TIME));
-}
-
 static void clear_during_ip(struct timer_list *t)
 {
 	struct wilc_vif *vif =3D from_timer(vif, t, during_ip_timer);
@@ -191,87 +81,15 @@ static void clear_during_ip(struct timer_list *t)
 	vif->obtaining_ip =3D false;
 }
=20
-static int is_network_in_shadow(struct network_info *nw_info,
-				struct wilc_priv *priv)
-{
-	int state =3D -1;
-	int i;
-
-	if (priv->scanned_cnt =3D=3D 0) {
-		mod_timer(&priv->aging_timer,
-			  jiffies + msecs_to_jiffies(AGING_TIME));
-		state =3D -1;
-	} else {
-		for (i =3D 0; i < priv->scanned_cnt; i++) {
-			if (memcmp(priv->scanned_shadow[i].bssid,
-				   nw_info->bssid, 6) =3D=3D 0) {
-				state =3D i;
-				break;
-			}
-		}
-	}
-	return state;
-}
-
-static void add_network_to_shadow(struct network_info *nw_info,
-				  struct wilc_priv *priv, void *join_params)
-{
-	int ap_found =3D is_network_in_shadow(nw_info, priv);
-	u32 ap_index =3D 0;
-	u8 rssi_index =3D 0;
-	struct network_info *shadow_nw_info;
-
-	if (priv->scanned_cnt >=3D MAX_NUM_SCANNED_NETWORKS_SHADOW)
-		return;
-
-	if (ap_found =3D=3D -1) {
-		ap_index =3D priv->scanned_cnt;
-		priv->scanned_cnt++;
-	} else {
-		ap_index =3D ap_found;
-	}
-	shadow_nw_info =3D &priv->scanned_shadow[ap_index];
-	rssi_index =3D shadow_nw_info->rssi_history.index;
-	shadow_nw_info->rssi_history.samples[rssi_index++] =3D nw_info->rssi;
-	if (rssi_index =3D=3D NUM_RSSI) {
-		rssi_index =3D 0;
-		shadow_nw_info->rssi_history.full =3D true;
-	}
-	shadow_nw_info->rssi_history.index =3D rssi_index;
-	shadow_nw_info->rssi =3D nw_info->rssi;
-	shadow_nw_info->cap_info =3D nw_info->cap_info;
-	shadow_nw_info->ssid_len =3D nw_info->ssid_len;
-	memcpy(shadow_nw_info->ssid, nw_info->ssid, nw_info->ssid_len);
-	memcpy(shadow_nw_info->bssid, nw_info->bssid, ETH_ALEN);
-	shadow_nw_info->beacon_period =3D nw_info->beacon_period;
-	shadow_nw_info->dtim_period =3D nw_info->dtim_period;
-	shadow_nw_info->ch =3D nw_info->ch;
-	shadow_nw_info->tsf =3D nw_info->tsf;
-	if (ap_found !=3D -1)
-		kfree(shadow_nw_info->ies);
-	shadow_nw_info->ies =3D kmemdup(nw_info->ies, nw_info->ies_len,
-				      GFP_KERNEL);
-	if (shadow_nw_info->ies)
-		shadow_nw_info->ies_len =3D nw_info->ies_len;
-	else
-		shadow_nw_info->ies_len =3D 0;
-	shadow_nw_info->time_scan =3D jiffies;
-	shadow_nw_info->time_scan_cached =3D jiffies;
-	shadow_nw_info->found =3D 1;
-	if (ap_found !=3D -1)
-		kfree(shadow_nw_info->join_params);
-	shadow_nw_info->join_params =3D join_params;
-}
-
 static void cfg_scan_result(enum scan_event scan_event,
 			    struct network_info *network_info,
-			    void *user_void, void *join_params)
+			    void *user_void)
 {
 	struct wilc_priv *priv;
 	struct wiphy *wiphy;
 	s32 freq;
 	struct ieee80211_channel *channel;
-	struct cfg80211_bss *bss =3D NULL;
+	struct cfg80211_bss *bss;
=20
 	priv =3D user_void;
 	if (!priv->cfg_scanning)
@@ -291,51 +109,22 @@ static void cfg_scan_result(enum scan_event scan_even=
t,
 		freq =3D ieee80211_channel_to_frequency((s32)network_info->ch,
 						      NL80211_BAND_2GHZ);
 		channel =3D ieee80211_get_channel(wiphy, freq);
-
 		if (!channel)
 			return;
=20
-		if (network_info->new_network) {
-			if (priv->rcvd_ch_cnt >=3D MAX_NUM_SCANNED_NETWORKS)
-				return;
-
-			priv->rcvd_ch_cnt++;
-
-			add_network_to_shadow(network_info, priv, join_params);
-
-			if (memcmp("DIRECT-", network_info->ssid, 7))
-				return;
-
-			bss =3D cfg80211_inform_bss(wiphy,
-						  channel,
-						  CFG80211_BSS_FTYPE_UNKNOWN,
-						  network_info->bssid,
-						  network_info->tsf,
-						  network_info->cap_info,
-						  network_info->beacon_period,
-						  (const u8 *)network_info->ies,
-						  (size_t)network_info->ies_len,
-						  (s32)network_info->rssi * 100,
-						  GFP_KERNEL);
-			cfg80211_put_bss(wiphy, bss);
-		} else {
-			u32 i;
-
-			for (i =3D 0; i < priv->rcvd_ch_cnt; i++) {
-				if (memcmp(priv->scanned_shadow[i].bssid,
-					   network_info->bssid, 6) =3D=3D 0)
-					break;
-			}
-
-			if (i >=3D priv->rcvd_ch_cnt)
-				return;
-
-			priv->scanned_shadow[i].rssi =3D network_info->rssi;
-			priv->scanned_shadow[i].time_scan =3D jiffies;
-		}
+		bss =3D cfg80211_inform_bss(wiphy,
+					  channel,
+					  CFG80211_BSS_FTYPE_UNKNOWN,
+					  network_info->bssid,
+					  network_info->tsf,
+					  network_info->cap_info,
+					  network_info->beacon_period,
+					  (const u8 *)network_info->ies,
+					  (size_t)network_info->ies_len,
+					  (s32)network_info->rssi * 100,
+					  GFP_KERNEL);
+		cfg80211_put_bss(wiphy, bss);
 	} else if (scan_event =3D=3D SCAN_EVENT_DONE) {
-		refresh_scan(priv, false);
-
 		mutex_lock(&priv->scan_req_lock);
=20
 		if (priv->scan_req) {
@@ -344,7 +133,6 @@ static void cfg_scan_result(enum scan_event scan_event,
 			};
=20
 			cfg80211_scan_done(priv->scan_req, &info);
-			priv->rcvd_ch_cnt =3D 0;
 			priv->cfg_scanning =3D false;
 			priv->scan_req =3D NULL;
 		}
@@ -357,9 +145,6 @@ static void cfg_scan_result(enum scan_event scan_event,
 				.aborted =3D false,
 			};
=20
-			update_scan_time(priv);
-			refresh_scan(priv, false);
-
 			cfg80211_scan_done(priv->scan_req, &info);
 			priv->cfg_scanning =3D false;
 			priv->scan_req =3D NULL;
@@ -368,17 +153,6 @@ static void cfg_scan_result(enum scan_event scan_event=
,
 	}
 }
=20
-static inline bool wilc_cfg_scan_time_expired(struct wilc_priv *priv, int =
i)
-{
-	unsigned long now =3D jiffies;
-
-	if (time_after(now, priv->scanned_shadow[i].time_scan_cached +
-		       (unsigned long)(nl80211_SCAN_RESULT_EXPIRE - (1 * HZ))))
-		return true;
-	else
-		return false;
-}
-
 static void cfg_connect_result(enum conn_event conn_disconn_evt,
 			       struct connect_info *conn_info,
 			       u8 mac_status,
@@ -409,28 +183,10 @@ static void cfg_connect_result(enum conn_event conn_d=
isconn_evt,
 			netdev_err(dev, "Unspecified failure\n");
 		}
=20
-		if (connect_status =3D=3D WLAN_STATUS_SUCCESS) {
-			bool scan_refresh =3D false;
-			u32 i;
-
+		if (connect_status =3D=3D WLAN_STATUS_SUCCESS)
 			memcpy(priv->associated_bss, conn_info->bssid,
 			       ETH_ALEN);
=20
-			for (i =3D 0; i < priv->scanned_cnt; i++) {
-				if (memcmp(priv->scanned_shadow[i].bssid,
-					   conn_info->bssid,
-					   ETH_ALEN) =3D=3D 0) {
-					if (wilc_cfg_scan_time_expired(priv, i))
-						scan_refresh =3D true;
-
-					break;
-				}
-			}
-
-			if (scan_refresh)
-				refresh_scan(priv, true);
-		}
-
 		cfg80211_connect_result(dev, conn_info->bssid,
 					conn_info->req_ies,
 					conn_info->req_ies_len,
@@ -531,10 +287,6 @@ static int scan(struct wiphy *wiphy, struct cfg80211_s=
can_request *request)
=20
 	priv->scan_req =3D request;
=20
-	priv->rcvd_ch_cnt =3D 0;
-
-	reset_shadow_found(priv);
-
 	priv->cfg_scanning =3D true;
 	if (request->n_channels <=3D MAX_NUM_SCANNED_NETWORKS) {
 		for (i =3D 0; i < request->n_channels; i++) {
@@ -583,13 +335,13 @@ static int connect(struct wiphy *wiphy, struct net_de=
vice *dev,
 	struct wilc_priv *priv =3D wiphy_priv(wiphy);
 	struct wilc_vif *vif =3D netdev_priv(priv->dev);
 	struct host_if_drv *wfi_drv =3D priv->hif_drv;
-	struct network_info *nw_info;
 	int ret;
 	u32 i;
-	u32 sel_bssi_idx =3D UINT_MAX;
 	u8 security =3D WILC_FW_SEC_NO;
 	enum authtype auth_type =3D WILC_FW_AUTH_ANY;
 	u32 cipher_group;
+	struct cfg80211_bss *bss;
+	void *join_params;
=20
 	vif->connecting =3D true;
=20
@@ -598,39 +350,6 @@ static int connect(struct wiphy *wiphy, struct net_dev=
ice *dev,
 	else
 		wfi_drv->p2p_connect =3D 0;
=20
-	for (i =3D 0; i < priv->scanned_cnt; i++) {
-		if (sme->ssid_len =3D=3D priv->scanned_shadow[i].ssid_len &&
-		    memcmp(priv->scanned_shadow[i].ssid,
-			   sme->ssid,
-			   sme->ssid_len) =3D=3D 0) {
-			if (!sme->bssid) {
-				if (sel_bssi_idx =3D=3D UINT_MAX ||
-				    priv->scanned_shadow[i].rssi >
-				    priv->scanned_shadow[sel_bssi_idx].rssi)
-					sel_bssi_idx =3D i;
-			} else {
-				if (memcmp(priv->scanned_shadow[i].bssid,
-					   sme->bssid,
-					   ETH_ALEN) =3D=3D 0) {
-					sel_bssi_idx =3D i;
-					break;
-				}
-			}
-		}
-	}
-
-	if (sel_bssi_idx < priv->scanned_cnt) {
-		nw_info =3D &priv->scanned_shadow[sel_bssi_idx];
-	} else {
-		ret =3D -ENOENT;
-		goto out_error;
-	}
-
-	if (ether_addr_equal_unaligned(vif->bssid, nw_info->bssid)) {
-		ret =3D -EALREADY;
-		goto out_error;
-	}
-
 	memset(priv->wep_key, 0, sizeof(priv->wep_key));
 	memset(priv->wep_key_len, 0, sizeof(priv->wep_key_len));
=20
@@ -704,29 +423,54 @@ static int connect(struct wiphy *wiphy, struct net_de=
vice *dev,
 			auth_type =3D WILC_FW_AUTH_IEEE8021;
 	}
=20
-	curr_channel =3D nw_info->ch;
+	bss =3D cfg80211_get_bss(wiphy, sme->channel, sme->bssid, sme->ssid,
+			       sme->ssid_len, IEEE80211_BSS_TYPE_ANY,
+			       IEEE80211_PRIVACY(sme->privacy));
+	if (!bss) {
+		ret =3D -EINVAL;
+		goto out_error;
+	}
+
+	if (ether_addr_equal_unaligned(vif->bssid, bss->bssid)) {
+		ret =3D -EALREADY;
+		goto out_put_bss;
+	}
+
+	join_params =3D wilc_parse_join_bss_param(bss);
+	if (!join_params) {
+		netdev_err(dev, "%s: failed to construct join param\n",
+			   __func__);
+		ret =3D -EINVAL;
+		goto out_put_bss;
+	}
+
+	curr_channel =3D ieee80211_frequency_to_channel(bss->channel->center_freq=
);
=20
 	if (!wfi_drv->p2p_connect)
-		wlan_channel =3D nw_info->ch;
+		wlan_channel =3D curr_channel;
=20
-	wilc_wlan_set_bssid(dev, nw_info->bssid, WILC_STATION_MODE);
+	wilc_wlan_set_bssid(dev, bss->bssid, WILC_STATION_MODE);
=20
-	ret =3D wilc_set_join_req(vif, nw_info->bssid, sme->ssid,
+	ret =3D wilc_set_join_req(vif, bss->bssid, sme->ssid,
 				sme->ssid_len, sme->ie, sme->ie_len,
 				cfg_connect_result, (void *)priv,
-				security, auth_type,
-				nw_info->ch,
-				nw_info->join_params);
+				security, auth_type, curr_channel, join_params);
 	if (ret) {
 		netdev_err(dev, "wilc_set_join_req(): Error\n");
 		ret =3D -ENOENT;
 		if (!wfi_drv->p2p_connect)
 			wlan_channel =3D INVALID_CHANNEL;
 		wilc_wlan_set_bssid(dev, NULL, WILC_STATION_MODE);
-		goto out_error;
+		kfree(join_params);
+		goto out_put_bss;
 	}
+	kfree(join_params);
+	cfg80211_put_bss(wiphy, bss);
 	return 0;
=20
+out_put_bss:
+	cfg80211_put_bss(wiphy, bss);
+
 out_error:
 	vif->connecting =3D false;
 	return ret;
@@ -2096,7 +1840,6 @@ int wilc_init_host_int(struct net_device *net)
 	struct wilc_priv *priv =3D wdev_priv(net->ieee80211_ptr);
 	struct wilc_vif *vif =3D netdev_priv(priv->dev);
=20
-	timer_setup(&priv->aging_timer, remove_network_from_shadow, 0);
 	timer_setup(&vif->during_ip_timer, clear_during_ip, 0);
=20
 	priv->p2p_listen_state =3D false;
@@ -2120,8 +1863,6 @@ void wilc_deinit_host_int(struct net_device *net)
 	mutex_destroy(&priv->scan_req_lock);
 	ret =3D wilc_deinit(vif);
=20
-	del_timer_sync(&priv->aging_timer);
-	clear_shadow_scan(priv);
 	del_timer_sync(&vif->during_ip_timer);
=20
 	if (ret)
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/stagin=
g/wilc1000/wilc_wfi_netdevice.h
index a3400c1..59e8352 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -137,7 +137,6 @@ struct wilc_priv {
 	u64 tx_cookie;
=20
 	bool cfg_scanning;
-	u32 rcvd_ch_cnt;
=20
 	u8 associated_bss[ETH_ALEN];
 	struct sta_info assoc_stainfo;
@@ -155,8 +154,6 @@ struct wilc_priv {
 	/* mutexes */
 	struct mutex scan_req_lock;
 	bool p2p_listen_state;
-	struct timer_list aging_timer;
-	struct network_info scanned_shadow[MAX_NUM_SCANNED_NETWORKS_SHADOW];
 	int scanned_cnt;
 	struct wilc_p2p_var p2p;
=20
--=20
2.7.4

