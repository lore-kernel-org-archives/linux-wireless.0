Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:33246 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933252AbdELQmd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 May 2017 12:42:33 -0400
Received: by mail-pf0-f175.google.com with SMTP id e193so32710634pfh.0
        for <linux-wireless@vger.kernel.org>; Fri, 12 May 2017 09:42:33 -0700 (PDT)
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
Subject: [PATCH 09/11] mwifiex: 11h: drop unnecessary check for '!priv'
Date: Fri, 12 May 2017 09:42:06 -0700
Message-Id: <20170512164208.38725-9-briannorris@chromium.org> (sfid-20170512_184438_561186_3B9CE39F)
In-Reply-To: <20170512164208.38725-1-briannorris@chromium.org>
References: <20170512164208.38725-1-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These pointers are retrieved via container_of(). There's no way they are
NULL.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/marvell/mwifiex/11h.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/11h.c b/drivers/net/wireless/marvell/mwifiex/11h.c
index 366eb4991a7d..238accfe4f41 100644
--- a/drivers/net/wireless/marvell/mwifiex/11h.c
+++ b/drivers/net/wireless/marvell/mwifiex/11h.c
@@ -128,9 +128,6 @@ void mwifiex_dfs_cac_work_queue(struct work_struct *work)
 			container_of(delayed_work, struct mwifiex_private,
 				     dfs_cac_work);
 
-	if (WARN_ON(!priv))
-		return;
-
 	chandef = priv->dfs_chandef;
 	if (priv->wdev.cac_started) {
 		mwifiex_dbg(priv->adapter, MSG,
@@ -289,9 +286,6 @@ void mwifiex_dfs_chan_sw_work_queue(struct work_struct *work)
 			container_of(delayed_work, struct mwifiex_private,
 				     dfs_chan_sw_work);
 
-	if (WARN_ON(!priv))
-		return;
-
 	bss_cfg = &priv->bss_cfg;
 	if (!bss_cfg->beacon_period) {
 		mwifiex_dbg(priv->adapter, ERROR,
-- 
2.13.0.rc2.291.g57267f2277-goog
