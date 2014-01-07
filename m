Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48626 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbaAGXQ6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jan 2014 18:16:58 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 11/12] mac80211_hwsim: register netlink even with multi-channel
Date: Wed,  8 Jan 2014 00:15:16 +0100
Message-Id: <1389136517-21216-12-git-send-email-johannes@sipsolutions.net> (sfid-20140108_001701_785830_A0912FCB)
In-Reply-To: <1389136517-21216-1-git-send-email-johannes@sipsolutions.net>
References: <1389136517-21216-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Reject wmediumd registrations when any devices have multi-channel
capability, but register the generic netlink family unconditionally
to make it possible to add new commands that shouldn't depend on
the number of (default) channels.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 68375f7..e623a9e 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2240,6 +2240,22 @@ out:
 static int hwsim_register_received_nl(struct sk_buff *skb_2,
 				      struct genl_info *info)
 {
+	struct mac80211_hwsim_data *data;
+	int chans = 1;
+
+	spin_lock_bh(&hwsim_radio_lock);
+	list_for_each_entry(data, &hwsim_radios, list)
+		chans = max(chans, data->channels);
+	spin_unlock_bh(&hwsim_radio_lock);
+
+	/* In the future we should revise the userspace API and allow it
+	 * to set a flag that it does support multi-channel, then we can
+	 * let this pass conditionally on the flag.
+	 * For current userspace, prohibit it since it won't work right.
+	 */
+	if (chans > 1)
+		return -EOPNOTSUPP;
+
 	if (wmediumd_portid)
 		return -EBUSY;
 
@@ -2297,10 +2313,6 @@ static int hwsim_init_netlink(void)
 {
 	int rc;
 
-	/* userspace test API hasn't been adjusted for multi-channel */
-	if (channels > 1)
-		return 0;
-
 	printk(KERN_INFO "mac80211_hwsim: initializing netlink\n");
 
 	rc = genl_register_family_with_ops(&hwsim_genl_family, hwsim_ops);
@@ -2320,10 +2332,6 @@ failure:
 
 static void hwsim_exit_netlink(void)
 {
-	/* userspace test API hasn't been adjusted for multi-channel */
-	if (channels > 1)
-		return;
-
 	/* unregister the notifier */
 	netlink_unregister_notifier(&hwsim_netlink_notifier);
 	/* unregister the family */
-- 
1.8.5.1

