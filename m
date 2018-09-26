Return-Path: <SRS0=mZ/2=MI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59E9FECE562
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 10:26:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D45C214DD
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 10:26:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1D45C214DD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728077AbeIZQiW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Sep 2018 12:38:22 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:39495 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726937AbeIZQiV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Sep 2018 12:38:21 -0400
X-IronPort-AV: E=Sophos;i="5.54,306,1534834800"; 
   d="scan'208";a="21366790"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES128-SHA; 26 Sep 2018 03:26:05 -0700
Received: from ajaysk-VirtualBox.microchip.com (10.10.76.4) by
 CHN-SV-EXCH01.mchp-main.com (10.10.76.37) with Microsoft SMTP Server id
 14.3.352.0; Wed, 26 Sep 2018 03:26:04 -0700
From:   Ajay Singh <ajay.kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <kvalo@codeaurora.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 10/19] wilc: add wilc_wfi_netdevice.h
Date:   Wed, 26 Sep 2018 15:55:16 +0530
Message-ID: <1537957525-11467-11-git-send-email-ajay.kathat@microchip.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
References: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Moved '/driver/staging/wilc1000/wilc_wfi_netdevice.h' to
'drivers/net/wireless/microchip/wilc/'.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 .../wireless/microchip/wilc/wilc_wfi_netdevice.h   | 230 +++++++++++++++++++++
 1 file changed, 230 insertions(+)
 create mode 100644 drivers/net/wireless/microchip/wilc/wilc_wfi_netdevice.h

diff --git a/drivers/net/wireless/microchip/wilc/wilc_wfi_netdevice.h b/drivers/net/wireless/microchip/wilc/wilc_wfi_netdevice.h
new file mode 100644
index 0000000..4f05a16
--- /dev/null
+++ b/drivers/net/wireless/microchip/wilc/wilc_wfi_netdevice.h
@@ -0,0 +1,230 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2012 - 2018 Microchip Technology Inc., and its subsidiaries.
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
+#define PMKID_LEN				16
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
+	u8 sta_associated_bss[MAX_NUM_STA][ETH_ALEN];
+};
+
+/*Parameters needed for host interface for  remaining on channel*/
+struct wilc_wfi_p2p_listen_params {
+	struct ieee80211_channel *listen_ch;
+	u32 listen_duration;
+	u64 listen_cookie;
+	u32 listen_session_id;
+};
+
+struct wilc_p2p_var {
+	u8 local_random;
+	u8 recv_random;
+	bool is_wilc_ie;
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
+	u32 rcvd_ch_cnt;
+
+	u8 associated_bss[ETH_ALEN];
+	struct sta_info assoc_stainfo;
+	struct sk_buff *skb;
+	struct net_device *dev;
+	struct host_if_drv *hif_drv;
+	struct host_if_pmkid_attr pmkid_list;
+	u8 wep_key[4][WLAN_KEY_LEN_WEP104];
+	u8 wep_key_len[4];
+	/* The real interface that the monitor is on */
+	struct net_device *real_ndev;
+	struct wilc_wfi_key *wilc_gtk[MAX_NUM_STA];
+	struct wilc_wfi_key *wilc_ptk[MAX_NUM_STA];
+	u8 wilc_groupkey;
+	/* mutexes */
+	struct mutex scan_req_lock;
+	bool p2p_listen_state;
+	struct timer_list aging_timer;
+	struct network_info scanned_shadow[MAX_NUM_SCANNED_NETWORKS_SHADOW];
+	int scanned_cnt;
+	struct wilc_p2p_var p2p;
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
+	struct wilc_vif *vif[NUM_CONCURRENT_IFC];
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
+	int cfg_frame_in_use;
+	struct wilc_cfg_frame cfg_frame;
+	u32 cfg_frame_offset;
+	int cfg_seq_no;
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
+};
+
+struct wilc_wfi_mon_priv {
+	struct net_device *real_ndev;
+};
+
+void wilc_frmw_to_linux(struct wilc *wilc, u8 *buff, u32 size, u32 pkt_offset);
+void wilc_mac_indicate(struct wilc *wilc);
+void wilc_netdev_cleanup(struct wilc *wilc);
+int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
+		     const struct wilc_hif_func *ops);
+void wilc_wfi_mgmt_rx(struct wilc *wilc, u8 *buff, u32 size);
+void wilc_wlan_set_bssid(struct net_device *wilc_netdev, u8 *bssid, u8 mode);
+
+#endif
-- 
2.7.4

