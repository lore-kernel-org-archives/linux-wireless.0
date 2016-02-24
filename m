Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53051 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316AbcBXTYW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2016 14:24:22 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, mrichart@fing.edu.uy,
	chaitanya.mgit@gmail.com
Subject: [PATCH] mac80211: minstrel_ht: fix a logic error in RTS/CTS handling
Date: Wed, 24 Feb 2016 12:07:17 +0100
Message-Id: <1456312037-82995-1-git-send-email-nbd@openwrt.org> (sfid-20160224_202425_754600_283CFCBF)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RTS/CTS needs to be enabled if the rate is a fallback rate *or* if it's
a dual-stream rate and the sta is in dynamic SMPS mode.

Fixes: a3ebb4e1b763 ("mac80211: minstrel_ht: handle peers in dynamic SMPS")
Reported-by: Matías Richart <mrichart@fing.edu.uy>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/rc80211_minstrel_ht.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 702328b..5e3dc7e 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -872,7 +872,7 @@ minstrel_ht_set_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
 	 *  - if station is in dynamic SMPS (and streams > 1)
 	 *  - for fallback rates, to increase chances of getting through
 	 */
-	if (offset > 0 &&
+	if (offset > 0 ||
 	    (mi->sta->smps_mode == IEEE80211_SMPS_DYNAMIC &&
 	     group->streams > 1)) {
 		ratetbl->rate[offset].count = ratetbl->rate[offset].count_rts;
-- 
2.2.2

