Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:45849 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753336Ab0BKRH3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Feb 2010 12:07:29 -0500
Message-ID: <4B743947.5070303@openwrt.org>
Date: Thu, 11 Feb 2010 18:07:19 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <Jouni.Malinen@atheros.com>
Subject: [PATCH] ath9k: add a workaround for ack timeout issues
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding support for setting the coverage class in some cases broke
association and data transfer, as it overwrote the initial ACK timeout
value from the initvals with a smaller value.
I don't know why the new value works in 5 GHz (matches the initval
there), but not in 2.4 GHz (initvals use 64us here), so until the
problem is fully understood, the value should be increased again.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1233,6 +1233,17 @@ void ath9k_hw_init_global_settings(struc
 	/* As defined by IEEE 802.11-2007 17.3.8.6 */
 	slottime = ah->slottime + 3 * ah->coverage_class;
 	acktimeout = slottime + sifstime;
+
+	/*
+	 * Workaround for early ACK timeouts, add an offset to match the
+	 * initval's 64us ack timeout value.
+	 * This was initially only meant to work around an issue with delayed
+	 * BA frames in some implementations, but it has been found to fix ACK
+	 * timeout issues in other cases as well.
+	 */
+	if (conf->channel && conf->channel->band == IEEE80211_BAND_2GHZ)
+		acktimeout += 64 - sifstime - ah->slottime;
+
 	ath9k_hw_setslottime(ah, slottime);
 	ath9k_hw_set_ack_timeout(ah, acktimeout);
 	ath9k_hw_set_cts_timeout(ah, acktimeout);
