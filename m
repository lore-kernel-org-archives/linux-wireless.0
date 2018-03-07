Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:38784 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934377AbeCHPLN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Mar 2018 10:11:13 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 08/10] staging: wilc1000: fix line over 80 char in mgmt_tx_cancel_wait()
Date: Wed, 7 Mar 2018 07:02:28 +0530
Message-ID: <1520386350-31607-9-git-send-email-ajay.kathat@microchip.com> (sfid-20180308_161122_483619_D6E13106)
In-Reply-To: <1520386350-31607-1-git-send-email-ajay.kathat@microchip.com>
References: <1520386350-31607-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix 'line over 80 char' issue found in checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 911af68..a93c550 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1705,9 +1705,13 @@ static int mgmt_tx_cancel_wait(struct wiphy *wiphy,
 	wfi_drv->p2p_timeout = jiffies;
 
 	if (!priv->p2p_listen_state) {
+		struct wilc_wfi_p2p_listen_params *params;
+
+		params = &priv->remain_on_ch_params;
+
 		cfg80211_remain_on_channel_expired(priv->wdev,
-						   priv->remain_on_ch_params.listen_cookie,
-						   priv->remain_on_ch_params.listen_ch,
+						   params->listen_cookie,
+						   params->listen_ch,
 						   GFP_KERNEL);
 	}
 
-- 
2.7.4
