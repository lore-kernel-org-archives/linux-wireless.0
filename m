Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:37745 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756758Ab2I0Kiq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 06:38:46 -0400
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, Ido Yariv <ido@wizery.com>
Subject: [PATCH 28/31] wlcore: Refactor probe
Date: Thu, 27 Sep 2012 13:38:06 +0300
Message-Id: <1348742289-6587-29-git-send-email-luca@coelho.fi> (sfid-20120927_123931_129637_7CCEE7A1)
In-Reply-To: <1348742289-6587-1-git-send-email-luca@coelho.fi>
References: <1348742289-6587-1-git-send-email-luca@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Yariv <ido@wizery.com>

Move most of the device-specific probe functionality into setup(), a new
op. By doing this, wlcore_probe will be the first to request a firmware
from userspace, making it easier to load the NVS file asynchronously.

Signed-off-by: Ido Yariv <ido@wizery.com>
Signed-off-by: Luciano Coelho <luca@coelho.fi>
---
 drivers/net/wireless/ti/wl12xx/main.c   |   52 ++++++++++++++++++---------
 drivers/net/wireless/ti/wl18xx/main.c   |   59 ++++++++++++++++++-------------
 drivers/net/wireless/ti/wlcore/main.c   |   18 +++++-----
 drivers/net/wireless/ti/wlcore/wlcore.h |    2 ++
 4 files changed, 83 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 630b4d4..dadf1db 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -1589,7 +1589,10 @@ static int wl12xx_set_key(struct wl1271 *wl, enum set_key_cmd cmd,
 	return wlcore_set_key(wl, cmd, vif, sta, key_conf);
 }
 
+static int wl12xx_setup(struct wl1271 *wl);
+
 static struct wlcore_ops wl12xx_ops = {
+	.setup			= wl12xx_setup,
 	.identify_chip		= wl12xx_identify_chip,
 	.identify_fw		= wl12xx_identify_fw,
 	.boot			= wl12xx_boot,
@@ -1630,23 +1633,11 @@ static struct ieee80211_sta_ht_cap wl12xx_ht_cap = {
 		},
 };
 
-static int __devinit wl12xx_probe(struct platform_device *pdev)
+static int wl12xx_setup(struct wl1271 *wl)
 {
-	struct wl12xx_platform_data *pdata = pdev->dev.platform_data;
-	struct wl1271 *wl;
-	struct ieee80211_hw *hw;
-	struct wl12xx_priv *priv;
-
-	hw = wlcore_alloc_hw(sizeof(*priv), WL12XX_AGGR_BUFFER_SIZE);
-	if (IS_ERR(hw)) {
-		wl1271_error("can't allocate hw");
-		return PTR_ERR(hw);
-	}
+	struct wl12xx_priv *priv = wl->priv;
+	struct wl12xx_platform_data *pdata = wl->pdev->dev.platform_data;
 
-	wl = hw->priv;
-	priv = wl->priv;
-	wl->ops = &wl12xx_ops;
-	wl->ptable = wl12xx_ptable;
 	wl->rtable = wl12xx_rtable;
 	wl->num_tx_desc = WL12XX_NUM_TX_DESCRIPTORS;
 	wl->num_rx_desc = WL12XX_NUM_RX_DESCRIPTORS;
@@ -1702,7 +1693,36 @@ static int __devinit wl12xx_probe(struct platform_device *pdev)
 			wl1271_error("Invalid tcxo parameter %s", tcxo_param);
 	}
 
-	return wlcore_probe(wl, pdev);
+	return 0;
+}
+
+static int __devinit wl12xx_probe(struct platform_device *pdev)
+{
+	struct wl1271 *wl;
+	struct ieee80211_hw *hw;
+	int ret;
+
+	hw = wlcore_alloc_hw(sizeof(struct wl12xx_priv),
+			     WL12XX_AGGR_BUFFER_SIZE);
+	if (IS_ERR(hw)) {
+		wl1271_error("can't allocate hw");
+		ret = PTR_ERR(hw);
+		goto out;
+	}
+
+	wl = hw->priv;
+	wl->ops = &wl12xx_ops;
+	wl->ptable = wl12xx_ptable;
+	ret = wlcore_probe(wl, pdev);
+	if (ret)
+		goto out_free;
+
+	return ret;
+
+out_free:
+	wlcore_free_hw(wl);
+out:
+	return ret;
 }
 
 static const struct platform_device_id wl12xx_id_table[] __devinitconst = {
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 44e5cad..9e3e10a 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -1304,7 +1304,10 @@ static u32 wl18xx_pre_pkt_send(struct wl1271 *wl,
 	return buf_offset;
 }
 
+static int wl18xx_setup(struct wl1271 *wl);
+
 static struct wlcore_ops wl18xx_ops = {
+	.setup		= wl18xx_setup,
 	.identify_chip	= wl18xx_identify_chip,
 	.boot		= wl18xx_boot,
 	.plt_init	= wl18xx_plt_init,
@@ -1385,24 +1388,11 @@ static struct ieee80211_sta_ht_cap wl18xx_mimo_ht_cap_2ghz = {
 		},
 };
 
-static int __devinit wl18xx_probe(struct platform_device *pdev)
+static int wl18xx_setup(struct wl1271 *wl)
 {
-	struct wl1271 *wl;
-	struct ieee80211_hw *hw;
-	struct wl18xx_priv *priv;
+	struct wl18xx_priv *priv = wl->priv;
 	int ret;
 
-	hw = wlcore_alloc_hw(sizeof(*priv), WL18XX_AGGR_BUFFER_SIZE);
-	if (IS_ERR(hw)) {
-		wl1271_error("can't allocate hw");
-		ret = PTR_ERR(hw);
-		goto out;
-	}
-
-	wl = hw->priv;
-	priv = wl->priv;
-	wl->ops = &wl18xx_ops;
-	wl->ptable = wl18xx_ptable;
 	wl->rtable = wl18xx_rtable;
 	wl->num_tx_desc = WL18XX_NUM_TX_DESCRIPTORS;
 	wl->num_rx_desc = WL18XX_NUM_TX_DESCRIPTORS;
@@ -1417,9 +1407,9 @@ static int __devinit wl18xx_probe(struct platform_device *pdev)
 	if (num_rx_desc_param != -1)
 		wl->num_rx_desc = num_rx_desc_param;
 
-	ret = wl18xx_conf_init(wl, &pdev->dev);
+	ret = wl18xx_conf_init(wl, wl->dev);
 	if (ret < 0)
-		goto out_free;
+		return ret;
 
 	/* If the module param is set, update it in conf */
 	if (board_type_param) {
@@ -1436,16 +1426,14 @@ static int __devinit wl18xx_probe(struct platform_device *pdev)
 		} else {
 			wl1271_error("invalid board type '%s'",
 				board_type_param);
-			ret = -EINVAL;
-			goto out_free;
+			return -EINVAL;
 		}
 	}
 
 	if (priv->conf.phy.board_type >= NUM_BOARD_TYPES) {
 		wl1271_error("invalid board type '%d'",
 			priv->conf.phy.board_type);
-		ret = -EINVAL;
-		goto out_free;
+		return -EINVAL;
 	}
 
 	if (low_band_component_param != -1)
@@ -1477,8 +1465,7 @@ static int __devinit wl18xx_probe(struct platform_device *pdev)
 			priv->conf.ht.mode = HT_MODE_SISO20;
 		else {
 			wl1271_error("invalid ht_mode '%s'", ht_mode_param);
-			ret = -EINVAL;
-			goto out_free;
+			return -EINVAL;
 		}
 	}
 
