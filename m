Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:38405 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752080Ab2KTJEN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 04:04:13 -0500
Received: from dlelxv30.itg.ti.com ([172.17.2.17])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id qAK94CdE027319
	for <linux-wireless@vger.kernel.org>; Tue, 20 Nov 2012 03:04:12 -0600
Received: from DLEE74.ent.ti.com (dlee74.ent.ti.com [157.170.170.8])
	by dlelxv30.itg.ti.com (8.13.8/8.13.8) with ESMTP id qAK94Ckc030681
	for <linux-wireless@vger.kernel.org>; Tue, 20 Nov 2012 03:04:12 -0600
From: Luciano Coelho <coelho@ti.com>
To: <coelho@ti.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] wlcore: remove a bunch of unnecessary parentheses
Date: Tue, 20 Nov 2012 11:03:32 +0200
Message-ID: <1353402212-20439-3-git-send-email-coelho@ti.com> (sfid-20121120_100420_910747_CB5506E4)
In-Reply-To: <1353402212-20439-1-git-send-email-coelho@ti.com>
References: <1353402212-20439-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some if statements had unnecessary parentheses.  Remove them for
consistency.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/main.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index c056bb3..11d20b1 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -3692,7 +3692,7 @@ static int wl1271_bss_beacon_info_changed(struct wl1271 *wl,
 	bool is_ap = (wlvif->bss_type == BSS_TYPE_AP_BSS);
 	int ret = 0;
 
-	if ((changed & BSS_CHANGED_BEACON_INT)) {
+	if (changed & BSS_CHANGED_BEACON_INT) {
 		wl1271_debug(DEBUG_MASTER, "beacon interval updated: %d",
 			bss_conf->beacon_int);
 
@@ -3705,7 +3705,7 @@ static int wl1271_bss_beacon_info_changed(struct wl1271 *wl,
 		wl1271_ap_set_probe_resp_tmpl(wl, rate, vif);
 	}
 
-	if ((changed & BSS_CHANGED_BEACON)) {
+	if (changed & BSS_CHANGED_BEACON) {
 		ret = wlcore_set_beacon_template(wl, vif, is_ap);
 		if (ret < 0)
 			goto out;
@@ -3726,7 +3726,7 @@ static void wl1271_bss_info_changed_ap(struct wl1271 *wl,
 	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	int ret = 0;
 
-	if ((changed & BSS_CHANGED_BASIC_RATES)) {
+	if (changed & BSS_CHANGED_BASIC_RATES) {
 		u32 rates = bss_conf->basic_rates;
 
 		wlvif->basic_rate_set = wl1271_tx_enabled_rates_get(wl, rates,
@@ -3858,7 +3858,7 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 			wl1271_warning("idle mode change failed %d", ret);
 	}
 
-	if ((changed & BSS_CHANGED_CQM)) {
+	if (changed & BSS_CHANGED_CQM) {
 		bool enable = false;
 		if (bss_conf->cqm_rssi_thold)
 			enable = true;
@@ -3901,7 +3901,7 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 		rcu_read_unlock();
 	}
 
-	if ((changed & BSS_CHANGED_ASSOC)) {
+	if (changed & BSS_CHANGED_ASSOC) {
 		if (bss_conf->assoc) {
 			u32 rates;
 			int ieoffset;
-- 
1.7.10.4

