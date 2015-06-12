Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:34734 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbbFLVNS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2015 17:13:18 -0400
Received: by iebmu5 with SMTP id mu5so31675188ieb.1
        for <linux-wireless@vger.kernel.org>; Fri, 12 Jun 2015 14:13:17 -0700 (PDT)
Message-ID: <557B4B65.60001@cococorp.com> (sfid-20150612_231321_656673_C5FF22C0)
Date: Fri, 12 Jun 2015 14:13:09 -0700
From: Alexis Green <agreen@cococorp.com>
Reply-To: agreen@cococorp.com
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, Jesse Jones <jjones@cococorp.com>
Subject: [PATCH] mac80211: don't invalidate SN on discovery failure
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jesse Jones <jjones@cococorp.com>

The 2012 spec mentions that path SNs can be invalid when created (see
section 13.10.8.4 table 13-9) but AFAICT never talks about invalidating
SNs. Which makes sense: if we have figured out the path to a target at a
certain SN then we want to remember that fact. Failing to do so can lead
to routing loops because if we don't have a valid SN then we have no way
of knowing whether an incoming path message leads to or away from the
target.

However currently when discovery fails we zero out mpath->flags which
clears MESH_PATH_SN_VALID. This patch fixes that so that only the
discovery relevant flags are cleared.

Signed-off-by: Alexis Green <agreen@cococorp.com>

---

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 085edc1..1d849be
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -1176,7 +1176,8 @@ void mesh_path_timer(unsigned long data)
 		spin_unlock_bh(&mpath->state_lock);
 		mesh_queue_preq(mpath, 0);
 	} else {
-		mpath->flags = 0;
+		mpath->flags &= ~(MESH_PATH_RESOLVING |
+			MESH_PATH_RESOLVED | MESH_PATH_REQ_QUEUED);
 		mpath->exp_time = jiffies;
 		spin_unlock_bh(&mpath->state_lock);
 		if (!mpath->is_gate && mesh_gate_num(sdata) > 0) {
