Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.sigma-star.at ([95.130.255.111]:14388 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbbDLWwu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Apr 2015 18:52:50 -0400
From: Richard Weinberger <richard@nod.at>
To: netdev@vger.kernel.org
Cc: linux-wireless@vger.kernel.org, coreteam@netfilter.org,
	netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
	sameo@linux.intel.com, aloisio.almeida@openbossa.org,
	lauro.venancio@openbossa.org, davem@davemloft.net,
	kadlec@blackhole.kfki.hu, kaber@trash.net, pablo@netfilter.org,
	Richard Weinberger <richard@nod.at>
Subject: [PATCH 4/5 v4] netfilter: Fix format string of nfnetlink_queue proc file
Date: Mon, 13 Apr 2015 00:52:38 +0200
Message-Id: <1428879159-19237-4-git-send-email-richard@nod.at> (sfid-20150413_005431_714085_62377450)
In-Reply-To: <1428879159-19237-1-git-send-email-richard@nod.at>
References: <1428879159-19237-1-git-send-email-richard@nod.at>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The printed values are all of type unsigned integer, therefore use
%u instead of %d. Otherwise an user can face negative values.

Fixes:
$ cat /proc/net/netfilter/nfnetlink_queue
    0  29508   278 2 65531     0 2004213241 -2129885586  1
    1 -27747     0 2 65531     0     0        0  1
    2 -27748     0 2 65531     0     0        0  1

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 net/netfilter/nfnetlink_queue_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_queue_core.c b/net/netfilter/nfnetlink_queue_core.c
index 49267f8..0b98c74 100644
--- a/net/netfilter/nfnetlink_queue_core.c
+++ b/net/netfilter/nfnetlink_queue_core.c
@@ -1251,7 +1251,7 @@ static int seq_show(struct seq_file *s, void *v)
 {
 	const struct nfqnl_instance *inst = v;
 
-	seq_printf(s, "%5d %6d %5d %1d %5d %5d %5d %8d %2d\n",
+	seq_printf(s, "%5u %6u %5u %1u %5u %5u %5u %8u %2d\n",
 		   inst->queue_num,
 		   inst->peer_portid, inst->queue_total,
 		   inst->copy_mode, inst->copy_range,
-- 
1.8.4.5

