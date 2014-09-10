Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:33094 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865AbaIJUPA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 16:15:00 -0400
Subject: [PATCH net-next] mac80211: Check correct skb for shared states
 before freeing original
To: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
From: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: davem@davemloft.net, linville@tuxdriver.com
Date: Wed, 10 Sep 2014 16:06:23 -0400
Message-ID: <20140910200442.15961.84466.stgit@ahduyck-bv4.jf.intel.com> (sfid-20140910_221517_589456_8B140F20)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The code for cloning the skb for an acknowledgement was checking to see if
the cloned skb was shared and if it was it was then freeing the original
skb.  Since a clone should never really be shared I suspect that the
intention was to avoid freeing the clone if the original was shared.  As
such I am updating the code so that if the original is shared we free the
original and use the clone.  This avoids unnecessary work in the next
section where we would be cloning the skb if the original is shared.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
---
 net/mac80211/tx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 925c39f..e527cd3 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2087,7 +2087,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 			if (id >= 0) {
 				info_id = id;
 				info_flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
-			} else if (skb_shared(skb)) {
+			} else if (skb_shared(orig_skb)) {
 				kfree_skb(orig_skb);
 			} else {
 				kfree_skb(skb);

