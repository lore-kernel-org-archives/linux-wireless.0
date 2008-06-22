Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45800 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447AbYFVPqV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Jun 2008 11:46:21 -0400
Subject: [PATCH] mac80211: add pre- and post-scan hooks
From: Dan Williams <dcbw@redhat.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain
Date: Sun, 22 Jun 2008 11:43:21 -0400
Message-Id: <1214149401.8585.2.camel@localhost.localdomain> (sfid-20080622_174624_286344_54D543FD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mrv8k has commands that get called before and after the scan has been
done to save and restore hardware state.  Add optional callbacks to
mac80211 to enable low-level drivers to know when the stack is about to
start scanning, and when it's done.

Signed-off-by: Dan Williams <dcbw@redhat.com>

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 7ab4ff6..b84e8ac 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1139,6 +1139,10 @@ enum ieee80211_ampdu_mlme_action {
  * 	ieee80211_ampdu_mlme_action. Starting sequence number (@ssn)
  * 	is the first frame we expect to perform the action on. notice
  * 	that TX/RX_STOP can pass NULL for this parameter.
+ *
+ * @prescan: Notifies low level driver that a software scan is about to happen.
+ *
+ * @postscan: Notifies low level driver that software scanning is done.
  */
 struct ieee80211_ops {
 	int (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb);
@@ -1190,6 +1194,8 @@ struct ieee80211_ops {
 	int (*ampdu_action)(struct ieee80211_hw *hw,
 			    enum ieee80211_ampdu_mlme_action action,
 			    const u8 *addr, u16 tid, u16 *ssn);
+	int (*prescan)(struct ieee80211_hw *hw);
+	int (*postscan)(struct ieee80211_hw *hw);
 };
 
 /**
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 55659a7..4bee2a7 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3850,6 +3850,10 @@ void ieee80211_scan_completed(struct ieee80211_hw *hw)
 
 	netif_tx_unlock_bh(local->mdev);
 
+	/* call postscan outside locks because drivers may need to sleep */
+	if (local->ops->postscan)
+		local->ops->postscan(local_to_hw(local));
+
 	rcu_read_lock();
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
 
@@ -4045,6 +4048,10 @@ static int ieee80211_sta_start_scan(struct net_device *dev,
 	local->scan_band = IEEE80211_BAND_2GHZ;
 	local->scan_dev = dev;
 
+	/* call prescan outside locks because drivers may need to sleep */
+	if (local->ops->prescan)
+		local->ops->prescan(local_to_hw(local));
+
 	netif_tx_lock_bh(local->mdev);
 	local->filter_flags |= FIF_BCN_PRBRESP_PROMISC;
 	local->ops->configure_filter(local_to_hw(local),

