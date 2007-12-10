Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55297 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755207AbXLJPqT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 10:46:19 -0500
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 43/48] libertas: refactor the 'should I sleep?' decision in lbs_thread()
Message-Id: <E1J1kpn-0006na-Ck@shinybook.infradead.org> (sfid-20071210_154640_499692_829AF8BF)
Date: Mon, 10 Dec 2007 10:46:19 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Sun, 9 Dec 2007 23:44:43 -0500

This was making my brain hurt.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/main.c |   20 ++++++++++++++++++--
 1 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index e9c6b4f..42b64b5 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -722,6 +722,8 @@ static int lbs_thread(void *data)
 	set_freezable();
 
 	for (;;) {
+		int shouldsleep;
+
 		lbs_deb_thread( "main-thread 111: intcounter=%d currenttxskb=%p dnld_sent=%d\n",
 				priv->intcounter, priv->currenttxskb, priv->dnld_sent);
 
@@ -729,8 +731,22 @@ static int lbs_thread(void *data)
 		set_current_state(TASK_INTERRUPTIBLE);
 		spin_lock_irq(&priv->driver_lock);
 
-		if ((priv->psstate == PS_STATE_SLEEP) ||
-		    (!priv->intcounter && (priv->dnld_sent || priv->cur_cmd || list_empty(&priv->cmdpendingq)))) {
+		if (priv->surpriseremoved)
+			shouldsleep = 0;	/* Bye */
+		else if (priv->psstate == PS_STATE_SLEEP)
+			shouldsleep = 1;	/* Sleep mode. Nothing we can do till it wakes */
+		else if (priv->intcounter)
+			shouldsleep = 0;	/* Interrupt pending. Deal with it now */
+		else if (priv->dnld_sent)
+			shouldsleep = 1;	/* Something is en route to the device already */
+		else if (priv->cur_cmd)
+			shouldsleep = 1;	/* Can't send a command; one already running */
+		else if (!list_empty(&priv->cmdpendingq))
+			shouldsleep = 0;	/* We have a command to send */
+		else
+			shouldsleep = 1;	/* No command */
+
+		if (shouldsleep) {
 			lbs_deb_thread("main-thread sleeping... Conn=%d IntC=%d PS_mode=%d PS_State=%d\n",
 				       priv->connect_status, priv->intcounter,
 				       priv->psmode, priv->psstate);
-- 
1.5.3.4

