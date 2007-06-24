Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:33070 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752264AbXFXIkQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jun 2007 04:40:16 -0400
Message-ID: <467E2DC0.30804@warmcat.com>
Date: Sun, 24 Jun 2007 09:39:28 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [WIP] mac80211: kill mgmt interface
References: <1182418939.10821.8.camel@johannes.berg>	 <20070621143558.68fc8e4a@griffin.suse.cz>	 <1182429920.21939.1.camel@johannes.berg>	 <20070621151441.500d62d5@griffin.suse.cz>	 <20070622154545.29eeebdb@griffin.suse.cz>	<467BDCB1.1010604@warmcat.com>	 <1182526221.21939.94.camel@johannes.berg>	 <20070622174953.500817e0@griffin.suse.cz>	 <1182543620.21939.98.camel@johannes.berg>	<467CB691.2090806@warmcat.com>	 <1182581630.21939.105.camel@johannes.berg>	 <20070623134451.643dd40c@logostar.upir.cz>  <467D10BA.80104@warmcat.com> <1182635467.21939.125.camel@johannes.berg>
In-Reply-To: <1182635467.21939.125.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:

>> but actually I quite liked your encapsulation
>> thing -- in itself is compatible with working in any mode.  The only
>> problem with it right now is that it seems when mananged mode interfaces
>>  are not associated, they are in a netif_carrier_off() state or similar.
> 
> Oh, good point, I forgot about that in my other reply. Yeah, we really
> want to go to IFF_DORMANT too and that really stops us from doing
> anything. Also, if we do QoS on the interfaces then the qdisc might end
> up dropping our packets if we don't do special hacks around that, again
> something we cannot accept.

That definitely is a bit of a problem for using Managed mode wlan0 for
injection, since it shuts off packets outside of mac80211 when
unassociated.  The "solution" if one was wanted would be to stop using
the interface-level mechanism and let everything through and filter in
hard_start_xmit() so only injected packets were accepted.

This is only the case on managed mode interfaces though, a feature of
the encapsulated method was that it removed the dependence on
specifically Monitor Mode to determine that an incoming TX packet had
the radiotap format -- aside from Managed it still works fine on Monitor
Mode interfaces (and presumably the other modes) with or without an
associated interface on the device.  To be clear it works exactly the
same on Monitor Mode as Try #13 just requiring a 14-byte ethhdr at the
start of the injected packet.

Anyway I don't want to argue myself out of an ACK ;-)  I think what I'll
do is post a try #14 using encapsulation that works on wlan0 too but
needs it associated, but on the understanding that try #13 is not
deprecated if people prefer it.

-Andy
