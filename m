Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost02.isp.att.net ([204.127.217.102]:59850 "EHLO
	fmailhost02.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbZDVTgI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 15:36:08 -0400
Message-ID: <49EF7190.7010004@lwfinger.net> (sfid-20090422_213614_123419_64A30C25)
Date: Wed, 22 Apr 2009 14:35:44 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Eugene Sobol <eugene.sobol@promwad.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: rtl8187 diversity
References: <200904221953.23265.eugene.sobol@promwad.com>
In-Reply-To: <200904221953.23265.eugene.sobol@promwad.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Eugene Sobol wrote:
> 
> This is reworked patch for antenna diversity in rtl8187 compat wireless.
>  - removed proc file system functionality 
>  - reworked calculation of agc 
>  - fixed codestyle
> Next step I will create for 2.6.30 RC2 

It would be better if the patch were made for wireless-testing, which contains
some changes that will not appear in mainline until 2.6.31.

--snip--

        {USB_DEVICE(0x03f0, 0xca02), .driver_info = DEVICE_RTL8187},
        /* Sitecom */
        {USB_DEVICE(0x0df6, 0x000d), .driver_info = DEVICE_RTL8187},
+

What is the vendor for your device? At http://www.linux-usb.org/usb.ids, this ID
is shown as belonging to A-MAX Technology Macao Commercial Offshore Co. Ltd.
That is quite a mouthful, and the above line might say "A-Max Technology",
unless you have a different vendor.

+       {USB_DEVICE(0x13d1, 0xabe6), .driver_info = DEVICE_RTL8187},
+

There should not be a blank line here.

--snip--

@@ -724,6 +738,8 @@
        u32 reg;
        int ret;

+       priv->hw = dev;

This will not be needed. See the comment in the patch for rtl8187.h.

--snip--

@@ -970,6 +995,85 @@
        rtl818x_iowrite32_async(priv, &priv->map->RX_CONF, priv->rx_conf);
 }

+#define ANTENNA_DIVERSITY_TIMER_PERIOD 1000
+#define ANTENNA_SWITCH_TIMER_PERIOD    300
+#define ANTENNA_MAX_AGC_DIFF 15
+void sw_antenna_diversity_timer_callback(struct rtl8187_priv *priv)
+{
+       static int average_old;
+       int average_current = 0;
+       int i, sub;
+
+       if (!priv->ant_diversity_enabled)
+               return;
+       for (i = 0; i < VAL_ARRAY_SIZE; ++i)
+               average_current += priv->ant_diversity.agc_array[i];
+
+       average_current /= VAL_ARRAY_SIZE;
+       sub = average_current - average_old;
+       if (sub > ANTENNA_MAX_AGC_DIFF) {
+               priv->ant_diversity.switch_to ^= 1;
+               queue_delayed_work(priv->hw->workqueue, &priv->antenna_work,
+                               msecs_to_jiffies(ANTENNA_SWITCH_TIMER_PERIOD));

Should be priv->dev->workqueue. Everywhere you have priv->hw, it should be
priv->dev.

--snip--

@@ -1123,6 +1229,7 @@
                        break;
                default:
                        chip_name = "RTL8187vB (default)";
+                       priv->ant_diversity_enabled = 1;

Is the default branch correct here? What is the value read from 0xFFE1? I'm
concerned that antenna diversity might be turned on for some unit that doesn't
support it.

The rtl8187se vendor driver in drivers/staging does the equivalent of:

        rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, \
		 RTL818X_EEPROM_CMD_CONFIG);
        if (rtl818x_ioread8(priv, &priv->map->CONFIG2) & 1 << 6)
		priv->ant_diversity_enabled = 1;
	else
		priv->ant_diversity_enabled = 0;

This method should be tested to see if it works for USB devices in general, and
yours in particular.

--snip--

 struct rtl8187_priv {
        /* common between rtl818x drivers */
        struct rtl818x_csr *map;
        const struct rtl818x_rf_ops *rf;
        struct ieee80211_vif *vif;
+       struct ieee80211_hw *hw;

Look about 15 lines down and see the "struct ieee80211hw *dev". It should be
used. It is badly named, but changing it would be disruptive.

Good work. This version is much improved.

Larry
