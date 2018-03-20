Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:29807 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751782AbeCTQ4R (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Mar 2018 12:56:17 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 07/11] staging: wilc1000: rename hAgingTimer to avoid camelCase issue
Date: Tue, 20 Mar 2018 22:25:40 +0530
Message-ID: <1521564944-3565-8-git-send-email-ajay.kathat@microchip.com> (sfid-20180320_175621_372573_F8E4DAC0)
In-Reply-To: <1521564944-3565-1-git-send-email-ajay.kathat@microchip.com>
References: <1521564944-3565-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix 'Avoid camelCase' issue found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 9950ca5..ebebdc3 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -90,7 +90,7 @@ static const struct wiphy_wowlan_support wowlan_support = {
 static struct network_info last_scanned_shadow[MAX_NUM_SCANNED_NETWORKS_SHADOW];
 static u32 last_scanned_cnt;
 struct timer_list wilc_during_ip_timer;
-static struct timer_list hAgingTimer;
+static struct timer_list aging_timer;
 static u8 op_ifcs;
 
 #define CHAN2G(_channel, _freq, _flags) {	 \
@@ -174,7 +174,7 @@ static void clear_shadow_scan(void)
 	int i;
 
 	if (op_ifcs == 0) {
-		del_timer_sync(&hAgingTimer);
+		del_timer_sync(&aging_timer);
 
 		for (i = 0; i < last_scanned_cnt; i++) {
 			if (last_scanned_shadow[last_scanned_cnt].ies) {
@@ -276,7 +276,7 @@ static void remove_network_from_shadow(struct timer_list *unused)
 	}
 
 	if (last_scanned_cnt != 0) {
-		mod_timer(&hAgingTimer, jiffies + msecs_to_jiffies(AGING_TIME));
+		mod_timer(&aging_timer, jiffies + msecs_to_jiffies(AGING_TIME));
 	}
 }
 
@@ -291,7 +291,7 @@ static int is_network_in_shadow(struct network_info *nw_info, void *user_void)
 	int i;
 
 	if (last_scanned_cnt == 0) {
-		mod_timer(&hAgingTimer, jiffies + msecs_to_jiffies(AGING_TIME));
+		mod_timer(&aging_timer, jiffies + msecs_to_jiffies(AGING_TIME));
 		state = -1;
 	} else {
 		for (i = 0; i < last_scanned_cnt; i++) {
@@ -2282,7 +2282,7 @@ int wilc_init_host_int(struct net_device *net)
 
 	priv = wdev_priv(net->ieee80211_ptr);
 	if (op_ifcs == 0) {
-		timer_setup(&hAgingTimer, remove_network_from_shadow, 0);
+		timer_setup(&aging_timer, remove_network_from_shadow, 0);
 		timer_setup(&wilc_during_ip_timer, clear_duringIP, 0);
 	}
 	op_ifcs++;
-- 
2.7.4
