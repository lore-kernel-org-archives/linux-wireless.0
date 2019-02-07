Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7854BC282C2
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 07:22:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 155632075C
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 07:22:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="ruHzovSK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbfBGHWd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 02:22:33 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:47400 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbfBGHWd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 02:22:33 -0500
X-IronPort-AV: E=Sophos;i="5.56,564,1539673200"; 
   d="scan'208";a="27377118"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 07 Feb 2019 00:22:31 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.105) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 7 Feb 2019 00:22:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I4ICCQWT/wydC+ychRlHjAkiSOwS/HLjstbw2+YOVXU=;
 b=ruHzovSKkYAtrbJoK+de9Tgh84UwFXQ6zFv5C2GxgMMuOyqdYlyzKPuJuQhNlIJk2j3mZjPMlFiHBynYb04RGmeAT4sYtR9bltqe8Ij5t21k6o9oJSdzjQ73nmycZ9wKV5rG4fuo/Rw0w/OxYiZF5ZHv2RiKy2H2uDQYFP9sCeU=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3415.namprd11.prod.outlook.com (20.177.224.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.22; Thu, 7 Feb 2019 07:22:29 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1601.016; Thu, 7 Feb 2019
 07:22:29 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 3/9] staging: wilc1000: add 'wilc_' prefix to have proper
 namespace
Thread-Topic: [PATCH 3/9] staging: wilc1000: add 'wilc_' prefix to have proper
 namespace
