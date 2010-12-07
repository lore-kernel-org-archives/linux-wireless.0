Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:63370 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab0LGBSn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 20:18:43 -0500
Received: by qyk11 with SMTP id 11so4329099qyk.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Dec 2010 17:18:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=w7p6bZzC78gx0qADthyM1FjLorw3+rn97URrV@mail.gmail.com>
References: <AANLkTimDF3kofO=kiuOsz+WrTGROdOL8-3eNvKd5NrD3@mail.gmail.com> <AANLkTi=w7p6bZzC78gx0qADthyM1FjLorw3+rn97URrV@mail.gmail.com>
From: Jonathan Guerin <jonathan@guerin.id.au>
Date: Tue, 7 Dec 2010 11:18:27 +1000
Message-ID: <AANLkTi=wdOjUYsaH2UijpxTzs+kSmc_EoR16EhiGXiGU@mail.gmail.com>
Subject: Re: ath5k: Weird Retransmission Behaviour
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath5k-devel <ath5k-devel@lists.ath5k.org>,
	Bruno Randolf <br1@einfach.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 6, 2010 at 7:38 PM, Nick Kossifidis <mickflemm@gmail.com> wrote:
> 2010/12/6 Jonathan Guerin <jonathan@guerin.id.au>:
>> Hi,
>>
>>
>> I've been doing some investigation into the behaviour of contention
>> windows and retransmissions.
>>
>> Firstly, I'll just describe the test scenario and setup that I have. I
>> have 3 Via x86 nodes with Atheros AR5001X+ cards. They are tethered to
>> each other via coaxial cables, into splitters. They have 20dB of fixed
>> attenuation applied to each antenna output, plus a programmable
>> variable attenuator on each link. One node acts as a sender, one as a
>> receiver, and one simply runs a monitor-mode interface to capture
>> packet traces. All 3 are running kernel version 2.6.37-rc2. The sender
>> and receiver are configured as IBSS stations and are tuned to 5.18
>> GHz.
>>
>> Here's a really dodgy ASCII diagram of the setup:
>>
>> S-----[variable attenuator]-----R
>> |                                         |
>> |                                         |
>> |                                         |
>> +------------M-------------------------+
>>
>> where S is the Sender node, R is the Receiver node and M is the
>> Monitoring capture node.
>>
>>
>> Secondly, I have written a program which will parse a captured pcap
>> file from the Monitoring station. It looks for 'chains' of frames with
>> the same sequence number, and where the first frame has the Retry bit
>> set to false in the header and all following have it set to true. Any
>> deviation from this, and the program drops the current chain without
>> including it in its stats, and looks for the next chain matching these
>> requirements. It averages the amount of time per transmission number
>> (i.e. the average of all transmissions which were the first, second,
>> third etc. for a unique sequence number). The transmission time of a
>> frame is the amount of time between the end of the frame and the end
>> of the previous. It tracks these 'chains' of frames with the same
>> sequence number. It considers the last transmission number in each
>> chain as the 'final' transmission.
>>
>> Finally, the link is loaded using a saturated UDP flow, and the data
>> rate is fixed to 54M and 36M. This is specified in the output. The
>> output is attached below.
>>
>> The output describes the fixed link data rate, the variable
>> attenuator's value, the delivery ratio, and the number of transmitted
>> packets/s. I've added a discussion per result set. Each line outputs
>> the transmission number, the average transmission time for this
>> number, the total number of transmissions, the number of frames which
>> ended their transmissions at this number (i.e. where the chain ended
>> its final transmission - this is equivalent to the retransmission
>> value from the Radiotap header + 1), and the average expected
>> transmission time for all that particular transmission number in all
>> chains. This is calculated using the airtime calculations from the
>> 802.11a standard, with the receipt of an ACK frame, as well as a SIFS
>> (16us), which is 28us. If the transmission did not receive an ACK, a
>> normal ACK timeout is 50 us, but ath5k appears to have this set to 25
>> us, so the value shouldn't be too far out what to expect.
>>
>
> Did you measure ACK timeout or 25 is what you get from the code ?
> Because from what we know so far hw starts counting after switching to
> RX mode so phy rx delay (25 from standard) is also added.

Unfortunately, due to the unpredictability of contention window sizes
up till now, it's very difficult to measure the ACK Timeout. I've seen
this value from the code itself. If, as you say, the phy_rx_delay is
also added, then the value in the code should be correct, which means
I am using the wrong values. Perhaps these assumptions should be
documented when the value is being set up?

>
>
>
> --
> GPG ID: 0xD21DB2DB
> As you read this post global entropy rises. Have Fun ;-)
> Nick
>
