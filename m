Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:59406 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753748AbYJIVPm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2008 17:15:42 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Ivo van Doorn <IvDoorn@gmail.com>
Subject: [PATCH 4/5] rfkill: honour EPO state when resuming a rfkill controller
Date: Thu,  9 Oct 2008 18:15:32 -0300
Message-Id: <1223586933-17753-5-git-send-email-hmh@hmh.eng.br> (sfid-20081009_231548_327375_EC985787)
In-Reply-To: <1223586933-17753-1-git-send-email-hmh@hmh.eng.br>
References: <1223586933-17753-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rfkill_resume() would always restore the rfkill controller state to its
pre-suspend state.

Now that we know when we are under EPO, kick the rfkill controller to
SOFT_BLOCKED state instead of to its pre-suspend state when it is resumed
while EPO mode is active.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ivo van Doorn <IvDoorn@gmail.com>
---
 net/rfkill/rfkill.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index e348eab..c9180c8 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -581,8 +581,17 @@ static int rfkill_resume(struct device *dev)
 
 		dev->power.power_state.event = PM_EVENT_ON;
 
-		/* restore radio state AND notify everybody */
-		rfkill_toggle_radio(rfkill, rfkill->state, 1);
+		/*
+		 * If we are under EPO, kick transmitter offline,
+		 * otherwise restore to pre-suspend state.
+		 *
+		 * Issue a notification in any case
+		 */
+		rfkill_toggle_radio(rfkill,
+				rfkill_epo_lock_active ?
+					RFKILL_STATE_SOFT_BLOCKED :
+					rfkill->state,
+				1);
 
 		mutex_unlock(&rfkill->mutex);
 	}
-- 
1.5.6.5

