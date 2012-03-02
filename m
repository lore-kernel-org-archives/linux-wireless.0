Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36240 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205Ab2CBViS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 16:38:18 -0500
Received: by pbcun15 with SMTP id un15so540514pbc.19
        for <linux-wireless@vger.kernel.org>; Fri, 02 Mar 2012 13:38:18 -0800 (PST)
MIME-Version: 1.0
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>, devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCHv4 2/2] mac80211: Modify tsf via debugfs in mesh interfaces
Date: Fri,  2 Mar 2012 13:38:11 -0800
Message-Id: <1330724291-9482-2-git-send-email-javier@cozybit.com> (sfid-20120302_223822_381511_DF302B42)
In-Reply-To: <1330724291-9482-1-git-send-email-javier@cozybit.com>
References: <1330724291-9482-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 drivers/net/wireless/mac80211_hwsim.c |   18 ++++++++++++++++++
 net/mac80211/debugfs_netdev.c         |    7 ++++++-
 2 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index a8321ff..6cb46b3 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -379,6 +379,22 @@ static __le64 __mac80211_hwsim_get_tsf(struct mac80211_hwsim_data *data)
 	return cpu_to_le64(now + data->tsf_offset);
 }
 
+static u64 mac80211_hwsim_get_tsf(struct ieee80211_hw *hw,
+		struct ieee80211_vif *vif)
+{
+	struct mac80211_hwsim_data *data = hw->priv;
+	return le64_to_cpu(__mac80211_hwsim_get_tsf(data));
+}
+
+static void mac80211_hwsim_set_tsf(struct ieee80211_hw *hw,
+		struct ieee80211_vif *vif, u64 tsf)
+{
+	struct mac80211_hwsim_data *data = hw->priv;
+	struct timeval tv = ktime_to_timeval(ktime_get_real());
+	u64 now = tv.tv_sec * USEC_PER_SEC + tv.tv_usec;
+	data->tsf_offset = tsf - now;
+}
+
 static void mac80211_hwsim_monitor_rx(struct ieee80211_hw *hw,
 				      struct sk_buff *tx_skb)
 {
@@ -1232,6 +1248,8 @@ static struct ieee80211_ops mac80211_hwsim_ops =
 	.sw_scan_start = mac80211_hwsim_sw_scan,
 	.sw_scan_complete = mac80211_hwsim_sw_scan_complete,
 	.flush = mac80211_hwsim_flush,
+	.get_tsf = mac80211_hwsim_get_tsf,
+	.set_tsf = mac80211_hwsim_set_tsf,
 };
 
 
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 510ed1d..416b906 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -537,11 +537,15 @@ static void add_monitor_files(struct ieee80211_sub_if_data *sdata)
 
 #ifdef CONFIG_MAC80211_MESH
 
+static void add_mesh_files(struct ieee80211_sub_if_data *sdata)
+{
+	DEBUGFS_ADD_MODE(tsf, 0600);
+}
+
 static void add_mesh_stats(struct ieee80211_sub_if_data *sdata)
 {
 	struct dentry *dir = debugfs_create_dir("mesh_stats",
 						sdata->debugfs.dir);
-
 #define MESHSTATS_ADD(name)\
 	debugfs_create_file(#name, 0400, dir, sdata, &name##_ops);
 
@@ -593,6 +597,7 @@ static void add_files(struct ieee80211_sub_if_data *sdata)
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_MESH_POINT:
 #ifdef CONFIG_MAC80211_MESH
+		add_mesh_files(sdata);
 		add_mesh_stats(sdata);
 		add_mesh_config(sdata);
 #endif
-- 
1.7.6

