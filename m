Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ausxippc101.us.dell.com ([143.166.85.207]:43751 "EHLO
	ausxippc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290AbZHSXeZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2009 19:34:25 -0400
From: Mario Limonciello <Mario_Limonciello@Dell.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-wireless@vger.kernel.org, linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mario Limonciello <Mario_Limonciello@Dell.com>
Subject: [PATCH] When the "hardware" switch is disabled, don't actually allow changing the softblock status.  
Date: Wed, 19 Aug 2009 18:34:01 -0500
Message-Id: <1250724841-12527-1-git-send-email-Mario_Limonciello@Dell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The "hardware" switch is tied directly to a BIOS interface that will connect and 
disconnect the hardware from the bus.

If you use the software interface to request the BIOS to make these changes, the HW
switch will be in an inconsistent state and LEDs may not reflect the state of the HW.

Signed-off-by: Mario Limonciello <Mario_Limonciello@Dell.com>
---
 drivers/platform/x86/dell-laptop.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
index 90a3d7c..2469ad5 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -180,6 +180,10 @@ static int dell_rfkill_set(int radio, enum rfkill_state state)
 	int disable = (state == RFKILL_STATE_UNBLOCKED) ? 0 : 1;
 
 	memset(&buffer, 0, sizeof(struct calling_interface_buffer));
+	dell_send_request(&buffer, 17, 11);
+	if (!(buffer.output[1] & BIT(16)))
+		return -EINVAL;
+
 	buffer.input[0] = (1 | (radio<<8) | (disable << 16));
 	dell_send_request(&buffer, 17, 11);
 
-- 
1.6.3.3

