Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50102 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751388AbdAMKMG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 05:12:06 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: corbet@lwn.net, linux-doc@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix documentation warnings
Date: Fri, 13 Jan 2017 11:12:01 +0100
Message-Id: <20170113101201.7352-1-johannes@sipsolutions.net> (sfid-20170113_111210_863954_DBDBE5D8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

For a few restructured text warnings in mac80211, making the
documentation warning-free (for now). Again, this required
adding trailing whitespace to keep multiple paragraphs in a
parameter description together.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 86967b85dfd0..228c72617916 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1771,10 +1771,12 @@ struct ieee80211_sta_rates {
  * @max_amsdu_len: indicates the maximal length of an A-MSDU in bytes. This
  *	field is always valid for packets with a VHT preamble. For packets
  *	with a HT preamble, additional limits apply:
- *		+ If the skb is transmitted as part of a BA agreement, the
- *		  A-MSDU maximal size is min(max_amsdu_len, 4065) bytes.
- *		+ If the skb is not part of a BA aggreement, the A-MSDU maximal
- *		  size is min(max_amsdu_len, 7935) bytes.
+ *	
+ *	* If the skb is transmitted as part of a BA agreement, the
+ *	  A-MSDU maximal size is min(max_amsdu_len, 4065) bytes.
+ *	* If the skb is not part of a BA aggreement, the A-MSDU maximal
+ *	  size is min(max_amsdu_len, 7935) bytes.
+ *	
  *	Both additional HT limits must be enforced by the low level driver.
  *	This is defined by the spec (IEEE 802.11-2012 section 8.3.2.2 NOTE 2).
  * @support_p2p_ps: indicates whether the STA supports P2P PS mechanism or not.
@@ -3212,14 +3214,20 @@ enum ieee80211_reconfig_type {
  *	nor send aggregates in a way that lost frames would exceed the
  *	buffer size. If just limiting the aggregate size, this would be
  *	possible with a buf_size of 8:
- *	 - TX: 1.....7
- *	 - RX:  2....7 (lost frame #1)
- *	 - TX:        8..1...
+ *	
+ *	- ``TX: 1.....7``
+ *	- ``RX:  2....7`` (lost frame #1)
+ *	- ``TX:        8..1...``
+ *	
  *	which is invalid since #1 was now re-transmitted well past the
  *	buffer size of 8. Correct ways to retransmit #1 would be:
- *	 - TX:       1 or 18 or 81
- *	Even "189" would be wrong since 1 could be lost again.
- *
+ *	
+ *	- ``TX:        1   or``
+ *	- ``TX:        18  or``
+ *	- ``TX:        81``
+ *	
+ *	Even ``189`` would be wrong since 1 could be lost again.
+ *	
  *	Returns a negative error code on failure.
  *	The callback can sleep.
  *
-- 
2.9.3
