Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:63657 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755122Ab0CXIOd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Mar 2010 04:14:33 -0400
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, luciano.coelho@nokia.com
Subject: [PATCH 1/1] cfg80211: Improve connection quality maintenance docs in nl80211.h
Date: Wed, 24 Mar 2010 10:11:14 +0200
Message-Id: <1269418274-11365-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In nl80211.h, be a little more elaborate in the docs for the definitions
NL80211_ATTR_CQM_RSSI_THOLD and NL80211_ATTR_CQM_RSSI_HYST.

Reported-by: Luis R. Rodriguez <mcgrof@gmail.com>
Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 include/linux/nl80211.h |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 8994759..daf6a34 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1600,8 +1600,12 @@ enum nl80211_ps_state {
 /**
  * enum nl80211_attr_cqm - connection quality monitor attributes
  * @__NL80211_ATTR_CQM_INVALID: invalid
- * @NL80211_ATTR_CQM_RSSI_THOLD: RSSI threshold in dBm (zero to disable)
- * @NL80211_ATTR_CQM_RSSI_HYST: RSSI hysteresis in dBm
+ * @NL80211_ATTR_CQM_RSSI_THOLD: RSSI threshold in dBm. This value specifies
+ *	the threshold for the RSSI level at which an event will be sent. Zero
+ *	to disable.
+ * @NL80211_ATTR_CQM_RSSI_HYST: RSSI hysteresis in dBm. This value specifies
+ *	the minimum amount the RSSI level must change after an event before a
+ *	new event may be issued (to reduce effects of RSSI oscillation).
  * @NL80211_ATTR_CQM_RSSI_THRESHOLD_EVENT: RSSI threshold event
  * @__NL80211_ATTR_CQM_AFTER_LAST: internal
  * @NL80211_ATTR_CQM_MAX: highest key attribute
-- 
1.6.3.3

