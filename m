Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14234C4360F
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 08:59:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D63A3222A4
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 08:59:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391181AbfBNI7w (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 03:59:52 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:39621 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732622AbfBNI7o (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 03:59:44 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x1E8xNKR005889, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x1E8xNKR005889
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=NOT);
        Thu, 14 Feb 2019 16:59:23 +0800
Received: from localhost.localdomain (172.21.68.126) by
 RTITCASV01.realtek.com.tw (172.21.6.18) with Microsoft SMTP Server id
 14.3.408.0; Thu, 14 Feb 2019 16:59:22 +0800
From:   <yhchuang@realtek.com>
To:     <kvalo@codeaurora.org>, <johannes@sipsolutions.net>
CC:     <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>,
        <pkshih@realtek.com>, <tehuang@realtek.com>,
        <briannorris@chromium.org>, <sgruszka@redhat.com>
Subject: [PATCH v2 15/24] rtw88: extract utility functions into util.c
Date:   Thu, 14 Feb 2019 16:58:54 +0800
Message-ID: <1550134743-17443-16-git-send-email-yhchuang@realtek.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1550134743-17443-1-git-send-email-yhchuang@realtek.com>
References: <1550134743-17443-1-git-send-email-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.68.126]
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

Move functions that might be used as utilities, such as
lte_coex_[read/write] and registers restore, into util.* files.

Besides, hardware polling and some vif/sta iteration wrappers are also
categorized into utilitiy functions as well.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
---
 drivers/net/wireless/realtek/rtw88/Makefile |  1 +
 drivers/net/wireless/realtek/rtw88/mac.c    | 53 +--------------------
 drivers/net/wireless/realtek/rtw88/main.h   | 46 +++---------------
 drivers/net/wireless/realtek/rtw88/util.c   | 72 +++++++++++++++++++++++++++++
 drivers/net/wireless/realtek/rtw88/util.h   | 34 ++++++++++++++
 5 files changed, 115 insertions(+), 91 deletions(-)
 create mode 100644 drivers/net/wireless/realtek/rtw88/util.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/util.h

diff --git a/drivers/net/wireless/realtek/rtw88/Makefile b/drivers/net/wireless/realtek/rtw88/Makefile
index d70782a..da5e36e 100644
--- a/drivers/net/wireless/realtek/rtw88/Makefile
+++ b/drivers/net/wireless/realtek/rtw88/Makefile
@@ -1,6 +1,7 @@
 obj-$(CONFIG_RTW88_CORE)	+= rtw88.o
 rtw88-y += main.o \
 	   mac80211.o \
+	   util.o \
 	   debug.o \
 	   tx.o \
 	   rx.o \
diff --git a/drivers/net/wireless/realtek/rtw88/mac.c b/drivers/net/wireless/realtek/rtw88/mac.c
index 3dd011d..5a60732 100644
--- a/drivers/net/wireless/realtek/rtw88/mac.c
+++ b/drivers/net/wireless/realtek/rtw88/mac.c
@@ -304,35 +304,6 @@ void rtw_mac_power_off(struct rtw_dev *rtwdev)
 	rtw_mac_power_switch(rtwdev, false);
 }
 
-static void
-restore_mac_reg(struct rtw_dev *rtwdev, struct rtw_backup_info *bckp, u32 num)
-{
-	u8 len;
-	u32 reg;
-	u32 val;
-	int i;
-
-	for (i = 0; i < num; i++, bckp++) {
-		len = bckp->len;
-		reg = bckp->reg;
-		val = bckp->val;
-
-		switch (len) {
-		case 1:
-			rtw_write8(rtwdev, reg, (u8)val);
-			break;
-		case 2:
-			rtw_write16(rtwdev, reg, (u16)val);
-			break;
-		case 4:
-			rtw_write32(rtwdev, reg, (u32)val);
-			break;
-		default:
-			break;
-		}
-	}
-}
-
 static bool check_firmware_size(const u8 *data, u32 size)
 {
 	u32 dmem_size;
@@ -355,28 +326,6 @@ static bool check_firmware_size(const u8 *data, u32 size)
 	return true;
 }
 
