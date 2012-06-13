Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:47304 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753320Ab2FMOOb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 10:14:31 -0400
Received: from dlelxv30.itg.ti.com ([172.17.2.17])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id q5DEEVRV004689
	for <linux-wireless@vger.kernel.org>; Wed, 13 Jun 2012 09:14:31 -0500
Received: from DLEE74.ent.ti.com (dlee74.ent.ti.com [157.170.170.8])
	by dlelxv30.itg.ti.com (8.13.8/8.13.8) with ESMTP id q5DEEVIR022589
	for <linux-wireless@vger.kernel.org>; Wed, 13 Jun 2012 09:14:31 -0500
From: Yair Shapira <yair.shapira@ti.com>
To: <linux-wireless@vger.kernel.org>, <coelho@ti.com>
CC: <yair.shapira@ti.com>
Subject: [PATCH 2/2] wlcore: add print logs of radio_status in case of BIP calibration
Date: Wed, 13 Jun 2012 17:14:22 +0300
Message-ID: <1339596862-2488-3-git-send-email-yair.shapira@ti.com> (sfid-20120613_161435_722492_D8DE8B70)
In-Reply-To: <1339596862-2488-1-git-send-email-yair.shapira@ti.com>
References: <1339596862-2488-1-git-send-email-yair.shapira@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

FEM BIP calibration may fail with fw/phy radio status. In order to
recognize these failures a log is added to the calibration answer
(TEST_CMD_P2G_CAL)

Signed-off-by: Yair Shapira <yair.shapira@ti.com>
---
 drivers/net/wireless/ti/wlcore/cmd.h      |   21 +++++++++++++++++++++
 drivers/net/wireless/ti/wlcore/testmode.c |   14 ++++++++++++++
 2 files changed, 35 insertions(+)
 mode change 100644 => 100755 drivers/net/wireless/ti/wlcore/cmd.h
 mode change 100644 => 100755 drivers/net/wireless/ti/wlcore/testmode.c

diff --git a/drivers/net/wireless/ti/wlcore/cmd.h b/drivers/net/wireless/ti/wlcore/cmd.h
old mode 100644
new mode 100755
index 85171f2..b94cc37
--- a/drivers/net/wireless/ti/wlcore/cmd.h
+++ b/drivers/net/wireless/ti/wlcore/cmd.h
@@ -652,4 +652,25 @@ struct wl12xx_cmd_stop_channel_switch {
 	struct wl1271_cmd_header header;
 } __packed;
 
+/* Used to check radio status after calibration */
+#define MAX_TLV_LENGTH  	500
+#define TEST_CMD_P2G_CAL	2	/* TX BiP */
+
+struct wl1271_cmd_cal_p2g {
+	struct wl1271_cmd_header header;
+
+	struct wl1271_cmd_test_header test;
+
+	__le32 ver;
+	__le16 len;
+	u8 buf[MAX_TLV_LENGTH];
+	u8 type;
+	u8 padding;
+
+	__le16 radio_status;
+
+	u8 sub_band_mask;
+	u8 padding2;
+} __packed;
+
 #endif /* __WL1271_CMD_H__ */
diff --git a/drivers/net/wireless/ti/wlcore/testmode.c b/drivers/net/wireless/ti/wlcore/testmode.c
old mode 100644
new mode 100755
index 0e59ea2..2a53284
--- a/drivers/net/wireless/ti/wlcore/testmode.c
+++ b/drivers/net/wireless/ti/wlcore/testmode.c
@@ -108,6 +108,20 @@ static int wl1271_tm_cmd_test(struct wl1271 *wl, struct nlattr *tb[])
 	}
 
 	if (answer) {
+		/* If we got bip calibration answer print radio status */
+		struct wl1271_cmd_cal_p2g* params =
+			(struct wl1271_cmd_cal_p2g*) buf;
+
+		s16 radio_status = (s16) le16_to_cpu(params->radio_status);
+
+		if (params->test.id == TEST_CMD_P2G_CAL &&
+		    radio_status < 0)
+			wl1271_warning("testmode cmd: radio status=%d",
+					radio_status);
+		else
+			wl1271_info("testmode cmd: radio status=%d",
+					radio_status);
+
 		len = nla_total_size(buf_len);
 		skb = cfg80211_testmode_alloc_reply_skb(wl->hw->wiphy, len);
 		if (!skb) {
-- 
1.7.9.5

