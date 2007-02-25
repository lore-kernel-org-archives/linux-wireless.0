Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web50211.mail.yahoo.com ([206.190.39.175]:38148 "HELO
	web50211.mail.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751483AbXBYENM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Feb 2007 23:13:12 -0500
Date: Sat, 24 Feb 2007 20:06:30 -0800 (PST)
From: Alex Davis <alex14641@yahoo.com>
Subject: Patch to allow specification of interface name prefix
To: larry.finger@lwfinger.net
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Message-ID: <510326.55988.qm@web50211.mail.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch will allow you to specify the interface name prefix of wireless devices.

On my machine, the wireless devices under the bcm43xx driver are named 'ethx'; I 
would really rather have them called 'wlanx', like bcm43xx-d80211 does.

I have this as an option to bcm43xx in modprobe.conf.

Usage: modprobe bcm43xx ifprefix=wlan
Your wireless devices will now be called 'wlan0', 'wlan1', etc.

This patch is against Larry's combined-2.6.20.1.patch

Signed-off by: Alex Davis <alex14641 at yahoo dot com>

--- drivers/net/wireless/bcm43xx/bcm43xx_main.c	2007-02-24 22:22:48.000000000 -0500
+++ ../linux-2.6.20.1-lwf/drivers/net/wireless/bcm43xx/bcm43xx_main.c	2007-02-24
22:44:46.000000000 -0500
@@ -103,6 +103,9 @@
 # define modparam_fwpostfix  ""
 #endif /* CONFIG_BCM43XX_DEBUG*/
 
+static char modparam_ifprefix[IFNAMSIZ - 4];
+module_param_string(ifprefix, modparam_ifprefix, IFNAMSIZ - 4, 0444);
+MODULE_PARM_DESC(ifprefix, "Prefix for interface names (e.g; wlan).");
 
 /* If you want to debug with just a single device, enable this,
  * where the string is the pci device ID (as given by the kernel's
@@ -4123,6 +4126,10 @@
 		goto out;
 	}
 	/* initialize the net_device struct */
+	if ( strlen(modparam_ifprefix) > 0 ) {
+		strcpy(net_dev->name, modparam_ifprefix);
+		strcat(net_dev->name, "%d");
+	}
 	SET_MODULE_OWNER(net_dev);
 	SET_NETDEV_DEV(net_dev, &pdev->dev);
 

I code, therefore I am


 
____________________________________________________________________________________
Have a burning question?  
Go to www.Answers.yahoo.com and get answers from real people who know.
