Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:58114 "HELO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756670Ab2EIBc7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 21:32:59 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 04/18] mwifiex: multi-interface support for mwifiex
Date: Tue,  8 May 2012 18:30:16 -0700
Message-Id: <1336527030-2045-5-git-send-email-bzhao@marvell.com> (sfid-20120509_033304_362445_F517341D)
In-Reply-To: <1336527030-2045-1-git-send-email-bzhao@marvell.com>
References: <1336527030-2045-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

mwifiex supports STA and AP interfaces which use same phy.
Indicate this to cfg80211.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 38d5191..4532393 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -20,6 +20,23 @@
 #include "cfg80211.h"
 #include "main.h"
 
+static const struct ieee80211_iface_limit mwifiex_ap_sta_limits[] = {
+	{
+		.max = 1, .types = BIT(NL80211_IFTYPE_STATION),
+	},
+	{
+		.max = 1, .types = BIT(NL80211_IFTYPE_AP),
+	},
+};
+
+static const struct ieee80211_iface_combination mwifiex_iface_comb_ap_sta = {
+	.limits = mwifiex_ap_sta_limits,
+	.num_different_channels = 1,
+	.n_limits = ARRAY_SIZE(mwifiex_ap_sta_limits),
+	.max_interfaces = MWIFIEX_MAX_BSS_NUM,
+	.beacon_int_infra_match = true,
+};
+
 /*
  * This function maps the nl802.11 channel type into driver channel type.
  *
@@ -1505,6 +1522,9 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 	else
 		wiphy->bands[IEEE80211_BAND_5GHZ] = NULL;
 
+	wiphy->iface_combinations = &mwifiex_iface_comb_ap_sta;
+	wiphy->n_iface_combinations = 1;
+
 	/* Initialize cipher suits */
 	wiphy->cipher_suites = mwifiex_cipher_suites;
 	wiphy->n_cipher_suites = ARRAY_SIZE(mwifiex_cipher_suites);
-- 
1.7.0.2

