Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.allnet.de ([212.18.29.59]:54497 "EHLO mail.allnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392Ab2GVMBS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Jul 2012 08:01:18 -0400
Message-ID: <500BEA08.6020406@allnet.de> (sfid-20120722_140156_824052_2E2F3DF2)
Date: Sun, 22 Jul 2012 14:54:48 +0300
From: Daniel Golle <dgolle@allnet.de>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	<users@rt2x00.serialmonkey.com>
CC: Felix Fietkau <nbd@openwrt.org>
Subject: rt2x00 and hostapd
References: <50082319.5060703@openwrt.org>
In-Reply-To: <50082319.5060703@openwrt.org>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2x00 doesn't work with hostapd, the driver seems to wrongly interpret the
carrier state and refuse to send beacons if there is no carrier.
there is a workaround out there to fix this (see below), but the right way
would be to have this done similar to other mac80211 driver which do not
require this workaround.
anyone got an idea what's wrong here?

-------- Original Message --------
Subject: Re: [OpenWrt-Devel] [PATCH] mac80211: import patch for rt2x00
Date: Thu, 19 Jul 2012 17:09:13 +0200
From: Felix Fietkau <nbd@openwrt.org>
To: OpenWrt Development List <openwrt-devel@lists.openwrt.org>
CC: Daniel Golle <dgolle@allnet.de>

On 2012-07-19 5:02 PM, Daniel Golle wrote:
> without this hostapd doesn't work on any of the RT3xxx systems I tested.
> 
> Signed-off-by: Daniel Golle <dgolle@allnet.de> --- 
> ...10-rt2x00-mac80211-manage-AP-netdev-carrier-state.patch | 14 
> ++++++++++++++ 1 file changed, 14 insertions(+) create mode 100644 
> package/mac80211/patches/610-rt2x00-mac80211-manage-AP-netdev-carrier-state.patch
>
>
> 
diff --git
> a/package/mac80211/patches/610-rt2x00-mac80211-manage-AP-netdev-carrier-state.patch
>
> 
b/package/mac80211/patches/610-rt2x00-mac80211-manage-AP-netdev-carrier-state.patch
> 
> 
new file mode 100644
> index 0000000..a1d9f06 --- /dev/null +++ 
> b/package/mac80211/patches/610-rt2x00-mac80211-manage-AP-netdev-carrier-state.patch
>
>
> 
@@ -0,0 +1,14 @@
> +Index: compat-wireless-2012-04-17/net/mac80211/iface.c 
> +=================================================================== +--- 
> compat-wireless-2012-04-17.orig/net/mac80211/iface.c	2012-05-09 
> 01:00:39.197975402 +0200 ++++ 
> compat-wireless-2012-04-17/net/mac80211/iface.c	2012-05-09 
> 01:02:32.514918371 +0200 +@@ -411,8 +407,7 @@ + 
> ieee80211_bss_info_change_notify(sdata, changed); + + 		if
> (sdata->vif.type == NL80211_IFTYPE_STATION || +-		    sdata->vif.type == 
> NL80211_IFTYPE_ADHOC || +-		    sdata->vif.type == NL80211_IFTYPE_AP) ++ 
> sdata->vif.type == NL80211_IFTYPE_ADHOC) + 			netif_carrier_off(dev); + 
> else + 			netif_carrier_on(dev);
I think this needs to be sorted out upstream. As far as I know, nobody
so far has figured out yet why managing the netdev carrier state causes
the hostapd issues and why it appears to only happen on rt2x00.

- Felix



