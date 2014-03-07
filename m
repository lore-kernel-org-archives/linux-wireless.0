Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:62354 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209AbaCGNiF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2014 08:38:05 -0500
Received: by mail-ee0-f53.google.com with SMTP id e51so1755036eek.12
        for <linux-wireless@vger.kernel.org>; Fri, 07 Mar 2014 05:38:03 -0800 (PST)
From: Rostislav Lisovy <lisovy@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Cc: Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
	jan-niklas.meier@volkswagen.de
Subject: [RFC PATCH 1/8] nl80211: Add new channel types -- 5MHz and 10MHz
Date: Fri,  7 Mar 2014 14:37:48 +0100
Message-Id: <1394199475-5208-2-git-send-email-rostislav.lisovy@fel.cvut.cz> (sfid-20140307_143811_354285_E0499D9B)
In-Reply-To: <1394199475-5208-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
References: <1394199475-5208-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These attributes are necessary to provide a way how to
set a channel type of '5MHz' or '10MHz' from userspace.
This is necessary for future 802.11p implementation.

Signed-off-by: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
---
 include/uapi/linux/nl80211.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 91054fd..8d0e319 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2891,12 +2891,16 @@ enum nl80211_ac {
  *	below the control channel
  * @NL80211_CHAN_HT40PLUS: HT40 channel, secondary channel
  *	above the control channel
+ * @NL80211_CHAN_5MHZ: normal, 5 MHz bandwidth
+ * @NL80211_CHAN_10MHZ: normal, 10 MHz bandwidth
  */
 enum nl80211_channel_type {
 	NL80211_CHAN_NO_HT,
 	NL80211_CHAN_HT20,
 	NL80211_CHAN_HT40MINUS,
-	NL80211_CHAN_HT40PLUS
+	NL80211_CHAN_HT40PLUS,
+	NL80211_CHAN_5MHZ,
+	NL80211_CHAN_10MHZ,
 };
 
 /**
-- 
1.8.5.1

