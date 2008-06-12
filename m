Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.180]:2221 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757509AbYFLRup (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2008 13:50:45 -0400
Received: by py-out-1112.google.com with SMTP id p76so1710017pyb.10
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jun 2008 10:50:44 -0700 (PDT)
Message-ID: <1ba2fa240806121050m1b83a6c2idce5e3a0c0a04fe3@mail.gmail.com> (sfid-20080612_195114_073211_AD9C0E50)
Date: Thu, 12 Jun 2008 20:50:44 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Problem: Out of memory after 2days with 2GB RAM
Cc: "Rik van Riel" <riel@redhat.com>,
	"Zdenek Kabelac" <zdenek.kabelac@gmail.com>,
	"Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
	yi.zhu@intel.com, reinette.chatre@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1213292340.3730.13.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <c4e36d110806120307n20cce692s9c136f11596f5ab0@mail.gmail.com>
	 <20080612093833.0fb9cdd6@bree.surriel.com>
	 <1213278884.3936.15.camel@johannes.berg>
	 <1ba2fa240806120843s268b2ff4mb45a11adf11afc7f@mail.gmail.com>
	 <1213290205.3730.2.camel@johannes.berg>
	 <1ba2fa240806121035t40d3e8c4laccc768ae337075d@mail.gmail.com>
	 <1213292340.3730.13.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 12, 2008 at 8:39 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> > Yeah, but why bother if we can just allocate 10% of the size, waste a
>> > lot less memory etc. mac80211 isn't going to pass in a scatter/gather
>> > frame anyway.
>>
>> Hope never dies. I actually have seen this speed up the throughput so
>> I will dig into it anyway.
>
> Well, you can always add it back later if you make the networking stack
> and mac80211 support it. It's a two-line patch after all.

I will handle this.

>> > The more interesting thing is the pci_alloc_consistent allocation right
>> > below that is also _huge_, but that's because of the stupid hardware
>> > design, or can the hardware cope with having the descriptors non-linear
>> > in memory?
>>
>> We talk after your next HW design. How will configure 265 * 16
>> descriptors separately.
>
> Well, considering that other hardware does manage to do things
> differently (say Broadcom because I know their DMA engine), I don't know
> why your hw designers went wild with this. All you need is an
> "end-of-frame" flag. But that's not really interesting to discuss,
> unless this is actually controlled by the microcode and you can change
> it.
>
This is have to do something with HW packet scheduling

> johannes
>
