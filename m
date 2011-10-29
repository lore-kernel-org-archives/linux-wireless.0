Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:44790 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab1J2FFm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Oct 2011 01:05:42 -0400
Received: by mail-pz0-f42.google.com with SMTP id 36so12352067pzk.1
        for <linux-wireless@vger.kernel.org>; Fri, 28 Oct 2011 22:05:41 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: devel@lists.open80211s.org, Thomas Pedersen <thomas@cozybit.com>,
	johannes@sipsolutions.net, linville@tuxdriver.com
Subject: [PATCH 3/4] mac80211: check if frame is really part of this BA
Date: Fri, 28 Oct 2011 22:05:31 -0700
Message-Id: <1319864732-11286-3-git-send-email-thomas@cozybit.com> (sfid-20111029_070546_551773_F3A9EE76)
In-Reply-To: <1319864732-11286-1-git-send-email-thomas@cozybit.com>
References: <1319864732-11286-1-git-send-email-thomas@cozybit.com>
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
index ee9e71b..ad39216 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -776,6 +776,10 @@ static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx)
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

