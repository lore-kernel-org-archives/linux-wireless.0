Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:36937 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab0AESQf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2010 13:16:35 -0500
Received: from saunalahti-vams (vs3-10.mail.saunalahti.fi [62.142.5.94])
	by emh07-2.mail.saunalahti.fi (Postfix) with SMTP id E103B18D32C
	for <linux-wireless@vger.kernel.org>; Tue,  5 Jan 2010 20:16:33 +0200 (EET)
Received: from [127.0.1.1] (a91-155-131-184.elisa-laajakaista.fi [91.155.131.184])
	by emh03.mail.saunalahti.fi (Postfix) with ESMTP id D85A6158A67
	for <linux-wireless@vger.kernel.org>; Tue,  5 Jan 2010 20:16:32 +0200 (EET)
Subject: [PATCH v2 3/9] wl1251: get PS Poll and Nullfunc templates from
	mac80211
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 05 Jan 2010 20:16:32 +0200
Message-ID: <20100105181632.27418.47775.stgit@tikku>
In-Reply-To: <20100105181522.27418.97100.stgit@tikku>
References: <20100105181522.27418.97100.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

Now that mac80211 creates templates for PS Poll and Nullfunc frames, use
them instead of creating our own.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1251_main.c |   58 ++++++++---------------------
 1 files changed, 16 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index 4e373f3..6cce864 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -563,45 +563,6 @@ static void wl1251_op_remove_interface(struct ieee80211_hw *hw,
 	mutex_unlock(&wl->mutex);
 }
 
-static int wl1251_build_null_data(struct wl1251 *wl)
-{
-	struct wl12xx_null_data_template template;
-
-	if (!is_zero_ether_addr(wl->bssid)) {
-		memcpy(template.header.da, wl->bssid, ETH_ALEN);
-		memcpy(template.header.bssid, wl->bssid, ETH_ALEN);
-	} else {
-		memset(template.header.da, 0xff, ETH_ALEN);
-		memset(template.header.bssid, 0xff, ETH_ALEN);
-	}
-
-	memcpy(template.header.sa, wl->mac_addr, ETH_ALEN);
-	template.header.frame_ctl = cpu_to_le16(IEEE80211_FTYPE_DATA |
-						IEEE80211_STYPE_NULLFUNC |
-						IEEE80211_FCTL_TODS);
-
-	return wl1251_cmd_template_set(wl, CMD_NULL_DATA, &template,
-				       sizeof(template));
-
-}
-
-static int wl1251_build_ps_poll(struct wl1251 *wl, u16 aid)
-{
-	struct wl12xx_ps_poll_template template;
-
-	memcpy(template.bssid, wl->bssid, ETH_ALEN);
-	memcpy(template.ta, wl->mac_addr, ETH_ALEN);
-
-	/* aid in PS-Poll has its two MSBs each set to 1 */
-	template.aid = cpu_to_le16(1 << 15 | 1 << 14 | aid);
-
-	template.fc = cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_PSPOLL);
-
-	return wl1251_cmd_template_set(wl, CMD_PS_POLL, &template,
-				       sizeof(template));
-
-}
-
 static int wl1251_op_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct wl1251 *wl = hw->priv;
@@ -1101,7 +1062,7 @@ static void wl1251_op_bss_info_changed(struct ieee80211_hw *hw,
 {
 	enum wl1251_cmd_ps_mode mode;
 	struct wl1251 *wl = hw->priv;
-	struct sk_buff *beacon;
+	struct sk_buff *beacon, *skb;
 	int ret;
 
 	wl1251_debug(DEBUG_MAC80211, "mac80211 bss info changed");
@@ -1115,7 +1076,13 @@ static void wl1251_op_bss_info_changed(struct ieee80211_hw *hw,
 	if (changed & BSS_CHANGED_BSSID) {
 		memcpy(wl->bssid, bss_conf->bssid, ETH_ALEN);
 
-		ret = wl1251_build_null_data(wl);
+		skb = ieee80211_nullfunc_get(wl->hw, wl->vif);
+		if (!skb)
+			goto out_sleep;
+
+		ret = wl1251_cmd_template_set(wl, CMD_NULL_DATA,
+					      skb->data, skb->len);
+		dev_kfree_skb(skb);
 		if (ret < 0)
 			goto out;
 
@@ -1136,7 +1103,14 @@ static void wl1251_op_bss_info_changed(struct ieee80211_hw *hw,
 							  wl->dtim_period);
 			wl->aid = bss_conf->aid;
 
-			ret = wl1251_build_ps_poll(wl, wl->aid);
+			skb = ieee80211_pspoll_get(wl->hw, wl->vif);
+			if (!skb)
+				goto out_sleep;
+
+			ret = wl1251_cmd_template_set(wl, CMD_PS_POLL,
+						      skb->data,
+						      skb->len);
+			dev_kfree_skb(skb);
 			if (ret < 0)
 				goto out_sleep;
 

