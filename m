Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:60966 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752840AbYKUWkP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2008 17:40:15 -0500
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: [PATCH 2/2] rfkill: always call get_state() hook on resume
Date: Fri, 21 Nov 2008 20:40:10 -0200
Message-Id: <1227307210-11062-2-git-send-email-hmh@hmh.eng.br> (sfid-20081121_234027_856340_D0549503)
In-Reply-To: <1227307210-11062-1-git-send-email-hmh@hmh.eng.br>
References: <20081120150330.GC4329@tuxdriver.com>
 <1227307210-11062-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We "optimize" away the get_state() hook call on rfkill_toggle_radio
when doing a forced state change.  This means the resume path is not
calling get_state() as it should.

Call it manually on the resume handler, as we don't want to mess with
the EPO path by removing the optimization.  This has the added benefit
of making it explicit that rfkill->state could have been modified
before we hit the rfkill_toggle_radio() call in the class resume
handler.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
---
 net/rfkill/rfkill.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index 4113454..ff3af0e 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -580,6 +580,7 @@ static int rfkill_suspend(struct device *dev, pm_message_t state)
 static int rfkill_resume(struct device *dev)
 {
 	struct rfkill *rfkill = to_rfkill(dev);
+	enum rfkill_state newstate;
 
 	if (dev->power.power_state.event != PM_EVENT_ON) {
 		mutex_lock(&rfkill->mutex);
@@ -587,6 +588,15 @@ static int rfkill_resume(struct device *dev)
 		dev->power.power_state.event = PM_EVENT_ON;
 
 		/*
+		 * rfkill->state could have been modified before we got
+		 * called, and won't be updated by rfkill_toggle_radio()
+		 * in force mode.  Sync it FIRST.
+		 */
+		if (rfkill->get_state &&
+		    !rfkill->get_state(rfkill->data, &newstate))
+			rfkill->state = newstate;
+
+		/*
 		 * If we are under EPO, kick transmitter offline,
 		 * otherwise restore to pre-suspend state.
 		 *
-- 
1.5.6.5

