Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:12115 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933078AbbFVIIV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 04:08:21 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t5M7xp6F015529
	for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2015 01:08:20 -0700
Received: from sc-owa03.marvell.com ([199.233.58.149])
	by mx0a-0016f401.pphosted.com with ESMTP id 1v55hgut9w-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2015 01:08:20 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <huxm@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH 16/17] mwifiex: separate interface combination for multichannel and DFS
Date: Mon, 22 Jun 2015 19:06:22 +0530
Message-ID: <1434980183-2901-17-git-send-email-patila@marvell.com> (sfid-20150622_103351_210877_C0C6F967)
In-Reply-To: <1434980183-2901-1-git-send-email-patila@marvell.com>
References: <1434980183-2901-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Multichannel and DFS cannot be supported at same time. So when multichannel
operation is enabled by module parameter, we enable number of channel as 2
while registering wiphy. For all other cases we advertise DFS support to
cfg80211. Patch also adds support for radar detect widths parameter.

Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index bc863e9..93e40d0 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -35,16 +35,33 @@ static const struct ieee80211_iface_limit mwifiex_ap_sta_limits[] = {
 	},
 };
 
-static const struct ieee80211_iface_combination mwifiex_iface_comb_ap_sta = {
+static const struct ieee80211_iface_combination
+mwifiex_iface_comb_ap_sta = {
 	.limits = mwifiex_ap_sta_limits,
 	.num_different_channels = 1,
 	.n_limits = ARRAY_SIZE(mwifiex_ap_sta_limits),
 	.max_interfaces = MWIFIEX_MAX_BSS_NUM,
 	.beacon_int_infra_match = true,
+	.radar_detect_widths =	BIT(NL80211_CHAN_WIDTH_20_NOHT) |
+				BIT(NL80211_CHAN_WIDTH_20) |
+				BIT(NL80211_CHAN_WIDTH_40),
+};
+
+static const struct ieee80211_iface_combination
+mwifiex_iface_comb_ap_sta_vht = {
+	.limits = mwifiex_ap_sta_limits,
+	.num_different_channels = 1,
+	.n_limits = ARRAY_SIZE(mwifiex_ap_sta_limits),
+	.max_interfaces = MWIFIEX_MAX_BSS_NUM,
+	.beacon_int_infra_match = true,
+	.radar_detect_widths =	BIT(NL80211_CHAN_WIDTH_20_NOHT) |
+				BIT(NL80211_CHAN_WIDTH_20) |
+				BIT(NL80211_CHAN_WIDTH_40) |
+				BIT(NL80211_CHAN_WIDTH_80),
 };
 
 static const struct
-ieee80211_iface_combination mwifiex_drcs_iface_comb_ap_sta = {
+ieee80211_iface_combination mwifiex_iface_comb_ap_sta_drcs = {
 	.limits = mwifiex_ap_sta_limits,
 	.num_different_channels = 2,
 	.n_limits = ARRAY_SIZE(mwifiex_ap_sta_limits),
@@ -3755,7 +3772,9 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 		wiphy->bands[IEEE80211_BAND_5GHZ] = NULL;
 
 	if (adapter->drcs_enabled && ISSUPP_DRCS_ENABLED(adapter->fw_cap_info))
-		wiphy->iface_combinations = &mwifiex_drcs_iface_comb_ap_sta;
+		wiphy->iface_combinations = &mwifiex_iface_comb_ap_sta_drcs;
+	else if (adapter->is_hw_11ac_capable)
+		wiphy->iface_combinations = &mwifiex_iface_comb_ap_sta_vht;
 	else
 		wiphy->iface_combinations = &mwifiex_iface_comb_ap_sta;
 	wiphy->n_iface_combinations = 1;
-- 
1.8.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
