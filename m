Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39829 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316Ab2CAXkP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 18:40:15 -0500
Received: by pbcup15 with SMTP id up15so1448539pbc.19
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2012 15:40:15 -0800 (PST)
MIME-Version: 1.0
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>, devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCHv2 2/3] mac80211: Modify tsf via debugfs in mesh interfaces
Date: Thu,  1 Mar 2012 15:40:06 -0800
Message-Id: <1330645207-13964-2-git-send-email-javier@cozybit.com> (sfid-20120302_004022_890321_40A16038)
In-Reply-To: <1330645207-13964-1-git-send-email-javier@cozybit.com>
References: <1330645207-13964-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 drivers/net/wireless/mac80211_hwsim.c |   16 ++++++++++++++++
 net/mac80211/debugfs_netdev.c         |    7 ++++++-
 2 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index f44b3f6..deed95f 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -375,6 +375,20 @@ static __le64 __mac80211_hwsim_get_tsf(struct mac80211_hwsim_data *data)
 			data->tsf_offset);
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
+	data->tsf_offset = tsf - jiffies_to_msecs(jiffies)*1000/1024;
+}
+
 static void mac80211_hwsim_monitor_rx(struct ieee80211_hw *hw,
 				      struct sk_buff *tx_skb)
 {
@@ -1228,6 +1242,8 @@ static struct ieee80211_ops mac80211_hwsim_ops =
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

