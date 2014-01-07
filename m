Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58909 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaAGML2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jan 2014 07:11:28 -0500
Date: Tue, 7 Jan 2014 13:11:27 +0100
From: Pavel Machek <pavel@ucw.cz>
To: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH v3 11/13] wl1251: enforce changed hw encryption support on
 monitor state change
Message-ID: <20140107121127.GK10836@amd.pavel.ucw.cz> (sfid-20140107_131132_109207_EB3FCBC6)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Gnedt <david.gnedt@davizone.at>

The firmware doesn't support per packet encryption selection, so disable hw
encryption support completely while a monitor interface is present to support
injection of packets (which shouldn't get encrypted by hw).
To enforce the changed hw encryption support force a disassociation on
non-monitor interfaces.
For disassociation a workaround using hw connection monitor is employed,
which temporary enables hw connection manager flag.

Signed-off-by: David Gnedt <david.gnedt@davizone.at>
Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>

---
 drivers/net/wireless/ti/wl1251/main.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/wireless/ti/wl1251/main.c b/drivers/net/wireless/ti/wl1251/main.c
index bb6e873..1ef264c 100644
--- a/drivers/net/wireless/ti/wl1251/main.c
+++ b/drivers/net/wireless/ti/wl1251/main.c
@@ -688,6 +688,16 @@ static int wl1251_op_config(struct ieee80211_hw *hw, u32 changed)
 		wl->power_level = conf->power_level;
 	}
 
+	/*
+	 * Tell stack that connection is lost because hw encryption isn't
+	 * supported in monitor mode.
+	 * This requires temporary enabling of the hw connection monitor flag
+	 */
+	if ((changed & IEEE80211_CONF_CHANGE_MONITOR) && wl->vif) {
+		wl->hw->flags |= IEEE80211_HW_CONNECTION_MONITOR;
+		ieee80211_connection_loss(wl->vif);
+	}
+
 out_sleep:
 	wl1251_ps_elp_sleep(wl);
 
@@ -1120,6 +1130,9 @@ static void wl1251_op_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	if (changed & BSS_CHANGED_ASSOC) {
+		/* Disable temporary enabled hw connection monitor flag */
+		wl->hw->flags &= ~IEEE80211_HW_CONNECTION_MONITOR;
+
 		if (bss_conf->assoc) {
 			wl->beacon_int = bss_conf->beacon_int;
 
