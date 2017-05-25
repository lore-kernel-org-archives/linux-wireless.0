Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:34399 "EHLO
        mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1164694AbdEYALx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 May 2017 20:11:53 -0400
Received: by mail-pf0-f172.google.com with SMTP id 9so150117475pfj.1
        for <linux-wireless@vger.kernel.org>; Wed, 24 May 2017 17:11:53 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Cc: <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH 06/14] mwifiex: don't short-circuit netdev notifiers on interface deletion
Date: Wed, 24 May 2017 17:11:11 -0700
Message-Id: <20170525001119.64791-6-briannorris@chromium.org> (sfid-20170525_021434_411505_8E46FCE4)
In-Reply-To: <20170525001119.64791-1-briannorris@chromium.org>
References: <20170525001119.64791-1-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we leave the delete interface function, there are still netdev
hooks that might try to process the device. We're short-circuiting some
of that by changing the interface type and clearing ieee80211_ptr. This
means we skip NETDEV_UNREGISTER_FINAL in cfg80211. Fortunately, that is
currently a no-op.

We don't need most of the cleanup here anyway:

 * the connection state will get (un)set as part of the disconnect
   process (which cfg80211 already initiates for us)
 * the interface type doesn't actually need to be cleared at all (it'll
   trigger a WARN_ON() in cfg80211 if we do)
 * the iee80211_ptr isn't really "ours" to clear anyway

So stop resetting those 3 things.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 025bc06a19d6..c3a25b7f2b48 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -3129,11 +3129,7 @@ int mwifiex_del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev)
 		priv->dfs_chan_sw_workqueue = NULL;
 	}
 	/* Clear the priv in adapter */
-	priv->netdev->ieee80211_ptr = NULL;
 	priv->netdev = NULL;
-	priv->wdev.iftype = NL80211_IFTYPE_UNSPECIFIED;
-
-	priv->media_connected = false;
 
 	switch (priv->bss_mode) {
 	case NL80211_IFTYPE_UNSPECIFIED:
-- 
2.13.0.219.gdb65acc882-goog
