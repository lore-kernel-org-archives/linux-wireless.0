Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29698 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbbKZMFV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 07:05:21 -0500
Date: Thu, 26 Nov 2015 15:04:49 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch] libertas: cleanup a variable name
Message-ID: <20151126120449.GK10556@mwanda> (sfid-20151126_130536_337985_CEE46E51)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"&card->priv->driver_lock" and "&priv->driver_lock" are the same and
it's nicer to use the shorter one consistently.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/marvell/libertas/if_sdio.c b/drivers/net/wireless/marvell/libertas/if_sdio.c
index 33ceda2..68fd3a9 100644
--- a/drivers/net/wireless/marvell/libertas/if_sdio.c
+++ b/drivers/net/wireless/marvell/libertas/if_sdio.c
@@ -228,7 +228,7 @@ static int if_sdio_handle_cmd(struct if_sdio_card *card,
 	memcpy(priv->resp_buf[i], buffer, size);
 	lbs_notify_command_response(priv, i);
 
-	spin_unlock_irqrestore(&card->priv->driver_lock, flags);
+	spin_unlock_irqrestore(&priv->driver_lock, flags);
 
 	ret = 0;
 
