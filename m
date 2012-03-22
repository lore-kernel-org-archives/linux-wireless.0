Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47873 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab2CVHOM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Mar 2012 03:14:12 -0400
From: santosh nayak <santoshprasadnayak@gmail.com>
To: linville@tuxdriver.com
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
	Santosh Nayak <santoshprasadnayak@gmail.com>
Subject: [PATCH 3/3] net: orinoco: add error handling for failed kmalloc().
Date: Thu, 22 Mar 2012 12:42:41 +0530
Message-Id: <1332400361-11176-1-git-send-email-santoshprasadnayak@gmail.com> (sfid-20120322_081421_375590_A8591ED8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Santosh Nayak <santoshprasadnayak@gmail.com>

With flag 'GFP_ATOMIC', probability of allocation failure is more.
Add error handling after kmalloc() call to avoid null dereference.

Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
---
 drivers/net/wireless/orinoco/main.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/orinoco/main.c b/drivers/net/wireless/orinoco/main.c
index dd6c64a..24a768b 100644
--- a/drivers/net/wireless/orinoco/main.c
+++ b/drivers/net/wireless/orinoco/main.c
@@ -1336,6 +1336,10 @@ static void qbuf_scan(struct orinoco_private *priv, void *buf,
 	unsigned long flags;
 
 	sd = kmalloc(sizeof(*sd), GFP_ATOMIC);
+	if (!sd) {
+		printk(KERN_ERR "%s: failed to alloc memory\n", __func__);
+		return;
+	}
 	sd->buf = buf;
 	sd->len = len;
 	sd->type = type;
@@ -1353,6 +1357,10 @@ static void qabort_scan(struct orinoco_private *priv)
 	unsigned long flags;
 
 	sd = kmalloc(sizeof(*sd), GFP_ATOMIC);
+	if (!sd) {
+		printk(KERN_ERR "%s: failed to alloc memory\n", __func__);
+		return;
+	}
 	sd->len = -1; /* Abort */
 
 	spin_lock_irqsave(&priv->scan_lock, flags);
-- 
1.7.4.4

