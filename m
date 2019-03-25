Return-Path: <SRS0=1+XV=R4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2BC4C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 22:27:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72698206DF
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 22:27:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="BsW4b2N3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729840AbfCYW13 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 Mar 2019 18:27:29 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:19949 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728912AbfCYW13 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Mar 2019 18:27:29 -0400
X-IronPort-AV: E=Sophos;i="5.60,270,1549954800"; 
   d="scan'208";a="26959229"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 25 Mar 2019 15:27:29 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.108) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Mon, 25 Mar 2019 15:27:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=geEJ2SkKz58lpxCJStWwcwuunLxRBj/4HGiz+WzRE3w=;
 b=BsW4b2N37YwcwwkJeSXJa+PlUAfsv5KFWw/ZmEotXKXfJcFr5HsAV2VlCSMbQuY+OBjAEQQe9jDF14Z8LTFRl3GBCnH1p/8WE1DiaYVIS6a9hxxwuM4wDZFwP9jRTUZz8bQErf4oOFYkTnlzHtYLSvZ/0zpOE33dTxAALLSuZIQ=
Received: from MWHPR11MB1373.namprd11.prod.outlook.com (10.169.234.7) by
 MWHPR11MB1712.namprd11.prod.outlook.com (10.169.236.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1730.15; Mon, 25 Mar 2019 22:27:26 +0000
Received: from MWHPR11MB1373.namprd11.prod.outlook.com
 ([fe80::583a:f4d8:147c:549]) by MWHPR11MB1373.namprd11.prod.outlook.com
 ([fe80::583a:f4d8:147c:549%4]) with mapi id 15.20.1730.019; Mon, 25 Mar 2019
 22:27:26 +0000
From:   <Adham.Abozaeid@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <johannes@sipsolutions.net>, <Ajay.Kathat@microchip.com>,
        <Adham.Abozaeid@microchip.com>
Subject: [PATCH] staging: wilc1000: use cfg80211 ssid list instead of
 repacking it
Thread-Topic: [PATCH] staging: wilc1000: use cfg80211 ssid list instead of
 repacking it
Thread-Index: AQHU41ns+IN3tSci0EOoJhL3zpyFlA==
Date:   Mon, 25 Mar 2019 22:27:26 +0000
Message-ID: <20190325222636.29708-1-adham.abozaeid@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.175.253.81]
x-clientproxiedby: BYAPR05CA0041.namprd05.prod.outlook.com
 (2603:10b6:a03:74::18) To MWHPR11MB1373.namprd11.prod.outlook.com
 (2603:10b6:300:24::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Adham.Abozaeid@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8fd69d62-bcf1-4a74-f4e3-08d6b1710f1e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:MWHPR11MB1712;
x-ms-traffictypediagnostic: MWHPR11MB1712:
x-microsoft-antispam-prvs: <MWHPR11MB171211F74E63EC9ED27EF01A8D5E0@MWHPR11MB1712.namprd11.prod.outlook.com>
x-forefront-prvs: 0987ACA2E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(376002)(346002)(39860400002)(396003)(366004)(199004)(189003)(478600001)(107886003)(72206003)(6506007)(3846002)(66066001)(6116002)(5660300002)(25786009)(36756003)(386003)(52116002)(14454004)(4326008)(102836004)(99286004)(2501003)(26005)(8936002)(6486002)(5640700003)(105586002)(106356001)(256004)(14444005)(86362001)(50226002)(6436002)(316002)(6512007)(6916009)(81156014)(68736007)(81166006)(486006)(8676002)(7736002)(1076003)(305945005)(53936002)(2906002)(186003)(71190400001)(71200400001)(476003)(54906003)(2616005)(97736004)(2351001);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR11MB1712;H:MWHPR11MB1373.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: vcnW/0IkWIITpBe8H29M1Bm5WBVhVEsIr01cB+AaTd7yUWxHCumkBncAZM+O8QWwUjijGuAzoRFzAIh5UMHYvgNfzs+iutj+7UT09xYdtxGAeII1ONKlT4GkS/1N23tnC2EfWgp6VRckip3jrp9a3A8iTGRGaOnFHu/CeB/2M501LeU2wHU+INiUDsluIsf0NqYT+MPyHGW8l8zL1t6wxQkQozwMfzwdedkRzpISy+r8t7XEbu2/KfePVcXkM7/QFtLUUInT4rCcMkozjQUc13Of1hkOGto3ZWNS1iEUrpD3eaE6u/+0pYMFP/tPz/c/p3YjyuxPQBucVeK1afiMH5VFPQJjhqLD+KrzuXBsrDiGdHQXGtvtj3lQBAc8VW5Cc2fn+vnvQvju1LLxbAtLl5S7K1bFZ6gyS1VlmZD/dRk=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fd69d62-bcf1-4a74-f4e3-08d6b1710f1e
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2019 22:27:26.6384
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1712
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Adham Abozaeid <adham.abozaeid@microchip.com>

Avoid repacking ssid values into struct wilc_probe_ssid, and use the
cfg80211 provided struct to pass the ssid list to wilc_scan.
With this change, struct wilc_probe_ssid, struct wilc_probe_ssid_info
and function wilc_wfi_cfg_alloc_fill_ssid will not be needed anymore.

Signed-off-by: Adham Abozaeid <adham.abozaeid@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c     | 32 ++++-----
 drivers/staging/wilc1000/host_interface.h     | 14 +---
 .../staging/wilc1000/wilc_wfi_cfgoperations.c | 69 +------------------
 3 files changed, 20 insertions(+), 95 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index 44556b22613e..91ea16a6ae2e 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -229,10 +229,10 @@ static int handle_scan_done(struct wilc_vif *vif, enu=
m scan_event evt)
 }
