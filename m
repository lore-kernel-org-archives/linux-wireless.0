Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:56606 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647AbZGRSV4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jul 2009 14:21:56 -0400
Received: by ey-out-2122.google.com with SMTP id 9so365701eyd.37
        for <linux-wireless@vger.kernel.org>; Sat, 18 Jul 2009 11:21:54 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: John Linville <linville@tuxdriver.com>,
	users@rt2x00.serialmonkey.com,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	"Lars Ericsson" <Lars_Ericsson@telia.com>
Subject: [PATCH] rt2x00: Don't alter rt2x00dev->default_ant
Date: Sat, 18 Jul 2009 20:21:52 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200907182021.52268.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lars Ericsson <Lars_Ericsson@telia.com>

rt2x00dev->default_ant should be initialized once by the driver,
and should not be changed afterwards. Because rt2x00lib_config_antenna()
was using a reference to the struct antenna_setup it actually had the oppurtunity
to change the default antenna setting and it actually did that during the validation.

Instead of passing a pointer to antenna_setup the entire structure should be copied.

Signed-off-by: Lars Ericsson <Lars_Ericsson@telia.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index c6e0bcf..3845316 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -124,7 +124,7 @@ enum antenna rt2x00lib_config_antenna_check(enum antenna current_ant,
 }
 
 void rt2x00lib_config_antenna(struct rt2x00_dev *rt2x00dev,
-			      struct antenna_setup *ant)
+			      struct antenna_setup ant)
 {
 	struct antenna_setup *def = &rt2x00dev->default_ant;
 	struct antenna_setup *active = &rt2x00dev->link.ant.active;
@@ -138,10 +138,10 @@ void rt2x00lib_config_antenna(struct rt2x00_dev *rt2x00dev,
 	 * might have caused that we restore back to the already
 	 * active setting. If that has happened we can quit.
 	 */
-	ant->rx = rt2x00lib_config_antenna_check(ant->rx, def->rx);
-	ant->tx = rt2x00lib_config_antenna_check(ant->tx, def->tx);
+	ant.rx = rt2x00lib_config_antenna_check(ant.rx, def->rx);
+	ant.tx = rt2x00lib_config_antenna_check(ant.tx, def->tx);
 
-	if (ant->rx == active->rx && ant->tx == active->tx)
+	if (ant.rx == active->rx && ant.tx == active->tx)
 		return;
 
 	/*
@@ -156,11 +156,11 @@ void rt2x00lib_config_antenna(struct rt2x00_dev *rt2x00dev,
 	 * The latter is required since we need to recalibrate the
 	 * noise-sensitivity ratio for the new setup.
 	 */
-	rt2x00dev->ops->lib->config_ant(rt2x00dev, ant);
+	rt2x00dev->ops->lib->config_ant(rt2x00dev, &ant);
 
 	rt2x00link_reset_tuner(rt2x00dev, true);
 
-	memcpy(active, ant, sizeof(*ant));
+	memcpy(active, &ant, sizeof(ant));
 
 	if (test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
 		rt2x00lib_toggle_rx(rt2x00dev, STATE_RADIO_RX_ON_LINK);
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index 2c3c239..c0aa2e6 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -88,7 +88,7 @@ void rt2x00lib_config_erp(struct rt2x00_dev *rt2x00dev,
 			  struct rt2x00_intf *intf,
 			  struct ieee80211_bss_conf *conf);
 void rt2x00lib_config_antenna(struct rt2x00_dev *rt2x00dev,
-			      struct antenna_setup *ant);
+			      struct antenna_setup ant);
 void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
 		      struct ieee80211_conf *conf,
 		      const unsigned int changed_flags);
diff --git a/drivers/net/wireless/rt2x00/rt2x00link.c b/drivers/net/wireless/rt2x00/rt2x00link.c
index 3257075..7991568 100644
--- a/drivers/net/wireless/rt2x00/rt2x00link.c
+++ b/drivers/net/wireless/rt2x00/rt2x00link.c
@@ -173,7 +173,7 @@ static void rt2x00lib_antenna_diversity_sample(struct rt2x00_dev *rt2x00dev)
 	if (ant->flags & ANTENNA_TX_DIVERSITY)
 		new_ant.tx = (sample_a > sample_b) ? ANTENNA_A : ANTENNA_B;
 
-	rt2x00lib_config_antenna(rt2x00dev, &new_ant);
+	rt2x00lib_config_antenna(rt2x00dev, new_ant);
 }
 
 static void rt2x00lib_antenna_diversity_eval(struct rt2x00_dev *rt2x00dev)
@@ -213,7 +213,7 @@ static void rt2x00lib_antenna_diversity_eval(struct rt2x00_dev *rt2x00dev)
 	if (ant->flags & ANTENNA_TX_DIVERSITY)
 		new_ant.tx = (new_ant.tx == ANTENNA_A) ? ANTENNA_B : ANTENNA_A;
 
-	rt2x00lib_config_antenna(rt2x00dev, &new_ant);
+	rt2x00lib_config_antenna(rt2x00dev, new_ant);
 }
 
 static void rt2x00lib_antenna_diversity(struct rt2x00_dev *rt2x00dev)
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 54fd2e8..8e8e46c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -378,7 +378,7 @@ int rt2x00mac_config(struct ieee80211_hw *hw, u32 changed)
 		 */
 		if (changed & IEEE80211_CONF_CHANGE_RADIO_ENABLED)
 			rt2x00lib_config_antenna(rt2x00dev,
-						 &rt2x00dev->default_ant);
+						 rt2x00dev->default_ant);
 
 		/* Turn RX back on */
 		rt2x00lib_toggle_rx(rt2x00dev, STATE_RADIO_RX_ON);
