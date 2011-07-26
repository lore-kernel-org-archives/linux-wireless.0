Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44772 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab1GZKSn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jul 2011 06:18:43 -0400
Received: by ewy4 with SMTP id 4so266516ewy.19
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jul 2011 03:18:42 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH 2/2] mac80211: Don't use a buf_size=0 in ADDBA requests
Date: Tue, 26 Jul 2011 12:18:28 +0200
Message-Id: <1311675508-29005-2-git-send-email-helmut.schaa@googlemail.com> (sfid-20110726_121846_792692_2D742EB9)
In-Reply-To: <1311675508-29005-1-git-send-email-helmut.schaa@googlemail.com>
References: <1311675508-29005-1-git-send-email-helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to 802.11-2007, 7.3.1.14 it is compliant to use a buf_size of
0 in ADDBA requests. But some devices (AVM Fritz Stick N) arn't able to
handle that correctly and will reply with an ADDBA reponse with a
buf_size of 0 which in turn will disallow BA sessions for these
devices.

To work around this problem, if the hardware doesn't specify an upper
limit for the number of subframes in an AMPDU send the maximum 0x40 by
default in ADDBA requests.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 net/mac80211/agg-tx.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index b7075f3..13dbd00 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -345,7 +345,9 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
 	/* send AddBA request */
 	ieee80211_send_addba_request(sdata, sta->sta.addr, tid,
 				     tid_tx->dialog_token, start_seq_num,
-				     local->hw.max_tx_aggregation_subframes,
+				     local->hw.max_tx_aggregation_subframes ?
+				     local->hw.max_tx_aggregation_subframes :
+				     0x40,
 				     tid_tx->timeout);
 }
 
-- 
1.7.3.4

