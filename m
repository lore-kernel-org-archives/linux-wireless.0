Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2133 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613AbXB0VFK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Feb 2007 16:05:10 -0500
Date: Tue, 27 Feb 2007 15:51:39 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: jeff@garzik.org
Cc: linux-wireless@vger.kernel.org
Subject: Please pull 'upstream' branch of wireless-2.6
Message-ID: <20070227205139.GG5826@tuxdriver.com>
References: <20070227205045.GF5826@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070227205045.GF5826@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following changes since commit 357efd57f229716fd6a1494b970c5a66c0c465ef:
  Stefano Brivio (1):
        bcm43xx: fix for 4309

are found in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git upstream

John W. Linville (1):
      wireless: remove obsolete text files

Larry Finger (1):
      bcm43xx: Update Documentation/bcm43xx.txt

Pavel Roskin (1):
      Use offsetof() instead of own equivalent

Ulrich Kunitz (1):
      zd1211rw: changed GFP_NOFS to GFP_KERNEL

Zhu Yi (1):
      ipw2200: add channels sysfs entry

 Documentation/networking/bcm43xx.txt        |   97 +++++++++++++++++++++------
 drivers/net/wireless/README                 |   25 -------
 drivers/net/wireless/hostap/hostap_common.h |    4 +-
 drivers/net/wireless/ipw2200.c              |   47 +++++++++++++
 drivers/net/wireless/todo.txt               |   15 ----
 drivers/net/wireless/zd1211rw/zd_chip.c     |    4 +-
 drivers/net/wireless/zd1211rw/zd_usb.c      |   20 +++---
 7 files changed, 136 insertions(+), 76 deletions(-)
 delete mode 100644 drivers/net/wireless/README
 delete mode 100644 drivers/net/wireless/todo.txt

diff --git a/Documentation/networking/bcm43xx.txt b/Documentation/networking/bcm43xx.txt
index 28541d2..a136721 100644
--- a/Documentation/networking/bcm43xx.txt
+++ b/Documentation/networking/bcm43xx.txt
@@ -2,35 +2,88 @@
 			BCM43xx Linux Driver Project
 			============================
 
-About this software
--------------------
+Introduction
+------------
 
-The goal of this project is to develop a linux driver for Broadcom
-BCM43xx chips, based on the specification at 
-http://bcm-specs.sipsolutions.net/
+Many of the wireless devices found in modern notebook computers are
+based on the wireless chips produced by Broadcom. These devices have
+been a problem for Linux users as there is no open-source driver
+available. In addition, Broadcom has not released specifications
+for the device, and driver availability has been limited to the
+binary-only form used in the GPL versions of AP hardware such as the
+Linksys WRT54G, and the Windows and OS X drivers.  Before this project
+began, the only way to use these devices were to use the Windows or
+OS X drivers with either the Linuxant or ndiswrapper modules. There
+is a strong penalty if this method is used as loading the binary-only
+module "taints" the kernel, and no kernel developer will help diagnose
+any kernel problems.
 
-The project page is http://bcm43xx.berlios.de/
+Development
+-----------
 
+This driver has been developed using
+a clean-room technique that is described at
+http://bcm-specs.sipsolutions.net/ReverseEngineeringProcess. For legal
+reasons, none of the clean-room crew works on the on the Linux driver,
+and none of the Linux developers sees anything but the specifications,
+which are the ultimate product of the reverse-engineering group.
 
-Requirements
-------------
+Software
+--------
+
+Since the release of the 2.6.17 kernel, the bcm43xx driver has been
+distributed with the kernel source, and is prebuilt in most, if not
+all, distributions.  There is, however, additional software that is
+required. The firmware used by the chip is the intellectual property
+of Broadcom and they have not given the bcm43xx team redistribution
+rights to this firmware.  Since we cannot legally redistribute
+the firwmare we cannot include it with the driver. Furthermore, it
+cannot be placed in the downloadable archives of any distributing
+organization; therefore, the user is responsible for obtaining the
+firmware and placing it in the appropriate location so that the driver
+can find it when initializing.
+
+To help with this process, the bcm43xx developers provide a separate
+program named bcm43xx-fwcutter to "cut" the firmware out of a
+Windows or OS X driver and write the extracted files to the proper
+location. This program is usually provided with the distribution;
+however, it may be downloaded from
+
+http://developer.berlios.de/project/showfiles.php?group_id=4547
 
-1)	Linux Kernel 2.6.16 or later
-	http://www.kernel.org/
+The firmware is available in two versions. V3 firmware is used with
+the in-kernel bcm43xx driver that uses a software MAC layer called
+SoftMAC, and will have a microcode revision of 0x127 or smaller. The
+V4 firmware is used by an out-of-kernel driver employing a variation of
+the Devicescape MAC layer known as d80211. Once bcm43xx-d80211 reaches
+a satisfactory level of development, it will replace bcm43xx-softmac
+in the kernel as it is much more flexible and powerful.
 
