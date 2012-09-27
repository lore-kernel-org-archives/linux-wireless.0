Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:47749 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756736Ab2I0Kio (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 06:38:44 -0400
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, Eliad Peller <eliad@wizery.com>
Subject: [PATCH 25/31] wlcore: invalidate keep-alive template on disconnection
Date: Thu, 27 Sep 2012 13:38:03 +0300
Message-Id: <1348742289-6587-26-git-send-email-luca@coelho.fi> (sfid-20120927_123924_379270_8588FE30)
In-Reply-To: <1348742289-6587-1-git-send-email-luca@coelho.fi>
References: <1348742289-6587-1-git-send-email-luca@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Previously, invalidation of the keep-alive template was
done when going idle. However, while removing the
idle-handling we didn't move the keep-alive template
invalidation to another place.

This finally resulted in fw error when trying to use
the keep-alive template by another role.

(Note that we still have an error here - each role
should have its unique keep-alive template id, while
currently they all use CMD_TEMPL_KLV_IDX_NULL_DATA (0).
This only works now because we don't support concurrent
connected stations yet)

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Luciano Coelho <luca@coelho.fi>
---
 drivers/net/wireless/ti/wlcore/main.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 3f5d87e..7c04b0b 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -2544,6 +2544,11 @@ static int wl1271_unjoin(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 		ieee80211_chswitch_done(vif, false);
 	}
 
+	/* invalidate keep-alive template */
+	wl1271_acx_keep_alive_config(wl, wlvif,
+				     CMD_TEMPL_KLV_IDX_NULL_DATA,
+				     ACX_KEEP_ALIVE_TPL_INVALID);
+
 	/* to stop listening to a channel, we disconnect */
 	ret = wl12xx_cmd_role_stop_sta(wl, wlvif);
 	if (ret < 0)
-- 
1.7.10.4

