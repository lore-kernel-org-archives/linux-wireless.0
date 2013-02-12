Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from a-keller-035.fem.tu-ilmenau.de ([141.24.40.99]:57255 "EHLO
	a251.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933865Ab3BLTCb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 14:02:31 -0500
From: Michael Braun <michael-dev@fami-braun.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de,
	Michael Braun <michael-dev@fami-braun.de>
Subject: [RFCv4 2/2] mac80211: free ps->bc_buf skbs on vlan device stop
Date: Tue, 12 Feb 2013 19:51:46 +0100
Message-Id: <1360695107-5721-3-git-send-email-michael-dev@fami-braun.de> (sfid-20130212_200235_648904_98A270D2)
In-Reply-To: <1360695107-5721-1-git-send-email-michael-dev@fami-braun.de>
References: <1360695107-5721-1-git-send-email-michael-dev@fami-braun.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the vlan device is removed, ps->bc_buf processing can no longer
send its frames.

Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
---
V4: Add this patch. Does it need locks? Which?

 net/mac80211/iface.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 0a36dc6..b7a57b7 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -748,6 +748,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	struct sk_buff *skb, *tmp;
 	u32 hw_reconf_flags = 0;
 	int i, flushed;
+	struct ps_data *ps;
 
 	clear_bit(SDATA_STATE_RUNNING, &sdata->state);
 
@@ -826,6 +827,17 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 					 u.vlan.list)
 			dev_close(vlan->dev);
 		WARN_ON(!list_empty(&sdata->u.ap.vlans));
+	} else if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN) {
+		/* remove all packets in parent bc_buf pointing to this dev */
+		ps = &sdata->bss->ps;
+
+		skb_queue_walk_safe(&ps->bc_buf, skb, tmp) {
+			if (skb->dev == sdata->dev) {
+				__skb_unlink(skb, &ps->bc_buf);
+				local->total_ps_buffered--;
+				kfree_skb(skb);
+			}
+		}
 	} else if (sdata->vif.type == NL80211_IFTYPE_STATION) {
 		ieee80211_mgd_stop(sdata);
 	}
-- 
1.7.10.4

