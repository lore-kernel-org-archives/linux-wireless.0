Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54756 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab1KDKVH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 06:21:07 -0400
Message-Id: <20111104101942.494327240@sipsolutions.net> (sfid-20111104_112111_090064_7F64AE1B)
Date: Fri, 04 Nov 2011 11:18:10 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 01/12] mac80211: add helper to free TX skb
References: <20111104101809.711636760@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Drivers that need to drop a frame before it
can be transmitted will usually simply free
that frame. This is currently fine, but in
the future it'll be needed to tell mac80211
about this case, so add a new routine that
frees a TX skb.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h |   10 ++++++++++
 net/mac80211/status.c  |    6 ++++++
 2 files changed, 16 insertions(+)

--- a/include/net/mac80211.h	2011-11-03 10:54:17.000000000 +0100
+++ b/include/net/mac80211.h	2011-11-03 11:52:48.000000000 +0100
@@ -1304,6 +1304,16 @@ ieee80211_get_alt_retry_rate(const struc
 }
 
 /**
+ * ieee80211_free_txskb - free TX skb
+ * @hw: the hardware
+ * @skb: the skb
+ *
+ * Free a transmit skb. Use this funtion when some failure
+ * to transmit happened and thus status cannot be reported.
+ */
+void ieee80211_free_txskb(struct ieee80211_hw *hw, struct sk_buff *skb);
+
+/**
  * DOC: Hardware crypto acceleration
  *
  * mac80211 is capable of taking advantage of many hardware
--- a/net/mac80211/status.c	2011-11-03 10:54:17.000000000 +0100
+++ b/net/mac80211/status.c	2011-11-03 11:52:48.000000000 +0100
@@ -609,3 +609,9 @@ void ieee80211_report_low_ack(struct iee
 				    num_packets, GFP_ATOMIC);
 }
 EXPORT_SYMBOL(ieee80211_report_low_ack);
+
+void ieee80211_free_txskb(struct ieee80211_hw *hw, struct sk_buff *skb)
+{
+	dev_kfree_skb_any(skb);
+}
+EXPORT_SYMBOL(ieee80211_free_txskb);


