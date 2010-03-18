Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:62411 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab0CRK1O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 06:27:14 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kalle.valo@nokia.com>,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 09/21] wl1271: get pspoll and nullfunc templates from mac80211
Date: Thu, 18 Mar 2010 12:26:34 +0200
Message-Id: <1268908006-16992-10-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1268908006-16992-1-git-send-email-luciano.coelho@nokia.com>
References: <1268908006-16992-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

mac80211 now can create pspoll and nullfunc templates, better to use those.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_cmd.c |   44 +++++++++++++----------------
 1 files changed, 20 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index d59b383..3a615fa 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -776,41 +776,37 @@ static int wl1271_build_extended_rates(u8 *rates, u8 band)
 
 int wl1271_cmd_build_null_data(struct wl1271 *wl)
 {
-	struct wl12xx_null_data_template template;
+	struct sk_buff *skb;
+	int ret = 0;
 
-	if (!is_zero_ether_addr(wl->bssid)) {
-		memcpy(template.header.da, wl->bssid, ETH_ALEN);
-		memcpy(template.header.bssid, wl->bssid, ETH_ALEN);
-	} else {
-		memset(template.header.da, 0xff, ETH_ALEN);
-		memset(template.header.bssid, 0xff, ETH_ALEN);
-	}
+	skb = ieee80211_nullfunc_get(wl->hw, wl->vif);
+	if (!skb)
+		goto out;
 
-	memcpy(template.header.sa, wl->mac_addr, ETH_ALEN);
-	template.header.frame_ctl = cpu_to_le16(IEEE80211_FTYPE_DATA |
-						IEEE80211_STYPE_NULLFUNC |
-						IEEE80211_FCTL_TODS);
+	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_NULL_DATA, skb->data,
+				      skb->len);
 
-	return wl1271_cmd_template_set(wl, CMD_TEMPL_NULL_DATA, &template,
-				       sizeof(template));
+out:
+	dev_kfree_skb(skb);
+	return ret;
 
 }
 
 int wl1271_cmd_build_ps_poll(struct wl1271 *wl, u16 aid)
 {
-	struct wl12xx_ps_poll_template template;
-
-	memcpy(template.bssid, wl->bssid, ETH_ALEN);
-	memcpy(template.ta, wl->mac_addr, ETH_ALEN);
-
-	/* aid in PS-Poll has its two MSBs each set to 1 */
-	template.aid = cpu_to_le16(1 << 15 | 1 << 14 | aid);
+	struct sk_buff *skb;
+	int ret = 0;
 
-	template.fc = cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_PSPOLL);
+	skb = ieee80211_pspoll_get(wl->hw, wl->vif);
+	if (!skb)
+		goto out;
 
-	return wl1271_cmd_template_set(wl, CMD_TEMPL_PS_POLL, &template,
-				       sizeof(template));
+	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_PS_POLL, skb->data,
+				      skb->len);
 
+out:
+	dev_kfree_skb(skb);
+	return ret;
 }
 
 int wl1271_cmd_build_probe_req(struct wl1271 *wl, u8 *ssid, size_t ssid_len,
-- 
1.6.3.3

