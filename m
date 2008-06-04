Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:21086 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758907AbYFDJKt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2008 05:10:49 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org, Dan Williams <dcbw@redhat.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] libertas: fix sleep confirmation
Date: Wed, 4 Jun 2008 11:10:40 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200806041110.40560.hs4233@mail.mn-solutions.de> (sfid-20080604_111123_601434_A86094F1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes an issus that made "iwconfig eth1 power on" non-working.
When we get a "PS sleep" event, we have to confirm this to the firmware.
The confirm happens with a command, but this command is special: the
firmware won't send us a response. if_cs_host_to_card() is setting
priv->dnld_sent anyway, so this variable stayed at DNLD_DATA_SENT and
was never cleared back.

Now I put the special knowledge that the CMD_802_11_PS_MODE with
CMD_SUBCMD_SLEEP_CONFIRMED doesn't need to need a response by directly
clearing the dnld_sent state in lbs_send_confirmsleep().

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Index: wireless-testing/drivers/net/wireless/libertas/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/main.c	2008-06-04 09:55:27.000000000 +0200
+++ wireless-testing/drivers/net/wireless/libertas/main.c	2008-06-04 09:55:55.000000000 +0200
@@ -765,8 +765,8 @@ static int lbs_thread(void *data)
 		lbs_deb_thread("4: currenttxskb %p, dnld_sent %d\n",
 		       priv->currenttxskb, priv->dnld_sent);
 
-		spin_lock_irq(&priv->driver_lock);
 		/* Process any pending command response */
+		spin_lock_irq(&priv->driver_lock);
 		resp_idx = priv->resp_idx;
 		if (priv->resp_len[resp_idx]) {
 			spin_unlock_irq(&priv->driver_lock);
Index: wireless-testing/drivers/net/wireless/libertas/cmd.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/cmd.c	2008-06-04 09:55:27.000000000 +0200
+++ wireless-testing/drivers/net/wireless/libertas/cmd.c	2008-06-04 09:56:20.000000000 +0200
@@ -1858,6 +1858,9 @@ static void lbs_send_confirmsleep(struct
 
 	spin_lock_irqsave(&priv->driver_lock, flags);
 
+	/* We don't get a response on the sleep-confirmation */
+	priv->dnld_sent = DNLD_RES_RECEIVED;
+
 	/* If nothing to do, go back to sleep (?) */
 	if (!__kfifo_len(priv->event_fifo) && !priv->resp_len[priv->resp_idx])
 		priv->psstate = PS_STATE_SLEEP;
@@ -1920,12 +1923,12 @@ void lbs_ps_confirm_sleep(struct lbs_pri
 
 	lbs_deb_enter(LBS_DEB_HOST);
 
+	spin_lock_irqsave(&priv->driver_lock, flags);
 	if (priv->dnld_sent) {
 		allowed = 0;
 		lbs_deb_host("dnld_sent was set\n");
 	}
 
-	spin_lock_irqsave(&priv->driver_lock, flags);
 	/* In-progress command? */
 	if (priv->cur_cmd) {
 		allowed = 0;