-	You may want to configure your kernel with:
+A source for the latest V3 firmware is
 
-	CONFIG_DEBUG_FS (optional):
-		-> Kernel hacking
-		  -> Debug Filesystem
+http://downloads.openwrt.org/sources/wl_apsta-3.130.20.0.o
 
-2)	SoftMAC IEEE 802.11 Networking Stack extension and patched ieee80211
-	modules:
-	http://softmac.sipsolutions.net/
+Once this file is downloaded, the command
+'bcm43xx-fwcutter -w <dir> <filename>'
+will extract the microcode and write it to directory
+<dir>. The correct directory will depend on your distribution;
+however, most use '/lib/firmware'. Once this step is completed,
+the bcm3xx driver should load when the system is booted. To see
+any messages relating to the driver, issue the command 'dmesg |
+grep bcm43xx' from a terminal window. If there are any problems,
+please send that output to Bcm43xx-dev@lists.berlios.de.
 
-3)	Firmware Files
+Although the driver has been in-kernel since 2.6.17, the earliest
+version is quite limited in its capability. Patches that include
+all features of later versions are available for the stable kernel
+versions from 2.6.18. These will be needed if you use a BCM4318,
+or a PCI Express version (BCM4311 and BCM4312). In addition, if you
+have an early BCM4306 and more than 1 GB RAM, your kernel will need
+to be patched.	These patches, which are being updated regularly,
+are available at ftp://lwfinger.dynalias.org/patches. Look for
+combined_2.6.YY.patch. Of course you will need kernel source downloaded
+from kernel.org, or the source from your distribution.
 