@@ -1517,7 +1504,31 @@ static int __devinit wl18xx_probe(struct platform_device *pdev)
 	/* Enable 11a Band only if we have 5G antennas */
 	wl->enable_11a = (priv->conf.phy.number_of_assembled_ant5 != 0);
 
-	return wlcore_probe(wl, pdev);
+	return 0;
+}
+
+static int __devinit wl18xx_probe(struct platform_device *pdev)
+{
+	struct wl1271 *wl;
+	struct ieee80211_hw *hw;
+	int ret;
+
+	hw = wlcore_alloc_hw(sizeof(struct wl18xx_priv),
+			     WL18XX_AGGR_BUFFER_SIZE);
+	if (IS_ERR(hw)) {
+		wl1271_error("can't allocate hw");
+		ret = PTR_ERR(hw);
+		goto out;
+	}
+
+	wl = hw->priv;
+	wl->ops = &wl18xx_ops;
+	wl->ptable = wl18xx_ptable;
+	ret = wlcore_probe(wl, pdev);
+	if (ret)
+		goto out_free;
+
+	return ret;
 
 out_free:
 	wlcore_free_hw(wl);
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 419c399..7db6384 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5547,9 +5547,17 @@ int __devinit wlcore_probe(struct wl1271 *wl, struct platform_device *pdev)
 
 	if (!wl->ops || !wl->ptable) {
 		ret = -EINVAL;
-		goto out_free_hw;
+		goto out;
 	}
 
+	wl->dev = &pdev->dev;
+	wl->pdev = pdev;
+	platform_set_drvdata(pdev, wl);
+
+	ret = wl->ops->setup(wl);
+	if (ret < 0)
+		goto out;
+
 	BUG_ON(wl->num_tx_desc > WLCORE_MAX_TX_DESCRIPTORS);
 
 	/* adjust some runtime configuration parameters */
@@ -5558,11 +5566,8 @@ int __devinit wlcore_probe(struct wl1271 *wl, struct platform_device *pdev)
 	wl->irq = platform_get_irq(pdev, 0);
 	wl->platform_quirks = pdata->platform_quirks;
 	wl->set_power = pdata->set_power;
-	wl->dev = &pdev->dev;
 	wl->if_ops = pdata->ops;
 
-	platform_set_drvdata(pdev, wl);
-
 	if (wl->platform_quirks & WL12XX_PLATFORM_QUIRK_EDGE_IRQ)
 		irqflags = IRQF_TRIGGER_RISING;
 	else
@@ -5573,7 +5578,7 @@ int __devinit wlcore_probe(struct wl1271 *wl, struct platform_device *pdev)
 				   pdev->name, wl);
 	if (ret < 0) {
 		wl1271_error("request_irq() failed: %d", ret);
-		goto out_free_hw;
+		goto out;
 	}
 
 #ifdef CONFIG_PM
@@ -5646,9 +5651,6 @@ out_unreg:
 out_irq:
 	free_irq(wl->irq, wl);
 
-out_free_hw:
-	wlcore_free_hw(wl);
-
 out:
 	return ret;
 }
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 8ad5f37..6a04556 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -43,6 +43,7 @@ enum wl_rx_buf_align;
 struct wl1271_rx_descriptor;
 
 struct wlcore_ops {
+	int (*setup)(struct wl1271 *wl);
 	int (*identify_chip)(struct wl1271 *wl);
 	int (*identify_fw)(struct wl1271 *wl);
 	int (*boot)(struct wl1271 *wl);
@@ -149,6 +150,7 @@ struct wl1271 {
 	bool mac80211_registered;
 
 	struct device *dev;
+	struct platform_device *pdev;
 
 	void *if_priv;
 
-- 
1.7.10.4

