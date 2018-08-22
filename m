Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lorien.comfychair.org ([173.8.144.98]:60536 "EHLO
        lorien.comfychair.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726424AbeHWCdD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Aug 2018 22:33:03 -0400
From: Danek Duvall <duvall@comfychair.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Danek Duvall <duvall@comfychair.org>
Subject: [PATCH 2/2] mac80211_hwsim: correct use of IEEE80211_VHT_CAP_RXSTBC_X
Date: Wed, 22 Aug 2018 16:01:05 -0700
Message-Id: <a4080ca57ba7cdccf905832fd4b9a73c745eee8d.1534978104.git.duvall@comfychair.org> (sfid-20180823_010616_417003_3029C47C)
In-Reply-To: <cover.1534978104.git.duvall@comfychair.org>
References: <cover.1534978104.git.duvall@comfychair.org>
In-Reply-To: <cover.1534978104.git.duvall@comfychair.org>
References: <cover.1534978104.git.duvall@comfychair.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mac80211_hwsim driver intends to say that it supports up to four
STBC receive streams, but instead it ends up saying something undefined.
The IEEE80211_VHT_CAP_RXSTBC_X macros aren't independent bits that can
be ORed together, but values.  In this case, _4 is the appropriate one
to use.

Signed-off-by: Danek Duvall <duvall@comfychair.org>
---
 drivers/net/wireless/mac80211_hwsim.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 998dfac0fcff..9b8f34949df1 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2820,9 +2820,6 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 				IEEE80211_VHT_CAP_SHORT_GI_80 |
 				IEEE80211_VHT_CAP_SHORT_GI_160 |
 				IEEE80211_VHT_CAP_TXSTBC |
-				IEEE80211_VHT_CAP_RXSTBC_1 |
-				IEEE80211_VHT_CAP_RXSTBC_2 |
-				IEEE80211_VHT_CAP_RXSTBC_3 |
 				IEEE80211_VHT_CAP_RXSTBC_4 |
 				IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_MASK;
 			sband->vht_cap.vht_mcs.rx_mcs_map =
-- 
2.11.0
