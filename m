Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:59276 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932492AbbDMQ1k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2015 12:27:40 -0400
Date: Mon, 13 Apr 2015 18:27:35 +0200
From: Jonathan Corbet <corbet@lwn.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Jim Davis <jim.epost@gmail.com>
Subject: [PATCH] mac80211: Fix mac80211.h docbook comments
Message-ID: <20150413182735.10c381bc@lwn.net> (sfid-20150413_182804_202779_196053DD)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A couple of enums in mac80211.h became structures recently, but the
comments didn't follow suit, leading to errors like:

  Error(.//include/net/mac80211.h:367): Cannot parse enum!
  Documentation/DocBook/Makefile:93: recipe for target 'Documentation/DocBook/80211.xml' failed
  make[1]: *** [Documentation/DocBook/80211.xml] Error 1
  Makefile:1361: recipe for target 'mandocs' failed
  make: *** [mandocs] Error 2

Fix the comments comments accordingly.  Added a couple of other small
comment fixes while I was there to silence other recently-added docbook
warnings.

Reported-by: Jim Davis <jim.epost@gmail.com>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 include/net/mac80211.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 201bc68e0cff..f1f147e246ff 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -321,7 +321,7 @@ enum ieee80211_rssi_event_data {
 };
 
 /**
- * enum ieee80211_rssi_event - data attached to an %RSSI_EVENT
+ * struct ieee80211_rssi_event - data attached to an %RSSI_EVENT
  * @data: See &enum ieee80211_rssi_event_data
  */
 struct ieee80211_rssi_event {
@@ -355,7 +355,7 @@ enum ieee80211_mlme_event_status {
 };
 
 /**
- * enum ieee80211_mlme_event - data attached to an %MLME_EVENT
+ * struct ieee80211_mlme_event - data attached to an %MLME_EVENT
  * @data: See &enum ieee80211_mlme_event_data
  * @status: See &enum ieee80211_mlme_event_status
  * @reason: the reason code if applicable
@@ -368,9 +368,10 @@ struct ieee80211_mlme_event {
 
 /**
  * struct ieee80211_event - event to be sent to the driver
- * @type The event itself. See &enum ieee80211_event_type.
+ * @type: The event itself. See &enum ieee80211_event_type.
  * @rssi: relevant if &type is %RSSI_EVENT
  * @mlme: relevant if &type is %AUTH_EVENT
+ * @u:    union holding the above two fields
  */
 struct ieee80211_event {
 	enum ieee80211_event_type type;
-- 
2.1.0

