Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:38810 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722AbaJQUMN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Oct 2014 16:12:13 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Ben Greear <greearb@candelatech.com>
Subject: [RFC] mac80211-hwsim:  support creating radios with specific name.
Date: Fri, 17 Oct 2014 13:12:01 -0700
Message-Id: <1413576721-22258-1-git-send-email-greearb@candelatech.com> (sfid-20141017_221217_956262_76A6176F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Otherwise, it can be very difficult to know which is which
if you are trying to do detailed testing.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

I imagine this patch at least need to be split up, and it has not been
tested.  But, I wanted to know if the basic approach is acceptable
before I spend more time cleaning it up.

 drivers/net/wireless/mac80211_hwsim.c | 12 ++++++----
 include/net/cfg80211.h                | 22 +++++++++++++++++-
 include/net/mac80211.h                | 25 +++++++++++++++++++-
 net/mac80211/main.c                   |  9 +++----
 net/wireless/core.c                   | 44 ++++++++++++++++++++++++++++++++---
 5 files changed, 99 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index ee21d2f..d3b293b 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2018,7 +2018,7 @@ static struct ieee80211_ops mac80211_hwsim_mchan_ops;
 static int mac80211_hwsim_create_radio(int channels, const char *reg_alpha2,
 				       const struct ieee80211_regdomain *regd,
 				       bool reg_strict, bool p2p_device,
-				       bool use_chanctx)
+				       bool use_chanctx, char *hwname)
 {
 	int err;
 	u8 addr[ETH_ALEN];
@@ -2037,7 +2037,7 @@ static int mac80211_hwsim_create_radio(int channels, const char *reg_alpha2,
 
 	if (use_chanctx)
 		ops = &mac80211_hwsim_mchan_ops;
-	hw = ieee80211_alloc_hw(sizeof(*data), ops);
+	hw = ieee80211_alloc_hw_nm(sizeof(*data), ops, hwname);
 	if (!hw) {
 		printk(KERN_DEBUG "mac80211_hwsim: ieee80211_alloc_hw failed\n");
 		err = -ENOMEM;
@@ -2508,10 +2508,14 @@ static int hwsim_create_radio_nl(struct sk_buff *msg, struct genl_info *info)
 	bool reg_strict = info->attrs[HWSIM_ATTR_REG_STRICT_REG];
 	bool p2p_device = info->attrs[HWSIM_ATTR_SUPPORT_P2P_DEVICE];
 	bool use_chanctx;
+	char *hwname = NULL;
 
 	if (info->attrs[HWSIM_ATTR_CHANNELS])
 		chans = nla_get_u32(info->attrs[HWSIM_ATTR_CHANNELS]);
 
+	if (info->attrs[HWSIM_ATTR_RADIO_NAME])
+		hwname = nla_data(info->attrs[HWSIM_ATTR_RADIO_NAME]);
+
 	if (info->attrs[HWSIM_ATTR_USE_CHANCTX])
 		use_chanctx = true;
 	else
@@ -2529,7 +2533,7 @@ static int hwsim_create_radio_nl(struct sk_buff *msg, struct genl_info *info)
 	}
 
 	return mac80211_hwsim_create_radio(chans, alpha2, regd, reg_strict,
-					   p2p_device, use_chanctx);
+					   p2p_device, use_chanctx, hwname);
 }
 
 static int hwsim_destroy_radio_nl(struct sk_buff *msg, struct genl_info *info)
@@ -2761,7 +2765,7 @@ static int __init init_mac80211_hwsim(void)
 		err = mac80211_hwsim_create_radio(channels, reg_alpha2,
 						  regd, reg_strict,
 						  support_p2p_device,
-						  channels > 1);
+						  channels > 1, NULL);
 		if (err < 0)
 			goto out_free_radios;
 	}
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index e1641e6..f32c88f 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3173,11 +3173,31 @@ static inline const char *wiphy_name(const struct wiphy *wiphy)
  *
  * Create a new wiphy and associate the given operations with it.
  * @sizeof_priv bytes are allocated for private use.
+ * @requested_name Request a particular name.
  *
  * Return: A pointer to the new wiphy. This pointer must be
  * assigned to each netdev's ieee80211_ptr for proper operation.
  */
-struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv);
+struct wiphy *wiphy_new_nm(const struct cfg80211_ops *ops, int sizeof_priv,
+			   const char *requested_name);
+
+/**
+ * wiphy_new - create a new wiphy for use with cfg80211
+ *
+ * @ops: The configuration operations for this device
+ * @sizeof_priv: The size of the private area to allocate
+ *
+ * Create a new wiphy and associate the given operations with it.
+ * @sizeof_priv bytes are allocated for private use.
+ *
+ * Return: A pointer to the new wiphy. This pointer must be
+ * assigned to each netdev's ieee80211_ptr for proper operation.
+ */
+static inline struct wiphy *wiphy_new(const struct cfg80211_ops *ops,
+				      int sizeof_priv)
+{
+	return wiphy_new_nm(ops, sizeof_priv, NULL);
+}
 
 /**
  * wiphy_register - register a wiphy with cfg80211
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 0ad1f47..d687d6c 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3052,11 +3052,34 @@ struct ieee80211_ops {
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
index 0de7c93..5ebb3ab 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -483,8 +483,9 @@ static const u8 extended_capabilities[] = {
 	WLAN_EXT_CAPA8_OPMODE_NOTIF,
 };
 
-struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
-					const struct ieee80211_ops *ops)
+struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
+					   const struct ieee80211_ops *ops,
+					   const char *requested_hwname)
 {
 	struct ieee80211_local *local;
 	int priv_size, i;
@@ -524,7 +525,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	 */
 	priv_size = ALIGN(sizeof(*local), NETDEV_ALIGN) + priv_data_len;
 
-	wiphy = wiphy_new(&mac80211_config_ops, priv_size);
+	wiphy = wiphy_new_nm(&mac80211_config_ops, priv_size, requested_hwname);
 
 	if (!wiphy)
 		return NULL;
@@ -651,7 +652,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 
 	return &local->hw;
 }
-EXPORT_SYMBOL(ieee80211_alloc_hw);
+EXPORT_SYMBOL(ieee80211_alloc_hw_nm);
 
 static int ieee80211_init_cipher_suites(struct ieee80211_local *local)
 {
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 4d7e17c..7773675 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -318,7 +318,8 @@ static void cfg80211_destroy_iface_wk(struct work_struct *work)
 
 /* exported functions */
 
-struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
+struct wiphy *wiphy_new_nm(const struct cfg80211_ops *ops, int sizeof_priv,
+			   const char* requested_name)
 {
 	static atomic_t wiphy_counter = ATOMIC_INIT(0);
 
@@ -345,6 +346,7 @@ struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
 	rdev->wiphy_idx = atomic_inc_return(&wiphy_counter);
 
 	if (unlikely(rdev->wiphy_idx < 0)) {
+		/* TOOD:  Fix this some day. */
 		/* ugh, wrapped! */
 		atomic_dec(&wiphy_counter);
 		kfree(rdev);
@@ -355,7 +357,43 @@ struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
 	rdev->wiphy_idx--;
 
 	/* give it a proper name */
-	dev_set_name(&rdev->wiphy.dev, PHY_NAME "%d", rdev->wiphy_idx);
+	if (requested_name && requested_name[0]) {
+		struct cfg80211_registered_device *rdev2;
+		int wiphy_idx, taken = -1, result, digits;
+
+		ASSERT_RTNL();
+
+		/* Code below is from cfg80211_dev_rename */
+		/* prohibit calling the thing phy%d when %d is not its number */
+		sscanf(requested_name, PHY_NAME "%d%n", &wiphy_idx, &taken);
+		if (taken == strlen(requested_name) &&
+		    wiphy_idx != rdev->wiphy_idx) {
+			/* count number of places needed to print wiphy_idx */
+			digits = 1;
+			while (wiphy_idx /= 10)
+				digits++;
+			/*
+			 * deny name if it is phy<idx> where <idx> is printed
+			 * without leading zeroes. taken == strlen(newname) here
+			 */
+			if (taken == strlen(PHY_NAME) + digits)
+				goto use_default_name;
+		}
+
+		/* Ensure another device does not already have this name. */
+		list_for_each_entry(rdev2, &cfg80211_rdev_list, list)
+			if (strcmp(requested_name, dev_name(&rdev2->wiphy.dev))
+			    == 0)
+				goto use_default_name;
+
+		result = dev_set_name(&rdev->wiphy.dev, requested_name);
+		if (result)
+			goto use_default_name;
+	}
+	else {
+use_default_name:
+		dev_set_name(&rdev->wiphy.dev, PHY_NAME "%d", rdev->wiphy_idx);
+	}
 
 	INIT_LIST_HEAD(&rdev->wdev_list);
 	INIT_LIST_HEAD(&rdev->beacon_registrations);
@@ -415,7 +453,7 @@ struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
 
 	return &rdev->wiphy;
 }
-EXPORT_SYMBOL(wiphy_new);
+EXPORT_SYMBOL(wiphy_new_nm);
 
 static int wiphy_verify_combinations(struct wiphy *wiphy)
 {
-- 
1.7.11.7