Thread-Index: AQHUvrXi2o/cbZnP/UqRGL9a3fX3Vw==
Date:   Thu, 7 Feb 2019 07:22:29 +0000
Message-ID: <1549519927-2651-4-git-send-email-ajay.kathat@microchip.com>
References: <1549519927-2651-1-git-send-email-ajay.kathat@microchip.com>
In-Reply-To: <1549519927-2651-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MAXPR0101CA0020.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:c::30) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.7.4
x-originating-ip: [223.237.230.157]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3415;6:axVn+NI4WnpC7+V+C1dcIX7/X82PZWIZZ1MzWeAwLa5Pmcyu0b8aebx2CKe6UKrEfGnV34IO99WXQYCwKsiamxGOuxZe50kryWXciMf6yFp9U3qDxIuA642D13vwgAMI08jZWFCfpLMT/FkrVSPUncUaevi7rZf64lgAyJe6vUl9Ny89FnSngZPAoXkZzloUNFCThFVXKNFP8w9DgG27P9BBfanyMZLxezVeupbyrpeol0FT4y4DLcwrTEXggqvG6uzqqBHUgNOBr6M7nG8/pmYXshdI9hLXAWHhoSFyH6kUEbOdbwR5rHRwGQ/LTyevHYM2SSzN0KWUuirZEXI3mpr5IFKjGswk0Y1hnmjOdwo87l3wHDcUrejAgb+ULzjkpXabLBqsOUoJJ5E5CQvuPssVmX5IPcPun+2X1ymg70ZFA8OND0UID8oqcSAktWwOFjj9LDvYyWVfqEY7QpRalQ==;5:xHUtSyAsCUSLsjLGXv+xErxUgQUV7MiqY0KsLAjhVAAI75M6GgwXS+y/7ta3m13wfbq3Ina7Fn2IaieaIrbIA/6SjKavTGOEsLeUqAotnY6MG3Xk8cvXCfiCEHU4suBrACI1JBV9WQW0RHqOLYovtkwO/csgctRo61C4xQgynrDZrS588386LXlgoMn8ps93W3F6uNV9cxyWaBG9lfA8Sg==;7:GLHOko5ZcK2neksSDI2pJOwNY0JLw+O1lJPkJAmQaIEFxUPsal/LpPS9G57r5sYkylY42VDx5ON4r0HJ3wKUPJojj8swrI+TajBj+SGBO/nNebTv/4Ly17qzKiNSsysv7RYQQe+GfUhzqSxJ0jylZw==
x-ms-office365-filtering-correlation-id: 21881159-3635-4b50-0bf7-08d68ccd03cb
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3415;
x-ms-traffictypediagnostic: BYAPR11MB3415:
x-microsoft-antispam-prvs: <BYAPR11MB3415510E0BC8E4F61A6DCA93E3680@BYAPR11MB3415.namprd11.prod.outlook.com>
x-forefront-prvs: 0941B96580
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39860400002)(136003)(366004)(396003)(376002)(189003)(199004)(86362001)(5640700003)(478600001)(6116002)(446003)(3846002)(72206003)(6486002)(11346002)(6436002)(25786009)(2351001)(2616005)(476003)(6512007)(105586002)(106356001)(486006)(26005)(53946003)(6506007)(102836004)(386003)(36756003)(71190400001)(30864003)(2501003)(97736004)(71200400001)(81156014)(305945005)(66066001)(54906003)(4326008)(186003)(68736007)(8936002)(81166006)(107886003)(52116002)(50226002)(53936002)(256004)(6916009)(14444005)(316002)(99286004)(14454004)(2906002)(76176011)(7736002)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3415;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 6s2aJ2Bmn7o7r8LypV/rhaTKA+WBMV+JkGzfP/aOwSJl+Ng8XdfOGNuRQZtG4VYyQHSSlehtlUQwgWbie/04NcD4cMKJDksDhV5TKW6rup/KUJqWV18V/hyndF26SSkxzmYnIUbLPPHS+nm5Vop1c8Cw2gGsFsOmzkf0PNlQ14vab4LUdfjpuO3/UD6+0FB5sJahyn+91yupAHdUUuNDhs+amtAf07q41HwwpsoenSPKyYLuYDCRWlWaywRnT4xfJnZKI7ugCyr4CPK00hejHvArWS4bGeQk5iPMCPDm78ZEgh4xt62RrB1U69S4NBUOz7UXWN7/35nnop24yHwYGbKjwZjoKifRr3GbvukBJKpywRhwOgqmGafqpMxwDSLTgRYfKx51/YOcLUUlvqBsTXibzqvITxCYzPeGoEU0vLw=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 21881159-3635-4b50-0bf7-08d68ccd03cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2019 07:22:25.6000
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3415
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Cleanup patch to rename data structure and function name to have 'wilc_'
prefix.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c         | 54 +++++++++++--------=
----
 drivers/staging/wilc1000/host_interface.h         | 12 ++---
 drivers/staging/wilc1000/wilc_spi.c               |  4 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 22 ++++-----
 drivers/staging/wilc1000/wilc_wlan.c              |  8 ++--
 drivers/staging/wilc1000/wilc_wlan.h              |  8 ++--
 drivers/staging/wilc1000/wilc_wlan_cfg.c          | 12 ++---
 drivers/staging/wilc1000/wilc_wlan_if.h           |  2 +-
 8 files changed, 61 insertions(+), 61 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index 0fb6ca3..9abe341 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -9,7 +9,7 @@
 #define WILC_HIF_SCAN_TIMEOUT_MS                4000
 #define WILC_HIF_CONNECT_TIMEOUT_MS             9500
