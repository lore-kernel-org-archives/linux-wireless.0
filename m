Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44891 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757638Ab1GAWPz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jul 2011 18:15:55 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.76)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Qcm0A-0007Ms-MW
	for linux-wireless@vger.kernel.org; Sat, 02 Jul 2011 00:15:54 +0200
Message-Id: <20110701221533.639776801@sipsolutions.net> (sfid-20110702_001601_958278_1C4F9159)
Date: Sat, 02 Jul 2011 00:13:22 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 1/3] mac80211: allow driver to iterate keys
References: <20110701221321.478559320@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When in suspend/wowlan, devices might implement crypto
offload differently (more features), and might require
reprogramming keys for the WoWLAN (as it is the case
for Intel devices that use another uCode image). Thus
allow the driver to iterate all keys in this context.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h |   23 +++++++++++++++++++++++
 net/mac80211/key.c     |   33 +++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+)

--- a/include/net/mac80211.h	2011-07-02 00:08:12.000000000 +0200
+++ b/include/net/mac80211.h	2011-07-02 00:08:13.000000000 +0200
@@ -2850,6 +2850,29 @@ void ieee80211_sta_block_awake(struct ie
 			       struct ieee80211_sta *pubsta, bool block);
 
 /**
+ * ieee80211_iter_keys - iterate keys programmed into the device
+ * @hw: pointer obtained from ieee80211_alloc_hw()
+ * @vif: virtual interface to iterate, may be %NULL for all
+ * @iter: iterator function that will be called for each key
+ * @iter_data: custom data to pass to the iterator function
+ *
+ * This function can be used to iterate all the keys known to
+ * mac80211, even those that weren't previously programmed into
+ * the device. This is intended for use in WoWLAN if the device
+ * needs reprogramming of the keys during suspend. Note that due
+ * to locking reasons, it is also only safe to call this at few
+ * spots since it must hold the RTNL and be able to sleep.
+ */
+void ieee80211_iter_keys(struct ieee80211_hw *hw,
+			 struct ieee80211_vif *vif,
+			 void (*iter)(struct ieee80211_hw *hw,
+				      struct ieee80211_vif *vif,
+				      struct ieee80211_sta *sta,
+				      struct ieee80211_key_conf *key,
+				      void *data),
+			 void *iter_data);
+
+/**
  * ieee80211_ap_probereq_get - retrieve a Probe Request template
  * @hw: pointer obtained from ieee80211_alloc_hw().
  * @vif: &struct ieee80211_vif pointer from the add_interface callback.
--- a/net/mac80211/key.c	2011-07-02 00:07:58.000000000 +0200
+++ b/net/mac80211/key.c	2011-07-02 00:08:13.000000000 +0200
@@ -504,6 +504,39 @@ void ieee80211_enable_keys(struct ieee80
 	mutex_unlock(&sdata->local->key_mtx);
 }
 
+void ieee80211_iter_keys(struct ieee80211_hw *hw,
+			 struct ieee80211_vif *vif,
+			 void (*iter)(struct ieee80211_hw *hw,
+				      struct ieee80211_vif *vif,
+				      struct ieee80211_sta *sta,
+				      struct ieee80211_key_conf *key,
+				      void *data),
+			 void *iter_data)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_key *key;
+	struct ieee80211_sub_if_data *sdata;
+
+	ASSERT_RTNL();
+
+	mutex_lock(&local->key_mtx);
+	if (vif) {
+		sdata = vif_to_sdata(vif);
+		list_for_each_entry(key, &sdata->key_list, list)
+			iter(hw, &sdata->vif,
+			     key->sta ? &key->sta->sta : NULL,
+			     &key->conf, iter_data);
+	} else {
+		list_for_each_entry(sdata, &local->interfaces, list)
+			list_for_each_entry(key, &sdata->key_list, list)
+				iter(hw, &sdata->vif,
+				     key->sta ? &key->sta->sta : NULL,
+				     &key->conf, iter_data);
+	}
+	mutex_unlock(&local->key_mtx);
+}
+EXPORT_SYMBOL(ieee80211_iter_keys);
+
 void ieee80211_disable_keys(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_key *key;


