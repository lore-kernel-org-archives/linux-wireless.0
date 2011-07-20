Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:44521 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab1GTJS7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2011 05:18:59 -0400
Subject: [PATCH] ethtool: fix ethtool_get_regs() to work with zero length
	registers
To: netdev@vger.kernel.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 20 Jul 2011 12:18:50 +0300
Message-ID: <20110720091850.32210.2059.stgit@localhost6.localdomain6> (sfid-20110720_111902_510915_C8C3333F)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cfg80211 exports zero length register size as it currently only uses
struct ethtool_regs.version to export struct wiphy.hw_version. But the
problem is that ethtool_get_regs() assumes that the driver (cfg80211 in this
case) always has non-zero length for registers. With cfg80211
it would always fail and return -ENOMEM to user space.

Fix this by checking the register length from the driver and exporting
struct ethtool_regs to user space if the length is zero.

With this patch it's possible to get the hardware id from wireless drivers.
Tested with wl12xx and ath6kl.

Tested-by: Gery Kahn <geryk@ti.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 net/core/ethtool.c |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index fd14116..6f073f4 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -1213,7 +1213,7 @@ static int ethtool_get_regs(struct net_device *dev, char __user *useraddr)
 {
 	struct ethtool_regs regs;
 	const struct ethtool_ops *ops = dev->ethtool_ops;
-	void *regbuf;
+	void *regbuf = NULL;
 	int reglen, ret;
 
 	if (!ops->get_regs || !ops->get_regs_len)
@@ -1226,18 +1226,24 @@ static int ethtool_get_regs(struct net_device *dev, char __user *useraddr)
 	if (regs.len > reglen)
 		regs.len = reglen;
 
-	regbuf = vzalloc(reglen);
-	if (!regbuf)
-		return -ENOMEM;
+	if (reglen > 0) {
+		regbuf = vzalloc(reglen);
+		if (!regbuf)
+			return -ENOMEM;
+	}
 
 	ops->get_regs(dev, &regs, regbuf);
 
 	ret = -EFAULT;
 	if (copy_to_user(useraddr, &regs, sizeof(regs)))
 		goto out;
-	useraddr += offsetof(struct ethtool_regs, data);
-	if (copy_to_user(useraddr, regbuf, regs.len))
-		goto out;
+
+	if (regs.len > 0) {
+		useraddr += offsetof(struct ethtool_regs, data);
+		if (copy_to_user(useraddr, regbuf, regs.len))
+			goto out;
+	}
+
 	ret = 0;
 
  out:

