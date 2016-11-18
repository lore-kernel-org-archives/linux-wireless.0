Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:56099 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752301AbcKRRN7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Nov 2016 12:13:59 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <rajatja@google.com>, <briannorris@google.com>,
        <dmitry.torokhov@gmail.com>,
        Brian Norris <briannorris@chromium.org>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 1/2] mwifiex: cleanup wake-IRQ handling if suspend fails
Date: Fri, 18 Nov 2016 22:43:24 +0530
Message-ID: <1479489205-30288-1-git-send-email-akarwar@marvell.com> (sfid-20161118_181402_565214_C4000B9D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Brian Norris <briannorris@chromium.org>

We don't want to leave the wake IRQ enabled.

Signed-off-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 1 +
 drivers/net/wireless/marvell/mwifiex/sdio.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 62ec141..32fa4ed 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -137,6 +137,7 @@ static int mwifiex_pcie_suspend(struct device *dev)
 		mwifiex_dbg(adapter, ERROR,
 			    "cmd: failed to suspend\n");
 		adapter->hs_enabling = false;
+		mwifiex_disable_wake(adapter);
 		return -EFAULT;
 	}
 
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index c219671..78f2cc9 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -308,6 +308,7 @@ static int mwifiex_sdio_suspend(struct device *dev)
 		mwifiex_dbg(adapter, ERROR,
 			    "cmd: failed to suspend\n");
 		adapter->hs_enabling = false;
+		mwifiex_disable_wake(adapter);
 		return -EFAULT;
 	}
 
-- 
1.9.1
