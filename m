Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:34891 "EHLO
        mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933227AbdELQm3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 May 2017 12:42:29 -0400
Received: by mail-pf0-f179.google.com with SMTP id n23so27803637pfb.2
        for <linux-wireless@vger.kernel.org>; Fri, 12 May 2017 09:42:29 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Cc: <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Doug Anderson <dianders@chromium.org>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH 05/11] mwifiex: don't drop lock between list-retrieval / list-deletion
Date: Fri, 12 May 2017 09:42:02 -0700
Message-Id: <20170512164208.38725-5-briannorris@chromium.org> (sfid-20170512_184516_384001_9113687F)
In-Reply-To: <20170512164208.38725-1-briannorris@chromium.org>
References: <20170512164208.38725-1-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mwifiex_exec_next_cmd() seems to have a classic TOCTOU race, where we
drop the list lock in between retrieving the next command and deleting
it from the list. This potentially leaves room for someone else to also
retrieve / steal this node from the list (e.g.,
mwifiex_cancel_all_pending_cmd()).

Let's keep holding the lock while we do our 'ps_state' sanity checks.
There should be no harm in continuing to hold this lock for a bit more.

Noticed only by code inspection.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/marvell/mwifiex/cmdevt.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cmdevt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
index 5fd6c53d7b06..95221306a4e5 100644
--- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
@@ -761,8 +761,6 @@ int mwifiex_exec_next_cmd(struct mwifiex_adapter *adapter)
 	}
 	cmd_node = list_first_entry(&adapter->cmd_pending_q,
 				    struct cmd_ctrl_node, list);
-	spin_unlock_irqrestore(&adapter->cmd_pending_q_lock,
-			       cmd_pending_q_flags);
 
 	host_cmd = (struct host_cmd_ds_command *) (cmd_node->cmd_skb->data);
 	priv = cmd_node->priv;
@@ -771,11 +769,12 @@ int mwifiex_exec_next_cmd(struct mwifiex_adapter *adapter)
 		mwifiex_dbg(adapter, ERROR,
 			    "%s: cannot send cmd in sleep state,\t"
 			    "this should not happen\n", __func__);
+		spin_unlock_irqrestore(&adapter->cmd_pending_q_lock,
+				       cmd_pending_q_flags);
 		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, cmd_flags);
 		return ret;
 	}
 
-	spin_lock_irqsave(&adapter->cmd_pending_q_lock, cmd_pending_q_flags);
 	list_del(&cmd_node->list);
 	spin_unlock_irqrestore(&adapter->cmd_pending_q_lock,
 			       cmd_pending_q_flags);
-- 
2.13.0.rc2.291.g57267f2277-goog
