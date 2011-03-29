Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44915 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603Ab1C2OQU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2011 10:16:20 -0400
Received: by fxm17 with SMTP id 17so236373fxm.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2011 07:16:18 -0700 (PDT)
From: Jarkko Nikula <jhnikula@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Jarkko Nikula <jhnikula@gmail.com>,
	Kalle Valo <kvalo@adurom.com>
Subject: [RFC] wl1251: Add support for idle mode
Date: Tue, 29 Mar 2011 17:15:14 +0300
Message-Id: <1301408114-2325-1-git-send-email-jhnikula@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Nokia N900 the wl1251 consumes the most power when the interface is up
but not associated to access point (that supports PSM). In terms of battery
current consumtion, the consumtion is ~180 mA higher when the interface is
up but not associated and only ~5 mA higher when associated compared to
interface down and driver not loaded cases.

This patch adds support for the mac80211 idle notifications. Chip is put into
idle very much the same way when entering into PSM by utilizing the Extreme
Low Power (ELP) mode. I.e. idle is entered by first setting necessary
conditions with psm flag set and then via calling the wl1251_ps_elp_sleep.

It seems it is just enough the authorize ELP mode followed by
CMD_DISCONNECT (thanks to Kalle Valo about the idea to use it).
Without disconnect command the chip remains somewhat active and stays
consuming ~20 mA. Idle mode is left by same way than PSM. The wl1251_join
call is used to revert the CMD_DISCONNECT. Without it association to AP
doesn't work when trying second time.

With this patch the interface up but not associated case the battery current
consumtion is less than 1 mA higher compared to interface down case.

Signed-off-by: Jarkko Nikula <jhnikula@gmail.com>
Cc: Kalle Valo <kvalo@adurom.com>
---
- Developed on top of vanilla commit 89078d572eb9ce8d4c04264b8b0ba86de0d74c8f.
- I don't have specs for the chip and this patch is developed heavily by
  trial and error method. Anyway, I believe the chip enters into idle properly
  as the consumtion is very near to interface down case.
- I have verified the patch by making sure that the driver can scan the APs
  and connect/disconnect multiple times after the idle mode was entered.
- There is still problem that the consumtion jumps again ~+180 mA after
  disconnection happens. Reason is the BSS_LOSE_EVENT which puts the chip
  again into active mode and driver doesn't receive an idle mode request
  after that. For me it looks the driver doesn't notify the mac80211
  properly and thus no idle mode request is coming. As this patch doesn't
  affect that I see that is better to handle separately.
---
 drivers/net/wireless/wl1251/cmd.h  |    3 ++-
 drivers/net/wireless/wl1251/main.c |   16 ++++++++++++++++
 drivers/net/wireless/wl1251/ps.c   |   13 +++++++++++++
 3 files changed, 31 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl1251/cmd.h b/drivers/net/wireless/wl1251/cmd.h
index e5c74c6..7ca0768 100644
--- a/drivers/net/wireless/wl1251/cmd.h
+++ b/drivers/net/wireless/wl1251/cmd.h
@@ -314,7 +314,8 @@ struct wl1251_cmd_vbm_update {
 
 enum wl1251_cmd_ps_mode {
 	STATION_ACTIVE_MODE,
-	STATION_POWER_SAVE_MODE
+	STATION_POWER_SAVE_MODE,
+	STATION_IDLE,
 };
 
 struct wl1251_cmd_ps_params {
diff --git a/drivers/net/wireless/wl1251/main.c b/drivers/net/wireless/wl1251/main.c
index 12c9e63..86c0b0e 100644
--- a/drivers/net/wireless/wl1251/main.c
+++ b/drivers/net/wireless/wl1251/main.c
@@ -639,6 +639,22 @@ static int wl1251_op_config(struct ieee80211_hw *hw, u32 changed)
 		}
 	}
 
+	if (changed & IEEE80211_CONF_CHANGE_IDLE) {
+		if (conf->flags & IEEE80211_CONF_IDLE) {
+			ret = wl1251_ps_set_mode(wl, STATION_IDLE);
+			if (ret < 0)
+				goto out_sleep;
+		} else {
+			ret = wl1251_ps_set_mode(wl, STATION_ACTIVE_MODE);
+			if (ret < 0)
+				goto out_sleep;
+			ret = wl1251_join(wl, wl->bss_type, wl->channel,
+					  wl->beacon_int, wl->dtim_period);
+			if (ret < 0)
+				goto out_sleep;
+		}
+	}
+
 	if (conf->power_level != wl->power_level) {
 		ret = wl1251_acx_tx_power(wl, conf->power_level);
 		if (ret < 0)
diff --git a/drivers/net/wireless/wl1251/ps.c b/drivers/net/wireless/wl1251/ps.c
index 9cc5147..2b035e0 100644
--- a/drivers/net/wireless/wl1251/ps.c
+++ b/drivers/net/wireless/wl1251/ps.c
@@ -138,6 +138,19 @@ int wl1251_ps_set_mode(struct wl1251 *wl, enum wl1251_cmd_ps_mode mode)
 
 		wl->psm = 1;
 		break;
+	case STATION_IDLE:
+		wl1251_debug(DEBUG_PSM, "entering idle");
+
+		ret = wl1251_acx_sleep_auth(wl, WL1251_PSM_ELP);
+		if (ret < 0)
+			return ret;
+
+		ret = wl1251_cmd_template_set(wl, CMD_DISCONNECT, NULL, 0);
+		if (ret < 0)
+			return ret;
+
+		wl->psm = 1;
+		break;
 	case STATION_ACTIVE_MODE:
 	default:
 		wl1251_debug(DEBUG_PSM, "leaving psm");
-- 
1.7.0.4

