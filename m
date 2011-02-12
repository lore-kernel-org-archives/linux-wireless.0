Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34988 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab1BLAF3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Feb 2011 19:05:29 -0500
Received: by yxt3 with SMTP id 3so1313050yxt.19
        for <linux-wireless@vger.kernel.org>; Fri, 11 Feb 2011 16:05:28 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: buytenh@wantstofly.org
Subject: [PATCH 2/2] mwl8k: Tell mac80211 we have rate adaptation in AP FW
Date: Fri, 11 Feb 2011 16:03:51 -0800
Message-Id: <1297469031-21004-2-git-send-email-thomas@cozybit.com>
In-Reply-To: <1297469031-21004-1-git-send-email-thomas@cozybit.com>
References: <1297469031-21004-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Nishant Sarmukadam <nishants@marvell.com>

Minstrel rate control algorithm is enabled by default by mac80211.
This is not needed since the firmware does the rate control in our case.

Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 drivers/net/wireless/mwl8k.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index f79da1b..840b9e4 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -4765,6 +4765,9 @@ static int mwl8k_firmware_load_success(struct mwl8k_priv *priv)
 
 	/* Set rssi values to dBm */
 	hw->flags |= IEEE80211_HW_SIGNAL_DBM;
+	/* AP FW has rate control */
+	if (priv->ap_fw)
+		hw->flags |= IEEE80211_HW_HAS_RATE_CONTROL;
 	hw->vif_data_size = sizeof(struct mwl8k_vif);
 	hw->sta_data_size = sizeof(struct mwl8k_sta);
 
-- 
1.7.0.4

