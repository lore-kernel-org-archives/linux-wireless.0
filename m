Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:40175 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755572AbXD0IZo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2007 04:25:44 -0400
Message-ID: <4631AEEF.2030306@linux.intel.com>
Date: Fri, 27 Apr 2007 01:06:07 -0700
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: Andy Green <andy@warmcat.com>
CC: Michael Wu <flamingice@sourmilk.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 09/13] mac80211: remove hw_scan callback
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net> <200704251634.16604.flamingice@sourmilk.net> <46312067.9090005@linux.intel.com> <200704262023.52833.flamingice@sourmilk.net> <46317888.9040909@linux.intel.com> <4631A9C8.5040003@warmcat.com>
In-Reply-To: <4631A9C8.5040003@warmcat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andy Green wrote:
> James Ketrenos wrote:
>> The more passive channels you add (most of 802.11a) the slower the
>> scanning gets.
> 
> Well just a datapoint on that (zd1211rw, presumably mac80211 scanned)
> 
> $ time iwlist mon0 scan
...
> real    0m0.857s
> user    0m0.001s
> sys     0m0.004s

How many channels are being scanned, and how many of those channels are passive only?  And can you clarify on 'presumably'?

>>> Eliminating the hw_scan callback reduces driver complexity. 
>> If done right, the stack would set up the list of channels to scan,
>> whether to scan the channel active or passive, and the template for the
>> probe request to use. 
> 
> I think one can reasonably say that's a lot of stuff to support what is
> a vendor-specific feature that only optimizes what can already be done.

I think I would say that's a lot of stuff to make software scanning try and work as well as hardware scanning does now.  hw_scan() is there now, it works, and its twice as fast as software scanning.  The work should be to make software scanning better for hardware that can't do hardware scan, not to remove the ability for hardware scanning.

...
> Maybe a simpler, more granular way to come at that is in the firmware to
> allow selection of "beacon only" filtering, or maybe a count of valid
> CRC packets that got filtered so you can assess if you should look
> closer at that channel.

Or maybe just let the firmware do the scan?  :)

...
> For result latency, at the moment the monolithic scan is atomic, you sit
> there with nothing and get your results all at once.  With a usermode
> driven scan, you will get results as you scan a channel, improving the
> perception of latency.

The action for finding your particular AP will always be atomic.  If the AP you want is on a passive channel and you happen to miss the beacon in one pass, now the 4.7s "find the AP and associate via software" sequence is 9.4s... or 13.  

There is no 'perception of latency' when it comes to the question of "How long after I click the button to turn on wireless do I have to wait before I can hit refresh on my browser?"

> It seems it won't make your life that much harder

Actually it will because we'll end up having to have our users use the external mac80211 subsystem for as long as hardware scanning is not supported by the kernel.  Accelerated scanning is something end users like.  I'm not going to give that up.

> mac80211-based scanning appears to work for you already

mac80211-based scanning worked as a stop gap.  It is definitely not suitable as a final solution.

> and we talk about 2 seconds instead of 1 for results now and again.

It isn't 2s vs 1s -- we're talking 5s vs. 2s... and that's if it finds the AP on the first scan, which it doesn't always do.  "now and again" is a lot more common than you'd like and when you're using a laptop and changing environments, roaming, AP hopping, etc.

James
