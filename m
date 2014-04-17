Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:44051 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756318AbaDQN1x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2014 09:27:53 -0400
Received: by mail-pa0-f54.google.com with SMTP id lf10so381445pab.13
        for <linux-wireless@vger.kernel.org>; Thu, 17 Apr 2014 06:27:53 -0700 (PDT)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: <linux-wireless@vger.kernel.org>
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3/6] adm8211: replace wiphy_debug() with wiphy_dbg()
Date: Thu, 17 Apr 2014 21:27:11 +0800
Message-Id: <8afc1980a6de073836b091dc8ef5d9f13f25a814.1397741141.git.gamerh2o@gmail.com> (sfid-20140417_152756_504862_EBF9CC7A)
In-Reply-To: <d0cc78c16143f5f54ebcfc4a71e340d8c646aa82.1397741141.git.gamerh2o@gmail.com>
References: <d0cc78c16143f5f54ebcfc4a71e340d8c646aa82.1397741141.git.gamerh2o@gmail.com>
In-Reply-To: <d0cc78c16143f5f54ebcfc4a71e340d8c646aa82.1397741141.git.gamerh2o@gmail.com>
References: <d0cc78c16143f5f54ebcfc4a71e340d8c646aa82.1397741141.git.gamerh2o@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dynamic debug function wiphy_dbg() is more convenient for debugging,
and if user doesn't enable CONFIG_DYNAMIC_DEBUG, it will fall back to
normal static debug, just as what wiphy_debug() does.

When all the users of wiphy_debug() are gone, wiphy_debug() can be
removed.

Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
---
 drivers/net/wireless/adm8211.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
index f35f93c..434e3514 100644
--- a/drivers/net/wireless/adm8211.c
+++ b/drivers/net/wireless/adm8211.c
@@ -374,8 +374,8 @@ static void adm8211_interrupt_rci(struct ieee80211_hw *dev)
 		pktlen = status & RDES0_STATUS_FL;
 		if (pktlen > RX_PKT_SIZE) {
 			if (net_ratelimit())
-				wiphy_debug(dev->wiphy, "frame too long (%d)\n",
-					    pktlen);
+				wiphy_dbg(dev->wiphy, "frame too long (%d)\n",
+					  pktlen);
 			pktlen = RX_PKT_SIZE;
 		}
 
@@ -458,7 +458,7 @@ static irqreturn_t adm8211_interrupt(int irq, void *dev_id)
 #define ADM8211_INT(x)						\
 do {								\
 	if (unlikely(stsr & ADM8211_STSR_ ## x))		\
-		wiphy_debug(dev->wiphy, "%s\n", #x);		\
+		wiphy_dbg(dev->wiphy, "%s\n", #x);		\
 } while (0)
 
 	struct ieee80211_hw *dev = dev_id;
@@ -571,9 +571,9 @@ static int adm8211_write_bbp(struct ieee80211_hw *dev, u8 addr, u8 data)
 	}
 
 	if (timeout == 0) {
-		wiphy_debug(dev->wiphy,
-			    "adm8211_write_bbp(%d,%d) failed prewrite (reg=0x%08x)\n",
-			    addr, data, reg);
+		wiphy_dbg(dev->wiphy,
+			  "adm8211_write_bbp(%d,%d) failed prewrite (reg=0x%08x)\n",
+			  addr, data, reg);
 		return -ETIMEDOUT;
 	}
 
@@ -606,9 +606,9 @@ static int adm8211_write_bbp(struct ieee80211_hw *dev, u8 addr, u8 data)
 	if (timeout == 0) {
 		ADM8211_CSR_WRITE(BBPCTL, ADM8211_CSR_READ(BBPCTL) &
 				  ~ADM8211_BBPCTL_WR);
-		wiphy_debug(dev->wiphy,
-			    "adm8211_write_bbp(%d,%d) failed postwrite (reg=0x%08x)\n",
-			    addr, data, reg);
+		wiphy_dbg(dev->wiphy,
+			  "adm8211_write_bbp(%d,%d) failed postwrite (reg=0x%08x)\n",
+			  addr, data, reg);
 		return -ETIMEDOUT;
 	}
 
@@ -676,8 +676,8 @@ static int adm8211_rf_set_channel(struct ieee80211_hw *dev, unsigned int chan)
 		break;
 
 	default:
-		wiphy_debug(dev->wiphy, "unsupported transceiver type %d\n",
-			    priv->transceiver_type);
+		wiphy_dbg(dev->wiphy, "unsupported transceiver type %d\n",
+			  priv->transceiver_type);
 		break;
 	}
 
@@ -733,8 +733,8 @@ static int adm8211_rf_set_channel(struct ieee80211_hw *dev, unsigned int chan)
 
 	/* Nothing to do for ADMtek BBP */
 	} else if (priv->bbp_type != ADM8211_TYPE_ADMTEK)
-		wiphy_debug(dev->wiphy, "unsupported BBP type %d\n",
-			    priv->bbp_type);
+		wiphy_dbg(dev->wiphy, "unsupported BBP type %d\n",
+			  priv->bbp_type);
 
 	ADM8211_RESTORE();
 
@@ -1028,12 +1028,12 @@ static int adm8211_hw_init_bbp(struct ieee80211_hw *dev)
 			break;
 
 		default:
-			wiphy_debug(dev->wiphy, "unsupported transceiver %d\n",
-				    priv->transceiver_type);
+			wiphy_dbg(dev->wiphy, "unsupported transceiver %d\n",
+				  priv->transceiver_type);
 			break;
 		}
 	} else
-		wiphy_debug(dev->wiphy, "unsupported BBP %d\n", priv->bbp_type);
+		wiphy_dbg(dev->wiphy, "unsupported BBP %d\n", priv->bbp_type);
 
 	ADM8211_CSR_WRITE(SYNRF, 0);
 
-- 
1.9.0

