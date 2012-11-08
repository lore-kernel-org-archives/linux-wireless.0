Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:49578 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab2KHMh0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Nov 2012 07:37:26 -0500
Received: by mail-wg0-f44.google.com with SMTP id dr13so1798593wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 08 Nov 2012 04:37:25 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH] mac80211: clear lower drv private data on iface removal
Date: Thu,  8 Nov 2012 14:37:21 +0200
Message-Id: <1352378241-31906-1-git-send-email-arik@wizery.com> (sfid-20121108_133738_096409_FA9EC387)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The lower driver might rely on getting zeroed per-vif private memory
when an interface is added. Resetting the memory on removal avoids
adverse affects during recovery, where the interface is added without
being removed.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 net/mac80211/driver-ops.h |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index d3d9fda..4620117 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -183,6 +183,10 @@ static inline void drv_remove_interface(struct ieee80211_local *local,
 	trace_drv_remove_interface(local, sdata);
 	local->ops->remove_interface(&local->hw, &sdata->vif);
 	sdata->flags &= ~IEEE80211_SDATA_IN_DRIVER;
+
+	/* clear driver specific private data */
+	memset(sdata->vif.drv_priv, 0, sdata->local->hw.vif_data_size);
+
 	trace_drv_return_void(local);
 }
 
-- 
1.7.9.5

