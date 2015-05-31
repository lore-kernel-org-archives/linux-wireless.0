Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:35797 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbbEaKWZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 May 2015 06:22:25 -0400
Received: by wgme6 with SMTP id e6so92945641wgm.2
        for <linux-wireless@vger.kernel.org>; Sun, 31 May 2015 03:22:24 -0700 (PDT)
From: Chaitanya T K <chaitanya.mgit@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Chaitanya T K <chaitanya.mgit@gmail.com>
Subject: [PATCH] mac80211: Fix power save state stuck in ACTIVE caused by race between suspend and Tx packet.
Date: Sun, 31 May 2015 15:52:11 +0530
Message-Id: <1433067731-20114-1-git-send-email-chaitanya.mgit@gmail.com> (sfid-20150531_122408_973977_DB036358)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaitanya T K <chaitanya.mgit@gmail.com>

If we receive suspend after TX path has executed
dynamic ps disable work, the driver will be in 
ACTIVE state during suspend and even after it 
resumes. 

As before suspend all data packets are flushed
it is safe to put the driver in to sleep for
optimal power during suspend or up on resume.

Signed-off-by: Chaitanya T K <chaitanya.mgit@gmail.com>
---
 net/mac80211/pm.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index ac6ad62..c9d71c2 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -76,6 +76,21 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 			if (sdata->vif.type != NL80211_IFTYPE_STATION)
 				continue;
 			ieee80211_mgd_quiesce(sdata);
+			/* This is to handle a race where suspend
+			 * is invoked after dynamic ps work disables
+			 * power save due to TX. This causes the driver
+			 * to be stuck in ACTIVE during suspend and
+			 * after resume unless there is another TX,
+			 * after which the dynamic ps puts driver
+			 * back to DOZE.
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