-static bool ltecoex_read_reg(struct rtw_dev *rtwdev, u16 offset, u32 *val)
-{
-	if (!check_hw_ready(rtwdev, LTECOEX_ACCESS_CTRL, LTECOEX_READY, 1))
-		return false;
-
-	rtw_write32(rtwdev, LTECOEX_ACCESS_CTRL, 0x800F0000 | offset);
-	*val = rtw_read32(rtwdev, LTECOEX_READ_DATA);
-
-	return true;
-}
-
-static bool ltecoex_reg_write(struct rtw_dev *rtwdev, u16 offset, u32 value)
-{
-	if (!check_hw_ready(rtwdev, LTECOEX_ACCESS_CTRL, LTECOEX_READY, 1))
-		return false;
-
-	rtw_write32(rtwdev, LTECOEX_WRITE_DATA, value);
-	rtw_write32(rtwdev, LTECOEX_ACCESS_CTRL, 0xC00F0000 | offset);
-
-	return true;
-}
-
 static void wlan_cpu_enable(struct rtw_dev *rtwdev, bool enable)
 {
 	if (enable) {
@@ -459,7 +408,7 @@ static void download_firmware_reg_restore(struct rtw_dev *rtwdev,
 					  struct rtw_backup_info *bckp,
 					  u8 bckp_num)
 {
-	restore_mac_reg(rtwdev, bckp, bckp_num);
+	rtw_restore_reg(rtwdev, bckp, bckp_num);
 }
 
 #define TX_DESC_SIZE 48
diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
index 1a98747..e091a87 100644
--- a/drivers/net/wireless/realtek/rtw88/main.h
+++ b/drivers/net/wireless/realtek/rtw88/main.h
@@ -12,6 +12,8 @@
 #include <linux/bitops.h>
 #include <linux/bitfield.h>
 
+#include "util.h"
+
 #define RTW_MAX_MAC_ID_NUM		32
 #define RTW_MAX_SEC_CAM_NUM		32
 
@@ -1079,47 +1081,13 @@ static inline void rtw_flag_set(struct rtw_dev *rtwdev, enum rtw_flags flag)
 	set_bit(flag, rtwdev->flags);
 }
 
-static inline u8 *get_hdr_bssid(struct ieee80211_hdr *hdr)
-{
-	__le16 fc = hdr->frame_control;
-	u8 *bssid;
-
-	if (ieee80211_has_tods(fc))
-		bssid = hdr->addr1;
-	else if (ieee80211_has_fromds(fc))
-		bssid = hdr->addr2;
-	else
-		bssid = hdr->addr3;
-
-	return bssid;
-}
-
-static inline bool check_hw_ready(struct rtw_dev *rtwdev,
-				  u32 addr, u32 mask, u32 target)
-{
-	u32 cnt;
-
-	for (cnt = 0; cnt < 1000; cnt++) {
-		if (rtw_read32_mask(rtwdev, addr, mask) == target)
-			return true;
-
-		udelay(10);
-	}
-
-	return false;
-}
-
-#define rtw_iterate_vifs(rtwdev, iterator, data)                               \
-	ieee80211_iterate_active_interfaces(rtwdev->hw,                        \
-			IEEE80211_IFACE_ITER_NORMAL, iterator, data)
-#define rtw_iterate_vifs_atomic(rtwdev, iterator, data)                        \
-	ieee80211_iterate_active_interfaces_atomic(rtwdev->hw,                 \
-			IEEE80211_IFACE_ITER_NORMAL, iterator, data)
-#define rtw_iterate_stas_atomic(rtwdev, iterator, data)                        \
-	ieee80211_iterate_stations_atomic(rtwdev->hw, iterator, data)
-
 void rtw_get_channel_params(struct cfg80211_chan_def *chandef,
 			    struct rtw_channel_params *ch_param);
+bool check_hw_ready(struct rtw_dev *rtwdev, u32 addr, u32 mask, u32 target);
+bool ltecoex_read_reg(struct rtw_dev *rtwdev, u16 offset, u32 *val);
+bool ltecoex_reg_write(struct rtw_dev *rtwdev, u16 offset, u32 value);
+void rtw_restore_reg(struct rtw_dev *rtwdev,
+		     struct rtw_backup_info *bckp, u32 num);
 void rtw_set_channel(struct rtw_dev *rtwdev);
 void rtw_vif_port_config(struct rtw_dev *rtwdev, struct rtw_vif *rtwvif,
 			 u32 config);
diff --git a/drivers/net/wireless/realtek/rtw88/util.c b/drivers/net/wireless/realtek/rtw88/util.c
new file mode 100644
index 0000000..9a03a40
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/util.c
@@ -0,0 +1,72 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2018  Realtek Corporation.
+ */
+
+#include "main.h"
+#include "util.h"
+#include "reg.h"
+
+bool check_hw_ready(struct rtw_dev *rtwdev, u32 addr, u32 mask, u32 target)
+{
+	u32 cnt;
+
+	for (cnt = 0; cnt < 1000; cnt++) {
+		if (rtw_read32_mask(rtwdev, addr, mask) == target)
+			return true;
+
+		udelay(10);
+	}
+
+	return false;
+}
+
+bool ltecoex_read_reg(struct rtw_dev *rtwdev, u16 offset, u32 *val)
+{
+	if (!check_hw_ready(rtwdev, LTECOEX_ACCESS_CTRL, LTECOEX_READY, 1))
+		return false;
+
+	rtw_write32(rtwdev, LTECOEX_ACCESS_CTRL, 0x800F0000 | offset);
+	*val = rtw_read32(rtwdev, LTECOEX_READ_DATA);
+
+	return true;
+}
+
+bool ltecoex_reg_write(struct rtw_dev *rtwdev, u16 offset, u32 value)
+{
+	if (!check_hw_ready(rtwdev, LTECOEX_ACCESS_CTRL, LTECOEX_READY, 1))
+		return false;
+
+	rtw_write32(rtwdev, LTECOEX_WRITE_DATA, value);
+	rtw_write32(rtwdev, LTECOEX_ACCESS_CTRL, 0xC00F0000 | offset);
+
+	return true;
+}
+
+void rtw_restore_reg(struct rtw_dev *rtwdev,
+		     struct rtw_backup_info *bckp, u32 num)
+{
+	u8 len;
+	u32 reg;
+	u32 val;
+	int i;
+
+	for (i = 0; i < num; i++, bckp++) {
+		len = bckp->len;
+		reg = bckp->reg;
+		val = bckp->val;
+
+		switch (len) {
+		case 1:
+			rtw_write8(rtwdev, reg, (u8)val);
+			break;
+		case 2:
+			rtw_write16(rtwdev, reg, (u16)val);
+			break;
+		case 4:
+			rtw_write32(rtwdev, reg, (u32)val);
+			break;
+		default:
+			break;
+		}
+	}
+}
diff --git a/drivers/net/wireless/realtek/rtw88/util.h b/drivers/net/wireless/realtek/rtw88/util.h
new file mode 100644
index 0000000..aa8f07b
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/util.h
@@ -0,0 +1,34 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2018  Realtek Corporation.
+ */
+
+#ifndef __RTW_UTIL_H__
+#define __RTW_UTIL_H__
+
+struct rtw_dev;
+
+#define rtw_iterate_vifs(rtwdev, iterator, data)                               \
+	ieee80211_iterate_active_interfaces(rtwdev->hw,                        \
+			IEEE80211_IFACE_ITER_NORMAL, iterator, data)
+#define rtw_iterate_vifs_atomic(rtwdev, iterator, data)                        \
+	ieee80211_iterate_active_interfaces_atomic(rtwdev->hw,                 \
+			IEEE80211_IFACE_ITER_NORMAL, iterator, data)
+#define rtw_iterate_stas_atomic(rtwdev, iterator, data)                        \
+	ieee80211_iterate_stations_atomic(rtwdev->hw, iterator, data)
+
+static inline u8 *get_hdr_bssid(struct ieee80211_hdr *hdr)
+{
+	__le16 fc = hdr->frame_control;
+	u8 *bssid;
+
+	if (ieee80211_has_tods(fc))
+		bssid = hdr->addr1;
+	else if (ieee80211_has_fromds(fc))
+		bssid = hdr->addr2;
+	else
+		bssid = hdr->addr3;
+
+	return bssid;
+}
+
+#endif
-- 
2.7.4

