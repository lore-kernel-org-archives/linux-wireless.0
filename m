Return-Path: <SRS0=P1q9=MZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5BA1C28CF8
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 09:01:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42C6220835
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 09:01:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 42C6220835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=realtek.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbeJMQhk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Oct 2018 12:37:40 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:60271 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727028AbeJMQhj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Oct 2018 12:37:39 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID w9D90tGI000965, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id w9D90tGI000965
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=NOT);
        Sat, 13 Oct 2018 17:00:55 +0800
Received: from localhost.localdomain (172.21.68.143) by
 RTITCASV01.realtek.com.tw (172.21.6.18) with Microsoft SMTP Server id
 14.3.408.0; Sat, 13 Oct 2018 17:00:54 +0800
From:   <yhchuang@realtek.com>
To:     <kvalo@codeaurora.org>
CC:     <Larry.Finger@lwfinger.net>, <pkshih@realtek.com>,
        <tehuang@realtek.com>, <sgruszka@redhat.com>,
        <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>
Subject: [RFC v4 02/13] rtw88: core files
Date:   Sat, 13 Oct 2018 17:00:34 +0800
Message-ID: <1539421245-11847-3-git-send-email-yhchuang@realtek.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1539421245-11847-1-git-send-email-yhchuang@realtek.com>
References: <1539421245-11847-1-git-send-email-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.68.143]
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

core files for Realtek 802.11ac wireless network chips

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
---
 drivers/net/wireless/realtek/rtw88/ps.c   | 168 +++++++++++++++
 drivers/net/wireless/realtek/rtw88/ps.h   |  20 ++
 drivers/net/wireless/realtek/rtw88/regd.c | 328 ++++++++++++++++++++++++++++++
 drivers/net/wireless/realtek/rtw88/regd.h |  40 ++++
 drivers/net/wireless/realtek/rtw88/sec.c  | 120 +++++++++++
 drivers/net/wireless/realtek/rtw88/sec.h  |  39 ++++
 6 files changed, 715 insertions(+)
 create mode 100644 drivers/net/wireless/realtek/rtw88/ps.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/ps.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/regd.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/regd.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/sec.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/sec.h

diff --git a/drivers/net/wireless/realtek/rtw88/ps.c b/drivers/net/wireless/realtek/rtw88/ps.c
new file mode 100644
index 0000000..28b7204
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/ps.c
@@ -0,0 +1,168 @@
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
+static void rtw_restore_port_cfg_iter(void *data, u8 *mac,
+				      struct ieee80211_vif *vif)
+{
+	struct rtw_dev *rtwdev = data;
+	struct rtw_vif *rtwvif = (struct rtw_vif *)vif->drv_priv;
+	u32 config = ~0;
+
+	rtw_vif_port_config(rtwdev, rtwvif, config);
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
+	ieee80211_iterate_active_interfaces_atomic(rtwdev->hw,
+			IEEE80211_IFACE_ITER_NORMAL,
+			rtw_restore_port_cfg_iter,
+			rtwdev);
+
+	return 0;
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
diff --git a/drivers/net/wireless/realtek/rtw88/ps.h b/drivers/net/wireless/realtek/rtw88/ps.h
new file mode 100644
index 0000000..4006c6c
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/ps.h
@@ -0,0 +1,20 @@
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
+void rtw_lps_work(struct work_struct *work);
+void rtw_enter_lps_irqsafe(struct rtw_dev *rtwdev, struct rtw_vif *rtwvif);
+void rtw_leave_lps_irqsafe(struct rtw_dev *rtwdev, struct rtw_vif *rtwvif);
+void rtw_enter_lps(struct rtw_dev *rtwdev, struct rtw_vif *rtwvif);
+void rtw_leave_lps(struct rtw_dev *rtwdev, struct rtw_vif *rtwvif);
+bool rtw_in_lps(struct rtw_dev *rtwdev);
+
+#endif
diff --git a/drivers/net/wireless/realtek/rtw88/regd.c b/drivers/net/wireless/realtek/rtw88/regd.c
new file mode 100644
index 0000000..0924ee2
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/regd.c
@@ -0,0 +1,328 @@
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
+static int
+rtw_regd_init_wiphy(struct rtw_regulatory *reg, struct wiphy *wiphy,
+		    void (*reg_notifier)(struct wiphy *wiphy,
+					 struct regulatory_request *request))
+{
+	wiphy->reg_notifier = reg_notifier;
+
+	wiphy->regulatory_flags |= REGULATORY_CUSTOM_REG;
+	wiphy->regulatory_flags &= ~REGULATORY_STRICT_REG;
+	wiphy->regulatory_flags &= ~REGULATORY_DISABLE_BEACON_HINTS;
+
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
diff --git a/drivers/net/wireless/realtek/rtw88/regd.h b/drivers/net/wireless/realtek/rtw88/regd.h
new file mode 100644
index 0000000..9cbdb8b
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/regd.h
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
diff --git a/drivers/net/wireless/realtek/rtw88/sec.c b/drivers/net/wireless/realtek/rtw88/sec.c
new file mode 100644
index 0000000..59b6fce
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/sec.c
@@ -0,0 +1,120 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2018  Realtek Corporation.
+ */
+
+#include "main.h"
+#include "sec.h"
+#include "reg.h"
+
+int rtw_sec_get_free_cam(struct rtw_sec_desc *sec)
+{
+	/* if default key search is enabled, the first 4 cam entries
+	 * are used to direct map to group key with its key->key_idx, so
+	 * driver should use cam entries after 4 to install pairwise key
+	 */
+	if (sec->default_key_search)
+		return find_next_zero_bit(sec->cam_map, RTW_MAX_SEC_CAM_NUM,
+					  RTW_SEC_DEFAULT_KEY_NUM);
+
+	return find_first_zero_bit(sec->cam_map, RTW_MAX_SEC_CAM_NUM);
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
+	set_bit(hw_key_idx, sec->cam_map);
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
+	clear_bit(hw_key_idx, sec->cam_map);
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
diff --git a/drivers/net/wireless/realtek/rtw88/sec.h b/drivers/net/wireless/realtek/rtw88/sec.h
new file mode 100644
index 0000000..f13b36a
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/sec.h
@@ -0,0 +1,39 @@
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

