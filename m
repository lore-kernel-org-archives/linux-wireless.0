Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.190]:56480 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbXLCTXB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2007 14:23:01 -0500
Received: by mu-out-0910.google.com with SMTP id i10so1531995mue
        for <linux-wireless@vger.kernel.org>; Mon, 03 Dec 2007 11:22:58 -0800 (PST)
Date: Mon, 3 Dec 2007 22:22:49 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Michael Wu <flamingice@sourmilk.net>
Cc: LKWL <linux-wireless@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] NET: mac80211 - fix inappropriate memory freeing
Message-ID: <20071203192249.GC7328@cvg> (sfid-20071203_192308_945614_AE5B4A0C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch does fix inappropriate memory freeing in case
of requested rate_control_ops was not found. In this case
the list head entity is going to be accidently wasted.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
 net/mac80211/ieee80211_rate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/ieee80211_rate.c b/net/mac80211/ieee80211_rate.c
index 3260a4a..c3f2783 100644
--- a/net/mac80211/ieee80211_rate.c
+++ b/net/mac80211/ieee80211_rate.c
@@ -60,11 +60,11 @@ void ieee80211_rate_control_unregister(struct rate_control_ops *ops)
 	list_for_each_entry(alg, &rate_ctrl_algs, list) {
 		if (alg->ops == ops) {
 			list_del(&alg->list);
+			kfree(alg);
 			break;
 		}
 	}
 	mutex_unlock(&rate_ctrl_mutex);
-	kfree(alg);
 }
 EXPORT_SYMBOL(ieee80211_rate_control_unregister);
 
-- 
1.5.3.5

