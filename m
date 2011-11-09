Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43731 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab1KIMQ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 07:16:29 -0500
Received: by faan17 with SMTP id n17so1567634faa.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 Nov 2011 04:16:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+XFjip8ithvfY_zdQbY0SogJfJyBv4nXyugPSjudYJcuQfa_Q@mail.gmail.com>
References: <1294426085.18385.8.camel@maggie> <1320837297.1926.6.camel@shinybook.infradead.org>
 <CA+XFjir0yGWWUdt5YD8DuSjFk0pi0yEhzqQR020d5G06ah7XgQ@mail.gmail.com> <CA+XFjip8ithvfY_zdQbY0SogJfJyBv4nXyugPSjudYJcuQfa_Q@mail.gmail.com>
From: Jonas Gorski <jonas.gorski@gmail.com>
Date: Wed, 9 Nov 2011 13:16:07 +0100
Message-ID: <CAOiHx=kVL3dewGR=utxfKMVmJ4zEbzXmSXEnCH_8ypwkQ5WhmQ@mail.gmail.com> (sfid-20111109_131632_801397_F815BD5F)
Subject: Re: [PATCH] ssb: Ignore dangling ethernet cores on wireless devices
To: =?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
	=?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9 November 2011 12:51, Gábor Stefanik <netrolller.3d@gmail.com> wrote:
> On Wed, Nov 9, 2011 at 12:50 PM, Gábor Stefanik <netrolller.3d@gmail.com> wrote:
>> On Wed, Nov 9, 2011 at 12:14 PM, David Woodhouse <dwmw2@infradead.org> wrote:
>>> On Fri, 2011-01-07 at 19:48 +0100, Michael Büsch wrote:
>>>>
>>>> +               case SSB_DEV_ETHERNET:
>>>> +                       if (bus->bustype == SSB_BUSTYPE_PCI) {
>>>> +                               if (bus->host_pci->vendor == PCI_VENDOR_ID_BROADCOM &&
>>>> +                                   (bus->host_pci->device & 0xFF00) == 0x4300) {
>>>> +                                       /* This is a dangling ethernet core on a
>>>> +                                        * wireless device. Ignore it. */
>>>> +                                       continue;
>>>> +                               }
>>>> +                       }
>>>> +                       break;
>>>
>>> Do you also need to check for (bus->host_pci->device / 1000) == 43?
>>> Or do the chips with 5-digit 'decimal' IDs not have the Ethernet cores?
>>>
>>> Would it be better to invert the test and check for != 0x4400?
>>
>> I do not know of any Broadcom wireless device with a decimal PCI ID
>> (as opposed to a decimal Chip ID).
>
> Edit: However, 0x4700 should also be checked, as some BCM43xx chips
> use 0x47xx PCI IDs.

As far as I can tell from this snippet (I'm missing the original
message), this code is SSB, and the only 0x47xx I know of is the
BCM4313, and that's a BCMA card. So this doesn't apply here.

Same for the five digit Chip IDs (which might leak into the PCI ID, if
the card has no SPROM), AFAIK these are also BCMA exclusive.


A check for != 0x44xx would probably still the safest way.


Regards
Jonas
