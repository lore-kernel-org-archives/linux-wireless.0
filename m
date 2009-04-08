Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from promwad.com ([83.149.69.23]:50906 "EHLO promwad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759684AbZDHM54 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2009 08:57:56 -0400
From: "eugene.sobol" <eugene.sobol@promwad.com>
To: linux-wireless@vger.kernel.org
Subject: Re: rtl8187 diversity
Date: Wed, 8 Apr 2009 15:30:51 +0300
Cc: ivan.kuten@promwad.com, hintak.leung@gmail.com
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_7jJ3JRjgw7GEktx"
Message-Id: <200904081530.51962.eugene.sobol@promwad.com> (sfid-20090408_145802_435278_58D3DA5E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_7jJ3JRjgw7GEktx
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello!

We are using RTL8187L module (with 2 antenna) from Abocom on our Blackfin DSP 
based board.
We have to enable antenna diversity for that module.

We have done some workaround realted with it:
I got compat-wireless archive from: 
http://wireless.kernel.org/download/compat-wireless-2.6/compat-wireless-old.tar.bz2
I added switch-antenna related code from rtl8187L_linux_26.1036.1105.2008 
driver.
I added simple logic how to evaluate quality of signal by AGC and switch 
between antennas.

Following code shows how does swiching between antennas work (from 
rtl8187L_linux_26.1036.1105.2008 ) :
+           write_nic_byte(priv, 0x7f, ((0x01009b90 & 0xff000000) >> 24));
+           write_nic_byte(priv, 0x7e, ((0x01009b90 & 0x00ff0000) >> 16));
+           write_nic_byte(priv, 0x7d, ((0x01009b90 & 0x0000ff00) >> 8));
+           write_nic_byte(priv, 0x7c, ((0x01009b90 & 0x000000ff) >> 0));
+
+           // Rx OFDM.
+           /* original code from realtek driver */
+           write_nic_byte(priv, 0x7f, ((0x000090a6 & 0xff000000) >> 24));
+           write_nic_byte(priv, 0x7e, ((0x000090a6 & 0x00ff0000) >> 16));
+           write_nic_byte(priv, 0x7d, ((0x000090a6 & 0x0000ff00) >> 8));
+           write_nic_byte(priv, 0x7c, ((0x000090a6 & 0x000000ff) >> 0));
+
+           // Tx Antenna.
+           /* original code from realtek driver */
+           write_nic_byte(priv, ANTSEL, 0x03); // Config TX antenna.

This is code example shows switching to one of two antennas. Other code you 
can see in attached patch.

During handling every packet, the AGC value recording to an array. Every 
second driver calculate average value from AGC's array and makes decision 
have to do switch to other antenna or not.

Compat drivers for chip on our board shows better results than 
rtl8187L_linux_26.1036.1105.2008 driver,
compat driver                                             ~ 800-1000Kbytes/sec
rtl8187L_linux_26.1036.1105.2008 driver ~ 200Kbytes/sec

Please correct me if I chose not correct parameter for evaluating signal 
quality information.

However while testing, the switching between antennas doesn't give any 
download speed improvements.
May be we missed some point.

Thank you.

Best Regards,
   Eugene Sobol

--Boundary-00=_7jJ3JRjgw7GEktx
Content-Type: text/x-diff;
  charset="iso 8859-15";
  name="rtl8187_antenna_diversity.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="rtl8187_antenna_diversity.patch"

diff -urN compat-wireless-2.6-old.orig/drivers/net/wireless/Makefile compat-wireless-2.6-old/drivers/net/wireless/Makefile
--- compat-wireless-2.6-old.orig/drivers/net/wireless/Makefile	2008-12-17 19:03:17.000000000 +0200
+++ compat-wireless-2.6-old/drivers/net/wireless/Makefile	2009-04-07 20:15:28.000000000 +0300
@@ -1,6 +1,7 @@
 #
 # Makefile for the Linux Wireless network device drivers.
 #
+EXTRA_CFLAGS += -DSW_ANTENNA_DIVERSITY
 
 obj-$(CONFIG_IPW2100) += ipw2100.o
 
diff -urN compat-wireless-2.6-old.orig/drivers/net/wireless/rtl8187_dev.c compat-wireless-2.6-old/drivers/net/wireless/rtl8187_dev.c
--- compat-wireless-2.6-old.orig/drivers/net/wireless/rtl8187_dev.c	2008-09-15 19:57:24.000000000 +0300
+++ compat-wireless-2.6-old/drivers/net/wireless/rtl8187_dev.c	2009-04-08 15:18:09.000000000 +0300
@@ -21,6 +21,8 @@
 #include <linux/etherdevice.h>
 #include <linux/eeprom_93cx6.h>
 #include <net/mac80211.h>
+#include <linux/proc_fs.h>      // for use the proc fs
+
 
 #include "rtl8187.h"
 #include "rtl8187_rtl8225.h"
@@ -45,6 +47,8 @@
 	{USB_DEVICE(0x03f0, 0xca02), .driver_info = DEVICE_RTL8187},
 	/* Sitecom */
 	{USB_DEVICE(0x0df6, 0x000d), .driver_info = DEVICE_RTL8187},
+	{USB_DEVICE(0x13d1, 0xabe6), .driver_info = DEVICE_RTL8187},
+
 	{}
 };
 
@@ -257,6 +261,7 @@
 
 	usb_fill_bulk_urb(urb, priv->udev, usb_sndbulkpipe(priv->udev, ep),
 			  buf, skb->len, rtl8187_tx_cb, skb);
+	urb->transfer_flags |= URB_ZERO_PACKET;
 	rc = usb_submit_urb(urb, GFP_ATOMIC);
 	if (rc < 0) {
 		usb_free_urb(urb);
@@ -266,6 +271,15 @@
 	return 0;
 }
 
+#ifdef SW_ANTENNA_DIVERSITY
+inline void add_to_average_array(struct rtl8187_priv * priv, u8 val)
+{
+    priv->ant_diversity.agc_array[ priv->ant_diversity.count++ ] = val;
+    if (priv->ant_diversity.count >= VAL_ARRAY_SIZE)
+        priv->ant_diversity.count = 0;
+}
+#endif /* SW_ANTENNA_DIVERSITY */
+
 static void rtl8187_rx_cb(struct urb *urb)
 {
 	struct sk_buff *skb = (struct sk_buff *)urb->context;
@@ -320,6 +334,9 @@
 		}
 		rx_status.signal = signal;
 		priv->signal = signal;
+#ifdef SW_ANTENNA_DIVERSITY
+        add_to_average_array(priv, hdr->agc);
+#endif /* SW_ANTENNA_DIVERSITY */
 	} else {
 		struct rtl8187b_rx_hdr *hdr =
 			(typeof(hdr))(skb_tail_pointer(skb) - sizeof(*hdr));
@@ -555,6 +572,13 @@
 	rtl818x_iowrite8(priv, (u8 *)0xFFFF, 0x60);
 	rtl818x_iowrite8(priv, &priv->map->PGSELECT, reg);
 
+#ifdef SW_ANTENNA_DIVERSITY 
+	INIT_DELAYED_WORK(&priv->antenna_work, SwAntennaWorkItemCallback);
+
+	priv->ant_diversity.switch_to = 0;
+	SwitchAntenna(priv);
+#endif /* SW_ANTENNA_DIVERSITY */
+
 	return 0;
 }
 
