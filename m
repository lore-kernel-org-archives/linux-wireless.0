Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:33340 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266AbbFJNmq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 09:42:46 -0400
Received: by wiwd19 with SMTP id d19so48941824wiw.0
        for <linux-wireless@vger.kernel.org>; Wed, 10 Jun 2015 06:42:45 -0700 (PDT)
From: Chaitanya T K <chaitanya.mgit@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: Chaitanya T K <chaitanya.mgit@gmail.com>
Subject: [PATCH V3] mac80211: wowlan: suspend: Fix power save state stuck in ACTIVE caused by race between suspend and Tx packet.
Date: Wed, 10 Jun 2015 19:12:31 +0530
Message-Id: <1433943751-11221-1-git-send-email-chaitanya.mgit@gmail.com> (sfid-20150610_154547_668010_C396A7A8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaitanya T K <chaitanya.mgit@gmail.com>

Background: When wowlan is enabled, the chipset stays in low
power state maintaining the connection as per the
mac80211 power save state.

If suspended during TX in progress, there can be 
race where the driver is put of of power-save due
to TX and during suspend dynamic_ps_time is cancelled
and TX packet is flushed, leaving the driver in ACTIVE
even after resuming until dynamic_ps_time puts 
driver back in DOZE. (Which only happens if there
is another TX).

This can lead to high power consumption of chipset 
during (or) after resuming.

Signed-off-by: Chaitanya T K <chaitanya.mgit@gmail.com>
---
V2: Updated Comment and Commit log.
---
 net/mac80211/pm.c |   16 +++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index ac6ad62..8149a3d 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -76,6 +76,22 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 			if (sdata->vif.type != NL80211_IFTYPE_STATION)
 				continue;
 			ieee80211_mgd_quiesce(sdata);
+			/* If suspended during TX in progress, and wowlan
+			 * is enabled (connection will be active) there
+			 * can be a race where the driver is put out
+			 * of power-save due to TX and during suspend
+			 * dynamic_ps_timer is cancelled and TX packet
+			 * is flushed, leaving the driver in ACTIVE even
+			 * after resuming until dynamic_ps_timer puts
+			 * driver back in DOZE.
+			 */
+			if (sdata->u.mgd.associated &&
+			    sdata->u.mgd.powersave &&
+			     !(local->hw.conf.flags & IEEE80211_CONF_PS)) {
+				local->hw.conf.flags |= IEEE80211_CONF_PS;
+				ieee80211_hw_config(local,
+						    IEEE80211_CONF_CHANGE_PS);
+			}
 		}
 
 		err = drv_suspend(local, wowlan);
