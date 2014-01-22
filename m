Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:56301 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414AbaAVLxx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 06:53:53 -0500
Received: by mail-we0-f180.google.com with SMTP id q59so227674wes.39
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jan 2014 03:53:50 -0800 (PST)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@gmail.com>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: [PATCH] mac80211: send {add,del}ba on AC_VO like other mgmt frames, as per spec
Date: Wed, 22 Jan 2014 12:52:44 +0100
Message-Id: <1390391564-18481-1-git-send-email-karl.beldan@gmail.com> (sfid-20140122_125356_479432_4BD767FD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
---
 net/mac80211/agg-tx.c | 2 +-
 net/mac80211/ht.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 13b7683..ce9633a 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -107,7 +107,7 @@ static void ieee80211_send_addba_request(struct ieee80211_sub_if_data *sdata,
 	mgmt->u.action.u.addba_req.start_seq_num =
 					cpu_to_le16(start_seq_num << 4);
 
-	ieee80211_tx_skb_tid(sdata, skb, tid);
+	ieee80211_tx_skb(sdata, skb);
 }
 
 void ieee80211_send_bar(struct ieee80211_vif *vif, u8 *ra, u16 tid, u16 ssn)
diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index fab7b91..dc3c280 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -375,7 +375,7 @@ void ieee80211_send_delba(struct ieee80211_sub_if_data *sdata,
 	mgmt->u.action.u.delba.params = cpu_to_le16(params);
 	mgmt->u.action.u.delba.reason_code = cpu_to_le16(reason_code);
 
-	ieee80211_tx_skb_tid(sdata, skb, tid);
+	ieee80211_tx_skb(sdata, skb);
 }
 
 void ieee80211_process_delba(struct ieee80211_sub_if_data *sdata,
-- 
1.8.5.1.19.gdaad3aa

