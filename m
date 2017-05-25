Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:36142 "EHLO
        mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1164701AbdEYALk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 May 2017 20:11:40 -0400
Received: by mail-pf0-f177.google.com with SMTP id m17so150174973pfg.3
        for <linux-wireless@vger.kernel.org>; Wed, 24 May 2017 17:11:40 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Cc: <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH 07/14] mwifiex: fixup init_channel_scan_gap error case
Date: Wed, 24 May 2017 17:11:12 -0700
Message-Id: <20170525001119.64791-7-briannorris@chromium.org> (sfid-20170525_021527_917192_4CF061F2)
In-Reply-To: <20170525001119.64791-1-briannorris@chromium.org>
References: <20170525001119.64791-1-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In reading through _mwifiex_fw_dpc(), I noticed that after we've
registered our wiphy, we still have error paths that don't free it back
up. Let's do that.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/marvell/mwifiex/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index be3badba028a..c6cdbc311471 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -584,7 +584,7 @@ static int _mwifiex_fw_dpc(const struct firmware *firmware, void *context)
 	if (mwifiex_init_channel_scan_gap(adapter)) {
 		mwifiex_dbg(adapter, ERROR,
 			    "could not init channel stats table\n");
-		goto err_init_fw;
+		goto err_init_chan_scan;
 	}
 
 	if (driver_mode) {
@@ -632,6 +632,7 @@ static int _mwifiex_fw_dpc(const struct firmware *firmware, void *context)
 
 err_add_intf:
 	vfree(adapter->chan_stats);
+err_init_chan_scan:
 	wiphy_unregister(adapter->wiphy);
 	wiphy_free(adapter->wiphy);
 err_init_fw:
-- 
2.13.0.219.gdb65acc882-goog
