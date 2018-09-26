Return-Path: <SRS0=mZ/2=MI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 263B1C43382
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 10:25:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD9D1214C5
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 10:25:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CD9D1214C5
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbeIZQhu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Sep 2018 12:37:50 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:39495 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727421AbeIZQhu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Sep 2018 12:37:50 -0400
X-IronPort-AV: E=Sophos;i="5.54,306,1534834800"; 
   d="scan'208";a="21366763"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES128-SHA; 26 Sep 2018 03:25:34 -0700
Received: from ajaysk-VirtualBox.microchip.com (10.10.76.4) by
 CHN-SV-EXCH01.mchp-main.com (10.10.76.37) with Microsoft SMTP Server id
 14.3.352.0; Wed, 26 Sep 2018 03:25:33 -0700
From:   Ajay Singh <ajay.kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <kvalo@codeaurora.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 01/19] wilc: add coreconfigurator.h
Date:   Wed, 26 Sep 2018 15:55:07 +0530
Message-ID: <1537957525-11467-2-git-send-email-ajay.kathat@microchip.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
References: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Moved '/driver/staging/wilc1000/coreconfigurator.h' to
'drivers/net/wireless/microchip/wilc/'.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 .../net/wireless/microchip/wilc/coreconfigurator.h | 81 ++++++++++++++++++++++
 1 file changed, 81 insertions(+)
 create mode 100644 drivers/net/wireless/microchip/wilc/coreconfigurator.h

diff --git a/drivers/net/wireless/microchip/wilc/coreconfigurator.h b/drivers/net/wireless/microchip/wilc/coreconfigurator.h
new file mode 100644
index 0000000..b62acb4
--- /dev/null
+++ b/drivers/net/wireless/microchip/wilc/coreconfigurator.h
@@ -0,0 +1,81 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2012 - 2018 Microchip Technology Inc., and its subsidiaries.
+ * All rights reserved.
+ */
+
+#ifndef CORECONFIGURATOR_H
+#define CORECONFIGURATOR_H
+
+#include "wilc_wlan_if.h"
+
+#define NUM_RSSI                5
+
+#define MAC_HDR_LEN             24
+#define FCS_LEN                 4
+#define TIME_STAMP_LEN          8
+#define BEACON_INTERVAL_LEN     2
+#define CAP_INFO_LEN            2
+#define STATUS_CODE_LEN         2
+#define AID_LEN                 2
+#define IE_HDR_LEN              2
+
+#define SET_CFG              0
+#define GET_CFG              1
+
+#define MAX_STRING_LEN               256
+#define MAX_ASSOC_RESP_FRAME_SIZE    MAX_STRING_LEN
+
+#define MAKE_WORD16(lsb, msb) ((((u16)(msb) << 8) & 0xFF00) | (lsb))
+#define MAKE_WORD32(lsw, msw) ((((u32)(msw) << 16) & 0xFFFF0000) | (lsw))
+
+struct rssi_history_buffer {
+	bool full;
+	u8 index;
+	s8 samples[NUM_RSSI];
+};
+
+struct network_info {
+	s8 rssi;
+	u16 cap_info;
+	u8 ssid[MAX_SSID_LEN];
+	u8 ssid_len;
+	u8 bssid[6];
+	u16 beacon_period;
+	u8 dtim_period;
+	u8 ch;
+	unsigned long time_scan_cached;
+	unsigned long time_scan;
+	bool new_network;
+	u8 found;
+	u32 tsf_lo;
+	u8 *ies;
+	u16 ies_len;
+	void *join_params;
+	struct rssi_history_buffer rssi_history;
+	u64 tsf_hi;
+};
+
+struct connect_info {
+	u8 bssid[6];
+	u8 *req_ies;
+	size_t req_ies_len;
+	u8 *resp_ies;
+	u16 resp_ies_len;
+	u16 status;
+};
+
+struct disconnect_info {
+	u16 reason;
+	u8 *ie;
+	size_t ie_len;
+};
+
+s32 wilc_parse_network_info(u8 *msg_buffer,
+			    struct network_info **ret_network_info);
+s32 wilc_parse_assoc_resp_info(u8 *buffer, u32 buffer_len,
+			       struct connect_info *ret_conn_info);
+void wilc_scan_complete_received(struct wilc *wilc, u8 *buffer, u32 length);
+void wilc_network_info_received(struct wilc *wilc, u8 *buffer, u32 length);
+void wilc_gnrl_async_info_received(struct wilc *wilc, u8 *buffer, u32 length);
+#endif
-- 
2.7.4

