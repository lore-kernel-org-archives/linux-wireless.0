Return-path: <zefir.kurtisi@neratec.com>
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: jdiq123@googlemail.com,
	nbd@openwrt.org
Cc: linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [PATCH] minstrel_ht: fixed rate mode through debugfs
Date: Fri, 20 May 2011 20:29:17 +0200
Message-Id: <1305916157-15280-1-git-send-email-zefir.kurtisi@neratec.com>
List-ID: <linux-wireless.vger.kernel.org>

Found several threads about fixed rate mode in minstrel_ht for test
environments, but no patches for it.

This patch provides such a mode through debugfs.

---
support fixed rate processing per RC instance
  - write static index to debugfs:ieee80211/phyX/rc/fixed_rate_idx
  - write -1 to enable RC processing again
  - setting will be applied on next update

The current MCS index mapping (with MINSTREL_MAX_STREAMS = 3) is
given by the minstrel_mcs_groups table as:

mode       streams    indices
HT20/LGI
              1        00-07
              2        08-15
              3        16-23
HT20/SGI
              1        24-31
              2        32-39
              3        40-47
HT40/LGI
              1        48-55
              2        56-63
              3        64-71
HT40/SGI
              1        72-79
              2        80-87
              3        88-95

Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 net/mac80211/rc80211_minstrel.c    |    9 +++++++++
 net/mac80211/rc80211_minstrel.h    |   12 ++++++++++++
 net/mac80211/rc80211_minstrel_ht.c |    7 +++++++
 3 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index 8adac67..58a8955 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -532,12 +532,21 @@ minstrel_alloc(struct ieee80211_hw *hw, struct dentry *debugfsdir)
 	mp->hw = hw;
 	mp->update_interval = 100;
 
+#ifdef CONFIG_MAC80211_DEBUGFS
+	mp->fixed_rate_idx = (u32) -1;
+	mp->dbg_fixed_rate = debugfs_create_u32("fixed_rate_idx",
+			S_IRUGO | S_IWUGO, debugfsdir, &mp->fixed_rate_idx);
+#endif
+
 	return mp;
 }
 
 static void
 minstrel_free(void *priv)
 {
+#ifdef CONFIG_MAC80211_DEBUGFS
+	debugfs_remove(((struct minstrel_priv *)priv)->dbg_fixed_rate);
+#endif
 	kfree(priv);
 }
 
diff --git a/net/mac80211/rc80211_minstrel.h b/net/mac80211/rc80211_minstrel.h
index 0f5a833..5d278ec 100644
--- a/net/mac80211/rc80211_minstrel.h
+++ b/net/mac80211/rc80211_minstrel.h
@@ -78,6 +78,18 @@ struct minstrel_priv {
 	unsigned int update_interval;
 	unsigned int lookaround_rate;
 	unsigned int lookaround_rate_mrr;
+
+#ifdef CONFIG_MAC80211_DEBUGFS
+	/*
+	 * enable fixed rate processing per RC
+	 *   - write static index to debugfs:ieee80211/phyX/rc/fixed_rate_idx
+	 *   - write -1 to enable RC processing again
+	 *   - setting will be applied on next update
+	 */
+	u32 fixed_rate_idx;
+	struct dentry *dbg_fixed_rate;
+#endif
+
 };
 
 struct minstrel_debugfs_info {
diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 333b511..66a1eeb 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -609,6 +609,13 @@ minstrel_ht_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 
 	info->flags |= mi->tx_flags;
 	sample_idx = minstrel_get_sample_rate(mp, mi);
+
+#ifdef CONFIG_MAC80211_DEBUGFS
+	/* use fixed index if set */
+	if (mp->fixed_rate_idx != -1)
+		sample_idx = mp->fixed_rate_idx;
+#endif
+
 	if (sample_idx >= 0) {
 		sample = true;
 		minstrel_ht_set_rate(mp, mi, &ar[0], sample_idx,
-- 
1.7.1
