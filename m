Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36830 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641Ab2C0MUS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Mar 2012 08:20:18 -0400
Message-Id: <20120327121921.313750559@sipsolutions.net> (sfid-20120327_142024_785147_A7FB2629)
Date: Tue, 27 Mar 2012 14:18:37 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/5] mac80211: clean up uAPSD TX code
References: <20120327121835.299635879@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Clean up the code formatting and also replace
the constant 0 by IEEE80211_AC_VO.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/mac80211/tx.c	2012-03-23 11:25:35.000000000 +0100
+++ b/net/mac80211/tx.c	2012-03-23 14:28:08.000000000 +0100
@@ -230,9 +230,9 @@ ieee80211_tx_h_dynamic_ps(struct ieee802
 	 * changed via debugfs, user needs to reassociate manually to have
 	 * everything in sync.
 	 */
-	if ((ifmgd->flags & IEEE80211_STA_UAPSD_ENABLED)
-	    && (ifmgd->uapsd_queues & IEEE80211_WMM_IE_STA_QOSINFO_AC_VO)
-	    && skb_get_queue_mapping(tx->skb) == 0)
+	if ((ifmgd->flags & IEEE80211_STA_UAPSD_ENABLED) &&
+	    (ifmgd->uapsd_queues & IEEE80211_WMM_IE_STA_QOSINFO_AC_VO) &&
+	    skb_get_queue_mapping(tx->skb) == IEEE80211_AC_VO)
 		return TX_CONTINUE;
 
 	if (local->hw.conf.flags & IEEE80211_CONF_PS) {


