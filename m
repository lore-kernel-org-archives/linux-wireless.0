Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:30751 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679Ab0CZKyf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Mar 2010 06:54:35 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Subject: [PATCH 17/24] wl1271: Removed checking of PSM from handling BSS_LOST_EVENT
Date: Fri, 26 Mar 2010 12:53:26 +0200
Message-Id: <1269600813-32145-18-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1269600813-32145-1-git-send-email-luciano.coelho@nokia.com>
References: <1269600813-32145-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>

Change the driver to call ieee80211_beacon_loss function always when
BSS_LOST_EVENT is received. Reason for the change is that entering PSM
might fail before driver receives BSS_LOST_EVENT. In such case the
driver would disable PSM and the stack would not be notified about beacon
loss and connection loss detection would be delayed by tens of seconds.

Signed-off-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_event.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_event.c b/drivers/net/wireless/wl12xx/wl1271_event.c
index 4d35af9..a5c1910 100644
--- a/drivers/net/wireless/wl12xx/wl1271_event.c
+++ b/drivers/net/wireless/wl12xx/wl1271_event.c
@@ -173,9 +173,12 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 	 * The BSS_LOSE_EVENT_ID is only needed while psm (and hence beacon
 	 * filtering) is enabled. Without PSM, the stack will receive all
 	 * beacons and can detect beacon loss by itself.
+	 *
+	 * As there's possibility that the driver disables PSM before receiving
+	 * BSS_LOSE_EVENT, beacon loss has to be reported to the stack.
+	 *
 	 */
-	if (vector & BSS_LOSE_EVENT_ID &&
-	    test_bit(WL1271_FLAG_PSM, &wl->flags)) {
+	if (vector & BSS_LOSE_EVENT_ID) {
 		wl1271_debug(DEBUG_EVENT, "BSS_LOSE_EVENT");
 
 		/* indicate to the stack, that beacons have been lost */
-- 
1.6.3.3

