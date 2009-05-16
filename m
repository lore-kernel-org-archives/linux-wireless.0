Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:17125 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754799AbZEPMJ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 May 2009 08:09:57 -0400
Received: by ey-out-2122.google.com with SMTP id 9so739066eyd.37
        for <linux-wireless@vger.kernel.org>; Sat, 16 May 2009 05:09:58 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@googlemail.com>
Subject: [RFC 2/3] cfg80211: mark wiphy->privid as pointer to const
Date: Sat, 16 May 2009 13:22:56 +0100
Message-Id: <1242476577-26320-3-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1242476577-26320-1-git-send-email-kilroyd@googlemail.com>
References: <1242476577-26320-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows drivers to use a const pointer as the privid without a cast.

Signed-off by: David Kilroy <kilroyd@gmail.com>
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

