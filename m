Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:23803 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab0CRK1Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 06:27:25 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kalle.valo@nokia.com>,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 12/21] wl1271: fix ps scheme in wl1271_op_conf_tx()
Date: Thu, 18 Mar 2010 12:26:37 +0200
Message-Id: <1268908006-16992-13-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1268908006-16992-1-git-send-email-luciano.coelho@nokia.com>
References: <1268908006-16992-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

Commit "wl1271: implement WMM" accidentally used CONF_PS_SCHEME_LEGACY_PSPOLL,
but instead CONF_PS_SCHEME_LEGACY should be used as earlier.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index fbc42ce..2a2e584 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1801,7 +1801,7 @@ static int wl1271_op_conf_tx(struct ieee80211_hw *hw, u16 queue,
 	ret = wl1271_acx_tid_cfg(wl, wl1271_tx_get_queue(queue),
 				 CONF_CHANNEL_TYPE_EDCF,
 				 wl1271_tx_get_queue(queue),
-				 CONF_PS_SCHEME_LEGACY_PSPOLL,
+				 CONF_PS_SCHEME_LEGACY,
 				 CONF_ACK_POLICY_LEGACY, 0, 0);
 	if (ret < 0)
 		goto out_sleep;
-- 
1.6.3.3

