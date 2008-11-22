Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:59435 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755061AbYKVKhw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Nov 2008 05:37:52 -0500
Received: by ey-out-2122.google.com with SMTP id 6so531313eyi.37
        for <linux-wireless@vger.kernel.org>; Sat, 22 Nov 2008 02:37:51 -0800 (PST)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Cc: arvidjaar@mail.ru, David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 3/4] orinoco: Resume spectrum_cs in the same way as orinoco_cs
Date: Sat, 22 Nov 2008 10:37:27 +0000
Message-Id: <1227350248-8917-4-git-send-email-kilroyd@googlemail.com> (sfid-20081122_113754_414158_90E1D53A)
In-Reply-To: <1227350248-8917-3-git-send-email-kilroyd@googlemail.com>
References: <1227350248-8917-1-git-send-email-kilroyd@googlemail.com>
 <1227350248-8917-2-git-send-email-kilroyd@googlemail.com>
 <1227350248-8917-3-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Retrieval of external firmware has been resolved, and should work with
the standard orinoco resume algorithm.

This fixes an issue where priv->hw_unavailable indicates the card is
ready when firmware has not been loaded.

Signed-off by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/spectrum_cs.c |   21 ++++++++++++++++++++-
 1 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/orinoco/spectrum_cs.c b/drivers/net/wireless/orinoco/spectrum_cs.c
index 852789a..c6c6d12 100644
--- a/drivers/net/wireless/orinoco/spectrum_cs.c
+++ b/drivers/net/wireless/orinoco/spectrum_cs.c
@@ -450,10 +450,29 @@ spectrum_cs_resume(struct pcmcia_device *link)
 {
 	struct net_device *dev = link->priv;
 	struct orinoco_private *priv = netdev_priv(dev);
+	unsigned long flags;
+	int err;
+
+	err = orinoco_reinit_firmware(dev);
+	if (err) {
+		printk(KERN_ERR "%s: Error %d re-initializing firmware\n",
+		       dev->name, err);
+		return -EIO;
+	}
+
+	spin_lock_irqsave(&priv->lock, flags);
 
 	netif_device_attach(dev);
 	priv->hw_unavailable--;
-	schedule_work(&priv->reset_work);
+
+	if (priv->open && !priv->hw_unavailable) {
+		err = __orinoco_up(dev);
+		if (err)
+			printk(KERN_ERR "%s: Error %d restarting card\n",
+			       dev->name, err);
+	}
+
+	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return 0;
 }
-- 
1.5.6.4

