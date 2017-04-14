Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f53.google.com ([74.125.83.53]:34619 "EHLO
        mail-pg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755186AbdDNVvt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Apr 2017 17:51:49 -0400
Received: by mail-pg0-f53.google.com with SMTP id 21so47981793pgg.1
        for <linux-wireless@vger.kernel.org>; Fri, 14 Apr 2017 14:51:49 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Cc: <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH 4/4] mwifiex: don't leak 'chan_stats' on reset
Date: Fri, 14 Apr 2017 14:51:20 -0700
Message-Id: <20170414215120.145038-4-briannorris@chromium.org> (sfid-20170414_235253_541307_C7122817)
In-Reply-To: <20170414215120.145038-1-briannorris@chromium.org>
References: <20170414215120.145038-1-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

'chan_stats' is (re)allocated in _mwifiex_fw_dpc() ->
mwifiex_init_channel_scan_gap(), which is called whenever the device is
initialized -- at probe or at reset.

But we only free it in we completely unregister the adapter, meaning we
leak a copy of it during every reset.

Let's free it in the shutdown / removal paths instead (and in the
error-handling path), to avoid the leak.

Ideally, we can eventually unify much of mwifiex_shutdown_sw() and
mwifiex_remove_card() (way too much copy-and-paste) to reduce the burden
on bugfixes like this. But that's work for tomorrow.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
Technically a bugfix, but I don't know where to "blame" it.

 drivers/net/wireless/marvell/mwifiex/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index 89eccd7adbe5..31fa62c4c148 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -149,7 +149,6 @@ static int mwifiex_unregister(struct mwifiex_adapter *adapter)
 
 	kfree(adapter->regd);
 
-	vfree(adapter->chan_stats);
 	kfree(adapter);
 	return 0;
 }
@@ -633,6 +632,7 @@ static int _mwifiex_fw_dpc(const struct firmware *firmware, void *context)
 	goto done;
 
 err_add_intf:
+	vfree(adapter->chan_stats);
 	wiphy_unregister(adapter->wiphy);
 	wiphy_free(adapter->wiphy);
 err_init_fw:
@@ -1417,6 +1417,7 @@ mwifiex_shutdown_sw(struct mwifiex_adapter *adapter)
 			mwifiex_del_virtual_intf(adapter->wiphy, &priv->wdev);
 		rtnl_unlock();
 	}
+	vfree(adapter->chan_stats);
 
 	mwifiex_dbg(adapter, INFO, "%s, successful\n", __func__);
 exit_return:
@@ -1728,6 +1729,7 @@ int mwifiex_remove_card(struct mwifiex_adapter *adapter)
 			mwifiex_del_virtual_intf(adapter->wiphy, &priv->wdev);
 		rtnl_unlock();
 	}
+	vfree(adapter->chan_stats);
 
 	wiphy_unregister(adapter->wiphy);
 	wiphy_free(adapter->wiphy);
-- 
2.12.2.762.g0e3151a226-goog
