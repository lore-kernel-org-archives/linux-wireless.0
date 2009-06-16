Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:51453 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbZFPNx0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2009 09:53:26 -0400
Received: by ewy6 with SMTP id 6so6028523ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jun 2009 06:53:28 -0700 (PDT)
Message-ID: <4A37A3D4.6010806@tuffmail.co.uk>
Date: Tue, 16 Jun 2009 14:53:24 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/4] rfkill: rfkill_set_block() when suspended nitpick
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If we return after fiddling with the state, userspace will see the
wrong state and rfkill_set_sw_state() won't work until the next call to
rfkill_set_block().  At the moment rfkill_set_block() will always be
called from rfkill_resume(), but this will change in future.

Also, presumably the point of this test is to avoid bothering devices
which may be suspended.  If we don't want to call set_block(), we
probably don't want to call query() either :-).

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
---
 net/rfkill/core.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index 4e68ab4..868d79f 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -270,6 +270,9 @@ static void rfkill_set_block(struct rfkill *rfkill, bool blocked)
 	unsigned long flags;
 	int err;
 
+	if (unlikely(rfkill->dev.power.power_state.event & PM_EVENT_SLEEP))
+		return;
+
 	/*
 	 * Some platforms (...!) generate input events which affect the
 	 * _hard_ kill state -- whenever something tries to change the
@@ -292,9 +295,6 @@ static void rfkill_set_block(struct rfkill *rfkill, bool blocked)
 	rfkill->state |= RFKILL_BLOCK_SW_SETCALL;
 	spin_unlock_irqrestore(&rfkill->lock, flags);
 
-	if (unlikely(rfkill->dev.power.power_state.event & PM_EVENT_SLEEP))
-		return;
-
 	err = rfkill->ops->set_block(rfkill->data, blocked);
 
 	spin_lock_irqsave(&rfkill->lock, flags);


