Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:40780 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388826AbeIULwK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Sep 2018 07:52:10 -0400
From: <yhchuang@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>,
        <pkshih@realtek.com>, <tehuang@realtek.com>
Subject: [PATCH 02/12] rtwlan: core files
Date: Fri, 21 Sep 2018 14:03:57 +0800
Message-ID: <1537509847-21087-3-git-send-email-yhchuang@realtek.com> (sfid-20180921_080501_193100_84C12547)
In-Reply-To: <1537509847-21087-1-git-send-email-yhchuang@realtek.com>
References: <1537509847-21087-1-git-send-email-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

core files for Realtek 802.11ac wireless network chips

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
---
 drivers/net/wireless/realtek/rtwlan/ps.c   | 193 ++++++++++++
 drivers/net/wireless/realtek/rtwlan/ps.h   |  21 ++
 drivers/net/wireless/realtek/rtwlan/regd.c | 462 +++++++++++++++++++++++++++++
 drivers/net/wireless/realtek/rtwlan/regd.h |  40 +++
 drivers/net/wireless/realtek/rtwlan/sec.c  | 135 +++++++++
 drivers/net/wireless/realtek/rtwlan/sec.h  |  40 +++
 6 files changed, 891 insertions(+)
 create mode 100644 drivers/net/wireless/realtek/rtwlan/ps.c
 create mode 100644 drivers/net/wireless/realtek/rtwlan/ps.h
 create mode 100644 drivers/net/wireless/realtek/rtwlan/regd.c
 create mode 100644 drivers/net/wireless/realtek/rtwlan/regd.h
 create mode 100644 drivers/net/wireless/realtek/rtwlan/sec.c
 create mode 100644 drivers/net/wireless/realtek/rtwlan/sec.h

