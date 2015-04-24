Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39436 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551AbbDXJIn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Apr 2015 05:08:43 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: make station hash table max_size configurable
Date: Fri, 24 Apr 2015 11:08:39 +0200
Message-Id: <1429866519-7371-1-git-send-email-johannes@sipsolutions.net> (sfid-20150424_110847_491257_4C44AFEE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Allow debug builds to configure the station hash table maximum
size in order to run with hash collisions in limited scenarios
such as hwsim testing. The default remains 0 which effectively
means no limit.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/Kconfig    | 10 ++++++++++
 net/mac80211/sta_info.c |  1 +
 2 files changed, 11 insertions(+)

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index 64a012a0c6e5..5f698d4ec53b 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -305,3 +305,13 @@ config MAC80211_DEBUG_COUNTERS
 	  and show them in debugfs.
 
 	  If unsure, say N.
+
+config MAC80211_STA_HASH_MAX_SIZE
+	int "Station hash table maximum size" if MAC80211_DEBUG_MENU
+	default 0
+	---help---
+	  Setting this option to a low value (e.g. 4) allows testing the
+	  hash table with collisions relatively deterministically (just
+	  connect more stations than the number selected here.)
+
+	  If unsure, leave the default of 0.
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 737730abba6d..aec15d746aea 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -70,6 +70,7 @@ static const struct rhashtable_params sta_rht_params = {
 	.key_offset = offsetof(struct sta_info, sta.addr),
 	.key_len = ETH_ALEN,
 	.hashfn = sta_addr_hash,
+	.max_size = CONFIG_MAC80211_STA_HASH_MAX_SIZE,
 };
 
 /* Caller must hold local->sta_mtx */
-- 
2.1.4

