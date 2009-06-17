Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail6.webfaction.com ([74.55.86.74]:58630 "EHLO
	smtp.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbZFQLZL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2009 07:25:11 -0400
Date: Wed, 17 Jun 2009 11:51:56 +0100 (BST)
From: Troy Moure <twmoure@szypr.net>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] acer-wmi: fix rfkill conversion
Message-ID: <alpine.LFD.2.00.0906171135080.3376@troy-laptop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 19d337dff95cbf76ed ("rfkill: rewrite") incorrectly reversed
the meaning of 'state' in acer_rfkill_update() when it changed
rfkill_force_state() to rfkill_set_sw_state().  Fix it.

Signed-off-by: Troy Moure <twmoure@szypr.net>
---
This fixes the rfkill switch on my Acer laptop, which was behaving
backwards (the state reported in the logs was the opposite of the
state indicated by the LED).

 drivers/platform/x86/acer-wmi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index 09a503e..be2fd6f 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -958,12 +958,12 @@ static void acer_rfkill_update(struct work_struct *ignored)
 
 	status = get_u32(&state, ACER_CAP_WIRELESS);
 	if (ACPI_SUCCESS(status))
-		rfkill_set_sw_state(wireless_rfkill, !!state);
+		rfkill_set_sw_state(wireless_rfkill, !state);
 
 	if (has_cap(ACER_CAP_BLUETOOTH)) {
 		status = get_u32(&state, ACER_CAP_BLUETOOTH);
 		if (ACPI_SUCCESS(status))
-			rfkill_set_sw_state(bluetooth_rfkill, !!state);
+			rfkill_set_sw_state(bluetooth_rfkill, !state);
 	}
 
 	schedule_delayed_work(&acer_rfkill_work, round_jiffies_relative(HZ));
-- 
1.6.2.2

