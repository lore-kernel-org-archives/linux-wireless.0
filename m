Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:16990 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751260AbYG3PUN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 11:20:13 -0400
From: Bruno Randolf <br1@einfach.org>
Subject: [PATCH 1/3] mac80211: add rx status flag for short preamble
To: tomas.winkler@intel.com
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Date: Wed, 30 Jul 2008 17:19:55 +0200
Message-ID: <20080730151955.24487.76871.stgit@void> (sfid-20080730_172016_998736_9B4D4AF5)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

and use it for the radiotap header

Signed-off-by: Bruno Randolf <br1@einfach.org>
---

 include/net/mac80211.h |    2 ++
 net/mac80211/rx.c      |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 24a69f6..2d01a75 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -367,6 +367,7 @@ static inline struct ieee80211_tx_info *IEEE80211_SKB_CB(struct sk_buff *skb)
  * @RX_FLAG_TSFT: The timestamp passed in the RX status (@mactime field)
  *	is valid. This is useful in monitor mode and necessary for beacon frames
  *	to enable IBSS merging.
+ * @RX_FLAG_SHORTPRE: Short preamble was used for this frame
  */
 enum mac80211_rx_flags {
 	RX_FLAG_MMIC_ERROR	= 1<<0,
@@ -377,6 +378,7 @@ enum mac80211_rx_flags {
 	RX_FLAG_FAILED_FCS_CRC	= 1<<5,
 	RX_FLAG_FAILED_PLCP_CRC = 1<<6,
 	RX_FLAG_TSFT		= 1<<7,
+	RX_FLAG_SHORTPRE	= 1<<8
 };
 
 /**
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 6d9ae67..254462f 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -143,6 +143,8 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 	/* IEEE80211_RADIOTAP_FLAGS */
 	if (local->hw.flags & IEEE80211_HW_RX_INCLUDES_FCS)
 		*pos |= IEEE80211_RADIOTAP_F_FCS;
+	if (status->flag & RX_FLAG_SHORTPRE)
+		*pos |= IEEE80211_RADIOTAP_F_SHORTPRE;
 	pos++;
 
 	/* IEEE80211_RADIOTAP_RATE */

