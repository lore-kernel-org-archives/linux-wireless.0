Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62682 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab0IIHLy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Sep 2010 03:11:54 -0400
Received: by bwz11 with SMTP id 11so863416bwz.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Sep 2010 00:11:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTimsdpMU-7mexyZhQ0TXQUABmgatb3TYCTNG6zTu@mail.gmail.com>
References: <1283988519-44671-1-git-send-email-steve@cozybit.com>
 <AANLkTimrfBjaQH3gQKJjiir24cKFoj_0rrFHdNSvbuv7@mail.gmail.com> <AANLkTimsdpMU-7mexyZhQ0TXQUABmgatb3TYCTNG6zTu@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 9 Sep 2010 17:11:32 +1000
Message-ID: <AANLkTik2PovFJ0in+rRu7v0Of2dJ-Juu7odMiU-F+zGy@mail.gmail.com>
Subject: Re: [PATCH] libertas_tf_usb: fix libertas_tf_usb to match structural
 changes in libertas_tf
To: Steve deRosier <steve@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, javier@cozybit.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 9, 2010 at 15:54, Steve deRosier <steve@cozybit.com> wrote:
> On Wed, Sep 8, 2010 at 7:29 PM, Julian Calaby <julian.calaby@gmail.com> wrote:
>> On Thu, Sep 9, 2010 at 09:28, Steve deRosier <steve@cozybit.com> wrote:
>>> The development of the libertas_tf_sdio driver introduced structural
>>> changes in libertas_tf.  Most notably, firmware loading and starting
>>> was needed in the probe stage due to the requirement that mac80211
>>> have the MAC address set before the starting of mac80211 in add_card.
>>> This patch fixes libertas_tf_usb to match these structural changes
>>> as needed.
>>>
>>> Signed-off-by: Steve deRosier <steve@cozybit.com>
>>
>> I'm not sure if the usb part of this driver is still functional, but
>> even if it isn't, it may be nicer (bisectability, etc.) to re-order
>> your patches like so:
>> 1. Make the structural changes (and clean ups) in the base code and usb driver
>> 2. Introduce the sdio driver in a single patch, taking advantage of
>> these changes.
>>
>> It will also mean that the sdio driver will be introduced to the
>> kernel in a working state, rather than introduced in a partially
>> working state, then fixed over several commits.
>>
>
> Well, it would be nice.  I agree 100%.  If I could have foreseen the
> changes to main code and the USB driver, perhaps I could've coded it
> this way.  I started out with trying not to make any changes to the
> main code at all if possible while adding the sdio driver.
> Unfortunately, it didn't work out that way.  My job was to make
> libertas_tf work with the 8686 on an sdio bus.  Changes to the usb
> driver only happened because I had to break it in order to make my
> sdio driver function.  Hence, the USB changes are last.  I could have
> left it in a non-functional state, but I don't work that way.

I agree, you can never predict what you're going to change.

In terms of Linux Kernel development, one of the constants that people
strive for is "bisectability". So if some random user wants to figure
out which patch broke his USB libertas device, he could use git bisect
to figure out exactly which commit introduced the problem. That tool
uses a binary search algorithm to find the exact commit which broke it
without having to test them all. If it asks her to compile some random
commit after you change the main code, but before you fix the USB
code, her USB libertas device won't work properly. In this case, she'd
be unable to continue this process without a lot of work and might
never be able to figure out which random mac80211 change 6 months ago
broke her dongle.

So, with big, sweeping changes (like your libertas_tf main changes)
people prefer them to be broken up into a set of simple, (hopefully)
obvious patches that change one thing and try to ensure that, at the
least, everything that worked before works afterwards, and if it
doesn't work afterwards, it's much easier to understand how a small
patch breaks something than how a large one does.

Getting this right is a *lot* of work, and I completely understand why
you haven't done it.

Also, IIRC, in general, if a number of people contributed to a patch,
the standard practise is to have signoffs from everyone involved. (If
you search for some of my changes in the arch/sparc tree you can see
how I handled fixing some oversights in another person's patches)

If this is a bit daunting to you, stick it all in a public repository
somewhere and I'll have a crack at it if I can find the time.
(Probably this weekend)

> BTW, as far as I know, before I started, libertas_tf_usb was
> functional and worked on the XO-1s that I tested on.  After my changes
> here, libertas_tf_usb did work on an XO-1.5 with a 8388 usb with
> thin-firmware.  So, libertas_tf_usb is still functional and ready to
> be used.  Does anything other than the XO-1s use it, I have no idea.

I recall a discussion in the recent past concerning the state of
libertas_tf. I can't recall whether it was described as broken or just
unmaintained, but as I couldn't remember the conclusion of the
discussion (you may have even taken part - I recall SDIO coming up at
one point) I assumed the worst.

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
