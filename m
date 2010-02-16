Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933090Ab0BPVgk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2010 16:36:40 -0500
From: Matthew Garrett <mjg@redhat.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, linux-input@vger.kernel.org,
	dmitry.torokhov@gmail.com, marcel@holtmann.org,
	Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 1/2] input: Add KEY_RFKILL
Date: Tue, 16 Feb 2010 16:36:24 -0500
Message-Id: <1266356185-10324-1-git-send-email-mjg@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Most laptops have keys that are intended to toggle all device state, not
just wifi. These are currently generally mapped to KEY_WLAN. As a result,
rfkill will only kill or enable wifi in response to the key press. This
confuses users and can make it difficult for them to enable bluetooth
and wwan devices.

This patch adds a new keycode, KEY_RFKILL. It indicates that the system
should toggle the state of all rfkillable devices.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 include/linux/input.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/input.h b/include/linux/input.h
index 735ceaf..3294a89 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -594,7 +594,7 @@ struct input_absinfo {
 #define KEY_NUMERIC_9		0x209
 #define KEY_NUMERIC_STAR	0x20a
 #define KEY_NUMERIC_POUND	0x20b
-
+#define KEY_RFKILL		0x20c /* Key that controls all radios */
 #define KEY_CAMERA_FOCUS	0x210
 
 /* We avoid low common keys in module aliases so they don't get huge. */
-- 
1.6.6.1

