Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37137 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754678Ab1JUOZS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 10:25:18 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.76)
	(envelope-from <johannes@sipsolutions.net>)
	id 1RHG29-0008Tf-N1
	for linux-wireless@vger.kernel.org; Fri, 21 Oct 2011 16:25:17 +0200
Message-Id: <20111021142428.223933039@sipsolutions.net> (sfid-20111021_162521_601897_F9593E45)
Date: Fri, 21 Oct 2011 16:23:26 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC v2 04/12] mac80211: support spurious class3 event
References: <20111021142322.229128720@sipsolutions.net>
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

--- a/net/mac80211/rx.c	2011-10-21 10:22:38.000000000 +0200
+++ b/net/mac80211/rx.c	2011-10-21 12:07:40.000000000 +0200
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
 


