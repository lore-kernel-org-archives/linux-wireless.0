Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:45371 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab1DOFCc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2011 01:02:32 -0400
Date: Fri, 15 Apr 2011 10:24:38 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>
Subject: [PATCH 2/2] mwl8k: setting IEEE80211_HW_CRYPTO_ENABLED for AP mode
Message-ID: <20110415045430.GA11530@hertz.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For AP mode, driver sets IEEE80211_HW_CRYPTO_ENABLED hardware flag to avoid
mac80211 reserving tail room space for crypto suite.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
---
 drivers/net/wireless/mwl8k.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 28ebaec..7ddc9ca 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -5472,6 +5472,10 @@ static int mwl8k_firmware_load_success(struct mwl8k_priv *priv)
 
 	/* Set rssi values to dBm */
 	hw->flags |= IEEE80211_HW_SIGNAL_DBM | IEEE80211_HW_HAS_RATE_CONTROL;
+
+	/* This is needed to avoid tailroom calculations */
+	hw->flags |= priv->ap_fw ? IEEE80211_HW_CRYPTO_ENABLED : 0;
+
 	hw->vif_data_size = sizeof(struct mwl8k_vif);
 	hw->sta_data_size = sizeof(struct mwl8k_sta);
 
-- 
1.7.3.5

