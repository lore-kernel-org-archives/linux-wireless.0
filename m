Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62338 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932107Ab1C3RSq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2011 13:18:46 -0400
Received: by fxm17 with SMTP id 17so1221291fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 30 Mar 2011 10:18:45 -0700 (PDT)
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH] wl12xx: fix "JOIN while associated" commentary
Date: Wed, 30 Mar 2011 19:18:31 +0200
Message-Id: <1301505511-26582-1-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Issuing multiple JOIN commands to the wl12xx's firmware, while
we're associated, might have undesired implications, so the driver
prints a message when that happens, and warn developers who check
out the source.

Update the commentary in order to consider the one valid scenario
where this can happen: roaming.

Cautiously keep the message for now, until we either gain confidence
there are no unintentional JOIN-while-associated events, or until
we move to the new multi-role fw who solves this multiple-join issue
for good.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 85cb4da..92def80 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1569,10 +1569,10 @@ static int wl1271_join(struct wl1271 *wl, bool set_assoc)
 	 * One of the side effects of the JOIN command is that is clears
 	 * WPA/WPA2 keys from the chipset. Performing a JOIN while associated
 	 * to a WPA/WPA2 access point will therefore kill the data-path.
-	 * Currently there is no supported scenario for JOIN during
-	 * association - if it becomes a supported scenario, the WPA/WPA2 keys
-	 * must be handled somehow.
-	 *
+	 * Currently the only valid scenario for JOIN during association
+	 * is on roaming, in which case we will also be given new keys.
+	 * Keep the below message for now, unless it starts bothering
+	 * users who really like to roam a lot :)
 	 */
 	if (test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags))
 		wl1271_info("JOIN while associated.");
-- 
1.7.1

