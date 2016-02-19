Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33245 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992784AbcBSKnL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2016 05:43:11 -0500
Received: by mail-wm0-f68.google.com with SMTP id c200so7295418wme.0
        for <linux-wireless@vger.kernel.org>; Fri, 19 Feb 2016 02:43:09 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v2 1/2] cfg80211: add radiotap VHT info to rtap_namespace_sizes
Date: Fri, 19 Feb 2016 11:43:04 +0100
Message-Id: <1455878585-5525-2-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20160219_114328_247307_F5A2F43E)
In-Reply-To: <1455878585-5525-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1455878585-5525-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add IEEE80211_RADIOTAP_VHT entry to rtap_namespace_sizes array in order to
define alignment and size of VHT info in tx radiotap

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 net/wireless/radiotap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/radiotap.c b/net/wireless/radiotap.c
index 722da61..6582d15 100644
--- a/net/wireless/radiotap.c
+++ b/net/wireless/radiotap.c
@@ -43,6 +43,7 @@ static const struct radiotap_align_size rtap_namespace_sizes[] = {
 	[IEEE80211_RADIOTAP_DATA_RETRIES] = { .align = 1, .size = 1, },
 	[IEEE80211_RADIOTAP_MCS] = { .align = 1, .size = 3, },
 	[IEEE80211_RADIOTAP_AMPDU_STATUS] = { .align = 4, .size = 8, },
+	[IEEE80211_RADIOTAP_VHT] = { .align = 2, .size = 12, },
 	/*
 	 * add more here as they are defined in radiotap.h
 	 */
-- 
2.5.0

