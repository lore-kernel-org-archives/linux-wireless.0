Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qmta07.westchester.pa.mail.comcast.net ([76.96.62.64]:45108
	"EHLO QMTA07.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750817AbYGFES1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2008 00:18:27 -0400
Message-ID: <4870556A.5050002@gentoo.org> (sfid-20080706_061831_175291_526004F6)
Date: Sun, 06 Jul 2008 00:17:30 -0500
From: Daniel Drake <dsd@gentoo.org>
MIME-Version: 1.0
To: wireless <linux-wireless@vger.kernel.org>
CC: bruno@thinktube.com, vlado@work.ksp.sk
Subject: Re: mac80211 ad-hoc problems
References: <486EA910.80408@gentoo.org>
In-Reply-To: <486EA910.80408@gentoo.org>
Content-Type: multipart/mixed;
 boundary="------------010906050401070908050506"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010906050401070908050506
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Daniel Drake wrote:
> Looking at the code, ieee80211_sta_find_ibss() in mlme.c, I can't see 
> how it's supposed to work.  It's clear why it said it found the other 
> network, because the ESSID matches. But it's also clear why it didn't 
> actually bother to try and connect: the ieee80211_sta_join_ibss() call 
> is surrounded in an if condition which checks the BSSID - but I 
> (intentionally) didn't specify one, so the condition evaluates as false.

Oh, I misread the code. I thought it was only looking for a 
user-specified BSSID (but I had not specified one). Actually it is 
checking that we aren't attempting to join the same network that we are 
already on.

The problem that was preventing me from getting connectivity was 
channel. It was only accepting IBSSes on local->hw.conf.channel, so I 
was required to do "iwconfig wlan0 channel X" first.

Is this by design, or is automatic channel selection a desirable 
feature? see attached patch, which seems to be working

Daniel

--------------010906050401070908050506
Content-Type: text/plain;
 name="ibss-channel.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ibss-channel.txt"

[PATCH] mac80211: automatic IBSS channel selection

When joining an ad-hoc network, the user is currently required to specify
the channel. The network will not be joined otherwise, unless it happens
to be sitting on the currently active channel.

This patch implements automatic channel selection when the user has not
locked the interface onto a specific channel.

Signed-off-by: Daniel Drake <dsd@gentoo.org>

Index: linux-2.6.26-rc8/net/mac80211/mlme.c
===================================================================
--- linux-2.6.26-rc8.orig/net/mac80211/mlme.c
+++ linux-2.6.26-rc8/net/mac80211/mlme.c
@@ -3582,6 +3582,7 @@ static int ieee80211_sta_find_ibss(struc
 	int found = 0;
 	u8 bssid[ETH_ALEN];
 	int active_ibss;
+	int search_freq;
 	DECLARE_MAC_BUF(mac);
 	DECLARE_MAC_BUF(mac2);
 
@@ -3614,11 +3615,21 @@ static int ieee80211_sta_find_ibss(struc
 	printk(KERN_DEBUG "   sta_find_ibss: selected %s current "
 	       "%s\n", print_mac(mac, bssid), print_mac(mac2, ifsta->bssid));
 #endif /* CONFIG_MAC80211_IBSS_DEBUG */
-	if (found && memcmp(ifsta->bssid, bssid, ETH_ALEN) != 0 &&
-	    (bss = ieee80211_rx_bss_get(dev, bssid,
-					local->hw.conf.channel->center_freq,
-					ifsta->ssid, ifsta->ssid_len))) {
+
+	if (found && memcmp(ifsta->bssid, bssid, ETH_ALEN) != 0) {
 		int ret;
+		int search_freq;
+
+		if (ifsta->flags & IEEE80211_STA_AUTO_CHANNEL_SEL)
+			search_freq = bss->freq;
+		else
+			search_freq = local->hw.conf.channel->center_freq;
+
+		bss = ieee80211_rx_bss_get(dev, bssid, search_freq,
+					   ifsta->ssid, ifsta->ssid_len);
+		if (!bss)
+			goto dont_join;
+
 		printk(KERN_DEBUG "%s: Selected IBSS BSSID %s"
 		       " based on configured SSID\n",
 		       dev->name, print_mac(mac, bssid));
@@ -3626,6 +3637,8 @@ static int ieee80211_sta_find_ibss(struc
 		ieee80211_rx_bss_put(dev, bss);
 		return ret;
 	}
+
+dont_join:
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
 	printk(KERN_DEBUG "   did not try to join ibss\n");
 #endif /* CONFIG_MAC80211_IBSS_DEBUG */

--------------010906050401070908050506--
