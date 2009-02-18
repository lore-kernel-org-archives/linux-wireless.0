Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:60489 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319AbZBREzL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Feb 2009 23:55:11 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 17 Feb 2009 20:55:11 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH] ath9k: Fix PTK/GTK handshake timeout
Date: Wed, 18 Feb 2009 10:22:02 +0530
Message-ID: <1234932722-10580-1-git-send-email-vasanth@atheros.com> (sfid-20090218_055515_819312_30B9A53D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some APs don't start BA negotiation with the client before it is done
with the key handshake in WPA/RSN. With those APs, key handshake times
out if EAPOL frames are sent after addba request. So defer the BA negotiation
until we are done with tx/rx of all EAPOL frames.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath9k/rc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index a4e8631..c85bbd0 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -1533,7 +1533,8 @@ static void ath_tx_status(void *priv, struct ieee80211_supported_band *sband,
 			 tx_info_priv->tx.ts_longretry);
 
 	/* Check if aggregation has to be enabled for this tid */
-	if (conf_is_ht(&sc->hw->conf)) {
+	if (conf_is_ht(&sc->hw->conf) &&
+	    !(skb->protocol == cpu_to_be16(ETH_P_PAE))) {
 		if (ieee80211_is_data_qos(fc)) {
 			u8 *qc, tid;
 			struct ath_node *an;
-- 
1.5.5.1

