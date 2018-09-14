Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf1-f68.google.com ([209.85.167.68]:34684 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726902AbeINVPw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Sep 2018 17:15:52 -0400
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: johannes@sipsolutions.net, davem@davemloft.net,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [PATCH] mac80211: fix issue with possible txq NULL pointer
Date: Fri, 14 Sep 2018 18:00:34 +0200
Message-Id: <20180914160034.2753-1-erik.stromdahl@gmail.com> (sfid-20180914_180055_775792_DFAEAF7B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drivers that do not have the BUFF_MMPDU_TXQ flag set will not have a
TXQ for the special TID = 16.

In this case, the last member in the *struct ieee80211_sta* txq array
will be NULL.

We must check this in order not to get a NULL pointer dereference when
iterating the txq array.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 net/mac80211/util.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 36a3c2ada515..ef5d1f60a63b 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -264,6 +264,9 @@ static void __ieee80211_wake_txqs(struct ieee80211_sub_if_data *sdata, int ac)
 		for (i = 0; i < ARRAY_SIZE(sta->sta.txq); i++) {
 			struct ieee80211_txq *txq = sta->sta.txq[i];
 
+			if (!txq)
+				continue;
+
 			txqi = to_txq_info(txq);
 
 			if (ac != txq->ac)
-- 
2.18.0
