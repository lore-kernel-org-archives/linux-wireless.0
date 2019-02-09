Return-Path: <SRS0=Ta2d=QQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51F34C282C4
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 07:12:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16B1E20863
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 07:12:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="xKUu6ane"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbfBIHMa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Feb 2019 02:12:30 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:14131 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbfBIHM3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Feb 2019 02:12:29 -0500
X-IronPort-AV: E=Sophos;i="5.58,350,1544511600"; 
   d="scan'208";a="23610412"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES128-SHA; 09 Feb 2019 00:12:29 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.37) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sat, 9 Feb 2019 00:12:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9O8vxx0bYZzDokTZJQBdnbSmldfmE2ofg88RmGU6I/o=;
 b=xKUu6anexC4KmzsJgbW693QWFPNRRW8ZuvoW+WltJe2odsJeEr0UHknufmSvsP6ANK01rHGhTGee5hC4ricelcdbdNu+qw1PHmA1Zo92cdvvRJksZGhELJjvitDJAaKTfm1y4L7p3aGXKHUmThAtdzykMQyXxLakKToxa3tL7uY=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3128.namprd11.prod.outlook.com (20.177.227.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.21; Sat, 9 Feb 2019 07:12:27 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1601.016; Sat, 9 Feb 2019
 07:12:27 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <kvalo@codeaurora.org>,
        <johannes@sipsolutions.net>, <Adham.Abozaeid@microchip.com>,
        <Venkateswara.Kaja@microchip.com>, <Nicolas.Ferre@microchip.com>,
        <Claudiu.Beznea@microchip.com>, <Ajay.Kathat@microchip.com>
Subject: [PATCH 06/16] wilc1000: add wilc_wfi_netdevice.h
Thread-Topic: [PATCH 06/16] wilc1000: add wilc_wfi_netdevice.h
Thread-Index: AQHUwEbQ808WIsm0iEe0hWNFkf6GKg==
Date:   Sat, 9 Feb 2019 07:12:27 +0000
Message-ID: <1549696298-9795-7-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3128;6:T1wR5zBx7YQQy+4QJ6BnK9/qlEqC1reIEVr3vKKLxDwaynV37Mbj3nvlbZL5COUsWCDwxJwAZTMIL8Y0mXzKcQsG/esa1YaHIRRADLQ/S8LcQuzDcTBce263zoBTa3MTLew/FfrA63ZmO+VUeHtq2Rm5bHYJQUaOsz8RsYtlM68pcIcvN6ZWuiqKd/LCLB9AzZRVi+HBNXh8gpNXyMTDp/qo/UmeKFBKAJ2fHjFJEw0fHxYFl4LVBPCkJci5jFQnMsEGxNB5AHYQGCpo8vcHbOoPFX2x4jhYI+b0bDt/gVFs5ycBOMohZBOpDtFVzNrzn3BtIwHcumfboCRMpIVXoIQ/Aj8zoa31ADI0TdPm/8J8FWI/ZAhQAmsl4bNu51Gl0td7g+2GzbOLZysZm8yHpVdO7LMMNHi6pOtvdVqMI6jrm13cRowZO1n9DYaCGH02ueOcznosq+x2SytayVbVtA==;5:X2apQSEhyWqGBUTCn+Fw4AuN40kd3gG3HBO/avPGpbwPHfym6Wa45NTkfD9jbTq7JuaEHRjNwwezq06iel5b9edzYPnYOxnolahhktnrCB4do5T5Dr4qwTcfv3YjkRPToe/4OrhGlmzuO1XX80XMlJLamme/pYy3gJ+cFnxO2IKItmkz4UobXKwCereJ2frEH/zHyJHrlJHuiWDSuJ03kQ==;7:VkirgDwGUeX4Je5Qq7H0sW1VSq/JgSmvyShUnpOBDpVZ7Cjo9uUJT0yZUWSo5jmTaX+I5aDjmWzzI3tvb2dqj53n+pR4+nzDF30V0f//Cxhy21HMTfABV6Df+mf1CM8xbbDYmVbwaXVU9A/gozUMPA==
x-ms-office365-filtering-correlation-id: febc0a7a-7a6c-4b16-3607-08d68e5df259
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3128;
x-ms-traffictypediagnostic: BYAPR11MB3128:
x-microsoft-antispam-prvs: <BYAPR11MB31283C99E92E86A89DF21D59E36A0@BYAPR11MB3128.namprd11.prod.outlook.com>
x-forefront-prvs: 09435FCA72
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(366004)(39860400002)(376002)(396003)(136003)(199004)(189003)(4326008)(8936002)(50226002)(476003)(52116002)(2616005)(2501003)(76176011)(305945005)(53936002)(6486002)(7736002)(66066001)(11346002)(2351001)(26005)(68736007)(6916009)(36756003)(6506007)(386003)(99286004)(6436002)(105586002)(102836004)(5640700003)(6512007)(8676002)(81156014)(81166006)(186003)(106356001)(446003)(97736004)(107886003)(478600001)(14444005)(256004)(71200400001)(78486014)(25786009)(316002)(54906003)(72206003)(486006)(14454004)(2906002)(86362001)(3846002)(6116002)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3128;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: H7Yo9jJNCHmH1hS8gwGdXLSwrqz4l4IiXeNQxAO5Xkr/HARCW/NM8G3uv+mC4BbNYtQOiTmcriLdIAWS8BaEfkPGRGpZp8d/fi8Z24/iRuQZEDjNLFTOYyN+p9oeCXMNnN1mOF8m0TL914fjA9Xli+HefrjXcGnloeeEq0hxqKDwmRgPL/ioSmRvxWk/C/MsQUGbPnQRfJoXhkkzb2Pu5hk2GdvDmMA4IGacAqT48yG4wpZcAltZdYnF/Oc9Z6K8QhrJcUXwb8KV+M8jHpVI92LHxpzoDA7Np/Cu5QkhoLyxsNNrN1CtswUkwO6Pc4yuQz3xL4qFvtSCWJGNl6wAjKn7TFOG6ndiGy1+NSH5LRnGK1bhkCbCrTy/KhStR1PKQJnLCPazw12Ayzg4ScKlfL3HBLZfctrhHf1OOaRBZgU=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: febc0a7a-7a6c-4b16-3607-08d68e5df259
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2019 07:12:24.3392
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

Moved '/driver/staging/wilc1000/wilc_wfi_netdevice.h' to
'drivers/net/wireless/microchip/wilc1000/'.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 .../microchip/wilc1000/wilc_wfi_netdevice.h        | 292 +++++++++++++++++=
++++
 1 file changed, 292 insertions(+)
 create mode 100644 drivers/net/wireless/microchip/wilc1000/wilc_wfi_netdev=
ice.h

diff --git a/drivers/net/wireless/microchip/wilc1000/wilc_wfi_netdevice.h b=
/drivers/net/wireless/microchip/wilc1000/wilc_wfi_netdevice.h
new file mode 100644
index 0000000..df00762
--- /dev/null
+++ b/drivers/net/wireless/microchip/wilc1000/wilc_wfi_netdevice.h
@@ -0,0 +1,292 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2012 - 2018 Microchip Technology Inc., and its subsidiari=
es.
+ * All rights reserved.
+ */
+
+#ifndef WILC_WFI_NETDEVICE
+#define WILC_WFI_NETDEVICE
+
+#include <linux/tcp.h>
+#include <linux/ieee80211.h>
+#include <net/cfg80211.h>
+#include <net/ieee80211_radiotap.h>
+#include <linux/if_arp.h>
+#include <linux/gpio/consumer.h>
+
+#include "host_interface.h"
+#include "wilc_wlan.h"
+#include "wilc_wlan_cfg.h"
+
+#define FLOW_CONTROL_LOWER_THRESHOLD		128
+#define FLOW_CONTROL_UPPER_THRESHOLD		256
+
+#define WILC_MAX_NUM_PMKIDS			16
+#define PMKID_FOUND				1
+#define NUM_STA_ASSOCIATED			8
+
+#define NUM_REG_FRAME				2
+
+#define TCP_ACK_FILTER_LINK_SPEED_THRESH	54
+#define DEFAULT_LINK_SPEED			72
+
+#define GET_PKT_OFFSET(a) (((a) >> 22) & 0x1ff)
+
+struct wilc_wfi_stats {
+	unsigned long rx_packets;
+	unsigned long tx_packets;
+	unsigned long rx_bytes;
+	unsigned long tx_bytes;
+	u64 rx_time;
+	u64 tx_time;
+
+};
+
+struct wilc_wfi_key {
+	u8 *key;
+	u8 *seq;
+	int key_len;
+	int seq_len;
+	u32 cipher;
+};
+
+struct wilc_wfi_wep_key {
+	u8 *key;
+	u8 key_len;
+	u8 key_idx;
+};
+
+struct sta_info {
+	u8 sta_associated_bss[WILC_MAX_NUM_STA][ETH_ALEN];
+};
+
+/*Parameters needed for host interface for  remaining on channel*/
+struct wilc_wfi_p2p_listen_params {
+	struct ieee80211_channel *listen_ch;
+	u32 listen_duration;
+	u64 listen_cookie;
+};
+
+struct wilc_p2p_var {
+	u8 local_random;
+	u8 recv_random;
+	bool is_wilc_ie;
+};
+
+static const u32 wilc_cipher_suites[] =3D {
+	WLAN_CIPHER_SUITE_WEP40,
+	WLAN_CIPHER_SUITE_WEP104,
+	WLAN_CIPHER_SUITE_TKIP,
+	WLAN_CIPHER_SUITE_CCMP,
+	WLAN_CIPHER_SUITE_AES_CMAC
+};
+
+#define CHAN2G(_channel, _freq, _flags) {	 \
+	.band             =3D NL80211_BAND_2GHZ, \
+	.center_freq      =3D (_freq),		 \
+	.hw_value         =3D (_channel),		 \
+	.flags            =3D (_flags),		 \
+	.max_antenna_gain =3D 0,			 \
+	.max_power        =3D 30,			 \
+}
+
+static const struct ieee80211_channel wilc_2ghz_channels[] =3D {
+	CHAN2G(1,  2412, 0),
+	CHAN2G(2,  2417, 0),
+	CHAN2G(3,  2422, 0),
+	CHAN2G(4,  2427, 0),
+	CHAN2G(5,  2432, 0),
+	CHAN2G(6,  2437, 0),
+	CHAN2G(7,  2442, 0),
+	CHAN2G(8,  2447, 0),
+	CHAN2G(9,  2452, 0),
+	CHAN2G(10, 2457, 0),
+	CHAN2G(11, 2462, 0),
+	CHAN2G(12, 2467, 0),
+	CHAN2G(13, 2472, 0),
+	CHAN2G(14, 2484, 0)
+};
+
+#define RATETAB_ENT(_rate, _hw_value, _flags) {	\
+	.bitrate  =3D (_rate),			\
+	.hw_value =3D (_hw_value),		\
+	.flags    =3D (_flags),			\
+}
+
+static struct ieee80211_rate wilc_bitrates[] =3D {
+	RATETAB_ENT(10,  0,  0),
+	RATETAB_ENT(20,  1,  0),
+	RATETAB_ENT(55,  2,  0),
+	RATETAB_ENT(110, 3,  0),
+	RATETAB_ENT(60,  9,  0),
+	RATETAB_ENT(90,  6,  0),
+	RATETAB_ENT(120, 7,  0),
+	RATETAB_ENT(180, 8,  0),
+	RATETAB_ENT(240, 9,  0),
+	RATETAB_ENT(360, 10, 0),
+	RATETAB_ENT(480, 11, 0),
+	RATETAB_ENT(540, 12, 0)
+};
+
+struct wilc_priv {
+	struct wireless_dev *wdev;
+	struct cfg80211_scan_request *scan_req;
+
+	struct wilc_wfi_p2p_listen_params remain_on_ch_params;
+	u64 tx_cookie;
+
+	bool cfg_scanning;
+
+	u8 associated_bss[ETH_ALEN];
+	struct sta_info assoc_stainfo;
+	struct sk_buff *skb;
+	struct net_device *dev;
+	struct host_if_drv *hif_drv;
+	struct wilc_pmkid_attr pmkid_list;
+	u8 wep_key[4][WLAN_KEY_LEN_WEP104];
+	u8 wep_key_len[4];
+	/* The real interface that the monitor is on */
+	struct net_device *real_ndev;
+	struct wilc_wfi_key *wilc_gtk[WILC_MAX_NUM_STA];
+	struct wilc_wfi_key *wilc_ptk[WILC_MAX_NUM_STA];
+	u8 wilc_groupkey;
+	/* mutexes */
+	struct mutex scan_req_lock;
+	bool p2p_listen_state;
+	int scanned_cnt;
+	struct wilc_p2p_var p2p;
+
+	struct ieee80211_channel channels[ARRAY_SIZE(wilc_2ghz_channels)];
+	struct ieee80211_rate bitrates[ARRAY_SIZE(wilc_bitrates)];
+	struct ieee80211_supported_band band;
+	u32 cipher_suites[ARRAY_SIZE(wilc_cipher_suites)];
+	u64 inc_roc_cookie;
+};
+
+struct frame_reg {
+	u16 type;
+	bool reg;
+};
+
+#define MAX_TCP_SESSION                25
+#define MAX_PENDING_ACKS               256
+
+struct ack_session_info {
+	u32 seq_num;
+	u32 bigger_ack_num;
+	u16 src_port;
+	u16 dst_port;
+	u16 status;
+};
+
+struct pending_acks {
+	u32 ack_num;
+	u32 session_index;
+	struct txq_entry_t  *txqe;
+};
+
+struct tcp_ack_filter {
+	struct ack_session_info ack_session_info[2 * MAX_TCP_SESSION];
+	struct pending_acks pending_acks[MAX_PENDING_ACKS];
+	u32 pending_base;
+	u32 tcp_session;
+	u32 pending_acks_idx;
+	bool enabled;
+};
+
+struct wilc_vif {
+	u8 idx;
+	u8 iftype;
+	int monitor_flag;
+	int mac_opened;
+	struct frame_reg frame_reg[NUM_REG_FRAME];
+	struct net_device_stats netstats;
+	struct wilc *wilc;
+	u8 src_addr[ETH_ALEN];
+	u8 bssid[ETH_ALEN];
+	struct host_if_drv *hif_drv;
+	struct net_device *ndev;
+	u8 mode;
+	u8 ifc_id;
+	struct timer_list during_ip_timer;
+	bool obtaining_ip;
+	struct timer_list periodic_rssi;
+	struct rf_info periodic_stat;
+	struct tcp_ack_filter ack_filter;
+	bool connecting;
+};
+
+struct wilc {
+	const struct wilc_hif_func *hif_func;
+	int io_type;
+	s8 mac_status;
+	struct gpio_desc *gpio_irq;
+	bool initialized;
+	int dev_irq_num;
+	int close;
+	u8 vif_num;
+	struct wilc_vif *vif[WILC_NUM_CONCURRENT_IFC];
+	u8 open_ifcs;
+	/*protect head of transmit queue*/
+	struct mutex txq_add_to_head_cs;
+	/*protect txq_entry_t transmit queue*/
+	spinlock_t txq_spinlock;
+	/*protect rxq_entry_t receiver queue*/
+	struct mutex rxq_cs;
+	/* lock to protect hif access */
+	struct mutex hif_cs;
+
+	struct completion cfg_event;
+	struct completion sync_event;
+	struct completion txq_event;
+	struct completion txq_thread_started;
+
+	struct task_struct *txq_thread;
+
+	int quit;
+	/* lock to protect issue of wid command to firmware */
+	struct mutex cfg_cmd_lock;
+	struct wilc_cfg_frame cfg_frame;
+	u32 cfg_frame_offset;
+	u8 cfg_seq_no;
+
+	u8 *rx_buffer;
+	u32 rx_buffer_offset;
+	u8 *tx_buffer;
+
+	struct txq_entry_t txq_head;
+	int txq_entries;
+
+	struct rxq_entry_t rxq_head;
+
+	const struct firmware *firmware;
+
+	struct device *dev;
+	bool suspend_event;
+
+	bool enable_ps;
+	int clients_count;
+	struct workqueue_struct *hif_workqueue;
+	enum chip_ps_states chip_ps_state;
+	struct wilc_cfg cfg;
+	void *bus_data;
+	struct net_device *monitor_dev;
+	/* deinit lock */
+	struct mutex deinit_lock;
+	u8 sta_ch;
+	u8 op_ch;
+};
+
+struct wilc_wfi_mon_priv {
+	struct net_device *real_ndev;
+};
+
+void wilc_frmw_to_host(struct wilc *wilc, u8 *buff, u32 size, u32 pkt_offs=
et);
+void wilc_mac_indicate(struct wilc *wilc);
+void wilc_netdev_cleanup(struct wilc *wilc);
+int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
+		     const struct wilc_hif_func *ops);
+void wilc_wfi_mgmt_rx(struct wilc *wilc, u8 *buff, u32 size);
+void wilc_wlan_set_bssid(struct net_device *wilc_netdev, u8 *bssid, u8 mod=
e);
+
+#endif
--=20
2.7.4