diff --git a/drivers/net/wireless/realtek/rtwlan/ps.c b/drivers/net/wireless/realtek/rtwlan/ps.c
new file mode 100644
index 0000000..1ee27d1
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtwlan/ps.c
@@ -0,0 +1,193 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2018  Realtek Corporation.
+ */
+
+#include "main.h"
+#include "fw.h"
+#include "ps.h"
+#include "mac.h"
+#include "debug.h"
+
+static int rtw_ips_pwr_up(struct rtw_dev *rtwdev)
+{
+	int ret;
+
+	ret = rtw_core_start(rtwdev);
+	if (ret)
+		rtw_err(rtwdev, "leave idle state failed\n");
+
+	rtw_flag_clear(rtwdev, RTW_FLAG_INACTIVE_PS);
+
+	return ret;
+}
+
+int rtw_enter_ips(struct rtw_dev *rtwdev)
+{
+	rtw_flag_set(rtwdev, RTW_FLAG_INACTIVE_PS);
+
+	rtw_core_stop(rtwdev);
+
+	return 0;
+}
+
+static void rtw_restore_port_cfg(struct rtw_dev *rtwdev)
+{
+	struct rtw_vif *rtwvif;
+	u32 config = ~0;
+
+	list_for_each_entry(rtwvif, &rtwdev->vif_list, list)
+		rtw_vif_port_config(rtwdev, rtwvif, config);
+}
+
+int rtw_leave_ips(struct rtw_dev *rtwdev)
+{
+	int ret;
+
+	ret = rtw_ips_pwr_up(rtwdev);
+	if (ret) {
+		rtw_err(rtwdev, "fail to leave ips state");
+		return ret;
+	}
+
+	rtw_restore_port_cfg(rtwdev);
+
+	return 0;
+}
+
+void rtw_lps_enter_check(struct rtw_dev *rtwdev)
+{
+	struct rtw_vif *rtwvif, *lps_if;
+	u8 assoc_cnt = 0;
+
+	list_for_each_entry(rtwvif, &rtwdev->vif_list, list) {
+		/* only station mode supports lps */
+		if (rtwvif->vif->type != NL80211_IFTYPE_STATION)
+			return;
+		/* take the station associated into account */
+		if (rtwvif->vif->bss_conf.assoc) {
+			lps_if = rtwvif;
+			assoc_cnt++;
+		}
+	}
+
+	/* fw supports only one station associated to enter lps, if there are
+	 * more than two stations associated to the AP, then we can not enter
+	 * lps, because fw does not handle the overlapped beacon interval
+	 */
+	if (assoc_cnt != 1)
+		return;
+
+	/* the remained interface is the one we want to enter lps */
+	if (lps_if->stats.tx_cnt <= RTW_LPS_THRESHOLD &&
+	    lps_if->stats.rx_cnt <= RTW_LPS_THRESHOLD)
+		rtw_enter_lps(rtwdev, lps_if);
+}
+
+static void rtw_leave_lps_core(struct rtw_dev *rtwdev)
+{
+	struct rtw_lps_conf *conf = &rtwdev->lps_conf;
+
+	conf->state = RTW_ALL_ON;
+	conf->awake_interval = 1;
+	conf->rlbm = 0;
+	conf->smart_ps = 0;
+
+	rtw_fw_set_pwr_mode(rtwdev);
+	rtw_flag_clear(rtwdev, RTW_FLAG_LEISURE_PS);
+}
+
+static void rtw_enter_lps_core(struct rtw_dev *rtwdev)
+{
+	struct rtw_lps_conf *conf = &rtwdev->lps_conf;
+
+	conf->state = RTW_RF_OFF;
+	conf->awake_interval = 1;
+	conf->rlbm = 1;
+	conf->smart_ps = 2;
+
+	rtw_fw_set_pwr_mode(rtwdev);
+	rtw_flag_set(rtwdev, RTW_FLAG_LEISURE_PS);
+}
+
+void rtw_lps_work(struct work_struct *work)
+{
+	struct rtw_dev *rtwdev = container_of(work, struct rtw_dev,
+					      lps_work.work);
+	struct rtw_lps_conf *conf = &rtwdev->lps_conf;
+	struct rtw_vif *rtwvif = conf->rtwvif;
+
+	if (WARN_ON(!rtwvif))
+		return;
+
+	if (conf->mode == RTW_MODE_LPS)
+		rtw_enter_lps_core(rtwdev);
+	else
+		rtw_leave_lps_core(rtwdev);
+}
+
+void rtw_enter_lps_irqsafe(struct rtw_dev *rtwdev, struct rtw_vif *rtwvif)
+{
+	struct rtw_lps_conf *conf = &rtwdev->lps_conf;
+
+	if (rtwvif->in_lps)
+		return;
+
+	conf->mode = RTW_MODE_LPS;
+	conf->rtwvif = rtwvif;
+	rtwvif->in_lps = true;
+
+	ieee80211_queue_delayed_work(rtwdev->hw, &rtwdev->lps_work, 0);
+}
+
+void rtw_leave_lps_irqsafe(struct rtw_dev *rtwdev, struct rtw_vif *rtwvif)
+{
+	struct rtw_lps_conf *conf = &rtwdev->lps_conf;
+
+	if (!rtwvif->in_lps)
+		return;
+
+	conf->mode = RTW_MODE_ACTIVE;
+	conf->rtwvif = rtwvif;
+	rtwvif->in_lps = false;
+
+	ieee80211_queue_delayed_work(rtwdev->hw, &rtwdev->lps_work, 0);
+}
+
+bool rtw_in_lps(struct rtw_dev *rtwdev)
+{
+	return rtw_flag_check(rtwdev, RTW_FLAG_LEISURE_PS);
+}
+
+void rtw_enter_lps(struct rtw_dev *rtwdev, struct rtw_vif *rtwvif)
+{
+	struct rtw_lps_conf *conf = &rtwdev->lps_conf;
+
+	if (WARN_ON(!rtwvif))
+		return;
+
+	if (rtwvif->in_lps)
+		return;
+
+	conf->mode = RTW_MODE_LPS;
+	conf->rtwvif = rtwvif;
+	rtwvif->in_lps = true;
+
+	rtw_enter_lps_core(rtwdev);
+}
+
+void rtw_leave_lps(struct rtw_dev *rtwdev, struct rtw_vif *rtwvif)
+{
+	struct rtw_lps_conf *conf = &rtwdev->lps_conf;
+
+	if (WARN_ON(!rtwvif))
+		return;
+
+	if (!rtwvif->in_lps)
+		return;
+
+	conf->mode = RTW_MODE_ACTIVE;
+	conf->rtwvif = rtwvif;
+	rtwvif->in_lps = false;
+
+	rtw_leave_lps_core(rtwdev);
+}
diff --git a/drivers/net/wireless/realtek/rtwlan/ps.h b/drivers/net/wireless/realtek/rtwlan/ps.h
new file mode 100644
index 0000000..71a74d1
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtwlan/ps.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2018  Realtek Corporation.
+ */
+
+#ifndef __RTW_PS_H_
+#define __RTW_PS_H_
+
+#define RTW_LPS_THRESHOLD	2
+
+int rtw_enter_ips(struct rtw_dev *rtwdev);
+int rtw_leave_ips(struct rtw_dev *rtwdev);
+
+void rtw_lps_enter_check(struct rtw_dev *rtwdev);
+void rtw_lps_work(struct work_struct *work);
+void rtw_enter_lps_irqsafe(struct rtw_dev *rtwdev, struct rtw_vif *rtwvif);
+void rtw_leave_lps_irqsafe(struct rtw_dev *rtwdev, struct rtw_vif *rtwvif);
+void rtw_enter_lps(struct rtw_dev *rtwdev, struct rtw_vif *rtwvif);
+void rtw_leave_lps(struct rtw_dev *rtwdev, struct rtw_vif *rtwvif);
+bool rtw_in_lps(struct rtw_dev *rtwdev);
+
+#endif
diff --git a/drivers/net/wireless/realtek/rtwlan/regd.c b/drivers/net/wireless/realtek/rtwlan/regd.c
new file mode 100644
index 0000000..4c2dcd3
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtwlan/regd.c
@@ -0,0 +1,462 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2018  Realtek Corporation.
+ */
+
+#include "main.h"
+#include "regd.h"
+
+static struct country_code_to_enum_rd all_countries[] = {
+	{COUNTRY_CODE_FCC, "US"},
+	{COUNTRY_CODE_IC, "US"},
+	{COUNTRY_CODE_ETSI, "EC"},
+	{COUNTRY_CODE_SPAIN, "EC"},
+	{COUNTRY_CODE_FRANCE, "EC"},
+	{COUNTRY_CODE_MKK, "JP"},
+	{COUNTRY_CODE_MKK1, "JP"},
+	{COUNTRY_CODE_ISRAEL, "EC"},
+	{COUNTRY_CODE_TELEC, "JP"},
+	{COUNTRY_CODE_MIC, "JP"},
+	{COUNTRY_CODE_GLOBAL_DOMAIN, "JP"},
+	{COUNTRY_CODE_WORLD_WIDE_13, "EC"},
+	{COUNTRY_CODE_TELEC_NETGEAR, "EC"},
+	{COUNTRY_CODE_WORLD_WIDE_13_5G_ALL, "US"},
+};
+
+/* Only these channels allow active
+ * scan on all world regulatory domains
+ */
+#define RTW_2GHZ_CH01_11	\
+	REG_RULE(2412 - 10, 2462 + 10, 40, 0, 20, 0)
+
+/* Enable active scan on these case
+ * by case basis by regulatory domain
+ */
+#define RTW_2GHZ_CH12_13	\
+	REG_RULE(2467 - 10, 2472 + 10, 40, 0, 20,\
+	NL80211_RRF_PASSIVE_SCAN)
+
+#define RTW_2GHZ_CH14	\
+	REG_RULE(2484 - 10, 2484 + 10, 40, 0, 20, \
+	NL80211_RRF_PASSIVE_SCAN | \
+	NL80211_RRF_NO_OFDM)
+
+/* 5G chan 36 - chan 64 */
+#define RTW_5GHZ_5150_5350	\
+	REG_RULE(5150 - 10, 5350 + 10, 80, 0, 30, 0)
+/* 5G chan 100 - chan 165 */
+#define RTW_5GHZ_5470_5850	\
+	REG_RULE(5470 - 10, 5850 + 10, 80, 0, 30, 0)
+/* 5G chan 149 - chan 165 */
+#define RTW_5GHZ_5725_5850	\
+	REG_RULE(5725 - 10, 5850 + 10, 80, 0, 30, 0)
+
+#define RTW_5GHZ_ALL	\
+	(RTW_5GHZ_5150_5350, RTW_5GHZ_5470_5850)
+
+static const struct ieee80211_regdomain rtw_regdom_11 = {
+	.n_reg_rules = 1,
+	.alpha2 = "99",
+	.reg_rules = {
+		RTW_2GHZ_CH01_11,
+	}
+};
+
+static const struct ieee80211_regdomain rtw_regdom_12_13 = {
+	.n_reg_rules = 2,
+	.alpha2 = "99",
+	.reg_rules = {
+		RTW_2GHZ_CH01_11,
+		RTW_2GHZ_CH12_13,
+	}
+};
+
+static const struct ieee80211_regdomain rtw_regdom_no_midband = {
+	.n_reg_rules = 3,
+	.alpha2 = "99",
+	.reg_rules = {
+		RTW_2GHZ_CH01_11,
+		RTW_5GHZ_5150_5350,
+		RTW_5GHZ_5725_5850,
+	}
+};
+
+static const struct ieee80211_regdomain rtw_regdom_60_64 = {
+	.n_reg_rules = 3,
+	.alpha2 = "99",
+	.reg_rules = {
+		RTW_2GHZ_CH01_11,
+		RTW_2GHZ_CH12_13,
+		RTW_5GHZ_5725_5850,
+	}
+};
+
+static const struct ieee80211_regdomain rtw_regdom_14_60_64 = {
+	.n_reg_rules = 4,
+	.alpha2 = "99",
+	.reg_rules = {
+		RTW_2GHZ_CH01_11,
+		RTW_2GHZ_CH12_13,
+		RTW_2GHZ_CH14,
+		RTW_5GHZ_5725_5850,
+	}
+};
+
+static const struct ieee80211_regdomain rtw_regdom_12_13_5g_all = {
+	.n_reg_rules = 4,
+	.alpha2 = "99",
+	.reg_rules = {
+		RTW_2GHZ_CH01_11,
+		RTW_2GHZ_CH12_13,
+		RTW_5GHZ_5150_5350,
+		RTW_5GHZ_5470_5850,
+	}
+};
+
+static const struct ieee80211_regdomain rtw_regdom_14 = {
+	.n_reg_rules = 3,
+	.alpha2 = "99",
+	.reg_rules = {
+		RTW_2GHZ_CH01_11,
+		RTW_2GHZ_CH12_13,
+		RTW_2GHZ_CH14,
+	}
+};
+
+static bool rtw_is_radar_freq(u16 center_freq)
+{
+	return center_freq >= 5260 && center_freq <= 5700;
+}
+
+static void rtw_regd_apply_beaconing_flags(struct wiphy *wiphy,
+					   enum nl80211_reg_initiator initiator)
+{
+	enum nl80211_band band;
+	struct ieee80211_supported_band *sband;
+	const struct ieee80211_reg_rule *reg_rule;
+	struct ieee80211_channel *ch;
+	unsigned int i;
+
+	for (band = 0; band < NUM_NL80211_BANDS; band++) {
+		if (!wiphy->bands[band])
+			continue;
+
+		sband = wiphy->bands[band];
+		for (i = 0; i < sband->n_channels; i++) {
+			ch = &sband->channels[i];
+			if (rtw_is_radar_freq(ch->center_freq) ||
+			    (ch->flags & IEEE80211_CHAN_RADAR))
+				continue;
+			if (initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE) {
+				reg_rule = freq_reg_info(wiphy,
+							 ch->center_freq);
+				if (IS_ERR(reg_rule))
+					continue;
+
+				/* If 11d had a rule for this channel ensure
+				 * we enable adhoc/beaconing if it allows us to
+				 * use it. Note that we would have disabled it
+				 * by applying our static world regdomain by
+				 * default during init, prior to calling our
+				 * regulatory_hint().
+				 */
+				if (!(reg_rule->flags & NL80211_RRF_NO_IBSS))
+					ch->flags &= ~IEEE80211_CHAN_NO_IBSS;
+				if (!(reg_rule->flags &
+				      NL80211_RRF_PASSIVE_SCAN))
+					ch->flags &=
+					    ~IEEE80211_CHAN_PASSIVE_SCAN;
+			} else {
+				if (ch->beacon_found)
+					ch->flags &= ~(IEEE80211_CHAN_NO_IBSS |
+						   IEEE80211_CHAN_PASSIVE_SCAN);
+			}
+		}
+	}
+}
+
+/* Allows active scan scan on Ch 12 and 13 */
+static void
+rtw_regd_apply_active_scan_flags(struct wiphy *wiphy,
+				 enum nl80211_reg_initiator initiator)
+{
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_channel *ch;
+	const struct ieee80211_reg_rule *reg_rule;
+
+	if (!wiphy->bands[NL80211_BAND_2GHZ])
+		return;
+	sband = wiphy->bands[NL80211_BAND_2GHZ];
+
+	/* If no country IE has been received always enable active scan
+	 * on these channels. This is only done for specific regulatory SKUs
+	 */
+	if (initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE) {
+		ch = &sband->channels[11];	/* CH 12 */
+		if (ch->flags & IEEE80211_CHAN_PASSIVE_SCAN)
+			ch->flags &= ~IEEE80211_CHAN_PASSIVE_SCAN;
+		ch = &sband->channels[12];	/* CH 13 */
+		if (ch->flags & IEEE80211_CHAN_PASSIVE_SCAN)
+			ch->flags &= ~IEEE80211_CHAN_PASSIVE_SCAN;
+		return;
+	}
+
+	/* If a country IE has been received check its rule for this
+	 * channel first before enabling active scan. The passive scan
+	 * would have been enforced by the initial processing of our
+	 * custom regulatory domain.
+	 */
+
+	ch = &sband->channels[11];	/* CH 12 */
+	reg_rule = freq_reg_info(wiphy, ch->center_freq);
+	if (!IS_ERR(reg_rule)) {
+		if (!(reg_rule->flags & NL80211_RRF_PASSIVE_SCAN))
+			if (ch->flags & IEEE80211_CHAN_PASSIVE_SCAN)
+				ch->flags &= ~IEEE80211_CHAN_PASSIVE_SCAN;
+	}
+
+	ch = &sband->channels[12];	/* CH 13 */
+	reg_rule = freq_reg_info(wiphy, ch->center_freq);
+	if (!IS_ERR(reg_rule)) {
+		if (!(reg_rule->flags & NL80211_RRF_PASSIVE_SCAN))
+			if (ch->flags & IEEE80211_CHAN_PASSIVE_SCAN)
+				ch->flags &= ~IEEE80211_CHAN_PASSIVE_SCAN;
+	}
+}
+
+static void rtw_regd_apply_hw_cap_flags(struct wiphy *wiphy)
+{
+	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_channel *ch;
+	struct rtw_dev *rtwdev = hw->priv;
+	struct rtw_efuse *efuse = &rtwdev->efuse;
+	int i;
+
+	if (efuse->hw_cap.bw & BIT(RTW_CHANNEL_WIDTH_80))
+		return;
+
+	sband = wiphy->bands[NL80211_BAND_2GHZ];
+	if (!sband)
+		goto out_5g;
+
+	for (i = 0; i < sband->n_channels; i++) {
+		ch = &sband->channels[i];
+		ch->flags |= IEEE80211_CHAN_NO_80MHZ;
+	}
+
+out_5g:
+	sband = wiphy->bands[NL80211_BAND_5GHZ];
+	if (!sband)
+		return;
+
+	for (i = 0; i < sband->n_channels; i++) {
+		ch = &sband->channels[i];
+		ch->flags |= IEEE80211_CHAN_NO_80MHZ;
+	}
+}
+
+/* Always apply Radar/DFS rules on
+ * freq range 5260 MHz - 5700 MHz
+ */
+static void rtw_regd_apply_radar_flags(struct wiphy *wiphy)
+{
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_channel *ch;
+	int i;
+
+	if (!wiphy->bands[NL80211_BAND_5GHZ])
+		return;
+
+	sband = wiphy->bands[NL80211_BAND_5GHZ];
+
+	for (i = 0; i < sband->n_channels; i++) {
+		ch = &sband->channels[i];
+		if (!rtw_is_radar_freq(ch->center_freq))
+			continue;
+
+		/* We always enable radar detection/DFS on this
+		 * frequency range. Additionally we also apply on
+		 * this frequency range:
+		 * - If STA mode does not yet have DFS supports disable
+		 *   active scanning
+		 * - If adhoc mode does not support DFS yet then disable
+		 *   adhoc in the frequency.
+		 * - If AP mode does not yet support radar detection/DFS
+		 *   do not allow AP mode
+		 */
+		if (!(ch->flags & IEEE80211_CHAN_DISABLED))
+			ch->flags |= IEEE80211_CHAN_RADAR |
+			    IEEE80211_CHAN_NO_IBSS |
+			    IEEE80211_CHAN_PASSIVE_SCAN;
+	}
+}
+
+static void rtw_regd_apply_world_flags(struct wiphy *wiphy,
+				       enum nl80211_reg_initiator initiator,
+				       struct rtw_regulatory *reg)
+{
+	rtw_regd_apply_beaconing_flags(wiphy, initiator);
+	rtw_regd_apply_active_scan_flags(wiphy, initiator);
+}
+
+static void rtw_dump_channel_map(struct wiphy *wiphy)
+{
+	enum nl80211_band band;
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_channel *ch;
+	unsigned int i;
+
+	for (band = 0; band < NUM_NL80211_BANDS; band++) {
+		if (!wiphy->bands[band])
+			continue;
+		sband = wiphy->bands[band];
+		for (i = 0; i < sband->n_channels; i++)
+			ch = &sband->channels[i];
+	}
+}
+
+static int rtw_regd_notifier_apply(struct wiphy *wiphy,
+				   struct regulatory_request *request,
+				   struct rtw_regulatory *reg)
+{
+	/* We always apply this */
+	rtw_regd_apply_radar_flags(wiphy);
+
+	switch (request->initiator) {
+	case NL80211_REGDOM_SET_BY_DRIVER:
+	case NL80211_REGDOM_SET_BY_CORE:
+	case NL80211_REGDOM_SET_BY_USER:
+		break;
+	case NL80211_REGDOM_SET_BY_COUNTRY_IE:
+		rtw_regd_apply_world_flags(wiphy, request->initiator, reg);
+		break;
+	}
+
+	rtw_dump_channel_map(wiphy);
+
+	return 0;
+}
+
+static const
+struct ieee80211_regdomain *rtw_regdomain_select(struct rtw_regulatory *reg)
+{
+	switch (reg->country_code) {
+	case COUNTRY_CODE_FCC:
+		return &rtw_regdom_no_midband;
+	case COUNTRY_CODE_IC:
+		return &rtw_regdom_11;
+	case COUNTRY_CODE_TELEC_NETGEAR:
+		return &rtw_regdom_60_64;
+	case COUNTRY_CODE_ETSI:
+	case COUNTRY_CODE_SPAIN:
+	case COUNTRY_CODE_FRANCE:
+	case COUNTRY_CODE_ISRAEL:
+		return &rtw_regdom_12_13;
+	case COUNTRY_CODE_MKK:
+	case COUNTRY_CODE_MKK1:
+	case COUNTRY_CODE_TELEC:
+	case COUNTRY_CODE_MIC:
+		return &rtw_regdom_14_60_64;
+	case COUNTRY_CODE_GLOBAL_DOMAIN:
+		return &rtw_regdom_14;
+	case COUNTRY_CODE_WORLD_WIDE_13:
+	case COUNTRY_CODE_WORLD_WIDE_13_5G_ALL:
+		return &rtw_regdom_12_13_5g_all;
+	default:
+		return &rtw_regdom_no_midband;
+	}
+}
+
+static int
+rtw_regd_init_wiphy(struct rtw_regulatory *reg, struct wiphy *wiphy,
+		    void (*reg_notifier)(struct wiphy *wiphy,
+					 struct regulatory_request *request))
+{
+	const struct ieee80211_regdomain *regd;
+
+	wiphy->reg_notifier = reg_notifier;
+
+	wiphy->regulatory_flags |= REGULATORY_CUSTOM_REG;
+	wiphy->regulatory_flags &= ~REGULATORY_STRICT_REG;
+	wiphy->regulatory_flags &= ~REGULATORY_DISABLE_BEACON_HINTS;
+
+	regd = rtw_regdomain_select(reg);
+	wiphy_apply_custom_regulatory(wiphy, regd);
+	rtw_regd_apply_hw_cap_flags(wiphy);
+	rtw_regd_apply_radar_flags(wiphy);
+	rtw_regd_apply_world_flags(wiphy, NL80211_REGDOM_SET_BY_DRIVER, reg);
+
+	return 0;
+}
+
+static struct country_code_to_enum_rd *rtw_regd_find_country(u16 countrycode)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(all_countries); i++) {
+		if (all_countries[i].countrycode == countrycode)
+			return &all_countries[i];
+	}
+	return NULL;
+}
+
+static u8 channel_plan_to_country_code(u8 channel_plan)
+{
+	switch (channel_plan) {
+	case 0x20:
+	case 0x21:
+		return COUNTRY_CODE_WORLD_WIDE_13;
+	case 0x22:
+		return COUNTRY_CODE_IC;
+	case 0x25:
+		return COUNTRY_CODE_ETSI;
+	case 0x32:
+		return COUNTRY_CODE_TELEC_NETGEAR;
+	case 0x41:
+		return COUNTRY_CODE_GLOBAL_DOMAIN;
+	case 0x7f:
+		return COUNTRY_CODE_WORLD_WIDE_13_5G_ALL;
+	default:
+		return COUNTRY_CODE_MAX;
+	}
+}
+
+int rtw_regd_init(struct rtw_dev *rtwdev,
+		  void (*reg_notifier)(struct wiphy *wiphy,
+				       struct regulatory_request *request))
+{
+	struct wiphy *wiphy = rtwdev->hw->wiphy;
+	struct country_code_to_enum_rd *country = NULL;
+	u8 channel_plan = rtwdev->efuse.channel_plan;
+
+	if (!wiphy || !&rtwdev->regd)
+		return -EINVAL;
+
+	/* init country_code from efuse channel plan */
+	rtwdev->regd.country_code = channel_plan_to_country_code(channel_plan);
+
+	if (rtwdev->regd.country_code >= COUNTRY_CODE_MAX)
+		rtwdev->regd.country_code = COUNTRY_CODE_WORLD_WIDE_13;
+
+	country = rtw_regd_find_country(rtwdev->regd.country_code);
+
+	if (country) {
+		rtwdev->regd.alpha2[0] = country->iso_name[0];
+		rtwdev->regd.alpha2[1] = country->iso_name[1];
+	} else {
+		rtwdev->regd.alpha2[0] = '0';
+		rtwdev->regd.alpha2[1] = '0';
+	}
+
+	rtw_regd_init_wiphy(&rtwdev->regd, wiphy, reg_notifier);
+
+	return 0;
+}
+
+void rtw_regd_notifier(struct wiphy *wiphy, struct regulatory_request *request)
+{
+	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
+	struct rtw_dev *rtwdev = hw->priv;
+
+	rtw_regd_notifier_apply(wiphy, request, &rtwdev->regd);
+}
diff --git a/drivers/net/wireless/realtek/rtwlan/regd.h b/drivers/net/wireless/realtek/rtwlan/regd.h
new file mode 100644
index 0000000..9cbdb8b
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtwlan/regd.h
@@ -0,0 +1,40 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2018  Realtek Corporation.
+ */
+
+#ifndef __RTW_REGD_H_
+#define __RTW_REGD_H_
+
+#define IEEE80211_CHAN_NO_IBSS IEEE80211_CHAN_NO_IR
+#define IEEE80211_CHAN_PASSIVE_SCAN IEEE80211_CHAN_NO_IR
+
+struct country_code_to_enum_rd {
+	u16 countrycode;
+	const char *iso_name;
+};
+
+enum country_code_type {
+	COUNTRY_CODE_FCC = 0,
+	COUNTRY_CODE_IC = 1,
+	COUNTRY_CODE_ETSI = 2,
+	COUNTRY_CODE_SPAIN = 3,
+	COUNTRY_CODE_FRANCE = 4,
+	COUNTRY_CODE_MKK = 5,
+	COUNTRY_CODE_MKK1 = 6,
+	COUNTRY_CODE_ISRAEL = 7,
+	COUNTRY_CODE_TELEC = 8,
+	COUNTRY_CODE_MIC = 9,
+	COUNTRY_CODE_GLOBAL_DOMAIN = 10,
+	COUNTRY_CODE_WORLD_WIDE_13 = 11,
+	COUNTRY_CODE_TELEC_NETGEAR = 12,
+	COUNTRY_CODE_WORLD_WIDE_13_5G_ALL = 13,
+
+	/* new channel plan above this */
+	COUNTRY_CODE_MAX
+};
+
+int rtw_regd_init(struct rtw_dev *rtwdev,
+		  void (*reg_notifier)(struct wiphy *wiphy,
+				       struct regulatory_request *request));
+void rtw_regd_notifier(struct wiphy *wiphy, struct regulatory_request *request);
+#endif
diff --git a/drivers/net/wireless/realtek/rtwlan/sec.c b/drivers/net/wireless/realtek/rtwlan/sec.c
new file mode 100644
index 0000000..7d09439
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtwlan/sec.c
@@ -0,0 +1,135 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2018  Realtek Corporation.
+ */
+
+#include "main.h"
+#include "sec.h"
+#include "reg.h"
+
+u32 rtw_sec_installed_cam_num(struct rtw_sec_desc *sec)
+{
+	u32 cnt = 0;
+	int i;
+
+	for (i = 0; i < sec->total_cam_num; i++)
+		if (sec->cam_table[i].used)
+			cnt++;
+
+	return cnt;
+}
+
+int rtw_sec_get_free_cam(struct rtw_sec_desc *sec)
+{
+	int i;
+
+	/* if default key search is enabled, the first 4 cam entries
+	 * are used to direct map to group key with its key->key_idx, so
+	 * driver should use cam entries after 4 to install pairwise key
+	 */
+	i = sec->default_key_search ? RTW_SEC_DEFAULT_KEY_NUM : 0;
+	for (; i < sec->total_cam_num; i++)
+		if (!sec->cam_table[i].used)
+			return i;
+
+	return i;
+}
+
+void rtw_sec_write_cam(struct rtw_dev *rtwdev,
+		       struct rtw_sec_desc *sec,
+		       struct ieee80211_sta *sta,
+		       struct ieee80211_key_conf *key,
+		       u8 hw_key_type, u8 hw_key_idx)
+{
+	struct rtw_cam_entry *cam = &sec->cam_table[hw_key_idx];
+	u32 write_cmd;
+	u32 command;
+	u32 content;
+	u32 addr;
+	int i, j;
+
+	cam->used = true;
+	cam->valid = true;
+	cam->group = !(key->flags & IEEE80211_KEY_FLAG_PAIRWISE);
+	cam->hw_key_type = hw_key_type;
+	cam->key = key;
+	if (sta)
+		ether_addr_copy(cam->addr, sta->addr);
+	else
+		eth_broadcast_addr(cam->addr);
+
+	write_cmd = RTW_SEC_CMD_WRITE_ENABLE | RTW_SEC_CMD_POLLING;
+	addr = hw_key_idx << RTW_SEC_CAM_ENTRY_SHIFT;
+	for (i = 5; i >= 0; i--) {
+		switch (i) {
+		case 0:
+			content = ((key->keyidx & 0x3))		|
+				  ((hw_key_type & 0x7)	<< 2)	|
+				  (cam->group		<< 6)	|
+				  (cam->valid		<< 15)	|
+				  (cam->addr[0]		<< 16)	|
+				  (cam->addr[1]		<< 24);
+			break;
+		case 1:
+			content = (cam->addr[2])		|
+				  (cam->addr[3]		<< 8)	|
+				  (cam->addr[4]		<< 16)	|
+				  (cam->addr[5]		<< 24);
+			break;
+		default:
+			j = (i - 2) << 2;
+			content = (key->key[j])			|
+				  (key->key[j + 1]	<< 8)	|
+				  (key->key[j + 2]	<< 16)	|
+				  (key->key[j + 3]	<< 24);
+			break;
+		}
+
+		command = write_cmd | (addr + i);
+		rtw_write32(rtwdev, RTW_SEC_WRITE_REG, content);
+		rtw_write32(rtwdev, RTW_SEC_CMD_REG, command);
+	}
+}
+
+void rtw_sec_clear_cam(struct rtw_dev *rtwdev,
+		       struct rtw_sec_desc *sec,
+		       u8 hw_key_idx)
+{
+	struct rtw_cam_entry *cam = &sec->cam_table[hw_key_idx];
+	u32 write_cmd;
+	u32 command;
+	u32 addr;
+
+	cam->used = false;
+	cam->valid = false;
+	cam->key = NULL;
+	eth_zero_addr(cam->addr);
+
+	write_cmd = RTW_SEC_CMD_WRITE_ENABLE | RTW_SEC_CMD_POLLING;
+	addr = hw_key_idx << RTW_SEC_CAM_ENTRY_SHIFT;
+	command = write_cmd | addr;
+	rtw_write32(rtwdev, RTW_SEC_WRITE_REG, 0);
+	rtw_write32(rtwdev, RTW_SEC_CMD_REG, command);
+}
+
+void rtw_sec_enable_sec_engine(struct rtw_dev *rtwdev)
+{
+	struct rtw_sec_desc *sec = &rtwdev->sec;
+	u16 ctrl_reg;
+	u16 sec_config;
+
+	/* default use default key search for now */
+	sec->default_key_search = true;
+
+	ctrl_reg = rtw_read16(rtwdev, REG_CR);
+	ctrl_reg |= RTW_SEC_ENGINE_EN;
+	rtw_write16(rtwdev, REG_CR, ctrl_reg);
+
+	sec_config = rtw_read16(rtwdev, RTW_SEC_CONFIG);
+
+	sec_config |= RTW_SEC_TX_DEC_EN | RTW_SEC_RX_DEC_EN;
+	if (sec->default_key_search)
+		sec_config |= RTW_SEC_TX_UNI_USE_DK | RTW_SEC_RX_UNI_USE_DK |
+			      RTW_SEC_TX_BC_USE_DK | RTW_SEC_RX_BC_USE_DK;
+
+	rtw_write16(rtwdev, RTW_SEC_CONFIG, sec_config);
+}
diff --git a/drivers/net/wireless/realtek/rtwlan/sec.h b/drivers/net/wireless/realtek/rtwlan/sec.h
new file mode 100644
index 0000000..b3d9fdb
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtwlan/sec.h
@@ -0,0 +1,40 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2018  Realtek Corporation.
+ */
+
+#ifndef __RTW_SEC_H_
+#define __RTW_SEC_H_
+
+#define RTW_SEC_CMD_REG			0x670
+#define RTW_SEC_WRITE_REG		0x674
+#define RTW_SEC_READ_REG		0x678
+#define RTW_SEC_CONFIG			0x680
+
+#define RTW_SEC_CAM_ENTRY_SHIFT		3
+#define RTW_SEC_DEFAULT_KEY_NUM		4
+#define RTW_SEC_CMD_WRITE_ENABLE	BIT(16)
+#define RTW_SEC_CMD_CLEAR		BIT(30)
+#define RTW_SEC_CMD_POLLING		BIT(31)
+
+#define RTW_SEC_TX_UNI_USE_DK		BIT(0)
+#define RTW_SEC_RX_UNI_USE_DK		BIT(1)
+#define RTW_SEC_TX_DEC_EN		BIT(2)
+#define RTW_SEC_RX_DEC_EN		BIT(3)
+#define RTW_SEC_TX_BC_USE_DK		BIT(6)
+#define RTW_SEC_RX_BC_USE_DK		BIT(7)
+
+#define RTW_SEC_ENGINE_EN		BIT(9)
+
+u32 rtw_sec_installed_cam_num(struct rtw_sec_desc *sec);
+int rtw_sec_get_free_cam(struct rtw_sec_desc *sec);
+void rtw_sec_write_cam(struct rtw_dev *rtwdev,
+		       struct rtw_sec_desc *sec,
+		       struct ieee80211_sta *sta,
+		       struct ieee80211_key_conf *key,
+		       u8 hw_key_type, u8 hw_key_idx);
+void rtw_sec_clear_cam(struct rtw_dev *rtwdev,
+		       struct rtw_sec_desc *sec,
+		       u8 hw_key_idx);
+void rtw_sec_enable_sec_engine(struct rtw_dev *rtwdev);
+
+#endif
-- 
2.7.4
