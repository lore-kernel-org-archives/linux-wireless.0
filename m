Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from toronto053.server4you.de ([62.75.220.53]:52248 "EHLO
	toronto053.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbZERRra (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2009 13:47:30 -0400
Date: Mon, 18 May 2009 19:49:25 +0200
From: Daniel Wagner <wagi@monom.org>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@gmail.com
Subject: [PATCH v3] mac80211_hwsim: Group radios
Message-ID: <20090518174925.GB3886@newton.monom.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Currently all radios receive all traffic on the simulated air
if they are tuned to the same channel. This patch introduces
the concept of grouping, which allows to assign a radio to
certain group. Only radios in the same group can 'see' each other.

Each bit in /debug/ieee80211/phy*/hwsim/group
represents one group. By default all radios belong to the same group "1",
e.g. bit 1 is set. Additionally a radio can belong to several groups.

Signed-off-by: Daniel Wagner <wagi@monom.org>
---

v3: Add a comment about the new variable in the mac80211_hwsim_data struct.

v2: Explain the patch a bit better in the commit message.

 drivers/net/wireless/mac80211_hwsim.c |   35 ++++++++++++++++++++++++++++++++-
 1 files changed, 34 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 61a4ad7..574b8bb 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -291,6 +291,14 @@ struct mac80211_hwsim_data {
 	bool ps_poll_pending;
 	struct dentry *debugfs;
 	struct dentry *debugfs_ps;
+
+	/*
+	 * Only radios in the same group can communicate together (the
+	 * channel has to match too). Each bit represents a group. A
+	 * radio can be in more then one group.
+	 */
+	u64 group;
+	struct dentry *debugfs_group;
 };
 
 
@@ -412,7 +420,8 @@ static bool mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
 
 		if (!data2->started || !data2->radio_enabled ||
 		    !hwsim_ps_rx_ok(data2, skb) ||
-		    data->channel->center_freq != data2->channel->center_freq)
+		    data->channel->center_freq != data2->channel->center_freq ||
+		    !(data->group & data2->group))
 			continue;
 
 		nskb = skb_copy(skb, GFP_ATOMIC);
@@ -720,6 +729,7 @@ static void mac80211_hwsim_free(void)
 	spin_unlock_bh(&hwsim_radio_lock);
 
 	list_for_each_entry(data, &tmplist, list) {
+		debugfs_remove(data->debugfs_group);
 		debugfs_remove(data->debugfs_ps);
 		debugfs_remove(data->debugfs);
 		ieee80211_unregister_hw(data->hw);
@@ -872,6 +882,24 @@ DEFINE_SIMPLE_ATTRIBUTE(hwsim_fops_ps, hwsim_fops_ps_read, hwsim_fops_ps_write,
 			"%llu\n");
 
 
+static int hwsim_fops_group_read(void *dat, u64 *val)
+{
+	struct mac80211_hwsim_data *data = dat;
+	*val = data->group;
+	return 0;
+}
+
+static int hwsim_fops_group_write(void *dat, u64 val)
+{
+	struct mac80211_hwsim_data *data = dat;
+	data->group = val;
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(hwsim_fops_group,
+			hwsim_fops_group_read, hwsim_fops_group_write,
+			"%llx\n");
+
 static int __init init_mac80211_hwsim(void)
 {
 	int i, err = 0;
@@ -976,6 +1004,8 @@ static int __init init_mac80211_hwsim(void)
 
 			hw->wiphy->bands[band] = sband;
 		}
+		/* By default all radios are belonging to the first group */
+		data->group = 1;
 
 		/* Work to be done prior to ieee80211_register_hw() */
 		switch (regtest) {
@@ -1100,6 +1130,9 @@ static int __init init_mac80211_hwsim(void)
 		data->debugfs_ps = debugfs_create_file("ps", 0666,
 						       data->debugfs, data,
 						       &hwsim_fops_ps);
+		data->debugfs_group = debugfs_create_file("group", 0666,
+							data->debugfs, data,
+							&hwsim_fops_group);
 
 		setup_timer(&data->beacon_timer, mac80211_hwsim_beacon,
 			    (unsigned long) hw);
-- 
1.6.2.4

