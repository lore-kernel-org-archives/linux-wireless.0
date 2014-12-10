Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:49295 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961AbaLJMoX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2014 07:44:23 -0500
Received: by mail-wg0-f41.google.com with SMTP id y19so3490311wgg.14
        for <linux-wireless@vger.kernel.org>; Wed, 10 Dec 2014 04:44:21 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 3/5] ath10k: prevent invalid ps timeout config
Date: Wed, 10 Dec 2014 13:31:52 +0100
Message-Id: <1418214714-29689-4-git-send-email-michal.kazior@tieto.com> (sfid-20141210_134427_277599_31CEC900)
In-Reply-To: <1418214714-29689-1-git-send-email-michal.kazior@tieto.com>
References: <1418214714-29689-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Setting 0 ps timeout to firmware yields very poor
latency and traffic issues. This is the case when
multi-vif is active.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 969d187..d41e3d5 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1079,10 +1079,12 @@ static int ath10k_mac_vif_recalc_ps_wake_threshold(struct ath10k_vif *arvif)
 static int ath10k_mac_vif_setup_ps(struct ath10k_vif *arvif)
 {
 	struct ath10k *ar = arvif->ar;
+	struct ieee80211_vif *vif = arvif->vif;
 	struct ieee80211_conf *conf = &ar->hw->conf;
 	enum wmi_sta_powersave_param param;
 	enum wmi_sta_ps_mode psmode;
 	int ret;
+	int ps_timeout;
 
 	lockdep_assert_held(&arvif->ar->conf_mutex);
 
@@ -1093,8 +1095,15 @@ static int ath10k_mac_vif_setup_ps(struct ath10k_vif *arvif)
 		psmode = WMI_STA_PS_MODE_ENABLED;
 		param = WMI_STA_PS_PARAM_INACTIVITY_TIME;
 
+		ps_timeout = conf->dynamic_ps_timeout;
+		if (ps_timeout == 0) {
+			/* Firmware doesn't like 0 */
+			ps_timeout = ieee80211_tu_to_usec(
+				vif->bss_conf.beacon_int) / 1000;
+		}
+
 		ret = ath10k_wmi_set_sta_ps_param(ar, arvif->vdev_id, param,
-						  conf->dynamic_ps_timeout);
+						  ps_timeout);
 		if (ret) {
 			ath10k_warn(ar, "failed to set inactivity time for vdev %d: %i\n",
 				    arvif->vdev_id, ret);
-- 
1.8.5.3

