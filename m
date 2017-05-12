Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f42.google.com ([74.125.83.42]:33752 "EHLO
        mail-pg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933216AbdELQm3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 May 2017 12:42:29 -0400
Received: by mail-pg0-f42.google.com with SMTP id u187so32675722pgb.0
        for <linux-wireless@vger.kernel.org>; Fri, 12 May 2017 09:42:28 -0700 (PDT)
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
Subject: [PATCH 04/11] mwifiex: Add locking to mwifiex_11n_delba
Date: Fri, 12 May 2017 09:42:01 -0700
Message-Id: <20170512164208.38725-4-briannorris@chromium.org> (sfid-20170512_184436_738989_5DCC1919)
In-Reply-To: <20170512164208.38725-1-briannorris@chromium.org>
References: <20170512164208.38725-1-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Douglas Anderson <dianders@chromium.org>

The mwifiex_11n_delba() function walked the rx_reorder_tbl_ptr without
holding the lock, which was an obvious violation.

Grab the lock.

NOTE: we hold the lock while calling mwifiex_send_delba().  There's also
several callers in 11n_rxreorder.c that hold the lock and the comments
in the struct sound just like very other list/lock pair -- as if the
lock should definitely be help for all operations like this.

Signed-off-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/marvell/mwifiex/11n.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/11n.c b/drivers/net/wireless/marvell/mwifiex/11n.c
index c75b6abf16a0..16c77c27f1b6 100644
--- a/drivers/net/wireless/marvell/mwifiex/11n.c
+++ b/drivers/net/wireless/marvell/mwifiex/11n.c
@@ -653,11 +653,13 @@ int mwifiex_send_delba(struct mwifiex_private *priv, int tid, u8 *peer_mac,
 void mwifiex_11n_delba(struct mwifiex_private *priv, int tid)
 {
 	struct mwifiex_rx_reorder_tbl *rx_reor_tbl_ptr;
+	unsigned long flags;
 
+	spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
 	if (list_empty(&priv->rx_reorder_tbl_ptr)) {
 		dev_dbg(priv->adapter->dev,
 			"mwifiex_11n_delba: rx_reorder_tbl_ptr empty\n");
-		return;
+		goto exit;
 	}
 
 	list_for_each_entry(rx_reor_tbl_ptr, &priv->rx_reorder_tbl_ptr, list) {
@@ -666,9 +668,11 @@ void mwifiex_11n_delba(struct mwifiex_private *priv, int tid)
 				"Send delba to tid=%d, %pM\n",
 				tid, rx_reor_tbl_ptr->ta);
 			mwifiex_send_delba(priv, tid, rx_reor_tbl_ptr->ta, 0);
-			return;
+			goto exit;
 		}
 	}
+exit:
+	spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
 }
 
 /*
-- 
2.13.0.rc2.291.g57267f2277-goog
