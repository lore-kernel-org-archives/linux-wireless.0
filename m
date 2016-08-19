Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46258 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755445AbcHSVrY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Aug 2016 17:47:24 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
        Hans de Goede <hdegoede@redhat.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 20/20] net: wireless: rtl8xxxu: Make rtl8xxxu_ampdu_action less chatty
Date: Fri, 19 Aug 2016 17:46:42 -0400
Message-Id: <1471643202-26250-21-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160819_234746_861808_5FE7C0A5)
In-Reply-To: <1471643202-26250-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1471643202-26250-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hans de Goede <hdegoede@redhat.com>

On my home network rtl8xxxu is spamming the log with
IEEE80211_AMPDU_RX_START / IEEE80211_AMPDU_RX_STOP every few seconds
turn these messages into debug messages.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 508d46f..c362083 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -5696,7 +5696,7 @@ rtl8xxxu_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 	switch (action) {
 	case IEEE80211_AMPDU_TX_START:
-		dev_info(dev, "%s: IEEE80211_AMPDU_TX_START\n", __func__);
+		dev_dbg(dev, "%s: IEEE80211_AMPDU_TX_START\n", __func__);
 		ampdu_factor = sta->ht_cap.ampdu_factor;
 		ampdu_density = sta->ht_cap.ampdu_density;
 		rtl8xxxu_set_ampdu_factor(priv, ampdu_factor);
@@ -5706,21 +5706,21 @@ rtl8xxxu_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			ampdu_factor, ampdu_density);
 		break;
 	case IEEE80211_AMPDU_TX_STOP_FLUSH:
-		dev_info(dev, "%s: IEEE80211_AMPDU_TX_STOP_FLUSH\n", __func__);
+		dev_dbg(dev, "%s: IEEE80211_AMPDU_TX_STOP_FLUSH\n", __func__);
 		rtl8xxxu_set_ampdu_factor(priv, 0);
 		rtl8xxxu_set_ampdu_min_space(priv, 0);
 		break;
 	case IEEE80211_AMPDU_TX_STOP_FLUSH_CONT:
-		dev_info(dev, "%s: IEEE80211_AMPDU_TX_STOP_FLUSH_CONT\n",
+		dev_dbg(dev, "%s: IEEE80211_AMPDU_TX_STOP_FLUSH_CONT\n",
 			 __func__);
 		rtl8xxxu_set_ampdu_factor(priv, 0);
 		rtl8xxxu_set_ampdu_min_space(priv, 0);
 		break;
 	case IEEE80211_AMPDU_RX_START:
-		dev_info(dev, "%s: IEEE80211_AMPDU_RX_START\n", __func__);
+		dev_dbg(dev, "%s: IEEE80211_AMPDU_RX_START\n", __func__);
 		break;
 	case IEEE80211_AMPDU_RX_STOP:
-		dev_info(dev, "%s: IEEE80211_AMPDU_RX_STOP\n", __func__);
+		dev_dbg(dev, "%s: IEEE80211_AMPDU_RX_STOP\n", __func__);
 		break;
 	default:
 		break;
-- 
2.7.4
