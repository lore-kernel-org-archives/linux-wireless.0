Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f175.google.com ([209.85.128.175]:34224 "EHLO
        mail-wr0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751524AbdFILIA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Jun 2017 07:08:00 -0400
Received: by mail-wr0-f175.google.com with SMTP id g76so29064852wrd.1
        for <linux-wireless@vger.kernel.org>; Fri, 09 Jun 2017 04:07:59 -0700 (PDT)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Ben Greear <greearb@candelatech.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH v2 1/3] ath10k: Use complete VHT chan width for 160MHz workaround
Date: Fri,  9 Jun 2017 13:07:48 +0200
Message-Id: <20170609110750.14950-1-sven.eckelmann@openmesh.com> (sfid-20170609_130803_631824_B02C1AF4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

The ath10k firmware doesn't announce its VHT channel width capabilities in
the vht_cap information from the "service ready event" arguments. The
driver must therefore check whether the 160MHz short GI bit is set and
whether the driver still doesn't set the bits for the 160/80+80 MHz
capabilities.

The two bits for the channel width are a two bit integer and not two
separate bits which cannot be parsed without the knowledge of the other
bit. Using IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ (b10..) as a
mask for this task doesn't make any sense. The correct mask for the VHT
channel width should be used instead to make this check more readable.

Signed-off-by: Ben Greear <greearb@candelatech.com>
[sven.eckelmann@openmesh.com: separate 160Mhz workaround cleanup, add commit
 message]
Signed-off-by: Sven Eckelmann <sven.eckelmann@openmesh.com>
---
v2:
 - extracted this cleanup portion and converted it to a separate patch

 drivers/net/wireless/ath/ath10k/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 4674ff33d320..8087b6be5484 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4391,7 +4391,7 @@ static struct ieee80211_sta_vht_cap ath10k_create_vht_cap(struct ath10k *ar)
 	 * mode until that's resolved.
 	 */
 	if ((ar->vht_cap_info & IEEE80211_VHT_CAP_SHORT_GI_160) &&
-	    !(ar->vht_cap_info & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ))
+	    (ar->vht_cap_info & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK) == 0)
 		vht_cap.cap |= IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ;
 
 	mcs_map = 0;
-- 
2.11.0
