Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:23006 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964890AbbLHOGc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2015 09:06:32 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3/9] mac80211: add flag for duplication check
Date: Tue,  8 Dec 2015 16:04:33 +0200
Message-Id: <1449583479-26658-4-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151208_150638_723337_AC6E4D45)
In-Reply-To: <1449583479-26658-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1449583479-26658-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Add an option for driver to check for packet duplication
by itself.
This is needed for example by the iwlwifi driver which
parallelizes the RX path and does the duplcation check
per queue.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/mac80211.h | 2 +-
 net/mac80211/rx.c      | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 71be30d..f4cbad4 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1063,7 +1063,7 @@ enum mac80211_rx_flags {
 	RX_FLAG_HT_GF			= BIT(13),
 	RX_FLAG_AMPDU_DETAILS		= BIT(14),
 	RX_FLAG_PN_VALIDATED		= BIT(15),
-	/* bit 16 free */
+	RX_FLAG_DUP_VALIDATED		= BIT(16),
 	RX_FLAG_AMPDU_LAST_KNOWN	= BIT(17),
 	RX_FLAG_AMPDU_IS_LAST		= BIT(18),
 	RX_FLAG_AMPDU_DELIM_CRC_ERROR	= BIT(19),
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index c4198d48..901c72b 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1099,6 +1099,9 @@ ieee80211_rx_h_check_dup(struct ieee80211_rx_data *rx)
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
 
+	if (status->flag & RX_FLAG_DUP_VALIDATED)
+		return RX_CONTINUE;
+
 	/*
 	 * Drop duplicate 802.11 retransmissions
 	 * (IEEE 802.11-2012: 9.3.2.10 "Duplicate detection and recovery")
-- 
2.5.0

