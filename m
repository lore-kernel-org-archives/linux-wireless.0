Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46747 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492AbbFQIlU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 04:41:20 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 08/14] mac80211: remove zero-length A-MPDU subframe reporting
Date: Wed, 17 Jun 2015 10:41:09 +0200
Message-Id: <1434530475-3553-9-git-send-email-johannes@sipsolutions.net> (sfid-20150617_104140_491269_8B872628)
In-Reply-To: <1434530475-3553-1-git-send-email-johannes@sipsolutions.net>
References: <1434530475-3553-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

As there's no driver using this capability and reporting zero-length
A-MPDU subframes for radiotap monitoring, remove the capability to
free up two RX flags.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h | 6 +-----
 net/mac80211/rx.c      | 7 +------
 2 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 4c23e787baeb..1fe761613d29 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -997,9 +997,6 @@ ieee80211_tx_info_clear_status(struct ieee80211_tx_info *info)
  * @RX_FLAG_AMPDU_DETAILS: A-MPDU details are known, in particular the reference
  *	number (@ampdu_reference) must be populated and be a distinct number for
  *	each A-MPDU
- * @RX_FLAG_AMPDU_REPORT_ZEROLEN: driver reports 0-length subframes
- * @RX_FLAG_AMPDU_IS_ZEROLEN: This is a zero-length subframe, for
- *	monitoring purposes only
  * @RX_FLAG_AMPDU_LAST_KNOWN: last subframe is known, should be set on all
  *	subframes of a single A-MPDU
  * @RX_FLAG_AMPDU_IS_LAST: this subframe is the last subframe of the A-MPDU
@@ -1039,8 +1036,7 @@ enum mac80211_rx_flags {
 	RX_FLAG_NO_SIGNAL_VAL		= BIT(12),
 	RX_FLAG_HT_GF			= BIT(13),
 	RX_FLAG_AMPDU_DETAILS		= BIT(14),
-	RX_FLAG_AMPDU_REPORT_ZEROLEN	= BIT(15),
-	RX_FLAG_AMPDU_IS_ZEROLEN	= BIT(16),
+	/* bits 15/16 free */
 	RX_FLAG_AMPDU_LAST_KNOWN	= BIT(17),
 	RX_FLAG_AMPDU_IS_LAST		= BIT(18),
 	RX_FLAG_AMPDU_DELIM_CRC_ERROR	= BIT(19),
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 817bf22dad5a..9d95cb8e8e95 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -122,8 +122,7 @@ static inline bool should_drop_frame(struct sk_buff *skb, int present_fcs_len,
 	hdr = (void *)(skb->data + rtap_vendor_space);
 
 	if (status->flag & (RX_FLAG_FAILED_FCS_CRC |
-			    RX_FLAG_FAILED_PLCP_CRC |
-			    RX_FLAG_AMPDU_IS_ZEROLEN))
+			    RX_FLAG_FAILED_PLCP_CRC))
 		return true;
 
 	if (unlikely(skb->len < 16 + present_fcs_len + rtap_vendor_space))
@@ -391,10 +390,6 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 			cpu_to_le32(1 << IEEE80211_RADIOTAP_AMPDU_STATUS);
 		put_unaligned_le32(status->ampdu_reference, pos);
 		pos += 4;
-		if (status->flag & RX_FLAG_AMPDU_REPORT_ZEROLEN)
-			flags |= IEEE80211_RADIOTAP_AMPDU_REPORT_ZEROLEN;
-		if (status->flag & RX_FLAG_AMPDU_IS_ZEROLEN)
-			flags |= IEEE80211_RADIOTAP_AMPDU_IS_ZEROLEN;
 		if (status->flag & RX_FLAG_AMPDU_LAST_KNOWN)
 			flags |= IEEE80211_RADIOTAP_AMPDU_LAST_KNOWN;
 		if (status->flag & RX_FLAG_AMPDU_IS_LAST)
-- 
2.1.4

