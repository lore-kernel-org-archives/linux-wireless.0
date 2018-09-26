Return-Path: <SRS0=mZ/2=MI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64FBCC46470
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 10:25:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28EF021508
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 10:25:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 28EF021508
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727523AbeIZQiM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Sep 2018 12:38:12 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:39495 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726802AbeIZQiK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Sep 2018 12:38:10 -0400
X-IronPort-AV: E=Sophos;i="5.54,306,1534834800"; 
   d="scan'208";a="21366779"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES128-SHA; 26 Sep 2018 03:25:54 -0700
Received: from ajaysk-VirtualBox.microchip.com (10.10.76.4) by
 CHN-SV-EXCH01.mchp-main.com (10.10.76.37) with Microsoft SMTP Server id
 14.3.352.0; Wed, 26 Sep 2018 03:25:54 -0700
From:   Ajay Singh <ajay.kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <kvalo@codeaurora.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 07/19] wilc: add wilc_wlan_cfg.c
Date:   Wed, 26 Sep 2018 15:55:13 +0530
Message-ID: <1537957525-11467-8-git-send-email-ajay.kathat@microchip.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
References: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Moved '/driver/staging/wilc1000/wilc_wlan_cfg.c' to
'drivers/net/wireless/microchip/wilc/'.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 .../net/wireless/microchip/wilc/wilc_wlan_cfg.c    | 497 +++++++++++++++++++++
 1 file changed, 497 insertions(+)
 create mode 100644 drivers/net/wireless/microchip/wilc/wilc_wlan_cfg.c

