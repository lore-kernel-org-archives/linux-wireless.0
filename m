Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-80-86-92-145.inaddr.intergenia.de ([80.86.92.145]:41657
	"EHLO home.einfach.org" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756130AbYGMWpn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jul 2008 18:45:43 -0400
From: Bruno Randolf <br1@einfach.org>
Subject: [PATCH 1/2] mac80211: add rx status flag for short preamble
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	tomasw@gmail.com, yi.zhu@intel.com
Date: Mon, 14 Jul 2008 00:20:26 +0200
Message-ID: <20080713222026.16732.9011.stgit@void> (sfid-20080714_004612_092408_EFAFE9D1)
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
index 656442c..8e9e0c8 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -355,6 +355,7 @@ static inline struct ieee80211_tx_info *IEEE80211_SKB_CB(struct sk_buff *skb)
  * @RX_FLAG_TSFT: The timestamp passed in the RX status (@mactime field)
  *	is valid. This is useful in monitor mode and necessary for beacon frames
  *	to enable IBSS merging.
+ * @RX_FLAG_SHORTPRE: Short preamble was used for this frame
  */
 enum mac80211_rx_flags {
 	RX_FLAG_MMIC_ERROR	= 1<<0,
@@ -365,6 +366,7 @@ enum mac80211_rx_flags {
 	RX_FLAG_FAILED_FCS_CRC	= 1<<5,
 	RX_FLAG_FAILED_PLCP_CRC = 1<<6,
 	RX_FLAG_TSFT		= 1<<7,
+	RX_FLAG_SHORTPRE	= 1<<8
 };
 
 /**
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index fab443d..5131ee2 100644
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

