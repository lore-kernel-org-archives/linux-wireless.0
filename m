Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D0C3A1B4
	for <linux-wireless@vger.kernel.org>; Mon, 18 Dec 2023 14:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="IKARBYYY";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="QsyvZC+I"
From: Martin Kaistra <martin.kaistra@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1702910229;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C4bcRKTY9GAPu5NO1zkb4kunZ+++ym2dwCU56rp2fjU=;
	b=IKARBYYYs4qyLUv3dxMghYqsrP3hkbOzhwhN4JNzRa4WeTg0/PPfAXv+SEcYUzjmoFUS9E
	2r+jZtHXCAjGrm7sK/GkUT4eOAQdCQKXv59m/xR+VktSisKCDVvSyye72hYY+z4s2WlrqN
	+sz1pSvHDXcrJXDAxo+EjkrSi8ERECJfvYe3gEens3Px1DOr0BzRMpozPsubTfO2jO630l
	5j1ReSSGUqqKgck71GPNwHXiVNOWWoBTOaVfJyuVwLbpSnRXApLv5jNVzx0XyVkWSEBWqc
	N+MhzC3BDUQ11h9ZUBuIISniwfyCPhgVi17PQh8APWGLtx4cnxrwoApnSxCpkA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1702910229;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C4bcRKTY9GAPu5NO1zkb4kunZ+++ym2dwCU56rp2fjU=;
	b=QsyvZC+IoklSSw8+cJAgc88qyyr7l9bGMRgD8tuDTXSt1qTDtooddcEErTpOICdwfXw/8X
	Ji1Day44dw8cG7Dg==
To: linux-wireless@vger.kernel.org
Cc: Jes Sorensen <Jes.Sorensen@gmail.com>,
	Kalle Valo <kvalo@kernel.org>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 14/20] wifi: rtl8xxxu: support multiple interfaces in bss_info_changed()
Date: Mon, 18 Dec 2023 15:36:39 +0100
Message-Id: <20231218143645.433356-15-martin.kaistra@linutronix.de>
In-Reply-To: <20231218143645.433356-1-martin.kaistra@linutronix.de>
References: <20231218143645.433356-1-martin.kaistra@linutronix.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Call set_linktype now with correct port_num. Only react to beacon
changes if port_num == 0, as we only support AP mode on this port.

Signed-off-by: Martin Kaistra <martin.kaistra@linutronix.de>
---
 .../wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 26 +++++++++++--------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 59dd50844f1ae..f929b01615d00 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -4981,6 +4981,7 @@ static void
 rtl8xxxu_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			  struct ieee80211_bss_conf *bss_conf, u64 changed)
 {
+	struct rtl8xxxu_vif *rtlvif = (struct rtl8xxxu_vif *)vif->drv_priv;
 	struct rtl8xxxu_priv *priv = hw->priv;
 	struct device *dev = &priv->udev->dev;
 	struct ieee80211_sta *sta;
@@ -4993,7 +4994,7 @@ rtl8xxxu_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	if (changed & BSS_CHANGED_ASSOC) {
 		dev_dbg(dev, "Changed ASSOC: %i!\n", vif->cfg.assoc);
 
-		rtl8xxxu_set_linktype(priv, vif->type, 0);
+		rtl8xxxu_set_linktype(priv, vif->type, rtlvif->port_num);
 
 		if (vif->cfg.assoc) {
 			u32 ramask;
@@ -5040,7 +5041,8 @@ rtl8xxxu_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 			rtl8xxxu_write8(priv, REG_BCN_MAX_ERR, 0xff);
 
-			rtl8xxxu_stop_tx_beacon(priv);
+			if (rtlvif->port_num == 0)
+				rtl8xxxu_stop_tx_beacon(priv);
 
 			/* joinbss sequence */
 			rtl8xxxu_write16(priv, REG_BCN_PSR_RPT,
@@ -5082,7 +5084,7 @@ rtl8xxxu_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 	if (changed & BSS_CHANGED_BSSID) {
 		dev_dbg(dev, "Changed BSSID!\n");
-		rtl8xxxu_set_bssid(priv, bss_conf->bssid, 0);
+		rtl8xxxu_set_bssid(priv, bss_conf->bssid, rtlvif->port_num);
 	}
 
 	if (changed & BSS_CHANGED_BASIC_RATES) {
@@ -5090,16 +5092,18 @@ rtl8xxxu_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		rtl8xxxu_set_basic_rates(priv, bss_conf->basic_rates);
 	}
 
-	if (changed & BSS_CHANGED_BEACON_ENABLED) {
-		if (bss_conf->enable_beacon)
-			rtl8xxxu_start_tx_beacon(priv);
-		else
-			rtl8xxxu_stop_tx_beacon(priv);
+	/* beacon only supported for port_num = 0 */
+	if (rtlvif->port_num == 0) {
+		if (changed & BSS_CHANGED_BEACON_ENABLED) {
+			if (bss_conf->enable_beacon)
+				rtl8xxxu_start_tx_beacon(priv);
+			else
+				rtl8xxxu_stop_tx_beacon(priv);
+		}
+		if (changed & BSS_CHANGED_BEACON)
+			schedule_work(&priv->update_beacon_work);
 	}
 
-	if (changed & BSS_CHANGED_BEACON)
-		schedule_work(&priv->update_beacon_work);
-
 error:
 	return;
 }
-- 
2.39.2

