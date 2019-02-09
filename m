Return-Path: <SRS0=Ta2d=QQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEFBAC282CB
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 07:12:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85B9E20863
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 07:12:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="bmyVM8xL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726724AbfBIHMM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Feb 2019 02:12:12 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:14113 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfBIHMM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Feb 2019 02:12:12 -0500
X-IronPort-AV: E=Sophos;i="5.58,350,1544511600"; 
   d="scan'208";a="23610406"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES128-SHA; 09 Feb 2019 00:12:11 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.37) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sat, 9 Feb 2019 00:12:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rPxZDlvoPPUSzGw23sch9Ba9BRfNBz88bVNM2m2PlxQ=;
 b=bmyVM8xLbaM9aOkfnDpG/aot50JW2Xg7BfpejgEKgvpsjbI15qCDZK9YetYDIBTpxpQWt4tF08/zZdSkL7/9hsDPx8lUvc9lO7RBSSrVCc7KCIRc55icZgkUvcGU5+QaAg35wh4N5FR92iLS5UUljbXlpgoYyolAjoET27f78gI=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3128.namprd11.prod.outlook.com (20.177.227.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.21; Sat, 9 Feb 2019 07:12:09 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1601.016; Sat, 9 Feb 2019
 07:12:09 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <kvalo@codeaurora.org>,
        <johannes@sipsolutions.net>, <Adham.Abozaeid@microchip.com>,
        <Venkateswara.Kaja@microchip.com>, <Nicolas.Ferre@microchip.com>,
        <Claudiu.Beznea@microchip.com>, <Ajay.Kathat@microchip.com>
Subject: [PATCH 01/16] wilc1000: add host_interface.h
Thread-Topic: [PATCH 01/16] wilc1000: add host_interface.h
Thread-Index: AQHUwEbF9esqgCBG6k26NXUaCcOBNQ==
Date:   Sat, 9 Feb 2019 07:12:08 +0000
Message-ID: <1549696298-9795-2-git-send-email-ajay.kathat@microchip.com>
References: <1549696298-9795-1-git-send-email-ajay.kathat@microchip.com>
In-Reply-To: <1549696298-9795-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR0101CA0021.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:21::31) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.7.4
x-originating-ip: [183.82.17.42]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3128;6:HXacPq64nTCbWDWtsQCU1hXSCNPYQQENDVcw0iX60e4VMsJUV9wQLWYVTLpczmEghyOp6Th5xEyvj2mF69tXvCbtxHDrDznt1LDz7zkVeVhJ1tkENqsJSHnTS+GfLIs9CnZHlH2Ke8hwV48LJS2jAk5a5qpeKn95mhCgp6+YP0ON5UIm0k3gVnzddXzHx48SYY29B2mDGVZpq3hphalp57fZWgamtVANB3f6uSR61XQsMa6HAKx9QZOc5f7ug8W42T9+WCJbFvfAi7p0UecU/Z8Xf0tp2j1jOvuxhjHIN3qEUeMxLJsRnKJm/kFuWzRC1pDBL4gbFs+13KLuUDIAHNcartphHZED+uwHoZAw9rZ5MlrYt6WCYg4c2u1yO3JN4hB1L8bFdR5X1CP3e13k5wzsXjSzs/5CukNW+5cRA8r6KwgfKvfa/+eV5KMSf+0zZZfrKI3jDsTx7TVhmtJenQ==;5:Oh8w6W+20MDmgU4JptEX3R9syB1j34ovL2UiUOM8Lkkiz8Jxztki2WxZuEABqM99N5NcSznwtZS63t+i4K9RLIjMfh7w+gSjviMo+VzxYSZMVG4UwbAYzksBi/AG192CZ9l7VUyfH3IsQ2wTLR3lmSsmqJBojBlGF42TlPNY3/KZ/gTvrIrYZwVQVym3FPf3dJquMVlBNxjmCUU7zKtOiw==;7:FeAgh7HDaw6EQ0tFBQmSl8iWIeVje9hGEYyYKFUhBEZ6FR7YiBSqmKnIBu1EzcMHd83X1ewzbLUuiyT8cWzSafycFm54DSKjinluiBXS/KdiVOPlmDX9DXVypCcEktg96hmdvkMqai4l8wYwWr5Uig==
x-ms-office365-filtering-correlation-id: 89a22201-7432-42cf-aed5-08d68e5de773
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3128;
x-ms-traffictypediagnostic: BYAPR11MB3128:
x-microsoft-antispam-prvs: <BYAPR11MB3128155518D9B12147EEE670E36A0@BYAPR11MB3128.namprd11.prod.outlook.com>
x-forefront-prvs: 09435FCA72
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(376002)(39860400002)(366004)(346002)(189003)(199004)(78486014)(71200400001)(25786009)(14444005)(256004)(2906002)(14454004)(3846002)(71190400001)(86362001)(6116002)(316002)(486006)(72206003)(54906003)(53936002)(52116002)(76176011)(305945005)(2501003)(2616005)(26005)(68736007)(6486002)(7736002)(66066001)(2351001)(11346002)(4326008)(8936002)(476003)(50226002)(81156014)(8676002)(81166006)(6512007)(97736004)(107886003)(478600001)(186003)(446003)(106356001)(6916009)(105586002)(6436002)(5640700003)(102836004)(36756003)(99286004)(386003)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3128;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: tqiax9SJIty1nZPT3Z4WyA45vntdA37CIE99X69r7j7GEx97daHuIC/IzNtmNdNlEG8IdoVCotuaspGjbYA5X5DrfWBD/eHnkzHfHihXSC19BAQsLSOM4XAvdXVTrsVGli8ZVkel445s5Qhyi1xI6XM/tqr3V2HqofVeEHXmGNZzZ7BR+KqOuPBeCBlQ1WGd4gAFKmqcwpwDv5wXwkR+DAQ9dFgI+WoBa5rSTMMejJNrVFYvPnR8ftgOYgRkIl4sx9qXxwq/fJIQ9OH0gsc+/iRY884ooZG/IK031xeokbBrLDAZ8r0+c0tHpA2DFvhf4nC2r4QQOcCSabdyrAhw5B2JdFolPbdQq/F3I99EvmsGgwyAnlYeFGWCJ2unD6GFEsBfPAmFupX1Qi/0pDMz54zYQjrmZzxuPUVwltRFwKU=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 89a22201-7432-42cf-aed5-08d68e5de773
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2019 07:12:05.3673
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3128
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Moved '/driver/staging/wilc1000/host_interface.h' to
'drivers/net/wireless/microchip/wilc1000/'.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 .../wireless/microchip/wilc1000/host_interface.h   | 247 +++++++++++++++++=
++++
 1 file changed, 247 insertions(+)
 create mode 100644 drivers/net/wireless/microchip/wilc1000/host_interface.=
