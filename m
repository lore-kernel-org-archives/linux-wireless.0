Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:25482 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753122AbYLDPIR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Dec 2008 10:08:17 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 04 Dec 2008 07:08:17 -0800
Date: Thu, 4 Dec 2008 20:38:13 +0530
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>, Jouni Malinen <j@w1.fi>,
	Luis Rodriguez <lrodriguez@atheros.com>
Subject: [PATCH] wireless: Incorrect LEAP authentication algorithm
	identifier.
Message-ID: <20081204150813.GA7816@senthil-lnx.users.atheros.com> (sfid-20081204_160821_653972_71E0ECD4)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a regression introduced by
"wireless: avoid some net/ieee80211.h vs. linux/ieee80211.h conflicts"
LEAP authentication algorithm identifier should be 128.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 include/linux/ieee80211.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index a6ec928..c4e6ca1 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -836,7 +836,7 @@ struct ieee80211_ht_info {
 /* Authentication algorithms */
 #define WLAN_AUTH_OPEN 0
 #define WLAN_AUTH_SHARED_KEY 1
-#define WLAN_AUTH_LEAP 2
+#define WLAN_AUTH_LEAP 128
 
 #define WLAN_AUTH_CHALLENGE_LEN 128
 
-- 
1.6.0.4

