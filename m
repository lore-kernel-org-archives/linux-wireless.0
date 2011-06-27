Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49766 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab1F0TGn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2011 15:06:43 -0400
Received: by mail-ww0-f44.google.com with SMTP id 5so5058241wwe.1
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jun 2011 12:06:43 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 2/2] wl12xx: always initialize AP-mode max power level
Date: Mon, 27 Jun 2011 22:06:34 +0300
Message-Id: <1309201594-12582-2-git-send-email-arik@wizery.com> (sfid-20110627_210656_478625_75BFAF59)
In-Reply-To: <1309201594-12582-1-git-send-email-arik@wizery.com>
References: <1309201594-12582-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sometimes we only get the Tx power level via op->config when the FW is
off. Record the received power level when this happens and use it to
initialize the firmware during boot.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/acx.c  |    2 +-
 drivers/net/wireless/wl12xx/init.c |    5 +++++
 drivers/net/wireless/wl12xx/main.c |    3 +++
 3 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index b5880eb..172aee4 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -90,7 +90,7 @@ int wl1271_acx_tx_power(struct wl1271 *wl, int power)
 	struct acx_current_tx_power *acx;
 	int ret;
 
-	wl1271_debug(DEBUG_ACX, "acx dot11_cur_tx_pwr");
+	wl1271_debug(DEBUG_ACX, "acx dot11_cur_tx_pwr %d", power);
 
 	if (power < 0 || power > 25)
 		return -EINVAL;
diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index b85edcc..5adecbe 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -441,6 +441,11 @@ static int wl1271_ap_hw_init(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
+	/* initialize Tx power */
+	ret = wl1271_acx_tx_power(wl, wl->power_level);
+	if (ret < 0)
+		return ret;
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index effde53..528b774 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2100,6 +2100,9 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 			wl->channel = channel;
 		}
 
+		if ((changed & IEEE80211_CONF_CHANGE_POWER))
+			wl->power_level = conf->power_level;
+
 		goto out;
 	}
 
-- 
1.7.4.1

