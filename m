Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:42776 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751942AbXB1U6l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 15:58:41 -0500
Received: from localhost (localhost.rutgers.edu [127.0.0.1])
	by annwn13.rutgers.edu (Postfix) with ESMTP id 523B5324074
	for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 15:58:40 -0500 (EST)
Received: from annwn13.rutgers.edu ([127.0.0.1])
	by localhost (annwn13.rutgers.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 25695-08 for <linux-wireless@vger.kernel.org>;
	Wed, 28 Feb 2007 15:58:40 -0500 (EST)
Received: from [192.168.1.103] (resnet-172.23.52.117.resnet.rutgers.edu [172.23.52.117])
	by annwn13.rutgers.edu (Postfix) with ESMTP id 3A69032405D
	for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 15:58:40 -0500 (EST)
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 2/5] d80211: Do not require drivers to implement reset callback
Date: Wed, 28 Feb 2007 15:39:43 -0500
To: linux-wireless@vger.kernel.org
Message-Id: <20070228203943.11473.91707.stgit@magic.sourmilk.net>
In-Reply-To: <20070228203943.11473.95222.stgit@magic.sourmilk.net>
References: <20070228203943.11473.95222.stgit@magic.sourmilk.net>
Content-Type: text/plain;
  charset=utf-8;
  format=fixed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

This prevents drivers from crashing if there is a TX timeout and the reset
callback isn't implemented.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 net/mac80211/ieee80211.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index bbdf928..15344c7 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -2084,7 +2084,7 @@ static void ieee80211_tx_timeout(struct
 
 	printk(KERN_WARNING "%s: resetting interface.\n", dev->name);
 
-	if (local->ops->reset(local_to_hw(local)))
+	if (local->ops->reset && local->ops->reset(local_to_hw(local)))
 		printk(KERN_ERR "%s: failed to reset interface.\n", dev->name);
 	else
 		netif_wake_queue(dev);

