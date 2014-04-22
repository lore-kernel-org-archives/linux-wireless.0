Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42531 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959AbaDVP3z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2014 11:29:55 -0400
Date: Tue, 22 Apr 2014 17:29:52 +0200
From: Jean Delvare <jdelvare@suse.de>
To: linux-wireless@vger.kernel.org
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH] NFC: microread: Delete dead code in
 microread_i2c_irq_thread_fn
Message-ID: <20140422172952.03dfa721@endymion.delvare> (sfid-20140422_173008_333237_36972041)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix the following warning (with W=1):

drivers/nfc/microread/i2c.c: In function "microread_i2c_irq_thread_fn":
drivers/nfc/microread/i2c.c:215:21: warning: variable "client" set but not used [-Wunused-but-set-variable]
  struct i2c_client *client;
                     ^

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/nfc/microread/i2c.c |    3 ---
 1 file changed, 3 deletions(-)

--- linux-3.15-rc2.orig/drivers/nfc/microread/i2c.c	2014-04-22 17:14:06.962088154 +0200
+++ linux-3.15-rc2/drivers/nfc/microread/i2c.c	2014-04-22 17:25:54.467845993 +0200
@@ -212,7 +212,6 @@ flush:
 static irqreturn_t microread_i2c_irq_thread_fn(int irq, void *phy_id)
 {
 	struct microread_i2c_phy *phy = phy_id;
-	struct i2c_client *client;
 	struct sk_buff *skb = NULL;
 	int r;
 
@@ -221,8 +220,6 @@ static irqreturn_t microread_i2c_irq_thr
 		return IRQ_NONE;
 	}
 
-	client = phy->i2c_dev;
-
 	if (phy->hard_fault != 0)
 		return IRQ_HANDLED;
 


-- 
Jean Delvare
SUSE L3 Support
