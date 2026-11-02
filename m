Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793609773;
	b=QlEIeHFtSziN90NM2Z2J636sCckX77S8N873nVndwEbvDRAGlIPNBhc609CW16LZJeZg
	 uX1y7RML4xOr8BUpPHhSxvO+g6KENgiZX7TjJEIFGOHFCkxeA9Irf4qLOZJSGkGqJe8mD
	 NrOlr01blne8sa8jLq8X2z/QbXaGam5AiiI3HZImjlsPih/r73J4znLKoG17qsfQqCGqF
	 aiZxEUs8fIRTtHBlkzs9ho+P7m20bp/myisNPUvK2VCf8DjYLtyLxanKQwXaBeJVYgGHV
	 yRm7SYjWqle9oGCryu84mtojYX/Bfy6N653rHQ7WlNcCPhEPp7TtUefQ1B8Oga2ZVkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793609773;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:Content-Type;
	bh=UfeTB3FT5NuxPNAnXepF/nC8uXzDeAnjlxysyZo905I=;
	b=UG5cDKQScN30tZcrVYZMI0lyV7540CeesO+o7lTd8HozOZtvhL22XKtr2gLTC3HlatdZ
	 vFhQKUQfhonnDe9tpk2p5ke29mVibBZlj1DcdO4Uv1U25xoDntxduJZhVa+f+rtPuXI4g
	 uijf7KrxrAP4PDkWbMgFdHJtQXYaucpZdPH+IrZDvWyOQe/44PLOohiR/bZOBhw/oLbeT
	 18T0KKgfEUtxKCHeGvprntYW7vhAYaVu2ed11lyHB0DSPo9eR3+ck7YpKwmurFhEvEib9
	 d4v3R3KvhM/+d5CcorDsbholTa8DMfNK2NT5iOBQ0x42povEiCzMTcnzMRuPFjNrIMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=hheDlevI;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2966F606A324
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 08:56:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2966F606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=hheDlevI
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6A28u3OE11997650, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793609763; bh=UfeTB3FT5NuxPNAnXepF/nC8uXzDeAnjlxysyZo905I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=hheDlevId4tDaNlEl9xZopoHbQuOoR5/Jcy6eB9GoxfkbYvShl/hk5oNU5uldJRJj
	 pWKcyRIuNRQMEVurIwKsO4GvKsMHxzMV06nNK8/aPIH/vTiMjjnCKuj9HkQUL0XTNu
	 mCFnS8AD8SdNyRY956Tn4tRzdkHwytptyDzGTMy5qgcu4eeryty/Kd3GnSDsuavTR9
	 3uhVArh2dvClFlVY472xk9k0KwcKbQS+6lgszg6eSVLTUKd4Sux9jAX6GWRaFVy3HF
	 cnhGEc/HlAprmicWzw2Eshc1mOYiFGaGl3rgz9DpN2oXuIOFJLwTC/x54tcwQHPc4Z
	 t9+P+hK7KaI6Q==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6A28u3OE11997650
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 2 Nov 2026 16:56:03 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 2 Nov 2026 16:56:03 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56 via Frontend
 Transport; Mon, 2 Nov 2026 16:56:03 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <charlesl@valvesoftware.com>, <sabae@valvesoftware.com>,
	<kevin_yang@realtek.com>, <wenjie.tsai@realtek.com>
Subject: [PATCH rtw-next v2 1/2] wifi: rtw89: add firmware-assisted regulatory domain learning
Date: Mon, 2 Nov 2026 16:55:33 +0800
Message-ID: <20261102085534.15153-2-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261102085534.15153-1-pkshih@realtek.com>
References: <20261102085534.15153-1-pkshih@realtek.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Johnson Tsai <wenjie.tsai@realtek.com>

Introduce a FW feature for regulatory domain learning, and add flow to
maintain the lifecycle of the FW process. With the FW feature supported,
FW can attempt to detect the most likely regulatory domain according to
surrounding APs. This FW feature will only be activated when there is no
active chanctx, and its regdom result can be replaced by another request
with higher priority.

Now, the priority order of various regdom requests is as follows.
1. programmed in module
2. set by distro/user
3. set by country IE
4. FW regd learn

Besides, the FW process of this FW feature will be canceled immediately
once a distro/user regdom request or any non-WW regdom request arrives.
Then, this FW feature will no longer run until a WW regdom request comes
even if it's in the range where it can be activated.

One difference from before is that once a regdom result is obtained from
this FW feature, there will be a wiphy regd, e.g. `iw reg get` will show
regdom by phy instead of only global regdom. But, the wiphy regd will be
updated as appropriate as possible.

Cc: Elliot Saba <sabae@valvesoftware.com>
Cc: Charles Lohr <charlesl@valvesoftware.com>
Signed-off-by: Johnson Tsai <wenjie.tsai@realtek.com>
Co-developed-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
v2:
 - update backoff time to prevent busy retry for the environment
   where AP doesn't advertise country IE.
---
 drivers/net/wireless/realtek/rtw89/chan.h     |   1 +
 drivers/net/wireless/realtek/rtw89/core.c     |   4 +
 drivers/net/wireless/realtek/rtw89/core.h     |  21 ++
 drivers/net/wireless/realtek/rtw89/fw.c       |  43 +++
 drivers/net/wireless/realtek/rtw89/fw.h       |  29 ++
 drivers/net/wireless/realtek/rtw89/mac.c      |  69 +++++
 drivers/net/wireless/realtek/rtw89/mac.h      |   1 +
 drivers/net/wireless/realtek/rtw89/mac80211.c |  32 ++-
 drivers/net/wireless/realtek/rtw89/pci.c      |   1 +
 drivers/net/wireless/realtek/rtw89/ps.h       |   5 +-
 drivers/net/wireless/realtek/rtw89/regd.c     | 258 ++++++++++++++++++
 drivers/net/wireless/realtek/rtw89/ser.c      |   1 +
 12 files changed, 460 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/chan.h b/drivers/net/wireless/realtek/rtw89/chan.h
