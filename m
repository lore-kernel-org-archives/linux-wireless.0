Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:58572 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124AbYJQSV7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Oct 2008 14:21:59 -0400
Subject: [PATCH] libertas: fix CF firmware loading
From: Dan Williams <dcbw@redhat.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Fri, 17 Oct 2008 14:15:49 -0400
Message-Id: <1224267349.4010.2.camel@dhcp-100-3-195.bos.redhat.com> (sfid-20081017_202204_998534_659AB233)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ryan Mallon <ryan@bluewatersys.com>

Change the return value of if_cs_poll_while_fw_download to zero on 
success, so that the firmware loading functions also correctly 
return zero on success.

Signed-off-by: Ryan Mallon <ryan@bluewatersys.com>
Acked-by: Dan Williams <dcbw@redhat.com>

diff --git a/drivers/net/wireless/libertas/if_cs.c b/drivers/net/wireless/libertas/if_cs.c
index 842a08d..8f8934a 100644
--- a/drivers/net/wireless/libertas/if_cs.c
+++ b/drivers/net/wireless/libertas/if_cs.c
@@ -151,7 +151,7 @@ static int if_cs_poll_while_fw_download(struct if_cs_card *card, uint addr, u8 r
        for (i = 0; i < 100000; i++) {
                u8 val = if_cs_read8(card, addr);
                if (val == reg)
-                       return i;
+                       return 0;
                udelay(5);
        }
        return -ETIME;



