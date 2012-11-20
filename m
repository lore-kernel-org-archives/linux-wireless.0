Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57714 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab2KTLUb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 06:20:31 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so1625946eek.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Nov 2012 03:20:31 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 11/11] wlcore: configure the remote rates with our own rates
Date: Tue, 20 Nov 2012 13:20:11 +0200
Message-Id: <1353410411-18833-12-git-send-email-eliad@wizery.com> (sfid-20121120_122036_244371_A395A769)
In-Reply-To: <1353410411-18833-1-git-send-email-eliad@wizery.com>
References: <1353410411-18833-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the new connection flow, start_sta is called before
the remote rates where updated. Use our own supported rates
instead to make sure we don't disable any potential rate
(the rate policies will be updated later, but there is
currently no way to update the remote rates)

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/cmd.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 1cf1225..04ba86d 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -479,7 +479,12 @@ int wl12xx_cmd_role_start_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	}
 	cmd->sta.hlid = wlvif->sta.hlid;
 	cmd->sta.session = wl12xx_get_new_session_id(wl, wlvif);
-	cmd->sta.remote_rates = cpu_to_le32(wlvif->rate_set);
+	/*
+	 * We don't have the correct remote rates in this stage, and there
+	 * is no way to update them later, so use our supported rates instead.
+	 * The fw will take the configured rate policies into account anyway.
+	 */
+	cmd->sta.remote_rates = cpu_to_le32(supported_rates);
 
 	wl1271_debug(DEBUG_CMD, "role start: roleid=%d, hlid=%d, session=%d "
 		     "basic_rate_set: 0x%x, remote_rates: 0x%x",
-- 
1.7.6.401.g6a319

