Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:33454 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225AbbLKNkF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2015 08:40:05 -0500
Received: by lbbkw15 with SMTP id kw15so70360797lbb.0
        for <linux-wireless@vger.kernel.org>; Fri, 11 Dec 2015 05:40:04 -0800 (PST)
From: Grzegorz Bajorski <grzegorz.bajorski@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Grzegorz Bajorski <grzegorz.bajorski@tieto.com>
Subject: [PATCHv2] mac80211: allow drivers to report (non-)monitor frames
Date: Fri, 11 Dec 2015 14:39:46 +0100
Message-Id: <1449841186-23976-1-git-send-email-grzegorz.bajorski@tieto.com> (sfid-20151211_144015_252451_75936E4F)
In-Reply-To: <1448888094-2707-1-git-send-email-grzegorz.bajorski@tieto.com>
References: <1448888094-2707-1-git-send-email-grzegorz.bajorski@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some drivers offload some frames internally (e.g.
AddBa). Reporting such frames to mac80211 would
only confuse MLME. However it would be useful to
be able to pass such frames to monitor interfaces
for sniffing purposes, e.g. when running AP +
monitor.

To do that allow drivers to tell mac80211 whether
a given frame should be:
 - processed but not delivered to any monitor vif
 - not processed but delievered to monitor vifs
   only

Signed-off-by: Grzegorz Bajorski <grzegorz.bajorski@tieto.com>
---

Notes:
    v2:
     * fix commit log [Johannes]

 include/net/mac80211.h | 11 +++++++++++
 net/mac80211/rx.c      |  5 +++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 7c30faf..a35e584 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1014,6 +1014,14 @@ ieee80211_tx_info_clear_status(struct ieee80211_tx_info *info)
  * @RX_FLAG_AMPDU_DELIM_CRC_KNOWN: The delimiter CRC field is known (the CRC
  *	is stored in the @ampdu_delimiter_crc field)
  * @RX_FLAG_LDPC: LDPC was used
+ * @RX_FLAG_ONLY_MONITOR: Report frame only to monitor interfaces without
+ *	processing it in any regular way.
+ *	This is useful if drivers offload some frames but still want to report
+ *	them for sniffing purposes.
+ * @RX_FLAG_SKIP_MONITOR: Process and report frame to all interfaces except
+ *	monitor interfaces.
+ *	This is useful if drivers offload some frames but still want to report
+ *	them for sniffing purposes.
  * @RX_FLAG_STBC_MASK: STBC 2 bit bitmask. 1 - Nss=1, 2 - Nss=2, 3 - Nss=3
  * @RX_FLAG_10MHZ: 10 MHz (half channel) was used
  * @RX_FLAG_5MHZ: 5 MHz (quarter channel) was used
@@ -1054,6 +1062,8 @@ enum mac80211_rx_flags {
 	RX_FLAG_MACTIME_END		= BIT(21),
 	RX_FLAG_VHT			= BIT(22),
 	RX_FLAG_LDPC			= BIT(23),
+	RX_FLAG_ONLY_MONITOR		= BIT(24),
+	RX_FLAG_SKIP_MONITOR		= BIT(25),
 	RX_FLAG_STBC_MASK		= BIT(26) | BIT(27),
 	RX_FLAG_10MHZ			= BIT(28),
 	RX_FLAG_5MHZ			= BIT(29),
@@ -1072,6 +1082,7 @@ enum mac80211_rx_flags {
  * @RX_VHT_FLAG_160MHZ: 160 MHz was used
  * @RX_VHT_FLAG_BF: packet was beamformed
  */
+
 enum mac80211_rx_vht_flags {
 	RX_VHT_FLAG_80MHZ		= BIT(0),
 	RX_VHT_FLAG_160MHZ		= BIT(1),
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 1f82753..43ad7a5 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -122,7 +122,8 @@ static inline bool should_drop_frame(struct sk_buff *skb, int present_fcs_len,
 	hdr = (void *)(skb->data + rtap_vendor_space);
 
 	if (status->flag & (RX_FLAG_FAILED_FCS_CRC |
-			    RX_FLAG_FAILED_PLCP_CRC))
+			    RX_FLAG_FAILED_PLCP_CRC |
+			    RX_FLAG_ONLY_MONITOR))
 		return true;
 
 	if (unlikely(skb->len < 16 + present_fcs_len + rtap_vendor_space))
@@ -507,7 +508,7 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
 		return NULL;
 	}
 
-	if (!local->monitors) {
+	if (!local->monitors || (status->flag & RX_FLAG_SKIP_MONITOR)) {
 		if (should_drop_frame(origskb, present_fcs_len,
 				      rtap_vendor_space)) {
 			dev_kfree_skb(origskb);
-- 
2.3.7

