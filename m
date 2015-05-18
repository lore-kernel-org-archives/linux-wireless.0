Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:35893 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932724AbbERUjs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2015 16:39:48 -0400
Received: by lagv1 with SMTP id v1so237388971lag.3
        for <linux-wireless@vger.kernel.org>; Mon, 18 May 2015 13:39:46 -0700 (PDT)
Message-ID: <555a4e12.e323700a.26a6.ffff9e65@mx.google.com> (sfid-20150518_223955_315748_38E6840F)
From: andrey.konovalov@linaro.org
To: johannes@sipsolutions.net, emmanuel.grumbach@intel.com
Cc: linux-wireless@vger.kernel.org,
	Andrey Konovalov <andrey.konovalov@linaro.org>
Subject: [PATCH] mac80211: fix kernel-doc comments in mac80211.h
Date: Mon, 18 May 2015 23:39:28 +0300
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commits a818292 "mac80211: convert rssi_callback() to event_callback()"
and a940909 "mac80211: notify the driver about authentication status"
added two errors and one warning when building docs for the mac80211
driver. Fix the kernel-doc comments so that the documentation targets
could be built successfully again.

Signed-off-by: Andrey Konovalov <andrey.konovalov@linaro.org>
---
 include/net/mac80211.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index b4bef11..dbb5f33 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -354,7 +354,7 @@ enum ieee80211_rssi_event_data {
 };
 
 /**
- * enum ieee80211_rssi_event - data attached to an %RSSI_EVENT
+ * struct ieee80211_rssi_event - data attached to an %RSSI_EVENT
  * @data: See &enum ieee80211_rssi_event_data
  */
 struct ieee80211_rssi_event {
@@ -388,7 +388,7 @@ enum ieee80211_mlme_event_status {
 };
 
 /**
- * enum ieee80211_mlme_event - data attached to an %MLME_EVENT
+ * struct ieee80211_mlme_event - data attached to an %MLME_EVENT
  * @data: See &enum ieee80211_mlme_event_data
  * @status: See &enum ieee80211_mlme_event_status
  * @reason: the reason code if applicable
@@ -401,7 +401,7 @@ struct ieee80211_mlme_event {
 
 /**
  * struct ieee80211_event - event to be sent to the driver
- * @type The event itself. See &enum ieee80211_event_type.
+ * @type: The event itself. See &enum ieee80211_event_type.
  * @rssi: relevant if &type is %RSSI_EVENT
  * @mlme: relevant if &type is %AUTH_EVENT
  */
-- 
1.7.9.5

