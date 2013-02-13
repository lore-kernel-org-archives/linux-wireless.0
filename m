Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gast-001.fem.tu-ilmenau.de ([141.24.44.1]:60890 "EHLO
	a251.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759822Ab3BMPtU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 10:49:20 -0500
From: Michael Braun <michael-dev@fami-braun.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de,
	Michael Braun <michael-dev@fami-braun.de>
Subject: [PATCHv6 1/2] mac80211: free ps->bc_buf skbs on vlan device stop
Date: Wed, 13 Feb 2013 16:49:15 +0100
Message-Id: <1360770556-6716-2-git-send-email-michael-dev@fami-braun.de> (sfid-20130213_164935_155033_ACBA4A6D)
In-Reply-To: <1360770556-6716-1-git-send-email-michael-dev@fami-braun.de>
References: <1360770556-6716-1-git-send-email-michael-dev@fami-braun.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the vlan device is removed, ps->bc_buf processing can no longer
send its frames.

Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
---
V4: Add this patch.
V5: add spin_lock, switch order of patches
V6: use ieee80211_free_txskb

 net/mac80211/iface.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 40ff030..c1411f0 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -680,6 +680,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	struct sk_buff *skb, *tmp;
 	u32 hw_reconf_flags = 0;
 	int i, flushed;
+	struct ps_data *ps;
 
 	clear_bit(SDATA_STATE_RUNNING, &sdata->state);
 
@@ -758,6 +759,19 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 					 u.vlan.list)
 			dev_close(vlan->dev);
 		WARN_ON(!list_empty(&sdata->u.ap.vlans));
+	} else if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN) {
+		/* remove all packets in parent bc_buf pointing to this dev */
+		ps = &sdata->bss->ps;
+
+		spin_lock_irqsave(&ps->bc_buf.lock, flags);
+		skb_queue_walk_safe(&ps->bc_buf, skb, tmp) {
+			if (skb->dev == sdata->dev) {
+				__skb_unlink(skb, &ps->bc_buf);
+				local->total_ps_buffered--;
+				ieee80211_free_txskb(&local->hw, skb);
+			}
+		}
+		spin_unlock_irqrestore(&ps->bc_buf.lock, flags);
 	} else if (sdata->vif.type == NL80211_IFTYPE_STATION) {
 		ieee80211_mgd_stop(sdata);
 	}
-- 
1.7.10.4

