Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ed1-f67.google.com ([209.85.208.67]:43754 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726051AbeIWPvp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 23 Sep 2018 11:51:45 -0400
Received: by mail-ed1-f67.google.com with SMTP id u23so4819217edx.10
        for <linux-wireless@vger.kernel.org>; Sun, 23 Sep 2018 02:54:49 -0700 (PDT)
From: Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, Kalle Valo <kvalo@codeaurora.org>,
        Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com>
Subject: [PATCH v3] brcmsmac: AP mode: update beacon when TIM changes
Date: Sun, 23 Sep 2018 12:54:25 +0300
Message-Id: <20180923095425.10292-1-alimjalnasrawy@gmail.com> (sfid-20180923_115458_889786_62F8854A)
In-Reply-To: <20180911172618.13049-1-alimjalnasrawy@gmail.com>
References: <20180911172618.13049-1-alimjalnasrawy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Beacons are not updated to reflect TIM changes. This is not compliant with
power-saving client stations as the beacons do not have valid TIM and can cause
the network to stall at random occasions with highly variable latencies.
Fix it by updating beacon templates on mac80211 set_tim callback.

Addresses an issue described in:
https://marc.info/?i=20180911163534.21312d08%20()%20manjaro

Signed-off-by: Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com>
---

v2 -> v3:
	- removed tabs from blank lines
	- extended the commit message to answer "Why"

 .../broadcom/brcm80211/brcmsmac/mac80211_if.c | 21 +++++++++++++++++++
 .../broadcom/brcm80211/brcmsmac/main.h        |  1 +
 2 files changed, 22 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
index ddfdfe1..c6b258f 100644
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
