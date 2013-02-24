Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53925 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758968Ab3BXBGl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Feb 2013 20:06:41 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: arend@broadcom.com
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [RFC 01/13] brcmsmac: implement ieee80211_ops get_tsf and set_tsf
Date: Sun, 24 Feb 2013 02:05:59 +0100
Message-Id: <1361667972-22909-2-git-send-email-hauke@hauke-m.de> (sfid-20130224_020655_940572_D73C044F)
In-Reply-To: <1361667972-22909-1-git-send-email-hauke@hauke-m.de>
References: <1361667972-22909-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

setting the tsf is needed to start a timer to make beaconing in AP mode
work.

This is based on older versions of brcmsmac and b43.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/d11.h      |    1 +
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   24 +++++++++++
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |   44 ++++++++++++++++++++
 drivers/net/wireless/brcm80211/brcmsmac/pub.h      |    2 +
 4 files changed, 71 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/d11.h b/drivers/net/wireless/brcm80211/brcmsmac/d11.h
index 3f659e0..9035cc4 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/d11.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/d11.h
@@ -457,6 +457,7 @@ struct d11regs {
 /*== maccontrol register ==*/
 #define	MCTL_GMODE		(1U << 31)
 #define	MCTL_DISCARD_PMQ	(1 << 30)
+#define	MCTL_TBTTHOLD		(1 << 28)
 #define	MCTL_WAKE		(1 << 26)
 #define	MCTL_HPS		(1 << 25)
 #define	MCTL_PROMISC		(1 << 24)
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index c6451c6..ab678ae 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -738,6 +738,28 @@ static void brcms_ops_flush(struct ieee80211_hw *hw, bool drop)
 			   "ret=%d\n", jiffies_to_msecs(ret));
 }
 
+static u64 brcms_ops_get_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
+{
+	struct brcms_info *wl = hw->priv;
+	u64 tsf;
+
+	spin_lock_bh(&wl->lock);
+	tsf = brcms_c_tsf_get(wl->wlc);
+	spin_unlock_bh(&wl->lock);
+
+	return tsf;
+}
+
+static void brcms_ops_set_tsf(struct ieee80211_hw *hw,
+			   struct ieee80211_vif *vif, u64 tsf)
+{
+	struct brcms_info *wl = hw->priv;
+
+	spin_lock_bh(&wl->lock);
+	brcms_c_tsf_set(wl->wlc, tsf);
+	spin_unlock_bh(&wl->lock);
+}
+
 static const struct ieee80211_ops brcms_ops = {
 	.tx = brcms_ops_tx,
 	.start = brcms_ops_start,
@@ -754,6 +776,8 @@ static const struct ieee80211_ops brcms_ops = {
 	.ampdu_action = brcms_ops_ampdu_action,
 	.rfkill_poll = brcms_ops_rfkill_poll,
 	.flush = brcms_ops_flush,
+	.get_tsf = brcms_ops_get_tsf,
+	.set_tsf = brcms_ops_set_tsf,
 };
 
 void brcms_dpc(unsigned long data)
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 8ef02dc..5f455ba 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -5543,6 +5543,20 @@ int brcms_c_set_rateset(struct brcms_c_info *wlc, struct brcm_rateset *rs)
 	return bcmerror;
 }
 
+static void brcms_c_time_lock(struct brcms_c_info *wlc)
+{
+	bcma_set32(wlc->hw->d11core, D11REGOFFS(maccontrol), MCTL_TBTTHOLD);
+	/* Commit the write */
+	bcma_read32(wlc->hw->d11core, D11REGOFFS(maccontrol));
+}
+
+static void brcms_c_time_unlock(struct brcms_c_info *wlc)
+{
+	bcma_mask32(wlc->hw->d11core, D11REGOFFS(maccontrol), ~MCTL_TBTTHOLD);
+	/* Commit the write */
+	bcma_read32(wlc->hw->d11core, D11REGOFFS(maccontrol));
+}
+
 int brcms_c_set_beacon_period(struct brcms_c_info *wlc, u16 period)
 {
 	if (period == 0)
@@ -7526,6 +7540,36 @@ void brcms_c_set_beacon_listen_interval(struct brcms_c_info *wlc, u8 interval)
 		brcms_c_bcn_li_upd(wlc);
 }
 
+u64 brcms_c_tsf_get(struct brcms_c_info *wlc)
+{
+	u32 tsf_h, tsf_l;
+	u64 tsf;
+
+	brcms_b_read_tsf(wlc->hw, &tsf_l, &tsf_h);
+
+	tsf = tsf_h;
+	tsf <<= 32;
+	tsf |= tsf_l;
+
+	return tsf;
+}
+
+void brcms_c_tsf_set(struct brcms_c_info *wlc, u64 tsf)
+{
+	u32 tsf_h, tsf_l;
+
+	brcms_c_time_lock(wlc);
+
+	tsf_l = tsf;
+	tsf_h = (tsf >> 32);
+
+	/* read the tsf timer low, then high to get an atomic read */
+	bcma_write32(wlc->hw->d11core, D11REGOFFS(tsf_timerlow), tsf_l);
+	bcma_write32(wlc->hw->d11core, D11REGOFFS(tsf_timerhigh), tsf_h);
+
+	brcms_c_time_unlock(wlc);
+}
+
 int brcms_c_set_tx_power(struct brcms_c_info *wlc, int txpwr)
 {
 	uint qdbm;
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/pub.h b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
index b0f14b7..382fb09 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/pub.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
@@ -326,6 +326,8 @@ extern void brcms_c_set_shortslot_override(struct brcms_c_info *wlc,
 				    s8 sslot_override);
 extern void brcms_c_set_beacon_listen_interval(struct brcms_c_info *wlc,
 					u8 interval);
+extern u64 brcms_c_tsf_get(struct brcms_c_info *wlc);
+extern void brcms_c_tsf_set(struct brcms_c_info *wlc, u64 tsf);
 extern int brcms_c_set_tx_power(struct brcms_c_info *wlc, int txpwr);
 extern int brcms_c_get_tx_power(struct brcms_c_info *wlc);
 extern bool brcms_c_check_radio_disabled(struct brcms_c_info *wlc);
-- 
1.7.10.4

