Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:22026 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab0CZKyH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Mar 2010 06:54:07 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 13/24] wl1271: remove deprecated usage of RX status noise
Date: Fri, 26 Mar 2010 12:53:22 +0200
Message-Id: <1269600813-32145-14-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1269600813-32145-1-git-send-email-luciano.coelho@nokia.com>
References: <1269600813-32145-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The noise element in the ieee80211_rx_status struct has been deprecated in
commit "mac80211: deprecate RX status noise".  Remove the usage of this
element from wl1271_rx.c to avoid warnings.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Reviewed-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_rx.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_rx.c b/drivers/net/wireless/wl12xx/wl1271_rx.c
index a1a7953..ca44270 100644
--- a/drivers/net/wireless/wl12xx/wl1271_rx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_rx.c
@@ -59,13 +59,6 @@ static void wl1271_rx_status(struct wl1271 *wl,
 	 */
 	status->signal = desc->rssi;
 
-	/*
-	 * FIXME: In wl1251, the SNR should be divided by two.  In wl1271 we
-	 * need to divide by two for now, but TI has been discussing about
-	 * changing it.  This needs to be rechecked.
-	 */
-	status->noise = desc->rssi - (desc->snr >> 1);
-
 	status->freq = ieee80211_channel_to_frequency(desc->channel);
 
 	if (desc->flags & WL1271_RX_DESC_ENCRYPT_MASK) {
-- 
1.6.3.3

