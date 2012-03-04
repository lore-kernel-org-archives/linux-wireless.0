Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:40715 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860Ab2CDIz5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 03:55:57 -0500
Received: by mail-wi0-f174.google.com with SMTP id hm2so1368116wib.19
        for <linux-wireless@vger.kernel.org>; Sun, 04 Mar 2012 00:55:57 -0800 (PST)
MIME-Version: 1.0
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 06/11] wl12xx: set correct vif type in change_interface callback
Date: Sun,  4 Mar 2012 10:55:50 +0200
Message-Id: <1330851355-24459-7-git-send-email-eliad@wizery.com> (sfid-20120304_095637_681450_6C0EC7FF)
In-Reply-To: <1330851355-24459-1-git-send-email-eliad@wizery.com>
References: <1330851355-24459-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In some cases, the wrong vif type was set in the
change_interface callback (P2P_CLIENT/P2P_GO instead
of STA/AP)

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index a330b0c..65f91d7 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2336,7 +2336,7 @@ static int wl12xx_op_change_interface(struct ieee80211_hw *hw,
 	set_bit(WL1271_FLAG_VIF_CHANGE_IN_PROGRESS, &wl->flags);
 	wl1271_op_remove_interface(hw, vif);
 
-	vif->type = ieee80211_iftype_p2p(new_type, p2p);
+	vif->type = new_type;
 	vif->p2p = p2p;
 	ret = wl1271_op_add_interface(hw, vif);
 
-- 
1.7.6.401.g6a319

