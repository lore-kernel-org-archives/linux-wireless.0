Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blaine.gmane.org ([80.91.229.8]:36205 "EHLO hugh.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764203AbYFZN2Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 09:28:25 -0400
Received: from public by hugh.gmane.org with local (Exim 4.63)
	(envelope-from <public@hugh.gmane.org>)
	id 1KBrQC-0005Wm-Oh
	for linux-wireless@vger.kernel.org; Thu, 26 Jun 2008 15:21:56 +0200
Date: Thu, 26 Jun 2008 17:13:42 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: Henrique de Moraes Holschuh
	<public-hmh-N3TV7GIv+o9fyO9Q7EP/yw@hugh.gmane.org>
Cc: John Linville
	<public-linville-2XuSBdqkA4R54TAoqtyWWQ@hugh.gmane.org>,
	public-linux-wireless-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org,
	Ivo van Doorn
	<public-ivdoorn-Re5JQEeQqe8AvxtiuMwx3w@hugh.gmane.org>,
	Matthew Garrett
	<public-mjg-H+wXaHxf7aLQT0dZR+AlfA@hugh.gmane.org>,
	Dan Williams <public-dcbw-H+wXaHxf7aLQT0dZR+AlfA@hugh.gmane.org>,
	Thomas Renninger <public-trenn-l3A5Bk7waGM@hugh.gmane.org>,
	Fabien Crespel
	<public-fabien-czgx1wgAc3rR7s880joybQ@hugh.gmane.org>,
	Dmitry Torokhov
	<public-dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@hugh.gmane.org>
Subject: Re: [GIT PATCH] rfkill rework for 2.6.27 (v3)
Message-ID: <20080626131342.GA12528@doriath.ww600.siemens.net> (sfid-20080626_152830_929072_FD5BFD54)
References: <1214252588-30723-1-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1214252588-30723-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Hi,

Here is a patch for rfkill sitting in my queue. It depends on the
leds-make-sure-led-trigger-is-valid-before-calling-trigger-activate.patch
lately merged into -mm, which hopefully will be merged into mainline soon
after 2.6.27 window opens.

>From b69b08959d1b1bb989b156492346441dd4a04423 Mon Sep 17 00:00:00 2001
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
Date: Fri, 20 Jun 2008 01:48:17 +0400
Subject: [PATCH] RFKILL: small improvements for leds handling

allow one to override the name of the led trigger
provide default activate function to set the state of the led.

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
---
 net/rfkill/rfkill.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index 4e10a95..e9010ff 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -57,6 +57,16 @@ static void rfkill_led_trigger(struct rfkill *rfkill,
 #endif /* CONFIG_RFKILL_LEDS */
 }
 
+#ifdef CONFIG_RFKILL_LEDS
+static void rfkill_led_trigger_activate(struct led_classdev *led)
+{
+	struct rfkill *rfkill = container_of(led->trigger,
+			struct rfkill, led_trigger);
+
+	rfkill_led_trigger(rfkill, rfkill->state);
+}
+#endif /* CONFIG_RFKILL_LEDS */
+
 static int rfkill_toggle_radio(struct rfkill *rfkill,
 				enum rfkill_state state)
 {
@@ -355,7 +365,10 @@ static void rfkill_led_trigger_register(struct rfkill *rfkill)
 #ifdef CONFIG_RFKILL_LEDS
 	int error;
 
-	rfkill->led_trigger.name = rfkill->dev.bus_id;
+	if (!rfkill->led_trigger.name)
+		rfkill->led_trigger.name = rfkill->dev.bus_id;
+	if (!rfkill->led_trigger.activate)
+		rfkill->led_trigger.activate = rfkill_led_trigger_activate;
 	error = led_trigger_register(&rfkill->led_trigger);
 	if (error)
 		rfkill->led_trigger.name = NULL;
-- 
1.5.5.4


-- 
With best wishes
Dmitry


