Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:35994 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbbFARPv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2015 13:15:51 -0400
Received: by wgbgq6 with SMTP id gq6so120327655wgb.3
        for <linux-wireless@vger.kernel.org>; Mon, 01 Jun 2015 10:15:50 -0700 (PDT)
From: Chaitanya T K <chaitanya.mgit@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: Chaitanya T K <chaitanya.mgit@gmail.com>
Subject: [PATCH V2] mac80211: Fix power save state stuck in ACTIVE caused by race between suspend and Tx packet.
Date: Mon,  1 Jun 2015 22:44:45 +0530
Message-Id: <1433178885-8787-1-git-send-email-chaitanya.mgit@gmail.com> (sfid-20150601_191555_052478_F1449F6D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaitanya T K <chaitanya.mgit@gmail.com>

If suspended during TX in progress, there can be 
race where the driver is put of of power-save due
to TX and during suspend dynamic_ps_time is cancelled
and TX packet is flushed, leaving the driver in ACTIVE
even after resuming until dynamic_ps_time puts 
driver back in DOZE. (Which only happens if there
is another TX).

This can lead high power consumption of chipset during (or)
after resuming also.

Signed-off-by: Chaitanya T K <chaitanya.mgit@gmail.com>
---
V2: Updated Comment and Commit log.
---
 net/mac80211/pm.c |   15 +++++++++++++++
 net/mac80211/pm.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index ac6ad62..cc311be 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -76,6 +76,21 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 			if (sdata->vif.type != NL80211_IFTYPE_STATION)
 				continue;
 			ieee80211_mgd_quiesce(sdata);
+			/* If suspended during TX in progress, there
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
