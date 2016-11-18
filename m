Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:56106 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752301AbcKRROH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Nov 2016 12:14:07 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <rajatja@google.com>, <briannorris@google.com>,
        <dmitry.torokhov@gmail.com>,
        Brian Norris <briannorris@chromium.org>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 2/2] mwifiex: avoid double-disable_irq() race
Date: Fri, 18 Nov 2016 22:43:25 +0530
Message-ID: <1479489205-30288-2-git-send-email-akarwar@marvell.com> (sfid-20161118_181410_160614_46D770CE)
In-Reply-To: <1479489205-30288-1-git-send-email-akarwar@marvell.com>
References: <1479489205-30288-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Brian Norris <briannorris@chromium.org>

We have a race where the wakeup IRQ might be in flight while we're
calling mwifiex_disable_wake() from resume(). This can leave us
disabling the IRQ twice.

Let's disable the IRQ and enable it in case if we have double-disabled
it.

Signed-off-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/main.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index b8ef1c0..d501d03 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -1419,8 +1419,13 @@ static inline void mwifiex_disable_wake(struct mwifiex_adapter *adapter)
 {
 	if (adapter->irq_wakeup >= 0) {
 		disable_irq_wake(adapter->irq_wakeup);
-		if (!adapter->wake_by_wifi)
-			disable_irq(adapter->irq_wakeup);
+		disable_irq(adapter->irq_wakeup);
+		if (adapter->wake_by_wifi)
+			/* Undo our disable, since interrupt handler already
+			 * did this.
+			 */
+			enable_irq(adapter->irq_wakeup);
+
 	}
 }
 
-- 
1.9.1
