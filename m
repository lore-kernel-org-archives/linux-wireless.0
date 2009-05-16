Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:34423 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451AbZEPWAt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 May 2009 18:00:49 -0400
Received: by mail-ew0-f176.google.com with SMTP id 24so3263140ewy.37
        for <linux-wireless@vger.kernel.org>; Sat, 16 May 2009 15:00:50 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@googlemail.com>,
	David Kilroy <kilroyd@gmail.com>
Subject: [PATCH 2/2] cfg80211: mark wiphy->privid as pointer to const
Date: Sat, 16 May 2009 23:13:47 +0100
Message-Id: <1242512027-15682-3-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1242512027-15682-1-git-send-email-kilroyd@googlemail.com>
References: <1242512027-15682-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows drivers to use a const pointer as the privid without a cast.

Signed-off-by: David Kilroy <kilroyd@gmail.com>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/cfg80211.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 7702715..0639962 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -994,7 +994,7 @@ struct wiphy {
 	 * know whether it points to a wiphy your driver has registered
 	 * or not. Assign this to something global to your driver to
 	 * help determine whether you own this wiphy or not. */
-	void *privid;
+	const void *privid;
 
 	struct ieee80211_supported_band *bands[IEEE80211_NUM_BANDS];
 
-- 
1.6.0.6

