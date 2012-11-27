Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:42408 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756643Ab2K0GpU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 01:45:20 -0500
Received: by mail-wi0-f178.google.com with SMTP id hm6so4054043wib.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2012 22:45:19 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 07/20] wlcore: clear roc_vif on iface removal
Date: Tue, 27 Nov 2012 08:44:48 +0200
Message-Id: <1353998701-18171-8-git-send-email-arik@wizery.com> (sfid-20121127_074613_589782_E70BDFE6)
In-Reply-To: <1353998701-18171-1-git-send-email-arik@wizery.com>
References: <1353998701-18171-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When removing an interface currently performing a ROC operation, clear
the current ROC state. This is useful especially during recovery and
keeps mac80211 in sync to our state.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 05ba72a..b659efd 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -2416,6 +2416,11 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 		wl->sched_vif = NULL;
 	}
 
+	if (wl->roc_vif == vif) {
+		wl->roc_vif = NULL;
+		ieee80211_remain_on_channel_expired(wl->hw);
+	}
+
 	if (!test_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS, &wl->flags)) {
 		/* disable active roles */
 		ret = wl1271_ps_elp_wakeup(wl);
-- 
1.7.9.5

