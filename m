Return-Path: <SRS0=z7UY=PZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C8C5C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 13:21:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 438AE20652
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 13:21:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="a6lTXSDj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727749AbfAQNVr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 17 Jan 2019 08:21:47 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:44190 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727686AbfAQNVr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Jan 2019 08:21:47 -0500
X-IronPort-AV: E=Sophos;i="5.56,489,1539673200"; 
   d="scan'208";a="22718474"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 17 Jan 2019 06:21:46 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.38) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 17 Jan 2019 06:21:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZAASCmedC9yx/9jV6+wsXw97IkUOTR3PkySepIHlj7g=;
 b=a6lTXSDjlLZGeUqmtRuypEXGafqmlDwZ8Q+shTcnLMzHzwxtTVILCeTYMyxcB7tpJOwrf3mqCkUyWFzlko0SB+NwVlhpW4yStfFjjeIe6nvdS/ZaSozfB1mhvrlUy9hxdHbzvFw2gVyMay0zJuDyZZ2O8fuuqdD6KFvK6+rZnt4=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2534.namprd11.prod.outlook.com (52.135.226.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.25; Thu, 17 Jan 2019 13:21:44 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::c110:8559:a438:491d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::c110:8559:a438:491d%3]) with mapi id 15.20.1516.019; Thu, 17 Jan 2019
 13:21:44 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 13/13] staging: wilc1000: avoid the use of typedef for
 function pointers
Thread-Topic: [PATCH 13/13] staging: wilc1000: avoid the use of typedef for
 function pointers
Thread-Index: AQHUrmeXYkQVaMGxBUKMK2zBcvTe2A==
Date:   Thu, 17 Jan 2019 13:21:44 +0000
Message-ID: <1547731250-18518-14-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2534;6:KNBwP9I/CAwLpnKHmmR+pqDpZFHxo1IcuP3FUi+qfKs3KWnr2rD+dZ3DxT1cvK0euM9TaFrvMkvoi9O3/LKZobxR20smoGkz3SPGt4Kiwm1ZNi5KyLCUiouSwNplxCofjKgeaeYs+Dvbv8XFJf813S3LU+H697+8Sv387C9SyZu0AI5Dn4cayQdxCuDWjjzcHw9CDqVOxR+Ps6yq/QBpqDBiwZ4xbyi1KpGWAXCi4wwZoWL3JVaKdv15Q3Nd+HtUpQMS/IUbyZ9c+J38avnFujTAJNQ27ZKBuuvpRrqSbV56Q3rktht4O4KHg+Qpvn3WXS5/vnphjgMvvGKYyy4fFguHHnM/F/k1WQ57trFl0t11wiqiAgPcYRiYMwhh4eYnUJcJNQqd/umKjvM2NAf9fsfRAmrBk2Flipcit/+LrlaKfb3BX6rSgvR3QOuHpr0wXAD9+g1wK/qBj7tkP9P0tA==;5:WK7JbwaDYjD05KVQOdfJpMZhMSi+RqBq251i2Oul0l5Zy6oyD3Uf9mBqiGFF3MkDNMRYiG1kf/3h6LGr/Lfe2p/aGzfBZG+FENjeEhZ8a5Cj6P6++VFKJH6MF7hPSpFCZ/irpkaiEStLAgDpobFwknRlK3uy4jq3j1+1+9mX3Dln9yo+wSPLrgBeTsBVSY7xE57xHlF7OpsXFpicHaHV3Q==;7:w6fP7g1GRMHFs+YGWyhje87f0gzV1Rmv7+wTb9rIC9X2RAXLbbGgToY6CUF9U0WGqqRRDMZQAklqiBHL4OBdvSVoMOV64ZOP3PJ4J1i4olk230KGUnmi1NnDE4lnB9sc/fGmCzqdGBPij0CArxL8bw==
x-ms-office365-filtering-correlation-id: 7c925bc5-0250-47b6-5054-08d67c7eb9a4
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2534;
x-ms-traffictypediagnostic: BYAPR11MB2534:
x-microsoft-antispam-prvs: <BYAPR11MB253458745B32E656B4CBC4A6E3830@BYAPR11MB2534.namprd11.prod.outlook.com>
x-forefront-prvs: 0920602B08
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(136003)(346002)(39860400002)(376002)(199004)(189003)(6916009)(6116002)(3846002)(386003)(6506007)(14454004)(2616005)(66066001)(7736002)(78486014)(71190400001)(71200400001)(5660300001)(102836004)(476003)(305945005)(52116002)(76176011)(446003)(106356001)(81166006)(81156014)(486006)(11346002)(316002)(8936002)(54906003)(8676002)(99286004)(50226002)(2351001)(72206003)(478600001)(68736007)(25786009)(186003)(5640700003)(2906002)(26005)(105586002)(53936002)(6512007)(36756003)(6436002)(6486002)(256004)(14444005)(4326008)(107886003)(2501003)(86362001)(97736004);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2534;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Yh/OFkyc2OAoS1mndXAh3HVl7O6+7h2DbbwQ0GuyCFYyGP8NZh8g2tW4/CFnG6Aan69H20FvE7ldRRz19k53zdNDYSDUD/QkdONBoNuKvNFSHw35xX1mMwvqzZPW7BHQ83tODEubzKHev4UJmkIlK9g3A/65bAaWykgU779T+TmNqKgd44cNmA8AHwl7MPSRWUCt6zpRMC6SO6Qaca97jqZ7L6mYW2bz2UwEZ5bWofyTK1mj3sAL3P8c/pOpY2CAimA27QHEJAeDJTqlgvT7+DJIxGscqSba3gURU3Zp3RLh0XjTls7XZ3M3oG0EmY8Kb5h+E9gm1Vxiwe3NgYL7YJ1hW32j7yb1imF3EXlX+5rJVRE3hrOuRJfMganyYP+i2hJqf8f0wMWmGCbAlnPj++Mp6eJUIP2GC7Z4Wg+QCU0=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c925bc5-0250-47b6-5054-08d67c7eb9a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2019 13:21:42.0946
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2534
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Remove typedef for function pointers.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 13 +++++++------
 drivers/staging/wilc1000/host_interface.h | 24 ++++++++++--------------
 drivers/staging/wilc1000/wilc_wlan.c      | 10 ++++++----
 drivers/staging/wilc1000/wilc_wlan.h      |  5 +++--
 drivers/staging/wilc1000/wilc_wlan_if.h   |  2 --
 5 files changed, 26 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index f463865..85573eb 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -231,9 +231,10 @@ static int handle_scan_done(struct wilc_vif *vif, enum=
 scan_event evt)
 }
