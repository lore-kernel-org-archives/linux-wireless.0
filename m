Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:40647 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754943Ab1AaHlz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 02:41:55 -0500
Received: from dlep33.itg.ti.com ([157.170.170.112])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id p0V7fsn6004487
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 31 Jan 2011 01:41:54 -0600
Received: from dlep26.itg.ti.com (localhost [127.0.0.1])
	by dlep33.itg.ti.com (8.13.7/8.13.7) with ESMTP id p0V7fsHV006602
	for <linux-wireless@vger.kernel.org>; Mon, 31 Jan 2011 01:41:54 -0600 (CST)
Received: from dlee74.ent.ti.com (localhost [127.0.0.1])
	by dlep26.itg.ti.com (8.13.8/8.13.8) with ESMTP id p0V7fs3K006659
	for <linux-wireless@vger.kernel.org>; Mon, 31 Jan 2011 01:41:54 -0600 (CST)
Received: from pimenta.tieu.ti.com (h64-3.vpn.ti.com [172.24.64.3])	by
 dlelxv22.itg.ti.com (8.13.8/8.13.8) with ESMTP id p0V7fqZ6006465	for
 <linux-wireless@vger.kernel.org>; Mon, 31 Jan 2011 01:41:53 -0600
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: fix warning due to missing arg in ampdu_action
Date: Mon, 31 Jan 2011 09:41:52 +0200
Message-ID: <1296459712-1056-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 0b01f030d38e00650e2db42da083d8647aad40a5 added a new argument
to the ampdu_action operation.  The ampdu_action operation in the
wl12xx driver currently doesn't have that argument and this generates
a warning.  This happened during merging of the latest mac80211
patches with the wl12xx BA patches.

  CC [M]  drivers/net/wireless/wl12xx/main.o
drivers/net/wireless/wl12xx/main.c:3035: warning: initialization from incompatible pointer type

The wl12xx driver doesn't need to do anything about the buf_size
argument since the AMPDU TX is fully handled by the firmware.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/main.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index dfab21e..254b7da 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2724,8 +2724,9 @@ out:
 }
 
 int wl1271_op_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-			    enum ieee80211_ampdu_mlme_action action,
-			    struct ieee80211_sta *sta, u16 tid, u16 *ssn)
+			   enum ieee80211_ampdu_mlme_action action,
+			   struct ieee80211_sta *sta, u16 tid, u16 *ssn,
+			   u8 buf_size)
 {
 	struct wl1271 *wl = hw->priv;
 	int ret;
-- 
1.7.1

