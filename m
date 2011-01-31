Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:54267 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755541Ab1AaSh5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 13:37:57 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] mac80211:  Recalculate channel-type on iface removal.
Date: Mon, 31 Jan 2011 10:37:52 -0800
Message-Id: <1296499072-6721-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

When a vif goes away, it could cause the super-chan
to be recalculated differently, so do that calculation
on iface removal.

Also, use WARN_ON_ONCE instead of WARN_ON if user has
ht40- stations in conjunction with ht40+.  It's not
really a kernel bug, just a mis-configuration of the
user's wifi environment.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 5b24740... ad9055d... M	net/mac80211/chan.c
:100644 100644 605c222... abf5f8e... M	net/mac80211/iface.c
 net/mac80211/chan.c  |    4 ++--
 net/mac80211/iface.c |    9 ++++++++-
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 5b24740..ad9055d 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -80,11 +80,11 @@ bool ieee80211_set_channel_type(struct ieee80211_local *local,
 			superchan = tmp->vif.bss_conf.channel_type;
 			break;
 		case NL80211_CHAN_HT40PLUS:
-			WARN_ON(superchan == NL80211_CHAN_HT40MINUS);
+			WARN_ON_ONCE(superchan == NL80211_CHAN_HT40MINUS);
 			superchan = NL80211_CHAN_HT40PLUS;
 			break;
 		case NL80211_CHAN_HT40MINUS:
-			WARN_ON(superchan == NL80211_CHAN_HT40PLUS);
+			WARN_ON_ONCE(superchan == NL80211_CHAN_HT40PLUS);
 			superchan = NL80211_CHAN_HT40MINUS;
 			break;
 		}
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 605c222..abf5f8e 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -382,6 +382,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	struct sk_buff *skb, *tmp;
 	u32 hw_reconf_flags = 0;
 	int i;
+	enum nl80211_channel_type orig_ct;
 
 	if (local->scan_sdata == sdata)
 		ieee80211_scan_cancel(local);
@@ -542,8 +543,14 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		hw_reconf_flags = 0;
 	}
 
+	/* Re-calculate channel-type, in case there are multiple vifs
+	 * on different channel types.
+	 */
+	orig_ct = local->_oper_channel_type;
+	ieee80211_set_channel_type(local, NULL, NL80211_CHAN_NO_HT);
+
 	/* do after stop to avoid reconfiguring when we stop anyway */
-	if (hw_reconf_flags)
+	if (hw_reconf_flags || (orig_ct != local->_oper_channel_type))
 		ieee80211_hw_config(local, hw_reconf_flags);
 
 	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
-- 
1.7.2.3

