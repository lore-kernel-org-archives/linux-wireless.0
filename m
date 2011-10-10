Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41933 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889Ab1JJINZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 04:13:25 -0400
Received: by mail-ey0-f174.google.com with SMTP id 27so1109073eye.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2011 01:13:25 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 28/29] wl12xx: add elp wakeup/sleep calls to add_interface
Date: Mon, 10 Oct 2011 10:13:16 +0200
Message-Id: <1318234397-21081-29-git-send-email-eliad@wizery.com> (sfid-20111010_101331_933428_07B35008)
In-Reply-To: <1318234397-21081-1-git-send-email-eliad@wizery.com>
References: <1318234397-21081-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

add_interface might be called while the chip is
in elp. add elp_wakeup/sleep calls to handle it.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 20a2a4b..e5edf64 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2115,6 +2115,10 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 		     ieee80211_vif_type_p2p(vif), vif->addr);
 
 	mutex_lock(&wl->mutex);
+	ret = wl1271_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out_unlock;
+
 	if (wl->vif) {
 		wl1271_debug(DEBUG_MAC80211,
 			     "multiple vifs are not supported yet");
@@ -2190,6 +2194,8 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 	list_add(&wlvif->list, &wl->wlvif_list);
 	set_bit(WLVIF_FLAG_INITIALIZED, &wlvif->flags);
 out:
+	wl1271_ps_elp_sleep(wl);
+out_unlock:
 	mutex_unlock(&wl->mutex);
 
 	mutex_lock(&wl_list_mutex);
-- 
1.7.6.401.g6a319

