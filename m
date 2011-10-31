Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45121 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051Ab1JaHMy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Oct 2011 03:12:54 -0400
Received: by ywf7 with SMTP id 7so781555ywf.19
        for <linux-wireless@vger.kernel.org>; Mon, 31 Oct 2011 00:12:53 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Thomas Pedersen <thomas@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH v2 3/4] mac80211: check if frame is really part of this BA
Date: Mon, 31 Oct 2011 00:12:40 -0700
Message-Id: <1320045161-16144-3-git-send-email-thomas@cozybit.com> (sfid-20111031_081258_313719_0E4D841B)
In-Reply-To: <1320045161-16144-1-git-send-email-thomas@cozybit.com>
References: <1320045161-16144-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There was an an implicit assumption that any QoS data frame received
from a STA/TID with an active BA session was sent to this vif as part of
a BA.  This is not true if IFF_PROMISC is enabled and the frame was
destined for a different peer, for example. Don't treat these frames as
part of a BA from the sending STA.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/rx.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index b9d3236..0995685 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -777,6 +777,10 @@ static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx)
 	      (ack_policy == IEEE80211_QOS_CTL_ACK_POLICY_NORMAL)))
 		goto dont_reorder;
 
+	/* not actually part of this BA session */
+	if (compare_ether_addr(hdr->addr1, rx->sdata->vif.addr) != 0)
+		goto dont_reorder;
+
 	/* new, potentially un-ordered, ampdu frame - process it */
 
 	/* reset session timer */
-- 
1.7.5.4

