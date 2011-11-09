Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49104 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037Ab1KINxN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 08:53:13 -0500
Received: by gyc15 with SMTP id 15so1737161gyc.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 Nov 2011 05:53:12 -0800 (PST)
Message-ID: <4EBA85C5.2000606@lwfinger.net> (sfid-20111109_145318_412371_C2120E2F)
Date: Wed, 09 Nov 2011 07:53:09 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jonas Gorski <jonas.gorski@gmail.com>
CC: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>,
	David Woodhouse <dwmw2@infradead.org>,
	=?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <mb@bu3sch.de>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Re: [PATCH] ssb: Ignore dangling ethernet cores on wireless devices
References: <1294426085.18385.8.camel@maggie> <1320837297.1926.6.camel@shinybook.infradead.org> <CA+XFjir0yGWWUdt5YD8DuSjFk0pi0yEhzqQR020d5G06ah7XgQ@mail.gmail.com> <CA+XFjip8ithvfY_zdQbY0SogJfJyBv4nXyugPSjudYJcuQfa_Q@mail.gmail.com> <CAOiHx=kVL3dewGR=utxfKMVmJ4zEbzXmSXEnCH_8ypwkQ5WhmQ@mail.gmail.com>
In-Reply-To: <CAOiHx=kVL3dewGR=utxfKMVmJ4zEbzXmSXEnCH_8ypwkQ5WhmQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/09/2011 06:16 AM, Jonas Gorski wrote:
> On 9 November 2011 12:51, Gábor Stefanik<netrolller.3d@gmail.com>  wrote:
>> On Wed, Nov 9, 2011 at 12:50 PM, Gábor Stefanik<netrolller.3d@gmail.com>  wrote:
>>> On Wed, Nov 9, 2011 at 12:14 PM, David Woodhouse<dwmw2@infradead.org>  wrote:
>>>> On Fri, 2011-01-07 at 19:48 +0100, Michael Büsch wrote:
>>>>>
>>>>> +               case SSB_DEV_ETHERNET:
>>>>> +                       if (bus->bustype == SSB_BUSTYPE_PCI) {
>>>>> +                               if (bus->host_pci->vendor == PCI_VENDOR_ID_BROADCOM&&
>>>>> +                                   (bus->host_pci->device&  0xFF00) == 0x4300) {
>>>>> +                                       /* This is a dangling ethernet core on a
>>>>> +                                        * wireless device. Ignore it. */
>>>>> +                                       continue;
>>>>> +                               }
>>>>> +                       }
>>>>> +                       break;
>>>>
>>>> Do you also need to check for (bus->host_pci->device / 1000) == 43?
>>>> Or do the chips with 5-digit 'decimal' IDs not have the Ethernet cores?
>>>>
>>>> Would it be better to invert the test and check for != 0x4400?
>>>
>>> I do not know of any Broadcom wireless device with a decimal PCI ID
>>> (as opposed to a decimal Chip ID).
>>
>> Edit: However, 0x4700 should also be checked, as some BCM43xx chips
>> use 0x47xx PCI IDs.
>
> As far as I can tell from this snippet (I'm missing the original
> message), this code is SSB, and the only 0x47xx I know of is the
> BCM4313, and that's a BCMA card. So this doesn't apply here.
>
> Same for the five digit Chip IDs (which might leak into the PCI ID, if
> the card has no SPROM), AFAIK these are also BCMA exclusive.

The only known card with this problem is the BCM4303, with PCI IDs 14e4:4301. My 
suspicion is that Broadcom created a chip that could be used for wireless or 
wired depending on which core was connected. Thus, it is an artifact of the 
early days. One can clean up the code as much as you want, but I do not believe 
any other chips are involved.

Larry

