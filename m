Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753107Ab3EYIxP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 May 2013 04:53:15 -0400
Date: Sat, 25 May 2013 10:55:04 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Jake Edge <jake@lwn.net>, Johannes Berg <johannes@sipsolutions.net>
Subject: [RFT/RFC 5/4] iwlegacy: unblock queues on passive channel if any
 frame receive
Message-ID: <20130525085503.GC1599@redhat.com> (sfid-20130525_105317_785641_0968F317)
References: <1369311660-15378-1-git-send-email-sgruszka@redhat.com>
 <1369311660-15378-5-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1369311660-15378-5-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently we unblock queues (when blocked on passive channel) only if
beacon with our bssid will be received. Change that to any frame, since
firmware should allow to transmit frames on passive channel when it
receives any frame with valid CRC sum.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/4965-mac.c | 13 ++++++-------
 drivers/net/wireless/iwlegacy/common.c   | 11 ++++++-----
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index b083502..2c77431 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -588,11 +588,9 @@ il4965_pass_packet_to_mac80211(struct il_priv *il, struct ieee80211_hdr *hdr,
 		return;
 	}
 
-	if (unlikely(test_bit(IL_STOP_REASON_PASSIVE, &il->stop_reason)) &&
-	    ieee80211_is_beacon(fc) &&
-	    ether_addr_equal(hdr->addr3, il->active.bssid_addr)) {
+	if (unlikely(test_bit(IL_STOP_REASON_PASSIVE, &il->stop_reason))) {
 		il_wake_queues_by_reason(il, IL_STOP_REASON_PASSIVE);
-		D_INFO("Woke queues - beacon received on passive channel\n");
+		D_INFO("Woke queues - frame received on passive channel\n");
 	}
 
 	/* In case of HW accelerated crypto and bad decryption, drop */
@@ -2815,9 +2813,10 @@ il4965_hdl_tx(struct il_priv *il, struct il_rx_buf *rxb)
 
 	/*
 	 * Firmware will not transmit frame on passive channel, if it not yet
-	 * received beacon frame on that channel. When this error happen, we
-	 * have to wait until firmware will unblock itself i.e. when we note
-	 * received beacon (see il4965_pass_packet_to_mac80211).
+	 * received some valid frame on that channel. When this error happen
+	 * we have to wait until firmware will unblock itself i.e. when we
+	 * note received beacon or other frame. We unblock queues in
+	 * il4965_pass_packet_to_mac80211 or in il_mac_bss_info_changed.
 	 */
 	if (unlikely(status == TX_STATUS_FAIL_PASSIVE_NO_RX) &&
 	    il->iw_mode == NL80211_IFTYPE_STATION) {
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index 9360d1f..3195aad 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -5307,11 +5307,12 @@ il_mac_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		D_MAC80211("BSSID %pM\n", bss_conf->bssid);
 
 		/*
-		 * On passive channel we wait with blocked queues for a beacon.
-		 * If beacon will not be received (what is very unlikely, but
-		 * theoretically possible), mac80211 associate procedure will
-		 * time out and mac80211 will call us with NULL bssid. We have
-		 * to unblock queues on such condition.
+		 * On passive channel we wait with blocked queues to see if
+		 * there is traffic on that channel. If no frame will be
+		 * received (what is very unlikely since scan detects AP on
+		 * that channel, but theoretically possible), mac80211 associate
+		 * procedure will time out and mac80211 will call us with NULL
+		 * bssid. We have to unblock queues on such condition.
 		 */
 		if (is_zero_ether_addr(bss_conf->bssid))
 			il_wake_queues_by_reason(il, IL_STOP_REASON_PASSIVE);
-- 
1.7.11.7

