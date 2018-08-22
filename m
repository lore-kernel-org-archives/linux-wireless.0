Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lorien.comfychair.org ([173.8.144.98]:53192 "EHLO
        lorien.comfychair.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbeHWCdC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Aug 2018 22:33:02 -0400
From: Danek Duvall <duvall@comfychair.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Danek Duvall <duvall@comfychair.org>
Subject: [PATCH 1/2] mac80211: correct use of IEEE80211_VHT_CAP_RXSTBC_X
Date: Wed, 22 Aug 2018 16:01:04 -0700
Message-Id: <71e7e4d3d234740314f0a8e8c3ea51bea7a897d0.1534978104.git.duvall@comfychair.org> (sfid-20180823_010616_087647_3D7C6A4A)
In-Reply-To: <cover.1534978104.git.duvall@comfychair.org>
References: <cover.1534978104.git.duvall@comfychair.org>
In-Reply-To: <cover.1534978104.git.duvall@comfychair.org>
References: <cover.1534978104.git.duvall@comfychair.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mod mask for VHT capabilities intends to say that you can override
the number of STBC receive streams, and it does, but only by accident.
The IEEE80211_VHT_CAP_RXSTBC_X aren't bits to be set, but values (albeit
left-shifted).  ORing the bits together gets the right answer, but we
should use the _MASK macro here instead.

Signed-off-by: Danek Duvall <duvall@comfychair.org>
---
 net/mac80211/main.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 4fb2709cb527..c5ca329e008a 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -471,10 +471,7 @@ static const struct ieee80211_vht_cap mac80211_vht_capa_mod_mask = {
 		cpu_to_le32(IEEE80211_VHT_CAP_RXLDPC |
 			    IEEE80211_VHT_CAP_SHORT_GI_80 |
 			    IEEE80211_VHT_CAP_SHORT_GI_160 |
-			    IEEE80211_VHT_CAP_RXSTBC_1 |
-			    IEEE80211_VHT_CAP_RXSTBC_2 |
-			    IEEE80211_VHT_CAP_RXSTBC_3 |
-			    IEEE80211_VHT_CAP_RXSTBC_4 |
+			    IEEE80211_VHT_CAP_RXSTBC_MASK |
 			    IEEE80211_VHT_CAP_TXSTBC |
 			    IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE |
 			    IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE |
-- 
2.11.0
