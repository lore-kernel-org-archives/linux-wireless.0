Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33357 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758013Ab2EaNJb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 May 2012 09:09:31 -0400
Message-ID: <1338469767.9102.8.camel@jlt3.sipsolutions.net> (sfid-20120531_150939_471965_9C8C4BD8)
Subject: [PATCH v2 3.5] mac80211: clean up remain-on-channel on interface
 stop
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Nirav Shah <nirav.j2.shah@intel.com>,
	Eliad Peller <eliad@wizery.com>
Date: Thu, 31 May 2012 15:09:27 +0200
In-Reply-To: <1338383762.4511.16.camel@jlt3.sipsolutions.net> (sfid-20120530_151615_403243_25B38365)
References: <1338383762.4511.16.camel@jlt3.sipsolutions.net>
	 (sfid-20120530_151615_403243_25B38365)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When any interface goes down, it could be the one that we
were doing a remain-on-channel with. We therefore need to
cancel the remain-on-channel and flush the related work
structs so they don't run after the interface has been
removed or even destroyed.

It's also possible in this case that an off-channel SKB
was never transmitted, so free it if this is the case.
Note that this can also happen if the driver finishes
the off-channel period without ever starting it.

Cc: stable@kernel.org
Reported-by: Nirav Shah <nirav.j2.shah@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
v2: actually cancel the roc and clean up after it

 net/mac80211/iface.c      |   12 ++++++++++++
 net/mac80211/offchannel.c |   16 ++++++++++++++++
 2 files changed, 28 insertions(+)

--- a/net/mac80211/iface.c	2012-05-31 14:29:52.000000000 +0200
+++ b/net/mac80211/iface.c	2012-05-31 15:03:22.000000000 +0200
@@ -637,6 +637,18 @@ static void ieee80211_do_stop(struct iee
 		ieee80211_configure_filter(local);
 		break;
 	default:
+		mutex_lock(&local->mtx);
+		if (local->hw_roc_dev == sdata->dev &&
+		    local->hw_roc_channel) {
+			/* ignore return value since this is racy */
+			drv_cancel_remain_on_channel(local);
+			ieee80211_queue_work(&local->hw, &local->hw_roc_done);
+		}
+		mutex_unlock(&local->mtx);
+
+		flush_work(&local->hw_roc_start);
+		flush_work(&local->hw_roc_done);
+
 		flush_work(&sdata->work);
 		/*
 		 * When we get here, the interface is marked down.
--- a/net/mac80211/offchannel.c	2012-05-31 14:48:54.000000000 +0200
+++ b/net/mac80211/offchannel.c	2012-05-31 14:48:57.000000000 +0200
@@ -234,6 +234,22 @@ static void ieee80211_hw_roc_done(struct
 		return;
 	}
 
+	/* was never transmitted */
+	if (local->hw_roc_skb) {
+		u64 cookie;
+
+		cookie = local->hw_roc_cookie ^ 2;
+
+		cfg80211_mgmt_tx_status(local->hw_roc_dev, cookie,
+					local->hw_roc_skb->data,
+					local->hw_roc_skb->len, false,
+					GFP_KERNEL);
+
+		kfree_skb(local->hw_roc_skb);
+		local->hw_roc_skb = NULL;
+		local->hw_roc_skb_for_status = NULL;
+	}
+
 	if (!local->hw_roc_for_tx)
 		cfg80211_remain_on_channel_expired(local->hw_roc_dev,
 						   local->hw_roc_cookie,


