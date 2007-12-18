Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43356 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753540AbXLRAX6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2007 19:23:58 -0500
Message-Id: <200712180022.lBI0MpTh010069@imap1.linux-foundation.org> (sfid-20071218_002400_882717_90E820B8)
Subject: [patch (for 2.6.24?) 1/4] ieee80211_rate: missed unlock
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, akpm@linux-foundation.org,
	gorcunov@gmail.com, flamingice@sourmilk.net
From: akpm@linux-foundation.org
Date: Mon, 17 Dec 2007 16:22:51 -0800
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Cyrill Gorcunov <gorcunov@gmail.com>

Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/mac80211/ieee80211_rate.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN net/mac80211/ieee80211_rate.c~ieee80211_rate-missed-unlock net/mac80211/ieee80211_rate.c
--- a/net/mac80211/ieee80211_rate.c~ieee80211_rate-missed-unlock
+++ a/net/mac80211/ieee80211_rate.c
@@ -33,6 +33,7 @@ int ieee80211_rate_control_register(stru
 		if (!strcmp(alg->ops->name, ops->name)) {
 			/* don't register an algorithm twice */
 			WARN_ON(1);
+			mutex_unlock(&rate_ctrl_mutex);
 			return -EALREADY;
 		}
 	}
_
