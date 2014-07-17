Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:45097 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933851AbaGQOOX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2014 10:14:23 -0400
Received: by mail-wi0-f173.google.com with SMTP id f8so6806748wiw.6
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jul 2014 07:14:22 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 13/15] cfg80211: fix TDLS setup with VHT peers
Date: Thu, 17 Jul 2014 17:14:29 +0300
Message-Id: <1405606471-30128-14-git-send-email-arik@wizery.com> (sfid-20140717_161443_733352_2ABA05FA)
In-Reply-To: <1405606471-30128-1-git-send-email-arik@wizery.com>
References: <1405606471-30128-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some VHT TDLS peers (Google Nexus 5) include the VHT-AID IE in their
TDLS setup request/response. Usermode passes this aid as the station
aid, causing it to fail verifiction, since this happens in the
"set_station" stage. Make an exception for the TDLS use-case.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/wireless/nl80211.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 082f5c6..df7b133 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3814,7 +3814,8 @@ int cfg80211_check_station_change(struct wiphy *wiphy,
 {
 	if (params->listen_interval != -1)
 		return -EINVAL;
-	if (params->aid)
+	if (params->aid &&
+	    !(params->sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER)))
 		return -EINVAL;
 
 	/* When you run into this, adjust the code below for the new flag */
-- 
1.9.1

