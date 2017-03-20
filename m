Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:36215 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752592AbdCTGRd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Mar 2017 02:17:33 -0400
From: Jacob Zachariah <jacob.zac316@gmail.com>
To: aditya.shankar@microchip.com, ganesh.krishna@microchip.com,
        gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Jacob Zachariah <jacob.zac316@gmail.com>
Subject: [PATCH] staging: wilc1000: Fix sparse warning in wilc_wfi_cfgoperations.c
Date: Sun, 19 Mar 2017 23:17:08 -0700
Message-Id: <1489990628-8665-1-git-send-email-jacob.zac316@gmail.com> (sfid-20170320_071759_916014_F7EA8D1D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix the following warning reported by sparse:

drivers/staging/wilc1000/wilc_wfi_cfgoperations.c:2006:51: warning: incorrect type in assignment (different base types)
drivers/staging/wilc1000/wilc_wfi_cfgoperations.c:2006:51:    expected unsigned short [unsigned] [assigned] [usertype] ht_capa_info
drivers/staging/wilc1000/wilc_wfi_cfgoperations.c:2006:51:    got restricted __le16 const [usertype] cap_info

Signed-off-by: Jacob Zachariah <jacob.zac316@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index a37896f..bacd366 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2003,7 +2003,7 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 			strStaParams.ht_supported = false;
 		} else {
 			strStaParams.ht_supported = true;
-			strStaParams.ht_capa_info = params->ht_capa->cap_info;
+			strStaParams.ht_capa_info = le16_to_cpu(params->ht_capa->cap_info);
 			strStaParams.ht_ampdu_params = params->ht_capa->ampdu_params_info;
 			memcpy(strStaParams.ht_supp_mcs_set,
 			       &params->ht_capa->mcs,
--
1.9.1
