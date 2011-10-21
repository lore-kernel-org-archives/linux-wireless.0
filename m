Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37132 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390Ab1JUOZG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 10:25:06 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.76)
	(envelope-from <johannes@sipsolutions.net>)
	id 1RHG1x-0008Qv-3c
	for linux-wireless@vger.kernel.org; Fri, 21 Oct 2011 16:25:05 +0200
Message-Id: <20111021142427.449830119@sipsolutions.net> (sfid-20111021_162515_360472_6EE3FB97)
Date: Fri, 21 Oct 2011 16:23:23 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC v2 01/12] mac80211: add helper to free TX skb
References: <20111021142322.229128720@sipsolutions.net>
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

--- a/include/net/mac80211.h	2011-10-21 10:20:42.000000000 +0200
+++ b/include/net/mac80211.h	2011-10-21 12:07:38.000000000 +0200
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
--- a/net/mac80211/status.c	2011-10-21 10:20:42.000000000 +0200
+++ b/net/mac80211/status.c	2011-10-21 12:07:38.000000000 +0200
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


