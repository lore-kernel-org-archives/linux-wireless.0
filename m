Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ed1-f65.google.com ([209.85.208.65]:36627 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730967AbeIVTfq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Sep 2018 15:35:46 -0400
Received: by mail-ed1-f65.google.com with SMTP id f4-v6so12869811edq.3
        for <linux-wireless@vger.kernel.org>; Sat, 22 Sep 2018 06:42:07 -0700 (PDT)
From: Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, Kalle Valo <kvalo@codeaurora.org>,
        Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com>
Subject: [PATCH v2] brcmsmac: AP mode: update beacon when TIM changes
Date: Sat, 22 Sep 2018 16:41:24 +0300
Message-Id: <20180922134124.12997-1-alimjalnasrawy@gmail.com> (sfid-20180922_154210_983469_CCC6CEC4)
In-Reply-To: <20180911172618.13049-1-alimjalnasrawy@gmail.com>
References: <20180911172618.13049-1-alimjalnasrawy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Beacons+TIM are created/updated for beaconing only when BSS_CHANGED_BEACON.
This is not compliant with power-saving stations. Fix it by updating
beacon templates on mac80211 set_tim callback.

Signed-off-by: Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com>
---
 .../broadcom/brcm80211/brcmsmac/mac80211_if.c | 21 +++++++++++++++++++
 .../broadcom/brcm80211/brcmsmac/main.h        |  1 +
 2 files changed, 22 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
index ddfdfe1..85e7b77 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
@@ -502,6 +502,7 @@ brcms_ops_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	}
 
 	spin_lock_bh(&wl->lock);
+	wl->wlc->vif = vif;
 	wl->mute_tx = false;
 	brcms_c_mute(wl->wlc, false);
 	if (vif->type == NL80211_IFTYPE_STATION)
@@ -937,6 +938,25 @@ static void brcms_ops_set_tsf(struct ieee80211_hw *hw,
 	spin_unlock_bh(&wl->lock);
 }
 
+static int brcms_ops_beacon_set_tim(struct ieee80211_hw *hw,
+				 struct ieee80211_sta *sta, bool set)
+{
+	struct brcms_info *wl = hw->priv;
+	struct sk_buff *beacon;
+	u16 tim_offset = 0;
+	
+	beacon = ieee80211_beacon_get_tim(hw, wl->wlc->vif,
+					  &tim_offset, NULL);
+	if (beacon){
+		spin_lock_bh(&wl->lock);
+		brcms_c_set_new_beacon(wl->wlc, beacon, tim_offset,
+				       wl->wlc->vif->bss_conf.dtim_period);
+		spin_unlock_bh(&wl->lock);
+	}
+	
+	return 0;
+}
+
 static const struct ieee80211_ops brcms_ops = {
 	.tx = brcms_ops_tx,
 	.start = brcms_ops_start,
@@ -955,6 +975,7 @@ static const struct ieee80211_ops brcms_ops = {
 	.flush = brcms_ops_flush,
 	.get_tsf = brcms_ops_get_tsf,
 	.set_tsf = brcms_ops_set_tsf,
+	.set_tim = brcms_ops_beacon_set_tim,
 };
 
 void brcms_dpc(unsigned long data)
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.h b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.h
index c4d135c..6ece25c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.h
@@ -568,6 +568,7 @@ struct brcms_c_info {
 	u16 beacon_tim_offset;
 	u16 beacon_dtim_period;
 	struct sk_buff *probe_resp;
+	struct ieee80211_vif *vif;
 };
 
 /* antsel module specific state */
-- 
2.18.0
