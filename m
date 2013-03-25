Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:39786 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758081Ab3CYPa2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Mar 2013 11:30:28 -0400
Received: by mail-ee0-f46.google.com with SMTP id e49so3243234eek.5
        for <linux-wireless@vger.kernel.org>; Mon, 25 Mar 2013 08:30:27 -0700 (PDT)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@gmail.com>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: [PATCH 3/3] mac80211_hwsim: advertise VHT support also when channels == 1
Date: Mon, 25 Mar 2013 16:26:59 +0100
Message-Id: <1364225219-18473-4-git-send-email-karl.beldan@gmail.com> (sfid-20130325_163036_128725_ADAEE019)
In-Reply-To: <1364225219-18473-1-git-send-email-karl.beldan@gmail.com>
References: <1364225219-18473-1-git-send-email-karl.beldan@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

Drivers can now advertise VHT support even if they don't use channel
contexts.

Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
---
 drivers/net/wireless/mac80211_hwsim.c |    3 ---
 1 file changed, 3 deletions(-)

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
1.7.10.GIT

