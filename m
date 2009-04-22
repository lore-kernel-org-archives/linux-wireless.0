Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from promwad.com ([83.149.69.23]:38855 "EHLO promwad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755090AbZDVQxU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 12:53:20 -0400
Received: from mail.promwad.com ([195.222.85.229] helo=intranet.promwad.com)
	by promwad.com with esmtps (TLSv1:AES256-SHA:256)
	(Exim 4.63)
	(envelope-from <eugene.sobol@promwad.com>)
	id 1LwfhD-00038V-0E
	for linux-wireless@vger.kernel.org; Wed, 22 Apr 2009 19:53:15 +0300
Received: from ws-022.promwad.com ([192.168.10.122])
	by intranet.promwad.com with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <eugene.sobol@promwad.com>)
	id 1LwfhC-0004oZ-0X
	for linux-wireless@vger.kernel.org; Wed, 22 Apr 2009 19:53:14 +0300
From: Eugene Sobol <eugene.sobol@promwad.com>
To: linux-wireless@vger.kernel.org
Subject: Re: rtl8187 diversity
Date: Wed, 22 Apr 2009 19:53:23 +0300
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200904221953.23265.eugene.sobol@promwad.com> (sfid-20090422_185343_590312_7FD83CB2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello.

This is reworked patch for antenna diversity in rtl8187 compat wireless.
 - removed proc file system functionality 
 - reworked calculation of agc 
 - fixed codestyle
Next step I will create for 2.6.30 RC2 

-- 
BR, Eugene Sobol

diff -urN compat-wireless-2.6-old.orig/drivers/net/wireless/rtl8187_dev.c compat-wireless-2.6-old/drivers/net/wireless/rtl8187_dev.c
--- compat-wireless-2.6-old.orig/drivers/net/wireless/rtl8187_dev.c     2008-09-15 19:57:24.000000000 +0300
+++ compat-wireless-2.6-old/drivers/net/wireless/rtl8187_dev.c  2009-04-22 18:04:01.000000000 +0300
@@ -45,6 +45,9 @@
        {USB_DEVICE(0x03f0, 0xca02), .driver_info = DEVICE_RTL8187},
        /* Sitecom */
        {USB_DEVICE(0x0df6, 0x000d), .driver_info = DEVICE_RTL8187},
+
+       {USB_DEVICE(0x13d1, 0xabe6), .driver_info = DEVICE_RTL8187},
+
        {}
 };

@@ -257,6 +260,7 @@

        usb_fill_bulk_urb(urb, priv->udev, usb_sndbulkpipe(priv->udev, ep),
                          buf, skb->len, rtl8187_tx_cb, skb);
+       urb->transfer_flags |= URB_ZERO_PACKET;
        rc = usb_submit_urb(urb, GFP_ATOMIC);
        if (rc < 0) {
                usb_free_urb(urb);
@@ -320,6 +324,9 @@
                }
                rx_status.signal = signal;
                priv->signal = signal;
+
+               if (priv->ant_diversity_enabled)
+                       add_to_average_array(priv, hdr->agc);
        } else {
                struct rtl8187b_rx_hdr *hdr =
                        (typeof(hdr))(skb_tail_pointer(skb) - sizeof(*hdr));
@@ -555,6 +562,13 @@
        rtl818x_iowrite8(priv, (u8 *)0xFFFF, 0x60);
        rtl818x_iowrite8(priv, &priv->map->PGSELECT, reg);

+       if (priv->ant_diversity_enabled) {
+               INIT_DELAYED_WORK(&priv->antenna_work,
+                       sw_antenna_work_item_callback);
+               priv->ant_diversity.switch_to = 0;
+               switch_antenna(priv);
+       }
+
        return 0;
 }

@@ -724,6 +738,8 @@
        u32 reg;
        int ret;

+       priv->hw = dev;
+
        ret = (!priv->is_rtl8187b) ? rtl8187_init_hw(dev) :
                                     rtl8187b_init_hw(dev);
        if (ret)
@@ -836,6 +852,9 @@
        struct rtl8187_priv *priv = dev->priv;
        int i;

+       if (priv->ant_diversity_enabled)
+               sw_antenna_diversity_timer_callback(priv);
+
        if (priv->mode != NL80211_IFTYPE_MONITOR)
                return -EOPNOTSUPP;

@@ -867,6 +886,12 @@
        mutex_lock(&priv->conf_mutex);
        priv->mode = NL80211_IFTYPE_MONITOR;
        priv->vif = NULL;
