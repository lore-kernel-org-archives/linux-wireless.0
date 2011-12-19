Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36292 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974Ab1LSNSz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 08:18:55 -0500
Received: by iaeh11 with SMTP id h11so8540229iae.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Dec 2011 05:18:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAF3gKsxgO16GqP8x4Q_+wUhYK4x919xbik-ATv4agS+Heg3yig@mail.gmail.com>
References: <CAF3gKsxgO16GqP8x4Q_+wUhYK4x919xbik-ATv4agS+Heg3yig@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 20 Dec 2011 00:18:33 +1100
Message-ID: <CAGRGNgUQ48Bc4qQeZ8Euj1+z8qiyA4cOEcEsx3B0EO5oh2Cnug@mail.gmail.com> (sfid-20111219_141901_250743_7FF6AD6B)
Subject: Re: Developing Linux tree support for Marvell 88W8335
To: Shahar Or <mightyiampresence@gmail.com>
Cc: libertas-dev@lists.infradead.org, mab@comnets.uni-bremen.de,
	luc@saillard.org, linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Shahar,

You really should subscribe to the linux-wireless list and CC them on
big emails like this. (I've quoted in full below and CC'd them.)

My response is below the quote.

On Mon, Dec 19, 2011 at 23:23, Shahar Or <mightyiampresence@gmail.com> wrote:
> To all whom may NOT be interested in this, I apologize. I collected your
> addresses from the libertas-dev mailing lists and saillard.org because you
> seemed to be interested in this about two to three years ago.
>
> So here it is again.
>
> I've two identical PCI NICs with the 88W8335 chip.
>
> I'd like to see firm Linux support for these so I'm doing what I can by
> donating them.
>
> If you want to work on the drivers and need a card please tell me and I'll
> ship one to you.
>
> BTW they work with ndiswrapper tested in Ubuntu but WPA2-PSK doesn't work
> but that's a different driver :)
>
> Thanks for all the amazing work.

I have a similar card in my testing and development box here, but have
not yet started on anything resembling a driver. - That said, I was
involved in prodding Marvell for a proper firmware release as I have,
on at least two occasions, intended to write a driver for this card
but never actually got anywhere.

I, annoyingly, lack the time (insert flimsy excuse about having a full
time programming job here) to actually write a driver, but I'm always
happy to test stuff out, so if you need any testing done, talk to me.
I'm sure there are other people out there with similar hardware who
could stick it in a Linux box and test your driver.

So, as for actual code and data and stuff:

The advice I was given when I was starting to write a driver (no
source remains, it never got to the point where it did anything
useful) was to start a new mac80211 driver from scratch as this
hardware is significantly different from the "Libertas" devices as
used in some mobile devices and the OLPC computers. Another approach
would be to update the official driver to a newer kernel and stick it
into staging, then clean it into a mac80211 driver and then push it
out into the kernel tree proper. I was advised that if I needed any
hardware info to look at the official driver. (see below)

There is a blessed version of the firmware in the linux-firmware tree here:

http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git;a=commitdiff;h=e694ee268684ec26af44a6b068203a5f44f6ed06

The official Marvell driver, in a source tree here: - Note that this
code only works on this exact kernel version and will need some
significant work to run with any other kernel version.

http://git.infradead.org/users/dwmw2/marvell-db64660-2.6.12.6.git

And something approximating a partial driver here:

http://git.infradead.org/mrv8k-2.6.git

Also, the hardware is probably also significantly different to the
"TopDog" devices, so using their driver as a base is probably a bad
idea. They have an official driver in the source tree here:

http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=blob;f=drivers/net/wireless/mwl8k.c;h=995695c28d5c8d66c9999126e9203392428c24c2;hb=HEAD
)

Good luck, and again, if you need any testing, talk to me =)

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
