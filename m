Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:25763 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027AbYHBXt2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 19:49:28 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 02 Aug 2008 16:49:28 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<jouni.malinen@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	Jack Howarth <howarth@bromo.msbb.uc.edu>
Subject: [PATCH 10/12] ath9k: Port to new skb->cb mac80211 changes
Date: Sat, 2 Aug 2008 16:49:02 -0700
Message-ID: <1217720944-23234-11-git-send-email-lrodriguez@atheros.com> (sfid-20080803_014935_952867_5991A579)
In-Reply-To: <1217720944-23234-10-git-send-email-lrodriguez@atheros.com>
References: <1217720944-23234-1-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-2-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-3-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-4-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-5-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-6-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-7-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-8-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-9-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-10-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change settings as per skb->cb fix patch which removed
IEEE80211_TX_CTL_DO_NOT_ENCRYPT and IEEE80211_TX_CTL_EAPOL_FRAME.

Signed-off-by: Jack Howarth <howarth@bromo.msbb.uc.edu>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/xmit.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index c136517..c6992f3 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -248,7 +248,8 @@ static void fill_min_rates(struct sk_buff *skb, struct ath_tx_control *txctl)
 		txctl->min_rate = tx_info_priv->min_rate;
 	} else if (ieee80211_is_data(fc)) {
 		if (ieee80211_is_nullfunc(fc) ||
-		    (tx_info->flags & IEEE80211_TX_CTL_EAPOL_FRAME)) {
+			/* Port Access Entity (IEEE 802.1X) */
+			(skb->protocol == cpu_to_be16(0x888E))) {
 			txctl->use_minrate = 1;
 			txctl->min_rate = tx_info_priv->min_rate;
 		}
@@ -310,7 +311,7 @@ static int ath_tx_prepare(struct ath_softc *sc,
 	txctl->keytype = ATH9K_KEY_TYPE_CLEAR;
 	txctl->keyix = ATH9K_TXKEYIX_INVALID;
 
-	if (!(tx_info->flags & IEEE80211_TX_CTL_DO_NOT_ENCRYPT)) {
+	if (tx_info->control.hw_key) {
 		txctl->keyix = tx_info->control.hw_key->hw_key_idx;
 		txctl->frmlen += tx_info->control.icv_len;
 
-- 
1.5.6.rc2.15.g457bb.dirty

