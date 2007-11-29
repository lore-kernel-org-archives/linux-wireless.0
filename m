Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:5924 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755080AbXK2Inc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2007 03:43:32 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 1/1] mac80211: move A-MSDU identifier to flags
Date: Thu, 29 Nov 2007 10:35:53 +0200
Message-Id: <11963253531534-git-send-email-ron.rindjunsky@intel.com> (sfid-20071129_084339_901264_D62A2127)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch moves u8 amsdu_frame in ieee80211_txrx_data to the flags
section as IEEE80211_TXRXD_RX_AMSDU

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 net/mac80211/ieee80211_i.h |    2 +-
 net/mac80211/rx.c          |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 399cc2d..2476cc5 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -123,6 +123,7 @@ typedef enum {
 /* frame is destined to interface currently processed (incl. multicast frames) */
 #define IEEE80211_TXRXD_RXRA_MATCH		BIT(5)
 #define IEEE80211_TXRXD_TX_INJECTED		BIT(6)
+#define IEEE80211_TXRXD_RX_AMSDU		BIT(7)
 struct ieee80211_txrx_data {
 	struct sk_buff *skb;
 	struct net_device *dev;
@@ -155,7 +156,6 @@ struct ieee80211_txrx_data {
 			int load;
 			u32 tkip_iv32;
 			u16 tkip_iv16;
-			u8  amsdu_frame;
 		} rx;
 	} u;
 };
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 878ca20..9009444 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -244,9 +244,9 @@ ieee80211_rx_h_parse_qos(struct ieee80211_txrx_data *rx)
 		/* frame has qos control */
 		tid = qc[0] & QOS_CONTROL_TID_MASK;
 		if (qc[0] & IEEE80211_QOS_CONTROL_A_MSDU_PRESENT)
-			rx->u.rx.amsdu_frame = 1;
+			rx->flags |= IEEE80211_TXRXD_RX_AMSDU;
 		else
-			rx->u.rx.amsdu_frame = 0;
+			rx->flags &= ~IEEE80211_TXRXD_RX_AMSDU;
 	} else {
 		if (unlikely((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT)) {
 			/* Separate TID for management frames */
@@ -1215,7 +1215,7 @@ ieee80211_rx_h_amsdu(struct ieee80211_txrx_data *rx)
 	if (unlikely(!WLAN_FC_DATA_PRESENT(fc)))
 		return TXRX_DROP;
 
-	if (!rx->u.rx.amsdu_frame)
+	if (!(rx->flags & IEEE80211_TXRXD_RX_AMSDU))
 		return TXRX_CONTINUE;
 
 	err = ieee80211_data_to_8023(rx);
-- 
1.5.3.3
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
