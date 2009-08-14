Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:53520 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941AbZHNLXr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 07:23:47 -0400
From: Christian Lamparter <chunkeey@web.de>
To: wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] p54: disable PS by default
Date: Fri, 14 Aug 2009 13:23:05 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Message-Id: <200908141323.05936.chunkeey@web.de>
Content-Type: Text/Plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes kindly pointed out that I completely missed a hunk in
his patch: "[PATCH] cfg80211: allow driver to override PS default".

The driver must explicitly set ps_default to false,
as the setting is pre-filled with the kconfig default.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
index 4a741df..77203e3 100644
--- a/drivers/net/wireless/p54/main.c
+++ b/drivers/net/wireless/p54/main.c
@@ -575,6 +575,12 @@ struct ieee80211_hw *p54_init_common(size_t priv_data_len)
 	dev->extra_tx_headroom = sizeof(struct p54_hdr) + 4 +
 				 sizeof(struct p54_tx_data);
 
+	/*
+	 * For now, disable PS by default because it affects
+	 * link stability significantly.
+	 */
+	dev->wiphy->ps_default = false;
+
 	mutex_init(&priv->conf_mutex);
 	mutex_init(&priv->eeprom_mutex);
 	init_completion(&priv->eeprom_comp);
