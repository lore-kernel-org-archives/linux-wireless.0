Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:23475 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbYJVFzy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 01:55:54 -0400
Received: by wf-out-1314.google.com with SMTP id 27so2862628wfd.4
        for <linux-wireless@vger.kernel.org>; Tue, 21 Oct 2008 22:55:53 -0700 (PDT)
Message-ID: <48FEC067.8040307@gmail.com> (sfid-20081022_075611_201498_4707A32A)
Date: Tue, 21 Oct 2008 22:55:51 -0700
From: John Daiker <daikerjohn@gmail.com>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>,
	linux-wireless@vger.kernel.org
Subject: Re: Marvell TopDog Driver Work
References: <48A5DBAB.9080405@erley.org> <20080815195825.GD5935@tesla>	 <1218830917.14841.20.camel@localhost.localdomain>	 <gdidhg$hdq$3@ger.gmane.org>	 <1224524168.29822.46.camel@dhcp-100-3-195.bos.redhat.com>	 <1224525810.6873.8.camel@the-omnibook>	 <43e72e890810201245t3ac18fd6taf229af88350958f@mail.gmail.com>	 <1224533105.6873.22.camel@the-omnibook> <1224595093.24581.15.camel@localhost.localdomain>
In-Reply-To: <1224595093.24581.15.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

snip
> Definitely, I've looked at marvell.git (topdog) and Luis's code, and
> earlier Marvell GPL code quite extensively.  The firmware interface is
> quite similar between the TopDog (802.11n) parts and the b/g parts, as
> are the TX and RX descriptors.  From my research, I didn't think it
> would be that hard to support both parts in the same driver.
>
> My strategy would be this, assuming you have TopDog hardware.  If you do
> not, I can ship you a CardBus TopDog card:
>
> 1) Use marvell.git and Luis' attempt to get minimal b/g support working
> for the TopDog parts
Don't think I can help with this part, as I don't have TopDog hardware...
>
> 2) Start adding in the support for 8335/8310 parts using mrv8k (and
> possibly BSD's malo(4)) as a guide
But I do have 8335 hardware:

00:0c.0 Ethernet controller: Marvell Technology Group Ltd. 88w8335 
[Libertas] 802.11b/g Wireless (rev 03)

--snip from the old mrv8k driver from a few months ago--
(mrv8k): successfully uploaded firmware
(mrv8k): HW ver. 1, FW ver. 0x3000036, 2 antennas, regulatory domain US 
(FCC)
--snip--

If memory serves, it's a Netgear 311v3 PCI... but the packaging isn't 
around and I'm too lazy to turn my machine off to physically look at the 
card (and stand on my head!).
>
> 3) Add the 802.11n bits of TopDog stuff
>
> The _most_ important thing is first to get a stable b/g driver, then add
> the candy later.  Since we have a full TopDog driver implementation,
> that might be the best thing to get working first.  mrv8k was never able
> to get very far for me when I was poking at it, I couldn't even get
> reliable scan results.
>
>> I don't think there is any question of *whether* TopDog support is
>> possible in mrv8k, only when, and "right now" does not yet appear to be
>> the answer. I really hope to be proven wrong on that, though.
>
> Oh, it's certainly possible in mrv8k.  But obviously you just want to
> get something up and running first, then add the tasty bits like N
> support later.
>
> Dan
I am more than willing to help test and/or debug any driver developments 
that come down the pipeline for the 8335 chip.

JD
