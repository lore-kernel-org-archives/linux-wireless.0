Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43935 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493AbXKWMP4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2007 07:15:56 -0500
Subject: Re: ZD1211RW unaligned accesses...
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	shaddy_baddah@hotmail.com
In-Reply-To: <20071120.040546.222294375.davem@davemloft.net> (sfid-20071120_120554_491311_552F5A44)
References: <20071120.040546.222294375.davem@davemloft.net>
	 (sfid-20071120_120554_491311_552F5A44)
Content-Type: text/plain
Date: Fri, 23 Nov 2007 11:41:26 +0100
Message-Id: <1195814486.4149.83.camel@johannes.berg> (sfid-20071123_121601_118712_D8E0AD7D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> The problem is
> drivers/net/wireless/zd1211/zd_mac.c:update_qual_rssi().
> Specifically the compare_ether_addr() call

I don't believe this is true. Shaddy seems to back that up by the patch
not helping.

> Wireless folks, I would suggest we do some auditing of the
> compare_ether_addr() calls and for the ones that are operating
> on these potentially unaligned structs we change it to either
> a straight memcmp() or some new routine which will more reflect
> the issue (say something like "compare_ether_addr_unaligned()"
> or "ieee80211_compare_ether_addr()").

All MAC addresses in 802.11 headers are at least aligned on 16-bit
boundaries. Hence, if the some MAC address like the BSSID here was
unaligned we'd also have the IP header unaligned causing a lot more
trouble than this.

Shaddy, please rebuild zd1211 with the patch below, it should make the
compiler not inline all those static functions allowing us to pinpoint
much better where the problem occurs. You will probably need to delete
all *.o files in the zd1211rw/ directory to the them rebuilt after the
Makefile change.

--- everything.orig/drivers/net/wireless/zd1211rw/Makefile	2007-11-23 11:36:30.652094075 +0100
+++ everything/drivers/net/wireless/zd1211rw/Makefile	2007-11-23 11:36:57.112090711 +0100
@@ -1,5 +1,7 @@
 obj-$(CONFIG_ZD1211RW) += zd1211rw.o
 
+EXTRA_CFLAGS += -fno-inline-functions-called-once
+
 zd1211rw-objs := zd_chip.o zd_ieee80211.o \
 		zd_mac.o zd_netdev.o \
 		zd_rf_al2230.o zd_rf_rf2959.o \


