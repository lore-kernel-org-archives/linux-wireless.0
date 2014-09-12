Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:36262 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbaILHqX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2014 03:46:23 -0400
Received: by mail-ie0-f171.google.com with SMTP id y20so422794ier.30
        for <linux-wireless@vger.kernel.org>; Fri, 12 Sep 2014 00:46:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <54125652.7060205@netcommwireless.com>
References: <540FA8D9.2070803@netcommwireless.com>
	<54100F0E.8030204@broadcom.com>
	<CAGXE3d9FRLOPQ1pO6WFWy4FF67PGbo5ztfhLELydq3k410731w@mail.gmail.com>
	<54125652.7060205@netcommwireless.com>
Date: Fri, 12 Sep 2014 09:46:22 +0200
Message-ID: <CAGXE3d_QE0zCAgbLaa+93JNM-GhRMvHENqW1zXy_txeV1mKwSg@mail.gmail.com> (sfid-20140912_094632_457699_B65DB276)
Subject: Re: Not reaching optimum speeds with IEEE 802.11n
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Sourav <sourav.chakraborty@netcommwireless.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 12, 2014 at 4:11 AM, Sourav
<sourav.chakraborty@netcommwireless.com> wrote:
> On 11/09/14 00:14, Helmut Schaa wrote:
>>
>> On Wed, Sep 10, 2014 at 10:42 AM, Arend van Spriel <arend@broadcom.com>
>> wrote:
>>>
>>> On 09/10/14 03:26, Sourav wrote:
>>>>
>>>> We are using Ralink chip Rt3072L (using rt2800usb drivers rt2800usb.c),
>>
>> The Ralink USB hardware is quite bad in reporting TX status and as
>> such minstrel_ht cannot do proper rate selection.
>> If you watch the rc stats at
>>
>> /sys/kernel/debug/ieee80211/phy0/netdev\:wlan0-0/stations/xx:xx:xx:xx:xx:xx/rc_stats
>> you might see a lot of rate selection "hopping".
>>
>> Regards.
>> Helmut
>
> please take a look at the attachments.... the first one shows the rc_stats
> and iperf stats side by side on the router(iperf is running in client mode
> in the router).....the second attachment is from a laptop which is running
> iperf in server mode.
>
> I don't see a lot of rate "hopping" in the rc_stats file, (T,t and P) rates
> are pretty much stable.... yet there is a big difference between those rates
> and the throughput using iperf......

Indeed, rc_stats looks acceptable.

> when you say "Ralink USB hardware is quite bad in reporting TX status", do
> you mean that the HW reports less tx rate to minstrel_ht and so its rate
> calculation is screwed up?

The HW sometimes does not report the status of transmitted frames correctly.
The TX status register is a FIFO of 16 (or similar) elements and if
the driver is
not reading it "fast enough" the FIFO will overflow :( at least that
was the point
when I was looking at the ralink hardware last time. Not sure if something
changed recently.

> Can you please let me know the section of code inside Rc_80211_minstrel_ht.c
> (or somewhere else) which deals with getting the tx rate from ralink HW?

There is no special code in minstrel(_ht) in regard to rt2x00.

Are you able able to get some statistics on the receiver side (your
windows machine)
regarding TX rates and AMPDU lengths?

Helmut
