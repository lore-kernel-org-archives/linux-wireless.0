Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f189.google.com ([209.85.216.189]:46459 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650AbZFRCN7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2009 22:13:59 -0400
Received: by pxi27 with SMTP id 27so743973pxi.33
        for <linux-wireless@vger.kernel.org>; Wed, 17 Jun 2009 19:14:02 -0700 (PDT)
From: Andrey Yurovsky <andrey@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: libertas-dev@lists.infradead.org, Dan Williams <dcbw@redhat.com>,
	Andrey Yurovsky <andrey@cozybit.com>
Subject: [PATCH] libertas: fix card cleanup order in SDIO driver
Date: Wed, 17 Jun 2009 19:15:19 -0700
Message-Id: <1245291319-26118-1-git-send-email-andrey@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The SDIO driver sets the surpriseremoved flag before calling
lbs_remove_card.  With IEEE PS enabled, lbs_remove_card must issue a
command to exit IEEE PS mode, however with that flag set the command
path is blocked and the card is never taken out of IEEE PS mode.  This
step is required to ensure that the driver can be reloaded.  This patch
moves the setting of surpriseremoved after lbs_remove_card is called.

Tested with V9 firmware by ensuring that IEEE PS is disabled when the
driver is removed.  Reloading the driver is not fully tested due to a
separate issue with module reload in the SDIO driver, however this
patch at least leaves the card in a better state when we bring the
driver down.

Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
---
 drivers/net/wireless/libertas/if_sdio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
index 8cdb88c..d48ed62 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -1096,11 +1096,11 @@ static void if_sdio_remove(struct sdio_func *func)
 			lbs_pr_alert("CMD_FUNC_SHUTDOWN cmd failed\n");
 	}
 
-	card->priv->surpriseremoved = 1;
 
 	lbs_deb_sdio("call remove card\n");
 	lbs_stop_card(card->priv);
 	lbs_remove_card(card->priv);
+	card->priv->surpriseremoved = 1;
 
 	flush_workqueue(card->workqueue);
 	destroy_workqueue(card->workqueue);
-- 
1.5.6.3

