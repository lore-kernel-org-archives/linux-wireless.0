Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54762 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578Ab1KDKVS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 06:21:18 -0400
Message-Id: <20111104101943.404597640@sipsolutions.net> (sfid-20111104_112120_374310_28D07F2D)
Date: Fri, 04 Nov 2011 11:18:13 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 04/12] mac80211: support spurious class3 event
References: <20111104101809.711636760@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add support for the spurious class3 frame event
to mac80211 to enable AP w/o monitor mode.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/net/mac80211/rx.c	2011-11-03 11:52:41.000000000 +0100
+++ b/net/mac80211/rx.c	2011-11-03 11:52:50.000000000 +0100
@@ -854,6 +854,13 @@ ieee80211_rx_h_check(struct ieee80211_rx
 			    rx->sdata->control_port_protocol)
 				return RX_CONTINUE;
 		}
+
+		if (rx->sdata->vif.type == NL80211_IFTYPE_AP &&
+		    cfg80211_rx_spurious_frame(rx->sdata->dev,
+		    			       hdr->addr2,
+		    			       GFP_ATOMIC))
+			return RX_DROP_UNUSABLE;
+
 		return RX_DROP_MONITOR;
 	}
 


