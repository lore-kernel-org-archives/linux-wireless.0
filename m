Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54814 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbYESPYQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2008 11:24:16 -0400
Subject: Re: [RFC] make wext wireless bits optional and deprecate them
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	Jean Tourrilhes <jt@hpl.hp.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1211199368.6252.19.camel@johannes.berg>
References: <1211026337.3827.25.camel@johannes.berg>
	 <CD993362-B1DE-4E4D-8A5B-E9E2AD7DA04C@holtmann.org>
	 (sfid-20080517_154639_384202_6D3479C2)  <1211032475.6252.2.camel@johannes.berg>
	 <1211117795.686.15.camel@localhost.localdomain>
	 <1211199368.6252.19.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 19 May 2008 17:22:58 +0200
Message-Id: <1211210578.6252.52.camel@johannes.berg> (sfid-20080519_172422_766103_65593623)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[removing linux-kernel and netdev from CC, I suppose they won't care too
much about these details]

On Mon, 2008-05-19 at 14:18 +0200, Johannes Berg wrote:
> > Instead of testing for wireless/, best thing would probably be to call
> > SIOCGIWRANGE on the device and if it returns EOPNOTSUP then it's not
> > wireless.  Some drivers may have to load firmware to figure out
> > supported rates and encryption capabilities, but to be honest, NM does
> > this to detect wireless devices and I haven't run into any issues in 4
> > years using it.  If there are issues with drivers, then we need to fix
> > the driver too.
> 
> I was about to propose calling SIOCGIWNAME since that is what
> wireless-tools do and that linux/wireless.h indicates.

Here's a patch, comments?

johannes

---
 hald/linux/device.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- hal.orig/hald/linux/device.c	2008-05-19 06:46:23.000000000 +0200
+++ hal/hald/linux/device.c	2008-05-19 06:55:25.000000000 +0200
@@ -45,6 +45,10 @@
   #include <linux/input.h>
 #endif
 
+/* for wireless extensions */
+#include <linux/if.h>
+#include <linux/wireless.h>
+
 #include <dbus/dbus.h>
 #include <dbus/dbus-glib.h>
 
@@ -532,10 +536,14 @@ net_add (const gchar *sysfs_path, const 
 		const char *addr;
 		const char *parent_subsys;
 		char bridge_path[HAL_PATH_MAX];
-		char wireless_path[HAL_PATH_MAX];
 		char phy80211_path[HAL_PATH_MAX];
 		struct stat s;
 		dbus_uint64_t mac_address = 0;
+		int ioctl_fd;
+		struct iwreq iwr;
+
+		ioctl_fd = socket (PF_INET, SOCK_DGRAM, 0);
+		strncpy (iwr.ifr_ifrn.ifrn_name, IFNAMSIZ, ifname);
 
 		addr = hal_device_property_get_string (d, "net.address");
 		if (addr != NULL) {
@@ -554,8 +562,6 @@ net_add (const gchar *sysfs_path, const 
 		}
 
 		snprintf (bridge_path, HAL_PATH_MAX, "%s/bridge", sysfs_path);
-		/* wireless extensions */
-		snprintf (wireless_path, HAL_PATH_MAX, "%s/wireless", sysfs_path);
 		/* cfg80211 */
 		snprintf (phy80211_path, HAL_PATH_MAX, "%s/phy80211", sysfs_path);
 		parent_subsys = hal_device_property_get_string (parent_dev, "info.subsystem");
@@ -565,7 +571,7 @@ net_add (const gchar *sysfs_path, const 
 			hal_device_property_set_string (d, "info.category", "net.bluetooth");
 			hal_device_add_capability (d, "net.bluetooth");
 			hal_device_property_set_uint64 (d, "net.bluetooth.mac_address", mac_address);
-		} else if ((stat (wireless_path, &s) == 0 && (s.st_mode & S_IFDIR)) ||
+		} else if ((ioctl (ioctl_fd, SIOCGIWNAME, &iwr) == 0) ||
 			(stat (phy80211_path, &s) == 0 && (s.st_mode & S_IFDIR))) {
 			hal_device_property_set_string (d, "info.product", "WLAN Interface");
 			hal_device_property_set_string (d, "info.category", "net.80211");
@@ -582,6 +588,8 @@ net_add (const gchar *sysfs_path, const 
 			hal_device_add_capability (d, "net.80203");
 			hal_device_property_set_uint64 (d, "net.80203.mac_address", mac_address);
 		}
+
+		close (ioctl_fd);
 	} else if (media_type == ARPHRD_IRDA) {
 		hal_device_property_set_string (d, "info.product", "Networking Interface");
 		hal_device_property_set_string (d, "info.category", "net.irda");


