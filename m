Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from host.76.145.23.62.rev.coltfrance.com ([62.23.145.76]:55821 "EHLO
	proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506AbcDZIGs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 04:06:48 -0400
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, sd@queasysnail.net, johannes@sipsolutions.net,
	kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
	jack@suse.com, linux-kernel@vger.kernel.org, pshelar@nicira.com,
	dev@openvswitch.org, jhs@mojatatu.com, philipp.reisner@linbit.com,
	lars.ellenberg@linbit.com, drbd-dev@lists.linbit.com,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH net-next 6/8] rtnl: align nlattr properly when needed
Date: Tue, 26 Apr 2016 10:06:16 +0200
Message-Id: <1461657978-13360-7-git-send-email-nicolas.dichtel@6wind.com> (sfid-20160426_100742_381647_4CB6B130)
In-Reply-To: <1461657978-13360-1-git-send-email-nicolas.dichtel@6wind.com>
References: <1461657978-13360-1-git-send-email-nicolas.dichtel@6wind.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 net/core/rtnetlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 9efc1f34ef3b..5503dfe6a050 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -876,7 +876,7 @@ static noinline size_t if_nlmsg_size(const struct net_device *dev,
 	       + nla_total_size(IFNAMSIZ) /* IFLA_IFNAME */
 	       + nla_total_size(IFALIASZ) /* IFLA_IFALIAS */
 	       + nla_total_size(IFNAMSIZ) /* IFLA_QDISC */
-	       + nla_total_size(sizeof(struct rtnl_link_ifmap))
+	       + nla_total_size_64bit(sizeof(struct rtnl_link_ifmap))
 	       + nla_total_size(sizeof(struct rtnl_link_stats))
 	       + nla_total_size_64bit(sizeof(struct rtnl_link_stats64))
 	       + nla_total_size(MAX_ADDR_LEN) /* IFLA_ADDRESS */
@@ -1181,7 +1181,7 @@ static int rtnl_fill_link_ifmap(struct sk_buff *skb, struct net_device *dev)
 		.dma         = dev->dma,
 		.port        = dev->if_port,
 	};
-	if (nla_put(skb, IFLA_MAP, sizeof(map), &map))
+	if (nla_put_64bit(skb, IFLA_MAP, sizeof(map), &map, IFLA_PAD))
 		return -EMSGSIZE;
 
 	return 0;
-- 
2.8.1

