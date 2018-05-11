Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:42663 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752472AbeEKIOu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 May 2018 04:14:50 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 12/30] staging: wilc1000: rename clear_duringIP() to avoid camelCase issue
Date: Fri, 11 May 2018 13:43:13 +0530
Message-ID: <1526026411-11058-13-git-send-email-ajay.kathat@microchip.com> (sfid-20180511_101525_592101_B49243A6)
In-Reply-To: <1526026411-11058-1-git-send-email-ajay.kathat@microchip.com>
References: <1526026411-11058-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rename clear_duringIP() function to avoid camelCase issue reported by
checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 1408ebd..9afba4d 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -269,7 +269,7 @@ static void remove_network_from_shadow(struct timer_list *unused)
 		mod_timer(&aging_timer, jiffies + msecs_to_jiffies(AGING_TIME));
 }
 
-static void clear_duringIP(struct timer_list *unused)
+static void clear_during_ip(struct timer_list *unused)
 {
 	wilc_optaining_ip = false;
 }
@@ -2262,7 +2262,7 @@ int wilc_init_host_int(struct net_device *net)
 	priv = wdev_priv(net->ieee80211_ptr);
 	if (op_ifcs == 0) {
 		timer_setup(&aging_timer, remove_network_from_shadow, 0);
-		timer_setup(&wilc_during_ip_timer, clear_duringIP, 0);
+		timer_setup(&wilc_during_ip_timer, clear_during_ip, 0);
 	}
 	op_ifcs++;
 
-- 
2.7.4
