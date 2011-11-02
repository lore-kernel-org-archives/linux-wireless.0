Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:44446 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932194Ab1KBT1i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Nov 2011 15:27:38 -0400
Received: by qabj40 with SMTP id j40so483600qab.19
        for <linux-wireless@vger.kernel.org>; Wed, 02 Nov 2011 12:27:37 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Thomas Pedersen <thomas@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH v3 3/4] mac80211: check if frame is really part of this BA
Date: Wed,  2 Nov 2011 12:27:26 -0700
Message-Id: <1320262047-5389-3-git-send-email-thomas@cozybit.com> (sfid-20111102_202743_469659_FEBC585A)
In-Reply-To: <1320262047-5389-1-git-send-email-thomas@cozybit.com>
References: <1320262047-5389-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There was an an implicit assumption that any QoS data frame received
from a STA/TID with an active BA session was sent to this vif as part of
a BA.  This is not true if IFF_PROMISC is enabled and the frame was
destined for a different peer, for example. Don't treat these frames as
part of a BA from the sending STA.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
v3: use RX_RA_MATCH instead of checking the address directly (Johannes)
 net/mac80211/rx.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index bbe7b50..45ace14 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -744,6 +744,7 @@ static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx)
 	struct ieee80211_local *local = rx->local;
 	struct ieee80211_hw *hw = &local->hw;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	struct sta_info *sta = rx->sta;
 	struct tid_ampdu_rx *tid_agg_rx;
 	u16 sc;
@@ -777,6 +778,10 @@ static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx)
 	    ack_policy != IEEE80211_QOS_CTL_ACK_POLICY_NORMAL)
 		goto dont_reorder;
 
+	/* not actually part of this BA session */
+	if (!(status->rx_flags & IEEE80211_RX_RA_MATCH))
+		goto dont_reorder;
+
 	/* new, potentially un-ordered, ampdu frame - process it */
 
 	/* reset session timer */
-- 
1.7.5.4

