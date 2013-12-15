Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42627 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab3LOVPU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Dec 2013 16:15:20 -0500
Received: by mail-pb0-f46.google.com with SMTP id md12so4589634pbc.5
        for <linux-wireless@vger.kernel.org>; Sun, 15 Dec 2013 13:15:20 -0800 (PST)
From: Thomas Pedersen <twpedersen@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: open80211s <devel@lists.open80211s.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 2/3] mac80211: reset TSF to 0 when joining a mesh
Date: Sun, 15 Dec 2013 13:14:15 -0800
Message-Id: <1387142056-21850-2-git-send-email-twpedersen@gmail.com> (sfid-20131215_221524_235029_2AB5C07A)
In-Reply-To: <1387142056-21850-1-git-send-email-twpedersen@gmail.com>
References: <1387142056-21850-1-git-send-email-twpedersen@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Thomas Pedersen <thomas@cozybit.com>

This should ensure the mac80211 DTIM count matches that of
the firmware beacon timer (DTIM 0 starts at TSF 0).

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 330d1f7..1174157 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -802,6 +802,8 @@ int ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 		return -ENOMEM;
 	}
 
+	/* next beacon will be DTIM-1, so TSF=0 was DTIM=0 */
+	drv_set_tsf(local, sdata, 0);
 	ieee80211_bss_info_change_notify(sdata, changed);
 
 	netif_carrier_on(sdata->dev);
-- 
1.7.10.4

