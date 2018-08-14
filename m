Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:41327 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727670AbeHNJgd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Aug 2018 05:36:33 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 07/24] staging: wilc1000: remove unused variable 'op_ifcs'
Date: Tue, 14 Aug 2018 12:19:59 +0530
Message-ID: <1534229416-13254-8-git-send-email-ajay.kathat@microchip.com> (sfid-20180814_085047_542406_BE22AA8F)
In-Reply-To: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
References: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After code refactor in previous commit now 'op_ifcs' is not require any
more, so remove it.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 1690890..3418d2d 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -82,8 +82,6 @@ static const struct wiphy_wowlan_support wowlan_support = {
 	.flags = WIPHY_WOWLAN_ANY
 };
 
-static u8 op_ifcs;
-
 #define CHAN2G(_channel, _freq, _flags) {	 \
 		.band             = NL80211_BAND_2GHZ, \
 		.center_freq      = (_freq),		 \
@@ -2164,7 +2162,6 @@ int wilc_init_host_int(struct net_device *net)
 
 	timer_setup(&priv->aging_timer, remove_network_from_shadow, 0);
 	timer_setup(&vif->during_ip_timer, clear_during_ip, 0);
-	op_ifcs++;
 
 	priv->p2p_listen_state = false;
 
@@ -2184,8 +2181,6 @@ int wilc_deinit_host_int(struct net_device *net)
 
 	priv->p2p_listen_state = false;
 
-	op_ifcs--;
-
 	mutex_destroy(&priv->scan_req_lock);
 	ret = wilc_deinit(vif);
 
-- 
2.7.4
