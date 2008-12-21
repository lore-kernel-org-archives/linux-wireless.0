Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:40820 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750825AbYLUSEd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2008 13:04:33 -0500
Message-ID: <494E852E.4070002@lwfinger.net> (sfid-20081221_190448_385691_AF830A3F)
Date: Sun, 21 Dec 2008 12:04:30 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Fabio Rossi <rossi.f@inwind.it>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
Subject: Re: rtl8180: the network interface is not anymore created
References: <200812211710.23846.rossi.f@inwind.it>
In-Reply-To: <200812211710.23846.rossi.f@inwind.it>
Content-Type: multipart/mixed;
 boundary="------------030507070608090304060304"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030507070608090304060304
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Fabio Rossi wrote:
> I was using successfully the rtl8180 driver but after last git-pull the 
> network interface (wlan0) is not anymore created.
> 
> I have discovered the problem: there has been a change in mac80211, commit 
> 3fc7826b95521e40cf53f63437a5fdcc24e54ac4. The problem is that the bit 
> NL80211_IFTYPE_STATION is not set during the hardware initialization.
> 
> I guess that the problem might be solved inserting the following line of code
> 
>     dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
> 
> somewhere in rtl8180_dev.c but I don't know which is the right point to do so.

Fabio,

Does this patch fix it for you?

Larry

Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8180_dev.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8180_dev.c
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8180_dev.c
@@ -898,6 +898,7 @@ static int __devinit rtl8180_probe(struc
 	dev->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 		     IEEE80211_HW_RX_INCLUDES_FCS |
 		     IEEE80211_HW_SIGNAL_UNSPEC;
+	dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
 	dev->queues = 1;
 	dev->max_signal = 65;



--------------030507070608090304060304
Content-Type: text/plain;
 name="rtl8180_STA_init"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="rtl8180_STA_init"

Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8180_dev.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8180_dev.c
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8180_dev.c
@@ -898,6 +898,7 @@ static int __devinit rtl8180_probe(struc
 	dev->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 		     IEEE80211_HW_RX_INCLUDES_FCS |
 		     IEEE80211_HW_SIGNAL_UNSPEC;
+	dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
 	dev->queues = 1;
 	dev->max_signal = 65;
 


--------------030507070608090304060304--
