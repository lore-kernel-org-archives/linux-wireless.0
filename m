Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:33427 "EHLO
        mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1164719AbdEYALm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 May 2017 20:11:42 -0400
Received: by mail-pf0-f174.google.com with SMTP id e193so150313047pfh.0
        for <linux-wireless@vger.kernel.org>; Wed, 24 May 2017 17:11:42 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Cc: <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH 10/14] mwifiex: pcie: stop masking interrupts in FW downloader
Date: Wed, 24 May 2017 17:11:15 -0700
Message-Id: <20170525001119.64791-10-briannorris@chromium.org> (sfid-20170525_021436_878044_906A99EC)
In-Reply-To: <20170525001119.64791-1-briannorris@chromium.org>
References: <20170525001119.64791-1-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The upper layers already have disabled our interrupts (haven't called
->enable_int() yet for probe(), and we call ->disable_int() before
trying to reset), so this is redundant.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 7d5a4f2a9a22..c86119b05f52 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -2113,12 +2113,6 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 		    "info: Downloading FW image (%d bytes)\n",
 		    firmware_len);
 
-	if (__mwifiex_pcie_disable_host_int(adapter)) {
-		mwifiex_dbg(adapter, ERROR,
-			    "%s: Disabling interrupts failed.\n", __func__);
-		return -1;
-	}
-
 	skb = dev_alloc_skb(MWIFIEX_UPLD_SIZE);
 	if (!skb) {
 		ret = -ENOMEM;
-- 
2.13.0.219.gdb65acc882-goog
