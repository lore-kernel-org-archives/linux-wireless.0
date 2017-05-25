Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:35185 "EHLO
        mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1164717AbdEYALm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 May 2017 20:11:42 -0400
Received: by mail-pf0-f177.google.com with SMTP id n23so150181971pfb.2
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
Subject: [PATCH 09/14] mwifiex: pcie: remove redundant synchronize_irq()
Date: Wed, 24 May 2017 17:11:14 -0700
Message-Id: <20170525001119.64791-9-briannorris@chromium.org> (sfid-20170525_021432_692869_B3F8129B)
In-Reply-To: <20170525001119.64791-1-briannorris@chromium.org>
References: <20170525001119.64791-1-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

free_irq() already calls synchronize_irq() in a non-racy manner. Calling
synchronize_irq() here is redundant.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 3d5c29d79609..7d5a4f2a9a22 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -3209,9 +3209,6 @@ static void mwifiex_unregister_dev(struct mwifiex_adapter *adapter)
 
 	if (card->msix_enable) {
 		for (i = 0; i < MWIFIEX_NUM_MSIX_VECTORS; i++)
-			synchronize_irq(card->msix_entries[i].vector);
-
-		for (i = 0; i < MWIFIEX_NUM_MSIX_VECTORS; i++)
 			free_irq(card->msix_entries[i].vector,
 				 &card->msix_ctx[i]);
 
-- 
2.13.0.219.gdb65acc882-goog
