Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:37722 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756481Ab2I0Kik (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 06:38:40 -0400
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 07/31] wlcore: allow only the lowest OFDM rate for p2p setup frames
Date: Thu, 27 Sep 2012 13:37:45 +0300
Message-Id: <1348742289-6587-8-git-send-email-luca@coelho.fi> (sfid-20120927_124022_921509_871E527C)
In-Reply-To: <1348742289-6587-1-git-send-email-luca@coelho.fi>
References: <1348742289-6587-1-git-send-email-luca@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

The IEEE80211_TX_CTL_NO_CCK_RATE flag is only set for mgmt packets
transmitted during p2p connection setup. Make sure to use the lowest
OFDM rate guarantee the peer always hears us.
Change the p2p rate policy to contain only the 6mpbs rate to acheive
this effect.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <luca@coelho.fi>
---
 drivers/net/wireless/ti/wlcore/conf.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/conf.h b/drivers/net/wireless/ti/wlcore/conf.h
index d77224f..9e40760 100644
--- a/drivers/net/wireless/ti/wlcore/conf.h
+++ b/drivers/net/wireless/ti/wlcore/conf.h
@@ -412,8 +412,7 @@ struct conf_rx_settings {
 #define CONF_TX_RATE_RETRY_LIMIT       10
 
 /* basic rates for p2p operations (probe req/resp, etc.) */
-#define CONF_TX_RATE_MASK_BASIC_P2P    (CONF_HW_BIT_RATE_6MBPS | \
-	CONF_HW_BIT_RATE_12MBPS | CONF_HW_BIT_RATE_24MBPS)
+#define CONF_TX_RATE_MASK_BASIC_P2P    CONF_HW_BIT_RATE_6MBPS
 
 /*
  * Rates supported for data packets when operating as AP. Note the absence
-- 
1.7.10.4