@@ -721,6 +745,8 @@
 static int rtl8187_start(struct ieee80211_hw *dev)
 {
 	struct rtl8187_priv *priv = dev->priv;
+
+	priv->hw = dev;
 	u32 reg;
 	int ret;
 
@@ -836,6 +862,10 @@
 	struct rtl8187_priv *priv = dev->priv;
 	int i;
 
+#ifdef SW_ANTENNA_DIVERSITY
+	sw_antenna_diversity_timer_callback(priv);
+#endif /* SW_ANTENNA_DIVERSITY */
+
 	if (priv->mode != NL80211_IFTYPE_MONITOR)
 		return -EOPNOTSUPP;
 
@@ -867,6 +897,12 @@
 	mutex_lock(&priv->conf_mutex);
 	priv->mode = NL80211_IFTYPE_MONITOR;
 	priv->vif = NULL;
+
+#ifdef SW_ANTENNA_DIVERSITY
+	del_timer_sync(&priv->sw_antenna_diversity_timer);
+	cancel_delayed_work(&priv->antenna_work);
+#endif /* SW_ANTENNA_DIVERSITY */
+
 	mutex_unlock(&priv->conf_mutex);
 }
 
@@ -970,6 +1006,127 @@
 	rtl818x_iowrite32_async(priv, &priv->map->RX_CONF, priv->rx_conf);
 }
 
