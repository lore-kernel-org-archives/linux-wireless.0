Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44882 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117Ab2K0Rbq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 12:31:46 -0500
Date: Tue, 27 Nov 2012 20:31:19 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] mac80211: silence NULL dereference warning
Message-ID: <20121127173119.GC1059@elgon.mountain> (sfid-20121127_183150_557638_DD2B4FD2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Smatch complains that we could dereference skb later in the function.
It's probably unlikely, but we may as well return here and avoid it.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index ec15a49..d923058 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -49,7 +49,7 @@ static struct sk_buff *remove_monitor_info(struct ieee80211_local *local,
 			/* driver bug */
 			WARN_ON(1);
 			dev_kfree_skb(skb);
-			skb = NULL;
+			return NULL;
 		}
 	}
 
