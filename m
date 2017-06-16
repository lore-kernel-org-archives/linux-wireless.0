Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:44123 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751641AbdFPDky (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2017 23:40:54 -0400
From: Mark Greer <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
        Mark Greer <mgreer@animalcreek.com>
Subject: [PATCH 1/2] NFC: digital: Abort cmd when deactivating target
Date: Thu, 15 Jun 2017 20:34:21 -0700
Message-Id: <20170616033422.18484-2-mgreer@animalcreek.com> (sfid-20170616_054105_306847_4B40E227)
In-Reply-To: <20170616033422.18484-1-mgreer@animalcreek.com>
References: <20170616033422.18484-1-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When deactivating an active target, the outstanding command should
be aborted.

Signed-off-by: Mark Greer <mgreer@animalcreek.com>
---
 net/nfc/digital_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/nfc/digital_core.c b/net/nfc/digital_core.c
index 0fd5518bf252..145dd74927c4 100644
--- a/net/nfc/digital_core.c
+++ b/net/nfc/digital_core.c
@@ -650,6 +650,7 @@ static void digital_deactivate_target(struct nfc_dev *nfc_dev,
 		return;
 	}
 
+	digital_abort_cmd(ddev);
 	ddev->curr_protocol = 0;
 }
 
-- 
2.13.0
