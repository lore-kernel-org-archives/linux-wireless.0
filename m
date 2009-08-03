Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f211.google.com ([209.85.219.211]:43556 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461AbZHCU6D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 16:58:03 -0400
Received: by ewy7 with SMTP id 7so46998ewy.18
        for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2009 13:58:02 -0700 (PDT)
Message-ID: <4A774F76.6020207@lwfinger.net>
Date: Mon, 03 Aug 2009 15:58:30 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
CC: Michael Buesch <mb@bu3sch.de>, bcm43xx-dev@lists.berlios.de,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH RESEND] b43: implement baseband init for LP-PHY <= rev1
References: <4A7610AE.5000908@gmail.com> <200908031115.12929.mb@bu3sch.de> 	<69e28c910908030655g4ea70567y30ca2e68a77b872b@mail.gmail.com> 	<200908032238.18030.mb@bu3sch.de> <69e28c910908031341n439384b4ned41f2983ab1de29@mail.gmail.com>
In-Reply-To: <69e28c910908031341n439384b4ned41f2983ab1de29@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gábor Stefanik wrote:
> 2009/8/3 Michael Buesch <mb@bu3sch.de>:
>> On Monday 03 August 2009 15:55:29 Gábor Stefanik wrote:
>>> On Mon, Aug 3, 2009 at 11:15 AM, Michael Buesch<mb@bu3sch.de> wrote:
>>>> On Monday 03 August 2009 11:13:37 Michael Buesch wrote:
>>>>> On Monday 03 August 2009 00:18:22 Gábor Stefanik wrote:
>>>>>> Implement baseband init for rev.0 and rev.1 LP PHYs. Convert
>>>>>> boardflags_hi values to defines.
>>>>>> Implement b43_phy_copy for easier copying between registers, as needed
>>>>>> by LP-PHY init.
>>>>>> +   if (bus->sprom.boardflags_hi&  B43_BFH_FEM_BT)&&
>>>>>> +      (bus->chip_id == 0x5354)&&
>>>>>> +      (bus->chip_package == SSB_CHIPPACK_BCM4712S)) {
>>>>>> +           b43_phy_set(dev, B43_LPPHY_CRSGAIN_CTL, 0x0006);
>>>>>> +           b43_phy_write(dev, B43_LPPHY_GPIO_SELECT, 0x0005);
>>>>>> +           b43_phy_write(dev, B43_LPPHY_GPIO_OUTEN, 0xFFFF);
>>>>>> +           b43_hf_write(dev, b43_hf_read | 0x0800ULL<<  32);
>>>>>> +   }
>>>>> The HF write is wrong. Read the specification:
>>>>> http://bcm-v4.sipsolutions.net/802.11/Mhf
>>>>>
>>>>> Patch otherwise looks ok.
>>>> Sorry, I replied to the wrong mail. But this does also apply to V2 patch.
>>>>
>>>> --
>>>> Greetings, Michael.
>>>>
>>> In V2, this line is as follows (b43_hf_read corrected):
>>>
>>> b43_hf_write(dev, b43_hf_read(dev) | 0x0800ULL << 32)
>>>
>>> The command in the specs is this:
>>>
>>> mhf(2, 0x800, 0x800, 1)
>>>
>>> 2 means B43_SHM_SH_HOSTFHI, 0x800 is the bit to set, and 1 is
>>> allbands, which, per Larry, can be ignored in our current
>>> implementation (it is specific to the caching behavior of the mips
>>> driver).
>>>
>>> From what I read in b43_hf_write, writing to HOSTFHI can be achieved
>>> by left-shifting by 32 (16 for HOSTFMI).
>>>
>>> Is the problem that we write all 3 hostflags registers here?
>>>
>>> (BTW are there any other known host flags? If there are, maybe we
>>> should #define them.)
>>>
>> My point is that update_mhf does not write to actual hardware, as far
>> as I understand the code. Larry, can you please explain that part of the
>> specs?
>>
> 
>>From 802.11/Mhf:
> "If core->clk is not zero AND band->mhfs[idx] is not equal to tmp:
>    1. Write band->mhfs[idx] to Shared Memory Address addr[idx]"
> 
> This looks to me like it does indeed write to SHM, though the actual
> mhf() tries to avoid writing to SHM if possible, while b43_hf_write
> doesn't perform this optimization. (We don't have a band->mhfs, nor a
> bandstate[] array.)

Gábor states it the way the Broadcom routine is written. They have the
flags divided into 3 16-bit values - high, middle, and low. The values
are kept in arrays - one set is for the current band and the other is
for both bands. When the routine is entered, the appropriate quantity
is saved in a temporary, then the array value is maskset. Only when
the resulting value changes is the shared memory location updated. The
implication is that shared memory writes are expensive. Is that true?

Larry
