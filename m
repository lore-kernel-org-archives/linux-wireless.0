Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from host.76.145.23.62.rev.coltfrance.com ([62.23.145.76]:55819 "EHLO
	proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468AbcDZIGo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 04:06:44 -0400
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, sd@queasysnail.net, johannes@sipsolutions.net,
	kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
	jack@suse.com, linux-kernel@vger.kernel.org, pshelar@nicira.com,
	dev@openvswitch.org, jhs@mojatatu.com, philipp.reisner@linbit.com,
	lars.ellenberg@linbit.com, drbd-dev@lists.linbit.com,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH net-next 7/8] neigh: align nlattr properly when needed
Date: Tue, 26 Apr 2016 10:06:17 +0200
Message-Id: <1461657978-13360-8-git-send-email-nicolas.dichtel@6wind.com> (sfid-20160426_100819_033388_45A8DBE5)
In-Reply-To: <1461657978-13360-1-git-send-email-nicolas.dichtel@6wind.com>
References: <1461657978-13360-1-git-send-email-nicolas.dichtel@6wind.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 net/core/neighbour.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 6a395d440228..29dd8cc22bbf 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1857,7 +1857,8 @@ static int neightbl_fill_info(struct sk_buff *skb, struct neigh_table *tbl,
 			ndst.ndts_table_fulls		+= st->table_fulls;
 		}
 
-		if (nla_put(skb, NDTA_STATS, sizeof(ndst), &ndst))
+		if (nla_put_64bit(skb, NDTA_STATS, sizeof(ndst), &ndst,
+				  NDTA_PAD))
 			goto nla_put_failure;
 	}
 
-- 
2.8.1

