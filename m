Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36511 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802Ab0CLLe5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Mar 2010 06:34:57 -0500
Subject: Re: [PATCH/RFC 0/3] hwsim user-space frame processing
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: jouni.malinen@atheros.com, linux-wireless@vger.kernel.org
In-Reply-To: <1268368999-12734-1-git-send-email-me@bobcopeland.com>
References: <1268368999-12734-1-git-send-email-me@bobcopeland.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Mar 2010 03:34:47 -0800
Message-ID: <1268393687.4828.9.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-03-11 at 23:43 -0500, Bob Copeland wrote:
> This patchset moves the forwarding of frames in mac80211 hwsim
> into user-space.  This gives the ability to simulate loss,
> retransmission delays, collisions, etc. in a controlled environment
> while still using the whole stack.
> 
> A few disclaimers:
> 
>  - We don't expire pending (transmitted but not status-reported) packets.
>    This is a nice DoS waiting to happen, so that needs to be fixed.
> 
>  - This breaks the in-kernel forwarding.  It may be useful to still
>    do that for quick-and-dirty testing, via modparam or something.
> 
>  - It really wants a configuration ioctl that happens before the device
>    is registered, so you can set up the rate set and so forth.  The ABI
>    needs work in general.
> 
> How to use:
> 
> 1. Write a program to open /dev/mac80211_hwsim_control for as many radios
>    as you want, and shuffle packets between the file descriptors.  Or
>    suitably modify my proof-of-concept:
> 
>    http://bobcopeland.com/srcs/wifi_sim.tar.gz
> 
> 2. Set up network namespaces, and put the devices in separate namespaces.
> This may no longer be necessary, I haven't kept up.
> 
> 3. Run hostapd on one interface and connect to it from the other(s).
> 
> I keep this patch to unbreak netns, which will likely explode your computer:

This is easier and will work without exploding, but NM will stop working
with this patch:

--- wireless-testing.orig/net/mac80211/iface.c	2010-02-09 09:09:30.000000000 +0100
+++ wireless-testing/net/mac80211/iface.c	2010-02-09 09:09:49.000000000 +0100
@@ -858,7 +858,7 @@ int ieee80211_if_add(struct ieee80211_lo
 
 	memcpy(ndev->dev_addr, local->hw.wiphy->perm_addr, ETH_ALEN);
 	memcpy(ndev->perm_addr, ndev->dev_addr, ETH_ALEN);
-	SET_NETDEV_DEV(ndev, wiphy_dev(local->hw.wiphy));
+//	SET_NETDEV_DEV(ndev, wiphy_dev(local->hw.wiphy));
 
 	/* don't use IEEE80211_DEV_TO_SUB_IF because it checks too much */
 	sdata = netdev_priv(ndev);


johannes

