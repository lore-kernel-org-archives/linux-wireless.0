Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34017 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbcGDLJc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jul 2016 07:09:32 -0400
Received: by mail-wm0-f68.google.com with SMTP id 187so20855005wmz.1
        for <linux-wireless@vger.kernel.org>; Mon, 04 Jul 2016 04:09:31 -0700 (PDT)
From: lemagoup@gmail.com
To: kvalo@qca.qualcomm.com
Cc: ath6kl@lists.infradead.org, linux-wireless@vger.kernel.org,
	jmassot@aldebaran.com,
	Pierre Le Magourou <plemagourou@aldebaran.com>
Subject: [PATCH v2 3/3] ath6kl: Unset IFF_LOWER_UP flag on AP mode leave.
Date: Mon,  4 Jul 2016 13:07:19 +0200
Message-Id: <20160704110719.7694-4-plemagourou@aldebaran.com> (sfid-20160704_130947_290040_C88E67F0)
In-Reply-To: <20160704110719.7694-1-plemagourou@aldebaran.com>
References: <20160704110719.7694-1-plemagourou@aldebaran.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pierre Le Magourou <plemagourou@aldebaran.com>

When disabling tethering after having enabled it, the ath6kl driver does
not set the IFF_LOWER_UP flag to 0 (carrier off) on the wlan interface.

The upper layers (eg. connman) are not notified of the tethering mode
status change. So, tethering can not be activated anymore.

This patch adds a netif_carrier_off() call when stopping AP mode to fix
the problem.

Signed-off-by: Pierre Le Magourou <plemagourou@aldebaran.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index c9c4d7f..713d230 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2972,6 +2972,7 @@ static int ath6kl_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 
 	ath6kl_wmi_disconnect_cmd(ar->wmi, vif->fw_vif_idx);
 	clear_bit(CONNECTED, &vif->flags);
+	netif_carrier_off(vif->ndev);
 
 	/* Restore ht setting in firmware */
 	return ath6kl_restore_htcap(vif);
-- 
2.9.0

