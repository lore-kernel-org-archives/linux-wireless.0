Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:59058 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092Ab1ECX5m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 19:57:42 -0400
Received: by mail-pv0-f174.google.com with SMTP id 12so258431pvg.19
        for <linux-wireless@vger.kernel.org>; Tue, 03 May 2011 16:57:41 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Thomas Pedersen <thomas@cozybit.com>,
	Javier Cardona <javier@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Subject: [PATCH 08/13] mac80211: Self-protected management frames are not robust
Date: Tue,  3 May 2011 16:57:14 -0700
Message-Id: <1304467039-7730-9-git-send-email-javier@cozybit.com> (sfid-20110504_015746_696216_9CF929B4)
In-Reply-To: <1304467039-7730-1-git-send-email-javier@cozybit.com>
References: <1304467039-7730-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Thomas Pedersen <thomas@cozybit.com>

They may contain encrypted information elements (as AMPE frames do)
but they are not encrypted.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 include/linux/ieee80211.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index ee1c96a..a26dcb8 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1515,6 +1515,7 @@ static inline bool ieee80211_is_robust_mgmt_frame(struct ieee80211_hdr *hdr)
 		category = ((u8 *) hdr) + 24;
 		return *category != WLAN_CATEGORY_PUBLIC &&
 			*category != WLAN_CATEGORY_HT &&
+			*category != WLAN_CATEGORY_SELF_PROTECTED &&
 			*category != WLAN_CATEGORY_VENDOR_SPECIFIC;
 	}
 
-- 
1.7.1

