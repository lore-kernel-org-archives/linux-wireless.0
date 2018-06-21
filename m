Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:45465 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932747AbeFUPN5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Jun 2018 11:13:57 -0400
Received: by mail-oi0-f53.google.com with SMTP id 188-v6so3233350oid.12
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jun 2018 08:13:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180621140140.BQL4E.211759.root@dnvrco-web04>
References: <5B280692.2060106@broadcom.com> <20180621140140.BQL4E.211759.root@dnvrco-web04>
From: Tom Psyborg <pozega.tomislav@gmail.com>
Date: Thu, 21 Jun 2018 17:13:56 +0200
Message-ID: <CAKR_QV+gcq1r7ODAXnj=MjY1UBbHjk=y3ybYPXSYZCgSpPY+rg@mail.gmail.com> (sfid-20180621_171401_496010_4CE41939)
Subject: Re: Atheros AR9462 - 5Ghz not working
To: mgreger@cinci.rr.com
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Janusz Dziedzic <janusz.dziedzic@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        =?UTF-8?Q?Micha=C5=82_Kazior?= <kazikcz@gmail.com>,
        sedat.dilek@gmail.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

with mPCIe version i got one could only read eeprom but not write, or
the information presented were wrong..

On 21/06/2018, mgreger@cinci.rr.com <mgreger@cinci.rr.com> wrote:
>
> ---- Arend van Spriel <arend.vanspriel@broadcom.com> wrote:
>> + Martin
>>
>> On 6/18/2018 3:53 PM, mgreger@cinci.rr.com wrote:
>> >
>> > ---- Tom Psyborg <pozega.tomislav@gmail.com> wrote:
>> >> Hi
>> >>
>> >> Your log only show attemps on ch 2447, Can you try connecting to 5GHz
>> >> AP? Connect to Hidden Wireless Network option at the bottom of the
>> >> nm-applet? Running airodump in monitor mode to see if it captures
>> >> anything? Maybe your laptop's antennas were designed for 2.4G card
>> >> only but this just dumb guessing...
>> >>
>> >
>> > It won't connect to any 5GHz AP.
>> > I don't run network manager or Gnome, in fact X11 is not installed on
>> > this machine at all.
>> > I don't think there is such a thing as 2.4GHz vs 5GHz antennas.
>>
>> Actually there is. At least there are 2.4G specific antennas and
>> dual-band antennas.
>>
>> In 4.11 there have been a couple eeprom related changes dealing with
>> endianness of fields in eeprom. Could be those cause a regression for
>> you. I don't have the exact sha id of those commits, but I added the
>> author to this thread.
>>
>> Regards,
>> Arend
>>
>
> An interesting new development:
>
> I've confirmed it's not the antenna as I was able to acquire some more cards
> from a different source which work fine.
>
> Ostensibly they are the same card:  Atheros AR9462 : QCNFA222 reference
> design.
>
> The output from lspci for both working and non-working cards is: "03:00.0
> Network controller: Qualcomm Atheros AR9462 Wireless Network Adapter".
>
> However the Subsystem listed in lspci is different. I don't have the exact
> value at the moment for the working cards, but it lists Dell and the part
> number DW1802. The non-working cards are AzureWave.
>
> I've seen a lot of similar cards on ebay that I suspect are the AzureWave. A
> few offers on ebay are for the genuine Dell parts.
>
> What would be the best way to compare and contrast these cards to determine
> if there is a way to make them work?
>
> Inspect EEPROM? Someone previously mentioned calibration data, but I have no
> idea if it's possible to inspect or alter that.
>
