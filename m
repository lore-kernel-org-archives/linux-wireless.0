Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:34587 "EHLO
        mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933057AbdCKBjd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Mar 2017 20:39:33 -0500
Received: by mail-pf0-f170.google.com with SMTP id v190so48012772pfb.1
        for <linux-wireless@vger.kernel.org>; Fri, 10 Mar 2017 17:39:33 -0800 (PST)
From: Brian Norris <briannorris@chromium.org>
To: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rajat Jain <rajatja@google.com>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH 3/4] mwifiex: uninit wakeup info when removing device
Date: Fri, 10 Mar 2017 17:39:23 -0800
Message-Id: <20170311013924.73348-4-briannorris@chromium.org> (sfid-20170311_024040_108776_00C33B1E)
In-Reply-To: <20170311013924.73348-1-briannorris@chromium.org>
References: <20170311013924.73348-1-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We manually init wakeup info, but we don't detach it on device removal.
This means that if we (for example) rmmod + modprobe the driver, the
device framework might return -EEXIST the second time, and we'll
complain in the logs:

[  839.311881] mwifiex_pcie 0000:01:00.0: fail to init wakeup for mwifiex

AFAICT, there's no other negative effect.

But we can fix this by disabling wakeup on remove, similar to what a few
other drivers do (e.g., the power supply framework).

This code (and bug) has existed on SDIO for a while, but it got moved
around and enabled for PCIe with commit 853402a00823 ("mwifiex: Enable
WoWLAN for both sdio and pcie").

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/marvell/mwifiex/main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index 43d040e02e4d..b62e03d11c2e 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -1718,6 +1718,9 @@ int mwifiex_remove_card(struct mwifiex_adapter *adapter)
 	wiphy_unregister(adapter->wiphy);
 	wiphy_free(adapter->wiphy);
 
+	if (adapter->irq_wakeup >= 0)
+		device_init_wakeup(adapter->dev, false);
+
 	/* Unregister device */
 	mwifiex_dbg(adapter, INFO,
 		    "info: unregister device\n");
-- 
2.12.0.246.ga2ecc84866-goog
