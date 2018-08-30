Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33467 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbeHaDIx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Aug 2018 23:08:53 -0400
Received: by mail-wr1-f67.google.com with SMTP id v90-v6so9505372wrc.0
        for <linux-wireless@vger.kernel.org>; Thu, 30 Aug 2018 16:04:22 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: fix an off-by-one issue in A-MSDU max_subframe computation
Date: Fri, 31 Aug 2018 01:04:13 +0200
Message-Id: <98a581c601ff1974ca4365817596453fd442e1f5.1535670110.git.lorenzo.bianconi@redhat.com> (sfid-20180831_010427_034197_9374EF9B)
In-Reply-To: <cover.1535670110.git.lorenzo.bianconi@redhat.com>
References: <cover.1535670110.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Initialize 'n' to 2 in order to take into account also the first
packet in the estimation of max_subframe limit for a given A-MSDU
since frag_tail pointer is NULL when ieee80211_amsdu_aggregate
routine analyzes the second frame.

Fixes: 6e0456b54545 ("mac80211: add A-MSDU tx support")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 net/mac80211/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 6ca0865de945..9b3b069e418a 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3174,7 +3174,7 @@ static bool ieee80211_amsdu_aggregate(struct ieee80211_sub_if_data *sdata,
 	void *data;
 	bool ret = false;
 	unsigned int orig_len;
-	int n = 1, nfrags, pad = 0;
+	int n = 2, nfrags, pad = 0;
 	u16 hdrlen;
 
 	if (!ieee80211_hw_check(&local->hw, TX_AMSDU))
-- 
2.17.1
