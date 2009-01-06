Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:63013 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbZAFIvn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 03:51:43 -0500
Received: by mail-ew0-f17.google.com with SMTP id 10so8320917ewy.13
        for <linux-wireless@vger.kernel.org>; Tue, 06 Jan 2009 00:51:41 -0800 (PST)
Message-ID: <eb3ff54b0901060051y5b6f557dkf17a98ae8d8e2311@mail.gmail.com> (sfid-20090106_095145_468131_E6CE937C)
Date: Tue, 6 Jan 2009 10:51:41 +0200
From: "Rami Rosen" <ramirose@gmail.com>
To: linville@tuxdriver.com
Subject: [PATCH 6/6] mac80211: remove unused declaration in mesh_plink_block().
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes and unused declaration (mac) in mesh_plink_block(),
mesh_plink.c.

(wireless-testing).

Signed-off-by: Rami Rosen <ramirose@gmail.com>

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index faac101..1c76a0e 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -360,10 +360,6 @@ int mesh_plink_open(struct sta_info *sta)

 void mesh_plink_block(struct sta_info *sta)
 {
-#ifdef CONFIG_MAC80211_VERBOSE_MPL_DEBUG
-	DECLARE_MAC_BUF(mac);
-#endif
-
 	spin_lock_bh(&sta->lock);
 	__mesh_plink_deactivate(sta);
 	sta->plink_state = PLINK_BLOCKED;
