Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54115 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120AbaAaXdh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jan 2014 18:33:37 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: j@w1.fi, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix fragmentation code, particularly for encryption
Date: Sat,  1 Feb 2014 00:33:29 +0100
Message-Id: <1391211209-14284-1-git-send-email-johannes@sipsolutions.net> (sfid-20140201_003340_747333_16673024)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The "new" fragmentation code (since my rewrite almost 5 years ago)
erroneously sets skb->len rather than using skb_trim() to adjust
the length of the first fragment after copying out all the others.
This leaves the skb tail pointer pointing to after where the data
originally ended, and thus causes the encryption MIC to be written
at that point, rather than where it belongs: immediately after the
data.

The impact of this is that if software encryption is done, then
 a) encryption doesn't work for the first fragment, the connection
    becomes unusable as the first fragment will never be properly
    verified at the receiver, the MIC is practically guaranteed to
    be wrong
 b) we leak up to 8 bytes of plaintext (!) of the packet out into
    the air

This is only mitigated by the fact that many devices are capable
of doing encryption in hardware, in which case this can't happen
as the tail pointer is irrelevant in that case. Additionally,
fragmentation is not used very frequently and would normally have
to be configured manually.

Fix this by using skb_trim() properly.

Cc: stable@vger.kernel.org
Fixes: 2de8e0d999b8 ("mac80211: rewrite fragmentation")
Reported-by: Jouni Malinen <j@w1.fi>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index a6ee535..6403c2e 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -871,7 +871,7 @@ static int ieee80211_fragment(struct ieee80211_tx_data *tx,
 	}
 
 	/* adjust first fragment's length */
-	skb->len = hdrlen + per_fragm;
+	skb_trim(skb, hdrlen + per_fragm);
 	return 0;
 }
 
-- 
1.8.5.2

