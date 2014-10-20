Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:34680 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035AbaJTWtu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 18:49:50 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2 2/6] mac80211:  allow creating wiphy devices with suggested name.
Date: Mon, 20 Oct 2014 15:49:34 -0700
Message-Id: <1413845378-27837-2-git-send-email-greearb@candelatech.com> (sfid-20141021_004959_766394_CFB76B35)
In-Reply-To: <1413845378-27837-1-git-send-email-greearb@candelatech.com>
References: <1413845378-27837-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Support creating wiphy devices with an optional name.
This will be used by hwsim to have better automated control
over virtual radio creation/deletion.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 include/net/mac80211.h | 25 ++++++++++++++++++++++++-
 net/mac80211/main.c    |  9 +++++----
 2 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9bb2fc7..a206a56 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3069,11 +3069,34 @@ struct ieee80211_ops {
  *
  * @priv_data_len: length of private data
  * @ops: callbacks for this device
+ * @requested_name:  Requested name for this device.
  *
  * Return: A pointer to the new hardware device, or %NULL on error.
  */
+struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
+					   const struct ieee80211_ops *ops,
+					   const char *requested_name);
+
+/**
+ * ieee80211_alloc_hw -  Allocate a new hardware device
+ *
+ * This must be called once for each hardware device. The returned pointer
+ * must be used to refer to this device when calling other functions.
+ * mac80211 allocates a private data area for the driver pointed to by
+ * @priv in &struct ieee80211_hw, the size of this area is given as
+ * @priv_data_len.
+ *
+ * @priv_data_len: length of private data
+ * @ops: callbacks for this device
+ *
+ * Return: A pointer to the new hardware device, or %NULL on error.
+ */
+static inline
 struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
-					const struct ieee80211_ops *ops);
+					const struct ieee80211_ops *ops)
+{
+	return ieee80211_alloc_hw_nm(priv_data_len, ops, NULL);
+}
 
 /**
  * ieee80211_register_hw - Register hardware device
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 9e322dc..b189122 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -478,8 +478,9 @@ static const struct ieee80211_vht_cap mac80211_vht_capa_mod_mask = {
 	},
 };
 
-struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
-					const struct ieee80211_ops *ops)
+struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
+					   const struct ieee80211_ops *ops,
+					   const char *requested_name)
 {
 	struct ieee80211_local *local;
 	int priv_size, i;
@@ -519,7 +520,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	 */
 	priv_size = ALIGN(sizeof(*local), NETDEV_ALIGN) + priv_data_len;
 
-	wiphy = wiphy_new(&mac80211_config_ops, priv_size);
+	wiphy = wiphy_new_nm(&mac80211_config_ops, priv_size, requested_name);
 
 	if (!wiphy)
 		return NULL;
@@ -649,7 +650,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 
 	return &local->hw;
 }
-EXPORT_SYMBOL(ieee80211_alloc_hw);
+EXPORT_SYMBOL(ieee80211_alloc_hw_nm);
 
 static int ieee80211_init_cipher_suites(struct ieee80211_local *local)
 {
-- 
1.7.11.7

