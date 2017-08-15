Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam03on0048.outbound.protection.outlook.com ([104.47.42.48]:5536
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750997AbdHONHD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Aug 2017 09:07:03 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 5/9] qtnfmac: decrease default Tx queue size
Date: Tue, 15 Aug 2017 16:06:35 +0300
Message-Id: <20170815130638.31718-6-sergey.matyukevich.os@quantenna.com> (sfid-20170815_150715_406310_9DFF441C)
In-Reply-To: <20170815130638.31718-1-sergey.matyukevich.os@quantenna.com>
References: <20170815130638.31718-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Avoid extra buffering in driver by default. Use max hardware Tx queue size.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
index a0b65d487ddb..f18e8a724c68 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
@@ -36,7 +36,7 @@ static bool use_msi = true;
 module_param(use_msi, bool, 0644);
 MODULE_PARM_DESC(use_msi, "set 0 to use legacy interrupt");
 
-static unsigned int tx_bd_size_param = 256;
+static unsigned int tx_bd_size_param = 32;
 module_param(tx_bd_size_param, uint, 0644);
 MODULE_PARM_DESC(tx_bd_size_param, "Tx descriptors queue size");
 
-- 
2.11.0
