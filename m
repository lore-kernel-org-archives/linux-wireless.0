Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2534 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab1K3FMJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Nov 2011 00:12:09 -0500
Cc: Jouni Malinen <jouni@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Vivek Natarajan <nataraja@qualcomm.com>,
	Russell Hu <rhu@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Wilson Tsao <wtsao@qca.qualcomm.com>
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH v2 03/17] ath9k_hw: Add MCI h/w specific structure
Date: Wed, 30 Nov 2011 10:41:15 +0530
Message-ID: <1322629889-19961-4-git-send-email-mohammed@qca.qualcomm.com> (sfid-20111130_061214_269874_581965A5)
In-Reply-To: <1322629889-19961-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1322629889-19961-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Cc: Wilson Tsao <wtsao@qca.qualcomm.com>
Cc: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/btcoex.h |   31 +++++++++++++++++++++++++++++++
 1 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/btcoex.h b/drivers/net/wireless/ath/ath9k/btcoex.h
index d5e5db1..278361c 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.h
+++ b/drivers/net/wireless/ath/ath9k/btcoex.h
@@ -54,8 +54,39 @@ enum ath_btcoex_scheme {
 	ATH_BTCOEX_CFG_MCI,
 };
 
+struct ath9k_hw_mci {
+	u32 raw_intr;
+	u32 rx_msg_intr;
+	u32 cont_status;
+	u32 gpm_addr;
+	u32 gpm_len;
+	u32 gpm_idx;
+	u32 sched_addr;
+	u32 wlan_channels[4];
+	u32 wlan_cal_seq;
+	u32 wlan_cal_done;
+	u32 config;
+	u8 *gpm_buf;
+	u8 *sched_buf;
+	bool ready;
+	bool update_2g5g;
+	bool is_2g;
+	bool query_bt;
+	bool unhalt_bt_gpm; /* need send UNHALT */
+	bool halted_bt_gpm; /* HALT sent */
+	bool need_flush_btinfo;
+	bool bt_version_known;
+	bool wlan_channels_update;
+	u8 wlan_ver_major;
+	u8 wlan_ver_minor;
+	u8 bt_ver_major;
+	u8 bt_ver_minor;
+	u8 bt_state;
+};
+
 struct ath_btcoex_hw {
 	enum ath_btcoex_scheme scheme;
+	struct ath9k_hw_mci mci;
 	bool enabled;
 	u8 wlanactive_gpio;
 	u8 btactive_gpio;
-- 
1.7.0.4

