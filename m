Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from glaubenleben.de ([85.214.105.140]:57643 "EHLO glaubenleben.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018AbcAFVTh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2016 16:19:37 -0500
From: Andreas Kemnade <andreas@kemnade.info>
To: Kalle Valo <kvalo@codeaurora.org>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Andreas Kemnade <andreas@kemnade.info>
Subject: [PATCH 6/6] wireless:libertas: fix suspend problems
Date: Wed,  6 Jan 2016 22:08:14 +0100
Message-Id: <1452114494-6451-7-git-send-email-andreas@kemnade.info> (sfid-20160106_221939_677301_557866A1)
In-Reply-To: <1452114494-6451-1-git-send-email-andreas@kemnade.info>
References: <1452114494-6451-1-git-send-email-andreas@kemnade.info>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the device goes to suspend mode with powersaving enabled,
lbs_remove_card tries to exit powersaving state even
when already woken up. That command is not processed properly in
that situation, so the system hangs at suspend,
so disable it.

Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
---
 drivers/net/wireless/libertas/main.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 8079560..b35b8bc 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -1060,7 +1060,12 @@ void lbs_remove_card(struct lbs_private *priv)
 
 	if (priv->psmode == LBS802_11POWERMODEMAX_PSP) {
 		priv->psmode = LBS802_11POWERMODECAM;
-		lbs_set_ps_mode(priv, PS_MODE_ACTION_EXIT_PS, true);
+		/* no need to wakeup if already woken up,
+		 * on suspend, this exit ps command is not processed
+		 * the driver hangs
+		 */
+		if (priv->psstate != PS_STATE_FULL_POWER)
+			lbs_set_ps_mode(priv, PS_MODE_ACTION_EXIT_PS, true);
 	}
 
 	if (priv->is_deep_sleep) {
-- 
2.1.4

