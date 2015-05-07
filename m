Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:33267 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750806AbbEGNjX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 May 2015 09:39:23 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Subject: [char-misc-next] NFC: microread: drop unused variable
Date: Thu,  7 May 2015 16:38:30 +0300
Message-Id: <1431005910-9284-1-git-send-email-tomas.winkler@intel.com> (sfid-20150507_153948_052853_EEAE27E6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In microread_i2c_irq_thread_fn 'client' set but not used

Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/nfc/microread/i2c.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/nfc/microread/i2c.c b/drivers/nfc/microread/i2c.c
index 661e2c8143c4..daf352597ef8 100644
--- a/drivers/nfc/microread/i2c.c
+++ b/drivers/nfc/microread/i2c.c
@@ -211,7 +211,6 @@ flush:
 static irqreturn_t microread_i2c_irq_thread_fn(int irq, void *phy_id)
 {
 	struct microread_i2c_phy *phy = phy_id;
-	struct i2c_client *client;
 	struct sk_buff *skb = NULL;
 	int r;
 
@@ -220,8 +219,6 @@ static irqreturn_t microread_i2c_irq_thread_fn(int irq, void *phy_id)
 		return IRQ_NONE;
 	}
 
-	client = phy->i2c_dev;
-
 	if (phy->hard_fault != 0)
 		return IRQ_HANDLED;
 
-- 
2.1.0

