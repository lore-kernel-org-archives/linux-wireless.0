Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:65205 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932154Ab0IHXgS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 19:36:18 -0400
Received: by gyd8 with SMTP id 8so371337gyd.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Sep 2010 16:36:17 -0700 (PDT)
From: Steve deRosier <steve@cozybit.com>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: johannes@sipsolutions.net, javier@cozybit.com,
	Mattia Barbon <mbarbon@cpan.org>,
	Steve deRosier <steve@cozybit.com>
Subject: [PATCH 3/3] libertas_tf: flush the write queue in if_sdio_update_hw_spec.
Date: Wed,  8 Sep 2010 16:35:58 -0700
Message-Id: <1283988958-44928-3-git-send-email-steve@cozybit.com>
In-Reply-To: <1283988958-44928-1-git-send-email-steve@cozybit.com>
References: <1283988958-44928-1-git-send-email-steve@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mattia Barbon <mbarbon@cpan.org>

After queuing the CMD_GET_HW_SPEC command, force a flush of the
write queue before waiting for the command response.

Signed-off-by: Mattia Barbon <mbarbon@cpan.org>
Signed-off-by: Steve deRosier <steve@cozybit.com>
---
 drivers/net/wireless/libertas_tf/if_sdio.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/libertas_tf/if_sdio.c b/drivers/net/wireless/libertas_tf/if_sdio.c
index d3d101e..8660229 100644
--- a/drivers/net/wireless/libertas_tf/if_sdio.c
+++ b/drivers/net/wireless/libertas_tf/if_sdio.c
@@ -946,6 +946,8 @@ int if_sdio_update_hw_spec(struct if_sdio_card *card)
 		goto out;
 	}
 
+	flush_workqueue(card->workqueue);
+
 	/* Wait for and retrieve response */
 	timeout = jiffies + HZ;
 	while (wait_cmd_done < 1) {
-- 
1.7.0

