Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42228 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751969AbdJ2JvV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 29 Oct 2017 05:51:21 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Tova Mussai <tova.mussai@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun, 29 Oct 2017 11:51:11 +0200
Message-Id: <20171029095111.17078-6-luca@coelho.fi> (sfid-20171029_105207_062088_D894A467)
In-Reply-To: <20171029095111.17078-1-luca@coelho.fi>
References: <20171029095111.17078-1-luca@coelho.fi>
Subject: [PATCH 5/5] cfg80211: IBSS: Add support for static WEP in driver for IBSS
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tova Mussai <tova.mussai@intel.com>

Add support for drivers that implement static WEP internally for IBSS.
Add the WEP keys to the IBSS params struct, that will allow the driver
to use the keys in the join flow, and not only after the connection.

Signed-off-by: Tova Mussai <tova.mussai@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/net/cfg80211.h | 5 +++++
 net/wireless/ibss.c    | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 8b8118a7fadb..698cebf2de2a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2021,6 +2021,9 @@ struct cfg80211_disassoc_request {
  * @ht_capa:  HT Capabilities over-rides.  Values set in ht_capa_mask
  *	will be used in ht_capa.  Un-supported values will be ignored.
  * @ht_capa_mask:  The bits of ht_capa which are to be used.
+ * @wep_keys: static WEP keys, if not NULL points to an array of
+ * 	CFG80211_MAX_WEP_KEYS WEP keys
+ * @wep_tx_key: key index (0..3) of the default TX static WEP key
  */
 struct cfg80211_ibss_params {
 	const u8 *ssid;
@@ -2037,6 +2040,8 @@ struct cfg80211_ibss_params {
 	int mcast_rate[NUM_NL80211_BANDS];
 	struct ieee80211_ht_cap ht_capa;
 	struct ieee80211_ht_cap ht_capa_mask;
+	struct key_params *wep_keys;
+	int wep_tx_key;
 };
 
 /**
diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index 10bf040a0982..6a4ad21174d5 100644
--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -125,6 +125,11 @@ static int __cfg80211_join_ibss(struct cfg80211_registered_device *rdev,
 	wdev->ibss_fixed = params->channel_fixed;
 	wdev->ibss_dfs_possible = params->userspace_handles_dfs;
 	wdev->chandef = params->chandef;
+	if (connkeys) {
+		params->wep_keys = connkeys->params;
+		params->wep_tx_key = connkeys->def;
+	}
+
 #ifdef CONFIG_CFG80211_WEXT
 	wdev->wext.ibss.chandef = params->chandef;
 #endif
-- 
2.14.2
