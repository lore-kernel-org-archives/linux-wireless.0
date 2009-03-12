Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:41208 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943AbZCLUTR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2009 16:19:17 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2009 13:19:16 -0700
Subject: Re: [PATCH 00/15] ath9k: Virtual interfaces and radios
From: Jouni Malinen <jouni.malinen@atheros.com>
To: Florian Fainelli <florian@openwrt.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <200903071456.03827.florian@openwrt.org>
References: <20090303172325.437810138@atheros.com>
	 <200903071456.03827.florian@openwrt.org>
Content-Type: text/plain
Date: Thu, 12 Mar 2009 22:19:12 +0200
Message-ID: <1236889152.16569.27.camel@jm-desktop> (sfid-20090312_211921_282822_98BB804A)
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2009-03-07 at 05:56 -0800, Florian Fainelli wrote:
> I am only commenting from a user point of view this feature. This definitively
> is very useful since quite a lot of people stick to madwifi instead of using
> ath5k or ath9k since there was not real support before this patch for virtual
> interfaces.

The set of patches that went in should take care of the virtual station
side. The patch I just sent out will add multi-BSSID support for AP mode
(it will require an update to hostapd, too), so this should provide
support for quite complete set of virtual interface configurations.

> One thing that I did not like with wlanconfig and I would like not to find
> with mac80211/cfg80211 is the incompatibility of some setups (i.e: AP should
> be created first, STA interface later with nosbeacon), not sure this is
> possible, but if it is, one should be able to add a virtual interface without
> knowing the state of the other interfaces before.

The goal is certainly to be able to add and remove virtual interfaces in
any order and at any time. There may be some limitations in the current
version, i.e., something might end up not working, but the configuration
part itself is not prevented. If someone finds a sequence that does not
work, I would hope it can be resolved.

> I really like the way we can create mesh point interfaces with iw, so this
> could be the user interface to configure virtual interfaces, say like this :
> 
> iw dev wlan0 interface add sta0 type sta
> iw dev wlan0 interface add ap0 type master

The multi-channel operation with virtual radio (wiphy) is at somewhat
different layer than the mesh interface (vif). Anyway, if nl80211 is
extended with a command that can be used to add a new virtual wiphy,
similar iw command could be added for this use, too. Here standard
commands (iwconfig/wpa_supplicant/hostapd) can change the interface
mode, so it does not need to be specified at wiphy creation time.

As far as multi-BSSID configuration of AP mode on the same channel is
concerned, those virtual interfaces are vifs and hostapd generates them
dynamically using the same mechanism as the iw commands above.

- Jouni


