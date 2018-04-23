Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:12878 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755192AbeDWQe4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Apr 2018 12:34:56 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [RESEND 03/33] staging: wilc1000: remove line over 80 char warnings in set_wiphy_params()
Date: Mon, 23 Apr 2018 22:03:05 +0530
Message-ID: <1524501215-4963-4-git-send-email-ajay.kathat@microchip.com> (sfid-20180423_183509_516207_9C0995D7)
In-Reply-To: <1524501215-4963-1-git-send-email-ajay.kathat@microchip.com>
References: <1524501215-4963-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix 'line over 80 character' issue reported by checkpatch.pl script in
set_wiphy_params(). Directly used the 'wiphy' pointer received as
function argument instead of using 'priv->dev->ieee80211_ptr->wiphy'.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 402f12e..8bd821f 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1185,20 +1185,20 @@ static int set_wiphy_params(struct wiphy *wiphy, u32 changed)
 
 	if (changed & WIPHY_PARAM_RETRY_SHORT) {
 		cfg_param_val.flag  |= RETRY_SHORT;
-		cfg_param_val.short_retry_limit = priv->dev->ieee80211_ptr->wiphy->retry_short;
+		cfg_param_val.short_retry_limit = wiphy->retry_short;
 	}
 	if (changed & WIPHY_PARAM_RETRY_LONG) {
 		cfg_param_val.flag |= RETRY_LONG;
-		cfg_param_val.long_retry_limit = priv->dev->ieee80211_ptr->wiphy->retry_long;
+		cfg_param_val.long_retry_limit = wiphy->retry_long;
 	}
 	if (changed & WIPHY_PARAM_FRAG_THRESHOLD) {
 		cfg_param_val.flag |= FRAG_THRESHOLD;
-		cfg_param_val.frag_threshold = priv->dev->ieee80211_ptr->wiphy->frag_threshold;
+		cfg_param_val.frag_threshold = wiphy->frag_threshold;
 	}
 
 	if (changed & WIPHY_PARAM_RTS_THRESHOLD) {
 		cfg_param_val.flag |= RTS_THRESHOLD;
-		cfg_param_val.rts_threshold = priv->dev->ieee80211_ptr->wiphy->rts_threshold;
+		cfg_param_val.rts_threshold = wiphy->rts_threshold;
 	}
 
 	ret = wilc_hif_set_cfg(vif, &cfg_param_val);
-- 
2.7.4
