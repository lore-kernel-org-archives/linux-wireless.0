Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:58468 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753363AbXC2LTB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2007 07:19:01 -0400
Message-ID: <460BA0A1.7080106@warmcat.com>
Date: Thu, 29 Mar 2007 12:18:57 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/4] mac80211: Monitor mode radiotap injection docs
References: <20070320103955.600509703@warmcat.com>	 <20070320104104.575903961@warmcat.com> <1174500950.3944.15.camel@johannes.berg>
In-Reply-To: <1174500950.3944.15.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Tue, 2007-03-20 at 10:39 +0000, andy@warmcat.com wrote:
> 
>> +++ b/Documentation/networking/mac80211-injection.txt
> 
> This needs to be for cfg80211.

Well, the actual injection action is happening in mac80211.  I think 
you're looking at it as a cfg80211 wext-replacing type thing and I am 
looking at it as completely generic mac80211 packet injection from 
userspace.

>> +Radiotap headers are variable-length and extensible, you can get most of the
>> +information you need to know on them from:
>> +
>> +./include/net/ieee80211_radiotap.h
>> +
>> +But note: all fields in the radiotap header are *little endian*.
>> +
>> +There is a fixed portion at the start which contains a u32 bitmap that defines
>> +if the possible argument is present or not.  At the moment there are only 13
>> +possible arguments defined, but in case we run out of space in the u32 it is
>> +defined that b31 set indicates that there is another u32 bitmap following, and
>> +the start of the arguments is moved forward 4 bytes each time.
> 
> Drop all that, it's generic radiotap description. Put it into another
> file if you want.

This kind of description makes documentation useful to the reader, who 
may never have heard of radiotap (it is not very visible in Google right 
now in a useful way).

>> +After the fixed part of the header, the arguments follow.
>> +
>> + - the arguments are all little-endian!
> 
> duplicated information.

Yes when documenting something, you duplicate critical information, it 
is not an error but a static Forward Error Correction technology for 
lossy readers.

>> +The ieee80211 header follows immediately afterwards, looking for example like
>> +this:
>> +
>> +	0x08, 0x01, 0x00, 0x00,
>> +	0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
>> +	0x13, 0x22, 0x33, 0x44, 0x55, 0x66,
>> +	0x13, 0x22, 0x33, 0x44, 0x55, 0x66,
>> +	0x10, 0x86
>> +
>> +Then lastly there is the payload.
> 
> Scratch that, somebody who doesn't know how a IEEE 802.11 header looks
> like has no business reading that file anyway ;)

Everybody has to learn from nothing!

>> Libpcap can also be used,
>> +(which is easier than doing the work to bind the socket to the right
>> +interface), along the following lines:
>> +
>> +	ppcap = pcap_open_live(szInterfaceName, 800, 1, 20, szErrbuf);
>> +...
>> +	r = pcap_inject(ppcap, u8aSendBuffer, nLength);
>> +
>> +You can also find sources for a complete inject test applet here:
>> +
>> +http://penumbra.warmcat.com/_twk/tiki-index.php?page=packetspammer
> 
> Is it big enough to warrant being elsewhere? I don't see how an example
> program can be more than a few lines of code and then it could be
> included here as a C file.

It's ~380 lines.  It also knows how to conjure up management interfaces. 
  I can chop it down and put it in here if you feel it is important.

I appreciate the comments, but I am 100% sure that some correct 
documentation that may be over-chatty is better than no documentation at 
all.  After hesitating and starting to change it I left it as it is, if 
you still feel these things are important comment in that direction 
again on the new patch and I will grit my teeth and change it.

-Andy
