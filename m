Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:50436 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726633AbeH2XCE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Aug 2018 19:02:04 -0400
Received: by mail-wm0-f67.google.com with SMTP id s12-v6so6314939wmc.0
        for <linux-wireless@vger.kernel.org>; Wed, 29 Aug 2018 12:03:48 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, nbd@nbd.name, sara.sharon@intel.com
Subject: [PATCH v2] mac80211: do not aggregate frames if max_frags is set to one
Date: Wed, 29 Aug 2018 21:03:25 +0200
Message-Id: <d016cad18842b71c6f06710cbc71cb3d55466a2e.1535567864.git.lorenzo.bianconi@redhat.com> (sfid-20180829_210352_745681_F4DB5BA1)
In-Reply-To: <cover.1535567864.git.lorenzo.bianconi@redhat.com>
References: <cover.1535567864.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do not try to aggregate packets in a A-MSDU frame and add A-MSDU header
on the first packet if max_tx_fragments or max_amsdu_subframes are
set to one

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
Changes since v1:
- rebased on top of mac80211 master branch
- removed ieee80211_amsdu_realloc_pad chunk
---
 net/mac80211/tx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 6a362b2882d3..75646e3fb3d9 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3213,9 +3213,6 @@ static bool ieee80211_amsdu_aggregate(struct ieee80211_sub_if_data *sdata,
 	if (skb->len + head->len > max_amsdu_len)
 		goto out;
 
-	if (!ieee80211_amsdu_prepare_head(sdata, fast_tx, head))
-		goto out;
-
 	nfrags = 1 + skb_shinfo(skb)->nr_frags;
 	nfrags += 1 + skb_shinfo(head)->nr_frags;
 	frag_tail = &skb_shinfo(head)->frag_list;
@@ -3231,6 +3228,9 @@ static bool ieee80211_amsdu_aggregate(struct ieee80211_sub_if_data *sdata,
 	if (max_frags && nfrags > max_frags)
 		goto out;
 
+	if (!ieee80211_amsdu_prepare_head(sdata, fast_tx, head))
+		goto out;
+
 	/*
 	 * Pad out the previous subframe to a multiple of 4 by adding the
 	 * padding to the next one, that's being added. Note that head->len
-- 
2.17.1
