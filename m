Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bn3nam01on0050.outbound.protection.outlook.com ([104.47.33.50]:19456
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751583AbdJOUxu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 15 Oct 2017 16:53:50 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Vasily Ulyanov <vulyanov@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 3/5] qtnfmac: drop nonexistent function declaration
Date: Sun, 15 Oct 2017 23:53:25 +0300
Message-Id: <20171015205327.9966-4-sergey.matyukevich.os@quantenna.com> (sfid-20171015_225420_348087_01B44C72)
In-Reply-To: <20171015205327.9966-1-sergey.matyukevich.os@quantenna.com>
References: <20171015205327.9966-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Function qtnf_classify_skb_no_mbss has been used for debug
during early stage of development. Drop its declaration.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/core.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.h b/drivers/net/wireless/quantenna/qtnfmac/core.h
index 44a2cbb19310..49ae700f66f0 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.h
@@ -153,9 +153,6 @@ int qtnf_cmd_send_get_phy_params(struct qtnf_wmac *mac);
 
 struct qtnf_wmac *qtnf_core_get_mac(const struct qtnf_bus *bus, u8 macid);
 struct net_device *qtnf_classify_skb(struct qtnf_bus *bus, struct sk_buff *skb);
-struct net_device *qtnf_classify_skb_no_mbss(struct qtnf_bus *bus,
-					     struct sk_buff *skb);
-
 void qtnf_virtual_intf_cleanup(struct net_device *ndev);
 
 void qtnf_netdev_updown(struct net_device *ndev, bool up);
-- 
2.11.0
