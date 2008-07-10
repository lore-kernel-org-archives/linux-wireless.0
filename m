Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33649 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbYGJJrl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2008 05:47:41 -0400
Subject: [PATCH] mac80211: fix struct ieee80211_tx_queue_params
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 10 Jul 2008 11:22:31 +0200
Message-Id: <1215681751.3932.14.camel@johannes.berg> (sfid-20080710_114743_586979_990ECB3B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Multiple issues:
 - there are no "default" values needed
 - cw_min/cw_max can be larger than documented
 - restructure to decrease size
 - use get_unaligned_le16

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h |   10 +++++-----
 net/mac80211/mlme.c    |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

--- everything.orig/include/net/mac80211.h	2008-07-10 11:20:10.000000000 +0200
+++ everything/include/net/mac80211.h	2008-07-10 11:20:14.000000000 +0200
@@ -115,17 +115,17 @@ enum ieee80211_max_queues {
  * The information provided in this structure is required for QoS
  * transmit queue configuration. Cf. IEEE 802.11 7.3.2.29.
  *
- * @aifs: arbitration interface space [0..255, -1: use default]
- * @cw_min: minimum contention window [will be a value of the form
- *	2^n-1 in the range 1..1023; 0: use default]
+ * @aifs: arbitration interface space [0..255]
+ * @cw_min: minimum contention window [a value of the form
+ *	2^n-1 in the range 1..32767]
  * @cw_max: maximum contention window [like @cw_min]
  * @txop: maximum burst time in units of 32 usecs, 0 meaning disabled
  */
 struct ieee80211_tx_queue_params {
-	s16 aifs;
+	u16 txop;
 	u16 cw_min;
 	u16 cw_max;
-	u16 txop;
+	u8 aifs;
 };
 
 /**
--- everything.orig/net/mac80211/mlme.c	2008-07-10 11:20:10.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-07-10 11:20:14.000000000 +0200
@@ -345,7 +345,7 @@ static void ieee80211_sta_wmm_params(str
 		params.aifs = pos[0] & 0x0f;
 		params.cw_max = ecw2cw((pos[1] & 0xf0) >> 4);
 		params.cw_min = ecw2cw(pos[1] & 0x0f);
-		params.txop = pos[2] | (pos[3] << 8);
+		params.txop = get_unaligned_le16(pos + 2);
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 		printk(KERN_DEBUG "%s: WMM queue=%d aci=%d acm=%d aifs=%d "
 		       "cWmin=%d cWmax=%d txop=%d\n",


