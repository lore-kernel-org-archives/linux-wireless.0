Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.238]:24357 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbYLWMoR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2008 07:44:17 -0500
Received: by rv-out-0506.google.com with SMTP id k40so2354614rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 23 Dec 2008 04:44:17 -0800 (PST)
Date: Tue, 23 Dec 2008 18:17:19 -0800
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Reset the power save timer from
	master_start_xmit.
Message-ID: <20081224021719.GA5225@myhost.users.atheros.com> (sfid-20081223_134422_680497_46FAE128)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a null data frame is generated from mac80211,  it goes through
master_start_xmit and not through  subif_start_xmit. Hence for the
power save timer to be triggered while sending this null data frame
also, the timer has to be reset from master_start_xmit.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 net/mac80211/tx.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 27474cf..c723dcc 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1298,6 +1298,19 @@ int ieee80211_master_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		return 0;
 	}
 
+	if (!(local->hw.flags & IEEE80211_HW_NO_STACK_DYNAMIC_PS) &&
+	    local->dynamic_ps_timeout > 0) {
+		if (local->hw.conf.flags & IEEE80211_CONF_PS) {
+			ieee80211_stop_queues_by_reason(&local->hw,
+					IEEE80211_QUEUE_STOP_REASON_PS);
+			queue_work(local->hw.workqueue,
+					&local->dynamic_ps_disable_work);
+		}
+
+		mod_timer(&local->dynamic_ps_timer, jiffies +
+				msecs_to_jiffies(local->dynamic_ps_timeout));
+	}
+
 	memset(info, 0, sizeof(*info));
 
 	info->flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
@@ -1475,19 +1488,6 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
 		goto fail;
 	}
 
-	if (!(local->hw.flags & IEEE80211_HW_NO_STACK_DYNAMIC_PS) &&
-	    local->dynamic_ps_timeout > 0) {
-		if (local->hw.conf.flags & IEEE80211_CONF_PS) {
-			ieee80211_stop_queues_by_reason(&local->hw,
-							IEEE80211_QUEUE_STOP_REASON_PS);
-			queue_work(local->hw.workqueue,
-				   &local->dynamic_ps_disable_work);
-		}
-
-		mod_timer(&local->dynamic_ps_timer, jiffies +
-			  msecs_to_jiffies(local->dynamic_ps_timeout));
-	}
-
 	nh_pos = skb_network_header(skb) - skb->data;
 	h_pos = skb_transport_header(skb) - skb->data;
 
-- 
1.6.0.1

