Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:42120 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab1BCWoQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Feb 2011 17:44:16 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/2] mwifiex: fix list_del corruption while unloading modules
Date: Thu,  3 Feb 2011 14:46:01 -0800
Message-Id: <1296773161-11642-2-git-send-email-bzhao@marvell.com>
In-Reply-To: <1296773161-11642-1-git-send-email-bzhao@marvell.com>
References: <1296773161-11642-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Driver uses pre-allocated number of command buffers. The
command free queue keeps track of command buffers currently
free/available for use.
Currently while unloading the driver, command free queue is
freed after releasing pre-allocated command buffers which
sometimes leads to list_del corruption issue.
Therefore command free queue is freed before releasing
command buffers to fix the issue.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/init.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index de670c7..91a484c 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -353,6 +353,10 @@ mwifiex_free_adapter(struct mwifiex_adapter *adapter)
 	}
 
 	mwifiex_cancel_all_pending_cmd(adapter);
+
+	/* Free lock variables */
+	mwifiex_free_lock_list(adapter);
+
 	/* Free command buffer */
 	PRINTM(MINFO, "Free Command buffer\n");
 	mwifiex_free_cmd_buffer(adapter);
@@ -367,9 +371,6 @@ mwifiex_free_adapter(struct mwifiex_adapter *adapter)
 
 	mwifiex_free_buffer(adapter->sleep_cfm);
 
-	/* Free lock variables */
-	mwifiex_free_lock_list(adapter);
-
 	LEAVE();
 	return;
 }
-- 
1.7.0.2

