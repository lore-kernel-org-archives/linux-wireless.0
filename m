Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:12531 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbeIDLDh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 07:03:37 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 02/26] staging: wilc1000: move 'aging_timer' static variable to wilc_priv struct
Date: Tue, 4 Sep 2018 12:09:18 +0530
Message-ID: <1536043182-19735-3-git-send-email-ajay.kathat@microchip.com> (sfid-20180904_083959_153405_4321F191)
In-Reply-To: <1536043182-19735-1-git-send-email-ajay.kathat@microchip.com>
References: <1536043182-19735-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Moved 'aging_timer' to wilc_priv struct instead of having it as static
variable.
As 'aging_timer' is maintained for each interfaces so 'op_ifcs' check is
not required before the timer_setup() and del_timer_sync() call.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 25 ++++++++++++-----------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  2 +-
 2 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 4727a8a..d853508 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -85,7 +85,6 @@ static const struct wiphy_wowlan_support wowlan_support = {
 static struct network_info last_scanned_shadow[MAX_NUM_SCANNED_NETWORKS_SHADOW];
 static u32 last_scanned_cnt;
 struct timer_list wilc_during_ip_timer;
-static struct timer_list aging_timer;
 static u8 op_ifcs;
 
 #define CHAN2G(_channel, _freq, _flags) {	 \
@@ -165,8 +164,6 @@ static void clear_shadow_scan(void)
 	if (op_ifcs != 0)
 		return;
 
-	del_timer_sync(&aging_timer);
-
 	for (i = 0; i < last_scanned_cnt; i++) {
 		if (last_scanned_shadow[last_scanned_cnt].ies) {
 			kfree(last_scanned_shadow[i].ies);
@@ -245,8 +242,9 @@ static void update_scan_time(void)
 		last_scanned_shadow[i].time_scan = jiffies;
 }
 
-static void remove_network_from_shadow(struct timer_list *unused)
+static void remove_network_from_shadow(struct timer_list *t)
 {
+	struct wilc_priv *priv = from_timer(priv, t, aging_timer);
 	unsigned long now = jiffies;
 	int i, j;
 
@@ -266,7 +264,8 @@ static void remove_network_from_shadow(struct timer_list *unused)
 	}
 
 	if (last_scanned_cnt != 0)
-		mod_timer(&aging_timer, jiffies + msecs_to_jiffies(AGING_TIME));
+		mod_timer(&priv->aging_timer,
+			  jiffies + msecs_to_jiffies(AGING_TIME));
 }
 
 static void clear_during_ip(struct timer_list *unused)
@@ -274,13 +273,15 @@ static void clear_during_ip(struct timer_list *unused)
 	wilc_optaining_ip = false;
 }
 
-static int is_network_in_shadow(struct network_info *nw_info, void *user_void)
+static int is_network_in_shadow(struct network_info *nw_info,
+				struct wilc_priv *priv)
 {
 	int state = -1;
 	int i;
 
 	if (last_scanned_cnt == 0) {
-		mod_timer(&aging_timer, jiffies + msecs_to_jiffies(AGING_TIME));
+		mod_timer(&priv->aging_timer,
+			  jiffies + msecs_to_jiffies(AGING_TIME));
 		state = -1;
 	} else {
 		for (i = 0; i < last_scanned_cnt; i++) {
@@ -295,9 +296,9 @@ static int is_network_in_shadow(struct network_info *nw_info, void *user_void)
 }
 
 static void add_network_to_shadow(struct network_info *nw_info,
-				  void *user_void, void *join_params)
+				  struct wilc_priv *priv, void *join_params)
 {
-	int ap_found = is_network_in_shadow(nw_info, user_void);
+	int ap_found = is_network_in_shadow(nw_info, priv);
 	u32 ap_index = 0;
 	u8 rssi_index = 0;
 	struct network_info *shadow_nw_info;
@@ -2166,10 +2167,9 @@ int wilc_init_host_int(struct net_device *net)
 	int ret;
 	struct wilc_priv *priv = wdev_priv(net->ieee80211_ptr);
 
-	if (op_ifcs == 0) {
-		timer_setup(&aging_timer, remove_network_from_shadow, 0);
+	timer_setup(&priv->aging_timer, remove_network_from_shadow, 0);
+	if (op_ifcs == 0)
 		timer_setup(&wilc_during_ip_timer, clear_during_ip, 0);
-	}
 	op_ifcs++;
 
 	priv->p2p_listen_state = false;
@@ -2195,6 +2195,7 @@ int wilc_deinit_host_int(struct net_device *net)
 	mutex_destroy(&priv->scan_req_lock);
 	ret = wilc_deinit(vif);
 
+	del_timer_sync(&priv->aging_timer);
 	clear_shadow_scan();
 	if (op_ifcs == 0)
 		del_timer_sync(&wilc_during_ip_timer);
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 8b74d61..a76b68c 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -94,7 +94,7 @@ struct wilc_priv {
 	/* mutexes */
 	struct mutex scan_req_lock;
 	bool p2p_listen_state;
-
+	struct timer_list aging_timer;
 };
 
 struct frame_reg {
-- 
2.7.4
