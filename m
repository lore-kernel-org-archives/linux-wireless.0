Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from glaubenleben.de ([85.214.105.140]:53800 "EHLO glaubenleben.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757049AbcA3RCT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jan 2016 12:02:19 -0500
From: Andreas Kemnade <andreas@kemnade.info>
To: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, hns@goldelico.com
Cc: Andreas Kemnade <andreas@kemnade.info>
Subject: [PATCH v3 3/6] libertas: do not confirm sleep if commands are pending
Date: Sat, 30 Jan 2016 18:01:53 +0100
Message-Id: <1454173316-13444-4-git-send-email-andreas@kemnade.info> (sfid-20160130_180310_385738_71099238)
In-Reply-To: <1454173316-13444-1-git-send-email-andreas@kemnade.info>
References: <1454173316-13444-1-git-send-email-andreas@kemnade.info>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the main thread gets one PS AWAKE event and one PS SLEEP event
in one iteration over event_fifo there will never be checks for
commands to be processed, since psstate will always be
PS_STATE_SLEEP or PS_STATE_PRE_SLEEP

Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
---
changes in v3: corrected paths
changes in v2: reordered: was 4/6
 drivers/net/wireless/marvell/libertas/cmdresp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/marvell/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index 701125f..c95bf6d 100644
--- a/drivers/net/wireless/marvell/libertas/cmdresp.c
+++ b/drivers/net/wireless/marvell/libertas/cmdresp.c
@@ -257,6 +257,10 @@ int lbs_process_event(struct lbs_private *priv, u32 event)
 			       "EVENT: in FULL POWER mode, ignoring PS_SLEEP\n");
 			break;
 		}
+		if (!list_empty(&priv->cmdpendingq)) {
+			lbs_deb_cmd("EVENT: commands in queue, do not sleep\n");
+			break;
+		}
 		priv->psstate = PS_STATE_PRE_SLEEP;
 
 		lbs_ps_confirm_sleep(priv);
-- 
2.1.4

