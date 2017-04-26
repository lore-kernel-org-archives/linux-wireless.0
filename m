Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33603 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2998351AbdDZKfA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 06:35:00 -0400
Received: by mail-pf0-f193.google.com with SMTP id c198so15977883pfc.0
        for <linux-wireless@vger.kernel.org>; Wed, 26 Apr 2017 03:34:59 -0700 (PDT)
From: Xinming Hu <huxinming820@gmail.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Zhiyuan Yang <yangzy@marvell.com>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>
Subject: [PATCH] mwifiex: p2p client using same data path as station
Date: Wed, 26 Apr 2017 10:34:48 +0000
Message-Id: <1493202888-20784-1-git-send-email-huxinming820@gmail.com> (sfid-20170426_123509_568716_C9050263)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

P2p client act as a station, data will be queued by DA instead
of RA. This patch pass the sanity check, so that p2p client share
the same data path with infrastruction station mode.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/main.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index f1cb875..72e87bf 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -1235,7 +1235,8 @@ int mwifiex_cmd_802_11_bg_scan_config(struct mwifiex_private *priv,
 	 * Currently we assume if we are in Infra, then DA=RA. This might not be
 	 * true in the future
 	 */
-	if ((priv->bss_mode == NL80211_IFTYPE_STATION) &&
+	if ((priv->bss_mode == NL80211_IFTYPE_STATION ||
+	     priv->bss_mode == NL80211_IFTYPE_P2P_CLIENT) &&
 	    (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA))
 		return false;
 
-- 
1.9.1
