Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48522 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755519AbbFQPQX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 11:16:23 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: add pointer for driver use to key
Date: Wed, 17 Jun 2015 17:16:19 +0200
Message-Id: <1434554179-4285-1-git-send-email-johannes@sipsolutions.net> (sfid-20150617_171627_539783_E450AE87)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Some drivers may need to store data per key, for example for PN
validation. Allow this by adding a pointer to the struct that
the driver can assign.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 8f61a230c482..484cc14fb947 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1492,8 +1492,10 @@ enum ieee80211_key_flags {
  * 	- Temporal Authenticator Rx MIC Key (64 bits)
  * @icv_len: The ICV length for this key type
  * @iv_len: The IV length for this key type
+ * @drv_priv: pointer for driver use
  */
 struct ieee80211_key_conf {
+	void *drv_priv;
 	atomic64_t tx_pn;
 	u32 cipher;
 	u8 icv_len;
-- 
2.1.4

