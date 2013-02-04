Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f178.google.com ([209.85.210.178]:54341 "EHLO
	mail-ia0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185Ab3BDWNq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 17:13:46 -0500
Received: by mail-ia0-f178.google.com with SMTP id y26so8568489iab.37
        for <linux-wireless@vger.kernel.org>; Mon, 04 Feb 2013 14:13:46 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH] mac80211: stop plink timer only on mesh interfaces
Date: Mon,  4 Feb 2013 14:12:41 -0800
Message-Id: <1360015961-5922-1-git-send-email-thomas@cozybit.com> (sfid-20130204_231351_661906_D041EDF0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since mesh_plink_quiesce() would unconditionally delete
the plink timer, and the timer initialization was recently
moved into the mesh code path, suspending with a non-mesh
interface now causes a crash. Fix this by only deleting
the plink timer for mesh interfaces.

Reported-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---

Hi Emmanuel,

Will you please test this patch?

 net/mac80211/mesh_plink.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 81e6126..1f40c4a 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -528,6 +528,9 @@ static void mesh_plink_timer(unsigned long data)
 #ifdef CONFIG_PM
 void mesh_plink_quiesce(struct sta_info *sta)
 {
+	if (!ieee80211_vif_is_mesh(&sta->sdata->vif))
+		return;
+
 	if (del_timer_sync(&sta->plink_timer))
 		sta->plink_timer_was_running = true;
 }
-- 
1.7.10.4

