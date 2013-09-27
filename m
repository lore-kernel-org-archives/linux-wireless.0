Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:42713 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753399Ab3I0R4g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Sep 2013 13:56:36 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Sven Neumann <s.neumann@raumfeld.com>,
	Andreas Fenkart <andreas.fenkart@streamunlimited.com>,
	Daniel Mack <zonque@gmail.com>,
	Dylan Reid <dgreid@chromium.org>,
	Paul Stewart <pstew@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.12] mwifiex: fix SDIO interrupt lost issue
Date: Fri, 27 Sep 2013 10:55:38 -0700
Message-ID: <1380304538-2816-1-git-send-email-bzhao@marvell.com> (sfid-20130927_195640_026336_A2D65842)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

601216e "mwifiex: process RX packets in SDIO IRQ thread directly"
introduced a command timeout issue which can be reproduced easily on
an AM33xx platform using a test application written by Daniel Mack:

https://gist.github.com/zonque/6579314

mwifiex_main_process() is called from both the SDIO handler and
the workqueue. In case an interrupt occurs right after the
int_status check, but before updating the mwifiex_processing flag,
this interrupt gets lost, resulting in a command timeout and
consequently a card reset.

Let main_proc_lock protect both int_status and mwifiex_processing
flag. This fixes the interrupt lost issue.

Cc: <stable@vger.kernel.org> # 3.7+
Reported-by: Sven Neumann <s.neumann@raumfeld.com>
Reported-by: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
Tested-by: Daniel Mack <zonque@gmail.com>
Reviewed-by: Dylan Reid <dgreid@chromium.org>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Paul Stewart <pstew@chromium.org>
---
 drivers/net/wireless/mwifiex/main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index fd77833..c2b91f5 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -358,10 +358,12 @@ process_start:
 		}
 	} while (true);
 
-	if ((adapter->int_status) || IS_CARD_RX_RCVD(adapter))
+	spin_lock_irqsave(&adapter->main_proc_lock, flags);
+	if ((adapter->int_status) || IS_CARD_RX_RCVD(adapter)) {
+		spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
 		goto process_start;
+	}
 
-	spin_lock_irqsave(&adapter->main_proc_lock, flags);
 	adapter->mwifiex_processing = false;
 	spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
 
-- 
1.8.2.3

