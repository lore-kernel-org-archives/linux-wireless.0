Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:50335 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209AbaCGNiI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2014 08:38:08 -0500
Received: by mail-ea0-f170.google.com with SMTP id g15so2311391eak.15
        for <linux-wireless@vger.kernel.org>; Fri, 07 Mar 2014 05:38:06 -0800 (PST)
From: Rostislav Lisovy <lisovy@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Cc: Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
	jan-niklas.meier@volkswagen.de
Subject: [RFC PATCH 3/8] cfg80211: Add attributes describing channel bandwidth
Date: Fri,  7 Mar 2014 14:37:50 +0100
Message-Id: <1394199475-5208-4-git-send-email-rostislav.lisovy@fel.cvut.cz> (sfid-20140307_143813_961966_FF2CEB3F)
In-Reply-To: <1394199475-5208-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
References: <1394199475-5208-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since channels with frequencies ranging from 5850 to 5925
are used with 5/10 MHz channels according to IEEE 802.11p,
we need a way how to keep the information about the forbidden
bandwidths.

Signed-off-by: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
---
 include/net/cfg80211.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index b1f84b0..f5ecd6c 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -109,6 +109,10 @@ enum ieee80211_band {
  *	channel as the control or any of the secondary channels.
  *	This may be due to the driver or due to regulatory bandwidth
  *	restrictions.
+ * @IEEE80211_CHAN_NO_20MHZ: 20 MHz bandwidth is not permitted
+ *     on this channel.
+ * @IEEE80211_CHAN_NO_10MHZ: 10 MHz bandwidth is not permitted
+ *     on this channel.
  */
 enum ieee80211_channel_flags {
 	IEEE80211_CHAN_DISABLED		= 1<<0,
@@ -120,6 +124,8 @@ enum ieee80211_channel_flags {
 	IEEE80211_CHAN_NO_OFDM		= 1<<6,
 	IEEE80211_CHAN_NO_80MHZ		= 1<<7,
 	IEEE80211_CHAN_NO_160MHZ	= 1<<8,
+	IEEE80211_CHAN_NO_20MHZ		= 1<<9,
+	IEEE80211_CHAN_NO_10MHZ		= 1<<10,
 };
 
 #define IEEE80211_CHAN_NO_HT40 \
-- 
1.8.5.1

