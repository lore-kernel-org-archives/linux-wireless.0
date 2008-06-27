Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:10311 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758897AbYF0XuU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jun 2008 19:50:20 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/1] mac80211: don't accept WEP keys other than WEP40 and WEP104
Date: Sat, 28 Jun 2008 02:50:13 +0300
Message-Id: <1214610613-6990-1-git-send-email-tomas.winkler@intel.com> (sfid-20080628_015023_927794_6BF30BCD)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch makes mac80211 refuse a WEP key whose length is not WEP40 nor
WEP104.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 include/net/mac80211.h |    9 +++++++++
 net/mac80211/wext.c    |    7 +++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 02c79e6..6a6c4bc 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -557,6 +557,15 @@ enum ieee80211_key_alg {
 	ALG_CCMP,
 };
 
+/**
+ * enum ieee80211_key_len - key length
+ * @WEP40: WEP 5 byte long key
+ * @WEP104: WEP 13 byte long key
+ */
+enum ieee80211_key_len {
+	LEN_WEP40 = 5,
+	LEN_WEP104 = 13,
+};
 
 /**
  * enum ieee80211_key_flags - key flags
diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
index df0531c..1babb97 100644
--- a/net/mac80211/wext.c
+++ b/net/mac80211/wext.c
@@ -95,6 +95,13 @@ static int ieee80211_set_encryption(struct net_device *dev, u8 *sta_addr,
 			}
 		}
 
+		if (alg == ALG_WEP &&
+			key_len != LEN_WEP40 && key_len != LEN_WEP104) {
+			ieee80211_key_free(key);
+			err = -EINVAL;
+			goto out_unlock;
+		}
+
 		ieee80211_key_link(key, sdata, sta);
 
 		if (set_tx_key || (!sta && !sdata->default_key && key))
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

