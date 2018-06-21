Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dnvrco-outbound-snat.email.rr.com ([107.14.73.227]:9941 "EHLO
        dnvrco-cmomta03.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751048AbeFUOBm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Jun 2018 10:01:42 -0400
Message-ID: <20180621140140.BQL4E.211759.root@dnvrco-web04> (sfid-20180621_160146_160578_72643943)
Date: Thu, 21 Jun 2018 14:01:40 +0000
From: <mgreger@cinci.rr.com>
To: Tom Psyborg <pozega.tomislav@gmail.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: Atheros AR9462 - 5Ghz not working
Cc: Janusz Dziedzic <janusz.dziedzic@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        =?utf-8?Q?Micha=C5=82_Kazior?= <kazikcz@gmail.com>,
        sedat.dilek@gmail.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
In-Reply-To: <5B280692.2060106@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


---- Arend van Spriel <arend.vanspriel@broadcom.com> wrote: 
> + Martin
> 
> On 6/18/2018 3:53 PM, mgreger@cinci.rr.com wrote:
> >
> > ---- Tom Psyborg <pozega.tomislav@gmail.com> wrote:
> >> Hi
> >>
> >> Your log only show attemps on ch 2447, Can you try connecting to 5GHz
> >> AP? Connect to Hidden Wireless Network option at the bottom of the
> >> nm-applet? Running airodump in monitor mode to see if it captures
> >> anything? Maybe your laptop's antennas were designed for 2.4G card
> >> only but this just dumb guessing...
> >>
> >
> > It won't connect to any 5GHz AP.
> > I don't run network manager or Gnome, in fact X11 is not installed on this machine at all.
> > I don't think there is such a thing as 2.4GHz vs 5GHz antennas.
> 
> Actually there is. At least there are 2.4G specific antennas and 
> dual-band antennas.
> 
> In 4.11 there have been a couple eeprom related changes dealing with 
> endianness of fields in eeprom. Could be those cause a regression for 
> you. I don't have the exact sha id of those commits, but I added the 
> author to this thread.
> 
> Regards,
> Arend
> 

An interesting new development:

I've confirmed it's not the antenna as I was able to acquire some more cards from a different source which work fine.

Ostensibly they are the same card:  Atheros AR9462 : QCNFA222 reference design.

The output from lspci for both working and non-working cards is: "03:00.0 Network controller: Qualcomm Atheros AR9462 Wireless Network Adapter".

However the Subsystem listed in lspci is different. I don't have the exact value at the moment for the working cards, but it lists Dell and the part number DW1802. The non-working cards are AzureWave.

I've seen a lot of similar cards on ebay that I suspect are the AzureWave. A few offers on ebay are for the genuine Dell parts.

What would be the best way to compare and contrast these cards to determine if there is a way to make them work?

Inspect EEPROM? Someone previously mentioned calibration data, but I have no idea if it's possible to inspect or alter that.
