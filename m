Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-ca-3.exch022.serverdata.net ([64.78.56.55]:24302 "EHLO
	HUB022-ca-3.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756630Ab3DJKmO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 06:42:14 -0400
Message-ID: <516541FD.9050109@posedge.com> (sfid-20130410_124239_109089_66F4AC54)
Date: Wed, 10 Apr 2013 16:12:05 +0530
From: Vivekananda Holla <vivekanandah@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: [Patch] mac80211: SMPS for AP Mode
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

patch for SMPS mode. after discussion, setting the IEEE80211_TX_RC_USE_RTS_CTS flag for first rate if dynamic SMPS is on in the receiving station

Signed-off-by: Vivekananda Holla <vivekanandah@posedge.com>
---
 net/mac80211/rc80211_minstrel_ht.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index d2b264d..fbca005 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -745,6 +745,10 @@ minstrel_ht_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
         minstrel_ht_set_rate(mp, mi, &ar[0], mi->max_tp_rate,
             false, false);
     }
+   
+    /* set RTS Flag for the first rate if dynamic SMPS is on for sta */
+    if (sta->smps_mode == IEEE80211_SMPS_DYNAMIC)
+        ar[0].flags |= IEEE80211_TX_RC_USE_RTS_CTS;
 
     if (mp->hw->max_rates >= 3) {
         /*
 

