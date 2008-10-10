Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:41613 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760219AbYJJV6h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 17:58:37 -0400
Received: by ey-out-2122.google.com with SMTP id 6so303065eyi.37
        for <linux-wireless@vger.kernel.org>; Fri, 10 Oct 2008 14:58:35 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net, arvidjaar@mail.ru,
	David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH] orinoco: fix unsafe locking in spectrum_cs_suspend
Date: Fri, 10 Oct 2008 22:58:32 +0100
Message-Id: <1223675912-8455-1-git-send-email-kilroyd@googlemail.com> (sfid-20081010_235841_387618_BDD9A0B9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A similar problem was highlighted in the orinoco_cs driver by lockdep.
This patch fixes the spectrum_cs driver.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---

I don't have the hardware to test this patch...

 drivers/net/wireless/spectrum_cs.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/spectrum_cs.c b/drivers/net/wireless/spectrum_cs.c
index 67b26d3..f5513cd 100644
--- a/drivers/net/wireless/spectrum_cs.c
+++ b/drivers/net/wireless/spectrum_cs.c
@@ -450,10 +450,11 @@ spectrum_cs_suspend(struct pcmcia_device *link)
 {
 	struct net_device *dev = link->priv;
 	struct orinoco_private *priv = netdev_priv(dev);
+	unsigned long flags;
 	int err = 0;
 
 	/* Mark the device as stopped, to block IO until later */
-	spin_lock(&priv->lock);
+	spin_lock_irqsave(&priv->lock, flags);
 
 	err = __orinoco_down(dev);
 	if (err)
@@ -463,7 +464,7 @@ spectrum_cs_suspend(struct pcmcia_device *link)
 	netif_device_detach(dev);
 	priv->hw_unavailable++;
 
-	spin_unlock(&priv->lock);
+	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return err;
 }
-- 
1.5.6.4