+#ifdef SW_ANTENNA_DIVERSITY
+#define ANTENNA_DIVERSITY_TIMER_PERIOD          2000 // 1000 m
+#define ANTENNA_SWITCH_TIMER_PERIOD				300 // 300 m 
+void sw_antenna_diversity_timer_callback(struct rtl8187_priv *priv)
+{
+    static int tick_without_switch = 0;
+    static int old_value = 0;
+    int average = 0;
+    int i;
+    for ( i = 0; i < VAL_ARRAY_SIZE; ++i)
+    {
+        average += priv->ant_diversity.agc_array[i];
+    }
+    average /= VAL_ARRAY_SIZE;
+    average /= 10; // cut 1 chipher
+    printk("%d->%d\n", old_value, average);
+
+    int sub = average - old_value;
+    if (sub < 0)
+        sub *= -1;
+    if (average > old_value) 
+    {
+        priv->ant_diversity.switch_to ^= 1;    
+        queue_delayed_work(priv->hw->workqueue, &priv->antenna_work,
+                                    msecs_to_jiffies(ANTENNA_SWITCH_TIMER_PERIOD));
+    }
+    old_value = average;
+
+    priv->sw_antenna_diversity_timer.expires = jiffies + msecs_to_jiffies(ANTENNA_DIVERSITY_TIMER_PERIOD);
+	add_timer(&priv->sw_antenna_diversity_timer);
+
+}
+
+/*
+ * Change Antenna Switch.
+ */
+bool SwitchAntenna(struct rtl8187_priv *priv)
+{
+	u8 u1bAntennaIndex = priv->ant_diversity.switch_to;
+
+	bool bAntennaSwitched = false;
+	switch(u1bAntennaIndex)
+	{
+		case 0:
+		/* main antenna */
+			// Rx CCK.
+			/* original code from realtek driver */
+			write_nic_byte(priv, 0x7f, ((0x01009b90 & 0xff000000) >> 24));
+			write_nic_byte(priv, 0x7e, ((0x01009b90 & 0x00ff0000) >> 16));
+			write_nic_byte(priv, 0x7d, ((0x01009b90 & 0x0000ff00) >> 8));
+			write_nic_byte(priv, 0x7c, ((0x01009b90 & 0x000000ff) >> 0));
+
+			// Rx OFDM.
+			/* original code from realtek driver */
+			write_nic_byte(priv, 0x7f, ((0x000090a6 & 0xff000000) >> 24));
+			write_nic_byte(priv, 0x7e, ((0x000090a6 & 0x00ff0000) >> 16));
+			write_nic_byte(priv, 0x7d, ((0x000090a6 & 0x0000ff00) >> 8));
+			write_nic_byte(priv, 0x7c, ((0x000090a6 & 0x000000ff) >> 0));
+
+			// Tx Antenna.
+			/* original code from realtek driver */
+			write_nic_byte(priv, ANTSEL, 0x03); // Config TX antenna.
+
+			bAntennaSwitched = true;
+			printk("switch to ANT1 antenna\n");
+		break;
+		case 1: /* switch(u1bAntennaIndex) */
+			// Rx CCK.
+			/* original code from realtek driver */
+			write_nic_byte(priv, 0x7f, ((0x0100db90 & 0xff000000) >> 24));
+			write_nic_byte(priv, 0x7e, ((0x0100db90 & 0x00ff0000) >> 16));
+			write_nic_byte(priv, 0x7d, ((0x0100db90 & 0x0000ff00) >> 8));
+			write_nic_byte(priv, 0x7c, ((0x0100db90 & 0x000000ff) >> 0));
+
+			// Rx OFDM.
+			/* original code from realtek driver */
+			write_nic_byte(priv, 0x7f, ((0x000010a6 & 0xff000000) >> 24));
+			write_nic_byte(priv, 0x7e, ((0x000010a6 & 0x00ff0000) >> 16));
+			write_nic_byte(priv, 0x7d, ((0x000010a6 & 0x0000ff00) >> 8));
+			write_nic_byte(priv, 0x7c, ((0x000010a6 & 0x000000ff) >> 0));
+
+			// Tx Antenna.
+			/* original code from realtek driver */
+			write_nic_byte(priv, ANTSEL, 0x00); // Config TX antenna.
+
+			bAntennaSwitched = true;
+			printk("switch to AUX antenna\n");
+			break;
+		default:
+			printk("[%s] unkown u1bAntennaIndex(%d)\n", __FUNCTION__, u1bAntennaIndex);
+		break;
+	} /* switch(u1bAntennaIndex) */
+
+	if(bAntennaSwitched)
+	{
+		priv->ant_diversity.curr_ant_index = u1bAntennaIndex;
+	}
+
+	return bAntennaSwitched;
+}
+
+
+
+void write_nic_byte(struct rtl8187_priv *priv, int indx, u8 data)
+{
+        struct usb_device *udev = priv->udev;
+
+        usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
+                               RTL8187_REQ_SET_REG, RTL8187_REQT_WRITE,
+                               indx|0xff00, 0, &data, 1, HZ / 2);
+}
+
+void SwAntennaWorkItemCallback(struct work_struct *work)
+{
+	struct rtl8187_priv * priv = container_of(work, struct rtl8187_priv, antenna_work.work);
+	SwitchAntenna(priv);
+}
+
+
+#endif /* SW_ANTENNA_DIVERSITY */
+
 static const struct ieee80211_ops rtl8187_ops = {
 	.tx			= rtl8187_tx,
 	.start			= rtl8187_start,
@@ -981,6 +1138,52 @@
 	.configure_filter	= rtl8187_configure_filter,
 };
 
