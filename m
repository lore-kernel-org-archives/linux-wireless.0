Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:39051 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbZIJRWD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2009 13:22:03 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-input@vger.kernel.org
Cc: linux-wireless@vger.kernel.org, marcel@holtmann.org,
	Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 1/2] input: Add KEY_RFKILL
Date: Thu, 10 Sep 2009 18:21:31 +0100
Message-Id: <1252603292-20830-1-git-send-email-mjg@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Most laptops have keys that are intended to toggle all device state, not
just wifi. These are currently generally mapped to KEY_WLAN. As a result,
rfkill will only kill or enable wifi in response to the key press. This
confuses users and can make it difficult for them to enable bluetooth
and wwan devices.

This patch adds a new keycode, KEY_RFKILL_ALL. It indicates that the
system should toggle the state of all rfkillable devices.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 include/linux/input.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/input.h b/include/linux/input.h
index 8b3bc3e..20a622e 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -595,6 +595,8 @@ struct input_absinfo {
 #define KEY_NUMERIC_STAR	0x20a
 #define KEY_NUMERIC_POUND	0x20b
 
+#define KEY_RFKILL		0x20c /* Key that controls all radios */
+
 /* We avoid low common keys in module aliases so they don't get huge. */
 #define KEY_MIN_INTERESTING	KEY_MUTE
 #define KEY_MAX			0x2ff
-- 
1.6.2.5

