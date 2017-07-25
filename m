Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f51.google.com ([74.125.83.51]:35771 "EHLO
        mail-pg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756803AbdGYBO2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Jul 2017 21:14:28 -0400
Received: by mail-pg0-f51.google.com with SMTP id v190so64053056pgv.2
        for <linux-wireless@vger.kernel.org>; Mon, 24 Jul 2017 18:14:28 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Cc: <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH v2 19/20] mwifiex: keep mwifiex_cancel_pending_ioctl() static
Date: Mon, 24 Jul 2017 18:13:35 -0700
Message-Id: <20170725011336.99993-20-briannorris@chromium.org> (sfid-20170725_031610_393545_3DD4FF4B)
In-Reply-To: <20170725011336.99993-1-briannorris@chromium.org>
References: <20170725011336.99993-1-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It has some scary comments about "only being called" from the timeout
handler, so let's help keep it that way.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
new in v2
---
 drivers/net/wireless/marvell/mwifiex/cmdevt.c | 4 +++-
 drivers/net/wireless/marvell/mwifiex/main.h   | 1 -
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cmdevt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
index 3f5e822673bf..0edc5d621304 100644
--- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
@@ -26,6 +26,8 @@
 #include "11n.h"
 #include "11ac.h"
 
+static void mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter);
+
 /*
  * This function initializes a command node.
  *
@@ -1074,7 +1076,7 @@ mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter)
  * In case of scan commands, all pending commands in scan pending queue
  * are cancelled.
  */
-void
+static void
 mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter)
 {
 	struct cmd_ctrl_node *cmd_node = NULL;
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index 909bd1ad3838..537a0ad795ff 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -1080,7 +1080,6 @@ int mwifiex_alloc_cmd_buffer(struct mwifiex_adapter *adapter);
 void mwifiex_free_cmd_buffer(struct mwifiex_adapter *adapter);
 void mwifiex_free_cmd_buffers(struct mwifiex_adapter *adapter);
 void mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter);
-void mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter);
 void mwifiex_cancel_pending_scan_cmd(struct mwifiex_adapter *adapter);
 void mwifiex_cancel_scan(struct mwifiex_adapter *adapter);
 
-- 
2.14.0.rc0.284.gd933b75aa4-goog
