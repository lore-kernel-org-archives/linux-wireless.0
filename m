Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:34859 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388036AbeGTTGL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Jul 2018 15:06:11 -0400
From: Colin King <colin.king@canonical.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
        Amit Pundir <amit.pundir@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-wireless@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] nfc: fdp: remove redundant pointer 'client'
Date: Fri, 20 Jul 2018 19:16:43 +0100
Message-Id: <20180720181643.21340-1-colin.king@canonical.com> (sfid-20180720_201658_860349_0429BE09)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Pointer 'client' is being assigned but is never used hence it is
redundant and can be removed.

Cleans up clang warning:
warning: variable 'client' set but not used [-Wunused-but-set-variable]

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/nfc/fdp/i2c.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/nfc/fdp/i2c.c b/drivers/nfc/fdp/i2c.c
index 70a970c7375c..5d3ea63e405f 100644
--- a/drivers/nfc/fdp/i2c.c
+++ b/drivers/nfc/fdp/i2c.c
@@ -210,7 +210,6 @@ static int fdp_nci_i2c_read(struct fdp_i2c_phy *phy, struct sk_buff **skb)
 static irqreturn_t fdp_nci_i2c_irq_thread_fn(int irq, void *phy_id)
 {
 	struct fdp_i2c_phy *phy = phy_id;
-	struct i2c_client *client;
 	struct sk_buff *skb;
 	int r;
 
@@ -219,8 +218,6 @@ static irqreturn_t fdp_nci_i2c_irq_thread_fn(int irq, void *phy_id)
 		return IRQ_NONE;
 	}
 
-	client = phy->i2c_dev;
-
 	r = fdp_nci_i2c_read(phy, &skb);
 
 	if (r == -EREMOTEIO)
-- 
2.17.1
