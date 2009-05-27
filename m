Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out01.mta.xmission.com ([166.70.13.231]:60972 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762989AbZE0Msj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2009 08:48:39 -0400
From: Jeff Hansen <x@jeffhansen.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jouni.malinen@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	Jeff Hansen <x@jeffhansen.com>
Date: Wed, 27 May 2009 12:48:30 +0000
Message-Id: <1243428510-14931-4-git-send-email-x@jeffhansen.com>
In-Reply-To: <1243428510-14931-1-git-send-email-x@jeffhansen.com>
References: <1243428510-14931-1-git-send-email-x@jeffhansen.com>
Subject: [PATCH 4/4] mac80211: Fix typos in "set default QoS values according to spec"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some of the acwmin and acwmax values were backwards in the original patch,
which cut TX performance (on my device at least) down from ~25-30Mbps to
2Mbps.  Performance is back up after this commit.

Signed-off-by: Jeff Hansen <x@jeffhansen.com>
---
 net/mac80211/util.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 949d857..31284c9 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -657,15 +657,15 @@ void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata)
 
 		switch (queue) {
 		case 3: /* AC_BK */
-			qparam.cw_max = aCWmin;
-			qparam.cw_min = aCWmax;
+			qparam.cw_max = aCWmax;
+			qparam.cw_min = aCWmin;
 			qparam.txop = 0;
 			qparam.aifs = 7;
 			break;
 		default: /* never happens but let's not leave undefined */
 		case 2: /* AC_BE */
-			qparam.cw_max = aCWmin;
-			qparam.cw_min = aCWmax;
+			qparam.cw_max = aCWmax;
+			qparam.cw_min = aCWmin;
 			qparam.txop = 0;
 			qparam.aifs = 3;
 			break;
-- 
1.6.0.4

