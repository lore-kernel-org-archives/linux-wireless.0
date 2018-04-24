Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:54884 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933839AbeDXNSN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Apr 2018 09:18:13 -0400
From: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Igor Mitsyanko <imitsyanko@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Vasily Ulyanov <vulyanov@quantenna.com>,
        Kees Cook <keescook@chromium.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] qtnfmac: fix qtnf_netdev_hard_start_xmit()'s return type
Date: Tue, 24 Apr 2018 15:18:04 +0200
Message-Id: <20180424131810.4963-1-luc.vanoostenryck@gmail.com> (sfid-20180424_152855_679709_F4AC558E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The method ndo_start_xmit() is defined as returning an 'netdev_tx_t',
which is a typedef for an enum type, but the implementation in this
driver returns an 'int'.

Fix this by returning 'netdev_tx_t' in this driver too.

Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
---
 drivers/net/wireless/quantenna/qtnfmac/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.c b/drivers/net/wireless/quantenna/qtnfmac/core.c
index cf26c15a8..b3bfb4faa 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.c
@@ -76,7 +76,7 @@ static int qtnf_netdev_close(struct net_device *ndev)
 
 /* Netdev handler for data transmission.
  */
-static int
+static netdev_tx_t
 qtnf_netdev_hard_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	struct qtnf_vif *vif;
-- 
2.17.0
