Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:56826 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932132Ab2HFPNu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 11:13:50 -0400
Message-ID: <501FDF2C.5020608@openwrt.org> (sfid-20120806_171356_042754_F0369B2F)
Date: Mon, 06 Aug 2012 17:13:48 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: WDS vs. multi-channel operation
References: <1343655393.4452.13.camel@jlt3.sipsolutions.net>   <501EA97B.3010703@openwrt.org>   <1344187264.5765.4.camel@jlt3.sipsolutions.net>   (sfid-20120805_192133_648139_FC40F06B) <1344187324.5765.5.camel@jlt3.sipsolutions.net>  <501FDC87.1000204@openwrt.org> <1344265599.4807.2.camel@jlt3.sipsolutions.net>
In-Reply-To: <1344265599.4807.2.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-08-06 5:06 PM, Johannes Berg wrote:
> On Mon, 2012-08-06 at 17:02 +0200, Felix Fietkau wrote:
> 
>> >> If you're going to require them to be bound to an AP though, where's the
>> >> difference to the current 4-addr AP_VLAN behaviour? It seems with that
>> >> you could actually implement a bound-to-AP-WDS entirely in userspace
>> >> since there's no requirement to actually go through the auth/assoc
>> >> sequence for hostapd to add the station entry?
>> > 
>> > Oh and if you actually do need WDS-type interfaces, maybe their role
>> > should change to be virtual like AP_VLAN-type interfaces?
> 
>> The difference between WDS and 4-addr AP_VLAN is that WDS is AP<->AP,
>> not AP<->STA. I guess it would be possible to write some code to create
>> AP VLANs + station entries for remote APs based on cooked monitor mode
>> based discovery or some form of mgmt frame exchange.
> 
> I was thinking just pre-configure it as you have to anyway now?
Well, when creating station entries manually, it has to know the HT
capabilities, etc.
With my incomplete fixes (which are being used on OpenWrt), those are
automatically extracted from the remote AP's beacons, so that needs less
preconfiguration.

- Felix
