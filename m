Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:44298 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755874Ab0LNHpU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Dec 2010 02:45:20 -0500
Received: by pva4 with SMTP id 4so52206pva.19
        for <linux-wireless@vger.kernel.org>; Mon, 13 Dec 2010 23:45:20 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19719.8288.322475.954293@gargle.gargle.HOWL>
Date: Tue, 14 Dec 2010 13:14:32 +0530
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: [RFC] mac80211: Change BA timeout
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The BlockAck session timout value is currently an arbitrary 5000.
This results in BA sessions being created and torn down incessantly
when mac80211 is used with a driver (say ath9k) in AP mode.

The 802.11 standard doesn't specify any default value for the timeout field.
And there is no benefit to be gained by tearing down BA sessions and
recreating them. The current value of 5000 doesn't cause any problems,
but it is hard to find an AP/STA in the field that uses a non-zero timeout.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 net/mac80211/agg-tx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index d4679b2..e5e6311 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -342,7 +342,7 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
 	/* send AddBA request */
 	ieee80211_send_addba_request(sdata, sta->sta.addr, tid,
 				     tid_tx->dialog_token, start_seq_num,
-				     0x40, 5000);
+				     0x40, 0);
 }
 
 int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid)
-- 
1.7.3.3

