Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57937 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab1CaNEO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2011 09:04:14 -0400
Received: by mail-fx0-f46.google.com with SMTP id 17so1817769fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 31 Mar 2011 06:04:14 -0700 (PDT)
From: Jarkko Nikula <jhnikula@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Kalle Valo <kvalo@adurom.com>,
	Jarkko Nikula <jhnikula@gmail.com>
Subject: [PATCH 2/2] wl1251: Add support for idle mode
Date: Thu, 31 Mar 2011 16:04:03 +0300
Message-Id: <1301576643-29224-2-git-send-email-jhnikula@gmail.com>
In-Reply-To: <1301576643-29224-1-git-send-email-jhnikula@gmail.com>
References: <1301576643-29224-1-git-send-email-jhnikula@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Nokia N900 the wl1251 consumes the most power when the interface is up
but not associated to access point (that supports PSM). In terms of battery
current consumption, the consumption is ~180 mA higher when the interface is
up but not associated and only ~5 mA higher when associated compared to
interface down and driver not loaded cases.

This patch adds support for the mac80211 idle notifications. Chip is put into
idle very much the same way when entering into PSM by utilizing the Extreme
Low Power (ELP) mode. I.e. idle is entered by setting necessary conditions
in wl1251_ps_set_mode followed by a call to wl1251_ps_elp_sleep.

It seems it is just enough the authorize ELP mode followed by
CMD_DISCONNECT (thanks to Kalle Valo about the idea to use it).
Without disconnect command the chip remains somewhat active and stays
consuming ~20 mA. Idle mode is left by same way than PSM. The wl1251_join
call is used to revert the CMD_DISCONNECT. Without it association to AP
doesn't work when trying second time.

With this patch the interface up but not associated case the battery current
consumption is less than 1 mA higher compared to interface down case.

Signed-off-by: Jarkko Nikula <jhnikula@gmail.com>
---
v2:
- cmd.h change not needed because of the patch 1/2
- developed on top vanilla commit 6aba74f2791287ec407e0f92487a725a25908067
v1:
- I don't have specs for the chip and this patch is developed heavily by
  trial and error method. Anyway, I believe the chip enters into idle properly
  as the consumption is very near to interface down case.
- I have verified the patch by making sure that the driver can scan the APs
  and connect/disconnect multiple times after the idle mode was entered.
- There is still problem that the consumption jumps again ~+180 mA after
  disconnection happens. Reason is the BSS_LOSE_EVENT which puts the chip
  again into active mode and driver doesn't receive an idle mode request
  after that. For me it looks the driver doesn't notify the mac80211
  properly and thus no idle mode request is coming. As this patch doesn't
  affect that I see that is better to handle separately.
---
 drivers/net/wireless/wl1251/main.c   |   16 ++++++++++++++++
 drivers/net/wireless/wl1251/ps.c     |   11 +++++++++++
 drivers/net/wireless/wl1251/wl1251.h |    1 +
 3 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl1251/main.c b/drivers/net/wireless/wl1251/main.c
index 04a0549..a14a48c 100644
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
index 5485f03..50ed918 100644
--- a/drivers/net/wireless/wl1251/ps.c
+++ b/drivers/net/wireless/wl1251/ps.c
@@ -136,6 +136,17 @@ int wl1251_ps_set_mode(struct wl1251 *wl, enum wl1251_station_mode mode)
 		if (ret < 0)
 			return ret;
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
+		break;
 	case STATION_ACTIVE_MODE:
 	default:
 		wl1251_debug(DEBUG_PSM, "leaving psm");
diff --git a/drivers/net/wireless/wl1251/wl1251.h b/drivers/net/wireless/wl1251/wl1251.h
index bf245a8..a77f1bb 100644
--- a/drivers/net/wireless/wl1251/wl1251.h
+++ b/drivers/net/wireless/wl1251/wl1251.h
@@ -132,6 +132,7 @@ enum wl1251_partition_type {
 enum wl1251_station_mode {
 	STATION_ACTIVE_MODE,
 	STATION_POWER_SAVE_MODE,
+	STATION_IDLE,
 };
 
 struct wl1251_partition {
-- 
1.7.0.4

