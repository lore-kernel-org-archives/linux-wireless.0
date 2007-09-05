Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42808 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932144AbXIFNqB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2007 09:46:01 -0400
Message-Id: <20070905234630.731410000@sipsolutions.net>
References: <20070905234209.108005000@sipsolutions.net>
Date: Thu, 06 Sep 2007 01:42:28 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 19/21] mac80211: remove crypto algorithm typedef
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The typedef is not required, we can just use "enum ieee80211_key_alg"
instead of "ieee80211_key_alg"

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 drivers/net/wireless/b43/main.c |    6 +++---
 drivers/net/wireless/iwl-base.c |    2 +-
 drivers/net/wireless/iwlwifi.h  |    2 +-
 include/net/mac80211.h          |   12 ++++++------
 net/mac80211/ieee80211_key.h    |    2 +-
 net/mac80211/key.c              |    2 +-
 6 files changed, 13 insertions(+), 13 deletions(-)

--- wireless-dev.orig/include/net/mac80211.h	2007-09-06 01:35:21.044453431 +0200
+++ wireless-dev/include/net/mac80211.h	2007-09-06 01:35:28.094453431 +0200
@@ -551,12 +551,12 @@ struct ieee80211_if_conf {
  * @ALG_TKIP: TKIP
  * @ALG_CCMP: CCMP (AES)
  */
-typedef enum ieee80211_key_alg {
+enum ieee80211_key_alg {
 	ALG_NONE,
 	ALG_WEP,
 	ALG_TKIP,
 	ALG_CCMP,
-} ieee80211_key_alg;
+};
 
 
 /**
@@ -596,7 +596,7 @@ enum ieee80211_key_flags {
  * @key: key material
  */
 struct ieee80211_key_conf {
-	ieee80211_key_alg alg;
+	enum ieee80211_key_alg alg;
 	u8 hw_key_idx;
 	u8 flags;
 	s8 keyidx;
@@ -616,9 +616,9 @@ struct ieee80211_key_conf {
  * @SET_KEY: a key is set
  * @DISABLE_KEY: a key must be disabled
  */
-typedef enum set_key_cmd {
+enum set_key_cmd {
 	SET_KEY, DISABLE_KEY,
-} set_key_cmd;
+};
 
 
 /**
@@ -1035,7 +1035,7 @@ struct ieee80211_ops {
 				 unsigned int changed_flags,
 				 unsigned int *total_flags);
 	int (*set_tim)(struct ieee80211_hw *hw, int aid, int set);
-	int (*set_key)(struct ieee80211_hw *hw, set_key_cmd cmd,
+	int (*set_key)(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		       const u8 *local_address, const u8 *address,
 		       struct ieee80211_key_conf *key);
 	int (*set_ieee8021x)(struct ieee80211_hw *hw, int use_ieee8021x);
--- wireless-dev.orig/net/mac80211/ieee80211_key.h	2007-09-06 01:34:53.224453431 +0200
+++ wireless-dev/net/mac80211/ieee80211_key.h	2007-09-06 01:35:28.094453431 +0200
@@ -114,7 +114,7 @@ struct ieee80211_key {
 
 struct ieee80211_key *ieee80211_key_alloc(struct ieee80211_sub_if_data *sdata,
 					  struct sta_info *sta,
-					  ieee80211_key_alg alg,
+					  enum ieee80211_key_alg alg,
 					  int idx,
 					  size_t key_len,
 					  const u8 *key_data);
--- wireless-dev.orig/net/mac80211/key.c	2007-09-06 01:34:53.274453431 +0200
+++ wireless-dev/net/mac80211/key.c	2007-09-06 01:35:28.124453431 +0200
@@ -111,7 +111,7 @@ static void ieee80211_key_disable_hw_acc
 
 struct ieee80211_key *ieee80211_key_alloc(struct ieee80211_sub_if_data *sdata,
 					  struct sta_info *sta,
-					  ieee80211_key_alg alg,
+					  enum ieee80211_key_alg alg,
 					  int idx,
 					  size_t key_len,
 					  const u8 *key_data)
--- wireless-dev.orig/drivers/net/wireless/iwlwifi.h	2007-09-06 01:34:53.304453431 +0200
+++ wireless-dev/drivers/net/wireless/iwlwifi.h	2007-09-06 01:35:28.124453431 +0200
@@ -417,7 +417,7 @@ struct iwl_tid_data {
 };
 
 struct iwl_hw_key {
-	ieee80211_key_alg alg;
+	enum ieee80211_key_alg alg;
 	int keylen;
 	u8 key[32];
 };
--- wireless-dev.orig/drivers/net/wireless/b43/main.c	2007-09-06 01:35:12.374453431 +0200
+++ wireless-dev/drivers/net/wireless/b43/main.c	2007-09-06 01:35:28.124453431 +0200
@@ -2850,9 +2850,9 @@ static int b43_dev_config(struct ieee802
 	return err;
 }
 
-static int b43_dev_set_key(struct ieee80211_hw *hw,
-			   set_key_cmd cmd, const u8 *local_addr,
-			   const u8 *addr, struct ieee80211_key_conf *key)
+static int b43_dev_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
+			   const u8 *local_addr, const u8 *addr,
+			   struct ieee80211_key_conf *key)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct b43_wldev *dev = wl->current_dev;
--- wireless-dev.orig/drivers/net/wireless/iwl-base.c	2007-09-06 01:35:12.394453431 +0200
+++ wireless-dev/drivers/net/wireless/iwl-base.c	2007-09-06 01:35:28.144453431 +0200
@@ -7866,7 +7866,7 @@ static int iwl_mac_hw_scan(struct ieee80
 	return rc;
 }
 
-static int iwl_mac_set_key(struct ieee80211_hw *hw, set_key_cmd cmd,
+static int iwl_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			   const u8 *local_addr, const u8 *addr,
 			   struct ieee80211_key_conf *key)
 {

-- 

