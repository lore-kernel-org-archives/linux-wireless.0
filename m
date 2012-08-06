Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35060 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932187Ab2HFPXV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 11:23:21 -0400
Message-ID: <1344266598.4807.3.camel@jlt3.sipsolutions.net> (sfid-20120806_172324_827228_1AFC92F1)
Subject: Re: WDS vs. multi-channel operation
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 06 Aug 2012 17:23:18 +0200
In-Reply-To: <501FDF2C.5020608@openwrt.org>
References: <1343655393.4452.13.camel@jlt3.sipsolutions.net>
	   <501EA97B.3010703@openwrt.org>
	   <1344187264.5765.4.camel@jlt3.sipsolutions.net>
	   (sfid-20120805_192133_648139_FC40F06B) <1344187324.5765.5.camel@jlt3.sipsolutions.net>
	  <501FDC87.1000204@openwrt.org>
	 <1344265599.4807.2.camel@jlt3.sipsolutions.net>
	 <501FDF2C.5020608@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-08-06 at 17:13 +0200, Felix Fietkau wrote:
> On 2012-08-06 5:06 PM, Johannes Berg wrote:
> > On Mon, 2012-08-06 at 17:02 +0200, Felix Fietkau wrote:
> > 
> >> >> If you're going to require them to be bound to an AP though, where's the
> >> >> difference to the current 4-addr AP_VLAN behaviour? It seems with that
> >> >> you could actually implement a bound-to-AP-WDS entirely in userspace
> >> >> since there's no requirement to actually go through the auth/assoc
> >> >> sequence for hostapd to add the station entry?
> >> > 
> >> > Oh and if you actually do need WDS-type interfaces, maybe their role
> >> > should change to be virtual like AP_VLAN-type interfaces?
> > 
> >> The difference between WDS and 4-addr AP_VLAN is that WDS is AP<->AP,
> >> not AP<->STA. I guess it would be possible to write some code to create
> >> AP VLANs + station entries for remote APs based on cooked monitor mode
> >> based discovery or some form of mgmt frame exchange.
> > 
> > I was thinking just pre-configure it as you have to anyway now?
> Well, when creating station entries manually, it has to know the HT
> capabilities, etc.
> With my incomplete fixes (which are being used on OpenWrt), those are
> automatically extracted from the remote AP's beacons, so that needs less
> preconfiguration.

Ah yes, but hostapd could do that as well since it always receives OBSS
beacons (via cooked monitor or nl80211 beacon reporting)

Anyway, I don't mind WDS special interfaces, I just have a feeling we
might be better served by AP_VLAN since they're implicitly handled in
mac80211 and don't need driver support etc.

johannes

