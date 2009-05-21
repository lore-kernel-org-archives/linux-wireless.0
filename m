Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:43776 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764AbZEURQw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2009 13:16:52 -0400
Received: by ewy24 with SMTP id 24so1347414ewy.37
        for <linux-wireless@vger.kernel.org>; Thu, 21 May 2009 10:16:51 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: linville@tuxdriver.com
Subject: [PATCH 2/2] rt2x00: Remove usage of IEEE80211_CONF_CHANGE_BEACON_INTERVAL
Date: Thu, 21 May 2009 19:16:46 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
References: <200905211916.14245.IvDoorn@gmail.com>
In-Reply-To: <200905211916.14245.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200905211916.46328.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

IEEE80211_CONF_CHANGE_BEACON_INTERVAL was deprecated a month ago,
it is about time to remove all usage from the rt2x00 drivers and
use the correct beacon interval configuration through the bss_info
structure.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c    |   30 +++++++--------------------
 drivers/net/wireless/rt2x00/rt2500pci.c    |   30 +++++++--------------------
 drivers/net/wireless/rt2x00/rt2500usb.c    |   17 +++------------
 drivers/net/wireless/rt2x00/rt2800usb.c    |   18 ++++------------
 drivers/net/wireless/rt2x00/rt2x00.h       |    2 +
 drivers/net/wireless/rt2x00/rt2x00config.c |    1 +
 drivers/net/wireless/rt2x00/rt61pci.c      |   28 ++++++-------------------
 drivers/net/wireless/rt2x00/rt73usb.c      |   28 ++++++-------------------
 8 files changed, 42 insertions(+), 112 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 6f39ba6..0197531 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -335,10 +335,11 @@ static void rt2400pci_config_erp(struct rt2x00_dev *rt2x00dev,
 	preamble_mask = erp->short_preamble << 3;
 
 	rt2x00pci_register_read(rt2x00dev, TXCSR1, &reg);
-	rt2x00_set_field32(&reg, TXCSR1_ACK_TIMEOUT,
-			   erp->ack_timeout);
+	rt2x00_set_field32(&reg, TXCSR1_ACK_TIMEOUT, erp->ack_timeout);
 	rt2x00_set_field32(&reg, TXCSR1_ACK_CONSUME_TIME,
 			   erp->ack_consume_time);
+	rt2x00_set_field32(&reg, TXCSR1_TSF_OFFSET, IEEE80211_HEADER);
+	rt2x00_set_field32(&reg, TXCSR1_AUTORESPONDER, 1);
 	rt2x00pci_register_write(rt2x00dev, TXCSR1, reg);
 
 	rt2x00pci_register_read(rt2x00dev, ARCSR2, &reg);
@@ -371,6 +372,11 @@ static void rt2400pci_config_erp(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&reg, CSR11_SLOT_TIME, erp->slot_time);
 	rt2x00pci_register_write(rt2x00dev, CSR11, reg);
 
+	rt2x00pci_register_read(rt2x00dev, CSR12, &reg);
+	rt2x00_set_field32(&reg, CSR12_BEACON_INTERVAL, erp->beacon_int * 16);
+	rt2x00_set_field32(&reg, CSR12_CFP_MAX_DURATION, erp->beacon_int * 16);
+	rt2x00pci_register_write(rt2x00dev, CSR12, reg);
+
 	rt2x00pci_register_read(rt2x00dev, CSR18, &reg);
 	rt2x00_set_field32(&reg, CSR18_SIFS, erp->sifs);
 	rt2x00_set_field32(&reg, CSR18_PIFS, erp->pifs);
@@ -503,24 +509,6 @@ static void rt2400pci_config_retry_limit(struct rt2x00_dev *rt2x00dev,
 	rt2x00pci_register_write(rt2x00dev, CSR11, reg);
 }
 
-static void rt2400pci_config_duration(struct rt2x00_dev *rt2x00dev,
-				      struct rt2x00lib_conf *libconf)
-{
-	u32 reg;
-
-	rt2x00pci_register_read(rt2x00dev, TXCSR1, &reg);
-	rt2x00_set_field32(&reg, TXCSR1_TSF_OFFSET, IEEE80211_HEADER);
-	rt2x00_set_field32(&reg, TXCSR1_AUTORESPONDER, 1);
-	rt2x00pci_register_write(rt2x00dev, TXCSR1, reg);
-
-	rt2x00pci_register_read(rt2x00dev, CSR12, &reg);
-	rt2x00_set_field32(&reg, CSR12_BEACON_INTERVAL,
-			   libconf->conf->beacon_int * 16);
-	rt2x00_set_field32(&reg, CSR12_CFP_MAX_DURATION,
-			   libconf->conf->beacon_int * 16);
-	rt2x00pci_register_write(rt2x00dev, CSR12, reg);
-}
-
 static void rt2400pci_config_ps(struct rt2x00_dev *rt2x00dev,
 				struct rt2x00lib_conf *libconf)
 {
@@ -558,8 +546,6 @@ static void rt2400pci_config(struct rt2x00_dev *rt2x00dev,
 					 libconf->conf->power_level);
 	if (flags & IEEE80211_CONF_CHANGE_RETRY_LIMITS)
 		rt2400pci_config_retry_limit(rt2x00dev, libconf);
-	if (flags & IEEE80211_CONF_CHANGE_BEACON_INTERVAL)
-		rt2400pci_config_duration(rt2x00dev, libconf);
 	if (flags & IEEE80211_CONF_CHANGE_PS)
 		rt2400pci_config_ps(rt2x00dev, libconf);
 }
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 906960f..f95cb64 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -341,10 +341,11 @@ static void rt2500pci_config_erp(struct rt2x00_dev *rt2x00dev,
 	preamble_mask = erp->short_preamble << 3;
 
 	rt2x00pci_register_read(rt2x00dev, TXCSR1, &reg);
-	rt2x00_set_field32(&reg, TXCSR1_ACK_TIMEOUT,
-			   erp->ack_timeout);
+	rt2x00_set_field32(&reg, TXCSR1_ACK_TIMEOUT, erp->ack_timeout);
 	rt2x00_set_field32(&reg, TXCSR1_ACK_CONSUME_TIME,
 			   erp->ack_consume_time);
+	rt2x00_set_field32(&reg, TXCSR1_TSF_OFFSET, IEEE80211_HEADER);
+	rt2x00_set_field32(&reg, TXCSR1_AUTORESPONDER, 1);
 	rt2x00pci_register_write(rt2x00dev, TXCSR1, reg);
 
 	rt2x00pci_register_read(rt2x00dev, ARCSR2, &reg);
@@ -377,6 +378,11 @@ static void rt2500pci_config_erp(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&reg, CSR11_SLOT_TIME, erp->slot_time);
 	rt2x00pci_register_write(rt2x00dev, CSR11, reg);
 
+	rt2x00pci_register_read(rt2x00dev, CSR12, &reg);
+	rt2x00_set_field32(&reg, CSR12_BEACON_INTERVAL, erp->beacon_int * 16);
+	rt2x00_set_field32(&reg, CSR12_CFP_MAX_DURATION, erp->beacon_int * 16);
+	rt2x00pci_register_write(rt2x00dev, CSR12, reg);
+
 	rt2x00pci_register_read(rt2x00dev, CSR18, &reg);
 	rt2x00_set_field32(&reg, CSR18_SIFS, erp->sifs);
 	rt2x00_set_field32(&reg, CSR18_PIFS, erp->pifs);
@@ -552,24 +558,6 @@ static void rt2500pci_config_retry_limit(struct rt2x00_dev *rt2x00dev,
 	rt2x00pci_register_write(rt2x00dev, CSR11, reg);
 }
 
-static void rt2500pci_config_duration(struct rt2x00_dev *rt2x00dev,
-				      struct rt2x00lib_conf *libconf)
-{
-	u32 reg;
-
-	rt2x00pci_register_read(rt2x00dev, TXCSR1, &reg);
-	rt2x00_set_field32(&reg, TXCSR1_TSF_OFFSET, IEEE80211_HEADER);
-	rt2x00_set_field32(&reg, TXCSR1_AUTORESPONDER, 1);
-	rt2x00pci_register_write(rt2x00dev, TXCSR1, reg);
-
-	rt2x00pci_register_read(rt2x00dev, CSR12, &reg);
-	rt2x00_set_field32(&reg, CSR12_BEACON_INTERVAL,
-			   libconf->conf->beacon_int * 16);
-	rt2x00_set_field32(&reg, CSR12_CFP_MAX_DURATION,
-			   libconf->conf->beacon_int * 16);
-	rt2x00pci_register_write(rt2x00dev, CSR12, reg);
-}
-
 static void rt2500pci_config_ps(struct rt2x00_dev *rt2x00dev,
 				struct rt2x00lib_conf *libconf)
 {
@@ -609,8 +597,6 @@ static void rt2500pci_config(struct rt2x00_dev *rt2x00dev,
 					 libconf->conf->power_level);
 	if (flags & IEEE80211_CONF_CHANGE_RETRY_LIMITS)
 		rt2500pci_config_retry_limit(rt2x00dev, libconf);
-	if (flags & IEEE80211_CONF_CHANGE_BEACON_INTERVAL)
-		rt2500pci_config_duration(rt2x00dev, libconf);
 	if (flags & IEEE80211_CONF_CHANGE_PS)
 		rt2500pci_config_ps(rt2x00dev, libconf);
 }
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 1debb88..69f966f 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -503,6 +503,10 @@ static void rt2500usb_config_erp(struct rt2x00_dev *rt2x00dev,
 
 	rt2500usb_register_write(rt2x00dev, TXRX_CSR11, erp->basic_rates);
 
+	rt2500usb_register_read(rt2x00dev, TXRX_CSR18, &reg);
+	rt2x00_set_field16(&reg, TXRX_CSR18_INTERVAL, erp->beacon_int * 4);
+	rt2500usb_register_write(rt2x00dev, TXRX_CSR18, reg);
+
 	rt2500usb_register_write(rt2x00dev, MAC_CSR10, erp->slot_time);
 	rt2500usb_register_write(rt2x00dev, MAC_CSR11, erp->sifs);
 	rt2500usb_register_write(rt2x00dev, MAC_CSR12, erp->eifs);
@@ -632,17 +636,6 @@ static void rt2500usb_config_txpower(struct rt2x00_dev *rt2x00dev,
 	rt2500usb_rf_write(rt2x00dev, 3, rf3);
 }
 
-static void rt2500usb_config_duration(struct rt2x00_dev *rt2x00dev,
-				      struct rt2x00lib_conf *libconf)
-{
-	u16 reg;
-
-	rt2500usb_register_read(rt2x00dev, TXRX_CSR18, &reg);
-	rt2x00_set_field16(&reg, TXRX_CSR18_INTERVAL,
-			   libconf->conf->beacon_int * 4);
-	rt2500usb_register_write(rt2x00dev, TXRX_CSR18, reg);
-}
-
 static void rt2500usb_config_ps(struct rt2x00_dev *rt2x00dev,
 				struct rt2x00lib_conf *libconf)
 {
@@ -680,8 +673,6 @@ static void rt2500usb_config(struct rt2x00_dev *rt2x00dev,
 	    !(flags & IEEE80211_CONF_CHANGE_CHANNEL))
 		rt2500usb_config_txpower(rt2x00dev,
 					 libconf->conf->power_level);
-	if (flags & IEEE80211_CONF_CHANGE_BEACON_INTERVAL)
-		rt2500usb_config_duration(rt2x00dev, libconf);
 	if (flags & IEEE80211_CONF_CHANGE_PS)
 		rt2500usb_config_ps(rt2x00dev, libconf);
 }
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index aae7aa7..142ad34 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -616,6 +616,11 @@ static void rt2800usb_config_erp(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&reg, XIFS_TIME_CFG_EIFS, erp->eifs);
 	rt2x00_set_field32(&reg, XIFS_TIME_CFG_BB_RXEND_ENABLE, 1);
 	rt2x00usb_register_write(rt2x00dev, XIFS_TIME_CFG, reg);
+
+	rt2x00usb_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
+	rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_INTERVAL,
+			   erp->beacon_int * 16);
+	rt2x00usb_register_write(rt2x00dev, BCN_TIME_CFG, reg);
 }
 
 static void rt2800usb_config_ant(struct rt2x00_dev *rt2x00dev,
@@ -955,17 +960,6 @@ static void rt2800usb_config_retry_limit(struct rt2x00_dev *rt2x00dev,
 	rt2x00usb_register_write(rt2x00dev, TX_RTY_CFG, reg);
 }
 
-static void rt2800usb_config_duration(struct rt2x00_dev *rt2x00dev,
-				      struct rt2x00lib_conf *libconf)
-{
-	u32 reg;
-
-	rt2x00usb_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
-	rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_INTERVAL,
-			   libconf->conf->beacon_int * 16);
-	rt2x00usb_register_write(rt2x00dev, BCN_TIME_CFG, reg);
-}
-
 static void rt2800usb_config_ps(struct rt2x00_dev *rt2x00dev,
 				struct rt2x00lib_conf *libconf)
 {
@@ -1010,8 +1004,6 @@ static void rt2800usb_config(struct rt2x00_dev *rt2x00dev,
 		rt2800usb_config_txpower(rt2x00dev, libconf->conf->power_level);
 	if (flags & IEEE80211_CONF_CHANGE_RETRY_LIMITS)
 		rt2800usb_config_retry_limit(rt2x00dev, libconf);
-	if (flags & IEEE80211_CONF_CHANGE_BEACON_INTERVAL)
-		rt2800usb_config_duration(rt2x00dev, libconf);
 	if (flags & IEEE80211_CONF_CHANGE_PS)
 		rt2800usb_config_ps(rt2x00dev, libconf);
 }
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 419b1b9..2b64a61 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -417,6 +417,8 @@ struct rt2x00lib_erp {
 	short pifs;
 	short difs;
 	short eifs;
+
+	u16 beacon_int;
 };
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index 863e399..c5bbf0b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -106,6 +106,7 @@ void rt2x00lib_config_erp(struct rt2x00_dev *rt2x00dev,
 	}
 
 	erp.basic_rates = bss_conf->basic_rates;
+	erp.beacon_int = bss_conf->beacon_int;
 
 	rt2x00dev->ops->lib->config_erp(rt2x00dev, &erp);
 }
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index cb521ee..a8bf5c4 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -603,15 +603,22 @@ static void rt61pci_config_erp(struct rt2x00_dev *rt2x00dev,
 
 	rt2x00pci_register_read(rt2x00dev, TXRX_CSR0, &reg);
 	rt2x00_set_field32(&reg, TXRX_CSR0_RX_ACK_TIMEOUT, erp->ack_timeout);
+	rt2x00_set_field32(&reg, TXRX_CSR0_TSF_OFFSET, IEEE80211_HEADER);
 	rt2x00pci_register_write(rt2x00dev, TXRX_CSR0, reg);
 
 	rt2x00pci_register_read(rt2x00dev, TXRX_CSR4, &reg);
+	rt2x00_set_field32(&reg, TXRX_CSR4_AUTORESPOND_ENABLE, 1);
 	rt2x00_set_field32(&reg, TXRX_CSR4_AUTORESPOND_PREAMBLE,
 			   !!erp->short_preamble);
 	rt2x00pci_register_write(rt2x00dev, TXRX_CSR4, reg);
 
 	rt2x00pci_register_write(rt2x00dev, TXRX_CSR5, erp->basic_rates);
 
+	rt2x00pci_register_read(rt2x00dev, TXRX_CSR9, &reg);
+	rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_INTERVAL,
+			   erp->beacon_int * 16);
+	rt2x00pci_register_write(rt2x00dev, TXRX_CSR9, reg);
+
 	rt2x00pci_register_read(rt2x00dev, MAC_CSR9, &reg);
 	rt2x00_set_field32(&reg, MAC_CSR9_SLOT_TIME, erp->slot_time);
 	rt2x00pci_register_write(rt2x00dev, MAC_CSR9, reg);
@@ -938,25 +945,6 @@ static void rt61pci_config_retry_limit(struct rt2x00_dev *rt2x00dev,
 	rt2x00pci_register_write(rt2x00dev, TXRX_CSR4, reg);
 }
 
-static void rt61pci_config_duration(struct rt2x00_dev *rt2x00dev,
-				    struct rt2x00lib_conf *libconf)
-{
-	u32 reg;
-
-	rt2x00pci_register_read(rt2x00dev, TXRX_CSR0, &reg);
-	rt2x00_set_field32(&reg, TXRX_CSR0_TSF_OFFSET, IEEE80211_HEADER);
-	rt2x00pci_register_write(rt2x00dev, TXRX_CSR0, reg);
-
-	rt2x00pci_register_read(rt2x00dev, TXRX_CSR4, &reg);
-	rt2x00_set_field32(&reg, TXRX_CSR4_AUTORESPOND_ENABLE, 1);
-	rt2x00pci_register_write(rt2x00dev, TXRX_CSR4, reg);
-
-	rt2x00pci_register_read(rt2x00dev, TXRX_CSR9, &reg);
-	rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_INTERVAL,
-			   libconf->conf->beacon_int * 16);
-	rt2x00pci_register_write(rt2x00dev, TXRX_CSR9, reg);
-}
-
 static void rt61pci_config_ps(struct rt2x00_dev *rt2x00dev,
 				struct rt2x00lib_conf *libconf)
 {
@@ -1016,8 +1004,6 @@ static void rt61pci_config(struct rt2x00_dev *rt2x00dev,
 		rt61pci_config_txpower(rt2x00dev, libconf->conf->power_level);
 	if (flags & IEEE80211_CONF_CHANGE_RETRY_LIMITS)
 		rt61pci_config_retry_limit(rt2x00dev, libconf);
-	if (flags & IEEE80211_CONF_CHANGE_BEACON_INTERVAL)
-		rt61pci_config_duration(rt2x00dev, libconf);
 	if (flags & IEEE80211_CONF_CHANGE_PS)
 		rt61pci_config_ps(rt2x00dev, libconf);
 }
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 270dd4e..211a3d6 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -566,15 +566,22 @@ static void rt73usb_config_erp(struct rt2x00_dev *rt2x00dev,
 
 	rt2x00usb_register_read(rt2x00dev, TXRX_CSR0, &reg);
 	rt2x00_set_field32(&reg, TXRX_CSR0_RX_ACK_TIMEOUT, erp->ack_timeout);
+	rt2x00_set_field32(&reg, TXRX_CSR0_TSF_OFFSET, IEEE80211_HEADER);
 	rt2x00usb_register_write(rt2x00dev, TXRX_CSR0, reg);
 
 	rt2x00usb_register_read(rt2x00dev, TXRX_CSR4, &reg);
+	rt2x00_set_field32(&reg, TXRX_CSR4_AUTORESPOND_ENABLE, 1);
 	rt2x00_set_field32(&reg, TXRX_CSR4_AUTORESPOND_PREAMBLE,
 			   !!erp->short_preamble);
 	rt2x00usb_register_write(rt2x00dev, TXRX_CSR4, reg);
 
 	rt2x00usb_register_write(rt2x00dev, TXRX_CSR5, erp->basic_rates);
 
+	rt2x00usb_register_read(rt2x00dev, TXRX_CSR9, &reg);
+	rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_INTERVAL,
+			   erp->beacon_int * 16);
+	rt2x00usb_register_write(rt2x00dev, TXRX_CSR9, reg);
+
 	rt2x00usb_register_read(rt2x00dev, MAC_CSR9, &reg);
 	rt2x00_set_field32(&reg, MAC_CSR9_SLOT_TIME, erp->slot_time);
 	rt2x00usb_register_write(rt2x00dev, MAC_CSR9, reg);
@@ -834,25 +841,6 @@ static void rt73usb_config_retry_limit(struct rt2x00_dev *rt2x00dev,
 	rt2x00usb_register_write(rt2x00dev, TXRX_CSR4, reg);
 }
 
-static void rt73usb_config_duration(struct rt2x00_dev *rt2x00dev,
-				    struct rt2x00lib_conf *libconf)
-{
-	u32 reg;
-
-	rt2x00usb_register_read(rt2x00dev, TXRX_CSR0, &reg);
-	rt2x00_set_field32(&reg, TXRX_CSR0_TSF_OFFSET, IEEE80211_HEADER);
-	rt2x00usb_register_write(rt2x00dev, TXRX_CSR0, reg);
-
-	rt2x00usb_register_read(rt2x00dev, TXRX_CSR4, &reg);
-	rt2x00_set_field32(&reg, TXRX_CSR4_AUTORESPOND_ENABLE, 1);
-	rt2x00usb_register_write(rt2x00dev, TXRX_CSR4, reg);
-
-	rt2x00usb_register_read(rt2x00dev, TXRX_CSR9, &reg);
-	rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_INTERVAL,
-			   libconf->conf->beacon_int * 16);
-	rt2x00usb_register_write(rt2x00dev, TXRX_CSR9, reg);
-}
-
 static void rt73usb_config_ps(struct rt2x00_dev *rt2x00dev,
 				struct rt2x00lib_conf *libconf)
 {
@@ -906,8 +894,6 @@ static void rt73usb_config(struct rt2x00_dev *rt2x00dev,
 		rt73usb_config_txpower(rt2x00dev, libconf->conf->power_level);
 	if (flags & IEEE80211_CONF_CHANGE_RETRY_LIMITS)
 		rt73usb_config_retry_limit(rt2x00dev, libconf);
-	if (flags & IEEE80211_CONF_CHANGE_BEACON_INTERVAL)
-		rt73usb_config_duration(rt2x00dev, libconf);
 	if (flags & IEEE80211_CONF_CHANGE_PS)
 		rt73usb_config_ps(rt2x00dev, libconf);
 }
-- 
1.6.3

