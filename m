Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog133.obsmtp.com ([74.125.149.82]:47139 "EHLO
	na3sys009aog133.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966330Ab2EPDAM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 23:00:12 -0400
Received: by lbom4 with SMTP id m4so244110lbo.2
        for <linux-wireless@vger.kernel.org>; Tue, 15 May 2012 20:00:09 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] wlcore: fix some sparse warnings due to missing static declaration
Date: Wed, 16 May 2012 06:00:00 +0300
Message-Id: <1337137200-32538-3-git-send-email-coelho@ti.com> (sfid-20120516_050021_845157_43182B76)
In-Reply-To: <1337137200-32538-1-git-send-email-coelho@ti.com>
References: <1337137200-32538-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There were three sparse warnings in main.c due to missing static
declaration:

  CHECK   drivers/net/wireless/ti/wlcore/main.c
drivers/net/wireless/ti/wlcore/main.c:1265:5: warning: symbol 'wl1271_validate_wowlan_pattern' was not declared. Should it be static?
drivers/net/wireless/ti/wlcore/main.c:1408:5: warning: symbol 'wl1271_convert_wowlan_pattern_to_rx_filter' was not declared. Should it be static?
drivers/net/wireless/ti/wlcore/main.c:4823:6: warning: symbol 'wl1271_connection_loss_work' was not declared. Should it be static?

Fix these by adding the static declaration to those functions.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/main.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 45fe911..acef933 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1262,7 +1262,8 @@ static struct sk_buff *wl12xx_alloc_dummy_packet(struct wl1271 *wl)
 
 
 #ifdef CONFIG_PM
-int wl1271_validate_wowlan_pattern(struct cfg80211_wowlan_trig_pkt_pattern *p)
+static int
+wl1271_validate_wowlan_pattern(struct cfg80211_wowlan_trig_pkt_pattern *p)
 {
 	int num_fields = 0, in_field = 0, fields_size = 0;
 	int i, pattern_len = 0;
@@ -1405,7 +1406,7 @@ void wl1271_rx_filter_flatten_fields(struct wl12xx_rx_filter *filter,
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
1.7.10

