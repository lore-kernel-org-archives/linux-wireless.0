Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52314 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073AbZLANYX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 08:24:23 -0500
Subject: [PATCH] mac80211_hwsim: implement ampdu action
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Dec 2009 14:24:24 +0100
Message-ID: <1259673864.32171.77.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Not that we actually ever aggregate anything, but
it could potentially be useful anyhow to simulate
aggregation sessions.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
This must go in front of "mac80211: introduce flush operation"
for that one to apply cleanly. Sorry.

 drivers/net/wireless/mac80211_hwsim.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

--- wireless-testing.orig/drivers/net/wireless/mac80211_hwsim.c	2009-12-01 10:51:01.000000000 +0100
+++ wireless-testing/drivers/net/wireless/mac80211_hwsim.c	2009-12-01 12:39:51.000000000 +0100
@@ -828,6 +828,31 @@ static int mac80211_hwsim_testmode_cmd(s
 }
 #endif
 
+static int mac80211_hwsim_ampdu_action(struct ieee80211_hw *hw,
+				       struct ieee80211_vif *vif,
+				       enum ieee80211_ampdu_mlme_action action,
+				       struct ieee80211_sta *sta, u16 tid, u16 *ssn)
+{
+	switch (action) {
+	case IEEE80211_AMPDU_TX_START:
+		ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
+		break;
+	case IEEE80211_AMPDU_TX_STOP:
+		ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
+		break;
+	case IEEE80211_AMPDU_TX_OPERATIONAL:
+		break;
+	case IEEE80211_AMPDU_RX_START:
+	case IEEE80211_AMPDU_RX_STOP:
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+
 static const struct ieee80211_ops mac80211_hwsim_ops =
 {
 	.tx = mac80211_hwsim_tx,
@@ -842,6 +867,7 @@ static const struct ieee80211_ops mac802
 	.set_tim = mac80211_hwsim_set_tim,
 	.conf_tx = mac80211_hwsim_conf_tx,
 	CFG80211_TESTMODE_CMD(mac80211_hwsim_testmode_cmd)
+	.ampdu_action = mac80211_hwsim_ampdu_action,
 };
 
 