=20
 int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 scan_type,
-	      u8 *ch_freq_list, u8 ch_list_len, const u8 *ies, size_t ies_len,
+	      u8 *ch_freq_list, u8 ch_list_len,
 	      void (*scan_result_fn)(enum scan_event,
 				     struct wilc_rcvd_net_info *, void *),
-	      void *user_arg, struct wilc_probe_ssid *search)
+	      void *user_arg, struct cfg80211_scan_request *request)
 {
 	int result =3D 0;
 	struct wid wid_list[5];
@@ -258,9 +258,9 @@ int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 =
scan_type,
=20
 	hif_drv->usr_scan_req.ch_cnt =3D 0;
=20
-	if (search) {
-		for (i =3D 0; i < search->n_ssids; i++)
-			valuesize +=3D ((search->ssid_info[i].ssid_len) + 1);
+	if (request->n_ssids) {
+		for (i =3D 0; i < request->n_ssids; i++)
+			valuesize +=3D ((request->ssids[i].ssid_len) + 1);
 		search_ssid_vals =3D kmalloc(valuesize + 1, GFP_KERNEL);
 		if (search_ssid_vals) {
 			wid_list[index].id =3D WID_SSID_PROBE_REQ;
@@ -268,13 +268,13 @@ int wilc_scan(struct wilc_vif *vif, u8 scan_source, u=
8 scan_type,
 			wid_list[index].val =3D search_ssid_vals;
 			buffer =3D wid_list[index].val;
=20
-			*buffer++ =3D search->n_ssids;
+			*buffer++ =3D request->n_ssids;
=20
-			for (i =3D 0; i < search->n_ssids; i++) {
-				*buffer++ =3D search->ssid_info[i].ssid_len;
-				memcpy(buffer, search->ssid_info[i].ssid,
-				       search->ssid_info[i].ssid_len);
-				buffer +=3D search->ssid_info[i].ssid_len;
+			for (i =3D 0; i < request->n_ssids; i++) {
+				*buffer++ =3D request->ssids[i].ssid_len;
+				memcpy(buffer, request->ssids[i].ssid,
+				       request->ssids[i].ssid_len);
+				buffer +=3D request->ssids[i].ssid_len;
 			}
 			wid_list[index].size =3D (s32)(valuesize + 1);
 			index++;
@@ -283,8 +283,8 @@ int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 =
scan_type,
=20
 	wid_list[index].id =3D WID_INFO_ELEMENT_PROBE;
 	wid_list[index].type =3D WID_BIN_DATA;
-	wid_list[index].val =3D (s8 *)ies;
-	wid_list[index].size =3D ies_len;
+	wid_list[index].val =3D (s8 *)request->ie;
+	wid_list[index].size =3D request->ie_len;
 	index++;
=20
 	wid_list[index].id =3D WID_SCAN_TYPE;
@@ -328,10 +328,8 @@ int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8=
 scan_type,
 		  jiffies + msecs_to_jiffies(WILC_HIF_SCAN_TIMEOUT_MS));
=20
 error:
-	if (search) {
-		kfree(search->ssid_info);
-		kfree(search_ssid_vals);
-	}
+
+	kfree(search_ssid_vals);
=20
 	return result;
 }
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wi=
lc1000/host_interface.h
index 678e62312215..a907c6d33012 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -115,16 +115,6 @@ struct wilc_rcvd_net_info {
 	struct ieee80211_mgmt *mgmt;
 };
=20
-struct wilc_probe_ssid_info {
-	u8 ssid_len;
-	u8 *ssid;
-};
-
-struct wilc_probe_ssid {
-	struct wilc_probe_ssid_info *ssid_info;
-	u8 n_ssids;
-	u32 size;
-};
=20
 struct wilc_user_scan_req {
 	void (*scan_result)(enum scan_event evt,
@@ -205,10 +195,10 @@ int wilc_disconnect(struct wilc_vif *vif);
 int wilc_set_mac_chnl_num(struct wilc_vif *vif, u8 channel);
 int wilc_get_rssi(struct wilc_vif *vif, s8 *rssi_level);
 int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 scan_type,
-	      u8 *ch_freq_list, u8 ch_list_len, const u8 *ies, size_t ies_len,
+	      u8 *ch_freq_list, u8 ch_list_len,
 	      void (*scan_result_fn)(enum scan_event,
 				     struct wilc_rcvd_net_info *, void *),
-	      void *user_arg, struct wilc_probe_ssid *search);
+	      void *user_arg, struct cfg80211_scan_request *request);
 int wilc_hif_set_cfg(struct wilc_vif *vif,
 		     struct cfg_param_attr *cfg_param);
 int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler=
);
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/st=
aging/wilc1000/wilc_wfi_cfgoperations.c
index 75ec752b5059..f6825727bf77 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -214,50 +214,6 @@ static int set_channel(struct wiphy *wiphy,
 	return result;
 }
=20
-static inline int
-wilc_wfi_cfg_alloc_fill_ssid(struct cfg80211_scan_request *request,
-			     struct wilc_probe_ssid *search)
-{
-	int i;
-	int slot_id =3D 0;
-
-	search->ssid_info =3D kcalloc(request->n_ssids,
-				    sizeof(*search->ssid_info), GFP_KERNEL);
-	if (!search->ssid_info)
-		goto out;
-
-	search->n_ssids =3D request->n_ssids;
-
-	for (i =3D 0; i < request->n_ssids; i++) {
-		if (request->ssids[i].ssid_len > 0) {
-			struct wilc_probe_ssid_info *info;
-
-			info =3D &search->ssid_info[slot_id];
-			info->ssid =3D kmemdup(request->ssids[i].ssid,
-					     request->ssids[i].ssid_len,
-					     GFP_KERNEL);
-			if (!info->ssid)
-				goto out_free;
-
-			info->ssid_len =3D request->ssids[i].ssid_len;
-			slot_id++;
-		} else {
-			search->n_ssids -=3D 1;
-		}
-	}
-	return 0;
-
-out_free:
-
-	for (i =3D 0; i < slot_id; i++)
-		kfree(search->ssid_info[i].ssid);
-
-	kfree(search->ssid_info);
-out:
-
-	return -ENOMEM;
-}
-
 static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request=
)
 {
 	struct wilc_priv *priv =3D wiphy_priv(wiphy);
@@ -265,7 +221,6 @@ static int scan(struct wiphy *wiphy, struct cfg80211_sc=
an_request *request)
 	u32 i;
 	int ret =3D 0;
 	u8 scan_ch_list[WILC_MAX_NUM_SCANNED_CH];
-	struct wilc_probe_ssid probe_ssid;
=20
 	if (request->n_channels > WILC_MAX_NUM_SCANNED_CH) {
 		netdev_err(priv->dev, "Requested scanned channels over\n");
@@ -280,28 +235,10 @@ static int scan(struct wiphy *wiphy, struct cfg80211_=
scan_request *request)
 		scan_ch_list[i] =3D ieee80211_frequency_to_channel(freq);
 	}
=20
-	if (request->n_ssids >=3D 1) {
-		if (wilc_wfi_cfg_alloc_fill_ssid(request, &probe_ssid)) {
-			ret =3D -ENOMEM;
-			goto out;
-		}
-
-		ret =3D wilc_scan(vif, WILC_FW_USER_SCAN,
-				WILC_FW_ACTIVE_SCAN, scan_ch_list,
-				request->n_channels,
-				(const u8 *)request->ie,
-				request->ie_len, cfg_scan_result,
-				(void *)priv, &probe_ssid);
-	} else {
-		ret =3D wilc_scan(vif, WILC_FW_USER_SCAN,
-				WILC_FW_ACTIVE_SCAN, scan_ch_list,
-				request->n_channels,
-				(const u8 *)request->ie,
-				request->ie_len, cfg_scan_result,
-				(void *)priv, NULL);
-	}
+	ret =3D wilc_scan(vif, WILC_FW_USER_SCAN, WILC_FW_ACTIVE_SCAN,
+			scan_ch_list, request->n_channels, cfg_scan_result,
+			(void *)priv, request);
=20
-out:
 	if (ret) {
 		priv->scan_req =3D NULL;
 		priv->cfg_scanning =3D false;
--=20
2.17.1

