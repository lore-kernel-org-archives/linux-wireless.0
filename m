Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:50735 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757731Ab2C1JWC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2012 05:22:02 -0400
Subject: [PATCH] mac80211_hwsim: Report rate info in tx status
From: Timo Lindhorst <tlnd@online.de>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Jouni Malinen" <j@w1.fi>
Date: Wed, 28 Mar 2012 11:17:52 +0200
MIME-Version: 1.0
Message-Id: <201203281117.53033.tlnd@online.de> (sfid-20120328_112206_645468_30ADE40E)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Assuming an ideal channel, always the first transmission is considered
successful if an ACK is received. If no ACK is received, the
rates/attempts are reported as set by the rate control.

Signed-off-by: Timo Lindhorst <tlnd@online.de>
---
 drivers/net/wireless/mac80211_hwsim.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c 
b/drivers/net/wireless/mac80211_hwsim.c
index b7ce6a6..64adb3c 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -698,6 +698,8 @@ static void mac80211_hwsim_tx(struct ieee80211_hw *hw, 
struct sk_buff *skb)
 	bool ack;
 	struct ieee80211_tx_info *txi;
 	u32 _pid;
+	u8 tx_count[IEEE80211_TX_MAX_RATES];
+	int i;
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *) skb->data;
 	struct mac80211_hwsim_data *data = hw->priv;
 
@@ -734,9 +736,22 @@ static void mac80211_hwsim_tx(struct ieee80211_hw *hw, 
struct sk_buff *skb)
 	if (txi->control.sta)
 		hwsim_check_sta_magic(txi->control.sta);
 
+	if (!ack)
+		for (i = 0; i < IEEE80211_TX_MAX_RATES; i++)
+			tx_count[i] = txi->control.rates[i].count;
+
 	ieee80211_tx_info_clear_status(txi);
 	if (!(txi->flags & IEEE80211_TX_CTL_NO_ACK) && ack)
 		txi->flags |= IEEE80211_TX_STAT_ACK;
+
+	if (ack) {
+		txi->status.rates[0].count = 1;
+		txi->status.rates[1].idx = -1;
+	} else {
+		for (i = 0; i < IEEE80211_TX_MAX_RATES; i++)
+			txi->control.rates[i].count = tx_count[i];
+	}
+
 	ieee80211_tx_status_irqsafe(hw, skb);
 }
 
-- 
1.7.9.1

