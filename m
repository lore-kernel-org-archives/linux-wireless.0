Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from toronto053.server4you.de ([62.75.220.53]:38381 "EHLO
	toronto053.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbZENVS4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2009 17:18:56 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by toronto053.server4you.de (Postfix) with ESMTP id CCFBD1F8020
	for <linux-wireless@vger.kernel.org>; Thu, 14 May 2009 23:21:32 +0200 (CEST)
Received: from toronto053.server4you.de ([127.0.0.1])
	by localhost (toronto053.server4you.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WmOImrUsrMvb for <linux-wireless@vger.kernel.org>;
	Thu, 14 May 2009 23:21:30 +0200 (CEST)
Received: from localhost (e181117089.adsl.alicedsl.de [85.181.117.89])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by toronto053.server4you.de (Postfix) with ESMTP id 32E751F8017
	for <linux-wireless@vger.kernel.org>; Thu, 14 May 2009 22:49:27 +0200 (CEST)
Date: Thu, 14 May 2009 22:48:38 +0200
From: Daniel Wagner <wagi@monom.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211_hwsim: Group radios
Message-ID: <20090514204838.GB3225@newton.monom.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Each bit in /debug/ieee80211/phy*/hwsim/group represents one
group. By default all radios belong to the same group "1".
A radio can belong to several groups.

Signed-off-by: Daniel Wagner <wagi@monom.org>
---
 drivers/net/wireless/mac80211_hwsim.c |   30 +++++++++++++++++++++++++++++-
 1 files changed, 29 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 61a4ad7..58fd29e 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -291,6 +291,9 @@ struct mac80211_hwsim_data {
 	bool ps_poll_pending;
 	struct dentry *debugfs;
 	struct dentry *debugfs_ps;
+
+	u64 group;
+	struct dentry *debugfs_group;
 };
 
 
@@ -412,7 +415,8 @@ static bool mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
 
 		if (!data2->started || !data2->radio_enabled ||
 		    !hwsim_ps_rx_ok(data2, skb) ||
-		    data->channel->center_freq != data2->channel->center_freq)
+		    data->channel->center_freq != data2->channel->center_freq ||
+		    !(data->group & data2->group))
 			continue;
 
 		nskb = skb_copy(skb, GFP_ATOMIC);
@@ -720,6 +724,7 @@ static void mac80211_hwsim_free(void)
 	spin_unlock_bh(&hwsim_radio_lock);
 
 	list_for_each_entry(data, &tmplist, list) {
+		debugfs_remove(data->debugfs_group);
 		debugfs_remove(data->debugfs_ps);
 		debugfs_remove(data->debugfs);
 		ieee80211_unregister_hw(data->hw);
@@ -872,6 +877,24 @@ DEFINE_SIMPLE_ATTRIBUTE(hwsim_fops_ps, hwsim_fops_ps_read, hwsim_fops_ps_write,
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
@@ -976,6 +999,8 @@ static int __init init_mac80211_hwsim(void)
 
 			hw->wiphy->bands[band] = sband;
 		}
+		/* By default all radios are belonging to the first group */
+		data->group = 1;
 
 		/* Work to be done prior to ieee80211_register_hw() */
 		switch (regtest) {
@@ -1100,6 +1125,9 @@ static int __init init_mac80211_hwsim(void)
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

