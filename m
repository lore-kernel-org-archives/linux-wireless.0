Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-ca-2.exch022.serverdata.net ([64.78.56.54]:32531 "EHLO
	HUB022-ca-2.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751299Ab3DOGdM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Apr 2013 02:33:12 -0400
Message-ID: <516B9F21.2080304@posedge.com> (sfid-20130415_083316_990916_B5105B8B)
Date: Mon, 15 Apr 2013 12:03:05 +0530
From: Vivekananda Holla <vivekanandah@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: [Patch] mac80211: add rts-cts for dynamic SMPS stations
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Checking whether dynamic SMPS is enabled at the receiver station for
which packet is intended to be transmitted. Enable RTS
protection for multi-stream rates for such packets.

Signed-off-by: Vivekananda Holla <vivekanandah@posedge.com>
---
 net/mac80211/tx.c |   20 +++++++++++++++++++-
 1 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index aad0bf5..38c2ec6 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -621,6 +621,7 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
     int i;
     u32 len;
     bool inval = false, rts = false, short_preamble = false;
+    bool dyn_smps = false;
     struct ieee80211_tx_rate_control txrc;
     bool assoc = false;
 
@@ -738,6 +739,13 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
         info->control.rts_cts_rate_idx = baserate;
     }
 
+    /* check if dynamic SMPS is on at receiving station */
+    if (tx->sta) {
+        if (tx->sta->sta.smps_mode == WLAN_HT_CAP_SM_PS_DYNAMIC) {
+            dyn_smps = true;
+        }
+    }
+
     for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
         /*
          * make sure there's no valid rate following
@@ -766,7 +774,17 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
         if (rts)
             info->control.rates[i].flags |=
                 IEEE80211_TX_RC_USE_RTS_CTS;
-
+        /*
+         * set up RTS protection for multi-stream rates if dynamic
+         * SMPS is enabled for the receiving station
+         */
+        if (dyn_smps) {
+            if ((info->control.rates[i].idx > 7) &&
+                (info->control.rates[i].idx != 32))
+                info->control.rates[i].flags |=
+                    IEEE80211_TX_RC_USE_RTS_CTS;        
+        }
+        
         /* RC is busted */
         if (WARN_ON_ONCE(info->control.rates[i].idx >=
                  sband->n_bitrates)) {
