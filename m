Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:33226 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933188AbdELQm2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 May 2017 12:42:28 -0400
Received: by mail-pf0-f175.google.com with SMTP id e193so32709625pfh.0
        for <linux-wireless@vger.kernel.org>; Fri, 12 May 2017 09:42:27 -0700 (PDT)
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
Subject: [PATCH 03/11] mwifiex: Don't release cmd_pending_q_lock while iterating
Date: Fri, 12 May 2017 09:42:00 -0700
Message-Id: <20170512164208.38725-3-briannorris@chromium.org> (sfid-20170512_184516_924614_A4B56851)
In-Reply-To: <20170512164208.38725-1-briannorris@chromium.org>
References: <20170512164208.38725-1-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Douglas Anderson <dianders@chromium.org>

Just like in the previous patch ("mwifiex: Don't release
tx_ba_stream_tbl_lock while iterating"), in
mwifiex_cancel_all_pending_cmd() we were itearting over a list protected
by a spinlock.  Again, it is not safe to release the spinlock while
iterating.  Don't do it.

Luckily in this case there should be no need to release the spinlock.
This is evidenced by:

1. The only function called while the spinlock was released was
   mwifiex_recycle_cmd_node()
2. Aside from atomic functions (which are safe to call), the only
   function called by mwifiex_recycle_cmd_node() was
   mwifiex_insert_cmd_to_free_q().
3. It can be seen in mwifiex_cancel_pending_scan_cmd() that it's OK to
   call mwifiex_insert_cmd_to_free_q() while holding a different
   spinlock (scan_pending_q_lock), so in general holding a spinlock
   should be OK.
4. It doesn't appear that mwifiex_insert_cmd_to_free_q() has any
   interaction with the cmd_pending_q_lock

No known bugs are fixed with this change, but as with other similar
changes this could fix random list corruption.

Signed-off-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/marvell/mwifiex/cmdevt.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cmdevt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
index 0c3b217247b1..5fd6c53d7b06 100644
--- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
@@ -1056,12 +1056,10 @@ mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter)
 	list_for_each_entry_safe(cmd_node, tmp_node,
 				 &adapter->cmd_pending_q, list) {
 		list_del(&cmd_node->list);
-		spin_unlock_irqrestore(&adapter->cmd_pending_q_lock, flags);
 
 		if (cmd_node->wait_q_enabled)
 			adapter->cmd_wait_q.status = -1;
 		mwifiex_recycle_cmd_node(adapter, cmd_node);
-		spin_lock_irqsave(&adapter->cmd_pending_q_lock, flags);
 	}
 	spin_unlock_irqrestore(&adapter->cmd_pending_q_lock, flags);
 	spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, cmd_flags);
-- 
2.13.0.rc2.291.g57267f2277-goog
