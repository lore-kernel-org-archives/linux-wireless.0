Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:47478 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbZGaCZs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 22:25:48 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-acpi@vger.kernel.org
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	timg@tpi.com, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH] dell-laptop: Fix rfkill state queries
Date: Fri, 31 Jul 2009 03:25:38 +0100
Message-Id: <1249007138-27354-1-git-send-email-mjg@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current code in dell-laptop is confused about the hardware rfkill
state. Fix it up such that it's always reported correctly.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/platform/x86/dell-laptop.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
index 74909c4..9061111 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -197,8 +197,8 @@ static void dell_rfkill_query(struct rfkill *rfkill, void *data)
 	dell_send_request(&buffer, 17, 11);
 	status = buffer.output[1];
 
-	if (status & BIT(bit))
-		rfkill_set_hw_state(rfkill, !!(status & BIT(16)));
+	rfkill_set_sw_state(rfkill, !!(status & BIT(bit)));
+	rfkill_set_hw_state(rfkill, !(status & BIT(16)));
 }
 
 static const struct rfkill_ops dell_rfkill_ops = {
-- 
1.6.2.5

