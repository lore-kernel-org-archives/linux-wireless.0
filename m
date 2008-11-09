Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bay0-omc3-s34.bay0.hotmail.com ([65.54.246.234]:55404 "EHLO
	bay0-omc3-s34.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753774AbYKIDJZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Nov 2008 22:09:25 -0500
Message-ID: <BAY104-DAV405497D40328FA26D8B14991B0@phx.gbl> (sfid-20081109_040931_707815_8E82A9AC)
Message-ID: <49165436.4040306@hotmail.com>
Date: Sun, 09 Nov 2008 14:08:38 +1100
From: Shaddy Baddah <shaddy_baddah@hotmail.com>
Reply-To: linux-wireless@vger.kernel.org,
	  Shaddy Baddah <shaddy_baddah@hotmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: zd1211rw (2.6.26 sparc64): unaligned access (zd_mac_rx)
References: <4902DEBB.3050205@hotmail.com>	 <20081025112147.GA12252@Chamillionaire.breakpoint.cc>	 <200810251325.07916.mb@bu3sch.de>	 <20081025112813.GC12252@Chamillionaire.breakpoint.cc>	 <49033782.5040701@hotmail.com>  <491589ED.4090904@hotmail.com> <1226149894.3610.8.camel@johannes.berg> <BAY104-DAV7C39A232BE9A213EB2122991B0@phx.gbl>
In-Reply-To: <BAY104-DAV7C39A232BE9A213EB2122991B0@phx.gbl>
Content-Type: multipart/mixed;
 boundary="------------020402080906000805040107"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020402080906000805040107
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 09/11/08 14:06, Shaddy Baddah wrote:
> (attached. Note, it also includes remnants of the patch recommended by 
> Sebastian Andrzej Siewior in 
> http://marc.info/?l=linux-wireless&m=122493409906326&w=2). The problem 
> occurs within compare_ether_addr() and this immediately reminded me that 

This time, really attached. Sorry about that.

Regards,
Shaddy

--------------020402080906000805040107
Content-Type: text/x-diff;
 name="zd_mac_rx_fix.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="zd_mac_rx_fix.diff"

diff -urN -x '*.o' -x '*.ko' ./linux-source-2.6.26.orig/drivers/net/wireless/zd1211rw/zd_mac.c ./linux-source-2.6.26/drivers/net/wireless/zd1211rw/zd_mac.c
--- ./linux-source-2.6.26.orig/drivers/net/wireless/zd1211rw/zd_mac.c	2008-07-14 07:51:29.000000000 +1000
+++ ./linux-source-2.6.26/drivers/net/wireless/zd1211rw/zd_mac.c	2008-11-09 03:52:45.000000000 +1100
@@ -25,6 +25,7 @@
 #include <linux/usb.h>
 #include <linux/jiffies.h>
 #include <net/ieee80211_radiotap.h>
+#include <asm/unaligned.h>
 
 #include "zd_def.h"
 #include "zd_chip.h"
@@ -632,7 +633,7 @@
 		struct ieee80211_hdr *tx_hdr;
 
 		tx_hdr = (struct ieee80211_hdr *)skb->data;
-		if (likely(!compare_ether_addr(tx_hdr->addr2, rx_hdr->addr1)))
+		if (likely(!memcmp(tx_hdr->addr2, rx_hdr->addr1, ETH_ALEN)))
 		{
 			struct ieee80211_tx_status status;
 
@@ -716,7 +717,7 @@
 			&& !mac->pass_ctrl)
 		return 0;
 
-	fc = le16_to_cpu(*((__le16 *) buffer));
+	fc = get_unaligned_le16(buffer);
 
 	is_qos = ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA) &&
 		 (fc & IEEE80211_STYPE_QOS_DATA);
@@ -806,7 +807,7 @@
 	u16 int_status;
 	struct zd_mac *mac = container_of(work, struct zd_mac, process_intr);
 
-	int_status = le16_to_cpu(*(__le16 *)(mac->intr_buffer+4));
+	int_status = get_unaligned_le16(mac->intr_buffer+4);
 	if (int_status & INT_CFG_NEXT_BCN) {
 		if (net_ratelimit())
 			dev_dbg_f(zd_mac_dev(mac), "INT_CFG_NEXT_BCN\n");

--------------020402080906000805040107--

