Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:9694 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167AbbAXRwb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2015 12:52:31 -0500
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/6] cfg80211: Fix BIP (AES-CMAC) cipher validation
Date: Sat, 24 Jan 2015 19:52:04 +0200
Message-ID: <1422121929-18238-1-git-send-email-jouni@qca.qualcomm.com> (sfid-20150124_185237_222664_50187DD0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This cipher can be used only as a group management frame cipher and as
such, there is no point in validating that it is not used with non-zero
key-index. Instead, verify that it is not used as a pairwise cipher
regardless of the key index.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 net/wireless/util.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 3535e8a..f608ba0 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -236,8 +236,11 @@ int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
 	 */
 	if (pairwise && key_idx &&
 	    ((params->cipher == WLAN_CIPHER_SUITE_TKIP) ||
-	     (params->cipher == WLAN_CIPHER_SUITE_CCMP) ||
-	     (params->cipher == WLAN_CIPHER_SUITE_AES_CMAC)))
+	     (params->cipher == WLAN_CIPHER_SUITE_CCMP)))
+		return -EINVAL;
+
+	/* Disallow BIP (group-only) cipher as pairwise cipher */
+	if (pairwise && params->cipher == WLAN_CIPHER_SUITE_AES_CMAC)
 		return -EINVAL;
 
 	switch (params->cipher) {
-- 
1.9.1

