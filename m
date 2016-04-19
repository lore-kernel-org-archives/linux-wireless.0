Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:33764 "EHLO
	mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbcDSFBZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2016 01:01:25 -0400
Received: by mail-pf0-f175.google.com with SMTP id 184so2751022pff.0
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2016 22:01:24 -0700 (PDT)
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Eugene Krasnikov <k.eugene.e@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: Pontus Fuchs <pontus.fuchs@gmail.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 13/18] wcn36xx: Track association state
Date: Mon, 18 Apr 2016 22:00:51 -0700
Message-Id: <1461042056-10607-14-git-send-email-bjorn.andersson@linaro.org> (sfid-20160419_070150_376715_BC2F7F14)
In-Reply-To: <1461042056-10607-1-git-send-email-bjorn.andersson@linaro.org>
References: <1461042056-10607-1-git-send-email-bjorn.andersson@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pontus Fuchs <pontus.fuchs@gmail.com>

Knowing the association state is needed for mc filtering.

Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---
 drivers/net/wireless/ath/wcn36xx/main.c    | 2 ++
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index f9c77de94583..253cece1b660 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -655,6 +655,7 @@ static void wcn36xx_bss_info_changed(struct ieee80211_hw *hw,
 				     vif->addr,
 				     bss_conf->aid);
 
+			vif_priv->sta_assoc = true;
 			rcu_read_lock();
 			sta = ieee80211_find_sta(vif, bss_conf->bssid);
 			if (!sta) {
@@ -686,6 +687,7 @@ static void wcn36xx_bss_info_changed(struct ieee80211_hw *hw,
 				    bss_conf->bssid,
 				    vif->addr,
 				    bss_conf->aid);
+			vif_priv->sta_assoc = false;
 			wcn36xx_smd_set_link_st(wcn,
 						bss_conf->bssid,
 						vif->addr,
diff --git a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
index 54000db0af1a..7433d67a5929 100644
--- a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
+++ b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
@@ -128,6 +128,7 @@ struct wcn36xx_vif {
 	u8 dtim_period;
 	enum ani_ed_type encrypt_type;
 	bool is_joining;
+	bool sta_assoc;
 	struct wcn36xx_hal_mac_ssid ssid;
 
 	/* Power management */
-- 
2.5.0

