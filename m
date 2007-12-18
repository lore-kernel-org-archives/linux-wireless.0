Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:22912 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756514AbXLRPYH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Dec 2007 10:24:07 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 1/1] mac80211: pass in PS_POLL frames
Date: Tue, 18 Dec 2007 17:23:53 +0200
Message-Id: <1197991433172-git-send-email-ron.rindjunsky@intel.com> (sfid-20071218_152413_980669_666846C0)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes should_drop_frame function to pass in ps poll control
frames required for power save functioanlity. Interface types that do not
have interest for PS POLL frames now drop it in handler.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 net/mac80211/rx.c   |   11 +++++++++--
 net/mac80211/util.c |    7 ++++++-
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 50f99e7..e94cf30 100644
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
@@ -880,6 +882,7 @@ ieee80211_rx_h_defragment(struct ieee80211_txrx_data *rx)
 static ieee80211_txrx_result
 ieee80211_rx_h_ps_poll(struct ieee80211_txrx_data *rx)
 {
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(rx->dev);
 	struct sk_buff *skb;
 	int no_pending_pkts;
 	DECLARE_MAC_BUF(mac);
@@ -890,6 +893,10 @@ ieee80211_rx_h_ps_poll(struct ieee80211_txrx_data *rx)
 		   !(rx->flags & IEEE80211_TXRXD_RXRA_MATCH)))
 		return TXRX_CONTINUE;
 
+	if ((sdata->type != IEEE80211_IF_TYPE_AP) &&
+	    (sdata->type != IEEE80211_IF_TYPE_VLAN))
+		return TXRX_DROP;
+
 	skb = skb_dequeue(&rx->sta->tx_filtered);
 	if (!skb) {
 		skb = skb_dequeue(&rx->sta->ps_tx_buf);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 7b278e9..fb7fd89 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -135,13 +135,16 @@ u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len)
 {
 	u16 fc;
 
-	if (len < 24)
+	 /* drop ACK/CTS frames and incorrect hdr len (ctrl) */
+	if (len < 16)
 		return NULL;
 
 	fc = le16_to_cpu(hdr->frame_control);
 
 	switch (fc & IEEE80211_FCTL_FTYPE) {
 	case IEEE80211_FTYPE_DATA:
+		if (len < 24) /* drop incorrect hdr len (data) */
+			return NULL;
 		switch (fc & (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS)) {
 		case IEEE80211_FCTL_TODS:
 			return hdr->addr1;
@@ -154,6 +157,8 @@ u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len)
 		}
 		break;
 	case IEEE80211_FTYPE_MGMT:
+		if (len < 24) /* drop incorrect hdr len (mgmt) */
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

