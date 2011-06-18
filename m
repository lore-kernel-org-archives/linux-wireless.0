Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49165 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab1FRSp4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jun 2011 14:45:56 -0400
Received: by wwe5 with SMTP id 5so1391590wwe.1
        for <linux-wireless@vger.kernel.org>; Sat, 18 Jun 2011 11:45:55 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH] mac80211: fix rx->key NULL dereference during mic failure
Date: Sat, 18 Jun 2011 21:45:49 +0300
Message-Id: <1308422749-16939-1-git-send-email-arik@wizery.com> (sfid-20110618_204559_893731_C7BC5AC8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sometimes when reporting a MIC failure rx->key may be unset. This
code path is hit when receiving a packet meant for a multicast
address, and decryption is performed in HW.

Fortunately, the failing key_idx is not used for anything up to
(and including) usermode, so we allow ourselves to set a bogus one
when a key cannot be retrieved.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 net/mac80211/wpa.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 9dc3b5f..c6dafc1 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -154,7 +154,8 @@ update_iv:
 	return RX_CONTINUE;
 
 mic_fail:
-	mac80211_ev_michael_mic_failure(rx->sdata, rx->key->conf.keyidx,
+	mac80211_ev_michael_mic_failure(rx->sdata,
+					rx->key ? rx->key->conf.keyidx : -1,
 					(void *) skb->data, NULL, GFP_ATOMIC);
 	return RX_DROP_UNUSABLE;
 }
-- 
1.7.4.1

