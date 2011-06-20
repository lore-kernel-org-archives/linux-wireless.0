Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37953 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab1FTBq4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jun 2011 21:46:56 -0400
Received: by pzk9 with SMTP id 9so3105289pzk.19
        for <linux-wireless@vger.kernel.org>; Sun, 19 Jun 2011 18:46:56 -0700 (PDT)
Message-ID: <4DFEA61A.8060805@ring3k.org> (sfid-20110620_034700_580656_3ACADA53)
Date: Mon, 20 Jun 2011 10:44:58 +0900
From: Mike McCormack <mikem@ring3k.org>
MIME-Version: 1.0
To: linville@tuxdriver.com
CC: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn,
	linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] rtlwifi: Fix typo in variable name
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

offchan_deley should be offchan_delay

Signed-off-by: Mike McCormack <mikem@ring3k.org>
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/core.c |    4 ++--
 drivers/net/wireless/rtlwifi/pci.c  |    3 +--
 drivers/net/wireless/rtlwifi/wifi.h |    2 +-
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/core.c b/drivers/net/wireless/rtlwifi/core.c
index 605514b..3313ce6 100644
--- a/drivers/net/wireless/rtlwifi/core.c
+++ b/drivers/net/wireless/rtlwifi/core.c
@@ -335,8 +335,8 @@ static int rtl_op_config(struct ieee80211_hw *hw, u32 changed)
 		 * before going offchannel, or dis-association or delete BA will
 		 * happen by AP
 		 */
-		if (rtlpriv->mac80211.offchan_deley) {
-			rtlpriv->mac80211.offchan_deley = false;
+		if (rtlpriv->mac80211.offchan_delay) {
+			rtlpriv->mac80211.offchan_delay = false;
 			mdelay(50);
 		}
 		rtlphy->current_channel = wide_chan;
diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index cb4e5e8..e6d0263 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -581,7 +581,7 @@ static void _rtl_pci_tx_isr(struct ieee80211_hw *hw, int prio)
 		fc = rtl_get_fc(skb);
 		if (ieee80211_is_nullfunc(fc)) {
 			if (ieee80211_has_pm(fc)) {
-				rtlpriv->mac80211.offchan_deley = true;
+				rtlpriv->mac80211.offchan_delay = true;
 				rtlpriv->psc.state_inap = 1;
 			} else {
 				rtlpriv->psc.state_inap = 0;
@@ -788,7 +788,6 @@ static irqreturn_t _rtl_pci_interrupt(int irq, void *dev_id)
 {
 	struct ieee80211_hw *hw = dev_id;
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	unsigned long flags;
 	u32 inta = 0;
diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
index fcf2c9f..c54cda5 100644
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -938,7 +938,7 @@ struct rtl_mac {
 	int n_channels;
 	int n_bitrates;
 
-	bool offchan_deley;
+	bool offchan_delay;
 
 	/*filters */
 	u32 rx_conf;
-- 
1.7.4.1


