Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:58631 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110Ab0AGTYM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2010 14:24:12 -0500
Message-ID: <4B4634C9.5060701@openwrt.org>
Date: Thu, 07 Jan 2010 20:23:53 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 2.6.33] mac80211: add missing sanity checks for action frames
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Various missing sanity checks caused rejected action frames to be 
interpreted as channel switch announcements, which can cause a client
mode interface to switch away from its operating channel, thereby losing 
connectivity. This patch ensures that only spectrum management action 
frames are processed by the CSA handling function and prevents rejected 
action frames from getting processed by the MLME code.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@kernel.org
---

--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1451,7 +1451,9 @@ static void ieee80211_sta_rx_queued_mgmt
 			rma = ieee80211_rx_mgmt_disassoc(sdata, mgmt, skb->len);
 			break;
 		case IEEE80211_STYPE_ACTION:
-			/* XXX: differentiate, can only happen for CSA now! */
+			if (mgmt->u.action.category != WLAN_CATEGORY_SPECTRUM_MGMT)
+				break;
+
 			ieee80211_sta_process_chanswitch(sdata,
 					&mgmt->u.action.u.chan_switch.sw_elem,
 					(void *)ifmgd->associated->priv);
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1934,6 +1934,10 @@ ieee80211_rx_h_action(struct ieee80211_r
 		}
 		break;
 	default:
+		/* do not process rejected action frames */
+		if (mgmt->u.action.category & 0x80)
+			return RX_DROP_MONITOR;
+
 		return RX_CONTINUE;
 	}
 
