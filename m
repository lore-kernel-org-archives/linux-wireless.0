Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:53039 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754085Ab2JRGfh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Oct 2012 02:35:37 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Sam Leffler <sleffler@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Bing Zhao <bzhao@marvell.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v6 4/6] wireless: use OR operation to set wiphy features
Date: Wed, 17 Oct 2012 23:34:29 -0700
Message-Id: <1350542071-26498-5-git-send-email-bzhao@marvell.com> (sfid-20121018_083541_052549_8011FC84)
In-Reply-To: <1350542071-26498-1-git-send-email-bzhao@marvell.com>
References: <1350542071-26498-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The next patch will introduce a flag that is set
by default in cfg80211 so drivers and mac80211
need to use |= to set features they have so that
they don't clear the already-set feature.

We could set the flag in wiphy_register() instead
of wiphy_new() to avoid this patch, but then the
drivers couldn't *unset* flags they don't want to
use even though the implementation is generic.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    2 +-
 drivers/net/wireless/mwifiex/cfg80211.c    |    4 ++--
 net/mac80211/main.c                        |    6 +++---
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index ad252d0..2770899 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -3651,7 +3651,7 @@ int ath6kl_cfg80211_init(struct ath6kl *ar)
 
 	if (test_bit(ATH6KL_FW_CAPABILITY_INACTIVITY_TIMEOUT,
 		     ar->fw_capabilities))
-		ar->wiphy->features = NL80211_FEATURE_INACTIVITY_TIMER;
+		ar->wiphy->features |= NL80211_FEATURE_INACTIVITY_TIMER;
 
 	ar->wiphy->probe_resp_offload =
 		NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS |
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 0679458..38a5871 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -2250,8 +2250,8 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 	wiphy->available_antennas_tx = BIT(adapter->number_of_antenna) - 1;
 	wiphy->available_antennas_rx = BIT(adapter->number_of_antenna) - 1;
 
-	wiphy->features = NL80211_FEATURE_HT_IBSS |
-			  NL80211_FEATURE_INACTIVITY_TIMER;
+	wiphy->features |= NL80211_FEATURE_HT_IBSS |
+			   NL80211_FEATURE_INACTIVITY_TIMER;
 
 	/* Reserve space for mwifiex specific private data for BSS */
 	wiphy->bss_priv_size = sizeof(struct mwifiex_bss_priv);
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 620f427..931f14f 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -598,9 +598,9 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	if (ops->remain_on_channel)
 		wiphy->flags |= WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
 
-	wiphy->features = NL80211_FEATURE_SK_TX_STATUS |
-			  NL80211_FEATURE_SAE |
-			  NL80211_FEATURE_HT_IBSS;
+	wiphy->features |= NL80211_FEATURE_SK_TX_STATUS |
+			   NL80211_FEATURE_SAE |
+			   NL80211_FEATURE_HT_IBSS;
 
 	if (!ops->set_key)
 		wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
-- 
1.7.0.4

