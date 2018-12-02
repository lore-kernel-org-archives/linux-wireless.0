Return-Path: <SRS0=9n1M=OL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC51BC04EB8
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:03:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A411C2080A
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:03:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="Orw+plL2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A411C2080A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725779AbeLBSDn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 2 Dec 2018 13:03:43 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:52871 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbeLBSDm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Dec 2018 13:03:42 -0500
X-IronPort-AV: E=Sophos;i="5.56,307,1539673200"; 
   d="scan'208";a="23451133"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 02 Dec 2018 11:03:40 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.49) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sun, 2 Dec 2018 11:03:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PEoRXonCN3451kh3RGvUHCRys6T0ehfHcNwblPz3O28=;
 b=Orw+plL2taywjyHx5ZOxk6JqJlDtDY2LSV/a2f6YEalHahBeAkbYBO22Nx/SJli0u/8nPto1RdsWsHJHdVX4Uy2GmnFw9JRQz/5wZXmVSC8gp9i3E8d9KjGvpu89WTm/lZgMBDKIxjtEIA2NMjH0RXO3IGrBfmjsKcF0LbkIX5s=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3096.namprd11.prod.outlook.com (20.177.227.78) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1382.21; Sun, 2 Dec 2018 18:03:38 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f%4]) with mapi id 15.20.1382.020; Sun, 2 Dec 2018
 18:03:38 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 29/29] staging: wilc1000: handle scan operation callback from
 cfg80211 context
Thread-Topic: [PATCH 29/29] staging: wilc1000: handle scan operation callback
 from cfg80211 context
Thread-Index: AQHUimlZQ1+Zp5z0eE6dGfCpad7bqA==
Date:   Sun, 2 Dec 2018 18:03:38 +0000
Message-ID: <1543773663-20561-30-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3096;6:UeJQKgEO3E6U8tdZiLc7yBAedVbr3Ww/jnre1qUoqE2BfnUjQhxZpHluxGEgi0gDnlFpvTuPVjAm1IHkF622OhU5GwpYV/VteAhiSyh6VQlWVTKk8sRdpkvzmovcNOWcMKa1T/6G1L5tG9bM4uWKssqTVk9tJ1w47/7+5NiJ4/zezsdZ1lYycBc9lkpUJjW+llQ/6SlfsLB7+BowSPD0grVc5fDYRsyLSf5/wnMbUHo1KcD/ng9QQS9vyuFJlUDXz4F1ilKsPM43oSnDCUq6h+gIbiM5JIesCpiIEQ1FJQkcMkzZ3tl4Oa+faCE3T9MYIz+IwfAj52KqXccyzGWB+Qmn2dOBW0lmzoWDQZRLodDcqnOgTXtBSPdKvdFhsMjPHBfTHxBK8j2jz+AAyj9Bkz8TuQtqTx6Jcb7kEM1y04kRFwx15gveg2/2I4Kc1JNZIUJ1Wl28esgefEzvpthIeA==;5:EwHBp4Mb0z+9jjeHwIYasNlc9m0V652RNXGprsm2W0clQl+6Vh+01uDu7ciVRs9x/2B7xWg8ExrP7+PB43TLNkl+ffyM+R7PshDvUL0hfvPQB7xg4/RZXelP0zAJvZG+qreV9tCfFGTIMqJsBHDm3ct6wL6uD+8e/4kCALdFna4=;7:adZ6TaQMbSlW9nK/FqyzLoDqcHPQjlt3L6tV2r8FkAdarP5OM3I/Dfipl9nW+tTW38tNErMXttvvKBqjaQIByMcFgVEW0kYegqq0SlJ1VJQXM64qlghsJDcDilSDeU9HsFC1vA+7IX9BkyKv0tEPWQ==
x-ms-office365-filtering-correlation-id: 7f90812e-7cdb-4489-b5f6-08d658807bf5
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3096;
x-ms-traffictypediagnostic: BYAPR11MB3096:
x-microsoft-antispam-prvs: <BYAPR11MB3096500718B649D4D5C9C770E3AD0@BYAPR11MB3096.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(10201501046)(3002001)(3231455)(999002)(944501491)(52105112)(93006095)(93001095)(148016)(149066)(150057)(6041310)(20161123558120)(20161123560045)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB3096;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB3096;
x-forefront-prvs: 087474FBFA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39840400004)(366004)(396003)(136003)(376002)(346002)(189003)(199004)(6512007)(8936002)(107886003)(81156014)(53936002)(6916009)(81166006)(105586002)(8676002)(106356001)(68736007)(6436002)(6486002)(5660300001)(86362001)(2351001)(2906002)(5640700003)(72206003)(7736002)(478600001)(305945005)(14444005)(256004)(97736004)(14454004)(486006)(186003)(26005)(66066001)(476003)(2616005)(11346002)(446003)(4326008)(36756003)(78486014)(54906003)(2501003)(316002)(25786009)(3846002)(6116002)(76176011)(99286004)(386003)(6506007)(102836004)(71200400001)(52116002)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3096;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: kexySjMTD+T6laqqW9AMrbPEo5Zoe+tr7XDMsAJ4Hepildec8R+IxT7prmvRV/V4NeFt6KNlijHXFnG8o7iPO2017PeMMZ2F8I8cKoD9u6ZHJSK/wlgHraNwQ/NIAN7gDYfIHXTYtG7rr9GwctDBrtbfDfcdPSpQJ0CeL0UfN51TBDKpmSR51BOmYDg2jp9Hw63nv4hsI+ibkWQwgBXaWc2lPq/2L0WuKXnh1CfFfQ2lLwXlT+wEhWYDdmoduOhPX3YdZ/QLXbWxyB11rC6vTCgEPqC3bkWmcKUyopjc1eaTW6HH+B/og61W072cSPY2BmMAl+MOzFwKjUo0sPjUiEwsfHLLRdsbNu9bf277M3g=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f90812e-7cdb-4489-b5f6-08d658807bf5
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2018 18:03:38.2735
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3096
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Refactor code to handle scan operation callback from cfg80211 context.
No need to maintain 'scan_attr' struct as the wid command is directly
sent to firmware from cfg80211 context.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c         | 143 ++++--------------=
----
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  13 +-
 2 files changed, 33 insertions(+), 123 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index f50728c..b8603f2 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -13,18 +13,6 @@
