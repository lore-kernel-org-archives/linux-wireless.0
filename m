Return-Path: <SRS0=z7UY=PZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF4CAC43387
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 13:21:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 850E320652
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 13:21:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="WKH2PJWM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbfAQNVh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 17 Jan 2019 08:21:37 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:61724 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727467AbfAQNVg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Jan 2019 08:21:36 -0500
X-IronPort-AV: E=Sophos;i="5.56,489,1539673200"; 
   d="scan'208";a="25443320"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 17 Jan 2019 06:21:32 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.105) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 17 Jan 2019 06:21:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YS4Hw0H2lmGPr8UbLQq7DcDQZP2O5tZ2KbLf+ZXYitk=;
 b=WKH2PJWMcZXH4E5jqDXU3mNUolMR9QY44mTzdWsTA6+lVKBi3gk1HUa6QvXt5mDPxjU7sbXdJmPnYyK+b8xr2GR232DYQMjvK/BUqG8sTo5jSP+o/MAk/jHR3nBc81NR1b252TASCmA/lSuZi9JY10T+nm6DSkEYS9rP526W4HU=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3464.namprd11.prod.outlook.com (20.177.187.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.26; Thu, 17 Jan 2019 13:21:30 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::c110:8559:a438:491d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::c110:8559:a438:491d%3]) with mapi id 15.20.1516.019; Thu, 17 Jan 2019
 13:21:30 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 08/13] staging: wilc1000: rename hidden_network related data
 structure
Thread-Topic: [PATCH 08/13] staging: wilc1000: rename hidden_network related
 data structure
Thread-Index: AQHUrmeOKU+uZ9ste0Gw9gNehpdB+A==
Date:   Thu, 17 Jan 2019 13:21:30 +0000
Message-ID: <1547731250-18518-9-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3464;6:tcVdCKKgBFk0SHxz4MZgz/AyVja5KpcyXouaRvKgKmgMexvtn3fKk2zUc5UbiQ0vd7/hrePggqrz1LOJOme8tlzKhJR3Jgfkb/9TD6CuBMl0A35Qc3u0WWTNrM17JgFmNZMtN9uunO2fKz7+wcTsDv9GomJxzH1WepBJ/Exc+22UcBUiSisvX+b0Pk1fgLeClHmGpBWPMQjO81ytyiT54jk/45xoOcWcRWMLNfPD4LhVsObtmHP+E2qE8uZlSP7yeAAbG9XA2Kgu9F3dsLVK/ahLzPnlHo/cNiHSyQsXk/zTO6HXOK1nkdvveySOVHJrlF4EprNtlEc96mSYXgwCav1DPkKgtPPKOC37mC8G1W/Fy6Ivz7oTe7VaA4FVJPyVHYK+WRXXqPQDTHxtJq2A+llNvYy8UnPmZGWBjOVCDWWg2qG/euuqcGvq7gUKeBY3aFk4k2GP5SSWzkLY2W6nwQ==;5:tyjw39Yc/3PybtTDWYYh/kcVeXS6DImqCSWXuSTI+B0Zivzip4klpgc5a3kPMnR5K60i45lGqukY3ulCdNbFTIW5jjNbpJcNfKLNHHyE/T8H7KVLe7O5G+VPUL3IKQDQW/5pu5oq46mqOsLex9pnAOzngy/Tk2zbm659GeID9eEHcK9tQHMlRb7mnNtyNZKaq9msq92NQ+Jhumum3p0DvQ==;7:jGTZV8YLfTtQfS8HZ6kvM434O+VLZprRt3Xb4jEZOp2d7zVib1lavVuWNZCrR1sArYT8NyGONy8qjeoCeogsKSxEDqp0c//xxy80KgYUnsBOMFnQyJ7yAUkZBHl3yZPsIdPpost1tg7xpyNyiur0mg==
x-ms-office365-filtering-correlation-id: eaaeb94a-3b85-49b8-87af-08d67c7eb11d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3464;
x-ms-traffictypediagnostic: BYAPR11MB3464:
x-microsoft-antispam-prvs: <BYAPR11MB3464FEA1E13FC60B67457E91E3830@BYAPR11MB3464.namprd11.prod.outlook.com>
x-forefront-prvs: 0920602B08
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(366004)(136003)(39860400002)(376002)(396003)(199004)(189003)(14454004)(68736007)(81166006)(81156014)(5660300001)(8936002)(2906002)(106356001)(8676002)(26005)(305945005)(7736002)(6486002)(6436002)(5640700003)(36756003)(86362001)(99286004)(478600001)(6916009)(50226002)(72206003)(78486014)(76176011)(2501003)(66066001)(4326008)(97736004)(486006)(25786009)(6506007)(476003)(102836004)(14444005)(256004)(386003)(53936002)(2616005)(54906003)(6512007)(71190400001)(71200400001)(105586002)(107886003)(3846002)(52116002)(186003)(2351001)(6116002)(316002)(11346002)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3464;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 93PQhFRiNDWrvTVCtv9Ab9qo/IU9Bd+9VvPWtG3aIu0TscKAoW04BRlJ3jwRSCCExySYZSrQ4lKlSoe9NArMTMVc4funfTWsYn7Kh/9QqZdLYu7fONgFJiIljnYfYdp9pvyDUynmq8bplhIEmmY2QGM10g2E54LfLlHX3QyfEzdEnrAslQzuIi+3dBPfH6F5nZIn4oxP+ToI8lfSeGudbFKEERPiKCOM6L6qbLxbt3Q8euqHiZWI93blaz8CPDwOTfMEpe3Nb4DlaPjFW5LXR0SQCkNmHrLMMolFm+jjBFRTYvmPcaXrHS0xGmLP0pAnyGlFYQ2C8W+2CTNH0cnnIM7tvD1xPviqQxk7Uxj44kmOTrSBQ0nqHT0mknHt531x0o3pg8sqk//oh68Uk846Q/MhZs9/rgprMbVZxnGeCkk=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: eaaeb94a-3b85-49b8-87af-08d67c7eb11d
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2019 13:21:27.9065
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

