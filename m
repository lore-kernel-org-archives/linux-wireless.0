Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56529 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762765AbXLMG7R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 01:59:17 -0500
Subject: [PATCH 58/48] libertas: don't run thread while firmware not yet ready
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J2i2Z-0005rW-UI@shinybook.infradead.org> (sfid-20071213_070111_121046_DD4DEA51)
Date: Thu, 13 Dec 2007 01:59:27 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Tue, 11 Dec 2007 11:55:37 -0500

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/main.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 8866402..9a23109 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -671,6 +671,8 @@ static int lbs_thread(void *data)
 			shouldsleep = 1;	/* Sleep mode. Nothing we can do till it wakes */
 		else if (priv->intcounter)
 			shouldsleep = 0;	/* Interrupt pending. Deal with it now */
+		else if (!priv->fw_ready)
+			shouldsleep = 1;	/* Firmware not ready. We're waiting for it */
 		else if (priv->dnld_sent)
 			shouldsleep = 1;	/* Something is en route to the device already */
 		else if (priv->tx_pending_len > 0)
@@ -753,6 +755,9 @@ static int lbs_thread(void *data)
 		} else
 			spin_unlock_irq(&priv->driver_lock);
 
+		if (!priv->fw_ready)
+			continue;
+
 		/* Check if we need to confirm Sleep Request received previously */
 		if (priv->psstate == PS_STATE_PRE_SLEEP &&
 		    !priv->dnld_sent && !priv->cur_cmd) {
-- 
1.5.3.4

