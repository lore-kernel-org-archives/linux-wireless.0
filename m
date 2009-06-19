Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43129 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbZFSRpb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jun 2009 13:45:31 -0400
Date: Fri, 19 Jun 2009 13:35:42 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: David Kilroy <kilroyd@googlemail.com>
Cc: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Subject: Re: [PATCH 21/23] orinoco: convert scanning to cfg80211
Message-ID: <20090619173541.GC2753@tuxdriver.com>
References: <1245363695-8289-1-git-send-email-kilroyd@googlemail.com> <1245363695-8289-22-git-send-email-kilroyd@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1245363695-8289-22-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 18, 2009 at 11:21:33PM +0100, David Kilroy wrote:
> This removes the custom scan cache used by orinoco.
> 
> We also have to avoid calling cfg80211_scan_done from the hard
> interrupt, so we offload the entirety of scan processing to a workqueue.
> 
> This may behave strangely if you start scanning just prior to
> suspending...
> 
> Signed-off-by: David Kilroy <kilroyd@googlemail.com>

Hmmm...please do try to compile test patches before posting! :-)

John

---

>From 81aab523c06da0e025a7c9b2669058fd16597d18 Mon Sep 17 00:00:00 2001
From: John W. Linville <linville@tuxdriver.com>
Date: Fri, 19 Jun 2009 13:33:50 -0400
Subject: [PATCH] fixups for "orinoco: convert scanning to cfg80211"

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/orinoco/main.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/orinoco/main.c b/drivers/net/wireless/orinoco/main.c
index 90e2d32..cd1c04d 100644
--- a/drivers/net/wireless/orinoco/main.c
+++ b/drivers/net/wireless/orinoco/main.c
@@ -1283,9 +1283,9 @@ static void qbuf_scan(struct orinoco_private *priv, void *buf,
 	sd->len = len;
 	sd->type = type;
 
-	spin_lock_irqsave(priv->scan_lock, flags);
+	spin_lock_irqsave(&priv->scan_lock, flags);
 	list_add_tail(&sd->list, &priv->scan_list);
-	spin_unlock_irqrestore(priv->scan_lock, flags);
+	spin_unlock_irqrestore(&priv->scan_lock, flags);
 
 	schedule_work(&priv->process_scan);
 }
@@ -1298,9 +1298,9 @@ static void qabort_scan(struct orinoco_private *priv)
 	sd = kmalloc(sizeof(*sd), GFP_ATOMIC);
 	sd->len = -1; /* Abort */
 
-	spin_lock_irqsave(priv->scan_lock, flags);
+	spin_lock_irqsave(&priv->scan_lock, flags);
 	list_add_tail(&sd->list, &priv->scan_list);
-	spin_unlock_irqrestore(priv->scan_lock, flags);
+	spin_unlock_irqrestore(&priv->scan_lock, flags);
 
 	schedule_work(&priv->process_scan);
 }
@@ -1315,9 +1315,9 @@ static void orinoco_process_scan_results(struct work_struct *work)
 	int len;
 	int type;
 
-	spin_lock_irqsave(priv->scan_lock, flags);
+	spin_lock_irqsave(&priv->scan_lock, flags);
 	list_for_each_entry_safe(sd, temp, &priv->scan_list, list) {
-		spin_unlock_irqrestore(priv->scan_lock, flags);
+		spin_unlock_irqrestore(&priv->scan_lock, flags);
 
 		buf = sd->buf;
 		len = sd->len;
@@ -1339,9 +1339,9 @@ static void orinoco_process_scan_results(struct work_struct *work)
 			priv->scan_request = NULL;
 		}
 
-		spin_lock_irqsave(priv->scan_lock, flags);
+		spin_lock_irqsave(&priv->scan_lock, flags);
 	}
-	spin_unlock_irqrestore(priv->scan_lock, flags);
+	spin_unlock_irqrestore(&priv->scan_lock, flags);
 }
 
 static void __orinoco_ev_info(struct net_device *dev, hermes_t *hw)
-- 
1.6.0.6

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
