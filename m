Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:49961 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753915Ab3LaReA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Dec 2013 12:34:00 -0500
Received: from spike ([81.217.122.98]) by mail.gmx.com (mrgmx102) with ESMTPSA
 (Nemesis) id 0M2FhY-1V8Z6o2DRM-00s79L for <linux-wireless@vger.kernel.org>;
 Tue, 31 Dec 2013 18:33:58 +0100
Date: Tue, 31 Dec 2013 18:33:57 +0100
From: Christian Engelmayer <cengelma@gmx.at>
To: Solomon Peachy <pizza@shaftnet.org>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] wireless: cw1200: Fix memory leak in cw1200_wow_suspend()
Message-ID: <20131231183357.3664e978@spike> (sfid-20131231_183404_551762_2F30ED8B)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix a memory leak in the cw1200_wow_suspend() error handling path.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
 drivers/net/wireless/cw1200/pm.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/cw1200/pm.c b/drivers/net/wireless/cw1200/pm.c
index b37abb9..6907c8f 100644
--- a/drivers/net/wireless/cw1200/pm.c
+++ b/drivers/net/wireless/cw1200/pm.c
@@ -225,7 +225,7 @@ int cw1200_wow_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 		cw1200_set_pm(priv, &priv->powersave_mode);
 		if (wait_event_interruptible_timeout(priv->ps_mode_switch_done,
 						     !priv->ps_mode_switch_in_progress, 1*HZ) <= 0) {
-			goto revert3;
+			goto revert4;
 		}
 	}
 
@@ -254,11 +254,11 @@ int cw1200_wow_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 
 	/* Stop serving thread */
 	if (cw1200_bh_suspend(priv))
-		goto revert4;
+		goto revert5;
 
 	ret = timer_pending(&priv->mcast_timeout);
 	if (ret)
-		goto revert5;
+		goto revert6;
 
 	/* Store suspend state */
 	pm_state->suspend_state = state;
@@ -280,9 +280,9 @@ int cw1200_wow_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 
 	return 0;
 
-revert5:
+revert6:
 	WARN_ON(cw1200_bh_resume(priv));
-revert4:
+revert5:
 	cw1200_resume_work(priv, &priv->bss_loss_work,
 			   state->bss_loss_tmo);
 	cw1200_resume_work(priv, &priv->join_timeout,
@@ -291,6 +291,7 @@ revert4:
 			   state->direct_probe);
 	cw1200_resume_work(priv, &priv->link_id_gc_work,
 			   state->link_id_gc);
+revert4:
 	kfree(state);
 revert3:
 	wsm_set_udp_port_filter(priv, &cw1200_udp_port_filter_off);
-- 
1.8.3.2
