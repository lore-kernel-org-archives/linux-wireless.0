Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40086 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab1KDELb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 00:11:31 -0400
Received: by mail-yw0-f46.google.com with SMTP id 7so2077492ywf.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 Nov 2011 21:11:30 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Thomas Pedersen <thomas@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH v4 3/4] mac80211: check if frame is really part of this BA
Date: Thu,  3 Nov 2011 21:11:12 -0700
Message-Id: <1320379873-30884-3-git-send-email-thomas@cozybit.com> (sfid-20111104_051135_363003_C75F5E1E)
In-Reply-To: <1320379873-30884-1-git-send-email-thomas@cozybit.com>
References: <1320379873-30884-1-git-send-email-thomas@cozybit.com>
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

