Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:38388 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368Ab2DPNQp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 09:16:45 -0400
Message-ID: <4F8C1BB5.5090602@openwrt.org> (sfid-20120416_151648_896446_4CE4C8FA)
Date: Mon, 16 Apr 2012 15:16:37 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Daniel Halperin <dhalperi@cs.washington.edu>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com
Subject: Re: [PATCH 2/9] ath9k_hw: do not override SIFS time for half/quarter
 channels
References: <1334484941-27673-1-git-send-email-nbd@openwrt.org> <1334484941-27673-2-git-send-email-nbd@openwrt.org> <CALSq=BZgn+O2BNq=yAe_g5DAqR7jO3eSX2AcABtWqGUcYjB_qQ@mail.gmail.com> <4F8B1312.2010108@openwrt.org> <CALSq=BZMi0Tc+7paCi_Fid5hurXVxBCROe3xOzpP+o1BW1EBQA@mail.gmail.com> <4F8BEA0D.9020104@openwrt.org>
In-Reply-To: <4F8BEA0D.9020104@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-04-16 11:44 AM, Felix Fietkau wrote:
> On 2012-04-16 8:30 AM, Daniel Halperin wrote:
>> On Sun, Apr 15, 2012 at 11:27 AM, Felix Fietkau <nbd@openwrt.org> wrote:
>>> On 2012-04-15 8:22 PM, Daniel Halperin wrote:
>>>> Felix,
>>>>
>>>> This whole patch series throws the NICs out of spec compliance. For
>>>> instance, page 626 of the 802.11-2007 standard (Table 17-15) says that
>>>> aSIFStime is 32 us in 10 MHz mode and 64 us in 5 MHz mode.
>>>>
>>>> This might be okay to do for certain implementations (as, apparently,
>>>> AR9280/AR9380), but will break compatibility with any device obeying
>>>> the standard instead.
>>>>
>>>> (I wonder that, if this code below still works, then it seems that you
>>>> might not be properly downclocking the chips' reference clock...)
>>>>
>>>> Are you aware there's a standard for this? Why violate it?
>>> I'm aware that there's a standard for it, but if I put in the standard
>>> values, the connection gets unreliable to the point where it's almost
>>> unusable. That's why I chose to use existing products with 5/10 MHz
>>> support as reference instead.
>>>
>> 
>> I hear you, but still suspect the bug's somewhere else. Violating the
>> standard likely isn't the right choice unless you have a good
>> reason... it sounds like you don't know why this is happening but this
>> hack 'seems to work'.
>> 
>> (UBNT is also ath-based, right? So it's not really proof that this
>> hack doesn't break compatibility..)
> Right, UBNT is also ath-based, and I dumped the registers on the device
> to figure out what parameters they were using, and used those as
> reference for my ath9k work.
> I'm not aware of *any* standard compliant 5/10 MHz product out there, do
> you know any?
By the way, I'm doing some more testing and it seems like I may be able
to get it working with standard compliant SIFS timing after all by
tweaking the rx latency settings some more.

John: Don't merge this series just yet, I'll send a v2 when I'm done
testing.

- Felix