h

diff --git a/drivers/net/wireless/microchip/wilc1000/host_interface.h b/dri=
vers/net/wireless/microchip/wilc1000/host_interface.h
new file mode 100644
index 0000000..678e623
--- /dev/null
+++ b/drivers/net/wireless/microchip/wilc1000/host_interface.h
@@ -0,0 +1,247 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2012 - 2018 Microchip Technology Inc., and its subsidiari=
es
+ * All rights reserved.
+ */
+
+#ifndef HOST_INT_H
+#define HOST_INT_H
+#include <linux/ieee80211.h>
+#include "wilc_wlan_if.h"
+
+enum {
+	WILC_IDLE_MODE =3D 0x0,
+	WILC_AP_MODE =3D 0x1,
+	WILC_STATION_MODE =3D 0x2,
+	WILC_GO_MODE =3D 0x3,
+	WILC_CLIENT_MODE =3D 0x4
+};
+
+#define WILC_MAX_NUM_STA			9
+#define WILC_MAX_NUM_SCANNED_CH			14
+#define WILC_MAX_NUM_PROBED_SSID		10
+
+#define WILC_TX_MIC_KEY_LEN			8
+#define WILC_RX_MIC_KEY_LEN			8
+
+#define WILC_MAX_NUM_PMKIDS			16
+#define WILC_ADD_STA_LENGTH			40
+#define WILC_NUM_CONCURRENT_IFC			2
+
+enum {
+	WILC_SET_CFG =3D 0,
+	WILC_GET_CFG
+};
+
+#define WILC_MAX_ASSOC_RESP_FRAME_SIZE   256
+
+struct assoc_resp {
+	__le16 capab_info;
+	__le16 status_code;
+	__le16 aid;
+} __packed;
+
+struct rf_info {
+	u8 link_speed;
+	s8 rssi;
+	u32 tx_cnt;
+	u32 rx_cnt;
+	u32 tx_fail_cnt;
+};
+
+enum host_if_state {
+	HOST_IF_IDLE			=3D 0,
+	HOST_IF_SCANNING		=3D 1,
+	HOST_IF_CONNECTING		=3D 2,
+	HOST_IF_WAITING_CONN_RESP	=3D 3,
+	HOST_IF_CONNECTED		=3D 4,
+	HOST_IF_P2P_LISTEN		=3D 5,
+	HOST_IF_FORCE_32BIT		=3D 0xFFFFFFFF
+};
+
+struct wilc_pmkid {
+	u8 bssid[ETH_ALEN];
+	u8 pmkid[WLAN_PMKID_LEN];
+} __packed;
+
+struct wilc_pmkid_attr {
+	u8 numpmkid;
+	struct wilc_pmkid pmkidlist[WILC_MAX_NUM_PMKIDS];
+} __packed;
+
+struct cfg_param_attr {
+	u32 flag;
+	u16 short_retry_limit;
+	u16 long_retry_limit;
+	u16 frag_threshold;
+	u16 rts_threshold;
+};
+
+enum cfg_param {
+	WILC_CFG_PARAM_RETRY_SHORT =3D BIT(0),
+	WILC_CFG_PARAM_RETRY_LONG =3D BIT(1),
+	WILC_CFG_PARAM_FRAG_THRESHOLD =3D BIT(2),
+	WILC_CFG_PARAM_RTS_THRESHOLD =3D BIT(3)
+};
+
+enum scan_event {
+	SCAN_EVENT_NETWORK_FOUND	=3D 0,
+	SCAN_EVENT_DONE			=3D 1,
+	SCAN_EVENT_ABORTED		=3D 2,
+	SCAN_EVENT_FORCE_32BIT		=3D 0xFFFFFFFF
+};
+
+enum conn_event {
+	CONN_DISCONN_EVENT_CONN_RESP		=3D 0,
+	CONN_DISCONN_EVENT_DISCONN_NOTIF	=3D 1,
+	CONN_DISCONN_EVENT_FORCE_32BIT		=3D 0xFFFFFFFF
+};
+
+enum {
+	WILC_HIF_SDIO =3D 0,
+	WILC_HIF_SPI =3D BIT(0)
+};
+
+enum {
+	WILC_MAC_STATUS_INIT =3D -1,
+	WILC_MAC_STATUS_DISCONNECTED =3D 0,
+	WILC_MAC_STATUS_CONNECTED =3D 1
+};
+
+struct wilc_rcvd_net_info {
+	s8 rssi;
+	u8 ch;
+	u16 frame_len;
+	struct ieee80211_mgmt *mgmt;
+};
+
+struct wilc_probe_ssid_info {
+	u8 ssid_len;
+	u8 *ssid;
+};
+
+struct wilc_probe_ssid {
+	struct wilc_probe_ssid_info *ssid_info;
+	u8 n_ssids;
+	u32 size;
+};
+
+struct wilc_user_scan_req {
+	void (*scan_result)(enum scan_event evt,
+			    struct wilc_rcvd_net_info *info, void *priv);
+	void *arg;
+	u32 ch_cnt;
+};
+
+struct wilc_conn_info {
+	u8 bssid[ETH_ALEN];
+	u8 security;
+	enum authtype auth_type;
+	u8 ch;
+	u8 *req_ies;
+	size_t req_ies_len;
+	u8 *resp_ies;
+	u16 resp_ies_len;
+	u16 status;
+	void (*conn_result)(enum conn_event evt, u8 status, void *priv_data);
+	void *arg;
+	void *param;
+};
+
+struct wilc_remain_ch {
+	u16 ch;
+	u32 duration;
+	void (*expired)(void *priv, u64 cookie);
+	void *arg;
+	u32 cookie;
+};
+
+struct wilc;
+struct host_if_drv {
+	struct wilc_user_scan_req usr_scan_req;
+	struct wilc_conn_info conn_info;
+	struct wilc_remain_ch remain_on_ch;
+	u64 p2p_timeout;
+
+	enum host_if_state hif_state;
+
+	u8 assoc_bssid[ETH_ALEN];
+
+	struct timer_list scan_timer;
+	struct wilc_vif *scan_timer_vif;
+
+	struct timer_list connect_timer;
+	struct wilc_vif *connect_timer_vif;
+
+	struct timer_list remain_on_ch_timer;
+	struct wilc_vif *remain_on_ch_timer_vif;
+
+	bool ifc_up;
+	int driver_handler_id;
+	u8 assoc_resp[WILC_MAX_ASSOC_RESP_FRAME_SIZE];
+};
+
+struct wilc_vif;
+int wilc_remove_wep_key(struct wilc_vif *vif, u8 index);
+int wilc_set_wep_default_keyid(struct wilc_vif *vif, u8 index);
+int wilc_add_wep_key_bss_sta(struct wilc_vif *vif, const u8 *key, u8 len,
+			     u8 index);
+int wilc_add_wep_key_bss_ap(struct wilc_vif *vif, const u8 *key, u8 len,
+			    u8 index, u8 mode, enum authtype auth_type);
+int wilc_add_ptk(struct wilc_vif *vif, const u8 *ptk, u8 ptk_key_len,
+		 const u8 *mac_addr, const u8 *rx_mic, const u8 *tx_mic,
+		 u8 mode, u8 cipher_mode, u8 index);
+s32 wilc_get_inactive_time(struct wilc_vif *vif, const u8 *mac,
+			   u32 *out_val);
+int wilc_add_rx_gtk(struct wilc_vif *vif, const u8 *rx_gtk, u8 gtk_key_len=
,
+		    u8 index, u32 key_rsc_len, const u8 *key_rsc,
+		    const u8 *rx_mic, const u8 *tx_mic, u8 mode,
+		    u8 cipher_mode);
+int wilc_set_pmkid_info(struct wilc_vif *vif, struct wilc_pmkid_attr *pmki=
d);
+int wilc_get_mac_address(struct wilc_vif *vif, u8 *mac_addr);
+int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ies,
+		      size_t ies_len);
+int wilc_disconnect(struct wilc_vif *vif);
+int wilc_set_mac_chnl_num(struct wilc_vif *vif, u8 channel);
+int wilc_get_rssi(struct wilc_vif *vif, s8 *rssi_level);
+int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 scan_type,
+	      u8 *ch_freq_list, u8 ch_list_len, const u8 *ies, size_t ies_len,
+	      void (*scan_result_fn)(enum scan_event,
+				     struct wilc_rcvd_net_info *, void *),
+	      void *user_arg, struct wilc_probe_ssid *search);
+int wilc_hif_set_cfg(struct wilc_vif *vif,
+		     struct cfg_param_attr *cfg_param);
+int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler=
);
+int wilc_deinit(struct wilc_vif *vif);
+int wilc_add_beacon(struct wilc_vif *vif, u32 interval, u32 dtim_period,
+		    struct cfg80211_beacon_data *params);
+int wilc_del_beacon(struct wilc_vif *vif);
+int wilc_add_station(struct wilc_vif *vif, const u8 *mac,
+		     struct station_parameters *params);
+int wilc_del_allstation(struct wilc_vif *vif, u8 mac_addr[][ETH_ALEN]);
+int wilc_del_station(struct wilc_vif *vif, const u8 *mac_addr);
+int wilc_edit_station(struct wilc_vif *vif, const u8 *mac,
+		      struct station_parameters *params);
+int wilc_set_power_mgmt(struct wilc_vif *vif, bool enabled, u32 timeout);
+int wilc_setup_multicast_filter(struct wilc_vif *vif, u32 enabled, u32 cou=
nt,
+				u8 *mc_list);
+int wilc_remain_on_channel(struct wilc_vif *vif, u64 cookie,
+			   u32 duration, u16 chan,
+			   void (*expired)(void *, u64),
+			   void *user_arg);
+int wilc_listen_state_expired(struct wilc_vif *vif, u64 cookie);
+void wilc_frame_register(struct wilc_vif *vif, u16 frame_type, bool reg);
+int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index, u8 mode,
+			     u8 ifc_id);
+int wilc_set_operation_mode(struct wilc_vif *vif, u32 mode);
+int wilc_get_statistics(struct wilc_vif *vif, struct rf_info *stats);
+void wilc_resolve_disconnect_aberration(struct wilc_vif *vif);
+int wilc_get_vif_idx(struct wilc_vif *vif);
+int wilc_set_tx_power(struct wilc_vif *vif, u8 tx_power);
+int wilc_get_tx_power(struct wilc_vif *vif, u8 *tx_power);
+void wilc_scan_complete_received(struct wilc *wilc, u8 *buffer, u32 length=
);
+void wilc_network_info_received(struct wilc *wilc, u8 *buffer, u32 length)=
;
+void wilc_gnrl_async_info_received(struct wilc *wilc, u8 *buffer, u32 leng=
th);
+void *wilc_parse_join_bss_param(struct cfg80211_bss *bss,
+				struct cfg80211_crypto_settings *crypto);
+#endif
--=20
2.7.4

