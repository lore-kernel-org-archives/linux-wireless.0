Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:33996 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391Ab3KEMEW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 07:04:22 -0500
Received: by mail-ea0-f170.google.com with SMTP id q10so3386841eaj.15
        for <linux-wireless@vger.kernel.org>; Tue, 05 Nov 2013 04:04:21 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v3 3/3] mac80211_hwsim: VHT add 160MHz width support
Date: Tue,  5 Nov 2013 13:03:54 +0100
Message-Id: <1383653034-6679-2-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131105_130426_351511_04AEC21F)
In-Reply-To: <1383653034-6679-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1383653034-6679-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add 160MHz width support. This could be
usefull for testing VHT160 DFS functionality.
This could be also usefull in the future when
DFS and non-DFS channels could be mixed.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/mac80211_hwsim.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 8519b13..8f24fe8 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2389,6 +2389,7 @@ static int __init init_mac80211_hwsim(void)
 			sband->vht_cap.cap =
 				IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454 |
 				IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ |
+				IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ |
 				IEEE80211_VHT_CAP_RXLDPC |
 				IEEE80211_VHT_CAP_SHORT_GI_80 |
 				IEEE80211_VHT_CAP_SHORT_GI_160 |
-- 
1.7.9.5

