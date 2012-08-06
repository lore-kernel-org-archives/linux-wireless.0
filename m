Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:35072 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756460Ab2HFPCd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 11:02:33 -0400
Message-ID: <501FDC87.1000204@openwrt.org> (sfid-20120806_170251_932536_F2F55D36)
Date: Mon, 06 Aug 2012 17:02:31 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: WDS vs. multi-channel operation
References: <1343655393.4452.13.camel@jlt3.sipsolutions.net>  <501EA97B.3010703@openwrt.org>  <1344187264.5765.4.camel@jlt3.sipsolutions.net>  (sfid-20120805_192133_648139_FC40F06B) <1344187324.5765.5.camel@jlt3.sipsolutions.net>
In-Reply-To: <1344187324.5765.5.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-08-05 7:22 PM, Johannes Berg wrote:
> On Sun, 2012-08-05 at 19:21 +0200, Johannes Berg wrote:
>> On Sun, 2012-08-05 at 19:12 +0200, Felix Fietkau wrote:
>> > On 2012-07-30 3:36 PM, Johannes Berg wrote:
>> > > Ok so I'm chipping away at multi-channel operation, but WDS is
>> > > troubling. Which channel should it use? It doesn't even have channel
>> > > configuration today, but relies on having a channel already, but that
>> > > breaks when you have multi-channel since then it either has to have its
>> > > own channel or be slaved to another channel...
>> > > 
>> > > Anyone have any ideas?
>> > Let's bind WDS interfaces to AP VIFs, then they can be slave to the AP's
>> > channel context. This is necessary for my yet-to-be-resubmitted WDS
>> > fixes anyway.
>> 
>> For now I decided that drivers supporting the channel context APIs will
>> not be allowed to support WDS interfaces :-P
>> (and the code in WDS TX will simply take the global channel as before)
>> 
>> So ... yes, I think this makes sense, but I'm not sure I care enough to
>> implement it right now, I have enough other things with multi-channel
>> still to do ... Though the question remains *how* we bind them. We could
>> try to match them by MAC address when they're brought up (and require
>> the same MAC address?), or do explicit binding, or something else
>> entirely ...
>> 
>> If you're going to require them to be bound to an AP though, where's the
>> difference to the current 4-addr AP_VLAN behaviour? It seems with that
>> you could actually implement a bound-to-AP-WDS entirely in userspace
>> since there's no requirement to actually go through the auth/assoc
>> sequence for hostapd to add the station entry?
> 
> Oh and if you actually do need WDS-type interfaces, maybe their role
> should change to be virtual like AP_VLAN-type interfaces?
The difference between WDS and 4-addr AP_VLAN is that WDS is AP<->AP,
not AP<->STA. I guess it would be possible to write some code to create
AP VLANs + station entries for remote APs based on cooked monitor mode
based discovery or some form of mgmt frame exchange.

- Felix
