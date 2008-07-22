Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.188]:32139 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbYGVKRv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2008 06:17:51 -0400
Received: by mu-out-0910.google.com with SMTP id w8so1128121mue.1
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jul 2008 03:17:50 -0700 (PDT)
Date: Tue, 22 Jul 2008 14:17:37 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Ivo van Doorn <IvDoorn@gmail.com>
Subject: [PATCH 1/2] RFKILL: allow one to specify led trigger name
Message-ID: <20080722101737.GA32672@doriath.ww600.siemens.net> (sfid-20080722_121755_223481_1FB58808)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow the rfkill driver to specify led trigger name.
By default it still defaults to the name of rfkill switch.

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ivo van Doorn <IvDoorn@gmail.com>
---
 net/rfkill/rfkill.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index 4e10a95..b247677 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -355,7 +355,8 @@ static void rfkill_led_trigger_register(struct rfkill *rfkill)
 #ifdef CONFIG_RFKILL_LEDS
 	int error;
 
-	rfkill->led_trigger.name = rfkill->dev.bus_id;
+	if (!rfkill->led_trigger.name)
+		rfkill->led_trigger.name = rfkill->dev.bus_id;
 	error = led_trigger_register(&rfkill->led_trigger);
 	if (error)
 		rfkill->led_trigger.name = NULL;
-- 
1.5.6.2


-- 
With best wishes
Dmitry

