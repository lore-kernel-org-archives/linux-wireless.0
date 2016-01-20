Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from glaubenleben.de ([85.214.105.140]:44445 "EHLO glaubenleben.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758123AbcATHg6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2016 02:36:58 -0500
From: Andreas Kemnade <andreas@kemnade.info>
To: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, hns@goldelico.com
Cc: Andreas Kemnade <andreas@kemnade.info>
Subject: [PATCH v2 5/6] wireless:libertas: fix ps-mode related removal problems
Date: Wed, 20 Jan 2016 08:35:38 +0100
Message-Id: <1453275339-25122-6-git-send-email-andreas@kemnade.info> (sfid-20160120_083831_030872_0A350CEB)
In-Reply-To: <1453275339-25122-1-git-send-email-andreas@kemnade.info>
References: <1453275339-25122-1-git-send-email-andreas@kemnade.info>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the device is remove e.g. because of going to suspend
 mode with powersaving enabled, lbs_remove_card tries to exit
powersaving state even when already woken up. That command is
not processed properly in that situation, since the command
processing queue is already stopped, so it waits forever
for the command being processed, so disable it.

Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
---
changes in v2: improved commit message, reordered: was 6/6
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

