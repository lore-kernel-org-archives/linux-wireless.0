Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:36329 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298Ab1JMMVt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Oct 2011 08:21:49 -0400
Subject: [PATCH 3/4] ath6kl: don't dump full htc packets
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 13 Oct 2011 15:21:45 +0300
Message-ID: <20111013122145.30551.50371.stgit@localhost6.localdomain6> (sfid-20111013_142153_833130_5467B57A)
In-Reply-To: <20111013122115.30551.94.stgit@localhost6.localdomain6>
References: <20111013122115.30551.94.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's currently possible to dump full sdio packets, so dumping htc packets
is not strictly needed. So remove it, we can always add it back if
there ever comes a need for that.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/htc.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
index 840f1b3..3cd3ef5 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.c
+++ b/drivers/net/wireless/ath/ath6kl/htc.c
@@ -1431,10 +1431,6 @@ static int ath6kl_htc_rx_process_hdr(struct htc_target *target,
 	if (n_lkahds != NULL)
 		*n_lkahds = 0;
 
-	/* FIXME: is this needed? */
-	ath6kl_dbg_dump(ATH6KL_DBG_HTC, "htc rx", "htc rx",
-			packet->buf, packet->act_len);
-
 	/*
 	 * NOTE: we cannot assume the alignment of buf, so we use the safe
 	 * macros to retrieve 16 bit fields.
@@ -1516,13 +1512,6 @@ fail_rx:
 	if (status)
 		ath6kl_dbg_dump(ATH6KL_DBG_HTC, "htc rx bad packet",
 				"", packet->buf, packet->act_len);
-	else {
-		/* FIXME: is this needed? */
-		if (packet->act_len > 0)
-			ath6kl_dbg_dump(ATH6KL_DBG_HTC,
-					"htc rx application message", "",
-					packet->buf, packet->act_len);
-	}
 
 	return status;
 }

