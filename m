Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:37423 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915Ab2KSQkA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 11:40:00 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so2051722eaa.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Nov 2012 08:39:59 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 15/15] wlcore: configure the remote rates with our own rates
Date: Mon, 19 Nov 2012 18:39:30 +0200
Message-Id: <1353343170-26516-16-git-send-email-eliad@wizery.com> (sfid-20121119_174527_622409_CB58BAC6)
In-Reply-To: <1353343170-26516-1-git-send-email-eliad@wizery.com>
References: <1353343170-26516-1-git-send-email-eliad@wizery.com>
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
index 4c2ed25..ec7e8b3 100644
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

