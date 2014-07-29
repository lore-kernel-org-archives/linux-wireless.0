Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:38432 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbaG2Mmc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2014 08:42:32 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ido Yariv <ido@wizery.com>,
	Ido Yariv <idox.yariv@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: Fix accounting of the tailroom-needed counter
Date: Tue, 29 Jul 2014 15:38:53 +0300
Message-Id: <1406637533-19393-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140729_144235_683608_49378266)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Yariv <ido@wizery.com>

When hw acceleration is enabled, the GENERATE_IV or PUT_IV_SPACE flags
will only require headroom space. Consequently, the tailroom-needed
counter can safely be decremented.

Signed-off-by: Ido Yariv <idox.yariv@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/mac80211.h |  7 +++++--
 net/mac80211/key.c     | 12 +++---------
 2 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index a0d3907..c9d1a5b 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1227,7 +1227,8 @@ struct ieee80211_vif *wdev_to_ieee80211_vif(struct wireless_dev *wdev);
  *
  * @IEEE80211_KEY_FLAG_GENERATE_IV: This flag should be set by the
  *	driver to indicate that it requires IV generation for this
- *	particular key.
+ *	particular key. Setting this flag does not necessarily mean that SKBs
+ *	will have sufficient tailroom for ICV or MIC.
  * @IEEE80211_KEY_FLAG_GENERATE_MMIC: This flag should be set by
  *	the driver for a TKIP key if it requires Michael MIC
  *	generation in software.
@@ -1239,7 +1240,9 @@ struct ieee80211_vif *wdev_to_ieee80211_vif(struct wireless_dev *wdev);
  * @IEEE80211_KEY_FLAG_PUT_IV_SPACE: This flag should be set by the driver
  *	if space should be prepared for the IV, but the IV
  *	itself should not be generated. Do not set together with
- *	@IEEE80211_KEY_FLAG_GENERATE_IV on the same key.
+ *	@IEEE80211_KEY_FLAG_GENERATE_IV on the same key. Setting this flag does
+ *	not necessarily mean that SKBs will have sufficient tailroom for ICV or
+ *	MIC.
  * @IEEE80211_KEY_FLAG_RX_MGMT: This key will be used to decrypt received
  *	management frames. The flag can help drivers that have a hardware
  *	crypto implementation that doesn't deal with management frames
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 0102b30..f320a04 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -131,9 +131,7 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 	if (!ret) {
 		key->flags |= KEY_FLAG_UPLOADED_TO_HARDWARE;
 
-		if (!((key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC) ||
-		      (key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV) ||
-		      (key->conf.flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE)))
+		if (!(key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC))
 			sdata->crypto_tx_tailroom_needed_cnt--;
 
 		WARN_ON((key->conf.flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE) &&
@@ -181,9 +179,7 @@ static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
 	sta = key->sta;
 	sdata = key->sdata;
 
-	if (!((key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC) ||
-	      (key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV) ||
-	      (key->conf.flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE)))
+	if (!(key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC))
 		increment_tailroom_need_count(sdata);
 
 	ret = drv_set_key(key->local, DISABLE_KEY, sdata,
@@ -879,9 +875,7 @@ void ieee80211_remove_key(struct ieee80211_key_conf *keyconf)
 	if (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) {
 		key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
 
-		if (!((key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC) ||
-		      (key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV) ||
-		      (key->conf.flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE)))
+		if (!(key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC))
 			increment_tailroom_need_count(key->sdata);
 	}
 
-- 
1.9.1