+
+       if (priv->ant_diversity_enabled) {
+               del_timer_sync(&priv->sw_antenna_diversity_timer);
+               cancel_delayed_work(&priv->antenna_work);
+       }
+
        mutex_unlock(&priv->conf_mutex);
 }

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
+       }
+
+       average_old = average_current;
+       priv->sw_antenna_diversity_timer.expires = jiffies +
+               msecs_to_jiffies(ANTENNA_DIVERSITY_TIMER_PERIOD);
+       add_timer(&priv->sw_antenna_diversity_timer);
+}
+
+/*
+ * Change Antenna Switch.
+ */
+u8 switch_antenna(struct rtl8187_priv *priv)
+{
+       u8 b_antenna_switched = 0;
+       u8 u1b_antenna_index = priv->ant_diversity.switch_to;
+
+       switch (u1b_antenna_index) {
+       case 0:
+               /* main antenna */
+               /* Rx CCK. */
+               rtl8187_write_phy(priv->hw, 0x10, 0x0001009b);
+               /* Rx OFDM. */
+               rtl8187_write_phy(priv->hw, 0x26, 0x00000090);
+               /* Tx Antenna. */
+               rtl818x_iowrite16(priv, (__le16 *)ANTSEL, 0x0003);
+
+               b_antenna_switched = 1;
+               printk(KERN_INFO "switch to ANT1 antenna\n");
+       break;
+       case 1: /* switch(u1bAntennaIndex) */
+               /* Rx CCK. */
+               rtl8187_write_phy(priv->hw, 0x10, 0x000100db);
+               /* Rx OFDM. */
+               rtl8187_write_phy(priv->hw, 0x26, 0x00000010);
+               /* Tx Antenna. */
+               rtl818x_iowrite16(priv, (__le16 *)ANTSEL, 0x0000);
+
+               b_antenna_switched = 1;
+               printk(KERN_INFO "switch to AUX antenna\n");
+       break;
+       default:
+               printk(KERN_WARNING "[%s] unkown u_1b_antenna_index(%d)\n",
+                       __func__, u1b_antenna_index);
+       break;
+       } /* switch(u1bAntennaIndex) */
+
+       if (b_antenna_switched)
+               priv->ant_diversity.curr_ant_index = u1b_antenna_index;
+
+       return b_antenna_switched;
+}
+
+void sw_antenna_work_item_callback(struct work_struct *work)
+{
+       struct rtl8187_priv *priv = container_of(work,
+                                       struct rtl8187_priv, antenna_work.work);
+       switch_antenna(priv);
+}
+
 static const struct ieee80211_ops rtl8187_ops = {
        .tx                     = rtl8187_tx,
        .start                  = rtl8187_start,
@@ -1034,6 +1138,8 @@
        priv = dev->priv;
        priv->is_rtl8187b = (id->driver_info == DEVICE_RTL8187B);

+       priv->ant_diversity_enabled = 0;
+
        SET_IEEE80211_DEV(dev, &intf->dev);
        usb_set_intfdata(intf, dev);
        priv->udev = udev;
@@ -1123,6 +1229,7 @@
                        break;
                default:
                        chip_name = "RTL8187vB (default)";
+                       priv->ant_diversity_enabled = 1;
                }
        } else {
                /*
@@ -1210,6 +1317,15 @@
               wiphy_name(dev->wiphy), print_mac(mac, dev->wiphy->perm_addr),
               chip_name, priv->asic_rev, priv->rf->name);

+       if (priv->ant_diversity_enabled) {
+               init_timer(&priv->sw_antenna_diversity_timer);
+               memset(priv->ant_diversity.agc_array, 0,
+                               sizeof priv->ant_diversity);
+               priv->sw_antenna_diversity_timer.data = (unsigned long)priv;
+               priv->sw_antenna_diversity_timer.function =
+                               (void *)sw_antenna_diversity_timer_callback;
+       }
+
        return 0;

  err_free_dev:
diff -urN compat-wireless-2.6-old.orig/drivers/net/wireless/rtl8187.h compat-wireless-2.6-old/drivers/net/wireless/rtl8187.h
--- compat-wireless-2.6-old.orig/drivers/net/wireless/rtl8187.h 2008-09-04 00:04:20.000000000 +0300
+++ compat-wireless-2.6-old/drivers/net/wireless/rtl8187.h      2009-04-22 16:51:13.000000000 +0300
@@ -82,11 +82,24 @@
        DEVICE_RTL8187B
 };

+#define VAL_ARRAY_SIZE 10
+#define ANTSEL 0xFF9F
+
+struct rtl8187_ant_diversity {
+
+    int count;
+       u8 agc_array[VAL_ARRAY_SIZE];
+
+    u8 switch_to;
+    u8 curr_ant_index;
+} __attribute__ ((packed));
+
 struct rtl8187_priv {
        /* common between rtl818x drivers */
        struct rtl818x_csr *map;
        const struct rtl818x_rf_ops *rf;
        struct ieee80211_vif *vif;
+       struct ieee80211_hw *hw;
        int mode;
        /* The mutex protects the TX loopback state.
         * Any attempt to set channels concurrently locks the device.
@@ -112,8 +125,21 @@
        u8 signal;
        u8 quality;
        u8 noise;
+
+       u8 ant_diversity_enabled;
+       struct timer_list sw_antenna_diversity_timer;
+       struct rtl8187_ant_diversity ant_diversity;
+       struct delayed_work antenna_work;
+
 };

+static inline void add_to_average_array(struct rtl8187_priv *priv, u8 val)
+{
+       priv->ant_diversity.agc_array[priv->ant_diversity.count++] = val;
+       if (priv->ant_diversity.count >= VAL_ARRAY_SIZE)
+               priv->ant_diversity.count = 0;
+}
+
 void rtl8187_write_phy(struct ieee80211_hw *dev, u8 addr, u32 data);

 static inline u8 rtl818x_ioread8_idx(struct rtl8187_priv *priv,
@@ -218,4 +244,10 @@
        rtl818x_iowrite32_idx(priv, addr, val, 0);
 }

+void sw_antenna_diversity_timer_callback(struct rtl8187_priv *dev);
+
+u8 switch_antenna(struct rtl8187_priv *priv);
+
+void sw_antenna_work_item_callback(struct work_struct *work);
+
 #endif /* RTL8187_H */

