Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36385 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753258AbaFDNUm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 09:20:42 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: users@rt2x00.serialmonkey.com
Cc: linux-wireless@vger.kernel.org,
	Matthias Fend <Matthias.Fend@wolfvision.net>
Subject: [RFC/RFT 4/5] rt2x00: change order when stop beaconing
Date: Wed,  4 Jun 2014 15:19:14 +0200
Message-Id: <1401887955-11361-4-git-send-email-sgruszka@redhat.com> (sfid-20140604_152045_834439_4AD85FAD)
In-Reply-To: <1401887955-11361-1-git-send-email-sgruszka@redhat.com>
References: <1401887955-11361-1-git-send-email-sgruszka@redhat.com>
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

