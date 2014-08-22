Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:44543 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756122AbaHVNSW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Aug 2014 09:18:22 -0400
Received: by mail-ig0-f174.google.com with SMTP id c1so14922937igq.7
        for <linux-wireless@vger.kernel.org>; Fri, 22 Aug 2014 06:18:21 -0700 (PDT)
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, mickflemm@gmail.com
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 2/3] ath5k: ensure led name is null terminated
Date: Fri, 22 Aug 2014 09:18:01 -0400
Message-Id: <1408713482-7917-2-git-send-email-me@bobcopeland.com> (sfid-20140822_151828_193741_30267E60)
In-Reply-To: <1408713482-7917-1-git-send-email-me@bobcopeland.com>
References: <1408713482-7917-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add the missing null termination after strncpy().

This isn't actually a buffer overflow in this case since we use
snprintf() appropriately to fill the buffer passed by the caller,
but in the interest of not turning this into a bug down the road,
go ahead and force termination here.

Found by Coverity.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/led.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath5k/led.c b/drivers/net/wireless/ath/ath5k/led.c
index f77ef36..edc32ea 100644
--- a/drivers/net/wireless/ath/ath5k/led.c
+++ b/drivers/net/wireless/ath/ath5k/led.c
@@ -130,6 +130,7 @@ ath5k_register_led(struct ath5k_hw *ah, struct ath5k_led *led,
 
 	led->ah = ah;
 	strncpy(led->name, name, sizeof(led->name));
+	led->name[sizeof(led->name)-1] = 0;
 	led->led_dev.name = led->name;
 	led->led_dev.default_trigger = trigger;
 	led->led_dev.brightness_set = ath5k_led_brightness_set;
-- 
1.7.10.4

