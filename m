Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:34329 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754785Ab3CPBri (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Mar 2013 21:47:38 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Daniel Drake <dsd@laptop.org>, Paul Fox <pgf@laptop.org>,
	John Rhodes <jrhodes@marvell.com>,
	Marco Cesarano <marco@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.9 3/3] mwifiex: cancel cmd timer and free curr_cmd in shutdown process
Date: Fri, 15 Mar 2013 18:47:07 -0700
Message-ID: <1363398427-30392-4-git-send-email-bzhao@marvell.com> (sfid-20130316_024745_429458_E58C3BE6)
In-Reply-To: <1363398427-30392-1-git-send-email-bzhao@marvell.com>
References: <1363398427-30392-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

curr_cmd points to the command that is in processing or waiting
for its command response from firmware. If the function shutdown
happens to occur at this time we should cancel the cmd timer and
put the command back to free queue.

Cc: <stable@vger.kernel.org> # 3.8
Tested-by: Marco Cesarano <marco@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/init.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index cab3434..daf8801 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -709,6 +709,14 @@ mwifiex_shutdown_drv(struct mwifiex_adapter *adapter)
 		return ret;
 	}
 
+	/* cancel current command */
+	if (adapter->curr_cmd) {
+		dev_warn(adapter->dev, "curr_cmd is still in processing\n");
+		del_timer(&adapter->cmd_timer);
+		mwifiex_insert_cmd_to_free_q(adapter, adapter->curr_cmd);
+		adapter->curr_cmd = NULL;
+	}
+
 	/* shut down mwifiex */
 	dev_dbg(adapter->dev, "info: shutdown mwifiex...\n");
 
-- 
1.7.0.2

