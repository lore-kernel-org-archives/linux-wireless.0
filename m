Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:33126 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab1KILum convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 06:50:42 -0500
Received: by qyk27 with SMTP id 27so4584586qyk.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 Nov 2011 03:50:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1320837297.1926.6.camel@shinybook.infradead.org>
References: <1294426085.18385.8.camel@maggie> <1320837297.1926.6.camel@shinybook.infradead.org>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Wed, 9 Nov 2011 12:50:21 +0100
Message-ID: <CA+XFjir0yGWWUdt5YD8DuSjFk0pi0yEhzqQR020d5G06ah7XgQ@mail.gmail.com> (sfid-20111109_125046_301548_A2FF2307)
Subject: Re: [PATCH] ssb: Ignore dangling ethernet cores on wireless devices
To: David Woodhouse <dwmw2@infradead.org>
Cc: =?ISO-8859-1?Q?Michael_B=FCsch?= <mb@bu3sch.de>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 9, 2011 at 12:14 PM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Fri, 2011-01-07 at 19:48 +0100, Michael Büsch wrote:
>>
>> +               case SSB_DEV_ETHERNET:
>> +                       if (bus->bustype == SSB_BUSTYPE_PCI) {
>> +                               if (bus->host_pci->vendor == PCI_VENDOR_ID_BROADCOM &&
>> +                                   (bus->host_pci->device & 0xFF00) == 0x4300) {
>> +                                       /* This is a dangling ethernet core on a
>> +                                        * wireless device. Ignore it. */
>> +                                       continue;
>> +                               }
>> +                       }
>> +                       break;
>
> Do you also need to check for (bus->host_pci->device / 1000) == 43?
> Or do the chips with 5-digit 'decimal' IDs not have the Ethernet cores?
>
> Would it be better to invert the test and check for != 0x4400?

I do not know of any Broadcom wireless device with a decimal PCI ID
(as opposed to a decimal Chip ID).

>
> --
> dwmw2
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
