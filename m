Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from toronto053.server4you.de ([62.75.220.53]:35904 "EHLO
	toronto053.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbZBTO5E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2009 09:57:04 -0500
Date: Fri, 20 Feb 2009 15:57:43 +0100
From: Daniel Wagner <wagi@monom.org>
To: Kevin Wilson <wkevils@gmail.com>
Cc: Dan Williams <dcbw@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, networkmanager-list@gnome.org
Subject: Re: NetworkManager and mac80211_hwsim
Message-ID: <20090220145743.GA9325@toronto053.server4you.de> (sfid-20090220_155709_952368_223B1FBF)
References: <20090216160016.GA29509@toronto053.server4you.de> <1234800284.4219.136.camel@johannes.local> <20090216172528.GB29509@toronto053.server4you.de> <1234807251.1666.9.camel@localhost.localdomain> <20090218080636.GA25504@toronto053.server4you.de> <55c333c0902190617w7ced9b7cu45ab0aad44305c77@mail.gmail.com> <20090219172002.GE28934@toronto053.server4you.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090219172002.GE28934@toronto053.server4you.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As it seems some more tweaking was needed to get it running
with the current HAL head. Does this work for you?

daniel

---

NetworkManager wants to read info.linux.driver for all devices.
Since a mac80211_hwsim device doesn't have a real parent the
property is not added. So let's add this property if there
is no proper parent and it is a 80211 device.

Signed-off-by: Daniel Wagner <wagi@monom.org>

---
v2: Set address for wmaster devices to nil. Otherwise the real
    networking device is overwritten.

 hald/linux/device.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/hald/linux/device.c b/hald/linux/device.c
index 21b9176..83b4a30 100644
--- a/hald/linux/device.c
+++ b/hald/linux/device.c
@@ -1576,6 +1576,7 @@ net_add (const gchar *sysfs_path, const gchar *device_file, HalDevice *parent_de
 	guint media_type;
 	gint flags;
 	gint addr_len;
+	gboolean real_parent = TRUE;
 
 	d = NULL;
 	d = hal_device_new ();
@@ -1588,6 +1589,7 @@ net_add (const gchar *sysfs_path, const gchar *device_file, HalDevice *parent_de
 				HAL_ERROR (("Device '%s' has no parent and couldn't find computer root object."));
 				goto error;
 			}
+			real_parent = FALSE;
 		}
         }
 
@@ -1662,6 +1664,11 @@ net_add (const gchar *sysfs_path, const gchar *device_file, HalDevice *parent_de
 			hal_device_property_set_string (d, "info.category", "net.80211");
 			hal_device_add_capability (d, "net.80211");
 			hal_device_property_set_uint64 (d, "net.80211.mac_address", mac_address);
+
+			if (!real_parent) {
+				/* This is must be a mac80211_hwsim device */
+				hal_device_property_set_string (parent_dev, "info.linux.driver", "mac80211_hwsim");
+			}
 		} else if (stat (bridge_path, &s) == 0 && (s.st_mode & S_IFDIR)) {
 			hal_device_property_set_string (d, "info.product", "Bridge Interface");
 			hal_device_property_set_string (d, "info.category", "net.bridge");
@@ -1691,6 +1698,7 @@ net_add (const gchar *sysfs_path, const gchar *device_file, HalDevice *parent_de
 		hal_device_property_set_string (d, "info.product", "Networking Wireless Control Interface");
 		hal_device_property_set_string (d, "info.category", "net.80211control");
 		hal_device_add_capability (d, "net.80211control");
+		hal_device_property_set_string (d, "net.address", "00:00:00:00:00:00");
 	}
 #else
 #warning ARPHRD_IEEE80211_RADIOTAP and/or ARPHRD_IEEE80211_PRISM not defined!
-- 
1.6.0.2.GIT

