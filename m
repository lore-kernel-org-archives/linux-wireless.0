Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:6505 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303AbZFLTod (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 15:44:33 -0400
Received: by wf-out-1314.google.com with SMTP id 26so921299wfd.4
        for <linux-wireless@vger.kernel.org>; Fri, 12 Jun 2009 12:44:35 -0700 (PDT)
From: Andrey Yurovsky <andrey@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: libertas-dev@lists.infradead.org, dcbw@redhat.com,
	Andrey Yurovsky <andrey@cozybit.com>,
	Javier Cardona <javier@cozybit.com>
Subject: [PATCH v2] libertas: fix IEEE PS mode in GSPI driver
Date: Fri, 12 Jun 2009 12:45:36 -0700
Message-Id: <1244835936-17188-1-git-send-email-andrey@cozybit.com>
In-Reply-To: <1244762625-29618-1-git-send-email-andrey@cozybit.com>
References: <1244762625-29618-1-git-send-email-andrey@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The card firmware does not set the Command Download Ready interrupt bit
when IEEE PS mode is enabled, preventing the driver from sending
commands (such as the command to exit IEEE PS mode) since there is no
indication that the card is ready to accept commands.

This patch works around the problem by using the the TX Download Ready
bit in place of the Command Download Ready Bit while in IEEE PS mode.
TX Download Ready is set in IEEE PS mode.

Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 drivers/net/wireless/libertas/if_spi.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_spi.c b/drivers/net/wireless/libertas/if_spi.c
index f8c2898..dc2a1f6 100644
--- a/drivers/net/wireless/libertas/if_spi.c
+++ b/drivers/net/wireless/libertas/if_spi.c
@@ -875,7 +875,12 @@ static int lbs_spi_thread(void *data)
 			err = if_spi_c2h_data(card);
 			if (err)
 				goto err;
-		if (hiStatus & IF_SPI_HIST_CMD_DOWNLOAD_RDY) {
+
+		/* workaround: in PS mode, the card does not set the Command
+		 * Download Ready bit, but it sets TX Download Ready. */
+		if (hiStatus & IF_SPI_HIST_CMD_DOWNLOAD_RDY ||
+		   (card->priv->psstate != PS_STATE_FULL_POWER &&
+		    (hiStatus & IF_SPI_HIST_TX_DOWNLOAD_RDY))) {
 			/* This means two things. First of all,
 			 * if there was a previous command sent, the card has
 			 * successfully received it.
-- 
1.5.6.3

