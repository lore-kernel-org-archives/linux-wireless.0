Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:58746 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751521AbeACUMA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Jan 2018 15:12:00 -0500
Subject: [PATCH 1/2] wireless: libertas_tf: Delete an error message for a
 failed memory allocation in __if_usb_submit_rx_urb()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <e8b93aae-8dea-7089-43fe-9222054f0749@users.sourceforge.net>
Message-ID: <f4de47c5-882f-eb11-ade0-f4c7a378d3be@users.sourceforge.net> (sfid-20180103_213518_897918_3C59D29A)
Date: Wed, 3 Jan 2018 21:11:53 +0100
MIME-Version: 1.0
In-Reply-To: <e8b93aae-8dea-7089-43fe-9222054f0749@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 3 Jan 2018 20:55:10 +0100

Omit an extra message for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/net/wireless/marvell/libertas_tf/if_usb.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/libertas_tf/if_usb.c b/drivers/net/wireless/marvell/libertas_tf/if_usb.c
index 5153922e7ce1..9eebc84cd15a 100644
--- a/drivers/net/wireless/marvell/libertas_tf/if_usb.c
+++ b/drivers/net/wireless/marvell/libertas_tf/if_usb.c
@@ -420,7 +420,6 @@ static int __if_usb_submit_rx_urb(struct if_usb_card *cardp,
 
 	skb = dev_alloc_skb(MRVDRV_ETH_RX_PACKET_BUFFER_SIZE);
 	if (!skb) {
-		pr_err("No free skb\n");
 		lbtf_deb_leave(LBTF_DEB_USB);
 		return -1;
 	}
-- 
2.15.1
