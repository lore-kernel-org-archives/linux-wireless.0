Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from toronto053.server4you.de ([62.75.220.53]:47613 "EHLO
	toronto053.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbZEQSRU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 May 2009 14:17:20 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by toronto053.server4you.de (Postfix) with ESMTP id 3C4F452E2B0
	for <linux-wireless@vger.kernel.org>; Sun, 17 May 2009 20:20:00 +0200 (CEST)
Received: from toronto053.server4you.de ([127.0.0.1])
	by localhost (toronto053.server4you.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lF4PpWnWxkIO for <linux-wireless@vger.kernel.org>;
	Sun, 17 May 2009 20:19:57 +0200 (CEST)
Received: from localhost (e181092162.adsl.alicedsl.de [85.181.92.162])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by toronto053.server4you.de (Postfix) with ESMTP id 6C56D52C0E7
	for <linux-wireless@vger.kernel.org>; Sun, 17 May 2009 20:19:57 +0200 (CEST)
Date: Sun, 17 May 2009 20:19:11 +0200
From: Daniel Wagner <wagi@monom.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v2] mac80211_hwsim: Group radios
Message-ID: <20090517181911.GA3455@newton.monom.org>
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
v2: Explain the patch a bit better in the commit message.

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

