Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:52006 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932788AbaFQNG5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jun 2014 09:06:57 -0400
Received: by mail-wi0-f176.google.com with SMTP id n3so5807752wiv.15
        for <linux-wireless@vger.kernel.org>; Tue, 17 Jun 2014 06:06:55 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: luca@coelho.fi, johannes@sipsolutions.net,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v10 5/5] cfg80211: remove channel_switch combination check
Date: Tue, 17 Jun 2014 14:58:58 +0200
Message-Id: <1403009938-1084-6-git-send-email-michal.kazior@tieto.com> (sfid-20140617_150701_514244_FDD08263)
In-Reply-To: <1403009938-1084-1-git-send-email-michal.kazior@tieto.com>
References: <1402577680-17888-1-git-send-email-michal.kazior@tieto.com>
 <1403009938-1084-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Driver is now responsible for veryfing if the
switch is possible.

Since this is inherently tricky driver may decide
to disconnect an interface later with
cfg80211_stop_iface().

This doesn't mean driver can accept everything. It
should do it's best to verify requests and reject
them as soon as possible.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    v7:
     * emphasize channel switching verification should not be
       taken lightly [Johannes]
     * update channel_switch description in cfg80211.h

 include/net/cfg80211.h |  7 ++++++-
 net/wireless/nl80211.c | 11 -----------
 2 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 6b02dd6..3d829d4 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2301,7 +2301,12 @@ struct cfg80211_qos_map {
  *	reliability. This operation can not fail.
  * @set_coalesce: Set coalesce parameters.
  *
- * @channel_switch: initiate channel-switch procedure (with CSA)
+ * @channel_switch: initiate channel-switch procedure (with CSA). Driver is
+ *	responsible for veryfing if the switch is possible. Since this is
+ *	inherently tricky driver may decide to disconnect an interface later
+ *	with cfg80211_stop_iface(). This doesn't mean driver can accept
+ *	everything. It should do it's best to verify requests and reject them
+ *	as soon as possible.
  *
  * @set_qos_map: Set QoS mapping information to the driver
  *
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ba4f172..d70f542 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6012,17 +6012,6 @@ skip_beacons:
 		params.radar_required = true;
 	}
 
-	/* TODO: I left this here for now.  With channel switch, the
-	 * verification is a bit more complicated, because we only do
-	 * it later when the channel switch really happens.
-	 */
-	err = cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
-					   params.chandef.chan,
-					   CHAN_MODE_SHARED,
-					   radar_detect_width);
-	if (err)
-		return err;
-
 	if (info->attrs[NL80211_ATTR_CH_SWITCH_BLOCK_TX])
 		params.block_tx = true;
 
-- 
1.8.5.3