=20
 #define REAL_JOIN_REQ				0
=20
-struct scan_attr {
-	u8 src;
-	u8 type;
-	u8 *ch_freq_list;
-	u8 ch_list_len;
-	u8 *ies;
-	size_t ies_len;
-	wilc_scan_result result;
-	void *arg;
-	struct hidden_network hidden_network;
-};
-
 struct rcvd_async_info {
 	u8 *buffer;
 	u32 len;
@@ -84,7 +72,6 @@ struct wilc_gtk_key {
 } __packed;
=20
 union message_body {
-	struct scan_attr scan_info;
 	struct rcvd_net_info net_info;
 	struct rcvd_async_info async_info;
 	struct set_multicast multicast_info;
@@ -230,11 +217,11 @@ static int handle_scan_done(struct wilc_vif *vif, enu=
m scan_event evt)
 	return result;
 }
=20
-static void handle_scan(struct work_struct *work)
+int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 scan_type,
+	      u8 *ch_freq_list, u8 ch_list_len, const u8 *ies,
+	      size_t ies_len, wilc_scan_result scan_result, void *user_arg,
+	      struct hidden_network *hidden_net)
 {
-	struct host_if_msg *msg =3D container_of(work, struct host_if_msg, work);
-	struct wilc_vif *vif =3D msg->vif;
-	struct scan_attr *scan_info =3D &msg->body.scan_info;
 	int result =3D 0;
 	struct wid wid_list[5];
 	u32 index =3D 0;
@@ -243,10 +230,6 @@ static void handle_scan(struct work_struct *work)
 	u8 valuesize =3D 0;
 	u8 *hdn_ntwk_wid_val =3D NULL;
 	struct host_if_drv *hif_drv =3D vif->hif_drv;
-	struct hidden_network *hidden_net =3D &scan_info->hidden_network;
-
-	hif_drv->usr_scan_req.scan_result =3D scan_info->result;
-	hif_drv->usr_scan_req.arg =3D scan_info->arg;
=20
 	if (hif_drv->hif_state >=3D HOST_IF_SCANNING &&
 	    hif_drv->hif_state < HOST_IF_CONNECTED) {
@@ -288,63 +271,55 @@ static void handle_scan(struct work_struct *work)
=20
 	wid_list[index].id =3D WID_INFO_ELEMENT_PROBE;
 	wid_list[index].type =3D WID_BIN_DATA;
-	wid_list[index].val =3D scan_info->ies;
-	wid_list[index].size =3D scan_info->ies_len;
+	wid_list[index].val =3D (s8 *)ies;
+	wid_list[index].size =3D ies_len;
 	index++;
=20
 	wid_list[index].id =3D WID_SCAN_TYPE;
 	wid_list[index].type =3D WID_CHAR;
 	wid_list[index].size =3D sizeof(char);
-	wid_list[index].val =3D (s8 *)&scan_info->type;
+	wid_list[index].val =3D (s8 *)&scan_type;
 	index++;
=20
 	wid_list[index].id =3D WID_SCAN_CHANNEL_LIST;
 	wid_list[index].type =3D WID_BIN_DATA;
=20
-	if (scan_info->ch_freq_list &&
-	    scan_info->ch_list_len > 0) {
-		int i;
-
-		for (i =3D 0; i < scan_info->ch_list_len; i++) {
-			if (scan_info->ch_freq_list[i] > 0)
-				scan_info->ch_freq_list[i] -=3D 1;
+	if (ch_freq_list && ch_list_len > 0) {
+		for (i =3D 0; i < ch_list_len; i++) {
+			if (ch_freq_list[i] > 0)
+				ch_freq_list[i] -=3D 1;
 		}
 	}
=20
-	wid_list[index].val =3D scan_info->ch_freq_list;
-	wid_list[index].size =3D scan_info->ch_list_len;
+	wid_list[index].val =3D ch_freq_list;
+	wid_list[index].size =3D ch_list_len;
 	index++;
=20
 	wid_list[index].id =3D WID_START_SCAN_REQ;
 	wid_list[index].type =3D WID_CHAR;
 	wid_list[index].size =3D sizeof(char);
-	wid_list[index].val =3D (s8 *)&scan_info->src;
+	wid_list[index].val =3D (s8 *)&scan_source;
 	index++;
=20
 	result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, wid_list,
 				      index,
 				      wilc_get_vif_idx(vif));
-
-	if (result)
-		netdev_err(vif->ndev, "Failed to send scan parameters\n");
-
-error:
 	if (result) {
-		del_timer(&hif_drv->scan_timer);
-		handle_scan_done(vif, SCAN_EVENT_ABORTED);
+		netdev_err(vif->ndev, "Failed to send scan parameters\n");
+		goto error;
 	}
=20
-	kfree(scan_info->ch_freq_list);
-	scan_info->ch_freq_list =3D NULL;
-
-	kfree(scan_info->ies);
-	scan_info->ies =3D NULL;
-	kfree(scan_info->hidden_network.net_info);
-	scan_info->hidden_network.net_info =3D NULL;
+	hif_drv->usr_scan_req.scan_result =3D scan_result;
+	hif_drv->usr_scan_req.arg =3D user_arg;
+	hif_drv->scan_timer_vif =3D vif;
+	mod_timer(&hif_drv->scan_timer,
+		  jiffies + msecs_to_jiffies(HOST_IF_SCAN_TIMEOUT));
=20
+error:
+	kfree(hidden_net->net_info);
 	kfree(hdn_ntwk_wid_val);
=20
-	kfree(msg);
+	return result;
 }
=20
 static int wilc_send_connect_wid(struct wilc_vif *vif)
@@ -2034,76 +2009,6 @@ int wilc_get_stats_async(struct wilc_vif *vif, struc=
t rf_info *stats)
 	return result;
 }
=20
-int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 scan_type,
-	      u8 *ch_freq_list, u8 ch_list_len, const u8 *ies,
-	      size_t ies_len, wilc_scan_result scan_result, void *user_arg,
-	      struct hidden_network *hidden_network)
-{
-	int result;
-	struct host_if_msg *msg;
-	struct scan_attr *scan_info;
-	struct host_if_drv *hif_drv =3D vif->hif_drv;
-
-	if (!hif_drv || !scan_result) {
-		netdev_err(vif->ndev, "hif_drv or scan_result =3D NULL\n");
-		return -EFAULT;
-	}
-
-	msg =3D wilc_alloc_work(vif, handle_scan, false);
-	if (IS_ERR(msg))
-		return PTR_ERR(msg);
-
-	scan_info =3D &msg->body.scan_info;
-
-	if (hidden_network) {
-		scan_info->hidden_network.net_info =3D hidden_network->net_info;
-		scan_info->hidden_network.n_ssids =3D hidden_network->n_ssids;
-	}
-
-	scan_info->src =3D scan_source;
-	scan_info->type =3D scan_type;
-	scan_info->result =3D scan_result;
-	scan_info->arg =3D user_arg;
-
-	scan_info->ch_list_len =3D ch_list_len;
-	scan_info->ch_freq_list =3D kmemdup(ch_freq_list,
-					  ch_list_len,
-					  GFP_KERNEL);
-	if (!scan_info->ch_freq_list) {
-		result =3D -ENOMEM;
-		goto free_msg;
-	}
-
-	scan_info->ies_len =3D ies_len;
-	scan_info->ies =3D kmemdup(ies, ies_len, GFP_KERNEL);
-	if (!scan_info->ies) {
-		result =3D -ENOMEM;
-		goto free_freq_list;
-	}
-
-	result =3D wilc_enqueue_work(msg);
-	if (result) {
-		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
-		goto free_ies;
-	}
-
-	hif_drv->scan_timer_vif =3D vif;
-	mod_timer(&hif_drv->scan_timer,
-		  jiffies + msecs_to_jiffies(HOST_IF_SCAN_TIMEOUT));
-
-	return 0;
-
-free_ies:
-	kfree(scan_info->ies);
-
-free_freq_list:
-	kfree(scan_info->ch_freq_list);
-
-free_msg:
-	kfree(msg);
-	return result;
-}
-
 int wilc_hif_set_cfg(struct wilc_vif *vif, struct cfg_param_attr *param)
 {
 	struct wid wid_list[4];
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/st=
aging/wilc1000/wilc_wfi_cfgoperations.c
index 08d4461..ac47dda 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -547,8 +547,10 @@ static int scan(struct wiphy *wiphy, struct cfg80211_s=
can_request *request)
=20
 		if (request->n_ssids >=3D 1) {
 			if (wilc_wfi_cfg_alloc_fill_ssid(request,
-							 &hidden_ntwk))
-				return -ENOMEM;
+							 &hidden_ntwk)) {
+				ret =3D -ENOMEM;
+				goto out;
+			}
=20
 			ret =3D wilc_scan(vif, WILC_FW_USER_SCAN,
 					WILC_FW_ACTIVE_SCAN, scan_ch_list,
@@ -568,8 +570,11 @@ static int scan(struct wiphy *wiphy, struct cfg80211_s=
can_request *request)
 		netdev_err(priv->dev, "Requested scanned channels over\n");
 	}
=20
-	if (ret !=3D 0)
-		ret =3D -EBUSY;
+out:
+	if (ret) {
+		priv->scan_req =3D NULL;
+		priv->cfg_scanning =3D false;
+	}
=20
 	return ret;
 }
--=20
2.7.4

