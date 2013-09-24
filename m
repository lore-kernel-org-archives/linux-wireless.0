Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:45401 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab3IXCcs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Sep 2013 22:32:48 -0400
Received: by mail-pd0-f179.google.com with SMTP id v10so4016533pde.10
        for <linux-wireless@vger.kernel.org>; Mon, 23 Sep 2013 19:32:48 -0700 (PDT)
From: Fred Zhou <fred.zy@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Fred Zhou <fred.zy@gmail.com>
Subject: [PATCH] mac80211: use exact-size allocation for authentication frame
Date: Tue, 24 Sep 2013 10:33:01 +0800
Message-Id: <1379989981-3440-1-git-send-email-fred.zy@gmail.com> (sfid-20130924_043251_882672_F0ECD537)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The authentication frame has a fixied size of 30 bytes
(including header, algo num, trans seq num, and status)
followed by a variable challenge text.
Allocate using exact size, instead of over-allocation
by sizeof(ieee80211_mgmt).

Signed-off-by: Fred Zhou <fred.zy@gmail.com>
---
 net/mac80211/util.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index e1b34a1..674ab12 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1083,9 +1083,10 @@ void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
 	int err;
-
+
+	/* 30 = header + auth_algo + auth_transaction + status_code */
 	skb = dev_alloc_skb(local->hw.extra_tx_headroom +
-			    sizeof(*mgmt) + 6 + extra_len);
+			    30 + extra_len);
 	if (!skb)
 		return;
 
-- 
1.7.9.5

