Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:52078 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803AbaFFRey (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jun 2014 13:34:54 -0400
From: Ken Helias <kenhelias@web.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ken Helias <kenhelias@firemail.de>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 08/13] mac80211: Use list_add_(before|after) macros
Date: Fri,  6 Jun 2014 19:34:27 +0200
Message-Id: <1402076072-4044-8-git-send-email-kenhelias@web.de> (sfid-20140606_193736_058758_53720A7A)
In-Reply-To: <1402076072-4044-1-git-send-email-kenhelias@web.de>
References: <1402076072-4044-1-git-send-email-kenhelias@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ken Helias <kenhelias@firemail.de>

Many places in the code uses list_add_tail/list_add to insert an entry
before/after another entry. This confuses the reader because these are usually
used to add an item to a list_head and not an entry. Better use the self
explaining function name.

Signed-off-by: Ken Helias <kenhelias@firemail.de>
Cc: linux-wireless@vger.kernel.org
---
 net/mac80211/cfg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index d7513a5..110c42b 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2822,7 +2822,7 @@ static int ieee80211_start_roc_work(struct ieee80211_local *local,
 
 				if (new_dur > 0) {
 					/* add right after tmp */
-					list_add(&roc->list, &tmp->list);
+					list_add_after(&roc->list, &tmp->list);
 				} else {
 					list_add_tail(&roc->list,
 						      &tmp->dependents);
-- 
2.0.0

