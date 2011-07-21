Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from exchange.solarflare.com ([216.237.3.220]:5345 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab1GURyL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 13:54:11 -0400
Subject: [PATCH net-2.6] ethtool: Allow zero-length register dumps again
From: Ben Hutchings <bhutchings@solarflare.com>
To: David Miller <davem@davemloft.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <1311270409.28569.32.camel@localhost>
References: <20110720091850.32210.2059.stgit@localhost6.localdomain6>
	 <1311161889.1041.11.camel@localhost> <4E26C2DC.8090208@qca.qualcomm.com>
	 <20110720143611.GA18231@tuxdriver.com>
	 <1311270409.28569.32.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Jul 2011 19:54:00 +0200
Message-ID: <1311270840.28569.34.camel@localhost> (sfid-20110721_195417_011929_3E38E2E5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some drivers (ab)use the ethtool_ops::get_regs operation to expose
only a hardware revision ID.  Commit
a77f5db361ed9953b5b749353ea2c7fed2bf8d93 ('ethtool: Allocate register
dump buffer with vmalloc()') had the side-effect of breaking these, as
vmalloc() returns a null pointer for size=0 whereas kmalloc() did not.

For backward-compatibility, allow zero-length dumps again.

Reported-by: Kalle Valo <kvalo@qca.qualcomm.com>
Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Cc: stable@kernel.org [2.6.37+]
---
This is compile-tested only.  I'm on vacation, damnit.

Ben.

 net/core/ethtool.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index fd14116..4fb7704 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -1227,7 +1227,7 @@ static int ethtool_get_regs(struct net_device *dev, char __user *useraddr)
 		regs.len = reglen;
 
 	regbuf = vzalloc(reglen);
-	if (!regbuf)
+	if (reglen && !regbuf)
 		return -ENOMEM;
 
 	ops->get_regs(dev, &regs, regbuf);
@@ -1236,7 +1236,7 @@ static int ethtool_get_regs(struct net_device *dev, char __user *useraddr)
 	if (copy_to_user(useraddr, &regs, sizeof(regs)))
 		goto out;
 	useraddr += offsetof(struct ethtool_regs, data);
-	if (copy_to_user(useraddr, regbuf, regs.len))
+	if (regbuf && copy_to_user(useraddr, regbuf, regs.len))
 		goto out;
 	ret = 0;
 
-- 
1.7.5.4


-- 
Ben Hutchings, Senior Software Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

