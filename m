Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:32863 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbcBJQbV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Feb 2016 11:31:21 -0500
Received: by mail-wm0-f46.google.com with SMTP id g62so34403017wme.0
        for <linux-wireless@vger.kernel.org>; Wed, 10 Feb 2016 08:31:20 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [RFC 1/2] cfg80211: add radiotap VHT info to rtap_namespace_sizes
Date: Wed, 10 Feb 2016 17:31:16 +0100
Message-Id: <1455121877-7238-2-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20160210_173125_940419_6F5DBBD6)
In-Reply-To: <1455121877-7238-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1455121877-7238-1-git-send-email-lorenzo.bianconi83@gmail.com>
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

