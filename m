Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f43.google.com ([209.85.215.43]:40928 "EHLO
	mail-ew0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932312Ab1IOKbn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 06:31:43 -0400
Received: by ewy20 with SMTP id 20so1670783ewy.2
        for <linux-wireless@vger.kernel.org>; Thu, 15 Sep 2011 03:31:42 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Kalyan C Gaddam <chakkal@iit.edu>, Arik Nemtsov <arik@wizery.com>
Subject: [RFC 5/5] mac80211: send data directly to TDLS peers
Date: Thu, 15 Sep 2011 13:25:34 +0300
Message-Id: <1316082334-7664-6-git-send-email-arik@wizery.com> (sfid-20110915_123146_593683_1FBA16D4)
In-Reply-To: <1316082334-7664-1-git-send-email-arik@wizery.com>
References: <1316082334-7664-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a station is determined to be a TDLS peer, send the data directly,
bypassing the AP.

In addition, allow data to be received directly from TDLS peers.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Cc: Kalyan C Gaddam <chakkal@iit.edu>
---
 net/mac80211/tx.c   |   24 ++++++++++++++++++++----
 net/wireless/util.c |    5 +++--
 2 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 0107263..43c08ce 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1725,6 +1725,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 	struct sta_info *sta = NULL;
 	u32 sta_flags = 0;
 	struct sk_buff *tmp_skb;
+	bool tdls_link = false;
 
 	if (unlikely(skb->len < ETH_HLEN)) {
 		ret = NETDEV_TX_OK;
@@ -1836,11 +1837,25 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 		break;
 #endif
 	case NL80211_IFTYPE_STATION:
-		memcpy(hdr.addr1, sdata->u.mgd.bssid, ETH_ALEN);
-		if (sdata->u.mgd.use_4addr &&
-		    cpu_to_be16(ethertype) != sdata->control_port_protocol) {
-			fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS);
+		if (local->hw.flags & IEEE80211_HW_SUPPORTS_TDLS) {
+			rcu_read_lock();
+			sta = sta_info_get(sdata, skb->data);
+			tdls_link = (sta && sta->tdls_link_enabled);
+			rcu_read_unlock();
+		}
+
+		if (tdls_link) {
+			/* DA SA BSSID */
+			memcpy(hdr.addr1, skb->data, ETH_ALEN);
+			memcpy(hdr.addr2, skb->data + ETH_ALEN, ETH_ALEN);
+			memcpy(hdr.addr3, sdata->u.mgd.bssid, ETH_ALEN);
+			hdrlen = 24;
+		}  else if (sdata->u.mgd.use_4addr &&
+			    cpu_to_be16(ethertype) != sdata->control_port_protocol) {
+			fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS |
+					  IEEE80211_FCTL_TODS);
 			/* RA TA DA SA */
+			memcpy(hdr.addr1, sdata->u.mgd.bssid, ETH_ALEN);
 			memcpy(hdr.addr2, sdata->vif.addr, ETH_ALEN);
 			memcpy(hdr.addr3, skb->data, ETH_ALEN);
 			memcpy(hdr.addr4, skb->data + ETH_ALEN, ETH_ALEN);
@@ -1848,6 +1863,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 		} else {
 			fc |= cpu_to_le16(IEEE80211_FCTL_TODS);
 			/* BSSID SA DA */
+			memcpy(hdr.addr1, sdata->u.mgd.bssid, ETH_ALEN);
 			memcpy(hdr.addr2, skb->data + ETH_ALEN, ETH_ALEN);
 			memcpy(hdr.addr3, skb->data, ETH_ALEN);
 			hdrlen = 24;
diff --git a/net/wireless/util.c b/net/wireless/util.c
index eef82f7..c28afee 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -392,8 +392,9 @@ int ieee80211_data_to_8023(struct sk_buff *skb, const u8 *addr,
 		}
 		break;
 	case cpu_to_le16(0):
-		if (iftype != NL80211_IFTYPE_ADHOC)
-			return -1;
+		if (iftype != NL80211_IFTYPE_ADHOC &&
+		    iftype != NL80211_IFTYPE_STATION)
+				return -1;
 		break;
 	}
 
-- 
1.7.4.1

