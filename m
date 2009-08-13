Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:25438 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753765AbZHMIxu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 04:53:50 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: j@w1.fi
Cc: hostap@lists.shmoo.com, linux-wireless@vger.kernel.org,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH] Fix cipher overwide problem for 802.1X WEP
Date: Thu, 13 Aug 2009 16:55:30 +0800
Message-Id: <1250153731-17208-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We set the cipher_pairwise and cipher_group to WEP104 only if they
are not set already. Otherwise WEP40 has no way to be configured.
This problem is found on 802.1X with static WEP.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 wpa_supplicant/wpa_supplicant.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/wpa_supplicant/wpa_supplicant.c b/wpa_supplicant/wpa_supplicant.c
index d03e9da..f1f929a 100644
--- a/wpa_supplicant/wpa_supplicant.c
+++ b/wpa_supplicant/wpa_supplicant.c
@@ -1116,7 +1116,8 @@ void wpa_supplicant_associate(struct wpa_supplicant *wpa_s,
 		      EAPOL_FLAG_REQUIRE_KEY_BROADCAST)) == 0 &&
 		    !wep_keys_set) {
 			use_crypt = 0;
-		} else {
+		} else if (cipher_pairwise == WPA_CIPHER_NONE &&
+			   cipher_group == WPA_CIPHER_NONE) {
 			/* Assume that dynamic WEP-104 keys will be used and
 			 * set cipher suites in order for drivers to expect
 			 * encryption. */
-- 
1.6.0.4

