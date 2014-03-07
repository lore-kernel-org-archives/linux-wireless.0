Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:38899 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbaCGNiG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2014 08:38:06 -0500
Received: by mail-ea0-f172.google.com with SMTP id l9so2349912eaj.3
        for <linux-wireless@vger.kernel.org>; Fri, 07 Mar 2014 05:38:05 -0800 (PST)
From: Rostislav Lisovy <lisovy@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Cc: Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
	jan-niklas.meier@volkswagen.de
Subject: [RFC PATCH 2/8] nl80211: Add attributes describing channel bandwidth
Date: Fri,  7 Mar 2014 14:37:49 +0100
Message-Id: <1394199475-5208-3-git-send-email-rostislav.lisovy@fel.cvut.cz> (sfid-20140307_143845_587446_D90320C6)
In-Reply-To: <1394199475-5208-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
References: <1394199475-5208-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These attributes are used to report back to userspace
the information about the bandwidth allowed in
a particular channel

Signed-off-by: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
---
 include/uapi/linux/nl80211.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 8d0e319..b5b5600 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2304,6 +2304,12 @@ enum nl80211_band_attr {
  * @NL80211_FREQUENCY_ATTR_NO_160MHZ: any 160 MHz (but not 80+80) channel
  *	using this channel as the primary or any of the secondary channels
  *	isn't possible
+ * @NL80211_FREQUENCY_ATTR_NO_20MHZ: 20 MHz operation is not allowed
+ *     on this channel in current regulatory domain.
+ *     - this still allows 10 MHz and 5 MHz operation
+ * @NL80211_FREQUENCY_ATTR_NO_10MHZ: 10 MHz operation is not allowed
+ *     on this channel in current regulatory domain.
+ *     - this still allows 20 MHz and 5 MHz operation
  * @NL80211_FREQUENCY_ATTR_MAX: highest frequency attribute number
  *	currently defined
  * @__NL80211_FREQUENCY_ATTR_AFTER_LAST: internal use
@@ -2322,6 +2328,8 @@ enum nl80211_frequency_attr {
 	NL80211_FREQUENCY_ATTR_NO_HT40_PLUS,
 	NL80211_FREQUENCY_ATTR_NO_80MHZ,
 	NL80211_FREQUENCY_ATTR_NO_160MHZ,
+	NL80211_FREQUENCY_ATTR_NO_20MHZ,
+	NL80211_FREQUENCY_ATTR_NO_10MHZ,
 
 	/* keep last */
 	__NL80211_FREQUENCY_ATTR_AFTER_LAST,
-- 
1.8.5.1