+#ifdef SW_ANTENNA_DIVERSITY
+
+#define procfs_name_in "antenna_diversity"
+int procfile_write(struct file *file, const char *buffer, unsigned long count, void* data)
+{
+    struct rtl8187_priv *priv = (struct rtl8187_priv *)data;
+    if (strncmp(buffer, "ANT1", 4) == 0)
+    {    
+        priv->ant_diversity.switch_to = 0;
+        queue_delayed_work(priv->hw->workqueue, &priv->antenna_work,
+                                    msecs_to_jiffies(ANTENNA_SWITCH_TIMER_PERIOD));
+    }
+    else if (strncmp(buffer, "AUX", 3) == 0)
+    {
+        priv->ant_diversity.switch_to = 1;
+        queue_delayed_work(priv->hw->workqueue, &priv->antenna_work,
+                                   msecs_to_jiffies(ANTENNA_SWITCH_TIMER_PERIOD));
+    }
+    return count;
+}
+
+int init_module_proc(struct rtl8187_priv *priv)
+{
+    struct proc_dir_entry *proc_file;
+
+    proc_file = create_proc_entry(procfs_name_in, 0644, NULL);
+
+    if (proc_file == NULL)
+    {
+        printk(KERN_ALERT "Error: Could not initialize /proc/%s\n", procfs_name_in);
+        return -ENOMEM;
+    }
+
+    proc_file->write_proc = procfile_write;
+    proc_file->owner      = THIS_MODULE;
+    proc_file->mode       = S_IFREG | S_IRUGO;
+    proc_file->uid        = 0;
+    proc_file->gid        = 0;
+    proc_file->size       = 0;
+    proc_file->data       =  priv;
+    printk(KERN_INFO "/proc/%s created\n", procfs_name_in);
+    return 0;
+}
+
+#endif //SW_ANTENNA_DIVERSITY
+
 static void rtl8187_eeprom_register_read(struct eeprom_93cx6 *eeprom)
 {
 	struct ieee80211_hw *dev = eeprom->data;
@@ -1209,6 +1412,13 @@
 	printk(KERN_INFO "%s: hwaddr %s, %s V%d + %s\n",
 	       wiphy_name(dev->wiphy), print_mac(mac, dev->wiphy->perm_addr),
 	       chip_name, priv->asic_rev, priv->rf->name);
+#ifdef SW_ANTENNA_DIVERSITY
+	#warning ANTENNA DIVERSITY enabled
+    init_module_proc(priv);
+	init_timer(&priv->sw_antenna_diversity_timer);
+	priv->sw_antenna_diversity_timer.data = (unsigned long)priv;
+	priv->sw_antenna_diversity_timer.function = (void *)sw_antenna_diversity_timer_callback;
+#endif /* SW_ANTENNA_DIVERSITY */
 
 	return 0;
 
diff -urN compat-wireless-2.6-old.orig/drivers/net/wireless/rtl8187.h compat-wireless-2.6-old/drivers/net/wireless/rtl8187.h
--- compat-wireless-2.6-old.orig/drivers/net/wireless/rtl8187.h	2008-09-04 00:04:20.000000000 +0300
+++ compat-wireless-2.6-old/drivers/net/wireless/rtl8187.h	2009-04-07 19:53:37.000000000 +0300
@@ -82,11 +82,28 @@
 	DEVICE_RTL8187B
 };
 
