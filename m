Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ed1-f68.google.com ([209.85.208.68]:34869 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726943AbeIKW0u (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Sep 2018 18:26:50 -0400
Received: by mail-ed1-f68.google.com with SMTP id y20-v6so19898042edq.2
        for <linux-wireless@vger.kernel.org>; Tue, 11 Sep 2018 10:26:30 -0700 (PDT)
From: Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com>
Subject: [PATCH] brcmsmac: ap mode: update beacon when TIM changes
Date: Tue, 11 Sep 2018 20:26:18 +0300
Message-Id: <20180911172618.13049-1-alimjalnasrawy@gmail.com> (sfid-20180911_192710_836113_0112FF69)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Beacons+TIM are created/updated for fw beaconing only when BSS_CHANGED_BEACON.
This is not compliant with power-saving stations. 
Fix it by updating beacon templates on mac80211 set_tim callback.
Adresses the issue in:
https://marc.info/?i=20180911163534.21312d08%20()%20manjaro

Signed-off-by: Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com>
---
 .../broadcom/brcm80211/brcmsmac/mac80211_if.c | 23 +++++++++++++++++++
 .../broadcom/brcm80211/brcmsmac/main.h        |  2 ++
 2 files changed, 25 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
index ddfdfe1..ee92bb5 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
@@ -502,6 +502,7 @@ brcms_ops_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	}
 
 	spin_lock_bh(&wl->lock);
+	wl->wlc->vif = vif;
 	wl->mute_tx = false;
 	brcms_c_mute(wl->wlc, false);
 	if (vif->type == NL80211_IFTYPE_STATION)
@@ -937,6 +938,27 @@ static void brcms_ops_set_tsf(struct ieee80211_hw *hw,
 	spin_unlock_bh(&wl->lock);
 }
 
+static int brcms_ops_beacon_set_tim(struct ieee80211_hw *hw,
+				 struct ieee80211_sta *sta, bool set)
+{
+	/*FIXME: this may be more efficiently handled by delegating
+	 beacon upload to the beacon interrupt handler*/
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
@@ -955,6 +977,7 @@ static const struct ieee80211_ops brcms_ops = {
 	.flush = brcms_ops_flush,
 	.get_tsf = brcms_ops_get_tsf,
 	.set_tsf = brcms_ops_set_tsf,
+	.set_tim = brcms_ops_beacon_set_tim,
 };
 
 void brcms_dpc(unsigned long data)
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.h b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.h
index c4d135c..e3939fc 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.h
@@ -568,6 +568,8 @@ struct brcms_c_info {
 	u16 beacon_tim_offset;
 	u16 beacon_dtim_period;
 	struct sk_buff *probe_resp;
+	
+	struct ieee80211_vif *vif;
 };
 
 /* antsel module specific state */
-- 
2.18.0
