Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:60053 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751800Ab2GRMN6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2012 08:13:58 -0400
Received: by lbbgj3 with SMTP id gj3so1861180lbb.25
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jul 2012 05:13:56 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com
Subject: [PATCH 10/14] wlcore/wl12xx: calibrator fem detect implementation
Date: Wed, 18 Jul 2012 15:13:29 +0300
Message-Id: <1342613613-917-11-git-send-email-coelho@ti.com> (sfid-20120718_141411_905514_B8DBA223)
In-Reply-To: <1342613613-917-1-git-send-email-coelho@ti.com>
References: <1342613613-917-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yair Shapira <yair.shapira@ti.com>

this completes the calibrator based fem detect logic in driver:
driver starts (by calibrator) in plt_mode PLT_FEM_DETECT
wlcore inits and starts plt on wl12xx
wl12xx fetches fem number from firmware and stores it in wl->fem_manuf
wl12xx immediatly returns (doesn't start radio, etc...)
wlcore returns the fem_manuf to calibrator using WL1271_TM_ATTR_DATA
plt_mode is stopped

Signed-off-by: Yair Shapira <yair.shapira@ti.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl12xx/cmd.c      |   34 +++++++++++++++++++++---
 drivers/net/wireless/ti/wl12xx/main.c     |   23 ++++++++++++++++
 drivers/net/wireless/ti/wlcore/testmode.c |   41 ++++++++++++++++++++++++++++-
 drivers/net/wireless/ti/wlcore/wlcore.h   |    1 +
 4 files changed, 94 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/cmd.c b/drivers/net/wireless/ti/wl12xx/cmd.c
index 30be784..6222062 100644
--- a/drivers/net/wireless/ti/wl12xx/cmd.c
+++ b/drivers/net/wireless/ti/wl12xx/cmd.c
@@ -85,7 +85,11 @@ int wl1271_cmd_general_parms(struct wl1271 *wl)
 
 	memcpy(&gen_parms->general_params, gp, sizeof(*gp));
 
-	if (gp->tx_bip_fem_auto_detect)
+	/* If we started in PLT FEM_DETECT mode, force auto detect */
+	if (wl->plt_mode == PLT_FEM_DETECT)
+		gen_parms->general_params.tx_bip_fem_auto_detect = true;
+
+	if (gen_parms->general_params.tx_bip_fem_auto_detect)
 		answer = true;
 
 	/* Override the REF CLK from the NVS with the one from platform data */
@@ -106,8 +110,17 @@ int wl1271_cmd_general_parms(struct wl1271 *wl)
 		goto out;
 	}
 
+	/* If we are in calibrator based fem auto detect - save fem nr */
+	if (wl->plt_mode == PLT_FEM_DETECT)
+		wl->fem_manuf = gp->tx_bip_fem_manufacturer;
+
 	wl1271_debug(DEBUG_CMD, "FEM autodetect: %s, manufacturer: %d\n",
-		     answer ? "auto" : "manual", gp->tx_bip_fem_manufacturer);
+		answer == false ?
+			"manual" :
+		wl->plt_mode == PLT_FEM_DETECT ?
+			"calibrator_fem_detect" :
+			"auto",
+		gp->tx_bip_fem_manufacturer);
 
 out:
 	kfree(gen_parms);
@@ -139,7 +152,11 @@ int wl128x_cmd_general_parms(struct wl1271 *wl)
 
 	memcpy(&gen_parms->general_params, gp, sizeof(*gp));
 
-	if (gp->tx_bip_fem_auto_detect)
+	/* If we started in PLT FEM_DETECT mode, force auto detect */
+	if (wl->plt_mode == PLT_FEM_DETECT)
+		gen_parms->general_params.tx_bip_fem_auto_detect = true;
+
+	if (gen_parms->general_params.tx_bip_fem_auto_detect)
 		answer = true;
 
 	/* Replace REF and TCXO CLKs with the ones from platform data */
@@ -161,8 +178,17 @@ int wl128x_cmd_general_parms(struct wl1271 *wl)
 		goto out;
 	}
 
+	/* If we are in calibrator based fem auto detect - save fem nr */
+	if (wl->plt_mode == PLT_FEM_DETECT)
+		wl->fem_manuf = gp->tx_bip_fem_manufacturer;
+
 	wl1271_debug(DEBUG_CMD, "FEM autodetect: %s, manufacturer: %d\n",
-		     answer ? "auto" : "manual", gp->tx_bip_fem_manufacturer);
+		answer == false ?
+			"manual" :
+		wl->plt_mode == PLT_FEM_DETECT ?
+			"calibrator_fem_detect" :
+			"auto",
+		gp->tx_bip_fem_manufacturer);
 
 out:
 	kfree(gen_parms);
diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 3d6c71b..f429fc1 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -1339,6 +1339,14 @@ static int wl12xx_hw_init(struct wl1271 *wl)
 		ret = wl128x_cmd_general_parms(wl);
 		if (ret < 0)
 			goto out;
+
+		/*
+		 * If we are in calibrator based auto detect then we got the FEM nr
+		 * in wl->fem_manuf. No need to continue further
+		 */
+		if (wl->plt_mode == PLT_FEM_DETECT)
+			goto out;
+
 		ret = wl128x_cmd_radio_parms(wl);
 		if (ret < 0)
 			goto out;
@@ -1355,6 +1363,14 @@ static int wl12xx_hw_init(struct wl1271 *wl)
 		ret = wl1271_cmd_general_parms(wl);
 		if (ret < 0)
 			goto out;
+
+		/*
+		 * If we are in calibrator based auto detect then we got the FEM nr
+		 * in wl->fem_manuf. No need to continue further
+		 */
+		if (wl->plt_mode == PLT_FEM_DETECT)
+			goto out;
+
 		ret = wl1271_cmd_radio_parms(wl);
 		if (ret < 0)
 			goto out;
@@ -1500,6 +1516,13 @@ static int wl12xx_plt_init(struct wl1271 *wl)
 	if (ret < 0)
 		goto out_irq_disable;
 
+	/*
+	 * If we are in calibrator based auto detect then we got the FEM nr
+	 * in wl->fem_manuf. No need to continue further
+	 */
+	if (wl->plt_mode == PLT_FEM_DETECT)
+		goto out;
+
 	ret = wl1271_acx_init_mem_config(wl);
 	if (ret < 0)
 		goto out_irq_disable;
diff --git a/drivers/net/wireless/ti/wlcore/testmode.c b/drivers/net/wireless/ti/wlcore/testmode.c
index a204c93..081f175 100644
--- a/drivers/net/wireless/ti/wlcore/testmode.c
+++ b/drivers/net/wireless/ti/wlcore/testmode.c
@@ -245,6 +245,43 @@ static int wl1271_tm_cmd_configure(struct wl1271 *wl, struct nlattr *tb[])
 	return 0;
 }
 
+static int wl1271_tm_detect_fem(struct wl1271 *wl, struct nlattr *tb[])
+{
+	/* return FEM type */
+	int ret, len;
+	struct sk_buff *skb;
+
+	ret = wl1271_plt_start(wl, PLT_FEM_DETECT);
+	if (ret < 0)
+		goto out;
+
+	mutex_lock(&wl->mutex);
+
+	len = nla_total_size(sizeof(wl->fem_manuf));
+	skb = cfg80211_testmode_alloc_reply_skb(wl->hw->wiphy, len);
+	if (!skb) {
+		ret = -ENOMEM;
+		goto out_mutex;
+	}
+
+	if (nla_put(skb, WL1271_TM_ATTR_DATA, sizeof(wl->fem_manuf),
+					      &wl->fem_manuf)) {
+		kfree_skb(skb);
+		ret = -EMSGSIZE;
+		goto out_mutex;
+	}
+
+	ret = cfg80211_testmode_reply(skb);
+
+out_mutex:
+	mutex_unlock(&wl->mutex);
+
+	/* We always stop plt after DETECT mode */
+	wl1271_plt_stop(wl);
+out:
+	return ret;
+}
+
 static int wl1271_tm_cmd_set_plt_mode(struct wl1271 *wl, struct nlattr *tb[])
 {
 	u32 val;
@@ -262,8 +299,10 @@ static int wl1271_tm_cmd_set_plt_mode(struct wl1271 *wl, struct nlattr *tb[])
 		ret = wl1271_plt_stop(wl);
 		break;
 	case PLT_ON:
+		ret = wl1271_plt_start(wl, PLT_ON);
+		break;
 	case PLT_FEM_DETECT:
-		ret = wl1271_plt_start(wl, val);
+		ret = wl1271_tm_detect_fem(wl, tb);
 		break;
 	default:
 		ret = -EINVAL;
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 4f8b419..0ce7a8e 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -157,6 +157,7 @@ struct wl1271 {
 	enum wl12xx_fw_type fw_type;
 	bool plt;
 	enum plt_mode plt_mode;
+	u8 fem_manuf;
 	u8 last_vif_count;
 	struct mutex mutex;
 
-- 
1.7.10.4