+#ifdef SW_ANTENNA_DIVERSITY
+
+#define VAL_ARRAY_SIZE 10
+
+#define ANTSEL 0x9F
+
+struct rtl8187_ant_diversity {
+	int count;
+	u8 agc_array[VAL_ARRAY_SIZE];
+
+    u8 switch_to;
+    u8 curr_ant_index;
+} __attribute__ ((packed));
+
+#endif /* SW_ANTENNA_DIVERSITY */
+
 struct rtl8187_priv {
 	/* common between rtl818x drivers */
 	struct rtl818x_csr *map;
 	const struct rtl818x_rf_ops *rf;
 	struct ieee80211_vif *vif;
+	struct ieee80211_hw *hw;
 	int mode;
 	/* The mutex protects the TX loopback state.
 	 * Any attempt to set channels concurrently locks the device.
@@ -112,6 +129,13 @@
 	u8 signal;
 	u8 quality;
 	u8 noise;
+
+#ifdef SW_ANTENNA_DIVERSITY
+	struct timer_list sw_antenna_diversity_timer;
+	struct rtl8187_ant_diversity ant_diversity;
+	struct delayed_work antenna_work;
+#endif /* SW_ANTENNA_DIVERSITY */
+
 };
 
 void rtl8187_write_phy(struct ieee80211_hw *dev, u8 addr, u32 data);
@@ -218,4 +242,20 @@
 	rtl818x_iowrite32_idx(priv, addr, val, 0);
 }
 
+void rtl8187_bss_info_changed(struct ieee80211_hw *hw,
+								struct ieee80211_vif *vif,
+								struct ieee80211_bss_conf *bss_conf,
+								u32 changes);
+#ifdef SW_ANTENNA_DIVERSITY
+
+void sw_antenna_diversity_timer_callback(struct rtl8187_priv *dev);
+
+bool SwitchAntenna(struct rtl8187_priv *priv);
+
+void write_nic_byte(struct rtl8187_priv *priv, int indx, u8 data);
+
+void SwAntennaWorkItemCallback(struct work_struct *work);
+
+#endif /* SW_ANTENNA_DIVERSITY */
+
 #endif /* RTL8187_H */

--Boundary-00=_7jJ3JRjgw7GEktx--
