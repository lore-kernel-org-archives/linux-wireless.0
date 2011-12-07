Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:48318 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757448Ab1LGUpx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Dec 2011 15:45:53 -0500
Received: by qcqz2 with SMTP id z2so776298qcq.19
        for <linux-wireless@vger.kernel.org>; Wed, 07 Dec 2011 12:45:53 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, ath9k-devel@lists.ath9k.org,
	devel@lists.open80211s.org, Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] ath9k: Support RSN Mesh
Date: Wed,  7 Dec 2011 12:45:46 -0800
Message-Id: <1323290746-6824-1-git-send-email-thomas@cozybit.com> (sfid-20111207_214557_167576_66AD668D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 424289f..82b0d4b 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1923,7 +1923,8 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 	if (ath9k_modparam_nohwcrypt)
 		return -ENOSPC;
 
-	if (vif->type == NL80211_IFTYPE_ADHOC &&
+	if ((vif->type == NL80211_IFTYPE_ADHOC ||
+	     vif->type == NL80211_IFTYPE_MESH_POINT) &&
 	    (key->cipher == WLAN_CIPHER_SUITE_TKIP ||
 	     key->cipher == WLAN_CIPHER_SUITE_CCMP) &&
 	    !(key->flags & IEEE80211_KEY_FLAG_PAIRWISE)) {
-- 
1.7.5.4

