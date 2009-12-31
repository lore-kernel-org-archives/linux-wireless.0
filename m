Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:63373 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbZLaTCF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Dec 2009 14:02:05 -0500
Received: by fxm25 with SMTP id 25so6875054fxm.21
        for <linux-wireless@vger.kernel.org>; Thu, 31 Dec 2009 11:02:02 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC] mac80211: fix AMPDU_TX_START ssn
Date: Thu, 31 Dec 2009 20:01:54 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <200912312001.54300.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The start_seq_num is taken from the station's tid_seq[tid].
(agg-tx.c / line 304). This would be fine, but there is a
small pitfall that we know too well: tid_seq is meant
to produce the sequence, which can be insert into an
IEEE 802.11 frame sequence_control field without
the 4 bit left shift (which is usually necessary to
accommodate for frame fragmenting).

So tid_seq is _increased_ in 0x10 steps, but some of
the code in agg-tx.c doesn't know about that, e.g:

ieee80211_send_addba_request: (line 91)
	mgmt->u.action.u.addba_req.start_seq_num =
		cpu_to_le16(start_seq_num << 4);

Now, ADDBA recipient certainly gets a wrong BA starting
point and may decide to drop some of the incoming 
aggregated frames, since it might think that they
were already too old.
---
Hmm, I'm not sure what to do with the debug_sta.c
counters? Obviously, they are now >> 4 as well,
but on the other hand just like the tid_rx side
always was...

Note: By the looks of it: iwlagn/ath9k are probably
unaffected, but carl9170 was: so no need for stable. 
---
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index ceda366..5aa8f4a 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -301,7 +301,7 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid)
 	 * call back right away, it must see that the flow has begun */
 	*state |= HT_ADDBA_REQUESTED_MSK;
 
-	start_seq_num = sta->tid_seq[tid];
+	start_seq_num = sta->tid_seq[tid] >> 4;
 
 	ret = drv_ampdu_action(local, sdata, IEEE80211_AMPDU_TX_START,
 			       pubsta, tid, &start_seq_num);