index f99aca9ef6a4..e9df90c4ce3c 100644
--- a/drivers/net/wireless/realtek/rtw89/chan.h
+++ b/drivers/net/wireless/realtek/rtw89/chan.h
@@ -97,6 +97,7 @@ enum rtw89_chanctx_pause_reasons {
 	RTW89_CHANCTX_PAUSE_REASON_HW_SCAN,
 	RTW89_CHANCTX_PAUSE_REASON_ROC,
 	RTW89_CHANCTX_PAUSE_REASON_GC_BCN_LOSS,
+	RTW89_CHANCTX_PAUSE_REASON_REGD_LEARN,
 };
 
 struct rtw89_chanctx_pause_parm {
diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index 58ee5efc3b5e..8c4dd6f4a797 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -5026,6 +5026,8 @@ void rtw89_roc_start(struct rtw89_dev *rtwdev, struct rtw89_vif *rtwvif)
 
 	lockdep_assert_wiphy(hw->wiphy);
 
+	rtw89_regd_learn_cancel(rtwdev);
+
 	rtw89_leave_ips_by_hwflags(rtwdev);
 	rtw89_leave_lps(rtwdev);
 
@@ -5115,6 +5117,8 @@ void rtw89_roc_end(struct rtw89_dev *rtwdev, struct rtw89_vif *rtwvif)
 	if (hw->conf.flags & IEEE80211_CONF_IDLE)
 		wiphy_delayed_work_queue(hw->wiphy, &roc->roc_work,
 					 msecs_to_jiffies(RTW89_ROC_IDLE_TIMEOUT));
+
+	rtw89_regd_learn_queue(rtwdev);
 }
 
 void rtw89_roc_work(struct wiphy *wiphy, struct wiphy_work *work)
diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index 0d893b992a4a..d0a42f09fa13 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -6126,6 +6126,7 @@ enum rtw89_fw_feature {
 	RTW89_FW_FEATURE_SER_POST_RECOVER_DMAC,
 	RTW89_FW_FEATURE_TX_HISTORY_V1,
 	RTW89_FW_FEATURE_NO_DRV_BT_TXRX_EN,
+	RTW89_FW_FEATURE_REGD_LEARN,
 
 	NUM_OF_RTW89_FW_FEATURES,
 };
@@ -6564,6 +6565,7 @@ enum rtw89_flags {
 	RTW89_FLAG_HW_RFKILL_STATE,
 	RTW89_FLAG_UNPLUGGED,
 	RTW89_FLAG_SHUTDOWN,
+	RTW89_FLAG_REGD_LEARNING,
 
 	NUM_OF_RTW89_FLAGS,
 };
@@ -7098,6 +7100,19 @@ struct rtw89_regd_ctrl {
 	const struct rtw89_regd *map;
 };
 
+#define RTW89_REGD_LEARN_TIMEOUT 8
+#define RTW89_REGD_LEARN_CACHE_TTL 3600
+
+struct rtw89_regd_learn {
+	char hinted_alpha2[2];
+	bool can_activate;
+	bool shall_run;
+	unsigned long last_hint;
+	unsigned int retry;
+	struct wiphy_delayed_work work;
+	struct wiphy_delayed_work timeout_work;
+};
+
 #define RTW89_REGD_MAX_COUNTRY_NUM U8_MAX
 #define RTW89_5GHZ_UNII4_CHANNEL_NUM 3
 #define RTW89_5GHZ_UNII4_START_INDEX 25
