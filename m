Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f226.google.com ([209.85.217.226]:49371 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755117AbZKEGAX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2009 01:00:23 -0500
Received: by gxk26 with SMTP id 26so5642984gxk.1
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2009 22:00:27 -0800 (PST)
Message-ID: <4AF269F9.4020107@lwfinger.net>
Date: Thu, 05 Nov 2009 00:00:25 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>, sidhayn@gmail.com,
	linux-wireless@vger.kernel.org, mcgrof@gmail.com,
	johannes@sipsolutions.net
Subject: Re: [PATCH] rtl8187: Fix kernel oops when device is removed when
 LEDS enabled (Bugzilla #14539)
References: <4af11879./IumKJ+RAbw7Zkq6%Larry.Finger@lwfinger.net> <20091104151132.GD12965@tuxdriver.com> <4AF1A3BD.1020009@lwfinger.net> <20091104165453.GH12965@tuxdriver.com> <4AF1C42E.7000808@lwfinger.net> <20091104184700.GK12965@tuxdriver.com>
In-Reply-To: <20091104184700.GK12965@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/04/2009 12:47 PM, John W. Linville wrote:
> 
> They are musings -- but feel free to be inspired! :-)
> 

I was somewhat inspired and tried the following alternative patch:

++++++++++++++++++++++++++++++++++++++++++++++++\

Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_leds.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_leds.c
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_leds.c
@@ -107,6 +107,9 @@ static void rtl8187_led_brightness_set(s
        struct ieee80211_hw *hw = led->dev;
        struct rtl8187_priv *priv = hw->priv;

+       /* detect shutting down */
+       if (priv->leds_off)
+               return;
        if (brightness == LED_OFF) {
                ieee80211_queue_delayed_work(hw, &priv->led_off, 0);
                /* The LED is off for 1/20 sec so that it just blinks. */
@@ -179,6 +182,7 @@ void rtl8187_leds_init(struct ieee80211_
                ledpin = LED_PIN_GPIO0;
        }

+       priv->leds_off = false;
        INIT_DELAYED_WORK(&priv->led_on, led_turn_on);
        INIT_DELAYED_WORK(&priv->led_off, led_turn_off);

@@ -210,6 +214,7 @@ void rtl8187_leds_exit(struct ieee80211_

        /* turn the LED off before exiting */
        ieee80211_queue_delayed_work(dev, &priv->led_off, 0);
+       priv->leds_off = true;
        cancel_delayed_work_sync(&priv->led_off);
        cancel_delayed_work_sync(&priv->led_on);
        rtl8187_unregister_led(&priv->led_rx);
Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187.h
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187.h
@@ -134,6 +134,7 @@ struct rtl8187_priv {
                __le32 bits32;
        } *io_dmabuf;
        bool rfkill_off;
+       bool leds_off;
 };

 void rtl8187_write_phy(struct ieee80211_hw *dev, u8 addr, u32 data);

++++++++++++++++++++++++++++++++++++++++++++++

Yes, I know it is white-space damaged. I do not want it being applied!

By adding a new variable that is set whenever the LED system is being
shutdown, the kernel no longer panics; however, the LED is not turned
off on shutdown, further confirmation that USB transfers take a long
time to happen. I could add an msleep() between queuing the led_off
work and setting the leds_off flag, but this just seems like extra
complexity. I think we should go with the counter-intuitive order on
the shutdown.

Larry
