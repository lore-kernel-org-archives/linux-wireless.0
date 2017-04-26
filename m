Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53799 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1437749AbdDZPLi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 11:11:38 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, thomas@net.t-labs.tu-berlin.de
Subject: [PATCH 5/5] mac80211: add txpower to the new tx_status_ext
Date: Wed, 26 Apr 2017 17:11:39 +0200
Message-Id: <20170426151139.87304-5-nbd@nbd.name> (sfid-20170426_172636_422533_DC6A1F8B)
In-Reply-To: <20170426151139.87304-1-nbd@nbd.name>
References: <20170426151139.87304-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>

To use the per rate information about which txpower level was
used for a successful or unsuccessful transmission, this new
tx power per multi-rate retry rate annotation in the tx status
path is needed.

Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
---
 include/net/mac80211.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index d29702601333..bd28c81bc515 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -959,11 +959,13 @@ struct ieee80211_tx_info {
  * @sta: Station that the packet was transmitted for
  * @info: Basic tx status information
  * @skb: Packet skb (can be NULL if not provided by the driver)
+ * @txpower: Txpower per rate status information
  */
 struct ieee80211_tx_status {
 	struct ieee80211_sta *sta;
 	struct ieee80211_tx_info *info;
 	struct sk_buff *skb;
+	s8 txpower[IEEE80211_TX_MAX_RATES];
 };
 
 /**
-- 
2.11.0