-	Please try fwcutter. Fwcutter can extract the firmware from various 
-	binary driver files. It supports driver files from Windows, MacOS and 
-	Linux. You can get fwcutter from http://bcm43xx.berlios.de/.
-	Also, fwcutter comes with a README file for further instructions.
+If you build your own kernel, please enable CONFIG_BCM43XX_DEBUG
+and CONFIG_IEEE80211_SOFTMAC_DEBUG. The log information provided is
+essential for solving any problems.
diff --git a/drivers/net/wireless/README b/drivers/net/wireless/README
deleted file mode 100644
index 0c274bf..0000000
--- a/drivers/net/wireless/README
+++ /dev/null
@@ -1,25 +0,0 @@
-	README
-	------
-
-	This directory is mostly for Wireless LAN drivers, in their
-various incarnations (ISA, PCI, Pcmcia...).
-	This separate directory is needed because a lot of driver work
-on different bus (typically PCI + Pcmcia) and share 95% of the
-code. This allow the code and the config options to be in one single
-place instead of scattered all over the driver tree, which is never
-100% satisfactory.
-
-	Note : if you want more info on the topic of Wireless LANs,
-you are kindly invited to have a look at the Wireless Howto :
-		http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/
-	Some Wireless LAN drivers, like orinoco_cs, require the use of
-Wireless Tools to be configured :
-		http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/Tools.html
-
-	Special notes for distribution maintainers :
-	1) wvlan_cs will be discontinued soon in favor of orinoco_cs
-	2) Please add Wireless Tools support in your scripts
-
-	Have fun...
-
-	Jean
diff --git a/drivers/net/wireless/hostap/hostap_common.h b/drivers/net/wireless/hostap/hostap_common.h
index 0162400..b31e6a0 100644
--- a/drivers/net/wireless/hostap/hostap_common.h
+++ b/drivers/net/wireless/hostap/hostap_common.h
@@ -368,9 +368,9 @@ enum {
 
 #define PRISM2_HOSTAPD_MAX_BUF_SIZE 1024
 #define PRISM2_HOSTAPD_RID_HDR_LEN \
-((int) (&((struct prism2_hostapd_param *) 0)->u.rid.data))
+offsetof(struct prism2_hostapd_param, u.rid.data)
 #define PRISM2_HOSTAPD_GENERIC_ELEMENT_HDR_LEN \
-((int) (&((struct prism2_hostapd_param *) 0)->u.generic_elem.data))
+offsetof(struct prism2_hostapd_param, u.generic_elem.data)
 
 /* Maximum length for algorithm names (-1 for nul termination) used in ioctl()
  */
diff --git a/drivers/net/wireless/ipw2200.c b/drivers/net/wireless/ipw2200.c
index c878a2f..99c517a 100644
--- a/drivers/net/wireless/ipw2200.c
+++ b/drivers/net/wireless/ipw2200.c
@@ -1847,6 +1847,52 @@ static ssize_t store_net_stats(struct device *d, struct device_attribute *attr,
 static DEVICE_ATTR(net_stats, S_IWUSR | S_IRUGO,
 		   show_net_stats, store_net_stats);
 
+static ssize_t show_channels(struct device *d,
+			     struct device_attribute *attr,
+			     char *buf)
+{
+	struct ipw_priv *priv = dev_get_drvdata(d);
+	const struct ieee80211_geo *geo = ipw_get_geo(priv->ieee);
+	int len = 0, i;
+
+	len = sprintf(&buf[len],
+		      "Displaying %d channels in 2.4Ghz band "
+		      "(802.11bg):\n", geo->bg_channels);
+
+	for (i = 0; i < geo->bg_channels; i++) {
+		len += sprintf(&buf[len], "%d: BSS%s%s, %s, Band %s.\n",
+			       geo->bg[i].channel,
+			       geo->bg[i].flags & IEEE80211_CH_RADAR_DETECT ?
+			       " (radar spectrum)" : "",
+			       ((geo->bg[i].flags & IEEE80211_CH_NO_IBSS) ||
+				(geo->bg[i].flags & IEEE80211_CH_RADAR_DETECT))
+			       ? "" : ", IBSS",
+			       geo->bg[i].flags & IEEE80211_CH_PASSIVE_ONLY ?
+			       "passive only" : "active/passive",
+			       geo->bg[i].flags & IEEE80211_CH_B_ONLY ?
+			       "B" : "B/G");
+	}
+
+	len += sprintf(&buf[len],
+		       "Displaying %d channels in 5.2Ghz band "
+		       "(802.11a):\n", geo->a_channels);
+	for (i = 0; i < geo->a_channels; i++) {
+		len += sprintf(&buf[len], "%d: BSS%s%s, %s.\n",
+			       geo->a[i].channel,
+			       geo->a[i].flags & IEEE80211_CH_RADAR_DETECT ?
+			       " (radar spectrum)" : "",
+			       ((geo->a[i].flags & IEEE80211_CH_NO_IBSS) ||
+				(geo->a[i].flags & IEEE80211_CH_RADAR_DETECT))
+			       ? "" : ", IBSS",
+			       geo->a[i].flags & IEEE80211_CH_PASSIVE_ONLY ?
+			       "passive only" : "active/passive");
+	}
+
+	return len;
+}
+
+static DEVICE_ATTR(channels, S_IRUSR, show_channels, NULL);
+
 static void notify_wx_assoc_event(struct ipw_priv *priv)
 {
 	union iwreq_data wrqu;
@@ -11383,6 +11429,7 @@ static struct attribute *ipw_sysfs_entries[] = {
 	&dev_attr_led.attr,
 	&dev_attr_speed_scan.attr,
 	&dev_attr_net_stats.attr,
+	&dev_attr_channels.attr,
 #ifdef CONFIG_IPW2200_PROMISCUOUS
 	&dev_attr_rtap_iface.attr,
 	&dev_attr_rtap_filter.attr,
diff --git a/drivers/net/wireless/todo.txt b/drivers/net/wireless/todo.txt
deleted file mode 100644
index 3223401..0000000
--- a/drivers/net/wireless/todo.txt
+++ /dev/null
@@ -1,15 +0,0 @@
-	Wireless Todo
-	-------------
-
-1) Bring other kernel Wireless LAN drivers here
-	Completed
-
-2) Bring new Wireless LAN driver not yet in the kernel there
-	See my web page for details
-	In particular : HostAP
-
-3) Misc
-	o Mark wavelan, wavelan_cs, netwave_cs drivers as obsolete
-	o Maybe arlan.c, ray_cs.c and strip.c also deserve to be obsolete
-
-	Jean II
diff --git a/drivers/net/wireless/zd1211rw/zd_chip.c b/drivers/net/wireless/zd1211rw/zd_chip.c
index 9c64f89..f97288d 100644
--- a/drivers/net/wireless/zd1211rw/zd_chip.c
+++ b/drivers/net/wireless/zd1211rw/zd_chip.c
@@ -114,7 +114,7 @@ int zd_ioread32v_locked(struct zd_chip *chip, u32 *values, const zd_addr_t *addr
 	/* Allocate a single memory block for values and addresses. */
 	count16 = 2*count;
 	a16 = (zd_addr_t *) kmalloc(count16 * (sizeof(zd_addr_t) + sizeof(u16)),
-		                   GFP_NOFS);
+		                   GFP_KERNEL);
 	if (!a16) {
 		dev_dbg_f(zd_chip_dev(chip),
 			  "error ENOMEM in allocation of a16\n");
@@ -163,7 +163,7 @@ int _zd_iowrite32v_locked(struct zd_chip *chip, const struct zd_ioreq32 *ioreqs,
 
 	/* Allocate a single memory block for values and addresses. */
 	count16 = 2*count;
-	ioreqs16 = kmalloc(count16 * sizeof(struct zd_ioreq16), GFP_NOFS);
+	ioreqs16 = kmalloc(count16 * sizeof(struct zd_ioreq16), GFP_KERNEL);
 	if (!ioreqs16) {
 		r = -ENOMEM;
 		dev_dbg_f(zd_chip_dev(chip),
diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index aac8a1c..5e67106 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -412,7 +412,7 @@ int zd_usb_enable_int(struct zd_usb *usb)
 
 	dev_dbg_f(zd_usb_dev(usb), "\n");
 
-	urb = usb_alloc_urb(0, GFP_NOFS);
+	urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!urb) {
 		r = -ENOMEM;
 		goto out;
@@ -430,7 +430,7 @@ int zd_usb_enable_int(struct zd_usb *usb)
 
 	/* TODO: make it a DMA buffer */
 	r = -ENOMEM;
-	transfer_buffer = kmalloc(USB_MAX_EP_INT_BUFFER, GFP_NOFS);
+	transfer_buffer = kmalloc(USB_MAX_EP_INT_BUFFER, GFP_KERNEL);
 	if (!transfer_buffer) {
 		dev_dbg_f(zd_usb_dev(usb),
 			"couldn't allocate transfer_buffer\n");
@@ -444,7 +444,7 @@ int zd_usb_enable_int(struct zd_usb *usb)
 			 intr->interval);
 
 	dev_dbg_f(zd_usb_dev(usb), "submit urb %p\n", intr->urb);
-	r = usb_submit_urb(urb, GFP_NOFS);
+	r = usb_submit_urb(urb, GFP_KERNEL);
 	if (r) {
 		dev_dbg_f(zd_usb_dev(usb),
 			 "Couldn't submit urb. Error number %d\n", r);
@@ -593,10 +593,10 @@ static struct urb *alloc_urb(struct zd_usb *usb)
 	struct urb *urb;
 	void *buffer;
 
-	urb = usb_alloc_urb(0, GFP_NOFS);
+	urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!urb)
 		return NULL;
-	buffer = usb_buffer_alloc(udev, USB_MAX_RX_SIZE, GFP_NOFS,
+	buffer = usb_buffer_alloc(udev, USB_MAX_RX_SIZE, GFP_KERNEL,
 		                  &urb->transfer_dma);
 	if (!buffer) {
 		usb_free_urb(urb);
@@ -629,7 +629,7 @@ int zd_usb_enable_rx(struct zd_usb *usb)
 	dev_dbg_f(zd_usb_dev(usb), "\n");
 
 	r = -ENOMEM;
-	urbs = kcalloc(URBS_COUNT, sizeof(struct urb *), GFP_NOFS);
+	urbs = kcalloc(URBS_COUNT, sizeof(struct urb *), GFP_KERNEL);
 	if (!urbs)
 		goto error;
 	for (i = 0; i < URBS_COUNT; i++) {
@@ -650,7 +650,7 @@ int zd_usb_enable_rx(struct zd_usb *usb)
 	spin_unlock_irq(&rx->lock);
 
 	for (i = 0; i < URBS_COUNT; i++) {
-		r = usb_submit_urb(urbs[i], GFP_NOFS);
+		r = usb_submit_urb(urbs[i], GFP_KERNEL);
 		if (r)
 			goto error_submit;
 	}
@@ -1156,7 +1156,7 @@ int zd_usb_ioread16v(struct zd_usb *usb, u16 *values,
 	}
 
 	req_len = sizeof(struct usb_req_read_regs) + count * sizeof(__le16);
-	req = kmalloc(req_len, GFP_NOFS);
+	req = kmalloc(req_len, GFP_KERNEL);
 	if (!req)
 		return -ENOMEM;
 	req->id = cpu_to_le16(USB_REQ_READ_REGS);
@@ -1219,7 +1219,7 @@ int zd_usb_iowrite16v(struct zd_usb *usb, const struct zd_ioreq16 *ioreqs,
 
 	req_len = sizeof(struct usb_req_write_regs) +
 		  count * sizeof(struct reg_data);
-	req = kmalloc(req_len, GFP_NOFS);
+	req = kmalloc(req_len, GFP_KERNEL);
 	if (!req)
 		return -ENOMEM;
 
@@ -1299,7 +1299,7 @@ int zd_usb_rfwrite(struct zd_usb *usb, u32 value, u8 bits)
 	bit_value_template &= ~(RF_IF_LE|RF_CLK|RF_DATA);
 
 	req_len = sizeof(struct usb_req_rfwrite) + bits * sizeof(__le16);
-	req = kmalloc(req_len, GFP_NOFS);
+	req = kmalloc(req_len, GFP_KERNEL);
 	if (!req)
 		return -ENOMEM;
 
-- 
John W. Linville
linville@tuxdriver.com
