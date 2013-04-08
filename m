Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:53284 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934675Ab3DHSHy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Apr 2013 14:07:54 -0400
Received: by mail-pa0-f41.google.com with SMTP id kx1so3394622pab.0
        for <linux-wireless@vger.kernel.org>; Mon, 08 Apr 2013 11:07:53 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wirelss <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 2/6] mac80211: exclude multicast frames from BA accounting
Date: Mon,  8 Apr 2013 11:06:13 -0700
Message-Id: <1365444377-9959-2-git-send-email-thomas@cozybit.com> (sfid-20130408_200759_770529_AB0070D9)
In-Reply-To: <1365444377-9959-1-git-send-email-thomas@cozybit.com>
References: <1365444377-9959-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since multicast aggregation is not currently supported by
mac80211, we can safely ignore them when reordering
aggregate MPDUs.

This fixes a bug where the expected sequence number might
be reset after processing a multicast frame from a STA
with an established aggregation session. The expected
sequence number would then be incorrect and all aggregated
frames until the sequence number rolled over would be
dropped.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/rx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 5168f89..cb55ef0 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -864,7 +864,8 @@ static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx,
 	u16 sc;
 	u8 tid, ack_policy;
 
-	if (!ieee80211_is_data_qos(hdr->frame_control))
+	if (!ieee80211_is_data_qos(hdr->frame_control) ||
+	    is_multicast_ether_addr(hdr->addr1))
 		goto dont_reorder;
 
 	/*
-- 
1.7.10.4

