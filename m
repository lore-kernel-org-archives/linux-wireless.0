Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:1372 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097AbZG0Oru (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 10:47:50 -0400
To: mjg@redhat.com
Subject: [PATCH] dell-laptop: Fix rfkill state setting
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Message-Id: <20090727144747.E7F4EF891B@sepang.rtg.net>
Date: Mon, 27 Jul 2009 08:47:47 -0600 (MDT)
From: timg@tpi.com (Tim Gardner)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Matthew,

I think the rfkill state change logic is inverted. I've tried the original
code on 3 different Dell models. Once 'rfkill block all' is run, then you
can never unblock 'dell-wifi: Wireless LAN'. With this change you can get
it unblocked, but you need to run 'rfkill unblock all' twice (which is
likely an issue with rfkill).

rtg

>From 778aec563a251418e455d63f711aab1c936bff73 Mon Sep 17 00:00:00 2001
From: Tim Gardner <tim.gardner@canonical.com>
Date: Mon, 27 Jul 2009 08:30:54 -0600
Subject: [PATCH] UBUNTU: [Upstream] dell-laptop: Fix rfkill state setting.

rfkill enable/disable transitions are predicated on the state of the
external hardware switch, i.e., if the external switch is in the on position,
then no rfkill state transitions are allowed.

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/platform/x86/dell-laptop.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
index 74909c4..cf40c4e 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -197,8 +197,11 @@ static void dell_rfkill_query(struct rfkill *rfkill, void *data)
 	dell_send_request(&buffer, 17, 11);
 	status = buffer.output[1];
 
-	if (status & BIT(bit))
-		rfkill_set_hw_state(rfkill, !!(status & BIT(16)));
+	/*
+	 * Don't change state unless the read-only HW rfkill switch is disabled.
+	 */
+	if (status & BIT(16))
+		rfkill_set_hw_state(rfkill, !!(status & BIT(bit)));
 }
 
 static const struct rfkill_ops dell_rfkill_ops = {
-- 
1.6.2.4

