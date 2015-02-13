Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:49174 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752935AbbBMO6G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2015 09:58:06 -0500
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, nbd@nbd.name,
	thomas@net.t-labs.tu-berlin.de
Subject: [PATCH v2 09/10] mac80211: reduce calculation costs of EWMA
Date: Fri, 13 Feb 2015 15:57:51 +0100
Message-Id: <1423839472-15625-10-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20150213_155819_088585_11A0B77D)
In-Reply-To: <1423839472-15625-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
References: <1423839472-15625-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch reduces the calculation costs of the EWMA macro from
"2x multiplication and 1 addition" down to "1x multiplication and
2x additions". This slightly improves performance depending on the
CPU architecture.

Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
---
 net/mac80211/rc80211_minstrel.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/rc80211_minstrel.h b/net/mac80211/rc80211_minstrel.h
index 6693d8d..38158b0 100644
--- a/net/mac80211/rc80211_minstrel.h
+++ b/net/mac80211/rc80211_minstrel.h
@@ -27,7 +27,12 @@
 static inline int
 minstrel_ewma(int old, int new, int weight)
 {
-	return (new * (EWMA_DIV - weight) + old * weight) / EWMA_DIV;
+	int diff, incr;
+
+	diff = new - old;
+	incr = (EWMA_DIV - weight) * diff / EWMA_DIV;
+
+	return old + incr;
 }
 
 struct minstrel_rate_stats {
-- 
2.2.2

