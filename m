Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay.kodofon.ru ([89.18.141.241]:55128 "EHLO kodofon.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755706Ab1AKMll (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jan 2011 07:41:41 -0500
Date: Tue, 11 Jan 2011 14:35:12 +0000
From: Nick Ledovskikh <nledovskikh@kodofon.vrn.ru>
To: linville@tuxdriver.com
Cc: devel@lists.open80211s.org, devel@lists.open80211s.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211:mesh_mpp_table_grow call should depend on
 MESH_WORK_GROW_MPP_TABLE flag.
Message-Id: <20110111143512.8161042b.nledovskikh@kodofon.vrn.ru>
Reply-To: nledovskikh@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace MESH_WORK_GROW_MPATH_TABLE by MESH_WORK_GROW_MPP_TABLE in 
mesh_mpp_table_grow call condition.

Signed-off-by: Nickolay Ledovskikh <nledovskikh@gmail.com>
---
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index ca3af46..2563fd1 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -645,7 +645,7 @@ void ieee80211_mesh_work(struct ieee80211_sub_if_data *sdata)
        if (test_and_clear_bit(MESH_WORK_GROW_MPATH_TABLE, &ifmsh->wrkq_flags))
                mesh_mpath_table_grow();
 
-       if (test_and_clear_bit(MESH_WORK_GROW_MPATH_TABLE, &ifmsh->wrkq_flags))
+       if (test_and_clear_bit(MESH_WORK_GROW_MPP_TABLE, &ifmsh->wrkq_flags))
                mesh_mpp_table_grow();
 
        if (test_and_clear_bit(MESH_WORK_HOUSEKEEPING, &ifmsh->wrkq_flags))

-- 
Best regards, Nickolay Ledovskikh.
