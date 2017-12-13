Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:43324 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751853AbdLML2S (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Dec 2017 06:28:18 -0500
From: Xinming Hu <huxm@marvell.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
CC: Kalle Valo <kvalo@codeaurora.org>,
        Brian Norris <briannorris@chromium.org>,
        Dmitry Torokhov <dtor@google.com>, <rajatja@google.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        James Cao <jcao@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Ellie Reeves <ellierevves@gmail.com>,
        Xinming Hu <huxm@marvell.com>
Subject: [PATCH] mwifiex: cancel pcie/sdio work in remove/shutdown handler
Date: Wed, 13 Dec 2017 19:27:53 +0800
Message-ID: <1513164473-13827-1-git-send-email-huxm@marvell.com> (sfid-20171213_122824_077985_645A5C26)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The last command used to shutdown firmware might be timeout,
and trigger firmware dump in asynchronous pcie/sdio work.

The remove/shutdown handler will continue free core data
structure private/adapter, which might be dereferenced in
pcie/sdio work, finally crash the kernel.

Sync and Cancel pcie/sdio work, could be a fix for above
cornel case. In this way, the last command timeout could
be handled properly.

Signed-off-by: Xinming Hu <huxm@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 2 ++
 drivers/net/wireless/marvell/mwifiex/sdio.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index f666cb2..23209c5 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -310,6 +310,8 @@ static void mwifiex_pcie_remove(struct pci_dev *pdev)
 		mwifiex_init_shutdown_fw(priv, MWIFIEX_FUNC_SHUTDOWN);
 	}
 
+	cancel_work_sync(&card->work);
+
 	mwifiex_remove_card(adapter);
 }
 
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index a828801..2488587 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -399,6 +399,8 @@ static int mwifiex_check_winner_status(struct mwifiex_adapter *adapter)
 		mwifiex_init_shutdown_fw(priv, MWIFIEX_FUNC_SHUTDOWN);
 	}
 
+	cancel_work_sync(&card->work);
+
 	mwifiex_remove_card(adapter);
 }
 
-- 
1.9.1
