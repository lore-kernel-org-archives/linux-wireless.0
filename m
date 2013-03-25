Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:35080 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758898Ab3CYUwV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Mar 2013 16:52:21 -0400
Received: by mail-we0-f181.google.com with SMTP id d7so245067wer.40
        for <linux-wireless@vger.kernel.org>; Mon, 25 Mar 2013 13:52:20 -0700 (PDT)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	fengguang.wu@intel.com, Karl Beldan <karl.beldan@gmail.com>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: [PATCH v2 3/3] mac80211_hwsim: advertise VHT support also when channels == 1
Date: Mon, 25 Mar 2013 21:51:45 +0100
Message-Id: <1364244705-31108-4-git-send-email-karl.beldan@gmail.com> (sfid-20130325_215227_952001_D08345FA)
In-Reply-To: <1364244705-31108-1-git-send-email-karl.beldan@gmail.com>
References: <1364244705-31108-1-git-send-email-karl.beldan@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

Drivers can now advertise VHT support even if they don't use channel
contexts.

Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
---
 drivers/net/wireless/mac80211_hwsim.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 4ac5486..70b6ce6 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2310,9 +2310,6 @@ static int __init init_mac80211_hwsim(void)
 
 			hw->wiphy->bands[band] = sband;
 
-			if (channels == 1)
-				continue;
-
 			sband->vht_cap.vht_supported = true;
 			sband->vht_cap.cap =
 				IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454 |
-- 
1.7.9.dirty

