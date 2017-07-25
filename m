Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f53.google.com ([74.125.83.53]:38624 "EHLO
        mail-pg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756809AbdGYBO3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Jul 2017 21:14:29 -0400
Received: by mail-pg0-f53.google.com with SMTP id s4so63909742pgr.5
        for <linux-wireless@vger.kernel.org>; Mon, 24 Jul 2017 18:14:29 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Cc: <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH v2 20/20] mwifiex: drop num CPU notice
Date: Mon, 24 Jul 2017 18:13:36 -0700
Message-Id: <20170725011336.99993-21-briannorris@chromium.org> (sfid-20170725_031608_287741_B7E2E452)
In-Reply-To: <20170725011336.99993-1-briannorris@chromium.org>
References: <20170725011336.99993-1-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This print isn't very useful. It's also different between
mwifiex_add_card() and mwifiex_reinit_sw(), and I'd like to consolidate
them eventually.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
new in v2
---
 drivers/net/wireless/marvell/mwifiex/main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index 0448dcc07139..13fc7b6ed11d 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -1619,10 +1619,8 @@ mwifiex_add_card(void *card, struct completion *fw_done,
 	adapter->cmd_wait_q.status = 0;
 	adapter->scan_wait_q_woken = false;
 
-	if ((num_possible_cpus() > 1) || adapter->iface_type == MWIFIEX_USB) {
+	if ((num_possible_cpus() > 1) || adapter->iface_type == MWIFIEX_USB)
 		adapter->rx_work_enabled = true;
-		pr_notice("rx work enabled, cpus %d\n", num_possible_cpus());
-	}
 
 	adapter->workqueue =
 		alloc_workqueue("MWIFIEX_WORK_QUEUE",
-- 
2.14.0.rc0.284.gd933b75aa4-goog
