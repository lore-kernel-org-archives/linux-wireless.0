Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.177]:5144 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637AbYJaBP7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 21:15:59 -0400
Received: by ik-out-1112.google.com with SMTP id c29so60069ika.5
        for <linux-wireless@vger.kernel.org>; Thu, 30 Oct 2008 18:15:57 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Cc: arvidjaar@mail.ru, linux-pm@lists.linux-foundation.org,
	David Kilroy <kilroyd@googlemail.com>
Subject: [RFC PATCH 2/2] orinoco: Resume spectrum_cs in the same way as orinoco_cs
Date: Fri, 31 Oct 2008 01:15:43 +0000
Message-Id: <1225415743-28209-3-git-send-email-kilroyd@googlemail.com> (sfid-20081031_021601_505920_E518E931)
In-Reply-To: <1225415743-28209-2-git-send-email-kilroyd@googlemail.com>
References: <1225415743-28209-1-git-send-email-kilroyd@googlemail.com>
 <1225415743-28209-2-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Retrieval of external firmware has been resolved, and should work with
the standard orinoco resume algorithm.

This fixes an issue where priv->hw_unavailable indicates the card is
ready when firmware has not been loaded.

Signed-off by: David Kilroy <kilroyd@googlemail.com>
---
I don't have a spectrum_cs card, so this patch really needs testing to
check resume works properly.
---
 drivers/net/wireless/spectrum_cs.c |   21 ++++++++++++++++++++-
 1 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/spectrum_cs.c b/drivers/net/wireless/spectrum_cs.c
index 852789a..c6c6d12 100644
--- a/drivers/net/wireless/spectrum_cs.c
+++ b/drivers/net/wireless/spectrum_cs.c
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

