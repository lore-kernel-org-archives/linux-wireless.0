Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:10037 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865AbXLIMdv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Dec 2007 07:33:51 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 1/1] mac80211: pass in PS_POLL frames
Date: Sun,  9 Dec 2007 14:33:42 +0200
Message-Id: <11972036221022-git-send-email-ron.rindjunsky@intel.com> (sfid-20071209_123357_394901_AC10C55A)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes should_drop_frame function to pass in ps poll control
frames required for power save functioanlity. Interface types that do not
have interest for PS POLL frames now drop it in handler.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 net/mac80211/ieee80211_i.h |    5 +++++
 net/mac80211/rx.c          |   10 ++++++++--
 net/mac80211/util.c        |    6 +++++-
 3 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 2476cc5..a7746da 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -58,6 +58,11 @@ struct ieee80211_local;
  * increased memory use (about 2 kB of RAM per entry). */
 #define IEEE80211_FRAGMENT_MAX 4
 
+/* IEEE 80211.11 minimal headers length */
+#define IEEE80211_HDR_MIN_LEN_CTRL 16
+#define IEEE80211_HDR_MIN_LEN_DATA 24
+#define IEEE80211_HDR_MIN_LEN_MGMT 24
+
 struct ieee80211_fragment_entry {
 	unsigned long first_frag_time;
 	unsigned int seq;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 9009444..3bd9edc 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -61,8 +61,10 @@ static inline int should_drop_frame(struct ieee80211_rx_status *status,
 		return 1;
 	if (unlikely(skb->len < 16 + present_fcs_len + radiotap_len))
 		return 1;
-	if ((hdr->frame_control & cpu_to_le16(IEEE80211_FCTL_FTYPE)) ==
-			cpu_to_le16(IEEE80211_FTYPE_CTL))
+	if (((hdr->frame_control & cpu_to_le16(IEEE80211_FCTL_FTYPE)) ==
+			cpu_to_le16(IEEE80211_FTYPE_CTL)) &&
+	    ((hdr->frame_control & cpu_to_le16(IEEE80211_FCTL_STYPE)) !=
+			cpu_to_le16(IEEE80211_STYPE_PSPOLL)))
 		return 1;
 	return 0;
 }
@@ -874,6 +876,7 @@ ieee80211_rx_h_defragment(struct ieee80211_txrx_data *rx)
 static ieee80211_txrx_result
 ieee80211_rx_h_ps_poll(struct ieee80211_txrx_data *rx)
 {
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(rx->dev);
 	struct sk_buff *skb;
 	int no_pending_pkts;
 	DECLARE_MAC_BUF(mac);
@@ -884,6 +887,9 @@ ieee80211_rx_h_ps_poll(struct ieee80211_txrx_data *rx)
 		   !(rx->flags & IEEE80211_TXRXD_RXRA_MATCH)))
 		return TXRX_CONTINUE;
 
+	if (sdata->type == IEEE80211_IF_TYPE_STA)
+		return TXRX_DROP;
+
 	skb = skb_dequeue(&rx->sta->tx_filtered);
 	if (!skb) {
 		skb = skb_dequeue(&rx->sta->ps_tx_buf);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index f90287a..b53644c 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -134,13 +134,15 @@ u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len)
 {
 	u16 fc;
 
-	if (len < 24)
+	if (len < IEEE80211_HDR_MIN_LEN_CTRL)
 		return NULL;
 
 	fc = le16_to_cpu(hdr->frame_control);
 
 	switch (fc & IEEE80211_FCTL_FTYPE) {
 	case IEEE80211_FTYPE_DATA:
+		if (len < IEEE80211_HDR_MIN_LEN_DATA)
+			return NULL;
 		switch (fc & (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS)) {
 		case IEEE80211_FCTL_TODS:
 			return hdr->addr1;
@@ -153,6 +155,8 @@ u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len)
 		}
 		break;
 	case IEEE80211_FTYPE_MGMT:
+		if (len < IEEE80211_HDR_MIN_LEN_MGMT)
+			return NULL;
 		return hdr->addr3;
 	case IEEE80211_FTYPE_CTL:
 		if ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_PSPOLL)
-- 
1.5.3.3
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
