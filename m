Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48017 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293Ab1HAC3F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jul 2011 22:29:05 -0400
Received: by wyg8 with SMTP id 8so1261798wyg.19
        for <linux-wireless@vger.kernel.org>; Sun, 31 Jul 2011 19:29:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201107312112.55357.chunkeey@googlemail.com>
References: <CAJ8GFOg4A4JwC8qdF6e7rRCRETnfrPm5Zv60_8Cm1xpbJJNQpg@mail.gmail.com>
	<201107312112.55357.chunkeey@googlemail.com>
Date: Sun, 31 Jul 2011 21:29:01 -0500
Message-ID: <CAJ8GFOgmsVyeGqYhfMoS+qPVx5cp53C94hr=GL0wPYUwQH5zwg@mail.gmail.com> (sfid-20110801_042927_914578_30508AE6)
Subject: Re: carl9170: How do I change value of retries for long packets?
From: Harshal Chhaya <harshal@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 31, 2011 at 2:12 PM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> On Sunday, July 31, 2011 06:48:46 PM Harshal Chhaya wrote:
>> I am still figuring out how to use 64 clients with h/w
>> encryption on the AR9170 - enabling debug/tracing in my build isn't as
>> straightforward as suggested by the wiki.
> Actually, to do this thing correctly, I recon you should ask your employer
> to get you the AR9170 chip documents from atheros qualcomm [if you haven't
> acquired them already.]

Christian,

I have the data sheet for this chip which tells me that the chip has
support for 64 pairs of keys. But what I can't figure out is why I can
use only 32 of them when I use hw crypto. All my clients use CCMP and
I would like to use the hw crypto if possible.

I was hoping to get some debug/trace information from carl9170 but
every time I try to enable tracing, my build config gets messed up and
my build fails. I am also hoping that this tracing helps me track down
why the wireless connection in unstable when I enable power save on
the clients.

>> However, I did find some very helpful information in the debug files
>> in 'debugfs' including the number of retries.
>> The current value is 4 for long packets and 7 for short packets.
> I don't think that the term "short packets" is what you think it is. :D

>From what I understand, short packets are smaller than the
RTSThreshold and long packets are larger than that value. Since my
RTSThreshold is undefined, I imagine all my data packets are 'long
packets'.


>> I think the small # of retries for regular data packets may be one
>> reason why I am seeing some throughput problems at longer ranges.
> Actually, your problem could be related to this thread:
> http://www.spinics.net/lists/linux-wireless/msg73850.html

It could be related to that discussion - but I am seeing the problem
with regular data packets after the authentication handshake. I think
the short # of retries coupled with minstrel_ht's rate management is
causing a higher failure count than if I had more retries. I can
possibly try a different rate control algo but I figured changing the
retry count is probably easier and better for cases where the range is
in the 5-10 m range.

> Furthermore, what's "longer range"? Is it 10-20 meters or are
> you talking about 200m+? [Note: mac80211 has a switch to select
> different coverage classes. The AR9170 MAC has a register
> AR9170_MAC_REG_ACK_EXTENSION to up the ACK timeout]

I am talking ~20-30 m (~65-100 ft). I don't think I need to change the
ACK timeout for this range.


>> How do I change the number of retries for long packets? Is this a
>> build-time configuration or can I change it at run-time?
> Actually, the number of retries is controlled by the selected
> mac80211's rate control algorithm. However, you first take a
> look at debug/ieee80211/phy0/statistics/failed_count and see
> if it really is the lack of additional "retries" which causes
> data loss.

I didn't know that the number of retries is controlled by the rate
control logic - that's very useful information. I had assumed that the
number is fixed. I will look at the 'failed_count' number for the
stations at the target range and see if it tells me the reason for the
failure.

Thanks,
- Harshal