Rename hidden_network related data structure to have more appropriate
names, as it's used to keep search network SSID details.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c         | 40 +++++++++++--------=
----
 drivers/staging/wilc1000/host_interface.h         | 11 ++++---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 25 +++++++-------
 3 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index 46fd448..6c2be43 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -234,7 +234,7 @@ static int handle_scan_done(struct wilc_vif *vif, enum =
scan_event evt)
 int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 scan_type,
 	      u8 *ch_freq_list, u8 ch_list_len, const u8 *ies,
 	      size_t ies_len, wilc_scan_result scan_result, void *user_arg,
-	      struct hidden_network *hidden_net)
+	      struct wilc_probe_ssid *search)
 {
 	int result =3D 0;
 	struct wid wid_list[5];
@@ -242,7 +242,7 @@ int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 =
scan_type,
 	u32 i;
 	u8 *buffer;
 	u8 valuesize =3D 0;
-	u8 *hdn_ntwk_wid_val =3D NULL;
+	u8 *search_ssid_vals =3D NULL;
 	struct host_if_drv *hif_drv =3D vif->hif_drv;
=20
 	if (hif_drv->hif_state >=3D HOST_IF_SCANNING &&
@@ -260,26 +260,24 @@ int wilc_scan(struct wilc_vif *vif, u8 scan_source, u=
8 scan_type,
=20
 	hif_drv->usr_scan_req.ch_cnt =3D 0;
=20
-	if (hidden_net) {
-		wid_list[index].id =3D WID_SSID_PROBE_REQ;
-		wid_list[index].type =3D WID_STR;
-
-		for (i =3D 0; i < hidden_net->n_ssids; i++)
-			valuesize +=3D ((hidden_net->net_info[i].ssid_len) + 1);
-		hdn_ntwk_wid_val =3D kmalloc(valuesize + 1, GFP_KERNEL);
-		wid_list[index].val =3D hdn_ntwk_wid_val;
-		if (wid_list[index].val) {
+	if (search) {
+		for (i =3D 0; i < search->n_ssids; i++)
+			valuesize +=3D ((search->ssid_info[i].ssid_len) + 1);
+		search_ssid_vals =3D kmalloc(valuesize + 1, GFP_KERNEL);
+		if (search_ssid_vals) {
+			wid_list[index].id =3D WID_SSID_PROBE_REQ;
+			wid_list[index].type =3D WID_STR;
+			wid_list[index].val =3D search_ssid_vals;
 			buffer =3D wid_list[index].val;
=20
-			*buffer++ =3D hidden_net->n_ssids;
+			*buffer++ =3D search->n_ssids;
=20
-			for (i =3D 0; i < hidden_net->n_ssids; i++) {
-				*buffer++ =3D hidden_net->net_info[i].ssid_len;
-				memcpy(buffer, hidden_net->net_info[i].ssid,
-				       hidden_net->net_info[i].ssid_len);
-				buffer +=3D hidden_net->net_info[i].ssid_len;
+			for (i =3D 0; i < search->n_ssids; i++) {
+				*buffer++ =3D search->ssid_info[i].ssid_len;
+				memcpy(buffer, search->ssid_info[i].ssid,
+				       search->ssid_info[i].ssid_len);
+				buffer +=3D search->ssid_info[i].ssid_len;
 			}
-
 			wid_list[index].size =3D (s32)(valuesize + 1);
 			index++;
 		}
@@ -332,9 +330,9 @@ int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 =
scan_type,
 		  jiffies + msecs_to_jiffies(HOST_IF_SCAN_TIMEOUT));
=20
 error:
-	if (hidden_net) {
-		kfree(hidden_net->net_info);
-		kfree(hdn_ntwk_wid_val);
+	if (search) {
+		kfree(search->ssid_info);
+		kfree(search_ssid_vals);
 	}
=20
 	return result;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wi=
lc1000/host_interface.h
index 659e8cc..e702404 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -131,14 +131,15 @@ typedef void (*wilc_connect_result)(enum conn_event,
 typedef void (*wilc_remain_on_chan_expired)(void *, u32);
 typedef void (*wilc_remain_on_chan_ready)(void *);
=20
-struct hidden_net_info {
-	u8  *ssid;
+struct wilc_probe_ssid_info {
 	u8 ssid_len;
+	u8 *ssid;
 };
=20
-struct hidden_network {
-	struct hidden_net_info *net_info;
+struct wilc_probe_ssid {
+	struct wilc_probe_ssid_info *ssid_info;
 	u8 n_ssids;
+	u32 size;
 };
=20
 struct user_scan_req {
@@ -238,7 +239,7 @@ int wilc_get_rssi(struct wilc_vif *vif, s8 *rssi_level)=
;
 int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 scan_type,
 	      u8 *ch_freq_list, u8 ch_list_len, const u8 *ies,
 	      size_t ies_len, wilc_scan_result scan_result, void *user_arg,
-	      struct hidden_network *hidden_network);
+	      struct wilc_probe_ssid *search);
 int wilc_hif_set_cfg(struct wilc_vif *vif,
 		     struct cfg_param_attr *cfg_param);
 int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler=
);
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/st=
aging/wilc1000/wilc_wfi_cfgoperations.c
index 5070cad..1762c60 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -221,22 +221,23 @@ static int set_channel(struct wiphy *wiphy,
=20
 static inline int
 wilc_wfi_cfg_alloc_fill_ssid(struct cfg80211_scan_request *request,
-			     struct hidden_network *ntwk)
+			     struct wilc_probe_ssid *search)
 {
 	int i;
 	int slot_id =3D 0;
=20
-	ntwk->net_info =3D kcalloc(request->n_ssids, sizeof(*ntwk->net_info),
-				 GFP_KERNEL);
-	if (!ntwk->net_info)
+	search->ssid_info =3D kcalloc(request->n_ssids,
+				    sizeof(*search->ssid_info), GFP_KERNEL);
+	if (!search->ssid_info)
 		goto out;
=20
-	ntwk->n_ssids =3D request->n_ssids;
+	search->n_ssids =3D request->n_ssids;
=20
 	for (i =3D 0; i < request->n_ssids; i++) {
 		if (request->ssids[i].ssid_len > 0) {
-			struct hidden_net_info *info =3D &ntwk->net_info[slot_id];
+			struct wilc_probe_ssid_info *info;
=20
+			info =3D &search->ssid_info[slot_id];
 			info->ssid =3D kmemdup(request->ssids[i].ssid,
 					     request->ssids[i].ssid_len,
 					     GFP_KERNEL);
@@ -246,7 +247,7 @@ wilc_wfi_cfg_alloc_fill_ssid(struct cfg80211_scan_reque=
st *request,
 			info->ssid_len =3D request->ssids[i].ssid_len;
 			slot_id++;
 		} else {
-			ntwk->n_ssids -=3D 1;
+			search->n_ssids -=3D 1;
 		}
 	}
 	return 0;
@@ -254,9 +255,9 @@ wilc_wfi_cfg_alloc_fill_ssid(struct cfg80211_scan_reque=
st *request,
 out_free:
=20
 	for (i =3D 0; i < slot_id; i++)
-		kfree(ntwk->net_info[i].ssid);
+		kfree(search->ssid_info[i].ssid);
=20
-	kfree(ntwk->net_info);
+	kfree(search->ssid_info);
 out:
=20
 	return -ENOMEM;
@@ -269,7 +270,7 @@ static int scan(struct wiphy *wiphy, struct cfg80211_sc=
an_request *request)
 	u32 i;
 	int ret =3D 0;
 	u8 scan_ch_list[MAX_NUM_SCANNED_NETWORKS];
-	struct hidden_network hidden_ntwk;
+	struct wilc_probe_ssid probe_ssid;
=20
 	priv->scan_req =3D request;
=20
@@ -283,7 +284,7 @@ static int scan(struct wiphy *wiphy, struct cfg80211_sc=
an_request *request)
=20
 		if (request->n_ssids >=3D 1) {
 			if (wilc_wfi_cfg_alloc_fill_ssid(request,
-							 &hidden_ntwk)) {
+							 &probe_ssid)) {
 				ret =3D -ENOMEM;
 				goto out;
 			}
@@ -293,7 +294,7 @@ static int scan(struct wiphy *wiphy, struct cfg80211_sc=
an_request *request)
 					request->n_channels,
 					(const u8 *)request->ie,
 					request->ie_len, cfg_scan_result,
-					(void *)priv, &hidden_ntwk);
+					(void *)priv, &probe_ssid);
 		} else {
 			ret =3D wilc_scan(vif, WILC_FW_USER_SCAN,
 					WILC_FW_ACTIVE_SCAN, scan_ch_list,
--=20
2.7.4

