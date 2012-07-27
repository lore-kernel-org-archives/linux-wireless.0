Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:55709 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab2G0XP2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 19:15:28 -0400
Received: by wibhm11 with SMTP id hm11so99615wib.1
        for <linux-wireless@vger.kernel.org>; Fri, 27 Jul 2012 16:15:27 -0700 (PDT)
Message-Id: <fbc79a8777dfbbda1aa2bc388a7c7062dcf2b36a.1343430404.git.chunkeey@googlemail.com> (sfid-20120728_011532_840562_D5DAA3DB)
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sat, 28 Jul 2012 00:23:14 +0200
Subject: [PATCH 1/2] carl9170: support per multi-retry-stage tpc
To: linux-wireless@vger.kernel.org
Cc: thomas@net.t-labs.tu-berlin.de, linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch add support for the upcoming
transmit power controller algorithm.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
Thomas,

since you are going to touch the code anyway (due to
the ack_signal offset). I thought it might be a good
idea to make patches for carl9170 and p54 myself, so
we can have some support for hw with per mrr tpc and
global ack (carl9170) and per data tpc (p54) from the
get-go.

Regards,
	Chr.

(Of course, I think you might do a few iterations, but
that's fine.)
---
 drivers/net/wireless/ath/carl9170/mac.c  |   10 +++++-----
 drivers/net/wireless/ath/carl9170/main.c |    5 ++++-
 drivers/net/wireless/ath/carl9170/tx.c   |    4 ++--
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/mac.c b/drivers/net/wireless/ath/carl9170/mac.c
index 53415bf..949861b 100644
--- a/drivers/net/wireless/ath/carl9170/mac.c
+++ b/drivers/net/wireless/ath/carl9170/mac.c
@@ -488,7 +488,7 @@ int carl9170_disable_key(struct ar9170 *ar, const u8 id)
 
 int carl9170_set_mac_tpc(struct ar9170 *ar, struct ieee80211_channel *channel)
 {
-	unsigned int power, chains;
+	unsigned int power, chains, ack_power;
 
 	if (ar->eeprom.tx_mask != 1)
 		chains = AR9170_TX_PHY_TXCHAIN_2;
@@ -506,17 +506,17 @@ int carl9170_set_mac_tpc(struct ar9170 *ar, struct ieee80211_channel *channel)
 		BUG_ON(1);
 	}
 
+	ack_power = min_t(unsigned int, power, ar->hw->conf.ack_power * 2);
 	power = min_t(unsigned int, power, ar->hw->conf.power_level * 2);
-
 	carl9170_regwrite_begin(ar);
 	carl9170_regwrite(AR9170_MAC_REG_ACK_TPC,
-			  0x3c1e | power << 20 | chains << 26);
+			  0x3c1e | ack_power << 20 | chains << 26);
 	carl9170_regwrite(AR9170_MAC_REG_RTS_CTS_TPC,
 			  power << 5 | chains << 11 |
 			  power << 21 | chains << 27);
 	carl9170_regwrite(AR9170_MAC_REG_CFEND_QOSNULL_TPC,
-			  power << 5 | chains << 11 |
-			  power << 21 | chains << 27);
+			  ack_power << 5 | chains << 11 |
+			  ack_power << 21 | chains << 27);
 	carl9170_regwrite_finish();
 	return carl9170_regwrite_result();
 }
diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index 858e58d..801fbb2 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -886,7 +886,8 @@ static int carl9170_op_config(struct ieee80211_hw *hw, u32 changed)
 			goto out;
 	}
 
-	if (changed & IEEE80211_CONF_CHANGE_POWER) {
+	if (changed & (IEEE80211_CONF_CHANGE_POWER |
+	    IEEE80211_CONF_CHANGE_ACK_POWER)) {
 		err = carl9170_set_mac_tpc(ar, ar->hw->conf.channel);
 		if (err)
 			goto out;
@@ -1782,6 +1783,8 @@ void *carl9170_alloc(size_t priv_size)
 		     IEEE80211_HW_SUPPORTS_PS |
 		     IEEE80211_HW_PS_NULLFUNC_STACK |
 		     IEEE80211_HW_NEED_DTIM_PERIOD |
+		     IEEE80211_HW_SUPPORTS_TPC_DATA_MRR |
+		     IEEE80211_HW_SUPPORTS_TPC_ACK_GLOBAL |
 		     IEEE80211_HW_SIGNAL_DBM;
 
 	if (!modparam_noht) {
diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
index 84377cf..c68cffb 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -277,7 +277,7 @@ static void carl9170_tx_release(struct kref *ref)
 		return;
 
 	BUILD_BUG_ON(
-	    offsetof(struct ieee80211_tx_info, status.ack_signal) != 20);
+	    offsetof(struct ieee80211_tx_info, status.ack_signal) != 24);
 
 	memset(&txinfo->status.ack_signal, 0,
 	       sizeof(struct ieee80211_tx_info) -
@@ -761,7 +761,7 @@ static void carl9170_tx_rate_tpc_chains(struct ar9170 *ar,
 			*chains = AR9170_TX_PHY_TXCHAIN_2;
 	}
 
-	*tpc = min_t(unsigned int, *tpc, ar->hw->conf.power_level * 2);
+	*tpc = min_t(unsigned int, *tpc, txrate->tpc * 2);
 }
 
 static __le32 carl9170_tx_physet(struct ar9170 *ar,
-- 
1.7.10.4