diff --git a/drivers/net/wireless/microchip/wilc/wilc_wlan_cfg.c b/drivers/net/wireless/microchip/wilc/wilc_wlan_cfg.c
new file mode 100644
index 0000000..930a389
--- /dev/null
+++ b/drivers/net/wireless/microchip/wilc/wilc_wlan_cfg.c
@@ -0,0 +1,497 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2012 - 2018 Microchip Technology Inc., and its subsidiaries.
+ * All rights reserved.
+ */
+
+#include "wilc_wlan_if.h"
+#include "wilc_wlan.h"
+#include "wilc_wlan_cfg.h"
+#include "coreconfigurator.h"
+#include "wilc_wfi_netdevice.h"
+
+enum cfg_cmd_type {
+	CFG_BYTE_CMD	= 0,
+	CFG_HWORD_CMD	= 1,
+	CFG_WORD_CMD	= 2,
+	CFG_STR_CMD	= 3,
+	CFG_BIN_CMD	= 4
+};
+
+static const struct wilc_cfg_byte g_cfg_byte[] = {
+	{WID_STATUS, 0},
+	{WID_RSSI, 0},
+	{WID_LINKSPEED, 0},
+	{WID_NIL, 0}
+};
+
+static const struct wilc_cfg_hword g_cfg_hword[] = {
+	{WID_NIL, 0}
+};
+
+static const struct wilc_cfg_word g_cfg_word[] = {
+	{WID_FAILED_COUNT, 0},
+	{WID_RECEIVED_FRAGMENT_COUNT, 0},
+	{WID_SUCCESS_FRAME_COUNT, 0},
+	{WID_GET_INACTIVE_TIME, 0},
+	{WID_NIL, 0}
+
+};
+
+static const struct wilc_cfg_str g_cfg_str[] = {
+	{WID_FIRMWARE_VERSION, NULL},
+	{WID_MAC_ADDR, NULL},
+	{WID_ASSOC_RES_INFO, NULL},
+	{WID_NIL, NULL}
+};
+
+/********************************************
+ *
+ *      Configuration Functions
+ *
+ ********************************************/
+
+static int wilc_wlan_cfg_set_byte(u8 *frame, u32 offset, u16 id, u8 val8)
+{
+	u8 *buf;
+
+	if ((offset + 4) >= MAX_CFG_FRAME_SIZE)
+		return 0;
+
+	buf = &frame[offset];
+
+	buf[0] = (u8)id;
+	buf[1] = (u8)(id >> 8);
+	buf[2] = 1;
+	buf[3] = 0;
+	buf[4] = val8;
+	return 5;
+}
+
+static int wilc_wlan_cfg_set_hword(u8 *frame, u32 offset, u16 id, u16 val16)
+{
+	u8 *buf;
+
+	if ((offset + 5) >= MAX_CFG_FRAME_SIZE)
+		return 0;
+
+	buf = &frame[offset];
+
+	buf[0] = (u8)id;
+	buf[1] = (u8)(id >> 8);
+	buf[2] = 2;
+	buf[3] = 0;
+	buf[4] = (u8)val16;
+	buf[5] = (u8)(val16 >> 8);
+
+	return 6;
+}
+
+static int wilc_wlan_cfg_set_word(u8 *frame, u32 offset, u16 id, u32 val32)
+{
+	u8 *buf;
+
+	if ((offset + 7) >= MAX_CFG_FRAME_SIZE)
+		return 0;
+
+	buf = &frame[offset];
+
+	buf[0] = (u8)id;
+	buf[1] = (u8)(id >> 8);
+	buf[2] = 4;
+	buf[3] = 0;
+	buf[4] = (u8)val32;
+	buf[5] = (u8)(val32 >> 8);
+	buf[6] = (u8)(val32 >> 16);
+	buf[7] = (u8)(val32 >> 24);
+
+	return 8;
+}
+
+static int wilc_wlan_cfg_set_str(u8 *frame, u32 offset, u16 id, u8 *str,
+				 u32 size)
+{
+	u8 *buf;
+
+	if ((offset + size + 4) >= MAX_CFG_FRAME_SIZE)
+		return 0;
+
+	buf = &frame[offset];
+
+	buf[0] = (u8)id;
+	buf[1] = (u8)(id >> 8);
+	buf[2] = (u8)size;
+	buf[3] = (u8)(size >> 8);
+
+	if (str && size != 0)
+		memcpy(&buf[4], str, size);
+
+	return (size + 4);
+}
+
+static int wilc_wlan_cfg_set_bin(u8 *frame, u32 offset, u16 id, u8 *b, u32 size)
+{
+	u8 *buf;
+	u32 i;
+	u8 checksum = 0;
+
+	if ((offset + size + 5) >= MAX_CFG_FRAME_SIZE)
+		return 0;
+
+	buf = &frame[offset];
+	buf[0] = (u8)id;
+	buf[1] = (u8)(id >> 8);
+	buf[2] = (u8)size;
+	buf[3] = (u8)(size >> 8);
+
+	if ((b) && size != 0) {
+		memcpy(&buf[4], b, size);
+		for (i = 0; i < size; i++)
+			checksum += buf[i + 4];
+	}
+
+	buf[size + 4] = checksum;
+
+	return (size + 5);
+}
+
+/********************************************
+ *
+ *      Configuration Response Functions
+ *
+ ********************************************/
+
+#define GET_WID_TYPE(wid)		(((wid) >> 12) & 0x7)
+static void wilc_wlan_parse_response_frame(struct wilc *wl, u8 *info, int size)
+{
+	u16 wid;
+	u32 len = 0, i = 0;
+
+	while (size > 0) {
+		i = 0;
+		wid = info[0] | (info[1] << 8);
+
+		switch (GET_WID_TYPE(wid)) {
+		case WID_CHAR:
+			do {
+				if (wl->cfg.b[i].id == WID_NIL)
+					break;
+
+				if (wl->cfg.b[i].id == wid) {
+					wl->cfg.b[i].val = info[4];
+					break;
+				}
+				i++;
+			} while (1);
+			len = 3;
+			break;
+
+		case WID_SHORT:
+			do {
+				if (wl->cfg.hw[i].id == WID_NIL)
+					break;
+
+				if (wl->cfg.hw[i].id == wid) {
+					wl->cfg.hw[i].val = (info[4] |
+							     (info[5] << 8));
+					break;
+				}
+				i++;
+			} while (1);
+			len = 4;
+			break;
+
+		case WID_INT:
+			do {
+				if (wl->cfg.w[i].id == WID_NIL)
+					break;
+
+				if (wl->cfg.w[i].id == wid) {
+					wl->cfg.w[i].val = (info[4] |
+							    (info[5] << 8) |
+							    (info[6] << 16) |
+							    (info[7] << 24));
+					break;
+				}
+				i++;
+			} while (1);
+			len = 6;
+			break;
+
+		case WID_STR:
+			do {
+				if (wl->cfg.s[i].id == WID_NIL)
+					break;
+
+				if (wl->cfg.s[i].id == wid) {
+					memcpy(wl->cfg.s[i].str, &info[2],
+					       (info[2] + 2));
+					break;
+				}
+				i++;
+			} while (1);
+			len = 2 + info[2];
+			break;
+
+		default:
+			break;
+		}
+		size -= (2 + len);
+		info += (2 + len);
+	}
+}
+
+static void wilc_wlan_parse_info_frame(struct wilc *wl, u8 *info)
+{
+	u32 wid, len;
+
+	wid = info[0] | (info[1] << 8);
+
+	len = info[2];
+
+	if (len == 1 && wid == WID_STATUS) {
+		int i = 0;
+
+		do {
+			if (wl->cfg.b[i].id == WID_NIL)
+				break;
+
+			if (wl->cfg.b[i].id == wid) {
+				wl->cfg.b[i].val = info[3];
+				break;
+			}
+			i++;
+		} while (1);
+	}
+}
+
+/********************************************
+ *
+ *      Configuration Exported Functions
+ *
+ ********************************************/
+
+int wilc_wlan_cfg_set_wid(u8 *frame, u32 offset, u16 id, u8 *buf, int size)
+{
+	u8 type = (id >> 12) & 0xf;
+	int ret = 0;
+
+	switch (type) {
+	case CFG_BYTE_CMD:
+		if (size >= 1)
+			ret = wilc_wlan_cfg_set_byte(frame, offset, id, *buf);
+		break;
+
+	case CFG_HWORD_CMD:
+		if (size >= 2)
+			ret = wilc_wlan_cfg_set_hword(frame, offset, id,
+						      *((u16 *)buf));
+		break;
+
+	case CFG_WORD_CMD:
+		if (size >= 4)
+			ret = wilc_wlan_cfg_set_word(frame, offset, id,
+						     *((u32 *)buf));
+		break;
+
+	case CFG_STR_CMD:
+		ret = wilc_wlan_cfg_set_str(frame, offset, id, buf, size);
+		break;
+
+	case CFG_BIN_CMD:
+		ret = wilc_wlan_cfg_set_bin(frame, offset, id, buf, size);
+		break;
+	}
+
+	return ret;
+}
+
+int wilc_wlan_cfg_get_wid(u8 *frame, u32 offset, u16 id)
+{
+	u8 *buf;
+
+	if ((offset + 2) >= MAX_CFG_FRAME_SIZE)
+		return 0;
+
+	buf = &frame[offset];
+
+	buf[0] = (u8)id;
+	buf[1] = (u8)(id >> 8);
+
+	return 2;
+}
+
+int wilc_wlan_cfg_get_wid_value(struct wilc *wl, u16 wid, u8 *buffer,
+				u32 buffer_size)
+{
+	u32 type = (wid >> 12) & 0xf;
+	int i, ret = 0;
+
+	i = 0;
+	if (type == CFG_BYTE_CMD) {
+		do {
+			if (wl->cfg.b[i].id == WID_NIL)
+				break;
+
+			if (wl->cfg.b[i].id == wid) {
+				memcpy(buffer, &wl->cfg.b[i].val, 1);
+				ret = 1;
+				break;
+			}
+			i++;
+		} while (1);
+	} else if (type == CFG_HWORD_CMD) {
+		do {
+			if (wl->cfg.hw[i].id == WID_NIL)
+				break;
+
+			if (wl->cfg.hw[i].id == wid) {
+				memcpy(buffer, &wl->cfg.hw[i].val, 2);
+				ret = 2;
+				break;
+			}
+			i++;
+		} while (1);
+	} else if (type == CFG_WORD_CMD) {
+		do {
+			if (wl->cfg.w[i].id == WID_NIL)
+				break;
+
+			if (wl->cfg.w[i].id == wid) {
+				memcpy(buffer, &wl->cfg.w[i].val, 4);
+				ret = 4;
+				break;
+			}
+			i++;
+		} while (1);
+	} else if (type == CFG_STR_CMD) {
+		do {
+			u32 id = wl->cfg.s[i].id;
+
+			if (id == WID_NIL)
+				break;
+
+			if (id == wid) {
+				u32 size = (wl->cfg.s[i].str[0] |
+					    (wl->cfg.s[i].str[1] << 8));
+
+				if (buffer_size >= size) {
+					memcpy(buffer, &wl->cfg.s[i].str[2],
+					       size);
+					ret = size;
+				}
+				break;
+			}
+			i++;
+		} while (1);
+	}
+	return ret;
+}
+
+void wilc_wlan_cfg_indicate_rx(struct wilc *wilc, u8 *frame, int size,
+			       struct wilc_cfg_rsp *rsp)
+{
+	u8 msg_type;
+	u8 msg_id;
+
+	msg_type = frame[0];
+	msg_id = frame[1];      /* seq no */
+	frame += 4;
+	size -= 4;
+	rsp->type = 0;
+
+	/*
+	 * The valid types of response messages are
+	 * 'R' (Response),
+	 * 'I' (Information), and
+	 * 'N' (Network Information)
+	 */
+
+	switch (msg_type) {
+	case 'R':
+		wilc_wlan_parse_response_frame(wilc, frame, size);
+		rsp->type = WILC_CFG_RSP;
+		rsp->seq_no = msg_id;
+		break;
+
+	case 'I':
+		wilc_wlan_parse_info_frame(wilc, frame);
+		rsp->type = WILC_CFG_RSP_STATUS;
+		rsp->seq_no = msg_id;
+		/*call host interface info parse as well*/
+		wilc_gnrl_async_info_received(wilc, frame - 4, size + 4);
+		break;
+
+	case 'N':
+		wilc_network_info_received(wilc, frame - 4, size + 4);
+		break;
+
+	case 'S':
+		wilc_scan_complete_received(wilc, frame - 4, size + 4);
+		break;
+
+	default:
+		rsp->seq_no = msg_id;
+		break;
+	}
+}
+
+int wilc_wlan_cfg_init(struct wilc *wl)
+{
+	struct wilc_cfg_str_vals *str_vals;
+	int i = 0;
+
+	wl->cfg.b = kmemdup(g_cfg_byte, sizeof(g_cfg_byte), GFP_KERNEL);
+	if (!wl->cfg.b)
+		return -ENOMEM;
+
+	wl->cfg.hw = kmemdup(g_cfg_hword, sizeof(g_cfg_hword), GFP_KERNEL);
+	if (!wl->cfg.hw)
+		goto out_b;
+
+	wl->cfg.w = kmemdup(g_cfg_word, sizeof(g_cfg_word), GFP_KERNEL);
+	if (!wl->cfg.w)
+		goto out_hw;
+
+	wl->cfg.s = kmemdup(g_cfg_str, sizeof(g_cfg_str), GFP_KERNEL);
+	if (!wl->cfg.s)
+		goto out_w;
+
+	str_vals = kzalloc(sizeof(str_vals), GFP_KERNEL);
+	if (!str_vals)
+		goto out_s;
+
+	wl->cfg.str_vals = str_vals;
+	/* store the string cfg parameters */
+	wl->cfg.s[i].id = WID_FIRMWARE_VERSION;
+	wl->cfg.s[i].str = str_vals->firmware_version;
+	i++;
+	wl->cfg.s[i].id = WID_MAC_ADDR;
+	wl->cfg.s[i].str = str_vals->mac_address;
+	i++;
+	wl->cfg.s[i].id = WID_ASSOC_RES_INFO;
+	wl->cfg.s[i].str = str_vals->assoc_rsp;
+	i++;
+	wl->cfg.s[i].id = WID_NIL;
+	wl->cfg.s[i].str = NULL;
+	return 0;
+
+out_s:
+	kfree(wl->cfg.s);
+out_w:
+	kfree(wl->cfg.w);
+out_hw:
+	kfree(wl->cfg.hw);
+out_b:
+	kfree(wl->cfg.b);
+	return -ENOMEM;
+}
+
+void wilc_wlan_cfg_deinit(struct wilc *wl)
+{
+	kfree(wl->cfg.b);
+	kfree(wl->cfg.hw);
+	kfree(wl->cfg.w);
+	kfree(wl->cfg.s);
+	kfree(wl->cfg.str_vals);
+}
-- 
2.7.4

