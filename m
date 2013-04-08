Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:52794 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762858Ab3DHSHx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Apr 2013 14:07:53 -0400
Received: by mail-pd0-f178.google.com with SMTP id w11so3340615pde.9
        for <linux-wireless@vger.kernel.org>; Mon, 08 Apr 2013 11:07:51 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wirelss <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 1/6] mac80211: unset FC retry bit in mesh fwding path
Date: Mon,  8 Apr 2013 11:06:12 -0700
Message-Id: <1365444377-9959-1-git-send-email-thomas@cozybit.com> (sfid-20130408_200758_043732_81FDE0AC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Otherwise forwarded frames would keep the retry bit set
from the previous link transmission.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/rx.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 5b4492a..5168f89 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2085,6 +2085,7 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 	}
 
 	fwd_hdr =  (struct ieee80211_hdr *) fwd_skb->data;
+	fwd_hdr->frame_control &= ~cpu_to_le16(IEEE80211_FCTL_RETRY);
 	info = IEEE80211_SKB_CB(fwd_skb);
 	memset(info, 0, sizeof(*info));
 	info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING;
-- 
1.7.10.4

