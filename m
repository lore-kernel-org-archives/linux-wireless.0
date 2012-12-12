Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:38633 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab2LLK2N (ORCPT
	<rfc822;groupwise-linux-wireless@vger.kernel.org:0:0>);
	Wed, 12 Dec 2012 05:28:13 -0500
From: "Chen, Chien-Chia" <machen@suse.com>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	users@rt2x00.serialmonkey.com
Subject: [PATCH] mac80211: modify max_nullfunc parameter
Date: Wed, 12 Dec 2012 18:28:19 +0800
Message-Id: <1355308099-18193-1-git-send-email-machen@suse.com> (sfid-20121212_112818_604239_5BEF48FB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chen, Chien-Chia <matt680209@gmail.com>

This parameter default is 2. But it is easy to cause my station 
losing the connection with AP. After I tune it to 20. It improves 
much when using rt2x00 and Linksys WRT160N V3 AP router.

Signed-off-by: Chen, Chien-Chia <matt680209@gmail.com>
---
 net/mac80211/mlme.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 1b7eed2..ef872d7 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -36,7 +36,7 @@
 #define IEEE80211_ASSOC_TIMEOUT (HZ / 5)
 #define IEEE80211_ASSOC_MAX_TRIES 3
 
-static int max_nullfunc_tries = 2;
+static int max_nullfunc_tries = 20;
 module_param(max_nullfunc_tries, int, 0644);
 MODULE_PARM_DESC(max_nullfunc_tries,
 		 "Maximum nullfunc tx tries before disconnecting (reason 4).");
-- 
1.7.7

