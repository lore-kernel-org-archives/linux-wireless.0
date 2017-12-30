Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:58224 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750968AbdL3T6E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 30 Dec 2017 14:58:04 -0500
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Ingo Molnar <mingo@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] wireless: airo: Delete an error message for a failed memory
 allocation in airo_networks_allocate()
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Message-ID: <33444ac1-9a8b-bd7d-fd22-f299add190df@users.sourceforge.net> (sfid-20171230_205828_351977_C8589F5D)
Date: Sat, 30 Dec 2017 20:57:15 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 30 Dec 2017 20:48:44 +0100

Omit an extra message for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/net/wireless/cisco/airo.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/wireless/cisco/airo.c b/drivers/net/wireless/cisco/airo.c
index 86e795de6760..a65d82d26eaa 100644
--- a/drivers/net/wireless/cisco/airo.c
+++ b/drivers/net/wireless/cisco/airo.c
@@ -2714,12 +2714,7 @@ static int airo_networks_allocate(struct airo_info *ai)
 
 	ai->networks = kcalloc(AIRO_MAX_NETWORK_COUNT, sizeof(BSSListElement),
 			       GFP_KERNEL);
-	if (!ai->networks) {
-		airo_print_warn("", "Out of memory allocating beacons");
-		return -ENOMEM;
-	}
-
-	return 0;
+	return ai->networks ? 0 : -ENOMEM;
 }
 
 static void airo_networks_free(struct airo_info *ai)
-- 
2.15.1
