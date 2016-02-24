Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:41111 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351AbcBXP0g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2016 10:26:36 -0500
From: Sven Eckelmann <sven@narfation.org>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 1/2] mac80211: document only injected *_RADIOTAP_* flags
Date: Wed, 24 Feb 2016 16:25:48 +0100
Message-Id: <1456327549-31765-1-git-send-email-sven@narfation.org> (sfid-20160224_162639_469267_873E32A3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Not the internal flags but the radiotap flags are parsed when the monitor
injected frames are prepared for transmission. Thus the documentation
should only document these.

Reported-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Reported-by: Johannes Berg <johannes@sipsolutions.net>
Fixes: 5ec3aed9ba4c ("mac80211: Parse legacy and HT rate in injected frames")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
---
 Documentation/networking/mac80211-injection.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/mac80211-injection.txt b/Documentation/networking/mac80211-injection.txt
index ec8f934..0a459e4 100644
--- a/Documentation/networking/mac80211-injection.txt
+++ b/Documentation/networking/mac80211-injection.txt
@@ -37,8 +37,8 @@ radiotap headers and used to control injection:
    HT rate for the transmission (only for devices without own rate control).
    Also some flags are parsed
 
-   IEEE80211_TX_RC_SHORT_GI: use short guard interval
-   IEEE80211_TX_RC_40_MHZ_WIDTH: send in HT40 mode
+   IEEE80211_RADIOTAP_MCS_SGI: use short guard interval
+   IEEE80211_RADIOTAP_MCS_BW_40: send in HT40 mode
 
  * IEEE80211_RADIOTAP_DATA_RETRIES
 
-- 
2.7.0

