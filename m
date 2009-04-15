Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39887 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873AbZDORTb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2009 13:19:31 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Lu8lm-0002TC-CE
	for linux-wireless@vger.kernel.org; Wed, 15 Apr 2009 19:19:30 +0200
Message-Id: <20090415171633.723852466@sipsolutions.net> (sfid-20090415_191937_921308_A4403082)
References: <20090415171046.336006351@sipsolutions.net>
Date: Wed, 15 Apr 2009 19:10:49 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 3/3] mac80211: enable PS by default
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable PS by default -- rely on drivers to control the level
using pm_qos. Due to the previous patch we turn off PS when
necessary due to latency requirements.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/mlme.c |    3 +++
 1 file changed, 3 insertions(+)

--- wireless-testing.orig/net/mac80211/mlme.c	2009-04-15 18:56:41.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-04-15 18:56:42.000000000 +0200
@@ -2163,6 +2163,9 @@ void ieee80211_sta_setup_sdata(struct ie
 		IEEE80211_STA_AUTO_CHANNEL_SEL;
 	if (sdata->local->hw.queues >= 4)
 		ifmgd->flags |= IEEE80211_STA_WMM_ENABLED;
+
+	if (sdata->local->hw.flags & IEEE80211_HW_SUPPORTS_PS)
+		ifmgd->powersave = 1;
 }
 
 /* configuration hooks */

-- 

