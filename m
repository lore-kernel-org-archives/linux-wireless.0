Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:42335 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755907AbYKCQm0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 11:42:26 -0500
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: [PATCH 2/2] rfkill: always call get_state() hook on resume
Date: Mon,  3 Nov 2008 14:42:17 -0200
Message-Id: <1225730537-2679-3-git-send-email-hmh@hmh.eng.br> (sfid-20081103_174235_785569_732DC7D7)
In-Reply-To: <1225730537-2679-1-git-send-email-hmh@hmh.eng.br>
References: <1225730537-2679-1-git-send-email-hmh@hmh.eng.br>
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
Cc: Ivo van Doorn <IvDoorn@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
---
 net/rfkill/rfkill.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index caee717..7a82a35 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -526,6 +526,7 @@ static int rfkill_suspend(struct device *dev, pm_message_t state)
 static int rfkill_resume(struct device *dev)
 {
 	struct rfkill *rfkill = to_rfkill(dev);
+	enum rfkill_state newstate;
 
 	if (dev->power.power_state.event != PM_EVENT_ON) {
 		mutex_lock(&rfkill->mutex);
@@ -533,6 +534,9 @@ static int rfkill_resume(struct device *dev)
 		dev->power.power_state.event = PM_EVENT_ON;
 
 		/* restore radio state AND notify everybody */
+		if (rfkill->get_state &&
+		    !rfkill->get_state(rfkill->data, &newstate))
+			rfkill->state = newstate;
 		rfkill_toggle_radio(rfkill, rfkill->state_for_resume, 1);
 
 		mutex_unlock(&rfkill->mutex);
-- 
1.5.6.5

