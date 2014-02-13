Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58812 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199AbaBMM21 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Feb 2014 07:28:27 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: j@w1.fi, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: remove erroneous comment about RX radiotap header
Date: Thu, 13 Feb 2014 13:28:23 +0100
Message-Id: <1392294503-13726-1-git-send-email-johannes@sipsolutions.net> (sfid-20140213_132830_873583_7AD10706)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no way the driver can pre-build the radiotap header,
so remove the comment stating that it can.

Reported-by: Jouni Malinen <j@w1.fi>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 2d4d312..a6bcc39 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -66,10 +66,6 @@
  *
  * Secondly, when the hardware handles fragmentation, the frame handed to
  * the driver from mac80211 is the MSDU, not the MPDU.
- *
- * Finally, for received frames, the driver is able to indicate that it has
- * filled a radiotap header and put that in front of the frame; if it does
- * not do so then mac80211 may add this under certain circumstances.
  */
 
 /**
-- 
1.8.5.3

