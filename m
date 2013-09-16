Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from svenfoo.org ([82.94.215.22]:48005 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866Ab3IPLjR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Sep 2013 07:39:17 -0400
From: Daniel Mack <zonque@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: s.neumann@raumfeld.com, afenkart@gmail.com, bzhao@marvell.com,
	linville@tuxdriver.com, johannes.berg@intel.com,
	Daniel Mack <zonque@gmail.com>, <stable@vger.kernel.org>
Subject: [PATCH 1/1] mwifiex: queue main work from main process when bailing on races
Date: Mon, 16 Sep 2013 13:39:06 +0200
Message-Id: <1379331546-30617-2-git-send-email-zonque@gmail.com> (sfid-20130916_133922_389751_6EA27E6C)
In-Reply-To: <1379331546-30617-1-git-send-email-zonque@gmail.com>
References: <1379331546-30617-1-git-send-email-zonque@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Queue main_work in case mwifiex_main_process() bails due to an already
processed transaction. This is particularly necessary because
mwifiex_main_process() is called from both the SDIO interrupt handler
and the workqueue. In case an interrupt occurs while the main process
is currently executed from the workqueue, the interrupt is lost,
resulting in a command timeout and consequently a card reset.

I'm marking this for stable kernel in version 3.7+, because on our
platform, the issue appears since 601216e12c ("mwifiex: process RX
packets in SDIO IRQ thread directly") went in.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Reported-by: Sven Neumann <s.neumann@raumfeld.com>
Reported-by: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
Cc: Bing Zhao <bzhao@marvell.com>
Cc: <stable@vger.kernel.org> [v3.7+]
---
 drivers/net/wireless/mwifiex/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index ff4ed96..0700bc2 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -235,6 +235,7 @@ int mwifiex_main_process(struct mwifiex_adapter *adapter)
 	/* Check if already processing */
 	if (adapter->mwifiex_processing) {
 		spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
+		queue_work(adapter->workqueue, &adapter->main_work);
 		goto exit_main_proc;
 	} else {
 		adapter->mwifiex_processing = true;
-- 
1.8.3.1

