Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway23.websitewelcome.com ([192.185.50.107]:47223 "EHLO
        gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750811AbdE3UnM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 May 2017 16:43:12 -0400
Received: from cm3.websitewelcome.com (unknown [108.167.139.23])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id 5F08D6A583
        for <linux-wireless@vger.kernel.org>; Tue, 30 May 2017 15:43:09 -0500 (CDT)
Date: Tue, 30 May 2017 15:43:07 -0500
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] NFC: add NULL checks to avoid potential NULL pointer
 dereference
Message-ID: <20170530204307.GA3931@embeddedgus> (sfid-20170530_224315_747040_B0109018)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

NULL checks at line 457: if (!link0 || !link1) {, implies that both
pointers link0 and link1 might be NULL.
Function nfcsim_link_free() dereference pointers link0 and link1.
Add NULL checks before calling nfcsim_link_free() to avoid a
potential NULL pointer dereference.

Addresses-Coverity-ID: 1364857
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/nfc/nfcsim.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/nfcsim.c b/drivers/nfc/nfcsim.c
index a466e79..6e90b54 100644
--- a/drivers/nfc/nfcsim.c
+++ b/drivers/nfc/nfcsim.c
@@ -482,8 +482,10 @@ static int __init nfcsim_init(void)
 exit_err:
 	pr_err("Failed to initialize nfcsim driver (%d)\n", rc);
 
-	nfcsim_link_free(link0);
-	nfcsim_link_free(link1);
+	if (link0)
+		nfcsim_link_free(link0);
+	if (link1)
+		nfcsim_link_free(link1);
 
 	return rc;
 }
-- 
2.5.0
