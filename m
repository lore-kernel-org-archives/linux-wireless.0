Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:36147 "EHLO
        mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1164706AbdEYALl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 May 2017 20:11:41 -0400
Received: by mail-pf0-f169.google.com with SMTP id m17so150175208pfg.3
        for <linux-wireless@vger.kernel.org>; Wed, 24 May 2017 17:11:41 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Cc: <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH 08/14] mwifiex: ensure "disable auto DS" struct is initialized
Date: Wed, 24 May 2017 17:11:13 -0700
Message-Id: <20170525001119.64791-8-briannorris@chromium.org> (sfid-20170525_021433_262212_D15CA579)
In-Reply-To: <20170525001119.64791-1-briannorris@chromium.org>
References: <20170525001119.64791-1-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The .idle_time field *should* be unused, but technically, we're allowing
unitialized stack garbage to pass all the way through to the firmware
host command. Let's zero it out instead.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
index 42997e05d90f..43ecd621d1ef 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
@@ -654,9 +654,9 @@ int mwifiex_get_bss_info(struct mwifiex_private *priv,
  */
 int mwifiex_disable_auto_ds(struct mwifiex_private *priv)
 {
-	struct mwifiex_ds_auto_ds auto_ds;
-
-	auto_ds.auto_ds = DEEP_SLEEP_OFF;
+	struct mwifiex_ds_auto_ds auto_ds = {
+		.auto_ds = DEEP_SLEEP_OFF,
+	};
 
 	return mwifiex_send_cmd(priv, HostCmd_CMD_802_11_PS_MODE_ENH,
 				DIS_AUTO_PS, BITMAP_AUTO_DS, &auto_ds, true);
-- 
2.13.0.219.gdb65acc882-goog
