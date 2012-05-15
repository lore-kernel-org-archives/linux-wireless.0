Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47224 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab2EOOJG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 10:09:06 -0400
Received: by wgbdr13 with SMTP id dr13so5822694wgb.1
        for <linux-wireless@vger.kernel.org>; Tue, 15 May 2012 07:09:04 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 01/10] wlcore: fix sparse warnings related to static functions
Date: Tue, 15 May 2012 17:08:51 +0300
Message-Id: <1337090940-13750-1-git-send-email-arik@wizery.com> (sfid-20120515_160910_582167_398A4D34)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The "static" modifier was mistakenly forgotten for some functions.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
These patches apply on top of the wl18xx support series.

 drivers/net/wireless/ti/wl18xx/main.c |    2 +-
 drivers/net/wireless/ti/wlcore/main.c |    7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index f1fef39..d7e48db 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -1097,7 +1097,7 @@ static struct ieee80211_sta_ht_cap wl18xx_mimo_ht_cap = {
 		},
 };
 
-int __devinit wl18xx_probe(struct platform_device *pdev)
+static int __devinit wl18xx_probe(struct platform_device *pdev)
 {
 	struct wl1271 *wl;
 	struct ieee80211_hw *hw;
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index f4b036e..659634b 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1212,7 +1212,8 @@ static struct sk_buff *wl12xx_alloc_dummy_packet(struct wl1271 *wl)
 
 
 #ifdef CONFIG_PM
-int wl1271_validate_wowlan_pattern(struct cfg80211_wowlan_trig_pkt_pattern *p)
+static int wl1271_validate_wowlan_pattern(
+	struct cfg80211_wowlan_trig_pkt_pattern *p)
 {
 	int num_fields = 0, in_field = 0, fields_size = 0;
 	int i, pattern_len = 0;
@@ -1355,7 +1356,7 @@ void wl1271_rx_filter_flatten_fields(struct wl12xx_rx_filter *filter,
  * Allocates an RX filter returned through f
  * which needs to be freed using rx_filter_free()
  */
-int wl1271_convert_wowlan_pattern_to_rx_filter(
+static int wl1271_convert_wowlan_pattern_to_rx_filter(
 	struct cfg80211_wowlan_trig_pkt_pattern *p,
 	struct wl12xx_rx_filter **f)
 {
@@ -4820,7 +4821,7 @@ static struct bin_attribute fwlog_attr = {
 	.read = wl1271_sysfs_read_fwlog,
 };
 
-void wl1271_connection_loss_work(struct work_struct *work)
+static void wl1271_connection_loss_work(struct work_struct *work)
 {
 	struct delayed_work *dwork;
 	struct wl1271 *wl;
-- 
1.7.9.5

