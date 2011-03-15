Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web57402.mail.re1.yahoo.com ([66.196.100.53]:42889 "HELO
	web57402.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758073Ab1COPlV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2011 11:41:21 -0400
Message-ID: <183581.36039.qm@web57402.mail.re1.yahoo.com>
Date: Tue, 15 Mar 2011 08:41:19 -0700 (PDT)
From: Joe Gunn <armadefuego@yahoo.com>
Subject: [PATCH 2.6.38-rc8-wl 1/1] orinoco: Maintain lock until entry removed from list
To: orinoco-devel@lists.sourceforge.net
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing an entry from the scan_list should be performed while holding the lock.
Signed-off-by: Joseph J. Gunn <armadefuego@yahoo.com>
---
diff --git a/drivers/net/wireless/orinoco/main.c b/drivers/net/wireless/orinoco/main.c
index f3d396e..62c6b2b 100644
--- a/drivers/net/wireless/orinoco/main.c
+++ b/drivers/net/wireless/orinoco/main.c
@@ -1376,13 +1376,13 @@ static void orinoco_process_scan_results(struct work_struct *work)
 
 	spin_lock_irqsave(&priv->scan_lock, flags);
 	list_for_each_entry_safe(sd, temp, &priv->scan_list, list) {
-		spin_unlock_irqrestore(&priv->scan_lock, flags);
 
 		buf = sd->buf;
 		len = sd->len;
 		type = sd->type;
 
 		list_del(&sd->list);
+		spin_unlock_irqrestore(&priv->scan_lock, flags);
 		kfree(sd);
 
 		if (len > 0) {



      
