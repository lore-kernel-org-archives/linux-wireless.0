Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:59412 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753294Ab2LEM1m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 07:27:42 -0500
Message-ID: <50BF3DBB.90000@posedge.com> (sfid-20121205_132746_039401_5037C9FB)
Date: Wed, 05 Dec 2012 17:57:39 +0530
From: Chaitanya <chaitanyatk@posedge.com>
MIME-Version: 1.0
To: johannes@sipsolutions.net
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: fix the multiple warnings for budding chipsets
 without ampdu_action defined
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Warn once should suffice.

Eg: our driver doesn't support the ampdu_action yet, so
seeing a lot of warnings, hence the check for any
new drivers to avoid messing the kernel log.

Changed the mail client to thunder bird to avoid whitespace issues.
Changed the subject and also the signing off to use offical mail.

Signed-off-by: T Krushna Chaitanya <chaitanyatk@posedge.com>
---
net/mac80211/agg-tx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 4152ed1..eb9df22 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -445,7 +445,7 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
 
     trace_api_start_tx_ba_session(pubsta, tid);
 
-    if (WARN_ON(!local->ops->ampdu_action))
+    if (WARN_ON_ONCE(!local->ops->ampdu_action))
         return -EINVAL;
 
     if ((tid >= IEEE80211_NUM_TIDS) ||
