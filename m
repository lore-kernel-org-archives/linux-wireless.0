Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway30.websitewelcome.com ([192.185.150.24]:48479 "EHLO
        gateway30.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753092AbeD3NMc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Apr 2018 09:12:32 -0400
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway30.websitewelcome.com (Postfix) with ESMTP id 528729DEA
        for <linux-wireless@vger.kernel.org>; Mon, 30 Apr 2018 07:50:43 -0500 (CDT)
Date: Mon, 30 Apr 2018 07:50:40 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Ajay Singh <ajay.kathat@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] staging: wilc1000: fix infinite loop and out-of-bounds access
Message-ID: <20180430125040.GA19050@embeddedor.com> (sfid-20180430_151235_949883_0D8367E1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If i < slot_id is initially true then it will remain true. Also,
as i is being decremented it will end up accessing memory out of
bounds.

Fix this by incrementing *i* instead of decrementing it.

Addresses-Coverity-ID: 1468454 ("Infinite loop")
Fixes: faa657641081 ("staging: wilc1000: refactor scan() to free kmalloc
memory on failure cases")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---

BTW... at first sight it seems to me that variables slot_id
and i should be of type unsigned instead of signed.

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 3ca0c97..67104e8 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -608,7 +608,7 @@ wilc_wfi_cfg_alloc_fill_ssid(struct cfg80211_scan_request *request,
 
 out_free:
 
-	for (i = 0; i < slot_id ; i--)
+	for (i = 0; i < slot_id; i++)
 		kfree(ntwk->net_info[i].ssid);
 
 	kfree(ntwk->net_info);
-- 
2.7.4
