Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from toronto053.server4you.de ([62.75.220.53]:51151 "EHLO
	toronto053.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbZDVJT6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 05:19:58 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by toronto053.server4you.de (Postfix) with ESMTP id 337D052F343
	for <linux-wireless@vger.kernel.org>; Wed, 22 Apr 2009 11:22:02 +0200 (CEST)
Received: from toronto053.server4you.de ([127.0.0.1])
	by localhost (toronto053.server4you.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id K3PPcbz7EvCq for <linux-wireless@vger.kernel.org>;
	Wed, 22 Apr 2009 11:21:59 +0200 (CEST)
Date: Wed, 22 Apr 2009 11:21:59 +0200
From: Daniel Wagner <wagi@monom.org>
To: linux-wireless@vger.kernel.org
Subject: [RFC] Simulate medium behavior
Message-ID: <20090422092159.GA24586@toronto053.server4you.de> (sfid-20090422_113107_838388_2485F0AE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm still working improving the scan behavior of NM. Yes, I'm
terrible slow.  One thing which would help for this work is to
simulate the wireless medium.

Below is my humble try to get a knob for enabling/disabling 
tx/rx. The variable name 'medium' is not really good, though
I didn't come up with something better.

Writing a 0 to /debug/ieee80211/phy*/hwsim/medium enables rx/tx for
the specific phy. Writing anything but 0 disables rx/tx.  Not a very
good API. It could be made something more realistic like reception
quality is 80% associated some statistical dropping algorithm. Any
thoughts?

Is this the right direction I'm heading to?

thanks,
daniel

---
 drivers/net/wireless/mac80211_hwsim.c |   32 +++++++++++++++++++++++++++++++-
 1 files changed, 31 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index d4fdc8b..6373226 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -291,6 +291,9 @@ struct mac80211_hwsim_data {
 	bool ps_poll_pending;
 	struct dentry *debugfs;
 	struct dentry *debugfs_ps;
+
+	struct dentry *debugfs_medium;
+	unsigned int medium;
 };
 
 
@@ -399,6 +402,11 @@ static bool mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
 	rx_status.rate_idx = info->control.rates[0].idx;
 	/* TODO: simulate signal strength (and optional packet drop) */
 
+	if (data->medium != 0) {
+		/* drop packet, no ack received */
+		return false;
+	}
+
 	if (data->ps != PS_DISABLED)
 		hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_PM);
 
@@ -412,7 +420,8 @@ static bool mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
 
 		if (!data2->started || !data2->radio_enabled ||
 		    !hwsim_ps_rx_ok(data2, skb) ||
-		    data->channel->center_freq != data2->channel->center_freq)
+		    data->channel->center_freq != data2->channel->center_freq ||
+		    data2->medium != 0)
 			continue;
 
 		nskb = skb_copy(skb, GFP_ATOMIC);
@@ -725,6 +734,7 @@ static void mac80211_hwsim_free(void)
 	spin_unlock_bh(&hwsim_radio_lock);
 
 	list_for_each_entry(data, &tmplist, list) {
+		debugfs_remove(data->debugfs_medium);
 		debugfs_remove(data->debugfs_ps);
 		debugfs_remove(data->debugfs);
 		ieee80211_unregister_hw(data->hw);
@@ -876,6 +886,22 @@ static int hwsim_fops_ps_write(void *dat, u64 val)
 DEFINE_SIMPLE_ATTRIBUTE(hwsim_fops_ps, hwsim_fops_ps_read, hwsim_fops_ps_write,
 			"%llu\n");
 
+static int hwsim_fops_medium_read(void *dat, u64 *val)
+{
+	struct mac80211_hwsim_data *data = dat;
+	*val = data->medium;
+	return 0;
+}
+
+static int hwsim_fops_medium_write(void *dat, u64 val)
+{
+	struct mac80211_hwsim_data *data = dat;
+	data->medium = val;
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(hwsim_fops_medium, hwsim_fops_medium_read, hwsim_fops_medium_write,
+			"%llu\n");
 
 static int __init init_mac80211_hwsim(void)
 {
@@ -1106,6 +1132,10 @@ static int __init init_mac80211_hwsim(void)
 						       data->debugfs, data,
 						       &hwsim_fops_ps);
 
+		data->debugfs_medium = debugfs_create_file("medium", 0666,
+							   data->debugfs, data,
+							   &hwsim_fops_medium);
+
 		setup_timer(&data->beacon_timer, mac80211_hwsim_beacon,
 			    (unsigned long) hw);
 
-- 
1.6.0.2.GIT

