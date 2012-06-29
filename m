Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:62843 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754358Ab2F2KrZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2012 06:47:25 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 04/13] cfg80211: track ibss fixed channel
Date: Fri, 29 Jun 2012 12:46:59 +0200
Message-ID: <1340966828-22874-5-git-send-email-michal.kazior@tieto.com> (sfid-20120629_124755_766663_DAC60DC4)
In-Reply-To: <1340966828-22874-1-git-send-email-michal.kazior@tieto.com>
References: <1340966828-22874-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

IBSS may hop between channels. It is necessary to
account this special case when considering
interface combinations.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 include/net/cfg80211.h |    2 ++
 net/wireless/ibss.c    |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index c62bc78..e030c6a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2411,6 +2411,8 @@ struct wireless_dev {
 	/* for AP and mesh channel tracking */
 	struct ieee80211_channel *channel;
 
+	bool ibss_fixed;
+
 	bool ps;
 	int ps_timeout;
 
diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index 89baa33..b90fd86 100644
--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -113,6 +113,7 @@ int __cfg80211_join_ibss(struct cfg80211_registered_device *rdev,
 		kfree(wdev->connect_keys);
 	wdev->connect_keys = connkeys;
 
+	wdev->ibss_fixed = params->channel_fixed;
 #ifdef CONFIG_CFG80211_WEXT
 	wdev->wext.ibss.channel = params->channel;
 #endif
-- 
1.7.0.4

