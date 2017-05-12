Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f47.google.com ([74.125.83.47]:33866 "EHLO
        mail-pg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933260AbdELQme (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 May 2017 12:42:34 -0400
Received: by mail-pg0-f47.google.com with SMTP id u28so32713994pgn.1
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
Subject: [PATCH 10/11] mwifiex: pcie: remove useless pdev check
Date: Fri, 12 May 2017 09:42:07 -0700
Message-Id: <20170512164208.38725-10-briannorris@chromium.org> (sfid-20170512_184438_010811_F9AA5719)
In-Reply-To: <20170512164208.38725-1-briannorris@chromium.org>
References: <20170512164208.38725-1-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index ac62bce50e96..d7e563a622f7 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -2380,11 +2380,6 @@ static irqreturn_t mwifiex_pcie_interrupt(int irq, void *context)
 	struct pcie_service_card *card;
 	struct mwifiex_adapter *adapter;
 
-	if (!pdev) {
-		pr_err("info: %s: pdev is NULL\n", __func__);
-		goto exit;
-	}
-
 	card = pci_get_drvdata(pdev);
 
 	if (!card->adapter) {
-- 
2.13.0.rc2.291.g57267f2277-goog
