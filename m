Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44175 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638Ab0ITW5R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Sep 2010 18:57:17 -0400
Received: by fxm3 with SMTP id 3so1065867fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 20 Sep 2010 15:57:16 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: fix possible null-pointer dereference
Date: Tue, 21 Sep 2010 00:57:13 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201009210057.13297.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

net/mac80211/mesh_plink.c +574 mesh_rx_plink_frame(168)
error: we previously assumed 'sta' could be null.

This bug was detected by smatch.
( http://repo.or.cz/w/smatch.git )

Cc: <stable@kernel.org>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index ea13a80..1d7c564 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -473,7 +473,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 	rcu_read_lock();
 
 	sta = sta_info_get(sdata, mgmt->sa);
-	if (!sta && ftype != PLINK_OPEN) {
+	if (!sta || ftype != PLINK_OPEN) {
 		mpl_dbg("Mesh plink: cls or cnf from unknown peer\n");
 		rcu_read_unlock();
 		return;
