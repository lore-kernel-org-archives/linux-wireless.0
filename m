Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:65427 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878Ab3CXWSM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Mar 2013 18:18:12 -0400
Received: by mail-we0-f181.google.com with SMTP id p43so4602379wea.12
        for <linux-wireless@vger.kernel.org>; Sun, 24 Mar 2013 15:18:11 -0700 (PDT)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Karl Beldan <karl.beldan@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: [RFC V4 3/3] mac80211_hwsim: advertise VHT support also when channels == 1
Date: Sun, 24 Mar 2013 23:17:43 +0100
Message-Id: <1364163463-16372-4-git-send-email-karl.beldan@gmail.com> (sfid-20130324_231818_839094_0F42E726)
In-Reply-To: <1364163463-16372-1-git-send-email-karl.beldan@gmail.com>
References: <1364163463-16372-1-git-send-email-karl.beldan@gmail.com>
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
index b8b562e..509539f 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2312,9 +2312,6 @@ static int __init init_mac80211_hwsim(void)
 
 			hw->wiphy->bands[band] = sband;
 
-			if (channels == 1)
-				continue;
-
 			sband->vht_cap.vht_supported = true;
 			sband->vht_cap.cap =
 				IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454 |
-- 
1.7.9.dirty

