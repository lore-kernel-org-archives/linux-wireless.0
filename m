Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:33611 "EHLO
        mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756746AbdGYBOS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Jul 2017 21:14:18 -0400
Received: by mail-pf0-f174.google.com with SMTP id s70so53108258pfs.0
        for <linux-wireless@vger.kernel.org>; Mon, 24 Jul 2017 18:14:18 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Cc: <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH v2 07/20] mwifiex: fixup init_channel_scan_gap error case
Date: Mon, 24 Jul 2017 18:13:23 -0700
Message-Id: <20170725011336.99993-8-briannorris@chromium.org> (sfid-20170725_032001_756856_344AEB4F)
In-Reply-To: <20170725011336.99993-1-briannorris@chromium.org>
References: <20170725011336.99993-1-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In reading through _mwifiex_fw_dpc(), I noticed that after we've
registered our wiphy, we still have error paths that don't free it back
up. Let's do that.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
v2: no change
---
 drivers/net/wireless/marvell/mwifiex/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index 77e491720664..0448dcc07139 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -588,7 +588,7 @@ static int _mwifiex_fw_dpc(const struct firmware *firmware, void *context)
 	if (mwifiex_init_channel_scan_gap(adapter)) {
 		mwifiex_dbg(adapter, ERROR,
 			    "could not init channel stats table\n");
-		goto err_init_fw;
+		goto err_init_chan_scan;
 	}
 
 	if (driver_mode) {
@@ -636,6 +636,7 @@ static int _mwifiex_fw_dpc(const struct firmware *firmware, void *context)
 
 err_add_intf:
 	vfree(adapter->chan_stats);
+err_init_chan_scan:
 	wiphy_unregister(adapter->wiphy);
 	wiphy_free(adapter->wiphy);
 err_init_fw:
-- 
2.14.0.rc0.284.gd933b75aa4-goog
