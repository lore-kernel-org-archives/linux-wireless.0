Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:38956 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752834Ab2FMReY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 13:34:24 -0400
Received: by ghbg16 with SMTP id g16so810945ghb.17
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jun 2012 10:34:23 -0700 (PDT)
From: Yoni Divinsky <yoni.divinsky@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: coelho@ti.com, Eliad Peller <eliad@wizery.com>,
	Yoni Divinsky <yoni.divinsky@ti.com>
Subject: [PATCH] wlcore: declare interface combinations
Date: Wed, 13 Jun 2012 20:29:16 +0300
Message-Id: <1339608556-23346-1-git-send-email-yoni.divinsky@ti.com> (sfid-20120613_193426_943521_045C6DEA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Advertise to the stack that the wlcore driver
supports multiple interfaces for a single device.
This is required in order to be able to run
multirole with mac80211.

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Yoni Divinsky <yoni.divinsky@ti.com>
---
 drivers/net/wireless/ti/wlcore/main.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 5886da5..cac5f46 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5019,6 +5019,29 @@ static void wl1271_unregister_hw(struct wl1271 *wl)
 
 }
 
+static const struct ieee80211_iface_limit wlcore_iface_limits[] = {
+	{
+		.max = 2,
+		.types = BIT(NL80211_IFTYPE_STATION),
+	},
+	{
+		.max = 1,
+		.types = BIT(NL80211_IFTYPE_AP) |
+			 BIT(NL80211_IFTYPE_P2P_GO) |
+			 BIT(NL80211_IFTYPE_P2P_CLIENT),
+	},
+};
+
+static const struct ieee80211_iface_combination
+wlcore_iface_combinations[] = {
+	{
+	  .num_different_channels = 1,
+	  .max_interfaces = 2,
+	  .limits = wlcore_iface_limits,
+	  .n_limits = ARRAY_SIZE(wlcore_iface_limits),
+	},
+};
+
 static int wl1271_init_ieee80211(struct wl1271 *wl)
 {
 	static const u32 cipher_suites[] = {
@@ -5113,6 +5136,11 @@ static int wl1271_init_ieee80211(struct wl1271 *wl)
 		NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS2 |
 		NL80211_PROBE_RESP_OFFLOAD_SUPPORT_P2P;
 
+	/* allowed interface combinations */
+	wl->hw->wiphy->iface_combinations = wlcore_iface_combinations;
+	wl->hw->wiphy->n_iface_combinations =
+		ARRAY_SIZE(wlcore_iface_combinations);
+
 	SET_IEEE80211_DEV(wl->hw, wl->dev);
 
 	wl->hw->sta_data_size = sizeof(struct wl1271_station);
-- 
1.7.0.4