=20
 int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 scan_type,
-	      u8 *ch_freq_list, u8 ch_list_len, const u8 *ies,
-	      size_t ies_len, wilc_scan_result scan_result, void *user_arg,
-	      struct wilc_probe_ssid *search)
+	      u8 *ch_freq_list, u8 ch_list_len, const u8 *ies, size_t ies_len,
+	      void (*scan_result_fn)(enum scan_event,
+				     struct wilc_rcvd_net_info *, void *),
+	      void *user_arg, struct wilc_probe_ssid *search)
 {
 	int result =3D 0;
 	struct wid wid_list[5];
@@ -322,7 +323,7 @@ int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 =
scan_type,
 		goto error;
 	}
=20
-	hif_drv->usr_scan_req.scan_result =3D scan_result;
+	hif_drv->usr_scan_req.scan_result =3D scan_result_fn;
 	hif_drv->usr_scan_req.arg =3D user_arg;
 	hif_drv->scan_timer_vif =3D vif;
 	mod_timer(&hif_drv->scan_timer,
@@ -1863,8 +1864,8 @@ void wilc_scan_complete_received(struct wilc *wilc, u=
8 *buffer, u32 length)
=20
 int wilc_remain_on_channel(struct wilc_vif *vif, u32 session_id,
 			   u32 duration, u16 chan,
-			   wilc_remain_on_chan_expired expired,
-			   wilc_remain_on_chan_ready ready,
+			   void (*expired)(void *, u32),
+			   void (*ready)(void *),
 			   void *user_arg)
 {
 	struct remain_ch roc;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wi=
lc1000/host_interface.h
index 527ae05..7f3fc4c 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -104,12 +104,6 @@ struct wilc_rcvd_net_info {
 	struct ieee80211_mgmt *mgmt;
 };
=20
-typedef void (*wilc_scan_result)(enum scan_event, struct wilc_rcvd_net_inf=
o *,
-				 void *);
-
-typedef void (*wilc_remain_on_chan_expired)(void *, u32);
-typedef void (*wilc_remain_on_chan_ready)(void *);
-
 struct wilc_probe_ssid_info {
 	u8 ssid_len;
 	u8 *ssid;
@@ -122,7 +116,8 @@ struct wilc_probe_ssid {
 };
=20
 struct user_scan_req {
-	wilc_scan_result scan_result;
+	void (*scan_result)(enum scan_event evt,
+			    struct wilc_rcvd_net_info *info, void *priv);
 	void *arg;
 	u32 ch_cnt;
 };
@@ -145,8 +140,8 @@ struct wilc_conn_info {
 struct remain_ch {
 	u16 ch;
 	u32 duration;
-	wilc_remain_on_chan_expired expired;
-	wilc_remain_on_chan_ready ready;
+	void (*expired)(void *priv, u32 session_id);
+	void (*ready)(void *priv);
 	void *arg;
 	u32 id;
 };
@@ -213,9 +208,10 @@ int wilc_disconnect(struct wilc_vif *vif);
 int wilc_set_mac_chnl_num(struct wilc_vif *vif, u8 channel);
 int wilc_get_rssi(struct wilc_vif *vif, s8 *rssi_level);
 int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 scan_type,
-	      u8 *ch_freq_list, u8 ch_list_len, const u8 *ies,
-	      size_t ies_len, wilc_scan_result scan_result, void *user_arg,
-	      struct wilc_probe_ssid *search);
+	      u8 *ch_freq_list, u8 ch_list_len, const u8 *ies, size_t ies_len,
+	      void (*scan_result_fn)(enum scan_event,
+				     struct wilc_rcvd_net_info *, void *),
+	      void *user_arg, struct wilc_probe_ssid *search);
 int wilc_hif_set_cfg(struct wilc_vif *vif,
 		     struct cfg_param_attr *cfg_param);
 int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler=
);
@@ -234,8 +230,8 @@ int wilc_setup_multicast_filter(struct wilc_vif *vif, u=
32 enabled, u32 count,
 				u8 *mc_list);
 int wilc_remain_on_channel(struct wilc_vif *vif, u32 session_id,
 			   u32 duration, u16 chan,
-			   wilc_remain_on_chan_expired expired,
-			   wilc_remain_on_chan_ready ready,
+			   void (*expired)(void *, u32),
+			   void (*ready)(void *),
 			   void *user_arg);
 int wilc_listen_state_expired(struct wilc_vif *vif, u32 session_id);
 void wilc_frame_register(struct wilc_vif *vif, u16 frame_type, bool reg);
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc100=
0/wilc_wlan.c
index 16b6c55..9d3aaae 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -274,7 +274,8 @@ static int wilc_wlan_txq_add_cfg_pkt(struct wilc_vif *v=
if, u8 *buffer,
 }
=20
 int wilc_wlan_txq_add_net_pkt(struct net_device *dev, void *priv, u8 *buff=
er,
-			      u32 buffer_size, wilc_tx_complete_func_t func)
+			      u32 buffer_size,
+			      void (*tx_complete_fn)(void *, int))
 {
 	struct txq_entry_t *tqe;
 	struct wilc_vif *vif =3D netdev_priv(dev);
@@ -292,7 +293,7 @@ int wilc_wlan_txq_add_net_pkt(struct net_device *dev, v=
oid *priv, u8 *buffer,
 	tqe->type =3D WILC_NET_PKT;
 	tqe->buffer =3D buffer;
 	tqe->buffer_size =3D buffer_size;
-	tqe->tx_complete_func =3D func;
+	tqe->tx_complete_func =3D tx_complete_fn;
 	tqe->priv =3D priv;
=20
 	tqe->ack_idx =3D NOT_TCP_ACK;
@@ -303,7 +304,8 @@ int wilc_wlan_txq_add_net_pkt(struct net_device *dev, v=
oid *priv, u8 *buffer,
 }
=20
 int wilc_wlan_txq_add_mgmt_pkt(struct net_device *dev, void *priv, u8 *buf=
fer,
-			       u32 buffer_size, wilc_tx_complete_func_t func)
+			       u32 buffer_size,
+			       void (*tx_complete_fn)(void *, int))
 {
 	struct txq_entry_t *tqe;
 	struct wilc_vif *vif =3D netdev_priv(dev);
@@ -321,7 +323,7 @@ int wilc_wlan_txq_add_mgmt_pkt(struct net_device *dev, =
void *priv, u8 *buffer,
 	tqe->type =3D WILC_MGMT_PKT;
 	tqe->buffer =3D buffer;
 	tqe->buffer_size =3D buffer_size;
-	tqe->tx_complete_func =3D func;
+	tqe->tx_complete_func =3D tx_complete_fn;
 	tqe->priv =3D priv;
 	tqe->ack_idx =3D NOT_TCP_ACK;
 	wilc_wlan_txq_add_to_tail(dev, tqe);
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc100=
0/wilc_wlan.h
index c8ca13b..3880452 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -275,7 +275,8 @@ int wilc_wlan_firmware_download(struct wilc *wilc, cons=
t u8 *buffer,
 int wilc_wlan_start(struct wilc *wilc);
 int wilc_wlan_stop(struct wilc *wilc);
 int wilc_wlan_txq_add_net_pkt(struct net_device *dev, void *priv, u8 *buff=
er,
-			      u32 buffer_size, wilc_tx_complete_func_t func);
+			      u32 buffer_size,
+			      void (*tx_complete_fn)(void *, int));
 int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count);
 void wilc_handle_isr(struct wilc *wilc);
 void wilc_wlan_cleanup(struct net_device *dev);
@@ -286,7 +287,7 @@ int wilc_wlan_cfg_get(struct wilc_vif *vif, int start, =
u16 wid, int commit,
 int wilc_wlan_cfg_get_val(struct wilc *wl, u16 wid, u8 *buffer,
 			  u32 buffer_size);
 int wilc_wlan_txq_add_mgmt_pkt(struct net_device *dev, void *priv, u8 *buf=
fer,
-			       u32 buffer_size, wilc_tx_complete_func_t func);
+			       u32 buffer_size, void (*func)(void *, int));
 void wilc_chip_sleep_manually(struct wilc *wilc);
=20
 void wilc_enable_tcp_ack_filter(struct wilc_vif *vif, bool value);
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc=
1000/wilc_wlan_if.h
index 961b6bb..9370caa 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -39,8 +39,6 @@ struct tx_complete_data {
 	struct sk_buff *skb;
 };
=20
-typedef void (*wilc_tx_complete_func_t)(void *, int);
-
 /********************************************
  *
  *      Wlan Configuration ID
--=20
2.7.4

