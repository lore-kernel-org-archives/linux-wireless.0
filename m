Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f43.google.com ([74.125.83.43]:33744 "EHLO
        mail-pg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933182AbdELQm1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 May 2017 12:42:27 -0400
Received: by mail-pg0-f43.google.com with SMTP id u187so32675385pgb.0
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
Subject: [PATCH 02/11] mwifiex: Don't release tx_ba_stream_tbl_lock while iterating
Date: Fri, 12 May 2017 09:41:59 -0700
Message-Id: <20170512164208.38725-2-briannorris@chromium.org> (sfid-20170512_184515_840364_687B7098)
In-Reply-To: <20170512164208.38725-1-briannorris@chromium.org>
References: <20170512164208.38725-1-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Douglas Anderson <dianders@chromium.org>

Despite the macro list_for_each_entry_safe() having the word "safe" in
the name, it's still not actually safe to release the list spinlock
while iterating over the list.  The "safe" in the macro name actually
only means that it's safe to delete the current entry while iterating
over the list.

Releasing the spinlock while iterating over the list means that someone
else could come in and adjust the list while we don't have the
spinlock.  If they do that it can totally mix up our iteration and fully
corrupt the list.  Later iterating over a corrupted list while holding a
spinlock and having IRQs off can cause all sorts of hard to debug
problems.

As evidenced by the other call to
mwifiex_11n_delete_tx_ba_stream_tbl_entry() in
mwifiex_11n_delete_all_tx_ba_stream_tbl(), it's actually safe to skip
the spinlock release.  Let's do that.

No known problems are fixed by this patch, but it could fix all sorts of
weird problems and it should be very safe.

Signed-off-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/marvell/mwifiex/11n.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/11n.c b/drivers/net/wireless/marvell/mwifiex/11n.c
index c174e79e6df2..c75b6abf16a0 100644
--- a/drivers/net/wireless/marvell/mwifiex/11n.c
+++ b/drivers/net/wireless/marvell/mwifiex/11n.c
@@ -764,14 +764,9 @@ void mwifiex_del_tx_ba_stream_tbl_by_ra(struct mwifiex_private *priv, u8 *ra)
 		return;
 
 	spin_lock_irqsave(&priv->tx_ba_stream_tbl_lock, flags);
-	list_for_each_entry_safe(tbl, tmp, &priv->tx_ba_stream_tbl_ptr, list) {
-		if (!memcmp(tbl->ra, ra, ETH_ALEN)) {
-			spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock,
-					       flags);
+	list_for_each_entry_safe(tbl, tmp, &priv->tx_ba_stream_tbl_ptr, list)
+		if (!memcmp(tbl->ra, ra, ETH_ALEN))
 			mwifiex_11n_delete_tx_ba_stream_tbl_entry(priv, tbl);
-			spin_lock_irqsave(&priv->tx_ba_stream_tbl_lock, flags);
-		}
-	}
 	spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock, flags);
 
 	return;
-- 
2.13.0.rc2.291.g57267f2277-goog
