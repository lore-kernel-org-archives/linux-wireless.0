Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:59963 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837Ab0ACXxJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jan 2010 18:53:09 -0500
Received: by fxm25 with SMTP id 25so8329415fxm.21
        for <linux-wireless@vger.kernel.org>; Sun, 03 Jan 2010 15:53:04 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: fix ampdu_action tx_start ssn
Date: Mon, 4 Jan 2010 00:52:56 +0100
Cc: linville@tuxdriver.com
References: <200912312001.54300.chunkeey@googlemail.com>
In-Reply-To: <200912312001.54300.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201001040052.57161.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The start_seq_num is taken from the station's tid_seq[tid].
This is fine, except tid_seq sequence counter is shifted
by 4 bits to accommodate for frame fragmentation.

Both (iwlagn & ath9k) were unaffected by this minor glitch,
because they don't read the *ssn for the AMPDU_TX_START action.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
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
