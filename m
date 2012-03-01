Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47194 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab2CAXkQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 18:40:16 -0500
Received: by mail-pz0-f46.google.com with SMTP id r28so1303002daj.19
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2012 15:40:16 -0800 (PST)
MIME-Version: 1.0
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>, devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCHv2 3/3] mac80211_hwsim: Implement ieee80211_ops:tx_last_beacon
Date: Thu,  1 Mar 2012 15:40:07 -0800
Message-Id: <1330645207-13964-3-git-send-email-javier@cozybit.com> (sfid-20120302_004026_804728_AC300718)
In-Reply-To: <1330645207-13964-1-git-send-email-javier@cozybit.com>
References: <1330645207-13964-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Without this you won't see probe responses in an IBSS/hwsim network,
which is convenient for testing.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 drivers/net/wireless/mac80211_hwsim.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index deed95f..e4b6ca6 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -47,6 +47,8 @@ static bool fake_hw_scan;
 module_param(fake_hw_scan, bool, 0444);
 MODULE_PARM_DESC(fake_hw_scan, "Install fake (no-op) hw-scan handler");
 
+static struct ieee80211_hw *txed_last_beacon;
+
 /**
  * enum hwsim_regtest - the type of regulatory tests we offer
  *
@@ -821,6 +823,7 @@ static void mac80211_hwsim_beacon_tx(void *arg, u8 *mac,
 	hdr = (struct ieee80211_hdr_3addr *) skb->data;
 	tsfpos = (__le64 *) (hdr + 1);
 	put_unaligned(__mac80211_hwsim_get_tsf(data), tsfpos);
+	txed_last_beacon = hw;
 
 	mac80211_hwsim_monitor_rx(hw, skb);
 
@@ -1220,6 +1223,11 @@ static void mac80211_hwsim_sw_scan_complete(struct ieee80211_hw *hw)
 	mutex_unlock(&hwsim->mutex);
 }
 
+static int mac80211_hwsim_tx_last_beacon(struct ieee80211_hw *hw)
+{
+	return (hw == txed_last_beacon);
+}
+
 static struct ieee80211_ops mac80211_hwsim_ops =
 {
 	.tx = mac80211_hwsim_tx,
@@ -1244,6 +1252,7 @@ static struct ieee80211_ops mac80211_hwsim_ops =
 	.flush = mac80211_hwsim_flush,
 	.get_tsf = mac80211_hwsim_get_tsf,
 	.set_tsf = mac80211_hwsim_set_tsf,
+	.tx_last_beacon = mac80211_hwsim_tx_last_beacon,
 };
 
 
-- 
1.7.6

