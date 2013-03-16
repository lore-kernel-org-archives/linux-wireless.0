Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:52682 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754081Ab3CPBsZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Mar 2013 21:48:25 -0400
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
Subject: [PATCH 3.9 2/3] mwifiex: skip pending commands after function shutdown
Date: Fri, 15 Mar 2013 18:47:06 -0700
Message-ID: <1363398427-30392-3-git-send-email-bzhao@marvell.com> (sfid-20130316_024827_682278_8C4FF1B7)
In-Reply-To: <1363398427-30392-1-git-send-email-bzhao@marvell.com>
References: <1363398427-30392-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During rmmod mwifiex_sdio processing FUNC_SHUTDOWN command is
sent to firmware. Firmware expcets only FUNC_INIT once WLAN
function is shut down.

Any command pending in the command queue should be ignored and
freed.

Cc: <stable@vger.kernel.org> # 3.8
Tested-by: Daniel Drake <dsd@laptop.org>
Tested-by: Marco Cesarano <marco@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/cmdevt.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index f47ad3a..9a1302b 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -157,6 +157,20 @@ static int mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 		return -1;
 	}
 
+	cmd_code = le16_to_cpu(host_cmd->command);
+	cmd_size = le16_to_cpu(host_cmd->size);
+
+	if (adapter->hw_status == MWIFIEX_HW_STATUS_RESET &&
+	    cmd_code != HostCmd_CMD_FUNC_SHUTDOWN &&
+	    cmd_code != HostCmd_CMD_FUNC_INIT) {
+		dev_err(adapter->dev,
+			"DNLD_CMD: FW in reset state, ignore cmd %#x\n",
+			cmd_code);
+		mwifiex_complete_cmd(adapter, cmd_node);
+		mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
+		return -1;
+	}
+
 	/* Set command sequence number */
 	adapter->seq_num++;
 	host_cmd->seq_num = cpu_to_le16(HostCmd_SET_SEQ_NO_BSS_INFO
@@ -168,9 +182,6 @@ static int mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 	adapter->curr_cmd = cmd_node;
 	spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
 
-	cmd_code = le16_to_cpu(host_cmd->command);
-	cmd_size = le16_to_cpu(host_cmd->size);
-
 	/* Adjust skb length */
 	if (cmd_node->cmd_skb->len > cmd_size)
 		/*
-- 
1.7.0.2

