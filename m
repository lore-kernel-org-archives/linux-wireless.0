Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:23084 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753563Ab1AYKVf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jan 2011 05:21:35 -0500
From: juuso.oikarinen@nokia.com
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] cfg80211: Allow non-zero indexes for device specific pair-wise ciphers
Date: Tue, 25 Jan 2011 12:21:22 +0200
Message-Id: <1295950882-16785-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Some vendor specific cipher suites require non-zero key indexes for pairwise
keys, but as of currently, the cfg80211 does not allow it.

As validating they cipher parameters for vendor specific cipher suites is the
job of the driver or hardware/firmware, change the cfg80211 to allow also
non-zero pairwise key indexes for vendor specific ciphers.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 net/wireless/util.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 4ed065d..6a750bc 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -167,12 +167,15 @@ int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
 
 	/*
 	 * Disallow pairwise keys with non-zero index unless it's WEP
-	 * (because current deployments use pairwise WEP keys with
-	 * non-zero indizes but 802.11i clearly specifies to use zero)
+	 * or a vendor specific cipher (because current deployments use
+	 * pairwise WEP keys with non-zero indices and for vendor specific
+	 * ciphers this should be validated in the driver or hardware level
+	 * - but 802.11i clearly specifies to use zero)
 	 */
 	if (pairwise && key_idx &&
-	    params->cipher != WLAN_CIPHER_SUITE_WEP40 &&
-	    params->cipher != WLAN_CIPHER_SUITE_WEP104)
+	    ((params->cipher == WLAN_CIPHER_SUITE_TKIP) ||
+	     (params->cipher == WLAN_CIPHER_SUITE_CCMP) ||
+	     (params->cipher == WLAN_CIPHER_SUITE_AES_CMAC)))
 		return -EINVAL;
 
 	switch (params->cipher) {
-- 
1.7.1