@@ -7796,6 +7811,7 @@ struct rtw89_dev {
 	bool scanning;
 
 	struct rtw89_regulatory_info regulatory;
+	struct rtw89_regd_learn regd_learn;
 	struct rtw89_sar_info sar;
 	struct rtw89_tas_info tas;
 	struct rtw89_ant_gain_info ant_gain;
@@ -9540,6 +9556,11 @@ bool rtw89_legacy_rate_to_bitrate(struct rtw89_dev *rtwdev, u8 legacy_rate, u16
 int rtw89_regd_setup(struct rtw89_dev *rtwdev);
 int rtw89_regd_init_hint(struct rtw89_dev *rtwdev);
 const char *rtw89_regd_get_string(enum rtw89_regulation_type regd);
+void rtw89_regd_learn_init(struct rtw89_dev *rtwdev);
+void rtw89_regd_learn_deinit(struct rtw89_dev *rtwdev, bool ser);
+void rtw89_regd_learn_queue(struct rtw89_dev *rtwdev);
+void rtw89_regd_learn_cancel(struct rtw89_dev *rtwdev);
+void rtw89_regd_learn_update(struct rtw89_dev *rtwdev, const char *alpha2, bool sync);
 void rtw89_traffic_stats_init(struct rtw89_dev *rtwdev,
 			      struct rtw89_traffic_stats *stats);
 struct rtw89_wait_response *
diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index ea7dba077f5d..07102c2c78ed 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -993,6 +993,7 @@ static const struct __fw_feat_cfg fw_feat_tbl[] = {
 	__CFG_FW_FEAT(RTL8852C, ge, 0, 27, 128, 0, LPS_DACK_BY_C2H_REG),
 	__CFG_FW_FEAT(RTL8852C, ge, 0, 27, 128, 0, CRASH_TRIGGER_TYPE_1),
 	__CFG_FW_FEAT(RTL8852C, ge, 0, 27, 129, 1, BEACON_TRACKING),
+	__CFG_FW_FEAT(RTL8852C, ge, 0, 27, 138, 1, REGD_LEARN),
 	__CFG_FW_FEAT(RTL8852C, ge, 0, 29, 94, 0, SER_L1_BY_EVENT),
 	__CFG_FW_FEAT(RTL8852C, ge, 0, 29, 130, 0, SIM_SER_L0L1_BY_HALT_H2C),
 	__CFG_FW_FEAT(RTL8922A, ge, 0, 0, 0, 0, RFK_PRE_NOTIFY_V0),
@@ -1045,6 +1046,7 @@ static const struct __fw_feat_cfg fw_feat_tbl[] = {
 	__CFG_FW_FEAT(RTL8922D, lt, 0, 35, 113, 2, SCAN_OFFLOAD_BE_V2),
 	__CFG_FW_FEAT(RTL8922D, ge, 0, 35, 119, 0, LPS_ML_INFO_V1_EXTRA),
 	__CFG_FW_FEAT(RTL8922D, lt, 0, 35, 119, 0, CH_INFO_BE_V1),
+	__CFG_FW_FEAT(RTL8922D, ge, 0, 35, 119, 2, REGD_LEARN),
 	__CFG_FW_FEAT(RTL8922D, lt, 0, 35, 119, 3, NO_DRV_BT_TXRX_EN),
 };
 
@@ -11129,6 +11131,47 @@ int rtw89_hw_scan_offload(struct rtw89_dev *rtwdev,
 	return ret;
 }
 
+int rtw89_fw_h2c_regd_learn(struct rtw89_dev *rtwdev, const char *dflt)
+{
+	struct rtw89_wait_info *wait = &rtwdev->mac.fw_ofld_wait;
+	struct rtw89_h2c_regd_learn *h2c;
+	u32 len = sizeof(*h2c);
+	struct sk_buff *skb;
+	bool abort = !dflt;
+	int ret;
+
+	skb = rtw89_fw_h2c_alloc_skb_with_hdr(rtwdev, len);
+	if (!skb) {
+		rtw89_err(rtwdev, "failed to alloc skb for regd_learn\n");
+		return -ENOMEM;
+	}
+
+	skb_put(skb, len);
+	h2c = (struct rtw89_h2c_regd_learn *)skb->data;
+	h2c->w0 = le32_encode_bits(abort ? 0 : dflt[0],
+				   RTW89_H2C_REGD_LEARN_W0_COUNTRY_0) |
+		  le32_encode_bits(abort ? 0 : dflt[1],
+				   RTW89_H2C_REGD_LEARN_W0_COUNTRY_1) |
+		  le32_encode_bits(abort, RTW89_H2C_REGD_LEARN_W0_ABORT);
+
+	rtw89_h2c_pkt_set_hdr(rtwdev, skb, FWCMD_TYPE_H2C,
+			      H2C_CAT_MAC, H2C_CL_MAC_FW_OFLD,
+			      H2C_FUNC_REGD_LEARN, 0, 0, len);
+
+	if (abort)
+		return rtw89_h2c_tx_and_wait(rtwdev, skb, wait,
+					     RTW89_FW_OFLD_WAIT_COND_REGD_LEARN_ABORT);
+
+	ret = rtw89_h2c_tx(rtwdev, skb, false);
+	if (ret) {
+		rtw89_err(rtwdev, "failed to send regd_learn h2c\n");
+		dev_kfree_skb_any(skb);
+		return ret;
+	}
+
+	return 0;
+}
+
 #define H2C_FW_CPU_EXCEPTION_TYPE_0 0x5566
 #define H2C_FW_CPU_EXCEPTION_TYPE_1 0x0
 int rtw89_fw_h2c_trigger_cpu_exception(struct rtw89_dev *rtwdev)
diff --git a/drivers/net/wireless/realtek/rtw89/fw.h b/drivers/net/wireless/realtek/rtw89/fw.h
index e4d3331fc18f..50b813a3eed4 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.h
+++ b/drivers/net/wireless/realtek/rtw89/fw.h
@@ -4000,6 +4000,7 @@ struct rtw89_fw_c2h_attr {
 	u8 class;
 	u8 func;
 	u16 len;
+	u8 ignore: 1;
 	u8 is_scan_event: 1;
 	u8 scan_seq: 2;
 };
@@ -4179,6 +4180,22 @@ struct rtw89_c2h_scanofld {
 #define RTW89_C2H_SCANOFLD_W8_PERIOD_V1 GENMASK(15, 0)
 #define RTW89_C2H_SCANOFLD_W8_EXPECT_PERIOD_V1 GENMASK(31, 16)
 
+struct rtw89_c2h_regd_learn {
+	struct rtw89_c2h_hdr hdr;
+	__le32 w2;
+} __packed;
+
+#define RTW89_C2H_REGD_LEARN_W2_STATUS GENMASK(7, 0)
+#define RTW89_C2H_REGD_LEARN_W2_COUNTRY_0 GENMASK(15, 8)
+#define RTW89_C2H_REGD_LEARN_W2_COUNTRY_1 GENMASK(23, 16)
+
+enum rtw89_c2h_regd_learn_status {
+	RTW89_C2H_REGD_LEARN_NONE = 0,
+	RTW89_C2H_REGD_LEARN_LEARNED = 1,
+	RTW89_C2H_REGD_LEARN_VERIFIED = 2,
+	RTW89_C2H_REGD_LEARN_ABORT = 3,
+};
+
 #define RTW89_GET_MAC_C2H_MCC_RCV_ACK_GROUP(c2h) \
 	le32_get_bits(*((const __le32 *)(c2h) + 2), GENMASK(1, 0))
 #define RTW89_GET_MAC_C2H_MCC_RCV_ACK_H2C_FUNC(c2h) \
@@ -4856,10 +4873,19 @@ enum rtw89_fw_ofld_h2c_func {
 	H2C_FUNC_MAC_MACID_PAUSE_SLEEP	= 0x28,
 	H2C_FUNC_SCANOFLD_BE		= 0x2c,
 	H2C_FUNC_TRX_PROTECT		= 0x34,
+	H2C_FUNC_REGD_LEARN		= 0x53,
 
 	NUM_OF_RTW89_FW_OFLD_H2C_FUNC,
 };
 
+struct rtw89_h2c_regd_learn {
+	__le32 w0;
+} __packed;
+
+#define RTW89_H2C_REGD_LEARN_W0_COUNTRY_0	GENMASK(7, 0)
+#define RTW89_H2C_REGD_LEARN_W0_COUNTRY_1	GENMASK(15, 8)
+#define RTW89_H2C_REGD_LEARN_W0_ABORT		BIT(16)
+
 #define RTW89_FW_OFLD_WAIT_COND(tag, func) \
 	((tag) * NUM_OF_RTW89_FW_OFLD_H2C_FUNC + (func))
 
@@ -4867,6 +4893,8 @@ enum rtw89_fw_ofld_h2c_func {
 	RTW89_FW_OFLD_WAIT_COND(RTW89_PKT_OFLD_WAIT_TAG(pkt_id, pkt_op), \
 				H2C_FUNC_PACKET_OFLD)
 #define RTW89_FW_OFLD_WAIT_COND_TRX_PROTECT RTW89_FW_OFLD_WAIT_COND(0, H2C_FUNC_TRX_PROTECT)
+#define RTW89_FW_OFLD_WAIT_COND_REGD_LEARN_ABORT \
+	RTW89_FW_OFLD_WAIT_COND(1, H2C_FUNC_REGD_LEARN)
 
 #define RTW89_SCANOFLD_WAIT_COND_ADD_CH RTW89_FW_OFLD_WAIT_COND(0, H2C_FUNC_ADD_SCANOFLD_CH)
 
@@ -5684,6 +5712,7 @@ int rtw89_hw_scan_append_wildcard_probe_req(struct rtw89_dev *rtwdev,
 					    const u8 *mac_addr, bool wowlan);
 void rtw89_hw_scan_calc_req_ssid(struct rtw89_dev *rtwdev,
 				 struct rtw89_vif_link *rtwvif_link, bool wowlan);
+int rtw89_fw_h2c_regd_learn(struct rtw89_dev *rtwdev, const char *dflt);
 int rtw89_fw_h2c_trigger_cpu_exception(struct rtw89_dev *rtwdev);
 int rtw89_fw_h2c_pkt_drop(struct rtw89_dev *rtwdev,
 			  const struct rtw89_pkt_drop_params *params);
diff --git a/drivers/net/wireless/realtek/rtw89/mac.c b/drivers/net/wireless/realtek/rtw89/mac.c
index de8598ba441f..41796bff08ed 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.c
+++ b/drivers/net/wireless/realtek/rtw89/mac.c
@@ -5420,6 +5420,7 @@ rtw89_mac_bcn_fltr_rpt(struct rtw89_dev *rtwdev, struct rtw89_vif_link *rtwvif_l
 	switch (type) {
 	case RTW89_BCN_FLTR_BEACON_LOSS:
 		if (!rtwdev->scanning && !rtwvif->offchan &&
+		    !test_bit(RTW89_FLAG_REGD_LEARNING, rtwdev->flags) &&
 		    !rtwvif_link->noa_once.in_duration) {
 			start_detect = rtw89_mcc_detect_go_bcn(rtwdev, rtwvif_link);
 			if (start_detect)
@@ -6069,6 +6070,47 @@ rtw89_mac_c2h_pwr_int_notify(struct rtw89_dev *rtwdev, struct sk_buff *skb, u32
 	rcu_read_unlock();
 }
 
+static void
+rtw89_mac_c2h_regd_learn(struct rtw89_dev *rtwdev, struct sk_buff *skb, u32 len)
+{
+	const struct rtw89_c2h_regd_learn *c2h =
+		(const struct rtw89_c2h_regd_learn *)skb->data;
+	const struct rtw89_fw_c2h_attr *attr = RTW89_SKB_C2H_CB(skb);
+	const char *res;
+	char alpha2[2];
+	u8 status;
+
+	if (len < sizeof(*c2h))
+		return;
+
+	if (attr->ignore)
+		return;
+
+	if (!test_bit(RTW89_FLAG_REGD_LEARNING, rtwdev->flags))
+		return;
+
+	status = le32_get_bits(c2h->w2, RTW89_C2H_REGD_LEARN_W2_STATUS);
+	alpha2[0] = le32_get_bits(c2h->w2, RTW89_C2H_REGD_LEARN_W2_COUNTRY_0);
+	alpha2[1] = le32_get_bits(c2h->w2, RTW89_C2H_REGD_LEARN_W2_COUNTRY_1);
+
+	switch (status) {
+	case RTW89_C2H_REGD_LEARN_NONE:
+		rtw89_debug(rtwdev, RTW89_DBG_REGD,
+			    "regd_learn: c2h none\n");
+		res = NULL;
+		break;
+	case RTW89_C2H_REGD_LEARN_LEARNED:
+	case RTW89_C2H_REGD_LEARN_VERIFIED:
+		res = alpha2;
+		break;
+	default:
+		rtw89_warn(rtwdev, "regd_learn: c2h unknown (status=%d)\n", status);
+		return;
+	}
+
+	rtw89_regd_learn_update(rtwdev, res, true);
+}
+
 static
 void (* const rtw89_mac_c2h_ofld_handler[])(struct rtw89_dev *rtwdev,
 					    struct sk_buff *c2h, u32 len) = {
@@ -6081,6 +6123,7 @@ void (* const rtw89_mac_c2h_ofld_handler[])(struct rtw89_dev *rtwdev,
 	[RTW89_MAC_C2H_FUNC_TX_DUTY_RPT] = rtw89_mac_c2h_tx_duty_rpt,
 	[RTW89_MAC_C2H_FUNC_TSF32_TOGL_RPT] = rtw89_mac_c2h_tsf32_toggle_rpt,
 	[RTW89_MAC_C2H_FUNC_BCNFLTR_RPT] = rtw89_mac_c2h_bcn_fltr_rpt,
+	[RTW89_MAC_C2H_FUNC_REGD_LEARN] = rtw89_mac_c2h_regd_learn,
 };
 
 static
@@ -6168,6 +6211,29 @@ static void rtw89_mac_c2h_scanofld_rsp_atomic(struct rtw89_dev *rtwdev,
 	}
 }
 
+static void rtw89_mac_c2h_regd_learn_atomic(struct rtw89_dev *rtwdev,
+					    struct sk_buff *skb)
+{
+	const struct rtw89_c2h_regd_learn *c2h =
+		(const struct rtw89_c2h_regd_learn *)skb->data;
+	struct rtw89_wait_info *fw_ofld_wait = &rtwdev->mac.fw_ofld_wait;
+	struct rtw89_fw_c2h_attr *attr = RTW89_SKB_C2H_CB(skb);
+	struct rtw89_completion_data data = {};
+	u8 status;
+
+	if (attr->len < sizeof(*c2h))
+		return;
+
+	status = le32_get_bits(c2h->w2, RTW89_C2H_REGD_LEARN_W2_STATUS);
+	if (status != RTW89_C2H_REGD_LEARN_ABORT)
+		return;
+
+	rtw89_complete_cond(fw_ofld_wait, RTW89_FW_OFLD_WAIT_COND_REGD_LEARN_ABORT,
+			    &data);
+
+	attr->ignore = true;
+}
+
 bool rtw89_mac_c2h_chk_atomic(struct rtw89_dev *rtwdev, struct sk_buff *c2h,
 			      u8 class, u8 func)
 {
@@ -6191,6 +6257,9 @@ bool rtw89_mac_c2h_chk_atomic(struct rtw89_dev *rtwdev, struct sk_buff *c2h,
 			return false;
 		case RTW89_MAC_C2H_FUNC_PKT_OFLD_RSP:
 			return true;
+		case RTW89_MAC_C2H_FUNC_REGD_LEARN:
+			rtw89_mac_c2h_regd_learn_atomic(rtwdev, c2h);
+			return false;
 		}
 	case RTW89_MAC_C2H_CLASS_MCC:
 		return true;
diff --git a/drivers/net/wireless/realtek/rtw89/mac.h b/drivers/net/wireless/realtek/rtw89/mac.h
index 8419bcd3956a..db42e33e694c 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.h
+++ b/drivers/net/wireless/realtek/rtw89/mac.h
@@ -413,6 +413,7 @@ enum rtw89_mac_c2h_ofld_func {
 	RTW89_MAC_C2H_FUNC_SCANOFLD_RSP = 0x9,
 	RTW89_MAC_C2H_FUNC_TX_DUTY_RPT = 0xa,
 	RTW89_MAC_C2H_FUNC_BCNFLTR_RPT = 0xd,
+	RTW89_MAC_C2H_FUNC_REGD_LEARN = 0x24,
 	RTW89_MAC_C2H_FUNC_OFLD_MAX,
 };
 
diff --git a/drivers/net/wireless/realtek/rtw89/mac80211.c b/drivers/net/wireless/realtek/rtw89/mac80211.c
index 9e6cafc492c4..5abf71a6ed1f 100644
--- a/drivers/net/wireless/realtek/rtw89/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw89/mac80211.c
@@ -57,10 +57,17 @@ static void rtw89_ops_wake_tx_queue(struct ieee80211_hw *hw,
 static int rtw89_ops_start(struct ieee80211_hw *hw)
 {
 	struct rtw89_dev *rtwdev = hw->priv;
+	int ret;
 
 	lockdep_assert_wiphy(hw->wiphy);
 
-	return rtw89_core_start(rtwdev);
+	ret = rtw89_core_start(rtwdev);
+	if (ret)
+		return ret;
+
+	rtw89_regd_learn_init(rtwdev);
+
+	return 0;
 }
 
 static void rtw89_ops_stop(struct ieee80211_hw *hw, bool suspend)
@@ -69,6 +76,8 @@ static void rtw89_ops_stop(struct ieee80211_hw *hw, bool suspend)
 
 	lockdep_assert_wiphy(hw->wiphy);
 
+	rtw89_regd_learn_deinit(rtwdev, false);
+
 	rtw89_core_stop(rtwdev);
 }
 
@@ -95,7 +104,8 @@ static int rtw89_ops_config(struct ieee80211_hw *hw, int radio_idx, u32 changed)
 
 	if ((changed & IEEE80211_CONF_CHANGE_IDLE) &&
 	    (hw->conf.flags & IEEE80211_CONF_IDLE) &&
-	    !rtwdev->scanning)
+	    !rtwdev->scanning &&
+	    !test_bit(RTW89_FLAG_REGD_LEARNING, rtwdev->flags))
 		rtw89_enter_ips(rtwdev);
 
 	if (changed & IEEE80211_CONF_CHANGE_MONITOR)
@@ -1298,7 +1308,8 @@ static int rtw89_ops_hw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		return -EBUSY;
 	}
 
-	if (rtwdev->scanning || rtwvif->offchan)
+	if (rtwdev->scanning || rtwvif->offchan ||
+	    test_bit(RTW89_FLAG_REGD_LEARNING, rtwdev->flags))
 		return -EBUSY;
 
 	rtwvif_link = rtw89_get_designated_link(rtwvif);
@@ -1413,6 +1424,8 @@ static int rtw89_ops_assign_vif_chanctx(struct ieee80211_hw *hw,
 		return -ENOLINK;
 	}
 
+	rtw89_regd_learn_deinit(rtwdev, false);
+
 	return rtw89_chanctx_ops_assign_vif(rtwdev, rtwvif_link, ctx);
 }
 
@@ -1424,6 +1437,7 @@ static void rtw89_ops_unassign_vif_chanctx(struct ieee80211_hw *hw,
 	struct rtw89_dev *rtwdev = hw->priv;
 	struct rtw89_vif *rtwvif = vif_to_rtwvif(vif);
 	struct rtw89_vif_link *rtwvif_link;
+	unsigned int count = 0;
 
 	lockdep_assert_wiphy(hw->wiphy);
 
@@ -1436,6 +1450,12 @@ static void rtw89_ops_unassign_vif_chanctx(struct ieee80211_hw *hw,
 	}
 
 	rtw89_chanctx_ops_unassign_vif(rtwdev, rtwvif_link, ctx);
+
+	rtw89_for_each_active_rtwvif(rtwdev, rtwvif)
+		count++;
+
+	if (count == 0)
+		rtw89_regd_learn_init(rtwdev);
 }
 
 static
@@ -1737,6 +1757,9 @@ int rtw89_ops_change_vif_links(struct ieee80211_hw *hw,
 		rcu_assign_pointer(rtwvif->snap_link_confs, snap);
 	}
 
+	/* might enter ips without defer work */
+	rtw89_regd_learn_cancel(rtwdev);
+
 	/* might depend on @snap; don't change order */
 	rtw89_leave_ips_by_hwflags(rtwdev);
 
@@ -1780,6 +1803,9 @@ int rtw89_ops_change_vif_links(struct ieee80211_hw *hw,
 		rtw89_vif_update_fw_links(rtwdev, rtwvif, new_links, false);
 
 	rtw89_enter_ips_by_hwflags(rtwdev);
+
+	rtw89_regd_learn_queue(rtwdev);
+
 	return ret;
 }
 
diff --git a/drivers/net/wireless/realtek/rtw89/pci.c b/drivers/net/wireless/realtek/rtw89/pci.c
index ddb27c7782a9..6d19e759fc0d 100644
--- a/drivers/net/wireless/realtek/rtw89/pci.c
+++ b/drivers/net/wireless/realtek/rtw89/pci.c
@@ -4268,6 +4268,7 @@ static void rtw89_pci_recalc_int_mit(struct rtw89_dev *rtwdev)
 	u32 val = 0;
 
 	if (rtwdev->scanning ||
+	    test_bit(RTW89_FLAG_REGD_LEARNING, rtwdev->flags) ||
 	    (tx_tfc_lv < RTW89_TFC_HIGH && rx_tfc_lv < RTW89_TFC_HIGH))
 		goto out;
 
diff --git a/drivers/net/wireless/realtek/rtw89/ps.h b/drivers/net/wireless/realtek/rtw89/ps.h
index 729477153de6..dee4d25da8cd 100644
--- a/drivers/net/wireless/realtek/rtw89/ps.h
+++ b/drivers/net/wireless/realtek/rtw89/ps.h
@@ -41,8 +41,9 @@ static inline void rtw89_enter_ips_by_hwflags(struct rtw89_dev *rtwdev)
 {
 	struct ieee80211_hw *hw = rtwdev->hw;
 
-	/* prevent entering IPS after ROC, but it is scanning */
-	if (rtwdev->scanning)
+	/* prevent entering IPS after ROC, but it is scanning or regd learning */
+	if (rtwdev->scanning ||
+	    test_bit(RTW89_FLAG_REGD_LEARNING, rtwdev->flags))
 		return;
 
 	if (hw->conf.flags & IEEE80211_CONF_IDLE)
diff --git a/drivers/net/wireless/realtek/rtw89/regd.c b/drivers/net/wireless/realtek/rtw89/regd.c
index ec345feed184..89be36ccd84b 100644
--- a/drivers/net/wireless/realtek/rtw89/regd.c
+++ b/drivers/net/wireless/realtek/rtw89/regd.c
@@ -3,7 +3,9 @@
  */
 
 #include "acpi.h"
+#include "chan.h"
 #include "debug.h"
+#include "fw.h"
 #include "ps.h"
 #include "util.h"
 
@@ -706,6 +708,248 @@ static void rtw89_regd_setup_reg_rules(struct rtw89_dev *rtwdev)
 	kfree(ptr);
 }
 
+void rtw89_regd_learn_queue(struct rtw89_dev *rtwdev)
+{
+	struct rtw89_regd_learn *regd_learn = &rtwdev->regd_learn;
+	static const unsigned int backoff_list[] = {
+		4, 16, 64, 256, 1024, 4096,
+	};
+	struct wiphy *wiphy = rtwdev->hw->wiphy;
+	unsigned int delay;
+	unsigned int index;
+
+	lockdep_assert_wiphy(wiphy);
+
+	if (!regd_learn->can_activate)
+		return;
+
+	if (!regd_learn->shall_run)
+		return;
+
+	rtw89_debug(rtwdev, RTW89_DBG_REGD, "regd_learn: queue (retry=%u)\n",
+		    regd_learn->retry);
+
+	index = min_t(unsigned int, regd_learn->retry,
+		      ARRAY_SIZE(backoff_list) - 1);
+	delay = backoff_list[index] * HZ;
+
+	wiphy_delayed_work_queue(wiphy, &regd_learn->work, delay);
+}
+
+static int __rtw89_regd_learn_retry(struct rtw89_dev *rtwdev, void *data)
+{
+	struct rtw89_regd_learn *regd_learn = &rtwdev->regd_learn;
+
+	regd_learn->retry++;
+	rtw89_regd_learn_queue(rtwdev);
+
+	return 0;
+}
+
+static void __rtw89_regd_learn_start_setup(struct rtw89_dev *rtwdev)
+{
+	struct rtw89_chanctx_pause_parm pause_parm = {
+		.rsn = RTW89_CHANCTX_PAUSE_REASON_REGD_LEARN,
+	};
+
+	rtw89_leave_ips_by_hwflags(rtwdev);
+	rtw89_leave_lps(rtwdev);
+	rtw89_chanctx_pause(rtwdev, &pause_parm);
+
+	set_bit(RTW89_FLAG_REGD_LEARNING, rtwdev->flags);
+}
+
+static void __rtw89_regd_learn_stop_cleanup(struct rtw89_dev *rtwdev, bool retry)
+{
+	static const struct rtw89_chanctx_cb_parm cb_retry = {
+		.cb = __rtw89_regd_learn_retry,
+		.data = NULL,
+		.caller = __func__,
+	};
+
+	clear_bit(RTW89_FLAG_REGD_LEARNING, rtwdev->flags);
+
+	rtw89_chanctx_proceed(rtwdev, retry ? &cb_retry : NULL);
+	rtw89_enter_ips_by_hwflags(rtwdev);
+}
+
+static void __rtw89_regd_learn_finish(struct rtw89_dev *rtwdev, bool retry)
+{
+	struct rtw89_regd_learn *regd_learn = &rtwdev->regd_learn;
+	struct wiphy *wiphy = rtwdev->hw->wiphy;
+
+	wiphy_delayed_work_cancel(wiphy, &regd_learn->work);
+	wiphy_delayed_work_cancel(wiphy, &regd_learn->timeout_work);
+
+	if (test_bit(RTW89_FLAG_REGD_LEARNING, rtwdev->flags))
+		__rtw89_regd_learn_stop_cleanup(rtwdev, retry);
+}
+
+void rtw89_regd_learn_cancel(struct rtw89_dev *rtwdev)
+{
+	struct rtw89_regd_learn *regd_learn = &rtwdev->regd_learn;
+	struct wiphy *wiphy = rtwdev->hw->wiphy;
+	int ret;
+
+	lockdep_assert_wiphy(wiphy);
+
+	if (!regd_learn->can_activate)
+		return;
+
+	rtw89_debug(rtwdev, RTW89_DBG_REGD, "regd_learn: cancel\n");
+
+	if (test_bit(RTW89_FLAG_REGD_LEARNING, rtwdev->flags)) {
+		ret = rtw89_fw_h2c_regd_learn(rtwdev, NULL);
+		if (ret)
+			rtw89_warn(rtwdev, "regd_learn: abort failed (ret=%d)\n", ret);
+	}
+
+	__rtw89_regd_learn_finish(rtwdev, false);
+}
+
+void rtw89_regd_learn_update(struct rtw89_dev *rtwdev, const char *alpha2, bool sync)
+{
+	struct rtw89_regd_learn *regd_learn = &rtwdev->regd_learn;
+	struct wiphy *wiphy = rtwdev->hw->wiphy;
+	const struct ieee80211_regdomain *wiphy_regd = get_wiphy_regdom(wiphy);
+	int ret;
+
+	lockdep_assert_wiphy(wiphy);
+
+	/*
+	 * Calls with REGD_LEARNING are only allowed in c2h context,
+	 * i.e. other callers should rtw89_regd_learn_cancel() first.
+	 */
+	if (test_bit(RTW89_FLAG_REGD_LEARNING, rtwdev->flags)) {
+		__rtw89_regd_learn_finish(rtwdev, !alpha2);
+
+		if (!alpha2)
+			return;
+
+		regd_learn->shall_run = false;
+		regd_learn->retry = 0;
+	} else {
+		regd_learn->retry = 0;
+
+		if (!wiphy_regd || memcmp(alpha2, wiphy_regd->alpha2, 2) == 0)
+			return;
+	}
+
+	rtw89_debug(rtwdev, RTW89_DBG_REGD,
+		    "regd_learn: reg_hint %.2s (sync=%d)\n", alpha2, sync);
+
+	ret = regulatory_hint(wiphy, alpha2);
+	if (ret) {
+		rtw89_warn(rtwdev, "regd_learn: reg_hint failed (ret=%d)\n", ret);
+		return;
+	}
+
+	if (!sync)
+		return;
+
+	memcpy(regd_learn->hinted_alpha2, alpha2, 2);
+	regd_learn->last_hint = jiffies;
+}
+
+static void rtw89_regd_learn_work(struct wiphy *wiphy, struct wiphy_work *work)
+{
+	struct rtw89_dev *rtwdev = container_of(work, struct rtw89_dev,
+						regd_learn.work.work);
+	struct rtw89_regd_learn *regd_learn = &rtwdev->regd_learn;
+	char *alpha2 = regd_learn->hinted_alpha2;
+	int ret;
+
+	lockdep_assert_wiphy(wiphy);
+
+	wiphy_delayed_work_cancel(wiphy, &regd_learn->timeout_work);
+
+	if (rtwdev->scanning || rtw89_chanctx_paused(rtwdev)) {
+		rtw89_regd_learn_queue(rtwdev);
+		return;
+	}
+
+	if (regd_learn->last_hint &&
+	    time_is_before_jiffies(regd_learn->last_hint +
+				   RTW89_REGD_LEARN_CACHE_TTL * HZ)) {
+		rtw89_debug(rtwdev, RTW89_DBG_REGD,
+			    "regd_learn: %.2s is outdated\n", alpha2);
+		memset(alpha2, 0, 2);
+	}
+
+	rtw89_debug(rtwdev, RTW89_DBG_REGD, "regd_learn: start\n");
+
+	__rtw89_regd_learn_start_setup(rtwdev);
+
+	ret = rtw89_fw_h2c_regd_learn(rtwdev, alpha2);
+	if (ret) {
+		rtw89_warn(rtwdev, "regd_learn: h2c failed (ret=%d)\n", ret);
+		__rtw89_regd_learn_stop_cleanup(rtwdev, true);
+		return;
+	}
+
+	wiphy_delayed_work_queue(wiphy, &regd_learn->timeout_work,
+				 RTW89_REGD_LEARN_TIMEOUT * HZ);
+}
+
+static void rtw89_regd_learn_timeout_work(struct wiphy *wiphy, struct wiphy_work *work)
+{
+	struct rtw89_dev *rtwdev = container_of(work, struct rtw89_dev,
+						regd_learn.timeout_work.work);
+
+	lockdep_assert_wiphy(wiphy);
+
+	rtw89_debug(rtwdev, RTW89_DBG_REGD, "regd_learn: timeout\n");
+
+	rtw89_regd_learn_cancel(rtwdev);
+	__rtw89_regd_learn_retry(rtwdev, NULL);
+}
+
+void rtw89_regd_learn_init(struct rtw89_dev *rtwdev)
+{
+	struct rtw89_regulatory_info *regulatory = &rtwdev->regulatory;
+	struct rtw89_regd_learn *regd_learn = &rtwdev->regd_learn;
+	struct wiphy *wiphy = rtwdev->hw->wiphy;
+
+	lockdep_assert_wiphy(wiphy);
+
+	if (regd_learn->can_activate)
+		return;
+
+	regd_learn->can_activate = !regulatory->programmed &&
+				   RTW89_CHK_FW_FEATURE(REGD_LEARN, &rtwdev->fw);
+	if (!regd_learn->can_activate)
+		return;
+
+	rtw89_debug(rtwdev, RTW89_DBG_REGD, "regd_learn: init\n");
+
+	wiphy_delayed_work_init(&regd_learn->work, rtw89_regd_learn_work);
+	wiphy_delayed_work_init(&regd_learn->timeout_work, rtw89_regd_learn_timeout_work);
+
+	regd_learn->retry = 0;
+
+	rtw89_regd_learn_queue(rtwdev);
+}
+
+void rtw89_regd_learn_deinit(struct rtw89_dev *rtwdev, bool ser)
+{
+	struct rtw89_regd_learn *regd_learn = &rtwdev->regd_learn;
+	struct wiphy *wiphy = rtwdev->hw->wiphy;
+
+	lockdep_assert_wiphy(wiphy);
+
+	if (!regd_learn->can_activate)
+		return;
+
+	if (ser)
+		__rtw89_regd_learn_finish(rtwdev, false);
+	else
+		rtw89_regd_learn_cancel(rtwdev);
+
+	rtw89_debug(rtwdev, RTW89_DBG_REGD, "regd_learn: deinit\n");
+
+	regd_learn->can_activate = false;
+}
+
 int rtw89_regd_setup(struct rtw89_dev *rtwdev)
 {
 	struct rtw89_regulatory_info *regulatory = &rtwdev->regulatory;
@@ -883,6 +1127,8 @@ static void rtw89_regd_notifier_apply(struct rtw89_dev *rtwdev,
 				      struct wiphy *wiphy,
 				      struct regulatory_request *request)
 {
+	struct rtw89_regd_learn *regd_learn = &rtwdev->regd_learn;
+
 	rtwdev->regulatory.regd = rtw89_regd_find_reg_by_name(rtwdev, request->alpha2);
 	/* This notification might be set from the system of distros,
 	 * and it does not expect the regulatory will be modified by
@@ -893,6 +1139,18 @@ static void rtw89_regd_notifier_apply(struct rtw89_dev *rtwdev,
 		wiphy->regulatory_flags |= REGULATORY_COUNTRY_IE_IGNORE;
 	else
 		wiphy->regulatory_flags &= ~REGULATORY_COUNTRY_IE_IGNORE;
+
+	rtw89_regd_learn_cancel(rtwdev);
+
+	regd_learn->shall_run = request->initiator != NL80211_REGDOM_SET_BY_USER &&
+				memcmp(request->alpha2, "00", 2) == 0;
+	if (!regd_learn->shall_run) {
+		rtw89_regd_learn_update(rtwdev, request->alpha2,
+					request->initiator != NL80211_REGDOM_SET_BY_USER);
+		return;
+	}
+
+	rtw89_regd_learn_queue(rtwdev);
 }
 
 static
diff --git a/drivers/net/wireless/realtek/rtw89/ser.c b/drivers/net/wireless/realtek/rtw89/ser.c
index 045dac0bd1db..3dc1b8a8dc2b 100644
--- a/drivers/net/wireless/realtek/rtw89/ser.c
+++ b/drivers/net/wireless/realtek/rtw89/ser.c
@@ -726,6 +726,7 @@ static void ser_l2_reset_st_pre_hdl(struct rtw89_ser *ser)
 bottom:
 	rtw89_ser_cd_free(rtwdev, buf, !!ret);
 
+	rtw89_regd_learn_deinit(rtwdev, true);
 	ser_reset_mac_binding(rtwdev);
 	rtw89_core_stop(rtwdev);
 	rtw89_entity_init(rtwdev);
-- 
2.25.1

