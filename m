Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24620 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbaFELxx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2014 07:53:53 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com,
	Matthias Fend <Matthias.Fend@wolfvision.net>
Subject: [PATCH 4/5] rt2x00: change order when stop beaconing
Date: Thu,  5 Jun 2014 13:52:26 +0200
Message-Id: <1401969147-3532-4-git-send-email-sgruszka@redhat.com> (sfid-20140605_135356_212112_DAC42CEC)
In-Reply-To: <1401969147-3532-1-git-send-email-sgruszka@redhat.com>
References: <1401969147-3532-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When no beaconing is needed, first stop beacon queue (disable beaconing
globally) to avoid possible sending of not prepared beacon on short
period after clearing beacon and before stop of BCN queue.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rt2x00/rt2x00mac.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 0aad22d..b144802 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -628,12 +628,6 @@ void rt2x00mac_bss_info_changed(struct ieee80211_hw *hw,
 		if (!bss_conf->enable_beacon && intf->enable_beacon) {
 			rt2x00dev->intf_beaconing--;
 			intf->enable_beacon = false;
-			/*
-			 * Clear beacon in the H/W for this vif. This is needed
-			 * to disable beaconing on this particular interface
-			 * and keep it running on other interfaces.
-			 */
-			rt2x00queue_clear_beacon(rt2x00dev, vif);
 
 			if (rt2x00dev->intf_beaconing == 0) {
 				/*
@@ -642,6 +636,12 @@ void rt2x00mac_bss_info_changed(struct ieee80211_hw *hw,
 				 */
 				rt2x00queue_stop_queue(rt2x00dev->bcn);
 			}
+			/*
+			 * Clear beacon in the H/W for this vif. This is needed
+			 * to disable beaconing on this particular interface
+			 * and keep it running on other interfaces.
+			 */
+			rt2x00queue_clear_beacon(rt2x00dev, vif);
 		} else if (bss_conf->enable_beacon && !intf->enable_beacon) {
 			rt2x00dev->intf_beaconing++;
 			intf->enable_beacon = true;
-- 
1.8.3.1

