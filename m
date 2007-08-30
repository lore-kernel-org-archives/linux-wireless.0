Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purr.warmcat.com ([87.106.142.209]:50913 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757772AbXH3Omf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2007 10:42:35 -0400
Message-ID: <46D6D759.2050600@warmcat.com>
Date: Thu, 30 Aug 2007 15:42:33 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Dan Williams <dcbw@redhat.com>, ian <ischram@telenet.be>,
	=?ISO-8859-1?Q?Robert_F=FChricht?= <the_master_of_disaster@gmx.at>,
	linux-wireless@vger.kernel.org
Subject: Re: mac80211, iwlwifi and packet injection
References: <20070829161655.7f68542c@doppelhertz>	 <46D5B8B9.8000803@telenet.be>  <46D5CE9B.8080401@warmcat.com>	 <1188481073.27590.11.camel@xo-3E-67-34.localdomain>	 <46D6D18F.2080108@warmcat.com> <1188483950.3978.15.camel@johannes.berg>
In-Reply-To: <1188483950.3978.15.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Somebody in the thread at some point said:
> On Thu, 2007-08-30 at 15:17 +0100, Andy Green wrote:
> 
>> There is *a* device.  There are multiple logical network interfaces that
>> are bound to that device.  I can spawn five logical network interfaces
>> and still only have one device.  NM thinks I spawned five devices: that
>> behaviour can be improved (by de-aliasing them via /sys or whatever I
>> don't mind).
> 
> No, it can't really do that because you may actually want NM to control
> multiple virtual interfaces if your hardware supports multiple STA

Well if for whatever reason you can spawn multiple logical network
interfaces in the stack, as you can, NM should generically be aware that
aliases exist it seems to me.

If a device can handle two associations simultaneously (with two
radios?), which I take the "multiple STA" to mean, maybe it should
present as two wiphys and NM can take the hint from that?

-Andy

