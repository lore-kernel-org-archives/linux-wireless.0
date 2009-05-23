Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:60481 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbZEWS2i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 May 2009 14:28:38 -0400
From: Christian Lamparter <chunkeey@web.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/4] ar9170: kill duplicated HT feature flag
Date: Sat, 23 May 2009 20:28:38 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200905232028.38786.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes a redundant flag.

.cap	=	IEEE80211_HT_CAP_MAX_AMSDU |	\
>		IEEE80211_HT_CAP_SM_PS |			\ <
		[...]									\
>		IEEE80211_HT_CAP_SM_PS,			\ <
		.ampdu_factor   = 3,					\

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index 201989a..1657e89 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -146,7 +146,6 @@ static struct ieee80211_channel ar9170_5ghz_chantable[] = {
 {									\
 	.ht_supported	= true,						\
 	.cap		= IEEE80211_HT_CAP_MAX_AMSDU |			\
-			  IEEE80211_HT_CAP_SM_PS |			\
 			  IEEE80211_HT_CAP_SUP_WIDTH_20_40 |		\
 			  IEEE80211_HT_CAP_SGI_40 |			\
 			  IEEE80211_HT_CAP_DSSSCCK40 |			\
