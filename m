Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from toronto053.server4you.de ([62.75.220.53]:45615 "EHLO
	toronto053.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbZENTFh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2009 15:05:37 -0400
Date: Thu, 14 May 2009 20:45:47 +0200
From: Daniel Wagner <wagi@monom.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] Simulate medium behavior
Message-ID: <20090514184547.GA3225@newton.monom.org>
References: <20090422092159.GA24586@toronto053.server4you.de> <1240393088.21756.3.camel@johannes.local> <20090422113556.GB24586@toronto053.server4you.de> <20090507184007.GA6684@newton.monom.org> <1241722972.7590.34.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1241722972.7590.34.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Thu, May 07, 2009 at 09:02:52PM +0200, Johannes Berg wrote:
> But I don't think your configfs support is optimal since you need to
> create those dirs for phy0 and put the name in etc. even when phy0
> already exists. I'm sorry to have wasted your time with the configfs
> suggestion, but I think with how hwsim _currently_ behaves, without
> configfs support for creating new radios etc., putting this into debugfs
> would be nicer, since debugfs already has a dir for this from
> cfg80211/mac80211...

Here we go (slow as usual :)

Subject: [PATCH] mac80211_hwsim: Group radios

Each bit in /debug/ieee80211/phy*/hwsim/group represents one
group. By default all radios belong to the same group "1".
A radio can belong to several groups.

Signed-off-by: Daniel Wagner <wagi@monom.org>
---
 drivers/net/wireless/mac80211_hwsim.c |   30 +++++++++++++++++++++++++++++-
 1 files changed, 29 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 61a4ad7..741f2e2 100644
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
+			"%llu\n");
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




