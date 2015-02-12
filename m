Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:36505 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbbBLNVY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2015 08:21:24 -0500
Message-ID: <54DCA8D2.5090006@candelatech.com> (sfid-20150212_142127_286584_EF60E058)
Date: Thu, 12 Feb 2015 05:21:22 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Matti Laakso <malaakso@elisanet.fi>
Subject: Re: [RFT] ath10k: restart fw on tx-credit timeout
References: <1423224354-24955-1-git-send-email-michal.kazior@tieto.com>	<54D4E89A.7040602@candelatech.com>	<CA+BoTQ=HqyGKOBdOmpWOn_VjH1UTWF9nN_PE0uanaGsdeJmB6Q@mail.gmail.com>	<54D8DA6F.7040805@candelatech.com>	<CA+BoTQk9C_7efUs6VTZrEz5ECxsvCgfA8ObrAXKjqMpTL8pggA@mail.gmail.com>	<54DA3957.10402@candelatech.com>	<54DBD6C0.5000106@candelatech.com> <CA+BoTQ=cXL4pdLg==RVh5ARfNyC5qscthh4YJW1ufOM5=EsLyw@mail.gmail.com>
In-Reply-To: <CA+BoTQ=cXL4pdLg==RVh5ARfNyC5qscthh4YJW1ufOM5=EsLyw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 02/11/2015 10:55 PM, Michal Kazior wrote:
> On 11 February 2015 at 23:25, Ben Greear <greearb@candelatech.com> wrote:
>> On 02/10/2015 09:01 AM, Ben Greear wrote:
>>
>>> I've hacked CT firmware to do a flush of all vdevs itself when it detects WMI hang.
>>> I don't have a good test bed to reproduce the problem reliably, but I should know
>>> after a few days if the flush works at all.  If not, then it's a moot point anyway.
>>
>> So, this appears to at least partially work.
>>
>> But, what we notice is that when using multiple station vdevs, the system pretty much
>> becomes useless if we get any significant number of stuck or slow-to-transmit management
>> buffers over WMI.  Part of this is because WMI messages are sent when holding rtnl
>> much of the time, I think.
>
> Most, if not all, WMI commands are sent while holding conf_mutex. This
> lock is taken in many situations including when RTNL is held so your
> observation isn't entirely correct but isn't wrong either.
>
>
>> I would guess that an AP with lots of peers associated might have similar problems
>> if peers are not ACKing packets reliably.
>
> It's not the ACKing per se. It's whether stations are asleep and
> unresponsive or not. You could do funny DoS attacks with a single
> ath9k card (using virtual stations) on ath10k APs now I guess :-)

In our lab we have some setups where there should be no power-save at all,
but still see this issue.  Unlucky (or nefarious) broken-ness in the peer can seem to
mostly hang the local system due to the 'not entirely correct' assumption above :)


>> Probably the only useful way to fix this is to make the firmware and driver able to
>> send management frames over the normal transport like every other data packet?
>
> Agreed. HTT should've been used for entire traffic, including management frames.
>
> The workaround could've been to guarantee to have only 1 wmi-mgmt-tx
> in-flight but since tx-credits aren't replenished predictably you'll
> end up with the patch I originally did, i.e. sleep 2*bcn intval and
> wmi-peer-flush-tids after each unicast mgmt frame to a known station.

Even assuming I have the tx-credits replenishment fixed,
that work-around would make sending sending mgt frames to many peers
very slow when at least a few peers are not answering quickly, right?

>> Any idea what it wasn't written like that to begin with?
>
> Beats me.

This might be something I can fix in CT firmware..but trying to kick a release out
the door, so I think I'll put this off for a bit.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