=20
-#define FALSE_FRMWR_CHANNEL			100
+#define WILC_FALSE_FRMWR_CHANNEL		100
=20
 struct wilc_rcvd_mac_info {
 	u8 status;
@@ -21,7 +21,7 @@ struct wilc_set_multicast {
 	u8 *mc_list;
 };
=20
-struct del_all_sta {
+struct wilc_del_all_sta {
 	u8 assoc_sta;
 	u8 mac[WILC_MAX_NUM_STA][ETH_ALEN];
 };
@@ -68,16 +68,16 @@ struct wilc_gtk_key {
 	u8 key[0];
 } __packed;
=20
-union message_body {
+union wilc_message_body {
 	struct wilc_rcvd_net_info net_info;
 	struct wilc_rcvd_mac_info mac_info;
 	struct wilc_set_multicast mc_info;
-	struct remain_ch remain_on_ch;
+	struct wilc_remain_ch remain_on_ch;
 	char *data;
 };
=20
 struct host_if_msg {
-	union message_body body;
+	union wilc_message_body body;
 	struct wilc_vif *vif;
 	struct work_struct work;
 	void (*fn)(struct work_struct *ws);
@@ -110,7 +110,7 @@ struct wilc_join_bss_param {
 	u8 bssid[ETH_ALEN];
 	__le16 beacon_period;
 	u8 dtim_period;
-	u8 supp_rates[MAX_RATES_SUPPORTED + 1];
+	u8 supp_rates[WILC_MAX_RATES_SUPPORTED + 1];
 	u8 wmm_cap;
 	u8 uapsd_cap;
 	u8 ht_capable;
@@ -195,7 +195,7 @@ static int handle_scan_done(struct wilc_vif *vif, enum =
scan_event evt)
 	u8 abort_running_scan;
 	struct wid wid;
 	struct host_if_drv *hif_drv =3D vif->hif_drv;
-	struct user_scan_req *scan_req;
+	struct wilc_user_scan_req *scan_req;
=20
 	if (evt =3D=3D SCAN_EVENT_ABORTED) {
 		abort_running_scan =3D 1;
@@ -475,8 +475,8 @@ void *wilc_parse_join_bss_param(struct cfg80211_bss *bs=
s,
 	supp_rates_ie =3D cfg80211_find_ie(WLAN_EID_EXT_SUPP_RATES, ies->data,
 					 ies->len);
 	if (supp_rates_ie) {
-		if (supp_rates_ie[1] > (MAX_RATES_SUPPORTED - rates_len))
-			param->supp_rates[0] =3D MAX_RATES_SUPPORTED;
+		if (supp_rates_ie[1] > (WILC_MAX_RATES_SUPPORTED - rates_len))
+			param->supp_rates[0] =3D WILC_MAX_RATES_SUPPORTED;
 		else
 			param->supp_rates[0] +=3D supp_rates_ie[1];
=20
@@ -563,7 +563,7 @@ static void handle_rcvd_ntwrk_info(struct work_struct *=
work)
 {
 	struct host_if_msg *msg =3D container_of(work, struct host_if_msg, work);
 	struct wilc_rcvd_net_info *rcvd_info =3D &msg->body.net_info;
-	struct user_scan_req *scan_req =3D &msg->vif->hif_drv->usr_scan_req;
+	struct wilc_user_scan_req *scan_req =3D &msg->vif->hif_drv->usr_scan_req;
 	const u8 *ch_elm;
 	u8 *ies;
 	int ies_len;
@@ -758,7 +758,7 @@ int wilc_disconnect(struct wilc_vif *vif)
 {
 	struct wid wid;
 	struct host_if_drv *hif_drv =3D vif->hif_drv;
-	struct user_scan_req *scan_req;
+	struct wilc_user_scan_req *scan_req;
 	struct wilc_conn_info *conn_info;
 	int result;
 	u16 dummy_reason_code =3D 0;
@@ -911,7 +911,7 @@ static void wilc_hif_pack_sta_param(u8 *cur_byte, const=
 u8 *mac,
 }
=20
 static int handle_remain_on_chan(struct wilc_vif *vif,
-				 struct remain_ch *hif_remain_ch)
+				 struct wilc_remain_ch *hif_remain_ch)
 {
 	int result;
 	u8 remain_on_chan_flag;
@@ -957,7 +957,7 @@ static void handle_listen_state_expired(struct work_str=
uct *work)
 {
 	struct host_if_msg *msg =3D container_of(work, struct host_if_msg, work);
 	struct wilc_vif *vif =3D msg->vif;
-	struct remain_ch *hif_remain_ch =3D &msg->body.remain_on_ch;
+	struct wilc_remain_ch *hif_remain_ch =3D &msg->body.remain_on_ch;
 	u8 remain_on_chan_flag;
 	struct wid wid;
 	int result;
@@ -975,7 +975,7 @@ static void handle_listen_state_expired(struct work_str=
uct *work)
 			goto free_msg;
=20
 		wid.val[0] =3D remain_on_chan_flag;
-		wid.val[1] =3D FALSE_FRMWR_CHANNEL;
+		wid.val[1] =3D WILC_FALSE_FRMWR_CHANNEL;
=20
 		result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
 					      wilc_get_vif_idx(vif));
@@ -1224,7 +1224,7 @@ int wilc_add_ptk(struct wilc_vif *vif, const u8 *ptk,=
 u8 ptk_key_len,
 		 u8 mode, u8 cipher_mode, u8 index)
 {
 	int result =3D 0;
-	u8 t_key_len  =3D ptk_key_len + RX_MIC_KEY_LEN + TX_MIC_KEY_LEN;
+	u8 t_key_len  =3D ptk_key_len + WILC_RX_MIC_KEY_LEN + WILC_TX_MIC_KEY_LEN=
;
=20
 	if (mode =3D=3D WILC_AP_MODE) {
 		struct wid wid_list[2];
@@ -1246,11 +1246,11 @@ int wilc_add_ptk(struct wilc_vif *vif, const u8 *pt=
k, u8 ptk_key_len,
=20
 		if (rx_mic)
 			memcpy(&key_buf->key[ptk_key_len], rx_mic,
-			       RX_MIC_KEY_LEN);
+			       WILC_RX_MIC_KEY_LEN);
=20
 		if (tx_mic)
-			memcpy(&key_buf->key[ptk_key_len + RX_MIC_KEY_LEN],
-			       tx_mic, TX_MIC_KEY_LEN);
+			memcpy(&key_buf->key[ptk_key_len + WILC_RX_MIC_KEY_LEN],
+			       tx_mic, WILC_TX_MIC_KEY_LEN);
=20
 		wid_list[1].id =3D WID_ADD_PTK;
 		wid_list[1].type =3D WID_STR;
@@ -1274,11 +1274,11 @@ int wilc_add_ptk(struct wilc_vif *vif, const u8 *pt=
k, u8 ptk_key_len,
=20
 		if (rx_mic)
 			memcpy(&key_buf->key[ptk_key_len], rx_mic,
-			       RX_MIC_KEY_LEN);
+			       WILC_RX_MIC_KEY_LEN);
=20
 		if (tx_mic)
-			memcpy(&key_buf->key[ptk_key_len + RX_MIC_KEY_LEN],
-			       tx_mic, TX_MIC_KEY_LEN);
+			memcpy(&key_buf->key[ptk_key_len + WILC_RX_MIC_KEY_LEN],
+			       tx_mic, WILC_TX_MIC_KEY_LEN);
=20
 		wid.id =3D WID_ADD_PTK;
 		wid.type =3D WID_STR;
@@ -1299,7 +1299,7 @@ int wilc_add_rx_gtk(struct wilc_vif *vif, const u8 *r=
x_gtk, u8 gtk_key_len,
 {
 	int result =3D 0;
 	struct wilc_gtk_key *gtk_key;
-	int t_key_len =3D gtk_key_len + RX_MIC_KEY_LEN + TX_MIC_KEY_LEN;
+	int t_key_len =3D gtk_key_len + WILC_RX_MIC_KEY_LEN + WILC_TX_MIC_KEY_LEN=
;
=20
 	gtk_key =3D kzalloc(sizeof(*gtk_key) + t_key_len, GFP_KERNEL);
 	if (!gtk_key)
@@ -1317,11 +1317,11 @@ int wilc_add_rx_gtk(struct wilc_vif *vif, const u8 =
*rx_gtk, u8 gtk_key_len,
 	memcpy(&gtk_key->key[0], rx_gtk, gtk_key_len);
=20
 	if (rx_mic)
-		memcpy(&gtk_key->key[gtk_key_len], rx_mic, RX_MIC_KEY_LEN);
+		memcpy(&gtk_key->key[gtk_key_len], rx_mic, WILC_RX_MIC_KEY_LEN);
=20
 	if (tx_mic)
-		memcpy(&gtk_key->key[gtk_key_len + RX_MIC_KEY_LEN],
-		       tx_mic, TX_MIC_KEY_LEN);
+		memcpy(&gtk_key->key[gtk_key_len + WILC_RX_MIC_KEY_LEN],
+		       tx_mic, WILC_TX_MIC_KEY_LEN);
=20
 	if (mode =3D=3D WILC_AP_MODE) {
 		struct wid wid_list[2];
@@ -1819,7 +1819,7 @@ int wilc_remain_on_channel(struct wilc_vif *vif, u64 =
cookie,
 			   void (*expired)(void *, u64),
 			   void *user_arg)
 {
-	struct remain_ch roc;
+	struct wilc_remain_ch roc;
 	int result;
=20
 	roc.ch =3D chan;
@@ -2017,7 +2017,7 @@ int wilc_del_allstation(struct wilc_vif *vif, u8 mac_=
addr[][ETH_ALEN])
 	int result;
 	int i;
 	u8 assoc_sta =3D 0;
-	struct del_all_sta del_sta;
+	struct wilc_del_all_sta del_sta;
=20
 	memset(&del_sta, 0x0, sizeof(del_sta));
 	for (i =3D 0; i < WILC_MAX_NUM_STA; i++) {
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wi=
lc1000/host_interface.h
index 790f83e..a007625 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -21,8 +21,8 @@ enum {
 #define WILC_MAX_NUM_SCANNED_CH			14
 #define WILC_MAX_NUM_PROBED_SSID		10
=20
-#define TX_MIC_KEY_LEN				8
-#define RX_MIC_KEY_LEN				8
+#define WILC_TX_MIC_KEY_LEN			8
+#define WILC_RX_MIC_KEY_LEN			8
=20
 #define WILC_MAX_NUM_PMKIDS			16
 #define WILC_ADD_STA_LENGTH			40
@@ -115,7 +115,7 @@ struct wilc_probe_ssid {
 	u32 size;
 };
=20
-struct user_scan_req {
+struct wilc_user_scan_req {
 	void (*scan_result)(enum scan_event evt,
 			    struct wilc_rcvd_net_info *info, void *priv);
 	void *arg;
@@ -137,7 +137,7 @@ struct wilc_conn_info {
 	void *param;
 };
=20
-struct remain_ch {
+struct wilc_remain_ch {
 	u16 ch;
 	u32 duration;
 	void (*expired)(void *priv, u64 cookie);
@@ -147,9 +147,9 @@ struct remain_ch {
=20
 struct wilc;
 struct host_if_drv {
-	struct user_scan_req usr_scan_req;
+	struct wilc_user_scan_req usr_scan_req;
 	struct wilc_conn_info conn_info;
-	struct remain_ch remain_on_ch;
+	struct wilc_remain_ch remain_on_ch;
 	u64 p2p_timeout;
=20
 	enum host_if_state hif_state;
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000=
/wilc_spi.c
index 153e120..4a1be9e 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -814,7 +814,7 @@ static int wilc_spi_read(struct wilc *wilc, u32 addr, u=
8 *buf, u32 size)
  *
  ********************************************/
=20
-static int _wilc_spi_deinit(struct wilc *wilc)
+static int wilc_spi_deinit(struct wilc *wilc)
 {
 	/*
 	 * TODO:
@@ -1122,7 +1122,7 @@ static int wilc_spi_sync_ext(struct wilc *wilc, int n=
int)
 /* Global spi HIF function table */
 static const struct wilc_hif_func wilc_hif_spi =3D {
 	.hif_init =3D wilc_spi_init,
-	.hif_deinit =3D _wilc_spi_deinit,
+	.hif_deinit =3D wilc_spi_deinit,
 	.hif_read_reg =3D wilc_spi_read_reg,
 	.hif_write_reg =3D wilc_spi_write_reg,
 	.hif_block_rx =3D wilc_spi_read,
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/st=
aging/wilc1000/wilc_wfi_cfgoperations.c
index 8fb4bd4..5e7a467 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -27,7 +27,7 @@
 #define GAS_INITIAL_REQ			0x0a
 #define GAS_INITIAL_RSP			0x0b
=20
-#define INVALID_CHANNEL			0
+#define WILC_INVALID_CHANNEL		0
=20
 static const struct ieee80211_txrx_stypes
 	wilc_wfi_cfg80211_mgmt_types[NUM_NL80211_IFTYPES] =3D {
@@ -62,7 +62,7 @@ static const struct wiphy_wowlan_support wowlan_support =
=3D {
 	.flags =3D WIPHY_WOWLAN_ANY
 };
=20
-struct p2p_mgmt_data {
+struct wilc_p2p_mgmt_data {
 	int size;
 	u8 *buff;
 };
@@ -158,7 +158,7 @@ static void cfg_connect_result(enum conn_event conn_dis=
conn_evt, u8 mac_status,
 			wilc_wlan_set_bssid(priv->dev, NULL, WILC_STATION_MODE);
=20
 			if (vif->iftype !=3D WILC_CLIENT_MODE)
-				wl->sta_ch =3D INVALID_CHANNEL;
+				wl->sta_ch =3D WILC_INVALID_CHANNEL;
=20
 			netdev_err(dev, "Unspecified failure\n");
 		}
@@ -184,7 +184,7 @@ static void cfg_connect_result(enum conn_event conn_dis=
conn_evt, u8 mac_status,
 		wilc_wlan_set_bssid(priv->dev, NULL, WILC_STATION_MODE);
=20
 		if (vif->iftype !=3D WILC_CLIENT_MODE)
-			wl->sta_ch =3D INVALID_CHANNEL;
+			wl->sta_ch =3D WILC_INVALID_CHANNEL;
=20
 		if (wfi_drv->ifc_up && dev =3D=3D wl->vif[1]->ndev)
 			reason =3D 3;
@@ -446,7 +446,7 @@ static int connect(struct wiphy *wiphy, struct net_devi=
ce *dev,
 		netdev_err(dev, "wilc_set_join_req(): Error\n");
 		ret =3D -ENOENT;
 		if (vif->iftype !=3D WILC_CLIENT_MODE)
-			vif->wilc->sta_ch =3D INVALID_CHANNEL;
+			vif->wilc->sta_ch =3D WILC_INVALID_CHANNEL;
 		wilc_wlan_set_bssid(dev, NULL, WILC_STATION_MODE);
 		wfi_drv->conn_info.conn_result =3D NULL;
 		kfree(join_params);
@@ -484,7 +484,7 @@ static int disconnect(struct wiphy *wiphy, struct net_d=
evice *dev,
 	}
=20
 	if (vif->iftype !=3D WILC_CLIENT_MODE)
-		wilc->sta_ch =3D INVALID_CHANNEL;
+		wilc->sta_ch =3D WILC_INVALID_CHANNEL;
 	wilc_wlan_set_bssid(priv->dev, NULL, WILC_STATION_MODE);
=20
 	priv->p2p.local_random =3D 0x01;
@@ -974,7 +974,7 @@ static void wilc_wfi_cfg_parse_rx_action(u8 *buf, u32 l=
en, u8 sta_ch)
 			op_channel_attr_index =3D index;
 		index +=3D buf[index + 1] + 3;
 	}
-	if (sta_ch !=3D INVALID_CHANNEL)
+	if (sta_ch !=3D WILC_INVALID_CHANNEL)
 		wilc_wfi_cfg_parse_ch_attr(buf, channel_list_attr_index,
 					   op_channel_attr_index, sta_ch);
 }
@@ -999,7 +999,7 @@ static void wilc_wfi_cfg_parse_tx_action(u8 *buf, u32 l=
en, bool oper_ch,
 			op_channel_attr_index =3D index;
 		index +=3D buf[index + 1] + 3;
 	}
-	if (sta_ch !=3D INVALID_CHANNEL && oper_ch)
+	if (sta_ch !=3D WILC_INVALID_CHANNEL && oper_ch)
 		wilc_wfi_cfg_parse_ch_attr(buf, channel_list_attr_index,
 					   op_channel_attr_index, sta_ch);
 }
@@ -1115,7 +1115,7 @@ void wilc_wfi_p2p_rx(struct net_device *dev, u8 *buff=
, u32 size)
=20
 static void wilc_wfi_mgmt_tx_complete(void *priv, int status)
 {
-	struct p2p_mgmt_data *pv_data =3D priv;
+	struct wilc_p2p_mgmt_data *pv_data =3D priv;
=20
 	kfree(pv_data->buff);
 	kfree(pv_data);
@@ -1189,7 +1189,7 @@ static int cancel_remain_on_channel(struct wiphy *wip=
hy,
 }
=20
 static void wilc_wfi_cfg_tx_vendor_spec(struct wilc_priv *priv,
-					struct p2p_mgmt_data *mgmt_tx,
+					struct wilc_p2p_mgmt_data *mgmt_tx,
 					struct cfg80211_mgmt_tx_params *params,
 					u8 iftype, u32 buf_len)
 {
@@ -1249,7 +1249,7 @@ static int mgmt_tx(struct wiphy *wiphy,
 	const u8 *buf =3D params->buf;
 	size_t len =3D params->len;
 	const struct ieee80211_mgmt *mgmt;
-	struct p2p_mgmt_data *mgmt_tx;
+	struct wilc_p2p_mgmt_data *mgmt_tx;
 	struct wilc_priv *priv =3D wiphy_priv(wiphy);
 	struct host_if_drv *wfi_drv =3D priv->hif_drv;
 	struct wilc_vif *vif =3D netdev_priv(wdev->netdev);
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc100=
0/wilc_wlan.c
index 7a757c9..af1c4d8 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -523,7 +523,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *t=
xq_count)
 			if (vmm_sz & 0x3)
 				vmm_sz =3D (vmm_sz + 4) & ~0x3;
=20
-			if ((sum + vmm_sz) > LINUX_TX_SIZE)
+			if ((sum + vmm_sz) > WILC_TX_BUFF_SIZE)
 				break;
=20
 			vmm_table[i] =3D vmm_sz / 4;
@@ -811,7 +811,7 @@ static void wilc_wlan_handle_isr_ext(struct wilc *wilc,=
 u32 int_status)
 	if (size <=3D 0)
 		return;
=20
-	if (LINUX_RX_SIZE - offset < size)
+	if (WILC_RX_BUFF_SIZE - offset < size)
 		offset =3D 0;
=20
 	buffer =3D &wilc->rx_buffer[offset];
@@ -1314,7 +1314,7 @@ int wilc_wlan_init(struct net_device *dev)
 	}
=20
 	if (!wilc->tx_buffer)
-		wilc->tx_buffer =3D kmalloc(LINUX_TX_SIZE, GFP_KERNEL);
+		wilc->tx_buffer =3D kmalloc(WILC_TX_BUFF_SIZE, GFP_KERNEL);
=20
 	if (!wilc->tx_buffer) {
 		ret =3D -ENOBUFS;
@@ -1322,7 +1322,7 @@ int wilc_wlan_init(struct net_device *dev)
 	}
=20
 	if (!wilc->rx_buffer)
-		wilc->rx_buffer =3D kmalloc(LINUX_RX_SIZE, GFP_KERNEL);
+		wilc->rx_buffer =3D kmalloc(WILC_RX_BUFF_SIZE, GFP_KERNEL);
=20
 	if (!wilc->rx_buffer) {
 		ret =3D -ENOBUFS;
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc100=
0/wilc_wlan.h
index 1d61e20..d8fabe8 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -131,8 +131,8 @@
 #define WILC_PLL_TO_SPI		2
 #define ABORT_INT		BIT(31)
=20
-#define LINUX_RX_SIZE		(96 * 1024)
-#define LINUX_TX_SIZE		(64 * 1024)
+#define WILC_RX_BUFF_SIZE	(96 * 1024)
+#define WILC_TX_BUFF_SIZE	(64 * 1024)
=20
 #define MODALIAS		"WILC_SPI"
 #define GPIO_NUM		0x44
@@ -248,7 +248,7 @@ struct wilc_hif_func {
 	void (*disable_interrupt)(struct wilc *nic);
 };
=20
-#define MAX_CFG_FRAME_SIZE	1468
+#define WILC_MAX_CFG_FRAME_SIZE		1468
=20
 struct wilc_cfg_cmd_hdr {
 	u8 cmd_type;
@@ -259,7 +259,7 @@ struct wilc_cfg_cmd_hdr {
=20
 struct wilc_cfg_frame {
 	struct wilc_cfg_cmd_hdr hdr;
-	u8 frame[MAX_CFG_FRAME_SIZE];
+	u8 frame[WILC_MAX_CFG_FRAME_SIZE];
 };
=20
 struct wilc_cfg_rsp {
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wil=
c1000/wilc_wlan_cfg.c
index 67e9f93..9dc5de4 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -54,7 +54,7 @@ static int wilc_wlan_cfg_set_byte(u8 *frame, u32 offset, =
u16 id, u8 val8)
 {
 	u8 *buf;
=20
-	if ((offset + 4) >=3D MAX_CFG_FRAME_SIZE)
+	if ((offset + 4) >=3D WILC_MAX_CFG_FRAME_SIZE)
 		return 0;
=20
 	buf =3D &frame[offset];
@@ -71,7 +71,7 @@ static int wilc_wlan_cfg_set_hword(u8 *frame, u32 offset,=
 u16 id, u16 val16)
 {
 	u8 *buf;
=20
-	if ((offset + 5) >=3D MAX_CFG_FRAME_SIZE)
+	if ((offset + 5) >=3D WILC_MAX_CFG_FRAME_SIZE)
 		return 0;
=20
 	buf =3D &frame[offset];
@@ -90,7 +90,7 @@ static int wilc_wlan_cfg_set_word(u8 *frame, u32 offset, =
u16 id, u32 val32)
 {
 	u8 *buf;
=20
-	if ((offset + 7) >=3D MAX_CFG_FRAME_SIZE)
+	if ((offset + 7) >=3D WILC_MAX_CFG_FRAME_SIZE)
 		return 0;
=20
 	buf =3D &frame[offset];
@@ -112,7 +112,7 @@ static int wilc_wlan_cfg_set_str(u8 *frame, u32 offset,=
 u16 id, u8 *str,
 {
 	u8 *buf;
=20
-	if ((offset + size + 4) >=3D MAX_CFG_FRAME_SIZE)
+	if ((offset + size + 4) >=3D WILC_MAX_CFG_FRAME_SIZE)
 		return 0;
=20
 	buf =3D &frame[offset];
@@ -134,7 +134,7 @@ static int wilc_wlan_cfg_set_bin(u8 *frame, u32 offset,=
 u16 id, u8 *b, u32 size)
 	u32 i;
 	u8 checksum =3D 0;
=20
-	if ((offset + size + 5) >=3D MAX_CFG_FRAME_SIZE)
+	if ((offset + size + 5) >=3D WILC_MAX_CFG_FRAME_SIZE)
 		return 0;
=20
 	buf =3D &frame[offset];
@@ -309,7 +309,7 @@ int wilc_wlan_cfg_get_wid(u8 *frame, u32 offset, u16 id=
)
 {
 	u8 *buf;
=20
-	if ((offset + 2) >=3D MAX_CFG_FRAME_SIZE)
+	if ((offset + 2) >=3D WILC_MAX_CFG_FRAME_SIZE)
 		return 0;
=20
 	buf =3D &frame[offset];
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc=
1000/wilc_wlan_if.h
index 26aad49..9b8cce8 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -45,7 +45,7 @@ struct tx_complete_data {
  *
  ********************************************/
 #define WILC_MULTICAST_TABLE_SIZE	8
-#define MAX_RATES_SUPPORTED     12
+#define WILC_MAX_RATES_SUPPORTED     12
=20
 enum bss_types {
 	WILC_FW_BSS_TYPE_INFRA =3D 0,
--=20
2.7.4

