Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:45058 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752952Ab0ALWqh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2010 17:46:37 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat-wireless: remove device_type in usbnet.c
Date: Tue, 12 Jan 2010 23:46:27 +0100
Message-Id: <1263336387-30707-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1263336387-30707-1-git-send-email-hauke@hauke-m.de>
References: <1263336387-30707-1-git-send-email-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes compile warning
drivers/net/usb/usbnet.c:1279: warning: ‘wlan_type’ defined but not used
drivers/net/usb/usbnet.c:1283: warning: ‘wwan_type’ defined but not used

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/14-device-type.patch |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/patches/14-device-type.patch b/patches/14-device-type.patch
index fdd7b23..5c4f4d7 100644
--- a/patches/14-device-type.patch
+++ b/patches/14-device-type.patch
@@ -34,3 +34,23 @@ compile warning.
  
  int bnep_add_connection(struct bnep_connadd_req *req, struct socket *sock)
  {
+--- a/drivers/net/usb/usbnet.c
++++ b/drivers/net/usb/usbnet.c
+@@ -1276,13 +1276,17 @@ static const struct net_device_ops usbne
+ 
+ // precondition: never called in_interrupt
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,32))
+ static struct device_type wlan_type = {
+ 	.name	= "wlan",
+ };
++#endif
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,32))
+ static struct device_type wwan_type = {
+ 	.name	= "wwan",
+ };
++#endif
+ 
+ int
+ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
-- 
1.6.3.3

